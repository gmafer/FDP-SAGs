#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=final_detail
#SBATCH --cpus-per-task=6
#SBATCH --mem=200G
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%3

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")
 
echo -e "SCAFFOLD\tLENGTH\tAUG_GUESSES\tegg_EUK\tegg_BACT\tTIARA\tKAIJU_nt_euk\tKAIJU_faa_euk\tKAIJU_nt_bact\tKAIJU_faa_bact" > data/clean/final_detail_summaries/${SAMPLE}_final_detail_summary.txt

 
for node in $(awk '{print $1}' data/clean/aug_gff_clean/${SAMPLE}_*_aug_gff_clean.txt | sort --version-sort -u);
do
 
 echo -e $node'\t' \
	$(echo $node | awk -F "_" '{print $4}')'\t' \
	$(grep -c $node data/clean/aug_gff_clean/${SAMPLE}_*_aug_gff_clean.txt)'\t' \
	$(grep -c $node data/clean/superjoins/euk/${SAMPLE}_euk_superjoin_version_sort.txt)'\t' \
	$(grep -c $node data/clean/superjoins/bact/${SAMPLE}_bact_superjoin_version_sort.txt)'\t' \
	$(grep $node ../seq1/data/clean/quast_busco_tiara/tiara_sel_scaff/${SAMPLE} | awk '{print $2}')'\t' \
	$(grep $node data/clean/aug+kaiju_joins_nt/${SAMPLE}_nt_aug+kaiju_join.txt | grep -c Euk)'\t' \
	$(grep $node data/clean/aug+kaiju_joins_faa/${SAMPLE}_faa_aug+kaiju_join.txt | grep -c Euk)'\t' \ 
	$(grep $node data/clean/aug+kaiju_joins_nt/${SAMPLE}_nt_aug+kaiju_join.txt | grep -c Bact) '\t' $(grep $node data/clean/aug+kaiju_joins_faa/${SAMPLE}_faa_aug+kaiju_join.txt | grep -c Bact) >> data/clean/final_detail_summaries/${SAMPLE}_final_detail_summary.txt
	
done
 
 
  







