#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=10G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --out ./history/blastp-%A.out
set -eu

#Download the database for blast searching
if [ ! -e uniprot_sprot.fasta ]; then
  echo $(date): Downloading SwissProt Database
  wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
  gunzip uniprot_sprot.fasta.gz
  echo $(date): Done
fi
  
#Do the search with Diamond
module load diamond/0.9.24
if [ ! -e uniprot.dmnd ]; then
  echo $(date): Making Diamond database.
  diamond makedb \
    --in uniprot_sprot.fasta \
    --db uniprot
  echo $(date): Done.
else
  echo $(date): Diamond database already present
fi

if [ ! -e Up.diamond.out ]; then
  echo $(date): Searching Up regulated genes on UniProt with DIAMOND
  diamond blastp \
    --db uniprot.dmnd \
    --sensitive \
    --outfmt 6 \
    --max-target-seqs 1 \
    --query ~/bigdata/Nobtusifolia/RNA-seq/Results_Ballgown/GoAnalysis/Up.fasta \
    -o Up.diamond.out
    cut -f2 Up.diamond.out | cut -d"|" -f2 > Up.uniprot
  echo $(date): Done.
else
  echo $(date): Diamond search already completed.
fi

if [ ! -e Down.diamond.out ]; then
  echo $(date): Searching Down Regulated Genes on UniProt with DIAMOND
  diamond blastp \
    --db uniprot.dmnd \
    --sensitive \
    --outfmt 6 \
    --max-target-seqs 1 \
    --query ~/bigdata/Nobtusifolia/RNA-seq/Results_Ballgown/GoAnalysis/Down.fasta \
    -o Down.diamond.out
    cut -f2 Down.diamond.out |cut -d"|" -f2 > Down.uniprot
  echo $(date): Done.
else
  echo $(date): Diamond search already completed.
fi

if [ ! -e All.diamond.out ]; then
  echo $(date): Searching All Genes on UniProt with DIAMOND
  diamond blastp \
    --db uniprot.dmnd \
    --sensitive \
    --outfmt 6 \
    --max-target-seqs 1 \
    --query ~/bigdata/Nobtusifolia/Genome_Files/NIOBT_r1.0.proteins.fa \
    -o All.diamond.out
    cut -f2 All.diamond.out |cut -d"|" -f2 > All.uniprot
  echo $(date): Done.
else
  echo $(date): Diamond search already completed.
fi



# echo $(date): Loading BLAST
# module load ncbi-blast/2.2.30+
# echo $(date): Done
# 
# if [ ! -e uniprot_sprot.fasta.pin ]; then
#   echo $(date): Making UniProt BLAST database
#   makeblastdb \
#     -in uniprot_sprot.fasta \
#     -parse_seqids \
#     -title "UniProt" \
#     -dbtype prot
#   echo $(date): Done.
# fi
# 
# #BLAST Search
# if [ ! -e DEG_pep.outfmt6 ]; then
#   echo $(date): "Searching for Uniprot hits with BLASTp"
#   blastp \
#     -query ~/bigdata/Nobtusifolia/RNA-seq/Results_Ballgown/GoAnalysis/DEG_pep.fasta  \
#     -db uniprot_sprot.fasta \
#     -num_threads $SLURM_NTASKS \
#     -max_target_seqs 1 \
#     -outfmt 6 \
#     > DEG_pep.outfmt6
#   echo $(date): Done.
# else
#   echo $(date): BLAST search already completed.
# fi

scontrol show job $SLURM_JOB_ID
