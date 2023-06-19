#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=grep_remove_scaff
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1

#================================================

grep bacteria ../ramon_selection/data/clean/qbt/tiara/ramon_sel | awk '{print $1}' > data/clean/ramon_sel_toremove.txt 
grep archaea ../ramon_selection/data/clean/qbt/tiara/ramon_sel | awk '{print $1}' >> data/clean/ramon_sel_toremove.txt

module load seqkit
seqkit grep \
 -v ../ramon_selection/GC1003827_A03_selected_scaffolds.fasta \
 -f data/clean/ramon_sel_toremove.txt > data/clean/GC1003827_A03_selected_scaffolds_tiara_clean.fasta




