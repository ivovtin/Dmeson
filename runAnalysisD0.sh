#!/bin/bash

#inruns=23219
#inruns=24835
inruns="/spool/users/ovtin/outDmeson/simulation/simDmeson000001.dat"
Nevents=5000
outfile="psi3770_to_D0meson_test.root"
mintracks=4
maxtracks=4
minbeamtracks=2
minIPtracks=2
maxIPtracks=4
minPt=10
maxPt=5000
minClusterEnergy=15
minTotalEnergy=45
minClusters=3
maxClusters=8
minClustersLKr=0
minClustersCsI=0
maxtchi2=50
minNhits=25
verbose=1

##$HOME/development/Dmeson/analysis_D0meson -x -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns
##$HOME/development/Dmeson/analysis_D0meson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns
##For MC
##$HOME/development/Dmeson/analysis_D0meson -x -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns
$HOME/development/Dmeson/analysis_D0meson -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns

