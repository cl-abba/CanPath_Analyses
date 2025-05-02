# GG individuals

CanPath <- read.delim("CanPath_merged_15_rs12913832_recode.ped", sep = " ", header = FALSE)

head(CanPath)

colnames(CanPath) <- c("FID", "ID", "PID", "MID", "Sex", "P", "A1", "A2")

head(CanPath)

EUR <- read.delim("EUR_Canpath_Samples_FromPCA.txt", sep = "\t", header = TRUE)

head(EUR)

library(dplyr)
library(readr) 

CanPath_EUR = inner_join(CanPath, EUR, by = "ID")

nrow(CanPath_EUR)

head(CanPath_EUR)

# G allele is 2 if we were working with binary codes

CanPath_GG <- CanPath_EUR %>% filter(A1 == "G", A2 == "G")

head(CanPath_GG)

nrow(CanPath_GG)

# 11062 GG individuals

write.table(CanPath_GG, file = "CanPath_EUR_GG.txt", sep = " ", row.names = FALSE, col.names = TRUE)

# AG individuals:

CanPath_AG <- CanPath_EUR %>% filter(A1 == "A", A2 == "G")

head(CanPath_AG)

nrow(CanPath_AG)

# 12334 AG individuals

write.table(CanPath_AG, file = "CanPath_EUR_AG.txt", sep = " ", row.names = FALSE, col.names = TRUE)

# AA individuals:

CanPath_AA <- CanPath_EUR %>% filter(A1 == "A", A2 == "A")

head(CanPath_AA)

nrow(CanPath_AA)

# 3544 AA individuals

write.table(CanPath_AA, file = "CanPath_EUR_AA.txt", sep = " ", row.names = FALSE, col.names = TRUE)

# Merge AG and AA dataframes since they have the same phenotype

CanPath_AAandAG <- rbind(CanPath_AA, CanPath_AG)

head(CanPath_AAandAG)

nrow(CanPath_AAandAG)

# 15878 AA and AG individuals

write.table(CanPath_AAandAG, file = "CanPath_EUR_AAandAG.txt", sep = " ", row.names = FALSE, col.names = TRUE)
