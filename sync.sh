#!/bin/sh

mix compile --force

# Only needed for C# and Java
# bin/compile_gpb.sh

WD=`pwd`
REACT_DIR=../gangsproto01client/
PROTOS=`${WD}/bin/all_protos.sh`
cd ${REACT_DIR}
npm run gpb ${PROTOS}
cd ${WD}
echo "Compiled gpb"

bin/compile_embedded.sh
echo "Generated embedded files"
