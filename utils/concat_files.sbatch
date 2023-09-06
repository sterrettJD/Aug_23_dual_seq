#!/bin/bash
#SBATCH -p short # Partition or queue.
#SBATCH --job-name=combine_fq # Job name
#SBATCH --mail-type=END # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=jost9358@colorado.edu
#SBATCH --nodes=1 # Only use a single node
#SBATCH --ntasks=1 # Run on a single CPU
#SBATCH --mem=12gb # Memory limit
#SBATCH --time=08:00:00 # Time limit hrs:min:sec
#SBATCH --output=/scratch/Users/jost9358/Aug_23_dual_seq/slurm_outs/combine_fq_%j.out # Standard output and error log
#SBATCH --error=/scratch/Users/jost9358/Aug_23_dual_seq/slurm_outs/combine_fq_%j.err # %j inserts job number

while getopts 1:2:o: flag
do
    case "${flag}" in
        1) file1=${OPTARG};;
        2) file2=${OPTARG};;
        o) outpath=${OPTARG};;
    esac
done

echo $1
echo $2 

cat $file1 $file2 > $outpath
echo "created combined fq"


