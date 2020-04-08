#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash
# -------------------------------------------
# --             batch name                --
#$ -N atcmc
# -------------------------------------------
# --     What to redirect to where         --
#$ -cwd
#$ -o $JOB_NAME.o$JOB_ID
#$ -j y
# -------------------------------------------
# --             Enviroment                --
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=bison-2
# -------------------------------------------
# --             Queue list                --
#$ -soft
#$ -l time=24:00:00
#$ -q remote
##$ -q extralong
#$ -m beas
#$ -M ovtin.ivan@gmail.com

###$ -t 1-18

##i=${SGE_TASK_ID}
##myrand=$[1000+$i]

#start the job
$HOME/3.0.0/bin/ks < $HOME/development/Dmeson/simulation/mc.cards.ee_to_DD > /dev/null
status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

