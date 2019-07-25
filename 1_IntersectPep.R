#to intersect a list of trnscripts of interest from a peptide list
library(Biostrings)

#Read in a list of all protein sequences
NobtPro <- readAAStringSet("~/bigdata/Nobtusifolia/Genome_Files/NIOBT_r1.0.proteins.fa")

#strip off transcript suffix
NobtWanted$t_name <- substr(NobtWanted$t_name,1,nchar(as.character(NobtWanted$t_name))-3)
#split into up and down regulated
NobtUp <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Nobt_Prev16_DESeq_Up.csv")
NobtDown <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Nobt_Prev6_DESeq_Down.csv")

#intersect the two list and write it to a fasta file
writeXStringSet(NobtPro[match(NobtUp[,1],names(NobtPro))], "NobtUp.fasta", format = "fasta")
writeXStringSet(NobtPro[match(NobtDown[,1],names(NobtPro))], "NobtDown.fasta", format = "fasta")

#This section will deal with tomato, which is slightly different. We already have a list
#of GO terms for each protein, so we just need to reformat and intersect the two lists
SlycUp <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Slyc_1v15_DESeq_Up.csv")
SlycDown <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Slyc_1v15_DESeq_Down.csv")

#ope, I also have to output the protein sequences for another analysis so I just do it here
SlycPro <- readAAStringSet("~/bigdata/Slycopersicum/data/ITAG3.2_proteins.fasta")
names(SlycPro) <- strtrim(names(SlycPro),16)
writeXStringSet(SlycPro[match(SlycUp[,1],names(SlycPro))], "SlycUp.fasta", format = "fasta")
writeXStringSet(SlycPro[match(SlycDown[,1],names(SlycPro))], "SlycDown.fasta", format = "fasta")


#get Go terms for each protein
library(topGO)

#read in all genes with Go terms
#I subbed out the | for ; in the .tsv file from SGN here to make it work
allGenes <- readMappings(file="~/bigdata/Slycopersicum/data/ITAG3.2_protein_go.tsv", sep="\t", IDsep=";")
names(allGenes) <- gsub('.{2}$', '', names(allGenes)) #remove transcript ID

#Write all to a TSV files
SlycAllOut <- data.frame(GOTerm=I(unlist(lapply(allGenes, paste, collapse="; "))))
SlycAllOut$gene_id <- names(allGenes)
SlycAllOut <- aggregate(SlycAllOut$GOTerm~SlycAllOut$gene_id, FUN=paste, collapse="; ")
write.table(file="SlycAll.tab", SlycAllOut, sep="\t", quote=F, col.names = F, row.names = F)

#Write subset to a tsv file
SlycUpOut <- data.frame(GOTerm=I(unlist(lapply(allGenes[SlycUp[,1]],paste,collapse="; "))))
row.names(SlycUpOut) <- SlycUp[,1]
write.table(file="SlycUp.tab", SlycUpOut ,sep = "\t", quote = FALSE, col.names = FALSE)

#down isnt working for some reason
SlycDownOut <- data.frame(GOTerm=I(unlist(lapply(allGenes[SlycDown[,1]],paste,collapse="; "))))
row.names(SlycDownOut) <- SlycDown[,1]
write.table(file="SlycDown.tab", SlycDownOut ,sep = "\t", quote = FALSE, col.names = FALSE)


