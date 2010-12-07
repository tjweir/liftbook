RSYNCFLAGS = "-rv --delete"

all	: master.pdf

html	: master.lyx
	@echo [Building HTML]
#	latex2html -split 3 -local_icons -no_antialias_text -no_antialias -white master.tex
#	./highlightHtml.sh
	rm -rf master/
	mkdir master/
	cp -R templates/* master/
	python elyxer.py --splitpart 1 master.lyx master/index.html
	tar cvzf master.html.tgz master/

pdf	: master.pdf

master.pdf	: master.aux

master.tex	: *.lyx
	@echo [Exporting PDFLaTeX]
	@lyx -e pdflatex master.lyx

master.aux	: master.tex
	@echo [Building PDF]
	pdflatex master.tex
	makeindex master.idx
	@bash -c "while pdflatex master.tex && grep -q \"Rerun to get cross-references right\" master.log ; do echo \"  Rebuilding references\" ; done"
	@echo [Built PDF]

clean:
	rm -f *.tex images/*.eps *.toc *.aux *.dvi *.idx *.lof *.log *.out *.toc *.lol master.pdf
	rm -rf master/

install: pdf html
	rsync $(RSYNC_FLAGS) master.pdf master.html.tgz lion.harpoon.me:/home/scalatools/hudson/www/exploring/downloads/
	rsync $(RSYNC_FLAGS) master/ lion.harpoon.me:/home/scalatools/hudson/www/exploring/master/
