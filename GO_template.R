# Load required libraries
library(AnnotationHub)
library(clusterProfiler)

# Load organism information--mouse by default
    # use query(hub, "species") filling in which species you would like to see other species codes
hub<-AnnotationHub()
mm <- hub[["AH75743"]]


# variables to replace:
    # parentDir/REGION_AGE_All.csv: path to a csv file containing three columns
        # significant: genes that are significantly changed, regardless of directionality (usually
        # padj < 0.05)
        # upregulated: genes that are significantly changed with a positive logFC value, sometimes
        # includes a logFC threshold (i.e. logFC > 0.25)
        # downregulated: the same as upregulated but for negative logFC
    # REGION & AGE: replace to fit the descriptor of your analysis. Set as brain region and age 
        # for ease of use given the usual structuring of my datasets. 

AGE <- read.csv("parentDir/REGION_AGE_All.csv")
sample_all<- AGE$significant
res=bitr(sample_all,fromType="ENSEMBL",toType="ENTREZID",OrgDb=mm)
sample_all=res[,2]
xx1=enrichGO(sample_all,OrgDb=mm,keyType="ENTREZID",readable=T)
write.csv(xx1, "REGION/allAGE_REGION_GO.csv")

sample_up<- AGE$upregulated
resUp=bitr(sample_up,fromType="ENSEMBL",toType="ENTREZID",OrgDb=mm)
sample_up=resUp[,2]
xx2=enrichGO(sample_up,OrgDb=mm,keyType="ENTREZID",readable=T)
write.csv(xx2, "REGION/upAGE_REGION_GO.csv")

sample_down<- AGE$downregulated
resDown=bitr(sample_down,fromType="ENSEMBL",toType="ENTREZID",OrgDb=mm)
sample_down=resDown[,2]
xx3=enrichGO(sample_down,OrgDb=mm,keyType="ENTREZID",readable=T)
write.csv(xx3, "REGION/downAGE_REGION_GO.csv")