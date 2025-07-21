# FeatureCounts Notes

**Tool:** featureCounts (Galaxy Version 2.0.1)  
**Platform:** UseGalaxy.org 
**Total Samples:** 10 (5 susceptible, 5 control)  

---

## Reference Annotation

- **Annotation Source:** Built-in GTF annotation (Galaxy)
- **Genome:** Human (hg38)
- **Annotation Format:** GTF
- **Annotation Type:** Gene-level counting

---

## Input

- **Input Type:** BAM files from HISAT2 output  
- **Read Type:** Paired-end  
- **Library Type / Strandness:** Unstranded  
- **GTF Feature Type Filter:** `exon`  
- **GTF Attribute Type for Gene ID:** `gene_id`

---

## Parameters Used

- **Paired-End Reads:** Yes  
- **Count Fragments Instead of Reads:** Yes (suitable for paired-end)  
- **Multi-mapping Reads:** Excluded (default)  
- **Chimeric Fragments:** Not counted  
- **Minimum Mapping Quality:** Default  
- **Minimum Overlap:** Default

---

## Output

- **Output File Format:** Tabular count matrix (`featureCounts output`)  
- **Gene IDs:** Used from GTF file  
- **Rows:** Genes  
- **Columns:** Samples (counts for each sample)

---

## Post-processing

- The individual sample count files were downloaded and combined into a unified **`.tsv` and `.tabular`** matrix on local machine.
- This combined count matrix was used as input for **differential gene expression analysis** using **DESeq2 in R**.

---

## Summary

featureCounts successfully generated a raw gene expression matrix for all 10 samples.  
The output matrix served as the foundation for downstream DGE analysis in R.