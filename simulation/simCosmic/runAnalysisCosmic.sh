#!/bin/bash

simOn=1
##inruns=4422 #ev 3653
##inruns=23280
##inruns=23556
inruns="/store/users/ovtin/outDmeson/simulation/Cosmic/simCosm0000020.dat"
#inruns="/space/skim/psi3770/sim/sim713201.dat.bz2"
Nevents=2000
outfile="psi3770_to_cosm_test.root"
#mintracks=2
mintracks=1
maxtracks=3
minbeamtracks=0
minIPtracks=0
maxIPtracks=10
minPt=50
maxPt=5000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=10000
minNhits=15
verbose=1
NevRate=550
NumFirstExpRun=23556
NumLastExpRun=23556

##$HOME/development/Dmeson/analysis_bhabha -x -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns
##$HOME/development/Dmeson/analysis_bhabha -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns
##For MC
##$HOME/development/Dmeson/analysis_bhabha -x -D $simOn -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns
$HOME/development/Dmeson/analysis_bhabha -x -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile $inruns

