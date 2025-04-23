- In 2018, we received CanPath datasets from all provinces. The data was dispersed among a few different genotyping chips and Frida conducted thorough QC and consolodated the samples for which eye colour data was available into two datasets GSA and Axiom UKBB (N = 12,998 with CaG and N = 3,834 without CaG)
- In 2023, we received a merged dataset for all CartaGene (CaG) samples from Quebec (this included the CaG samples from 2018, N = 19,916)
- So we removed CaG samples from the 2018 datasets, performed imputation with TopMed, and then merged with the 2023 CaG samples using IMMerge (N = 23,750)
    - Order of scripts (in preparation for imputation with TopMed server):
     a) removeCaG-2018.sh
     b) split-chr.sh
     c) index-vcf.sh
     d) R2vsAlleleFreq.sh
     e) hexPlot.R

- Settings for imputation with TopMed:

  - Settings for the imputation:
    1. Reference Panel: TOPMed r2
    2. Array Build: GRCh19/hg37
    3. Rsq Filter: off
    4. Phasing: Eagle v2.4 (phased output)
    5. Population: vs. TOPMed Panel
    6. Mode: Quality Control & Imputation
    7. AES 256 encryption: off
    8. Generate Meta-imputation file: on
- Results:
    1. Quality control report
       - In the QC step, TopMed checks each variant and excludesit in the case of:
         a) Contains invalid alleles
         b) Duplicates
         c) Indels
         d) Monomorphic sites
         e) Allele mismatch between reference panel and uploaded data
         f) SNP call rate <90%
       - All filtered variants are listed in a file called "statistics.txt" which can be downloaded by clicking on the provided link
    2. Compressed chromosomal data
       - If imputation was successful, TopMed compresses and encrypts the data and sends the user a random password via email (all data is deleted after 7 days!)
       - Note, the compressed chromosome folders contain .dose.vcf.gz, .empiricalDose.vcf.gz and .info.gz files
    3. Chunks exluded text file
    4. md5sum report
    5. snps-excluded text file
    6. typed-only text file
 
- If a user has vcf.gz and info.gz files that were all generated from TopMed, then there is a tool called IMMerge that may work well (the CartaGene files we have, do not have the info files available)
- We are going to proceed with vcftools (more on this in 2_Merging):
    1.	For the Axiom 2.0 CanPath files that I imputed myself with TopMed
                a)	Plot imputation R2 vs allele frequency
                b)	Perform QC on this set of files with the following:
                    i.	MAF
                    ii.	HWE
                    iii.	SNP-missingness

      	![download](https://github.com/user-attachments/assets/1f3da675-1234-406b-b787-ef2676fdfd09)

    3.	From the other CartaGene files for which I do not have the imputation results:
                a)	Extract the SNP list from point 1 above
                    i.	Double check MAF, HWE and missingness to be sure this SNP list is “high quality” in both cohorts
    4.	Merge cohorts, perform PCA (x2) and GWAS
- If someone wanted to perform all of the QC within PLINK, this link is helpful for learning PLINK's order of operations: https://www.cog-genomics.org/plink/2.0/order


  
