#!/bin/sh
PROTO_DIR=./protobufs/
CSHARP_DIR=../gangsproto01game/Assets/Scripts/Protobufs/

`rm "$CSHARP_DIR"*`
for i in `ls "$PROTO_DIR"*`; do
  protoc --proto_path="$PROTO_DIR" --csharp_out="$CSHARP_DIR" "$i"
done
