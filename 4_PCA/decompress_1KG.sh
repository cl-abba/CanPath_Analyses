#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=2:00:00
#SBATCH --job-name=decompress
#SBATCH --output=decompress.out
#SBATCH --error=decompress.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

module load StdEnv/2020
module load nixpkgs/16.09
module load plink/2.00-10252019-avx2

plink2 --zst-decompress all_hg38.pgen.zst > all_hg38.pgen
