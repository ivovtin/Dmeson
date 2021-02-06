#!/bin/bash

filename='/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_2016-17_good.dat'

echo Start rewriting

while read run; do
    if [ $run -ge 23453 ]; then
      echo "Stop"
      break
    fi
    echo $run
    egrep -w "Nev|Nrnd" "/spool/users/ovtin/dcnoises/out"$run".dat" >> test1.dat
    sed '1,10d' test1.dat >> test2.dat
    sed -e 's/Nev//; s/Nrnd//; s/Ndc>20(100)//; s/: <run>//; s/( /  /; s/) <200>//; s/ <1000>//; s/( /  /; s/)//' test2.dat >> "/spool/users/ovtin/dcnoises/rewrite_out"$run".dat"
    rm test1.dat test2.dat
done < $filename

echo "Job finished\n"
