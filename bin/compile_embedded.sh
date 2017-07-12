#!/bin/sh
CSHARP_DIR=../gangsproto01game/Assets/Scripts/Generated/
rm -r $CSHARP_DIR/*

mix compile
elixir embedded/message_dict.cs.exs >> $CSHARP_DIR/MessageDict.cs

