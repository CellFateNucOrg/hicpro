# hicpro
Scripts to run hicpro on Illumina-HiC data

see documentation here:
https://github.com/nservant/HiC-Pro

https://genomebiology.biomedcentral.com/articles/10.1186/s13059-015-0831-x

## Installation
### Installing hicpro in izblisbon:
Go to the software directory and pull the singularity image:
```
singularity pull https://zerkalo.curie.fr/partage/HiC-Pro/singularity_images/hicpro_3.0.0_ubuntu.img
```

Check if it works:
```
singularity exec hicpro_3.0.0_ubuntu.img HiC-Pro -h
```

Add shortcut to .bashrc
```
echo "export HICPRO_SIMG=${PWD}/hicpro_3.0.0_ubuntu.img" >> ~/.bashrc
```

Get path to utils directory inside the singularity image, and create a shortcut:
```
singularity exec ${HICPRO_SIMG} which HiC-Pro
echo "export HICPRO_PATH=/usr/local/bin/HiC-Pro_3.0.0/bin/utils" >> ~/.bashrc
```

edit config_hicpro.txt this file is very picky and must have a very specific format and file paths (absolute, not relative).

```
# Please change the variable settings below if necessary

#########################################################################
## Paths and Settings  - Do not edit !
#########################################################################

TMP_DIR = tmp
LOGS_DIR = logs
BOWTIE2_OUTPUT_DIR = bowtie_results
MAPC_OUTPUT = hic_results
RAW_DIR = rawdata

#######################################################################
## SYSTEM AND SCHEDULER - Start Editing Here !!
#######################################################################
N_CPU = 2
SORT_RAM = 768M
LOGFILE = hicpro.log

JOB_NAME = hicpro
JOB_MEM = 8gb
JOB_WALLTIME = 1:00:00
JOB_QUEUE = batch
JOB_MAIL = jennifer.semple@izb.unibe.ch

#########################################################################
## Data
#########################################################################

PAIR1_EXT = _R1
PAIR2_EXT = _R2

#######################################################################
## Alignment options
#######################################################################

MIN_MAPQ = 10

BOWTIE2_IDX_PATH = /home/mdas/20200922_Arima_366b2/hicpro/bowtieIdx
BOWTIE2_GLOBAL_OPTIONS = --very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder
BOWTIE2_LOCAL_OPTIONS =  --very-sensitive -L 20 --score-min L,-0.6,-0.2 --end-to-end --reorder

#######################################################################
## Annotation files
#######################################################################

REFERENCE_GENOME = ce11
GENOME_SIZE = /home/mdas/20200922_Arima_366b2/hicpro/bowtieIdx/ce11.chrom.sizes
#######################################################################
## Allele specific analysis
#######################################################################

ALLELE_SPECIFIC_SNP =

#######################################################################
## Capture Hi-C analysis
#######################################################################

CAPTURE_TARGET =
REPORT_CAPTURE_REPORTER = 1

#######################################################################
## Digestion Hi-C
#######################################################################

GENOME_FRAGMENT = /home/mdas/20200922_Arima_366b2/hicpro/bowtieIdx/ce11.bed
LIGATION_SITE = GATCGATC,GANTGATC,GANTANTC,GATCANTC
MIN_FRAG_SIZE =
MAX_FRAG_SIZE =
MIN_INSERT_SIZE =
MAX_INSERT_SIZE =

#######################################################################
## Hi-C processing
#######################################################################

MIN_CIS_DIST =
GET_ALL_INTERACTION_CLASSES = 1
GET_PROCESS_SAM = 0
RM_SINGLETON = 1
RM_MULTI = 1
RM_DUP = 1

#######################################################################
## Contact Maps
#######################################################################

BIN_SIZE = 2000
MATRIX_FORMAT = upper

#######################################################################
## Normalization
#######################################################################
MAX_ITER = 100
FILTER_LOW_COUNT_PERC = 0.02
FILTER_HIGH_COUNT_PERC = 0
EPS = 0.1
```

You MIGHT need to change the following variables (the rest are just the default values):

N_CPU = 

JOB_NAME = 

JOB_MEM =

JOB_WALLTIME = 

JOB_MAIL = 


BOWTIE2_IDX_PATH =


REFERENCE_GENOME = 

GENOME_SIZE = 


GENOME_FRAGMENT = 

LIGATION_SITE = 


BIN_SIZE =

### Cooler installation
You will also have to install **cooler** in your base environment (or create a new envirnoment for it). Currently working with version  0.8.6 that seems to be fine.


## Running the pipeline
### Edit settings file
You need to edit both envSettings.sh and config-hicpro.txt with the right settings

### Preparing the raw data
Copy the fastq files into a "rawdata" directory in your working directory. in that directory create subdirectories for each samples and put the relevant fastq.gz files into those subdirectories.
The final directory structure should be:
```
$WORK_DIR/rawdata/sample1/forwardReadsFileForSample1_R1.fastq.gz
                          reverseReadsFileForSample1_R2.fastq.gz
                 /sample2/forwardReadsFileForSample2_R1.fastq.gz
                          reverseReadsFileForSample2_R2.fastq.gz
```
                         
### Scripts to run
1. Download and index the genome with **prepareGenome.sh**. The files will be placed in __bowtieIdx/__ folder
2. Run the HiC-Pro pipeline with **runHicPro.sh**. The files will be placed in __results/__ folder
3. Convert hic files to cool and mcool with **runHicToCool.sh**. The files will be placed in __higlass__/ folder
