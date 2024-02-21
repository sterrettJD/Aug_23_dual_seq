#!/bin/bash
#SBATCH -p long # Partition or queue.
#SBATCH --job-name=HoMiCorr # Job name
#SBATCH --mail-type=ALL # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jost9358@colorado.edu
#SBATCH --nodes=1 # Only use a single node
#SBATCH --ntasks=32 # Run on 32 single CPUs
#SBATCH --mem=200gb # Memory limit
#SBATCH --time=48:00:00 # Time limit hrs:min:sec
#SBATCH --output=/scratch/Users/jost9358/Aug_23_dual_seq/slurm_outs/HoMiCorr_%j.out # Standard output and error log
#SBATCH --error=//scratch/Users/jost9358/Aug_23_dual_seq/slurm_outs/HoMiCorr_%j.err # %j inserts job number

source activate HoMiStats

Rscript Host-Microbe-Corr.R
