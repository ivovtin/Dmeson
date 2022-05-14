#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimD0BG
# -------------------------------------------
# --     What to redirect to where         --
# -- working directory --
#$ -cwd
#$ -o /store/users/ovtin/$JOB_NAME.o$JOB_ID
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

#$ -t 1-120

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#BG ee_to_DD
simOn=1
outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD2004/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0/psi3770_to_simD0mesonBkg_eetoDD_"$i".root"

mintracks=3
maxtracks=15
minbeamtracks=0
minIPtracks=0
maxIPtracks=15
minPt=0
maxPt=2000
minClusterEnergy=0
minTotalEnergy=0
minClusters=0
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=18
kinefit=1

#########################
beginR1=0
endR1=6000
#
beginR2=6001
endR2=12000
#
beginR3=12001
endR3=18000
#
beginR4=18001
endR4=24000
#
beginR5=24001
endR5=30000
#
beginR6=30001
endR6=36000
#
beginR7=36001
endR7=42000
#
beginR8=42001
endR8=48000
#
beginR9=48001
endR9=54000
#
beginR10=54001
endR10=60000
#
beginR11=60001
endR11=66000
#
beginR12=66001
endR12=72000
#
beginR13=72001
endR13=78000
#
beginR14=78001
endR14=84000
#
beginR15=84001
endR15=90000
#
beginR16=90001
endR16=96000
#
beginR17=96001
endR17=100000


########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000001.dat"
#
if [ $i == 1 ]; then
NumFirstExpRun=4100
NumLastExpRun=4102
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 2 ]; then
NumFirstExpRun=4103
NumLastExpRun=4108
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 3 ]; then
NumFirstExpRun=4109
NumLastExpRun=4112
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 4 ]; then
NumFirstExpRun=4113
NumLastExpRun=4117
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 5 ]; then
NumFirstExpRun=4118
NumLastExpRun=4120
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 6 ]; then
NumFirstExpRun=4126
NumLastExpRun=4128
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 7 ]; then
NumFirstExpRun=4132
NumLastExpRun=4138
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 8 ]; then
NumFirstExpRun=4139
NumLastExpRun=4144
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 9 ]; then
NumFirstExpRun=4145
NumLastExpRun=4151
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 10 ]; then
NumFirstExpRun=4152
NumLastExpRun=4153
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 11 ]; then
NumFirstExpRun=4154
NumLastExpRun=4156
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 12 ]; then
NumFirstExpRun=4157
NumLastExpRun=4159
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 13 ]; then
NumFirstExpRun=4160
NumLastExpRun=4162
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 14 ]; then
NumFirstExpRun=4163
NumLastExpRun=4166
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 15 ]; then
NumFirstExpRun=4167
NumLastExpRun=4169
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 16 ]; then
NumFirstExpRun=4170
NumLastExpRun=4173
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 17 ]; then
NumFirstExpRun=4174
NumLastExpRun=4177
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

########################################################################################################
if [ $i -ge 18 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000002.dat"
fi

if [ $i == 18 ]; then
NumFirstExpRun=4178
NumLastExpRun=4180
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 19 ]; then
NumFirstExpRun=4181
NumLastExpRun=4184
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 20 ]; then
NumFirstExpRun=4185
NumLastExpRun=4188
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 21 ]; then
NumFirstExpRun=4189
NumLastExpRun=4193
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 22 ]; then
NumFirstExpRun=4194
NumLastExpRun=4197
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 23 ]; then
NumFirstExpRun=4198
NumLastExpRun=4201
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 24 ]; then
NumFirstExpRun=4202
NumLastExpRun=4205
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 25 ]; then
NumFirstExpRun=4209
NumLastExpRun=4212
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 26 ]; then
NumFirstExpRun=4213
NumLastExpRun=4215
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 27 ]; then
NumFirstExpRun=4216
NumLastExpRun=4219
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 28 ]; then
NumFirstExpRun=4220
NumLastExpRun=4223
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 29 ]; then
NumFirstExpRun=4231
NumLastExpRun=4235
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 30 ]; then
NumFirstExpRun=4236
NumLastExpRun=4238
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 31 ]; then
NumFirstExpRun=4239
NumLastExpRun=4240
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 32 ]; then
NumFirstExpRun=4252
NumLastExpRun=4254
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 33 ]; then
NumFirstExpRun=4255
NumLastExpRun=4258
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 34 ]; then
NumFirstExpRun=4259
NumLastExpRun=4262
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

