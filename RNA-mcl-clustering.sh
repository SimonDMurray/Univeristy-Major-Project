#!/bin/bash

set -euo pipefail

## Organising work directory for MCL
cd RNA_seurat_analysis_output/barcode_files
## Converting barcodes file to expected format for MCL
srt2tab.sh filtered_barcodes.txt > cells.tab
mkdir -p ../../RNA_mcl_work
cd ../../RNA_mcl_work
## MCXload generates a network in expected formated for MCL from a matrix market file
mkdir -p mcl_nn
tail -n +3 ../RNA_seurat_analysis_output/nn_matrix/nn.mtx | mcxload -123 -  -ri max --write-binary -o mcl_nn/nn.mcx
## Create MCL output directory
mkdir -p cls_mcl
## Running MCL clustering using 30 CPUs and an inflation value of 1.4 (equivalent to 0.8 resolution)
rcl mcl cls_mcl -p 30 -n mcl_nn/nn.mcx -t ../RNA_seurat_analysis_output/barcode_files/cells.tab -I "1.4"
mkdir -p lei_conversion
cd lei_conversion
# Converting leiden script requires leiden clustering to be in current working directory
cp ../../RNA_seurat_analysis_output/cls_lei/lei_r08 .
## Converting leiden clustering to rcl format for comparison
srt2cls.sh lei_r08 ../../RNA_seurat_analysis_output/barcode_files/cells.tab
rm lei_r08
cd ..
mkdir -p comparison
clm vol -o comparison/out.RNA.vol cls_mcl/out.nn.mcx.I140 lei_conversion/lei_r08.cls
## Can't compare RNA to RNA clusterings of the same algorithm as clm vol requires matrices to be the same size
mkdir -p mcl_seurat_table
cd mcl_seurat_table
## Converting mcl clustering to table format to be integrated to Seurat object
mcxdump -imx ../cls_mcl/out.nn.mcx.I140 -tabr ../../RNA_seurat_analysis_output/barcode_files/cells.tab --transpose --no-values -o RNA_srt_mcl.file
