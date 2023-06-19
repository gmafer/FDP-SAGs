#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=filter_vsearch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --output=data/logs/filter_vsearch_%A_%a.out
#SBATCH --error=data/logs/filter_vsearch_%A_%a.err

# Load modules

module load vsearch

OUT='data/clean/genome_filtered'

mkdir -p ${OUT}

MIN_LEN=1000

vsearch \
 --fastx_filter data/clean/CLEANEST.fasta \
 --fastq_minlen ${MIN_LEN} \
 --fastaout ${OUT}/CLEANEST_filter1000.fasta
