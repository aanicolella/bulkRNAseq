#!/bin/bash

fileList=()
sampleName=()

for i in "${!fileList[@]}"; do sed -i -e 's/^[ \t]*//' -e '/^$/d' "${fileList[i]}"; echo "${sampleName[i]}" >> path/to/REGION/output.csv; cut -d' ' -f1,2 "${fileList[i]}" 1<> "${fileList[i]}"; paste -s -d " " "${fileList[i]}" >> path/to/REGION/output.csv; done