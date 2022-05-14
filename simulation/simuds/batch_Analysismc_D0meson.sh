#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimD0uds
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
##$ -soft
##$ -hard
##$ -l time=24:00:00
#$ -q remote
##$ -q extralong
##$ -q 6h
##$ -q day
#
# -- Send mail at submission and completion of script --
##$ -m beas
##$ -M ovtin.ivan@gmail.com

##$ -t 1-330
#$ -t 301-330

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#BG continium
simOn=1
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_atc_dedx/psi3770_to_simD0meson_ee_to_qq_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_atc_dedx_minus1sigma/psi3770_to_simD0meson_ee_to_qq_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_atc_dedx_ionization_losses_rndGauss/psi3770_to_simD0meson_ee_to_qq_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A7.2_Z0.2_syst_momres/psi3770_to_simD0meson_ee_to_qq_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.8_Z0.0_syst_momres/psi3770_to_simD0meson_ee_to_qq_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.9_Z0.0_syst_momres/psi3770_to_simD0meson_ee_to_qq_"$i".root"
##outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A5.1_Z0.0_syst_momres/psi3770_to_simD0meson_ee_to_qq_"$i".root"

outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_atc_dedx/psi3770_to_simD0meson_ee_to_qq_"$i".root"

mintracks=3
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
minPt=0
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=50
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=18
kinefit=1

#########################
beginR1=0
endR1=10000
#
beginR2=10001
endR2=20000
#
beginR3=20001
endR3=30000
#
beginR4=30001
endR4=40000
#
beginR5=40001
endR5=50000
#
beginR6=50001
endR6=60000
#
beginR7=60001
endR7=70000
#
beginR8=70001
endR8=80000
#
beginR9=80001
endR9=90000
#
beginR10=90001
endR10=100000

## 1-110 u-quark
########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000001.dat"
#
if [ $i == 1 ]; then
NumFirstExpRun=23272
NumLastExpRun=23282
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 2 ]; then
NumFirstExpRun=23283
NumLastExpRun=23291
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 3 ]; then
NumFirstExpRun=23292
NumLastExpRun=23303
NevRate=90
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 4 ]; then
NumFirstExpRun=23304
NumLastExpRun=23312
NevRate=80
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 5 ]; then
NumFirstExpRun=23313
NumLastExpRun=23323
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 6 ]; then
NumFirstExpRun=23324
NumLastExpRun=23333
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 7 ]; then
NumFirstExpRun=23334
NumLastExpRun=23344
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 8 ]; then
NumFirstExpRun=23345
NumLastExpRun=23359
NevRate=50
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 9 ]; then
NumFirstExpRun=23411
NumLastExpRun=23421
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 10 ]; then
NumFirstExpRun=23422
NumLastExpRun=23431
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

########################################################################################################
if [ $i -ge 11 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/uds/simDmeson000002.dat"
fi

if [ $i == 11 ]; then
NumFirstExpRun=23432
NumLastExpRun=23441
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 12 ]; then
NumFirstExpRun=23442
NumLastExpRun=23451
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 13 ]; then
NumFirstExpRun=23452
NumLastExpRun=23461
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 14 ]; then
NumFirstExpRun=23462
NumLastExpRun=23471
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 15 ]; then
NumFirstExpRun=23472
NumLastExpRun=23481
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 16 ]; then
NumFirstExpRun=23482
NumLastExpRun=23498
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 17 ]; then
NumFirstExpRun=23497
NumLastExpRun=23510
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 18 ]; then
NumFirstExpRun=23511
NumLastExpRun=23520
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 19 ]; then
NumFirstExpRun=23521
NumLastExpRun=23530
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 20 ]; then
NumFirstExpRun=23531
NumLastExpRun=23540
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 21 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000003.dat"
fi

