#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=24:00:00
#SBATCH --job-name=extract-variant-list-chr1
#SBATCH --output=extract-variant-list-chr1.out
#SBATCH --error=#SBATCH --output=extract-variant-list-chr1.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020 htslib/1.17 tabix/0.2.6

# Copy header lines from the original VCF file to the output file
zcat chr1.CartaGene-clean.recode.vcf.gz | grep "^#" > chr1.CartaGene-clean-varlist.vcf

# Use grep to filter variants from dataset 2 using the variant list
zcat chr1.CartaGene-clean.recode.vcf.gz | grep -Ff variant_list_chr1.txt >> chr1.CartaGene-clean-varlist.vcf

# Compress the output VCF file
bgzip chr1.CartaGene-clean-varlist.vcf

# Index the compressed VCF file using tabix
tabix -p vcf chr1.CartaGene-clean-varlist.vcf.gz

echo "Variant extraction for chr1 from dataset 2 complete."

## Turn this into a loop or array to do multiple chromosomes at one
