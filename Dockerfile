# Rocker is a remote repository containing R versions complete with basic packages so most installed packages work
FROM rocker/r-ver:4.0.4

# Need it to install some basic OS packages in order to other packages to work
RUN apt-get update && apt-get install -y liblzma-dev libbz2-dev zlib1g libpng-dev libxml2-dev \
    gfortran-7 libglpk-dev libhdf5-dev libcurl4-openssl-dev python3.8 python3-dev python3-pip wget git-all

# Need to install specific pacakges for UMAP and leiden to allow them to work within Seurat 
RUN pip3 install numpy==1.20.1 umap-learn leidenalg igraph anndata regex cellxgene

# Installing the packages needed for downstream analysis in R, due to some packages being dependencings of others the order they are installed in matters
RUN Rscript -e "install.packages(c('BiocManager', 'devtools', 'R.utils', 'reticulate', 'processx'))"
RUN Rscript -e "BiocManager::install(c('Rhtslib', 'LoomExperiment', 'SingleCellExperiment'))"

# Need to specify version of Seurat data 
RUN Rscript -e "devtools::install_github(c('cellgeni/sceasy', 'satijalab/seurat-data@v0.2.1'))"

RUN Rscript -e "install.packages(c('hdf5r','dimRed','png','ggplot2','reticulate','plotly','Matrix','leiden', 'Seurat', 'gplots', 'SeuratObject'))"

RUN Rscript -e "devtools::install_github('mojaveazure/seurat-disk')"

# Installing MCL/RCL
# Need to re-organise mcl directory to contain additional scripts not in source download and remove unecessary files from repository in container
RUN cd /opt && \
    git clone https://github.com/micans/mcl.git && \
    cd mcl && \
    chmod u+x install-this-mcl.sh && \
    ./install-this-mcl.sh 

# Need to re-organise mcl directory to contain everything needed and remove unecessary files from repository
RUN mv /opt/mcl/rcl/srt2tab.sh /opt/mcl/mcl-22-282/rcl && \
    mv /opt/mcl/rcl/srt2cls.sh /opt/mcl/mcl-22-282/rcl && \
    mv /opt/mcl/mcl-22-282 /opt && \
    rm -rf /opt/mcl

# Add MCL and associated tools to PATH
ENV PATH="${PATH}:/opt/mcl-22-282/src/shcl:/opt/mcl-22-282/src/shmcl:/opt/mcl-22-282/src/shmcx:/opt/mcl-22-282/src/shmcxquery:/opt/mcl-22-282/src/shmx:/opt/mcl-22-282/rcl"

# Specify docker container to start in bash rather than R
ENTRYPOINT ["bash"]
