#!/bin/bash
# This script is for performing basic directory/file descriptive analysis for the TCGA dataset.
# Upon successful completion there will be a log file summary in each directory (<dir>.log).
cd "$(dirname "$0")" || exit
cd ../data || exit

DIRS=(TCGA-BRCA TCGA-COAD TCGA-GBM TCGA-KIRC TCGA-KIRP TCGA-LUAD TCGA-LUSC TCGA-OV TCGA-READ TCGA-UCEC)

for d in "${DIRS[@]}"; do
  cd "$d" || exit; pwd
  toWrite=''; fc=0

  for f in $(find . -name \*.txt); do # This loop style is generally bad practice, but it is fine here.
    ((fc += 1))
    size="$(wc -lm "$f")"
    _file="$(echo "$size" | tr -s ' ' | cut -d ' ' -f 4)"
    _line="$(echo "$size" | tr -s ' ' | cut -d ' ' -f 2)"
    _byte="$(echo "$size" | tr -s ' ' | cut -d ' ' -f 3)" # Same as character count since this is ASCII.
    head="$(head "$f")"; tail="$(tail "$f")"

    printf -v printed "FILE: %s\nLINES: %s BYTES/CHARS: %s\n----------HEAD----------\n%s\n----------TAIL\
----------\n%s\n----------------------------------------------------------------------------------------\
------------\n" "$_file" "$_line" "$_byte" "$head" "$tail"

    toWrite+=$printed
  done

  printf -v printed '%d FILES PROCESSED\n' "$fc"
  toWrite+=$printed; echo "$toWrite" > "$d".log
  cd ..
done
