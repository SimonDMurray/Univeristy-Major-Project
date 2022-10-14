#!/bin/bash

set -euo pipefail

# Downloading CITEseq dataset

mkdir -p data
wget -O data/GSE164378_RAW.tar 'https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE164378&format=file'
tar -xvf data/GSE164378_RAW.tar -C data/

# Removing HTO data as not needed for this project
rm -rf data/*HTO*

# Removing TCR data as not needed for this project
rm -rf data/*TCR*

# Removing BCR data as not needed for this project
rm -rf data/*BCR*

# Removing 3' data as discussed in project meeting 3 
rm -rf data/*5P*

# Organising data
mkdir -p data/RNA
mv data/*RNA*.gz data/RNA

mkdir -p data/ADT
mv data/*ADT*.gz data/ADT/

# Changing files name to expected input for Seurat
cd data/RNA
for file in *; do
        mv $file ${file##GSM5008737_RNA_3P-}
done

cd ../ADT
for file in *; do
	mv $file ${file#GSM5008738_ADT_3P-}
done

cd ..

# Downloading reference seurat object
wget https://atlas.fredhutch.org/data/nygc/multimodal/pbmc_multimodal.h5seurat

# Removing TAR file
rm GSE164378_RAW.tar


