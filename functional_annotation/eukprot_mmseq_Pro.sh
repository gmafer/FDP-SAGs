#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=mmseqtax_pro
#SBATCH --ntasks=1
#SBATCH --mem=200G
#SBATCH --cpus-per-task=10
#SBATCH --error=data/logs/taxeuk_pro_%A_%a.err
#SBATCH --output=data/logs/taxeuk_pro_%A_%a.out
#SBATCH --array=1-69%3


SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

module load mmseqs2/11-e1a1c


DB_DIR='/mnt/lustre/repos/bio/databases/public/gtdb/release89_unclustered-54k-genomes'

EP='data/clean/eukProt_Pro'

TMP_DIR=${EP}/tempF/TAX_DBs

AA='data/clean/metaeuk_scff/${SAMPLE}_metaeuk.output/${SAMPLE}_TARA_pred.exons.fasta'

OUT_DB=${EP}/TARA.aa.db

OUT_TAX=${EP}/results_EukProt_TARA

OUT_TMP=${EP}/tmp_eukprot_TARA

mkdir -p ${EP} ${OUT_DB} ${OUT_TAX} ${TMP_DIR}/${OUT_TMP}

## we also create the db from the aa genes
mmseqs createdb ${AA} ${OUT_DB}/aa_TARA_db # [infile (.gz)] [output sequenceDB]

## the taxonomy
mmseqs taxonomy --search-type 1 --threads 10 --lca-ranks "species,genus,family,order,class,phylum,superkingdom" \
        ${OUT_DB}/aa_TARA_db  \
        ${DB_DIR}/sequenceDB ${OUT_TAX}/taxEukMPGC.EukProt.TARA.db ${TMP_DIR}/${OUT_TMP}

## extract the results
mmseqs createtsv ${OUT_DB}/aa_TARA_db ${OUT_TAX}/taxEukMPGC.EukProt.TARA.db ${OUT_TAX}/taxonomyResult.EukMPGC.EukProt.TARA.tsv
