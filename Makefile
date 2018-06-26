PANDOC=/usr/local/bin/pandoc
LDOC=/usr/local/bin/ldoc

TEMPLATE_HTML=$(realpath input/template.html)
TEMPLATE_LATEX=$(realpath input/template.latex)
INPUT=$(realpath input/input.md)
OUTPUT_HTML=$(realpath index.html)
OUTPUT_PDF=$(realpath aar.pdf)
OUTPUT_MD=$(realpath README.md)

all: html pdf markdown ldoc

pdf: $(OUTPUT_PDF)
$(OUTPUT_PDF): $(INPUT)
	$(PANDOC) -s --template=$(TEMPLATE_LATEX) $(INPUT) --toc -o $(OUTPUT_PDF)

html: $(OUTPUT_HTML)
$(OUTPUT_HTML): $(INPUT)
	$(PANDOC) -s --template=$(TEMPLATE_HTML) $(INPUT) --toc -o $(OUTPUT_HTML)

markdown: $(OUTPUT_MD)
$(OUTPUT_MD): $(INPUT)
	$(PANDOC) -t gfm --atx --reference-location=block -s -o $(OUTPUT_MD) $(INPUT)

ldoc:
	$(LDOC) --all .