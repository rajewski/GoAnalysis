## Summary
The overall goal of this git project is to produce a series of graphs showing GO enrichment. This particular project is centered around both Solanum lycopersicum (tomato) and Nicotiana obtusifolia (desert tobacco), which are typically abbreviated Slyc and Nobt, respectively.

## Find protein seuqences for DEGs
This workflow starts with several lists of gene names flagged as differentialyl expressed based on DEseq2 analysis. In the case of Nobt, this first file is Nobt_Prev16_DESeq_Up.csv, representing the list of upregulated genes between prenthesis and 1 day post anthesis. Similar lists are on hand for down regulated genes and for Slyc. In all cases the script 1_InstersectPep.R is used to get the protein sequences for these gene identifiers. The peptide sequences are pulled from a fasta file of all proteins in the genome, NIOBT_r1.0.proteins.fa in the case on Nobt. This script does some light cleaning of the gene/transcript names to make them compatible for later analyses, and outputs a file called NobtUp.fasta, or similar for down regulated genes or Slyc genes. This fasta file contains the gene names and protein sequences for all of the upregulated genes in Nobt for this analysis.

In the case of Slyc, GO terms had already been mapped by ITAG, and were simply downloaded. This required a bit of finessing to get the two species' datasets in the same format, and that step is done in the same 1_IntersectPep.sh script.


## Get best UniProt hits for proteins
In the case of Nobt, GO terms have not been mapped to most genes yet, though I am working on it. To get around this, the output fasta files from 1_IntersectPep.R (e.g. NobtUp.fasta) are used as a query for a blastp search of UniProt. This search is conducted using DIAMOND instead of BLAST to speed things up a bit with the 2_Diamond.sh script. If necessary, this script will download and create a UniProt database to search through locally. For each protein in the input file, the single best hit is returned. Additionally, this script  runs on a list of all proteins from Nobt in order to eventually get a list of "background" GO terms against which the enrichment will be calculated.

This script works sequentially on all three output protein fasta files from 1_IntersectPep.R and creates three DIAMOND search output files suffixed with .dmndo. Using a simple shell one-liner, the UniPro accession ID is cut out and written to a separte file suffixed with .uniprot. 


## Get GO Terms
This is the biggest kludge of the workflow and I apologize. I can't seem to find a simple way to retrieve GO term IDs from the UniProt Accessions. 

I have been going to http://www.uniprot.org/uploadlists/ and searching the UniProt databased with the .uniprot output file produced by 2_Diamond.sh. The results columns from UniProt can then be customized to only display the accession ID and the GO terms. This list is downloaded as a .tab file retaining the same name as the input .uniprot file. That is, if NobtUp.uniprot is the query file, NobtUp.tab will be the downloaded results file containing one column with accession IDs and one with the GO terms. 

## Running the GO Enrichment Script
With the list of GO terms for each set of DEGs, now the actualy enrichment test can be conducted by 3_GoEnrichment.R. This begins with a lot of data processing steps before the analysis itself is conducted. The node size of the test can be modified, but I have started with it at 5 in the new() function. Additionally, you can adjust the number of GO terms reported by the analysis in the GenTable() function. I do not find the actual networks that are output by topGO to be that useful for visualization, but the graphs with the enrichment are very helpful.

