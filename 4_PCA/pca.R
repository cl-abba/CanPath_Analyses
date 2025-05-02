library(tidyverse)
library(ggplot2)
library(dplyr)

### STEP 1: PLOT CANPATH SAMPLES ONLY

# Read in data

pca_results <- read.table("AllCanPath_chr1to22_pruned2_pca.eigenvec", header = FALSE)
colnames(pca_results) <- c("FID", "IID", paste("PC", 1:20, sep=""))

head(pca_results)

# Remove the 'FID' column
pca_results$FID <- NULL

# Rename the 'IID' column to 'ID'
names(pca_results)[names(pca_results) == "IID"] <- "ID"

head(pca_results)

phenotypes <- read.csv("CanPath_Only.csv", header = TRUE)

head(phenotypes)

# Merging pca_results with phenotypes
# Keep only the rows with IDs that are present in the phenotypes dataframe

merged_data_can_path <- merge(phenotypes, pca_results, by = "ID")

# The resulting merged_data dataframe will have one ID column, the 20 PC columns 
#from pca_results,
# and the additional columns from phenotypes (like age, sex, etc.)

head(merged_data_can_path)
nrow(merged_data_can_path)

# Reading in eigenvalues

eigenvalues <- read.table("AllCanPath_chr1to22_pruned2_pca.eigenval")
colnames(eigenvalues) <- "evals"

# Calculate variance explained for all 20 PCs

eval_df <- data.frame(pc = sub("^", "PC", 1:nrow(eigenvalues)),
                      evals = eigenvalues,
                      var_exp = (eigenvalues$evals/sum(eigenvalues$evals))*100)
eval_df <- eval_df %>% mutate(cum_var = cumsum(var_exp), 
                              var_exp_rounded = round(var_exp, 2),
                              cum_var_rounded = round(cum_var, 2),
                              var_exp_percent = sub("$", "%", var_exp_rounded),
                              cum_var_percent = sub("$", "%", cum_var_rounded))

head(eval_df)

# PC1 vs PC2 for CanPath by Province

