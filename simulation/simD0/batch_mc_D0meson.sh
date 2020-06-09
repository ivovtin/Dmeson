#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash
# -------------------------------------------
# --             batch name                --
#$ -N DmesonMC
# -------------------------------------------
# --     What to redirect to where         --
#$ -cwd
#$ -o /spool/users/ovtin/$JOB_NAME.o$JOB_ID
#$ -j y
# -------------------------------------------
# --             Enviroment                --
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=bison-2
# -------------------------------------------
# --             Queue list                --
#$ -soft
#$ -l time=24:00:00
##$ -q remote
#$ -q extralong
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 1-20

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#start the job
##$HOME/3.0.0/bin/ks < $HOME/development/Dmeson/simulation/simD0/mccards/mc.cards.ee_to_DD_10 > /dev/null
$HOME/3.0.0/bin/ks < $HOME/development/Dmeson/simulation/simD0/mccards/mc.cards.ee_to_DD_"$i" > /dev/null
##$HOME/3.0.0/bin/ks < $HOME/development/Dmeson/simulation/simD0/mccards/mc.cards.ee_to_qq_3 > /dev/null
status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

