#!/bin/bash

##----------------------------------------------------------
## entwine
## Tested on Ubuntu 16.04 LTS, Ubuntu 18.04 LTS
##----------------------------------------------------------
#
## https://entwine.io/download.html
#
##----------------------------------------------------------


function entwine_install() {
  local LSCRIPTS=$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )
  source ${LSCRIPTS}/lscripts.config.sh

  if [ -z "${BASEPATH}" ]; then
    BASEPATH="${HOME}/softwares"
    echo "Unable to get BASEPATH, using default path#: ${BASEPATH}"
  fi

  if [ -z "${ENTWINE_VER}" ]; then
    ENTWINE_VER="2.1.0"
    echo "Unable to get ENTWINE_VER version, falling back to default version#: ${ENTWINE_VER}"
  fi

  DIR="entwine"
  PROG_DIR="${BASEPATH}/${DIR}"

  URL="https://github.com/connormanning/${DIR}.git"

  echo "Number of threads will be used: ${NUMTHREADS}"
  echo "BASEPATH: ${BASEPATH}"
  echo "URL: ${URL}"
  echo "PROG_DIR: ${PROG_DIR}"

  if [ ! -d ${PROG_DIR} ]; then
    git -C ${PROG_DIR} || git clone ${URL} ${PROG_DIR}
  else
    echo Gid clone for ${URL} exists at: ${PROG_DIR}
  fi

  cd ${PROG_DIR}
  git pull
  git checkout ${ENTWINE_VER}

  if [ -d ${PROG_DIR}/build ]; then
    rm -rf ${PROG_DIR}/build
  fi

  mkdir ${PROG_DIR}/build
  cd ${PROG_DIR}/build
  cmake ..
  # ccmake ..
  # make -j${NUMTHREADS}
  # sudo make install -j${NUMTHREADS}

  # cd ${LSCRIPTS}


  # ##----------------------------------------------------------
  # ## Build Logs
  # ##----------------------------------------------------------

  # # GeoWave
  # https://locationtech.github.io/geowave/userguide.html

  # https://gist.github.com/medined/1535657

  # # Greyhound
  # A point cloud streaming framework for dynamic web services and native applications.

  # https://github.com/hobu/greyhound


  # sudo apt install libzstd1-dev


  # - PDAL: should be compiled with las-perf enabled
  # - Etwine
  # https://entwine.io/

  # /home/thanos/softwares/entwine/entwine/third/arbiter/arbiter.cpp: In member function ‘std::__cxx11::string entwine::arbiter::drivers::Google::Auth::sign(std::__cxx11::string, std::__cxx11::string) const’:
  # /home/thanos/softwares/entwine/entwine/third/arbiter/arbiter.cpp:2666:16: error: aggregate ‘EVP_MD_CTX ctx’ has incomplete type and cannot be defined
  #      EVP_MD_CTX ctx;
  #                 ^
  # /home/thanos/softwares/entwine/entwine/third/arbiter/arbiter.cpp:2683:28: error: ‘EVP_MD_CTX_cleanup’ was not declared in this scope
  #      EVP_MD_CTX_cleanup(&ctx);
  #                             ^

  # **EDIT**
  # https://www.openssl.org/docs/man1.1.0/crypto/EVP_DigestInit.html
  # https://www.openssl.org/docs/man1.0.2/crypto/EVP_MD_CTX_init.html
  # https://www.openssl.org/docs/man1.1.0/crypto/EVP_DigestSignInit.html


  # https://github.com/connormanning/entwine/issues/108


  # vi /home/thanos/softwares/entwine/entwine/third/arbiter/arbiter.cpp
  # https://github.com/openssl/openssl/issues/3513
  # https://www.openssl.org/docs/man1.0.2/crypto/EVP_MD_CTX_init.html


  #     EVP_PKEY* key(loadKey(pkey, false));

  #     EVP_MD_CTX *ctx;
  #     ctx = EVP_MD_CTX_new();
  #     EVP_DigestSignInit(ctx, nullptr, EVP_sha256(), nullptr, key);

  #     if (EVP_DigestSignUpdate(ctx, data.data(), data.size()) == 1)
  #     {
  #         std::size_t size(0);
  #         if (EVP_DigestSignFinal(ctx, nullptr, &size) == 1)
  #         {
  #             std::vector<unsigned char> v(size, 0);
  #             if (EVP_DigestSignFinal(ctx, v.data(), &size) == 1)
  #             {
  #                 signature.assign(reinterpret_cast<const char*>(v.data()), size);
  #             }
  #         }
  #     }

  #     EVP_MD_CTX_free(ctx);
  #     if (signature.empty()) throw ArbiterError("Could not sign JWT");
  #     return signature;
  # #else
  #     throw ArbiterError("Cannot use google driver without OpenSSL");
  # #endif

  ## On Ubuntu 18.04 LTS
  # After above fix

  # [ 92%] Linking CXX executable entwine
  # ../libentwine.so.2.0.0: undefined reference to `pdal::LazPerfDecompressor::LazPerfDecompressor(std::function<void (char*, unsigned long)>, std::vector<pdal::DimType, std::allocator<pdal::DimType> > const&, unsigned long)'
  # ../libentwine.so.2.0.0: undefined reference to `pdal::LazPerfCompressor::LazPerfCompressor(std::function<void (char*, unsigned long)>, std::vector<pdal::DimType, std::allocator<pdal::DimType> > const&)'
  # collect2: error: ld returned 1 exit status
  # app/CMakeFiles/app.dir/build.make:201: recipe for target 'app/entwine' failed
  # make[2]: *** [app/entwine] Error 1
  # CMakeFiles/Makefile2:661: recipe for target 'app/CMakeFiles/app.dir/all' failed
  # make[1]: *** [app/CMakeFiles/app.dir/all] Error 2
  # make[1]: *** Waiting for unfinished jobs....
  # [ 94%] Building CXX object test/CMakeFiles/entwine-test.dir/unit/main.cpp.o
  # [ 96%] Building CXX object test/CMakeFiles/entwine-test.dir/unit/read.cpp.o
  # [ 98%] Building CXX object test/CMakeFiles/entwine-test.dir/unit/version.cpp.o
  # [100%] Linking CXX executable entwine-test
  # ../libentwine.so.2.0.0: undefined reference to `pdal::LazPerfDecompressor::LazPerfDecompressor(std::function<void (char*, unsigned long)>, std::vector<pdal::DimType, std::allocator<pdal::DimType> > const&, unsigned long)'
  # ../libentwine.so.2.0.0: undefined reference to `pdal::LazPerfCompressor::LazPerfCompressor(std::function<void (char*, unsigned long)>, std::vector<pdal::DimType, std::allocator<pdal::DimType> > const&)'
  # collect2: error: ld returned 1 exit status
  # test/CMakeFiles/entwine-test.dir/build.make:204: recipe for target 'test/entwine-test' failed
  # make[2]: *** [test/entwine-test] Error 1
  # CMakeFiles/Makefile2:845: recipe for target 'test/CMakeFiles/entwine-test.dir/all' failed
  # make[1]: *** [test/CMakeFiles/entwine-test.dir/all] Error 2
  # Makefile:151: recipe for target 'all' failed
  # make: *** [all] Error 2


  # thanos@avengers:~/softwares$ npm install -g greyhound-server
  # npm WARN deprecated jade@1.11.0: Jade has been renamed to pug, please install the latest version of pug instead of jade
  # npm WARN deprecated node-uuid@1.4.8: Use uuid module instead
  # npm WARN deprecated constantinople@3.0.2: Please update to at least constantinople 3.1.1
  # npm WARN deprecated transformers@2.1.0: Deprecated, use jstransformer
  # npm WARN deprecated graceful-fs@3.0.11: please upgrade to graceful-fs 4 for compatibility with current and future versions of Node.js
  # npm WARN deprecated natives@1.1.3: This module relies on Node.js's internals and will break at some point. Do not use it, and update to graceful-fs@4.x.
  # /home/thanos/.npm-packages/bin/greyhound -> /home/thanos/.npm-packages/lib/node_modules/greyhound-server/src/forever.js
  # /home/thanos/.npm-packages/bin/greyhound-solo -> /home/thanos/.npm-packages/lib/node_modules/greyhound-server/src/app.js

  # > greyhound-server@1.0.1 install /home/thanos/.npm-packages/lib/node_modules/greyhound-server
  # > node-gyp rebuild

  # make: Entering directory '/home/thanos/.npm-packages/lib/node_modules/greyhound-server/build'
  #   CXX(target) Release/obj.target/session/src/session/bindings.o
  # In file included from ../src/session/commands/read.hpp:8:0,
  #                  from ../src/session/bindings.cpp:30:
  # ../src/session/read-queries/base.hpp:7:32: fatal error: pdal/Compression.hpp: No such file or directory
}

entwine_install
