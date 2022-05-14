#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N SimDpBG
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
##$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/ovtin/release/lib,KDBHOST=bison-2
#$ -v PATH=$PATH:$HOME/release/KdRunFastMon,LD_LIBRARY_PATH=/usr/local/root/lib/root:/home/ovtin/release/lib,KDBHOST=localhost
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

#$ -t 1-122

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Bkg eetoDD
simOn=1
##outfile="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD2004/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.5_Z0.0/psi3770_to_simDplusmesonBkg_eetoDD_"$i".root"
outfile="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD2004/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.5_Z0.0/psi3770_to_simDplusmesonBkg_eetoDD_"$i".root"

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
##############################
beginR1=0
endR1=5400
#
beginR2=5401
endR2=10800
#
beginR3=10801
endR3=16200
#
beginR4=16201
endR4=21600
#
beginR5=21601
endR5=27000
#
beginR6=27001
endR6=32400
#
beginR7=32401
endR7=37800
#
beginR8=37801
endR8=43200
#
beginR9=43201
endR9=48600
#
beginR10=48601
endR10=54000
#
beginR11=54001
endR11=59400
#
beginR12=59401
endR12=64800
#
beginR13=64801
endR13=70200
#
beginR14=70201
endR14=75600
#
beginR15=75601
endR15=81000
#
beginR16=81001
endR16=86400
#
beginR17=86401
endR17=91800
#
beginR18=91801
endR18=97200

########################################################################################################
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/simDmeson000001.dat"
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
NumLastExpRun=4108
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 4 ]; then
NumFirstExpRun=4109
NumLastExpRun=4114
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 5 ]; then
NumFirstExpRun=4115
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
NumLastExpRun=4143
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 9 ]; then
NumFirstExpRun=4144
NumLastExpRun=4145
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 10 ]; then
NumFirstExpRun=4150
NumLastExpRun=4155
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 11 ]; then
NumFirstExpRun=4156
NumLastExpRun=4159
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 12 ]; then
NumFirstExpRun=4160
NumLastExpRun=4165
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 13 ]; then
NumFirstExpRun=4166
NumLastExpRun=4170
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 14 ]; then
NumFirstExpRun=4171
NumLastExpRun=4176
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 15 ]; then
NumFirstExpRun=4177
NumLastExpRun=4182
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 16 ]; then
NumFirstExpRun=4183
NumLastExpRun=4187
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 17 ]; then
NumFirstExpRun=4188
NumLastExpRun=4193
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 18 ]; then
NumFirstExpRun=4194
NumLastExpRun=4198
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

########################################################################################################
if [ $i -ge 19 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/simDmeson000002.dat"
fi

if [ $i == 19 ]; then
NumFirstExpRun=4199
NumLastExpRun=4202
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 20 ]; then
NumFirstExpRun=4203
NumLastExpRun=4205
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 21 ]; then
NumFirstExpRun=4209
NumLastExpRun=4212
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 22 ]; then
NumFirstExpRun=4213
NumLastExpRun=4216
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 23 ]; then
NumFirstExpRun=4217
NumLastExpRun=4221
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 24 ]; then
NumFirstExpRun=4222
NumLastExpRun=4223
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 25 ]; then
NumFirstExpRun=4231
NumLastExpRun=4235
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 26 ]; then
NumFirstExpRun=4236
NumLastExpRun=4240
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 27 ]; then
NumFirstExpRun=4252
NumLastExpRun=4257
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 28 ]; then
NumFirstExpRun=4258
NumLastExpRun=4262
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 29 ]; then
NumFirstExpRun=4263
NumLastExpRun=4267
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 30 ]; then
NumFirstExpRun=4269
NumLastExpRun=4271
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 31 ]; then
NumFirstExpRun=4272
NumLastExpRun=4273
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 32 ]; then
NumFirstExpRun=4277
NumLastExpRun=4279
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 33 ]; then
NumFirstExpRun=4280
NumLastExpRun=4285
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 34 ]; then
NumFirstExpRun=4286
NumLastExpRun=4291
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 35 ]; then
NumFirstExpRun=4292
NumLastExpRun=4298
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 36 ]; then
NumFirstExpRun=4299
NumLastExpRun=4304
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

