#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=kaiju_nt_3.5
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=500G
#SBATCH --output=data/logs/kaiju_nt_%A_%a.out
#SBATCH --error=data/logs/kaiju_nt_%A_%a.err 
#SBATCH --array=1-69%4

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

# Fasta file

COD_SEQ=data/clean/augustus+eggnog_results/${SAMPLE}/${SAMPLE}*.codingseq

# Out dir and filenames

OUT_DIR=data/clean/kaiju_nt/

THREADS=24

# Load modules

module load kaiju

# Run Kaiju

kaiju \
 -t /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/nodes.dmp \
 -f /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/kaiju_db_nr_euk.fmi \
 -i ${COD_SEQ} \
 -o ${OUT_DIR}/${SAMPLE}_kaiju_nt.out \
 -z ${THREADS}  

kaiju-addTaxonNames \
 -t /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/nodes.dmp \
 -n /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/names.dmp \
 -p \
 -i ${OUT_DIR}/${SAMPLE}_kaiju_nt.out \
 -o ${OUT_DIR}/${SAMPLE}_kaiju_nt_names.out

kaiju2table \
 -t /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/nodes.dmp \
 -n /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/names.dmp \
 -r genus \
 -p \
 -o ${OUT_DIR}/${SAMPLE}_kaiju_nt_summary.tsv ${OUT_DIR}/${SAMPLE}_kaiju_nt.out
