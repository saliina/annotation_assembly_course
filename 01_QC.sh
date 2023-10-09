#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB
#SBATCH --time=01:00:00
#SBATCH --job-name=fastqc
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

#Add modules
module load UHTS/Quality_control/fastqc/0.11.9

#Define variables
INPUT=/data/users/sjaegers/assembly_annotation_course/participant_2/
BASE=/data/users/sjaegers/assembly_annotation_course/01_FASTQC/

#Make the general output directory for the fastqc step
mkdir $BASE

#Do fastqc for all 3 paired reads
for folder in $INPUT/*;
do
    mkdir $BASE$(basename $folder)
    for file in $folder/*;
    do
        fastqc $file -o $BASE$(basename $folder)
    done    
done

