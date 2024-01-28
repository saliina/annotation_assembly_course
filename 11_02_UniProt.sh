#!/usr/bin/env bash

#SBATCH --cpus-per-task=30
#SBATCH --mem=10G
#SBATCH --time=20:00:00
#SBATCH --job-name=UniProt_evaluation
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_UniProt_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_UniProt_%j.e
#SBATCH --partition=pall

### Run this script X times.

#Add the modules
    module add Blast/ncbi-blast/2.10.1+
    module add SequenceAnalysis/GenePrediction/maker/2.31.9


#Specify directory structure and create them
    BASE=/data/users/sjaegers/assembly_annotation_course
        INPUT=$BASE/10_Maker/An-1-2.maker.output
        QUALITY=$BASE/11_Quality
            UNIPROT=$QUALITY/UniProt
                BLAST=$UNIPROT/blastdb
        
    COURSEDIR=/data/courses/assembly-annotation-course
        REFERENCE=$COURSEDIR/CDS_annotation/MAKER/uniprot_viridiplantae_reviewed.fa
   
    mkdir $UNIPROT


#Specify the assembly to use
    ASSEMBLY=$INPUT/An-1-2.all.maker.proteins.fasta.renamed.fasta
    GFF=$INPUT/An-1-2.all.maker.noseq.gff.renamed.gff

#Go to folder where the evaluation results will be stored
    cd $UNIPROT

#Align protein against UniProt database
    makeblastdb -in $REFERENCE -dbtype prot -out $BLAST/uniprot-plant_reviewed
    blastp -query $ASSEMBLY -db $BLAST/uniprot-plant_reviewed -num_threads 30 -outfmt 6 -evalue 1e-10 -out $UNIPROT/blastp.out
    blastp -query $ASSEMBLY -db $BLAST/uniprot-plant_reviewed -num_threads 30 -outfmt 6 -evalue 1e-10 -out $UNIPROT/blastp.xml

#Map protein putative functions
    cp $ASSEMBLY $ASSEMBLY.Uniprot
    cp $GFF $GFF.Uniprot

    maker_functional_fasta $REFERENCE $UNIPROT/blastp.out $ASSEMBLY.Uniprot
    maker_functional_gff $REFERENCE $UNIPROT/blastp.out $GFF.Uniprot