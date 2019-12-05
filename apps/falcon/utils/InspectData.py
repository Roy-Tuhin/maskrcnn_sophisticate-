
# coding: utf-8

# In[1]:


'''
# Inspect Image Annotation Data created by VIA tool
Inspect and visualize data loading and pre-processing code.
'''
import os
import sys
import random
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches

import logging
log = logging.getLogger('__main__.'+__name__)

from mrcnn import utils
from mrcnn import visualize
from mrcnn.visualize import display_images
import mrcnn.model as modellib
from mrcnn.model import log


class InspectData():

    def load_and_display_random_single_sample(self, dataset, ds_datacfg=None):
        '''
        ## Bounding Boxes
        Rather than using bounding box coordinates provided by the source datasets,
        compute the bounding boxes from masks instead. This allows to handle bounding
        boxes consistently regardless of the source dataset, and it also makes it easier
        to resize, rotate, or crop images because simply generate the bounding boxes from
        the updates masks rather than computing bounding box transformation for each type
        of image transformation.

        ## Load random single image and mask.
        '''
        print("load_and_display_random_single_sample::-------------------------------->")

        image_ids = dataset.image_ids
        class_names = dataset.class_names

        image_id = random.choice(image_ids)

        print("dataset: image_id: {}".format(image_id))
        print("dataset: len(class_names): {}\nclass_names: {}".format(len(class_names), class_names))

        datacfg = None
        if ds_datacfg:
            info = dataset.image_info[image_id]
            ds_source = info['source']
            datacfg = utils.get_datacfg(ds_datacfg, ds_source)

        image = dataset.load_image(image_id, datacfg)
        mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg)

        # Compute Bounding box
        bbox = utils.extract_bboxes(mask)

        # Display image and additional stats
        log("image_id",image_id)
        log("image", image)
        log("mask", mask)
        log("class_ids", class_ids)
        log("bbox", bbox)

        ## Return /Display image and instances

        self.display_masks(image, mask, class_ids, class_names)
        self.display_instances(image, bbox, mask, class_ids, class_names)
        # return image, bbox, mask, class_ids, class_names


    def load_and_display_random_sample(self, dataset, ds_datacfg=None):
        '''
        ## Load and display random samples
        '''
        print("load_and_display_random_sample::-------------------------------->")

        image_ids = np.random.choice(dataset.image_ids, 4)
        class_names = dataset.class_names

        print("dataset: len(image_ids): {}\nimage_ids: {}".format(len(image_ids), image_ids))
        print("dataset: len(class_names): {}\nclass_names: {}".format(len(class_names), class_names))

        for image_id in image_ids:
            datacfg = None
            if ds_datacfg:
                info = dataset.image_info[image_id]
                print("info: {}".format(info))
                ds_source = info['source']
                # print("ds_source:{}".format(ds_source))
                datacfg = utils.get_datacfg(ds_datacfg, ds_source)

            image = dataset.load_image(image_id, datacfg)
            mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg)

            print("keys: {}".format(keys))
            print("values: {}".format(values))
            print("class_ids: {}".format(class_ids))
            ## Compute Bounding box
            # bbox = utils.extract_bboxes(mask)

            ## Display image and instances

            self.display_masks(image, mask, class_ids, class_names)
            # self.display_instances(image, bbox, mask, class_ids, class_names)
            # return image, bbox, mask, class_ids, class_names


    def test_load_and_display_dataset(self, dataset, ds_datacfg=None):
        '''
        ## Test Loading of Dataset for any images and masks loading issues
        '''
        print("test_load_and_display_dataset::-------------------------------->")

        image_ids = dataset.image_ids
        class_names = dataset.class_names

        print("dataset: len(image_ids): {}\nimage_ids: {}".format(len(image_ids), image_ids))
        print("dataset: len(class_names): {}\nclass_names: {}".format(len(class_names), class_names))

        total_annotation = 0
        for image_id in image_ids:
            # print("image_id:{}".format(image_id))
            # image = dataset.load_image(image_id)
            datacfg = None
            if ds_datacfg:
                info = dataset.image_info[image_id]
                ds_source = info['source']
                # print("ds_source: {}".format(ds_source))
                datacfg = utils.get_datacfg(ds_datacfg, ds_source)

            mask, class_id, keys, values = dataset.load_mask(image_id, datacfg)
            total_annotation += len(class_id)

        print("total_annotation: {}".format(total_annotation))


    def load_and_display_dataset(self, dataset, ds_datacfg=None):
        '''
        ## Display Dataset
        ## Load and display images and masks.
        '''
        print("load_and_display_dataset::-------------------------------->")

        image_ids = dataset.image_ids
        class_names = dataset.class_names

        # print("dataset: len(image_ids): {}\nimage_ids: {}".format(len(image_ids), image_ids))
        # print("dataset: len(class_names): {}\nclass_names: {}".format(len(class_names), class_names))

        total_annotation = 0
        total_annontation_per_image_map = {}
        for image_id in image_ids:
            # print("image_id:{}".format(image_id))
            # image = dataset.load_image(image_id)
            datacfg = None
            if ds_datacfg:
                info = dataset.image_info[image_id]
                ds_source = info['source']
                # print("ds_source: {}".format(ds_source))
                datacfg = utils.get_datacfg(ds_datacfg, ds_source)

            mask, class_id, keys, values = dataset.load_mask(image_id, datacfg)
            # print("class_id: {}".format(class_id))
            if image_id not in total_annontation_per_image_map:
                total_annontation_per_image_map[image_id] = []
            total_annontation_per_image_map[image_id].append(class_id)

            total_annotation += len(class_id)


        print("total_annotation: {}".format(total_annotation))

        return total_annotation


    def display_instances(self, image, bbox, mask, class_ids, class_names):
        # print("display_instances: {}, {}".format(class_ids, class_names))
        visualize.display_instances(image, bbox, mask, class_ids, class_names)


    def display_masks(self, image, mask, class_ids, class_names):
        # print("display_masks: {}, {}".format(class_ids, class_names))
        visualize.display_top_masks(image, mask, class_ids, class_names)


    def load_and_resize_images(self, dataset, dnncfg, ds_datacfg):
        '''
        ## Resize Images
        To support multiple images per batch, images are resized to one size (1024x1024).
        Aspect ratio is preserved, though. If an image is not square, then zero padding
        is added at the top/bottom or right/left.
        '''
        print("load_and_resize_images::-------------------------------->")

        image_id = np.random.choice(dataset.image_ids, 1)[0]
        image = dataset.load_image(image_id)
        datacfg = None

        if ds_datacfg:
            info = dataset.image_info[image_id]
            ds_source = info['source']
            datacfg = utils.get_datacfg(ds_datacfg, ds_source)

        mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg)
        original_shape = image.shape
        # Resize
        image, window, scale, padding, _ = utils.resize_image(
            image,
            min_dim=dnncfg.IMAGE_MIN_DIM,
            max_dim=dnncfg.IMAGE_MAX_DIM,
            mode=dnncfg.IMAGE_RESIZE_MODE)
        mask = utils.resize_mask(mask, scale, padding)
        # Compute Bounding box
        bbox = utils.extract_bboxes(mask)

        # Display image and additional stats
        print("Original shape: ", original_shape)
        log("image", image)
        log("mask", mask)
        log("class_ids", class_ids)
        log("bbox", bbox)

        ## Display image and instances
        class_names = dataset.class_names
        self.display_instances(image, bbox, mask, class_ids, class_names)


    def load_mini_masks(self, dataset, config, ds_datacfg):
        '''
        ## Mini Masks

        Instance binary masks can get large when training with high resolution images.
        For example, if training with 1024x1024 image then the mask of a single instance
        requires 1MB of memory (Numpy uses bytes for boolean values). If an image has
        100 instances then that's 100MB for the masks alone.

        To improve training speed, we optimize masks by:
        * We store mask pixels that are inside the object bounding box, rather than a mask
        of the full image. Most objects are small compared to the image size, so we save space
        by not storing a lot of zeros around the object.
        * We resize the mask to a smaller size (e.g. 56x56). For objects that are larger than
        the selected size we lose a bit of accuracy. But most object annotations are not very
        accuracy to begin with, so this loss is negligable for most practical purposes.
        Thie size of the mini_mask can be set in the config class.

        To visualize the effect of mask resizing, and to verify the code correctness,
        we visualize some examples.
        '''
        print("load_mini_masks::-------------------------------->")

        image_id = np.random.choice(dataset.image_ids, 1)[0]
        print("image_id: {}".format(image_id))

        datacfg = None
        if ds_datacfg:
            info = dataset.image_info[image_id]
            ds_source = info['source']
            datacfg = utils.get_datacfg(ds_datacfg, ds_source)

        image, image_meta, class_ids, bbox, mask = modellib.load_image_gt(
            dataset, datacfg, config, image_id, use_mini_mask=False)

        log("image", image)
        log("image_meta", image_meta)
        log("class_ids", class_ids)
        log("bbox", bbox)
        log("mask", mask)

        display_images([image]+[mask[:,:,i] for i in range(min(mask.shape[-1], 7))])

        ## Display image and instances
        class_names = dataset.class_names
        self.display_instances(image, bbox, mask, class_ids, class_names)

        return image_id


    def add_augmentation(self, dataset, config, ds_datacfg, image_id):
        '''
        # Add augmentation and mask resizing.
        '''
        print("add_augmentation::-------------------------------->")

        # image_id = image_id if image_id==None else np.random.choice(dataset.image_ids, 1)[0]

        datacfg = None
        if ds_datacfg:
            info = dataset.image_info[image_id]
            ds_source = info['source']
            datacfg = utils.get_datacfg(ds_datacfg, ds_source)

        # Add augmentation and mask resizing.
        image, image_meta, class_ids, bbox, mask = modellib.load_image_gt(
            dataset, datacfg, config, image_id, augment=True, use_mini_mask=True)
        log("mask", mask)
        display_images([image]+[mask[:,:,i] for i in range(min(mask.shape[-1], 7))])
        mask = utils.expand_mask(bbox, mask, image.shape)

        ## Display image and instances
        class_names = dataset.class_names
        self.display_instances(image, bbox, mask, class_ids, class_names)


    def generate_anchors(self, config):
        '''
        ## Anchors

        The order of anchors is important. Use the same order in training and prediction phases.
        And it must match the order of the convolution execution.

        For an FPN network, the anchors must be ordered in a way that makes it easy to match anchors
        to the output of the convolution layers that predict anchor scores and shifts. 
        * Sort by pyramid level first. All anchors of the first level, then all of the second and so on.
        This makes it easier to separate anchors by level.
        * Within each level, sort anchors by feature map processing sequence. Typically, a convolution layer
        processes a feature map starting from top-left and moving right row by row. 
        * For each feature map cell, pick any sorting order for the anchors of different ratios.
        Here we match the order of ratios passed to the function.

        **Anchor Stride:**
        In the FPN architecture, feature maps at the first few layers are high resolution.
        For example, if the input image is 1024x1024 then the feature meap of the first layer is 256x256,
        which generates about 200K anchors (256*256*3). These anchors are 32x32 pixels and their stride
        relative to image pixels is 4 pixels, so there is a lot of overlap. We can reduce the load
        significantly if we generate anchors for every other cell in the feature map. A stride of 2 will
        cut the number of anchors by 4, for example.

        In this implementation we use an anchor stride of 2, which is different from the paper.
        '''
        print("generate_anchors::-------------------------------->")

        # Generate Anchors
        backbone_shapes = modellib.compute_backbone_shapes(config, config.IMAGE_SHAPE)
        anchors = utils.generate_pyramid_anchors(config.RPN_ANCHOR_SCALES,
                                                  config.RPN_ANCHOR_RATIOS,
                                                  backbone_shapes,
                                                  config.BACKBONE_STRIDES, 
                                                  config.RPN_ANCHOR_STRIDE)

        # Print summary of anchors
        num_levels = len(backbone_shapes)
        anchors_per_cell = len(config.RPN_ANCHOR_RATIOS)
        print("Count: ", anchors.shape[0])
        print("Scales: ", config.RPN_ANCHOR_SCALES)
        print("ratios: ", config.RPN_ANCHOR_RATIOS)
        print("Anchors per Cell: ", anchors_per_cell)
        print("Levels: ", num_levels)
        anchors_per_level = []
        for l in range(num_levels):
            num_cells = backbone_shapes[l][0] * backbone_shapes[l][1]
            anchors_per_level.append(anchors_per_cell * num_cells // config.RPN_ANCHOR_STRIDE**2)
            print("Anchors in Level {}: {}".format(l, anchors_per_level[l]))
        return backbone_shapes, anchors, anchors_per_level, anchors_per_cell


    def visualize_anchors_at_center(self, dataset, ds_datacfg, config, backbone_shapes, anchors, anchors_per_level, anchors_per_cell):
        '''
        ## Visualize anchors of one cell at the center of the feature map of a specific level
        '''
        print("visualize_anchors_at_center::-------------------------------->")
        # Load and draw random image
        image_id = np.random.choice(dataset.image_ids, 1)[0]

        datacfg = None
        if ds_datacfg:
            info = dataset.image_info[image_id]
            ds_source = info['source']
            datacfg = utils.get_datacfg(ds_datacfg, ds_source)

        image, image_meta, _, _, _ = modellib.load_image_gt(dataset, datacfg, config, image_id)
        fig, ax = plt.subplots(1, figsize=(10, 10))
        ax.imshow(image)
        levels = len(backbone_shapes)

        for level in range(levels):
            colors = visualize.random_colors(levels)
            # Compute the index of the anchors at the center of the image
            level_start = sum(anchors_per_level[:level]) # sum of anchors of previous levels
            level_anchors = anchors[level_start:level_start+anchors_per_level[level]]
            print("Level {}. Anchors: {:6}  Feature map Shape: {}".format(level, level_anchors.shape[0], 
                                                                          backbone_shapes[level]))
            center_cell = backbone_shapes[level] // 2
            center_cell_index = (center_cell[0] * backbone_shapes[level][1] + center_cell[1])
            level_center = center_cell_index * anchors_per_cell
            center_anchor = anchors_per_cell * (
                (center_cell[0] * backbone_shapes[level][1] / config.RPN_ANCHOR_STRIDE**2) \
                + center_cell[1] / config.RPN_ANCHOR_STRIDE)
            level_center = int(center_anchor)

            # Draw anchors. Brightness show the order in the array, dark to bright.
            for i, rect in enumerate(level_anchors[level_center:level_center+anchors_per_cell]):
                y1, x1, y2, x2 = rect
                p = patches.Rectangle((x1, y1), x2-x1, y2-y1, linewidth=2, facecolor='none',
                                      edgecolor=(i+1)*np.array(colors[level]) / anchors_per_cell)
                ax.add_patch(p)


'''
## Load YAML file as easy dictionary object
'''
def yaml_load(fileName):
  import yaml
  from easydict import EasyDict as edict
  fc = None
  with open(fileName, 'r') as f:
    # fc = edict(yaml.load(f))
    fc = edict(yaml.safe_load(f))

  return fc


def get_dataset_dnncfg(datacfg, subset = "train"):
    '''
    ## Load configurations file and create config object
    '''
    from importlib import import_module
    from core.InferenceConfig import InferenceConfig

    print("datacfg.DATACLASS: {}".format(datacfg.DATACLASS))

    mod = import_module(datacfg.DATACLASS)
    modcls = getattr(mod, datacfg.DATACLASS)

    dataset = modcls(datacfg.NAME)
    dataset.load_data(subset, datacfg)
    dataset.prepare()

    class_names = [ i['name'] for i in dataset.class_info]
    num_classes = len(dataset.class_info)
    datacfg.CLASSES = class_names
    datacfg.CONFIG.NAME = dataset.name
    datacfg.CONFIG.NUM_CLASSES = num_classes

    dnncfg = InferenceConfig(datacfg.CONFIG)

    return dataset, dnncfg


# In[6]:
def main(dataset, dnncfg, ds_datacfg=None):
    '''
    ## Single entry point for all the steps for inspecting dataset
    '''
    inspectdata = InspectData()

    ## Uncomment for debugging
    # inspectdata.load_and_display_dataset(dataset, ds_datacfg)

    # In[7]:
    print("[7]. ---------------")
    print("Load and display random images and masks---------------")
    inspectdata.load_and_display_random_sample(dataset, ds_datacfg)

    # In[8]:
    print("[8]. ---------------")
    print("Bounding Boxes---------------")

    inspectdata.load_and_display_random_single_sample(dataset, ds_datacfg)

    # In[9]:
    print("[9]. ---------------")
    print("Resize Images---------------")
    inspectdata.load_and_resize_images(dataset, dnncfg, ds_datacfg)

    # In[10]:
    print("[10]. ---------------")
    print("Mini Masks---------------")
    image_id = inspectdata.load_mini_masks(dataset, dnncfg, ds_datacfg)

    print("image_id: {}".format(image_id))
    # In[11]:
    print("[11]. ---------------")
    print("Add augmentation and mask resizing---------------")
    inspectdata.add_augmentation(dataset, dnncfg, ds_datacfg, image_id)

    info = dataset.image_info[image_id]
    print("info: {}".format(info))

    # In[12]:
    print("[12]. ---------------")
    print("Anchors---------------")
    backbone_shapes, anchors, anchors_per_level, anchors_per_cell = inspectdata.generate_anchors(dnncfg)

    # In[13]:
    print("[13]. ---------------")
    print("Visualize anchors of one cell at the center of the feature map of a specific level---------------")
    inspectdata.visualize_anchors_at_center(dataset, ds_datacfg, dnncfg, backbone_shapes, anchors, anchors_per_level, anchors_per_cell)

    # In[14]:
    print("[14]. ---------------")
    print("info---------------")
    image_ids = dataset.image_ids
    print(image_ids)
    image_index = -1
    image_index = (image_index + 1) % len(image_ids)
    print("image_index:{}".format(image_index))

    # In[15]:
    print("[15]. ---------------")
    print("data_generator---------------")

    ## Data Generator
    # Create data generator
    random_rois = 2000
    g = modellib.data_generator(
        dataset, ds_datacfg, dnncfg, shuffle=True, random_rois=random_rois,
        batch_size=4,
        detection_targets=True)

    # Uncomment to run the generator through a lot of images
    # to catch rare errors
    # for i in range(1000):
    #     print(i)
    #     _, _ = next(g)

    # Get Next Image
    if random_rois:
        [normalized_images, image_meta, rpn_match, rpn_bbox, gt_class_ids, gt_boxes, gt_masks, rpn_rois, rois],     [mrcnn_class_ids, mrcnn_bbox, mrcnn_mask] = next(g)

        log("rois", rois)
        log("mrcnn_class_ids", mrcnn_class_ids)
        log("mrcnn_bbox", mrcnn_bbox)
        log("mrcnn_mask", mrcnn_mask)
    else:
        [normalized_images, image_meta, rpn_match, rpn_bbox, gt_boxes, gt_masks], _ = next(g)

    log("gt_class_ids", gt_class_ids)
    log("gt_boxes", gt_boxes)
    log("gt_masks", gt_masks)
    log("rpn_match", rpn_match, )
    log("rpn_bbox", rpn_bbox)
    image_id = modellib.parse_image_meta(image_meta)["image_id"][0]

    # Remove the last dim in mrcnn_class_ids. It's only added
    # to satisfy Keras restriction on target shape.
    mrcnn_class_ids = mrcnn_class_ids[:,:,0]


    # In[16]:
    print("[16]. ---------------")

    b = 0
    # Restore original image (reverse normalization)
    sample_image = modellib.unmold_image(normalized_images[b], dnncfg)

    # Compute anchor shifts.
    indices = np.where(rpn_match[b] == 1)[0]
    refined_anchors = utils.apply_box_deltas(anchors[indices], rpn_bbox[b, :len(indices)] * dnncfg.RPN_BBOX_STD_DEV)
    log("anchors", anchors)
    log("refined_anchors", refined_anchors)

    # Get list of positive anchors
    positive_anchor_ids = np.where(rpn_match[b] == 1)[0]
    print("Positive anchors: {}".format(len(positive_anchor_ids)))
    negative_anchor_ids = np.where(rpn_match[b] == -1)[0]
    print("Negative anchors: {}".format(len(negative_anchor_ids)))
    neutral_anchor_ids = np.where(rpn_match[b] == 0)[0]
    print("Neutral anchors: {}".format(len(neutral_anchor_ids)))

    print("ROI breakdown by class---------------")
    # ROI breakdown by class
    for c, n in zip(dataset.class_names, np.bincount(mrcnn_class_ids[b].flatten())):
        if n:
            print("{:23}: {}".format(c[:20], n))

    print("Show positive anchors---------------")
    # Show positive anchors
    fig, ax = plt.subplots(1, figsize=(16, 16))
    visualize.draw_boxes(sample_image, boxes=anchors[positive_anchor_ids],
                         refined_boxes=refined_anchors, ax=ax)


    # In[17]:
    print("[17]. ---------------")
    print("Show negative anchors---------------")
    # Show negative anchors
    visualize.draw_boxes(sample_image, boxes=anchors[negative_anchor_ids])


    # In[18]:
    print("[18]. ---------------")
    print("Show neutral anchors. They don't contribute to training---------------")
    # Show neutral anchors. They don't contribute to training.
    visualize.draw_boxes(sample_image, boxes=anchors[np.random.choice(neutral_anchor_ids, 100)])


    # In[19]:
    print("[19]. ---------------")
    print("ROIs---------------")
    ## ROIs
    if random_rois:
        # Class aware bboxes
        bbox_specific = mrcnn_bbox[b, np.arange(mrcnn_bbox.shape[1]), mrcnn_class_ids[b], :]

        # Refined ROIs
        refined_rois = utils.apply_box_deltas(rois[b].astype(np.float32), bbox_specific[:,:4] * dnncfg.BBOX_STD_DEV)

        # Class aware masks
        mask_specific = mrcnn_mask[b, np.arange(mrcnn_mask.shape[1]), :, :, mrcnn_class_ids[b]]

        visualize.draw_rois(sample_image, rois[b], refined_rois, mask_specific, mrcnn_class_ids[b], dataset.class_names)

        # Any repeated ROIs?
        rows = np.ascontiguousarray(rois[b]).view(np.dtype((np.void, rois.dtype.itemsize * rois.shape[-1])))
        _, idx = np.unique(rows, return_index=True)
        print("Unique ROIs: {} out of {}".format(len(idx), rois.shape[1]))


    # In[20]:
    print("[20]. ---------------")
    print("Dispalay ROIs and corresponding masks and bounding boxes---------------")
    if random_rois:
        # Dispalay ROIs and corresponding masks and bounding boxes
        ids = random.sample(range(rois.shape[1]), 8)

        images = []
        titles = []
        for i in ids:
            image = visualize.draw_box(sample_image.copy(), rois[b,i,:4].astype(np.int32), [255, 0, 0])
            image = visualize.draw_box(image, refined_rois[i].astype(np.int64), [0, 255, 0])
            images.append(image)
            titles.append("ROI {}".format(i))
            images.append(mask_specific[i] * 255)
            titles.append(dataset.class_names[mrcnn_class_ids[b,i]][:20])

        display_images(images, titles, cols=4, cmap="Blues", interpolation="none")


    # In[21]:
    print("[21]. ---------------")
    print("Check ratio of positive ROIs in a set of images.---------------")
    # Check ratio of positive ROIs in a set of images.
    if random_rois:
        limit = 10
        temp_g = modellib.data_generator(
            dataset, ds_datacfg, dnncfg, shuffle=True, random_rois=10000,
            batch_size=1, detection_targets=True)
        total = 0
        for i in range(limit):
            _, [ids, _, _] = next(temp_g)
            positive_rois = np.sum(ids[0] > 0)
            total += positive_rois
            print("{:5} {:5.2f}".format(positive_rois, positive_rois/ids.shape[1]))
        print("Average percent: {:.2f}".format(total/(limit*ids.shape[1])))


'''
## parse_args
'''
def parse_args():
  import argparse
  ## Parse command line arguments
  parser = argparse.ArgumentParser(
    description='Inspect Mask R-CNN Data - masks, augmentation, Anchors, ROIs.')

  parser.add_argument('--cfg'
    ,metavar="/path/to/<name>-cfg.yml"
    ,required=True
    ,help='Configuration file (yml) for specifiying DNN training parameters, ex: `balloon-cfg.yml`')

  args = parser.parse_args()    

  return args


'''
TBD:
* Images Stats:
    - total
    - dimensions: max, min, mean
* Annotations Stats:
    - total
    - area
'''
if __name__ == '__main__':
    '''
    ## Configurations
    Configurations are defined in `.yml` file
    '''
    # cfgroot = 'cfg'
    # cfgroot = 'cfg-dev'

    # cfgfilename = 'hmd-cfg.yml'
    # cfgfilename = 'tsd-cfg.yml'
    # cfgfilename = 'balloon-cfg.yml'

    # cfgfile = os.path.join(cfgroot, cfgfilename)

    args = parse_args()
    cfgfile = args.cfg
    datacfg = yaml_load(cfgfile)
    subset = "train"
    dataset, dnncfg = get_dataset_dnncfg(datacfg, subset)
    dnncfg.display()

    main(dataset, dnncfg)
