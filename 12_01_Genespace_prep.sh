#!/usr/bin/env bash

#SBATCH --cpus-per-task=1
#SBATCH --mem=500M
#SBATCH --time=20:00:00
#SBATCH --job-name=Genespace_prep
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_genespaceprep_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_genespaceprep_%j.e
#SBATCH --partition=pall

### Run this script 5 times for all ascentions

module add UHTS/Analysis/SeqKit/0.13.2

#Specify directory structure and create them
    BASE=/data/users/sjaegers/assembly_annotation_course
        INPUT=$BASE/10_Maker/An-1-2.maker.output
        GENESPACE=$BASE/12_Genespace
            BED=$GENESPACE/bed
            PEPTIDES=$GENESPACE/peptide

    mkdir $GENESPACE
    mkdir $BED
    mkdir $PEPTIDES

#Specify the assembly to use
    genome1="An-1-2"
    genome2="An1_2"

#Get all contings and sort them by size
    awk '$3=="contig"' $INPUT/$genome1.all.maker.noseq.gff.renamed.gff|sort -t $'\t' -r -k5,5n > $GENESPACE/size_sorted_contigs.txt

#Get the 10 longest
    tail $GENESPACE/size_sorted_contigs.txt|cut -f1 > $GENESPACE/contigs.txt

#Create bed file
    awk '$3=="mRNA"' $INPUT/$genome1.all.maker.noseq.gff.renamed.gff|cut -f 1,4,5,9|sed 's/ID=//'|sed 's/;.\+//'|grep -w -f $GENESPACE/contigs.txt > $BED/$genome2.bed


#Get the gene IDs
    cut -f4 $BED/$genome2.bed > $GENESPACE/gene_IDs.txt

#Create fasta file
    cat $INPUT/$genome1.all.maker.proteins.fasta.renamed.fasta|seqkit grep -r -f $GENESPACE/gene_IDs.txt |seqkit seq -i > $PEPTIDES/$genome2.fa

#Copy the references to the bed and peptides directory
    cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/TAIR10.bed $BED
    cp /data/courses/assembly-annotation-course/CDS_annotation/Genespace/TAIR10.fa $PEPTIDES