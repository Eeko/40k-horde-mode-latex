#!/usr/env bash

# generate-tex-files-onscreen.sh
# Run this script to generate all .tex files from the .md files in 40k-horde-mode-markdown/ directory
# which should be intended for on-screen consumption. I.e, single pages in a pdf without crop marks.
# The output files will be stored to the build/tex/onscreen/ path in the execution folder which will be created.
export GITROOT=$(git rev-parse --show-toplevel)

source $GITROOT/40k-horde-mode-markdown/VERSION.env


mkdir $GITROOT/build
mkdir -p $GITROOT/build/tex/onscreen
mkdir -p $GITROOT/build/tex/onscreen/cards/misery
mkdir -p $GITROOT/build/tex/onscreen/cards/secondary
mkdir -p $GITROOT/build/tex/onscreen/cards/secret
mkdir -p $GITROOT/build/tex/onscreen/rules
mkdir -p $GITROOT/build/tex/onscreen/spawn-tables

ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/rules/core-rules.md --template $GITROOT/app/templates/core-rules-book.tex.erb --output $GITROOT/build/tex/onscreen/rules/core-rules.tex
ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/rules/reinforcement-points-purchase-table.md --template $GITROOT/app/templates/reinforcement-points-purchase-table.tex.erb --output $GITROOT/build/tex/onscreen/rules/reinforcement-points-purchase-table.tex
ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/spawn-tables --template $GITROOT/app/templates/spawn-table.tex.erb --output $GITROOT/build/tex/onscreen/spawn-tables
ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/cards/misery --template $GITROOT/app/templates/misery-card.tex.erb --output $GITROOT/build/tex/onscreen/cards/misery
ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/cards/secondary --template $GITROOT/app/templates/secondary-objective-card.tex.erb --output $GITROOT/build/tex/onscreen/cards/secondary
ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/cards/secret --template $GITROOT/app/templates/secret-objective-card.tex.erb --output $GITROOT/build/tex/onscreen/cards/secret