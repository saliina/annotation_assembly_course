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

module load UHTS/Quality_control/fastqc/0.11.9
mkdir /data/users/sjaegers/assembly_annotation_course/01_FASTQC
cd /data/users/sjaegers/assembly_annotation_course/01_FASTQC

INPUT=/data/users/sjaegers/assembly_annotation_course/participant_2




for folder in $INPUT/*;
do
    mkdir /data/users/sjaegers/assembly_annotation_course/01_FASTQC/$(basename $folder)
    for file in $folder/*;
    do
        fastqc $file -o /data/users/sjaegers/assembly_annotation_course/01_FASTQC/$(basename $folder)
    done    
done

