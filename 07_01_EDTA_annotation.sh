#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=EDTA_annotation
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_EDTA_annotation_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_EDTA_annotation_%j.e
#SBATCH --partition=pall




COURSEDIR = /data/courses/assembly-annotation-course
WORKDIR = /data/users/sjaegers/assembly_annotation_course/07_Annotation/EDTA
ASSEMBLY = /data/users/sjaegers/assembly_annotation_course/04_Polish/Pilon/Flye/flye.fasta
CDS = /data/courses/assembly-annotation-course/CDS_annotation/TAIR10_cds_20110103_representative_gene_model_updated 

mkdir /data/users/sjaegers/assembly_annotation_course/07_Annotation
mkdir /data/users/sjaegers/assembly_annotation_course/07_Annotation/EDTA

cd $WORKDIR

singularity exec \
--bind $COURSEDIR \
--bind $WORKDIR \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
EDTA.pl \
  --genome $ASSEMBLY  \
  --species others \
  --step all \
  --cds $CDS \
  --anno 1 \
  --threads 50   #Number of threads to run this script (default: 4)