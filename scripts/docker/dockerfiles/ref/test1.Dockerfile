## References:
## https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/tools/dockerfiles/bashrc
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu-jupyter.Dockerfile
## https://blog.hasura.io/how-to-write-dockerfiles-for-python-web-apps-6d173842ae1d/
## https://stackoverflow.com/questions/34213837/dockerfile-output-of-run-instruction-into-a-variable
## https://stackoverflow.com/questions/20635472/using-the-run-instruction-in-a-dockerfile-with-source-does-not-work
## https://stackoverflow.com/questions/34911622/dockerfile-set-env-to-result-of-command
## https://unix.stackexchange.com/questions/117467/how-to-permanently-set-environmental-variables
## https://github.com/moby/moby/issues/29110

ARG BASE_IMAGE_NAME=${BASE_IMAGE_NAME}
FROM ${BASE_IMAGE_NAME}
LABEL maintainer "mangalbhaskar <mangalbhaskar@gmail.com>"

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
      grep \
      vim \
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

# ARG BASH_FILE=/home/${DUSER}/.bashrc
ARG BASH_FILE=/etc/bash.bashrc

RUN chmod a+rwx ${BASH_FILE} && \
      mkdir -p ${PY_VENV_PATH} && \
      venv_timestamp=$(date +%Y-%m-%d) && \
      venv_pyVer=$($(which ${PYTHON}) -c 'import sys; print("-".join(map(str, sys.version_info[:3])))') && \
      venv_name="py_${venv_pyVer}_${venv_timestamp}" && \
      venvline="source /usr/local/bin/virtualenvwrapper.sh" && \
      grep -qF "${venvline}" "${BASH_FILE}" || echo "${venvline}" >> "${BASH_FILE}" && \
      venvline="export WORKON_HOME=${PY_VENV_PATH}" && \
      grep -qF "${venvline}" "${BASH_FILE}" || echo "${venvline}" >> "${BASH_FILE}" && \
      venvline="export PY_VENV_NAME=${venv_name}" && \
      grep -qF "${venvline}" "${BASH_FILE}" || echo "${venvline}" >> "${BASH_FILE}"


RUN mkdir -p ${PY_VENV_PATH} && \
      export WORKON_HOME=${PY_VENV_PATH} && \
      source /usr/local/bin/virtualenvwrapper.sh && \
      mkvirtualenv -p $(which ${PYTHON}) py_$($(which ${PYTHON}) -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')_$(date +%Y-%m-%d)

