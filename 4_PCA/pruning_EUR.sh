#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=20:00:00
#SBATCH --job-name=pruning_EUR
#SBATCH --output=pruning_EUR.out
#SBATCH --error=pruning_EUR.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

module load StdEnv/2020
module load plink/1.9b_6.21-x86_64

plink --vcf chr1_merged_AllCanPath_clean_EUR.vcf.gz --indep-pairwise 50 1 0.1 --out chr1_EUR;

plink --vcf chr2_merged_AllCanPath_clean_EUR.vcf.gz --indep-pairwise 50 1 0.1 --out chr2_EUR;

plink --vcf chr3_merged_AllCanPath_clean_EUR.vcf.gz --indep-pairwise 50 1 0.1 --out chr2_EUR

# Modify to loop or array for all 22 chromosomes
