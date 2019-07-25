#Install libraries
#source("https://bioconductor.org/biocLite.R")
#biocLite("Rgraphviz")
library(topGO)
#Honestly Alex, you should make this a loop that generates all the graphs and just reads in different data

#Read in "gene universe"
NobtAll <- readMappings(file="NobtAll.tab", sep="\t", IDsep=";")
NobtAllNames <- names(NobtAll)

# Nobt Up -----------------------------------------------------------------
#make a list of upregualted genes with GO IDs from Uniprot
NobtUp <- readMappings(file="NobtUp.tab", sep="\t", IDsep=";")
NobtUp <- NobtUp[2:length(NobtUp)]
NobtUpNames <- names(NobtUp)

#Create a list of which genes in the larger list are "of interest"
NobtUpList <- factor(as.integer(NobtAllNames %in% NobtUpNames))
names(NobtUpList) <- NobtAllNames

#Black box to do that actual go analysis
NobtUpGOData <- new("topGOdata", description = "0 vs 6 DPA", ontology = "BP", allGenes = NobtUpList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=NobtAll)
#NobtUpGOData <- new("topGOdata", description = "0 vs 6 DPA", ontology = "MF", allGenes = NobtUpList, nodeSize = 10, annot = annFUN.gene2GO, gene2GO=NobtAll)
#NobtUpGOData <- new("topGOdata", description = "0 vs 6 DPA", ontology = "CC", allGenes = NobtUpList, nodeSize = 10, annot = annFUN.gene2GO, gene2GO=NobtAll)

#Summary of the analysis
NobtUpGOData

#Run enrichment test
NobtUpFisherWeightResults <- runTest(NobtUpGOData, algorithm="weight01", statistic = "fisher")

#Summary of test
NobtUpallRes <- GenTable(NobtUpGOData, Fisher = NobtUpFisherWeightResults, orderBy = "Fisher", ranksOf = "Fisher", topNodes = 20)
showSigOfNodes(NobtUpGOData, score(NobtUpFisherWeightResults), firstSigNodes = 10, useInfo = "all")
NobtUpallRes

#Make graph for plotting GO Terms
# from https://www.biostars.org/p/350710/
NobtUpGraph <- GenTable(NobtUpGOData,Fisher=NobtUpFisherWeightResults, orderBy=Fisher, topNodes=20)
NobtUpGraph <- NobtUpGraph[as.numeric(NobtUpGraph$Fisher)<0.05,c("GO.ID", "Term", "Fisher")]
NobtUpGraph$Term <- gsub(" [a-z]*\\.\\.\\.$", "", NobtUpGraph$Term) #clean elipses
NobtUpGraph$Term <- gsub("\\.\\.\\.$", "", NobtUpGraph$Term)
NobtUpGraph$Term <- paste(NobtUpGraph$GO.ID, NobtUpGraph$Term, sep=", ")
NobtUpGraph$Term <- factor(NobtUpGraph$Term, levels=rev(NobtUpGraph$Term))
NobtUpGraph$Fisher <- as.numeric(NobtUpGraph$Fisher)

require(ggplot2)
NobtUpPlot <- ggplot(NobtUpGraph, aes(x=Term, y=-log10(Fisher))) +
  stat_summary(geom = "bar", fun.y = mean, position = "dodge") +
  xlab("Biological Process") +
  ylab("Log Fold Enrichment") +
  ggtitle("Tobacco Genes Down at 6DPA") +
  scale_y_continuous(breaks = round(seq(0, max(-log10(NobtUpGraph$Fisher)), by = 2), 1)) +
  theme_bw(base_size=24) +
  theme(
    panel.grid = element_blank(),
    legend.position='none',
    legend.background=element_rect(),
    plot.title=element_text(angle=0, size=24, face="bold", vjust=1),
    axis.text.x=element_text(angle=0, size=18, face="bold", hjust=1.10),
    axis.text.y=element_text(angle=0, size=18, face="bold", vjust=0.5),
    axis.title=element_text(size=24, face="bold"),
    legend.key=element_blank(),     #removes the border
    legend.key.size=unit(1, "cm"),      #Sets overall area/size of the legend
    legend.text=element_text(size=18),  #Text size
    title=element_text(size=18)) +
  guides(colour=guide_legend(override.aes=list(size=2.5))) +
  coord_flip()



