import os
import sys
import random
import numpy as np

# import logging
# log = logging.getLogger(__name__)


## arch specific code
from mrcnn import model as modellib
from mrcnn import utils
from mrcnn.config import Config
from mrcnn import visualize
from mrcnn.model import log as customlog

import matplotlib.pyplot as plt
import matplotlib.patches as patches

import logging
log = logging.getLogger('__main__.'+__name__)
# log = logging.getLogger(__name__)
# log.setLevel(logging.DEBUG)


def load_and_display_random_sample(dataset, datacfg, N=2):
  """Load and display random samples
  """
  log.info("load_and_display_random_sample::-------------------------------->")

  image_ids = np.random.choice(dataset.image_ids, N)
  class_names = dataset.class_names
  log.debug("dataset: len(image_ids): {}\nimage_ids: {}".format(len(image_ids), image_ids))
  log.debug("dataset: len(class_names): {}\nclass_names: {}".format(len(class_names), class_names))

  for image_id in image_ids:
    image = dataset.load_image(image_id, datacfg)
    mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg)

    log.debug("keys: {}".format(keys))
    log.debug("values: {}".format(values))
    log.debug("class_ids: {}".format(class_ids))

    ## Display image and instances
    visualize.display_top_masks(image, mask, class_ids, class_names)
    ## Compute Bounding box
    
    bbox = utils.extract_bboxes(mask)
    log.debug("bbox: {}".format(bbox))
    visualize.display_instances(image, bbox, mask, class_ids, class_names)
    # return image, bbox, mask, class_ids, class_names


def load_and_display(dataset, datacfg, image_ids):
  """Load and display given image_ids
  """
  log.info("load_and_display::-------------------------------->")

  class_names = dataset.class_names
  log.debug("dataset: len(image_ids): {}\nimage_ids: {}".format(len(image_ids), image_ids))
  log.debug("dataset: len(class_names): {}\nclass_names: {}".format(len(class_names), class_names))

  for image_id in image_ids:
    image = dataset.load_image(image_id, datacfg)
    mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg)

    log.debug("keys: {}".format(keys))
    log.debug("values: {}".format(values))
    log.debug("class_ids: {}".format(class_ids))

    ## Display image and instances
    # visualize.display_top_masks(image, mask, class_ids, class_names)
    ## Compute Bounding box
    
    bbox = utils.extract_bboxes(mask)
    log.debug("bbox: {}".format(bbox))
    visualize.display_instances(image, bbox, mask, class_ids, class_names, show_bbox=False)
    # return image, bbox, mask, class_ids, class_names


def load_and_resize_images(dataset, datacfg, dnncfg):
  '''
  ## Resize Images
  To support multiple images per batch, images are resized to one size (1024x1024).
  Aspect ratio is preserved, though. If an image is not square, then zero padding
  is added at the top/bottom or right/left.
  '''
  log.info("load_and_resize_images::-------------------------------->")

  image_id = np.random.choice(dataset.image_ids, 1)[0]
  image = dataset.load_image(image_id)

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
  log.debug("Original shape: {}".format(original_shape))
  # customlog("image", image)
  # customlog("mask", mask)
  # customlog("class_ids", class_ids)
  # customlog("bbox", bbox)

  ## Display image and instances
  class_names = dataset.class_names
  visualize.display_instances(image, bbox, mask, class_ids, class_names)


def load_mini_masks(dataset, datacfg, dnncfg):
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
  log.info("load_mini_masks::-------------------------------->")

  image_id = np.random.choice(dataset.image_ids, 1)[0]
  log.debug("image_id: {}".format(image_id))
  image, image_meta, class_ids, bbox, mask = modellib.load_image_gt(
      dataset, datacfg, dnncfg, image_id, use_mini_mask=False)

  # customlog("image", image)
  # customlog("image_meta", image_meta)
  # customlog("class_ids", class_ids)
  # customlog("bbox", bbox)
  # customlog("mask", mask)

  visualize.display_images([image]+[mask[:,:,i] for i in range(min(mask.shape[-1], 7))])

  ## Display image and instances
  class_names = dataset.class_names
  visualize.display_instances(image, bbox, mask, class_ids, class_names)

  return image_id


def add_augmentation(dataset, datacfg, dnncfg, image_id=None):
    '''
    # Add augmentation and mask resizing.
    '''
    log.info("add_augmentation::-------------------------------->")

    image_id = image_id if image_id==None else np.random.choice(dataset.image_ids, 1)[0]
    # Add augmentation and mask resizing.
    image, image_meta, class_ids, bbox, mask = modellib.load_image_gt(dataset, datacfg, dnncfg, image_id, augment=True, use_mini_mask=False)
    # customlog("mask", mask)
    
    visualize.display_images([image]+[mask[:,:,i] for i in range(min(mask.shape[-1], 7))])
    mask = utils.expand_mask(bbox, mask, image.shape)

    ## Display image and instances
    class_names = dataset.class_names
    visualize.display_instances(image, bbox, mask, class_ids, class_names)


