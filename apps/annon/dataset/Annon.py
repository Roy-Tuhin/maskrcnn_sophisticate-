__author__ = 'mangalbhaskar'
__version__ = '2.0'
"""
Inspired from pycocotools
------------------------------------------------------------
Copyright (c) 2019 Vidteq India Pvt. Ltd.
Licensed under [see LICENSE for details]
Written by mangalbhaskar
------------------------------------------------------------
"""

import os
import sys
import time

from collections import defaultdict
import itertools

import logging

this_dir = os.path.dirname(__file__)
if this_dir not in sys.path:
  sys.path.append(this_dir)

APP_ROOT_DIR = os.getenv('AI_APP')

if APP_ROOT_DIR not in sys.path:
  sys.path.append(APP_ROOT_DIR)

log = logging.getLogger('__main__.'+__name__)

import annonutils
import common


class ANNON(object):
  def __init__(self, dbcfg=None, datacfg=None, subset=None, images_data=None, annotations_data=None, classinfo=None):
    """Constructor of ANNON helper class for reading and visualizing annotations.
    """
    log.info("-------------------------------->")
    self.dataset, self.anns, self.imgs = dict(), dict(), dict()
    
    self.imgToAnns, self.catToImgs, self.cat_lblid_to_id, self.catToAnns = None, None, None, None
    self.dbcfg = dbcfg.copy() if dbcfg else None
    self.datacfg = datacfg.copy() if datacfg else None
    self.subset = subset
    # self.cat_lblid_to_id = defaultdict(list)

    tic = time.time()

    self.load_data(images_data, annotations_data, classinfo)

    self.createIndex()
    log.info('Done (t={:0.2f}s)'.format(time.time()- tic))


  def load_data(self, images_data=None, annotations_data=None, classinfo=None):
    log.info("-------------------------------->")
    if images_data and annotations_data and classinfo:
      self.dataset['release'] = None
      if type(images_data)==str and type(annotations_data)==str and type(classinfo)==str:
        self.load_data_from_file(images_data, annotations_data, classinfo)
      else:
        self.dataset['images'] = images_data
        self.dataset['annotations'] = annotations_data
        self.dataset['categories'] = classinfo
    else:
      self.load_data_from_db()


  def load_data_from_db(self):
    """Load the annotation data from the database

    TODO
    - plit is replaced with subset
    """
    log.info("-------------------------------->")
    import pymongo
    from pymongo import MongoClient
    import arrow

    dbcfg = self.dbcfg
    log.debug("dbcfg: {}".format(dbcfg))
    mclient = MongoClient('mongodb://'+dbcfg['host']+':'+str(dbcfg['port']))
    dbname = dbcfg['dbname']
    db = mclient[dbname]

    query_annotations = {}
    query_images = {}
    query_classinfo = {}

    if self.subset:
      query_annotations = {'subset': self.subset}
      query_images = {'subset': self.subset}

    tblname = annonutils.get_tblname('ANNOTATIONS')
    annotations = db.get_collection(tblname)
    annotations_data = list(annotations.find(query_annotations,{'_id':0}))
    self.dataset['annotations'] = annotations_data

    tblname = annonutils.get_tblname('IMAGES')
    images = db.get_collection(tblname)
    images_data = list(images.find(query_images,{'_id':0}))
    self.dataset['images'] = images_data

    tblname = annonutils.get_tblname('CLASSINFO')
    classinfo = db.get_collection(tblname)

    ## sorting is critical to avoid label mismatch issues
    ## https://stackoverflow.com/questions/8109122/how-to-sort-mongodb-with-pymongo
    classinfo = list(classinfo.find(query_classinfo,{'_id':0}).sort('lbl_id', pymongo.ASCENDING))

    # lbl_ids = []
    # for item in classinfo:
    #     lbl_ids.append(item['lbl_id'])

    # log.info('lbl_ids: {}'.format(lbl_ids))
    # lbl_ids.sort()
    # log.info('len(lbl_ids): {}'.format(len(lbl_ids)))
    # log.info('lbl_ids: {}'.format(lbl_ids))

    log.info("classinfo: {}".format(classinfo))
    self.dataset['categories'] = classinfo

    ## get RELEASE data
    self.dataset['release'] = None
    tblname = annonutils.get_tblname('RELEASE')
    collection = db.get_collection(tblname)
    if collection:
        release = list(collection.find({'rel_type':'annon'}, {'_id':False}))
        log.info("len(release): {}".format(len(release)))
        ## 'YYYY-MM-DD HH:mm:ss ZZ'
        release.sort(key = lambda x: arrow.get(x['created_on'], common._date_format_).date(), reverse=True)
        self.dataset['release'] = release

    mclient.close()


  def load_data_from_file(self, images_data=None, annotations_data=None, classinfo=None):
    """Load the annotation data from the files
    TODO:
    - load from csv file data. Default extension supported is .json;
    """
    log.info("-------------------------------->")
    import json

    def _load_data_from_filepath(d, t):
      fp = d if d else self.datacfg[t]
      log.info("{}_filepath: {}".format(t, fp))
      if not os.path.exists(fp):
        raise Exception("{} filepath: {} does not exists!".format(t, fp))
      with open(fp,'r') as fr:
        self.dataset[t] = json.load(fr)

    _load_data_from_filepath(images_data, 'images')
    _load_data_from_filepath(annotations_data, 'annotations')
    _load_data_from_filepath(classinfo, 'categories')


  def createIndex(self):
    """Create Index for annotation, categories and images
    """
    log.info("-------------------------------->")
    stats = {
      'total_labels': 0
      ,'total_annotations': 0
      ,'total_images': 0
      ,'total_unique_images': 0
      ,"total_label_per_img": defaultdict(list)
      ,"total_img_per_label": defaultdict()
      ,"label_per_img": defaultdict(list)
      ,"total_annotation_per_label": defaultdict()
      ,"total_bboxarea_per_label": defaultdict(list)
      ,"total_maskarea_per_label": defaultdict(list)
      ,"total_annotation_per_img": defaultdict()
      ,"total_maskarea_per_img": defaultdict()
      ,"total_bboxarea_per_img": defaultdict()
    }

    unique_images = set()
    anns, cats, imgs = {}, {}, {}
    imgToAnns, catToImgs, cat_lblid_to_id, catToAnns = defaultdict(list), defaultdict(list), defaultdict(list), defaultdict(list)

    if 'annotations' in self.dataset:
      for ann in self.dataset['annotations']:
        imgToAnns[ann['img_id']].append(ann)
        anns[ann['ant_id']] = ann
        stats['total_annotations'] += 1
        stats['label_per_img'][str(ann['img_id'])].append(ann['lbl_id'])

        # catToImgs[ann['lbl_id']].append(ann['img_id'])
        if 'categories' in self.dataset:
          catToImgs[ann['lbl_id']].append(ann['img_id'])
          catToAnns[ann['lbl_id']].append(ann['ant_id'])
          if 'bboxarea' in ann and ann['bboxarea'] > -1:
            stats['total_bboxarea_per_label'][ann['lbl_id']].append(ann['bboxarea'])
          if 'maskarea' in ann and ann['maskarea'] > -1:
            stats['total_maskarea_per_label'][ann['lbl_id']].append(ann['maskarea'])

    if 'images' in self.dataset:
        for img in self.dataset['images']:
          imgs[img['img_id']] = img
          stats['total_images'] += 1
          _ann = imgToAnns[img['img_id']]
          stats['total_annotation_per_img'][str(img['img_id'])] = len(_ann)
          stats['total_label_per_img'][str(img['img_id'])] = len(set(stats['label_per_img'][str(img['img_id'])]))

          if 'bboxarea' in _ann and ann['bboxarea'] > -1:
            stats['total_bboxarea_per_img'][str(img['img_id'])] = ann['bboxarea']
          if 'maskarea' in _ann and ann['maskarea'] > -1:
            stats['total_bboxarea_per_img'][str(img['img_id'])] = ann['maskarea']

    # if 'annotations' in self.dataset and 'categories' in self.dataset:
    #   for ann in self.dataset['annotations']:
    #     # catid = cat_lblid_to_id[ann['lbl_id']]
    #     # catToImgs[catid].append(ann['img_id'])
    #     catToImgs[ann['lbl_id']].append(ann['img_id'])
    #     catToAnns[ann['lbl_id']].append(ann['ant_id'])

    ## categories and labels are synonymous and are used to mean the same thing
    if 'categories' in self.dataset:
      for cat in self.dataset['categories']:
        cats[cat['lbl_id']] = cat
        # cats[cat['id']] = cat
        # self.cat_lblid_to_id[cat['lbl_id']] = cat['id']
        stats['total_labels'] += 1
        stats['total_annotation_per_label'][cat['lbl_id']] = len(catToAnns[cat['lbl_id']])
        stats['total_img_per_label'][cat['lbl_id']] = len(catToImgs[cat['lbl_id']])

    log.info('index created!')

    # create class members
    self.anns = anns
    self.imgToAnns = imgToAnns
    self.catToImgs = catToImgs
    self.catToAnns = catToAnns
    self.imgs = imgs
    self.cats = cats
    self.stats = stats


  def getStats(self):
    return self.stats.copy()


  def getAnnIds(self, imgIds=[], catIds=[], areaRng=[]):
    """Get ann ids that satisfy given filter conditions. default skips that filter
    :param imgIds  (int array)     : get anns for given imgs
           catIds  (int array)     : get anns for given cats
           areaRng (float array)   : get anns for given area range (e.g. [0 inf])
    :return: ids (int array)       : integer array of ann ids
    """
    # log.info("-------------------------------->")
    imgIds = imgIds if type(imgIds) == list else [imgIds]
    catIds = catIds if type(catIds) == list else [catIds]

    if len(imgIds) == len(catIds) == len(areaRng) == 0:
        anns = self.dataset['annotations']
    else:
        if not len(imgIds) == 0:
            lists = [self.imgToAnns[imgId] for imgId in imgIds if imgId in self.imgToAnns]
            anns = list(itertools.chain.from_iterable(lists))
        else:
            anns = self.dataset['annotations']

        # log.info("anns: {}".format(anns))
        anns = anns if len(catIds)  == 0 else [ann for ann in anns if ann['lbl_id'] in catIds]
        # anns = anns if len(areaRng) == 0 else [ann for ann in anns if ann['area'] > areaRng[0] and ann['area'] < areaRng[1]]

    ids = [ann['ant_id'] for ann in anns]
    return ids


  def getCatIds(self, catNms=[], supNms=[], catIds=[]):
    """Filtering parameters. default skips that filter.
    :param catNms (str array)  : get categories for given cat names
    :param supNms (str array)  : get categories for given supercategory names
    :param catIds (int array)  : get categories for given cat ids
    :return: ids (int array)   : integer array of cat ids
    """
    # log.info("-------------------------------->")
    catNms = catNms if type(catNms) == list else [catNms]
    supNms = supNms if type(supNms) == list else [supNms]
    catIds = catIds if type(catIds) == list else [catIds]

    if len(catNms) == len(supNms) == len(catIds) == 0:
      categories = self.dataset['categories']
    else:
      categories = self.dataset['categories']
      
      categories = categories if len(catNms) == 0 else [cat for cat in categories if cat['name'] in catNms]
      # categories = categories if len(supNms) == 0 else [cat for cat in categories if cat['supercategory'] in supNms]
      # categories = categories if len(catIds) == 0 else [cat for cat in categories if cat['id'] in catIds]
      categories = categories if len(catIds) == 0 else [cat for cat in categories if cat['lbl_id'] in catIds]

    # log.info("categories:{}".format(categories))
    # ids = [cat['id'] for cat in cats]
    
    ids = [cat['name'] for cat in categories]
  
    ids.sort()

    return ids


  def getCatIdsFromAnnIds(self, annIds=[]):
    """Filtering parameters. default skips that filter.
    :param annIds (str array)  : get categories for given annIds
    :return: ids (int array)   : integer array of cat ids
    """
    # log.info("-------------------------------->")
    import numpy as np

    annIds = annIds if type(annIds) == list else [annIds]
    ids = []
    catToAnns_ids = []

    if len(annIds) == 0:
      categories = self.dataset['categories']
      ids = [cat['name'] for cat in categories]
    else:
      catToAnns = self.catToAnns
      # print("catToAnns: {}".format(catToAnns))
      # for cat in catToAnns:
        # print("cat:{}".format(catToAnns[cat]))
        # print(np.where(np.in1d(catToAnns['cat'], annIds)))

      ids = [] if len(annIds) == 0 else [cat for cat in catToAnns if len(np.where(np.in1d(catToAnns[cat], annIds))[0]) > 0]

    return ids


  def getImgIds(self, imgIds=[], catIds=[]):
    """Get img ids that satisfy given filter conditions.
    :param imgIds (int array) : get imgs for given ids
    :param catIds (int array) : get imgs with all given cats
    :return: ids (int array)  : integer array of img ids
    """
    # log.info("-------------------------------->")
    imgIds = imgIds if type(imgIds) == list else [imgIds]
    catIds = catIds if type(catIds) == list else [catIds]

    # log.info("getImgIds::catIds: {}".format(catIds))

    _img_ids = []
    if len(imgIds) == len(catIds) == 0:
        ids = self.imgs.keys()
        _img_ids = set(ids)
    else:
      ids = set(imgIds)
      # log.info("ids: {}".format(ids))
      for i, catId in enumerate(catIds):
          _ids = self.catToImgs[catId]
          _img_ids += _ids
          # log.info("i, catId, _ids: {}, {}, {}".format(i, catId, len(_ids)))
          # log.info("len(_ids): {}".format(len(_ids)))

      if len(ids) > 0:
        _img_ids = set(_img_ids) & ids
      else:
        _img_ids = set(_img_ids)

    # log.info("len(_img_ids): {}".format(len(_img_ids)))
    return list(_img_ids)


  def getReleaseId(self):
    release = None
    if self.dataset['release']:
        release = self.dataset['release'][0]

    return release


  def loadImgs(self, ids=[]):
    """Load image object with the specified ids.
    :param ids (int array)       : integer ids specifying image
    :return: imgs (object array) : loaded image objects
    """
    # log.info("-------------------------------->")
    if type(ids) == list:
        return [self.imgs[x] for x in ids]
    else:
        return [self.imgs[ids]]


  def loadAnns(self, ids=[]):
    """Load anns with the specified ids.
    :param ids (int array)       : integer ids specifying anns
    :return: anns (object array) : loaded ann objects
    """
    # log.info("-------------------------------->")
    if type(ids) == list:
        return [self.anns[x] for x in ids]
    elif type(ids) == int:
        return [self.anns[ids]]


  def loadCats(self, ids=[]):
    """Load cats with the specified ids.
    :param ids (int array)       : integer ids specifying cats
    :return: cats (object array) : loaded cat objects
    """
    log.info("-------------------------------->")
    # log.info("ids: {}".format(ids))
    # log.info("cats: {}".format(self.cats))

    # return self.cats[ids]

    if type(ids) == list:
        return [self.cats[x] for x in ids]
    else:
        return [self.cats[ids]]
