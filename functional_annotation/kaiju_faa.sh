#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=kaiju_faa_3.5
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=500G
#SBATCH --output=data/logs/kaiju_faa_%A_%a.out
#SBATCH --error=data/logs/kaiju_faa_%A_%a.err 
#SBATCH --array=1-69%4

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

# Fasta file

FAA=data/clean/augustus+eggnog_results/${SAMPLE}/${SAMPLE}_prot.faa

# Out dir and filenames

OUT_DIR=data/clean/kaiju_faa/

THREADS=24

# Load modules

module load kaiju

# Run Kaiju

kaiju \
 -t /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/nodes.dmp \
 -f /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/kaiju_db_nr_euk.fmi \
 -i ${FAA} \
 -p \
 -o ${OUT_DIR}/${SAMPLE}_kaiju_faa.out \
 -z ${THREADS} 

kaiju-addTaxonNames \
 -t /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/nodes.dmp \
 -n /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/names.dmp \
 -p \
 -i ${OUT_DIR}/${SAMPLE}_kaiju_faa.out \
 -o ${OUT_DIR}/${SAMPLE}_kaiju_faa_names.out

kaiju2table \	
 -t /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/nodes.dmp \
 -n /mnt/lustre/repos/bio/databases/public/kaiju/nr_euk_2022-03-10/names.dmp \
 -r genus \
 -o ${OUT_DIR}/${SAMPLE}_kaiju_faa_summary.tsv ${OUT_DIR}/${SAMPLE}_kaiju_faa.out
