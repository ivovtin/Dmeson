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

##$ -t 1-114
##$ -t 2-4
##$ -t 5-9
##$ -t 10-11
##$ -t 12-15
##$ -t 16-19
##$ -t 20-22
##$ -t 23-24
##$ -t 25-26
##$ -t 27-29
##$ -t 30-32
##$ -t 33-34
##$ -t 36-37
##$ -t 38-40
##$ -t 41-42
##$ -t 43-44
##$ -t 45-50
##$ -t 51-54
##$ -t 55-58
##$ -t 59-61
##$ -t 62-64
##$ -t 65-69
##$ -t 70-71
##$ -t 72-75
##$ -t 76-78
##$ -t 79-84
##$ -t 85-89
##$ -t 90-91
##$ -t 92-95
##$ -t 96-98
##$ -t 99-100
##$ -t 101-103
##$ -t 104-107
##$ -t 108-109
##$ -t 110-113
##$ -t 114-116
##$ -t 117-120
#$ -t 121-124

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
maxPt=2000
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
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000013.dat"
##inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simDmeson000021.dat"
#
if [ $i == 1 ]; then
##NumFirstExpRun=23207
NumFirstExpRun=23275
NumLastExpRun=23286   #75 runs        152 -> 87
NevRate=50
nevbegin=0
nevend=6000
fi

if [ $i == 2 ]; then
NumFirstExpRun=23287
NumLastExpRun=23292
NevRate=50
nevbegin=6001
nevend=12000
fi

if [ $i == 3 ]; then
NumFirstExpRun=23293
NumLastExpRun=23303
NevRate=50
nevbegin=12001
nevend=18000
fi

if [ $i == 4 ]; then
NumFirstExpRun=23304
NumLastExpRun=23312
NevRate=50
nevbegin=18001
nevend=24000
fi

if [ $i == 5 ]; then
NumFirstExpRun=23318
NumLastExpRun=23323
NevRate=50
nevbegin=24001
nevend=30000
fi

if [ $i == 6 ]; then
NumFirstExpRun=23324
NumLastExpRun=23333
NevRate=50
nevbegin=30001
nevend=36000
fi

if [ $i == 7 ]; then
NumFirstExpRun=23334
NumLastExpRun=23344
NevRate=50
nevbegin=36001
nevend=42000
fi

if [ $i == 8 ]; then
NumFirstExpRun=23345
NumLastExpRun=23355
NevRate=50
nevbegin=42001
nevend=48000
fi

if [ $i == 9 ]; then
NumFirstExpRun=23356
NumLastExpRun=23359
NevRate=50
nevbegin=48001
nevend=50000
fi

########################################################################################################
if [ $i -ge 10 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000014.dat"
fi

#
if [ $i == 10 ]; then
NumFirstExpRun=23411
NumLastExpRun=23421
NevRate=50
nevbegin=0
nevend=6000
fi

if [ $i == 11 ]; then
NumFirstExpRun=23422
NumLastExpRun=23430
NevRate=50
nevbegin=6001
nevend=12000
fi

if [ $i == 12 ]; then
NumFirstExpRun=23432
NumLastExpRun=23441
NevRate=50
nevbegin=12001
nevend=18000
fi

if [ $i == 13 ]; then
NumFirstExpRun=23442
NumLastExpRun=23451
NevRate=50
nevbegin=18001
nevend=24000
fi

if [ $i == 14 ]; then
NumFirstExpRun=23452
NumLastExpRun=23461
NevRate=50
nevbegin=24001
nevend=30000
fi

if [ $i == 15 ]; then
NumFirstExpRun=23462
NumLastExpRun=23471
NevRate=50
nevbegin=30001
nevend=36000
fi

if [ $i == 16 ]; then
NumFirstExpRun=23473
NumLastExpRun=23481
NevRate=50
nevbegin=36001
nevend=43000
fi

if [ $i == 17 ]; then
NumFirstExpRun=23482
NumLastExpRun=23498
NevRate=50
nevbegin=43001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 18 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000015.dat"
fi

if [ $i == 18 ]; then
NumFirstExpRun=23500
NumLastExpRun=23510   #175 runs        65
NevRate=50
nevbegin=0
nevend=7000
fi

if [ $i == 19 ]; then
NumFirstExpRun=23511
NumLastExpRun=23520
NevRate=50
nevbegin=7001
nevend=14000
fi

if [ $i == 20 ]; then
NumFirstExpRun=23523
NumLastExpRun=23530
NevRate=50
nevbegin=14001
nevend=21000
fi

if [ $i == 21 ]; then
NumFirstExpRun=23531
NumLastExpRun=23540
NevRate=50
nevbegin=21001
nevend=28000
fi

if [ $i == 22 ]; then
NumFirstExpRun=23541
NumLastExpRun=23550
NevRate=50
nevbegin=28001
nevend=36000
fi

if [ $i == 23 ]; then
NumFirstExpRun=23551
NumLastExpRun=23560
NevRate=50
nevbegin=36001
nevend=44000
fi

if [ $i == 24 ]; then
NumFirstExpRun=23561
NumLastExpRun=23569
NevRate=50
nevbegin=44001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 25 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000016.dat"
fi

if [ $i == 25 ]; then
NumFirstExpRun=23670
NumLastExpRun=23675
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 26 ]; then
NumFirstExpRun=23676
NumLastExpRun=23681
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 27 ]; then
NumFirstExpRun=23686
NumLastExpRun=23695
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 28 ]; then
NumFirstExpRun=23696
NumLastExpRun=23705
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 29 ]; then
NumFirstExpRun=23706
NumLastExpRun=23715
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 30 ]; then
NumFirstExpRun=23716
NumLastExpRun=23725
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 31 ]; then
NumFirstExpRun=23726
NumLastExpRun=23735
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 32 ]; then
NumFirstExpRun=23736
NumLastExpRun=23742
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 33 ]; then
NumFirstExpRun=23746
NumLastExpRun=23755
NevRate=50
nevbegin=40001
nevend=46000
fi

