#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=blast_manual_clean_sag
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1


# Load modules

module load blast

# CREATE DATABASE

SAMPLE="GC1003827_A03"

mkdir -p blast_db

makeblastdb -in ${SAMPLE}_selected_scaffolds.fasta -dbtype nucl -parse_seqids -out blast_db/${SAMPLE}


# Blast DB's

DB_BLAST="blast_db/${SAMPLE}"

# Run name

RUN_NAME=$(echo ${SAMPLE} | awk -F'/' '{print $NF}')

# Out dir and filenames

DB_NAME=$(echo ${DB_BLAST} | awk -F'/' '{print $NF}') # take db name from db

OUT_DIR="blast_results/"

mkdir -p ${OUT_DIR}

THREADS=24

# BLAST

## Nanopore contigs

date
echo "Blast sag manual clean ${DB_NAME}"
blastn \
 -max_target_seqs 10 \
 -db ${DB_BLAST} \
 -outfmt '6 qseqid sseqid pident length qstart qend sstart send evalue stitle slen qlen' \
 -perc_identity 90 \
 -query ../../easig_metaG/PACBIO/data/clean/1_A01/1_A01HS_ccs0P.fasta \
 -out ${OUT_DIR}/${SAMPLE}.out \
 -evalue 0.0001 \
 -num_threads ${THREADS}


### Best hit

LC_ALL=C sort \
 -k1,1 -k9,9g \
 ${OUT_DIR}/${SAMPLE}.out | \
 sort -u -k1,1 --merge > ${OUT_DIR}/${SAMPLE}_best_hit.txt

<<NO
date
echo 'Blast finished'

echo -e "query_id\tsubject_id\t%_identity\taln_len\tq_start\tq_end\ts_start\ts_end\te_value\tseq_title\tseq_len\tq_len" | cat - blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT.reads_18S_blast.out > blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT.reads_18S_blast.out.GOOD

echo -e "query_id\tsubject_id\t%_identity\taln_len\tq_start\tq_end\ts_start\ts_end\te_value\tseq_title\tseq_len" | cat - blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT_reads.best_hit.txt > blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT_reads.best_hit.txt.GOOD

# remove not good files

rm blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT.reads_18S_blast.out

rm blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT_reads.best_hit.txt

mv blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT.reads_18S_blast.out.GOOD blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT.reads_18S_blast.out

mv blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT_reads.best_hit.txt.GOOD blast_comparisons/data/clean/blast_18S/${SAMPLE}_ONT_reads.best_hit.txt

NO
