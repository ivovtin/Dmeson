#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N eeSim
# -------------------------------------------
# --     What to redirect to where         --
# -- working directory --
#$ -cwd
#$ -o /spool/users/ovtin/$JOB_NAME.o$JOB_ID
# -- Merge the standard out and standard error to one file --
#$ -j y
##$ -shell n
##$ -V
##$ -e /dev/null
# -------------------------------------------
# --             Enviroment                --
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=bison-2
##$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
# -------------------------------------------
# --             Queue list                --
#$ -soft
##$ -hard
#$ -l time=24:00:00
##$ -q remote
##$ -q extralong
##$ -q 6h
##$ -q hour
#$ -q day
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 1-4

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
outfile="/spool/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i".root"
mintracks=2
maxtracks=2
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minPt=100
maxPt=10000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=0
#verbose=1

########################################################################################################
inruns="/store/sim/ee/Bhabha/1885/theta-15-165-IPzero-Field6kGs.dat.bz2"
#
if [ $i == 1 ]; then
NumFirstExpRun=23275
NumLastExpRun=23283   #75 runs        152 -> 87
NevRate=10
nevbegin=0
nevend=60000
fi

if [ $i == 2 ]; then
NumFirstExpRun=23287
NumLastExpRun=23293
NevRate=10
nevbegin=60001
nevend=120000
fi

if [ $i == 3 ]; then
NumFirstExpRun=23294
NumLastExpRun=23301
NevRate=10
nevbegin=120001
nevend=180000
fi

if [ $i == 4 ]; then
NumFirstExpRun=23304
NumLastExpRun=23310
NevRate=10
nevbegin=180001
nevend=240000
fi

if [ $i == 5 ]; then
NumFirstExpRun=23318
NumLastExpRun=23323
NevRate=50
nevbegin=240001
nevend=300000
fi

if [ $i == 6 ]; then
NumFirstExpRun=23325
NumLastExpRun=23332
NevRate=50
nevbegin=300001
nevend=360000
fi

if [ $i == 7 ]; then
NumFirstExpRun=23335
NumLastExpRun=23343
NevRate=50
nevbegin=360001
nevend=420000
fi

if [ $i == 8 ]; then
NumFirstExpRun=23346
NumLastExpRun=23354
NevRate=50
nevbegin=420001
nevend=480000
fi

if [ $i == 9 ]; then
NumFirstExpRun=23356
NumLastExpRun=23359
NevRate=50
nevbegin=480001
nevend=540000
fi

if [ $i == 10 ]; then
NumFirstExpRun=23411
NumLastExpRun=23421
NevRate=50
nevbegin=540001
nevend=600000
fi

###############################################

if [ $i == 11 ]; then
NumFirstExpRun=23422
NumLastExpRun=23430
NevRate=50
nevbegin=110001
nevend=120000
fi

if [ $i == 12 ]; then
NumFirstExpRun=23432
NumLastExpRun=23441
NevRate=50
nevbegin=120001
nevend=130000
fi

if [ $i == 13 ]; then
NumFirstExpRun=23442
NumLastExpRun=23451
NevRate=50
nevbegin=130001
nevend=140000
fi

if [ $i == 14 ]; then
NumFirstExpRun=23452
NumLastExpRun=23461
NevRate=50
nevbegin=140001
nevend=150000
fi

if [ $i == 15 ]; then
NumFirstExpRun=23462
NumLastExpRun=23471
NevRate=50
nevbegin=150001
nevend=160000
fi

if [ $i == 16 ]; then
NumFirstExpRun=23473
NumLastExpRun=23481
NevRate=50
nevbegin=160001
nevend=170000
fi

if [ $i == 17 ]; then
NumFirstExpRun=23482
NumLastExpRun=23498
NevRate=50
nevbegin=170001
nevend=180000
fi

if [ $i == 18 ]; then
NumFirstExpRun=23500
NumLastExpRun=23510   #175 runs        65
NevRate=50
nevbegin=180001
nevend=190000
fi

if [ $i == 19 ]; then
NumFirstExpRun=23511
NumLastExpRun=23520
NevRate=50
nevbegin=190001
nevend=200000
fi

if [ $i == 20 ]; then
NumFirstExpRun=23523
NumLastExpRun=23530
NevRate=50
nevbegin=200001
nevend=210000
fi

if [ $i == 21 ]; then
NumFirstExpRun=23531
NumLastExpRun=23540
NevRate=50
nevbegin=210001
nevend=220000
fi

if [ $i == 22 ]; then
NumFirstExpRun=23541
NumLastExpRun=23550
NevRate=50
nevbegin=220001
nevend=230000
fi

if [ $i == 23 ]; then
NumFirstExpRun=23551
NumLastExpRun=23560
NevRate=50
nevbegin=230001
nevend=240000
fi

if [ $i == 24 ]; then
NumFirstExpRun=23561
NumLastExpRun=23569
NevRate=50
nevbegin=240001
nevend=250000
fi

if [ $i == 25 ]; then
NumFirstExpRun=23670
NumLastExpRun=23675
NevRate=50
nevbegin=250001
nevend=260000
fi

if [ $i == 26 ]; then
NumFirstExpRun=23676
NumLastExpRun=23681
NevRate=50
nevbegin=260001
nevend=270000
fi

if [ $i == 27 ]; then
NumFirstExpRun=23686
NumLastExpRun=23695
NevRate=50
nevbegin=270001
nevend=280000
fi

