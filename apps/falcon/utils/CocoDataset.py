import os
import sys
import numpy as np

import zipfile
import urllib.request
import shutil
import logging

this_dir = os.path.dirname(__file__)
APP_ROOT_DIR = os.path.join(this_dir,'..')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

ROOT_DIR = os.path.join(APP_ROOT_DIR,'..')
BASE_PATH_CFG = os.path.join(ROOT_DIR,'cfg')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

if BASE_PATH_CFG not in sys.path:
  sys.path.append(BASE_PATH_CFG)

log = logging.getLogger('__main__.'+__name__)

# # Root directory of the project
# ROOT_DIR = os.path.abspath("../../")

# # Import Mask RCNN
# sys.path.append(ROOT_DIR)  # To find local version of the library

from mrcnn import utils
from pycocotools.coco import COCO
from pycocotools import mask as maskUtils


### MS COCO Tasks: <task>
## captions
## person_keypoints
## instances
## stuff
## panoptic ## does not work for it's in new format, instead created a converted from panoptic to detections format named the task `panoptic_instances`

### MS COCO Different Annotation zip files  : <annZipFileByTask>
## TBD: task is year specific
##--- 2014
## annotations_trainval2014.zip
##--- 2017
## annotations_trainval2017.zip
## panoptic_annotations_trainval2017.zip
## stuff_trainval2017.zip


