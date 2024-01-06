#!/usr/env bash
#
# generate-tex-files-printable.sh
# Script to generate versions for printing from the individual card files (misery, secondary, secret)
# Makes slightly larger pages to include the cropmarks for cards.

export GITROOT=$(git rev-parse --show-toplevel)

source $GITROOT/40k-horde-mode-markdown/VERSION.env


mkdir $GITROOT/build
mkdir -p $GITROOT/build/tex/printable
mkdir -p $GITROOT/build/tex/printable/cards/misery
mkdir -p $GITROOT/build/tex/printable/cards/secondary
mkdir -p $GITROOT/build/tex/printable/cards/secret

ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/cards/misery --template $GITROOT/app/templates/misery-card.tex.erb --output $GITROOT/build/tex/printable/cards/misery --croplines
ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/cards/secondary --template $GITROOT/app/templates/secondary-objective-card.tex.erb --output $GITROOT/build/tex/printable/cards/secondary --croplines
ruby $GITROOT/app/bin/parse-rules.rb --version "$VERSION" --rule-file $GITROOT/40k-horde-mode-markdown/cards/secret --template $GITROOT/app/templates/secret-objective-card.tex.erb --output $GITROOT/build/tex/printable/cards/secret --croplines