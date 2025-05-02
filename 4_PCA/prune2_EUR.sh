#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=5:00:00
#SBATCH --job-name=CanPath-pruning2-1-5
#SBATCH --output=CanPath-pruning2-1-5.out
#SBATCH --error=CanPath-pruning2-1-5.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

module load StdEnv/2020
module load plink/1.9b_6.21-x86_64

plink --vcf chr1_merged_AllCanPath_clean_EUR.vcf.gz --extract chr1_EUR.prune.in --make-bed --out chr1_merged_AllCanPath_clean_EUR_pruned

# Modify to loop or array for all 22 chromosomes

# May choose to prune more than once due to the window nature of the indep-pairwise function
