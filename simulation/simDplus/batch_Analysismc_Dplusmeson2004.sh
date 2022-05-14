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

#$ -t 1-108

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
##outfile="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal2004/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.5_Z0.0/psi3770_to_simDplusmesonSignal_"$i".root"
outfile="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal2004/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.5_Z0.0/psi3770_to_simDplusmesonSignal_"$i".root"

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

#########################
beginR1=0
endR1=5000
#
beginR2=5001
endR2=10000
#
beginR3=10001
endR3=15000
#
beginR4=15001
endR4=20000
#
beginR5=20001
endR5=25000
#
beginR6=25001
endR6=30000
#
beginR7=30001
endR7=35000
#
beginR8=35001
endR8=40000
#
beginR9=40001
endR9=45000
#
beginR10=45001
endR10=50000
#
########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000001.dat"
#
if [ $i == 1 ]; then
NumFirstExpRun=4100
NumLastExpRun=4101
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 2 ]; then
NumFirstExpRun=4102
NumLastExpRun=4103
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 3 ]; then
NumFirstExpRun=4104
NumLastExpRun=4105
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 4 ]; then
NumFirstExpRun=4106
NumLastExpRun=4107
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 5 ]; then
NumFirstExpRun=4108
NumLastExpRun=4109
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 6 ]; then
NumFirstExpRun=4110
NumLastExpRun=4111
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 7 ]; then
NumFirstExpRun=4112
NumLastExpRun=4113
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 8 ]; then
NumFirstExpRun=4114
NumLastExpRun=4116
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 9 ]; then
NumFirstExpRun=4117
NumLastExpRun=4118
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

########################################################################################################
if [ $i -ge 10 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000002.dat"
fi
#
if [ $i == 10 ]; then
NumFirstExpRun=4126
NumLastExpRun=4128
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 11 ]; then
NumFirstExpRun=4132
NumLastExpRun=4134
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 12 ]; then
NumFirstExpRun=4135
NumLastExpRun=4140
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 13 ]; then
NumFirstExpRun=4141
NumLastExpRun=4145
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 14 ]; then
NumFirstExpRun=4150
NumLastExpRun=4155
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 15 ]; then
NumFirstExpRun=4156
NumLastExpRun=4160
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 16 ]; then
NumFirstExpRun=4161
NumLastExpRun=4165
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 17 ]; then
NumFirstExpRun=4166
NumLastExpRun=4170
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

#######################################################################################################
if [ $i -ge 18 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000003.dat"
fi

if [ $i == 18 ]; then
NumFirstExpRun=4171
NumLastExpRun=4175
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 19 ]; then
NumFirstExpRun=4176
NumLastExpRun=4180
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 20 ]; then
NumFirstExpRun=4181
NumLastExpRun=4185
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 21 ]; then
NumFirstExpRun=4186
NumLastExpRun=4190
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 22 ]; then
NumFirstExpRun=4191
NumLastExpRun=4195
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 23 ]; then
NumFirstExpRun=4196
NumLastExpRun=4200
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 24 ]; then
NumFirstExpRun=4201
NumLastExpRun=4205
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

#######################################################################################################
if [ $i -ge 25 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000004.dat"
fi

if [ $i == 25 ]; then
NumFirstExpRun=4209
NumLastExpRun=4210
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 26 ]; then
NumFirstExpRun=4211
NumLastExpRun=4215
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 27 ]; then
NumFirstExpRun=4216
NumLastExpRun=4220
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 28 ]; then
NumFirstExpRun=4221
NumLastExpRun=4223
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 29 ]; then
NumFirstExpRun=4231
NumLastExpRun=4235
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 30 ]; then
NumFirstExpRun=4236
NumLastExpRun=4240
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 31 ]; then
NumFirstExpRun=4252
NumLastExpRun=4256
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 32 ]; then
NumFirstExpRun=4257
NumLastExpRun=4261
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 33 ]; then
NumFirstExpRun=4262
NumLastExpRun=4266
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 34 ]; then
NumFirstExpRun=4267
NumLastExpRun=4272
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 35 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000005.dat"
fi

if [ $i == 35 ]; then
NumFirstExpRun=4273
NumLastExpRun=4280
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 36 ]; then
NumFirstExpRun=4281
NumLastExpRun=4282
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 37 ]; then
NumFirstExpRun=4283
NumLastExpRun=4286
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 38 ]; then
NumFirstExpRun=4287
NumLastExpRun=4290
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 39 ]; then
NumFirstExpRun=4291
NumLastExpRun=4295
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 40 ]; then
NumFirstExpRun=4296
NumLastExpRun=4300
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 41 ]; then
NumFirstExpRun=4301
NumLastExpRun=4305
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 42 ]; then
NumFirstExpRun=4306
NumLastExpRun=4310
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 43 ]; then
NumFirstExpRun=4311
NumLastExpRun=4313
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 44 ]; then
NumFirstExpRun=4314
NumLastExpRun=4320
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 45 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000006.dat"
fi

if [ $i == 45 ]; then
NumFirstExpRun=4321
NumLastExpRun=4334
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 46 ]; then
NumFirstExpRun=4335
NumLastExpRun=4338
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 47 ]; then
NumFirstExpRun=4339
NumLastExpRun=4343
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 48 ]; then
NumFirstExpRun=4344
NumLastExpRun=4348
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 49 ]; then
NumFirstExpRun=4349
NumLastExpRun=4354
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 50 ]; then
NumFirstExpRun=4355
NumLastExpRun=4359
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 51 ]; then
NumFirstExpRun=4379
NumLastExpRun=4383
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 52 ]; then
NumFirstExpRun=4384
NumLastExpRun=4386
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 53 ]; then
NumFirstExpRun=4387
NumLastExpRun=4392
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 54 ]; then
NumFirstExpRun=4393
NumLastExpRun=4397
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 55 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000007.dat"
fi

