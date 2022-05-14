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

#$ -t 1-264

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#BG continium
simOn=1
outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium2004/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0/psi3770_to_simD0meson_ee_to_qq_"$i".root"

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

## 1-88 u-quark
########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000001.dat"
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
NumLastExpRun=4105
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 3 ]; then
NumFirstExpRun=4106
NumLastExpRun=4108
NevRate=90
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 4 ]; then
NumFirstExpRun=4109
NumLastExpRun=4113
NevRate=80
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 5 ]; then
NumFirstExpRun=4114
NumLastExpRun=4118
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
NumLastExpRun=4142
NevRate=50
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 9 ]; then
NumFirstExpRun=4143
NumLastExpRun=4145
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 10 ]; then
NumFirstExpRun=4150
NumLastExpRun=4153
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

########################################################################################################
if [ $i -ge 11 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/uds/simDmeson000002.dat"
fi

if [ $i == 11 ]; then
NumFirstExpRun=4154
NumLastExpRun=4159
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 12 ]; then
NumFirstExpRun=4160
NumLastExpRun=4164
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 13 ]; then
NumFirstExpRun=4165
NumLastExpRun=4169
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 14 ]; then
NumFirstExpRun=4170
NumLastExpRun=4175
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 15 ]; then
NumFirstExpRun=4176
NumLastExpRun=4180
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 16 ]; then
NumFirstExpRun=4181
NumLastExpRun=4185
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 17 ]; then
NumFirstExpRun=4186
NumLastExpRun=4190
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 18 ]; then
NumFirstExpRun=4191
NumLastExpRun=4196
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 19 ]; then
NumFirstExpRun=4197
NumLastExpRun=4200
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 20 ]; then
NumFirstExpRun=4201
NumLastExpRun=4205
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 21 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000003.dat"
fi

if [ $i == 21 ]; then
NumFirstExpRun=4209
NumLastExpRun=4213
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 22 ]; then
NumFirstExpRun=4214
NumLastExpRun=4219
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 23 ]; then
NumFirstExpRun=4220
NumLastExpRun=4223
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 24 ]; then
NumFirstExpRun=4231
NumLastExpRun=4235
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 25 ]; then
NumFirstExpRun=4236
NumLastExpRun=4239
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 26 ]; then
NumFirstExpRun=4240
NumLastExpRun=4245
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 27 ]; then
NumFirstExpRun=4252
NumLastExpRun=4256
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 28 ]; then
NumFirstExpRun=4257
NumLastExpRun=4263
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 29 ]; then
NumFirstExpRun=4264
NumLastExpRun=4269
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 30 ]; then
NumFirstExpRun=4270
NumLastExpRun=4273
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 31 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000004.dat"
fi

if [ $i == 31 ]; then
NumFirstExpRun=4277
NumLastExpRun=4282
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 32 ]; then
NumFirstExpRun=4283
NumLastExpRun=4288
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 33 ]; then
NumFirstExpRun=4289
NumLastExpRun=4294
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 34 ]; then
NumFirstExpRun=4295
NumLastExpRun=4299
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 35 ]; then
NumFirstExpRun=4300
NumLastExpRun=4305
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 36 ]; then
NumFirstExpRun=4306
NumLastExpRun=4312
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 37 ]; then
NumFirstExpRun=4313
NumLastExpRun=4319
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 38 ]; then
NumFirstExpRun=4320
NumLastExpRun=4321
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 39 ]; then
NumFirstExpRun=4331
NumLastExpRun=4336
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 40 ]; then
NumFirstExpRun=4337
NumLastExpRun=4342
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 41 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000005.dat"
fi

