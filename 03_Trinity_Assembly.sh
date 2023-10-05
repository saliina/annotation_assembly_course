#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48GB
#SBATCH --time=1-00:00:00
#SBATCH --job-name=trinity
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_assembly_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_assembly_%j.e
#SBATCH --partition=pall

module load UHTS/Assembler/trinityrnaseq/2.5.1

INPUT_LEFT='/data/users/sjaegers/assembly_annotation_course/participant_2/RNAseq/ERR754061_1.fastq.gz'
INPUT_RIGHT='/data/users/sjaegers/assembly_annotation_course/participant_2/RNAseq/ERR754061_2.fastq.gz'
OUTPUT='/data/users/sjaegers/assembly_annotation_course/03_Assembly/Trinity'

mkdir $OUTPUT

cd /data/users/sjaegers/assembly_annotation_course/

Trinity --seqType fq --left $INPUT_LEFT --right $INPUT_RIGHT --CPU 12 --max_memory 48G --output $OUTPUT --SS_lib_type RF
