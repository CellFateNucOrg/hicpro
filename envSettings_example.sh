#! /bin/bash

#HICPRO_SIMG and HICPRO_UTILS should be set in .bashrc

# get working directory
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo $WORK_DIR is work dir
INPUT_DIR=${WORK_DIR}/rawdata

#GENOME=${HOME}/genomeVer/ws265/ce11_genome.fa
GENOME=${HOME}/genomeVer/bowtieIdx/ce11.fa
echo $GENOME is genome
GENOME_DIR=`dirname ${GENOME}`
echo $GENOME_DIR is genome dir
echo $GENOME_DIR

genomeDigestFile=${GENOME_DIR}/ce11.bed

chromSizesFile=${GENOME_DIR}/ce11.chrom.sizes

res=5000

samples=( 366b2 382b1 775b1 784b1 )