if [ $i == 41 ]; then
NumFirstExpRun=4343
NumLastExpRun=4348
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 42 ]; then
NumFirstExpRun=4349
NumLastExpRun=4354
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 43 ]; then
NumFirstExpRun=4355
NumLastExpRun=4359
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 44 ]; then
NumFirstExpRun=4379
NumLastExpRun=4385
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 45 ]; then
NumFirstExpRun=4386
NumLastExpRun=4392
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 46 ]; then
NumFirstExpRun=4393
NumLastExpRun=4398
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 47 ]; then
NumFirstExpRun=4399
NumLastExpRun=4404
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 48 ]; then
NumFirstExpRun=4405
NumLastExpRun=4409
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 49 ]; then
NumFirstExpRun=4413
NumLastExpRun=4419
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 50 ]; then
NumFirstExpRun=4420
NumLastExpRun=4426
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 51 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000006.dat"
fi

if [ $i == 51 ]; then
NumFirstExpRun=4427
NumLastExpRun=4432
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 52 ]; then
NumFirstExpRun=4433
NumLastExpRun=4439
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 53 ]; then
NumFirstExpRun=4440
NumLastExpRun=4445
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 54 ]; then
NumFirstExpRun=4446
NumLastExpRun=4452
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 55 ]; then
NumFirstExpRun=4453
NumLastExpRun=4457
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 56 ]; then
NumFirstExpRun=4458
NumLastExpRun=4462
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 57 ]; then
NumFirstExpRun=4467
NumLastExpRun=4472
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 58 ]; then
NumFirstExpRun=4473
NumLastExpRun=4478
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 59 ]; then
NumFirstExpRun=4479
NumLastExpRun=4484
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 60 ]; then
NumFirstExpRun=4485
NumLastExpRun=4490
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 61 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000007.dat"
fi

if [ $i == 61 ]; then
NumFirstExpRun=4501
NumLastExpRun=4507
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 62 ]; then
NumFirstExpRun=4508
NumLastExpRun=4514
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 63 ]; then
NumFirstExpRun=4515
NumLastExpRun=4520
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 64 ]; then
NumFirstExpRun=4521
NumLastExpRun=4527
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 65 ]; then
NumFirstExpRun=4528
NumLastExpRun=4534
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 66 ]; then
NumFirstExpRun=4554
NumLastExpRun=4557
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 67 ]; then
NumFirstExpRun=4563
NumLastExpRun=4569
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 68 ]; then
NumFirstExpRun=4570
NumLastExpRun=4577
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 69 ]; then
NumFirstExpRun=4578
NumLastExpRun=4582
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 70 ]; then
NumFirstExpRun=4583
NumLastExpRun=4586
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 71 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000008.dat"
fi

if [ $i == 71 ]; then
NumFirstExpRun=4587
NumLastExpRun=4589
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 72 ]; then
NumFirstExpRun=4596
NumLastExpRun=4602
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 73 ]; then
NumFirstExpRun=4603
NumLastExpRun=4609
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 74 ]; then
NumFirstExpRun=4610
NumLastExpRun=4615
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 75 ]; then
NumFirstExpRun=4616
NumLastExpRun=4622
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 76 ]; then
NumFirstExpRun=4623
NumLastExpRun=4628
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 77 ]; then
NumFirstExpRun=4629
NumLastExpRun=4635
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 78 ]; then
NumFirstExpRun=4637
NumLastExpRun=4642
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 79 ]; then
NumFirstExpRun=4644
NumLastExpRun=4647
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 80 ]; then
NumFirstExpRun=4650
NumLastExpRun=4656
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 81 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000009.dat"
fi

if [ $i == 81 ]; then
NumFirstExpRun=4657
NumLastExpRun=4663
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 82 ]; then
NumFirstExpRun=4664
NumLastExpRun=4669
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 83 ]; then
NumFirstExpRun=4670
NumLastExpRun=4676
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 84 ]; then
NumFirstExpRun=4677
NumLastExpRun=4681
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 85 ]; then
NumFirstExpRun=4682
NumLastExpRun=4687
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 86 ]; then
NumFirstExpRun=4690
NumLastExpRun=4696
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 87 ]; then
NumFirstExpRun=4697
NumLastExpRun=4703
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 88 ]; then
NumFirstExpRun=4704
NumLastExpRun=4707
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi


