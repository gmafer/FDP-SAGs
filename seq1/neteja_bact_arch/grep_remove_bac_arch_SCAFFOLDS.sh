#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=grep_remove_scaff
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/grep_remove_scaff%A_%a.out
#SBATCH --error=seq1/data/logs/grep_remove_scaff%A_%a.err
#SBATCH --array=1-128%16

#================================================
DATA_DIR='seq1/data/clean/assembly'
SAMPLE=$(cat seq1/data/clean/samples.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

grep bacteria seq1/data/clean/quast_busco_tiara/tiara/${SAMPLE} | awk '{print $1}' > seq1/data/clean/all_scaff_toremove/${SAMPLE}_all_scaff.txt 
grep archaea seq1/data/clean/quast_busco_tiara/tiara/${SAMPLE} | awk '{print $1}' >> seq1/data/clean/all_scaff_toremove/${SAMPLE}_all_scaff.txt

module load seqkit
seqkit grep \
 -v ${DATA_DIR}/${SAMPLE}/scaffolds.fasta \
 -f seq1/data/clean/all_scaff_toremove/${SAMPLE}_all_scaff.txt > ${DATA_DIR}/${SAMPLE}/scaffolds_mod.fasta

#SAMPLE=$(ls ${DATA_DIR} | awk "NR == ${SLURM_ARRAY_TASK_ID}")
#awk 'BEGIN{while((getline<"seq1/data/clean/all_toremove/${SAMPLE}_all.txt")>0)l[">"$1]=1}/^>/{f=!l[$1]}f' ${DATA_DIR}/${SAMPLE}/contigs.fasta > ${DATA_DIR}/${SAMPLE}/contigs_mod.fasta
