- Run the GWAS for each phenotypic model
- SAIGE was used for this - SAIGE is a mixed model approach with 2 steps; 1) for creating a relatedness matrix and 2) for conducting the GWAS itself
- More on SAIGE: https://saigegit.github.io/SAIGE-doc/
- Order of scripts:
  1. install_SAIGE.sh (docker image is helpful for this, previously I had used singularity for installation on Compute Canadaa, but this time I had to use apptainer, they achieve the same outcome)
  2. SAIGE_Sep1.sh
  3. SAIGE_Step2.sh
  4. Manhattan_Plots.R (for vizuation of QQ plots and Manhattan plots)
  5. get_rsIDs.R (this is because I noticed after running the GWAS that the .vcf files did not have rsIDs in them, since I had already run the GWAS, instead of annotating the vcf files (which is also very doable), I decided to annotate the summary statistic files (and to help with downstrea analyses such as LDSC shich benefits from having rsIDs)