#######################################################################################################
if [ $i -ge 37 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/simDmeson000003.dat"
fi

if [ $i == 37 ]; then
NumFirstExpRun=4305
NumLastExpRun=4309
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 38 ]; then
NumFirstExpRun=4310
NumLastExpRun=4314
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 39 ]; then
NumFirstExpRun=4315
NumLastExpRun=4319
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 40 ]; then
NumFirstExpRun=4320
NumLastExpRun=4321
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 41 ]; then
NumFirstExpRun=4331
NumLastExpRun=4335
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 42 ]; then
NumFirstExpRun=4336
NumLastExpRun=4340
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 43 ]; then
NumFirstExpRun=4341
NumLastExpRun=4345
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 44 ]; then
NumFirstExpRun=4346
NumLastExpRun=4350
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 45 ]; then
NumFirstExpRun=4351
NumLastExpRun=4354
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 46 ]; then
NumFirstExpRun=4355
NumLastExpRun=4358
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 47 ]; then
NumFirstExpRun=4359
NumLastExpRun=4362
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 48 ]; then
NumFirstExpRun=4379
NumLastExpRun=4382
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 49 ]; then
NumFirstExpRun=4383
NumLastExpRun=4386
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 50 ]; then
NumFirstExpRun=4387
NumLastExpRun=4390
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 51 ]; then
NumFirstExpRun=4392
NumLastExpRun=4394
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 52 ]; then
NumFirstExpRun=4395
NumLastExpRun=4399
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 53 ]; then
NumFirstExpRun=4400
NumLastExpRun=4404
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 54 ]; then
NumFirstExpRun=4405
NumLastExpRun=4409
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

#######################################################################################################
if [ $i -ge 55 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/simDmeson000004.dat"
fi

if [ $i == 55 ]; then
NumFirstExpRun=4413
NumLastExpRun=4416
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 56 ]; then
NumFirstExpRun=4417
NumLastExpRun=4420
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 57 ]; then
NumFirstExpRun=4421
NumLastExpRun=4424
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 58 ]; then
NumFirstExpRun=4425
NumLastExpRun=4426
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 59 ]; then
NumFirstExpRun=4427
NumLastExpRun=4428
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 60 ]; then
NumFirstExpRun=4429
NumLastExpRun=4430
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 61 ]; then
NumFirstExpRun=4431
NumLastExpRun=4432
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 62 ]; then
NumFirstExpRun=4433
NumLastExpRun=4434
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 63 ]; then
NumFirstExpRun=4435
NumLastExpRun=4436
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 64 ]; then
NumFirstExpRun=4437
NumLastExpRun=4440
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 65 ]; then
NumFirstExpRun=4441
NumLastExpRun=4443
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 66 ]; then
NumFirstExpRun=4444
NumLastExpRun=4445
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 67 ]; then
NumFirstExpRun=4446
NumLastExpRun=4447
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 68 ]; then
NumFirstExpRun=4448
NumLastExpRun=4449
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 69 ]; then
NumFirstExpRun=4450
NumLastExpRun=4453
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 70 ]; then
NumFirstExpRun=4454
NumLastExpRun=4456
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 71 ]; then
NumFirstExpRun=4457
NumLastExpRun=4460
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 72 ]; then
NumFirstExpRun=4461
NumLastExpRun=4467
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

#######################################################################################################
if [ $i -ge 73 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/simDmeson000005.dat"
fi

if [ $i == 73 ]; then
NumFirstExpRun=4468
NumLastExpRun=4472
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 74 ]; then
NumFirstExpRun=4473
NumLastExpRun=4477
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 75 ]; then
NumFirstExpRun=4478
NumLastExpRun=4482
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 76 ]; then
NumFirstExpRun=4483
NumLastExpRun=4484
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 77 ]; then
NumFirstExpRun=4485
NumLastExpRun=4489
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 78 ]; then
NumFirstExpRun=4490
NumLastExpRun=4492
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 79 ]; then
NumFirstExpRun=4501
NumLastExpRun=4505
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 80 ]; then
NumFirstExpRun=4506
NumLastExpRun=4510
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 81 ]; then
NumFirstExpRun=4511
NumLastExpRun=4515
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 82 ]; then
NumFirstExpRun=4516
NumLastExpRun=4520
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 83 ]; then
NumFirstExpRun=4521
NumLastExpRun=4525
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 84 ]; then
NumFirstExpRun=4526
NumLastExpRun=4530
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 85 ]; then
NumFirstExpRun=4531
NumLastExpRun=4534
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 86 ]; then
NumFirstExpRun=4554
NumLastExpRun=4557
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 87 ]; then
NumFirstExpRun=4563
NumLastExpRun=4566
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 88 ]; then
NumFirstExpRun=4567
NumLastExpRun=4570
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 89 ]; then
NumFirstExpRun=4571
NumLastExpRun=4574
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 90 ]; then
NumFirstExpRun=4575
NumLastExpRun=4578
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

