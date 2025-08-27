#!/bin/bash

WORKDIR=testlocal
mkdir -p ${WORKDIR}
cd ${WORKDIR}
ln -nsf ../styles .
ln -nsf ../images .
ln -nsf ../attachments .
cd ..

for file in *.html; do
  echo "$file"
  sed -E 's| src="https://nii-gakunin-cloud.github.io/jdcat-analysis/attachments/| src="attachments/|g' ${file} > ${file}.tmp1
  sed -E 's| src="https://nii-gakunin-cloud.github.io/jdcat-analysis/images/| src="images/|g' ${file}.tmp1 > ${file}.tmp2
  sed -E 's| href="https://nii-gakunin-cloud.github.io/jdcat-analysis/styles/| href="styles|g' ${file}.tmp2 > ${WORKDIR}/${file}
  rm -f ${file}.tmp1 ${file}.tmp2
done
