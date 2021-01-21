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
#$ -q hour
##$ -q day
#
# -- Send mail at submission and completion of script --
##$ -m beas
##$ -M ovtin.ivan@gmail.com

##$ -t 1-60
#$ -t 11-20

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
outfile="/spool/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_"$i".root"
mintracks=2
maxtracks=2
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minPt=100
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=100
minNhits=0
#verbose=1


########################################################################################################
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000001.dat"
#
if [ $i == 1 ]; then
NumFirstExpRun=4100
#NumLastExpRun=4707  
NumLastExpRun=4109  
NevRate=50
nevbegin=0
nevend=6000
fi

if [ $i == 2 ]; then
NumFirstExpRun=4110
NumLastExpRun=4119
NevRate=50
nevbegin=6001
nevend=12000
fi

if [ $i == 3 ]; then
NumFirstExpRun=4120
NumLastExpRun=4129
NevRate=50
nevbegin=12001
nevend=18000
fi

if [ $i == 4 ]; then
NumFirstExpRun=4130
NumLastExpRun=4139
NevRate=50
nevbegin=18001
nevend=24000
fi

if [ $i == 5 ]; then
NumFirstExpRun=4140
NumLastExpRun=4149
NevRate=50
nevbegin=24001
nevend=30000
fi

if [ $i == 6 ]; then
NumFirstExpRun=4150
NumLastExpRun=4159
NevRate=50
nevbegin=30001
nevend=36000
fi

if [ $i == 7 ]; then
NumFirstExpRun=4160
NumLastExpRun=4169
NevRate=50
nevbegin=36001
nevend=42000
fi

if [ $i == 8 ]; then
NumFirstExpRun=4170
NumLastExpRun=4179
NevRate=50
nevbegin=42001
nevend=48000
fi

if [ $i == 9 ]; then
NumFirstExpRun=4180
NumLastExpRun=4189
NevRate=50
nevbegin=48001
nevend=50000
fi

########################################################################################################
if [ $i -ge 10 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000002.dat"
fi

#
if [ $i == 10 ]; then
NumFirstExpRun=4190
NumLastExpRun=4199
NevRate=50
nevbegin=0
nevend=6000
fi

if [ $i == 11 ]; then
NumFirstExpRun=4200
NumLastExpRun=4209
NevRate=50
nevbegin=6001
nevend=12000
fi

if [ $i == 12 ]; then
NumFirstExpRun=4210
NumLastExpRun=4219
NevRate=50
nevbegin=12001
nevend=18000
fi

if [ $i == 13 ]; then
NumFirstExpRun=4220
NumLastExpRun=4229
NevRate=50
nevbegin=18001
nevend=24000
fi

if [ $i == 14 ]; then
NumFirstExpRun=4230
NumLastExpRun=4239
NevRate=50
nevbegin=24001
nevend=30000
fi

if [ $i == 15 ]; then
NumFirstExpRun=4240
NumLastExpRun=4249
NevRate=50
nevbegin=30001
nevend=36000
fi

if [ $i == 16 ]; then
NumFirstExpRun=4250
NumLastExpRun=4259
NevRate=50
nevbegin=36001
nevend=43000
fi

if [ $i == 17 ]; then
NumFirstExpRun=4260
NumLastExpRun=4269
NevRate=50
nevbegin=43001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 18 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000003.dat"
fi

if [ $i == 18 ]; then
NumFirstExpRun=4270
NumLastExpRun=4279  
NevRate=50
nevbegin=0
nevend=7000
fi

if [ $i == 19 ]; then
NumFirstExpRun=4280
NumLastExpRun=4289
NevRate=50
nevbegin=7001
nevend=14000
fi

if [ $i == 20 ]; then
NumFirstExpRun=4290
NumLastExpRun=4299
NevRate=50
nevbegin=14001
nevend=21000
fi

if [ $i == 21 ]; then
NumFirstExpRun=4300
NumLastExpRun=4309
NevRate=50
nevbegin=21001
nevend=28000
fi

if [ $i == 22 ]; then
NumFirstExpRun=4310
NumLastExpRun=4319
NevRate=50
nevbegin=28001
nevend=36000
fi

if [ $i == 23 ]; then
NumFirstExpRun=4320
NumLastExpRun=4329
NevRate=50
nevbegin=36001
nevend=44000
fi

if [ $i == 24 ]; then
NumFirstExpRun=4330
NumLastExpRun=4339
NevRate=50
nevbegin=44001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 25 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000004.dat"
fi

if [ $i == 25 ]; then
NumFirstExpRun=4340
NumLastExpRun=4349
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 26 ]; then
NumFirstExpRun=4350
NumLastExpRun=4359
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 27 ]; then
NumFirstExpRun=4360
NumLastExpRun=4369
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 28 ]; then
NumFirstExpRun=4370
NumLastExpRun=4379
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 29 ]; then
NumFirstExpRun=4380
NumLastExpRun=4389
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 30 ]; then
NumFirstExpRun=4390
NumLastExpRun=4399
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 31 ]; then
NumFirstExpRun=4400
NumLastExpRun=4409
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 32 ]; then
NumFirstExpRun=4410
NumLastExpRun=4419
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 33 ]; then
NumFirstExpRun=4420
NumLastExpRun=4429
NevRate=50
nevbegin=40001
nevend=46000
fi

