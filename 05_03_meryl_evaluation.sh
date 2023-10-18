#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --job-name=meryl_evaluation
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_meryl_evaluation_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_meryl_evaluation_%j.e
#SBATCH --partition=pall

### Run this script 1 time.

#Add the modules
module add UHTS/Assembler/canu/2.1.1

#Specify directory structure and create them
BASE=/data/users/sjaegers/assembly_annotation_course
    EVALUATION=$BASE/05_Evaluation
        MERYL=$EVALUATION/Meryl
    
mkdir $MERYL

######CHANGE THIS LINK BROOOOO#####
#Specify where the raw reads are stored (no soft link)
SOURCE_DATA=/data/courses/assembly-annotation-course/raw_data/An-1/participant_2/Illumina

#Run meryl to create db for merqury
meryl k=19 count output $SCRATCH/read_1.meryl $SOURCE_DATA/*1.fastq.gz
meryl k=19 count output $SCRATCH/read_2.meryl $SOURCE_DATA/*2.fastq.gz
meryl union-sum output $MERYL/genome.meryl $SCRATCH/read*.meryl