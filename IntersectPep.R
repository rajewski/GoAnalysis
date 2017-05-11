#to intersect a list of trnscripts of interest from a peptide list
Pros <- readAAStringSet("NIOBT_r1.0.aa")
wanted <- read.table("wanted.txt")
wanted2 <- substr(wanted$V1,1,nchar(as.character(wanted$V1))-3)
matches2 <- Pros[match(wanted2[1:length(wanted2)],names(Pros))]
writeXStringSet(matches2, "DEG_pep.fasta", format = "fasta")
