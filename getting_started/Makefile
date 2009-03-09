SOURCE = mod_master.lyx
LYX ?= lyx

all	: clean $(SOURCE) html pdf 

pdf	: $(SOURCE)
	$(LYX) -e pdf $(SOURCE)
	mv mod_master.pdf StartingWithLift.pdf

html	: mod_master.tex
	./genHtml.sh

mod_master.tex : $(SOURCE)
	$(LYX) -e latex $(SOURCE)

clean	:
	rm -f *.html *.pdf *.dvi *.css *.tmp *.aux *.tex *.4tc *.4ct *.lg *.log *.idv *.xref *.out
	rm -rf getting_started/