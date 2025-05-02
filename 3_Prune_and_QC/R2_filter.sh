#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=24:00:00
#SBATCH --job-name=R2-0.98-filter
#SBATCH --output=R2-0.98-filter.out
#SBATCH --error=R2-0.98-filter.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

# Test chromosome 22

module load StdEnv/2020 gcc/9.3.0 bcftools/1.16 vcftools/0.1.16 tabix/0.2.6

vcftools --gzvcf chr22_merged_AllCanPath_clean.vcf.gz --maf 0.05 --recode --recode-INFO-all --stdout | bgzip -c > chr22_merged_All_maf.vcf.gz

bcftools filter -i 'R2>=0.98' chr22_merged_All_maf.vcf.gz -O z -o chr22_merged_All_maf_R2.vcf.gz

tabix -p vcf chr22_merged_All_maf_R2.vcf.gz

#Array for all other chromosomes

vcftools --gzvcf chr${SLURM_ARRAY_TASK_ID}_merged_AllCanPath_clean.vcf.gz --maf 0.05 --recode --recode-INFO-all --stdout | bgzip -c > chr${SLURM_ARRAY_TASK_ID}_merged_All_maf.vcf.gz

bcftools filter -i 'R2>=0.98' chr${SLURM_ARRAY_TASK_ID}_merged_All_maf.vcf.gz -O z -o chr${SLURM_ARRAY_TASK_ID}_merged_All_maf_R2.vcf.gz

tabix -p vcf chr${SLURM_ARRAY_TASK_ID}_merged_All_maf_R2.vcf.gz
