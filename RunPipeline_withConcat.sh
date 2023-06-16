#! /bin/bash

#$ -cwd
#$ -e logs/bulkpipe.$TASK_ID.err
#$ -o logs/bulkpipe.$TASK_ID.log
#$ -q broad
#$ -l h_vmem=90g
#$ -l h_rt=120:00:00
#$ -l os="RedHat7"

#$ -t 20-50

source /broad/software/scripts/useuse

use UGER
use .samtools-1.8
use BEDTools
use Java-1.8
use .rsem-1.3.0
use Anaconda3
conda activate bulk_pipeline

SEEDFILE=/path/to/file/manifest.txt
outdir=/path/to/ouput_dir
#SEEDFILE=$1 ##sample sheet/manifest containing fastq information--tab seperated file with first column read1, second column read2, third column sample name (no spaces, etc in name), and each row is a sample
#outdir=$2 ##the directory the bams will be written to
read1=$(awk "NR==$SGE_TASK_ID" $SEEDFILE | awk '{print $1}')
read2=$(awk "NR==$SGE_TASK_ID" $SEEDFILE | awk '{print $2}')
sampname=$(awk "NR==$SGE_TASK_ID" $SEEDFILE | awk '{print $3}')

mkdir $outdir
mkdir $outdir/$sampname
outdir=$outdir/$sampname
cd $outdir


nextflow=/path/to/nextflow
pipeline=/path/to/pipeline
ref=/path/to/ref

$nextflow $pipeline --fq1 $read1 --fq2 $read2 --ref_comb $ref --outdir $outdir --isoMethod Salmon