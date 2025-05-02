setwd("/Volumes/LaCie/CanPath_Project/SAIGE_Step2_Output/Both_Sexes/EYE_M1")

# Load necessary libraries
# Make sure to install these packages if you haven't done so already:
# install.packages("qqman")
# install.packages("data.table")

library(qqman)       # For QQ and Manhattan plots
library(data.table)  # For fast file reading and merging

# Define the working directory where the files are stored
# setwd("/path/to/your/files")  # Replace with the path to your files

# Read and merge all files into a single data frame
file_list <- list.files(pattern = "Chr[0-9]+_SAIGE_Step2_BothSexes_EYE_M1_vcf.out")

# Load each file and merge them using data.table's rbindlist for efficiency
data <- rbindlist(lapply(file_list, fread))
head(data)

# Task 1: QQ Plot
# Ensure p-values are numeric for plotting (couple additional filters as well)
data$p.value <- as.numeric(data$p.value)
data <- data[!is.na(data$p.value), ]
data <- data[data$p.value != 0, ]
data <- data[data$BETA != 0, ]
data <- data[data$AF_Allele2 >= 0.01, ]

# Create QQ plot for p-values
qq(data$p.value, main = "Eye Colour Model 1 All Sexes QQ Plot",
   xlab = "Expected -log10(p-value)", ylab = "Observed -log10(p-value)")

# Task 2: Manhattan Plot
# Prepare data for the Manhattan plot by renaming columns if necessary
# The qqman package requires columns to be named as follows:
# CHR (chromosome), BP (position), SNP (marker ID), P (p-value)

# Rename columns to match the qqman package requirements
colnames(data)[which(colnames(data) == "POS")] <- "BP"
colnames(data)[which(colnames(data) == "MarkerID")] <- "SNP"
colnames(data)[which(colnames(data) == "p.value")] <- "P"

head(data)

# Filter any missing p-values
data <- data[!is.na(data$P), ]

# Manhattan plot with genome-wide and suggestive significance lines

manhattan(data, main = "Eye Colour Model 1 All Sexes Manhattan Plot", ylim = c(0, 50), cex = 0.6, 
          cex.axis = 0.9, col = c("blue4", "orange3"), suggestiveline = T, genomewideline = T, chrlabs = c(1:22),
          xlab = "Chromosome", ylab = "-log10(p-value)")

# Task 3: Extract significant markers based on suggestive threshold
# Filter data for p-values below the suggestive significance threshold (1e-5)
suggestive_hits <- data[data$P < 1e-5, ]

# Save the filtered data into a new text file
fwrite(suggestive_hits, "suggestive_significant_markers.txt", sep = "\t", quote = FALSE)

# End of script


