#!/bin/bash

# Prepare Test Directory

PRJDIR=`pwd`
TESTDIR=${PRJDIR}/testlocal
BAK_DIR=${PRJDIR}/backup
WORKDIR=${PRJDIR}/work

# LOCKFILE="/tmp/`$basename $0`.lock"
# if [ -f $LOCKFILE ]; then
#   echo "Testing on local now."
#   exit -1
# fi
# trap "{
#   rm $LOCKFILE;
# }" EXIT
# touch $LOCKFILE

# Backup
rm -rf ${BAK_DIR}
mkdir ${BAK_DIR}
cp -rp attachments ${BAK_DIR}/attachments
cp -p *.html ${BAK_DIR}

# Prepar empty test directory
mkdir -p ${TESTDIR}
rsync -au --delete attachments/ ${TESTDIR}/attachments/
rm -f ${TESTDIR}/*.html

# rm -rf ${WORKDIR}
# mkdir -p ${WORKDIR}

cd ${PRJDIR}
for file in *.html; do
  echo "$file"
  sed -E 's| src="https://nii-gakunin-cloud.github.io/jdcat-analysis/attachments/| src="attachments/|g' ${file} > ${TESTDIR}/${file}
done

exit 0