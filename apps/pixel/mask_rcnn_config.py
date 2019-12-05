from mrcnn.config import Config

## Ref:
## How to creating-class-instance-properties-from-a-dictionary?
## https://stackoverflow.com/questions/1639174/creating-class-instance-properties-from-a-dictionary
#
## How to invoke the super constructor?
## https://stackoverflow.com/questions/2399307/how-to-invoke-the-super-constructor#2399332
class Mask_Rcnn_Config(Config):
  def __init__(self, dictionary):
    for k,v in dictionary.items():
      setattr(self, k, v)
    super(Mask_Rcnn_Config, self).__init__()



############################################################
#  Configurations
############################################################

# ## TBD: change the configuration from external config and at run time: IMAGE_MAX_DIM, IMAGE_MIN_DIM based on the image under prediction
# class Mask_Rcnn_Config(Config):
#     # Set batch size to 1 since we'll be running inference on
#     # one image at a time. Batch size = GPU_COUNT * IMAGES_PER_GPU
#     GPU_COUNT = 1

#     """Configuration for training on MS COCO.
#     Derives from the base Config class and overrides values specific
#     to the COCO dataset.
#     """
#     # Give the configuration a recognizable name
#     NAME = "road"
#     # NAME = "coco"

#     # We use a GPU with 12GB memory, which can fit two images.
#     # Adjust down if you use a smaller GPU.
#     IMAGES_PER_GPU = 1

#     # Uncomment to train on 8 GPUs (default is 1)
#     # GPU_COUNT = 8

#     # Number of classes (including background)
#     NUM_CLASSES = 1 + 1  # Background + road
#     # NUM_CLASSES = 1 + 80  # Background + thing
    
#     # Skip detections with < 90% confidence
#     DETECTION_MIN_CONFIDENCE = 0.9

#     IMAGE_MIN_DIM = 1080
#     IMAGE_MAX_DIM = 1920

