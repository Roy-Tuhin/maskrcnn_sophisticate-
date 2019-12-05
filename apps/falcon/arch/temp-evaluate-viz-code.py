
        # log.debug("len(pred_boxes), pred_boxes.shape, type(pred_boxes): {},{},{}".format(len(pred_boxes), pred_boxes.shape, type(pred_boxes)))
        # log.debug("len(pred_masks), pred_masks.shape, type(pred_masks): {},{},{}".format(len(pred_masks), pred_masks.shape, type(pred_masks)))
        # log.debug("len(pred_match_class_ids), type(pred_match_class_ids): {},{}".format(len(pred_match_class_ids), type(pred_match_class_ids)))
        # log.info("boxes.shape, masks.shape, pred_match_class_ids.shape: {},{},{}".format(pred_boxes.shape, pred_masks.shape, pred_match_class_ids.shape))

        # ## TODO: if model is trained with higher classes but dataset contains less classes; this fails because predictions bbox and masks are higher and not equal to class_ids
        # ## TODO: visualize pred_match_class_ids alone, which is different from pred_class_ids; or highlight in viz which are those matched IDs
        # ## TODO: batchify
        # if save_viz_and_json:
        #   imgviz, jsonres = viz.get_display_instances(im, pred_boxes, pred_masks, pred_class_ids, class_names, pred_scores,
        #                                                  colors=cc, show_bbox=False, get_mask=get_mask)
        #   # imgviz, jsonres = viz.get_display_instances(im, pred_boxes, pred_masks, np.array(pred_match_class_ids), class_names, pred_scores,
        #   #                                                colors=cc, show_bbox=False, get_mask=get_mask)
        # else:
        #   jsonres = viz.get_detections(im, pred_boxes, pred_masks, pred_class_ids, class_names, pred_scores,
        #                                  colors=cc, get_mask=get_mask)
        #   # jsonres = viz.get_detections(im, pred_boxes, pred_masks, np.array(pred_match_class_ids), class_names, pred_scores,
        #   #                                colors=cc, get_mask=get_mask)

        # ## Convert Json response to VIA Json response
        # ##---------------------------------------------
        # # size_image = 0
        # size_image = os.path.getsize(filepath_image_in)
        # jsonres["filename"] = image_filename
        # jsonres["size"] = size_image

        # ## Create Visualisations & Save output
        # ## TODO: resize the annotation and match with the original image size and not the min or max image dimenion form cfg
        # ##---------------------------------------------
        # time_taken_save_viz_and_json = -1
        # if save_viz_and_json:
        #   t6 = time.time()
        #   # ## TODO: resize image and masks to the original image size, unable to fix the vizulaisation and mask in the original dimensions

        #   # ## expand the masks to original image size
        #   # gt_masks = utils.expand_mask(gt_boxes, gt_masks, original_image_shape)
        #   # gt_boxes = utils.extract_bboxes(gt_masks)


        #   # pred_masks = utils.expand_mask(pred_boxes, pred_masks, original_image_shape)

        #   # ## recompute bbox by extracting the bbox from the resized mask
        #   # pred_boxes = utils.extract_bboxes(pred_masks)
          
        #   # ## resize the image to the original size
        #   # im = utils.resize(im, original_image_shape)


        #   ## Annotation Visualisation & Save image
        #   ##---------------------------------------------

        #   fext = ".png"
        #   file_name = image_filename+fext
        #   log.info("saved to: file_name: {}".format(file_name))

        #   ## Color Mask Effect & Save image
        #   ##---------------------------------------------
        #   viz.imsave(os.path.join(filepath, 'mask', file_name), viz.color_mask(im, pred_masks))

        #   ## Annotation Visualisation & Save image
        #   ##---------------------------------------------
        #   viz.imsave(os.path.join(filepath, 'viz', file_name), imgviz)

        #   t7 = time.time()
        #   time_taken_save_viz_and_json = (t6 - t7)
        #   log.debug('Total time taken in save_viz_and_json: %f seconds' %(time_taken_save_viz_and_json))

        # t8 = time.time()
        # tt_turnaround = (t8 - t0)
        # log.debug('Total time taken in tt_turnaround: %f seconds' %(tt_turnaround))

        # jsonres['file_attributes'] = {
        #   'image_read': time_taken_imread
        #   ,'detect': time_taken_in_detect
        #   ,'res_preparation': time_taken_res_preparation
        #   ,'time_taken_save_viz_and_json': time_taken_save_viz_and_json
        #   ,'tt_turnaround': tt_turnaround
        # }

        # ## TODO: if want to store in mongoDB, '.' (dot) should not be present in the key in the json data
        # ## but, to visualize the results in VIA tool, this (dot) and size is expected
        # # via_jsonres[image_filename.replace('.','-')+str(size_image)] = json.loads(common.numpy_to_json(jsonres))
        # via_jsonres[image_filename+str(size_image)] = json.loads(common.numpy_to_json(jsonres))
