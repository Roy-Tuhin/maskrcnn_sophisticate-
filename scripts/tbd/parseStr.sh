#!/bin/bash

mystring="01.Driver Report|userid@company.com"
echo "$mystring"|while IFS="|" read f1 f2
do
name="$f1"
email="$f2"
done
echo "$name"
echo "$email"
