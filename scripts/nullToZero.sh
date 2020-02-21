#!/bin/bash
# Replace all null values with zero.
cd "$(dirname "$0")" || exit
cd ../data || exit

if [[ "$OSTYPE" == "darwin"* ]]; then # Different sed distros.
  sed -i '' 's/[Nn][Uu][Ll][Ll]/0/g' tcgaFrame.tsv
else
  sed -i 's/[Nn][Uu][Ll][Ll]/0/g' tcgaFrame.tsv
fi
