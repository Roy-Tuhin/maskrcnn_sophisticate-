ARG BASE_IMAGE_NAME="ubuntu:18.04"
FROM ${BASE_IMAGE_NAME}

LABEL maintainer "mangalbhaskar <mangalbhaskar@gmail.com>"

ARG pyVer=3
ARG PYTHON=python${pyVer}
ARG PIP=pip${pyVer}
RUN apt-get update && apt-get install -y --no-install-recommends \
      ${PYTHON} \
      ${PYTHON}-dev \
      ${PYTHON}-pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*
