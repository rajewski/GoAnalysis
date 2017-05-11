## Create a list of genes of interest
This workflow starts with an arbitrary list of genes that are differnetially expressed. In this case the names of those genes correspond to the transcript names from the NIOBT_r1.0 genome. These names are saved into the "wanted.txt" file. I have a set of up and down regulated genes separately and these are eventually split apart before being fed into the later R script, so it is useful to have a list of these somewhere.

## Get peptide sequences
The R script IntersectPep.R is used to extract the amino acid sequence of the genes listed in the "wanted.txt" files from the NIOBT_r1.0.aa file, which is located elsewhere and must be provided. This outputs a "DEG_pep.fast" file.

## Get UniProt Accessions for genes
Because no functional annotation is yet available for the genome (Working on it!!), I decided to simply BLASTP these coding sequences against UniProt and take the best hit. This is done with the "blastp.sh" script. This script will have to be modified to take the DEG_pep.fasta as a query and to output the "DEG_pep.outfmt6" results file. At this stage it is useful to create separate lists of up and down regulated transcripts. I find that creating a dummy spreadsheet from the blast output is useful because it contains the original transcript names that were identified. I simply create two separate csv files with the UniProt Accession names of the up or down regualted files (simply named "up.csv" or "down.csv")

## Get GO Terms
This is the biggest kludge of the workflow. I can't seem to find a simple way to retrieve GO term IDs from the UniProt Accessions. I have been going to http://www.uniprot.org/uploadlists/ and uploading a list of accessions and retrieving the accessions and GO term IDs as an uncompressed tsv document. These output files are eventually fed into the GoEnrichment.R script.
