#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10GB
#SBATCH --time=02:00:00
#SBATCH --job-name=k-mer
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall


module load UHTS/Analysis/jellyfish/2.2.6
mkdir /data/users/sjaegers/assembly_annotation_course/02_k-mer_count
cd /data/users/sjaegers/assembly_annotation_course/02_k-mer_count

INPUT=/data/users/sjaegers/assembly_annotation_course/participant_2
OUTPUT=/data/users/sjaegers/assembly_annotation_course/02_k-mer_count


for folder in $INPUT/*;
do
    mkdir /data/users/sjaegers/assembly_annotation_course/02_k-mer_count/$(basename $folder)
    
    FILES=($folder/*.fastq.gz)

    filename=$(basename "${FILES[1]}")
    jellyfish count -C -s 10G -t 4 -m 19 -o $OUTPUT/$(basename $folder)/${filename%.*.*}.jf <(zcat ${FILES[1]}) <(zcat ${FILES[2]})

    jellyfish histo -t 4 $OUTPUT/$(basename $folder)/${filename%.*.*}.jf > $OUTPUT/$(basename $folder)/${filename%.*.*}.histo
        
done