if [ $i == 21 ]; then
NumFirstExpRun=23541
NumLastExpRun=23550
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 22 ]; then
NumFirstExpRun=23551
NumLastExpRun=23560
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 23 ]; then
NumFirstExpRun=23561
NumLastExpRun=23565
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 24 ]; then
NumFirstExpRun=23666
NumLastExpRun=23675
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 25 ]; then
NumFirstExpRun=23676
NumLastExpRun=23685
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 26 ]; then
NumFirstExpRun=23686
NumLastExpRun=23695
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 27 ]; then
NumFirstExpRun=23696
NumLastExpRun=23705
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 28 ]; then
NumFirstExpRun=23706
NumLastExpRun=23715
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 29 ]; then
NumFirstExpRun=23716
NumLastExpRun=23725
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 30 ]; then
NumFirstExpRun=23726
NumLastExpRun=23735
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 31 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000004.dat"
fi

if [ $i == 31 ]; then
NumFirstExpRun=23740
NumLastExpRun=23750
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 32 ]; then
NumFirstExpRun=23751
NumLastExpRun=23759
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 33 ]; then
NumFirstExpRun=23830
NumLastExpRun=23842
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 34 ]; then
NumFirstExpRun=23858
NumLastExpRun=23869
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 35 ]; then
NumFirstExpRun=23870
NumLastExpRun=23879
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 36 ]; then
NumFirstExpRun=23880
NumLastExpRun=23889
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 37 ]; then
NumFirstExpRun=23890
NumLastExpRun=23899
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 38 ]; then
NumFirstExpRun=23900
NumLastExpRun=23909
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 39 ]; then
NumFirstExpRun=23910
NumLastExpRun=23919
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 40 ]; then
NumFirstExpRun=23920
NumLastExpRun=23929
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 41 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000005.dat"
fi

if [ $i == 41 ]; then
NumFirstExpRun=24618
NumLastExpRun=24627
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 42 ]; then
NumFirstExpRun=24628
NumLastExpRun=24637
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 43 ]; then
NumFirstExpRun=24638
NumLastExpRun=24647
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 44 ]; then
NumFirstExpRun=24648
NumLastExpRun=24657
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 45 ]; then
NumFirstExpRun=24658
NumLastExpRun=24667
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 46 ]; then
NumFirstExpRun=24668
NumLastExpRun=24677
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 47 ]; then
NumFirstExpRun=24678
NumLastExpRun=24687
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 48 ]; then
NumFirstExpRun=24688
NumLastExpRun=24697
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 49 ]; then
NumFirstExpRun=24698
NumLastExpRun=24707
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 50 ]; then
NumFirstExpRun=24708
NumLastExpRun=24712
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 51 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000006.dat"
fi

if [ $i == 51 ]; then
NumFirstExpRun=24808
NumLastExpRun=24817
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 52 ]; then
NumFirstExpRun=24818
NumLastExpRun=24827
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 53 ]; then
NumFirstExpRun=24828
NumLastExpRun=24837
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 54 ]; then
NumFirstExpRun=24838
NumLastExpRun=24847
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 55 ]; then
NumFirstExpRun=24848
NumLastExpRun=24859
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 56 ]; then
NumFirstExpRun=24860
NumLastExpRun=24872
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 57 ]; then
NumFirstExpRun=24873
NumLastExpRun=24882
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 58 ]; then
NumFirstExpRun=24883
NumLastExpRun=24892
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 59 ]; then
NumFirstExpRun=24893
NumLastExpRun=24905
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 60 ]; then
NumFirstExpRun=25042
NumLastExpRun=25051
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 61 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000007.dat"
fi

if [ $i == 61 ]; then
NumFirstExpRun=25052
NumLastExpRun=25061
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 62 ]; then
NumFirstExpRun=25062
NumLastExpRun=25071
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 63 ]; then
NumFirstExpRun=25072
NumLastExpRun=25081
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 64 ]; then
NumFirstExpRun=25082
NumLastExpRun=25091
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 65 ]; then
NumFirstExpRun=25092
NumLastExpRun=25103
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 66 ]; then
NumFirstExpRun=25104
NumLastExpRun=25111
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 67 ]; then
NumFirstExpRun=25112
NumLastExpRun=25121
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 68 ]; then
NumFirstExpRun=25122
NumLastExpRun=25131
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 69 ]; then
NumFirstExpRun=25132
NumLastExpRun=25139
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 70 ]; then
NumFirstExpRun=25150
NumLastExpRun=25159
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 71 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000008.dat"
fi

