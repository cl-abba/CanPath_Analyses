#####- Download hg38 reference from UCSC (in terminal) :curl -O https://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/snp151.txt.gz

setwd("/Volumes/LaCie/CanPath_Project/Multi_Trait_CanPath")

# ---- File paths (modify if needed) ----
summary_file <- "/Volumes/LaCie/CanPath_Project/Multi_Trait_CanPath/CanPath_HairColour_M3_Linear_SumStats_Z.txt"
#bed_file <- "/Volumes/LaCie/CanPath_Project/Imputed_Files/EUR_BothSexes_vcf/snp151_rsids_hg38.bed"
output_file <- "/Volumes/LaCie/CanPath_Project/Multi_Trait_CanPath/CanPath_HairColour_M3_Linear_SumStats_Z_Annotated.txt"

# ---- Load summary stats ----
summary_df <- read.table(summary_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# Ensure CHR is character for merging
summary_df$CHR <- as.character(summary_df$CHR)

# Create fallback SNP ID
summary_df$SNP_fallback <- paste(summary_df$CHR, summary_df$BP, summary_df$Allele1, summary_df$Allele2, sep = ":")

# ---- Load BED file ----

write.table(unique(summary_df[, c("CHR", "BP")]),
            file = "summary_chr_pos.txt", sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE) # For filtering in terminal

# Then in terminal: 

awk 'NR==FNR {a[$1":"$2]; next} ($1 ~ /^chr/) {key=substr($1,4)":"$3; if (key in a) print}' \
>   ~/summary_chr_pos.txt \
>   snp151_rsids_hg38.bed > snp151_filtered.bed

bed_df <- read.table("/Volumes/LaCie/CanPath_Project/Imputed_Files/EUR_BothSexes_vcf/snp151_filtered.bed", header = FALSE, sep = "\t",
                     col.names = c("CHR", "START", "END", "rsID"), stringsAsFactors = FALSE)

# Remove "chr" prefix from CHR
#bed_df$CHR <- gsub("^chr", "", bed_df$CHR)

# Merge by CHR and BP (BED END matches VCF POS)
annotated_df <- merge(summary_df, bed_df, by.x = c("CHR", "BP"), by.y = c("CHR", "END"), all.x = TRUE)

# Create MarkerID
annotated_df$MarkerID <- ifelse(!is.na(annotated_df$rsID), annotated_df$rsID, annotated_df$SNP_fallback)

# Optional: reorder columns (put MarkerID after SNP)
snp_idx <- which(names(annotated_df) == "SNP")
reordered_cols <- append(names(annotated_df), "MarkerID", after = snp_idx)
reordered_cols <- reordered_cols[!duplicated(reordered_cols)]
annotated_df <- annotated_df[, reordered_cols]

# ---- Summary stats for matching ----
num_total <- nrow(annotated_df)
num_with_rsID <- sum(!is.na(annotated_df$rsID))
num_with_fallback <- num_total - num_with_rsID

cat("🔍 Summary:\n")
cat("  Total variants: ", num_total, "\n")
cat("  rsID matches:   ", num_with_rsID, "\n")
cat("  Fallback IDs:   ", num_with_fallback, "\n")

# ---- Save to file ----
write.table(annotated_df, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE)

cat("✅ Annotated file saved to:\n", output_file, "\n")

