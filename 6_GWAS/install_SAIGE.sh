#!/bin/bash

#SBATCH --account=def-eparra
#SBATCH --time=5:00:00
#SBATCH --job-name=saige-install
#SBATCH --output=docker.out
#SBATCH --error=docker.err
#SBATCH --mail-user=c.abbatangelo@mail.utoronto.ca
#SBATCH --mail-type=ALL
#SBATCH --mem=5G

# module load singularity/3.8

# singularity build /home/abbatan1/saige_v1.0.5.sif docker://wzhou88/saige:1.0.5

# Load the appropriate version of Apptainer
module load apptainer/1.2.4

# Use Apptainer to build your container from the Docker hub image
apptainer build  /home/abbatan1/saige_v1.3.0.sif docker://wzhou88/saige:1.3.0

# Install the most up to date version of SAIGE
