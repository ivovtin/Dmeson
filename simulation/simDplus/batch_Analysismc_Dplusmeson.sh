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
#$ -q remote
##$ -q extralong
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 4-4

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#inruns=23219
#Nevents=10000
#outfile="psi3770_to_D0meson_test.root"
#Bkg
inruns="/spool/users/ovtin/outDmeson/simulation/uds/simDmeson_eetoqq3_0"$i".dat"
outfile="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq3_"$i"_50k.root"
#Signal
##inruns="/spool/users/ovtin/outDmeson/simulation/simDmesonSignal0"$i".dat"
##inruns="/spool/users/ovtin/outDmeson/simulation/simDmesonSignal"$i".dat"
##outfile="/spool/users/ovtin/outDmeson/simulation/psi3770_to_simD0mesonSignal_kin_"$i".root"
##inruns="/spool/users/ovtin/outDmeson/simulation/simDmesonBkg_eetoDD"$i".dat"
##outfile="/spool/users/ovtin/outDmeson/simulation/psi3770_to_simD0mesonBkg_eetoDD_"$i".root"
mintracks=3
maxtracks=12
minbeamtracks=0
minIPtracks=0
maxIPtracks=12
minPt=100
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=100
minNhits=20
kinefit=1
#nevbegin=40000
#nevend=50000
nevbegin=0
nevend=0

$HOME/development/Dmeson/analysis_Dplusmeson -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

