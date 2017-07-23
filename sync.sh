#!/bin/sh

mix compile --force

bin/compile_gpb.sh
echo "Compiled gpb"

bin/compile_embedded.sh
echo "Generated embedded files"
