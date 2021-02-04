#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimKspp
# -------------------------------------------
# --     What to redirect to where         --
# -- working directory --
#$ -cwd             # run the job in the directory specified.
#$ -o /spool/users/ovtin/$JOB_NAME.o$JOB_ID
# -- Merge the standard out and standard error to one file --
#$ -j y
##$ -shell n
#$ -V                 ##will pass all environment variables to the job
##$ -e /dev/null
# -------------------------------------------
# --             Enviroment                --
##$ -v PATH=$PATH:$HOME/development/lib:/home/ovtin/development/KrKRec,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/ovtin/development/lib,KDBHOST=bison-2
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/alexbarn/release/lib,KDBHOST=localhost
# -------------------------------------------
# --             Queue list                --
#$ -soft
##$ -hard
##$ -l time=24:00:00
#$ -l time=6:00:00
#$ -q remote
##$ -q extralong
##$ -q 6h
##$ -q day
#
# -- Send mail at submission and completion of script --
##$ -m beas
##$ -M ovtin.ivan@gmail.com

#$ -t 1-221

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
outfile="/spool/users/ovtin/outDmeson/simulation/Kspp/psi3770_to_Kspp_"$i".root"
mintracks=3
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minP=100
maxP=1600
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=23
#verbose=1

########################################################################################################
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000001.dat"
#
if [ $i == 1 ]; then
##NumFirstExpRun=23207
NumFirstExpRun=23272
NumLastExpRun=23276   #75 runs        152 -> 87
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 2 ]; then
NumFirstExpRun=23277
NumLastExpRun=23282
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 3 ]; then
NumFirstExpRun=23283
NumLastExpRun=23286
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 4 ]; then
NumFirstExpRun=23287
NumLastExpRun=23292
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 5 ]; then
NumFirstExpRun=23293
NumLastExpRun=23297
NevRate=50
nevbegin=12001
nevend=14600
fi

if [ $i == 6 ]; then
NumFirstExpRun=23298
NumLastExpRun=23303
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 7 ]; then
NumFirstExpRun=23304
NumLastExpRun=23307
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 8 ]; then
NumFirstExpRun=23308
NumLastExpRun=23312
NevRate=50
nevbegin=21001
nevend=24000
fi

if [ $i == 9 ]; then
NumFirstExpRun=23313
NumLastExpRun=23317
NevRate=50
nevbegin=24001
nevend=27000
fi

if [ $i == 10 ]; then
NumFirstExpRun=23318
NumLastExpRun=23323
NevRate=50
nevbegin=27001
nevend=30000
fi

if [ $i == 11 ]; then
NumFirstExpRun=23324
NumLastExpRun=23327
NevRate=50
nevbegin=30001
nevend=33000
fi

if [ $i == 12 ]; then
NumFirstExpRun=23328
NumLastExpRun=23333
NevRate=50
nevbegin=33001
nevend=36000
fi

if [ $i == 13 ]; then
NumFirstExpRun=23334
NumLastExpRun=23339
NevRate=50
nevbegin=36001
nevend=39000
fi

if [ $i == 14 ]; then
NumFirstExpRun=23340
NumLastExpRun=23344
NevRate=50
nevbegin=39001
nevend=42000
fi

if [ $i == 15 ]; then
NumFirstExpRun=23345
NumLastExpRun=23350
NevRate=50
nevbegin=42001
nevend=45000
fi

if [ $i == 16 ]; then
NumFirstExpRun=23351
NumLastExpRun=23355
NevRate=50
nevbegin=45001
nevend=48000
fi

if [ $i == 17 ]; then
NumFirstExpRun=23356
NumLastExpRun=23359
NevRate=50
nevbegin=48001
nevend=50000
fi

