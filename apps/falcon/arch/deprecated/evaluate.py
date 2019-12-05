import os
import numpy as np
import json
import datetime
import time
from collections import defaultdict

import pandas as pd

import logging
log = logging.getLogger('__main__.'+__name__)


## custom imports
import common

from falcon.utils import viz

## arch specific code
from mrcnn import utils


def load_image_gt_without_resizing(dataset, datacfg, config, image_id):
  """Inspired from load_image_gt, but does not re-size the image
  """

  # Load image and mask
  image = dataset.load_image(image_id, datacfg, config)
  mask, class_ids, keys, values = dataset.load_mask(image_id, datacfg, config)
  # Note that some boxes might be all zeros if the corresponding mask got cropped out.
  # and here is to filter them out
  _idx = np.sum(mask, axis=(0, 1)) > 0
  mask = mask[:, :, _idx]
  class_ids = class_ids[_idx]
  
  # Bounding boxes. Note that some boxes might be all zeros
  # if the corresponding mask got cropped out.
  # bbox: [num_instances, (y1, x1, y2, x2)]
  bbox = utils.extract_bboxes(mask)

  # Active classes
  # Different datasets have different classes, so track the
  # classes supported in the dataset of this image.
  active_class_ids = np.zeros([dataset.num_classes], dtype=np.int32)
  source_class_ids = dataset.source_class_ids[dataset.image_info[image_id]["source"]]
  active_class_ids[source_class_ids] = 1
  
  # return image, class_ids, bbox, mask
  return image, class_ids, bbox, mask, active_class_ids


