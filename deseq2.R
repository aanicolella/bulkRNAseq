library("DESeq2")
library("tximport")
filePath <- "/parentDir/REGION/"
sampleNames <- c()

colData = data.frame(model=c(rep(c("GENE_GENO"), 5), rep(c("GENE_WT"), 5)),sample=sampleNames)
colData$model = relevel(colData$model, "GENE_WT")
files <- file.path(filePath, paste0(sampleNames, "/", sampleNames, ".genes.results"))
names(files) <- sampleNames
rsem.in <- tximport(files, type="rsem", txIn=FALSE, txOut=FALSE)

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

dds <- DESeqDataSetFromTximport(rsem.in, colData, ~model)
dds <- DESeq(dds)
 
check <- estimateSizeFactors(dds)
norm <- counts(check, normalized=TRUE)
all <- rbind(norm, dropped)
                                             
geneName <- data.frame(do.call('rbind', strsplit(as.character(row.names(all)), '_', fixed=TRUE)))
geneName <- geneName["X2"]               
row.names(all) <- geneName$X2
all <- all[order(row.names(all)),]
head(all)

write.csv(all, "EXP_normalizedCounts.csv", row.names=TRUE)
                       
pdf(file="EXP_pca.pdf")
vsdata <- vst(dds, blind=FALSE)
plotPCA(vsdata, intgroup="sample")
dev.off()
pdf(file="EXP_modelpca.pdf")
vsdata <- vst(dds, blind=FALSE)
plotPCA(vsdata, intgroup="model")
dev.off()

res <- results(dds)
head(results(dds, tidy=TRUE), n=6)
summary(dds)
                         
res <- lfcShrink(dds=dds, coef=2, res=res, type="normal")
geneName <- data.frame(do.call('rbind', strsplit(as.character(row.names(res)), '_', fixed=TRUE)))
geneName <- geneName["X2"]               
res$symbol <- geneName$X2

resMerge <- rbind(res, dropRes)
dim(resMerge)
resMerge <- resMerge[order(resMerge$pvalue),]
write.csv(resMerge, "EXP-DESeq2_allGenes.csv")