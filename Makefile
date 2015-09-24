authorea_paper.pdf: authorea_paper.tex


ALL_TEX_FILES = $(filter-out authorea_paper.tex,$(wildcard *.tex))
authorea_paper.tex: $(ALL_TEX_FILES)
	python local_build.py $(LOCAL_BUILD_OPTIONS)

LATEX_OPTIONS =
LATEX_OPTIONS += -interaction=nonstopmode
LATEX_OPTIONS += -shell-escape

LATEXMK := latexmk
#LATEXMK += -e '$$pdflatex=q/pdflatex %O -interaction=nonstopmode -shell-escape %S/'
LATEXMK += -pdf -dvi- -ps-
LATEXMK += -latexoption="$(LATEX_OPTIONS)"
#$(error $(LATEXMK))

LOCAL_BUILD_OPTIONS = 
LOCAL_BUILD_OPTIONS += --no-bibtex
LOCAL_BUILD_OPTIONS += --build-dir .
LOCAL_BUILD_OPTIONS += --latex /bin/true


%.eps: %.svg
	inkscape --export-eps=$@ $<

%.eps: %.dia
	dia --export=$@ $<

%.pdf: %.tex
	@echo | pygmentize  || (echo pygmentize not found. Try to install python-pygments; exit 1)
	$(LATEXMK) $<

clean:
	latexmk -c
	-rm *.aux *.bcf *.blg *.fls *.out *.toc *.nav *.bbl *.log *.bak *.pdf *.sta *~	

.PHONY: clean

.DELETE_ON_ERROR:
