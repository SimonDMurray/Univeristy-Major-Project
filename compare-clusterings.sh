#!/bin/bash

set -euo pipefail

mkdir -p compare_clusterings
cd compare_clusterings
# Comparing RNA clustering between leiden and mcl
clm vol -o out.RNA.vol ../cls_mcl/RNA/out.nn.mcx.I140 ../cls_lei/RNA/lei_r08.cls
# Comparing ADT clustering between leiden and mcl
clm vol -o out.ADT.vol ../cls_mcl/ADT/out.nn.mcx.I140 ../cls_lei/ADT/lei_r08.cls
# Can't compare ADT to RNA clusterings of the same algorithm as clm vol requires matrices to be the same size
