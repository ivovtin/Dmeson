#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N D0meson
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
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
# -------------------------------------------
# --             Queue list                --
#$ -soft
##$ -hard
##$ -l time=24:00:00
#$ -l time=6:00:00
#$ -q remote
##$ -q extralong
##$ -q 6h
##$ -q day
#
# -- Send mail at submission and completion of script --
##$ -m beas
##$ -M ovtin.ivan@gmail.com

##$ -t 1-482
#$ -t 1-693

i=${SGE_TASK_ID}
myrand=$[1000+$i]

##inruns=23219
#Signal
inruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/runDmeson"$i
##outfile="/spool/users/ovtin/outDmeson/D0/dataPcorr_1.0173/psi3770_to_D0meson_"$i".root"
outfile="/spool/users/ovtin/outDmeson/D0/dataPcorr_1.0173_kNoiseReject3_KemcAllowed-1/psi3770_to_D0meson_"$i".root"
##inruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/runDmeson"$i
##outfile="/spool/users/ovtin/outDmeson/D0/dataPcorr2004_1.030/psi3770_to_D0meson_"$i".root"
#Bkg
#inruns="/home/ovtin/development/Dmeson/runsDmeson/runBkgDmeson"$i
#outfile="/spool/users/ovtin/psi3770_to_BkgD0meson_"$i".root"
mintracks=3  
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minPt=0
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=10000        #!!!
minNhits=0
kinefit=1
##=========
##pSF=1.0240   ##data 2016-17
##pSF=1.0185   ##data 2016-17
pSF=1.0173   ##data 2016-17  - best
##=========
##pSF=1.030   ##data 2004
##=========
##pSF=1.0
#verbose=1

$HOME/development/Dmeson/analysis_D0meson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -y $pSF
##$HOME/development/Dmeson/analysis_D0meson -n 3000 -z $verbose -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

