#!/bin/sh
PROTO_DIR=protobufs/
CSHARP_DIR=../gangsproto01game/Assets/Scripts/Network/Protobufs/
JAVA_DIR=../protobufs_java/

JAVA_OPT=
if [ -d "$JAVA_DIR" ]; then
  JAVA_OPT="--java_out=$JAVA_DIR"
  `rm -r "$JAVA_DIR"*`
fi

CSHARP_OPT=
if [ -d "$CSHARP_DIR" ]; then
  CSHARP_OPT="--csharp_out=$CSHARP_DIR"
  `rm "$CSHARP_DIR"*`
fi

function look_for_protos {
  for i in `find $(pwd)/"$1"*  -type f`; do
    DIR=$(dirname "$i")
    protoc --proto_path="$DIR" $CSHARP_OPT $JAVA_OPT "$i"
  done
}

look_for_protos "$PROTO_DIR"
