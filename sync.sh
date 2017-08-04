#!/bin/sh

mix compile --force

bin/compile_gpb.sh

WD=`pwd`
REACT_DIR=../reactNativeTest/
PROTOS=`${WD}/bin/all_protos.sh`
cd ${REACT_DIR}
yarn gpb ${PROTOS}
cd ${WD}
echo "Compiled gpb"

bin/compile_embedded.sh
echo "Generated embedded files"
