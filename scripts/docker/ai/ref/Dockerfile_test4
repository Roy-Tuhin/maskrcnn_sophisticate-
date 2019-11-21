## References:
## https://raw.githubusercontent.com/tensorflow/tensorflow/master/tensorflow/tools/dockerfiles/bashrc
## https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/devel-gpu-jupyter.Dockerfile
## https://blog.hasura.io/how-to-write-dockerfiles-for-python-web-apps-6d173842ae1d/
# Install app dependencies
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

## Needed for string substitution
SHELL ["/bin/bash", "-c"]

# ARG BASH_FILE=/home/${DUSER}/.bashrc
ARG BASH_FILE=/etc/bash.bashrc
ARG PY_VENV_NAME=${PY_VENV_NAME}

# # mkvirtualenv -p $(which ${PYTHON}) py_$($(which ${PYTHON}) -c 'import sys; print("-".join(map(str, sys.version_info[:3])))')_$(date +%Y-%m-%d)
# RUN mkdir -p ${PY_VENV_PATH} && \
#       export WORKON_HOME=${PY_VENV_PATH} && \
#       source /usr/local/bin/virtualenvwrapper.sh && \
#       mkvirtualenv -p $(which ${PYTHON}) ${PY_VENV_NAME} && \
#       ${PIP} --no-cache-dir install -r installer/python.requirements.txt

# # Install bazel
# ARG BASEDIR="softwares"
# ARG BASEPATH="/${BASEDIR}"

# ARG BAZEL_URL=${BAZEL_URL}
# RUN mkdir -p ${BASEPATH}/bazel \
#     && wget -O ${BASEPATH}/bazel/installer.sh ${BAZEL_URL} \
#     && wget -O ${BASEPATH}/bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" \
#     && chmod +x ${BASEPATH}/bazel/installer.sh \
#     && ${BASEPATH}/bazel/installer.sh \
#     && rm -f ${BASEPATH}/bazel/installer.sh

USER ${DUSER}