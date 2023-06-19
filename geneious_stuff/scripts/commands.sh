cat 700_Consensus_Sequences_CLEAN.fasta | sed 's/ .*//g' > cons_seq_700_assembly_SAG_MAG_CLEAN_reduced_names.fasta

cat cons_seq_700_assembly_SAG_MAG_CLEAN_reduced_names.fasta Unused_Reads.fasta > cons_unused_CLEAN.fasta
