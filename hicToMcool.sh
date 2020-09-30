#! /bin/bash

#SBATCH --time=0-01:00:00
##SBATCH --mail-user=moushumi.das@izb.unibe.ch
##SBATCH --mail-type=end,fail
#SBATCH --job-name="pairHIC"
#SBATCH --cpus-per-task=4
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

let i=${SLURM_ARRAY_TASK_ID}-1
sampleName=${samples[i]}

echo $WORK_DIR
#singularity exec $HICPRO_SIMG HiC-Pro -i ${INPUT_DIR} -o ${WORK_DIR}/results -c config-hicpro.txt

mkdir ${WORK_DIR}/higlass
singularity exec $HICPRO_SIMG ${HICPRO_UTILS}/hicpro2higlass.sh -i ${WORK_DIR}/results/hic_results/matrix/${sampleName}/iced/${res}/${sampleName}_${res}_iced.matrix -r ${res} -c ${WORK_DIR}/bowtieIdx/ce11.chrom.sizes -o ${WORK_DIR}/higlass
# hicpro2higlass -i INPUT -r RESOLUTION -c CHROMSIZE [-n] [-o ODIR] [-t TEMP]  [-h]
