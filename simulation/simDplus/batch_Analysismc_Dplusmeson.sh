#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimDpSig
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

#$ -t 1-114

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
outfile="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/psi3770_to_simDplusmesonSignal_"$i".root"
mintracks=3
maxtracks=12
minbeamtracks=0
minIPtracks=0
maxIPtracks=12
minPt=0
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=20
kinefit=1
##nevbegin=4001
##nevend=5000

########################################################################################################
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000001.dat"
#
if [ $i == 1 ]; then
##NumFirstExpRun=23207
##NumFirstExpRun=23897
##NumLastExpRun=23897
NumFirstExpRun=23272
NumLastExpRun=23282   #75 runs        152 -> 87
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 2 ]; then
NumFirstExpRun=23283
NumLastExpRun=23292
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 3 ]; then
NumFirstExpRun=23293
NumLastExpRun=23303
NevRate=50
nevbegin=6001
nevend=8000

fi

if [ $i == 4 ]; then
NumFirstExpRun=23304
NumLastExpRun=23312
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 5 ]; then
NumFirstExpRun=23313
NumLastExpRun=23323
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 6 ]; then
NumFirstExpRun=23324
NumLastExpRun=23333
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 7 ]; then
NumFirstExpRun=23334
NumLastExpRun=23344
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 8 ]; then
NumFirstExpRun=23345
NumLastExpRun=23355
NevRate=50
nevbegin=21001
nevend=24000
fi

if [ $i == 9 ]; then
NumFirstExpRun=23356
NumLastExpRun=23359
NevRate=50
nevbegin=24001
nevend=27000
fi

########################################################################################################
if [ $i -ge 10 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000002.dat"
fi

#
if [ $i == 10 ]; then
NumFirstExpRun=23411
NumLastExpRun=23421
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 11 ]; then
NumFirstExpRun=23422
NumLastExpRun=23431
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 12 ]; then
NumFirstExpRun=23432
NumLastExpRun=23441
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 13 ]; then
NumFirstExpRun=23442
NumLastExpRun=23451
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 14 ]; then
NumFirstExpRun=23452
NumLastExpRun=23461
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 15 ]; then
NumFirstExpRun=23462
NumLastExpRun=23471
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 16 ]; then
NumFirstExpRun=23472
NumLastExpRun=23481
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 17 ]; then
NumFirstExpRun=23482
NumLastExpRun=23498
NevRate=50
nevbegin=21001
nevend=24000
fi

#######################################################################################################
if [ $i -ge 18 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000003.dat"
fi

if [ $i == 18 ]; then
NumFirstExpRun=23500
NumLastExpRun=23510   #175 runs        65
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 19 ]; then
NumFirstExpRun=23511
NumLastExpRun=23520
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 20 ]; then
NumFirstExpRun=23521
NumLastExpRun=23530
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 21 ]; then
NumFirstExpRun=23531
NumLastExpRun=23540
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 22 ]; then
NumFirstExpRun=23541
NumLastExpRun=23550
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 23 ]; then
NumFirstExpRun=23551
NumLastExpRun=23560
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 24 ]; then
NumFirstExpRun=23561
NumLastExpRun=23565
NevRate=50
nevbegin=18001
nevend=21000
fi

#######################################################################################################
if [ $i -ge 25 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000004.dat"
fi

if [ $i == 25 ]; then
#NumFirstExpRun=23626
#NumLastExpRun=23759   #227 runs       133 ->93
NumFirstExpRun=23666
NumLastExpRun=23675
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 26 ]; then
NumFirstExpRun=23676
NumLastExpRun=23685
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 27 ]; then
NumFirstExpRun=23686
NumLastExpRun=23695
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 28 ]; then
NumFirstExpRun=23696
NumLastExpRun=23705
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 29 ]; then
NumFirstExpRun=23706
NumLastExpRun=23715
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 30 ]; then
NumFirstExpRun=23716
NumLastExpRun=23725
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 31 ]; then
NumFirstExpRun=23726
NumLastExpRun=23735
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 32 ]; then
NumFirstExpRun=23736
NumLastExpRun=23745
NevRate=50
nevbegin=21001
nevend=24000
fi

if [ $i == 33 ]; then
NumFirstExpRun=23746
NumLastExpRun=23755
NevRate=50
nevbegin=24001
nevend=27000
fi

