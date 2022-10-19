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
## Running MCL clustering using 30 CPUs and an inflation values of 1.1-4.0 (0.1-3.0 equivalent)
rcl mcl cls_mcl -p 30 -n mcl_nn/nn.mcx -t ../RNA_seurat_analysis_output/barcode_files/cells.tab -I "1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0"
mkdir -p lei_conversion
cd lei_conversion
# Converting leiden script requires leiden clustering to be in current working directory
cp ../../RNA_seurat_analysis_output/cls_lei/lei_r* .
## Converting leiden clustering to rcl format for comparison
for cls in *; do 
	srt2cls.sh $cls ../../RNA_seurat_analysis_output/barcode_files/cells.tab
	rm $cls;
done
cd ..
mkdir -p comparison
clm vol -o comparison/out.RNA.vol cls_mcl/out.nn.mcx.I* lei_conversion/lei_*.cls
## Can't compare ADT to RNA clusterings of the same algorithm as clm vol requires matrices to be the same size
mkdir -p mcl_seurat_table
cd mcl_seurat_table
## Converting mcl clustering to table format to be integrated to Seurat object
for cls in ../cls_mcl/out.nn.mcx.I*; do 
    infl=`echo $cls | cut -f 3 -d "/" | cut -f 4 -d "."`
    mcxdump -imx $cls -tabr ../../RNA_seurat_analysis_output/barcode_files/cells.tab --transpose --no-values -o "${infl}_srt_mcl.file"; 
done
## Converting volatility file to seurat readable format
cd ../comparison
mcxdump -imx out.RNA.vol -tabr ../../RNA_seurat_analysis_output/barcode_files/cells.tab -o vol.srt.file
