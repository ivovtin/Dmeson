#!/bin/bash

##inruns=4422
#inruns=4132
#inruns=4257
##inruns=4422
##inruns=23219
##inruns=25059
##inruns=24835
inruns=23341
##inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000001.dat"
Nevents=20000
outfile="psi3770_to_D0meson_test.root"
mintracks=3
maxtracks=16
minbeamtracks=0
minIPtracks=0
maxIPtracks=16
minPt=100
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=50
minNhits=20
kinefit=1
verbose=1
#nevbegin=20000
#nevend=20100
nevbegin=0
nevend=0
#pSF=1.0270   ##data 2004
##pSF=1.0155   ##data 2016-17
pSF=1.0170   ##data 2016-17


##$HOME/development/Dmeson/analysis_Dplusmeson -x -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -y $pSF
$HOME/development/Dmeson/analysis_Dplusmeson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -y $pSF
##$HOME/development/Dmeson/analysis_Dplusmeson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend -y $pSF
##For MC
##$HOME/development/Dmeson/analysis_Dplusmeson -x -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_Dplusmeson -v 23665 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

