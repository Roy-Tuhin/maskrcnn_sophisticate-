## Nvidia Driver
* Nvidia Driver 410+ minimum is required
* Nvidia Driver 430 is preferred for CUDA 10.0
  ```
  check version of Driver installed

  1 GPU on ultron-Precision-3630-Tower:0

      [0] ultron-Precision-3630-Tower:0[gpu:0] (Quadro P2000)

        Has the following names:
          GPU-0
          GPU-83fcbf13-2a6e-f905-8b09-f473c06631a8

  Thu Aug  1 13:38:53 2019       
  +-----------------------------------------------------------------------------+
  | NVIDIA-SMI 430.26       Driver Version: 430.26       CUDA Version: 10.2     |
  |-------------------------------+----------------------+----------------------+
  | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
  |===============================+======================+======================|
  |   0  Quadro P2000        Off  | 00000000:01:00.0  On |                  N/A |
  | 52%   43C    P8     6W /  75W |    232MiB /  5050MiB |      0%      Default |
  +-------------------------------+----------------------+----------------------+
                                                                                 
  +-----------------------------------------------------------------------------+
  | Processes:                                                       GPU Memory |
  |  GPU       PID   Type   Process name                             Usage      |
  |=============================================================================|
  |    0      1092      G   /usr/lib/xorg/Xorg                           125MiB |
  |    0      1327      G   /usr/bin/gnome-shell                         105MiB |
  +-----------------------------------------------------------------------------+
  Driver Version                      : 430.26
  count, name, memory.total [MiB], driver_version, clocks.max.memory [MHz], compute_mode
  1, Quadro P2000, 5050 MiB, 430.26, 3504 MHz, Default
  nvidia_uvm            819200  0
  nvidia_drm             45056  3
  nvidia_modeset       1110016  6 nvidia_drm
  nvidia              18792448  261 nvidia_uvm,nvidia_modeset
  drm_kms_helper        180224  2 nvidia_drm,i915
  drm                   479232  8 drm_kms_helper,nvidia_drm,i915
  ipmi_msghandler       102400  2 ipmi_devintf,nvidia

  Command 'prime-select' not found, but can be installed with:

  sudo apt install nvidia-prime
  ```
* `sudo apt install nvidia-prime`
  ```
  check version of Driver installed

  1 GPU on ultron-Precision-3630-Tower:0

      [0] ultron-Precision-3630-Tower:0[gpu:0] (Quadro P2000)

        Has the following names:
          GPU-0
          GPU-83fcbf13-2a6e-f905-8b09-f473c06631a8

  Thu Aug  1 13:40:05 2019       
  +-----------------------------------------------------------------------------+
  | NVIDIA-SMI 430.26       Driver Version: 430.26       CUDA Version: 10.2     |
  |-------------------------------+----------------------+----------------------+
  | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
  | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
  |===============================+======================+======================|
  |   0  Quadro P2000        Off  | 00000000:01:00.0  On |                  N/A |
  | 52%   47C    P0    18W /  75W |    264MiB /  5050MiB |      2%      Default |
  +-------------------------------+----------------------+----------------------+
                                                                                 
  +-----------------------------------------------------------------------------+
  | Processes:                                                       GPU Memory |
  |  GPU       PID   Type   Process name                             Usage      |
  |=============================================================================|
  |    0      1092      G   /usr/lib/xorg/Xorg                           137MiB |
  |    0      1327      G   /usr/bin/gnome-shell                         125MiB |
  +-----------------------------------------------------------------------------+
  Driver Version                      : 430.26
  count, name, memory.total [MiB], driver_version, clocks.max.memory [MHz], compute_mode
  1, Quadro P2000, 5050 MiB, 430.26, 3504 MHz, Default
  nvidia_uvm            819200  0
  nvidia_drm             45056  3
  nvidia_modeset       1110016  6 nvidia_drm
  nvidia              18792448  261 nvidia_uvm,nvidia_modeset
  drm_kms_helper        180224  2 nvidia_drm,i915
  drm                   479232  8 drm_kms_helper,nvidia_drm,i915
  ipmi_msghandler       102400  2 ipmi_devintf,nvidia
  nvidia
  ```

## CUDA

