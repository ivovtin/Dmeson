#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N Dmeson
# -------------------------------------------
# --     What to redirect to where         --
# -- working directory --
#$ -cwd
#$ -o $JOB_NAME.o$JOB_ID
# -- Merge the standard out and standard error to one file --
#$ -j y
##$ -shell n
##$ -V
##$ -e /dev/null
# -------------------------------------------
# --             Enviroment                --
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=bison-2
# -------------------------------------------
# --             Queue list                --
#$ -soft
##$ -hard
#$ -l time=24:00:00
#$ -q remote
##$ -q extralong
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 1-245
##$ -t 5-5

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#inruns=23942
#outfile="psi3770_to_D0meson_test.root"

inruns="/home/ovtin/development/Dmeson/runsDmeson/runDmeson"$i
outfile="/spool/users/ovtin/psi3770_to_D0meson_"$i".root"
mintracks=4
maxtracks=4
minbeamtracks=2
minIPtracks=2
maxIPtracks=4
minPt=100
maxPt=2000
minClusterEnergy=15
minTotalEnergy=45
minClusters=2
maxClusters=8
minClustersLKr=0
minClustersCsI=0

##$HOME/development/Dmeson/analysis_Dmeson -n 200000 -o $outfile $inruns
$HOME/development/Dmeson/analysis_Dmeson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxCluster -k $minClustersLKr -i $minClustersCsI -o $outfile $inruns

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

