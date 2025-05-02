#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=2:00:00
#SBATCH --job-name=remove_related
#SBATCH --output=remove_related.out
#SBATCH --error=remove_related.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

module load StdEnv/2023
module load plink/2.00-20231024-avx2

plink2 --pfile all_hg38 --remove deg2_hg38.king.cutoff.out.id --make-pgen --out 1KG_All
