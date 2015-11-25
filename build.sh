#!/bin/sh

BASE_DIR=`pwd`
WORKING_DIR="$BASE_DIR/TMP"
OONI_PROBE_BRANCH="master"
OONI_PIPELINE_BRANCH="feature/docs"

if [ ! -d "$WORKING_DIR"  ]; then
    mkdir $WORKING_DIR
fi
if [ ! -d "$WORKING_DIR/virtualenv-docs/"  ]; then
    virtualenv $WORKING_DIR/virtualenv-docs/
fi
source $WORKING_DIR/virtualenv-docs/bin/activate

# Build the documentation for ooni-probe
if [ ! -d "$WORKING_DIR/ooni-probe/"  ]; then
    git clone https://github.com/TheTorProject/ooni-probe.git $WORKING_DIR/ooni-probe
    cd $WORKING_DIR/ooni-probe/
else
    cd $WORKING_DIR/ooni-probe/
    git pull
fi
git checkout $OONI_PROBE_BRANCH
pip install -r requirements.txt
pip install sphinx

cd docs/
make html
rm -rf $BASE_DIR/ooni/probe
mv build/html $BASE_DIR/ooni/probe
deactivate


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
rm -rf $BASE_DIR/ooni/pipeline
mv site $BASE_DIR/ooni/pipeline