if [ $i == 71 ]; then
NumFirstExpRun=25160
NumLastExpRun=25169
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 72 ]; then
NumFirstExpRun=25170
NumLastExpRun=25179
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 73 ]; then
NumFirstExpRun=25180
NumLastExpRun=25189
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 74 ]; then
NumFirstExpRun=25190
NumLastExpRun=25199
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 75 ]; then
NumFirstExpRun=25200
NumLastExpRun=25209
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 76 ]; then
NumFirstExpRun=25210
NumLastExpRun=25219
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 77 ]; then
NumFirstExpRun=25220
NumLastExpRun=25229
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 78 ]; then
NumFirstExpRun=25230
NumLastExpRun=25239
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 79 ]; then
NumFirstExpRun=25240
NumLastExpRun=25244
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 80 ]; then
NumFirstExpRun=25350
NumLastExpRun=25354
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 81 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000009.dat"
fi

if [ $i == 81 ]; then
NumFirstExpRun=25355
NumLastExpRun=25364
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 82 ]; then
NumFirstExpRun=25365
NumLastExpRun=25374
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 83 ]; then
NumFirstExpRun=25375
NumLastExpRun=25384
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 84 ]; then
NumFirstExpRun=25385
NumLastExpRun=25394
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 85 ]; then
NumFirstExpRun=25395
NumLastExpRun=25404
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 86 ]; then
NumFirstExpRun=25405
NumLastExpRun=25414
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 87 ]; then
NumFirstExpRun=25415
NumLastExpRun=25424
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 88 ]; then
NumFirstExpRun=25425
NumLastExpRun=25434
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 89 ]; then
NumFirstExpRun=25435
NumLastExpRun=25444
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 90 ]; then
NumFirstExpRun=25445
NumLastExpRun=25449
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 91 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000010.dat"
fi

if [ $i == 91 ]; then
NumFirstExpRun=25565
NumLastExpRun=25574
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 92 ]; then
NumFirstExpRun=25575
NumLastExpRun=25584
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 93 ]; then
NumFirstExpRun=25585
NumLastExpRun=25594
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 94 ]; then
NumFirstExpRun=25595
NumLastExpRun=25604
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 95 ]; then
NumFirstExpRun=25605
NumLastExpRun=25614
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 96 ]; then
NumFirstExpRun=25615
NumLastExpRun=25624
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 97 ]; then
NumFirstExpRun=25625
NumLastExpRun=25634
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 98 ]; then
NumFirstExpRun=25635
NumLastExpRun=25644
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 99 ]; then
NumFirstExpRun=25645
NumLastExpRun=25654
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 100 ]; then
NumFirstExpRun=25655
NumLastExpRun=25660
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 101 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000011.dat"
fi

if [ $i == 101 ]; then
NumFirstExpRun=26058
NumLastExpRun=26067
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 102 ]; then
NumFirstExpRun=26068
NumLastExpRun=26077
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 103 ]; then
NumFirstExpRun=26078
NumLastExpRun=26087
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 104 ]; then
NumFirstExpRun=26088
NumLastExpRun=26097
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 105 ]; then
NumFirstExpRun=26098
NumLastExpRun=26107
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 106 ]; then
NumFirstExpRun=26108
NumLastExpRun=26117
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 107 ]; then
NumFirstExpRun=26118
NumLastExpRun=26127
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 108 ]; then
NumFirstExpRun=26128
NumLastExpRun=26137
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 109 ]; then
NumFirstExpRun=26138
NumLastExpRun=26147
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 110 ]; then
NumFirstExpRun=26148
NumLastExpRun=26151
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
## 111-220 d-quark
########################################################################################################
if [ $i -ge 111 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000012.dat"
fi
#
if [ $i == 111 ]; then
NumFirstExpRun=23272
NumLastExpRun=23282
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 112 ]; then
NumFirstExpRun=23283
NumLastExpRun=23291
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 113 ]; then
NumFirstExpRun=23292
NumLastExpRun=23303
NevRate=90
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 114 ]; then
NumFirstExpRun=23304
NumLastExpRun=23312
NevRate=80
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 115 ]; then
NumFirstExpRun=23313
NumLastExpRun=23323
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 116 ]; then
NumFirstExpRun=23324
NumLastExpRun=23333
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 117 ]; then
NumFirstExpRun=23334
NumLastExpRun=23344
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 118 ]; then
NumFirstExpRun=23345
NumLastExpRun=23359
NevRate=50
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 119 ]; then
NumFirstExpRun=23411
NumLastExpRun=23421
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 120 ]; then
NumFirstExpRun=23422
NumLastExpRun=23431
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