# Nobt Down ---------------------------------------------------------------
#make a list of upregualted genes with GO IDs from Uniprot
NobtDown <- readMappings(file="NobtDown.tab", sep="\t", IDsep=";")
NobtDown <- NobtDown[2:length(NobtDown)]
NobtDownNames <- names(NobtDown)

#Create a list of which genes in the larger list are "of interest"
NobtDownList <- factor(as.integer(NobtAllNames %in% NobtDownNames))
names(NobtDownList) <- NobtAllNames

#Black box to do that actual go analysis
NobtDownGOData <- new("topGOdata", description = "0 vs 6 DPA", ontology = "BP", allGenes = NobtDownList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=NobtAll)

#Summary of the analysis
NobtDownGOData

#Run enrichment test
NobtDownFisherWeight <- runTest(NobtDownGOData, algorithm="weight01", statistic="fisher")

#Summary of Test
NobtDownallRes <- GenTable(NobtDownGOData, Fisher=NobtDownFisherWeight, orderBy = "Fisher", ranksOf = "Fisher", topNodes = 20)
showSigOfNodes(NobtDownGOData, score(NobtDownFisherWeight), firstSigNodes = 10, useInfo = "all")

#Make graph for plotting GO Terms
# from https://www.biostars.org/p/350710/
NobtDownGraph <- GenTable(NobtDownGOData,Fisher=NobtDownFisherWeight, orderBy=Fisher, topNodes=20)
NobtDownGraph <- NobtDownGraph[as.numeric(NobtDownGraph$Fisher)<0.05,c("GO.ID", "Term", "Fisher")]
NobtDownGraph$Term <- gsub(" [a-z]*\\.\\.\\.$", "", NobtDownGraph$Term) #clean elipses
NobtDownGraph$Term <- gsub("\\.\\.\\.$", "", NobtDownGraph$Term)
NobtDownGraph$Term <- paste(NobtDownGraph$GO.ID, NobtDownGraph$Term, sep=", ")
NobtDownGraph$Term <- factor(NobtDownGraph$Term, levels=rev(NobtDownGraph$Term))
NobtDownGraph$Fisher <- as.numeric(NobtDownGraph$Fisher)

require(ggplot2)
NobtDownPlot <- ggplot(NobtDownGraph, aes(x=Term, y=-log10(Fisher))) +
  stat_summary(geom = "bar", fun.y = mean, position = "dodge") +
  xlab("Biological Process") +
  ylab("Log Fold Enrichment") +
  ggtitle("Tobacco Genes Up at 6DPA") +
  scale_y_continuous(breaks = round(seq(0, max(-log10(NobtDownGraph$Fisher)), by = 2), 1)) +
  theme_bw(base_size=24) +
  theme(
    panel.grid = element_blank(),
    legend.position='none',
    legend.background=element_rect(),
    plot.title=element_text(angle=0, size=24, face="bold", vjust=1),
    axis.text.x=element_text(angle=0, size=18, face="bold", hjust=1.10),
    axis.text.y=element_text(angle=0, size=18, face="bold", vjust=0.5),
    axis.title=element_text(size=24, face="bold"),
    legend.key=element_blank(),     #removes the border
    legend.key.size=unit(1, "cm"),      #Sets overall area/size of the legend
    legend.text=element_text(size=18),  #Text size
    title=element_text(size=18)) +
  guides(colour=guide_legend(override.aes=list(size=2.5))) +
  coord_flip()




#Read in "gene universe"
SlycAll <- readMappings(file="SlycAll.tab", sep="\t", IDsep=";")
SlycAllNames <- names(SlycAll)

