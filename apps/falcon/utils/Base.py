"""
Mask R-CNN
Common utility functions and classes.

Copyright (c) 2017 Matterport, Inc.
Licensed under the MIT License (see LICENSE for details)
Written by Waleed Abdulla
"""

import numpy as np
import skimage.color
import skimage.io

import logging
log = logging.getLogger('__main__.'+__name__)

############################################################
#  Dataset
############################################################

class Dataset(object):
    """The base class for dataset classes.
    To use it, create a new class that adds functions specific to the dataset
    you want to use. For example:

    class CatsAndDogsDataset(Dataset):
        def load_cats_and_dogs(self):
            ...
        def load_mask(self, image_id, datacfg=None, config=None):
            ...
        def image_reference(self, image_id):
            ...

    See COCODataset and ShapesDataset as examples.
    """

    def __init__(self, class_map=None):
        log.info("-------------------------------->")
        self._image_ids = []
        self.image_info = []
        # Background is always the first class
        self.classinfo = [{"source": "", "id": 0, "name": "BG"}]
        self.source_class_ids = {}
        self.source_names = []

        # ## Additional Information for inheritance
        # self.class_from_source_map = {}
        # self.classname_from_source_map = {}
        # self.classname_from_sourcename_map = {}
        # self.image_from_source_map = {}
        # self.sources = []
        # self.source_class_ids = {}
        # self.class_names = []
        # self.class_ids = None
        # self.num_images = 0
        # self.num_classes = 0

        log.debug("classinfo: {}".format(self.classinfo))

    def add_class(self, source, idx, class_name, lbl_id=None, color=None):
        assert "." not in source, "Source name cannot contain a dot"
        # Does the class exist already?
        for info in self.classinfo:
            if info['source'] == source and info["id"] == idx:
                # source.idx combination already available, skip
                return
        # Add the class
        classinfo = {
            "source": source,
            "id": idx,
            "lbl_id": lbl_id,
            "name": class_name,
            "color": color,
        }

        ## Add sources separately, for cross training support
        if source not in self.source_names:
            self.source_names.append(source)

        self.classinfo.append(classinfo)


    def add_image(self, source, image_id, path, **kwargs):
        image_info = {
            "id": image_id,
            "source": source,
            "path": path,
        }
        image_info.update(kwargs)
        self.image_info.append(image_info)


    def image_reference(self, image_id, info=None, datacfg=None):
        """Return a link to the image in its source Website or details about
        the image that help looking it up or debugging it.

        Override for your dataset, but pass to this function
        if you encounter images not in your dataset.
        """
        return ""


    def prepare(self, class_map=None):
        """Prepares the Dataset class for use.

        TODO: class map is not supported yet. When done, it should handle mapping
              classes from different datasets to the same class ID.
        """
        log.info("-------------------------------->")

        def clean_name(name):
            log.debug("name: {}".format(name))
            """Returns a shorter version of object names for cleaner display."""
            return ",".join(name.split(",")[:1])

        # Build (or rebuild) everything else from the info dicts.
        log.debug("classinfo: {}".format(self.classinfo))

        self.num_classes = len(self.classinfo)
        self.class_ids = np.arange(self.num_classes)
        self.class_names = [clean_name(c["name"]) for c in self.classinfo]

        for i,ci in enumerate(self.classinfo):
          log.debug("self.class_ids[i]: {}".format(self.class_ids[i]))
          ci['id'] = self.class_ids[i]

        log.debug("num_classes: {}".format(self.num_classes))
        log.debug("class_names: {}".format(self.class_names))
        log.debug("class_ids: {}".format(self.class_ids))


        ## Not sure, if required, but in case of name conflicts can try it out
        ## self.class_names = [clean_name(c["name"]+"."+str(c["id"])) for c in self.classinfo]
        self.num_images = len(self.image_info)
        self._image_ids = np.arange(self.num_images)

        # Mapping from source class and image IDs to internal IDs
        self.class_from_source_map = {"{}.{}".format(info['source'], info['id']): _id
                                      for info, _id in zip(self.classinfo, self.class_ids)}
        self.classname_from_source_map = {"{}.{}".format(info['source'], info['id']): name
                                      for info, name in zip(self.classinfo, self.class_names)}
        self.classname_from_sourcename_map = {"{}.{}".format(info['source'], info['name']): _id
                                      for info, _id in zip(self.classinfo, self.class_ids)}

        ## Not sure, if required, but in case of name conflicts can try it out
        # self.classname_from_source_map = {"{}.{}".format(info['source'], info['id']): name+"."+str(info["id"])
        #                               for info, name in zip(self.classinfo, self.class_names)}

        self.image_from_source_map = {"{}.{}".format(info['source'], info['id']): _id
                                      for info, _id in zip(self.image_info, self.image_ids)}

        # Map sources to class_ids they support
        self.sources = list(set([i['source'] for i in self.classinfo]))
        # self.source_class_ids = {}
        # Loop over datasets
        for source in self.sources:
            self.source_class_ids[source] = []
            # Find classes that belong to this dataset
            for i, info in enumerate(self.classinfo):
                # Include BG class in all datasets
                if i == 0 or source == info['source']:
                    self.source_class_ids[source].append(i)


    def map_source_class_id(self, source_class_id):
        """Takes a source class ID and returns the int class ID assigned to it.

        For example:
        dataset.map_source_class_id("coco.12") -> 23
        """
        return self.class_from_source_map[source_class_id]


    def get_classid_from_source_class_id(self, source_class_id):
        """wrapper around, map_source_class_id, as this name is more intutive
        """
        return self.map_source_class_id(source_class_id)


    def get_classid_from_source_class_name(self, source_class_name):
        """Takes a source class ID and returns the int class ID assigned to it.

        For example:
        dataset.classname_from_sourcename_map("coco.labelName") -> 23 (TBD put the class_name agaist 23)
        """
        return self.classname_from_sourcename_map[source_class_name]


    def get_classname_from_source_class_id(self, source_class_id):
        """Takes a source class ID and returns the int class ID assigned to it.

        For example:
        dataset.classname_from_source_map("coco.12") -> 23 (TBD put the class_name agaist 23)
        """
        return self.classname_from_source_map[source_class_id]


    def get_source_class_id(self, class_id, source):
        """Map an internal class ID to the corresponding class ID in the source dataset."""
        info = self.classinfo[class_id]
        assert info['source'] == source
        return info['id']


    @property
    def image_ids(self):
        return self._image_ids


    def source_image_link(self, image_id):
        """Returns the path or URL to the image.
        Override this to return a URL to the image if it's available online for easy
        debugging.
        """
        return self.image_info[image_id]["path"]


    def load_image(self, image_id, datacfg=None, config=None):
        """Load the specified image and return a [H,W,3] Numpy array.
        """
        image = None
        try:
            # Load image
            image_path = self.image_info[image_id]['path']
            image = skimage.io.imread(image_path)
            # log.debug("load_image::image_path, image.ndim: {},{}".format(image_path, image.ndim))
            # If grayscale. Convert to RGB for consistency.
            if image.ndim != 3:
                image = skimage.color.gray2rgb(image)
            # If has an alpha channel, remove it for consistency
            if image.shape[-1] == 4:
                image = image[..., :3]
        except Exception as e:
            log.exception("Error reading image: {}".format(image_path), exc_info=True)
            raise
        finally:
            return image


    def load_mask(self, image_id, datacfg=None, config=None):
        """Load instance masks for the given image.

        Different datasets use different ways to store masks. Override this
        method to load instance masks and return them in the form of am
        array of binary masks of shape [height, width, instances].

        Returns:
            masks: A bool array of shape [height, width, instance count] with
                a binary mask per instance.
            class_ids: a 1D array of class IDs of the instance masks.
        """
        # Override this function to load a mask from your dataset.
        # Otherwise, it returns an empty mask.
        logging.warning("You are using the default load_mask(), maybe you need to define your own one.")
        mask = np.empty([0, 0, 0])
        class_ids = np.empty([0], np.int32)
        class_labels = np.empty([0], np.int32)
        info = self.image_info
        keys = ['image_name', 'image_id', 'image_source', 'class_ids', 'class_labels']
        values = ["{},{},{},{}, {}".format(info[image_id]['id'],info[image_id]['source'], image_id, class_ids, class_labels)]

        return mask, class_ids, keys, values
