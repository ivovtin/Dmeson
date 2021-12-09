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
##$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=bison-2
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
# -------------------------------------------
# --             Queue list                --
##$ -soft
##$ -l time=24:00:00
#$ -q remote
##$ -q extralong
##$ -q 6h
##$ -q day
##$ -m beas
##$ -M ovtin.ivan@gmail.com

#$ -t 1-12

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#start the job
$HOME/development/bin/ks < $HOME/development/Dmeson/simulation/simDplus/BG_eetoDD/mccards/mc.cards.ee_to_DD_"$i"
status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

