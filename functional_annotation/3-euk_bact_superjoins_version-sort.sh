#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=version_sort_superjoins
#SBATCH --cpus-per-task=6
#SBATCH --mem=50G
#SBATCH --ntasks-per-node=1

DATA_DIR='data/clean/'

OUT_DIR='data/clean/superjoins/'

for SAMPLE in $(cat ${DATA_DIR}/samples_file_69.txt); \
do 

 awk '{print $1"\t"$9}' data/clean/aug_gff_clean/${SAMPLE}_*_aug_gff_clean.txt > ${OUT_DIR}/${SAMPLE}_file1_temp.txt
 
 awk '{print $1"\t"$2}' data/clean/eggnog_full_annot_clean/${SAMPLE}_*_full_annot_clean.txt | sed 's/.*_g/g/g' | sed 's/.t1//g' | awk '{print $2"\t"$1}' > ${OUT_DIR}/${SAMPLE}_file2_temp.txt


 sort -k2 ${OUT_DIR}/${SAMPLE}_file1_temp.txt > ${OUT_DIR}/${SAMPLE}_file1_temp_sorted.txt
 sort -k2 ${OUT_DIR}/${SAMPLE}_file2_temp.txt > ${OUT_DIR}/${SAMPLE}_file2_temp_sorted.txt


 join -j 2 ${OUT_DIR}/${SAMPLE}_file1_temp_sorted.txt ${OUT_DIR}/${SAMPLE}_file2_temp_sorted.txt > ${OUT_DIR}/${SAMPLE}_temp_superjoin.txt


 rm ${OUT_DIR}/${SAMPLE}_file*_temp.txt
 rm ${OUT_DIR}/${SAMPLE}_file*_temp_sorted.txt


 grep -wf data/clean/db2/euk_uniq.txt ${OUT_DIR}/${SAMPLE}_temp_superjoin.txt > ${OUT_DIR}/euk/${SAMPLE}_euk_superjoin_bad_sort.txt
 grep -wf data/clean/db2/bact_uniq.txt ${OUT_DIR}/${SAMPLE}_temp_superjoin.txt > ${OUT_DIR}/bact/${SAMPLE}_bact_superjoin_bad_sort.txt


 for f in ${OUT_DIR}/euk/${SAMPLE}_euk_superjoin_bad_sort.txt; 
 	do sed -i "s/$/\teuk/g" $f; 
 done

 for f in ${OUT_DIR}/bact/${SAMPLE}_bact_superjoin_bad_sort.txt; 
 	do sed -i "s/$/\tbact/g" $f; 
 done

 sort --version-sort data/clean/superjoins/euk/${SAMPLE}_euk_superjoin_bad_sort.txt > ${OUT_DIR}/euk/${SAMPLE}_euk_superjoin_version_sort.txt

 sort --version-sort data/clean/superjoins/bact/${SAMPLE}_bact_superjoin_bad_sort.txt > ${OUT_DIR}/bact/${SAMPLE}_bact_superjoin_version_sort.txt
 
 rm ${OUT_DIR}/euk/*_superjoin_bad_sort.txt
 rm ${OUT_DIR}/bact/*_superjoin_bad_sort.txt
 rm ${OUT_DIR}/${SAMPLE}_temp_superjoin.txt


done;

