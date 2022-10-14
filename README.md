# Univeristy-Major-Project
Evidence of all scripts used in University Major Project for evidencing in University report

Script Explanations:

`get-data.sh` - this script downloads the TAR file containing cellranger outputs, removes data not needed for this project and reorganises the data into a readable manner that Seurat expects.

`Dockerfile` - contains all of the code to generate the Docker container with the correct environmental set up to reproduce project's working environment

`seurat-ADT-analysis.Rmd` - R notebook that runs downstream analysis, Leiden clustering and generates MCL input matrix for CITEseq data

`seurat-RNA-analysis.Rmd` - R notebook that runs downstream analysis, Leiden clustering and generates MCL input matrix for scRNAseq data

`altering-anndata.ipynb` - Python notebook that changes h5ad MCL clustering observation to categorical, for display on cellxgene

`integration-analysis.Rmd` - R notebook that integrates MCL clusterings, volatility scores and cell type annotations to ADT and RNA seurat objects 

`sceasy-conversion.Rmd` - R notebook that converts integrated seurat objects to anndata objects to be displayed on cellxgene

`ADT-mcl-clustering.sh` - bash script that clusters ADT data with MCL and compares leiden and mcl clusterings for volatile nodes

`RNA-mcl-clustering.sh` - bash script that clusters RNA data with MCL and compares leiden and mcl clusterings for volatile nodes
