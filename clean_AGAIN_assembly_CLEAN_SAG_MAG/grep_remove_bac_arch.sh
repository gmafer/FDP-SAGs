#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=grep_remove_scaff
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1

#================================================

grep bacteria ../geneious_stuff/SAG_MAG_assembly_clean/data/clean/qbt/tiara/cons_un_CLEAN | awk '{print $1}' > data/clean/toremove.txt 
grep archaea ../geneious_stuff/SAG_MAG_assembly_clean/data/clean/qbt/tiara/cons_un_CLEAN | awk '{print $1}' >> data/clean/toremove.txt

module load seqkit
seqkit grep \
 -v data/clean/cons_unused_CLEAN.fasta \
 -f data/clean/toremove.txt > data/clean/CLEANEST.fasta




