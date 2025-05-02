#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=3:00:00
#SBATCH --job-name=CanPath-exlude-HLA-and-inversions
#SBATCH --output=CanPath-exclude-HLA-and-inversions.out
#SBATCH --error=CanPath-exclude-HLA-and-inversions.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=80G

module load StdEnv/2020
module load plink/1.9b_6.21-x86_64

plink --bfile AllCanPath_chr1to22_pruned --exclude range pca_regions.txt --make-bed --out AllCanPath_chr1to22_pruned2

#PCA regions to exlude (note these are the hg38 positions)

6 27032221 35032223 R1
2 134242429 136242430 R2
8 6142478 16142491 R2
17 41843748 46922634 R3
