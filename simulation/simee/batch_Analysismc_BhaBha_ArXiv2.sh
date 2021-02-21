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
##$ -q hour
##$ -q day
#
# -- Send mail at submission and completion of script --
#$ -m beas
#$ -M ovtin.ivan@gmail.com

#$ -t 60-124

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
inruns="/store/sim/ee/Bhabha/1885/theta-15-165-IPzero-Field6kGs.dat.bz2"

if [ $i == 60 ]; then
NumFirstExpRun=24858
NumLastExpRun=24867
NevRate=50
nevbegin=0
nevend=10000
fi

if [ $i == 61 ]; then
NumFirstExpRun=24868
NumLastExpRun=24875
NevRate=50
nevbegin=10001
nevend=20000
fi

if [ $i == 62 ]; then
NumFirstExpRun=24878
NumLastExpRun=24887
NevRate=50
nevbegin=20001
nevend=30000
fi

if [ $i == 63 ]; then
NumFirstExpRun=24888
NumLastExpRun=24897
NevRate=50
nevbegin=30001
nevend=40000
fi

if [ $i == 64 ]; then
NumFirstExpRun=24898
NumLastExpRun=24905
NevRate=50
nevbegin=40001
nevend=50000
fi

if [ $i == 65 ]; then
##NumFirstExpRun=25034
NumFirstExpRun=25045
#NumLastExpRun=25139   #               105 -> 97
NumLastExpRun=25051
NevRate=50
nevbegin=50001
nevend=60000
fi

if [ $i == 66 ]; then
NumFirstExpRun=25052
NumLastExpRun=25061
NevRate=50
nevbegin=60001
nevend=70000
fi

if [ $i == 67 ]; then
NumFirstExpRun=25062
NumLastExpRun=25071
NevRate=50
nevbegin=70001
nevend=80000
fi

if [ $i == 68 ]; then
NumFirstExpRun=25072
NumLastExpRun=25081
NevRate=50
nevbegin=80001
nevend=90000
fi

if [ $i == 69 ]; then
NumFirstExpRun=25082
NumLastExpRun=25090
NevRate=50
nevbegin=90001
nevend=100000
fi

if [ $i == 70 ]; then
NumFirstExpRun=25091
NumLastExpRun=25100
NevRate=50
nevbegin=100001
nevend=110000
fi

if [ $i == 71 ]; then
NumFirstExpRun=25102
NumLastExpRun=25111
NevRate=50
nevbegin=110001
nevend=120000
fi

if [ $i == 72 ]; then
NumFirstExpRun=25115
NumLastExpRun=25121
NevRate=50
nevbegin=120001
nevend=130000
fi

if [ $i == 73 ]; then
NumFirstExpRun=25122
NumLastExpRun=25131
NevRate=50
nevbegin=130001
nevend=140000
fi

if [ $i == 74 ]; then
NumFirstExpRun=25132
NumLastExpRun=25139
NevRate=50
nevbegin=140001
nevend=150000
fi

if [ $i == 75 ]; then
##NumFirstExpRun=25140
#NumLastExpRun=25244   #527 runs       104 -> 94
NumFirstExpRun=25150
NumLastExpRun=25157
NevRate=50
nevbegin=150001
nevend=160000
fi

if [ $i == 76 ]; then
NumFirstExpRun=25160
NumLastExpRun=25169
NevRate=50
nevbegin=160001
nevend=170000
fi

if [ $i == 77 ]; then
NumFirstExpRun=25170
NumLastExpRun=25179
NevRate=50
nevbegin=170001
nevend=180000
fi

if [ $i == 78 ]; then
NumFirstExpRun=25180
NumLastExpRun=25185
NevRate=50
nevbegin=180001
nevend=190000
fi

if [ $i == 79 ]; then
NumFirstExpRun=25186
NumLastExpRun=25195
NevRate=50
nevbegin=190001
nevend=200000
fi

if [ $i == 80 ]; then
NumFirstExpRun=25200
NumLastExpRun=25209
NevRate=50
nevbegin=200001
nevend=210000
fi

if [ $i == 81 ]; then
NumFirstExpRun=25210
NumLastExpRun=25219
NevRate=50
nevbegin=210001
nevend=220000
fi

if [ $i == 82 ]; then
NumFirstExpRun=25220
NumLastExpRun=25229
NevRate=50
nevbegin=220001
nevend=230000
fi

if [ $i == 83 ]; then
NumFirstExpRun=25230
NumLastExpRun=25236
NevRate=50
nevbegin=230001
nevend=240000
fi

if [ $i == 84 ]; then
NumFirstExpRun=25237
NumLastExpRun=25241
NevRate=50
nevbegin=240001
nevend=250000
fi

if [ $i == 85 ]; then
##NumFirstExpRun=25328
##NumLastExpRun=25447   #583 runs       119 -> 97
NumFirstExpRun=25352
NumLastExpRun=25359
NevRate=50
nevbegin=250001
nevend=260000
fi

if [ $i == 86 ]; then
NumFirstExpRun=25360
NumLastExpRun=25369
NevRate=50
nevbegin=260001
nevend=270000
fi

if [ $i == 87 ]; then
NumFirstExpRun=25370
NumLastExpRun=25379
NevRate=50
nevbegin=270001
nevend=280000
fi

if [ $i == 88 ]; then
NumFirstExpRun=25380
NumLastExpRun=25389
NevRate=50
nevbegin=280001
nevend=290000
fi

if [ $i == 89 ]; then
NumFirstExpRun=25390
NumLastExpRun=25395
NevRate=50
nevbegin=290001
nevend=300000
fi

if [ $i == 90 ]; then
NumFirstExpRun=25396
NumLastExpRun=25405
NevRate=50
nevbegin=300001
nevend=310000
fi

