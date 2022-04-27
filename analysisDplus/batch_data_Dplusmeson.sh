#!/bin/bash
# -------------------------------------------
# --          use bash                     --
#$ -S /bin/bash                            ##specifies the interpreting shell for this job to be the Bash shell.
# -------------------------------------------
# --             batch name                --
#$ -N Dpmeson
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

##$ -t 1-693
#$ -t 401-693

i=${SGE_TASK_ID}
myrand=$[1000+$i]

#Signal
inruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/runDmeson"$i
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0210_kNoiseReject3_atc_KemcAllowediOn/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0150_kNoiseReject3_atc_KemcAllowediOn/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0150_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0150_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_KcExp1_kXTKey1/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0150_kNoiseReject3_atc_KemcAllowedOff_dedx_tof_KcExp1_kXTKey1/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_1.20/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_0.80/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_plus1sigma/psi3770_to_D0meson_"$i".root"
outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_minus1sigma/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0130_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0120_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0200_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0300_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0170_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0125_kNoiseReject3_atc_KemcAllowediOn/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0165_kNoiseReject3_atc_KemcAllowediOn/psi3770_to_D0meson_"$i".root"
##outfile="/store/users/ovtin/outDmeson/Dplus/psi3770_to_D0meson_"$i".root"
#outfile="/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0110_kNoiseReject3_atc_KemcAllowediOn_v2/psi3770_to_D0meson_"$i".root"
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
#maxClusters=35
maxClusters=30
minClustersLKr=0
minClustersCsI=0
maxtchi2=1000
minNhits=0
kinefit=1
##pSF=1.0210   ##data 2016-17
##pSF=1.0150   ##data 2016-17
pSF=1.0140   ##data 2016-17
##pSF=1.0130   ##data 2016-17
##pSF=1.0120   ##data 2016-17
##pSF=1.0200   ##data 2016-17
##pSF=1.0300   ##data 2016-17
##pSF=1.0170   ##data 2016-17
##pSF=1.0125   ##data 2016-17
##pSF=1.0165   ##data 2016-17
##pSF=1.0110   ##data 2016-17
#pSF=1.0   ##data 2016-17
##verbose=1

$HOME/development/Dmeson/analysis_Dplusmeson -a $mintracks -d $maxtracks -b $minbeamtracks -p $minIPtracks -h $maxIPtracks -s $minPt -j $maxPt -t $minClusterEnergy -e $minTotalEnergy -c $minClusters -l $maxClusters -k $minClustersLKr -i $minClustersCsI -u $maxtchi2 -q $minNhits -o $outfile -f $kinefit $inruns -y $pSF

status=$?
if [ $status != 0 ]; then
  echo "Program exited with status $status"
  exit
fi

echo "Job finished\n"