if [ $i == 34 ]; then
NumFirstExpRun=23756
NumLastExpRun=23759
NevRate=50
nevbegin=46001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 35 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000017.dat"
fi

if [ $i == 35 ]; then
##NumFirstExpRun=23809
##NumLastExpRun=23943   #292 runs       134
##NumLastExpRun=23927      #292 runs       134 -> 97
NumFirstExpRun=23830
NumLastExpRun=23838
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 36 ]; then
NumFirstExpRun=23839
NumLastExpRun=23848
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 37 ]; then
NumFirstExpRun=23850
NumLastExpRun=23859
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 38 ]; then
NumFirstExpRun=23863
NumLastExpRun=23869
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 39 ]; then
NumFirstExpRun=23870
NumLastExpRun=23879
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 40 ]; then
NumFirstExpRun=23880
NumLastExpRun=23885
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 41 ]; then
NumFirstExpRun=23886
NumLastExpRun=23895
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 42 ]; then
NumFirstExpRun=23896
NumLastExpRun=23905
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 43 ]; then
NumFirstExpRun=23907
NumLastExpRun=23916
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 44 ]; then
NumFirstExpRun=23920
NumLastExpRun=23929
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 45 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000018.dat"
fi

if [ $i == 45 ]; then
NumFirstExpRun=24621
#NumLastExpRun=24712   #352 runs        94
NumLastExpRun=24627
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 46 ]; then
NumFirstExpRun=24628
NumLastExpRun=24637
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 47 ]; then
NumFirstExpRun=24638
NumLastExpRun=24647
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 48 ]; then
NumFirstExpRun=24648
NumLastExpRun=24657
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 49 ]; then
NumFirstExpRun=24658
NumLastExpRun=24667
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 50 ]; then
NumFirstExpRun=24668
NumLastExpRun=24675
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 51 ]; then
NumFirstExpRun=24676
NumLastExpRun=24685
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 52 ]; then
NumFirstExpRun=24688
NumLastExpRun=24697
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 53 ]; then
NumFirstExpRun=24698
NumLastExpRun=24707
NevRate=50
nevbegin=40001
nevend=46000
fi

if [ $i == 54 ]; then
NumFirstExpRun=24708
NumLastExpRun=24712
NevRate=50
nevbegin=46001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 55 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000019.dat"
fi

if [ $i == 55 ]; then
##NumFirstExpRun=24790
##NumLastExpRun=24916    #424 runs      126
NumFirstExpRun=24802
NumLastExpRun=24811
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 56 ]; then
NumFirstExpRun=24818
NumLastExpRun=24827
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 57 ]; then
NumFirstExpRun=24828
NumLastExpRun=24837
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 58 ]; then
NumFirstExpRun=24838
NumLastExpRun=24845
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 59 ]; then
NumFirstExpRun=24847
NumLastExpRun=24856
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 60 ]; then
NumFirstExpRun=24858
NumLastExpRun=24867
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 61 ]; then
NumFirstExpRun=24868
NumLastExpRun=24875
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 62 ]; then
NumFirstExpRun=24878
NumLastExpRun=24887
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 63 ]; then
NumFirstExpRun=24888
NumLastExpRun=24897
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 64 ]; then
NumFirstExpRun=24898
NumLastExpRun=24905
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 65 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000020.dat"
fi

