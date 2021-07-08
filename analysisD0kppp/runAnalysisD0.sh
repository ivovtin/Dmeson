#!/bin/bash

inruns=23665
nevbegin=0
nevend=50000
#inruns="/store/users/ovtin/outDmeson/simulation/outsimD0_kppp/Signal/simDmeson000001.dat"
##inruns="/store/users/ovtin/outDmeson/simulation/outsimD0_kppp/Bkg_eetoDD/simDmeson000001.dat"
##inruns="/store/users/ovtin/simDmeson000001.dat"
Nevents=100000
outfile="psi3770_to_D0meson_test.root"
mintracks=4
maxtracks=20
minbeamtracks=2
minIPtracks=2
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
##kinefit=0
pSF=1.0220   ##data 2016-17
##pSF=1.0173   ##data 2016-17
##pSF=1.0155   ##data 2016-17
##pSF=1.030   ##data 2004
verbose=3
#verbose=1

##echo $pSF

$HOME/development/Dmeson/analysis_D0kppp -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit $inruns -y $pSF -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_D0kppp -x -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit $inruns -y $pSF 
##$HOME/development/Dmeson/analysis_D0meson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit $inruns -y $pSF -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_D0meson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -y $pSF
##For MC
##$HOME/development/Dmeson/analysis_D0kppp -D 1 -x -v 23225 -m 23225 -M 50 -S 1.0 -A 6.0 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_D0kppp -D 1 -v 23272 -m 23272 -M 50 -S 1.0 -A 6.0 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -n $Nevents -z $verbose -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

