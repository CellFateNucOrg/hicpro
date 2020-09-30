#! /bin/bash

#SBATCH --time=0-01:00:00

#SBATCH --job-name="getCE11"
#SBATCH --cpus-per-task=1
#SBATCH --partition=all
#SBATCH --mem-per-cpu=8G

# prepare Genome

#source $CONDA_ACTIVATE hicpro
source ./envSettings.sh

GENOME_DIR=`dirname $GENOME`
mkdir -p $GENOME_DIR
baseGenomeName=`basename $GENOME`
baseGenomeName=${baseGenomeName%.fa}

# get genome sequence
if [[ ! -f "$GENOME" ]]; then
  wget http://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/chromFa.tar.gz
  tar -xvzf chromFa.tar.gz
  cat chrI.fa chrII.fa chrIII.fa chrIV.fa chrV.fa chrX.fa > ce11.fa
  rm chrI.fa chrII.fa chrIII.fa chrIV.fa chrV.fa chrX.fa chrM.fa chromFa.tar.gz
  mv ce11.fa $GENOME_DIR/
fi

# index genome for bowtie

if [[ ! -f "${GENOME_DIR}/${baseGenomeName}.1.bt2" ]]; then
  singularity exec $HICPRO_SIMG  bowtie2-build --version
  singularity exec $HICPRO_SIMG  bowtie2-build  $GENOME ${GENOME_DIR}/${baseGenomeName}
fi

# get chrom.sizes file
if [[ ! -f "${GENOME_DIR}/ce11.chrom.sizes" ]];  then
  wget http://hgdownload.soe.ucsc.edu/goldenPath/ce11/bigZips/ce11.chrom.sizes
  mv ce11.chrom.sizes $GENOME_DIR/
fi
#### NOTE: You should edit the ce11.chrom.sizes to have the chromosomes in the right order, and remove
#### chrM


# get blacklist
if [[ ! -f "$GENOME_DIR/ce11-blacklist.v2.bed" ]]; then
  wget https://github.com/Boyle-Lab/Blacklist/raw/master/lists/ce11-blacklist.v2.bed.gz
  gunzip ce11-blacklist.v2.bed.gz
  mv ce11-blacklist.v2.bed $GENOME_DIR
fi

# get genome digest file
if [[ ! -f "$GENOME_DIR/${baseGenomeName}.bed" ]]; then
  singularity exec ${HICPRO_SIMG} ${HICPRO_UTILS}/digest_genome.py -r ^GATC G^ANTC -o $GENOME_DIR/${baseGenomeName}.bed $GENOME
fi