def generate_anchors(dnncfg):
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
  log.info("generate_anchors::-------------------------------->")

  # Generate Anchors
  backbone_shapes = modellib.compute_backbone_shapes(dnncfg, dnncfg.IMAGE_SHAPE)
  anchors = utils.generate_pyramid_anchors(dnncfg.RPN_ANCHOR_SCALES,
                                            dnncfg.RPN_ANCHOR_RATIOS,
                                            backbone_shapes,
                                            dnncfg.BACKBONE_STRIDES, 
                                            dnncfg.RPN_ANCHOR_STRIDE)

  # Print summary of anchors
  num_levels = len(backbone_shapes)
  anchors_per_cell = len(dnncfg.RPN_ANCHOR_RATIOS)
  log.debug("Count: {}".format(anchors.shape[0]))
  log.debug("Scales: {}".format(dnncfg.RPN_ANCHOR_SCALES))
  log.debug("ratios: {}".format(dnncfg.RPN_ANCHOR_RATIOS))
  log.debug("Anchors per Cell: {}".format(anchors_per_cell))
  log.debug("Levels: {}".format(num_levels))
  anchors_per_level = []
  for l in range(num_levels):
      num_cells = backbone_shapes[l][0] * backbone_shapes[l][1]
      anchors_per_level.append(anchors_per_cell * num_cells // dnncfg.RPN_ANCHOR_STRIDE**2)
      log.debug("Anchors in Level {}: {}".format(l, anchors_per_level[l]))
  return backbone_shapes, anchors, anchors_per_level, anchors_per_cell


def visualize_anchors_at_center(dataset, datacfg, dnncfg, backbone_shapes, anchors, anchors_per_level, anchors_per_cell):
  '''
  ## Visualize anchors of one cell at the center of the feature map of a specific level
  '''
  log.info("visualize_anchors_at_center::-------------------------------->")
  # Load and draw random image
  image_id = np.random.choice(dataset.image_ids, 1)[0]

  image, image_meta, _, _, _ = modellib.load_image_gt(dataset, datacfg, dnncfg, image_id)
  fig, ax = plt.subplots(1, figsize=(10, 10))
  ax.imshow(image)
  levels = len(backbone_shapes)

  for level in range(levels):
      colors = visualize.random_colors(levels)
      # Compute the index of the anchors at the center of the image
      level_start = sum(anchors_per_level[:level]) # sum of anchors of previous levels
      level_anchors = anchors[level_start:level_start+anchors_per_level[level]]
      log.debug("Level {}. Anchors: {:6}  Feature map Shape: {}".format(level, level_anchors.shape[0], 
                                                                    backbone_shapes[level]))
      center_cell = backbone_shapes[level] // 2
      center_cell_index = (center_cell[0] * backbone_shapes[level][1] + center_cell[1])
      level_center = center_cell_index * anchors_per_cell
      center_anchor = anchors_per_cell * (
          (center_cell[0] * backbone_shapes[level][1] / dnncfg.RPN_ANCHOR_STRIDE**2) \
          + center_cell[1] / dnncfg.RPN_ANCHOR_STRIDE)
      level_center = int(center_anchor)

      # Draw anchors. Brightness show the order in the array, dark to bright.
      for i, rect in enumerate(level_anchors[level_center:level_center+anchors_per_cell]):
          y1, x1, y2, x2 = rect
          p = patches.Rectangle((x1, y1), x2-x1, y2-y1, linewidth=2, facecolor='none',
                                edgecolor=(i+1)*np.array(colors[level]) / anchors_per_cell)
          ax.add_patch(p)


def all_steps(dataset, datacfg, dnncfg):
  '''
  ## Single entry point for all the steps for inspecting dataset
  '''

  ## Uncomment for debugging
  # inspectdata.load_and_display_dataset(dataset, datacfg)

  # In[7]:
  log.info("[7]. ---------------")
  log.info("Load and display random images and masks---------------")
  log.info("Bounding Boxes---------------")
  load_and_display_random_sample(dataset, datacfg)

  # In[9]:
  log.info("[9]. ---------------")
  log.info("Resize Images---------------")
  load_and_resize_images(dataset, datacfg, dnncfg)

  # In[10]:
  log.info("[10]. ---------------")
  log.info("Mini Masks---------------")
  image_id = load_mini_masks(dataset, datacfg, dnncfg)

  log.info("image_id: {}".format(image_id))
  # In[11]:
  log.info("[11]. ---------------")
  log.info("Add augmentation and mask resizing---------------")
  add_augmentation(dataset, datacfg, dnncfg, image_id)

  info = dataset.image_info[image_id]
  log.debug("info: {}".format(info))

  # In[12]:
  log.info("[12]. ---------------")
  log.info("Anchors---------------")
  backbone_shapes, anchors, anchors_per_level, anchors_per_cell = generate_anchors(dnncfg)

  # In[13]:
  log.info("[13]. ---------------")
  log.info("Visualize anchors of one cell at the center of the feature map of a specific level---------------")
  visualize_anchors_at_center(dataset, datacfg, dnncfg, backbone_shapes, anchors, anchors_per_level, anchors_per_cell)

  # In[14]:
  log.info("[14]. ---------------")
  log.info("info---------------")
  image_ids = dataset.image_ids
  log.info(image_ids)
  image_index = -1
  image_index = (image_index + 1) % len(image_ids)
  log.info("image_index:{}".format(image_index))

  # In[15]:
  log.info("[15]. ---------------")
  log.info("data_generator---------------")

  ## Data Generator
  # Create data generator
  random_rois = 2000
  g = modellib.data_generator(
      dataset, datacfg, dnncfg, shuffle=True, random_rois=random_rois,
      batch_size=4,
      detection_targets=True)

  # Uncomment to run the generator through a lot of images
  # to catch rare errors
  # for i in range(1000):
  #     log.debug(i)
  #     _, _ = next(g)

  # Get Next Image
  if random_rois:
      [normalized_images, image_meta, rpn_match, rpn_bbox, gt_class_ids, gt_boxes, gt_masks, rpn_rois, rois],     [mrcnn_class_ids, mrcnn_bbox, mrcnn_mask] = next(g)

      customlog("rois", rois)
      customlog("mrcnn_class_ids", mrcnn_class_ids)
      customlog("mrcnn_bbox", mrcnn_bbox)
      customlog("mrcnn_mask", mrcnn_mask)
  else:
      [normalized_images, image_meta, rpn_match, rpn_bbox, gt_boxes, gt_masks], _ = next(g)

  customlog("gt_class_ids", gt_class_ids)
  customlog("gt_boxes", gt_boxes)
  customlog("gt_masks", gt_masks)
  customlog("rpn_match", rpn_match, )
  customlog("rpn_bbox", rpn_bbox)
  image_id = modellib.parse_image_meta(image_meta)["image_id"][0]

  # Remove the last dim in mrcnn_class_ids. It's only added
  # to satisfy Keras restriction on target shape.
  mrcnn_class_ids = mrcnn_class_ids[:,:,0]


  # In[16]:
  log.info("[16]. ---------------")

  b = 0
  # Restore original image (reverse normalization)
  sample_image = modellib.unmold_image(normalized_images[b], dnncfg)

  # Compute anchor shifts.
  indices = np.where(rpn_match[b] == 1)[0]
  refined_anchors = utils.apply_box_deltas(anchors[indices], rpn_bbox[b, :len(indices)] * dnncfg.RPN_BBOX_STD_DEV)
  customlog("anchors", anchors)
  customlog("refined_anchors", refined_anchors)

  # Get list of positive anchors
  positive_anchor_ids = np.where(rpn_match[b] == 1)[0]
  log.info("Positive anchors: {}".format(len(positive_anchor_ids)))
  negative_anchor_ids = np.where(rpn_match[b] == -1)[0]
  log.info("Negative anchors: {}".format(len(negative_anchor_ids)))
  neutral_anchor_ids = np.where(rpn_match[b] == 0)[0]
  log.info("Neutral anchors: {}".format(len(neutral_anchor_ids)))

  log.info("ROI breakdown by class---------------")
  # ROI breakdown by class
  for c, n in zip(dataset.class_names, np.bincount(mrcnn_class_ids[b].flatten())):
      if n:
          log.info("{:23}: {}".format(c[:20], n))

  log.info("Show positive anchors---------------")
  # Show positive anchors
  fig, ax = plt.subplots(1, figsize=(16, 16))
  visualize.draw_boxes(sample_image, boxes=anchors[positive_anchor_ids],
                       refined_boxes=refined_anchors, ax=ax)


  # In[17]:
  log.info("[17]. ---------------")
  log.info("Show negative anchors---------------")
  # Show negative anchors
  visualize.draw_boxes(sample_image, boxes=anchors[negative_anchor_ids])


  # In[18]:
  log.info("[18]. ---------------")
  log.info("Show neutral anchors. They don't contribute to training---------------")
  # Show neutral anchors. They don't contribute to training.
  visualize.draw_boxes(sample_image, boxes=anchors[np.random.choice(neutral_anchor_ids, 100)])


  # In[19]:
  log.info("[19]. ---------------")
  log.info("ROIs---------------")
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
      log.info("Unique ROIs: {} out of {}".format(len(idx), rois.shape[1]))


  # In[20]:
  log.info("[20]. ---------------")
  log.info("Dispalay ROIs and corresponding masks and bounding boxes---------------")
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

      visualize.display_images(images, titles, cols=4, cmap="Blues", interpolation="none")


  # In[21]:
  log.info("[21]. ---------------")
  log.info("Check ratio of positive ROIs in a set of images.---------------")
  # Check ratio of positive ROIs in a set of images.
  if random_rois:
      limit = 10
      temp_g = modellib.data_generator(
          dataset, datacfg, dnncfg, shuffle=True, random_rois=10000,
          batch_size=1, detection_targets=True)
      total = 0
      for i in range(limit):
          _, [ids, _, _] = next(temp_g)
          positive_rois = np.sum(ids[0] > 0)
          total += positive_rois
          log.info("{:5} {:5.2f}".format(positive_rois, positive_rois/ids.shape[1]))
      log.info("Average percent: {:.2f}".format(total/(limit*ids.shape[1])))
