#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=table_build_joins
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=300G
#SBATCH --output=data/logs/table_build_joins_%A_%a.out
#SBATCH --error=data/logs/table_build_joins_%A_%a.err
#SBATCH --array=1-69%3


SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")


mkdir -p temp_file

TF=temp_file

cat data/clean/final_detail_summaries/${SAMPLE}_final_detail_summary.txt | sed 1d > ${TF}/${SAMPLE}_f11.txt


awk -F"\t" -v OFS="\t" '{
       for (i=1;i<=NF;i++) {
         if ($i == "") $i="NA"
       }
       print $0
 }' ${TF}/${SAMPLE}_f11.txt > ${TF}/${SAMPLE}_f11_na.txt


cat data/clean/eukrep/${SAMPLE}_nodes_euk.txt > ${TF}/${SAMPLE}_f2.txt

grep -E "length_[3-9][0-9][0-9][0-9]" data/clean/eukrep_backup/${SAMPLE}_nodes_proc.txt > ${TF}/${SAMPLE}_f33.txt


sort -f ${TF}/${SAMPLE}_f11_na.txt > ${TF}/${SAMPLE}_s1
sort -f ${TF}/${SAMPLE}_f2.txt > ${TF}/${SAMPLE}_s2
sort -f ${TF}/${SAMPLE}_f33.txt > ${TF}/${SAMPLE}_s3


join ${TF}/${SAMPLE}_s1 ${TF}/${SAMPLE}_s2 -a1 > ${TF}/${SAMPLE}_join1
join ${TF}/${SAMPLE}_join1 ${TF}/${SAMPLE}_s3 -a1 > ${TF}/${SAMPLE}_join2 

sort --version-sort ${TF}/${SAMPLE}_join2 > ${TF}/${SAMPLE}_fin


awk -F"\t" -v OFS="\t" '{
       for (i=1;i<=NF;i++) {
         if ($i == "") $i="NA"
       }
       print $0
 }' ${TF}/${SAMPLE}_fin > ${TF}/${SAMPLE}_finna 

sed -E 's/(.*[0-9]{1,}$)/\1 NA/' ${TF}/${SAMPLE}_finna > ${TF}/${SAMPLE}_ara

################################################################################

awk -F "\t" '{print $1"\t"$6}' data/clean/scaffolds_CAT_output/${SAMPLE}/CAT.full.bin.688.CATdb.official_names.txt | sort --version-sort | sed 's/:.*$//g' > ${TF}/${SAMPLE}_nsg.txt

join ${TF}/${SAMPLE}_ara ${TF}/${SAMPLE}_nsg.txt | sed 's/no support/no_support/g' | sed 's/ $/&NA/' > ${TF}/${SAMPLE}_arasi

echo -e "SCAFFOLD\tLENGTH\tAUG_GUESSES\tegg_EUK\tegg_BACT\tTIARA\tKAIJU_nt_euk\tKAIJU_faa_euk\tKAIJU_nt_bact\tKAIJU_faa_bact\tEukRep\tCAT" | cat - ${TF}/${SAMPLE}_arasi > ${TF}/${SAMPLE}_arasihdr

#rm temp_file/*