if [ $i == 28 ]; then
NumFirstExpRun=23696
NumLastExpRun=23705
NevRate=50
nevbegin=280001
nevend=290000
fi

if [ $i == 29 ]; then
NumFirstExpRun=23706
NumLastExpRun=23715
NevRate=50
nevbegin=290001
nevend=300000
fi

if [ $i == 30 ]; then
NumFirstExpRun=23716
NumLastExpRun=23725
NevRate=50
nevbegin=300001
nevend=310000
fi

###############################################

if [ $i == 31 ]; then
NumFirstExpRun=23726
NumLastExpRun=23735
NevRate=50
nevbegin=310001
nevend=320000
fi

if [ $i == 32 ]; then
NumFirstExpRun=23736
NumLastExpRun=23742
NevRate=50
nevbegin=320001
nevend=330000
fi

if [ $i == 33 ]; then
NumFirstExpRun=23746
NumLastExpRun=23755
NevRate=50
nevbegin=330001
nevend=340000
fi

if [ $i == 34 ]; then
NumFirstExpRun=23756
NumLastExpRun=23759
NevRate=50
nevbegin=340001
nevend=350000
fi

if [ $i == 35 ]; then
##NumFirstExpRun=23809
##NumLastExpRun=23943   #292 runs       134
##NumLastExpRun=23927      #292 runs       134 -> 97
NumFirstExpRun=23830
NumLastExpRun=23838
NevRate=50
nevbegin=350001
nevend=360000
fi

if [ $i == 36 ]; then
NumFirstExpRun=23839
NumLastExpRun=23848
NevRate=50
nevbegin=360001
nevend=370000
fi

if [ $i == 37 ]; then
NumFirstExpRun=23850
NumLastExpRun=23859
NevRate=50
nevbegin=370001
nevend=380000
fi

if [ $i == 38 ]; then
NumFirstExpRun=23863
NumLastExpRun=23869
NevRate=50
nevbegin=380001
nevend=390000
fi

if [ $i == 39 ]; then
NumFirstExpRun=23870
NumLastExpRun=23879
NevRate=50
nevbegin=390001
nevend=400000
fi

if [ $i == 40 ]; then
NumFirstExpRun=23880
NumLastExpRun=23885
NevRate=50
nevbegin=400001
nevend=410000
fi

if [ $i == 41 ]; then
NumFirstExpRun=23886
NumLastExpRun=23895
NevRate=50
nevbegin=410001
nevend=420000
fi

if [ $i == 42 ]; then
NumFirstExpRun=23896
NumLastExpRun=23905
NevRate=50
nevbegin=420001
nevend=430000
fi

if [ $i == 43 ]; then
NumFirstExpRun=23907
NumLastExpRun=23916
NevRate=50
nevbegin=430001
nevend=440000
fi

if [ $i == 44 ]; then
NumFirstExpRun=23920
NumLastExpRun=23929
NevRate=50
nevbegin=440001
nevend=450000
fi

if [ $i == 45 ]; then
NumFirstExpRun=24621
#NumLastExpRun=24712   #352 runs        94
NumLastExpRun=24627
NevRate=50
nevbegin=450001
nevend=460000
fi

if [ $i == 46 ]; then
NumFirstExpRun=24628
NumLastExpRun=24637
NevRate=50
nevbegin=460001
nevend=470000
fi

if [ $i == 47 ]; then
NumFirstExpRun=24638
NumLastExpRun=24647
NevRate=50
nevbegin=470001
nevend=480000
fi

if [ $i == 48 ]; then
NumFirstExpRun=24648
NumLastExpRun=24657
NevRate=50
nevbegin=480001
nevend=490000
fi

if [ $i == 49 ]; then
NumFirstExpRun=24658
NumLastExpRun=24667
NevRate=50
nevbegin=490001
nevend=500000
fi

if [ $i == 50 ]; then
NumFirstExpRun=24668
NumLastExpRun=24675
NevRate=50
nevbegin=500001
nevend=510000
fi

if [ $i == 51 ]; then
NumFirstExpRun=24676
NumLastExpRun=24685
NevRate=50
nevbegin=510001
nevend=520000
fi

if [ $i == 52 ]; then
NumFirstExpRun=24688
NumLastExpRun=24697
NevRate=50
nevbegin=520001
nevend=530000
fi

if [ $i == 53 ]; then
NumFirstExpRun=24698
NumLastExpRun=24707
NevRate=50
nevbegin=530001
nevend=540000
fi

if [ $i == 54 ]; then
NumFirstExpRun=24708
NumLastExpRun=24712
NevRate=50
nevbegin=540001
nevend=550000
fi

if [ $i == 55 ]; then
##NumFirstExpRun=24790
##NumLastExpRun=24916    #424 runs      126
NumFirstExpRun=24802
NumLastExpRun=24811
NevRate=50
nevbegin=550001
nevend=560000
fi

if [ $i == 56 ]; then
NumFirstExpRun=24818
NumLastExpRun=24827
NevRate=50
nevbegin=560001
nevend=570000
fi

if [ $i == 57 ]; then
NumFirstExpRun=24828
NumLastExpRun=24837
NevRate=50
nevbegin=570001
nevend=580000
fi

if [ $i == 58 ]; then
NumFirstExpRun=24838
NumLastExpRun=24845
NevRate=50
nevbegin=580001
nevend=590000
fi

if [ $i == 59 ]; then
NumFirstExpRun=24847
NumLastExpRun=24856
NevRate=50
nevbegin=590001
nevend=600000
fi

#######################################################################################################
$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -w $nevbegin -g $nevend


status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
