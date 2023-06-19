#!/bin/sh

DATA_DIR=data/clean/qbt/busco/cons_un/
OUT_FILE=data/clean/qbt/all_reports/busco_report.txt

HEADERS_SAMPLE=$(ls ${DATA_DIR} | grep 'euk' | head -1)
HEADERS=$(cat ${DATA_DIR}/${HEADERS_SAMPLE}/*txt | grep -v '^#' | sed '/^$/d' | grep -v '%' | perl -pe 's/.*\d+\s+//' | tr '\n' '\t')

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

for SAMPLE in $(ls ${DATA_DIR} | grep run | cut -f2,3 -d'_')
do
  REPORT=$(cat ${DATA_DIR}/run_${SAMPLE}/short_summary.txt | \
  grep -v '^#' | perl -pe 's/^\n//' | awk '{print $1}' | tr '\n' '\t')
  echo -e "${SAMPLE}\t${REPORT}" >> ${OUT_FILE}
done



DATA_DIR=data/clean/qbt/tiara/
OUT_FILE=data/clean/qbt/all_reports/tiara_report.txt

for SAMPLE in $(ls ${DATA_DIR} | grep '^log')
do
  cat ${DATA_DIR}/${SAMPLE} | \
  grep -e 'archaea' -e 'bacteria' -e 'eukarya' -e 'organelle' -e 'unknown' | \
  awk -v var=${SAMPLE} '{print var$0}' OFS='\t' \
  >> ${OUT_FILE}
done



DATA_DIR=data/clean/qbt/quast/cons_un/
OUT_FILE=data/clean/qbt/all_reports/quast_report.txt

#HEADERS_SAMPLE=$(ls ${DATA_DIR} | head -1)
HEADERS=$(cat ${DATA_DIR}/transposed_report.tsv | head -1)

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

REPORT=$(cat ${DATA_DIR}/transposed_report.tsv | tail -1)
echo -e "X\t${REPORT}" >> ${OUT_FILE}

