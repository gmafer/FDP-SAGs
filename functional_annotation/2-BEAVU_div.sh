#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=beavu_div
#SBATCH --cpus-per-task=6
#SBATCH --mem=50G
#SBATCH --ntasks-per-node=1


DATA_DIR="data/clean"


for SAMPLE in $(cat ${DATA_DIR}/samples_file_69.txt)
do

grep -wf ${DATA_DIR}/db2/euk_uniq.txt data/clean/eggnog_full_annot_clean/${SAMPLE}_*_full_annot_clean.txt | \
 grep -wvf ${DATA_DIR}/db2/bact_uniq.txt | \
 grep -wvf ${DATA_DIR}/db2/AV_uniq.txt > ${DATA_DIR}/BEAVU/euk/${SAMPLE}_euk.txt


grep -wvf ${DATA_DIR}/db2/euk_uniq.txt data/clean/eggnog_full_annot_clean/${SAMPLE}_*_full_annot_clean.txt | \
 grep -wf ${DATA_DIR}/db2/bact_uniq.txt | \
 grep -wvf ${DATA_DIR}/db2/AV_uniq.txt > ${DATA_DIR}/BEAVU/bact/${SAMPLE}_bact.txt


grep -wvf ${DATA_DIR}/db2/euk_uniq.txt data/clean/eggnog_full_annot_clean/${SAMPLE}_*_full_annot_clean.txt | \
 grep -wvf ${DATA_DIR}/db2/bact_uniq.txt | \
 grep -wf ${DATA_DIR}/db2/AV_uniq.txt > ${DATA_DIR}/BEAVU/av/${SAMPLE}_av.txt


grep -wvf ${DATA_DIR}/db2/euk_uniq.txt data/clean/eggnog_full_annot_clean/${SAMPLE}_*_full_annot_clean.txt | \
 grep -wvf ${DATA_DIR}/db2/bact_uniq.txt | \
 grep -wvf ${DATA_DIR}/db2/AV_uniq.txt > ${DATA_DIR}/BEAVU/unkn/${SAMPLE}_unkn.txt 

done


wc -l ${DATA_DIR}/BEAVU/euk/* | sed 's|data/clean/BEAVU/euk/||g' > ${DATA_DIR}/BEAVU/reports/euk_report.txt
wc -l ${DATA_DIR}/BEAVU/bact/* | sed 's|data/clean/BEAVU/bact/||g' > ${DATA_DIR}/BEAVU/reports/bact_report.txt
wc -l ${DATA_DIR}/BEAVU/av/* | sed 's|data/clean/BEAVU/av/||g' > ${DATA_DIR}/BEAVU/reports/av_report.txt
wc -l ${DATA_DIR}/BEAVU/unkn/* | sed 's|data/clean/BEAVU/unkn/||g' > ${DATA_DIR}/BEAVU/reports/unkn_report.txt
