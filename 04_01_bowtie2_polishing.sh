#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=06:00:00
#SBATCH --job-name=bowtie2_polishing
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_bowtie2_polishing_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_bowtie2_polishing_%j.e
#SBATCH --partition=pall


#Add the modules
module add UHTS/Aligner/bowtie2/2.3.4.1
module add UHTS/Analysis/samtools/1.10

#Create variables
BASE=/data/users/sjaegers/assembly_annotation_course
RAW_DATA=$BASE/rawdata

#Choose the names of the assembly for directories and files
#ASSEMBLY_NAME_DIR=Canu
#ASSEMBLY_NAME=canu
ASSEMBLY_NAME_DIR=Flye
ASSEMBLY_NAME=flye

#Create the directory structure
    POLISH=$BASE/04_Polish
        INDEX=$POLISH/Index
            ASSEMBLY_INDEX=$INDEX/$ASSEMBLY_NAME_DIR
        ALIGNMENT=$POLISH/Alignment
            ASSEMBLY_ALIGNED=$ALIGNMENT/$ASSEMBLY_NAME_DIR
        
#Make the directories according to the structure above
mkdir $POLISH
mkdir $INDEX
mkdir $ASSEMBLY_INDEX
mkdir $ALIGNMENT
mkdir $ASSEMBLY_ALIGNED

#Specify the assembly to use
#ASSEMBLY=$BASE/03_Assembly/Canu/pacbio_canu.contigs.fasta
ASSEMBLY=$BASE/03_Assembly/Flye/assembly.fasta


#-------------------------------------------------------------------------------------------------------------------------#

###MAIN PART###
#Go to folder where the index should be build
cd $ASSEMBLY_INDEX

#Run bowtie2 to align the reads to the assembly
#Create index
bowtie2-build $ASSEMBLY index_bowtie2 

#Execute bowtie2
bowtie2 -p 8 --sensitive-local -x $ASSEMBLY_INDEX/index_bowtie2 -1 $RAW_DATA/Illumina/*_1.fastq.gz -2 $RAW_DATA/Illumina/*_2.fastq.gz -S $SCRATCH/$ASSEMBLY_NAME.sam

#Convert SAM to BAM
samtools view -b $SCRATCH/$ASSEMBLY_NAME.sam > $SCRATCH/$ASSEMBLY_NAME_unsorted.bam

#Sort BAM
samtools sort -o $SCRATCH/$ASSEMBLY_NAME.bam $SCRATCH/$ASSEMBLY_NAME_unsorted.bam

#Index BAM
samtools index $SCRATCH/$ASSEMBLY_NAME.bam

#Move the bams created in the temporary folder $SCRATCH to the output folder
mv $SCRATCH/$ASSEMBLY_NAME.bam* $ASSEMBLY_ALIGNED
