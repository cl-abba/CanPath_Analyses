- CanPath samples from different provinces were genotyped with different genotyping arrays (mainly the GSA 24v1MDP array and the Axiom 2.0 UK Biobank (Affymetrix) (UKBB) and the Global Screening Array (GSA) 24v1+MDP.
- Our aim was to merge based on common SNPs shared across both arrays (note that this may not be a suitable approach for all researchers depending on their goals, some SNPs are lost this way)
- Order of scripts:
  1. axiom_carta_qc.sh
  2. extract_variants.sh
  3. extract_variants2.sh
  4. merge_vcftools.sh

