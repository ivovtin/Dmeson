#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N bhabhaSim
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
##$ -q hour
#$ -q day
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 1-1

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
##outfile="/store/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i"_2method_corr_S1.0_A5.5_Z0.0.root"
##outfile="/store/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i"_2method_corr_S1.0_A6.0_Z0.0.root"
##outfile="/store/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i"_2method_corr_S1.0_A7.2_Z0.2.root"
##outfile="/store/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i"_2method_corr_S1.0_A4.8_Z0.0.root"
##outfile="/store/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i"_2method_corr_S1.0_A6.9_Z0.0.root"
outfile="/store/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i"_2method_corr_S1.0_A5.1_Z0.0.root"
mintracks=2
maxtracks=2
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minPt=100
maxPt=10000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=0
#verbose=1

########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/BhaBha/simee000001.dat"
#
NumFirstExpRun=23275
NumLastExpRun=26134
NevRate=1000
##nevbegin=0
##nevend=6000

#######################################################################################################
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 5.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.0 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 7.2 -Z 0.2 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.8 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.9 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 5.1 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns


status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
