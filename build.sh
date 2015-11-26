#!/bin/sh

BASE_DIR=`pwd`
WORKING_DIR="$BASE_DIR/TMP"
OONI_PROBE_BRANCH="master"
OONI_PIPELINE_BRANCH="master"

if [ ! -d "$WORKING_DIR"  ]; then
    mkdir $WORKING_DIR
fi
if [ ! -d "$WORKING_DIR/virtualenv-docs/"  ]; then
    virtualenv $WORKING_DIR/virtualenv-docs/
fi
source $WORKING_DIR/virtualenv-docs/bin/activate

# Generate all the documentation related to OONI
rm -rf $BASE_DIR/public/ooni
mkdir -p $BASE_DIR/public/ooni/

# Github pages related stuff
pip install ghp-import

# General packages
pip install pelican markdown

# Build the documentation for ooni-probe
if [ ! -d "$WORKING_DIR/ooni-probe/"  ]; then
    git clone https://github.com/TheTorProject/ooni-probe.git $WORKING_DIR/ooni-probe
    cd $WORKING_DIR/ooni-probe/
    git checkout $OONI_PROBE_BRANCH
else
    cd $WORKING_DIR/ooni-probe/
    git checkout $OONI_PROBE_BRANCH
    git pull
fi
pip install -r requirements.txt
pip install sphinx

cd docs/
make html
mv build/html $BASE_DIR/public/ooni/probe


# Build the documentation for ooni-pipeline
if [ ! -d "$WORKING_DIR/ooni-pipeline/"  ]; then
    git clone https://github.com/TheTorProject/ooni-pipeline.git $WORKING_DIR/ooni-pipeline
    cd $WORKING_DIR/ooni-pipeline/
else
    cd $WORKING_DIR/ooni-pipeline/
    git pull
fi
git checkout $OONI_PIPELINE_BRANCH
pip install -r requirements.txt
mkdocs build
mv site $BASE_DIR/public/ooni/pipeline

# Copy the main website in
cp -R $BASE_DIR/site/* $BASE_DIR/public/
