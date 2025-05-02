#!/bin/bash 

#SBATCH --account=def-eparra
#SBATCH --time=8:00:00
#SBATCH --job-name=SAIGE_Step2_BothSexes_EYE_M1
#SBATCH --output=SAIGE_Step2_BothSexes_EYE_M1.out
#SBATCH --error=SAIGE_Step2_BothSexes_EYE_M1.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=950M

module load apptainer/1.2.4

for i in {1..22}

do

apptainer exec -B /localscratch /home/abbatan1/saige_v1.3.0.sif step2_SPAtests.R \
--bgenFile=Chr${i}_AllCanPath_EUR_Clean_Final_BothSexes.bgen \
--bgenFileIndex=Chr${i}_AllCanPath_EUR_Clean_Final_BothSexes.bgen.bgi \
--sampleFile=Chr${i}_AllCanPath_EUR_Clean_Final_BothSexes.sample \
--SAIGEOutputFile=Chr${i}_SAIGE_Step2_BothSexes_EYE_M1.out \
--AlleleOrder=ref-first \
--chrom=${i} \
--minMAF=0.01 \
--minMAC=10 \
--is_imputed_data=TRUE \
--GMMATmodelFile=SAIGE_Step1_BothSexes_EYE_M1.rda \
--varianceRatioFile=SAIGE_Step1_BothSexes_EYE_M1.varianceRatio.txt \
--is_Firth_beta=TRUE \
--pCutoffforFirth=0.01 \
--LOCO=FALSE;

done

# To run from the command line (no job):

module load StdEnv/2020

module load gcc r python

R

library('SAIGE')

q()

#Note chr 10, 11 and 12 encountered an error and chr 9 was not indexed....

Rscript /home/abbatan1/SAIGE-1.0.0/extdata/step2_SPAtests.R \
    --bgenFile=/home/abbatan1/scratch/Chr12_AllCanPath_EUR_Clean_Final_BothSexes.bgen \
    --bgenFileIndex=/home/abbatan1/scratch/Chr12_AllCanPath_EUR_Clean_Final_BothSexes.bgen.bgi \
    --sampleFile=/home/abbatan1/scratch/Chr12_AllCanPath_EUR_Clean_Final_BothSexes.sample \
    --SAIGEOutputFile=/home/abbatan1/scratch/Chr12_SAIGE_Step2_BothSexes_EYE_M1.out \
    --AlleleOrder=ref-first \
    --chrom=12 \
    --minMAF=0.01 \
    --minMAC=10 \
    --is_imputed_data=TRUE \
    --GMMATmodelFile=/home/abbatan1/scratch/SAIGE_Step1_BothSexes_EYE_M1.rda \
    --varianceRatioFile=/home/abbatan1/scratch/SAIGE_Step1_BothSexes_EYE_M1.varianceRatio.txt \
    --is_Firth_beta=TRUE \
    --pCutoffforFirth=0.01 \
    --LOCO=FALSE

#Note chr 10, 11 and 12 have a different number of samples, so we will re-do Step 1 of SAIGE with them really quick

Rscript /home/abbatan1/SAIGE-1.0.0/extdata/step2_SPAtests.R \
        --vcfFile=/home/abbatan1/scratch/Chr1_AllCanPath_EUR_Clean_Final_BothSexes.vcf.gz \
        --vcfFileIndex=/home/abbatan1/scratch/Chr1_AllCanPath_EUR_Clean_Final_BothSexes.vcf.gz.csi \
        --vcfField=GT \
        --SAIGEOutputFile=/home/abbatan1/scratch/Chr1_SAIGE_Step2_BothSexes_EYE_M1_vcf.out \
        --chrom=1 \
        --minMAF=0.01 \
        --minMAC=20 \
        --LOCO=FALSE \
        --GMMATmodelFile=/home/abbatan1/scratch/SAIGE_Step1_BothSexes_EYE_M1.rda \
        --varianceRatioFile=/home/abbatan1/scratch/SAIGE_Step1_BothSexes_EYE_M1.varianceRatio.txt\
        --is_output_moreDetails=TRUE

