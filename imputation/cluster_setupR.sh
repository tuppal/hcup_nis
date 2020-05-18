#!/bin/bash

# A simple R batch example

#$ -S /bin/bash
#$ -N hcup_aim1
#$ -o /home/tuppal/packages/
#$ -e /home/tuppal/packages/

Rscript /home/tuppal/project/hcup_aim1/imputation/cluster_setup.R
