#!/usr/env bash

# generate-pdf-files-printable.sh
# Run this script to build all .pdf files from the .tex files in build/tex/printable directory
# I.e, multiple pages in a pdf with crop marks.
# The output files will be stored to the build/pdf/printable/ path in the execution folder which will be created.
# requires pdflatex with a bunch of built-in packages. E.g. sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra

export GITROOT=$(git rev-parse --show-toplevel)
#export TEXINPUTS=$GITROOT
export TEXHOME=$(kpsewhich -var-value=TEXMFHOME)
mkdir -p $TEXHOME/tex/latex/hordemode
cp $GITROOT/HordeModeTarot.cls $TEXHOME/tex/latex/hordemode

# create pdf directories
mkdir -p $GITROOT/build/pdf/printable
mkdir -p $GITROOT/build/pdf/printable/cards/misery
mkdir -p $GITROOT/build/pdf/printable/cards/secondary
mkdir -p $GITROOT/build/pdf/printable/cards/secret
mkdir -p $GITROOT/build/pdf/printable/rules
mkdir -p $GITROOT/build/pdf/printable/spawn-tables


# the page collections needs to be generated at this phase since they 
# use the already generated pdf's as input and are run in the same directories

# generate misery cards
for file in $GITROOT/build/tex/printable/cards/misery/*.tex
do
  pdflatex --output-directory $GITROOT/build/pdf/printable/cards/misery "$file"
done
ruby $GITROOT/app/bin/generate-multipage-printables.rb -t $GITROOT/app/templates/four-cards-printable.tex.erb -r $GITROOT/build/pdf/printable/cards/misery
pdflatex --output-directory $GITROOT/build/pdf/printable/cards/misery $GITROOT/build/pdf/printable/cards/misery/pdf-collection-printable.tex
rm $GITROOT/build/pdf/printable/cards/misery/pdf-collection-printable.tex #cleanup

# generate secondary cards
for file in $GITROOT/build/tex/printable/cards/secondary/*.tex
do
  pdflatex --output-directory $GITROOT/build/pdf/printable/cards/secondary "$file"
done
ruby $GITROOT/app/bin/generate-multipage-printables.rb -t $GITROOT/app/templates/four-cards-printable.tex.erb -r $GITROOT/build/pdf/printable/cards/secondary
pdflatex --output-directory $GITROOT/build/pdf/printable/cards/secondary $GITROOT/build/pdf/printable/cards/secondary/pdf-collection-printable.tex
rm $GITROOT/build/pdf/printable/cards/secondary/pdf-collection-printable.tex #cleanup

# generate secret cards
for file in $GITROOT/build/tex/printable/cards/secret/*.tex
do
  pdflatex --output-directory $GITROOT/build/pdf/printable/cards/secret "$file"
done
ruby $GITROOT/app/bin/generate-multipage-printables.rb -t $GITROOT/app/templates/four-cards-printable.tex.erb -r $GITROOT/build/pdf/printable/cards/secret
pdflatex --output-directory $GITROOT/build/pdf/printable/cards/secret $GITROOT/build/pdf/printable/cards/secret/pdf-collection-printable.tex
rm $GITROOT/build/pdf/printable/cards/secret/pdf-collection-printable.tex #cleanup

# make the spawn-tables
for file in $GITROOT/build/pdf/onscreen/spawn-tables/*.pdf
do
  $GITROOT/app/bin/generate-multipage-printables.rb -t $GITROOT/app/templates/four-page-pdf-leaflet.tex.erb -r "$file"
done

for file in $GITROOT/build/pdf/onscreen/spawn-tables/*.tex
do
  pdflatex --output-directory $GITROOT/build/pdf/onscreen/spawn-tables "$file"
done
mv $GITROOT/build/pdf/onscreen/spawn-tables/*-printable.pdf $GITROOT/build/pdf/printable/spawn-tables/

# make the reinforcement-points table
$GITROOT/app/bin/generate-multipage-printables.rb -t $GITROOT/app/templates/four-page-pdf-leaflet.tex.erb -r $GITROOT/build/pdf/onscreen/rules/reinforcement-points-purchase-table.pdf
pdflatex --output-directory $GITROOT/build/pdf/onscreen/rules $GITROOT/build/pdf/onscreen/rules/reinforcement-points-purchase-table-printable.tex
mv $GITROOT/build/pdf/onscreen/rules/reinforcement-points-purchase-table-printable.pdf $GITROOT/build/pdf/printable/rules/

# make the rulebook booklet
$GITROOT/app/bin/generate-multipage-printables.rb -t $GITROOT/app/templates/two-page-pdf-booklet.tex.erb -r $GITROOT/build/pdf/onscreen/rules/core-rules.pdf
pdflatex --output-directory $GITROOT/build/pdf/onscreen/rules $GITROOT/build/pdf/onscreen/rules/core-rules-printable.tex
mv $GITROOT/build/pdf/onscreen/rules/core-rules-printable.pdf $GITROOT/build/pdf/printable/rules/


# clean up the working files
find $GITROOT/build/pdf/ -name '*.tex' -execdir rm {} \;
find $GITROOT/build/ -name '*.aux' -execdir rm {} \;
find $GITROOT/build/ -name '*.log' -execdir rm {} \;
find $GITROOT/build/ -name '*.out' -execdir rm {} \;