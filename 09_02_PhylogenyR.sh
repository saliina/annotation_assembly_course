#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=Phylogeny
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_Phylogeny_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_Phylogeny_%j.e
#SBATCH --partition=pall

Rscript plot_div.R