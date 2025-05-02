#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=15:00:00
#SBATCH --job-name=filter4EURsamples
#SBATCH --output=filter4EURsamples.out
#SBATCH --error=filter4EURsamples.out
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

module load StdEnv/2020 
module load nixpkgs/16.09 
module load plink/2.00-10252019-avx2

for 

i in {1..5}

do

plink2 --vcf chr${i}_merged_AllCanPath_clean.vcf.gz --keep EUR_CanPath_Samples_b.txt --export vcf --out chr${i}_merged_AllCanPath_clean_EUR

done