########################################################################################################
if [ $i -ge 121 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000013.dat"
fi

if [ $i == 121 ]; then
NumFirstExpRun=23432
NumLastExpRun=23441
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 122 ]; then
NumFirstExpRun=23442
NumLastExpRun=23451
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 123 ]; then
NumFirstExpRun=23452
NumLastExpRun=23461
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 124 ]; then
NumFirstExpRun=23462
NumLastExpRun=23471
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 125 ]; then
NumFirstExpRun=23472
NumLastExpRun=23481
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 126 ]; then
NumFirstExpRun=23482
NumLastExpRun=23498
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 127 ]; then
NumFirstExpRun=23497
NumLastExpRun=23510
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 128 ]; then
NumFirstExpRun=23511
NumLastExpRun=23520
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 129 ]; then
NumFirstExpRun=23521
NumLastExpRun=23530
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 130 ]; then
NumFirstExpRun=23531
NumLastExpRun=23540
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 131 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000014.dat"
fi

if [ $i == 131 ]; then
NumFirstExpRun=23541
NumLastExpRun=23550
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 132 ]; then
NumFirstExpRun=23551
NumLastExpRun=23560
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 133 ]; then
NumFirstExpRun=23561
NumLastExpRun=23565
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 134 ]; then
NumFirstExpRun=23666
NumLastExpRun=23675
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 135 ]; then
NumFirstExpRun=23676
NumLastExpRun=23685
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 136 ]; then
NumFirstExpRun=23686
NumLastExpRun=23695
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 137 ]; then
NumFirstExpRun=23696
NumLastExpRun=23705
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 138 ]; then
NumFirstExpRun=23706
NumLastExpRun=23715
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 139 ]; then
NumFirstExpRun=23716
NumLastExpRun=23725
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 140 ]; then
NumFirstExpRun=23726
NumLastExpRun=23735
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 141 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000015.dat"
fi

if [ $i == 141 ]; then
NumFirstExpRun=23740
NumLastExpRun=23750
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 142 ]; then
NumFirstExpRun=23751
NumLastExpRun=23759
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 143 ]; then
NumFirstExpRun=23830
NumLastExpRun=23842
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 144 ]; then
NumFirstExpRun=23858
NumLastExpRun=23869
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 145 ]; then
NumFirstExpRun=23870
NumLastExpRun=23879
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 146 ]; then
NumFirstExpRun=23880
NumLastExpRun=23889
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 147 ]; then
NumFirstExpRun=23890
NumLastExpRun=23899
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 148 ]; then
NumFirstExpRun=23900
NumLastExpRun=23909
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 149 ]; then
NumFirstExpRun=23910
NumLastExpRun=23919
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 150 ]; then
NumFirstExpRun=23920
NumLastExpRun=23929
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 151 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000016.dat"
fi

if [ $i == 151 ]; then
NumFirstExpRun=24618
NumLastExpRun=24627
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 152 ]; then
NumFirstExpRun=24628
NumLastExpRun=24637
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 153 ]; then
NumFirstExpRun=24638
NumLastExpRun=24647
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 154 ]; then
NumFirstExpRun=24648
NumLastExpRun=24657
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 155 ]; then
NumFirstExpRun=24658
NumLastExpRun=24667
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 156 ]; then
NumFirstExpRun=24668
NumLastExpRun=24677
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 157 ]; then
NumFirstExpRun=24678
NumLastExpRun=24687
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 158 ]; then
NumFirstExpRun=24688
NumLastExpRun=24697
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 159 ]; then
NumFirstExpRun=24698
NumLastExpRun=24707
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 160 ]; then
NumFirstExpRun=24708
NumLastExpRun=24712
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 161 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000017.dat"
fi

