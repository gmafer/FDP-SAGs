#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=createdb_metaeuk
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=100G
#SBATCH --output=data/logs/createdb.log_%A_%a.out
#SBATCH --error=data/logs/createdb.log_%A_%a.err


# mmseqs2
module load mmseqs2

# var
sample=GC1003827_A03
contigs=../final_assembly/contigs/GC1003827_A03_contigs.fasta
out=data/clean/gene.prediction/sampledb

mkdir -p ${out}

mmseqs createdb ${contigs} ${out}/${sample}.euk.contigs.db --dont-split-seq-by-len --dbtype 2
