#!/bin/bash

files=`ls $1/*.m`
for f in $files
do
    echo python update_header.py license.txt $f
done