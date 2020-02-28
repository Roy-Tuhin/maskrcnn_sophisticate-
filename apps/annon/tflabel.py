## Adapted from here:
## Credit: https://github.com/tensorflow/models/issues/1601#issuecomment-533659942
## NOTE:
## 1. tensorflow object_detection module should be in the PYTHONPATH

import logging

from google.protobuf import text_format
from object_detection.protos.string_int_label_map_pb2 import StringIntLabelMap, StringIntLabelMapItem

log = logging.getLogger('__main__.'+__name__)


class TFLabel():
  @staticmethod
  def convert_classes(classes, start=1):
    msg = StringIntLabelMap()
    for id, name in enumerate(classes, start=start):
      msg.item.append(StringIntLabelMapItem(id=id, name=name))

    text = str(text_format.MessageToBytes(msg, as_utf8=True), 'utf-8')
    return text

  @classmethod
  def write(cls, class_ids, fname):
    """
    Example:
    class_ids = ['cat', 'dog', 'fox', 'squirrel']

    How do I have to do in Python for calling an static method from another static method of the same class?
    https://stackoverflow.com/a/4104303
    """
    txt = cls.convert_classes(class_ids)
    log.info(txt)
    with open(fname+'.pbtxt', 'w') as f:
      f.write(txt)

    with open(fname+'.txt', 'w') as f:
      for ids in class_ids:
        f.write(ids)


def main(class_ids, fname='labelmap'):
  TFLabel.write(class_ids, fname)
