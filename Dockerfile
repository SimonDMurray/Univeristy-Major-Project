# Rocker is a remote repository containing R versions complete with basic packages so most installed packages work
FROM rocker/r-ver:4.0.4

# Need it to install some basic OS packages in order to other packages to work
RUN apt-get update && apt-get install -y liblzma-dev libbz2-dev zlib1g libpng-dev libxml2-dev \
        gfortran-7 libglpk-dev libhdf5-dev libcurl4-openssl-dev python3.8 python3-dev python3-pip wget

# Need to install specific pacakges for UMAP and leiden to allow them to work within Seurat 
RUN pip3 install numpy==1.20.1 umap-learn leidenalg igraph anndata regex


# Installing the pacakges needed for downstream analysis in R, due to some packages being dependencings of others the order they are installed in matters
RUN Rscript -e "install.packages(c('BiocManager', 'devtools', 'R.utils', 'reticulate', 'processx'))"
RUN Rscript -e "BiocManager::install(c('Rhtslib', 'LoomExperiment', 'SingleCellExperiment'))"

# Need to specify version of Seurat data 
RUN Rscript -e "devtools::install_github(c('cellgeni/sceasy', 'satijalab/seurat-data@v0.2.1'))"

RUN Rscript -e "install.packages(c('hdf5r','dimRed','png','ggplot2','reticulate','plotly','Matrix','leiden', 'Seurat', 'gplots', 'SeuratObject'))"

RUN Rscript -e "devtools::install_github('mojaveazure/seurat-disk')"

# Specify docker container to start in bash rather than R
ENTRYPOINT ["bash"]