########################################################################################################
if [ $i -ge 18 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000002.dat"
fi

if [ $i == 18 ]; then
NumFirstExpRun=23411
NumLastExpRun=23415
NevRate=50
nevbegin=0
nevend=3000
fi

if [ $i == 19 ]; then
NumFirstExpRun=23416
NumLastExpRun=23421
NevRate=50
nevbegin=3001
nevend=6000
fi

if [ $i == 20 ]; then
NumFirstExpRun=23422
NumLastExpRun=23426
NevRate=50
nevbegin=6001
nevend=9000
fi

if [ $i == 21 ]; then
NumFirstExpRun=23427
NumLastExpRun=23431
NevRate=50
nevbegin=9001
nevend=12000
fi

if [ $i == 22 ]; then
NumFirstExpRun=23432
NumLastExpRun=23436
NevRate=50
nevbegin=12001
nevend=15000
fi

if [ $i == 23 ]; then
NumFirstExpRun=23437
NumLastExpRun=23441
NevRate=50
nevbegin=15001
nevend=18000
fi

if [ $i == 24 ]; then
NumFirstExpRun=23442
NumLastExpRun=23446
NevRate=50
nevbegin=18001
nevend=21000
fi

if [ $i == 25 ]; then
NumFirstExpRun=23447
NumLastExpRun=23451
NevRate=50
nevbegin=21001
nevend=24000
fi

if [ $i == 26 ]; then
NumFirstExpRun=23452
NumLastExpRun=23456
NevRate=50
nevbegin=24001
nevend=27000
fi

if [ $i == 27 ]; then
NumFirstExpRun=23457
NumLastExpRun=23461
NevRate=50
nevbegin=27001
nevend=30000
fi

if [ $i == 28 ]; then
NumFirstExpRun=23462
NumLastExpRun=23466
NevRate=50
nevbegin=30001
nevend=33000
fi

if [ $i == 29 ]; then
NumFirstExpRun=23467
NumLastExpRun=23471
NevRate=50
nevbegin=33001
nevend=36000
fi

if [ $i == 30 ]; then
NumFirstExpRun=23472
NumLastExpRun=23476
NevRate=50
nevbegin=36001
nevend=39000
fi

if [ $i == 31 ]; then
NumFirstExpRun=23477
NumLastExpRun=23481
NevRate=50
nevbegin=39001
nevend=43000
fi

if [ $i == 32 ]; then
NumFirstExpRun=23482
NumLastExpRun=23486
NevRate=50
nevbegin=43001
nevend=47000
fi

if [ $i == 33 ]; then
NumFirstExpRun=23487
NumLastExpRun=23498
NevRate=50
nevbegin=47001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 34 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000003.dat"
fi

if [ $i == 34 ]; then
NumFirstExpRun=23500
NumLastExpRun=23505   #175 runs        65
NevRate=50
nevbegin=0
nevend=3500
fi

if [ $i == 35 ]; then
NumFirstExpRun=23506
NumLastExpRun=23510
NevRate=50
nevbegin=3501
nevend=7000
fi

if [ $i == 36 ]; then
NumFirstExpRun=23511
NumLastExpRun=23515
NevRate=50
nevbegin=7001
nevend=10500
fi

if [ $i == 37 ]; then
NumFirstExpRun=23516
NumLastExpRun=23520
NevRate=50
nevbegin=10501
nevend=14000
fi

if [ $i == 38 ]; then
NumFirstExpRun=23521
NumLastExpRun=23525
NevRate=50
nevbegin=14001
nevend=17500
fi

if [ $i == 39 ]; then
NumFirstExpRun=23526
NumLastExpRun=23530
NevRate=50
nevbegin=17501
nevend=21000
fi

if [ $i == 40 ]; then
NumFirstExpRun=23531
NumLastExpRun=23535
NevRate=50
nevbegin=21001
nevend=24500
fi

if [ $i == 41 ]; then
NumFirstExpRun=23536
NumLastExpRun=23540
NevRate=50
nevbegin=24501
nevend=28000
fi

if [ $i == 42 ]; then
NumFirstExpRun=23541
NumLastExpRun=23545
NevRate=50
nevbegin=28001
nevend=32000
fi

if [ $i == 43 ]; then
NumFirstExpRun=23546
NumLastExpRun=23550
NevRate=50
nevbegin=32001
nevend=36000
fi

if [ $i == 44 ]; then
NumFirstExpRun=23551
NumLastExpRun=23555
NevRate=50
nevbegin=36001
nevend=40000
fi

if [ $i == 45 ]; then
NumFirstExpRun=23556
NumLastExpRun=23560
NevRate=50
nevbegin=40001
nevend=44000
fi

if [ $i == 46 ]; then
NumFirstExpRun=23561
NumLastExpRun=23565
NevRate=50
nevbegin=44001
nevend=48000
fi

#######################################################################################################
if [ $i -ge 47 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000004.dat"
fi

if [ $i == 47 ]; then
#NumFirstExpRun=23626
#NumLastExpRun=23759   #227 runs       133 ->93
NumFirstExpRun=23666
NumLastExpRun=23670
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 48 ]; then
NumFirstExpRun=23671
NumLastExpRun=23675
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 49 ]; then
NumFirstExpRun=23676
NumLastExpRun=23680
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 50 ]; then
NumFirstExpRun=23681
NumLastExpRun=23685
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 51 ]; then
NumFirstExpRun=23686
NumLastExpRun=23690
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 52 ]; then
NumFirstExpRun=23691
NumLastExpRun=23695
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 53 ]; then
NumFirstExpRun=23696
NumLastExpRun=23700
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 54 ]; then
NumFirstExpRun=23701
NumLastExpRun=23705
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 55 ]; then
NumFirstExpRun=23706
NumLastExpRun=23710
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 56 ]; then
NumFirstExpRun=23711
NumLastExpRun=23715
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 57 ]; then
NumFirstExpRun=23716
NumLastExpRun=23720
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 58 ]; then
NumFirstExpRun=23721
NumLastExpRun=23725
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 59 ]; then
NumFirstExpRun=23726
NumLastExpRun=23730
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 60 ]; then
NumFirstExpRun=23731
NumLastExpRun=23735
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 61 ]; then
NumFirstExpRun=23736
NumLastExpRun=23738
NevRate=50
nevbegin=35001
nevend=37200
fi