#######################################################################################################
if [ $i -ge 35 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000003.dat"
fi

if [ $i == 35 ]; then
NumFirstExpRun=4263
NumLastExpRun=4267
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 36 ]; then
NumFirstExpRun=4269
NumLastExpRun=4272
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 37 ]; then
NumFirstExpRun=4273
NumLastExpRun=4279
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 38 ]; then
NumFirstExpRun=4280
NumLastExpRun=4283
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 39 ]; then
NumFirstExpRun=4284
NumLastExpRun=4287
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 40 ]; then
NumFirstExpRun=4288
NumLastExpRun=4291
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 41 ]; then
NumFirstExpRun=4292
NumLastExpRun=4296
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 42 ]; then
NumFirstExpRun=4297
NumLastExpRun=4300
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 43 ]; then
NumFirstExpRun=4301
NumLastExpRun=4305
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 44 ]; then
NumFirstExpRun=4306
NumLastExpRun=4310
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 45 ]; then
NumFirstExpRun=4311
NumLastExpRun=4315
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 46 ]; then
NumFirstExpRun=4316
NumLastExpRun=4320
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 47 ]; then
NumFirstExpRun=4321
NumLastExpRun=4325
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 48 ]; then
NumFirstExpRun=4331
NumLastExpRun=4334
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 49 ]; then
NumFirstExpRun=4335
NumLastExpRun=4339
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 50 ]; then
NumFirstExpRun=4340
NumLastExpRun=4344
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 51 ]; then
NumFirstExpRun=4345
NumLastExpRun=4349
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

#######################################################################################################
if [ $i -ge 52 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000004.dat"
fi

if [ $i == 52 ]; then
NumFirstExpRun=4350
NumLastExpRun=4353
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 53 ]; then
NumFirstExpRun=4354
NumLastExpRun=4356
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 54 ]; then
NumFirstExpRun=4357
NumLastExpRun=4359
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 55 ]; then
NumFirstExpRun=4379
NumLastExpRun=4383
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 56 ]; then
NumFirstExpRun=4384
NumLastExpRun=4388
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 57 ]; then
NumFirstExpRun=4389
NumLastExpRun=4394
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 58 ]; then
NumFirstExpRun=4395
NumLastExpRun=4399
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 59 ]; then
NumFirstExpRun=4400
NumLastExpRun=4404
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 60 ]; then
NumFirstExpRun=4405
NumLastExpRun=4408
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 61 ]; then
NumFirstExpRun=4409
NumLastExpRun=4413
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 62 ]; then
NumFirstExpRun=4414
NumLastExpRun=4419
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 63 ]; then
NumFirstExpRun=4420
NumLastExpRun=4425
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 64 ]; then
NumFirstExpRun=4426
NumLastExpRun=4430
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 65 ]; then
NumFirstExpRun=4431
NumLastExpRun=4435
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 66 ]; then
NumFirstExpRun=4436
NumLastExpRun=4439
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 67 ]; then
NumFirstExpRun=4440
NumLastExpRun=4444
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 68 ]; then
NumFirstExpRun=4445
NumLastExpRun=4448
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

