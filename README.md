# Dmeson - package for analysis

Get the code:  <br />
```
git clone https://github.com/ivovtin/Dmeson
```
Package depends on [KaFramework](https://github.com/ivovtin/KaFramework) <br />

analysis_D0meson.C - The code for D0 preprocessing raw events with help reconstruction package and write structures in the root-file. <br />

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
./D0meson 1 1 0 1 0 160 3000 0

. runDmeson.sh
```

Important plots are here http://kedr.inp.nsk.su/~ovtin/outDmeson/


# Information about D-meson statistic:
Runs in peak Psi(3770) -> e+e- -> DD^- (D^0D^-0 or D+D-): <br />

D0 meson - 1864,86 MeV <br />
D+ meson - 1869,57 MeV <br />
Ds meson - 1968.47 MeV <br />

1) 23206 - 23942 (date: 2016-02-09 - 2016-05-23) <br />
In selected runs - 130775145 events (207190 e+e- and 21046 MHadr candidates), integral luminosity is 1161.799 nb^-1 (or 1.16 pb^-1).  <br />
2) 24835 - 26248 (date: 2017-03-05 - 2017-12-24) <br />
In selected runs - 452752351 events (393776 e+e- and 61279 MHadr candidates), integral luminosity is 2638.276 nb^-1 (or 2.64 pb^-1).  <br />

Summary: 583,527,496 events; 600966 e+e- and 82325 MHadr candidates; integral luminosity - 3.8 pb^-1. <br />

Bkg Runs: <br />
1) 23939 - 23499 <br />
In selected runs - 6791860 events (1 e+e- and 510 MHadr candidates), integral luminosity is 0.000 nb^-1   <br />
2) 24834 - 26245 (2017 year) <br />
In selected runs - 14182834 events (7 e+e- and 3124 MHadr candidates), integral luminosity is 0.000 nb^-1   <br />

0.9 pb^-1 statistic for 2004-2009 year - expect 100 signal events D0->K-pi+  <br />
2x900(nb^-1)x3.66 (nb)x0.0388 = 255.61440  -  expected signal events         <br />
98.4/255.61440=38.5%  - efficiency                                           <br />


# Registration D-mesons in channels:<br />
D0->K-pi+ (D0bar->K+pi-)           <br />
D+->K-pi+pi+ (D- ->K+pi-pi-)       <br />

Resonant depolarization technique for Beam energy measurement - accuracy is 10-70 keV  <br />

Momentum D-meson from decay Psi(3770) -> DD^- constitute pd ~ 260 MeV/c <br />
In decay Psi(3770) born 2 D-mesons                                <br />

N=Lint*sigma                                                                 <br />

Lint - integral luminosity (pb-1)                                        <br />
sigma - cross-section (pb, cm^2)                                                   <br />

sigma(DDbar)=6.57 nb   -> sigma(D0D0bar) + sigma(D+D-)                       <br />
sigma(D0D0bar)=3.66 nb                                                       <br />
sigma(D+D-)=2.91 nb                                                          <br />

N=3800 nb^-1 x 3.66 nb = 13908 events Psi(3770)->D0D0bar, (D0->K-pi+)  x3.80%  =>  = 528.5 x2 = 1057      <br />

N=3800x2.91 = 11058 events Psi(3770)->D+D-, ( D+->K-pi+pi+) (D- ->K+pi-pi-) x9.2% =>  = 1017.3 x2 = 2034         <br />


The criteria pi/K identidication in ATC:                                                       <br />
Nph.e. less then ~0.5-1.0 in momentum range for track 400-1300 MeV/c  - Kaon, otherwise Pion, lenght track is >4 cm. <br />

Example from previous analysis: /home/poluektv/kedr/release/dmass2/kp/bin/dmass_kp.cc  <br />

# Simulation

~/3.0.0/bin/ks < mc.cards.ee_to_DD > /dev/null  <br />
KDisplay < simout/sim000001.dat -r -R19697     <br />

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

# List candidates for D0->K-pi+ decay
Run 23930:                                                                                     <br />
Event=12208	Raw event=12439	eTracksAll=4	eTracksBeam=4	eTracksIP=4    +   -e12195     <br />
root [5] et->Scan("ev.run:ev.evdaq");           <br />
    Row   |    ev.run |  ev.evdaq               <br />
       0  |    23206 |     70250                <br />
       1  |    23215 |     32843                <br />
       9  |    23218 |      3306                <br />
      14  |    23219 |      4596                <br />
      15  |    23219 |     16396                <br />
      16  |    23219 |     20915                <br />
      24  |    23220 |     19317                <br />
      25  |    23220 |     31429                <br />
et->Scan("ev.run:ev.evdaq:Dmeson.Mbc:Dmeson.dE","Dmeson.dE>0");    <br />
et->Draw("Dmeson.Mbc","emc.ncls>2 && emc.ncls<6")                  <br />














