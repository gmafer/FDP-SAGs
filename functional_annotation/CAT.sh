#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=CAT
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=400G
#SBATCH --output=data/logs/CAT_%A_%a.out
#SBATCH --error=data/logs/CAT_%A_%a.err 


#SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

SAMPLE=GC1003827_A03


module load cat


contigs=../final_assembly/contigs/GC1003827_A03_contigs.fasta

## Proteins are not needed, CAT will predict them with prodigal. Only use for EUK organisms, headers must have: >CONTIGNAME_gene/ORF/exon
#proteins=

taxonomy_db=/mnt/lustre/repos/bio/databases/public/cat/20210107/2021-01-07_taxonomy

reference_db=/mnt/lustre/repos/bio/databases/public/cat/20210107/2021-01-07_CAT_database

output=data/clean/fran_CAT_output

## Command

mkdir -p ${output}

# Parse MetaEUK proteins for CAT:

#cat -n ${proteins} | sed 's/\([0-9]*\)\t.*[|]\(k[0-9]*_[0-9]*\)[|].*[|].*[|].*[|].*[|].*[|].*[|].*]/\1\t>\2_EXON\1/' | cut -f2 > ${output}/full.bin.688.proteins.CAT.fasta

echo "Running CAT contigs on ${contigs}"
CAT contigs -c ${contigs} -d ${reference_db} -t ${taxonomy_db} -n 20 --sensitive --force -o ${output}/CAT.full.bin.688.CATdb

echo "Adding taxonomy names to CAT output"
CAT add_names -i ${output}/CAT.full.bin.688.CATdb.contig2classification.txt -o ${output}/CAT.full.bin.688.CATdb.official_names.txt -t ${taxonomy_db} --only_official --force

echo "Summarizing CAT output information"
CAT summarise -i ${output}/CAT.full.bin.688.CATdb.official_names.txt -c ${contigs} -o ${output}/CAT.full.bin.688.CATdb.summary.txt --force