if [ $i == 62 ]; then
NumFirstExpRun=23741
NumLastExpRun=23745
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 63 ]; then
NumFirstExpRun=23746
NumLastExpRun=23750
NevRate=50
nevbegin=40001
nevend=43000
fi

if [ $i == 64 ]; then
NumFirstExpRun=23751
NumLastExpRun=23755
NevRate=50
nevbegin=43001
nevend=46000
fi

if [ $i == 65 ]; then
NumFirstExpRun=23756
NumLastExpRun=23759
NevRate=50
nevbegin=46001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 66 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000005.dat"
fi

if [ $i == 66 ]; then
##NumFirstExpRun=23809
##NumLastExpRun=23943   #292 runs       134
##NumLastExpRun=23927      #292 runs       134 -> 97
NumFirstExpRun=23830
NumLastExpRun=23834
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 67 ]; then
NumFirstExpRun=23835
NumLastExpRun=23839
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 68 ]; then
NumFirstExpRun=23840
NumLastExpRun=23844
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 69 ]; then
NumFirstExpRun=23845
NumLastExpRun=23847
NevRate=50
nevbegin=7501
nevend=9500
fi

if [ $i == 70 ]; then
NumFirstExpRun=23850
NumLastExpRun=23852
NevRate=50
nevbegin=10001
nevend=12200
fi

if [ $i == 71 ]; then
NumFirstExpRun=23855
NumLastExpRun=23859
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 72 ]; then
NumFirstExpRun=23860
NumLastExpRun=23864
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 73 ]; then
NumFirstExpRun=23865
NumLastExpRun=23869
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 74 ]; then
NumFirstExpRun=23870
NumLastExpRun=23874
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 75 ]; then
NumFirstExpRun=23875
NumLastExpRun=23879
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 76 ]; then
NumFirstExpRun=23880
NumLastExpRun=23884
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 77 ]; then
NumFirstExpRun=23885
NumLastExpRun=23889
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 78 ]; then
NumFirstExpRun=23890
NumLastExpRun=23894
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 79 ]; then
NumFirstExpRun=23895
NumLastExpRun=23899
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 80 ]; then
NumFirstExpRun=23900
NumLastExpRun=23904
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 81 ]; then
NumFirstExpRun=23905
NumLastExpRun=23909
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 82 ]; then
NumFirstExpRun=23910
NumLastExpRun=23914
NevRate=50
nevbegin=40001
nevend=42500
fi

if [ $i == 83 ]; then
NumFirstExpRun=23915
NumLastExpRun=23919
NevRate=50
nevbegin=42501
nevend=45000
fi

