cp -r data/clean/db1 data/clean/db2

cat data/clean/try1/unkn/*_unkn.txt | \
 sort -u | \
 grep -E "bacteria|bacteres|bacteriia" | \
 cut -d "|" -f 1 >> data/clean/db2/bact_uniq.txt

cat data/clean/try1/unkn/*_unkn.txt | \
 sort -u | \
 grep "vir" | \
 cut -d "|" -f 1 >> data/clean/db2/AV_uniq.txt
