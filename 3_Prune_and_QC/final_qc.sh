#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=48:00:00
#SBATCH --job-name=final-autosome-qc
#SBATCH --array=1-22
#SBATCH --output=final-autosome-qc.out
#SBATCH --error=final-autosome-qc.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

module load StdEnv/2020 gcc/9.3.0 bcftools/1.13 vcftools/0.1.16 tabix/0.2.6

# Input VCF file
input_vcf="chr${SLURM_ARRAY_TASK_ID}-merged-AllCanPath.vcf.gz"

# Output filtered and compressed VCF file
output_filtered="chr${SLURM_ARRAY_TASK_ID}_merged_AllCanPath_clean.vcf.gz"

# Filtering using vcftools
vcftools --gzvcf "$input_vcf" --maf 0.005 --hwe 1e-6 --max-missing 0.98 --recode --recode-INFO-all --stdout | bgzip -c > "$output_filtered"

# Indexing the filtered and compressed VCF file using tabix
tabix -p vcf "$output_filtered"