p1 <- ggplot(merged_data_can_path) +
  geom_point(aes(x=PC1, y=PC2, color=PROVINCE)) +
  geom_point(aes(x=mean(PC1), y=mean(PC2)), color = "black", shape=1) +
  labs(title = "PC1 vs PC2 for CanPath Samples (by Province)",  
       x = paste("PC1: ", sprintf("%.2f%%", eval_df$var_exp_rounded[1]), 
                 " Variation", sep = ""), 
       y = paste("PC2: ", sprintf("%.2f%%", eval_df$var_exp_rounded[2]), 
                 " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p1)

# PC1 vs PC2 for CanPath by European and Unknown Ancestry

pca_subset_2 <- merged_data_can_path[merged_data_can_path$ANCESTRY %in% c("EUR", "UNKNOWN"), ]

p2 <- ggplot(pca_subset_2) +
  geom_point(aes(x=PC1, y=PC2, color=ANCESTRY)) +
  geom_point(aes(x=mean(PC1), y=mean(PC2)), color = "black", shape=1) +
  labs(title = "PC1 vs PC2 for CanPath Samples (EUR & UNKNOWN)",  
       x = paste("PC1: ", sprintf("%.2f%%", eval_df$var_exp_rounded[1]), 
                 " Variation", sep = ""), 
       y = paste("PC2: ", sprintf("%.2f%%", eval_df$var_exp_rounded[2]), 
                 " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p2)

### STEP 2: PLOT PCA ANALYSIS FROM CANPATH MERGED WITH 1KG

#Read in data

pca_results_2 <- read.table("1KG_CanPath_merged_PCA_PCs.eigenvec", header = FALSE)
colnames(pca_results_2) <- c("FID", "IID", paste("PC", 1:20, sep=""))

head(pca_results_2)

# Remove the 'FID' column

pca_results_2$FID <- NULL

# Rename the 'IID' column to 'ID'
names(pca_results_2)[names(pca_results_2) == "IID"] <- "ID"

head(pca_results_2)

phenotypes_2 <- read.csv("1KG_CanPath_Merged.csv", header = TRUE)

tail(phenotypes_2)

# Merging pca_results with phenotypes
# Keep only the rows with IDs that are present in the phenotypes dataframe

merged_data_can_path_2 <- merge(phenotypes_2, pca_results_2, by = "ID")

head(merged_data_can_path_2)

# The resulting merged_data dataframe will have one ID column, the 20 PC 
#columns from pca_results,
# and the additional columns from phenotypes (like age, sex, etc.)

# Reading in eigenvalues

eigenvalues_2 <- read.table("1KG_CanPath_merged_PCA_PCs.eigenval")
colnames(eigenvalues_2) <- "evals_2"

# Calculate variance explained for all 20 PCs

eval_df_2 <- data.frame(pc = sub("^", "PC", 1:nrow(eigenvalues_2)),
                      evals = eigenvalues_2,
                      var_exp = (eigenvalues_2$evals_2/sum(eigenvalues_2$evals_2))*100)
eval_df_2 <- eval_df_2 %>% mutate(cum_var = cumsum(var_exp), 
                              var_exp_rounded = round(var_exp, 2),
                              cum_var_rounded = round(cum_var, 2),
                              var_exp_percent = sub("$", "%", var_exp_rounded),
                              cum_var_percent = sub("$", "%", cum_var_rounded))

head(eval_df_2)

# PC1 vs PC2

p3 <- ggplot(merged_data_can_path_2) +
  geom_point(aes(x=PC1, y=PC2, color=ANCESTRY, shape=DATASET)) +
  geom_point(aes(x=mean(PC1), y=mean(PC2)), color = "black", shape=1) +
  labs(title = "PC1 vs PC2 for CanPath + 1KG Samples",  
       x = paste("PC1: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[1]), 
                 " Variation", sep = ""), 
       y = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]), 
                 " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p3)

# PC2 vs PC3

p4 <- ggplot(merged_data_can_path_2) +
  geom_point(aes(x=PC2, y=PC3, color=ANCESTRY, shape=DATASET)) +
  labs(title = "PC2 vs PC3 for CanPath + 1KG Samples",  
       x = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]), 
                 " Variation", sep = ""), 
       y = paste("PC3: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[3]), 
                 " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p4)

# PC3 vs PC4

p5 <- ggplot(merged_data_can_path_2) +
  geom_point(aes(x=PC3, y=PC4, color=ANCESTRY, shape=DATASET)) +
  labs(title = "PC3 vs PC4 for CanPath + 1KG Samples",  
       x = paste("PC3: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[3]), 
                 " Variation", sep = ""), 
       y = paste("PC4: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[4]), 
                 " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p5)

# Scree plot
# This plot shows the proportion of variance explained by each PC as well 
# as the cumulative variance explained by the first 10 PCs.

ggplot(eval_df_2[1:10,]) + 
  geom_col(aes(x = reorder(pc, -var_exp, sum), y = var_exp), colour = 'steelblue4', 
           fill = 'steelblue4') + 
  geom_line(data = eval_df_2[1:10,], aes(x = reorder(pc, -cum_var, sum), y = cum_var), 
            group = 1) + 
  geom_point(data = eval_df_2[1:10,], aes(x = pc, y = cum_var), size = 2) + 
  labs(title = "Scree Plot", x = "Principal Components", y = "% Variance Explained") + 
  geom_text(aes(x = pc, y = cum_var, label = cum_var_rounded, group = pc), size = 2, 
            position = position_stack(vjust = 1.1), angle = 40) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# Variance Explained Plot

ggplot(eval_df_2[1:10,]) + 
  geom_point(data = eval_df_2[1:10,], aes(x = reorder(pc, -var_exp, sum), 
                                          y = var_exp, group = pc), color='steelblue4') +
  geom_line(data = eval_df_2[1:10,], aes(x = reorder(pc, -var_exp, sum), 
                                         y = var_exp, group = 1), color='steelblue4') +
  labs(title = "Variance Explained", x = 'Principal Components', 
       y = 'Proportion of Variance Explained') +
  geom_text(aes(x = pc, y = var_exp, label = var_exp_rounded, group = pc), 
            size = 2, position = position_nudge(x=0.25, y=1)) + 
  theme_classic() + 
  theme(axis.title = element_text(), axis.text.x = element_text(angle = 70, hjust = 1))

# Like the Scree plot above, this shows the proportion of variance explained by each PC. 
# Using the elbow method, we see that the variance levels off at PC3. Since we are using this PCA for data visualization, 3 PCs is more than appropriate.
# This is similar to the elbow method in k-means clustering, which would suggest that k=3 clusters is optimal for our dataset should it be clusters rather than PCs.
# Below we plot the first 3 PCs in a scatter plot (can be rotated in R):

library(plotly)

p3d <- plot_ly(data = merged_data_can_path_2, 
               x = ~PC1, 
               y = ~PC2, 
               z = ~PC3, 
               color = ~ANCESTRY, 
               symbols = ~DATASET, 
               type = 'scatter3d', 
               mode = 'markers') %>%
  layout(title = "3D PCA Plot for PC1-PC3 in CanPath + 1KG Samples",
         scene = list(
           xaxis = list(title = paste("PC1: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[1]),
                                      " Variation", sep = "")),
           yaxis = list(title = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]),
                                      " Variation", sep = "")),
           zaxis = list(title = paste("PC3: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[3]), 
                                      " Variation", sep = ""))
         ))

# Print the plot

print(p3d)

### STEP3: ESTABLISH A RADIUS WHERE OUTLIERS WILL BE REMOVED

# Creating centroids, SDs, and Euclidean distances
PCA_CENTROIDS <- sapply(merged_data_can_path_2[,-(1:9)], mean)
PCA_SD <- sapply(merged_data_can_path_2[,-(1:9)], sd)
PCA_POINTS <- merged_data_can_path_2[,-(1:9)]
POINT_CENTROID_DISTANCES <- sqrt(apply((PCA_POINTS-PCA_CENTROIDS)^2, 
                                       MARGIN = 1, sum))

# Define the radius for the EUR circle (ex. 2 SD)

# Create a numeric sequence for the circle
t <- seq(0, 2 * pi, length.out = 100)

# Filter for EUR samples from the 1KG dataset
eur_samples_1KG <- merged_data_can_path_2[merged_data_can_path_2$ANCESTRY == "EUR" & 
                                            merged_data_can_path_2$DATASET == "1KG", ]

# Calculate the centroid for these samples
eur_centroids_1KG <- colMeans(eur_samples_1KG[, c("PC1", "PC2")])

# Ensure centroids are numeric
eur_centroids_1KG <- as.numeric(eur_centroids_1KG)

# Calculate standard deviation for EUR samples from the 1KG dataset only
eur_sd_1KG <- apply(eur_samples_1KG[, c("PC1", "PC2")], 2, sd)

# Now calculate the radius using the maximum standard deviation from these samples
radius_1KG <- 3 * max(eur_sd_1KG)  # Adjust the factor as needed

# Adjust the position of the label to the left of the circle
label_x_position <- eur_centroids_1KG[1] - 0.001  # Adjust the 0.01 
    # to move the label further to the left if needed
label_y_position <- eur_centroids_1KG[2] + radius_1KG + 0.001  # You may also adjust the 0.01 here 
    #for vertical positioning

# Now, let's plot the circle around the EUR samples
p6 <- ggplot(merged_data_can_path_2, aes(x = PC1, y = PC2)) +
  geom_point(aes(color = ANCESTRY, shape = DATASET)) +
  labs(title = "PC1 vs PC2 for CanPath + 1KG Samples", 
       x = paste("PC1: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[1]),
                 " Variation", sep = ""), 
       y = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]),
                 " Variation", sep = "")) +
  annotate("path", x = eur_centroids_1KG[1] + radius_1KG * cos(t), 
           y = eur_centroids_1KG[2] + radius_1KG * sin(t), 
           colour = "black", linetype = "dashed") +
  annotate("text", x = label_x_position, y = label_y_position, 
           label = "EUR cluster", hjust = 1, colour = "black") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

