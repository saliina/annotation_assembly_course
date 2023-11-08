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
        RAWDATA=$BASE/rawdata
    
    mkdir $MAKER

#Go to folder where results should be stored.
    cd $MAKER

#Copy data files from Monsur to RawData and make soft link course folder
    #cp /data/users/mfaye/assembly_course/data/assemblies/trinity_out/assembly.fasta $RAWDATA

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

#Run MAKER with MPI
mpiexec -n 16 singularity exec \
--bind $SCRATCH \
--bind $COURSEDIR \
--bind $BASE \
--bind $SOFTWARE \
$COURSEDIR/containers2/MAKER_3.01.03.sif \
maker -mpi maker_opts.ctl maker_bopts.ctl maker_exe.ctl
    #Options entered here are:
        #"mpiexec -n 16 singularity exec": execute container with given options
        #"--bind": a user-bind path specification.
        #"${COURSE_DIR}/containers2/MAKER_3.01.03.sif": Singularity Image Format container to be executed
        #"maker -mpi maker_opts.ctl maker_bopts.ctl maker_exe.ctl": command to be executed