## 89-176 d-quark
########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000012.dat"
#
if [ $i == 89 ]; then
NumFirstExpRun=4100
NumLastExpRun=4102
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 90 ]; then
NumFirstExpRun=4103
NumLastExpRun=4105
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 91 ]; then
NumFirstExpRun=4106
NumLastExpRun=4108
NevRate=90
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 92 ]; then
NumFirstExpRun=4109
NumLastExpRun=4113
NevRate=80
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 93 ]; then
NumFirstExpRun=4114
NumLastExpRun=4118
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 94 ]; then
NumFirstExpRun=4126
NumLastExpRun=4128
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 95 ]; then
NumFirstExpRun=4132
NumLastExpRun=4138
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 96 ]; then
NumFirstExpRun=4139
NumLastExpRun=4142
NevRate=50
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 97 ]; then
NumFirstExpRun=4143
NumLastExpRun=4145
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 98 ]; then
NumFirstExpRun=4150
NumLastExpRun=4153
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

########################################################################################################
if [ $i -ge 99 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/uds/simDmeson000013.dat"
fi

if [ $i == 99 ]; then
NumFirstExpRun=4154
NumLastExpRun=4159
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 100 ]; then
NumFirstExpRun=4160
NumLastExpRun=4164
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 101 ]; then
NumFirstExpRun=4165
NumLastExpRun=4169
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 102 ]; then
NumFirstExpRun=4170
NumLastExpRun=4175
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 103 ]; then
NumFirstExpRun=4176
NumLastExpRun=4180
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 104 ]; then
NumFirstExpRun=4181
NumLastExpRun=4185
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 105 ]; then
NumFirstExpRun=4186
NumLastExpRun=4190
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 106 ]; then
NumFirstExpRun=4191
NumLastExpRun=4196
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 107 ]; then
NumFirstExpRun=4197
NumLastExpRun=4200
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 108 ]; then
NumFirstExpRun=4201
NumLastExpRun=4205
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 109 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000014.dat"
fi

if [ $i == 109 ]; then
NumFirstExpRun=4209
NumLastExpRun=4213
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 110 ]; then
NumFirstExpRun=4214
NumLastExpRun=4219
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 111 ]; then
NumFirstExpRun=4220
NumLastExpRun=4223
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 112 ]; then
NumFirstExpRun=4231
NumLastExpRun=4235
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 113 ]; then
NumFirstExpRun=4236
NumLastExpRun=4239
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 114 ]; then
NumFirstExpRun=4240
NumLastExpRun=4245
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 115 ]; then
NumFirstExpRun=4252
NumLastExpRun=4256
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 116 ]; then
NumFirstExpRun=4257
NumLastExpRun=4263
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 117 ]; then
NumFirstExpRun=4264
NumLastExpRun=4269
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 118 ]; then
NumFirstExpRun=4270
NumLastExpRun=4273
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 119 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000015.dat"
fi

if [ $i == 119 ]; then
NumFirstExpRun=4277
NumLastExpRun=4282
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 120 ]; then
NumFirstExpRun=4283
NumLastExpRun=4288
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 121 ]; then
NumFirstExpRun=4289
NumLastExpRun=4294
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 122 ]; then
NumFirstExpRun=4295
NumLastExpRun=4299
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 123 ]; then
NumFirstExpRun=4300
NumLastExpRun=4305
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 124 ]; then
NumFirstExpRun=4306
NumLastExpRun=4312
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 125 ]; then
NumFirstExpRun=4313
NumLastExpRun=4319
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 126 ]; then
NumFirstExpRun=4320
NumLastExpRun=4321
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 127 ]; then
NumFirstExpRun=4331
NumLastExpRun=4336
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 128 ]; then
NumFirstExpRun=4337
NumLastExpRun=4342
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 129 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000016.dat"
fi

