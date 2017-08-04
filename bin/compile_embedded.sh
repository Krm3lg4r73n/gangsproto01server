#!/bin/sh
CSHARP_DIR=../gangsproto01game/Assets/Scripts/Network/Generated/
rm -r $CSHARP_DIR/*

JS_DIR=../reactNativeTest/app/generated/
rm -r $JS_DIR/*

mix compile
elixir embedded/message_dict.cs.exs >> $CSHARP_DIR/MessageDict.cs
elixir embedded/message_dict.js.exs >> $JS_DIR/messageDict.js