```
 CUDA Device Query (Runtime API) version (CUDART static linking)

Detected 1 CUDA Capable device(s)

Device 0: "Quadro P2000"
  CUDA Driver Version / Runtime Version          10.2 / 10.0
  CUDA Capability Major/Minor version number:    6.1
  Total amount of global memory:                 5051 MBytes (5295898624 bytes)
  ( 8) Multiprocessors, (128) CUDA Cores/MP:     1024 CUDA Cores
  GPU Max Clock rate:                            1481 MHz (1.48 GHz)
  Memory Clock rate:                             3504 Mhz
  Memory Bus Width:                              160-bit
  L2 Cache Size:                                 1310720 bytes
  Maximum Texture Dimension Size (x,y,z)         1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
  Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
  Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
  Total amount of constant memory:               65536 bytes
  Total amount of shared memory per block:       49152 bytes
  Total number of registers available per block: 65536
  Warp size:                                     32
  Maximum number of threads per multiprocessor:  2048
  Maximum number of threads per block:           1024
  Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
  Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
  Maximum memory pitch:                          2147483647 bytes
  Texture alignment:                             512 bytes
  Concurrent copy and kernel execution:          Yes with 2 copy engine(s)
  Run time limit on kernels:                     Yes
  Integrated GPU sharing Host Memory:            No
  Support host page-locked memory mapping:       Yes
  Alignment requirement for Surfaces:            Yes
  Device has ECC support:                        Disabled
  Device supports Unified Addressing (UVA):      Yes
  Device supports Compute Preemption:            Yes
  Supports Cooperative Kernel Launch:            Yes
  Supports MultiDevice Co-op Kernel Launch:      Yes
  Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
  Compute Mode:
     < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >

deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 10.2, CUDA Runtime Version = 10.0, NumDevs = 1
Result = PASS

cat /proc/driver/nvidia/version

NVRM version: NVIDIA UNIX x86_64 Kernel Module  430.26  Tue Jun  4 17:40:52 CDT 2019
GCC version:  gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1) 
```

