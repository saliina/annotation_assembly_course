#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=01:00:00
#SBATCH --job-name=mummer_comparison
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_mummer_comparison_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_mummer_comparison_%j.e
#SBATCH --partition=pall

### Run this script 2 times.
#1. assembly_name=canu; assembly=${polish_evaluation_dir}/polish/pilon/canu/canu.fasta
#2. assembly_name=flye; assembly=${polish_evaluation_dir}/polish/pilon/flye/flye.fasta

#Add the modules
module add UHTS/Analysis/mummer/4.0.0beta1
export PATH=/software/bin:$PATH

#Specify name of assembly 
ASSEMBLY_NAME=canu
ASSEMBLY_NAME_DIR=Canu
#ASSEMBLY_NAME=flye
#ASSEMBLY_NAME_DIR=Flye

#Specify directory structure and create them
BASE=/data/users/sjaegers/assembly_annotation_course
RAW_DATA=$BASE/rawdata
    COMPARISON=$BASE/06_Comparison
        NUCMER=$COMPARISON/Nucmer
            NUCMER_POLISHED=$NUCMER/Polished
            #NUCMER_POLISHED=$NUCMER/Non-polished
                NUCMER_ASSEMBLY=$NUCMER_POLISHED/$ASSEMBLY_NAME_DIR
        MUMMER=$COMPARISON/Mummer
            POLISHED=$MUMMER/Polished
            #POLISHED=$MUMMER/Non-polished
                MUMMER_ASSEMBLY=$POLISHED/$ASSEMBLY_NAME_DIR
    
mkdir $MUMMER
mkdir $POLISHED
mkdir $MUMMER_ASSEMBLY

#Specify the assembly to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
ASSEMBLY=$BASE/04_Polish/Pilon/Canu/canu.fasta #Polished canu assembly
#ASSEMBLY=$BASE/04_Polish/Pilon/Flye/flye.fasta #Polished flye assembly
#ASSEMBLY=$BASE/03_Assembly/Canu/pacbio_canu.contigs.fasta
#ASSEMBLY=$BASE/03_Assembly/Flye/assembly.fasta

#Specify the reference genome
REFERENCE=$RAW_DATA/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa


#Specify the delta file to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
DELTA=$NUCMER_ASSEMBLY/canu.delta #Not sure if this is right yet. Have to run nucmer first and see what the output is.
#DELTA=$NUCMER_ASSEMBLY/flye.delta #Not sure if this is right yet. Have to run nucmer first and see what the output is.

cd $MUMMER_ASSEMBLY

#Run mummerplot to show results
mummerplot -f -l -R $REFERENCE -Q $ASSEMBLY --large --png $DELTA -p $ASSEMBLY_NAME #png output does not work since there is no gnuplot on cluster, do it locally
