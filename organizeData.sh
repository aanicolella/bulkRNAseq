#!/bin/bash -l

#$ -cwd
#$ -q broad
#$ -e parentDir
#$ -o parentDir
#$ -l h_vmem=64g

filename="/path/to/exampleDataOrganizationSheet.csv"

while IFS=,  read f1 f2 f3 f4 f5 f6 f7 f8
do
    mkdir -p "$f1";
    cat $f3 $f5 >> $f7
    cat $f4 $f6 >> $f8
done < "$filename"
