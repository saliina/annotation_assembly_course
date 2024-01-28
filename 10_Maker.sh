#!/usr/bin/env bash

#SBATCH --mem-per-cpu=12G
#SBATCH --time=20:00:00
#SBATCH --job-name=Maker
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output/output_Maker_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error/error_Maker_%j.e
#SBATCH --partition=pall
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16

### Run this script 2 times.
#1. To make the control files
#2. To run maker

#Add the modules
    module add SequenceAnalysis/GenePrediction/maker/2.31.9

#Define other dictionaries and variables that are used
    COURSEDIR=/data/courses/assembly-annotation-course
    SOFTWARE=/software


#Specify directory structure and create them
    BASE=/data/users/sjaegers/assembly_annotation_course
        MAKER=$BASE/10_Maker
        RAWDATA=$BASE/04_Polish/Pilon/Flye
    
    mkdir $MAKER

#Go to folder where results should be stored.
    cd $MAKER


#Create control files
#singularity exec \
#--bind $SCRATCH \
#--bind $COURSEDIR \
#--bind $BASE \
#--bind $SOFTWARE \
#$COURSEDIR/containers2/MAKER_3.01.03.sif \
#maker -CTL
    #Options entered here are:
        #"singularity exec": execute container with given options
        #"--bind": a user-bind path specification.
        #"${COURSE_DIR}/containers2/MAKER_3.01.03.sif": Singularity Image Format container to be executed
        #"maker": command to be executed
        #"-CTL": Generate empty control files in the current directory.

#base="An-1-2"
#Run MAKER with MPI
#mpiexec -n 16 singularity exec \
#--bind $SCRATCH \
#--bind $COURSEDIR \
#--bind $BASE \
#--bind $SOFTWARE \
#--bind $RAWDATA \
#$COURSEDIR/containers2/MAKER_3.01.03.sif \
#maker -mpi -base $base maker_opts.ctl maker_bopts.ctl maker_exe.ctl
    #Options entered here are:
        #"mpiexec -n 16 singularity exec": execute container with given options
        #"--bind": a user-bind path specification.
        #"${COURSE_DIR}/containers2/MAKER_3.01.03.sif": Singularity Image Format container to be executed
        #"maker -mpi maker_opts.ctl maker_bopts.ctl maker_exe.ctl": command to be executed



export TMPDIR=$SCRATCH
base="An-1-2"
data=${base}_master_datastore_index.log
cd $MAKER/${base}.maker.output
gff3_merge -d $data -o ${base}.all.maker.gff
gff3_merge -d $data -n -o ${base}.all.maker.noseq.gff
fasta_merge -d $data -o ${base}



cd $MAKER/${base}.maker.output
protein=${base}.all.maker.proteins.fasta
transcript=${base}.all.maker.transcripts.fasta
gff=${base}.all.maker.noseq.gff
prefix=${base}_

cp $gff ${gff}.renamed.gff
cp $protein ${protein}.renamed.fasta
cp $transcript ${transcript}.renamed.fasta

maker_map_ids --prefix $prefix --justify 7 ${gff}.renamed.gff > ${base}.id.map
map_gff_ids ${base}.id.map ${gff}.renamed.gff
map_fasta_ids ${base}.id.map ${protein}.renamed.fasta
map_fasta_ids ${base}.id.map ${transcript}.renamed.fasta