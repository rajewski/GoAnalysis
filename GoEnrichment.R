#Install libraries
source("https://bioconductor.org/biocLite.R")
biocLite("topGO")
biocLite("Rgraphviz")
library(topGO)

#Read in "gene universe"
allGenes <- readMappings(file="NIOBT_r1.0.Uniprot.tab", sep="\t", IDsep=";")
allGeneNames <- names(allGenes)

#make a list of upregualted genes with GO IDs from Uniprot
upReg <- readMappings(file="UniprotUp.tab", sep="\t", IDsep=";")
upReg <- upReg[2:length(upReg)]
geneNamesUp <- names(upReg)

#Create a list of which genes in the larger list are "of interest"
geneListup <- factor(as.integer(allGeneNames %in% geneNamesUp))
names(geneListup) <- allGeneNames

#Black box to do that actual go analysis
sampleGOdataUp <- new("topGOdata", description = "0 vs 3 DPA", ontology = "BP", allGenes = geneListup, nodeSize = 10, annot = annFUN.gene2GO, gene2GO=allGenes)

#Summary of the analysis
sampleGOdataUp

#Run several enrichment tests
resultFisherUp <- runTest(sampleGOdataUp, algorithm = "classic", statistic = "fisher")
resultKSUp <- runTest(sampleGOdataUp, algorithm = "classic", statistic = "ks")
resultKS.elimUp <- runTest(sampleGOdataUp, algorithm = "elim", statistic = "ks")

allResUp <- GenTable(sampleGOdataUp, classicFisher = resultFisherUp, classicKS = resultKSUp, elimKS = resultKS.elimUp, orderBy = "elimKS", ranksOf = "classicFisher", topNodes = 10)

showSigOfNodes(sampleGOdataUp, score(resultFisherUp), firstSigNodes = 10, useInfo = "all")


#########Repeat for downregulated genes
#make a list of upregualted genes with GO IDs from Uniprot
downReg <- readMappings(file="UniprotDown.tab", sep="\t", IDsep=";")
downReg <- downReg[2:length(downReg)]
geneNamesDown <- names(downReg)

#Create a list of which genes in the larger list are "of interest"
geneListdown <- factor(as.integer(allGeneNames %in% geneNamesDown))
names(geneListdown) <- allGeneNames

#Black box to do that actual go analysis
sampleGOdataDown <- new("topGOdata", description = "0 vs 3 DPA", ontology = "BP", allGenes = geneListdown, nodeSize = 10, annot = annFUN.gene2GO, gene2GO=allGenes)

#Summary of the analysis
sampleGOdataDown

#Run several enrichment tests
resultFisherDown <- runTest(sampleGOdataDown, algorithm = "classic", statistic = "fisher")
resultKSDown <- runTest(sampleGOdataDown, algorithm = "classic", statistic = "ks")
resultKS.elimDown <- runTest(sampleGOdataDown, algorithm = "elim", statistic = "ks")

allResDown <- GenTable(sampleGOdataDown, classicFisher = resultFisherDown, classicKS = resultKSDown, elimKS = resultKS.elimDown, orderBy = "elimKS", ranksOf = "classicFisher", topNodes = 35)

showSigOfNodes(sampleGOdataDown, score(resultFisherDown), firstSigNodes = 10, useInfo = "all")
