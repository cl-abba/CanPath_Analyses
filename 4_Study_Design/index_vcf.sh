#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=15:00:00
#SBATCH --job-name=index-CanPath
#SBATCH --output=index-CanPath.out
#SBATCH --error=index-CanPath.err
#SBATCH --array=1-4
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=120G

module load StdEnv/2020 gcc/9.3.0 bcftools/1.13 

  # VCF file name
  vcf_file="chr${SLURM_ARRAY_TASK_ID}_merged_AllCanPath_clean_EUR.vcf.gz"

  # Index the VCF file using bcftools
  bcftools index ${vcf_file}
