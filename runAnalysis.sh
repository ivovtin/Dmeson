#!/bin/bash

inruns=23219
Nevents=10000
outfile="psi3770_to_D0meson_test.root"
#inruns="/home/ovtin/development/Dmeson/runsDmeson/runDmeson"$i
#outfile="/spool/users/ovtin/psi3770_to_D0meson_"$i".root"
mintracks=2
maxtracks=6
minbeamtracks=1
minIPtracks=1
maxIPtracks=6
minPt=10
maxPt=5000
minClusterEnergy=10
minTotalEnergy=45
minClusters=1
maxClusters=10
minClustersLKr=0
minClustersCsI=0
maxtchi2=150
minNhits=15
verbose=0

##$HOME/development/Dmeson/analysis_Dmeson -n 2000 -o $outfile $inruns
$HOME/development/Dmeson/analysis_Dmeson -x -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns

