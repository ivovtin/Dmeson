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

##$ -t 1-862
#$ -t 1-862
##$ -t 1-608
##$ -t 1-1

i=${SGE_TASK_ID}
myrand=$[1000+$i]

##inruns=23219
##Nevents=10000
#Signal
inruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/runDmeson"$i
##inruns="/home/ovtin/development/Dmeson/runsDmeson/runs2005/runDmeson"$i
##outfile="/spool/users/ovtin/outDmeson/psi3770_to_D0meson_"$i".root"
outfile="/spool/users/ovtin/outDmeson/Dplus/data/psi3770_to_D0meson_"$i".root"
#Bkg
#inruns="/home/ovtin/development/Dmeson/runsDmeson/runBkgDmeson"$i
#outfile="/spool/users/ovtin/psi3770_to_BkgD0meson_"$i".root"
mintracks=3
maxtracks=12
minbeamtracks=0
minIPtracks=0
maxIPtracks=12
minPt=100
maxPt=2000
#minClusterEnergy=15
#minTotalEnergy=45
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=100
minNhits=20
kinefit=1
#verbose=1

$HOME/development/Dmeson/analysis_Dplusmeson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
