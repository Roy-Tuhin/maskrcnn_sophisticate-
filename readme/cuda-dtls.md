https://devtalk.nvidia.com/default/topic/1028313/cuda-programming-and-performance/jit-details/

8.0.44 is called CUDA 8.0 GA1 by NVIDIA. Even for folks who wish to use CUDA 8.0, NVIDIA would recommend that you move forward to CUDA 8 GA2, where the version number is 8.0.61/8.0.62

And after that, both CUDA 9.0 and CUDA 9.1 have been released. 

Current CUDA (9.1 at the moment): http://www.nvidia.com/getcuda

CUDA toolkit archive: https://developer.nvidia.com/cuda-toolkit-archive

Since you are on 8.0.44, it might be that by installing CUDA 8.0.61, you may observe different behavior, and be able to inspect the ptxas-compiled (SASS) code. A similar statement could be made for CUDA 9.0, and CUDA 9.1

Both CUDA 8.0.61 and CUDA 9.0 should be usable with your r384-branch driver, without having to change your GPU driver.

https://developer.nvidia.com/cuda-80-ga2-download-archive
https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
https://developer.nvidia.com/compute/cuda/8.0/Prod2/patches/2/cuda_8.0.61.2_linux-run