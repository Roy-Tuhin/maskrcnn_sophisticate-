#!/bin/bash

# Usage:
# source docker.buildimg.sh ./<docker-file-name>

DOCKERFILE=$1

DOCKERTAG=$(echo $DOCKERFILE | sed 's:/*$::' | rev | cut -d'/' -f1 | rev)

if [ ! -z "$DOCKERTAG" -a "$DOCKERTAG" == " " ]; then
  error "DOCKERTAG is empty or '/'"
  return
fi

CONTEXT="$(dirname "${BASH_SOURCE[0]}")"

ARCH=$(uname -m)
TIME=$(date +%Y%m%d_%H%M)

TAG="${DOCKERTAG}-${ARCH}-${TIME}"

# Fail on first error.
set -e
docker build -t ${TAG} -f ${DOCKERFILE} ${CONTEXT}
echo "Built new image ${TAG}"
