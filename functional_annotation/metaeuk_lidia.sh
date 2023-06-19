#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=metaeuk
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=200G
#SBATCH --output=data/logs/metaeuk_lidia.log_%A_%a.out
#SBATCH --error=data/logs/metaeuk_lidia.log_%A_%a.err

# metaeuk
module load metaeuk

# Variables
sample=GC1003827_A03
referenceDB=/mnt/lustre/bio/shared/ecomics/databases/eukaryotic/MERC.MMETSP.uniclust50/MMETSP_uniclust50_MERC_profiles  #/mnt/lustre/bio/users/rlogares/data/metaeuk.db/MMETSP_uniclust50_MERC_profiles
sampledb=data/clean/gene.prediction/sampledb
temp=data/clean/gene.prediction/tmp
out=data/clean/gene.prediction/${sample}

mkdir -p ${out}

#predict
metaeuk predictexons ${sampledb}/${sample}.euk.contigs.db "${referenceDB}" ${out}/${sample}.predEx ${out}/${sample}.tempFolder --metaeuk-eval 0.0001 -e 100 --min-length 40 --slice-search --min-ungapped-score 35  --split-memory-limit 80G --min-exon-aa 20 --metaeuk-tcov 0.6  --disk-space-limit 300G --threads 12  --local-tmp "${temp}" 

# reduce redundancy:
metaeuk reduceredundancy ${out}/${sample}.predEx  ${out}/${sample}.predRed ${out}/${sample}.predClust --threads 12

# unite reduced predictions in a fasta:
metaeuk  unitesetstofasta ${sampledb}/${sample}.euk.contigs.db ${referenceDB} ${out}/${sample}.predRed ${out}/${sample}.pred.exons.fas --protein 0
