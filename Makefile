RSYNCFLAGS = -rv --delete

all	: master.pdf

html	: master.lyx
	@echo [Building HTML]
#	latex2html -split 3 -local_icons -no_antialias_text -no_antialias -white master.tex
#	./highlightHtml.sh
	rm -rf master/
	rm -rf onepage/
	mkdir master/
	mkdir onepage/
	cp -R templates/css master/
	cp -R templates/css onepage/
	cp -R templates/scripts master/
	cp -R templates/scripts onepage/
	python elyxer.py --splitpart 1 --defaultbrush "scala" --template templates/template.html master.lyx master/index.html
	python elyxer.py --defaultbrush "scala" --template templates/template.html master.lyx onepage/index.html
	tar cvzf master.html.tgz master/
	tar cvzf onepage.html.tgz onepage/

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
	rsync $(RSYNCFLAGS) master.pdf master.html.tgz onepage.html.tgz lion.harpoon.me:/home/scalatools/hudson/www/exploring/downloads/
	rsync $(RSYNCFLAGS) master/ lion.harpoon.me:/home/scalatools/hudson/www/exploring/master/
	rsync $(RSYNCFLAGS) onepage/ lion.harpoon.me:/home/scalatools/hudson/www/exploring/onepage/
