#!/bin/bash
#SBATCH --job-name=219eeg
#SBATCH --output=log-%j.txt
#SBATCH --nodes=1
#SBATCH --ntasks=15
#SBACTH --ntasks-per-node=15
#SBATCH --partition=general
#SBATCH --time=99:00:00
#SBATCH --mail-type=END  	  # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=jdeleeuw@vassar.edu

cd ~/219-2023

srun --ntasks=1 Rscript run-preprocess-hpc.R 01 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 02 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 03 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 04 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 05 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 08 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 09 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 10 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 11 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 12 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 13 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 14 &
srun --ntasks=1 Rscript run-preprocess-hpc.R 15 &

wait