def execute_eval(detect, model, dataset, datacfg, dnncfg, class_names, reportcfg, get_mask=True):
  """Execute the evaluation and generates the evaluation reports
  - classification report with differet scores
  - confusion matrix
  - summary report
  """
  log.info("execute_eval---------------------------->")

  save_viz_and_json = reportcfg['save_viz_and_json']
  evaluate_no_of_result = reportcfg['evaluate_no_of_result']
  filepath = reportcfg['filepath']
  evaluate_run_summary = reportcfg['evaluate_run_summary']

  log.info("evaluate_no_of_result: {}".format(evaluate_no_of_result))

  detection_on_dataset = []
  ## TODO: put at right place
  iou_threshold = reportcfg['iou_threshold']
  # iou_thresholds = None
  # iou_thresholds = iou_thresholds or np.arange(0.5, 1.0, 0.05)
  iou_thresholds = np.arange(0.5, 1.0, 0.05)

  gt_total_annotation = 0
  pred_total_annotation = 0
  remaining_num_images = -1
  image_ids = dataset.image_ids
  num_images = len(image_ids)
  pred_match_total_annotation = []
  
  log.info("class_names: {}".format(class_names))
  
  colors = viz.random_colors(len(class_names))
  log.info("len(colors), colors: {},{}".format(len(colors), colors))

  cc = dict(zip(class_names,colors))

  ## for some reasons if gets an error in iterating through dataset, all the hardwork is lost,
  ## therefore, save the data to disk in finally clause
  via_jsonres = {}
  imagelist = []
  T0 = time.time()

  try:
    for i, image_id in enumerate(image_ids):
      log.debug("-------")

      filepath_image_in = dataset.image_reference(image_id)
      image_filename = filepath_image_in.split(os.path.sep)[-1]
      image_name_without_ext = image_filename.split('.')[0]

      imagelist.append(filepath_image_in)
      log.debug("Running on {}".format(image_filename))

      if evaluate_no_of_result == i:
        log.info("evaluate_no_of_result reached: i: {}\n".format(i))
        break

      remaining_num_images = evaluate_no_of_result if evaluate_no_of_result and evaluate_no_of_result > 0 else num_images
      remaining_num_images = remaining_num_images - i - 1
      log.info("To be evaluated remaining_num_images:...................{}".format(remaining_num_images))

      t0 = time.time()

      im, gt_class_ids, gt_boxes, gt_masks, gt_active_class_ids = load_image_gt_without_resizing(dataset, datacfg, dnncfg, image_id)

      t1 = time.time()
      time_taken_imread = (t1 - t0)
      log.debug('Total time taken in time_taken_imread: %f seconds' %(time_taken_imread))

      gt_total_annotation += len(gt_class_ids)

      log.info("\nGround Truth-------->")

      log.info("i,image_id:{},{}".format(i,image_id))
      log.info("len(gt_active_class_ids),gt_active_class_ids: {},{}".format(len(gt_active_class_ids), gt_active_class_ids))

      log.info("len(gt_class_ids): {}\nTotal Unique classes: len(set(gt_class_ids)): {}\ngt_class_ids: {}".format(len(gt_class_ids), len(set(gt_class_ids)), gt_class_ids))
      log.info("len(gt_boxes), gt_boxes.shape, type(gt_boxes): {},{},{}".format(len(gt_boxes), gt_boxes.shape, type(gt_boxes)))
      log.info("len(gt_masks), gt_masks.shape, type(gt_masks): {},{},{}".format(len(gt_masks), gt_masks.shape, type(gt_masks)))
      
      log.debug("gt_boxes: {}".format(gt_boxes))
      log.debug("gt_masks: {}".format(gt_masks))

      log.info("--------")

      # Detect objects
      ##---------------------------------------------
      t2 = time.time()

      r = detect(model, im=im, verbose=1)[0]
      pred_boxes = r['rois']
      pred_masks =  r['masks']
      pred_class_ids = r['class_ids']
      pred_scores = r['scores']

      pred_total_annotation += len(pred_class_ids)

      log.debug("Prediction on Groud Truth-------->")
      log.debug('len(r): {}'.format(len(r)))
      log.debug("len(pred_class_ids), pred_class_ids, type(pred_class_ids): {},{},{}".format(len(pred_class_ids), pred_class_ids, type(pred_class_ids)))
      log.debug("len(pred_boxes), pred_boxes.shape, type(pred_boxes): {},{},{}".format(len(pred_boxes), pred_boxes.shape, type(pred_boxes)))
      log.debug("len(pred_masks), pred_masks.shape, type(pred_masks): {},{},{}".format(len(pred_masks), pred_masks.shape, type(pred_masks)))
      log.debug("--------")

      t3 = time.time()
      time_taken_in_detect = (t3 - t2)
      log.debug('Total time taken in detect: %f seconds' %(time_taken_in_detect))

      t4 = time.time()

      ## TODO: gt via_json resp and pred via jsn res separate data strucure
      ## TODO: mAP calculation for per image, per class and enitre dataset

      ##TODO: this does not help; need to flatten the all ground truts for eniter dataset.
      ## np.zeros(len(gt_for_all_images)), ideally same number of predictions sohuld be there
      ## Insort; have to re-write the compute_matches function for entire dataset

      evaluate_run_summary['images'].append(image_filename)
      # evaluate_run_summary['gt_boxes'].append(gt_boxes)
      evaluate_run_summary['gt_class_ids'].append(list(gt_class_ids))
      # evaluate_run_summary['gt_masks'].append(gt_masks)
      # evaluate_run_summary['pred_boxes'].append(pred_boxes)
      evaluate_run_summary['pred_class_ids'].append(list(pred_class_ids))
      evaluate_run_summary['pred_scores'].append(list(pred_scores))
      # evaluate_run_summary['pred_masks'].append(pred_masks)
      evaluate_run_summary['gt_total_annotation_per_image'].append(len(gt_class_ids))
      evaluate_run_summary['pred_total_annotation_per_image'].append(len(pred_class_ids))

      detection_on_dataset_item = defaultdict(list)
      __pred_match_total_annotation = np.zeros([len(iou_thresholds)], dtype=int)
  
      for count, iou_threshold in enumerate(iou_thresholds):
        log.info("count, iou_threshold: {}, {}".format(count, iou_threshold))

        ## Compute Average Precision at a set IoU threshold
        ## --------------------------------------------
        AP_per_image, precisions, recalls, gt_match, pred_match, overlaps, pred_match_scores, pred_match_class_ids = utils.compute_ap(
          gt_boxes, gt_class_ids, gt_masks,
          pred_boxes, pred_class_ids, pred_scores, pred_masks,
          iou_threshold=iou_threshold)

        __pred_match_total_annotation[count] += len(pred_match_class_ids)

        ## compute and returns f1 score metric
        ## --------------------------------------------
        f1_per_image = utils.compute_f1score(precisions, recalls)

        ## Compute the recall at the given IoU threshold. It's an indication
        ## of how many GT boxes were found by the given prediction boxes.
        ## --------------------------------------------
        recall_bbox, positive_ids_bbox = utils.compute_recall(gt_boxes, pred_boxes, iou_threshold)

        # log.info("len(precisions),precisions: {},{}".format(len(precisions), precisions))
        # log.info("len(recalls),recalls: {},{}".format(len(recalls), recalls))
        # log.info("len(pred_match_class_ids),pred_match_class_ids: {},{}".format(len(pred_match_class_ids), pred_match_class_ids))

        # log.info("AP_per_image: {}".format(AP_per_image))
        # log.info("len(overlaps),overlaps: {},{}".format(len(overlaps), overlaps))

        class_names = np.array(class_names)
        pred_match_class_names = list(class_names[np.where(np.in1d(dataset.class_ids, pred_match_class_ids))[0]])
        class_names = list(class_names)

        detection_on_dataset_item['ap_per_image'].append(AP_per_image)
        detection_on_dataset_item['f1_per_image'].append(f1_per_image)
        detection_on_dataset_item['precisions'].append(precisions)
        detection_on_dataset_item['recalls'].append(list(recalls))
        detection_on_dataset_item['recall_bbox'].append(recall_bbox)
        detection_on_dataset_item['positive_ids_bbox'].append(list(positive_ids_bbox))
        detection_on_dataset_item['gt_match'].append(list(gt_match))
        detection_on_dataset_item['pred_match'].append(list(pred_match))
        detection_on_dataset_item['pred_match_scores'].append(list(pred_match_scores))
        detection_on_dataset_item['overlaps_mask_iou'].append(list(overlaps))
        detection_on_dataset_item['pred_match_class_ids'].append(list(pred_match_class_ids))
        detection_on_dataset_item['pred_match_class_names'].append(pred_match_class_names)
        detection_on_dataset_item['pred_match_total_annotation'].append(len(pred_match_class_ids))
        detection_on_dataset_item['iou_thresholds'].append(iou_threshold)

        ## TODO: ref temp-evaluate-viz.code.py

      detection_on_dataset.append(detection_on_dataset_item)
      pred_match_total_annotation.append(__pred_match_total_annotation)
    log.info("---x-x---")
  except Exception as e:
    log.info("Exception: {}".format(e))
    raise
  finally:
    log.info("--------X--------X--------X--------")
    T1 = time.time()

    evaluate_run_summary['total_execution_time'] = T1 - T0
    evaluate_run_summary['pred_match_total_annotation'] = pred_match_total_annotation
    evaluate_run_summary['gt_total_annotation'] = gt_total_annotation
    evaluate_run_summary['pred_total_annotation'] = pred_total_annotation
    evaluate_run_summary['iou_thresholds'] = iou_thresholds
    evaluate_run_summary['execution_end_time'] = "{:%d%m%y_%H%M%S}".format(datetime.datetime.now())
    # evaluate_run_summary['detection_min_confidence'] = dnncfg.config['DETECTION_MIN_CONFIDENCE']
    evaluate_run_summary['remaining_num_images'] = remaining_num_images
    # evaluate_run_summary['total_images'] = num_images

    log.debug("evaluate_run_summary: {}".format(evaluate_run_summary))

    ## Save the image list for loading the response in VIA along with the images
    imagelist_filepath = os.path.join(filepath, 'annotations', "imagelist.csv")
    pd.DataFrame(imagelist).to_csv(imagelist_filepath)

    classification_reportfile_path = reportcfg['classification_reportfile']+'-per_dataset.json'
    with open(classification_reportfile_path,'w') as fw:
      fw.write(common.numpy_to_json(detection_on_dataset))

    evaluate_run_summary_reportfile_path = reportcfg['evaluate_run_summary_reportfile']+'.json'
    with open(evaluate_run_summary_reportfile_path,'w') as fw:
      fw.write(common.numpy_to_json(evaluate_run_summary))

    print("EVALUATE_REPORT:IMAGELIST:{}".format(imagelist_filepath))
    print("EVALUATE_REPORT:METRIC:{}".format(classification_reportfile_path))
    print("EVALUATE_REPORT:SUMMARY:{}".format(evaluate_run_summary_reportfile_path))

    log.info("--------")

    return evaluate_run_summary
