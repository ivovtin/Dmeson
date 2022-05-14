	#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimD0Sig
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

##for Signal
#$ -t 1-101

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
simOn=1
outfile="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal2004/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0/psi3770_to_simD0mesonSignal_"$i".root"

mintracks=2
maxtracks=20
minbeamtracks=0
minIPtracks=0
maxIPtracks=20
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
verbose=0

#########################
beginR1=0
endR1=2000
#
beginR2=2001
endR2=4000
#
beginR3=4001
endR3=6000
#
beginR4=6001
endR4=8000
#
beginR5=8001
endR5=10000
#
beginR6=10001
endR6=12000
#
beginR7=12001
endR7=14000
#
beginR8=14001
endR8=16000
#
beginR9=16001
endR9=18000
#
beginR10=18001
endR10=20000
#
beginR11=20001
endR11=22000
#
beginR12=22001
endR12=24000
#
beginR13=24001
endR13=26000
#
beginR14=26001
endR14=28000
#
beginR15=28001
endR15=30000
#
beginR16=30001
endR16=32000
#
beginR17=32001
endR17=34000
#
beginR18=34001
endR18=36000
#
beginR19=36001
endR19=38000
#
beginR20=38001
endR20=40000
#
beginR21=40001
endR21=42000
#
beginR22=42001
endR22=44000
#
beginR23=44001
endR23=46000

########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson000001.dat"
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
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 4 ]; then
NumFirstExpRun=4109
NumLastExpRun=4111
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 5 ]; then
NumFirstExpRun=4112
NumLastExpRun=4114
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 6 ]; then
NumFirstExpRun=4115
NumLastExpRun=4117
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 7 ]; then
NumFirstExpRun=4118
NumLastExpRun=4120
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 8 ]; then
NumFirstExpRun=4126
NumLastExpRun=4128
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 9 ]; then
NumFirstExpRun=4132
NumLastExpRun=4134
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 10 ]; then
NumFirstExpRun=4135
NumLastExpRun=4138
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 11 ]; then
NumFirstExpRun=4139
NumLastExpRun=4141
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 12 ]; then
NumFirstExpRun=4142
NumLastExpRun=4145
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 13 ]; then
NumFirstExpRun=4150
NumLastExpRun=4152
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 14 ]; then
NumFirstExpRun=4153
NumLastExpRun=4156
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 15 ]; then
NumFirstExpRun=4157
NumLastExpRun=4160
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 16 ]; then
NumFirstExpRun=4161
NumLastExpRun=4164
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 17 ]; then
NumFirstExpRun=4165
NumLastExpRun=4168
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 18 ]; then
NumFirstExpRun=4169
NumLastExpRun=4172
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

if [ $i == 19 ]; then
NumFirstExpRun=4173
NumLastExpRun=4176
NevRate=100
nevbegin=$beginR19
nevend=$endR19
fi

if [ $i == 20 ]; then
NumFirstExpRun=4177
NumLastExpRun=4180
NevRate=100
nevbegin=$beginR20
nevend=$endR20
fi

if [ $i == 21 ]; then
NumFirstExpRun=4181
NumLastExpRun=4185
NevRate=100
nevbegin=$beginR21
nevend=$endR21
fi

if [ $i == 22 ]; then
NumFirstExpRun=4186
NumLastExpRun=4190
NevRate=100
nevbegin=$beginR22
nevend=$endR22
fi

if [ $i == 23 ]; then
NumFirstExpRun=4191
NumLastExpRun=4193
NevRate=100
nevbegin=$beginR23
nevend=$endR23
fi