if [ $i == 55 ]; then
NumFirstExpRun=4398
NumLastExpRun=4402
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 56 ]; then
NumFirstExpRun=4403
NumLastExpRun=4407
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 57 ]; then
NumFirstExpRun=4408
NumLastExpRun=4415
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 58 ]; then
NumFirstExpRun=4416
NumLastExpRun=4420
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 59 ]; then
NumFirstExpRun=4421
NumLastExpRun=4426
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 60 ]; then
NumFirstExpRun=4427
NumLastExpRun=4432
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 61 ]; then
NumFirstExpRun=4433
NumLastExpRun=4438
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 62 ]; then
NumFirstExpRun=4439
NumLastExpRun=4444
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 63 ]; then
NumFirstExpRun=4445
NumLastExpRun=4450
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 64 ]; then
NumFirstExpRun=4451
NumLastExpRun=4455
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 65 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000008.dat"
fi

if [ $i == 65 ]; then
NumFirstExpRun=4456
NumLastExpRun=4461
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 66 ]; then
NumFirstExpRun=4462
NumLastExpRun=4469
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 67 ]; then
NumFirstExpRun=4470
NumLastExpRun=4475
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 68 ]; then
NumFirstExpRun=4476
NumLastExpRun=4481
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 69 ]; then
NumFirstExpRun=4482
NumLastExpRun=4487
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 70 ]; then
NumFirstExpRun=4488
NumLastExpRun=4490
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 71 ]; then
NumFirstExpRun=4501
NumLastExpRun=4505
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 72 ]; then
NumFirstExpRun=4506
NumLastExpRun=4510
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 73 ]; then
NumFirstExpRun=4511
NumLastExpRun=4516
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 74 ]; then
NumFirstExpRun=4517
NumLastExpRun=4522
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 75 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000009.dat"
fi

if [ $i == 75 ]; then
NumFirstExpRun=4523
NumLastExpRun=4527
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 76 ]; then
NumFirstExpRun=4528
NumLastExpRun=4533
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 77 ]; then
NumFirstExpRun=4534
NumLastExpRun=4535
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 78 ]; then
NumFirstExpRun=4554
NumLastExpRun=4557
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 79 ]; then
NumFirstExpRun=4563
NumLastExpRun=4568
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 80 ]; then
NumFirstExpRun=4569
NumLastExpRun=4573
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 81 ]; then
NumFirstExpRun=4574
NumLastExpRun=4578
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 82 ]; then
NumFirstExpRun=4579
NumLastExpRun=4584
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 83 ]; then
NumFirstExpRun=4585
NumLastExpRun=4589
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 84 ]; then
NumFirstExpRun=4596
NumLastExpRun=4599
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 85 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000010.dat"
fi

if [ $i == 85 ]; then
NumFirstExpRun=4600
NumLastExpRun=4605
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 86 ]; then
NumFirstExpRun=4606
NumLastExpRun=4610
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 87 ]; then
NumFirstExpRun=4611
NumLastExpRun=4616
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 88 ]; then
NumFirstExpRun=4617
NumLastExpRun=4622
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 89 ]; then
NumFirstExpRun=4623
NumLastExpRun=4629
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 90 ]; then
NumFirstExpRun=4630
NumLastExpRun=4635
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 91 ]; then
NumFirstExpRun=4637
NumLastExpRun=4642
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 92 ]; then
NumFirstExpRun=4644
NumLastExpRun=4647
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 93 ]; then
NumFirstExpRun=4650
NumLastExpRun=4655
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 94 ]; then
NumFirstExpRun=4656
NumLastExpRun=4660
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 95 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000011.dat"
fi

if [ $i == 95 ]; then
NumFirstExpRun=4661
NumLastExpRun=4666
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 96 ]; then
NumFirstExpRun=4668
NumLastExpRun=4673
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 97 ]; then
NumFirstExpRun=4674
NumLastExpRun=4679
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 98 ]; then
NumFirstExpRun=4680
NumLastExpRun=4683
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 99 ]; then
NumFirstExpRun=4684
NumLastExpRun=4686
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 100 ]; then
NumFirstExpRun=4687
NumLastExpRun=4691
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 101 ]; then
NumFirstExpRun=4692
NumLastExpRun=4693
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 102 ]; then
NumFirstExpRun=4694
NumLastExpRun=4695
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 103 ]; then
NumFirstExpRun=4696
NumLastExpRun=4697
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 104 ]; then
NumFirstExpRun=4698
NumLastExpRun=4699
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

#######################################################################################################
if [ $i -ge 105 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/simDmeson000012.dat"
fi

if [ $i == 105 ]; then
NumFirstExpRun=4700
NumLastExpRun=4701
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 106 ]; then
NumFirstExpRun=4702
NumLastExpRun=4703
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 107 ]; then
NumFirstExpRun=4704
NumLastExpRun=4705
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 108 ]; then
NumFirstExpRun=4706
NumLastExpRun=4707
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

#######################################################################################################

$HOME/development/Dmeson/analysis_Dplusmeson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

