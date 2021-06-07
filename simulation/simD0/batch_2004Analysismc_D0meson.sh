#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimD0Sig
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
##$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
# -------------------------------------------
# --             Queue list                --
##$ -soft
##$ -hard
##$ -l time=24:00:00
##$ -q remote
##$ -q extralong
##$ -q 6h
#$ -q day
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

##for Signal
#$ -t 1-1

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A5.5_Z2.5_2004/psi3770_to_simD0mesonSignal_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A5.5_Z2.5_v2/psi3770_to_simD0mesonSignal_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.5_Z0.0_gen60_4_0/psi3770_to_simD0mesonSignal_"$i".root"
outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.5_Z5.5_gen60_4_0/psi3770_to_simD0mesonSignal_"$i".root"
##mintracks=3
mintracks=2
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=15
minPt=0
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=18
kinefit=1
##nevbegin=0
##nevend=5000
verbose=0

########################################################################################################
##inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson000001.dat"
##inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/TESTallmodes/simDmeson000001.dat"
inruns="/store/users/ovtin/simout/sim00000gen60_4_0.dat"
#
##NumFirstExpRun=4712
##NumLastExpRun=4941
NumFirstExpRun=23272
NumLastExpRun=23675
NevRate=1000

#######################################################################################################

##$HOME/development/Dmeson/analysis_D0meson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit $inruns
$HOME/development/Dmeson/analysis_D0meson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.5 -Z 5.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit $inruns

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
