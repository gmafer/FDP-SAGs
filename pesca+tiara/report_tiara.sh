#!/bin/sh

DATA_DIR=data/clean/
OUT_FILE=data/clean/tiara_report_PACBIO_all.txt

for SAMPLE in $(ls ${DATA_DIR} | grep 'log')
do
  cat ${DATA_DIR}/${SAMPLE} | \
  grep -e 'archaea' -e 'bacteria' -e 'eukarya' -e 'organelle' -e 'unknown' | \
  awk -v var=${SAMPLE} '{print var$0}' OFS='\t' \
  >> ${OUT_FILE}
done
