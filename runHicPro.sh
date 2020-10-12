#! /bin/bash

#SBATCH --time=4-00:00:00
#SBATCH --mail-user=moushumi.das@izb.unibe.ch
##SBATCH --mail-type=end,fail
#SBATCH --job-name="pairHIC"
#SBATCH --cpus-per-task=8
#SBATCH --partition=all
#SBATCH --mem-per-cpu=8G
##SBATCH --tmp=64G


## need to edit config-hicpro.txt to contain many settings
source ./envSettings.sh

#source $CONDA_ACTIVATE hicpro
export LANGUAGE="en_US:en"
export LANG="C"
#export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"



echo $WORK_DIR
singularity exec $HICPRO_SIMG HiC-Pro -i ${INPUT_DIR} -o ${WORK_DIR}/results -c config-hicpro.txt