#######################################################################################################
if [ $i -ge 91 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/simDmeson000006.dat"
fi

if [ $i == 91 ]; then
NumFirstExpRun=4579
NumLastExpRun=4583
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 92 ]; then
NumFirstExpRun=4584
NumLastExpRun=4588
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 93 ]; then
NumFirstExpRun=4589
NumLastExpRun=4592
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 94 ]; then
NumFirstExpRun=4596
NumLastExpRun=4599
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 95 ]; then
NumFirstExpRun=4600
NumLastExpRun=4605
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 96 ]; then
NumFirstExpRun=4606
NumLastExpRun=4610
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 97 ]; then
NumFirstExpRun=4611
NumLastExpRun=4614
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 98 ]; then
NumFirstExpRun=4615
NumLastExpRun=4619
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 99 ]; then
NumFirstExpRun=4620
NumLastExpRun=4624
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 100 ]; then
NumFirstExpRun=4625
NumLastExpRun=4630
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 101 ]; then
NumFirstExpRun=4631
NumLastExpRun=4635
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 102 ]; then
NumFirstExpRun=4637
NumLastExpRun=4638
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 103 ]; then
NumFirstExpRun=4639
NumLastExpRun=4640
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 104 ]; then
NumFirstExpRun=4641
NumLastExpRun=4642
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

if [ $i == 105 ]; then
NumFirstExpRun=4644
NumLastExpRun=4645
NevRate=100
nevbegin=$beginR15
nevend=$endR15
fi

if [ $i == 106 ]; then
NumFirstExpRun=4646
NumLastExpRun=4647
NevRate=100
nevbegin=$beginR16
nevend=$endR16
fi

if [ $i == 107 ]; then
NumFirstExpRun=4650
NumLastExpRun=4654
NevRate=100
nevbegin=$beginR17
nevend=$endR17
fi

if [ $i == 108 ]; then
NumFirstExpRun=4655
NumLastExpRun=4659
NevRate=100
nevbegin=$beginR18
nevend=$endR18
fi

#######################################################################################################
if [ $i -ge 109 ]; then
inruns="/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/simDmeson000007.dat"
fi

if [ $i == 109 ]; then
NumFirstExpRun=4660
NumLastExpRun=4664
NevRate=100
nevbegin=$beginR1
nevend=$endR1
fi

if [ $i == 110 ]; then
NumFirstExpRun=4665
NumLastExpRun=4670
NevRate=100
nevbegin=$beginR2
nevend=$endR2
fi

if [ $i == 111 ]; then
NumFirstExpRun=4671
NumLastExpRun=4673
NevRate=100
nevbegin=$beginR3
nevend=$endR3
fi

if [ $i == 112 ]; then
NumFirstExpRun=4674
NumLastExpRun=4675
NevRate=100
nevbegin=$beginR4
nevend=$endR4
fi

if [ $i == 113 ]; then
NumFirstExpRun=4676
NumLastExpRun=4678
NevRate=100
nevbegin=$beginR5
nevend=$endR5
fi

if [ $i == 114 ]; then
NumFirstExpRun=4679
NumLastExpRun=4681
NevRate=100
nevbegin=$beginR6
nevend=$endR6
fi

if [ $i == 115 ]; then
NumFirstExpRun=4682
NumLastExpRun=4685
NevRate=100
nevbegin=$beginR7
nevend=$endR7
fi

if [ $i == 116 ]; then
NumFirstExpRun=4686
NumLastExpRun=4690
NevRate=100
nevbegin=$beginR8
nevend=$endR8
fi

if [ $i == 117 ]; then
NumFirstExpRun=4691
NumLastExpRun=4693
NevRate=100
nevbegin=$beginR9
nevend=$endR9
fi

if [ $i == 118 ]; then
NumFirstExpRun=4694
NumLastExpRun=4696
NevRate=100
nevbegin=$beginR10
nevend=$endR10
fi

if [ $i == 119 ]; then
NumFirstExpRun=4697
NumLastExpRun=4699
NevRate=100
nevbegin=$beginR11
nevend=$endR11
fi

if [ $i == 120 ]; then
NumFirstExpRun=4700
NumLastExpRun=4702
NevRate=100
nevbegin=$beginR12
nevend=$endR12
fi

if [ $i == 121 ]; then
NumFirstExpRun=4703
NumLastExpRun=4705
NevRate=100
nevbegin=$beginR13
nevend=$endR13
fi

if [ $i == 122 ]; then
NumFirstExpRun=4706
NumLastExpRun=4707
NevRate=100
nevbegin=$beginR14
nevend=$endR14
fi

#######################################################################################################

$HOME/development/Dmeson/analysis_Dplusmeson -D $simOn -v $NumFirstExpRun -m $NumLastExpRun -M $NevRate -S 1.0 -A 4.5 -Z 0.0 -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -w $nevbegin -g $nevend

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

