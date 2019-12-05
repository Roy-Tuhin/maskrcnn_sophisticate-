import numpy as np

gt_match = [[1,2,-1],[0,-1],[2,0,-1,1]]
pred_match = [[-1,0,1],[0,-1],[1,3,0,-1]]

gt_match = np.array(gt_match)
pred_match = np.array(pred_match)

# len_items = [3,2,4]
# no_of_matche_per_item = [2,1,3]

# ## mergining indiviual items for gt and pred using hstack
# #                          [0,1,2,   3,4,   5,6,7, 8]
# gt_match_merged =          [1,2,-1,  0,-1,  2,0,-1,1]
# pred_match_merged =        [-1,0,1,  0,-1,  1,3,0,-1]


# len_merged = len(gt_match_merged)
# assert len_merged == len(pred_match_merged) == np.sum(len_items)

# ## indices_merged = np.arange(len_merged)
# indices_merged = [0,1,2,3,4,5,6,7,8]


# ## what should be the new indices in the gt_match_merged and pred_match_merged respectively

# ## indices where gt_match_merged has_matched_indices_of pred_match
# ## np.where(gt_match_merged>-1)[0]

# #                          [0,1,2,   3,4,   5,6,7, 8]
# gt_match_merged_match =    [0,1,     3,     5,6,   8]
# pred_match_merged_match =  [   1,2,  3,     5,6,7   ]

# #                          [0,1,2,   3,4,   5,6,7, 8]
# gt_match_new =             [1,2,-1,  3,-1,  7,5,-1,6]
# pred_match_new =           [-1,0,1,  3,-1,  6,8,5,-1]

# assert np.sum(no_of_matche_per_item) == len(np.where(gt_match_new>-1)) == len(np.where(pred_match_new>-1))

