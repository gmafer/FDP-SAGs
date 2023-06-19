#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=eukProt_3cols
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200G

<<X
awk -F "\t" '{print $1}'  data/clean/eukProt_Euk_1sample/results_EukProt_TARA/taxonomyResult.EukMPGC.EukProt.TARA.tsv | awk -F "|" '{print $2}' > e1

awk -F "\t" '{print $5}'  data/clean/eukProt_Euk_1sample/results_EukProt_TARA/taxonomyResult.EukMPGC.EukProt.TARA.tsv | awk -F ";" '{print $7}' > e2

paste e1 e2 | sort --version-sort > vs_e12

awk  '$2!=""' vs_e12 > noempty
awk  '$2==""' vs_e12 > empty
X


for n in $(awk '{print $1}' vs_e12 | sort --version-sort -u);
do
 echo -e $n'\t' \
 $(grep -c $n vs_e12)'\t' \
 $(grep -c $n noempty)'\t' \
 $(grep -c $n empty) >> 3cols;
done

echo -e "SCAFFOLD\tTOTAL\tEUK\tNA" | cat - 3cols > 3colshdr
