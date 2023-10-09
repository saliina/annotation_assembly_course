#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=06:00:00
#SBATCH --job-name=mummer_comparison
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=begin,end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_mummer_comparison_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_mummer_comparison_%j.e
#SBATCH --partition=pall

### Run this script 2 times.
#1. assembly_name=canu; assembly=${polish_evaluation_dir}/polish/pilon/canu/canu.fasta
#2. assembly_name=flye; assembly=${polish_evaluation_dir}/polish/pilon/flye/flye.fasta

#Add the modules
module add UHTS/Analysis/mummer/4.0.0beta1

#Specify name of assembly (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
ASSEMBLY_NAME=canu
ASSEMBLY_NAME_DIR=Canu
#ASSEMBLY_NAME=flye
#ASSEMBLY_NAME_DIR=Flye

#Specify directory structure and create them
BASE=/data/users/sjaegers/assembly_annotation_course
RAW_DATA=$BASE/rawdata
    COMPARISON=$BASE/06_Comparison
        NUCMER=$COMPARISON/Nucmer
            NUCMER_ASSEMBLY=$NUCMER/$ASSEMBLY_NAME_DIR
        MUMMER=$COMPARISON/Mummer
            MUMMER_ASSEMBLY=$MUMMER/$ASSEMBLY_NAME_DIR
    
mkdir $MUMMER
mkdir $MUMMER_ASSEMBLY

#Specify the assembly to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
ASSEMBLY=$BASE/04_Polish/Pilon/Canu/canu.fasta #Polished canu assembly
#ASSEMBLY=$BASE/04_Polish/Pilon/Flye/flye.fasta #Polished flye assembly

#Specify the reference genome
REFERENCE=$RAW_DATA/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa


#Specify the delta file to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
DELTA=$NUCMER_ASSEMBLY/canu.delta #Not sure if this is right yet. Have to run nucmer first and see what the output is.
#DELTAe=$NUCMER_ASSEMBLY/flye.delta #Not sure if this is right yet. Have to run nucmer first and see what the output is.


#Run mummerplot to show results
mummerplot -f -l -R $REFERENCE -Q $ASSEMBLY --large --png $DELTA
        #Options entered here are:
            #"-f": Only display alignments which represent the "best" one-to-one mapping of reference and query subsequences (requires delta formatted input)
            #"-l": Layout a multiplot by ordering and orienting sequences such that the largest hits cluster near the main diagonal (requires delta formatted input)
            #"-R": Generate a multiplot by using the order and length information contained in this file, either a FastA file of the desired reference sequences or a tab-delimited list of sequence IDs, lengths and orientations [ +-]
            #"-Q": Generate a multiplot by using the order and length information contained in this file, either a FastA file of the desired query sequences or a tab-delimited list of sequence IDs, lengths and orientations [ +-]
            #"--large": Set the output size to small, medium or large --small --medium --large
            #"--png": Set the output terminal to x11, postscript or png