## cuDNN
```
CUDA VERSION: 10000
TARGET ARCH: x86_64
HOST_ARCH: x86_64
TARGET OS: linux
SMS: 30 35 50 53 60 61 62 70 72 75
/usr/local/cuda/bin/nvcc -ccbin g++ -I/usr/local/cuda/include -IFreeImage/include  -m64    -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_62,code=sm_62 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_72,code=sm_72 -gencode arch=compute_75,code=sm_75 -gencode arch=compute_75,code=compute_75 -o fp16_dev.o -c fp16_dev.cu
g++ -I/usr/local/cuda/include -IFreeImage/include   -o fp16_emu.o -c fp16_emu.cpp
g++ -I/usr/local/cuda/include -IFreeImage/include   -o mnistCUDNN.o -c mnistCUDNN.cpp
/usr/local/cuda/bin/nvcc -ccbin g++   -m64      -gencode arch=compute_30,code=sm_30 -gencode arch=compute_35,code=sm_35 -gencode arch=compute_50,code=sm_50 -gencode arch=compute_53,code=sm_53 -gencode arch=compute_60,code=sm_60 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_62,code=sm_62 -gencode arch=compute_70,code=sm_70 -gencode arch=compute_72,code=sm_72 -gencode arch=compute_75,code=sm_75 -gencode arch=compute_75,code=compute_75 -o mnistCUDNN fp16_dev.o fp16_emu.o mnistCUDNN.o -I/usr/local/cuda/include -IFreeImage/include  -LFreeImage/lib/linux/x86_64 -LFreeImage/lib/linux -lcudart -lcublas -lcudnn -lfreeimage -lstdc++ -lm
cudnnGetVersion() : 7600 , CUDNN_VERSION from cudnn.h : 7600 (7.6.0)
Host compiler version : GCC 7.4.0
There are 1 CUDA capable devices on your machine :
device 0 : sms  8  Capabilities 6.1, SmClock 1480.5 Mhz, MemSize (Mb) 5050, MemClock 3504.0 Mhz, Ecc=0, boardGroupID=0
Using device 0

Testing single precision
Loading image data/one_28x28.pgm
Performing forward propagation ...
Testing cudnnGetConvolutionForwardAlgorithm ...
Fastest algorithm is Algo 1
Testing cudnnFindConvolutionForwardAlgorithm ...
^^^^ CUDNN_STATUS_SUCCESS for Algo 0: 0.035840 time requiring 0 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 1: 0.039968 time requiring 3464 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 2: 0.046080 time requiring 57600 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 4: 0.119808 time requiring 207360 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 7: 0.172032 time requiring 2057744 memory
Resulting weights from Softmax:
0.0000000 0.9999399 0.0000000 0.0000000 0.0000561 0.0000000 0.0000012 0.0000017 0.0000010 0.0000000 
Loading image data/three_28x28.pgm
Performing forward propagation ...
Resulting weights from Softmax:
0.0000000 0.0000000 0.0000000 0.9999288 0.0000000 0.0000711 0.0000000 0.0000000 0.0000000 0.0000000 
Loading image data/five_28x28.pgm
Performing forward propagation ...
Resulting weights from Softmax:
0.0000000 0.0000008 0.0000000 0.0000002 0.0000000 0.9999820 0.0000154 0.0000000 0.0000012 0.0000006 

Result of classification: 1 3 5

Test passed!

Testing half precision (math in single precision)
Loading image data/one_28x28.pgm
Performing forward propagation ...
Testing cudnnGetConvolutionForwardAlgorithm ...
Fastest algorithm is Algo 1
Testing cudnnFindConvolutionForwardAlgorithm ...
^^^^ CUDNN_STATUS_SUCCESS for Algo 0: 0.025600 time requiring 0 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 1: 0.037888 time requiring 3464 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 2: 0.062464 time requiring 28800 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 4: 0.119808 time requiring 207360 memory
^^^^ CUDNN_STATUS_SUCCESS for Algo 7: 0.171008 time requiring 2057744 memory
Resulting weights from Softmax:
0.0000001 1.0000000 0.0000001 0.0000000 0.0000563 0.0000001 0.0000012 0.0000017 0.0000010 0.0000001 
Loading image data/three_28x28.pgm
Performing forward propagation ...
Resulting weights from Softmax:
0.0000000 0.0000000 0.0000000 1.0000000 0.0000000 0.0000714 0.0000000 0.0000000 0.0000000 0.0000000 
Loading image data/five_28x28.pgm
Performing forward propagation ...
Resulting weights from Softmax:
0.0000000 0.0000008 0.0000000 0.0000002 0.0000000 1.0000000 0.0000154 0.0000000 0.0000012 0.0000006 

Result of classification: 1 3 5

Test passed!
OR:
cp -r /usr/src/cudnn_samples_v7 /home/ultron/softwares
cd /home/ultron/softwares/cudnn_samples_v7/mnistCUDNN
make clean && make
./mnistCUDNN
```

## tensorRT
```
Selecting previously unselected package uff-converter-tf.
Preparing to unpack .../uff-converter-tf_5.1.5-1+cuda10.0_amd64.deb ...
Unpacking uff-converter-tf (5.1.5-1+cuda10.0) ...
Setting up graphsurgeon-tf (5.1.5-1+cuda10.0) ...
Setting up uff-converter-tf (5.1.5-1+cuda10.0) ...
ii  graphsurgeon-tf                                             5.1.5-1+cuda10.0                             amd64        GraphSurgeon for TensorRT package
ii  libnvinfer-dev                                              5.1.5-1+cuda10.0                             amd64        TensorRT development libraries and headers
ii  libnvinfer-samples                                          5.1.5-1+cuda10.0                             all          TensorRT samples and documentation
ii  libnvinfer5                                                 5.1.5-1+cuda10.0                             amd64        TensorRT runtime libraries
ii  tensorrt                                                    5.1.5.0-1+cuda10.0                           amd64        Meta package of TensorRT
ii  uff-converter-tf                                            5.1.5-1+cuda10.0                             amd64        UFF converter for TensorRT package
Reading package lists...
Building dependency tree...
Reading state information...
E: Unable to locate package libnvinfer
```

