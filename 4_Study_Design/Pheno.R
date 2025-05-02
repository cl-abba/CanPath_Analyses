# Load necessary library
library(dplyr)

##COVARIATE FILE

# Read the .txt file into R
eur_cov <- read.table("EUR_Cov.txt", header = TRUE, sep = "", na.strings = "", stringsAsFactors = FALSE)
head(eur_cov)

# Assuming merged_data_can_path is already in your environment
# If not, you would need to load this data frame into R from its source as well

# Merge datasets on the "ID" column
merged_final <- left_join(merged_data_can_path, eur_cov, by = "ID")

# Save the merged data frame to a .txt file
write.table(merged_final, "EUR_Covariates.txt", row.names = FALSE, sep = "\t")

# Rules for the phenotype file:

# Read the .txt file into R
eur_pheno <- read.table("EUR_Pheno_Only_AmberRemoved.txt", header = TRUE, sep = "", na.strings = "", stringsAsFactors = FALSE)
head(eur_pheno)

# Assuming eur_pheno is already read into R
# Creating the new columns based on the rules provided

# Hair Color Model
eur_pheno$HAIR_M1 <- ifelse(eur_pheno$UVE_HAIR == 1, 2,
                            ifelse(eur_pheno$UVE_HAIR == 2, NA,
                                   ifelse(eur_pheno$UVE_HAIR == 3, NA,
                                          ifelse(eur_pheno$UVE_HAIR == 4, 1,
                                                 ifelse(eur_pheno$UVE_HAIR == 5, 1, NA)))))

eur_pheno$HAIR_M2 <- ifelse(eur_pheno$UVE_HAIR == 1, NA,
                            ifelse(eur_pheno$UVE_HAIR == 2, 2,
                                   ifelse(eur_pheno$UVE_HAIR == 3, NA,
                                          ifelse(eur_pheno$UVE_HAIR == 4, 1,
                                                 ifelse(eur_pheno$UVE_HAIR == 5, 1, NA)))))

eur_pheno$HAIR_M3 <- ifelse(eur_pheno$UVE_HAIR == 1, 1,
                            ifelse(eur_pheno$UVE_HAIR == 2, NA,
                                   ifelse(eur_pheno$UVE_HAIR == 3, 2,
                                          ifelse(eur_pheno$UVE_HAIR == 4, 3,
                                                 ifelse(eur_pheno$UVE_HAIR == 5, 4, NA)))))

# Eye Color Model
eur_pheno$EYE_M1 <- ifelse(eur_pheno$UVE_EYE == 2, 2,
                           ifelse(eur_pheno$UVE_EYE == 4, 2,
                                  ifelse(eur_pheno$UVE_EYE == 3, 1,
                                         ifelse(eur_pheno$UVE_EYE == 5, 1,
                                                ifelse(eur_pheno$UVE_EYE == 6, 1, NA)))))

eur_pheno$EYE_M2 <- ifelse(eur_pheno$UVE_EYE == 2, 2,
                           ifelse(eur_pheno$UVE_EYE == 4, 2,
                                  ifelse(eur_pheno$UVE_EYE == 3, 1,
                                         ifelse(eur_pheno$UVE_EYE == 5, NA,
                                                ifelse(eur_pheno$UVE_EYE == 6, 1, NA)))))

eur_pheno$EYE_M3 <- ifelse(eur_pheno$UVE_EYE == 2, 1,
                           ifelse(eur_pheno$UVE_EYE == 4, 1,
                                  ifelse(eur_pheno$UVE_EYE == 5, 2,
                                         ifelse(eur_pheno$UVE_EYE == 6, 3,
                                                ifelse(eur_pheno$UVE_EYE == 3, 4, NA)))))


# Skin Reaction Model
eur_pheno$SKIN_M1 <- ifelse(eur_pheno$UVE_SKIN_REACTION == 0, 1,
                            ifelse(eur_pheno$UVE_SKIN_REACTION == 1, 2,
                                   ifelse(eur_pheno$UVE_SKIN_REACTION == 2, 3,
                                          ifelse(eur_pheno$UVE_SKIN_REACTION == 3, 4,
                                                 ifelse(eur_pheno$UVE_SKIN_REACTION == 4, 5, NA)))))

eur_pheno$SKIN_M2 <- ifelse(eur_pheno$UVE_SKIN_REACTION == 0, NA,
                            ifelse(eur_pheno$UVE_SKIN_REACTION == 1, 1,
                                   ifelse(eur_pheno$UVE_SKIN_REACTION == 2, 2,
                                          ifelse(eur_pheno$UVE_SKIN_REACTION == 3, 3,
                                                 ifelse(eur_pheno$UVE_SKIN_REACTION == 4, 4, NA)))))

# Selecting only the new columns to create a new data frame
new_pheno <- eur_pheno[, c("ID", "HAIR_M1", "HAIR_M2", "HAIR_M3", "EYE_M1", "EYE_M2", "EYE_M3", "SKIN_M1", "SKIN_M2")]

# Check the first few rows of the new data frame to verify
head(new_pheno)
nrow(new_pheno)

eur_cov <- read.table("EUR_Covariates_10PCs.txt", header = TRUE, sep = "", na.strings = "", stringsAsFactors = FALSE)
head(eur_cov)

merged_pheno_cov <- left_join(eur_pheno, eur_cov, by = "ID")
head(merged_pheno_cov)
nrow(merged_pheno_cov)

eur_geno <- read.table("rs12913832_Geno.txt", header = TRUE, sep = "", na.strings = "", stringsAsFactors = FALSE)
head(eur_geno)

merged_pheno_cov_geno <- left_join(merged_pheno_cov, eur_geno, by = "ID")
head(merged_pheno_cov_geno)

write.table(merged_pheno_cov_geno, "EUR_Pheno_Cov_Geno_Merged.txt", row.names = FALSE, sep = "\t")

# Remove related individuals

rel_list <- read.table("Related_Individuals_List.txt", header = TRUE, sep = "", na.strings = "", stringsAsFactors = FALSE)
head(rel_list)

# rel_list is a dataframe with a column "ID" that contains IDs to be removed
# merged_pheno_cov_geno is the main dataframe from which rows will be removed

# Find the rows in merged_pheno_cov_geno where the ID is not in rel_list$ID
remaining_ids <- !merged_pheno_cov_geno$ID %in% rel_list$ID

# Subset merged_pheno_cov_geno to keep only the rows with remaining IDs
merged_pheno_cov_geno_filtered <- merged_pheno_cov_geno[remaining_ids, ]


head(merged_pheno_cov_geno_filtered)

write.table(merged_pheno_cov_geno_filtered, "EUR_Pheno_Cov_Geno_Merged_Filtered.txt", row.names = FALSE, sep = "\t")
