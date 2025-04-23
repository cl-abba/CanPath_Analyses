#This step is required because the input for TopMed must be split by chromosome

#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=15:00:00
#SBATCH --job-name=split-chr
#SBATCH --output=split-chr.out
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020 gcc/9.3.0 samtools/1.17  bcftools/1.13 

# Input VCF file name
input_vcf="CanPath-AxiomUKBB-2018-notimp-clean.vcf.gz" #Ensure this has been indexed

bgzip ${input_vcf}

# Loop over each chromosome
for i in {1..22}
do
  # Output VCF file name
  output_vcf="AxiomUKBB-chr${i}.vcf.gz"

  # Extract variants for current chromosome
  bcftools view -r ${i} ${input_vcf} | bgzip -c > ${output_vcf}
done
