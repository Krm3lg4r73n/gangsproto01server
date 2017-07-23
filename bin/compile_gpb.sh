#!/bin/sh
PROTO_DIR=./protobufs/
CSHARP_DIR=../gangsproto01game/Assets/Scripts/Protobufs/
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

for i in `ls "$PROTO_DIR"*`; do
  protoc --proto_path="$PROTO_DIR" $CSHARP_OPT $JAVA_OPT "$i"
done
