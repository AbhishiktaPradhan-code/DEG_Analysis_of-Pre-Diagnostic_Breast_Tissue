## Summary of FASTP Quality Control (QC)

FASTP was used to perform quality filtering, adapter trimming, and duplication estimation on the raw FASTQ files. Below is a summary of key QC metrics across all 10 samples.

| Metric | Description |
|--------|-------------|
| `pct_duplication` | Percentage of duplicate reads (higher may indicate PCR bias) |
| `q30_rate` | Percentage of bases with Q ≥ 30 (higher = better sequencing quality) |
| `gc_content` | GC content after filtering, should be relatively consistent across samples |
| `pct_surviving` | Percentage of reads retained after filtering (ideally >90%) |
| `pct_adapter` | Percentage of reads where adapters were detected and trimmed |

### Key Observations

- All samples show high-quality sequencing with **Q30 > 88%**.
- **Duplication rates** are slightly higher in control samples (~22–27%) compared to susceptible samples (~16–21%), which may reflect sequencing or library prep variability.
- Adapter content is low across all samples (<0.03%), indicating effective adapter trimming.
- **GC content** is consistent (~47–49%) across samples, indicating no major bias.
- **Read survival rates** after filtering are very high (>96% for most), confirming minimal filtering loss.

### QC Conclusion

The FASTQ data is of good quality and suitable for downstream analysis.