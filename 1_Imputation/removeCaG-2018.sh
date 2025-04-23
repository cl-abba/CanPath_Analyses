#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=15:00:00
#SBATCH --job-name=removeCaG-2018-imputed
#SBATCH --output=removeCaG-2018-imputed.out
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020 
module load nixpkgs/16.09 
module load plink/2.00-10252019-avx2

plink2 --vcf /home/abbatan1/projects/def-eparra/CPTP/cptp.final.1KG.clean-2.vcf.gz --keep samples2keep-CanPath2018.txt --export vcf --out CanPath-AxiomUKBB-2018-notimp-clean;

plink2 --vcf /home/abbatan1/projects/def-eparra/CPTP/gsa.5300.final.1KG.clean-2.vcf.gz --keep samples2keep-CanPath2018.txt--export vcf --out CanPath-GSA-2018-notimp-clean
