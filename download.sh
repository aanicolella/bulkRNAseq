#!/usr/bin/bash

#$ -l h_vmem=64g
#$ -o /path/to/output/dir
#$ -l h_rt=06:00:00

wget --tries=10 --continue --mirror --user insertUserName --password insertPassword --no-check-certificate --cut-dirs 3 -P /path/to/output/rawData https://get.broadinstitute.org/pkgs/insertUserName/
