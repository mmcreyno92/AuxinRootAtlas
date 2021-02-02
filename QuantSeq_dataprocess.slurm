#!/bin/bash

#SBATCH --time=24:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=36   # 36 processor core(s) per node 
#SBATCH --job-name="QSdataProcess"
#SBATCH --mail-user=chrisfm@iastate.edu   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="QS_datproc_%j.out" # job standard output file (%j replaced by job id)
#SBATCH --error="QS_datproc_%j.err" # job standard error file (%j replaced by job id)

#Provide the file name for your quantseq results
raw_file=8_31525_01_1-A01-1_HFYCN_1728.tar #provide the filename from your quantseq results
STAR_index=STAR_index_TAIR10
annot_file=TAIR10.44.gtf

# LOAD MODULES
module load bbmap
module load fastqc
module load star
module load samtools
module load py-htseq

#create output directories
mkdir QC
mkdir counts
mkdir seq_files

#unzip and copy files to working dir
tar -xvf $raw_file
find . -name '*.gz' -exec cp {} seq_files/. \;
rm -rf seq_files/polyA.fa.gz
rm -rf seq_files/truseq_rna.fa.gz
rm -rf seq_files/undetermined*


#Sequence trimming using bbduk script from bbtools package
for fq in seq_files/*.gz;
do bbduk.sh in=$fq out=${fq/%fastq.gz/clean.fastq} ref=polyA.fa.gz,truseq_rna.fa.gz \
k=13 ktrim=r useshortkmers=tmink=5 qtrim=r trimq=10 minlength=20;
done

#Sequence QC using FastQC
for fq in seq_files/*.gz;
do fastqc -o QC -t 16 --nogroup $fq;
done
for fq in seq_files/*.fastq;
do fastqc -o QC -t 16 --nogroup $fq;
done

#Sequence read mapping using STARaligner
for fq in seq_files/*.fastq;
do \
STAR --runThreadN 16 --genomeDir $STAR_index \
--readFilesIn $fq --outFilterType BySJout \
--outFilterMultimapNmax 20 --alignSJoverhangMin 8 \
--alignSJDBoverhangMin 1 --outFilterMismatchNmax 999 \
--outFilterMismatchNoverLmax 0.6 --alignIntronMin 20 \
--alignIntronMax 1000000 --alignMatesGapMax 1000000 \
--outSAMattributes NH HI NM MD --outSAMtype BAM SortedByCoordinate \
--outFileNamePrefix ${fq/%clean.fastq/};
done

#indexing alignment files using samtools
for bam in seq_files/*.bam;
do samtoolsindex $bam;
done

#extracting counts using HTseq-count
i=0
for bam in seq_files/*.bam;
do printf -v nam '%s_%02d.txt' "counts" "$(( ++i ))";
#running HTSeq-count
htseq-count -m intersection-nonempty -s yes -f bam -r pos \
--idattr Parent $bam $annot_file > counts/$nam;
done

