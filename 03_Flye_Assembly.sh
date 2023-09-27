#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --time=1-00:00:00
#SBATCH --job-name=flye
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

module load UHTS/Assembler/flye/2.8.3

INPUT='/data/users/sjaegers/assembly_annotation_course/participant_2/pacbio/*'
OUTPUT='/data/users/sjaegers/assembly_annotation_course/03_Assembly/Flye'

mkdir $OUTPUT

cd /data/users/sjaegers/assembly_annotation_course/

flye -t 16 -o $OUTPUT --pacbio-raw $INPUT --genome-size 124m
