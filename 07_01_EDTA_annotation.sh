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




COURSEDIR=/data/courses/assembly-annotation-course
  CDS=$COURSEDIR/CDS_annotation/TAIR10_cds_20110103_representative_gene_model_updated 
BASE=/data/users/sjaegers/assembly_annotation_course
  WORKDIR=$BASE/07_Annotation/EDTA
  ASSEMBLY=$BASE/04_Polish/Pilon/Flye
RAWDATA=$BASE/rawdata

mkdir $BASE/07_Annotation
mkdir $WORKDIR

cd $WORKDIR

singularity exec \
--bind $COURSEDIR \
--bind $WORKDIR \
--bind $ASSEMBLY \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
EDTA.pl \
  --genome $ASSEMBLY/flye.fasta  \
  --species others \
  --step all \
  --cds $CDS \
  --anno 1 \
  --threads 50   #Number of threads to run this script (default: 4)