if [ $i == 65 ]; then
##NumFirstExpRun=25034
NumFirstExpRun=25045
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
NumLastExpRun=25090
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 70 ]; then
NumFirstExpRun=25091
NumLastExpRun=25100
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
NumFirstExpRun=25115
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
#NumLastExpRun=25244   #527 runs       104 -> 94
NumFirstExpRun=25150
NumLastExpRun=25157
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
NumLastExpRun=25185
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 79 ]; then
NumFirstExpRun=25186
NumLastExpRun=25195
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
NumLastExpRun=25236
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 84 ]; then
NumFirstExpRun=25237
NumLastExpRun=25241
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
##NumLastExpRun=25447   #583 runs       119 -> 97
NumFirstExpRun=25352
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
NumLastExpRun=25395
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 90 ]; then
NumFirstExpRun=25396
NumLastExpRun=25405
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 91 ]; then
NumFirstExpRun=25410
NumLastExpRun=25416
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 92 ]; then
NumFirstExpRun=25418
NumLastExpRun=25422
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 93 ]; then
NumFirstExpRun=25423
NumLastExpRun=25428
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 94 ]; then
NumFirstExpRun=25429
NumLastExpRun=25434
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 95 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000011.dat"
fi

if [ $i == 95 ]; then
NumFirstExpRun=25435
NumLastExpRun=25438
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 96 ]; then
NumFirstExpRun=25439
NumLastExpRun=25443
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 97 ]; then
NumFirstExpRun=25444
NumLastExpRun=25448
NevRate=50
nevbegin=11001
nevend=15000
fi

if [ $i == 98 ]; then
NumFirstExpRun=25449
NumLastExpRun=25452
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 99 ]; then
##NumLastExpRun=25687   #660 runs       174
##NumLastExpRun=25660   #660 runs       174 -> 95
NumFirstExpRun=25559
NumLastExpRun=25566
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 100 ]; then
NumFirstExpRun=25567
NumLastExpRun=25574
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 101 ]; then
NumFirstExpRun=25575
NumLastExpRun=25584
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 102 ]; then
NumFirstExpRun=25585
NumLastExpRun=25594
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 103 ]; then
NumFirstExpRun=25595
NumLastExpRun=25604
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 104 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000012.dat"
fi

if [ $i == 104 ]; then
NumFirstExpRun=25609
NumLastExpRun=25614
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 105 ]; then
NumFirstExpRun=25615
NumLastExpRun=25624
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 106 ]; then
NumFirstExpRun=25625
NumLastExpRun=25634
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 107 ]; then
NumFirstExpRun=25635
NumLastExpRun=25640
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 108 ]; then
NumFirstExpRun=25641
NumLastExpRun=25650
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 109 ]; then
NumFirstExpRun=25655
NumLastExpRun=25663
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 110 ]; then
NumFirstExpRun=25664
NumLastExpRun=25673
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 111 ]; then
NumFirstExpRun=25674
NumLastExpRun=25683
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 112 ]; then
NumFirstExpRun=25688
NumLastExpRun=25696
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 113 ]; then
NumFirstExpRun=25697
NumLastExpRun=25705
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 114 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000008.dat"
fi

if [ $i == 114 ]; then
NumFirstExpRun=26051
NumLastExpRun=26060
NevRate=50
nevbegin=0
nevend=5000
fi

if [ $i == 115 ]; then
NumFirstExpRun=26061
NumLastExpRun=26070
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 116 ]; then
NumFirstExpRun=26071
NumLastExpRun=26079
NevRate=50
nevbegin=10001
nevend=15000
fi

if [ $i == 117 ]; then
NumFirstExpRun=26080
NumLastExpRun=26085
NevRate=50
nevbegin=15001
nevend=20000
fi

if [ $i == 118 ]; then
NumFirstExpRun=26086
NumLastExpRun=26091
NevRate=50
nevbegin=20001
nevend=25000
fi

if [ $i == 119 ]; then
NumFirstExpRun=26092
NumLastExpRun=26097
NevRate=50
nevbegin=25001
nevend=30000
fi

if [ $i == 120 ]; then
NumFirstExpRun=26098
NumLastExpRun=26102
NevRate=50
nevbegin=30001
nevend=35000
fi

if [ $i == 121 ]; then
NumFirstExpRun=26103
NumLastExpRun=26111
NevRate=50
nevbegin=35001
nevend=40000
fi

if [ $i == 122 ]; then
NumFirstExpRun=26112
NumLastExpRun=26119
NevRate=50
nevbegin=40001
nevend=45000
fi

if [ $i == 123 ]; then
NumFirstExpRun=26120
NumLastExpRun=26127
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 124 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000007.dat"
fi

if [ $i == 124 ]; then
NumFirstExpRun=26128
NumLastExpRun=26134
NevRate=50
nevbegin=0
nevend=5000
fi

####################

if [ $i == 125 ]; then
NumFirstExpRun=26135
NumLastExpRun=26147
NevRate=50
nevbegin=5001
nevend=10000
fi

if [ $i == 126 ]; then
NumFirstExpRun=26148
NumLastExpRun=26151
NevRate=50
nevbegin=10001
nevend=15000
fi

#######################################################################################################

####
##$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -w $nevbegin -g $nevend > /dev/null
$HOME/development/Dmeson/analysis_bhabha -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns -w $nevbegin -g $nevend


status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
