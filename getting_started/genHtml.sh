#!/bin/bash

mkdir getting_started
cp *.tex getting_started/
cd getting_started/
mk4ht htlatex mod_master.tex "html" "" ""
awk 'BEGIN{ printout = 0 } /DOCTYPE/{ printout = 1 } { if (printout) print $0 }' mod_master.html > tmp
mv tmp mod_master.html

for fl in *.html; do
	sed -e 's/~/"/g' $fl > tmp
	mv tmp $fl
done

# clean up temp files
rm -f *.aux *.tex *.4ct *.4tc *.dvi *.idv *.lg *.log *.tmp *.xref
