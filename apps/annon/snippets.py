db_chuck, db_annon, latest_release_info = get_annon_data(cfg)
log.info("latest_release_info:{}".format(latest_release_info))
# log.info("db_annon:{}".format(db_annon))
# log.info("db_chuck:{}".format(db_chuck))
AIDS_SPLITS_CRITERIA = cfg['AIDS_SPLITS_CRITERIA'][cfg['AIDS_SPLITS_CRITERIA']['USE']]

splits = AIDS_SPLITS_CRITERIA[0] ## directory names
log.info("AIDS_SPLITS_CRITERIA, splits: {}, {}".format(AIDS_SPLITS_CRITERIA, splits))

## provides the Image Data in the splits
KV_split = do_aids_split(db_chuck, AIDS_SPLITS_CRITERIA, cfg['AIDS_RANDOMIZER'])

log.info("len(KV_split): {}".format(len(KV_split)))
for split in tqdm(KV_split):
    log.info("len(split): {}".format(len(split)))

images_1 = images.reshape(len(images),1,1)
print("{}\n{}\n".format(images_1.shape, images_1.ndim))
log.info('lbl_ids: {}'.format(lbl_ids[1:]))


np.expand_dims(lbl_ids[1:], axis=1).shape
np.concatenate([images_1[:,:,-1], np.expand_dims(lbl_ids[1:], axis=1)], axis=0).shape


from sklearn.preprocessing import OneHotEncoder
onehotencoder = OneHotEncoder(categorical_features = [0])


tensor = np.zeros([len(images), len(lbl_ids[1:])])
print("{}".format(tensor.shape))
print(tensor[1:2,:].shape)
# tensor[1:2,:] = tensor[1:2,:]+1
# tensor[2,:] = tensor[2,:]+2

# print(tensor[1:2,:])
# tensor[2,:] = [1,2,3,4,5]
# print(tensor[2,:])
# print(tensor[:,0])

for t in range(len(tensor)):
#     print("t:{}".format(t))
    tensor[t,:] += t
#     for i,t2 in enumerate(tensor[t,:]):
#         print("{}, {}".format(i, t2))
# #         tensor[t,:i] += i

# print(tensor[:])

for t2 in range(tensor.shape[-1]):
#     print("t2:{}".format(t2))
#     tensor[:,t2] += t2
    tensor[:,t2] += 1

# print(tensor[:,0])
print(tensor[:])
  

# tensor = np.zeros([len(images), len(lbl_ids[1:])], str)
tensor = np.zeros([len(images), len(lbl_ids[1:])], int)
lbls = {j:0 for i, j in enumerate(lbl_ids[1:])}
# print("{}".format(tensor.shape))

for j, image in enumerate(images):
    print("j: {}".format(j))
#     print("{}".format(len(image['annotations'])))
    #np.expand_dim(tensor[j,:])
#     print("{},{},{}".format(j, tensor[j,:], tensor[j,:].shape))
#     print("{},{}".format(j,image['lbl_ids']))
    labels_all = lbls.copy()
    for l in image['lbl_ids']:
        labels_all[l] += 1
#     print(list(labels_all.keys()))
#     print(list(labels_all.values()))
    tensor[j,:] = list(labels_all.values())
    
#     tensor[j,:] = list(labels_all.keys())
#     tensor[j,:] = ['a','b','c','d','e']
#     tensor[j,:] = [0.,1.,2.,3.,4.]
#     tensor[j,:] = image['annotations']
#     tensor[j,:] = image['lbl_ids']
    

print("{}".format(tensor))

np.array(tensor != 0, dtype=int)