if [ $i == 161 ]; then
NumFirstExpRun=24808
NumLastExpRun=24817
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 162 ]; then
NumFirstExpRun=24818
NumLastExpRun=24827
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 163 ]; then
NumFirstExpRun=24828
NumLastExpRun=24837
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 164 ]; then
NumFirstExpRun=24838
NumLastExpRun=24847
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 165 ]; then
NumFirstExpRun=24848
NumLastExpRun=24859
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 166 ]; then
NumFirstExpRun=24860
NumLastExpRun=24872
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 167 ]; then
NumFirstExpRun=24873
NumLastExpRun=24882
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 168 ]; then
NumFirstExpRun=24883
NumLastExpRun=24892
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 169 ]; then
NumFirstExpRun=24893
NumLastExpRun=24905
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 170 ]; then
NumFirstExpRun=25042
NumLastExpRun=25051
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 171 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000018.dat"
fi

if [ $i == 171 ]; then
NumFirstExpRun=25052
NumLastExpRun=25061
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 172 ]; then
NumFirstExpRun=25062
NumLastExpRun=25071
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 173 ]; then
NumFirstExpRun=25072
NumLastExpRun=25081
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 174 ]; then
NumFirstExpRun=25082
NumLastExpRun=25091
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 175 ]; then
NumFirstExpRun=25092
NumLastExpRun=25103
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 176 ]; then
NumFirstExpRun=25104
NumLastExpRun=25111
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 177 ]; then
NumFirstExpRun=25112
NumLastExpRun=25121
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 178 ]; then
NumFirstExpRun=25122
NumLastExpRun=25131
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 179 ]; then
NumFirstExpRun=25132
NumLastExpRun=25139
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 180 ]; then
NumFirstExpRun=25150
NumLastExpRun=25159
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 181 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000019.dat"
fi

if [ $i == 181 ]; then
NumFirstExpRun=25160
NumLastExpRun=25169
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 182 ]; then
NumFirstExpRun=25170
NumLastExpRun=25179
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 183 ]; then
NumFirstExpRun=25180
NumLastExpRun=25189
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 184 ]; then
NumFirstExpRun=25190
NumLastExpRun=25199
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 185 ]; then
NumFirstExpRun=25200
NumLastExpRun=25209
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 186 ]; then
NumFirstExpRun=25210
NumLastExpRun=25219
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 187 ]; then
NumFirstExpRun=25220
NumLastExpRun=25229
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 188 ]; then
NumFirstExpRun=25230
NumLastExpRun=25239
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 189 ]; then
NumFirstExpRun=25240
NumLastExpRun=25244
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 190 ]; then
NumFirstExpRun=25350
NumLastExpRun=25354
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 191 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000020.dat"
fi

if [ $i == 191 ]; then
NumFirstExpRun=25355
NumLastExpRun=25364
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 192 ]; then
NumFirstExpRun=25365
NumLastExpRun=25374
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 193 ]; then
NumFirstExpRun=25375
NumLastExpRun=25384
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 194 ]; then
NumFirstExpRun=25385
NumLastExpRun=25394
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 195 ]; then
NumFirstExpRun=25395
NumLastExpRun=25404
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 196 ]; then
NumFirstExpRun=25405
NumLastExpRun=25414
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 197 ]; then
NumFirstExpRun=25415
NumLastExpRun=25424
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 198 ]; then
NumFirstExpRun=25425
NumLastExpRun=25434
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 199 ]; then
NumFirstExpRun=25435
NumLastExpRun=25444
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 200 ]; then
NumFirstExpRun=25445
NumLastExpRun=25449
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 201 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000021.dat"
fi