if [ $i == 91 ]; then
NumFirstExpRun=25410
NumLastExpRun=25416
NevRate=50
nevbegin=310001
nevend=320000
fi

if [ $i == 92 ]; then
NumFirstExpRun=25418
NumLastExpRun=25422
NevRate=50
nevbegin=320001
nevend=330000
fi

if [ $i == 93 ]; then
NumFirstExpRun=25423
NumLastExpRun=25428
NevRate=50
nevbegin=330001
nevend=340000
fi

if [ $i == 94 ]; then
NumFirstExpRun=25429
NumLastExpRun=25434
NevRate=50
nevbegin=340001
nevend=350000
fi

if [ $i == 95 ]; then
NumFirstExpRun=25435
NumLastExpRun=25438
NevRate=50
nevbegin=350001
nevend=360000
fi

if [ $i == 96 ]; then
NumFirstExpRun=25439
NumLastExpRun=25443
NevRate=50
nevbegin=360001
nevend=370000
fi

if [ $i == 97 ]; then
NumFirstExpRun=25444
NumLastExpRun=25448
NevRate=50
nevbegin=370001
nevend=380000
fi

if [ $i == 98 ]; then
NumFirstExpRun=25449
NumLastExpRun=25452
NevRate=50
nevbegin=380001
nevend=390000
fi

if [ $i == 99 ]; then
##NumLastExpRun=25687   #660 runs       174
##NumLastExpRun=25660   #660 runs       174 -> 95
NumFirstExpRun=25559
NumLastExpRun=25566
NevRate=50
nevbegin=390001
nevend=400000
fi

if [ $i == 100 ]; then
NumFirstExpRun=25567
NumLastExpRun=25574
NevRate=50
nevbegin=410001
nevend=420000
fi

if [ $i == 101 ]; then
NumFirstExpRun=25575
NumLastExpRun=25584
NevRate=50
nevbegin=420001
nevend=430000
fi

if [ $i == 102 ]; then
NumFirstExpRun=25585
NumLastExpRun=25594
NevRate=50
nevbegin=430001
nevend=440000
fi

if [ $i == 103 ]; then
NumFirstExpRun=25595
NumLastExpRun=25604
NevRate=50
nevbegin=440001
nevend=450000
fi

if [ $i == 104 ]; then
NumFirstExpRun=25609
NumLastExpRun=25614
NevRate=50
nevbegin=450001
nevend=460000
fi

if [ $i == 105 ]; then
NumFirstExpRun=25615
NumLastExpRun=25624
NevRate=50
nevbegin=460001
nevend=470000
fi

if [ $i == 106 ]; then
NumFirstExpRun=25625
NumLastExpRun=25634
NevRate=50
nevbegin=470001
nevend=480000
fi

if [ $i == 107 ]; then
NumFirstExpRun=25635
NumLastExpRun=25640
NevRate=50
nevbegin=480001
nevend=490000
fi

if [ $i == 108 ]; then
NumFirstExpRun=25641
NumLastExpRun=25650
NevRate=50
nevbegin=490001
nevend=500000
fi

if [ $i == 109 ]; then
NumFirstExpRun=25655
NumLastExpRun=25663
NevRate=50
nevbegin=500001
nevend=510000
fi

if [ $i == 110 ]; then
NumFirstExpRun=25664
NumLastExpRun=25673
NevRate=50
nevbegin=510001
nevend=520000
fi

if [ $i == 111 ]; then
NumFirstExpRun=25674
NumLastExpRun=25683
NevRate=50
nevbegin=520001
nevend=530000
fi

if [ $i == 112 ]; then
NumFirstExpRun=25688
NumLastExpRun=25696
NevRate=50
nevbegin=530001
nevend=540000
fi

if [ $i == 113 ]; then
NumFirstExpRun=25697
NumLastExpRun=25705
NevRate=50
nevbegin=540001
nevend=550000
fi

if [ $i == 114 ]; then
NumFirstExpRun=26051
NumLastExpRun=26060
NevRate=50
nevbegin=550001
nevend=560000
fi

if [ $i == 115 ]; then
NumFirstExpRun=26061
NumLastExpRun=26070
NevRate=50
nevbegin=560001
nevend=565000
fi

if [ $i == 116 ]; then
NumFirstExpRun=26071
NumLastExpRun=26079
NevRate=50
nevbegin=565001
nevend=570000
fi

if [ $i == 117 ]; then
NumFirstExpRun=26080
NumLastExpRun=26085
NevRate=50
nevbegin=570001
nevend=575000
fi

if [ $i == 118 ]; then
NumFirstExpRun=26086
NumLastExpRun=26091
NevRate=50
nevbegin=575001
nevend=580000
fi

if [ $i == 119 ]; then
NumFirstExpRun=26092
NumLastExpRun=26097
NevRate=50
nevbegin=580001
nevend=585000
fi

if [ $i == 120 ]; then
NumFirstExpRun=26098
NumLastExpRun=26102
NevRate=50
nevbegin=585001
nevend=590000
fi

if [ $i == 121 ]; then
NumFirstExpRun=26103
NumLastExpRun=26111
NevRate=50
nevbegin=590001
nevend=593000
fi

if [ $i == 122 ]; then
NumFirstExpRun=26112
NumLastExpRun=26119
NevRate=50
nevbegin=593001
nevend=596000
fi

if [ $i == 123 ]; then
NumFirstExpRun=26120
NumLastExpRun=26127
NevRate=50
nevbegin=596001
nevend=598000
fi

if [ $i == 124 ]; then
NumFirstExpRun=26128
NumLastExpRun=26134
NevRate=50
nevbegin=598001
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
