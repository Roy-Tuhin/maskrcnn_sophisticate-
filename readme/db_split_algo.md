1. Get Images and categories from the images and classinfo tables from the database
2. create 2D zero array for shape (len(images), len(labels)). labels without the BG class.
3. Create the 2D image boolen (int) array and then drive the statistics from it and verify against the database tables using assert statements
  * Total Images per Label
  * Total Label per Image
  * Total Labels
  * Total Annotations per Label
  * Total Annotations
  * Total Images
  * Total Annotations per Image
4. sort the 1D array of total_images_per_label and get the index of them.
5. pick the column (index) from the 2D array which has least total_images_per_label and remove the index number from the total_images_per_label array
6. for the picked index column which provide the label which has least total_images_per_label, get the index in the 2D image array which has non-zero value i.e. pick those rows for a given label which has the given label in the image and get the total images for that label
7. keep the indices of each split in a single list (set)
8. using the calculated total images for the given label, use it to drive the number of images in the train, test and val spit sets for the given percentage distribution
9. use the calculated total numbers per split for the given label, use the indices vaues in each split set to get the actual data from the images_per_label data
10. for the next label, calculate the statistics for the columns excluding the index of the previous label
10. repeat from 4,5,6,7 but if the indices of exitings in the existing single list, remove tht from the images_per_label data or do not process it for the given label
11. repeat steps 4 to 10, till all the labels are processed
12. outputs should be the splits set with per label data distributed in the given percentage with image in each set being mutually exclusive
