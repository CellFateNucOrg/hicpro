#! /bin/bash

#SBATCH --time=0-01:00:00
##SBATCH --mail-user=moushumi.das@izb.unibe.ch
##SBATCH --mail-type=end,fail
#SBATCH --job-name="hic2mcool"
#SBATCH --cpus-per-task=2
#SBATCH --partition=all
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-4
##SBATCH --tmp=64G


## number of array jobs should match the number of samples in envSettings.sh
source ./envSettings.sh

#source $CONDA_ACTIVATE hicpro
export LANGUAGE="en_US:en"
export LANG="C"
#export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

let i=${SLURM_ARRAY_TASK_ID}-1
sampleName=${samples[i]}

echo $WORK_DIR

if [[ ! -d "${WORK_DIR}/higlass" ]] 
then
  mkdir ${WORK_DIR}/higlass
fi

if [[ ! -d "${WORK_DIR}/hicpro2higlass.sh" ]]
then
  singularity exec $HICPRO_SIMG cp $HICPRO_UTILS/hicpro2higlass.sh ${WORK_DIR}/
fi

#singularity exec $HICPRO_SIMG ${HICPRO_UTILS}/hicpro2higlass.sh -i ${WORK_DIR}/results/hic_results/matrix/${sampleName}/iced/${res}/${sampleName}_${res}_iced.matrix -r ${res} -c ${WORK_DIR}/bowtieIdx/ce11.chrom.sizes -p $SLURM_CPUS_PER_TASK -o ${WORK_DIR}/higlass

${WORK_DIR}/hicpro2higlass.sh -i ${WORK_DIR}/results/hic_results/matrix/${sampleName}/raw/${res}/${sampleName}_${res}.matrix -r ${res} -c ${GENOME_DIR}/ce11.chrom.sizes -p $SLURM_CPUS_PER_TASK -n -o ${WORK_DIR}/higlass
