#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=metaeuk
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=300G
#SBATCH --output=data/logs/metaeuk_%A_%a.out
#SBATCH --error=data/logs/metaeuk_%A_%a.err 
#SBATCH --array=1-69%3


SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")


module load mmseqs2 metaeuk


DC=data/clean/metaeuk
FASTA=../final_assembly/contigs/${SAMPLE}_contigs.fasta
OUTPUT=${DC}/${SAMPLE}_metaeuk.output
REF_DB=/mnt/biostore/bio/flatorre/MERC.MMETSP.uniclust50
TEMP=./tempF


## Commands

# Creating output and temporary directory
mkdir -p ${TEMP} ${OUTPUT}

echo "- Creating TARA DB with MMSEQS2"
mmseqs createdb ${FASTA} ${OUTPUT}/${SAMPLE}_TARA_contigs.db --dont-split-seq-by-len --dbtype 2

echo "- Predicting exons with metaeuk with MMSEQS2 database"
metaeuk predictexons ${OUTPUT}/${SAMPLE}_TARA_contigs.db ${REF_DB} ${OUTPUT}/${SAMPLE}_TARA_contigs.predEx ${OUTPUT}/${SAMPLE}_TARA_contigs.tempFolder --metaeuk-eval 0.0001 -e 100 --min-length 40 --slice-search --min-ungapped-score 35  --split-memory-limit 80G --min-exon-aa 20 --metaeuk-tcov 0.6  --disk-space-limit 300G --threads 24 --local-tmp "${TEMP}"

echo "- Reducing redundancy"
metaeuk reduceredundancy ${OUTPUT}/${SAMPLE}_TARA_contigs.predEx ${OUTPUT}/${SAMPLE}_TARA_contigs.predRed ${OUTPUT}/${SAMPLE}_TARA_contigs.predClust --threads 24

echo "- Transforming exons to FASTA file"  ## Change --protein 0 option to obtain aminoacids instead of nucleotides
metaeuk  unitesetstofasta ${OUTPUT}/${SAMPLE}_TARA_contigs.db ${REF_DB} ${OUTPUT}/${SAMPLE}_TARA_contigs.predRed ${OUTPUT}/${SAMPLE}_TARA_pred.exons.fasta --protein 0
