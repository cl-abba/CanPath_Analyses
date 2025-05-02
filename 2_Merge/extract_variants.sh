#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=24:00:00
#SBATCH --job-name=extract-variant-list
#SBATCH --output=extract-variant-list.out
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020 htslib/1.17

# chr${i}.Axiom.R2-clean.recode.vcf.gz 
# chr${i}.CartaGene-clean.recode.vcf.gz

# Loop through the files using the naming convention chr1.vcf.gz, chr2.vcf.gz
for i in {1..22}; do
    vcf_file="chr${i}.Axiom.R2-clean.recode.vcf.gz"
    output_txt="variant_list_chr${i}.txt"

    # Use grep to extract variant lines and append to the output file
    zcat "$vcf_file" | grep -v "^#" | cut -f 1-5 >> "$output_txt"

    echo "Variant list generation for chr${i} complete."
done

echo "All variant lists generated."