if [ $i == 84 ]; then
NumFirstExpRun=23920
NumLastExpRun=23924
NevRate=50
nevbegin=45001
nevend=47500
fi

if [ $i == 85 ]; then
NumFirstExpRun=23925
NumLastExpRun=23929
NevRate=50
nevbegin=47501
nevend=50000
fi

#######################################################################################################
if [ $i -ge 86 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000006.dat"
fi

if [ $i == 86 ]; then
NumFirstExpRun=24618
#NumLastExpRun=24712   #352 runs        94
NumLastExpRun=24622
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 87 ]; then
NumFirstExpRun=24623
NumLastExpRun=24627
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 88 ]; then
NumFirstExpRun=24628
NumLastExpRun=24632
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 89 ]; then
NumFirstExpRun=24633
NumLastExpRun=24637
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 90 ]; then
NumFirstExpRun=24638
NumLastExpRun=24642
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 91 ]; then
NumFirstExpRun=24643
NumLastExpRun=24647
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 92 ]; then
NumFirstExpRun=24648
NumLastExpRun=24652
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 93 ]; then
NumFirstExpRun=24653
NumLastExpRun=24657
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 94 ]; then
NumFirstExpRun=24658
NumLastExpRun=24662
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 95 ]; then
NumFirstExpRun=24663
NumLastExpRun=24667
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 96 ]; then
NumFirstExpRun=24668
NumLastExpRun=24672
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 97 ]; then
NumFirstExpRun=24673
NumLastExpRun=24677
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 98 ]; then
NumFirstExpRun=24678
NumLastExpRun=24682
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 99 ]; then
NumFirstExpRun=24683
NumLastExpRun=24687
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 100 ]; then
NumFirstExpRun=24688
NumLastExpRun=24692
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 101 ]; then
NumFirstExpRun=24693
NumLastExpRun=24697
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 102 ]; then
NumFirstExpRun=24698
NumLastExpRun=24702
NevRate=50
nevbegin=40001
nevend=43000
fi

if [ $i == 103 ]; then
NumFirstExpRun=24703
NumLastExpRun=24707
NevRate=50
nevbegin=43001
nevend=46000
fi

if [ $i == 104 ]; then
NumFirstExpRun=24708
NumLastExpRun=24712
NevRate=50
nevbegin=46001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 105 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000007.dat"
fi

if [ $i == 105 ]; then
##NumFirstExpRun=24790
##NumLastExpRun=24916    #424 runs      126
NumFirstExpRun=24808
#NumLastExpRun=24904    #424 runs      126 -> 96
NumLastExpRun=24812
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 106 ]; then
NumFirstExpRun=24813
NumLastExpRun=24817
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 107 ]; then
NumFirstExpRun=24818
NumLastExpRun=24822
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 108 ]; then
NumFirstExpRun=24823
NumLastExpRun=24827
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 109 ]; then
NumFirstExpRun=24828
NumLastExpRun=24832
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 110 ]; then
NumFirstExpRun=24833
NumLastExpRun=24837
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 111 ]; then
NumFirstExpRun=24838
NumLastExpRun=24842
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 112 ]; then
NumFirstExpRun=24843
NumLastExpRun=24847
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 113 ]; then
NumFirstExpRun=24848
NumLastExpRun=24852
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 114 ]; then
NumFirstExpRun=24853
NumLastExpRun=24855
NevRate=50
nevbegin=22501
nevend=24500
fi

if [ $i == 115 ]; then
NumFirstExpRun=24858
NumLastExpRun=24862
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 116 ]; then
NumFirstExpRun=24863
NumLastExpRun=24867
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 117 ]; then
NumFirstExpRun=24868
NumLastExpRun=24872
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 118 ]; then
NumFirstExpRun=24873
NumLastExpRun=24877
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 119 ]; then
NumFirstExpRun=24878
NumLastExpRun=24882
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 120 ]; then
NumFirstExpRun=24883
NumLastExpRun=24887
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 121 ]; then
NumFirstExpRun=24888
NumLastExpRun=24892
NevRate=50
nevbegin=40001
nevend=42500
fi

