# ===================================================
#  Install and Load DESeq2
# ===================================================
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("DESeq2")

library(DESeq2)

# ===================================================
#  Load Count Matrix and Metadata
# ===================================================
count_matrix <- read.table(
  "https://raw.githubusercontent.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/main/data/counts/merged_counts_matrix.tabular",
  header = TRUE, sep = "\t", row.names = 1
)

metadata <- read.table(
  "https://raw.githubusercontent.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/main/data/metadata/metadata_10.txt",
  header = TRUE, sep = "\t", row.names = 1
)

metadata$condition <- as.factor(metadata$condition)

# Sanity check
stopifnot(all(colnames(count_matrix) == rownames(metadata)))

# ===================================================
#  DESeq2 Analysis
# ===================================================
dds <- DESeqDataSetFromMatrix(
  countData = count_matrix,
  colData = metadata,
  design = ~ condition
)

# Filter out low count genes
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]

# Run DESeq2
dds <- DESeq(dds)

# Get DEGs and sort
res <- results(dds)
resOrdered <- res[order(res$padj), ]

# Remove rows with NA in padj or log2FoldChange
resOrdered <- resOrdered[!is.na(resOrdered$padj) & !is.na(resOrdered$log2FoldChange), ]

# Add significance column
resOrdered$significant <- ifelse(resOrdered$padj < 0.05 & abs(resOrdered$log2FoldChange) > 1, "yes", "no")

# Get only significant DEGs
res_sig <- resOrdered[resOrdered$significant == "yes", ]

# View top results
head(res_sig)

# Save to CSV
write.csv(as.data.frame(res_sig), "significant_DEGs.csv")
write.csv(as.data.frame(resOrdered), "deseq2_results.csv")

# Save up- and down-regulated genes
write.csv(subset(resOrdered, padj < 0.05 & log2FoldChange < -1), "downregulated_genes.csv")
write.csv(subset(resOrdered, padj < 0.05 & log2FoldChange > 1), "upregulated_genes.csv")

summary(res)
cat("Significant DEGs (padj < 0.05 & |log2FC| > 1):", 
    sum(res$padj < 0.05 & abs(res$log2FoldChange) > 1, na.rm = TRUE), "\n")
# ===================================================
# 📉 MA Plot
# ===================================================
png("ma_plot.png")
plotMA(res, ylim = c(-5, 5), main = "MA Plot")
dev.off()

# ===================================================
#  Volcano Plot (Simple + Labeled)
# ===================================================
library(ggplot2)
library(ggrepel)

res_df <- as.data.frame(resOrdered)
res_df$neglog10padj <- -log10(res_df$padj)
res_df$gene <- rownames(res_df)

# Simple volcano plot
ggplot(res_df, aes(x = log2FoldChange, y = neglog10padj)) +
  geom_point(aes(color = significant), alpha = 0.6) +
  scale_color_manual(values = c("no" = "grey", "yes" = "red")) +
  theme_bw() +
  labs(title = "Volcano Plot", x = "log2 Fold Change", y = "-log10 Adjusted P-value")

ggsave("volcano_plot_white.png", width = 6, height = 5)

# Volcano plot with top 30 DEGs labeled
top_genes <- head(res_df[res_df$significant == "yes" & !is.na(res_df$padj), ], 30)

ggplot(res_df, aes(x = log2FoldChange, y = neglog10padj)) +
  geom_point(aes(color = significant), alpha = 0.6) +
  scale_color_manual(values = c("no" = "grey", "yes" = "red")) +
  geom_text_repel(data = top_genes, aes(label = gene), size = 3.5, max.overlaps = 100) +
  theme_bw(base_size = 14) +
  labs(
    title = "Volcano Plot (Top 30 DEGs Labeled)",
    x = "log2 Fold Change",
    y = "-log10 Adjusted P-value"
  )

ggsave("volcano_plot_top30.png", width = 7, height = 6)

# ===================================================
#  PCA Plot
# ===================================================
vsd <- vst(dds, blind = TRUE)
pcaData <- plotPCA(vsd, intgroup = "condition", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

pca_plot <- ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, label = name)) +
  geom_point(size = 3) +
  geom_text_repel(size = 3) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  ggtitle("PCA Plot of All Samples") +
  theme_bw(base_size = 14)

ggsave("pca_plot_labeled.png", plot = pca_plot, width = 6, height = 5)

sink("session_info.txt")
sessionInfo()
sink()



# Confirm total number of genes analyzed
total_genes <- nrow(res)
cat("Total genes analyzed:", total_genes, "\n")

# Filter for significant DEGs
res_sig <- res[which(res$padj < 0.05 & abs(res$log2FoldChange) > 1), ]
num_sig_degs <- nrow(res_sig)
cat("Significant DEGs:", num_sig_degs, "\n")

# Count upregulated and downregulated genes
upregulated <- sum(res_sig$log2FoldChange > 1)
downregulated <- sum(res_sig$log2FoldChange < -1)
cat("Upregulated:", upregulated, "\n")
cat("Downregulated:", downregulated, "\n")

# Top 3 DEGs by lowest adjusted p-value
res_sig_sorted <- res_sig[order(res_sig$padj), ]
top3 <- head(res_sig_sorted, 3)
cat("Top 3 DEGs:\n")
print(top3)
