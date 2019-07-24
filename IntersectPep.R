#to intersect a list of trnscripts of interest from a peptide list
library(Biostrings)

#Read in a list of all protein sequences
NobtPro <- readAAStringSet("~/bigdata/Nobtusifolia/Genome_Files/NIOBT_r1.0.proteins.fa")

#strip off transcript suffix
NobtWanted$t_name <- substr(NobtWanted$t_name,1,nchar(as.character(NobtWanted$t_name))-3)
#split into up and down regulated
NobtUp <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Nobt_Prev16_DESeq_Up.csv")
NobtDown <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Nobt_Prev6_DESeq_Down.csv")

#intersect the two list
NobtUpMatch <- NobtPro[match(NobtUp[,1],names(NobtPro))]
NobtDownMatch <- NobtPro[match(NobtDown[,1],names(NobtPro))]
#write it to a fasta file
writeXStringSet(NobtUpMatch, "NobtUp.fasta", format = "fasta")
writeXStringSet(NobtDownMatch, "NobtDown.fasta", format = "fasta")

#This section will deal with tomato, which is slightly different. We already have a list
#of GO terms for each protein, so we just need to reformat and intersect the two lists
SlycUp <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Slyc_1v15_DESeq_Up.csv")
SlycDown <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Slyc_1v15_DESeq_Down.csv")

#get Go terms for each protein
library(topGO)

#read in all genes with Go terms
#I subbed out the | for ; in the .tsv file from SGN here to make it work
allGenes <- readMappings(file="~/bigdata/Slycopersicum/data/ITAG3.2_protein_go.tsv", sep="\t", IDsep=";")
names(allGenes) <- gsub('.{2}$', '', names(allGenes)) #remove transcript ID

#Write subset to a tsv file
SlycUpOut <- data.frame(GOTerm=I(unlist(lapply(allGenes[SlycUp[,1]],paste,collapse="; "))))
row.names(SlycUpOut) <- SlycUp[,1]
write.table(file="SlycUp.tab", SlycUpOut ,sep = "\t", quote = FALSE, col.names = FALSE)

#down isnt working for some reason
SlycDownOut <- data.frame(GOTerm=I(unlist(lapply(allGenes[SlycDown[,1]],paste,collapse="; "))))
row.names(SlycDownOut) <- SlycDown[,1]
write.table(file="SlycDown.tab", SlycDownOut ,sep = "\t", quote = FALSE, col.names = FALSE)


