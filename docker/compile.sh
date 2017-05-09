#!/bin/bash

cp ../workdir/* ./
if [ -e ../workdir/template.tex ]; then
   ./md2pdf.sh -t template.tex document.md
else
    ./md2pdf.sh document.md
fi
cp document.md.pdf ../workdir/document.pdf