#######################################################################################################
if [ $i -ge 69 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000005.dat"
fi

if [ $i == 69 ]; then
NumFirstExpRun=4449
NumLastExpRun=4452
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 70 ]; then
NumFirstExpRun=4453
NumLastExpRun=4457
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 71 ]; then
NumFirstExpRun=4458
NumLastExpRun=4462
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 72 ]; then
NumFirstExpRun=4467
NumLastExpRun=4469
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 73 ]; then
NumFirstExpRun=4470
NumLastExpRun=4473
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 74 ]; then
NumFirstExpRun=4474
NumLastExpRun=4477
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 75 ]; then
NumFirstExpRun=4478
NumLastExpRun=4481
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 76 ]; then
NumFirstExpRun=4482
NumLastExpRun=4485
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 77 ]; then
NumFirstExpRun=4486
NumLastExpRun=4488
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 78 ]; then
NumFirstExpRun=4489
NumLastExpRun=4490
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 79 ]; then
NumFirstExpRun=4501
NumLastExpRun=4504
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 80 ]; then
NumFirstExpRun=4505
NumLastExpRun=4508
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 81 ]; then
NumFirstExpRun=4509
NumLastExpRun=4511
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 82 ]; then
NumFirstExpRun=4512
NumLastExpRun=4515
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 83 ]; then
NumFirstExpRun=4516
NumLastExpRun=4520
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 84 ]; then
NumFirstExpRun=4521
NumLastExpRun=4525
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 85 ]; then
NumFirstExpRun=4526
NumLastExpRun=4529
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

#######################################################################################################
if [ $i -ge 86 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000006.dat"
fi

if [ $i == 86 ]; then
NumFirstExpRun=4530
NumLastExpRun=4534
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 87 ]; then
NumFirstExpRun=4554
NumLastExpRun=4556
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 88 ]; then
NumFirstExpRun=4557
NumLastExpRun=4558
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 89 ]; then
NumFirstExpRun=4563
NumLastExpRun=4565
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 90 ]; then
NumFirstExpRun=4566
NumLastExpRun=4569
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 91 ]; then
NumFirstExpRun=4570
NumLastExpRun=4573
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 92 ]; then
NumFirstExpRun=4574
NumLastExpRun=4576
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 93 ]; then
NumFirstExpRun=4577
NumLastExpRun=4579
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 94 ]; then
NumFirstExpRun=4580
NumLastExpRun=4583
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 95 ]; then
NumFirstExpRun=4584
NumLastExpRun=4587
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 96 ]; then
NumFirstExpRun=4588
NumLastExpRun=4596
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 97 ]; then
NumFirstExpRun=4597
NumLastExpRun=4600
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 98 ]; then
NumFirstExpRun=4601
NumLastExpRun=4605
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 99 ]; then
NumFirstExpRun=4606
NumLastExpRun=4609
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 100 ]; then
NumFirstExpRun=4610
NumLastExpRun=4614
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 101 ]; then
NumFirstExpRun=4615
NumLastExpRun=4619
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 102 ]; then
NumFirstExpRun=4620
NumLastExpRun=4623
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

#######################################################################################################
if [ $i -ge 103 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000007.dat"
fi

if [ $i == 103 ]; then
NumFirstExpRun=4624
NumLastExpRun=4628
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 104 ]; then
NumFirstExpRun=4629
NumLastExpRun=4632
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 105 ]; then
NumFirstExpRun=4633
NumLastExpRun=4637
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 106 ]; then
NumFirstExpRun=4638
NumLastExpRun=4642
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 107 ]; then
NumFirstExpRun=4644
NumLastExpRun=4647
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 108 ]; then
NumFirstExpRun=4650
NumLastExpRun=4654
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 109 ]; then
NumFirstExpRun=4655
NumLastExpRun=4659
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 110 ]; then
NumFirstExpRun=4660
NumLastExpRun=4664
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 111 ]; then
NumFirstExpRun=4665
NumLastExpRun=4669
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 112 ]; then
NumFirstExpRun=4670
NumLastExpRun=4675
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 113 ]; then
NumFirstExpRun=4676
NumLastExpRun=4679
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 114 ]; then
NumFirstExpRun=4680
NumLastExpRun=4684
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 115 ]; then
NumFirstExpRun=4685
NumLastExpRun=4690
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 116 ]; then
NumFirstExpRun=4691
NumLastExpRun=4693
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 117 ]; then
NumFirstExpRun=4694
NumLastExpRun=4696
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 118 ]; then
NumFirstExpRun=4697
NumLastExpRun=4700
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 119 ]; then
NumFirstExpRun=4701
NumLastExpRun=4704
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

#######################################################################################################
if [ $i -ge 120 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/simDmeson000008.dat"
fi

if [ $i == 120 ]; then
NumFirstExpRun=4705
NumLastExpRun=4707
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

#######################################################################################################

$HOME/development/Dmeson/analysis_D0meson_woATC -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

