#!/bin/bash

set -euo pipefail

## Organising work directory for MCL
mkdir -p mcl_work/RNA
cp nn_matrices/RNA/nn.mtx mcl_work/RNA
cp data/RNA/barcodes.tsv.gz mcl_work/RNA
cp data/RNA/features.tsv.gz mcl_work/RNA/features.tsv.gz
cd mcl_work/RNA
gunzip *.gz
mv features.tsv genes.txt
## Converting barcodes file to expected format for MCL
srt2tab.sh barcodes.tsv > cells.tab
## MCXload generates a network in expected formated for MCL from a matrix market file
tail -n +3 nn.mtx | mcxload -123 -  -ri max --write-binary -o nn.mcx
## Create MCL output directory
cd ../..
mkdir -p cls_mcl/RNA
## Running MCL clustering using 30 CPUs and an inflation value of 1.4 (equivalent to 0.8 resolution)
rcl mcl cls_mcl/RNA -p 30 -n mcl_work/RNA/nn.mcx -t mcl_work/RNA/cells.tab -I "1.4"