#######################################################################################################
if [ $i -ge 24 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson000002.dat"
fi

if [ $i == 24 ]; then
NumFirstExpRun=4194
NumLastExpRun=4196
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 25 ]; then
NumFirstExpRun=4197
NumLastExpRun=4200
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 26 ]; then
NumFirstExpRun=4201
NumLastExpRun=4204
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 27 ]; then
NumFirstExpRun=4205
NumLastExpRun=4209
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 28 ]; then
NumFirstExpRun=4210
NumLastExpRun=4214
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 29 ]; then
NumFirstExpRun=4215
NumLastExpRun=4218
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 30 ]; then
NumFirstExpRun=4219
NumLastExpRun=4222
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 31 ]; then
NumFirstExpRun=4223
NumLastExpRun=4225
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 32 ]; then
NumFirstExpRun=4231
NumLastExpRun=4235
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 33 ]; then
NumFirstExpRun=4236
NumLastExpRun=4239
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 34 ]; then
NumFirstExpRun=4240
NumLastExpRun=4245
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 35 ]; then
NumFirstExpRun=4252
NumLastExpRun=4256
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 36 ]; then
NumFirstExpRun=4257
NumLastExpRun=4261
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 37 ]; then
NumFirstExpRun=4262
NumLastExpRun=4267
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 38 ]; then
NumFirstExpRun=4269
NumLastExpRun=4273
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 39 ]; then
NumFirstExpRun=4277
NumLastExpRun=4282
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 40 ]; then
NumFirstExpRun=4283
NumLastExpRun=4287
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 41 ]; then
NumFirstExpRun=4288
NumLastExpRun=4292
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

if [ $i == 42 ]; then
NumFirstExpRun=4293
NumLastExpRun=4297
NevRate=100
nevbegin=$beginR19
nevend=$endR19
fi

if [ $i == 43 ]; then
NumFirstExpRun=4298
NumLastExpRun=4303
NevRate=100
nevbegin=$beginR20
nevend=$endR20
fi

if [ $i == 44 ]; then
NumFirstExpRun=4304
NumLastExpRun=4308
NevRate=100
nevbegin=$beginR21
nevend=$endR21
fi

if [ $i == 45 ]; then
NumFirstExpRun=4309
NumLastExpRun=4314
NevRate=100
nevbegin=$beginR22
nevend=$endR22
fi

if [ $i == 46 ]; then
NumFirstExpRun=4315
NumLastExpRun=4320
NevRate=100
nevbegin=$beginR23
nevend=$endR23
fi

#######################################################################################################
if [ $i -ge 47 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson000003.dat"
fi

if [ $i == 47 ]; then
NumFirstExpRun=4321
NumLastExpRun=4325
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 48 ]; then
NumFirstExpRun=4335
NumLastExpRun=4340
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 49 ]; then
NumFirstExpRun=4341
NumLastExpRun=4346
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 50 ]; then
NumFirstExpRun=4347
NumLastExpRun=4352
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 51 ]; then
NumFirstExpRun=4353
NumLastExpRun=4357
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 52 ]; then
NumFirstExpRun=4358
NumLastExpRun=4359
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 53 ]; then
NumFirstExpRun=4379
NumLastExpRun=4384
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 54 ]; then
NumFirstExpRun=4385
NumLastExpRun=4389
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 55 ]; then
NumFirstExpRun=4390
NumLastExpRun=4396
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 56 ]; then
NumFirstExpRun=4397
NumLastExpRun=4402
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 57 ]; then
NumFirstExpRun=4403
NumLastExpRun=4409
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 58 ]; then
NumFirstExpRun=4413
NumLastExpRun=4419
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 59 ]; then
NumFirstExpRun=4420
NumLastExpRun=4426
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 60 ]; then
NumFirstExpRun=4427
NumLastExpRun=4432
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 61 ]; then
NumFirstExpRun=4433
NumLastExpRun=4438
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 62 ]; then
NumFirstExpRun=4439
NumLastExpRun=4444
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 63 ]; then
NumFirstExpRun=4445
NumLastExpRun=4450
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 64 ]; then
NumFirstExpRun=4451
NumLastExpRun=4453
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

if [ $i == 65 ]; then
NumFirstExpRun=4454
NumLastExpRun=4459
NevRate=100
nevbegin=$beginR19
nevend=$endR19
fi

if [ $i == 66 ]; then
NumFirstExpRun=4460
NumLastExpRun=4467
NevRate=100
nevbegin=$beginR20
nevend=$endR20
fi

