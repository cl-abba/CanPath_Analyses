#!/bin/bash
#SBATCH --account=def-eparra
#SBATCH --time=15:00:00
#SBATCH --job-name=merge-chr1   
#SBATCH --output=merge-chr1.out
#SBATCH --error=merge-chr1.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020  gcc/9.3.0 bcftools/1.16
module load tabix/0.2.6

# Command suggested by G. Debortoli bcftools concat file1.vcf file2.vcf 
# -Oz > all_chr.vcf.gz

#gzip -d chr22.CartaGene-clean-varlist.vcf.gz

#bgzip chr22.CartaGene-clean-varlist.vcf

    vcf_file1="chr1.Axiom.R2-clean.recode.vcf.gz"
    vcf_file2="chr1.CartaGene-clean-varlist.vcf.gz"
    output_file="chr1-merged-AllCanPath.vcf.gz"

    # Merge VCF files using vcftools
    bcftools merge "$vcf_file1" "$vcf_file2" -Oz > "$output_file"

    # Index the merged VCF file
    #tabix -p vcf chr22-merged-AllCanPath.vcf.gz

    echo "Merged chr1 complete."
