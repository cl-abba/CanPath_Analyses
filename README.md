# CanPath_Analyses
This repository describes steps in genome-wide association studies (GWAS) and post-GWAS analyses of pigmentation traits in the Canadian Partnership for Tomorrow's Health (CanPath) dataset, which represents the fourth chapter (Paper 3) in my PhD thesis.

## Introduction

This example uses vcf files from over approximately 30,000 individuals from the Canadian Partnership for Tomorrow's Health (CanPath) expanded dataset (supplented with many additional samples from CARTaGENE) and investigates genetic associations with categorical eye colours (blue, green, hazel and brown), hair colours and skin reaction to the sun. Phenotypes were self-reported by participants, along with province, age and sex. The command line scripts (.sh) are formatted for running on a server with a scheduler, such as SLURM. Some may require program installation if the server is not already equipped with the necessary programs. URLs are provided for each program utilized. It is reccomended to read the documentation before using a program for the first time, this will provide an understanding of the flags or parameters, how to set up the proper input files, what output files will look like and how to interpret them. Figures for the R visualization scripts are provided.

Additional notes:

- In 2018, we received CanPath datasets from all provinces. The data was dispersed among a few different genotyping chips and Frida conducted thorough QC and consolodated the samples for which eye colour data was available into two datasets GSA and Axiom UKBB (N = 12,998 with CaG and N = 3,834 without CaG)
- In 2023, we received a merged dataset for all CARTaGENE (CaG) samples from Quebec (this included the CaG samples from 2018, N = 19,916).
- So we removed CaG samples from the 2018 datasets, performed imputation with TopMed, and then merged with the 2023 CaG samples using IMMerge (N = 23,750)
- The scripts to achieve this are outlined in this repository.

## Materials and methods

The methodology is as follows:

1) Impute CanPath arrays (GSA and Axiom UKBB) with TopMed (remove repeated CaG (Quebec) samples)
2) Merge imputed CanPath_GSA + CanPath_Axiom_UKBB + CartaGene 
3) Pruning and QC on imputed genotype data
4) PCA
5) Modify the .vcf files to reflect the project: a) Eye colour, b) Hair colour, c) Skin response to the sun
6) Run the GWAS for the different arrays and models
7) Run GCTA COJO (conditional analysis) for signficant regions
8) Run FINEMAP for signficant regions
9) Genetic correlation and multi-trait analysis (LDSC + CPASSOC)

