#!/bin/bash

WORKDIR=work
mkdir -p ${WORKDIR}
cd ${WORKDIR}
ln -nsf ../styles .
ln -nsf ../images .
ln -nsf ../attachments .
cd ..

for file in *.html; do
  echo "$file"
  sed -E 's| src="attachments/| src="https://nii-gakunin-cloud.github.io/jdcat-analysis/attachments/|g' ${file} > ${file}.tmp1
  sed -E 's| src="images/| src="https://nii-gakunin-cloud.github.io/jdcat-analysis/images/|g' ${file}.tmp1 > ${file}.tmp2
  sed -E 's| href="styles| href="https://nii-gakunin-cloud.github.io/jdcat-analysis/styles/|g' ${file}.tmp2 > ${WORKDIR}/${file}
  rm -f ${file}.tmp1 ${file}.tmp2
done
