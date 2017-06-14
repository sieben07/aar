#! /bin/bash

export LANG=en_CA.UTF-8
source "$HOME/.rvm/scripts/rvm"
PROJECT="game/opl/doc"
MYPATH="Work/$PROJECT"
PDFLATEX="/usr/texbin/pdflatex"
TEMPLATE_HTML="$HOME/$MYPATH/template.html.erb"
TEMPLATE_LATEX="$HOME/$MYPATH/template.tex"
INPUT="$HOME/$MYPATH/md/index.md"
INPUT_LATEX="$HOME/$MYPATH/md/index.md"
OUTPUT="$HOME/$MYPATH/output_md"
OUTPUT_HTML="$HOME/$MYPATH/output_md/index.html"
OUTPUT_LATEX="$HOME/$MYPATH/output_md/index.tex"
LOG="$HOME/.logs/$PROJECT.log"
KRAMDOWN="$HOME/.rvm/gems/ruby-2.2.0/bin/kramdown"
$KRAMDOWN --template $TEMPLATE_HTML $INPUT >> $LOG 2>> >(while read line; do echo "$(date): ${line}"; done) > $OUTPUT_HTML;
$KRAMDOWN --template $TEMPLATE_LATEX -i kramdown -o remove_html_tags,latex $INPUT_LATEX > $OUTPUT_LATEX && cd $OUTPUT && $PDFLATEX $OUTPUT_LATEX;
open -a Preview  $HOME/$MYPATH/output_md/index.pdf

