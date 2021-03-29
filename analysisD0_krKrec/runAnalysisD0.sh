#!/bin/bash

##inruns=4422 #ev 3653
##inruns=23665  #ev 527
##inruns=23443
##inruns=23247
##nevbegin=16000
##nevbegin=3890
nevbegin=0
##nevend=10000
nevend=1000
#inruns=4132
#inruns=4257
##inruns=4422
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson000001.dat"
Nevents=100000
outfile="psi3770_to_D0meson_test.root"
#mintracks=2
mintracks=4
maxtracks=20
minbeamtracks=4
minIPtracks=4
maxIPtracks=20
minPt=0
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=10000
minNhits=0
kinefit=1
#pSF=1.0185   ##data 2016-17
##pSF=1.0173   ##data 2016-17
##pSF=1.030   ##data 2004
#verbose=2
verbose=1

##echo $pSF

##$HOME/development/Dmeson/analysis_D0meson_krKrec -x -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit -y $pSF -w $nevbegin -g $nevend $inruns
##$HOME/development/Dmeson/analysis_D0meson_krKrec -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit -y $pSF -w $nevbegin -g $nevend $inruns
##For MC
##$HOME/development/Dmeson/analysis_D0meson_krKrec -x -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns
$HOME/development/Dmeson/analysis_D0meson_krKrec -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

