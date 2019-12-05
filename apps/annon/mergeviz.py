import os
import glob
import numpy as np
import skimage.io
path = "/aimldl-dat/data-gaze/rld_job_110919/merged"

items = np.arange(1,105)
save_path = "/aimldl-dat/data-gaze/rld_job_110919/intro"
for index, i in enumerate(items):
  x = glob.glob('/aimldl-dat/data-gaze/rld_job_110919/merged/*/{}.png'.format(i))
  print(x)
  img = skimage.io.imread(x[0])+skimage.io.imread(x[1])+skimage.io.imread(x[2])
  skimage.io.imsave(os.path.join(save_path,str(index+1)+".png"), img)



# np.stack((img,)*3, axis=-1).shape
# np.stack((skimage.io.imread(x[1]),)*3, axis=-1).shape

# x=['/aimldl-dat/data-gaze/rld_job_110919/merged/3-mask/1.png', '/aimldl-dat/data-gaze/rld_job_110919/merged/1-mask/1.png', '/aimldl-dat/data-gaze/rld_job_110919/merged/2-mask/1.png']