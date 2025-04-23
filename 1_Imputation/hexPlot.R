# Since there are so many variants to vizualize, 
# a hex plot can be used
# Can learn more about the function here: 
# https://r-graph-gallery.com/100-high-density-scatterplot-with-binning.html

install.packages("usethis")

# sessionInfo() make sure you are running on an R version 3+ and 64-bit platform
library(usethis)
usethis::edit_r_environ() #increase the physical an virtual memory so that 
        #R_MAX_VSIZE=51200 MB

install.packages("hexbin")
library(hexbin)
install.packages("RColorBrewer")
library(RColorBrewer)

data <- read.table("merged_R2data.txt", header = TRUE)
head(data)
colnames(data) <- c("CHR", "POS", "MAF", "R2")
head(data)

x_min <- 0.001
data2 <- subset(data, AF >= x_min)

bin <- hexbin(data2$MAF, data2$R2, xbins = 100)
my_colors <- colorRampPalette(rev(brewer.pal(11, 'Spectral')))
plot(bin, main = "", colramp = my_colors, legend = FALSE,
     xlab = "AF", ylab = "R2")
