#!/usr/env bash

# generate-pdf-files-onscreen.sh
# Run this script to generate all .pdf files from the .tex files in build/tex/onscreen directory
# I.e, single pages in a pdf without crop marks.
# The output files will be stored to the build/pdf/onscreen/ path in the execution folder which will be created.
# requires pdflatex with a bunch of built-in packages. E.g. sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra

export GITROOT=$(git rev-parse --show-toplevel)
#export TEXINPUTS=$GITROOT
export TEXHOME=$(kpsewhich -var-value=TEXMFHOME)
mkdir -p $TEXHOME/tex/latex/hordemode
cp $GITROOT/HordeModeTarot.cls $TEXHOME/tex/latex/hordemode

# create pdf directories
mkdir -p $GITROOT/build/pdf/onscreen
mkdir -p $GITROOT/build/pdf/onscreen/cards/misery
mkdir -p $GITROOT/build/pdf/onscreen/cards/secondary
mkdir -p $GITROOT/build/pdf/onscreen/cards/secret
mkdir -p $GITROOT/build/pdf/onscreen/rules
mkdir -p $GITROOT/build/pdf/onscreen/spawn-tables

# generate misery cards
for file in $GITROOT/build/tex/onscreen/cards/misery/*.tex
do
  pdflatex  --output-directory $GITROOT/build/pdf/onscreen/cards/misery "$file"
done

# generate secret cards
for file in $GITROOT/build/tex/onscreen/cards/secret/*.tex
do
  pdflatex  --output-directory $GITROOT/build/pdf/onscreen/cards/secret "$file"
done

# generate secondary cards
for file in $GITROOT/build/tex/onscreen/cards/secondary/*.tex
do
  pdflatex  --output-directory $GITROOT/build/pdf/onscreen/cards/secondary "$file"
done

# generate spawn tables
for file in $GITROOT/build/tex/onscreen/spawn-tables/*.tex
do
  pdflatex  --output-directory $GITROOT/build/pdf/onscreen/spawn-tables "$file"
done

# generate rulebook
pdflatex  --output-directory $GITROOT/build/pdf/onscreen/rules $GITROOT/build/tex/onscreen/rules/core-rules.tex

# generate reinforcement-points shop
pdflatex  --output-directory $GITROOT/build/pdf/onscreen/rules $GITROOT/build/tex/onscreen/rules/reinforcement-points-purchase-table.tex

# clean up the working files
find $GITROOT/build/pdf -name '*.aux' -execdir rm {} \;
find $GITROOT/build/pdf -name '*.log' -execdir rm {} \;
find $GITROOT/build/pdf -name '*.out' -execdir rm {} \;