class CocoDataset(utils.Dataset):
    name = ""
    dataclass = None

    def __init__(self, name=None, dataclass=None):
        super(self.__class__, self).__init__()
        self.name = name

        self.dataclass = dataclass if dataclass else None
        print("CocoDataset: self.dataclass: {}".format(self.dataclass))


    def load_data(self, subset, datacfg, class_ids=None, class_map=None):
        print("CocoDataset::load_data: datacfg: {}".format(datacfg))
        prefix = datacfg.name+"_" if datacfg.name else "coco_"
        ##TBD: get the class_id and class_map from datacfg, fix code
        self.name = prefix+datacfg.default_task
        return self.load_coco(datacfg.db_dir
            ,subset
            ,year=datacfg.default_dataset_year
            ,class_ids=class_ids
            ,class_map=class_map
            ,return_coco=datacfg.return_coco
            ,auto_download=datacfg.auto_download
            ,task=datacfg.default_task
            ,datacfg=datacfg)


    def load_coco(self, dataset_dir, subset, year=None, class_ids=None,
                  class_map=None, return_coco=False, auto_download=False, task="instances", datacfg=None):
        """Load a subset of the COCO dataset.
        dataset_dir: The root directory of the COCO dataset.
        subset: What to load (train, val, minival, valminusminival)
        year: What dataset year to load (2014, 2017) as a string, not an integer
        class_ids: If provided, only loads images that have the given classes.
        class_map: TODO: Not implemented yet. Supports maping classes from
            different datasets to the same class ID.
        return_coco: If True, returns the COCO object.
        auto_download: Automatically download and unzip MS-COCO images and annotations
        """

        if auto_download is True:
            self.auto_download(dataset_dir, subset, year, task)

        if task == "panoptic":
            # coco = COCO("{}/annotations/instances_{}{}.json".format(dataset_dir, subset, year))
            annFileName = "{}/annotations/{}_{}{}.json".format(dataset_dir, task+"_instances", subset, year)
        else:
            annFileName = "{}/annotations/{}_{}{}.json".format(dataset_dir, task, subset, year)

        print("annFileName: {}".format(annFileName))
        
        if subset == "minival" or subset == "valminusminival":
            subset = "val"
        
        if task == "panoptic":
            subset = task+"_"+subset

        image_dir = "{}/{}{}".format(dataset_dir, subset, year)
        print("image_dir: {}".format(image_dir))

        coco = COCO(annFileName)

        # Load all classes or a subset?
        if not class_ids:
            # All classes
            class_ids = sorted(coco.getCatIds())

        # All images or a subset?
        if class_ids:
            image_ids = []
            for id in class_ids:
                image_ids.extend(list(coco.getImgIds(catIds=[id])))
            # Remove duplicates
            image_ids = list(set(image_ids))
        else:
            # All images
            image_ids = list(coco.imgs.keys())


        total_img, total_annotation, total_classes = self.add_data_coco(coco, class_ids, image_ids, image_dir, datacfg)

        if return_coco:
            return coco, total_img, total_annotation, total_classes

        return total_img, total_annotation, total_classes


    def add_data_coco(self, coco, class_ids, image_ids, image_dir, datacfg=None):
        ds = self.dataclass if self.dataclass else self
        # print("add_data_coco::ds: {}".format(ds))

        add_class = ds.add_class if ds.add_class else super(ds, self).add_class
        add_image = ds.add_image if ds.add_image else super(ds, self).add_image
        # print("add_image: {}".format(add_image))

        total_img = len(image_ids)
        total_classes = len(class_ids)
        total_annotation = 0
        annon_type = "coco"
        DATA_READ_THRESHOLD = datacfg.data_read_threshold if datacfg and 'DATA_READ_THRESHOLD' in datacfg else 0
        print("DATA_READ_THRESHOLD: {}".format(DATA_READ_THRESHOLD))

        # Add classes
        name = "coco"
        for index, v in enumerate(class_ids):
            class_name = coco.loadCats(v)[0]["name"]
            print("name,index,v,class_name: {},{},{},{}".format(name, index+1, v, class_name))
            add_class(name, v, class_name)

        # Add images
        for count, i in enumerate(image_ids):
            if DATA_READ_THRESHOLD == count:
                break
            
            # print("add_data_coco: image_id................:{}".format(i))
            annotations = coco.loadAnns(coco.getAnnIds(imgIds=[i], catIds=class_ids, iscrowd=None))
            total_annotation += len(annotations)
            add_image(
                name,
                image_id=i,
                path=os.path.join(image_dir, coco.imgs[i]['file_name']),
                width=coco.imgs[i]["width"],
                height=coco.imgs[i]["height"],
                annon_type=annon_type,
                annotations=annotations)

        print("Total Images: {}".format(total_img))
        print("Total Annotations: {}".format(total_annotation))
        print("Total Classes: {}".format(total_classes))
        print("-------")

        return total_img, total_annotation, total_classes


    def auto_download(self, dataDir, dataType, dataYear, task):
        """Download the COCO dataset/annotations if requested.
        dataDir: The root directory of the COCO dataset.
        dataType: What to load (train, val, minival, valminusminival)
        dataYear: What dataset year to load (2014, 2017) as a string, not an integer
        Note:
            For 2014, use "train", "val", "minival", or "valminusminival"
            For 2017, only "train" and "val" annotations are available
        task: MS COCO challange task: instances, stuff, stuffthings, panoptic
        Note: stuff, stuffthings, panoptic are not avaiable in year 2014
        """

        # Setup paths and file names
        if dataType == "minival" or dataType == "valminusminival":
            imgDir = "{}/{}{}".format(dataDir, "val", dataYear)
            imgZipFile = "{}/{}{}.zip".format(dataDir, "val", dataYear)
            imgURL = "http://images.cocodataset.org/zips/{}{}.zip".format("val", dataYear)
        else:
            imgDir = "{}/{}{}".format(dataDir, dataType, dataYear)
            imgZipFile = "{}/{}{}.zip".format(dataDir, dataType, dataYear)
            imgURL = "http://images.cocodataset.org/zips/{}{}.zip".format(dataType, dataYear)
        print("Image paths:"); print(imgDir); print(imgZipFile); print(imgURL)

        # http://images.cocodataset.org/zips/train2014.zip


        if task == "instances":
            annZipFileByTask="annotations"
        else:
            annZipFileByTask=task
        

        # Create main folder if it doesn't exist yet
        if not os.path.exists(dataDir):
            os.makedirs(dataDir)

        # Download images if not available locally
        if not os.path.exists(imgDir):
            os.makedirs(imgDir)
            print("Downloading images to " + imgZipFile + " ...")
            # with urllib.request.urlopen(imgURL) as resp, open(imgZipFile, 'wb') as out:
            #     shutil.copyfileobj(resp, out)
            # print("... done downloading.")
            # print("Unzipping " + imgZipFile)
            # with zipfile.ZipFile(imgZipFile, "r") as zip_ref:
            #     zip_ref.extractall(dataDir)
            # print("... done unzipping")
        print("Will use images in " + imgDir)

        # Setup annotations data paths
        annDir = "{}/annotations".format(dataDir)
        if dataType == "minival":
            annZipFile = "{}/instances_minival2014.json.zip".format(dataDir)
            annFile = "{}/instances_minival2014.json".format(annDir)
            annURL = "https://dl.dropboxusercontent.com/s/o43o90bna78omob/instances_minival2014.json.zip?dl=0"
            unZipDir = annDir
        elif dataType == "valminusminival":
            annZipFile = "{}/instances_valminusminival2014.json.zip".format(dataDir)
            annFile =    "{}/instances_valminusminival2014.json".format(annDir)
            annURL = "https://dl.dropboxusercontent.com/s/s3tw5zcg7395368/instances_valminusminival2014.json.zip?dl=0"
            unZipDir = annDir
        else:            
            annZipFile = "{}/{}_trainval{}.zip".format(dataDir, annZipFileByTask, dataYear)
            annFile = "{}/{}_{}{}.json".format(annDir, task, dataType, dataYear)
            annURL = "http://images.cocodataset.org/annotations/{}_trainval{}.zip".format(annZipFileByTask, dataYear)
            unZipDir = dataDir
        print("Annotations paths:"); print(annDir); print(annFile); print(annZipFile); print(annURL)

        # Download annotations if not available locally
        if not os.path.exists(annDir):
            os.makedirs(annDir)
        if not os.path.exists(annFile):
            if not os.path.exists(annZipFile):
                print("Downloading zipped annotations to " + annZipFile + " ...")
                with urllib.request.urlopen(annURL) as resp, open(annZipFile, 'wb') as out:
                    shutil.copyfileobj(resp, out)
                print("... done downloading.")
            print("Unzipping " + annZipFile)
            with zipfile.ZipFile(annZipFile, "r") as zip_ref:
                zip_ref.extractall(unZipDir)
            print("... done unzipping")
        print("Will use annotations in " + annFile)


    def load_mask(self, image_id, config=None):
        """Load instance masks for the given image.

        Different datasets use different ways to store masks. This
        function converts the different mask format to one format
        in the form of a bitmap [height, width, instances].

        Returns:
        masks: A bool array of shape [height, width, instance count] with
            one mask per instance.
        class_ids: a 1D array of class IDs of the instance masks.
        """
        # print("coco: load_mask::-------------------------------->")
        
        name = "coco"
        # If not a COCO image, delegate to parent class.
        ds = self.dataclass if self.dataclass else self
        # print("load_mask::ds: {}".format(ds))

        classname_from_source_map = ds.classname_from_source_map if ds.classname_from_source_map else super(ds, self).classname_from_source_map
        classname_from_sourcename_map = ds.classname_from_sourcename_map if ds.classname_from_sourcename_map else super(ds, self).classname_from_sourcename_map

        # print("classname_from_source_map: {}".format(classname_from_source_map))

        # print("-------------")
        # print("source_class_ids: {}".format(ds.source_class_ids))
        # print("-------------")
        # print("class_ids, class_names, num_classes: {},{},{}".format(ds.class_ids, ds.class_names, ds.num_classes))
        # print("-------------")
        # print("class_info: {}".format(ds.class_info))
        # print("-------------")
        # print("classname_from_source_map: {}".format(ds.classname_from_source_map))
        # print("-------------")
        # print("classname_from_sourcename_map: {}".format(ds.classname_from_sourcename_map))
        # print("-------------")

        image_info = ds.image_info[image_id]
        # print("image_info: {}".format(image_info))
        # print("-------------")

        if image_info["source"] != name:
            return super(self.__class__, ds).load_mask(image_id)

        instance_masks = []
        class_ids = []
        class_labels = []
        
        annotations = image_info["annotations"]
        # Build mask of shape [height, width, instance_count] and list
        # of class IDs that correspond to each channel of the mask.
        for annotation in annotations:
            # print("coco: load_mask: annotation['category_id']: {}".format(annotation['category_id']))
            lbl_id = annotation['category_id']
            # map_source_class_id("{}.{}".format(name, annotation['category_id']))
            # print("lbl_id: {}".format(lbl_id))

            class_label = classname_from_source_map["{}.{}".format(name, lbl_id)]
            # print("class_label: {}".format(class_label))

            class_id = classname_from_sourcename_map["{}.{}".format(name, class_label)]
            # print("class_id: {}".format(class_id))

            # ct_class_id = get_classid_from_source_class_name( "{}.{}".format(name, lbl_id) )
            # print("ct_class_id: {}".format(ct_class_id))

            # class_id = class_info[ct_class_id]['id']
            # print("class_id: {}".format(class_id))

            # class_label = get_classname_from_source_class_id("{}.{}".format(name, class_id) )
            # print("class_label: {}".format(class_label))

            # assert lbl_id == class_label

            if class_id:
                m = self.annToMask(annotation, image_info["height"], image_info["width"])
                # Some objects are so small that they're less than 1 pixel area
                # and end up rounded out. Skip those objects.
                if m.max() < 1:
                    continue
                # Is it a crowd? If so, use a negative class ID.
                if annotation['iscrowd']:
                    # Use negative class ID for crowds
                    class_id *= -1
                    # For crowd masks, annToMask() sometimes returns a mask
                    # smaller than the given dimensions. If so, resize it.
                    if m.shape[0] != image_info["height"] or m.shape[1] != image_info["width"]:
                        m = np.ones([image_info["height"], image_info["width"]], dtype=bool)
                instance_masks.append(m)
                class_ids.append(class_id)
                class_labels.append(class_id)

        # Pack instance masks into an array
        # print("class_ids: {}".format(class_ids))
        # print("class_labels: {}".format(class_labels))

        if class_ids:
            mask = np.stack(instance_masks, axis=2).astype(np.bool)
            keys = ['image_name', 'image_id', 'image_source', 'class_ids', 'class_labels']
            values = [image_info['id'], image_id, image_info['source'], class_ids, class_labels]
            class_ids = np.array(class_ids, dtype=np.int32)
            return mask, class_ids, keys, values
        else:
            # Call super class to return an empty mask
            return super(self.__class__, ds).load_mask(image_id)


    def image_reference(self, image_id):
        """Return a link to the image in the COCO Website."""
        info = self.image_info[image_id]
        if info["source"] == "coco":
            return "http://cocodataset.org/#explore?id={}".format(info["id"])
        else:
            super(self.__class__, self).image_reference(image_id)

    
    # The following two functions are from pycocotools with a few changes.
    def annToRLE(self, ann, height, width):
        """
        Convert annotation which can be polygons, uncompressed RLE to RLE.
        :return: binary mask (numpy 2D array)
        """
        segm = ann['segmentation']
        if isinstance(segm, list):
            # polygon -- a single object might consist of multiple parts
            # we merge all parts into one mask rle code
            rles = maskUtils.frPyObjects(segm, height, width)
            rle = maskUtils.merge(rles)
        elif isinstance(segm['counts'], list):
            # uncompressed RLE
            rle = maskUtils.frPyObjects(segm, height, width)
        else:
            # rle
            rle = ann['segmentation']
        return rle


    def annToMask(self, ann, height, width):
        """
        Convert annotation which can be polygons, uncompressed RLE, or RLE to binary mask.
        :return: binary mask (numpy 2D array)
        """
        rle = self.annToRLE(ann, height, width)
        m = maskUtils.decode(rle)
        return m
