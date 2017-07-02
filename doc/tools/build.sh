#! /bin/bash

PROJECT="game/aar"
MYPATH="work/$PROJECT"
TEMPLATE_HTML="$HOME/$MYPATH/doc/template.html"
TEMPLATE_LATEX="$HOME/$MYPATH/doc/template.latex"
INPUT="$HOME/$MYPATH/README.md"
OUTPUT="$HOME/$MYPATH/doc/output"
OUTPUT_HTML="$OUTPUT/index.html"
OUTPUT_PDF="$OUTPUT/aar.pdf"

pandoc -s --template=$TEMPLATE_HTML $INPUT --toc -o $OUTPUT_HTML
pandoc -s --template=$TEMPLATE_LATEX $INPUT --toc -o $OUTPUT_PDF

open -a Preview  $OUTPUT/aar.pdf

