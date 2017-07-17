#! /bin/bash

PROJECT="game/aar"
MYPATH="work/$PROJECT"
TEMPLATE_HTML="$HOME/$MYPATH/doc/input/template.html"
TEMPLATE_LATEX="$HOME/$MYPATH/doc/input/template.latex"
INPUT="$HOME/$MYPATH/doc/input/input.md"
OUTPUT="$HOME/$MYPATH/doc/output"
OUTPUT_HTML="$OUTPUT/index.html"
OUTPUT_PDF="$OUTPUT/aar.pdf"
OUTPUT_MD="$HOME/$MYPATH/README.md"

pandoc -s --template=$TEMPLATE_HTML $INPUT --toc -o $OUTPUT_HTML
pandoc -s --template=$TEMPLATE_LATEX $INPUT --toc -o $OUTPUT_PDF
pandoc -t markdown_github --atx --normalize --reference-location=block -s -o $OUTPUT_MD $INPUT
