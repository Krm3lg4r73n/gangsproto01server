#!/bin/sh
CSHARP_FILE=../gangsproto01game/Assets/Scripts/Generated/MessageDictionary.cs

rm $CSHARP_FILE
elixir compile_embedded.exs >> $CSHARP_FILE

