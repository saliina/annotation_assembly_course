#!/usr/bin/env bash

#SBATCH --cpus-per-task=10
#SBATCH --mem=10G
#SBATCH --time=20:00:00
#SBATCH --job-name=BUSCO_evaluation
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_BUSCO_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_BUSCO_%j.e
#SBATCH --partition=pall

### Run this script X times.

#Add the modules
    module add UHTS/Analysis/busco/4.1.4

#Define other dictionaries and variables that are used
    

#Specify directory structure and create them
    BASE=/data/users/sjaegers/assembly_annotation_course
        INPUT=$BASE/10_Maker/An-1-2.maker.output
        QUALITY=$BASE/11_Quality
            BUSCO=$QUALITY/BUSCO
   
    mkdir $QUALITY
    mkdir $BUSCO

#Specify the assembly to use
    ASSEMBLY=$INPUT/An-1-2.all.maker.proteins.fasta.renamed.fasta

#Go to folder where the evaluation results will be stored
    cd $BUSCO

#Make a copy of the augustus config directory to a location where I have write permission
    cp -r /software/SequenceAnalysis/GenePrediction/augustus/3.3.3.1/config augustus_config
    export AUGUSTUS_CONFIG_PATH=./augustus_config

#Run busco to assess the quality of the assemblies
    busco -i $ASSEMBLY -l brassicales_odb10 -o BUSCO -m proteins -c 8
        
#Remove the augustus config directory again
    rm -r ./augustus_config

#Make Busco Plot
python3 generate_plot.py -wd /data/users/sjaegers/assembly_annotation_course/05_Evaluation/BUSOC_all