if [ $i == 34 ]; then
NumFirstExpRun=23756
NumLastExpRun=23759
NevRate=50
nevbegin=27001
nevend=30000
fi

#######################################################################################################
if [ $i -ge 35 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000005.dat"
fi

if [ $i == 35 ]; then
##NumFirstExpRun=23809
##NumLastExpRun=23943   #292 runs       134
##NumLastExpRun=23927      #292 runs       134 -> 97
NumFirstExpRun=23830
NumLastExpRun=23839
NevRate=50
nevbegin=0
nevend=2000
fi

if [ $i == 36 ]; then
NumFirstExpRun=23840
NumLastExpRun=23849
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 37 ]; then
NumFirstExpRun=23850
NumLastExpRun=23859
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 38 ]; then
NumFirstExpRun=23860
NumLastExpRun=23869
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 39 ]; then
NumFirstExpRun=23870
NumLastExpRun=23879
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 40 ]; then
NumFirstExpRun=23880
NumLastExpRun=23889
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 41 ]; then
NumFirstExpRun=23890
NumLastExpRun=23899
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 42 ]; then
NumFirstExpRun=23900
NumLastExpRun=23909
NevRate=50
nevbegin=21001
nevend=23000
fi

if [ $i == 43 ]; then
NumFirstExpRun=23910
NumLastExpRun=23919
NevRate=50
nevbegin=24001
nevend=26000
fi

if [ $i == 44 ]; then
NumFirstExpRun=23920
NumLastExpRun=23929
NevRate=50
nevbegin=27001
nevend=29000
fi

#######################################################################################################
if [ $i -ge 45 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000006.dat"
fi

if [ $i == 45 ]; then
NumFirstExpRun=24618
#NumLastExpRun=24712   #352 runs        94
NumLastExpRun=24627
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 46 ]; then
NumFirstExpRun=24628
NumLastExpRun=24637
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 47 ]; then
NumFirstExpRun=24638
NumLastExpRun=24647
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 48 ]; then
NumFirstExpRun=24648
NumLastExpRun=24657
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 49 ]; then
NumFirstExpRun=24658
NumLastExpRun=24667
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 50 ]; then
NumFirstExpRun=24668
NumLastExpRun=24677
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 51 ]; then
NumFirstExpRun=24678
NumLastExpRun=24687
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 52 ]; then
NumFirstExpRun=24688
NumLastExpRun=24697
NevRate=50
nevbegin=21001
nevend=24000
fi

if [ $i == 53 ]; then
NumFirstExpRun=24698
NumLastExpRun=24707
NevRate=50
nevbegin=24001
nevend=26000
fi

if [ $i == 54 ]; then
NumFirstExpRun=24708
NumLastExpRun=24712
NevRate=50
nevbegin=27001
nevend=29000
fi

#######################################################################################################
if [ $i -ge 55 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000007.dat"
fi

if [ $i == 55 ]; then
##NumFirstExpRun=24790
##NumLastExpRun=24916    #424 runs      126
NumFirstExpRun=24808
#NumLastExpRun=24904    #424 runs      126 -> 96
NumLastExpRun=24817
NevRate=50
nevbegin=0
nevend=2000
fi

if [ $i == 56 ]; then
NumFirstExpRun=24818
NumLastExpRun=24827
NevRate=50
nevbegin=3001
nevend=5000
fi

if [ $i == 57 ]; then
NumFirstExpRun=24828
NumLastExpRun=24837
NevRate=50
nevbegin=6001
nevend=8000
fi

if [ $i == 58 ]; then
NumFirstExpRun=24838
NumLastExpRun=24847
NevRate=50
nevbegin=9001
nevend=11000
fi

if [ $i == 59 ]; then
NumFirstExpRun=24848
NumLastExpRun=24857
NevRate=50
nevbegin=12001
nevend=14000
fi

if [ $i == 60 ]; then
NumFirstExpRun=24858
NumLastExpRun=24867
NevRate=50
nevbegin=15001
nevend=17000
fi

if [ $i == 61 ]; then
NumFirstExpRun=24868
NumLastExpRun=24877
NevRate=50
nevbegin=18001
nevend=20000
fi

if [ $i == 62 ]; then
NumFirstExpRun=24878
NumLastExpRun=24887
NevRate=50
nevbegin=21001
nevend=23000
fi

if [ $i == 63 ]; then
NumFirstExpRun=24888
NumLastExpRun=24897
NevRate=50
nevbegin=24001
nevend=27000
fi

if [ $i == 64 ]; then
NumFirstExpRun=24898
NumLastExpRun=24905
NevRate=50
nevbegin=27001
nevend=30000
fi

#######################################################################################################
if [ $i -ge 65 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000008.dat"
fi

if [ $i == 65 ]; then
##NumFirstExpRun=25034
NumFirstExpRun=25042
#NumLastExpRun=25139   #               105 -> 97
NumLastExpRun=25051
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 66 ]; then
NumFirstExpRun=25052
NumLastExpRun=25061
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 67 ]; then
NumFirstExpRun=25062
NumLastExpRun=25071
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 68 ]; then
NumFirstExpRun=25072
NumLastExpRun=25081
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 69 ]; then
NumFirstExpRun=25082
NumLastExpRun=25091
NevRate=50
nevbegin=12001
nevend=14000
fi

