#  Identifying Differentially Expressed Genes in Histologically Normal Breast Tissue Prior to Cancer Onset

##  Project Overview

This study aims to identify early transcriptional changes in histologically normal breast tissues of breast cancer patients versus controls. Using RNA-seq data and differential gene expression analysis.

This project analyzes RNA-seq data from 10 human samples (5 susceptible, 5 control) to identify differentially expressed genes (DEGs). The analysis was conducted using a Galaxy-based RNA-seq pipeline, followed by DESeq2 analysis in R.

---

##  RNA-Seq Workflow Overview

The RNA-seq analysis pipeline used in this project is illustrated below:

<img src="https://github.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/blob/main/image/RNA-seq%20Workflow%20(GSE166044%20Subset).png" alt="Analysis Workflow" height="400"/>

##  1. Dataset Selection

- **Source:** [GEO - Gene Expression Omnibus](https://www.ncbi.nlm.nih.gov/geo/)
- **Accession:** GSE166044  
- **SRA Project ID:** SRP304393

###  Selected Samples

| Sample ID      | Condition     |
| -------------- | ------------- |
| SRR13615479    | Susceptible   |
| SRR13615480    | Susceptible   |
| SRR13615481    | Susceptible   |
| SRR13615482    | Susceptible   |
| SRR13615483    | Susceptible   |
| SRR13615524    | Control       |
| SRR13615525    | Control       |
| SRR13615526    | Control       |
| SRR13615527    | Control       |
| SRR13615528    | Control       |

- Downloaded using Galaxy’s **Faster Download and Extract Reads in FASTQ** tool (paired-end `.fastq.gz`).

---

##  2. Preprocessing

### Tool: `fastp` (Galaxy Version)

- **Mode:** Paired-end
- **Settings:** Adapter trimming, quality filtering
- **Output:** Cleaned `.fastq` files
- All 10 sample pairs processed in a collection.

---

##  3. Alignment

### Tool: `HISAT2` (Galaxy Version 2.2.1+galaxy1)

- **Reference Genome:** Human (hg38 Canonical, built-in Galaxy index)
- **Strandness:** Unstranded
- **Input Format:** Paired-end FASTQ
- **Read Quality:** High-quality post-fastp

###  Alignment Summary:

- **Platform:** [UseGalaxy.org]
- **Result:** 100% of paired-end reads aligned for **all samples**  
- No re-alignment or filtering was needed.

---

##  4. Quantification

### Tool: `featureCounts` (Galaxy Version)

- **Reference Annotation:** GTF file corresponding to hg38
- **Strandness:** Unstranded
- **Paired-end:** Yes
- **GTF Feature Type:** Exon
- **Attribute:** Gene ID
- **Output:** Raw read counts (`.tabular` files per sample)

###  Combined Output

- Individual count files were downloaded and merged into a single matrix (`.tsv` and `.tabular`)  
- Used as input for DESeq2 analysis in R.

---

## 5. Differential Expression Analysis

### Tool: `DESeq2` (in R)

- Input: Combined raw count matrix + metadata
- **Design Formula:** `~ condition`
- **Comparisons:** Susceptible vs Control
- **Output:**  
  - Normalized counts  
  - MA plot, Volcano plot ,PCA plot 
  - DEGs with adjusted p-value (FDR) < 0.05  
  
---

## 📌 Summary

| Step             | Tool (Platform)            | Output                            |
|------------------|----------------------------|-----------------------------------|
| Download         | SRA Toolkit (Galaxy)       | FASTQ (paired-end)                |
| Preprocessing    | fastp                      | Cleaned FASTQ                     |
| Alignment        | HISAT2                     | BAM (aligned reads)               |
| Counting         | featureCounts              | Raw gene counts                   |
| DEG Analysis     | DESeq2 (R)                 | Differential expression results   |

---


---


##  Tools Summary

| Tool            | Purpose                      |
|-----------------|------------------------------|
| fastp           | Read trimming & QC           |
| HISAT2          | Alignment                    |
| featureCounts   | Gene-level quantification    |
| DESeq2 (R)      | Differential expression      |
| Galaxy          | Workflow-based processing    |

---

##  Exploratory Data Analysis (EDA)

###  MA Plot

<img src="https://github.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/blob/main/results/plots/MA%20Plot.png" width="500"/>

The MA plot displays the log2 fold change versus the average gene expression (mean normalized counts). Most genes are clustered around a log2FC of 0, indicating no differential expression. A subset of genes stands out with significant upregulation or downregulation (highlighted in blue), reflecting strong transcriptional changes between the susceptible and control groups.

---

###  Volcano Plot

<img src="https://github.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/blob/main/results/plots/volcano_plot_top30.png" width="500"/>


The volcano plot visualizes the distribution of genes based on their –log10 adjusted p-value (y-axis) and log2 fold change (x-axis). Genes that are both highly significant and strongly differentially expressed appear at the corners of the plot. The top 30 genes with the lowest adjusted p-values are highlighted, showing a balanced mix of upregulated and downregulated genes.

---

###  PCA Plot

<img src="https://github.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/blob/main/results/plots/pca_plot_labeled.png" width="500"/>

Principal Component Analysis (PCA) shows a clear separation between control and susceptible samples, with PC1 explaining 79% of the total variance. Samples cluster tightly by condition, suggesting high within-group consistency and strong condition-driven transcriptomic differences. This supports the biological validity of the differential expression analysis.
