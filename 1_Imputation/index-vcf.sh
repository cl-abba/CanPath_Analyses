#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=15:00:00
#SBATCH --job-name=index-chr
#SBATCH --output=index-chr.out
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020 gcc/9.3.0 bcftools/1.13 

# Loop over each chromosome
for i in {1..22}
do
  # VCF file name
  vcf_file="AxiomUKBB-chr${i}.vcf.gz"

  # Index the VCF file using bcftools
  bcftools index ${vcf_file}
done
