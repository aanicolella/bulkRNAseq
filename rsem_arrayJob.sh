#!/bin/bash -l

INPUTSAMPLES=(HT1 HT2 HT3 KO1 KO2 KO3 WT1 WT2 WT3)
SAMPLENAME="${INPUTSAMPLES[$SGE_TASK_ID - 1]}"

#$ -cwd
#$ -q broad
#$ -l h_vmem=100g
#$ -l h_rt=48:00:00
#$ -t 1-numReps

reuse -q UGER
reuse -q Rsem
reuse -q Bowtie2
reuse -q Samtools
reuse -q R-3.5

rsem-calculate-expression -p 8  --bowtie2 --paired-end --estimate-rspd --append-names --sort-bam-by-coordinate /path/to/data/$SAMPLENAME/$SAMPLENAME.unmapped.1.fastq.gz /path/to/data/$SAMPLENAME/$SAMPLENAME.unmapped.2.fastq.gz /homeDir/references/mouse_gencode/mouse_gencode /path/to/data/$SAMPLENAME/$SAMPLENAME