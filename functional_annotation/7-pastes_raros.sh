#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=g+NODE
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%4

#================================================

##########VARIABLES#########

####NT####

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

sort --version-sort data/clean/kaiju_nt/${SAMPLE}_kaiju_nt_names.out > data/clean/kaiju_nt_version_sorts/${SAMPLE}_versort.txt

awk '{print $2"\t"$6}' data/clean/kaiju_nt_version_sorts/${SAMPLE}_versort.txt | sed 's/;//g' | sed 's/.t1//g' > data/clean/pastes/${SAMPLE}_nt_awk_2_6.txt

paste data/clean/aug_g+NODE/${SAMPLE}_g+NODE.txt data/clean/pastes/${SAMPLE}_nt_awk_2_6.txt > data/clean/pastes/${SAMPLE}_nt_paste.txt


####FAA####

sort --version-sort data/clean/kaiju_faa/${SAMPLE}_kaiju_faa_names.out > data/clean/kaiju_faa_version_sorts/${SAMPLE}_versort.txt

awk '{print $2"\t"$6}' data/clean/kaiju_faa_version_sorts/${SAMPLE}_versort.txt | sed 's/;//g' | sed 's/.t1//g' | sed "s/${SAMPLE}_//g" > data/clean/pastes/${SAMPLE}_faa_awk_2_6.txt

paste data/clean/aug_g+NODE/${SAMPLE}_g+NODE.txt data/clean/pastes/${SAMPLE}_faa_awk_2_6.txt > data/clean/pastes/${SAMPLE}_faa_paste.txt

