#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=64G
#SBATCH --time=08:00:00
#SBATCH --job-name=merqury_evaluation
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_merqury_evaluation_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_merqury_evaluation_%j.e
#SBATCH --partition=pall

### Run this script 4 times.
#1. assembly_name=canu; evaulation_dir=${polish_evaluation_dir}/evaluation;           meryl_dir=${evaulation_dir}/meryl;                   assembly=${polish_evaluation_dir}/polish/pilon/canu/canu.fasta 
#2. assembly_name=flye; evaulation_dir=${polish_evaluation_dir}/evaluation;           meryl_dir=${evaulation_dir}/meryl;                   assembly=${polish_evaluation_dir}/polish/pilon/flye/flye.fasta
#3. assembly_name=canu; evaulation_dir=${polish_evaluation_dir}/evaluation_no_polish; meryl_dir=${polish_evaluation_dir}/evaluation/meryl; assembly=${course_dir}/02_assembly/canu/canu.contigs.fasta
#4. assembly_name=flye; evaulation_dir=${polish_evaluation_dir}/evaluation_no_polish; meryl_dir=${polish_evaluation_dir}/evaluation/meryl; assembly=${course_dir}/02_assembly/flye/assembly.fasta

#Specify name of assembly (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY_NAME=canu
#ASSEMBLY_NAME_DIR=Canu
ASSEMBLY_NAME=flye
ASSEMBLY_NAME_DIR=Flye

#Specify directory structure and create them
BASE=/data/users/sjaegers/assembly_annotation_course
RAW_DATA=$BASE/rawdata
    EVALUATION=$BASE/05_Evaluation
        POLISH=$EVALUATION/with_polish
        #POLISH=$EVALUATION/no_polish #Use this instead of the upper one when analysing the not polished assemblies
        MERYL=$EVALUATION/Meryl
            MERQURY=$POLISH/merqury
                MERQURY_ASSEMBLY=$MERQURY/$ASSEMBLY_NAME_DIR
    
    mkdir $MERQURY
    mkdir $MERQURY_ASSEMBLY

#Specify the assembly to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY=$BASE/04_Polish/Pilon/Canu/canu.fasta #Polished canu assembly
#ASSEMBLY=$BASE/03_Assembly/Canu/pacbio_canu.contigs.fasta #Unpolished canu assembly
ASSEMBLY=$BASE/04_Polish/Pilon/Flye/flye.fasta #Polished flye assembly
#ASSEMBLY=$BASE/03_Assembly/Flye/assembly.fasta #Unpolished flye assembly

#Change permisson of assembly otherwise there is an error and go to folder where results should be stored.
chmod ugo+rwx $ASSEMBLY
cd $MERQURY_ASSEMBLY

#Run merqury to assess quality of the assemblies; do not indent
apptainer exec \
--bind $BASE \
/software/singularity/containers/Merqury-1.3-1.ubuntu20.sif \
merqury.sh $MERYL/genome.meryl $ASSEMBLY $ASSEMBLY_NAME_DIR