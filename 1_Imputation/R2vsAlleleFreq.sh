#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=40:00:00
#SBATCH --array=1-22
#SBATCH --job-name=step1chromfiles1-22-imputed
#SBATCH --output=step1chromfiles1-22.out
#SBATCH --error=step1chromfiles1-22.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

 module load StdEnv/2020 gcc/9.3.0 bcftools/1.16 tabix/0.2.6

    # Perform filtering using bcftools

    bcftools filter -i 'R2 >= 0.7' chr${SLURM_ARRAY_TASK_ID}.Axiom.vcf.gz -O z -o chr${SLURM_ARRAY_TASK_ID}.Axiom.R2.vcf.gz

    # Index the filtered VCF file

    tabix -p vcf chr${SLURM_ARRAY_TASK_ID}.Axiom.R2.vcf.gz

#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=25:00:00
#SBATCH --job-name=Axiom_R2vsAlleleFreq    
#SBATCH --output=Axiom_R2vsAlleleFreq.out
#SBATCH --error=Axiom_R2vsAlleleFreq.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020 gcc/9.3.0 bcftools/1.16

# Set the output file name
output_file="merged_AxiomR2data.txt"

# Loop through the chromosome files
for i in {1..22}

do

    # Set the input VCF file name
    input_file="chr${i}.Axiom.R2.vcf.gz"
    
    # Run bcftools query and append the output to the merged file
    bcftools query -f '%CHROM\t%POS\t%MAF\t%INFO/R2\n' "$input_file" >> "$output_file"

    done
