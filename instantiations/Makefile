BUILD_DIR := build

.PHONY: build prepare render compile clean reset

build: prepare compile

prepare:
	mkdir -p $(BUILD_DIR)/$*

compile:
	for tex in *.tex; do \
	    latexmk -pdflatex -outdir=$(BUILD_DIR) $$tex; \
	done

clean:
	find build -mindepth 1 ! \( -iname "" \
		-or -iname "*.pdf" \
		-or -iname "*.png" \
		-or -iname "*.tex" \
		-or -iname ".gitkeep" \
	\) -delete

reset:
	find build -mindepth 1 ! \( -iname ".gitkeep" \) -delete
