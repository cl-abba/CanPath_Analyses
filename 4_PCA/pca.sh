#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=10:00:00
#SBATCH --job-name=PCA
#SBATCH --output=PCA
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=80G

module load StdEnv/2020
module load plink/1.9b_6.21-x86_64

plink 
        --bfile 1KG_CanPath_merged_PCA_pruned --pca 20 --out 1KG_CanPath_merged_PCA_pruned_PCout
     