if [ $i == 201 ]; then
NumFirstExpRun=25565
NumLastExpRun=25574
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 202 ]; then
NumFirstExpRun=25575
NumLastExpRun=25584
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 203 ]; then
NumFirstExpRun=25585
NumLastExpRun=25594
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 204 ]; then
NumFirstExpRun=25595
NumLastExpRun=25604
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 205 ]; then
NumFirstExpRun=25605
NumLastExpRun=25614
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 206 ]; then
NumFirstExpRun=25615
NumLastExpRun=25624
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 207 ]; then
NumFirstExpRun=25625
NumLastExpRun=25634
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 208 ]; then
NumFirstExpRun=25635
NumLastExpRun=25644
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 209 ]; then
NumFirstExpRun=25645
NumLastExpRun=25654
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 210 ]; then
NumFirstExpRun=25655
NumLastExpRun=25660
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 211 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000022.dat"
fi

if [ $i == 211 ]; then
NumFirstExpRun=26058
NumLastExpRun=26067
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 212 ]; then
NumFirstExpRun=26068
NumLastExpRun=26077
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 213 ]; then
NumFirstExpRun=26078
NumLastExpRun=26087
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 214 ]; then
NumFirstExpRun=26088
NumLastExpRun=26097
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 215 ]; then
NumFirstExpRun=26098
NumLastExpRun=26107
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 216 ]; then
NumFirstExpRun=26108
NumLastExpRun=26117
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 217 ]; then
NumFirstExpRun=26118
NumLastExpRun=26127
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 218 ]; then
NumFirstExpRun=26128
NumLastExpRun=26137
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 219 ]; then
NumFirstExpRun=26138
NumLastExpRun=26147
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 220 ]; then
NumFirstExpRun=26148
NumLastExpRun=26151
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
## 221-330 s-quark
########################################################################################################
if [ $i -ge 221 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000023.dat"
fi
#
if [ $i == 221 ]; then
NumFirstExpRun=23272
NumLastExpRun=23282
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 222 ]; then
NumFirstExpRun=23283
NumLastExpRun=23291
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 223 ]; then
NumFirstExpRun=23292
NumLastExpRun=23303
NevRate=90
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 224 ]; then
NumFirstExpRun=23304
NumLastExpRun=23312
NevRate=80
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 225 ]; then
NumFirstExpRun=23313
NumLastExpRun=23323
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 226 ]; then
NumFirstExpRun=23324
NumLastExpRun=23333
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 227 ]; then
NumFirstExpRun=23334
NumLastExpRun=23344
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 228 ]; then
NumFirstExpRun=23345
NumLastExpRun=23359
NevRate=50
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 229 ]; then
NumFirstExpRun=23411
NumLastExpRun=23421
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 230 ]; then
NumFirstExpRun=23422
NumLastExpRun=23431
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

########################################################################################################
if [ $i -ge 231 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000024.dat"
fi

if [ $i == 231 ]; then
NumFirstExpRun=23432
NumLastExpRun=23441
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 232 ]; then
NumFirstExpRun=23442
NumLastExpRun=23451
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 233 ]; then
NumFirstExpRun=23452
NumLastExpRun=23461
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 234 ]; then
NumFirstExpRun=23462
NumLastExpRun=23471
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 235 ]; then
NumFirstExpRun=23472
NumLastExpRun=23481
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 236 ]; then
NumFirstExpRun=23482
NumLastExpRun=23498
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 237 ]; then
NumFirstExpRun=23497
NumLastExpRun=23510
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 238 ]; then
NumFirstExpRun=23511
NumLastExpRun=23520
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 239 ]; then
NumFirstExpRun=23521
NumLastExpRun=23530
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 240 ]; then
NumFirstExpRun=23531
NumLastExpRun=23540
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 241 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000025.dat"
fi

