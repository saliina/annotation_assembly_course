#!/usr/bin/env bash

#SBATCH --cpus-per-task=50
#SBATCH --mem=10G
#SBATCH --time=05:00:00
#SBATCH --job-name=TA_sorting
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_TA_sorting_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_TA_sorting_%j.e
#SBATCH --partition=pall


BASE=/data/users/sjaegers/assembly_annotation_course
ANNOTATION=$BASE/07_Annotation
    EDTA=/data/courses/assembly-annotation-course/CDS_annotation/EDTA_v1.9.6_new
    #EDTA=$ANNOTATION/EDTA
    TE=$ANNOTATION/TE
        OUTPUT_GYPSY=$TE/Gypsy
        OUTPUT_COPIA=$TE/Copia
DATABASE=/data/courses/assembly-annotation-course/CDS_annotation/Brassicaceae_repbase_all_march2019.fasta
COURSEDIR=/data/courses/assembly-annotation-course


mkdir $ANNOTATION
mkdir $TE

cd $TE

#filter out the copia and gyspsy superfamilies
grep -A1 'Gypsy' $EDTA/Ler_flye.fasta.mod.EDTA.TElib.fa | grep -v -- "^--$"> $OUTPUT_GYPSY
grep -A1 'Copia' $EDTA/Ler_flye.fasta.mod.EDTA.TElib.fa | grep -v -- "^--$"> $OUTPUT_COPIA

#TE for copia
singularity exec \
--bind $EDTA \
--bind $OUTPUT_COPIA \ 
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_COPIA -db rexdb-plant

#TE for gypsy
singularity exec \
--bind $EDTA \
--bind $OUTPUT_GYPSY \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_GYPSY -db rexdb-plant




#TE with Brassicaceae TE database for copia
singularity exec \
--bind $EDTA \
--bind $OUTPUT_COPIA \ 
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_COPIA -db $DATABASE

#TE with Brassicaceae TE database for gypsy
singularity exec \
--bind $EDTA \
--bind $OUTPUT_GYPSY \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_GYPSY -db $DATABASE