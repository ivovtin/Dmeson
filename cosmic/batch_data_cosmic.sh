#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N cosmic
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
##$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=bison-2
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
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

#$ -t 1-62

i=${SGE_TASK_ID}
myrand=$[1000+$i]


outfile="/spool/users/ovtin/outDmeson/cosmic/psi3770_to_cosmic_"$i".root"

##5 +
inruns="/spool/users/ovtin/cosmruns/march16cosmruns_"$i

##4 +
if [ $i -ge 6 ]; then
inruns="/spool/users/ovtin/cosmruns/apr16cosmruns_"[$i-5]
fi

##6 +
if [ $i -ge 10 ]; then
inruns="/spool/users/ovtin/cosmruns/may16cosmruns_"[$i-9]
fi

##4 +
if [ $i -ge 16 ]; then
inruns="/spool/users/ovtin/cosmruns/jun16cosmruns_"[$i-15]
fi

##5 +
if [ $i -ge 20 ]; then
inruns="/spool/users/ovtin/cosmruns/oct16cosmruns_"[$i-19]
fi

##2 +
if [ $i -ge 25 ]; then
inruns="/spool/users/ovtin/cosmruns/feb17cosmruns_"[$i-24]
fi

##3 +
if [ $i -ge 27 ]; then
inruns="/spool/users/ovtin/cosmruns/march17cosmruns_"[$i-26]
fi

##3 +
if [ $i -ge 30 ]; then
inruns="/spool/users/ovtin/cosmruns/apr17cosmruns_"[$i-29]
fi

##3 +
if [ $i -ge 33 ]; then
inruns="/spool/users/ovtin/cosmruns/may17cosmruns_"[$i-32]
fi

##1 +
if [ $i -ge 36 ]; then
inruns="/spool/users/ovtin/cosmruns/jun17cosmruns_"[$i-35]
fi

##9 +
if [ $i -ge 37 ]; then
inruns="/spool/users/ovtin/cosmruns/oct17cosmruns_"[$i-36]
fi

##1 +
if [ $i -ge 46 ]; then
inruns="/spool/users/ovtin/cosmruns/nov17cosmruns_"[$i-45]
fi

##7 +
if [ $i -ge 47 ]; then
inruns="/spool/users/ovtin/cosmruns/dec17cosmruns_"[$i-46]
fi

##6
if [ $i -ge 54 ]; then
inruns="/spool/users/ovtin/cosmruns/SC1_17cosmruns_"[$i-53]
fi

##2
if [ $i -ge 60 ]; then
inruns="/spool/users/ovtin/cosmruns/SC2_17cosmruns_"[$i-59]
fi

##============================================================

#inruns=23621
#outfile="/spool/users/ovtin/psi3770_to_cosmic_"$i".root"

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
verbose=0

$HOME/development/Dmeson/analysis_bhabha -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -z $verbose

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

