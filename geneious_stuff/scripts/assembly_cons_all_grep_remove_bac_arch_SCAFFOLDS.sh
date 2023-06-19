#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=grep_remove_scaff
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1

#================================================

grep bacteria ../assembly_consensus_all/data/clean/qbt/tiara/all_cons | awk '{print $1}' > data/clean/all_cons_toremove.txt 
grep archaea ../assembly_consensus_all/data/clean/qbt/tiara/all_cons | awk '{print $1}' >> data/clean/all_cons_toremove.txt

module load seqkit
seqkit grep \
 -v ../assembly_consensus_all/all_cons.fasta \
 -f data/clean/all_cons_toremove.txt > data/clean/all_cons_tiara_clean.fasta




