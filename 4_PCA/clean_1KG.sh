#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=5:00:00
#SBATCH --job-name=clean-1KG
#SBATCH --output=clean-1KG.out
#SBATCH --error=clean-1Kg.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=100G

# "vzs" modifier to directly operate with pvar.zst
# "--chr 1-22" excludes all variants not on the listed chromosomes
# "--output-chr 26" uses numeric chromosome codes
# "--max-alleles 2": PLINK 1 binary does not allow multi-allelic variants
# "--rm-dup" removes duplicate-ID variants
# "--set-missing-var-id" replaces missing IDs with a pattern

module load StdEnv/2023
module load plink/2.00-20231024-avx2

plink2 --pfile 1KG_All vzs \
       --chr 1-22 \
       --output-chr 26 \
       --max-alleles 2 \
       --rm-dup exclude-mismatch \
       --set-missing-var-ids '@_#_$1_$2' \
       --make-pgen \
       --out 1KG_All_Phase3_Autosomes

# second script to convert to binary 

# pgen to bed
# "--maf 0.005" remove most monomorphic SNPs 
# (still may have some when all samples are heterozyguous -> maf=0.5)
plink2 --pfile 1KG_All_Phase3_Autosomes \
       --maf 0.005 \
       --make-bed \
       --out 1KG_All_Phase3_Autosomes