if [ $i == 34 ]; then
NumFirstExpRun=4430
NumLastExpRun=4439
NevRate=50
nevbegin=46001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 35 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000005.dat"
fi

if [ $i == 35 ]; then
NumFirstExpRun=4440
NumLastExpRun=4449
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 36 ]; then
NumFirstExpRun=4450
NumLastExpRun=4459
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 37 ]; then
NumFirstExpRun=4460
NumLastExpRun=4469
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 38 ]; then
NumFirstExpRun=4470
NumLastExpRun=4479
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 39 ]; then
NumFirstExpRun=4480
NumLastExpRun=4489
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 40 ]; then
NumFirstExpRun=4490
NumLastExpRun=4499
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 41 ]; then
NumFirstExpRun=4500
NumLastExpRun=4509
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 42 ]; then
NumFirstExpRun=4510
NumLastExpRun=4519
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 43 ]; then
NumFirstExpRun=4520
NumLastExpRun=4529
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 44 ]; then
NumFirstExpRun=4530
NumLastExpRun=4539
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 45 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000006.dat"
fi

if [ $i == 45 ]; then
NumFirstExpRun=4540
NumLastExpRun=4549
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 46 ]; then
NumFirstExpRun=4550
NumLastExpRun=4559
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 47 ]; then
NumFirstExpRun=4560
NumLastExpRun=4569
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 48 ]; then
NumFirstExpRun=4570
NumLastExpRun=4579
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 49 ]; then
NumFirstExpRun=4580
NumLastExpRun=4589
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 50 ]; then
NumFirstExpRun=4590
NumLastExpRun=4599
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 51 ]; then
NumFirstExpRun=4600
NumLastExpRun=4609
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 52 ]; then
NumFirstExpRun=4610
NumLastExpRun=4619
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 53 ]; then
NumFirstExpRun=4620
NumLastExpRun=4629
NevRate=50
nevbegin=40001
nevend=46000
fi

if [ $i == 54 ]; then
NumFirstExpRun=4630
NumLastExpRun=4639
NevRate=50
nevbegin=46001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 55 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000007.dat"
fi

if [ $i == 55 ]; then
NumFirstExpRun=4640
NumLastExpRun=4649
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 56 ]; then
NumFirstExpRun=4670
NumLastExpRun=4679
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 57 ]; then
NumFirstExpRun=4680
NumLastExpRun=4689
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 58 ]; then
NumFirstExpRun=4690
NumLastExpRun=4699
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 59 ]; then
NumFirstExpRun=4700
NumLastExpRun=4709
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 60 ]; then
NumFirstExpRun=4710
NumLastExpRun=4719
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 61 ]; then
NumFirstExpRun=4720
NumLastExpRun=4729
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 62 ]; then
NumFirstExpRun=4730
NumLastExpRun=4739
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 63 ]; then
NumFirstExpRun=4740
NumLastExpRun=4749
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 64 ]; then
NumFirstExpRun=4750
NumLastExpRun=4759
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 65 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000008.dat"
fi

if [ $i == 65 ]; then
##NumFirstExpRun=25034
NumFirstExpRun=25042
#NumLastExpRun=25139   #               105 -> 97
NumLastExpRun=25051
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 66 ]; then
NumFirstExpRun=25052
NumLastExpRun=25061
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 67 ]; then
NumFirstExpRun=25062
NumLastExpRun=25071
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 68 ]; then
NumFirstExpRun=25072
NumLastExpRun=25081
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 69 ]; then
NumFirstExpRun=25082
NumLastExpRun=25091
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 70 ]; then
NumFirstExpRun=25092
NumLastExpRun=25101
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 71 ]; then
NumFirstExpRun=25102
NumLastExpRun=25111
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 72 ]; then
NumFirstExpRun=25112
NumLastExpRun=25121
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 73 ]; then
NumFirstExpRun=25122
NumLastExpRun=25131
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 74 ]; then
NumFirstExpRun=25132
NumLastExpRun=25139
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 75 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000009.dat"
fi

