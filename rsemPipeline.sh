#!/bin/bash -l

#$ -cwd
#$ -q broad
#$ -l h_vmem=100g
#$ -e parentDir/sample/sample.err
#$ -o parentDir/sample/sample.out
#$ -l h_rt=48:00:00

reuse -q UGER
reuse -q Rsem
reuse -q Bowtie2
reuse -q Samtools
reuse -q R-3.5

rsem-calculate-expression -p 8  --bowtie2 --paired-end --estimate-rspd --append-names --sort-bam-by-coordinate parentDir/sample/sample.unmapped.1.fastq.gz parentDir/sample/sample.unmapped.2.fastq.gz homeDir/references/mouse_gencode/mouse_gencode parentDir/sample/sample
