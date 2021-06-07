#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N cosmRecSim
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
##$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=bison-2
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
# -------------------------------------------
# --             Queue list                --
##$ -soft
##$ -hard
##$ -l time=24:00:00
#$ -q remote
##$ -q extralong
##$ -q 6h
##$ -q hour
##$ -q day
#
# -- Send mail at submission and completion of script --
##$ -m beas
##$ -M ovtin.ivan@gmail.com

#$ -t 1-24
##$ -t 1-1
##soft
##$ -t 1-9
##$ -t 10-99
##$ -t 100-119

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/1method/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/1method/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method/softcosm/psi3770_to_simCosmic_"$i".root"
#outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A3.0_Z1.0/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A3.0_Z1.0/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A3.0_Z1.0/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.5_Z0.0/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.5_Z0.0/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.5_Z2.5/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.5_Z2.5/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z2.5/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z2.5/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A9.5_Z5.5/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A9.5_Z5.5/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.5_Z4.5/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.5_Z4.5/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A8.5_Z5.5/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A8.5_Z5.5/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A8.0_Z5.5/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A8.0_Z5.5/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.5_Z5.5/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z0.0/softcosm/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z0.0/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A4.5_Z0.0_new/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.5_Z5.5_new/psi3770_to_simCosmic_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.0_Z0.0/softcosm/psi3770_to_simCosmic_"$i".root"
outfile="/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.0_Z0.0/psi3770_to_simCosmic_"$i".root"


mintracks=2
maxtracks=2
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minPt=0
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
inruns="/store/users/ovtin/outDmeson/simulation/Cosmic/simCosm00000"$i".dat"
##inruns="/store/users/offline/SimCosm/softcos00"$i".dat.bz2"
##inruns="/store/users/offline/SimCosm/softcos0"$i".dat.bz2"
##inruns="/store/users/offline/SimCosm/softcos"$i".dat.bz2"
##inruns="/spool/sim/Cosmic/DC/theta-0-80-Field-6kGs.dat.bz2"
NumFirstExpRun=23275
NumLastExpRun=26134
NevRate=1000

#######################################################################################################
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 3.0 -Z 1.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 5.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 5.5 -Z 2.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.5 -Z 2.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 9.5 -Z 5.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.5 -Z 3.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 7.5 -Z 4.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 8.5 -Z 5.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 8.0 -Z 5.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 7.5 -Z 5.5 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.0 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns


status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
