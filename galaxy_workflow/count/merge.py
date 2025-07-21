import pandas as pd
import glob
import os

# Path to folder containing tabular files
folder_path = '/galaxy_workflow/count/merge.py'  

# Get all .tabular files
file_paths = glob.glob(os.path.join(folder_path, '*.tabular'))

# Initialize merged DataFrame
merged_df = None

for file_path in file_paths:
    # Use SRR filename (without extension) as column name
    sample_name = os.path.splitext(os.path.basename(file_path))[0]

    # Read file
    df = pd.read_csv(file_path, sep='\t')

    # Rename second column to sample name
    df.columns = ['Geneid', sample_name]

    # Merge
    if merged_df is None:
        merged_df = df
    else:
        merged_df = pd.merge(merged_df, df, on='Geneid')

# Save merged count matrix
output_path = os.path.join(folder_path, 'merged_counts_matrix.tsv')
merged_df.to_csv(output_path, sep='\t', index=False)

print(f'Merged file saved to: {output_path}')