# Print the plot

print(p6)

# I chose the radius where all 1KG EUR samples were included (based on 
# previously published GWAS 3 SD seems a common radius choice)

# Now remove samples that are not located within the cluster

# Calculate the Euclidean distance from the centroid for each sample

merged_data_can_path_2$distance_from_centroid_1KG <- sqrt(
  (merged_data_can_path_2$PC1 - eur_centroids_1KG[1])^2 + 
    (merged_data_can_path_2$PC2 - eur_centroids_1KG[2])^2
)

# Filter the data to only include samples within the radius of the EUR cluster
within_eur_cluster <- merged_data_can_path_2[merged_data_can_path_2$distance_from_centroid_1KG <= radius_1KG, ]

within_eur_cluster <- within_eur_cluster[!within_eur_cluster$X1KG_SUBPOP %in% c("CLM", "MXL", "PUR"), ]

# Now you have a new data frame called 'within_eur_cluster' that only contains samples within the EUR cluster

head(within_eur_cluster)

# Fill in blank cells

# Replace blank cells with 'CanPath' and '1KG'
updated_eur_cluster <- within_eur_cluster %>%
  mutate(
    X1KG_SUBPOP = ifelse(X1KG_SUBPOP == "", "CanPath", X1KG_SUBPOP),
    PROVINCE = ifelse(PROVINCE == "", "1KG", PROVINCE)
  )

