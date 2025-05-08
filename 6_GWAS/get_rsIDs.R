#####- Download hg38 reference from UCSC (in terminal) :curl -O https://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/snp151.txt.gz

# Load required packages
library(data.table)

# -------------------------------
# Step 1: Load your summary stats
# -------------------------------
summary_file <- "/Volumes/LaCie/CanPath_Project/Clean_SumStats/CanPath_EyeColour_M3_Linear_SumStats_Z.txt"
summary_df <- fread(summary_file)

# Ensure chromosome is character (to match 'chr' strings in BED)
summary_df[, CHR := as.character(CHR)]

# Create fallback ID for unmatched SNPs
summary_df[, SNP_fallback_hg38 := paste0(CHR, ":", BP, ":", Allele1, ":", Allele2)]

# Create matching key in format like "chr1:12345"
summary_df[, key := paste0("chr", CHR, ":", BP)]
lookup_keys <- unique(summary_df$key)

# -----------------------------------------------------
# Step 2: Read the massive BED file in memory-safe chunks
# -----------------------------------------------------
bed_path <- "/Volumes/LaCie/CanPath_Project/Imputed_Files/EUR_BothSexes_vcf/snp151_rsids_hg38.bed"
bed_conn <- file(bed_path, open = "r")  # Open the file connection

chunk_size <- 1e6  # Read 1 million lines at a time
filtered_bed_chunks <- list()  # To collect matched chunks
chunk_count <- 0  # Counter

cat("📦 Starting chunked reading of BED file...\n")

repeat {
  # Read the next chunk of lines
  lines <- readLines(bed_conn, n = chunk_size)
  if (length(lines) == 0) break  # Exit when no more lines
  
  # Convert chunk into a data.table
  bed_chunk <- fread(text = lines, header = FALSE, sep = "\t",
                     col.names = c("CHR", "START", "END", "rsID"))
  
  # Create key for matching (e.g., "chr1:12345")
  bed_chunk[, key := paste0(CHR, ":", END)]
  
  # Filter to rows that match any SNP position in summary stats
  matched_chunk <- bed_chunk[key %in% lookup_keys]
  
  # If matches found, store them
  if (nrow(matched_chunk) > 0) {
    filtered_bed_chunks[[length(filtered_bed_chunks) + 1]] <- matched_chunk
  }
  
  chunk_count <- chunk_count + 1
  cat("✅ Processed chunk", chunk_count, "- matched rows so far:", sum(sapply(filtered_bed_chunks, nrow)), "\n")
}

# Close file connection
close(bed_conn)

# ----------------------------------------------
# Step 3: Combine all matching chunks into one table
# ----------------------------------------------
bed_filtered_df <- rbindlist(filtered_bed_chunks)
bed_filtered_df[, CHR := gsub("^chr", "", CHR)]  # remove 'chr' prefix to match summary

# ----------------------------------------------
# Step 4: Merge rsIDs into summary stats
# ----------------------------------------------

# Merge by CHR and BP (BED END == VCF POS)
merged_df <- merge(summary_df, bed_filtered_df, by.x = c("CHR", "BP"), by.y = c("CHR", "END"), all.x = TRUE)

# Create MarkerID: use rsID where available, fallback otherwise
merged_df[, MarkerID_hg38 := ifelse(!is.na(rsID), rsID, SNP_fallback_hg38)]

# Clean up intermediate columns (drop only if they exist)
cols_to_drop <- intersect(c("SNP_fallback_hg38", "key", "START", "rsID"), colnames(merged_df))
merged_df[, (cols_to_drop) := NULL]

if ("SNP" %in% names(merged_df)) {
  snp_idx <- which(names(merged_df) == "SNP")
  # Move MarkerID just after SNP
  col_order <- append(names(merged_df), "MarkerID_hg38", after = snp_idx)
  col_order <- unique(col_order)  # Ensure no duplicates
  setcolorder(merged_df, col_order)
}

# ----------------------------------------------
# Step 5: Save to a new annotated file
# ----------------------------------------------
output_file <- "/Volumes/LaCie/CanPath_Project/Clean_SumStats/CanPath_EyeColour_M3_Linear_SumStats_Z_Annotated.txt"
fwrite(merged_df, file = output_file, sep = "\t", quote = FALSE)

# ----------------------------------------------
# Step 6: Print summary of how many rsIDs matched
# ----------------------------------------------
num_total <- nrow(merged_df)
num_with_rsID <- sum(merged_df$MarkerID_hg38 != merged_df$SNP)
num_with_fallback <- num_total - num_with_rsID

cat("\n🔍 Annotation Summary:\n")
cat("  Total SNPs:           ", num_total, "\n")
cat("  Matched rsIDs:        ", num_with_rsID, "\n")
cat("  Used fallback format: ", num_with_fallback, "\n")
cat("  Output file saved to: ", output_file, "\n")



