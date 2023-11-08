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

module load UHTS/Analysis/SeqKit/0.13.2


BASE=/data/users/sjaegers/assembly_annotation_course
RAWDATA=$BASE/rawdata

cp /data/courses/assembly-annotation-course/CDS_annotation/Brassicaceae_repbase_all_march2019.fasta $RAWDATA

ANNOTATION=$BASE/07_Annotation
    EDTA=$ANNOTATION/EDTA
    TE=$ANNOTATION/TE
        GYPSY=$TE/Gypsy
            OUTPUT_GYPSY=$GYPSY/Gypsy.fa
        COPIA=$TE/Copia
            OUTPUT_COPIA=$COPIA/Copia.fa
        Brassicaceae=$TE/Brassicaceae
            BCOPIA=$Brassicaceae/Copia
                OUTPUT_BCOPIA=$BCOPIA/Copia.fa
            BGYPSY=$Brassicaceae/Gypsy
                OUTPUT_BGYPSY=$BGYPSY/Gypsy.fa
DATABASE=$RAWDATA/Brassicaceae_repbase_all_march2019.fasta
COURSEDIR=/data/courses/assembly-annotation-course


mkdir $TE
mkdir $GYPSY
mkdir $COPIA
mkdir $Brassicaceae
mkdir $BCOPIA
mkdir $BGYPSY

cd $TE

#filter out the copia and gyspsy superfamilies
seqkit grep -r -p 'Gypsy' $EDTA/flye.fasta.mod.EDTA.TElib.fa > $OUTPUT_GYPSY
seqkit grep -r -p 'Copia' $EDTA/flye.fasta.mod.EDTA.TElib.fa > $OUTPUT_COPIA
seqkit grep -r -p 'Copia' $DATABASE > $OUTPUT_BCOPIA
seqkit grep -r -p 'Gypsy' $DATABASE > $OUTPUT_BGYPSY


cd $COPIA
#TE for copia
singularity exec \
--bind $EDTA \
--bind $OUTPUT_COPIA \ 
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_COPIA -db rexdb-plant -pre 'Copia'

cd $GYPSY
#TE for gypsy
singularity exec \
--bind $EDTA \
--bind $OUTPUT_GYPSY \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_GYPSY -db rexdb-plant -pre 'Gypsy'



cd $BCOPIA
#TE with Brassicaceae TE database for copia
singularity exec \
--bind $COURSEDIR \
--bind $OUTPUT_BCOPIA \ 
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_BCOPIA -db rexdb-plant -pre 'Copia'

cd $BGYPSY
#TE with Brassicaceae TE database for gypsy
singularity exec \
--bind $EDTA \
--bind $OUTPUT_BGYPSY \
$COURSEDIR/containers2/EDTA_v1.9.6.sif \
TEsorter $OUTPUT_BGYPSY -db rexdb-plant -pre 'Gypsy'