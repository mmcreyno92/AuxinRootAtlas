# AuxinRootAtlas
Code repository for McReynolds et al., 2021

File Description:

`QuantSeq_dataprocess.slurm`  
Script for SLURM manager that was used to perform the QuantSeq data processing:  
- Trimming of raw reads using BBDUK
- Reads quality check using fastQC  
- Sequence alignment to TAIR10 annotation using STARaligner
- Indexing the alignment files using Samtools
- Extract transcript counts using HTSeq-count

`Transcriptomic_analysis_PoissonSeq.Rmd`  
R markdown script for root tissue and auxin treatment transcript differential expression analysis:
- Uses TMM normalization
- Uses PoissonSeq for differential expression  
Outputs html file containing diagnostic plots of the data

