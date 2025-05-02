#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=10:00:00
#SBATCH --job-name=PCA_2
#SBATCH --output=PCA_2.out
#SBATCH --error=PCA_2.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=80G

module load StdEnv/2020
module load plink/1.9b_6.21-x86_64

plink 
        --bfile AllChr_CanPath_EUR_pruned_unrelated --pca 20 --out AllChr_CanPath_EUR_pruned_PCA_unrelated
     
