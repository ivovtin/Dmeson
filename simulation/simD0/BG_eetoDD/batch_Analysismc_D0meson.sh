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
#$ -o /spool/users/ovtin/$JOB_NAME.o$JOB_ID
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
##$ -q remote
#$ -q extralong
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 1-10

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#BG ee_to_DD
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson00000"$i".dat"
outfile="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/psi3770_to_simD0mesonBkg_eetoDD_"$i"_10k.root"
##mintracks=3
mintracks=2
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=15
minPt=100
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=100
minNhits=16
kinefit=1
##nevbegin=0
##nevend=5000
nevbegin=5001
nevend=10000

#pSF=1.000

##$HOME/development/Dmeson/analysis_D0meson -n 200000 -o $outfile $inruns
$HOME/development/Dmeson/analysis_D0meson -v 23897 -m 23897 -M 1 -S 1.0 -A 1.0 -Z 1.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend


status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

