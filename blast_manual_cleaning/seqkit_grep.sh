#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=seqkit_grep
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1


module load seqkit

seqkit grep -f nodes.txt \
 ../final_assembly/scaffolds/GC1003827_A03_scaffolds.fasta \
 -o selected_scaffolds.fasta
