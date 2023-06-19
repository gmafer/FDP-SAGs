#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=grep_remove_scaff_sel
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/grep_remove_scaff_sel_%A_%a.out
#SBATCH --error=seq1/data/logs/grep_remove_scaff_sel_%A_%a.err
#SBATCH --array=1-69%16

#================================================
DATA_DIR='seq1/data/clean/final_assembly/scaffolds/'
SAMPLE=$(cat seq1/data/clean/keep.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

grep bacteria seq1/data/clean/quast_busco_tiara/tiara_sel/${SAMPLE} | awk '{print $1}' > seq1/data/clean/all_sel_scaff_toremove/${SAMPLE}_all_scaff.txt 
grep archaea seq1/data/clean/quast_busco_tiara/tiara_sel/${SAMPLE} | awk '{print $1}' >> seq1/data/clean/all_sel_scaff_toremove/${SAMPLE}_all_scaff.txt

#module load seqkit
#seqkit grep \
# -v ${DATA_DIR}/${SAMPLE}_scaffolds.fasta \
# -f seq1/data/clean/all_sel_scaff_toremove/${SAMPLE}_all_scaff.txt > ${DATA_DIR}/${SAMPLE}_scaffolds_mod.fasta