## Apache
```
 Edit this file and make following entries: 
 * (copy below line and replace the existing) 
 * (use 'vi' editor only) 

 sudo vi /etc/apache2/mods-available/userdir.conf 

<IfModule mod_userdir.c>
  UserDir public_html
  UserDir disabled root


  #Solution using mod_headers and mod_setenvif
  <IfModule mod_headers.c>
     SetEnvIf Origin (.*) AccessControlAllowOrigin=
     Header add Access-Control-Allow-Origin %{AccessControlAllowOrigin}e env=AccessControlAllowOrigin
     Header set Access-Control-Allow-Credentials true
  </IfModule> 

  <Directory /home/*/public_html>
    #AllowOverride FileInfo AuthConfig Limit Indexes
    #Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec
    AllowOverride All
    Options MultiViews Indexes SymLinksIfOwnerMatch
    <Limit GET POST OPTIONS>
      # Apache <= 2.2:
      #Order allow,deny
      #Allow from all
 
      # Apache >= 2.4:
      Require all granted
    </Limit>
    <LimitExcept GET POST OPTIONS>
      # Apache <= 2.2:
      #Order deny,allow
      #Deny from all
 
      # Apache >= 2.4:
      Require all denied
    </LimitExcept>
  </Directory>
</IfModule>


 Edit this file and make following entries: 
 * (copy below line and replace the existing) 
 * (use 'vi' editor only) 

 sudo vi /etc/apache2/mods-available/php7.2.conf 

<IfModule mod_userdir.c>
    <Directory /home/*/public_html>
        #php_admin_flag engine Off
        AllowOverride All
    </Directory>
    <Directory /home/*/public_html/*/cgi-bin>
        DirectoryIndex index.py
        Options +ExecCGI
        SetHandler cgi-script
        AddHandler cgi-script .py 
    </Directory>
    <Directory /home/*/public_html/*/wsgi-bin>
        DirectoryIndex index.wsgi    
        Options +ExecCGI
        SetHandler wsgi-script
        AddHandler wsgi-script .wsgi
    </Directory>
</IfModule>

 Created file: /home/ultron/public_html/info.php 

 Restart the server:
 sudo service apache2 restart 

 Access server at: 
 http://localhost/~ultron/ 
 Access info.php at: 
 http://localhost/~ultron/info.php 

/aimldl-cod/scripts/system
/aimldl-cod/scripts/system
LINUX_VERSION:18.04
18.04
Reading package lists...
Building dependency tree...
```

## NodeJs
```
(Reading database ... 262933 files and directories currently installed.)
Preparing to unpack .../nodejs_9.11.2-1nodesource1_amd64.deb ...
Unpacking nodejs (9.11.2-1nodesource1) ...
Setting up nodejs (9.11.2-1nodesource1) ...
Processing triggers for man-db (2.8.3-2ubuntu0.1) ...
npm ERR! path /home/ultron/.npm-packages/lib
npm ERR! code ENOENT
npm ERR! errno -2
npm ERR! syscall lstat
npm ERR! enoent ENOENT: no such file or directory, lstat '/home/ultron/.npm-packages/lib'
npm ERR! enoent This is related to npm not being able to find a file.
npm ERR! enoent 

npm ERR! A complete log of this run can be found in:
npm ERR!     /home/ultron/.npm/_logs/2019-08-01T08_55_45_191Z-debug.log
5.6.0
v9.11.2
mkdir: cann
```

