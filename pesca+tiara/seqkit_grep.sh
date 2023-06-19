#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=seqkit_grep
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1


module load seqkit

seqkit grep -f sel_all.txt \
 ../../../easig_metaG/PACBIO/data/clean/cutadapt/1_A01_ccs_cutadapt_3000.fasta \
 -o selected_PACBIO_all.fasta
