#!/usr/bin/bash

filename="/path/to/exampleDataOrganizationSheet.csv"

while IFS=,  read f1 f2 f3 f4 f5 f6
do
    mkdir -p $f2;
    cp $f3 $f2
    cp $f4 $f2
    cp $f5 $f2
    cp $f6 $f2 
done < "$filename"

