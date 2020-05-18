#!/bin/bash

# A simple R batch example

#$ -S /bin/bash
#$ -N hcup_readmission
#$ -o /home/tuppal/project/hcup_aim1/
#$ -e /home/tuppal/project/hcup_aim1/

R --vanilla < /home/tuppal/project/hcup_aim1/imputation/imp_cluster_test.R

