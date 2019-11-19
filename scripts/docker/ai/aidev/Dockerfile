FROM nvidia/cuda:10.0-cudnn-7.6.4.38-devel-ubuntu18.04
LABEL maintainer "mangalbhaskar <mangalbhaskar@gmail.com>"

## References:
## https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/tools/dockerfiles/bashrc
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu-jupyter.Dockerfile

## See http://bugs.python.org/issue19846
## format changes required for asammdf v3.4.0
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ARG pyVer
ARG PYTHON=python${pyVer}
ARG PIP=pip${pyVer}

ARG PY_VENV_PATH=${PY_VENV_PATH}

ARG duser
ENV DUSER $duser

ARG duser_id
ENV DUSER_ID $duser_id

ARG duser_grp
ENV DUSER_GRP $duser_grp

ARG duser_grp_id
ENV DUSER_GRP_ID $duser_grp_id

## Needed for string substitution
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      libcurl3-dev \
      libfreetype6-dev \
      libhdf5-serial-dev \
      libzmq3-dev \
      software-properties-common \
      pkg-config \
      rsync \
      unzip \
      zip \
      zlib1g-dev \
      wget \
      curl \
      git \
      openjdk-8-jdk \
      ${PYTHON} \
      ${PYTHON}-dev \
      ${PYTHON}-pip \
      swig \
      sudo \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Some TF tools expect a "python" binary
RUN ln -s $(which ${PYTHON}) /usr/local/bin/python \
    && ln -s $(which ${PIP}) /usr/bin/pip

RUN ${PIP} --no-cache-dir install --upgrade \
    pip \
    setuptools

RUN ${PIP} --no-cache-dir install \
      virtualenv \
      virtualenvwrapper


## add docker group and user as same as host group and user ids and names
RUN addgroup --gid ${DUSER_GRP_ID} ${DUSER_GRP} && \
    useradd -ms /bin/bash ${DUSER} --uid ${DUSER_ID} --gid ${DUSER_GRP_ID} && \
    adduser ${DUSER} sudo

#set main entry point as working directory
WORKDIR /
COPY ./installer ./installer

ARG BASH_FILE=/etc/bash.bashrc

## https://blog.hasura.io/how-to-write-dockerfiles-for-python-web-apps-6d173842ae1d/
# Install app dependencies
## https://stackoverflow.com/questions/34213837/dockerfile-output-of-run-instruction-into-a-variable
RUN   chmod a+rwx ${BASH_FILE} && \
      mkdir -p ${PY_VENV_PATH} && \
      venv_timestamp=$(date +%Y-%m-%d) && \
      venv_pyVer=$($(which ${PYTHON}) -c 'import sys; print("-".join(map(str, sys.version_info[:3])))') && \
      venv_name="py_${venv_pyVer}_${venv_timestamp}" && \
      mkvirtualenv -p $(which ${PYTHON}) ${venv_name} && \
      virtualenvpath=$(which virtualenv) && \
      venvline="source ${virtualenvpath}/virtualenvwrapper.sh" && \
      grep -qF "${venvline}" "${BASH_FILE}" || echo "${venvline}" >> "${BASH_FILE}" && \
      source ${BASH_FILE} && \
      workon ${venv_name} && \
      ${PIP} --no-cache-dir install \
        Pillow \
        h5py \
        keras_applications \
        keras_preprocessing \
        matplotlib \
        mock \
        numpy \
        scipy \
        sklearn \
        pandas \
        future \
        portpicker \
        && test "${USE_PYTHON_3_NOT_2}" -eq 1 && true || ${PIP} --no-cache-dir install \
        enum34 && \
      ${PIP} install -r installer/python.requirements.txt

# Install bazel
ARG BASEDIR="softwares"
ARG BASEPATH="/${BASEDIR}"

ARG BAZEL_VERSION=1.1.0
ARG BAZEL_URL="https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh"
RUN mkdir -p ${BASEPATH}/bazel \
    && wget -O /bazel/installer.sh ${BAZEL_URL} \
    && wget -O /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" \
    && chmod +x /bazel/installer.sh \
    && /bazel/installer.sh \
    && rm -f /bazel/installer.sh
