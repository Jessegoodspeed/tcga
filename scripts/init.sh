#!/bin/bash
# This script is for initializing the TCGA project data
# The only precondition is the zip archive must be in the repository root.
cd "$(dirname "$0")" || exit
cd ..; unzip TCGAdata.zip -d data

cd data || exit
rm -r __MACOSX
mv TCGA_KIRC TCGA-KIRC

DIRS=(TCGA-BRCA TCGA-COAD TCGA-GBM TCGA-KIRC TCGA-KIRP
  TCGA-LUAD TCGA-LUSC TCGA-OV TCGA-READ TCGA-UCEC)

for d in "${DIRS[@]}"; do
  cd "$d" || exit
  dir="$(echo "$d" | cut -d - -f 2)"
  unzip -d "$dir" -- *.zip
  cd "$dir" || exit
  rm -r __MACOSX
  cd ../..
done

cd TCGA-LUAD/LUAD || exit
chmod u=rw,g=r,o=r ./*.txt
