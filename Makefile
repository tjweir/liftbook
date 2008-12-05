all	: master

master	: master.tex master.aux
	latex2html -split 3 -local_icons master.tex
	
master.tex	: master.lyx
	lyx -e latex master.lyx

master.aux	: master.tex
	pdflatex master.tex
clean:
	rm -f *.tex images/*.eps *.toc *.aux *.dvi *.idx *.lof *.log *.out *.toc
