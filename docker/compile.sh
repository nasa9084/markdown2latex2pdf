#!/bin/bash

cp ../workdir/document.md ./
./md2pdf.sh document.md
cp document.md.pdf ../workdir/document.pdf
