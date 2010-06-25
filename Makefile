all	: master.pdf

html	: master.tex master.aux
	@echo [Building HTML]
	latex2html -split 3 -local_icons master.tex
	
pdf	: master.aux
master.pdf	: master.aux

master.tex	: *.lyx
	@echo [Exporting PDFLaTeX]
	@lyx -e pdflatex master.lyx

master.aux	: master.tex
	@echo [Building PDF]
	@bash -c "while pdflatex master.tex && grep -q \"Rerun to get cross-references right\" master.log ; do echo \"  Rebuilding references\" ; done"
	@echo [Built PDF]

clean:
	rm -f *.tex images/*.eps *.toc *.aux *.dvi *.idx *.lof *.log *.out *.toc *.lol
