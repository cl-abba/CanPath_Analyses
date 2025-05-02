#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=20:00:00
#SBATCH --job-name=Index-bgen-BothSexes
#SBATCH --output=Index-bgen-BothSexes.out
#SBATCH --error=Index-bgen-BothSexes.err
#SBATCH --array=1-22
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=120G

module load nixpkgs/16.09 gcc/5.4.0 bgen/1.1.4

bgenix -g Chr${SLURM_ARRAY_TASK_ID}_AllCanPath_EUR_Clean_Final_BothSexes.bgen -index
