#!/bin/bash

gunicorn web_server:app -b "0.0.0.0:5050"
