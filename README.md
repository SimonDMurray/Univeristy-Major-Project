# Univeristy-Major-Project
Evidence of all scripts used in University Major Project for evidencing in University report

Script Explanations:

get-data.sh - this script downloads the TAR file containing cellranger outputs, removes data not needed for this project and reorganises the data into a readable manner that Seurat expects.

Dockerfile - contains all of the code to generate the Docker container with the correct environmental set up to reproduce project's working environment

seurat-ADT-analysis.Rmd - R notebook that runs downstream analysis, Leiden clustering and generates MCL input matrix for CITEseq data

seurat-RNA-analysis.Rmd - R notebook that runs downstream analysis, Leiden clustering and generates MCL input matrix for scRNAseq data
