# Install required packages if not already installed
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("clusterProfiler")
BiocManager::install("AnnotationHub")

# Load required libraries
library(AnnotationHub)
library(clusterProfiler)

# Load organism information--mouse by default
    # use query(hub, "species") filling in which species you would like to see other species codes
hub<-AnnotationHub()
mm <- hub[["AH75743"]]

# variables to replace:
    # parentDir/REGION_AGE_All.csv: path to the DESeq output table for the experiment used in this analysis
    # REGION & AGE: replace to fit the descriptor of your analysis. Set as brain region and age 
        # for ease of use given the usual structuring of my datasets. 
AGE <- read.csv("parentDir/REGION_AGE_All.csv")
# upregulated: genes that are significantly changed with a positive logFC value, sometimes
        # includes a logFC threshold (i.e. logFC > 0.25)
sample_up<- AGE[AGE$pvalue < 0.05 & AGE$log2FoldChange > 0,]
resUp=bitr(sample_up$symbol,fromType="SYMBOL",toType="ENTREZID",OrgDb=mm)
sample_up=resUp[,2]
xx2=enrichGO(sample_up,OrgDb=mm,keyType="ENTREZID",readable=T)
write.csv(xx2, "REGION/upregulated_AGE_REGION_GO.csv")
# downregulated: the same as upregulated but for negative logFC
sample_down<- AGE[AGE$pvalue < 0.05 & AGE$log2FoldChange < 0,]
resDown=bitr(sample_down$symbol,fromType="SYMBOL",toType="ENTREZID",OrgDb=mm)
sample_down=resDown[,2]
xx3=enrichGO(sample_down,OrgDb=mm,keyType="ENTREZID",readable=T)
write.csv(xx3, "REGION/downregulated_AGE_REGION_GO.csv")
