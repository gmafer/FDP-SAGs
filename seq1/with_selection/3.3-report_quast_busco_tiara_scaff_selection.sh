#!/bin/sh

DATA_DIR=seq1/data/clean/quast_busco_tiara/busco_sel/
OUT_FILE=seq1/data/clean/quast_busco_tiara/busco_sel/busco_sel_report.txt

HEADERS_SAMPLE=$(ls ${DATA_DIR} | grep 'GC' | head -1)
HEADERS=$(cat ${DATA_DIR}/${HEADERS_SAMPLE}/short_summary_*txt | grep -v '^#' | sed '/^$/d' | grep -v '%' | perl -pe 's/.*\d+\s+//' | tr '\n' '\t')

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

for SAMPLE in $(ls ${DATA_DIR} | grep run | cut -f2,3 -d'_')
do
  REPORT=$(cat ${DATA_DIR}/run_${SAMPLE}/short_summary_${SAMPLE}.txt | \
  grep -v '^#' | perl -pe 's/^\n//' | awk '{print $1}' | tr '\n' '\t')
  echo -e "${SAMPLE}\t${REPORT}" >> ${OUT_FILE}
done

DATA_DIR=seq1/data/clean/quast_busco_tiara/tiara_sel/
OUT_FILE=seq1/data/clean/quast_busco_tiara/tiara_sel/tiara_sel_report.txt


for SAMPLE in $(ls ${DATA_DIR} | grep '^GC')
do
  cat ${DATA_DIR}/log_${SAMPLE} | \
  grep -e 'archaea' -e 'bacteria' -e 'eukarya' -e 'organelle' -e 'unknown' | \
  awk -v var=${SAMPLE} '{print var$0}' OFS='\t' \
  >> ${OUT_FILE}
done

## reformat with R

#library(tidyverse)
#report <- read_tsv('seq1/data/clean/quast_busco_tiara/tiara_scff_mod/tiara_scff_mod_report.txt', col_names = c('Sample','Result'))

# Separate column and remove duplicated unknowns which come from the second part of tiara that outputs organelle origin

#new_report <- report %>% separate(Result, into = c('domain','contigs'), sep = ': ') %>% group_by(Sample, domain) %>% filter(contigs == max(contigs)) %>% pivot_wider(names_from= domain, values_from=contigs)
#write_tsv(new_report, 'seq1/data/clean/quast_busco_tiara/tiara_scff_mod/tiara_scff_mod_report_FORMAT.txt')

DATA_DIR=seq1/data/clean/quast_busco_tiara/quast_sel/
OUT_FILE=seq1/data/clean/quast_busco_tiara/quast_sel/quast_sel_report.txt

HEADERS_SAMPLE=$(ls ${DATA_DIR} | grep 'GC' | head -1)
HEADERS=$(cat ${DATA_DIR}/${HEADERS_SAMPLE}/transposed_report.tsv | head -1)

echo -e "Sample\t${HEADERS}" > ${OUT_FILE}

for SAMPLE in $(ls ${DATA_DIR} | grep '^GC')
do
  REPORT=$(cat ${DATA_DIR}/${SAMPLE}/transposed_report.tsv | tail -1)
  echo -e "${SAMPLE}\t${REPORT}" >> ${OUT_FILE}
done
