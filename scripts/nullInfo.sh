#!/bin/bash
# This script is for performing basic null value analysis.
# Precondition: `dataInfo.sh` must have completed successfully.
#
# It is composed of two main parts:
#  1. Frequency of null values by cancer; printed to stdout.
#  2. Frequency of null values by gene (approximation); printed to 'data/nullByGene.log'.
cd "$(dirname "$0")" || exit
cd ../data || exit

DIRS=(TCGA-BRCA TCGA-COAD TCGA-GBM TCGA-KIRC TCGA-KIRP TCGA-LUAD TCGA-LUSC TCGA-OV TCGA-READ TCGA-UCEC)

echo 'Part 1/2: null/cancer'
find . -name '*.txt' -exec grep -i null {} \; > hold.log
nullsT="$(wc -l < hold.log | tr -d ' ')"; genesT=0;

for d in "${DIRS[@]}"; do
  cd "$d" || exit; pwd

  files="$(tail -n2 "$d".log | head -n1)"
  genes=$(($(echo "$files" | cut -d' ' -f1) * 17814))
  nulls="$(find . -name '*.txt' -exec grep -i null {} \; | wc -l | tr -d ' ')"
  (( genesT += genes ))

  echo "$files; $nulls null values of $genes genes total.
------------------------------------------------------------"

  cd ..
done

pwd; echo "2210 FILES PROCESSED; $nullsT null values of $genesT genes total."
echo 'Part 1/2: null/cancer DONE
Part 2/2: null/gene'

while read -r line; do
  count="$(grep -cF "$line	" hold.log)"
  printf -v printed "%s %s\n" "$line" "$count"
  toWrite+=$printed
done < <(cut -f1 "$(find . -name '*.txt' -print -quit)")

rm hold.log
echo "$toWrite" > nullByGene.log
echo 'Part 2/2: null/gene DONE
See /data/nullByGene.log'
