#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

module load ncbi-blast

blastp -query ../../../../Genome_Files/NIOBT_r1.0.aa  -db uniprotblast.pep -num_threads 16 -max_target_seqs 1 -outfmt 6 > NIOBT_r1.0.aa.outfmt6

