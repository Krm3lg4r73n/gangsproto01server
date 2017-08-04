#!/bin/sh
PROTO_DIR=protobufs/

PROTOS_STRING=""
for i in `find $(pwd)/"$PROTO_DIR"*  -type f`; do
  PROTOS_STRING=`echo ${PROTOS_STRING} $i`
done
echo $PROTOS_STRING
