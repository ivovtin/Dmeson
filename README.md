# Dmeson - package for analysis mass D0 and D+ mesons

Get the code:  <br />
```
git clone https://github.com/ivovtin/Dmeson
```
Package depends on [KaFramework](https://github.com/ivovtin/KaFramework) <br />

analysis_D0meson.C - D0 preprocessing raw events with help reconstruction package and write structure in the root-file. <br />
analysis_Dplusmeson.C - D+ preprocessing raw events with help reconstruction package and write structure in the root-file. <br />

Examples for run: <br />
```
./runAnalysisD0.sh
```
Run processing 2000 experimental events and write to file:
```
analysis_D0meson -n 2000 /space/runs/daq023930.nat.bz2 -o out.root
/home/ovtin/development/Dmeson/analysis_Dmeson -n 10000 -o /spool/users/ovtin/psi3770_test.root /home/ovtin/development/Dmeson/runsDmeson/runDmeson1
```
Simulation 50 events:
```
analysis_D0meson  -v 23110 -n 50 /spool/users/ovtin/sim000018.dat
```
Run drawing with KDisplay:
```
analysis_D0meson -x -n 2000 /space/runs/daq023930.nat.bz2
```
Run KDisplay for view event with reconstruction:
```
bzcat /space/runs/daq021913.nat.bz2 | KDisplay -r -e3197
```
Run tasks with D-meson on batch system:
```
qsub batch_data_D0meson.sh
qstat
qstat -u ovtin
qdel 772354
```

Processing prepared root-files with reconstruction for D-meson:
```
./D0meson 0

. runDmeson.sh
```

Important plots are here http://kedr.inp.nsk.su/~ovtin/outDmeson/

# Simulation

For run simulation see directory Dmeson/simulation. <br />
KedrGen - contains modified generator 60 with ISR (RADCOR package) and FSR (PHOTOS package). <br />

Example for run and reconstruction from sim.dat:
```
ks < mc.cards.ee_to_DD > /dev/null

KDisplay < simout/sim000001.dat -r -R19697
```


Information about generators is here http://kedr.inp.nsk.su/FOR_MEMBERS/SOFTWARE/SIMULATION/generators.html#60  <br />
```
GENE 60 Wtot SigmaW
```
Wtot - total energy of collision (GeV) <br />
SigmaW - sigma total energy of collision (GeV) <br />
pair D+D- and anti-D0D0 born equiprobably <br />

Magnetic field is 6 kGs. <br />
D0 mass for simulation is 1864.60 MeV. <br />
Combinatorial background from continuum events (e+e-->qq, q=u,d,s) simulation with 205 generator (Jetset 7.4). <br />
Bkg from decay e+e-->DD simulation with apply 60 generator for which decay D0->K-pi+ is forbidden in decay table JETSET. <br />














