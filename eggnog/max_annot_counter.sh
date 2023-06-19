#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=maxannotcount
#SBATCH --cpus-per-task=6
#SBATCH --mem=30G
#SBATCH --ntasks-per-node=1

for sample in $(cat samples_file.txt); \
	do \
	
	echo "SAMPLE: $sample" >> report.txt;
	echo "Total: $(cat results/${sample}/${sample}_eggnog.emapper.annotations | awk '{print $6}' | wc -l)" >> report.txt;
	echo "Eukaryota: $(cat results/${sample}/${sample}_eggnog.emapper.annotations | awk '{print $6}' | grep -c 'Eukaryota')" >> report.txt;
	echo "Bacteria: $(cat results/${sample}/${sample}_eggnog.emapper.annotations | awk '{print $6}' | grep -c '2|Bacteria')" >> report.txt;
	echo "xbacteria: $(cat results/${sample}/${sample}_eggnog.emapper.annotations | awk '{print $6}' | grep -c 'bacteria')" >> report.txt;
	echo "Metazoa: $(cat results/${sample}/${sample}_eggnog.emapper.annotations | awk '{print $6}' | grep -c 'Metazoa')" >> report.txt;
	echo -e "Fungi: $(cat results/${sample}/${sample}_eggnog.emapper.annotations | awk '{print $6}' | grep -c 'Fungi') \n" >> report.txt;
	
	done;

#--> hacer sample file con todos 69 names

#--> por cada name en sample file, hacer grep -c de euk, bact, etc (alguno mas)
# + igual hacerlo con echo rolllo: 

#SAMPLE:	"GC....."
#total: n
#euk: n
#bact: n
#arch: n

#(+ meter result de todo en un solo report file)


#la linea es esta: cat seq1/data/clean/results/GC1003828_A03/GC1003828_A03_eggnog.emapper.annotations | awk '{print $6}' | grep -c 'Euk'
