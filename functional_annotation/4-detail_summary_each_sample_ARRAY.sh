#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=detail_summ
#SBATCH --cpus-per-task=6
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%3


SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")
 
echo -e "SCAFFOLD\tLENGTH\tGUESSES\tEUK\tBACT\tTIARA_SAYS" > data/clean/detail_summaries/${SAMPLE}_detail_summary.txt

 
for node in $(awk '{print $1}' data/clean/aug_gff_clean/${SAMPLE}_*_aug_gff_clean.txt | sort --version-sort -u);
do
 
 echo -e $node'\t' \
	$(echo $node | awk -F "_" '{print $4}')'\t' \
	$(grep -c $node data/clean/aug_gff_clean/${SAMPLE}_*_aug_gff_clean.txt)'\t' \
	$(grep -c $node data/clean/superjoins/euk/${SAMPLE}_euk_superjoin_version_sort.txt)'\t' \
	$(grep -c $node data/clean/superjoins/bact/${SAMPLE}_bact_superjoin_version_sort.txt)'\t' \
	$(grep $node ../seq1/data/clean/quast_busco_tiara/tiara_sel_scaff/${SAMPLE} | awk '{print $2}') >> data/clean/detail_summaries/${SAMPLE}_detail_summary.txt
	
done
 
 
  