if [ $i == 122 ]; then
NumFirstExpRun=24893
NumLastExpRun=24897
NevRate=50
nevbegin=42501
nevend=45000
fi

if [ $i == 123 ]; then
NumFirstExpRun=24898
NumLastExpRun=24900
NevRate=50
nevbegin=45001
nevend=47500
fi

if [ $i == 124 ]; then
NumFirstExpRun=24901
NumLastExpRun=24905
NevRate=50
nevbegin=47501
nevend=50000
fi

#######################################################################################################
if [ $i -ge 125 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000008.dat"
fi

if [ $i == 125 ]; then
##NumFirstExpRun=25034
NumFirstExpRun=25042
#NumLastExpRun=25139   #               105 -> 97
NumLastExpRun=25046
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 126 ]; then
NumFirstExpRun=25047
NumLastExpRun=25051
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 127 ]; then
NumFirstExpRun=25052
NumLastExpRun=25056
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 128 ]; then
NumFirstExpRun=25057
NumLastExpRun=25061
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 129 ]; then
NumFirstExpRun=25062
NumLastExpRun=25066
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 130 ]; then
NumFirstExpRun=25067
NumLastExpRun=25071
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 131 ]; then
NumFirstExpRun=25072
NumLastExpRun=25076
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 132 ]; then
NumFirstExpRun=25077
NumLastExpRun=25081
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 133 ]; then
NumFirstExpRun=25082
NumLastExpRun=25086
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 134 ]; then
NumFirstExpRun=25087
NumLastExpRun=25091
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 135 ]; then
NumFirstExpRun=25092
NumLastExpRun=25096
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 136 ]; then
NumFirstExpRun=25097
NumLastExpRun=25099
NevRate=50
nevbegin=27501
nevend=29500
fi

if [ $i == 137 ]; then
NumFirstExpRun=25102
NumLastExpRun=25106
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 138 ]; then
NumFirstExpRun=25107
NumLastExpRun=25111
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 139 ]; then
NumFirstExpRun=25112
NumLastExpRun=25116
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 140 ]; then
NumFirstExpRun=25117
NumLastExpRun=25121
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 141 ]; then
NumFirstExpRun=25122
NumLastExpRun=25126
NevRate=50
nevbegin=40001
nevend=42500
fi

if [ $i == 142 ]; then
NumFirstExpRun=25127
NumLastExpRun=25131
NevRate=50
nevbegin=42501
nevend=45000
fi

if [ $i == 143 ]; then
NumFirstExpRun=25132
NumLastExpRun=25134
NevRate=50
nevbegin=45001
nevend=47500
fi

if [ $i == 144 ]; then
NumFirstExpRun=25135
NumLastExpRun=25139
NevRate=50
nevbegin=47501
nevend=50000
fi

#######################################################################################################
if [ $i -ge 145 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000009.dat"
fi

if [ $i == 145 ]; then
##NumFirstExpRun=25140
NumFirstExpRun=25150
#NumLastExpRun=25244   #527 runs       104 -> 94
NumLastExpRun=25154
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 146 ]; then
NumFirstExpRun=25155
NumLastExpRun=25159
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 147 ]; then
NumFirstExpRun=25160
NumLastExpRun=25164
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 148 ]; then
NumFirstExpRun=25165
NumLastExpRun=25169
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 149 ]; then
NumFirstExpRun=25170
NumLastExpRun=25174
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 150 ]; then
NumFirstExpRun=25175
NumLastExpRun=25179
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 151 ]; then
NumFirstExpRun=25180
NumLastExpRun=25184
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 152 ]; then
NumFirstExpRun=25185
NumLastExpRun=25189
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 153 ]; then
NumFirstExpRun=25190
NumLastExpRun=25194
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 154 ]; then
NumFirstExpRun=25195
NumLastExpRun=25199
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 155 ]; then
NumFirstExpRun=25200
NumLastExpRun=25204
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 156 ]; then
NumFirstExpRun=25205
NumLastExpRun=25209
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 157 ]; then
NumFirstExpRun=25210
NumLastExpRun=25214
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 158 ]; then
NumFirstExpRun=25215
NumLastExpRun=25219
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 159 ]; then
NumFirstExpRun=25220
NumLastExpRun=25224
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 160 ]; then
NumFirstExpRun=25225
NumLastExpRun=25229
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 161 ]; then
NumFirstExpRun=25230
NumLastExpRun=25234
NevRate=50
nevbegin=40001
nevend=42500
fi

