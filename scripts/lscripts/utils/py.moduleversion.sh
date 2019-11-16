#!/bin/bash

PYLIB=$1
python -c "import $PYLIB as module; print(module.__version__)"
