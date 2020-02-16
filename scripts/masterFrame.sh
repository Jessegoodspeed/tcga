#!/bin/bash
# This script generates a single TSV file for the entire TCGA dataset; `./data/tcgaFrame.tsv`.
# Precondition: In order for the file to be correct, `trimFile.sh` must have completed successfully.
#
# The output file has 17815 rows (17814 genes + 1 header row) X 2211 cols (2210 files + 1 gene col).
# A sample format follows; **note** the sort order of `trimFile.sh` may differ by system.
#  This is _fine_ since each file is sorted according to the same ordering semantics.
#
# ----------------------------------------------
# |   GENES   | BRCA | ... | COAD | ... | UCEC |
# |-----------|------|-----|------|-----|------|
# | 15E1.2    | #    |     | #    |     | #    |
# | 2'-PDE    | #    |     | #    |     | #    |
# | ...       |      |     |      |     |      |
# | tcag7.350 | #    |     | #    |     | #    |
# ----------------------------------------------
#
cd "$(dirname "$0")" || exit
cd ../data || exit

genes=$'GENES\n'
genes+="$(cut -f1 "$(find . -name \*.txt -print -quit)")"
echo "$genes" > genes.tsv; unset genes

DIRS=(TCGA-BRCA TCGA-COAD TCGA-GBM TCGA-KIRC TCGA-KIRP TCGA-LUAD TCGA-LUSC TCGA-OV TCGA-READ TCGA-UCEC)

for d in "${DIRS[@]}"; do
  subDir="$(echo "$d" | cut -d'-' -f2)"
  cd "$d"/"$subDir" || exit; pwd

  cols="$(seq -s, 2 2 1200)" # Above max columns; shortcut since `cut` will ignore extra columns.
  header="$(yes "$subDir" | head -n"$(find . -name '*.txt' | wc -l)" | tr '\n' '\t' | sed s/.$//)"

  if [[ "$OSTYPE" == "darwin"* ]]; then # Since macOS `seq` is wacky.
    cols="$(echo "$cols" | sed 's/.$//')"
  fi

  # Do this wacky stuff to prevent FS complaining about too many open files. Assume limit is 256.
  find . -name \*.txt | split -l 240 - lists
  for list in lists*; do
    cat "$list" | xargs paste > merge"${list##lists}"
  done
  paste merge* | cut -f"$cols" > ../"$subDir".tsv
  rm lists* merge*

  echo "$header" | cat - ../"$subDir".tsv > tmp && mv tmp ../"$subDir".tsv

  cd ../..
done

paste ./genes.tsv ./TCGA-BRCA/BRCA.tsv ./TCGA-COAD/COAD.tsv ./TCGA-GBM/GBM.tsv ./TCGA-KIRC/KIRC.tsv \
  ./TCGA-KIRP/KIRP.tsv ./TCGA-LUAD/LUAD.tsv ./TCGA-LUSC/LUSC.tsv ./TCGA-OV/OV.tsv ./TCGA-READ/READ.tsv \
  ./TCGA-UCEC/UCEC.tsv > tcgaFrame.tsv

rm ./genes.tsv ./TCGA-BRCA/BRCA.tsv ./TCGA-COAD/COAD.tsv ./TCGA-GBM/GBM.tsv ./TCGA-KIRC/KIRC.tsv \
  ./TCGA-KIRP/KIRP.tsv ./TCGA-LUAD/LUAD.tsv ./TCGA-LUSC/LUSC.tsv ./TCGA-OV/OV.tsv ./TCGA-READ/READ.tsv \
  ./TCGA-UCEC/UCEC.tsv
