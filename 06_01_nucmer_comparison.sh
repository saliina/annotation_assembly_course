#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=06:00:00
#SBATCH --job-name=nucmer_comparison
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_nucmer_comparison_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_nucmer_comparison_%j.e
#SBATCH --partition=pall

### Run this script 2 times.
#1. assembly_name=canu; assembly=${polish_evaluation_dir}/polish/pilon/canu/canu.fasta
#2. assembly_name=flye; assembly=${polish_evaluation_dir}/polish/pilon/flye/flye.fasta

#Add the modules
module add UHTS/Analysis/mummer/4.0.0beta1

#Specify name of assembly (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY_NAME=canu
#ASSEMBLY_NAME_DIR=Canu
ASSEMBLY_NAME=flye
ASSEMBLY_NAME_DIR=Flye

#Specify directory structure and create them
BASE=/data/users/sjaegers/assembly_annotation_course
RAW_DATA=$BASE/rawdata
    COMPARISON=$BASE/06_Comparison
        NUCMER=$COMPARISON/Nucmer
            POLISHED=$NUCMER/Polished
            #POLISHED=$NUCMER/Non-polished
                NUCMER_ASSEMBLY=$POLISHED/$ASSEMBLY_NAME_DIR
    
mkdir $COMPARISON
mkdir $NUCMER
mkdir $POLISHED
mkdir $NUCMER_ASSEMBLY

#Specify the assembly to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY=$BASE/04_Polish/Pilon/Canu/canu.fasta #Polished canu assembly
ASSEMBLY=$BASE/04_Polish/Pilon/Flye/flye.fasta #Polished flye assembly
#ASSEMBLY=$BASE/03_Assembly/Canu/pacbio_canu.contigs.fasta
#ASSEMBLY=$BASE/03_Assembly/Flye/assembly.fasta

#Specify the reference genome
REFERENCE=$RAW_DATA/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa

#Go to folder where results should be stored.
cd $NUCMER_ASSEMBLY

#Run nucmer to compare assemblies
nucmer -b 1000 -c 1000 -p $ASSEMBLY_NAME $REFERENCE $ASSEMBLY
        #Options entered here are:
            #"-b 1000": Distance an alignment extension will attempt to extend poor scoring regions before giving up (default 200)
            #"-c 1000": Minimum cluster length
            #"-p": Set the output file prefix