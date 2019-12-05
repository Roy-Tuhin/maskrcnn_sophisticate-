#!/bin/bash

ip=10.4.71.69
gunicorn index:app -b "$ip:4040"