if [ $i == 241 ]; then
NumFirstExpRun=23541
NumLastExpRun=23550
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 242 ]; then
NumFirstExpRun=23551
NumLastExpRun=23560
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 243 ]; then
NumFirstExpRun=23561
NumLastExpRun=23565
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 244 ]; then
NumFirstExpRun=23666
NumLastExpRun=23675
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 245 ]; then
NumFirstExpRun=23676
NumLastExpRun=23685
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 246 ]; then
NumFirstExpRun=23686
NumLastExpRun=23695
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 247 ]; then
NumFirstExpRun=23696
NumLastExpRun=23705
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 248 ]; then
NumFirstExpRun=23706
NumLastExpRun=23715
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 249 ]; then
NumFirstExpRun=23716
NumLastExpRun=23725
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 250 ]; then
NumFirstExpRun=23726
NumLastExpRun=23735
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 251 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000026.dat"
fi

if [ $i == 251 ]; then
NumFirstExpRun=23740
NumLastExpRun=23750
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 252 ]; then
NumFirstExpRun=23751
NumLastExpRun=23759
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 253 ]; then
NumFirstExpRun=23830
NumLastExpRun=23842
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 254 ]; then
NumFirstExpRun=23858
NumLastExpRun=23869
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 255 ]; then
NumFirstExpRun=23870
NumLastExpRun=23879
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 256 ]; then
NumFirstExpRun=23880
NumLastExpRun=23889
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 257 ]; then
NumFirstExpRun=23890
NumLastExpRun=23899
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 258 ]; then
NumFirstExpRun=23900
NumLastExpRun=23909
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 259 ]; then
NumFirstExpRun=23910
NumLastExpRun=23919
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 260 ]; then
NumFirstExpRun=23920
NumLastExpRun=23929
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 261 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000027.dat"
fi

if [ $i == 261 ]; then
NumFirstExpRun=24618
NumLastExpRun=24627
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 262 ]; then
NumFirstExpRun=24628
NumLastExpRun=24637
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 263 ]; then
NumFirstExpRun=24638
NumLastExpRun=24647
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 264 ]; then
NumFirstExpRun=24648
NumLastExpRun=24657
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 265 ]; then
NumFirstExpRun=24658
NumLastExpRun=24667
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 266 ]; then
NumFirstExpRun=24668
NumLastExpRun=24677
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 267 ]; then
NumFirstExpRun=24678
NumLastExpRun=24687
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 268 ]; then
NumFirstExpRun=24688
NumLastExpRun=24697
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 269 ]; then
NumFirstExpRun=24698
NumLastExpRun=24707
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 270 ]; then
NumFirstExpRun=24708
NumLastExpRun=24712
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 271 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000028.dat"
fi

if [ $i == 271 ]; then
NumFirstExpRun=24808
NumLastExpRun=24817
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 272 ]; then
NumFirstExpRun=24818
NumLastExpRun=24827
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 273 ]; then
NumFirstExpRun=24828
NumLastExpRun=24837
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 274 ]; then
NumFirstExpRun=24838
NumLastExpRun=24847
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 275 ]; then
NumFirstExpRun=24848
NumLastExpRun=24859
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 276 ]; then
NumFirstExpRun=24860
NumLastExpRun=24872
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 277 ]; then
NumFirstExpRun=24873
NumLastExpRun=24882
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 278 ]; then
NumFirstExpRun=24883
NumLastExpRun=24892
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 279 ]; then
NumFirstExpRun=24893
NumLastExpRun=24905
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 280 ]; then
NumFirstExpRun=25042
NumLastExpRun=25051
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 281 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000029.dat"
fi

if [ $i == 281 ]; then
NumFirstExpRun=25052
NumLastExpRun=25061
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 282 ]; then
NumFirstExpRun=25062
NumLastExpRun=25071
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 283 ]; then
NumFirstExpRun=25072
NumLastExpRun=25081
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 284 ]; then
NumFirstExpRun=25082
NumLastExpRun=25091
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 285 ]; then
NumFirstExpRun=25092
NumLastExpRun=25103
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 286 ]; then
NumFirstExpRun=25104
NumLastExpRun=25111
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 287 ]; then
NumFirstExpRun=25112
NumLastExpRun=25121
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 288 ]; then
NumFirstExpRun=25122
NumLastExpRun=25131
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 289 ]; then
NumFirstExpRun=25132
NumLastExpRun=25139
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 290 ]; then
NumFirstExpRun=25150
NumLastExpRun=25159
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 291 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000030.dat"
fi

