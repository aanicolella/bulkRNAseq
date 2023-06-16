#!/bin/bash -l

#$ -cwd
#$ -q broad
#$ -e parentDir
#$ -o parentDir
#$ -l h_vmem=64G
#$ -l h_rt=04:00:00

filename="/path/to/exampleDataOrganizationSheet.csv"

while IFS=,  read f1 f2 f3 f4 f5 f6 f7 f8 f9
do
    mv $f2 $f6
    mv $f3 $f7
    mv $f4 $f8
    mv $f5 $f9
done < "$filename"
