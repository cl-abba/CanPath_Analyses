#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=12:00:00
#SBATCH --job-name=CanPath-pruning1A-1-3
#SBATCH --output=CanPath-pruning1A-1-3.out
#SBATCH --error=CanPath-pruning1A-1-3.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=80G

module load StdEnv/2020
module load plink/1.9b_6.21-x86_64

plink --vcf chr1_merged_All_maf_R2.vcf.gz --indep-pairwise 50 1 0.1 --out chr1_CanPath_LD

# Modify to loop or array for all 22 chromosomes