if [ $i == 70 ]; then
NumFirstExpRun=25092
NumLastExpRun=25101
NevRate=50
nevbegin=15001
nevend=17000
fi

if [ $i == 71 ]; then
NumFirstExpRun=25102
NumLastExpRun=25111
NevRate=50
nevbegin=18001
nevend=20000
fi

if [ $i == 72 ]; then
NumFirstExpRun=25112
NumLastExpRun=25121
NevRate=50
nevbegin=21001
nevend=23000
fi

if [ $i == 73 ]; then
NumFirstExpRun=25122
NumLastExpRun=25131
NevRate=50
nevbegin=24001
nevend=26000
fi

if [ $i == 74 ]; then
NumFirstExpRun=25132
NumLastExpRun=25139
NevRate=50
nevbegin=27001
nevend=29000
fi

#######################################################################################################
if [ $i -ge 75 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000009.dat"
fi

if [ $i == 75 ]; then
##NumFirstExpRun=25140
NumFirstExpRun=25150
#NumLastExpRun=25244   #527 runs       104 -> 94
NumLastExpRun=25159
NevRate=50
nevbegin=0
nevend=2000
fi

if [ $i == 76 ]; then
NumFirstExpRun=25160
NumLastExpRun=25169
NevRate=50
nevbegin=3001
nevend=5000
fi

if [ $i == 77 ]; then
NumFirstExpRun=25170
NumLastExpRun=25179
NevRate=50
nevbegin=6001
nevend=8000
fi

if [ $i == 78 ]; then
NumFirstExpRun=25180
NumLastExpRun=25189
NevRate=50
nevbegin=9001
nevend=11000
fi

if [ $i == 79 ]; then
NumFirstExpRun=25190
NumLastExpRun=25199
NevRate=50
nevbegin=12001
nevend=14000
fi

if [ $i == 80 ]; then
NumFirstExpRun=25200
NumLastExpRun=25209
NevRate=50
nevbegin=15001
nevend=17000
fi

if [ $i == 81 ]; then
NumFirstExpRun=25210
NumLastExpRun=25219
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 82 ]; then
NumFirstExpRun=25220
NumLastExpRun=25229
NevRate=50
nevbegin=21001
nevend=23000
fi

if [ $i == 83 ]; then
NumFirstExpRun=25230
NumLastExpRun=25239
NevRate=50
nevbegin=24001
nevend=26000
fi

if [ $i == 84 ]; then
NumFirstExpRun=25240
NumLastExpRun=25244
NevRate=50
nevbegin=27001
nevend=30000
fi

