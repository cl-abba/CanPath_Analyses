# From pruned files (local machine):

--bfile Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_BothSexes --keep EUR_PhenoFile_Clean_BothSexes_ID.txt --make-bed --out Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_BothSexes

# From imputed files (Compute Canada):

#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=12:00:00
#SBATCH --job-name=Filter_EUR_BothSexes
#SBATCH --output=Filter_EUR_BothSexes.out
#SBATCH --error=Filter_EUR_BothSexes.err
#SBATCH --array=1-4
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=120G

module load StdEnv/2020 
module load nixpkgs/16.09 
module load plink/2.00-10252019-avx2

##Run this first for converting to pgen (plink2) format

VCF_PREFIX="chr${SLURM_ARRAY_TASK_ID}_merged_AllCanPath_clean_EUR"
OUT_PREFIX="Chr${SLURM_ARRAY_TASK_ID}_AllCanPath_EUR_Clean_Plink2_BothSexes"
ID_LIST="Both_Sexes_vcf.txt"

plink2 --vcf ${VCF_PREFIX}.vcf.gz dosage=HDS --make-pgen erase-phase --snps-only --keep ${ID_LIST} --out ${OUT_PREFIX}

##Then run this to complete conversion to bgen

PFILE_PREFIX="Chr${SLURM_ARRAY_TASK_ID}_AllCanPath_EUR_Clean_Plink2_BothSexes"
OUT_PREFIX="Chr${SLURM_ARRAY_TASK_ID}_AllCanPath_EUR_Clean_Final_BothSexes"

plink2 --pfile  ${PFILE_PREFIX} --export bgen-1.2 ref-first bits=8 --out ${OUT_PREFIX}

##Trying with .vcf files:

#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=20:00:00
#SBATCH --job-name=Filter_EUR_BothSexes_vcf
#SBATCH --output=Filter_EUR_BothSexes_vcf.out
#SBATCH --error=Filter_EUR_BothSexes_vcf.err
#SBATCH --array=1-4
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=400G

module load StdEnv/2020 
module load nixpkgs/16.09 
module load plink/2.00-10252019-avx2

## Convert directly to a filtered VCF

VCF_PREFIX="chr${SLURM_ARRAY_TASK_ID}_merged_AllCanPath_clean_EUR"
OUT_VCF_PREFIX="Chr${SLURM_ARRAY_TASK_ID}_AllCanPath_EUR_Clean_Final_BothSexes"
ID_LIST="BothSexes_Samples.txt"

plink2 --vcf ${VCF_PREFIX}.vcf.gz --snps-only --keep ${ID_LIST} --recode vcf bgz --out ${OUT_VCF_PREFIX}

#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=20:00:00
#SBATCH --job-name=index-CanPath-vcf
#SBATCH --output=index-CanPath-vcf.out
#SBATCH --error=index-CanPath-vcf.err
#SBATCH --array=1-4
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=400G

module load StdEnv/2020 gcc/9.3.0 bcftools/1.13 

  # VCF file name
  vcf_file="Chr${SLURM_ARRAY_TASK_ID}_AllCanPath_EUR_Clean_Final_BothSexes.vcf.gz"

  # Index the VCF file using bcftools
  bcftools index ${vcf_file}
