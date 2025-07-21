import pandas as pd
import glob
import os

# Path to folder containing .tabular files — CHANGE THIS
folder_path = ' /galaxy_workflow/count'

# Get all .tabular files
file_paths = sorted(glob.glob(os.path.join(folder_path, '*.tabular')))

# Initialize merged DataFrame
merged_df = None

for file_path in file_paths:
    # Extract sample name from filename 
    sample_name = os.path.splitext(os.path.basename(file_path))[0]

    # Read the file
    df = pd.read_csv(file_path, sep='\t', usecols=[0, 1], dtype={0: str})

    # Rename second column to sample name
    df.columns = ['Geneid', sample_name]

    # Merge on Geneid
    if merged_df is None:
        merged_df = df
    else:
        merged_df = pd.merge(merged_df, df, on='Geneid', how='outer')

# Sort rows by Geneid

merged_df = merged_df.sort_values(by='Geneid')

#  Save as .tabular file
output_path = os.path.join(folder_path, 'merged_counts_matrix.tabular')
merged_df.to_csv(output_path, sep='\t', index=False)

print(f'Merged count matrix saved to:\n{output_path}')