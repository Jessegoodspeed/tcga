#!/bin/bash
# This script is for initial cleaning of the data.
#  For the LUAD set it removes the one header line and left most column.
#  For all others it removes the two header lines.
#  Every file is sorted according to the same ordering.
#
# To run from the repository root:
#  W/ GNU PARALLEL (https://www.gnu.org/software/parallel/):
#    time -p find ./data -name "*.txt" | parallel ./scripts/trimFile.sh
#  W/O:
#    time -p find ./data -name "*.txt" -exec ./scripts/trimFile.sh {} \;
if [[ -n $1 ]]; then
  if [[ $1 == *"un"* ]]; then # LUAD has different format.
    tail -n +2 "$1" | cut -f2- | sort > "$1"_tmp && mv "$1"_tmp "$1"
  else
    if [[ $1 != *"2991"* ]]; then # Strangely there's one file already trimmed.
      tail -n +3 "$1" | sort > "$1"_tmp && mv "$1"_tmp "$1"
    else
      sort -o "$1" "$1"
    fi
  fi
fi
# To verify, you can run 'dataInfo.sh'.
# Then the following should both output '2210' when run from the project root:
#  find ./data -name "*.txt" | wc -l # Number of data files.
#  grep -r '^LINES: 17814' ./data | wc -l # Number of data files with 17814 lines.