if [ $i == 75 ]; then
##NumFirstExpRun=25140
NumFirstExpRun=25150
#NumLastExpRun=25244   #527 runs       104 -> 94
NumLastExpRun=25159
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 76 ]; then
NumFirstExpRun=25160
NumLastExpRun=25169
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 77 ]; then
NumFirstExpRun=25170
NumLastExpRun=25179
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 78 ]; then
NumFirstExpRun=25180
NumLastExpRun=25189
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 79 ]; then
NumFirstExpRun=25190
NumLastExpRun=25199
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 80 ]; then
NumFirstExpRun=25200
NumLastExpRun=25209
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 81 ]; then
NumFirstExpRun=25210
NumLastExpRun=25219
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 82 ]; then
NumFirstExpRun=25220
NumLastExpRun=25229
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 83 ]; then
NumFirstExpRun=25230
NumLastExpRun=25239
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 84 ]; then
NumFirstExpRun=25240
NumLastExpRun=25244
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 85 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000010.dat"
fi

if [ $i == 85 ]; then
##NumFirstExpRun=25328
NumFirstExpRun=25350
##NumLastExpRun=25447   #583 runs       119 -> 97
NumLastExpRun=25359
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 86 ]; then
NumFirstExpRun=25360
NumLastExpRun=25369
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 87 ]; then
NumFirstExpRun=25370
NumLastExpRun=25379
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 88 ]; then
NumFirstExpRun=25380
NumLastExpRun=25389
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 89 ]; then
NumFirstExpRun=25390
NumLastExpRun=25399
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 90 ]; then
NumFirstExpRun=25400
NumLastExpRun=25409
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 91 ]; then
NumFirstExpRun=25410
NumLastExpRun=25419
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 92 ]; then
NumFirstExpRun=25420
NumLastExpRun=25429
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 93 ]; then
NumFirstExpRun=25430
NumLastExpRun=25439
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 94 ]; then
NumFirstExpRun=25440
NumLastExpRun=25449
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 95 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000011.dat"
fi

if [ $i == 95 ]; then
#NumFirstExpRun=25513
##NumLastExpRun=25687   #660 runs       174
NumFirstExpRun=25565
##NumLastExpRun=25660   #660 runs       174 -> 95
NumLastExpRun=25574
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 96 ]; then
NumFirstExpRun=25575
NumLastExpRun=25584
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 97 ]; then
NumFirstExpRun=25585
NumLastExpRun=25594
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 98 ]; then
NumFirstExpRun=25595
NumLastExpRun=25604
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 99 ]; then
NumFirstExpRun=25605
NumLastExpRun=25614
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 100 ]; then
NumFirstExpRun=25615
NumLastExpRun=25624
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 101 ]; then
NumFirstExpRun=25625
NumLastExpRun=25634
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 102 ]; then
NumFirstExpRun=25635
NumLastExpRun=25644
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 103 ]; then
NumFirstExpRun=25645
NumLastExpRun=25654
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 104 ]; then
NumFirstExpRun=25655
NumLastExpRun=25660
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 105 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000012.dat"
fi

if [ $i == 105 ]; then
NumFirstExpRun=26058
##NumLastExpRun=26151   #693 runs        93
NumLastExpRun=26067
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 106 ]; then
NumFirstExpRun=26068
NumLastExpRun=26077
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 107 ]; then
NumFirstExpRun=26078
NumLastExpRun=26087
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 108 ]; then
NumFirstExpRun=26088
NumLastExpRun=26097
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 109 ]; then
NumFirstExpRun=26098
NumLastExpRun=26107
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 110 ]; then
NumFirstExpRun=26108
NumLastExpRun=26117
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 111 ]; then
NumFirstExpRun=26118
NumLastExpRun=26127
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 112 ]; then
NumFirstExpRun=26128
NumLastExpRun=26137
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 113 ]; then
NumFirstExpRun=26138
NumLastExpRun=26147
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 114 ]; then
NumFirstExpRun=26148
NumLastExpRun=26151
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################

####
##$HOME/development/Dmeson/analysis_bhabha -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -w $nevbegin -g $nevend > /dev/null
$HOME/development/Dmeson/analysis_bhabha -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -w $nevbegin -g $nevend


status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
