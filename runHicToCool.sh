#! /bin/bash

#SBATCH --time=0-05:00:00
##SBATCH --mail-user=moushumi.das@izb.unibe.ch
##SBATCH --mail-type=end,fail
#SBATCH --job-name="hic2mcool"
#SBATCH --cpus-per-task=2
#SBATCH --partition=all
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1
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

if [[ ! -d "${WORK_DIR}/cool" ]] 
then
  mkdir -p ${WORK_DIR}/cool
  mkdir -p ${WORK_DIR}/mcool
fi

# copy the utility script from the container to the working directory
if [[ ! -f "${WORK_DIR}/hicpro2higlass.sh" ]]
then
  singularity exec $HICPRO_SIMG cp $HICPRO_UTILS/hicpro2higlass.sh ${WORK_DIR}/
fi

#singularity exec $HICPRO_SIMG ${HICPRO_UTILS}/hicpro2higlass.sh -i ${WORK_DIR}/results/hic_results/matrix/${sampleName}/iced/${res}/${sampleName}_${res}_iced.matrix -r ${res} -c ${WORK_DIR}/bowtieIdx/ce11.chrom.sizes -p $SLURM_CPUS_PER_TASK -o ${WORK_DIR}/higlass

${WORK_DIR}/hicpro2higlass.sh -i ${WORK_DIR}/results/hic_results/matrix/${sampleName}/raw/${res}/${sampleName}_${res}.matrix -r ${res} -c ${GENOME_DIR}/ce11.chrom.sizes -p $SLURM_CPUS_PER_TASK -n -o ${WORK_DIR}/cool


## replace mcool files produced by hicpro2higlass with ones made with our settings.
rm ${WORK_DIR}/cool/${sampleName}_${res}.mcool

echo "making mcools file from cool file..."
cooler zoomify --balance --balance-args '--convergence-policy store_nan' -n $SLURM_CPUS_PER_TASK -o ${WORK_DIR}/mcool/${sampleName}_${res}_ice.mcool -c 10000000 -r '2000,4000,10000,20000,50000,100000,200000,500000'  ${WORK_DIR}/cool/${sampleName}_${res}.cool

echo "making raw mcool file from cool file..."
cooler zoomify -n $SLURM_CPUS_PER_TASK -o ${WORK_DIR}/mcool/${sampleName}_${res}_raw.mcool -c 10000000 -r '2000,4000,10000,20000,50000,100000,200000,500000'  ${WORK_DIR}/cool/${sampleName}_${res}.cool
