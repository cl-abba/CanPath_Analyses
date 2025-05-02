#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=24:00:00
#SBATCH --job-name=freq-report
#SBATCH --output=freq-report.out
#SBATCH --error=freq-report.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2023 plink/2.00-20231024-avx2 

plink2 --vcf chr22_merged_AllCanPath_clean.vcf.gz --freq --out chr22_merged_AllCanPath_clean_freq

plink2 --vcf chr22_merged_All_maf_R2.vcf.gz --freq --make-bed --out chr22_merged_All_maf_R2
