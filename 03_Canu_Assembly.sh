#!/usr/bin/env bash

#SBATCH --cpus-per-task=10
#SBATCH --mem=4G
#SBATCH --time=10:00:00
#SBATCH --job-name=canu
#SBATCH --mail-user=salina.jaegers@students.unibe.ch
#SBATCH --mail-type=end,fail
#SBATCH --output=/data/users/sjaegers/assembly_annotation_course/output_fastqc_%j.o
#SBATCH --error=/data/users/sjaegers/assembly_annotation_course/error_fastqc_%j.e
#SBATCH --partition=pall


module load UHTS/Assembler/canu/2.1.1

file_path="/data/users/sjaegers/assembly_annotation_course/participant_2/pacbio"
out_dir="/data/users/sjaegers/assembly_annotation_course/03_Assembly"
files="ERR3415817.fastq.gz ERR3415818.fastq.gz"
gridEngineResourceOption="--cpus-per-task=THREADS --mem-per-cpu=MEMORY"


# what is the genome size?
for file in $files; do
  canu -p pacbio_canu -d $out_dir genomeSize=124m -pacbio $file_path/$file maxThreads=16 maxMemory=64
done