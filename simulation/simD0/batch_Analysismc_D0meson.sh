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

#$ -t 1-2

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
##inruns="/spool/users/ovtin/simDmeson00000"$i".dat"
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson00000"$i".dat"
outfile="/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/psi3770_to_simD0mesonSignal_"$i".root"
#BG continium
##inruns="/spool/users/ovtin/outDmeson/simulation/uds/simDmeson_eetoqq3_0"$i".dat"
##outfile="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq3_"$i"_50k.root"
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
nevbegin=0
nevend=700
##nevbegin=5001
##nevend=10000

######
#1
##nevbegin=0
##nevend=1000
#2
##nevbegin=1001
##nevend=2000
#3
##nevbegin=2001
##nevend=4000
#4
##nevbegin=4001
##nevend=6000
#5
##nevbegin=6001
##nevend=8000
#6
##nevbegin=8001
##nevend=9000
#7
##nevbegin=9001
##nevend=10000
#####

#pSF=1.000

##$HOME/development/Dmeson/analysis_D0meson -n 200000 -o $outfile $inruns
$HOME/development/Dmeson/analysis_D0meson -v 23897 -m 23897 -M 1 -S 1.0 -A 1.0 -Z 1.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

#### 1
##$HOME/development/Dmeson/analysis_D0meson -v 23215 -m 23313 -M 50 -S 1.0 -A 1.0 -Z 1.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
#### 2
##$HOME/development/Dmeson/analysis_D0meson -v 23322 -m 23359 -M 50 -S 4.0 -A 2.0 -Z 2.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
#### 3
##$HOME/development/Dmeson/analysis_D0meson -v 23418 -m 23895 -M 50 -S 1.0 -A 1.0 -Z 1.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
#### 4
##$HOME/development/Dmeson/analysis_D0meson -v 23897 -m 24836 -M 50 -S 1.0 -A 1.0 -Z 1.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
#### 5
##$HOME/development/Dmeson/analysis_D0meson -v 23837 -m 25231 -M 50 -S 4.0 -A 2.0 -Z 2.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
#### 6
##$HOME/development/Dmeson/analysis_D0meson -v 25341 -m 25574 -M 50 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
###  7
##$HOME/development/Dmeson/analysis_D0meson -v 25607 -m 25687 -M 50 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend


status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

