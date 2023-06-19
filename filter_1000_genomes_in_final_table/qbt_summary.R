### Load libraries

library(readr)
library(tidyverse)
library(readxl)

getwd()
#setwd("Desktop/ICM-CSIC/easig_sags/BINNING (SOLA_MAGS_Fran_Latorre)/")

### Main directory

DATA_DIR <- "data/clean/qbt/all_reports/"

### Re-format + clean unknowks from TIARA

tiara <- read_tsv(sprintf("%stiara_report.txt", DATA_DIR), col_names = FALSE)

tiara <- separate(tiara, X2, c("type", "num"))

tiaradf <- as.data.frame(tiara)

vec <- c()

for (x in 1:(nrow(tiaradf)-1)) {
    
    if (tiaradf[x,2] ==  tiaradf[x+1,2] && tiaradf[x,1] ==  tiaradf[x+1,1]){
        tiaradf[x,3] <- as.integer(tiaradf[x,3]) + as.integer(tiaradf[x+1,3])
        vec <- append(vec, x+1)
    }
}

if (length(vec) != 0){
    tiaraclean <- tiaradf[-vec,]
} else {
    tiaraclean <- tiaradf
}

tiaraclean <- tiaradf[-vec,]

write_tsv(tiaraclean, sprintf("%stiara_report.tsv", DATA_DIR))


tiara_new <- read_tsv(sprintf("%stiara_report.tsv", DATA_DIR))


data_wide <- spread(tiara_new, type, num)

tiara_perf <- tiara_new %>% mutate(X1 = factor(X1, levels = unique(X1))) %>% spread(type, num)

write_tsv(tiara_perf, sprintf("%stiara_report_GOOD.tsv", DATA_DIR))


### Read QUAST, BUSCO & TIARA report files

rm(list = ls())

DATA_DIR <- "data/clean/qbt/all_reports/"

quast <- read_tsv(sprintf("%squast_report.txt", DATA_DIR))
busco <- read_tsv(sprintf("%sbusco_report.txt", DATA_DIR))
tiara <- read_tsv(sprintf("%stiara_report_GOOD.tsv", DATA_DIR))

base <- data.frame(matrix(NA, nrow = nrow(quast), ncol = 17))

colnames(base) <- c("Sample", "Mb (>= 0 )", "Mb (> =1k)", "Mb (>= 3kb)", "Mb (>= 5Kb)", "contigs (>= 1Kb)", "contigs (>= 3Kb)", "contigs (>= 5Kb)", "Largest contig", "GC (%)", "N50", "Complete BUSCOs", "Fragmented BUSCOs", "Completeness (%) (out of 255)", "%-bact", "%-euk", "all tiara")

### QUAST 

base$Sample <- quast$Sample

base[2:5] <- round(quast[7:10] / 1000000, 2)

base[6:8] <- quast[4:6]

base$`Largest contig` <- quast$`Largest contig`

base$`GC (%)` <- quast$`GC (%)`

base$N50 <- quast$N50


### BUSCO

base$`Complete BUSCOs` <- busco$X5

base$`Fragmented BUSCOs` <- busco$X7

base$`Completeness (%) (out of 255)` <- round(100*(base$`Complete BUSCOs` + base$`Fragmented BUSCOs`)/255, 2)


### TIARA

for (i in 1:dim(tiara)[1]){
  for (j in 1:dim(tiara)[2]){
    if (is.na(tiara[i,j]) == TRUE){
      tiara[i,j] = 0
    }
  }
}

base$`all tiara` <- tiara$bacteria + tiara$archaea + tiara$eukarya + tiara$organelle + tiara$unknown

base$`%-bact` <- round(100* tiara$bacteria / base$`all tiara`, 1)

base$`%-euk` <- round(100* tiara$eukarya / base$`all tiara`, 1)


### Write final summary table

write_tsv(base, sprintf("%sQBT_summary_genomes_filter1000.tsv", DATA_DIR))

