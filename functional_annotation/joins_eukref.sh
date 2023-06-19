rm data/clean/fin
rm data/clean/finna

cat data/clean/final_detail_summaries/GC1003827_A03_final_detail_summary.txt > f1.txt

sed 1d f1.txt > f11.txt

awk -F"\t" -v OFS="\t" '{
       for (i=1;i<=NF;i++) {
         if ($i == "") $i="NA"
       }
       print $0
 }' f11.txt > f11_na.txt


cat data/clean/eukrep/GC1003827_A03_nodes_euk.txt > f2.txt


cat data/clean/eukrep/GC1003827_A03_nodes_proc.txt > f3.txt

grep -E "length_[3-9][0-9][0-9][0-9]" f3.txt > f33


sort -f f11_na.txt > s1
sort -f f2.txt > s2
sort -f f33 > s3



join s1 s2 -a1 > join1
join join1 s3 -a1 > join2 

sort --version-sort join2 > data/clean/fin

#echo -e "SCAFFOLD\tLENGTH\tAUG_GUESSES\tegg_EUK\tegg_BACT\tTIARA\tKAIJU_nt_euk\tKAIJU_faa_euk\tKAIJU_nt_bact\tKAIJU_faa_bact\tEukRep" | cat - fin > fin_hdr.txt

awk -F"\t" -v OFS="\t" '{
       for (i=1;i<=NF;i++) {
         if ($i == "") $i="NA"
       }
       print $0
 }' data/clean/fin > data/clean/finna 

rm *

################################################################################

awk -F "\t" '{print $1"\t"$6}' data/clean/scaffolds_CAT_output/GC1003827_A03/CAT.full.bin.688.CATdb.official_names.txt | sort --version-sort | sed 's/:.*$//g' > nsg.txt

sed -E 's/(.*[0-9]{1,}$)/\1 NA/' data/clean/finna > ara

join ara nsg.txt | sed 's/no support/no_support/g' | sed 's/ $/&NA/' > arasi

echo -e "SCAFFOLD\tLENGTH\tAUG_GUESSES\tegg_EUK\tegg_BACT\tTIARA\tKAIJU_nt_euk\tKAIJU_faa_euk\tKAIJU_nt_bact\tKAIJU_faa_bact\tEukRep\tCAT" | cat - arasi > arasihdr
