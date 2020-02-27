#!/bin/bash


## pdf to images
# pdfimages -j somefile.pdf outputdir/

## resize images
# for file in *.jpg; do convert $file -resize 25% r-$file; done

## Convert Images to PDF
# sudo apt install graphicsmagick


# gm convert *.jpg $(date -d now +'%d%m%y_%H%M%S').pdf

pdf_filename=$(date -d now +'%d%m%y_%H%M%S').pdf
gm convert *.jpg ${pdf_filename}

## view the pdf file
evince ${pdf_filename}
