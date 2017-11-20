#!/bin/sh
PROTO_DIR=protobufs/
CSHARP_DIR=../gangsproto01game/Assets/Scripts/Network/Protobufs/
JAVA_DIR=../protobufs_java/

JAVA_OUT=
if [ -d "$JAVA_DIR" ]; then
  JAVA_OUT="--java_out=$JAVA_DIR"
  `rm -r "$JAVA_DIR"*`
fi

CSHARP_OUT=
if [ -d "$CSHARP_DIR" ]; then
  CSHARP_OUT="--csharp_out=$CSHARP_DIR"
  `rm "$CSHARP_DIR"*`
fi

function look_for_protos {
  for i in `find $(pwd)/"$1"*  -type f`; do
    DIR=$(dirname "$i")
    protoc --proto_path="$DIR" $CSHARP_OUT $JAVA_OUT "$i"
  done
}

look_for_protos "$PROTO_DIR"
