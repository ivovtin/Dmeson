#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N Dpmeson
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
##$ -q 6h
##$ -q day
#
# -- Send mail at submission and completion of script --
##$ -m beas
##$ -M ovtin.ivan@gmail.com

#$ -t 1-482
##$ -t 1-693

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
##inruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/runDmeson"$i
##outfile="/spool/users/ovtin/outDmeson/Dplus/dataPcorr_1.0170/psi3770_to_D0meson_"$i".root"
inruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/runDmeson"$i
##outfile="/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004/psi3770_to_D0meson_"$i".root"
outfile="/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0280/psi3770_to_D0meson_"$i".root"
mintracks=3
maxtracks=25
minbeamtracks=0
minIPtracks=0
maxIPtracks=25
minPt=0
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=35
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000   #!!!!!!!!
minNhits=0
kinefit=1
##pSF=1.0270   ##data 2004
pSF=1.0280   ##data 2004
##pSF=1.0155   ##data 2016-17
##pSF=1.0170   ##data 2016-17
##verbose=1

##$HOME/development/Dmeson/analysis_Dplusmeson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns
$HOME/development/Dmeson/analysis_Dplusmeson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -y $pSF

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