if [ $i == 129 ]; then
NumFirstExpRun=4343
NumLastExpRun=4348
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 130 ]; then
NumFirstExpRun=4349
NumLastExpRun=4354
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 131 ]; then
NumFirstExpRun=4355
NumLastExpRun=4359
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 132 ]; then
NumFirstExpRun=4379
NumLastExpRun=4385
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 133 ]; then
NumFirstExpRun=4386
NumLastExpRun=4392
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 134 ]; then
NumFirstExpRun=4393
NumLastExpRun=4398
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 135 ]; then
NumFirstExpRun=4399
NumLastExpRun=4404
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 136 ]; then
NumFirstExpRun=4405
NumLastExpRun=4409
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 137 ]; then
NumFirstExpRun=4413
NumLastExpRun=4419
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 138 ]; then
NumFirstExpRun=4420
NumLastExpRun=4426
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 139 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000017.dat"
fi

if [ $i == 139 ]; then
NumFirstExpRun=4427
NumLastExpRun=4432
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 140 ]; then
NumFirstExpRun=4433
NumLastExpRun=4439
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 141 ]; then
NumFirstExpRun=4440
NumLastExpRun=4445
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 142 ]; then
NumFirstExpRun=4446
NumLastExpRun=4452
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 143 ]; then
NumFirstExpRun=4453
NumLastExpRun=4457
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 144 ]; then
NumFirstExpRun=4458
NumLastExpRun=4462
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 145 ]; then
NumFirstExpRun=4467
NumLastExpRun=4472
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 146 ]; then
NumFirstExpRun=4473
NumLastExpRun=4478
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 147 ]; then
NumFirstExpRun=4479
NumLastExpRun=4484
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 148 ]; then
NumFirstExpRun=4485
NumLastExpRun=4490
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 149 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000018.dat"
fi

if [ $i == 149 ]; then
NumFirstExpRun=4501
NumLastExpRun=4507
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 150 ]; then
NumFirstExpRun=4508
NumLastExpRun=4514
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 151 ]; then
NumFirstExpRun=4515
NumLastExpRun=4520
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 152 ]; then
NumFirstExpRun=4521
NumLastExpRun=4527
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 153 ]; then
NumFirstExpRun=4528
NumLastExpRun=4534
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 154 ]; then
NumFirstExpRun=4554
NumLastExpRun=4557
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 155 ]; then
NumFirstExpRun=4563
NumLastExpRun=4569
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 156 ]; then
NumFirstExpRun=4570
NumLastExpRun=4577
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 157 ]; then
NumFirstExpRun=4578
NumLastExpRun=4582
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 158 ]; then
NumFirstExpRun=4583
NumLastExpRun=4586
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 159 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000019.dat"
fi

if [ $i == 159 ]; then
NumFirstExpRun=4587
NumLastExpRun=4589
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 160 ]; then
NumFirstExpRun=4596
NumLastExpRun=4602
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 161 ]; then
NumFirstExpRun=4603
NumLastExpRun=4609
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 162 ]; then
NumFirstExpRun=4610
NumLastExpRun=4615
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 163 ]; then
NumFirstExpRun=4616
NumLastExpRun=4622
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 164 ]; then
NumFirstExpRun=4623
NumLastExpRun=4628
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 165 ]; then
NumFirstExpRun=4629
NumLastExpRun=4635
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 166 ]; then
NumFirstExpRun=4637
NumLastExpRun=4642
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 167 ]; then
NumFirstExpRun=4644
NumLastExpRun=4647
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 168 ]; then
NumFirstExpRun=4650
NumLastExpRun=4656
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 169 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000020.dat"
fi

if [ $i == 169 ]; then
NumFirstExpRun=4657
NumLastExpRun=4663
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 170 ]; then
NumFirstExpRun=4664
NumLastExpRun=4669
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 171 ]; then
NumFirstExpRun=4670
NumLastExpRun=4676
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 172 ]; then
NumFirstExpRun=4677
NumLastExpRun=4681
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 173 ]; then
NumFirstExpRun=4682
NumLastExpRun=4687
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 174 ]; then
NumFirstExpRun=4690
NumLastExpRun=4696
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 175 ]; then
NumFirstExpRun=4697
NumLastExpRun=4703
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 176 ]; then
NumFirstExpRun=4704
NumLastExpRun=4707
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi


