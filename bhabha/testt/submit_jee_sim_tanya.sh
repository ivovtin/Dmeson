#!/bin/sh

# Send mail to these users
#$ -M kozlova@kedr.inp.nsk.su

# Mail at beginning/end/on suspension/on abortion
#$ -m ase
#$ -cwd
#export LD_LIBRARY_PATH=/usr/local/root-5.14.00/lib/root/
echo $SHELL

echo "start jobs running"

./jee_sim_tanya1.sh