if [ $i == 162 ]; then
NumFirstExpRun=25235
NumLastExpRun=25239
NevRate=50
nevbegin=42501
nevend=45000
fi

if [ $i == 163 ]; then
NumFirstExpRun=25240
NumLastExpRun=25244
NevRate=50
nevbegin=45001
nevend=50000
fi

#######################################################################################################
if [ $i -ge 164 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson0000010.dat"
fi

if [ $i == 164 ]; then
##NumFirstExpRun=25328
NumFirstExpRun=25350
##NumLastExpRun=25447   #583 runs       119 -> 97
NumLastExpRun=25354
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 165 ]; then
NumFirstExpRun=25355
NumLastExpRun=25359
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 166 ]; then
NumFirstExpRun=25360
NumLastExpRun=25364
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 167 ]; then
NumFirstExpRun=25365
NumLastExpRun=25369
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 168 ]; then
NumFirstExpRun=25370
NumLastExpRun=25374
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 169 ]; then
NumFirstExpRun=25375
NumLastExpRun=25379
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 170 ]; then
NumFirstExpRun=25380
NumLastExpRun=25384
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 171 ]; then
NumFirstExpRun=25385
NumLastExpRun=25389
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 172 ]; then
NumFirstExpRun=25390
NumLastExpRun=25394
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 173 ]; then
NumFirstExpRun=25395
NumLastExpRun=25399
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 174 ]; then
NumFirstExpRun=25400
NumLastExpRun=25404
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 175 ]; then
NumFirstExpRun=25405
NumLastExpRun=25409
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 176 ]; then
NumFirstExpRun=25410
NumLastExpRun=25414
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 177 ]; then
NumFirstExpRun=25415
NumLastExpRun=25419
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 178 ]; then
NumFirstExpRun=25420
NumLastExpRun=25424
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 179 ]; then
NumFirstExpRun=25425
NumLastExpRun=25429
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 180 ]; then
NumFirstExpRun=25430
NumLastExpRun=25434
NevRate=50
nevbegin=40001
nevend=42500
fi

if [ $i == 181 ]; then
NumFirstExpRun=25435
NumLastExpRun=25439
NevRate=50
nevbegin=42501
nevend=45000
fi

if [ $i == 182 ]; then
NumFirstExpRun=25440
NumLastExpRun=25444
NevRate=50
nevbegin=45001
nevend=47500
fi

if [ $i == 183 ]; then
NumFirstExpRun=25445
NumLastExpRun=25449
NevRate=50
nevbegin=47501
nevend=50000
fi

#######################################################################################################
if [ $i -ge 184 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson0000011.dat"
fi

if [ $i == 184 ]; then
#NumFirstExpRun=25513
##NumLastExpRun=25687   #660 runs       174
NumFirstExpRun=25565
##NumLastExpRun=25660   #660 runs       174 -> 95
NumLastExpRun=25569
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 185 ]; then
NumFirstExpRun=25570
NumLastExpRun=25574
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 186 ]; then
NumFirstExpRun=25575
NumLastExpRun=25579
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 187 ]; then
NumFirstExpRun=25580
NumLastExpRun=25584
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 188 ]; then
NumFirstExpRun=25585
NumLastExpRun=25589
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 189 ]; then
NumFirstExpRun=25590
NumLastExpRun=25594
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 190 ]; then
NumFirstExpRun=25595
NumLastExpRun=25599
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 191 ]; then
NumFirstExpRun=25600
NumLastExpRun=25604
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 192 ]; then
NumFirstExpRun=25605
NumLastExpRun=25609
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 193 ]; then
NumFirstExpRun=25610
NumLastExpRun=25614
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 194 ]; then
NumFirstExpRun=25615
NumLastExpRun=25619
NevRate=50
nevbegin=25001
nevend=27500
fi

if [ $i == 195 ]; then
NumFirstExpRun=25620
NumLastExpRun=25624
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 196 ]; then
NumFirstExpRun=25625
NumLastExpRun=25629
NevRate=50
nevbegin=30001
nevend=32500
fi