#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=8:00:00
#SBATCH --job-name=SAIGE_Step2_BothSexes_EYE_M1_chr1to4
#SBATCH --output=SAIGE_Step2_BothSexes_EYE_M1_chr1to4.out
#SBATCH --error=SAIGE_Step2_BothSexes_EYE_M1_chr1to4.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --array=1-4
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=950M

module load StdEnv/2020
module load gcc r

CHROM=${SLURM_ARRAY_TASK_ID}

Rscript /home/abbatan1/SAIGE-1.0.0/extdata/step2_SPAtests.R \
        --vcfFile=/home/abbatan1/scratch/Chr${CHROM}_AllCanPath_EUR_Clean_Final_AAstrat.vcf.gz \
        --vcfFileIndex=/home/abbatan1/scratch/Chr${CHROM}_AllCanPath_EUR_Clean_Final_AAstrat.vcf.gz.csi \
        --vcfField=GT \
        --SAIGEOutputFile=/home/abbatan1/scratch/Chr${CHROM}_SAIGE_Step2_AAstrat_EYE_M1_vcf.out \
        --chrom=${CHROM} \
        --minMAF=0.01 \
        --minMAC=20 \
        --LOCO=FALSE \
        --GMMATmodelFile=/home/abbatan1/scratch/SAIGE_Step1_AAstrat_EYE_M1.rda \
        --varianceRatioFile=/home/abbatan1/scratch/SAIGE_Step1_AAstrat_EYE_M1.varianceRatio.txt\
        --is_output_moreDetails=TRUE

Rscript /home/abbatan1/SAIGE-1.0.0/extdata/step2_SPAtests.R \
        --vcfFile=/home/abbatan1/scratch/Chr9_AllCanPath_EUR_Clean_Final_BothSexes.vcf.gz \
        --vcfFileIndex=/home/abbatan1/scratch/Chr9_AllCanPath_EUR_Clean_Final_BothSexes.vcf.gz.csi \
        --vcfField=GT \
        --SAIGEOutputFile=/home/abbatan1/scratch/Chr9_SAIGE_Step2_BothSexes_SKIN_M1_vcf.out \
        --chrom=9 \
        --minMAF=0.01 \
        --minMAC=20 \
        --LOCO=FALSE \
        --GMMATmodelFile=/home/abbatan1/scratch/SAIGE_Step1_BothSexes_SKIN_M1.rda \
        --varianceRatioFile=/home/abbatan1/scratch/SAIGE_Step1_BothSexes_SKIN_M1.varianceRatio.txt\
        --is_output_moreDetails=TRUE

#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=8:00:00
#SBATCH --job-name=SAIGE_Step2_AGstrat_EYE_M1_chr1to6
#SBATCH --output=SAIGE_Step2_AGstrat_EYE_M1_chr1to6.out
#SBATCH --error=SAIGE_Step2_AGstrat_EYE_M1_chr1to6.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --array=1-6
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=950M

module load StdEnv/2020
module load gcc r

CHROM=${SLURM_ARRAY_TASK_ID}

Rscript /home/abbatan1/SAIGE-1.0.0/extdata/step2_SPAtests.R \
        --vcfFile=/home/abbatan1/scratch/Chr${CHROM}_AllCanPath_EUR_Clean_Final_AGstrat.vcf.gz \
        --vcfFileIndex=/home/abbatan1/scratch/Chr${CHROM}_AllCanPath_EUR_Clean_Final_AGstrat.vcf.gz.csi \
        --vcfField=GT \
        --SAIGEOutputFile=/home/abbatan1/scratch/Chr${CHROM}_SAIGE_Step2_AGstrat_EYE_M1_vcf.out \
        --chrom=${CHROM} \
        --minMAF=0.01 \
        --minMAC=20 \
        --LOCO=FALSE \
        --GMMATmodelFile=/home/abbatan1/scratch/SAIGE_Step1_AGstrat_EYE_M1.rda \
        --varianceRatioFile=/home/abbatan1/scratch/SAIGE_Step1_AGstrat_EYE_M1.varianceRatio.txt\
        --is_output_moreDetails=TRUE

