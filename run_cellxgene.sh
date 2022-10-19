#!/bin/bash

set -euo pipefail

## Script that locally runs cellxgene for quick access and testing if scripts to generate output have been followed

h5ad=${1?:Please input path to h5ad to be displayed on cellxgene}

cellxgene launch $h5ad
