#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=8:00:00
#SBATCH --job-name=extract-snp-Canpath-merged
#SBATCH --output=extract-snp-CanPath-merged
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=60G

module load StdEnv/2020 plink/1.9b_6.21-x86_64

plink \
    --vcf chr15_merged_AllCanPath_clean.vcf.gz \
    --chr 15 \
    --from-bp 28120472 \
    --to-bp 28120472 \
    --make-bed \
    --out CanPath_merged_15_rs12913832 