## 177-264 s-quark
########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000023.dat"
#
if [ $i == 177 ]; then
NumFirstExpRun=4100
NumLastExpRun=4102
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 178 ]; then
NumFirstExpRun=4103
NumLastExpRun=4105
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 179 ]; then
NumFirstExpRun=4106
NumLastExpRun=4108
NevRate=90
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 180 ]; then
NumFirstExpRun=4109
NumLastExpRun=4113
NevRate=80
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 181 ]; then
NumFirstExpRun=4114
NumLastExpRun=4118
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 182 ]; then
NumFirstExpRun=4126
NumLastExpRun=4128
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 183 ]; then
NumFirstExpRun=4132
NumLastExpRun=4138
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 184 ]; then
NumFirstExpRun=4139
NumLastExpRun=4142
NevRate=50
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 185 ]; then
NumFirstExpRun=4143
NumLastExpRun=4145
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 186 ]; then
NumFirstExpRun=4150
NumLastExpRun=4153
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

########################################################################################################
if [ $i -ge 187 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/uds/simDmeson000024.dat"
fi

if [ $i == 187 ]; then
NumFirstExpRun=4154
NumLastExpRun=4159
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 188 ]; then
NumFirstExpRun=4160
NumLastExpRun=4164
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 189 ]; then
NumFirstExpRun=4165
NumLastExpRun=4169
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 190 ]; then
NumFirstExpRun=4170
NumLastExpRun=4175
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 191 ]; then
NumFirstExpRun=4176
NumLastExpRun=4180
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 192 ]; then
NumFirstExpRun=4181
NumLastExpRun=4185
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 193 ]; then
NumFirstExpRun=4186
NumLastExpRun=4190
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 194 ]; then
NumFirstExpRun=4191
NumLastExpRun=4196
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 195 ]; then
NumFirstExpRun=4197
NumLastExpRun=4200
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 196 ]; then
NumFirstExpRun=4201
NumLastExpRun=4205
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 197 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000025.dat"
fi

if [ $i == 197 ]; then
NumFirstExpRun=4209
NumLastExpRun=4213
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 198 ]; then
NumFirstExpRun=4214
NumLastExpRun=4219
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 199 ]; then
NumFirstExpRun=4220
NumLastExpRun=4223
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 200 ]; then
NumFirstExpRun=4231
NumLastExpRun=4235
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 201 ]; then
NumFirstExpRun=4236
NumLastExpRun=4239
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 202 ]; then
NumFirstExpRun=4240
NumLastExpRun=4245
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 203 ]; then
NumFirstExpRun=4252
NumLastExpRun=4256
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 204 ]; then
NumFirstExpRun=4257
NumLastExpRun=4263
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 205 ]; then
NumFirstExpRun=4264
NumLastExpRun=4269
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 206 ]; then
NumFirstExpRun=4270
NumLastExpRun=4273
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 207 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000026.dat"
fi

if [ $i == 207 ]; then
NumFirstExpRun=4277
NumLastExpRun=4282
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 208 ]; then
NumFirstExpRun=4283
NumLastExpRun=4288
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 209 ]; then
NumFirstExpRun=4289
NumLastExpRun=4294
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 210 ]; then
NumFirstExpRun=4295
NumLastExpRun=4299
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 211 ]; then
NumFirstExpRun=4300
NumLastExpRun=4305
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 212 ]; then
NumFirstExpRun=4306
NumLastExpRun=4312
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 213 ]; then
NumFirstExpRun=4313
NumLastExpRun=4319
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 214 ]; then
NumFirstExpRun=4320
NumLastExpRun=4321
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 215 ]; then
NumFirstExpRun=4331
NumLastExpRun=4336
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 216 ]; then
NumFirstExpRun=4337
NumLastExpRun=4342
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 217 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000027.dat"
fi

