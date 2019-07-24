#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=16G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL
#SBATCH --out ./history/2_Diamond-%A.out
set -eu

#Do the search with Diamond
module load diamond/0.9.24
if [ ! -e uniprot.dmnd ]; then
  echo $(date): Downloading SwissProt Database
  wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
  gunzip uniprot_sprot.fasta.gz
  echo $(date): Done
  echo $(date): Making Diamond database.
  diamond makedb \
    --in uniprot_sprot.fasta \
    --db uniprot
  echo $(date): Done.
else
  echo $(date): Diamond database already present
fi

if [ ! -e NobtUp.dmndo ]; then
  echo $(date): Searching Up regulated genes on UniProt with DIAMOND
  diamond blastp \
    --db uniprot.dmnd \
    -p $SLURM_NTASKS \
    --sensitive \
    --outfmt 6 \
    --max-target-seqs 1 \
    --query ~/bigdata/Nobtusifolia/RNA-seq/Results_Ballgown/GoAnalysis/NobtUp.fasta \
    -o NobtUp.dmndo
    cut -f2 NobtUp.dmndo | cut -d"|" -f2 > NobtUp.uniprot
  echo $(date): Done.
else
  echo $(date): Diamond search already completed.
fi

if [ ! -e NobtDown.dmndo ]; then
  echo $(date): Searching Down Regulated Genes on UniProt with DIAMOND
  diamond blastp \
    --db uniprot.dmnd \
    -p $SLURM_NTASKS \
    --sensitive \
    --outfmt 6 \
    --max-target-seqs 1 \
    --query ~/bigdata/Nobtusifolia/RNA-seq/Results_Ballgown/GoAnalysis/NobtDown.fasta \
    -o NobtDown.dmndo
    cut -f2 NobtDown.dmndo |cut -d"|" -f2 > NobtDown.uniprot
  echo $(date): Done.
else
  echo $(date): Diamond search already completed.
fi

if [ ! -e NobtAll.dmndo ]; then
  echo $(date): Searching All Genes on UniProt with DIAMOND
  diamond blastp \
    --db uniprot.dmnd \
    --sensitive \
    --outfmt 6 \
    --max-target-seqs 1 \
    --query ~/bigdata/Nobtusifolia/Genome_Files/NIOBT_r1.0.proteins.fa \
    -o NobtAll.dmndo
    cut -f2 NobtAll.dmndo |cut -d"|" -f2 > NobtAll.uniprot
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