if [ $i == 197 ]; then
NumFirstExpRun=25630
NumLastExpRun=25634
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 198 ]; then
NumFirstExpRun=25635
NumLastExpRun=25639
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 199 ]; then
NumFirstExpRun=25640
NumLastExpRun=25644
NevRate=50
nevbegin=37501
nevend=40000
fi

if [ $i == 200 ]; then
NumFirstExpRun=25645
NumLastExpRun=25649
NevRate=50
nevbegin=40001
nevend=43000
fi

if [ $i == 201 ]; then
NumFirstExpRun=25650
NumLastExpRun=25654
NevRate=50
nevbegin=43001
nevend=46500
fi

if [ $i == 202 ]; then
NumFirstExpRun=25655
NumLastExpRun=25660
NevRate=50
nevbegin=46501
nevend=50000
fi

#######################################################################################################
if [ $i -ge 203 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson0000012.dat"
fi

if [ $i == 203 ]; then
NumFirstExpRun=26058
##NumLastExpRun=26151   #693 runs        93
NumLastExpRun=26062
NevRate=50
nevbegin=0
nevend=2500
fi

if [ $i == 204 ]; then
NumFirstExpRun=26063
NumLastExpRun=26067
NevRate=50
nevbegin=2501
nevend=5000
fi

if [ $i == 205 ]; then
NumFirstExpRun=26068
NumLastExpRun=26072
NevRate=50
nevbegin=5001
nevend=7500
fi

if [ $i == 206 ]; then
NumFirstExpRun=26073
NumLastExpRun=26077
NevRate=50
nevbegin=7501
nevend=10000
fi

if [ $i == 207 ]; then
NumFirstExpRun=26078
NumLastExpRun=26082
NevRate=50
nevbegin=10001
nevend=12500
fi

if [ $i == 208 ]; then
NumFirstExpRun=26083
NumLastExpRun=26087
NevRate=50
nevbegin=12501
nevend=15000
fi

if [ $i == 209 ]; then
NumFirstExpRun=26088
NumLastExpRun=26092
NevRate=50
nevbegin=15001
nevend=17500
fi

if [ $i == 210 ]; then
NumFirstExpRun=26093
NumLastExpRun=26097
NevRate=50
nevbegin=17501
nevend=20000
fi

if [ $i == 211 ]; then
NumFirstExpRun=26098
NumLastExpRun=26102
NevRate=50
nevbegin=20001
nevend=22500
fi

if [ $i == 212 ]; then
NumFirstExpRun=26103
NumLastExpRun=26107
NevRate=50
nevbegin=22501
nevend=25000
fi

if [ $i == 213 ]; then
NumFirstExpRun=26108
NumLastExpRun=26110
NevRate=50
nevbegin=25001
nevend=27000
fi

if [ $i == 214 ]; then
NumFirstExpRun=26113
NumLastExpRun=26117
NevRate=50
nevbegin=27501
nevend=30000
fi

if [ $i == 215 ]; then
NumFirstExpRun=26118
NumLastExpRun=26120
NevRate=50
nevbegin=30001
nevend=32000
fi

if [ $i == 216 ]; then
NumFirstExpRun=26123
NumLastExpRun=26127
NevRate=50
nevbegin=32501
nevend=35000
fi

if [ $i == 217 ]; then
NumFirstExpRun=26128
NumLastExpRun=26132
NevRate=50
nevbegin=35001
nevend=37500
fi

if [ $i == 218 ]; then
NumFirstExpRun=26133
NumLastExpRun=26137
NevRate=50
nevbegin=37501
nevend=41000
fi

if [ $i == 219 ]; then
NumFirstExpRun=26138
NumLastExpRun=26142
NevRate=50
nevbegin=41001
nevend=44500
fi

if [ $i == 220 ]; then
NumFirstExpRun=26143
NumLastExpRun=26147
NevRate=50
nevbegin=44501
nevend=47000
fi

if [ $i == 221 ]; then
NumFirstExpRun=26148
NumLastExpRun=26151
NevRate=50
nevbegin=47001
nevend=50000
fi

#######################################################################################################

$HOME/development/Dmeson/analysis_Ks -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minP -j $maxP -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile $inruns

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

