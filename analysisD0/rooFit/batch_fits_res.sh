#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N fitDmeson
# -------------------------------------------
# --     What to redirect to where         --
# -- working directory --
#$ -cwd             # run the job in the directory specified.
##$ -o /spool/users/ovtin/$JOB_NAME.o$JOB_ID
#$ -o $JOB_NAME.o$JOB_ID
# -- Merge the standard out and standard error to one file --
##$ -j y
#$ -b y
#$ -shell n
#$ -V                 ##will pass all environment variables to the job
##$ -e /dev/null
# -------------------------------------------
# --             Queue list                --
#$ -soft
##$ -hard
#$ -l time=24:00:00
##$ -q remote
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

## MC signal
##$HOME/development/Dmeson/analysisD0/rooFit/batch_sig_def
## uds BG
$HOME/development/Dmeson/analysisD0/rooFit/batch_bck
## DD BG
##$HOME/development/Dmeson/analysisD0/rooFit/batch_dbck
## exp
##$HOME/development/Dmeson/analysisD0/rooFit/batch_exp

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

