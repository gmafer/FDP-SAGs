#!/bin/bash
#SBATCH --account=emm1                          # Compulsory option
#SBATCH --job-name="metaeuk"              # Default to the script name
#SBATCH -D .                                    # the working directory of the job
#SBATCH --mem=300G                            # Memory to be used in MB or G. Default is 8G (4G per thread).
#SBATCH --error=metaeuk.%J.err            # file to collect the standard error output (stderr)
#SBATCH --output=metaeuk.%J.out           # file to collect the standard output (stdout). Change %J to %A when in array. %a for subindex.
#SBATCH --nodes=1                               # How many nodes you want to use. NODES /= THREADS. NODES = 'Machines'
#SBATCH --ntasks=1                              # Total number of tasks or jobs to launch, normally 1, but more if Jobs are in an array
#SBATCH --cpus-per-task=24                      # Number of threads per task/job.
#SBATCH --mail-type=ALL                         # Option of when to e-mail: BEGIN, END, FAIL or ALL.
#SBATCH --mail-user=latorre@icm.csic.es         # e-mail address.

## Module

module load mmseqs2 metaeuk

## Variables

wdp=/home/flatorre/ecomics/SAGs/TARA/tiara
fasta=./eukarya_TARA_contigs.fasta
input=${wdp}/tiara.output
output=${wdp}/metaeuk.output
referenceDB=/mnt/lustre/bio/shared/ecomics/databases/eukaryotic/MERC.MMETSP.uniclust50/MMETSP_uniclust50_MERC_profiles
temp=./tempF

## Commands

# Creating output and temporary directory
mkdir -p ${temp} ${output}

echo "- Creating TARA DB with MMSEQS2"
mmseqs createdb ${fasta} ${output}/eukarya_TARA_contigs.db --dont-split-seq-by-len --dbtype 2

echo "- Predicting exons with metaeuk with MMSEQS2 database"
metaeuk predictexons ${output}/eukarya_TARA_contigs.db ${referenceDB} ${output}/eukarya_TARA_contigs.predEx ${output}/eukarya_TARA_contigs.tempFolder --metaeuk-eval 0.0001 -e 100 --min-length 40 --slice-search --min-ungapped-score 35  --split-memory-limit 80G --min-exon-aa 20 --metaeuk-tcov 0.6  --disk-space-limit 300G --threads 24  --local-tmp "${temp}"

echo "- Reducing redundancy"
metaeuk reduceredundancy ${output}/eukarya_TARA_contigs.predEx ${output}/eukarya_TARA_contigs.predRed ${output}/eukarya_TARA_contigs.predClust --threads 24

echo "- Transforming exons to FASTA file"  ## Change --protein 0 option to obtain aminoacids instead of nucleotides
metaeuk  unitesetstofasta ${output}/eukarya_TARA_contigs.db ${referenceDB} ${output}/eukarya_TARA_contigs.predRed ${output}/eukarya_TARA_pred.exons.fasta --protein 0
