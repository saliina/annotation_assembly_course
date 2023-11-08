#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=Phylogeny
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_Phylogeny_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_Phylogeny_%j.e
#SBATCH --partition=pall

module load UHTS/Analysis/SeqKit/0.13.2


####GYPSY#####
INPUT_G=/data/users/sjaegers/assembly_annotation_course/07_Annotation/TE/Gypsy/Gypsy.dom.faa
OUTPUT_G=/data/users/sjaegers/assembly_annotation_course/09_Phylogeny/Gypsy
LIST_OUTPUT_G=$OUTPUT_G/Gypsy_RT_list_full.fasta
FINAL_OUTPUT_G=$OUTPUT_G/Gypsy_RT.fasta
PROTEIN_ALIGNMENT_G=$OUTPUT_G/Gypsy_protein_alignment.fasta
PROTEIN_TREE_G=$OUTPUT_G/Gypsy_protein_alignment.tree

mkdir $OUTPUT_G
# Gypsy RT proteins are named as Ty3-RT, Copia RT proteins as Ty1-RT
grep Ty3-RT $INPUT_G > $LIST_OUTPUT_G   #make a list of RT proteins
to extract
sed -i 's/>//' $LIST_OUTPUT_G       #remove ">" from the header
sed -i 's/ .\+//' $LIST_OUTPUT_G     #remove all characters following "empty space"
from the header
seqkit grep -f $LIST_OUTPUT_G  $INPUT_G -o $FINAL_OUTPUT_G

#Shorten the identifiers of RT sequences
sed -i 's/|.\+//' $FINAL_OUTPUT_G  #remove all characters following "|"

#Align the sequences with clustal omega.
module load SequenceAnalysis/MultipleSequenceAlignment/clustal-omega/1.2.4
clustalo -i $FINAL_OUTPUT_G -o $PROTEIN_ALIGNMENT_G


#4. Create a phylogenetic tree with FastTree (approximately-maximum-likelihood).

module load Phylogeny/FastTree/2.1.10
FastTree -out $PROTEIN_TREE_G $PROTEIN_ALIGNMENT_G









#-----------------------------------------------------------------------------------------------------------#
####COPIA#####
INPUT_C=/data/users/sjaegers/assembly_annotation_course/07_Annotation/TE/Copia/Copia.dom.faa
OUTPUT_C=/data/users/sjaegers/assembly_annotation_course/09_Phylogeny/Copia
LIST_OUTPUT_C=$OUTPUT_C/Copia_RT_list_full.fasta
FINAL_OUTPUT_C=$OUTPUT_C/Copia_RT.fasta
PROTEIN_ALIGNMENT_C=$OUTPUT_C/Copia_protein_alignment.fasta
PROTEIN_TREE_C=$OUTPUT_C/Copia_protein_alignment.tree

mkdir $OUTPUT_C
# Gypsy RT proteins are named as Ty3-RT, Copia RT proteins as Ty1-RT
grep Ty1-RT $INPUT_C > $LIST_OUTPUT_C   #make a list of RT proteins
to extract
sed -i 's/>//' $LIST_OUTPUT_C      #remove ">" from the header
sed -i 's/ .\+//' $LIST_OUTPUT_C     #remove all characters following "empty space"
from the header
seqkit grep -f $LIST_OUTPUT_C  $INPUT_C -o $FINAL_OUTPUT_C

#Shorten the identifiers of RT sequences
sed -i 's/|.\+//' $FINAL_OUTPUT_C  #remove all characters following "|"

#Align the sequences with clustal omega.
module load SequenceAnalysis/MultipleSequenceAlignment/clustal-omega/1.2.4
clustalo -i $FINAL_OUTPUT_C -o $PROTEIN_ALIGNMENT_C


#4. Create a phylogenetic tree with FastTree (approximately-maximum-likelihood).

module load Phylogeny/FastTree/2.1.10
FastTree -out $PROTEIN_TREE_C $PROTEIN_ALIGNMENT_C

