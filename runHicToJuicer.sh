#! /bin/bash

#SBATCH --time=0-05:00:00
##SBATCH --mail-user=moushumi.das@izb.unibe.ch
##SBATCH --mail-type=end,fail
#SBATCH --job-name="hic2juicer"
#SBATCH --cpus-per-task=2
#SBATCH --partition=all
#SBATCH --mem-per-cpu=32G
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


JUICER_JAR=${HOME}/software/juicer/CPU/common/juicer_tools.jar
# copy the utility script from the container to the working directory
if [[ ! -f "${WORK_DIR}/hicpro2juicebox.sh" ]]
then
  singularity exec $HICPRO_SIMG cp $HICPRO_UTILS/hicpro2juicebox.sh ${WORK_DIR}/
fi

if [[ ! -d "${WORK_DIR}/juicer" ]]
then
          mkdir ${WORK_DIR}/juicer
fi

${WORK_DIR}/hicpro2juicebox.sh -i ${WORK_DIR}/results/hic_results/data/${sampleName}/${sampleName}.allValidPairs -j ${JUICER_JAR} -r ${res} -g ${GENOME_DIR}/ce11.chrom.sizes -r ${GENOME_DIR}/ce11.bed  -o ${WORK_DIR}/juicer
