#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=06:00:00
#SBATCH --job-name=BUSCO_evaluation
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_BUSCO_evaluation_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_BUSCO_evaluation_%j.e
#SBATCH --partition=pall

### Run this script 5 times.
#1. assembly_name=canu;    evaulation_dir=${polish_evaluation_dir}/evaluation;           assembly=${polish_evaluation_dir}/polish/pilon/canu/canu.fasta 
#2. assembly_name=flye;    evaulation_dir=${polish_evaluation_dir}/evaluation;           assembly=${polish_evaluation_dir}/polish/pilon/flye/flye.fasta
#3. assembly_name=trinity; evaulation_dir=${polish_evaluation_dir}/evaluation;           assembly=${course_dir}/02_assembly/trinity/Trinity.fasta
#4. assembly_name=canu;    evaulation_dir=${polish_evaluation_dir}/evaluation_no_polish; assembly=${course_dir}/02_assembly/canu/canu.contigs.fasta
#5. assembly_name=flye;    evaulation_dir=${polish_evaluation_dir}/evaluation_no_polish; assembly=${course_dir}/02_assembly/flye/assembly.fasta

#Add the modules
module add UHTS/Analysis/busco/4.1.4

#Specify name of assembly (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY_NAME_DIR=Canu
#ASSEMBLY_NAME_DIR=Flye
ASSEMBLY_NAME_DIR=Trinity

#Specify directory structure and create them
BASE=/data/users/sjaegers/assembly_annotation_course
    EVALUATION=$BASE/05_Evaluation
        POLISH=$EVALUATION/with_polish
        #POLISH=$EVALUATION/no_polish #Use this instead of the upper one when analysing the not polished assemblies
            BUSCO=$POLISH/BUSCO
                BUSCO_ASSEMBLY=$BUSCO/$ASSEMBLY_NAME_DIR
    
mkdir $EVALUATION
mkdir $POLISH
mkdir $BUSCO
mkdir $BUSCO_ASSEMBLY

#Specify the assembly to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY=$BASE/04_Polish/Pilon/Canu/canu.fasta #Polished canu assembly
#ASSEMBLY=$BASE/03_Assembly/Canu/pacbio_canu.contigs.fasta #Unpolished canu assembly
#ASSEMBLY=$BASE/04_Polish/Pilon/Flye/flye.fasta #Polished flye assembly
#ASSEMBLY=$BASE/03_Assembly/Flye/assembly.fasta #Unpolished flye assembly
ASSEMBLY=$BASE/03_Assembly/Trinity/Trinity.fasta #Unpolished trinity assembly -> but is in evaulation folder (trinity polishes itself)

#Go to folder where the evaluation results will be stored
cd $BUSCO_ASSEMBLY

#Make a copy of the augustus config directory to a location where I have write permission
cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config augustus_config
export AUGUSTUS_CONFIG_PATH=./augustus_config

#Run busco to assess the quality of the assemblies
busco -i $ASSEMBLY -l brassicales_odb10 -o $ASSEMBLY_NAME_DIR -m genome --cpu 12
        #Options entered here are:
            #"-i": Input sequence file in FASTA format. Can be an assembled genome or transcriptome (DNA), or protein sequences from an annotated gene set.
            #"-l": Specify the name of the BUSCO lineage to be used.
            #"-o": defines the folder that will contain all results, logs, and intermediate data
            #"-m": Specify which BUSCO analysis mode to run, genome, proteins, transcriptome (!!!FOR THE CANU AND FLYE ASSEMBLY I USE GENOME AND FOR THE TRINITRY ASSEMBLY I USE TRANSCRIPTOME!!!)
            #"--cpu": Specify the number (N=integer) of threads/cores to use.

#Remove the augustus config directory again
rm -r ./augustus_config