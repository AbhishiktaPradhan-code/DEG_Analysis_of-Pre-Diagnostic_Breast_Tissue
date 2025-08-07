# Load libraries
library(ggplot2)
library(dplyr)
library(readr)

# Read in Enrichr results
KEGG_2021_Human_table <- read_tsv("https://raw.githubusercontent.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/refs/heads/main/results/%20Enrichr/KEGG_2021_Human_table.txt")
Reactome_Pathways_2024_table <- read_tsv("https://raw.githubusercontent.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/refs/heads/main/results/%20Enrichr/Reactome_Pathways_2024_table.txt")
WikiPathways_2024_Human_table <- read_tsv("https://raw.githubusercontent.com/AbhishiktaPradhan-code/DEG_Analysis_of-Pre-Diagnostic_Breast_Tissue/refs/heads/main/results/%20Enrichr/WikiPathways_2024_Human_table.txt")

# Select top 10 by adjusted p-value
top_kegg <- KEGG_2021_Human_table %>%
  arrange(`Adjusted P-value`) %>%
  slice_head(n = 10) %>%
  mutate(Source = "KEGG")

top_reactome <- Reactome_Pathways_2024_table %>%
  arrange(`Adjusted P-value`) %>%
  slice_head(n = 10) %>%
  mutate(Source = "Reactome")

top_WikiPathways <- WikiPathways_2024_Human_table %>%
  arrange(`Adjusted P-value`) %>%
  slice_head(n = 10) %>%
  mutate(Source = "WikiPathways")

# Combine all
combined_top <- bind_rows(top_kegg, top_reactome, top_WikiPathways)

colnames(combined_top)

combined_top <- combined_top %>%
  mutate(
    logFDR = -log10(`Adjusted P-value`),
    Term = factor(Term, levels = rev(unique(Term)))
  )


# Top 10 by -log10(adj p-value)
top_terms <- combined_top %>% 
  arrange(desc(logFDR)) %>%
  slice_head(n = 10)

ggplot(top_terms, aes(x = logFDR, y = reorder(Term, logFDR), fill = Source)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Top 10 Enriched Pathways",
    x = "-log10(Adjusted P-value)",
    y = "Pathway"
  ) +
  theme_minimal()

# Save the 'combined_top' enrichment results to CSV
write.csv(combined_top, "combined_top_enriched_pathways.csv", row.names = FALSE)


