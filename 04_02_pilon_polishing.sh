#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=06:00:00
#SBATCH --job-name=pilon_polishing
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_pilon_polishing_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_pilon_polishing_%j.e
#SBATCH --partition=pall

#Create variables
BASE=/data/users/sjaegers/assembly_annotation_course

#Choose the names of the assembly for directories and files
ASSEMBLY_NAME_DIR=Canu
ASSEMBLY_NAME=canu
#ASSEMBLY_NAME_DIR=Flye
#ASSEMBLY_NAME=flye

#Create the directory structure
POLISH=$BASE/04_Polish
    PILON=$POLISH/Pilon
        PILON_ASSEMBLY=$PILON/$ASSEMBLY_NAME_DIR
    ALIGNMENT=$POLISH/Alignment/$ASSEMBLY_NAME_DIR
        
#Make the directories according to the structure above
mkdir $PILON     
mkdir $PILON_ASSEMBLY

#Specify the assembly to use
ASSEMBLY=$BASE/03_Assembly/Canu/pacbio_canu.contigs.fasta
#ASSEMBLY=$BASE/03_Assembly/Flye/assembly.fasta


#-------------------------------------------------------------------------------------------------------------------------#

###MAIN PART###
#Run pilon to polish the assemblies
java -Xmx45g -jar /mnt/software/UHTS/Analysis/pilon/1.22/bin/pilon-1.22.jar \
    --genome $ASSEMBLY --frags $ALIGNMENT/$ASSEMBLY_NAME.bam --output $ASSEMBLY_NAME --outdir $PILON_ASSEMBLY