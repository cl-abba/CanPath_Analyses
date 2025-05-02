#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=15:00:00
#SBATCH --job-name=compress-EUR
#SBATCH --output=compress-EUR.out
#SBATCH --error=compress-EUR.err
#SBATCH --array=1-11
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

module load StdEnv/2020 gcc/9.3.0 samtools/1.17 bcftools/1.13 vcftools/0.1.16

# Define the file name pattern
FILE_PATTERN="chr${SLURM_ARRAY_TASK_ID}_merged_AllCanPath_clean_EUR.vcf"

# Run bgzip to compress the VCF file
bgzip -c ${FILE_PATTERN} > ${FILE_PATTERN}.gz

echo "Compression completed for chromosome ${SLURM_ARRAY_TASK_ID}"

# Index with bcftools
