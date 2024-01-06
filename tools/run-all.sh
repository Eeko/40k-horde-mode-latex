# run-all.sh
# run all the tooling we have in the correct order. 
# Generates a /build folder which gets renamed as /outputs after everything is done.
bash generate-tex-files-onscreen.sh
bash generate-pdf-files-onscreen.sh
bash generate-tex-files-printable.sh
bash generate-pdf-files-printable.sh

export GITROOT=$(git rev-parse --show-toplevel)

mv $GITROOT/build $GITROOT/outputs