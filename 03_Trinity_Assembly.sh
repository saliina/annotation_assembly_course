#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48GB
#SBATCH --time=1-00:00:00
#SBATCH --job-name=trinity
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=fail,end
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall

module load UHTS/Assembler/trinityrnaseq/2.5.1

cd /data/users/sjaegers/assembly_annotation_course/

Trinity --seqType fq --left ./participant_2/RNAseq/ERR754061_1.fastq.gz --right ./participant_2/RNAseq/ERR754061_2.fastq.gz --CPU 12 --max_memory 48G
