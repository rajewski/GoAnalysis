#to intersect a list of trnscripts of interest from a peptide list
library(Biostrings)
#Read in a list of all protein sequences
Pros <- readAAStringSet("~/bigdata/Nobtusifolia/Genome_Files/NIOBT_r1.0.proteins.fa")
#Read in a list of the query protein names
wanted <- read.csv("~/bigdata/Nobtusifolia/RNA-seq/Results_Ballgown/Nobt_Prev3DPA_DEGs.csv")
#strip off transcript suffix
wanted$t_name <- substr(wanted$t_name,1,nchar(as.character(wanted$t_name))-3)

#split into up and down regulated
Up <- wanted[wanted$fc>=1,]
Down <- wanted[wanted$fc<1,]

#intersect the two list
UpMatch <- Pros[match(Up$t_name,names(Pros))]
DownMatch <- Pros[match(Down$t_name,names(Pros))]
#write it to a fasta file
writeXStringSet(UpMatch, "Up.fasta", format = "fasta")
writeXStringSet(DownMatch, "Down.fasta", format = "fasta")
