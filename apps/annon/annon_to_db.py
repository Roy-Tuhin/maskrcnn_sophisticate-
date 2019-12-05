__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
## Description:
# --------------------------------------------------------
# Annotation Parser Interface for Annotation work flow.
# It uses the annotations created by VGG VIA tool v2.03 (not tested), v2.05 (tested).

# --------------------------------------------------------
# Copyright (c) 2019 Vidteq India Pvt. Ltd.
# Licensed under [see LICENSE for details]
# Written by mangalbhaskar
# --------------------------------------------------------
## Example:
# --------------------------------------------------------

1. Create Annotation Database from the single file
python annon_to_db.py create --from $HOME/annotations/images-p1-230119_AT2_via205_010219.json --to $HOME/AIML_Database_Test

2. Create Annotation Database from the all the files under a given directory
python annon_to_db.py create --from $HOME/annotations --to $HOME/AIML_Database_Test

## TODO:
# --------------------------------------------------------
- The script needs to be sync with the annotation specification of the VGG VIA tool being used - maintenance
- create database with custom geometry attributes so that it's indepenednt of VIA attributes
  * required for compressed format storage like MA COCO or payscal format, provide speedy loading, less storage
- option to switch between bbox or shape_attributes for training the data


* add source field in database (annon, pxl)

