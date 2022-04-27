#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N eeSim
# -------------------------------------------
# --     What to redirect to where         --
# -- working directory --
#$ -cwd             # run the job in the directory specified.
#$ -o /spool/users/ovtin/$JOB_NAME.o$JOB_ID
# -- Merge the standard out and standard error to one file --
#$ -j y
##$ -shell n
#$ -V                 ##will pass all environment variables to the job
##$ -e /dev/null
# -------------------------------------------
# --             Enviroment                --
##$ -v PATH=$PATH:$HOME/development/lib:/home/ovtin/development/KrKRec,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/ovtin/development/lib,KDBHOST=bison-2
# -------------------------------------------
# --             Queue list                --
#$ -soft
##$ -hard
##$ -l time=24:00:00
#$ -l time=6:00:00
##$ -q remote
##$ -q extralong
#$ -q 6h
##$ -q day
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 1-1
##$ -t 1-19

i=${SGE_TASK_ID}
myrand=$[1000+$i]

##simulation
##$HOME/development/Dmeson/BhaBhaSimpleSampleCC -RF23551 -RL23569 -Nsw50 -N25000 -sim1
$HOME/development/Dmeson/BhaBhaSimpleSampleCC -RF23556 -RL23556 -Nsw550 -N2000 -sim1
##data
##$HOME/development/Dmeson/BhaBhaSimpleSampleCC -RF23551 -RL23569 -N1000000 -sim0
##$HOME/development/Dmeson/BhaBhaSimpleSampleCC -RF23556 -RL23556 -N5000 -sim0

#COUNTER=0

##for RUN in `seq 23556 23556`
#for RUN in `seq 23551 23569`
#do
#  echo "RUN="$RUN
#  let COUNTER++
#  if [ $COUNTER == $i ]; then
#     $HOME/development/Dmeson/BhaBhaSimpleSampleCC -RF$RUN -RL$RUN -N1000000 -sim0
#     continue
#  fi
#done

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

