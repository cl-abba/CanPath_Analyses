#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=3:00:00
#SBATCH --job-name=recode-SNP-file
#SBATCH --output=extract-snp-CanPath.out
#SBATCH --error=extract-snp-CanPath.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=30G

module load StdEnv/2020 plink/1.9b_6.21-x86_64

plink \
    --bfile CanPath_merged_15_rs12913832 \
    --allow-no-sex \
    --recode \
    --out CanPath_15_rs12913832_recode 
