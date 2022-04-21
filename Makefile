PANDOC=/usr/local/bin/pandoc

TEMPLATE_HTML=$(realpath input/template.html)
TEMPLATE_LATEX=$(realpath input/eisvogel.latex)
INPUT=$(realpath input/input.md)
OUTPUT_HTML=$(realpath output/index.html)
OUTPUT_PDF=$(realpath output/aar.pdf)
OUTPUT_MD=$(realpath output/README.md)

all: html pdf markdown

html:
	$(PANDOC) -s $(INPUT) --toc -o $(OUTPUT_HTML)

pdf:
	$(PANDOC) -s --template=$(TEMPLATE_LATEX) $(INPUT) --toc --top-level-division=chapter -o $(OUTPUT_PDF)

markdown:
	$(PANDOC) -t commonmark+pipe_tables -o $(OUTPUT_MD) $(INPUT)
