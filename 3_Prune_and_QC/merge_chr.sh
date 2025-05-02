#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=3:00:00
#SBATCH --job-name=merge-chr
#SBATCH --output=merge-chr.out
#SBATCH --error=merge-chr.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=80G

module load StdEnv/2020
module load plink/1.9b_6.21-x86_64

plink --bfile chr1_merged_AllCanPath_pruned1 --merge-list chrom_list.txt --make-bed --out AllCanPath_chr1to22_pruned
