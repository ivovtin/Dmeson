echo "make histograms: dcnoise.sh <run>"
echo "show histograms with paw: exe loop <run>"
#
##nice -n 19 /home/offline/release/bin/plotdcx -DC-9 -TRG1 -TrgTest1 -R$1 -d/space/runs -HIST/spool/users/ovtin/dcnoises/h$1.rz -save1000 -print5000 -STOP -PLOT -vdRT -wait-5 $2 $3 $4 $5 $6
$HOME/development/Dmeson/dcnoise/plotdcx -DC-9 -TRG1 -TrgTest1 -R$1 -d/space/runs -HIST/spool/users/ovtin/dcnoises/h$1.rz -save1000 -print5000 -STOP -PLOT -vdRT -wait-5 $2 $3 $4 $5 $6
#
#nice -n 19 ../bin/plotdcx -TRG1 -TrgTest1 -R$1 -d/runs/runs -HISTh$1.rz -save1000 -STOP -PLOT -vdRT -wait-5 $2 $3 $4 $5 $6
