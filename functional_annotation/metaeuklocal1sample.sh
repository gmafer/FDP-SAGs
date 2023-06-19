#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=metaeuk1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=250G
#SBATCH --output=data/logs/metaeuk_%A_%a.out
#SBATCH --error=data/logs/metaeuk_%A_%a.err 


SAMPLE=GC1003827_A03


module load mmseqs2 metaeuk


DC=data/clean/metaeuk1sample_scaff

FASTA=../final_assembly/scaffolds/${SAMPLE}_scaffolds.fasta

OUTPUT=${DC}/${SAMPLE}_metaeuk.output


REF_DB=MERC.MMETSP.uniclust50/MMETSP_uniclust50_MERC_profiles

TEMP=./tempF1


## Commands

# Creating output and temporary directory
mkdir -p ${TEMP} ${OUTPUT}

echo "- Creating TARA DB with MMSEQS2"
mmseqs createdb ${FASTA} ${OUTPUT}/${SAMPLE}_TARA_contigs.db --dont-split-seq-by-len --dbtype 2

echo "- Predicting exons with metaeuk with MMSEQS2 database"
metaeuk predictexons ${OUTPUT}/${SAMPLE}_TARA_contigs.db "${REF_DB}" ${OUTPUT}/${SAMPLE}_TARA_contigs.predEx ${OUTPUT}/${SAMPLE}_TARA_contigs.tempFolder --metaeuk-eval 0.0001 -e 100 --min-length 40 --slice-search --min-ungapped-score 35  --split-memory-limit 80G --min-exon-aa 20 --metaeuk-tcov 0.6  --disk-space-limit 250G --threads 24 --local-tmp "${TEMP}"

echo "- Reducing redundancy"
metaeuk reduceredundancy ${OUTPUT}/${SAMPLE}_TARA_contigs.predEx ${OUTPUT}/${SAMPLE}_TARA_contigs.predRed ${OUTPUT}/${SAMPLE}_TARA_contigs.predClust --threads 24

echo "- Transforming exons to FASTA file"  ## Change --protein 0 option to obtain aminoacids instead of nucleotides
metaeuk  unitesetstofasta ${OUTPUT}/${SAMPLE}_TARA_contigs.db ${REF_DB} ${OUTPUT}/${SAMPLE}_TARA_contigs.predRed ${OUTPUT}/${SAMPLE}_TARA_pred.exons.fasta --protein 0