## Future wok:
# --------------------------------------------------------
- Extend the script to support `scalable` annotation tool
"""
import os
import sys
import time
import datetime
import json

import glob
import pandas as pd

from pymongo import MongoClient

import logging
import logging.config

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')
if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

from _annoncfg_ import appcfg
import annonutils
import annon_parser
import common

from _log_ import logcfg
log = logging.getLogger(__name__)
logging.config.dictConfig(logcfg)


def get_annon_db_file(base_path, tblname):
  """Utility function to get all the files for merging when consolidating to create a single file aka DB file.
  """
  result = [y for x in os.walk(base_path) for y in glob.glob(os.path.join(x[0], '*-'+tblname))]

  return result


def get_data_tbl(path, tblname):
  """Wrapper function around @merge_json
  """
  files = get_annon_db_file(path, tblname)
  log.info("files: {}".format(files))
  K,V = common.merge_json(files)

  return K,V


def create_db_data(cfg, path):
  """Create the single data files aka tables by consolidating respective files present in all the individual release folders
  These single data files are referred as DB release.
  DB Release is timestamped which is configured in the cfg.
  Every run of the script generates the new DB Release.
  :return the DB data for persistent storage
  """
  log.info("\ncreate_db_data:-----------------------------")
  log.info("path: {}".format(path))

  data = {}
  tbls = cfg['TABLES']
  for tblname, tblindex in tbls.items():
    log.info("\nTable-------------".format(tblname))
    tblfilename = cfg['FILES'][tblname]
    file_ext = os.path.splitext(tblfilename)[-1]
    log.info("file_ext: {}".format(file_ext))

    if file_ext == '.json':
      K,V = get_data_tbl(path, tblfilename)
      # tbl = dict(zip(K,V))
      # log.info("mergedfiles length: {}".format(len(tbl.values())))
      log.info("Total Records: {} =>{}\n".format( tblname, len(K) ))
      tlb_data = dict(zip(K,V))

      index_data = {}
      for _k,_v in tlb_data.items():
        index_data[_k] = []
        for idx in tblindex:
          if idx and idx in _v:
            index_data[_k].append(_v[idx])
          else:
            index_data[_k].append(_k)

      data[tblname] = {
        'type':file_ext
        ,'index':index_data
        ,'data': tlb_data
      }
    elif file_ext == '.csv':
      ## if csvdata is empty, csvdata.keys() still works
      ## and hence a quirk or hack to by-pass additional conditional checks      
      files = get_annon_db_file(path, cfg['FILES'][tblname])
      log.info("{} files: {}".format(tblname, files))
      csvdata = common.merge_csv(files)
      data[tblname] = {
        'type':file_ext
        ,'index':list(csvdata.keys())
        ,'data':csvdata
      }

  return data


def save_db_data(cfg, base_path, db_data):
  """Saves the DB data
  Create and save the summary on stats at the same time
  Create and maintains the release log configured in cfg
  This release log is the reference for generating the data splits
  ## new data overwrites the existing data,
  ## hence if no new data, files are not re-opend, thus preventing zero-byte data files, i.e. the data losss
  """
  log.info("\nsave_db_data:-----------------------------")
  log.info("base_path: {}".format(base_path))

  total_lbl = 0
  timestamp = cfg['TIMESTAMP']
  db_data_dir = cfg['BASE_PATH']['DB_DATA_DIR']
  for tblname,T in db_data.items():
    tbl_type = T['type']
    tbl_data = T['data']
    tbl_index = T['index']

    tblfilename = cfg['FILES'][tblname]
    tbldtls = os.path.splitext(tblfilename)

    # file_name = tbldtls[0]+"_"+timestamp+tbldtls[1]
    file_name = tblfilename
    ## timestamp based folder
    tbl_filename = os.path.join(db_data_dir, file_name)
    log.info("\ntblname:------->: {}".format(tblname))
    log.info("tbl_filename: {}".format(tbl_filename))

    # log.info("tbl_data: {}".format(tbl_data))
    # log.info("tbl_index: {}".format(tbl_index))

    total_rcrd = 0
    if tblname == tbldtls[0]:
      total_rcrd = len(tbl_data)
      log.info("total_rcrd:: {}".format(total_rcrd))
    
    if tblname == 'LABELS':
      total_lbl = total_rcrd

    if tbl_type == '.json' and tbl_index != {}:
      ## disable indexing for now
      # with open(tbl_filename+'.index','w') as fw:
      #   fw.write(json.dumps(tbl_index))

      with open(tbl_filename,'w') as fw:
        fw.write(json.dumps(tbl_data))
      if tblname == 'LABELS':
        colors = common.random_colors(len(tbl_data))
        class_info = annonutils.get_class_info(tbl_data, colors=colors)
        # classinfo_filename = "CLASSINFO_"+timestamp+".json"
        classinfo_filename = "CLASSINFO.json"
        classinfo_filepath = os.path.join(db_data_dir, classinfo_filename)
        log.info("classinfo_filepath: {}".format(classinfo_filepath))
        with open(classinfo_filepath,'w') as fw:
          fw.write(json.dumps(class_info))

    ## because tbl_data can be empty dict is no data otherwise list, but tbl_index will alsways be a list
    if tbl_type == '.csv' and tbl_index != []:
      tbl_data.to_csv( tbl_filename, index=False )

      cols = cfg['SUMMARY'][tblname]
      df = pd.DataFrame.from_dict(tbl_data)[cols]

      if tblname in cfg['GROUPBY']:
        groupby = cfg['GROUPBY'][tblname]
        summary = df.groupby([groupby], axis=0, as_index=False).sum()
        sdf = summary.sort_values(cfg['SORT'][tblname], ascending=False)
        log.info("sdf: {}".format(sdf))
      else:
        sdf = df

      summary_filename = os.path.join(db_data_dir, 'SUMMARY-'+file_name)
      sdf.to_csv( summary_filename, index=False )

  ## RELEASE
  log_dir = cfg['BASE_PATH']['LOG_DIR']
  rel_filename = os.path.join(log_dir, cfg['LOG']['FILE'])
  rel_file_cols = ','.join([str(i) for i in list(cfg['LOG']['COLS'].keys())])
  rel_file_vals = ','.join([str(i) for i in list(cfg['LOG']['COLS'].values())])

  if os.path.exists(rel_filename):
    fmode = 'a'
  else:
    fmode = 'w'

  with open(rel_filename,'a') as fw:
    log.info("Release rel_file_cols: {}".format(rel_file_cols))
    log.info("Release rel_file_vals: {}".format(rel_file_vals))

    if fmode == 'w':
      fw.write(rel_file_cols+"\n")
    
    fw.write(rel_file_vals+"\n")


def create_stats_files(cfg, stats, total_stats, dst_dir):
  """save the data on the stats
  It sort the data before saving for convenience and easy interpretation in excel sheets
  """
  label = stats['label']
  for i,gid in enumerate(label):
    image_name = stats['image_name'][i]
    
    ImgFilename = os.path.join(dst_dir, 'image-'+gid+'.txt')
    with open(ImgFilename,'w') as fw:
      fw.write("\n".join(image_name))
    
    labelFilename = os.path.join(dst_dir, 'label-'+gid+'.json')
    with open(labelFilename,'w') as fw:
      fw.write(json.dumps(gid))

  ## stats
  df = pd.DataFrame.from_dict(stats)
  stats_filename = os.path.join(dst_dir, os.path.basename(dst_dir)+'-'+cfg['FILES']['STATSLABEL'])
  sdf = df.sort_values(cfg['SORT']['STATSLABEL'], ascending=False)
  sdf.to_csv(stats_filename, index=False)

  ## total_stats
  df = pd.DataFrame.from_dict(total_stats)
  total_stats_filename = os.path.join(dst_dir, os.path.basename(dst_dir)+'-'+cfg['FILES']['STATS'])
  sdf = df.sort_values(cfg['SORT']['STATS'], ascending=False)
  sdf.to_csv(total_stats_filename, index=False)


def save_parsed_data(cfg, annondata, dst_dir=None, ant_data_dir=None, annon_filepath=None, db=None):
  """persist single annon_file_data and statistics
  """

  labels = annondata['Labels']

  Label = annondata['Label']
  Image = annondata['Image']
  Annotation_Info = annondata['Annotation_Info']
  Annotation_Data = annondata['Annotation_Data']
  Error = annondata['Error']
  Stats = annondata['Stats']

  Total_Stats = annondata['Total_Stats']

  dataset = annondata['Dataset']

  ## Stats
  save_Stats(cfg, Stats, Total_Stats, dataset, annon_filepath, dst_dir, db)
  ## Image
  save_Image(cfg, Image, dst_dir, db)
  ## Annotation_Info
  save_Annotation_Info(cfg, Annotation_Info, dst_dir, db)
  ## Label
  save_Label(cfg, Label, dst_dir, db)
  ## Error
  save_Error(cfg, Error, dst_dir, db)
  ## Annotation_Data
  save_Annotation_Data(cfg, Annotation_Data, ant_data_dir, db)


def save_Stats(cfg, Stats, Total_Stats, dataset=None, annon_filepath=None, dst_dir=None, db=None):
  stats_data = json.loads(common.numpy_to_json(Stats))
  total_stats_data = json.loads(common.numpy_to_json(Total_Stats))

  stats_total_stats_data = common.merge_dict([stats_data, total_stats_data])

  tblname = annonutils.get_tblname('STATS')

  save_to_file = cfg['SAVE_TO_FILE']
  if save_to_file:
    ## Stats files
    create_stats_files(cfg, Stats, Total_Stats, dst_dir)
    ## Move processed annotation file to archive folder
    log.info("annon_filepath, tblname: {}, {}".format(annon_filepath, tblname))
    rel_dir = cfg['BASE_PATH']['RELEASE_DIR']
    with open(os.path.join(rel_dir, os.path.basename(annon_filepath)),'w') as fw:
      json.dump(dataset,fw)
  else:
    log.info("tblname: {}".format(tblname))
    annonutils.write2db(db, tblname, [stats_total_stats_data], idx_col='rel_filename')


def save_Image(cfg, Image, dst_dir=None, db=None):
  if len(Image) > 0:
    tblname = annonutils.get_tblname('IMAGES')

    save_to_file = cfg['SAVE_TO_FILE']
    if save_to_file:
      img_filename = os.path.join(dst_dir,os.path.basename(dst_dir)+'-'+cfg['FILES']['IMAGES'])
      log.info("img_filename, tblname: {}, {}".format(img_filename, tblname))
      with open(img_filename,'w') as fw:
        fw.write(json.dumps(Image))
    else:
      log.info("tblname: {}".format(tblname))
      annonutils.write2db(db, tblname, list(Image.values()), idx_col='img_id')


def save_Annotation_Info(cfg, Annotation_Info, dst_dir=None, db=None):
  if len(Annotation_Info) > 0:
    tblname = annonutils.get_tblname('ANNOTATIONS')
    json_str = common.numpy_to_json(Annotation_Info)
    # log.info("json_str: {}".format(json_str))

    save_to_file = cfg['SAVE_TO_FILE']
    if save_to_file:
      ant_filename = os.path.join(dst_dir,os.path.basename(dst_dir)+'-'+cfg['FILES']['ANNOTATIONS'])
      log.info("ant_filename, tblname: {}, {}".format(ant_filename, tblname))
      with open(ant_filename,'w') as fw:
        # fw.write(json.dumps(Annotation_Info))
        fw.write(json_str)
    else:
      log.info("tblname: {}".format(tblname))
      annonutils.write2db(db, tblname, list(json.loads(json_str).values()), idx_col='ant_id')


def save_Label(cfg, Label, dst_dir=None, db=None):
  if len(Label) > 0:
    ## TODO
    # tblname = 'LABELS'
    # annonutils.write2db(db, tblname, list(Label.values()))
    tblname = annonutils.get_tblname('CLASSINFO')
    colors = common.random_colors(len(Label))
    class_info = annonutils.get_class_info(Label, colors=colors)

    log.info("len(Label): {}".format(len(Label)))
    log.info("Label: {}".format(Label))
    save_to_file = cfg['SAVE_TO_FILE']
    if save_to_file:
      lbl_filename = os.path.join(dst_dir,os.path.basename(dst_dir)+'-'+cfg['FILES']['LABELS'])
      log.info("lbl_filename: {}".format(lbl_filename))
      # db[tblname].insert_many(list(Label.values()))
      with open(lbl_filename,'w') as fw:
        fw.write(json.dumps(Label))

      classinfo_filename = os.path.join(dst_dir,os.path.basename(dst_dir)+'-'+cfg['FILES']['CLASSINFO'])
      log.info("classinfo_filename, tblname: {}, {}".format(classinfo_filename, tblname))

      with open(classinfo_filename,'w') as fw:
        json.dump(class_info,fw)
    else:
      log.info("tblname: {}".format(tblname))
      annonutils.write2db(db, tblname, class_info, idx_col='lbl_id')


def save_Error(cfg, Error, dst_dir=None, db=None):
  if len(Error) > 0:
    # log.info("Error:\n{}".format(Error))
    tblname = annonutils.get_tblname('ERRORS')

    save_to_file = cfg['SAVE_TO_FILE']
    if save_to_file:
      err_filename = os.path.join(dst_dir,os.path.basename(dst_dir)+'-'+cfg['FILES']['ERRORS'])
      log.info("err_filename, tblname: {}, {}".format(err_filename, tblname))
      # db[tblname].insert_many(list(Error.values()))
      with open(err_filename,'w') as fw:
        fw.write(json.dumps(Error))
    else:
      log.info("tblname: {}".format(tblname))
      annonutils.write2db(db, tblname, list(Error.values()), idx_col='rel_filename')


def save_Annotation_Data(cfg, Annotation_Data, ant_data_dir=None, db=None):
  ## At least create empty directory even when NO Annotation_Data is present to avoid dir not exists checks
  if len(Annotation_Data) > 0:
    save_to_file = cfg['SAVE_TO_FILE']
    if save_to_file:
      log.info("ant_data_dir: {}".format(ant_data_dir))
      for k,v in Annotation_Data.items():
        # ant_data_filename = os.path.join(ant_data_dir,k+'.json')
        ant_data_filename = os.path.join(ant_data_dir,k)
        json_str = common.numpy_to_json(v)
        with open(ant_data_filename,'w') as fw:
          # fw.write(json.dumps(v))
          fw.write(json_str)


def verify_anndb(cfg, args):
  tic = time.time()
  log.info("\nverify_anndb:-----------------------------")

  toc = time.time()
  total_exec_time = '{:0.2f}s'.format(toc - tic)
  log.info("\n Done: total_exec_time: {}".format(total_exec_time))
  
  return


def release_files(cfg, args):
  """Entry point to parse VIA based annotations for creating and saving basic data structures - IMAGES, ANNOTATIONS, LABELS and related data
  Implements the DRC - Design Rule Checks and acts as a gatekeeper, also reports any possible errors
  Create data structures to be parsed in 2nd pass to create the AIDS - AI Datasets with the actual splits 

  Test Cases:
  ## /some/path/AIML_Annotation/ods_job_230119/annotations/images-p1-230119_AT1_via205_250119.json
  ## /some/path/AIML_Annotation/ods_job_230119/annotations/
  ## /some/path/AIML_Annotation/ods_job_230119/annotations/
  """

  ## Check required args
  for d in ['from_path', 'to_path']:
    if d not in args:
      log.info("'{}' is not present.\n".format(d))
      sys.exit(-1)
  if not os.path.exists(args.from_path):
    raise NotADirectoryError("{}".format(args.from_path))
  if not os.path.exists(args.to_path):
    raise NotADirectoryError("{}".format(args.to_path))

  from_path, to_path = args.from_path, args.to_path

  tic = time.time()
  log.info("\nrelease_db:-----------------------------")
  cfg['TIMESTAMP'] = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())

  base_from_path = common.getBasePath(from_path)
  log.info("base_from_path: {}".format(base_from_path))

  base_to_path = common.getBasePath(to_path)
  log.info("base_to_path: {}".format(base_to_path))

  cfg['LOG']['COLS']['timestamp'] = cfg['TIMESTAMP']

  ## Create Base Directories
  db_dir = os.path.join(base_to_path, cfg['BASEDIR_NAME']['DB'])
  log.info("db_dir: {}".format(db_dir))
  common.mkdir_p(db_dir)

  db_data_dir = os.path.join(db_dir, cfg['TIMESTAMP'])
  log.info("ANNDB db_data_dir: {}".format(db_data_dir))
  common.mkdir_p(db_data_dir)

  rel_dir = os.path.join(base_to_path, cfg['BASEDIR_NAME']['RELEASE'], cfg['TIMESTAMP'])
  log.info("rel_dir: {}".format(rel_dir))
  common.mkdir_p(rel_dir)

  log_dir = os.path.join(base_to_path, cfg['BASEDIR_NAME']['LOG'])
  log.info("log_dir: {}".format(log_dir))
  common.mkdir_p(log_dir)

  ant_data_dir = os.path.join(db_data_dir,cfg["BASEDIR_NAME"]["ANNON"])
  log.info("ant_data_dir: {}".format(ant_data_dir))
  common.mkdir_p(ant_data_dir)

  cfg['BASE_PATH']['DB_DIR'] = db_dir
  cfg['BASE_PATH']['DB_DATA_DIR'] = db_data_dir
  cfg['BASE_PATH']['RELEASE_DIR'] = rel_dir
  cfg['BASE_PATH']['LOG_DIR'] = log_dir
  cfg['BASE_PATH']['ANT_DATA_DIR'] = ant_data_dir

  log.info("-------")
  log.info("cfg: {}".format(cfg))

  if os.path.isdir(from_path):
    ## normalizes and takes care of path ending with slash or not as the user input
    files = glob.glob(os.path.join(base_from_path,cfg['ANNON_FILENAME_PREFIX']+'*.json'))
  else:
    files = [from_path]

  log.info("-------")
  log.info("\nfiles: {}".format(files))
  log.info("-------")
  log.info("\nTotal files to process =======>: {}".format(len(files)))

  total_annon_file_processed = 0

  log_tblname = annonutils.get_tblname('LOG')
  for annon_filepath in files:
    log.info("-------")
    tic2 = time.time()
    annon_filename = os.path.basename(annon_filepath)

    ## TODO: check if the file is parsed: skip the processing in normal mode of the already parsed file
    res = False
    
    ## TODO: in update mode
    ## delete the entries of annotations and images before inserting the values of the same file again 
    if not res:
      log.info(" annon_filename: {} \n annon_filepath: {}".format(annon_filename, annon_filepath))

      created_on = cfg['LOG']['COLS']['created_on'] = common.now()
      log.info("created_on: {}".format(created_on))

      cfg['LOG']['COLS']['rel_filename'] = annon_filename
      annondata = annon_parser.parse_annon_file(cfg, annon_filepath, base_from_path)
      total_annon_file_processed += 1

      # ## if the annon_filepath is absolute path, base_bast gets ignored and thus the dst_dir is the file's directory
      ## dst_dir= os.path.join(base_from_path,os.path.splitext(annon_filepath)[0])

      ## log.info("annon_filepath: {}".format(annon_filepath))
      ## dst_dir = os.path.join(db_dir,os.path.splitext(annon_filepath)[0])

      ## dst_dir = os.path.join(db_dir,os.path.splitext(annon_filepath)[0])

      dst_dir = os.path.join(rel_dir, os.path.splitext(annon_filename)[0])
      ## log.info("dst_dir: {}".format(dst_dir))
      common.mkdir_p(dst_dir)
      save_parsed_data(cfg, annondata, dst_dir=dst_dir, ant_data_dir=ant_data_dir, annon_filepath=annon_filepath)

      cfg['LOG']['COLS']['modified_on'] = None

      toc2 = time.time()
      total_exec_time = '{:0.2f}s'.format(toc2 - tic)
      cfg['LOG']['COLS']['total_exec_time'] = total_exec_time

      ##TODO:
      ## if exception occurs or terminate, save what has been processed so for in the log instead of one-shot update of log out of for loop
      ## this helps to recover from the abrupt termination and start from previous successfuly processed file 

      log.info("=======> Total Execution Time: {:0.2f}s, Processed files: {}, Remaning files: {}".format(toc2 - tic2, total_annon_file_processed, len(files) - total_annon_file_processed))

      ## Update the LOG table here itself
    else:
      log.info("Already Exist in Database: annon_filename: {} \n annon_filepath: {}".format(annon_filename, annon_filepath))
      log.info("Use update / delete command to process this file again")

  ## Every execution of the script is a release
  ## For every release, recreate the entire database either for directory or specific file release
  
  ## create and save db data i.e. consolidated data with index structure
  db_data = create_db_data(cfg, rel_dir)

  save_db_data(cfg, db_dir, db_data)

  log.info("total_annon_file_processed: {}".format(total_annon_file_processed))

  return db_data_dir


def release_db(cfg, args):
  """Entry point to parse VIA based annotations for creating and saving basic data structures - IMAGES, ANNOTATIONS, LABELS and related data
  Implements the DRC - Design Rule Checks and acts as a gatekeeper, also reports any possible errors
  Create data structures to be parsed in 2nd pass to create the AIDS - AI Datasets with the actual splits 

  Test Cases:
  ## /some/path/AIML_Annotation/ods_job_230119/annotations/images-p1-230119_AT1_via205_250119.json
  ## /some/path/AIML_Annotation/ods_job_230119/annotations/
  ## /some/path/AIML_Annotation/ods_job_230119/annotations/
  """

  ## Check required args
  for d in ['from_path']:
    if d not in args:
      log.info("'{}' is not present.\n".format(d))
      sys.exit(-1)
  if not os.path.exists(args.from_path):
    raise NotADirectoryError("{}".format(args.from_path))

  from_path = args.from_path

  tic = time.time()
  log.info("\nrelease_db:-----------------------------")

  base_from_path = common.getBasePath(from_path)
  log.info("base_from_path: {}".format(base_from_path))

  uuid_rel = common.createUUID('rel')

  timestamp = cfg['RELEASE']['COLS']['timestamp'] = cfg['LOG']['COLS']['timestamp'] = cfg['TIMESTAMP']
  cfg['RELEASE']['COLS']['rel_id'] = cfg['LOG']['COLS']['rel_id'] = uuid_rel

  cfg['SAVE_TO_FILE'] = False

  log.info("-------")
  log.info("cfg: {}".format(cfg))

  if os.path.isdir(from_path):
    ## normalizes and takes care of path ending with slash or not as the user input
    files = glob.glob(os.path.join(base_from_path, cfg['ANNON_FILENAME_PREFIX']+'*.json'))
  else:
    files = [from_path]

  total_files = len(files)

  log.info("-------")
  log.debug("\nfiles: {}".format(files))
  log.info("-------")
  log.info("\nTotal files to process =======>: {}".format(total_files))

  total_annon_file_processed = 0
  total_annon_file_existed = 0

  DBCFG = cfg['DBCFG']
  ANNONCFG = DBCFG['ANNONCFG']
  mclient = MongoClient('mongodb://'+ANNONCFG['host']+':'+str(ANNONCFG['port']))
  dbname = ANNONCFG['dbname']
  log.info("ANNONCFG['dbname']: {}".format(dbname))
  db = mclient[dbname]

  rel_tblname = annonutils.get_tblname('RELEASE')
  annonutils.create_unique_index(db, rel_tblname, 'rel_id')
  rel_collection = db.get_collection(rel_tblname)

  log_tblname = annonutils.get_tblname('LOG')
  annonutils.create_unique_index(db, log_tblname, 'created_on')
  log_collection = db.get_collection(log_tblname)

  for annon_filepath in files:
    log.info("-------")
    tic2 = time.time()
    annon_filename = os.path.basename(annon_filepath)

    ## check if the file is parsed: skip the processing in normal mode of the already parsed file
    res = log_collection.find_one({'rel_filename': annon_filename})
    
    ## TODO: in update mode
    ## delete the entries of annotations and images before inserting the values of the same file again 
    if not res:
      log.info(" annon_filename: {} \n annon_filepath: {}".format(annon_filename, annon_filepath))

      created_on  = common.now()
      cfg['RELEASE']['COLS']['created_on'] = cfg['LOG']['COLS']['created_on'] = created_on
      log.info("created_on: {}".format(created_on))

      cfg['LOG']['COLS']['rel_filename'] = annon_filename
      annondata = annon_parser.parse_annon_file(cfg, annon_filepath, base_from_path)
      total_annon_file_processed += 1

      save_parsed_data(cfg, annondata, db=db)

      cfg['LOG']['COLS']['modified_on'] = None

      toc2 = time.time()
      cfg['LOG']['COLS']['total_exec_time'] = '{:0.2f}s'.format(toc2 - tic)

      ## if exception occurs or terminate, save what has been processed so for in the log instead of one-shot update of log out of for loop
      ## this helps to recover from the abrupt termination and start from previous successfuly processed file 
      log_collection.update_one(
        {'created_on': created_on}
        ,{'$setOnInsert': cfg['LOG']['COLS']}
        ,upsert=True
      )

      log.info("=======> Total Execution Time: {:0.2f}s, Processed files: {}, Remaning files: {}".format(toc2 - tic2, total_annon_file_processed, total_files - total_annon_file_processed))

      ## Update the LOG table here itself
    else:
      log.info("Already Exist in Database: annon_filename: {} \n annon_filepath: {}".format(annon_filename, annon_filepath))
      log.info("Use update / delete command to process this file again")
      total_annon_file_existed += 1


  cfg['RELEASE']['COLS']['total_annon_file_processed'] = total_annon_file_processed
  # cfg['RELEASE']['COLS']['total_exec_time'] = '{:0.2f}s'.format(time.time() - tic)
  cfg['RELEASE']['COLS']['total_exec_time_in_sec'] = '{:0.2f}'.format(time.time() - tic)

  if total_annon_file_processed:
    rel_collection.update_one(
      {'rel_id': uuid_rel}
      ,{'$setOnInsert': cfg['RELEASE']['COLS']}
      ,upsert=True
    )

  log.info("total_files, total_annon_file_processed, total_annon_file_existed: {} = {} + {}".format(total_files, total_annon_file_processed, total_annon_file_existed))

  mclient.close()

  return timestamp


def tdd(cfg, args):
  import lanet_parser
  return "I am TDD"


def release_annon(cfg, args):
  """Create ANNON - Annotation Database
  Execute all the steps from creation to saving of annon ready for creating AI Datasets
  """
  tic = time.time()
  log.info("\nrelease_annon:-----------------------------")
  cfg['TIMESTAMP'] = ("{:%d%m%y_%H%M%S}").format(datetime.datetime.now())

  createdb = False
  ## Check required args
  if not args.to_path:
    createdb = True

  log.info("createdb: {}".format(createdb))
  if createdb:
    res = release_db(cfg, args)
  else:
    res = release_files(cfg, args)

  toc = time.time()
  total_exec_time = '{:0.2f}s'.format(toc - tic)
  log.info("\n Done: total_exec_time: {}".format(total_exec_time))

  return res


def main(cfg, args):
  if args.command == 'create':
    res = release_annon(cfg, args)
    log.info("-------")
    log.info("ANNON(Annotation Database) res: {}".format(res))
    log.info("-------")
  elif args.command == 'tdd':
    res = tdd(cfg, args)
  
  log.info("res: {}".format(res))


def parse_args(commands):
  """Command line parameter parser
  """
  import argparse
  from argparse import RawTextHelpFormatter

  parser = argparse.ArgumentParser(
    description='Annotation parser for VGG Via tool files'
    ,formatter_class=RawTextHelpFormatter)

  parser.add_argument("command",
    metavar="<command>",
    help="{}".format(', '.join(commands)))

  parser.add_argument('--from'
    ,dest='from_path'
    ,help='/path/to/annotation/<directory_OR_annotation_json_file>'
    ,required=True)

  parser.add_argument('--to'
    ,dest='to_path'
    ,help='/path/to/anndb_root_OR_aids_root'
    ,required=False)

  args = parser.parse_args()
  
  ## Validate arguments
  cmd = args.command

  cmd_supported = False

  for c in commands:
    if cmd == c:
      cmd_supported = True

  if not cmd_supported:
    log.info("'{}' is not recognized.\n"
          "Use any one: {}".format(cmd,', '.join(commands)))
    sys.exit(-1)

  return args


if __name__ == '__main__':
  commands = ['create', 'verify', 'tdd']
  args = parse_args(commands)

  main(appcfg, args)
