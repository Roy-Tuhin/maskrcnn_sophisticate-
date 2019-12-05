import os
import yaml
from easydict import EasyDict as edict

import glob
import datetime
import logging

log = logging.getLogger(__name__)
log.setLevel(logging.DEBUG)
log.addHandler(logging.StreamHandler())


def mkdir_p(path):
  import errno

  """
  mkdir -p` linux command functionality

  References:
  * https://stackoverflow.com/questions/600268/mkdir-p-functionality-in-python
  """
  try:
    os.makedirs(path)
  except OSError as exc:  # Python >2.5
    if exc.errno == errno.EEXIST and os.path.isdir(path):
      pass
    else:
      raise


def yaml_load(fileName):
  fc = None
  with open(fileName,'r') as f:
    fc = yaml.safe_load(f)
  return fc


def yaml_safe_dump(fileName, o):
  with open(fileName, 'w') as f:
    yaml.safe_dump(o, f, default_flow_style=False)


def dict_keys_to_lowercase(d):
  d_mod = { k.lower():d[k] if not isinstance(d[k],dict) else dict_keys_to_lowercase(d[k]) for k in d.keys() }
  return d_mod


def modelinfo_cfg_fix():
  """
  converts the old conventions to new lowercase conventions.
  probably not needed in future, once TEPPr workflow migration is completed.
  add any new field if required
  """
  # basepath = os.path.dirname(__file__)
  basepath = '/aimldl-cfg'
  filepath_yml = os.path.join(basepath,'model','*.yml')
  log.info("filepath_yml: {}".format(filepath_yml))

  now = datetime.datetime.now()
  ## create log directory based on timestamp for evaluation reporting
  timestamp = "{:%d%m%y_%H%M%S}".format(now)

  files = glob.glob(filepath_yml)
  dirpath = os.path.join(basepath,'model-'+timestamp)
  mkdir_p(dirpath)

  for file in files:
    fc = yaml_load(file)
    rel_num = file.split('-')[-2]
    fc['rel_num'] = int(rel_num)
    fc['weights'] = None
    fc['mode'] = 'inference'

    if 'config' in fc:
      fc['config']['NAME'] = fc['name']
      fc['classes'] = ['BG'] + fc['classes']
      fc['config']['NUM_CLASSES'] = len(fc['classes'])
      fc['num_classes'] = len(fc['classes'])

    fc['load_weights'] = {
      'by_name': True
       ,'exclude':['mrcnn_class_logits','mrcnn_bbox_fc','mrcnn_bbox','mrcnn_mask'] 
    }
    
    filepath_mod = os.path.join(dirpath, file.split(os.path.sep)[-1])
    log.debug("filepath_mod: {}".format(filepath_mod))
    yaml_safe_dump(filepath_mod, fc)


def arch_cfg_fix():
  """
  converts the old conventions to new lowercase conventions.
  probably not needed in future, once TEPPr workflow migration is completed.
  """
  # basepath = os.path.dirname(__file__)
  basepath = '/aimldl-cfg'
  filepath_yml = os.path.join(basepath,'arch','*.yml')
  files = glob.glob(filepath_yml)
  # log.info(files)

  timestamp = "{:%d%m%y_%H%M%S}".format(now)
  dirpath = os.path.join(basepath,'arch-'+timestamp)
  mkdir_p(dirpath)

  for file in files:
    fc = yaml_load(file)
    
    ## TEP should have DNNARCH attribute
    # fc['TRAIN']['DNNARCH'] = fc['DNNARCH']
    # fc['EVALUATE']['DNNARCH'] = fc['DNNARCH']
    # fc['PREDICT']['DNNARCH'] = fc['DNNARCH']
    # yaml_safe_dump(file, fc)

    ## converting to lowercase
    
    fc_mod = dict_keys_to_lowercase(fc)
    
    for tep in ['train','evaluate','predict']:
      ## Config keys should be in uppercase
      fc_mod[tep]['config'] = fc[tep.upper()]['CONFIG'].copy() if 'CONFIG' in fc[tep.upper()] and fc[tep.upper()]['CONFIG'] else None

      if 'schedules' in fc_mod[tep] and fc_mod[tep]['schedules']:
        for i,item in enumerate(fc_mod[tep]['schedules']):
          item_mod = dict_keys_to_lowercase(item)
          fc_mod[tep]['schedules'][i] = item_mod

    filepath = os.path.join(dirpath, file.split(os.path.sep)[-1])
    log.debug(filepath)
    yaml_safe_dump(filepath, fc_mod)


def main():
  # arch_cfg_fix()
  modelinfo_cfg_fix()


if __name__=='__main__':
  """
  copy this file parrallel to the directory under which config files are present and execute.
  It will create parallel directory for modified files
  """
  main()