# Slyc Up ----------------------------------------------------------------
#make a list of upregualted genes with GO IDs from Uniprot
SlycUp <- readMappings(file="SlycUp.tab", sep="\t", IDsep=";")
# SlycUp <- SlycUp[2:length(SlycUp)]
SlycUpNames <- names(SlycUp)

#Create a list of which genes in the larger list are "of interest"
SlycUpList <- factor(as.integer(SlycAllNames %in% SlycUpNames))
names(SlycUpList) <- SlycAllNames

#Black box to do that actual go analysis
SlycUpGOData <- new("topGOdata", description = "1 vs 15 DPA", ontology = "BP", allGenes = SlycUpList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=SlycAll)
#SlycUpGOData <- new("topGOdata", description = "1 vs 15 DPA", ontology = "MF", allGenes = SlycUpList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=SlycAll)
#SlycUpGOData <- new("topGOdata", description = "1 vs 15 DPA", ontology = "CC", allGenes = SlycUpList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=SlycAll)

#Summary of the analysis
SlycUpGOData

#Run enrichment test
SlycUpFisherWeightResults <- runTest(SlycUpGOData, algorithm="weight01", statistic = "fisher")

#Summary of test
SlycUpallRes <- GenTable(SlycUpGOData, Fisher = SlycUpFisherWeightResults, orderBy = "Fisher", ranksOf = "Fisher", topNodes = 20)
showSigOfNodes(SlycUpGOData, score(SlycUpFisherWeightResults), firstSigNodes = 4, useInfo = "all")
SlycUpallRes

#Make graph for plotting GO Terms
# from https://www.biostars.org/p/350710/
SlycUpGraph <- GenTable(SlycUpGOData,Fisher=SlycUpFisherWeightResults, orderBy=Fisher, topNodes=20)
SlycUpGraph <- SlycUpGraph[as.numeric(SlycUpGraph$Fisher)<0.05,c("GO.ID", "Term", "Fisher")]
SlycUpGraph$Term <- gsub(" [a-z]*\\.\\.\\.$", "", SlycUpGraph$Term) #clean elipses
SlycUpGraph$Term <- gsub("\\.\\.\\.$", "", SlycUpGraph$Term)
SlycUpGraph$Term <- paste(SlycUpGraph$GO.ID, SlycUpGraph$Term, sep=", ")
SlycUpGraph$Term <- factor(SlycUpGraph$Term, levels=rev(SlycUpGraph$Term))
SlycUpGraph$Fisher <- as.numeric(SlycUpGraph$Fisher)

require(ggplot2)
SlycUpPlot <- ggplot(SlycUpGraph, aes(x=Term, y=-log10(Fisher))) +
  stat_summary(geom = "bar", fun.y = mean, position = "dodge") +
  xlab("Biological Process") +
  ylab("Log Fold Enrichment") +
  ggtitle("Tomato Genes Down at 15DPA") +
  scale_y_continuous(breaks = round(seq(0, max(-log10(SlycUpGraph$Fisher)), by = 2), 1)) +
  theme_bw(base_size=24) +
  theme(
    panel.grid = element_blank(),
    legend.position='none',
    legend.background=element_rect(),
    plot.title=element_text(angle=0, size=24, face="bold", vjust=1),
    axis.text.x=element_text(angle=0, size=18, face="bold", hjust=1.10),
    axis.text.y=element_text(angle=0, size=18, face="bold", vjust=0.5),
    axis.title=element_text(size=24, face="bold"),
    legend.key=element_blank(),     #removes the border
    legend.key.size=unit(1, "cm"),      #Sets overall area/size of the legend
    legend.text=element_text(size=18),  #Text size
    title=element_text(size=18)) +
  guides(colour=guide_legend(override.aes=list(size=2.5))) +
  coord_flip()





# Slyc Down ---------------------------------------------------------------
#make a list of upregualted genes with GO IDs from Uniprot
SlycDown <- readMappings(file="SlycDown.tab", sep="\t", IDsep=";")
# SlycDown <- SlycDown[2:length(SlycDown)]
SlycDownNames <- names(SlycDown)

