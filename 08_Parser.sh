#!/usr/bin/env bash

#SBATCH --cpus-per-task=8
#SBATCH --mem=40G
#SBATCH --time=05:00:00
#SBATCH --job-name=Parser
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_Parser_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_Parser_%j.e
#SBATCH --partition=pall

#make conda env with this package
#conda install -c bioconda perl-bioperl
#environment location: /home/sjaegers/.conda/envs/annotation_course

#outside of script before running:
    #conda activate annotation_course


OUTPUT=/data/users/sjaegers/assembly_annotation_course/08_Parser
mkdir $OUTPUT
GENOME_ORIGINAL=/data/users/sjaegers/assembly_annotation_course/07_Annotation/EDTA/flye.fasta.mod.EDTA.anno/flye.fasta.mod.out
#move the previous genome file to the new 08 directory bc the output dir cannot be adjusted so we have everything in one folder
cp $GENOME_ORIGINAL $OUTPUT
GENOME=$OUTPUT/flye.fasta.mod.out
perl parseRM.pl -i $GENOME -l 50,1 -v

sed '1d;3d' $OUTPUT/flye.fasta.mod.out.landscape.Div.Rname.tab > $OUTPUT/flye_final.fasta.mod.out.landscape.Div.Rname.tab
