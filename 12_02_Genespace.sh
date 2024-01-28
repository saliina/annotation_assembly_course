#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=10GB
#SBATCH --time=05:00:00
#SBATCH --job-name=Genespace
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_genespace_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_genespace_%j.e
#SBATCH --partition=pall

#Specify directory structure and create them
    BASE=/data/users/sjaegers/assembly_annotation_course
        INPUT=$BASE/10_Maker/An-1-2.maker.output
        GENESPACE=$BASE/12_Genespace
        SCRIPT=$BASE/scripts
            RGENESPACE=$SCRIPT/12_Genespace.R
            IMAGE=$SCRIPT/genespace_1.1.4.sif
            RORTHOFINDER=$SCRIPT/Parse_Orthofinder.R


    COURSEDIR=/data/courses/assembly-annotation-course/CDS_annotation/Genespace
        

#cd $SCRIPT
#
#apptainer exec --bind $GENESPACE --bind $SCRIPT $IMAGE Rscript $RGENESPACE


#activate conda env R-Orthofinder before running this part
#/home/sjaegers/.conda/envs/R-Orthofinder
cd $GENESPACE
Rscript $RORTHOFINDER