#######################################################################################################
if [ $i -ge 85 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson0000010.dat"
fi

if [ $i == 85 ]; then
##NumFirstExpRun=25328
NumFirstExpRun=25350
##NumLastExpRun=25447   #583 runs       119 -> 97
NumLastExpRun=25359
NevRate=50
nevbegin=0
nevend=2000
fi

if [ $i == 86 ]; then
NumFirstExpRun=25360
NumLastExpRun=25369
NevRate=50
nevbegin=3001
nevend=5000
fi

if [ $i == 87 ]; then
NumFirstExpRun=25370
NumLastExpRun=25379
NevRate=50
nevbegin=6001
nevend=8000
fi

if [ $i == 88 ]; then
NumFirstExpRun=25380
NumLastExpRun=25389
NevRate=50
nevbegin=9001
nevend=11000
fi

if [ $i == 89 ]; then
NumFirstExpRun=25390
NumLastExpRun=25399
NevRate=50
nevbegin=12001
nevend=14000
fi

if [ $i == 90 ]; then
NumFirstExpRun=25400
NumLastExpRun=25409
NevRate=50
nevbegin=15001
nevend=17000
fi

if [ $i == 91 ]; then
NumFirstExpRun=25410
NumLastExpRun=25419
NevRate=50
nevbegin=18001
nevend=20000
fi

if [ $i == 92 ]; then
NumFirstExpRun=25420
NumLastExpRun=25429
NevRate=50
nevbegin=21001
nevend=23000
fi

if [ $i == 93 ]; then
NumFirstExpRun=25430
NumLastExpRun=25439
NevRate=50
nevbegin=24001
nevend=26000
fi

if [ $i == 94 ]; then
NumFirstExpRun=25440
NumLastExpRun=25449
NevRate=50
nevbegin=27001
nevend=30000
fi

#######################################################################################################
if [ $i -ge 95 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson0000011.dat"
fi

if [ $i == 95 ]; then
#NumFirstExpRun=25513
##NumLastExpRun=25687   #660 runs       174
NumFirstExpRun=25565
##NumLastExpRun=25660   #660 runs       174 -> 95
NumLastExpRun=25574
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 96 ]; then
NumFirstExpRun=25575
NumLastExpRun=25584
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 97 ]; then
NumFirstExpRun=25585
NumLastExpRun=25594
NevRate=50
nevbegin=6001
nevend=8000
fi

if [ $i == 98 ]; then
NumFirstExpRun=25595
NumLastExpRun=25604
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 99 ]; then
NumFirstExpRun=25605
NumLastExpRun=25614
NevRate=50
nevbegin=12001
nevend=14000
fi

if [ $i == 100 ]; then
NumFirstExpRun=25615
NumLastExpRun=25624
NevRate=50
nevbegin=15001
nevend=17000
fi

if [ $i == 101 ]; then
NumFirstExpRun=25625
NumLastExpRun=25634
NevRate=50
nevbegin=18001
nevend=20000
fi

if [ $i == 102 ]; then
NumFirstExpRun=25635
NumLastExpRun=25644
NevRate=50
nevbegin=21001
nevend=23000
fi

if [ $i == 103 ]; then
NumFirstExpRun=25645
NumLastExpRun=25654
NevRate=50
nevbegin=24001
nevend=23000
fi

if [ $i == 104 ]; then
NumFirstExpRun=25655
NumLastExpRun=25660
NevRate=50
nevbegin=27001
nevend=29000
fi

#######################################################################################################
if [ $i -ge 105 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson0000012.dat"
fi

if [ $i == 105 ]; then
NumFirstExpRun=26058
##NumLastExpRun=26151   #693 runs        93
NumLastExpRun=26067
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 106 ]; then
NumFirstExpRun=26068
NumLastExpRun=26077
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 107 ]; then
NumFirstExpRun=26078
NumLastExpRun=26087
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 108 ]; then
NumFirstExpRun=26088
NumLastExpRun=26097
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 109 ]; then
NumFirstExpRun=26098
NumLastExpRun=26107
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 110 ]; then
NumFirstExpRun=26108
NumLastExpRun=26117
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 111 ]; then
NumFirstExpRun=26118
NumLastExpRun=26127
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 112 ]; then
NumFirstExpRun=26128
NumLastExpRun=26137
NevRate=50
nevbegin=21001
nevend=24000
fi

if [ $i == 113 ]; then
NumFirstExpRun=26138
NumLastExpRun=26147
NevRate=50
nevbegin=24001
nevend=27000
fi

if [ $i == 114 ]; then
NumFirstExpRun=26148
NumLastExpRun=26151
NevRate=50
nevbegin=27001
nevend=30000
fi

#######################################################################################################

$HOME/development/Dmeson/analysis_Dplusmeson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

