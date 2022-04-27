#!/bin/sh


# simulated e+e- -> e+e- data for the given run interval
# increase systemtic errors in x(t) by factors from dccalibrationDB.txt
# usage: jee_sim.sh run1 run2 prefix
# e+e- -> e+e- was simulated with CMD's generator, E=1524.1 
date

echo "start "

export LD_LIBRARY_PATH=/usr/local/root-5.14.00/lib/root/

run1=23556
run2=23556
iter=a

echo iter: ${iter}
  
#  ../../bin/kee -SimSyst1 -VDRtAlt1 -EmcAngles1 -EEsel1101 -SIM-3 -d/space/skim/psi3770/sim/ -Fsim713201 -R0 -Elkr900 -SAVE3000 -print1000 -SIM1RUN$run1 -SIM2RUN$run2 -HISTee_sim1_${iter}${run1}-${run2}.rz -TRG2 -last1000
#  /store/users/kozlova/bin/kee -D50 -SimSyst1 -VDRtAlt1 -EmcAngles1 -EEsel1101 -SIM-3 -d/space/skim/psi3770/sim/ -Fsim713201 -R0 -Elkr900 -SAVE3000 -print1000 -SIM1RUN$run1 -SIM2RUN$run2 -HISTee_sim1_${iter}${run1}-${run2}.rz -TRG2 -last1000

#  /store/users/ovtin/KEDR/bin/kee -SimSyst1 -VDRtAlt1 -EmcAngles1 -EEsel1101 -SIM-3 -d/space/skim/psi3770/sim/ -Fsim713201 -R0 -Elkr900 -SAVE3000 -print1000 -SIM1RUN$run1 -SIM2RUN$run2 -HISTee_sim1_${iter}${run1}-${run2}.rz -last1000
#  /store/users/ovtin/KEDR/bin/kee -DBG2 -SimSyst1 -VDRtAlt1 -EEsel1101 -SIM-3 -d/space/skim/psi3770/sim/ -Fsim713201 -R0 -Elkr900 -SAVE3000 -print1000 -SIM1RUN$run1 -SIM2RUN$run2 -HISTee_sim1_${iter}${run1}-${run2}.rz -last1000
  /store/users/ovtin/KEDR/bin/kee -SimSyst1 -SIM-3 -d/space/skim/psi3770/sim/ -Fsim713201 -R0 -Elkr900 -SAVE3000 -print1000 -SIM1RUN$run1 -SIM2RUN$run2 -HISTee_sim1_${iter}${run1}-${run2}.rz -last1000

#00 

##../../bin/kee -SimSyst2 -VDRtAlt1 -EmcAngles1 -EEsel1101 -SIM-3 -d/space/skim/psi3770/sim/ -Fsim713201 -R0 -Elkr900 -SAVE3000 -print1000 -SIM1RUN$run1 -SIM2RUN$run2 -HISTee_sim2_${iter}${run1}-${run2}.rz -TRG2 -last1000

#00 

#
date
