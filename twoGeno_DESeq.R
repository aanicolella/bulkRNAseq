# Variables to replace
    # EXP: name of experiment, usually the gene of interest
    # REGION: brain region you are studying
    # X, Y: number of replicates for each genotype

# load in libraries and path to data
library("DESeq2")
library("tximport")
filePath <- "/parentDir/REGION/"
sampleNames <- c()

# Set up metadata
    # model = genotype 
    # sample = individual sample name
colData = data.frame(model=c(rep(c("EXP_GENO"), X), rep(c("EXP_WT"), Y)),sample=sampleNames)
colData$model = relevel(colData$model, "EXP_WT")
files <- file.path(filePath, paste0(sampleNames, "/", sampleNames, ".genes.results"))
names(files) <- sampleNames
rsem.in <- tximport(files, type="rsem", txIn=FALSE, txOut=FALSE)

# Optional: find genes below expression threshhold. Create 'NA' data frame to re-add lowly expressed 
# genes for easier comparison between analyses.
drop <- rsem.in
drop$abundance <-
    drop$abundance[apply(drop$length,
                             1,
                             function(row) !all(row > 5)),]                              
drop$counts <-
  drop$counts[apply(drop$length,
                            1,
                             function(row) !all(row > 5)),]
drop$length <-
  drop$length[apply(drop$length,
                             1,
                             function(row) !all(row > 5)),]
                    
dropped <- drop$counts
dropRes <- data.frame(row.names=make.unique(row.names(drop$counts)), matrix(ncol=6, nrow=dim(drop$counts)[1]))
cols = c("baseMean", "log2FoldChange", "lfcSE", "stat", "pvalue", "padj")
colnames(dropRes) <- cols
geneName1 <- data.frame(do.call('rbind', strsplit(as.character(row.names(dropRes)), '_', fixed=TRUE)))
geneName1 <- geneName1["X2"]               
dropRes$symbol <- geneName1$X2

# Filter lowly expressed genes found above out of the main dataset for the DE analysis
rsem.in$abundance <-
  rsem.in$abundance[apply(rsem.in$length,
                             1,
                             function(row) all(row > 5 )),]
rsem.in$counts <-
  rsem.in$counts[apply(rsem.in$length,
                             1,
                             function(row) all(row > 5 )),]
rsem.in$length <-
  rsem.in$length[apply(rsem.in$length,
                             1,
                             function(row) all(row > 5 )),]
                       
# Convert data structure to proper format and run DESeq
dds <- DESeqDataSetFromTximport(rsem.in, colData, ~model)
dds <- DESeq(dds)
check <- estimateSizeFactors(dds)
norm <- counts(check, normalized=TRUE)
                       
# Combine normalized count dataframe with the 'NA' dataframe and save
all <- rbind(norm, dropped)                                          
geneName <- data.frame(do.call('rbind', strsplit(as.character(row.names(all)), '_', fixed=TRUE)))
geneName <- geneName["X2"]               
row.names(all) <- geneName$X2
all <- all[order(row.names(all)),]
head(all)
write.csv(all, "EXP_normalizedCounts.csv", row.names=TRUE)
                       
# Plot pca using different metadata conditions to see relationships between samples                   
pdf(file="EXP_pca.pdf")
vsdata <- vst(dds, blind=FALSE)
plotPCA(vsdata, intgroup="sample")
dev.off()
pdf(file="EXP_modelpca.pdf")
vsdata <- vst(dds, blind=FALSE)
plotPCA(vsdata, intgroup="model")
dev.off()
                       
# Extract DE results 
    # Currently set up such that the LFC directionality is in relation to the mutant: i.e. + lfc == 
    # upregulation in the mutant, - lfc == downregulation
res <- results(dds)
head(results(dds, tidy=TRUE), n=6)
summary(dds)

# Scale results using lfcShrink(): https://rdrr.io/bioc/DESeq2/man/lfcShrink.html
   # Combine post-shrinkage results with 'NA' dropped dataframe then write to .csv
res <- lfcShrink(dds=dds, coef=2, res=res, type="normal")
geneName <- data.frame(do.call('rbind', strsplit(as.character(row.names(res)), '_', fixed=TRUE)))
geneName <- geneName["X2"]               
res$symbol <- geneName$X2
resMerge <- rbind(res, dropRes)
dim(resMerge)
resMerge <- resMerge[order(resMerge$pvalue),]
write.csv(resMerge, "EXP-DESeq2_allGenes.csv")