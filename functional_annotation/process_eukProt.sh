awk -F "\t" '{print $1}'  data/clean/eukProt_Euk_1sample/results_EukProt_TARA/taxonomyResult.EukMPGC.EukProt.TARA.tsv | awk -F "|" '{print $2}' > e1

awk -F "\t" '{print $5}'  data/clean/eukProt_Euk_1sample/results_EukProt_TARA/taxonomyResult.EukMPGC.EukProt.TARA.tsv | awk -F ";" '{print $7}' > e2

paste e1 e2 | sort --version-sort > vs_e12

awk  '$2!=""' vs_e12 > noempty
awk  '$2==""' vs_e12 > empty

for n in $(awk '{print $1}' vs_e12 | sort --version-sort -u); 
do 
 echo -e $n'\t' \
 $(grep -c $n vs_e12)'\t' \
 $(grep -c $n noempty)'\t' \
 $(grep -c $n empty) >> 3cols; 
done













##################################################

join arasi uniq_noempty -a1 > try1

##################################################
awk -F "\t" '{print $1}'  data/clean/eukProt_Pro_1sample/results_EukProt_TARA/taxonomyResult.EukMPGC.EukProt.TARA.tsv | awk -F "|" '{print $2}' > p1

awk -F "\t" '{print $5}'  data/clean/eukProt_Pro_1sample/results_EukProt_TARA/taxonomyResult.EukMPGC.EukProt.TARA.tsv | awk -F ";" '{print $7}' > p2

paste p1 p2 | sort --version-sort > vs_p12
