#!/bin/bash

set -euo pipefail

## Organising work directory for MCL
mkdir -p mcl_work/ADT
cp nn_matrices/ADT/nn.mtx mcl_work/ADT
cp data/ADT/barcodes.tsv.gz mcl_work/ADT
cp data/ADT/features.tsv.gz mcl_work/ADT/features.tsv.gz
cd mcl_work/ADT
gunzip *.gz
mv features.tsv genes.txt
## Converting barcodes file to expected format for MCL
srt2tab.sh barcodes.tsv > cells.tab
## MCXload generates a network in expected formated for MCL from a matrix market file
tail -n +3 nn.mtx | mcxload -123 -  -ri max --write-binary -o nn.mcx
## Create MCL output directory
cd ../..
mkdir -p cls_mcl/ADT
## Running MCL clustering using 30 CPUs and an inflation value of 1.4 (equivalent to 0.8 resolution)
rcl mcl cls_mcl/ADT -p 30 -n mcl_work/ADT/nn.mcx -t mcl_work/ADT/cells.tab -I "1.4"