# PC1 vs PC2 for within EUR cluster

p7 <- ggplot(updated_eur_cluster) +
  geom_point(aes(x=PC1, y=PC2, color=PROVINCE)) +
  geom_point(aes(x=mean(PC1), y=mean(PC2)), color = "black", shape=1) +
  labs(title = "PC1 vs PC2 for CanPath + 1KG Samples within EUR cluster",  
       x = paste("PC1: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[1]), " Variation", sep = ""), 
       y = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]), " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p7)

p8 <- ggplot(updated_eur_cluster) +
  geom_point(aes(x=PC1, y=PC2, color=X1KG_SUBPOP)) +
  geom_point(aes(x=mean(PC1), y=mean(PC2)), color = "black", shape=1) +
  labs(title = "PC1 vs PC2 for CanPath + 1KG Samples within EUR cluster",  
       x = paste("PC1: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[1]), " Variation", sep = ""), 
       y = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]), " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p8)

# I used p8 to see where EUR country clusters were and highlighted these in PPT

nrow(updated_eur_cluster)

# PC2 vs PC3 and PC3 vs PC4 to see if we get separation of Quebec samples

p9 <- ggplot(updated_eur_cluster) +
  geom_point(aes(x=PC2, y=PC3, color=PROVINCE)) +
  geom_point(aes(x=mean(PC2), y=mean(PC3)), color = "black", shape=1) +
  labs(title = "PC2 vs PC3 for CanPath + 1KG Samples within EUR cluster",  
       x = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]), " Variation", sep = ""), 
       y = paste("PC3: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[3]), " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p9)

p10 <- ggplot(updated_eur_cluster) +
  geom_point(aes(x=PC2, y=PC3, color=X1KG_SUBPOP)) +
  geom_point(aes(x=mean(PC2), y=mean(PC3)), color = "black", shape=1) +
  labs(title = "PC2 vs PC3 for CanPath + 1KG Samples within EUR cluster",  
       x = paste("PC2: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[2]), " Variation", sep = ""), 
       y = paste("PC3: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[3]), " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p10)

p11 <- ggplot(updated_eur_cluster) +
  geom_point(aes(x=PC3, y=PC4, color=PROVINCE)) +
  geom_point(aes(x=mean(PC3), y=mean(PC4)), color = "black", shape=1) +
  labs(title = "PC3 vs PC4 for CanPath + 1KG Samples within EUR cluster",  
       x = paste("PC3: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[3]), " Variation", sep = ""), 
       y = paste("PC4: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[4]), " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p11)

p12 <- ggplot(updated_eur_cluster) +
  geom_point(aes(x=PC3, y=PC4, color=X1KG_SUBPOP)) +
  geom_point(aes(x=mean(PC3), y=mean(PC4)), color = "black", shape=1) +
  labs(title = "PC3 vs PC4 for CanPath + 1KG Samples within EUR cluster",  
       x = paste("PC3: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[3]), " Variation", sep = ""), 
       y = paste("PC4: ", sprintf("%.2f%%", eval_df_2$var_exp_rounded[4]), " Variation", sep = "")) + 
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

print(p12)

write.table(file = 'EUR_CanPath_Samples.txt', updated_eur_cluster, sep = "\t", quote = FALSE, row.names = FALSE)
