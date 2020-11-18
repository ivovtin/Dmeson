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

#$ -t 1-862
##$ -t 1-608

i=${SGE_TASK_ID}
myrand=$[1000+$i]

##inruns=23219
#Signal
inruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/runDmeson"$i
##outfile="/spool/users/ovtin/outDmeson/D0/data/psi3770_to_D0meson_"$i".root"
outfile="/spool/users/ovtin/outDmeson/D0/dataPcorr_v11/psi3770_to_D0meson_"$i".root"
##inruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/runDmeson"$i
##outfile="/spool/users/ovtin/outDmeson/D0/data2004_v3/psi3770_to_D0meson_"$i".root"
#Bkg
#inruns="/home/ovtin/development/Dmeson/runsDmeson/runBkgDmeson"$i
#outfile="/spool/users/ovtin/psi3770_to_BkgD0meson_"$i".root"
mintracks=3  ##!!!
##mintracks=2
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minPt=100
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=100
##maxtchi2=50   ##!!!
minNhits=0
kinefit=1
##pSF=1.0381   ##data 2016-17 v4
##pSF=1.034   ##data 2016-17   v5
##pSF=1.030   ##data 2016-17   v6
##pSF=1.026   ##data 2016-17   v7
##pSF=1.022   ##data 2016-17   v8
##pSF=1.0185   ##data 2016-17   v9   - best
##pSF=1.0195   ##data 2016-17   v10
pSF=1.0252   ##data 2016-17   v11
##pSF=1.0   ##data 2016-17
##=========
##pSF=1.035   ##data 2004 pcor
##pSF=1.029   ##data 2004  v2, v3
##pSF=1.030   ##data 2004  v3
##pSF=1.0   ##data 2004
#verbose=1

$HOME/development/Dmeson/analysis_D0meson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -y $pSF
##$HOME/development/Dmeson/analysis_D0meson -n 3000 -z $verbose -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