if [ $i == 291 ]; then
NumFirstExpRun=25160
NumLastExpRun=25169
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 292 ]; then
NumFirstExpRun=25170
NumLastExpRun=25179
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 293 ]; then
NumFirstExpRun=25180
NumLastExpRun=25189
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 294 ]; then
NumFirstExpRun=25190
NumLastExpRun=25199
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 295 ]; then
NumFirstExpRun=25200
NumLastExpRun=25209
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 296 ]; then
NumFirstExpRun=25210
NumLastExpRun=25219
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 297 ]; then
NumFirstExpRun=25220
NumLastExpRun=25229
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 298 ]; then
NumFirstExpRun=25230
NumLastExpRun=25239
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 299 ]; then
NumFirstExpRun=25240
NumLastExpRun=25244
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 300 ]; then
NumFirstExpRun=25350
NumLastExpRun=25354
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 301 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000031.dat"
fi

if [ $i == 301 ]; then
NumFirstExpRun=25355
NumLastExpRun=25364
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 302 ]; then
NumFirstExpRun=25365
NumLastExpRun=25374
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 303 ]; then
NumFirstExpRun=25375
NumLastExpRun=25384
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 304 ]; then
NumFirstExpRun=25385
NumLastExpRun=25394
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 305 ]; then
NumFirstExpRun=25395
NumLastExpRun=25404
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 306 ]; then
NumFirstExpRun=25405
NumLastExpRun=25414
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 307 ]; then
NumFirstExpRun=25415
NumLastExpRun=25424
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 308 ]; then
NumFirstExpRun=25425
NumLastExpRun=25434
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 309 ]; then
NumFirstExpRun=25435
NumLastExpRun=25444
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 310 ]; then
NumFirstExpRun=25445
NumLastExpRun=25449
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 311 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000032.dat"
fi

if [ $i == 311 ]; then
NumFirstExpRun=25565
NumLastExpRun=25574
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 312 ]; then
NumFirstExpRun=25575
NumLastExpRun=25584
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 313 ]; then
NumFirstExpRun=25585
NumLastExpRun=25594
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 314 ]; then
NumFirstExpRun=25595
NumLastExpRun=25604
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 315 ]; then
NumFirstExpRun=25605
NumLastExpRun=25614
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 316 ]; then
NumFirstExpRun=25615
NumLastExpRun=25624
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 317 ]; then
NumFirstExpRun=25625
NumLastExpRun=25634
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 318 ]; then
NumFirstExpRun=25635
NumLastExpRun=25644
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 319 ]; then
NumFirstExpRun=25645
NumLastExpRun=25654
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 320 ]; then
NumFirstExpRun=25655
NumLastExpRun=25660
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 321 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000033.dat"
fi

if [ $i == 321 ]; then
NumFirstExpRun=26058
NumLastExpRun=26067
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 322 ]; then
NumFirstExpRun=26068
NumLastExpRun=26077
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 323 ]; then
NumFirstExpRun=26078
NumLastExpRun=26087
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 324 ]; then
NumFirstExpRun=26088
NumLastExpRun=26097
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 325 ]; then
NumFirstExpRun=26098
NumLastExpRun=26107
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 326 ]; then
NumFirstExpRun=26108
NumLastExpRun=26117
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 327 ]; then
NumFirstExpRun=26118
NumLastExpRun=26127
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 328 ]; then
NumFirstExpRun=26128
NumLastExpRun=26137
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 329 ]; then
NumFirstExpRun=26138
NumLastExpRun=26147
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 330 ]; then
NumFirstExpRun=26148
NumLastExpRun=26151
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################


$HOME/development/Dmeson/analysis_D0meson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.0 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_D0meson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 7.2 -Z 0.2 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_D0meson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.8 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_D0meson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 6.9 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend
##$HOME/development/Dmeson/analysis_D0meson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 5.1 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

