#!/usr/bin/env bash

#SBATCH --cpus-per-task=12
#SBATCH --mem=48G
#SBATCH --time=06:00:00
#SBATCH --job-name=QUAST_evaluation
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_QUAST_evaluation_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_QUAST_evaluation_%j.e
#SBATCH --partition=pall

### Run this script 4 times.
#1. assembly_name=canu; evaulation_dir=${polish_evaluation_dir}/evaluation;           assembly=${polish_evaluation_dir}/polish/pilon/canu/canu.fasta 
#2. assembly_name=flye; evaulation_dir=${polish_evaluation_dir}/evaluation;           assembly=${polish_evaluation_dir}/polish/pilon/flye/flye.fasta
#3. assembly_name=canu; evaulation_dir=${polish_evaluation_dir}/evaluation_no_polish; assembly=${course_dir}/02_assembly/canu/canu.contigs.fasta
#4. assembly_name=flye; evaulation_dir=${polish_evaluation_dir}/evaluation_no_polish; assembly=${course_dir}/02_assembly/flye/assembly.fasta

#Add the modules
module add UHTS/Quality_control/quast/4.6.0

#Specify name of assembly (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY_NAME=canu
#ASSEMBLY_NAME_DIR=Canu
ASSEMBLY_NAME=flye
ASSEMBLY_NAME_DIR=Flye

#Specify directory structure and create them
BASE=/data/users/sjaegers/assembly_annotation_course
RAW_DATA=$BASE/rawdata
    EVALUATION=$BASE/05_Evaluation
        #POLISH=$EVALUATION/with_polish
        POLISH=$EVALUATION/no_polish #Use this instead of the upper one when analysing the not polished assemblies
            QUAST=$POLISH/QUAST
                QUAST_ASSEMBLY=$QUAST/$ASSEMBLY_NAME_DIR
                    NO_REFERENCE=$QUAST_ASSEMBLY/no_reference
                    WITH_REFERENCE=$QUAST_ASSEMBLY/with_reference
    
mkdir $QUAST
mkdir $QUAST_ASSEMBLY
mkdir $NO_REFERENCE
mkdir $WITH_REFERENCE

#Specify the assembly to use (!!!COMMENT OUT THE ONE YOU ARE NOT USING!!!)
#ASSEMBLY=$BASE/04_Polish/Pilon/Canu/canu.fasta #Polished canu assembly
#ASSEMBLY=$BASE/03_Assembly/Canu/pacbio_canu.contigs.fasta #Unpolished canu assembly
#ASSEMBLY=$BASE/04_Polish/Pilon/Flye/flye.fasta #Polished flye assembly
ASSEMBLY=$BASE/03_Assembly/Flye/assembly.fasta #Unpolished flye assembly

#Copy reference to Raw Data
ln -s /data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa $RAW_DATA

###Run QUAST to assess quality of the assemblies###
#Without reference
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py -o $NO_REFERENCE -m 3000 -t 12 -l $ASSEMBLY_NAME -e --est-ref-size 125000000 -i 500 -x 7000 $ASSEMBLY
            #Options entered here are:
                #"-o": Directory to store all result files
                #"-m": Lower threshold for contig length.
                #"-t": Maximum number of threads
                #"-l": Human-readable assembly names. Those names will be used in reports, plots and logs.
                #"-e": Genome is eukaryotic. Affects gene finding, conserved orthologs finding and contig alignment.
                #"--est-ref-size": Estimated reference size
                #"-i": the minimum alignment length
                #"-x": Lower threshold for extensive misassembly size. All relocations with inconsistency less than extensive-mis-size are counted as local misassemblies
    
#With reference
python /software/UHTS/Quality_control/quast/4.6.0/bin/quast.py -o $WITH_REFERENCE -R $RAW_DATA/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa -m 3000 -t 8 -l $ASSEMBLY_NAME -e --est-ref-size 125000000 -i 500 -x 7000 $ASSEMBLY
            #Options entered here are:
                #"-o": Directory to store all result files
                #"-R": Reference genome file
                #"-m": Lower threshold for contig length.
                #"-t": Maximum number of threads
                #"-l": Human-readable assembly names. Those names will be used in reports, plots and logs.
                #"-e": Genome is eukaryotic. Affects gene finding, conserved orthologs finding and contig alignment.
                #"--est-ref-size": Estimated reference size
                #"-i": the minimum alignment length
                #"-x": Lower threshold for extensive misassembly size. All relocations with inconsistency less than extensive-mis-size are counted as local misassemblies