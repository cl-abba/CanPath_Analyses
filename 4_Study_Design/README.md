- The extended CanPath data (including the CARTaGENE additions) was used in two different PhD papers; 1) An analysis of rs12913832:GG vs AA+AG individuals and 2) Analysis of hair colour, eye colour and skin reaction to the sun.
- The different goals in each study necessetated some modifications to phenotype and genotype files to answer our questions of interest.
- In the case of rs12913832:GG vs AA+AG, we first have to extract the one SNP from all individuals, to be able to categorize individuals into their genetic backgrounds (GG=blue eye background and AA+AG=brown eye background)
- For this, we began with:
  1. extract_snp_CanPath.sh

- This will generate the following output:
  1. {outputprefix_SNPextracted}.bed
  2. {outputprefix_SNPextracted}.bim
  3. {outputprefix_SNPextracted}.fam
 
- After looking through the files, I decide .ped and .map would be a bit easier for me to work this, so when I moved the files to my local machine I recoded from .bed, .bim, .fam to .ped and .map using plink
- Next:
  1. recode_SNP_file.sh
 
- This will generate:
  1. {outputprefix_SNPextracted}.ped
  2. {outputprefix_SNPextracted}.map
  3. {outputprefix_SNPextracted}.nosex
 
- Now using RStudio:
  1. filter_genotypes.R
 
- Next, I created different phenotype models for running different types of GWAS (for the second PhD paper which will utilize this data
  - HAIR_M1: Logistic Blonde (2) vs Non-blonde (Dark brown and Black) (1)
  - HAIR_M2: Logistic Red (2) vs Non-red (Dark brown and Black) (1)
  - HAIR_M3: Linear Blonde (1) vs Light brown (2) vs Dark brown (3) vs Black (4)
  - EYE_M1: Logistic Blue(+grey) (2) vs Non-blue (Brown, Green and Hazel) (1)
  - EYE_M2: Logistic Blue(+grey) (2) vs Non-blue (Brown and Hazel) (1)
  - EYE_M3: Linear Blue(+grey) (1) vs Green (2) vs Hazel (3) vs Brown (4)
  - SKIN_M1: Linear in order of increasing reaction to sun exposure, beginning from no reaction (1, 2, 3, 4, 5)
  - SKIN_M2: Linear in order of increasing reaction to sun exposure, geninning from tan, no burn (1, 2, 3, 4)
 
- Modify the phenotype files in R:
  1. Pheno.R
 
- The goal was the creation of 7 different phenotype files:
  1. EUR_PhenoFile_Clean_BothSexes.txt
  2. EUR_PhenoFile_Clean_Males.txt
  3. EUR_PhenoFile_Clean_Females.txt
  4. EUR_PhenoFile_Clean_GGstrat.txt
  5. EUR_PhenoFile_Clean_AGstrat.txt
  6. EUR_PhenoFile_Clean_AAstrat.txt
  7. EUR_PhenoFile_Clean_AAandAGstrat.txt
- These files contained columns with each phenotype model, as well as all covariates (Sex, Age, first 10PCs)
- I used the IDs from these files to generate filtered pruned genotype files (for Step 1 of SAIGE)
  1. Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_BothSexes
  2. Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_Males
  3. Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_Females
  4. Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_GGstrat
  5. Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_AGstrat
  6. Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_AAstrat
  7. Chr1to22_CanPath_EUR_Pruned_Clean_Unrelated_AAandAGstrat
- I did the same for the imputed files, hopefully this will work in SAIGE so that I do not have to make a file for each phenotype model

- Note that SAIGE can sometimes have difficulty reading flags in .vcf files, so following the lead of Frida Lona Durazo (PhD student preceding me, find her GitHub here: https://github.com/ape4fld I made .bgen files in preparation for SAIGE)
  1. index_vcf.sh
  2. make_bgen.sh
  3. index_bgen.sh
