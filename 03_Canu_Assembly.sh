#!/usr/bin/env bash

#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH --time=10:00:00
#SBATCH --job-name=canu
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_assembly_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_assembly_%j.e
#SBATCH --partition=pall


module load UHTS/Assembler/canu/2.1.1

INPUT="/data/users/sjaegers/assembly_annotation_course/participant_2/pacbio/*.fastq.gz"
OUTPUT="/data/users/sjaegers/assembly_annotation_course/03_Assembly/Canu"



mkdir $OUTPUT

cd /data/users/sjaegers/assembly_annotation_course/


canu -p pacbio_canu -d $OUTPUT genomeSize=124m -pacbio $INPUT maxThreads=16 maxMemory=64 gridEngineResourceOption="--cpus-per-task=THREADS --mem-per-cpu=MEMORY --time=2-00:00:00"