if [ $i == 67 ]; then
NumFirstExpRun=4468
NumLastExpRun=4472
NevRate=100
nevbegin=$beginR21
nevend=$endR21
fi

if [ $i == 68 ]; then
NumFirstExpRun=4473
NumLastExpRun=4477
NevRate=100
nevbegin=$beginR22
nevend=$endR22
fi

if [ $i == 69 ]; then
NumFirstExpRun=4478
NumLastExpRun=4483
NevRate=100
nevbegin=$beginR23
nevend=$endR23
fi

#######################################################################################################
if [ $i -ge 70 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson000004.dat"
fi

if [ $i == 70 ]; then
NumFirstExpRun=4484
NumLastExpRun=4489
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 71 ]; then
NumFirstExpRun=4490
NumLastExpRun=4496
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 72 ]; then
NumFirstExpRun=4501
NumLastExpRun=4505
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 73 ]; then
NumFirstExpRun=4506
NumLastExpRun=4509
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 74 ]; then
NumFirstExpRun=4510
NumLastExpRun=4515
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 75 ]; then
NumFirstExpRun=4516
NumLastExpRun=4520
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 76 ]; then
NumFirstExpRun=4521
NumLastExpRun=4526
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 77 ]; then
NumFirstExpRun=4527
NumLastExpRun=4532
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 78 ]; then
NumFirstExpRun=4533
NumLastExpRun=4534
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 79 ]; then
NumFirstExpRun=4554
NumLastExpRun=4557
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 80 ]; then
NumFirstExpRun=4563
NumLastExpRun=4568
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 81 ]; then
NumFirstExpRun=4569
NumLastExpRun=4574
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 82 ]; then
NumFirstExpRun=4575
NumLastExpRun=4580
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 83 ]; then
NumFirstExpRun=4581
NumLastExpRun=4587
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 84 ]; then
NumFirstExpRun=4588
NumLastExpRun=4589
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 85 ]; then
NumFirstExpRun=4596
NumLastExpRun=4601
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 86 ]; then
NumFirstExpRun=4602
NumLastExpRun=4607
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 87 ]; then
NumFirstExpRun=4608
NumLastExpRun=4613
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

if [ $i == 88 ]; then
NumFirstExpRun=4614
NumLastExpRun=4619
NevRate=100
nevbegin=$beginR19
nevend=$endR19
fi

if [ $i == 89 ]; then
NumFirstExpRun=4620
NumLastExpRun=4625
NevRate=100
nevbegin=$beginR20
nevend=$endR20
fi

if [ $i == 90 ]; then
NumFirstExpRun=4628
NumLastExpRun=4633
NevRate=100
nevbegin=$beginR21
nevend=$endR21
fi

if [ $i == 91 ]; then
NumFirstExpRun=4634
NumLastExpRun=4640
NevRate=100
nevbegin=$beginR22
nevend=$endR22
fi

if [ $i == 92 ]; then
NumFirstExpRun=4641
NumLastExpRun=4647
NevRate=100
nevbegin=$beginR23
nevend=$endR23
fi

#######################################################################################################
if [ $i -ge 93 ]; then
inruns="/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/simDmeson000005.dat"
fi

if [ $i == 93 ]; then
NumFirstExpRun=4650
NumLastExpRun=4655
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 94 ]; then
NumFirstExpRun=4656
NumLastExpRun=4661
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 95 ]; then
NumFirstExpRun=4662
NumLastExpRun=4668
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 96 ]; then
NumFirstExpRun=4669
NumLastExpRun=4674
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 97 ]; then
NumFirstExpRun=4675
NumLastExpRun=4681
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 98 ]; then
NumFirstExpRun=4682
NumLastExpRun=4687
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 99 ]; then
NumFirstExpRun=4690
NumLastExpRun=4696
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 100 ]; then
NumFirstExpRun=4697
NumLastExpRun=4702
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 101 ]; then
NumFirstExpRun=4703
NumLastExpRun=4707
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

#######################################################################################################

$HOME/development/Dmeson/analysis_D0meson_woATC -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -z $verbose -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"
