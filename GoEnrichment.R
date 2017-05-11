#Install libraries
source("https://bioconductor.org/biocLite.R")
biocLite("topGO")
biocLite("Rgraphviz")
library(topGO)

#make a list of genes with GO IDs from Uniprot
DEGs <- readMappings(file="Uniprotout.tab", sep="\t", IDsep=";")
geneNames <- names(DEGs)

#Get a list of the upregulated genes
upReg <- read.csv(file="up.csv", header=FALSE,stringsAsFactors = FALSE)

#Create a list of which genes in the larger list are "of interest"
geneListup <- factor(as.integer(names(DEGs) %in% upReg$V1))
names(geneListup) <- geneNames
geneListdown <- factor(as.integer(!(names(DEGs) %in% upReg$V1)))
names(geneListdown) <- geneNames

#Black box to do that actual go analysis
sampleGOdataUp <- new("topGOdata", description = "0 vs 3 DPA", ontology = "BP", allGenes = geneListup, geneSel = DEGs, nodeSize = 10, annot = annFUN.gene2GO, gene2GO=DEGs)

#Summary of the analysis
sampleGOdataUp

#Run several enrichment tests
resultFisherUp <- runTest(sampleGOdataUp, algorithm = "classic", statistic = "fisher")
resultKSUp <- runTest(sampleGOdataUp, algorithm = "classic", statistic = "ks")
resultKS.elimUp <- runTest(sampleGOdataUp, algorithm = "elim", statistic = "ks")

allResUp <- GenTable(sampleGOdataUp, classicFisher = resultFisherUp, classicKS = resultKSUp, elimKS = resultKS.elimUp, orderBy = "elimKS", ranksOf = "classicFisher", topNodes = 10)

showSigOfNodes(sampleGOdataUp, score(resultKS.elimUp), firstSigNodes = 5, useInfo = "all")


#Repeat for downregulated genes
sampleGOdataDown <- new("topGOdata", description = "0 vs 3 DPA", ontology = "BP", allGenes = geneListdown, geneSel = DEGs, nodeSize = 10, annot = annFUN.gene2GO, gene2GO=DEGs)

#Summary of the analysis
sampleGOdataDown

#Run several enrichment tests
resultFisherDown <- runTest(sampleGOdataDown, algorithm = "classic", statistic = "fisher")
resultKSDown <- runTest(sampleGOdataDown, algorithm = "classic", statistic = "ks")
resultKS.elimDown <- runTest(sampleGOdataDown, algorithm = "elim", statistic = "ks")

allResDown <- GenTable(sampleGOdataDown, classicFisher = resultFisherDown, classicKS = resultKSDown, elimKS = resultKS.elimDown, orderBy = "elimKS", ranksOf = "classicFisher", topNodes = 10)

showSigOfNodes(sampleGOdataDown, score(resultKS.elimDown), firstSigNodes = 5, useInfo = "all")
