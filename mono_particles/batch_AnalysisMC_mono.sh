#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimMono
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
#$ -v PATH=$PATH:$HOME/development/lib:/home/ovtin/development/KrKRec,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/ovtin/development/lib,KDBHOST=bison-2
##$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
# -------------------------------------------
# --             Queue list                --
#$ -soft
##$ -hard
##$ -l time=24:00:00
##$ -l time=6:00:00
##$ -q remote
##$ -q extralong
#$ -q 6h
##$ -q hour
##$ -q day
#
# -- Send mail at submission and completion of script --
##$ -m beas
##$ -M ovtin.ivan@gmail.com

##$ -t 1-5
##$ -t 1-6
##$ -t 1-4
#$ -t 1-6

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
##outfile="/store/users/ovtin/outDmeson/simulation/mono/kaon/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/mono_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/mono/pion/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/mono_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/mono/electron/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/mono_"$i".root"
outfile="/store/users/ovtin/outDmeson/simulation/mono/muon/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/mono_"$i".root"
mintracks=0
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minP=0
maxP=10000
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
##inruns="/store/users/ovtin/outDmeson/simulation/mono/kaon/simDmeson00100"$i".dat"
##inruns="/store/users/ovtin/outDmeson/simulation/mono/pion/simDmeson00100"$i".dat"
##inruns="/store/users/ovtin/outDmeson/simulation/mono/electron/simDmeson00100"$i".dat"
inruns="/store/users/ovtin/outDmeson/simulation/mono/muon/simDmeson00100"$i".dat"
#
NumFirstExpRun=23272
NumLastExpRun=26151
NevRate=1000

#######################################################################################################

$HOME/development/Dmeson/analysis_mono -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minP -j $maxP -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

