#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=seqkit_grep
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1


module load seqkit

seqkit grep -f 324_pacbio_manual_clean.txt \
 ../../easig_metaG/PACBIO/data/clean/1_A01/1_A01HS_ccs0P.fasta \
 -o 324_pacbio_manual_selected.fasta
