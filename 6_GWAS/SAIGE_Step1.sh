#!/bin/bash 

#SBATCH --account=def-eparra
#SBATCH --time=8:00:00
#SBATCH --job-name=SAIGE_Step1_BothSexes_EYE_M1
#SBATCH --output=SAIGE_Step1_BothSexes_EYE_M1.out
#SBATCH --error=SAIGE_Step1_BothSexes_EYE_M1.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --cpus-per-task=8
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=950M

# Load the appropriate version of Apptainer
module load apptainer/1.2.4

# Both Sexes
# EYE_M1 binary

# Execute the genetic analysis using Apptainer instead of Singularity
apptainer exec -B /localscratch /home/abbatan1/saige_v1.3.0.sif step1_fitNULLGLMM.R \
        --plinkFile=Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_BothSexes2 \
        --phenoFile=EUR_PhenoFile_Clean_BothSexes_SAIGEedit.txt \
        --phenoCol=EYE_M1_SAIGE \
        --covarColList=AGE,SEX,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 \
        --sampleIDColinphenoFile=ID \
        --traitType=binary \
        --outputPrefix=/home/abbatan1/scratch/SAIGE_Step1_BothSexes_EYE_M1 \
        --nThreads=8 \
        --IsOverwriteVarianceRatioFile=TRUE
        --LOCO=FALSE


#For categorical traits
        --plinkFile= Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_BothSexes2 \
        --useSparseGRMtoFitNULL=FALSE \
        --phenoFile=EUR_PhenoFile_Clean_BothSexes_SAIGEedit.txt \
        --phenoCol=EYE_M3 \
        --covarColList=AGE,SEX,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 \
        --sampleIDColinphenoFile=ID \
        --traitType=quantitative \
        --outputPrefix=SAIGE_Step1_BothSexes_EYE_M3 \
        --nThreads=24 
        --IsOverwriteVarianceRatioFile=TRUE
        
        /home/abbatan1/scratch/SAIGE_Step1_GGstrat_EYE_M3
        
        apptainer exec -B /localscratch /home/abbatan1/saige_v1.3.0.sif step1_fitNULLGLMM.R \
        --plinkFile=Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_BothSexes2 \
        --phenoFile=AAandAG_Replication_Samples_Filt.txt \
        --phenoCol=EYE_M2_SAIGE \
        --covarColList=AGE,SEX,PC1,PC2,PC3,PC4,PC5,PC6,PC7,PC8,PC9,PC10 \
        --sampleIDColinphenoFile=ID \
        --traitType=binary \
        --outputPrefix=/home/abbatan1/scratch/SAIGE_Step1_AAandAG_Replication_EYE_M2 \
        --nThreads=8 \
        --IsOverwriteVarianceRatioFile=TRUE
        --LOCO=FALSE