## Python virtualenv setup
```
  Stored in directory: /home/ultron/.cache/pip/wheels/a2/82/de/fd5f70739a3c8d7475cc21f4e186150abbc5d77180af7d94a2
  Building wheel for Mayavi (setup.py) ... error
  ERROR: Command errored out with exit status 1:
   command: /home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/bin/python3 -u -c 'import sys, setuptools, tokenize; sys.argv[0] = '"'"'/tmp/pip-install-luyqjcx6/Mayavi/setup.py'"'"'; __file__='"'"'/tmp/pip-install-luyqjcx6/Mayavi/setup.py'"'"';f=getattr(tokenize, '"'"'open'"'"', open)(__file__);code=f.read().replace('"'"'\r\n'"'"', '"'"'\n'"'"');f.close();exec(compile(code, __file__, '"'"'exec'"'"'))' bdist_wheel -d /tmp/pip-wheel-c8l2ievj --python-tag cp36
       cwd: /tmp/pip-install-luyqjcx6/Mayavi/
  Complete output (33 lines):
  running bdist_wheel
  running build
  Traceback (most recent call last):
    File "<string>", line 1, in <module>
    File "/tmp/pip-install-luyqjcx6/Mayavi/setup.py", line 474, in <module>
      **config
    File "/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/numpy/distutils/core.py", line 171, in setup
      return old_setup(**new_attr)
    File "/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/setuptools/__init__.py", line 145, in setup
      return distutils.core.setup(**attrs)
    File "/usr/lib/python3.6/distutils/core.py", line 148, in setup
      dist.run_commands()
    File "/usr/lib/python3.6/distutils/dist.py", line 955, in run_commands
      self.run_command(cmd)
    File "/usr/lib/python3.6/distutils/dist.py", line 974, in run_command
      cmd_obj.run()
    File "/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/wheel/bdist_wheel.py", line 192, in run
      self.run_command('build')
    File "/usr/lib/python3.6/distutils/cmd.py", line 313, in run_command
      self.distribution.run_command(command)
    File "/usr/lib/python3.6/distutils/dist.py", line 974, in run_command
      cmd_obj.run()
    File "/tmp/pip-install-luyqjcx6/Mayavi/setup.py", line 268, in run
      build_tvtk_classes_zip()
    File "/tmp/pip-install-luyqjcx6/Mayavi/setup.py", line 254, in build_tvtk_classes_zip
      gen_tvtk_classes_zip()
    File "tvtk/setup.py", line 83, in gen_tvtk_classes_zip
      from tvtk.code_gen import TVTKGenerator
    File "/tmp/pip-install-luyqjcx6/Mayavi/tvtk/code_gen.py", line 10, in <module>
      import vtk_module as vtk
    File "tvtk/vtk_module.py", line 15, in <module>
      from vtk import *
  ModuleNotFoundError: No module named 'vtk'
  ----------------------------------------
  ERROR: Failed building wheel for Mayavi
  Running setup.py clean for Mayavi
```
* tensorflow gpu validation
```
(py_3-6-8_2019-08-01) ultron@ultron-Precision-3630-Tower:/aimldl-cod/scripts/system$ python tensorflow.validateinstallation.py 
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:516: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint8 = np.dtype([("qint8", np.int8, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:517: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_quint8 = np.dtype([("quint8", np.uint8, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:518: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint16 = np.dtype([("qint16", np.int16, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:519: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_quint16 = np.dtype([("quint16", np.uint16, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:520: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint32 = np.dtype([("qint32", np.int32, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorflow/python/framework/dtypes.py:525: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  np_resource = np.dtype([("resource", np.ubyte, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:541: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint8 = np.dtype([("qint8", np.int8, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:542: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_quint8 = np.dtype([("quint8", np.uint8, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:543: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint16 = np.dtype([("qint16", np.int16, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:544: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_quint16 = np.dtype([("quint16", np.uint16, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:545: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  _np_qint32 = np.dtype([("qint32", np.int32, 1)])
/home/ultron/virtualmachines/virtualenvs/py_3-6-8_2019-08-01/lib/python3.6/site-packages/tensorboard/compat/tensorflow_stub/dtypes.py:550: FutureWarning: Passing (type, 1) or '1type' as a synonym of type is deprecated; in a future version of numpy, it will be understood as (type, (1,)) / '(1,)type'.
  np_resource = np.dtype([("resource", np.ubyte, 1)])
1.14.0
WARNING: Logging before flag parsing goes to stderr.
W0801 14:29:43.518507 139962385610560 deprecation_wrapper.py:119] From tensorflow.validateinstallation.py:22: The name tf.Session is deprecated. Please use tf.compat.v1.Session instead.

2019-08-01 14:29:43.519328: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcuda.so.1
2019-08-01 14:29:43.530612: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.530870: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties: 
name: Quadro P2000 major: 6 minor: 1 memoryClockRate(GHz): 1.4805
pciBusID: 0000:01:00.0
2019-08-01 14:29:43.530995: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.0
2019-08-01 14:29:43.531907: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10.0
2019-08-01 14:29:43.538968: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcufft.so.10.0
2019-08-01 14:29:43.541066: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcurand.so.10.0
2019-08-01 14:29:43.555974: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusolver.so.10.0
2019-08-01 14:29:43.565548: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusparse.so.10.0
2019-08-01 14:29:43.567553: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
2019-08-01 14:29:43.567628: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.567890: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.568107: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0
2019-08-01 14:29:43.568316: I tensorflow/core/platform/cpu_feature_guard.cc:142] Your CPU supports instructions that this TensorFlow binary was not compiled to use: AVX2 FMA
2019-08-01 14:29:43.612006: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.612331: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x504d540 executing computations on platform CUDA. Devices:
2019-08-01 14:29:43.612346: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (0): Quadro P2000, Compute Capability 6.1
2019-08-01 14:29:43.631666: I tensorflow/core/platform/profile_utils/cpu_utils.cc:94] CPU Frequency: 3696000000 Hz
2019-08-01 14:29:43.633195: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x5825980 executing computations on platform Host. Devices:
2019-08-01 14:29:43.633244: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (0): <undefined>, <undefined>
2019-08-01 14:29:43.633580: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.634359: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties: 
name: Quadro P2000 major: 6 minor: 1 memoryClockRate(GHz): 1.4805
pciBusID: 0000:01:00.0
2019-08-01 14:29:43.634439: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.0
2019-08-01 14:29:43.634482: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10.0
2019-08-01 14:29:43.634519: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcufft.so.10.0
2019-08-01 14:29:43.634565: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcurand.so.10.0
2019-08-01 14:29:43.634611: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusolver.so.10.0
2019-08-01 14:29:43.634653: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusparse.so.10.0
2019-08-01 14:29:43.634700: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
2019-08-01 14:29:43.634847: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.635722: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.636445: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0
2019-08-01 14:29:43.636533: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.0
2019-08-01 14:29:43.638324: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1181] Device interconnect StreamExecutor with strength 1 edge matrix:
2019-08-01 14:29:43.638369: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1187]      0 
2019-08-01 14:29:43.638397: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1200] 0:   N 
2019-08-01 14:29:43.638646: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.638892: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.639126: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1326] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 4384 MB memory) -> physical GPU (device: 0, name: Quadro P2000, pci bus id: 0000:01:00.0, compute capability: 6.1)
b'Hello, TensorFlow!'
W0801 14:29:43.641768 139962385610560 deprecation_wrapper.py:119] From tensorflow.validateinstallation.py:27: The name tf.ConfigProto is deprecated. Please use tf.compat.v1.ConfigProto instead.

2019-08-01 14:29:43.642052: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.642268: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties: 
name: Quadro P2000 major: 6 minor: 1 memoryClockRate(GHz): 1.4805
pciBusID: 0000:01:00.0
2019-08-01 14:29:43.642285: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.0
2019-08-01 14:29:43.642296: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10.0
2019-08-01 14:29:43.642305: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcufft.so.10.0
2019-08-01 14:29:43.642314: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcurand.so.10.0
2019-08-01 14:29:43.642323: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusolver.so.10.0
2019-08-01 14:29:43.642332: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusparse.so.10.0
2019-08-01 14:29:43.642341: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
2019-08-01 14:29:43.642373: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.642600: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.642818: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0
2019-08-01 14:29:43.642831: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1181] Device interconnect StreamExecutor with strength 1 edge matrix:
2019-08-01 14:29:43.642836: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1187]      0 
2019-08-01 14:29:43.642839: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1200] 0:   N 
2019-08-01 14:29:43.642885: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.643124: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
2019-08-01 14:29:43.643362: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1326] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 4384 MB memory) -> physical GPU (device: 0, name: Quadro P2000, pci bus id: 0000:01:00.0, compute capability: 6.1)
Device mapping:
/job:localhost/replica:0/task:0/device:XLA_GPU:0 -> device: XLA_GPU device
/job:localhost/replica:0/task:0/device:XLA_CPU:0 -> device: XLA_CPU device
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: Quadro P2000, pci bus id: 0000:01:00.0, compute capability: 6.1
2019-08-01 14:29:43.643389: I tensorflow/core/common_runtime/direct_session.cc:296] Device mapping:
/job:localhost/replica:0/task:0/device:XLA_GPU:0 -> device: XLA_GPU device
/job:localhost/replica:0/task:0/device:XLA_CPU:0 -> device: XLA_CPU device
/job:localhost/replica:0/task:0/device:GPU:0 -> device: 0, name: Quadro P2000, pci bus id: 0000:01:00.0, compute capability: 6.1
```
