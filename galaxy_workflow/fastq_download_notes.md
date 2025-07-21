# FASTQ Download Notes

##  Dataset: GSE166044  
- **Title:** Whole transcriptome analysis of breast tissues prior to breast cancer diagnosis  
- **Organism:** *Homo sapiens*  
- **Source:** Gene Expression Omnibus (GEO)  
- **GEO Accession:** [GSE166044](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE166044)  
- **SRA Project ID:** SRP304393  

##  Project Aim  
To identify differentially expressed genes (DEGs) between histologically normal pre-diagnostic (“susceptible”) and healthy control breast tissues in bulk RNA-seq data.

##  Sample Selection  
- The full dataset includes 90 samples (15 susceptible vs 15 control, each with multiple technical replicates).
- I selected **10 representative SRR samples** (5 susceptible and 5 control) for this initial analysis due to computational constraints.

###  Selected Samples

| Sample ID      | Condition     |
|----------------|---------------|
| SRR13615479     | Susceptible   |
| SRR13615480     | Susceptible   |
| SRR13615481     | Susceptible   |
| SRR13615482     | Susceptible   |
| SRR13615483     | Susceptible   |
| SRR13615524     | Control       |
| SRR13615525     | Control       |
| SRR13615526     | Control       |
| SRR13615527     | Control       |
| SRR13615528     | Control       |

##  FASTQ Download Details  
- **Tool Used:** *Faster Download and Extract Reads in FASTQ* (Galaxy)
- **Input:** 10 SRA Run IDs from SRP304393  
- **Output:** Paired-end FASTQ files for each sample  
- **Compression:** GZIP  

##  Notes  
- Download was successful for all selected runs.
- Downloaded files were automatically split into forward and reverse reads.

