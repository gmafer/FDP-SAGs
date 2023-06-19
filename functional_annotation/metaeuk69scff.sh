#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=metaeuk_scff
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=350G
#SBATCH --output=data/logs/metaeuk_scff_%A_%a.out
#SBATCH --error=data/logs/metaeuk_scff_%A_%a.err 
#SBATCH --array=1-69%5

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

module load mmseqs2 metaeuk


DC=data/clean/metaeuk_scff

FASTA=../final_assembly/scaffolds/${SAMPLE}_scaffolds.fasta

OUTPUT=${DC}/${SAMPLE}_metaeuk.output

REF_DB=MERC.MMETSP.uniclust50/MMETSP_uniclust50_MERC_profiles

TEMP=./tempF_scf


## Commands

# Creating output and temporary directory
mkdir -p ${TEMP} ${OUTPUT}

echo "- Creating TARA DB with MMSEQS2"
mmseqs createdb ${FASTA} ${OUTPUT}/${SAMPLE}_TARA_scff.db --dont-split-seq-by-len --dbtype 2

echo "- Predicting exons with metaeuk with MMSEQS2 database"
metaeuk predictexons ${OUTPUT}/${SAMPLE}_TARA_scff.db "${REF_DB}" ${OUTPUT}/${SAMPLE}_TARA_scff.predEx ${OUTPUT}/${SAMPLE}_TARA_scff.tempFolder --metaeuk-eval 0.0001 -e 100 --min-length 40 --slice-search --min-ungapped-score 35  --split-memory-limit 80G --min-exon-aa 20 --metaeuk-tcov 0.6  --disk-space-limit 350G --threads 24 --local-tmp "${TEMP}"

echo "- Reducing redundancy"
metaeuk reduceredundancy ${OUTPUT}/${SAMPLE}_TARA_scff.predEx ${OUTPUT}/${SAMPLE}_TARA_scff.predRed ${OUTPUT}/${SAMPLE}_TARA_scff.predClust --threads 24

echo "- Transforming exons to FASTA file"  ## Change --protein 0 option to obtain aminoacids instead of nucleotides
metaeuk  unitesetstofasta ${OUTPUT}/${SAMPLE}_TARA_scff.db ${REF_DB} ${OUTPUT}/${SAMPLE}_TARA_scff.predRed ${OUTPUT}/${SAMPLE}_TARA_pred.exons.fasta --protein 0