#Create a list of which genes in the larger list are "of interest"
SlycDownList <- factor(as.integer(SlycAllNames %in% SlycDownNames))
names(SlycDownList) <- SlycAllNames

#Black box to do that actual go analysis
SlycDownGOData <- new("topGOdata", description = "1 vs 15 DPA", ontology = "BP", allGenes = SlycDownList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=SlycAll)
#SlycDownGOData <- new("topGOdata", description = "1 vs 15 DPA", ontology = "MF", allGenes = SlycDownList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=SlycAll)
#SlycDownGOData <- new("topGOdata", description = "1 vs 15 DPA", ontology = "CC", allGenes = SlycDownList, nodeSize = 5, annot = annFUN.gene2GO, gene2GO=SlycAll)

#Summary of the analysis
SlycDownGOData

#Run enrichment test
SlycDownFisherWeightResults <- runTest(SlycDownGOData, algorithm="weight01", statistic = "fisher")

#Summary of test
SlycDownallRes <- GenTable(SlycDownGOData, Fisher = SlycDownFisherWeightResults, orderBy = "Fisher", ranksOf = "Fisher", topNodes = 20)
showSigOfNodes(SlycDownGOData, score(SlycDownFisherWeightResults), firstSigNodes = 4, useInfo = "all")
SlycDownallRes

#Make graph for plotting GO Terms
# from https://www.biostars.org/p/350710/
SlycDownGraph <- GenTable(SlycDownGOData,Fisher=SlycDownFisherWeightResults, orderBy=Fisher, topNodes=20)
SlycDownGraph <- SlycDownGraph[as.numeric(SlycDownGraph$Fisher)<0.05,c("GO.ID", "Term", "Fisher")]
SlycDownGraph$Term <- gsub(" [a-z]*\\.\\.\\.$", "", SlycDownGraph$Term) #clean elipses
SlycDownGraph$Term <- gsub("\\.\\.\\.$", "", SlycDownGraph$Term)
SlycDownGraph$Term <- paste(SlycDownGraph$GO.ID, SlycDownGraph$Term, sep=", ")
SlycDownGraph$Term <- factor(SlycDownGraph$Term, levels=rev(SlycDownGraph$Term))
SlycDownGraph$Fisher <- as.numeric(SlycDownGraph$Fisher)

require(ggplot2)
SlycDownPlot <- ggplot(SlycDownGraph, aes(x=Term, y=-log10(Fisher))) +
  stat_summary(geom = "bar", fun.y = mean, position = "dodge") +
  xlab("Biological Process") +
  ylab("Log Fold Enrichment") +
  ggtitle("Tomato Genes Up at 15DPA") +
  scale_y_continuous(breaks = round(seq(0, max(-log10(SlycDownGraph$Fisher)), by = 2), 1)) +
  theme_bw(base_size=24) +
  theme(
    panel.grid = element_blank(),
    legend.position='none',
    legend.background=element_rect(),
    plot.title=element_text(angle=0, size=24, face="bold", vjust=1),
    axis.text.x=element_text(angle=0, size=18, face="bold", hjust=1.10),
    axis.text.y=element_text(angle=0, size=18, face="bold", vjust=0.5),
    axis.title=element_text(size=24, face="bold"),
    legend.key=element_blank(),     #removes the border
    legend.key.size=unit(1, "cm"),      #Sets overall area/size of the legend
    legend.text=element_text(size=18),  #Text size
    title=element_text(size=18)) +
  guides(colour=guide_legend(override.aes=list(size=2.5))) +
  coord_flip()


#Save Outputs
pdf(file="NobtUp.pdf", height=10, width=17)
  NobtUpPlot
dev.off()

pdf(file="NobtDown.pdf", height=10, width=17)
  NobtDownPlot
dev.off()
  
pdf(file="SlycUp.pdf", height=10, width=17)
  SlycUpPlot
dev.off()

pdf(file="SlycDown.pdf", height=10, width=17)
  SlycDownPlot
dev.off()