if [ $i == 217 ]; then
NumFirstExpRun=4343
NumLastExpRun=4348
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 218 ]; then
NumFirstExpRun=4349
NumLastExpRun=4354
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 219 ]; then
NumFirstExpRun=4355
NumLastExpRun=4359
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 220 ]; then
NumFirstExpRun=4379
NumLastExpRun=4385
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 221 ]; then
NumFirstExpRun=4386
NumLastExpRun=4392
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 222 ]; then
NumFirstExpRun=4393
NumLastExpRun=4398
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 223 ]; then
NumFirstExpRun=4399
NumLastExpRun=4404
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 224 ]; then
NumFirstExpRun=4405
NumLastExpRun=4409
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 225 ]; then
NumFirstExpRun=4413
NumLastExpRun=4419
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 226 ]; then
NumFirstExpRun=4420
NumLastExpRun=4426
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 227 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000028.dat"
fi

if [ $i == 227 ]; then
NumFirstExpRun=4427
NumLastExpRun=4432
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 228 ]; then
NumFirstExpRun=4433
NumLastExpRun=4439
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 229 ]; then
NumFirstExpRun=4440
NumLastExpRun=4445
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 230 ]; then
NumFirstExpRun=4446
NumLastExpRun=4452
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 231 ]; then
NumFirstExpRun=4453
NumLastExpRun=4457
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 232 ]; then
NumFirstExpRun=4458
NumLastExpRun=4462
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 233 ]; then
NumFirstExpRun=4467
NumLastExpRun=4472
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 234 ]; then
NumFirstExpRun=4473
NumLastExpRun=4478
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 235 ]; then
NumFirstExpRun=4479
NumLastExpRun=4484
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 236 ]; then
NumFirstExpRun=4485
NumLastExpRun=4490
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 237 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000029.dat"
fi

if [ $i == 237 ]; then
NumFirstExpRun=4501
NumLastExpRun=4507
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 238 ]; then
NumFirstExpRun=4508
NumLastExpRun=4514
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 239 ]; then
NumFirstExpRun=4515
NumLastExpRun=4520
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 240 ]; then
NumFirstExpRun=4521
NumLastExpRun=4527
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 241 ]; then
NumFirstExpRun=4528
NumLastExpRun=4534
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 242 ]; then
NumFirstExpRun=4554
NumLastExpRun=4557
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 243 ]; then
NumFirstExpRun=4563
NumLastExpRun=4569
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 244 ]; then
NumFirstExpRun=4570
NumLastExpRun=4577
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 245 ]; then
NumFirstExpRun=4578
NumLastExpRun=4582
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 246 ]; then
NumFirstExpRun=4583
NumLastExpRun=4586
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi


#######################################################################################################
if [ $i -ge 247 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000030.dat"
fi

if [ $i == 247 ]; then
NumFirstExpRun=4587
NumLastExpRun=4589
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 248 ]; then
NumFirstExpRun=4596
NumLastExpRun=4602
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 249 ]; then
NumFirstExpRun=4603
NumLastExpRun=4609
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 250 ]; then
NumFirstExpRun=4610
NumLastExpRun=4615
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 251 ]; then
NumFirstExpRun=4616
NumLastExpRun=4622
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 252 ]; then
NumFirstExpRun=4623
NumLastExpRun=4628
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 253 ]; then
NumFirstExpRun=4629
NumLastExpRun=4635
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 254 ]; then
NumFirstExpRun=4637
NumLastExpRun=4642
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 255 ]; then
NumFirstExpRun=4644
NumLastExpRun=4647
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 256 ]; then
NumFirstExpRun=4650
NumLastExpRun=4656
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 257 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/uds/simDmeson000031.dat"
fi

if [ $i == 257 ]; then
NumFirstExpRun=4657
NumLastExpRun=4663
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 258 ]; then
NumFirstExpRun=4664
NumLastExpRun=4669
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 259 ]; then
NumFirstExpRun=4670
NumLastExpRun=4676
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 260 ]; then
NumFirstExpRun=4677
NumLastExpRun=4681
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 261 ]; then
NumFirstExpRun=4682
NumLastExpRun=4687
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 262 ]; then
NumFirstExpRun=4690
NumLastExpRun=4696
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 263 ]; then
NumFirstExpRun=4697
NumLastExpRun=4703
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 264 ]; then
NumFirstExpRun=4704
NumLastExpRun=4707
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi



#######################################################################################################


$HOME/development/Dmeson/analysis_D0meson_woATC -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

