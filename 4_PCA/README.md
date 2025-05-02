- Downloaded hg38 pgen, psam and pvar files from PLINK2 website
- Must exlcude related individuals and convert to binary format for merging with CanPath data
- Converting to binary steps adapted from: https://cran.r-project.org/web/packages/snpsettest/vignettes/reference_1000Genomes.html
- Order of scripts:
  1. decompress_1KG.sh
  2. remove_related.sh
  3. clean_1KG.sh
 
- Then I moved the files to my local machine and completed the following steps:

plink --bfile AllCanPath_chr1to22_pruned2 --write-snplist --out AllCanPath_chr1to22_pruned2

plink --bfile 1KG_All_Phase3_Autosomes_clean_unique_plink1 --extract AllCanPath_chr1to22_pruned2_unique_plink1.snplist --make-bed --out 1KG_All_Phase3_Autosomes_clean_unique_plink1_subset

plink --bfile 1KG_All_Phase3_Autosomes_clean_unique_plink1_subset --bmerge AllCanPath_chr1to22_pruned2_unique_plink1.bed AllCanPath_chr1to22_pruned2_unique_plink1.bim AllCanPath_chr1to22_pruned2_unique_plink1.fam --make-bed --out 1KG_CanPath_merged_PCA

plink --bfile 1KG_All_Phase3_Autosomes_clean_unique_plink1_subset --exclude 1KG_CanPath_merged_PCA-merge.missnp --make-bed --out 1KG_clean_subset
plink --bfile AllCanPath_chr1to22_pruned2_unique_plink1 --exclude 1KG_CanPath_merged_PCA-merge.missnp --make-bed --out AllCanPath_clean

plink --bfile 1KG_clean_subset --bmerge AllCanPath_clean.bed AllCanPath_clean.bim AllCanPath_clean.fam --make-bed --out 1KG_CanPath_merged_PCA

- Then prune again to capture patterns of LD in merged dataset

plink --bfile 1KG_CanPath_merged_PCA --indep-pairwise 50 1 0.1 --out pruned_markers

plink --vcf 1KG_CanPath_merged_PCA --extract pruned_markers.prune.in --make-bed --out 1KG_CanPath_merged_pruned

- Next, run:
  1. pca.sh
  2. pca.R

- Notes regarding missing ancestry:
  - Total eye colour samples = 12,320 (124 missing ancestry)
  - Total hair colour samples = 32,477 (8,356 missing ancestry)
  - Total tanning response samples = 28,195 (8,164 missing ancestry)
  - In the total sample there are 23,034 self reported EUR individuals and 8,553 individuals missing ancestry information that could be EUR
 
- After removing individuals who self-report more than one ancestry
- 32,773 total samples after merging the phenotype file and pca_results files

  <img width="278" alt="pca" src="https://github.com/user-attachments/assets/f6ba5091-658c-415c-98ed-5a24ec985ed9" />

- Filter for individuals who survived the radius in the pca.R script and prune again for final PCA:
  1. filter_EUR.sh
  2. compress_EUR.sh
  3. pruning_EUR.sh
  4. prune2_EUR.sh
  5. merge_chrB.sh
 
- At this time I also double checked for related individuals (I found 1000 related pairs with a pi hat score of greater than 0.1875, indicating second cousins or closer) so I removed those individuals using my local machine

plink --bfile AllCanPath_EUR_pruned --genome --min 0.1875 --out AllCanPath_EUR_relatedness

#Make a .txt file containing the individuals you would like to remove and use the --remove flag in plink

- Finally:
  1. pca_2.sh
 
- Extract individuals from pruned dataset for final PCA
- Then generate files for the different GWAS models that will be run

plink --bfile --keep CanPath_EUR.txt --make-bed --out CanPath_merged_2_EUR
  
