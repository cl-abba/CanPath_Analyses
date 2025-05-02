#!/bin/bash
#SBATCH --account=def-eparra
#SBATCH --time=24:00:00
#SBATCH --job-name=vcftools-qc
#SBATCH --array=1-22
#SBATCH --output=vcftools-qc.out
#SBATCH --error=vcftools-qc.err
#SBATCH --mail-user=c.abbantagelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=20G

module load StdEnv/2020 gcc/9.3.0 bcftools/1.13 vcftools/0.1.16 tabix/0.2.6

vcftools --gzvcf chr${SLURM_ARRAY_TASK_ID}.CartaGene.vcf.gz --maf 0.005 --hwe 1e-6 --max-missing 0.98 >

bgzip -c chr${SLURM_ARRAY_TASK_ID}.CartaGene-clean.recode.vcf > chr${SLURM_ARRAY_TASK_ID}.CartaGene-clean >

tabix -p vcf chr${SLURM_ARRAY_TASK_ID}.CartaGene-clean.recode.vcf.gz
