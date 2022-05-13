# AuxinRootAtlas
Code repository for McReynolds et al., 2021

File Description:

`QuantSeq_dataprocess.slurm`  
Script for SLURM manager that was used to perform the QuantSeq data processing:  
- Trim raw reads using BBDUK
- Reads quality check using fastQC before and after trimming 
- Sequence alignment to B73v4 annotation using STARaligner
- Index the alignment files using Samtools
- Extract transcript counts using HTSeq-count

`Transcriptomic_analysis_PoissonSeq.Rmd`  
R markdown script for root tissue and auxin treatment transcript differential expression analysis:
- Uses TMM normalization
- Uses PoissonSeq for differential expression  
- Outputs html file containing diagnostic plots of the data

`30min_IAAvMock_upset_plot.R`
`120min_IAAvMock_upset_plot.R`
`Tissue_upset_plot.R`
R script for generating UpSet plots for characterizing overlapping and distinct sets of differentially expressed genes across samples
- Uses the UpSetR package
