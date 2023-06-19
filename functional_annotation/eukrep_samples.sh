#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=eukrep
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=300G
#SBATCH --output=data/logs/eukrep_%A_%a.out
#SBATCH --error=data/logs/eukrep_%A_%a.err 
#SBATCH --array=1-69%3

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

module load eukrep

SCAFF=../final_assembly/scaffolds/${SAMPLE}_scaffolds.fasta

OUT_DIR=data/clean/eukrep/${SAMPLE}


mkdir -p ${OUT_DIR}


EukRep -i ${SCAFF} -o ${OUT_DIR}/${SAMPLE}_euk.out --prokarya ${OUT_DIR}/${SAMPLE}_proc.out

grep ">" data/clean/eukrep/GC1003827_A03_euk.out | sed 's/>//g' > data/clean/eukrep/GC1003827_A03_nodes_euk.txt

grep ">" data/clean/eukrep/GC1003827_A03_proc.out | sed 's/>//g' > data/clean/eukrep/GC1003827_A03_nodes_proc.txt

perl -lpi -e '$_ .= "\teukarya"' data/clean/eukrep/GC1003827_A03_nodes_euk.txt

perl -lpi -e '$_ .= "\tprokaryota"' data/clean/eukrep/GC1003827_A03_nodes_proc.txt


#EukRep -i <Sequences in Fasta format> -o <Eukaryote sequence output file> --prokarya <Prokaryote sequence output file>
