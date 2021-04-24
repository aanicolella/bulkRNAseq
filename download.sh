#!/usr/bin/bash

filename="parentDir/download.csv"

while IFS=,  read f1 f2 f3 f4 f5 f6
do
    mkdir -p parentDir/"$f1";
    wget --mirror --user userName --password passCode --no-check-certificate --cut-dirs 3 -P parentDir "$f3"
    mv parentDir/get.broadinstitute.org/${f3##*/}  parentDir/"$f1"
    
    wget --mirror --user userName --password passCode --no-check-certificate --cut-dirs 3 -P parentDir "$f4"
    mv parentDir/get.broadinstitute.org/${f4##*/}  parentDir/"$f1"
    
    wget --mirror --user userName --password passCode --no-check-certificate --cut-dirs 3 -P parentDir "$f5"
    mv parentDir/get.broadinstitute.org/${f5##*/}  parentDir/"$f1"
    
    wget --mirror --user userName --password passCode --no-check-certificate --cut-dirs 3 -P parentDir "$f6"
    mv parentDir/get.broadinstitute.org/${f6##*/}  parentDir/"$f1"
done < "$filename"

