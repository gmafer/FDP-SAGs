#!/bin/sh

mkdir -p data/clean/qbt_CLEANEST_filter1000/all_reports_CLEANEST_filter1000

DATA_DIR=data/clean/qbt_CLEANEST_filter1000/busco/
OUT_FILE=data/clean/qbt_CLEANEST_filter1000/all_reports_CLEANEST_filter1000/busco_report.txt

HEADERS_SAMPLE=$(ls ${DATA_DIR} | grep 'CLEANEST' | head -1)
HEADERS=$(cat ${DATA_DIR}/${HEADERS_SAMPLE}/short_summary.specific.eukaryota_odb10.${HEADERS_SAMPLE}.txt | grep -v '^#' | sed '/^$/d' | grep -v '%' | perl -pe 's/.*\d+\s+//' | tr '\n' '\t')

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

for SAMPLE in $(ls ${DATA_DIR} | grep 'CLEANEST')
do
  REPORT=$(cat ${DATA_DIR}/${SAMPLE}/short_summary.specific.eukaryota_odb10.${SAMPLE}.txt | \
  grep -v '^#' | perl -pe 's/^\n//' | awk '{print $1}' | tr '\n' '\t')
  echo -e "${SAMPLE}\t${REPORT}" >> ${OUT_FILE}
done



DATA_DIR=data/clean/qbt_CLEANEST_filter1000/tiara/
OUT_FILE=data/clean/qbt_CLEANEST_filter1000/all_reports_CLEANEST_filter1000/tiara_report.txt

for SAMPLE in $(ls ${DATA_DIR} | grep '^CLEANEST')
do
  cat ${DATA_DIR}/log_${SAMPLE} | \
  grep -e 'archaea' -e 'bacteria' -e 'eukarya' -e 'organelle' -e 'unknown' | \
  awk -v var=${SAMPLE} '{print var$0}' OFS='\t' \
  >> ${OUT_FILE}
done



DATA_DIR=data/clean/qbt_CLEANEST_filter1000/quast/
OUT_FILE=data/clean/qbt_CLEANEST_filter1000/all_reports_CLEANEST_filter1000/quast_report.txt

HEADERS_SAMPLE=$(ls ${DATA_DIR} | grep 'CLEANEST' | head -1)
HEADERS=$(cat ${DATA_DIR}/${HEADERS_SAMPLE}/transposed_report.tsv | head -1)

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

for SAMPLE in $(ls ${DATA_DIR} | grep '^CLEANEST')
do
  REPORT=$(cat ${DATA_DIR}/${SAMPLE}/transposed_report.tsv | tail -1)
  echo -e "${SAMPLE}\t${REPORT}" >> ${OUT_FILE}
done
