
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}")/.." && pwd )"

echo "Cloning inside... ${SCRIPTS_DIR}/external"


mkdir -p ${SCRIPTS_DIR}/external/tensorflow

cd ${SCRIPTS_DIR}/external/tensorflow
 
git clone https://github.com/tensorflow/tensorflow.git
git clone https://github.com/tensorflow/model-optimization.git
git clone https://github.com/tensorflow/examples.git
git clone https://github.com/tensorflow/models.git
git clone https://github.com/tensorflow/tfx.git
git clone https://github.com/tensorflow/docs.git


## Mobile Examples
* https://github.com/tensorflow/examples/tree/master/lite/examples/object_detection/android