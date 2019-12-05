import numpy as np

## utils.compute_matches
overlaps = np.array([[0.],[0.],[0.],[0.],[0.6966708],[0.],[0.]])


SyntaxError: invalid syntax
>>> tp = np.array([0,0,0,0,1,1,1])
>>> tpfp = np.array([1,2,3,4,5,6,7])
>>> tp/tpfp
array([0.        , 0.        , 0.        , 0.        , 0.2       ,
       0.16666667, 0.14285714])


# 2019-10-26 17:32:14,392:[INFO]:[__main__.falcon.arch.evaluate]:[evaluate.py:227 -         execute_eval() ]: len(pred_match),pred_match: 7,[-1. -1. -1. -1.  0. -1. -1.]

# [-1.,-1.,-1.,-1.,0.,-1.,-1.]


# https://github.com/matterport/Mask_RCNN/pull/1024


# https://github.com/waspinator/pycococreator

# https://github.com/matterport/Mask_RCNN/issues/1395

# https://towardsdatascience.com/implementation-of-mean-average-precision-map-with-non-maximum-suppression-f9311eb92522