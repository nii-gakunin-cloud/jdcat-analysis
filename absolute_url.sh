#!/bin/bash

PRJDIR=`pwd`
TESTDIR=${PRJDIR}/testlocal
WORKDIR=${PRJDIR}/work

# LOCKFILE="/tmp/absolute_url.lock"
# if [ -f $LOCKFILE ]; then
#   echo "Testing on local now."
#   exit -1
# fi
# trap "{
#   rm $LOCKFILE;
# }" EXIT
# touch $LOCKFILE

rsync -au --delete ${TESTDIR}/attachments/ ${PRJDIR}/attachments/
rm -rf ${WORKDIR}
mkdir -p ${WORKDIR}
cd ${TESTDIR}
for file in *.html; do
  echo "$file"
  sed -E 's| src="attachments/| src="https://nii-gakunin-cloud.github.io/jdcat-analysis/attachments/|g' ${file} > ${WORKDIR}/${file}
  mv ${WORKDIR}/${file} ${PRJDIR}/${file}
done
cd ${PRJDIR}
rm -rf ${WORKDIR}

exit 0