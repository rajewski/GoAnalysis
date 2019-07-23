#to intersect a list of trnscripts of interest from a peptide list
library(Biostrings)

#Read in a list of all protein sequences
NobtPro <- readAAStringSet("~/bigdata/Nobtusifolia/Genome_Files/NIOBT_r1.0.proteins.fa")

#Read in a list of the query protein names
NobtWanted <- read.csv("~/bigdata/Nobtusifolia/RNA-seq/Results_Ballgown/Nobt_Prev3DPA_DEGs.csv")

#strip off transcript suffix
NobtWanted$t_name <- substr(NobtWanted$t_name,1,nchar(as.character(NobtWanted$t_name))-3)
#split into up and down regulated
NobtUp <- NobtWanted[NobtWanted$fc>=1 & NobtWanted$qval<=0.05,]
NobtDown <- NobtWanted[NobtWanted$fc<1 & NobtWanted$qval<=0.05,]

#intersect the two list
NobtUpMatch <- NobtPro[match(NobtUp$t_name,names(NobtPro))]
NobtDownMatch <- NobtPro[match(NobtDown$t_name,names(NobtPro))]
#write it to a fasta file
writeXStringSet(NobtUpMatch, "NobtUp.fasta", format = "fasta")
writeXStringSet(NobtDownMatch, "NobtDown.fasta", format = "fasta")

#This section will deal with tomato, which is slightly different. We already have a list
#of GO terms for each protein, so we just need to reformat and intersect the two lists
SlycWanted <- read.csv("~/bigdata/Slycopersicum/slyc-WT/Slyc_1DPAv15DPA_DEGs.csv")
SlycUp <- SlycWanted[SlycWanted$fc>=1 & SlycWanted$q<=0.05,]
SlycDown <- SlycWanted[SlycWanted$fc<=1 & SlycWanted$q<=0.05,]

#get Go terms for each protein
library(topGO)

#read in all genes with Go terms
#I subbed out the | for ; in the .tsv file from SGN here to make it work
allGenes <- readMappings(file="~/bigdata/Slycopersicum/data/ITAG3.2_protein_go.tsv", sep="\t", IDsep=";")
names(allGenes) <- gsub('.{2}$', '', names(allGenes)) #remove transcript ID

#Write subset to a tsv file
write.table(file="SlycUp.tab", data.frame(GOTerm=I(unlist(lapply(allGenes[SlycUp$gene_name],paste,collapse="; ")))),sep = "\t", quote = FALSE, col.names = FALSE)
#down isnt working for some reason
#write.table(file="SlycDown.tab", data.frame(GOTerm=I(unlist(lapply(allGenes[SlycDown$gene_name],paste,collapse="; ")))),sep = "\t", quote = FALSE, col.names = FALSE)

#subset and write a list with only the upreg genes and their goterms to feed into other programs



