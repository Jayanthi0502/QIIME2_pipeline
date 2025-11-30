# Metagenomics Pipeline
- Using QIIME2 to compare the metagenome of healthy individuals vs. patients with Major Depressive Disorder  
- The project ID used was **SRP233274**. It is a publicly available dataset on NCBI:  
  <https://www.ncbi.nlm.nih.gov/Traces/study/?acc=SRP233274>  
- The samples were downloaded using ENA Browser Tools on Linux.  

# System Requirements
- **Operating system**: Ubuntu (WSL2 on Windows)
- QIIME2 installed through Anaconda (conda environment)
- **32 GB RAM** for faster PICRUSt2 performance  
- **16 GB RAM** minimum required for QIIME2  
- **PICRUSt2 can run on 16 GB RAM** by decreasing the chunk size  

## Setting up QIIME2 
- The dataset we are using is amplicon sequencing data.
- Go to <https://docs.qiime2.org/2024.10/install/index.html> to download 2024.10 version of QIIME2.
- Click on "Install QIIME 2 within a conda environment" under "Natively installing QIIME 2" section.
- We will download the QIIME2-amplicon distribution. Choose the option "Windows (via WSL)"
- Copy the command into Ubuntu. This will create an environment called "qiime2-amplicon-2024.10"
## Downloading the data 
## Preprocessing 
## Running QIIME2 
### Visualization of results 
## Downstream analysis is this outline fine for QIIME2
