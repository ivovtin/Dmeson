# Dmeson - package for analysis

Get the code:  <br />
```
git clone https://github.com/ivovtin/Dmeson
```

D0 meson - 1864,86 MeV <br />
D+ meson - 1869,57 MeV <br />
Ds meson - 1968.47 MeV <br />

analysis_Dmeson.C - The code for handling raw events with help reconstruction package and write structures in the root-file. <br />

Examples for run: <br />
```
analysis_Dmeson  -v 23110 -n 50 /spool/users/ovtin/sim000018.dat - simulation 50 events <br />
analysis_Dmeson -x -n 2000 /space/runs/daq023930.nat.bz2  - run draw with KDisplay <br />
analysis_Dmeson -n 2000 /space/runs/daq023930.nat.bz2 -o out.root - experiment, write to file<br />
/home/ovtin/development/Dmeson/analysis_Dmeson -n 10000 -o /spool/users/ovtin/psi3770_test.root /home/ovtin/development/Dmeson/runsDmeson/runDmeson1 <br />
```

Run KDisplay for view event with reconstruction <br />
```
bzcat /space/runs/daq021913.nat.bz2 | KDisplay -r -e3197 <br />
```

Work on batch system: <br />
bsub batch_dataatc_Dmeson.sh <br />
qstat                        <br />
qstat -u ovtin               <br />
qdel 772354                  <br />


# Information about D-meson statistic:
Runs in peak Psi(3770) -> e+e- -> DD^- (D0D^-0 or D+D-): <br />
23206 (2016-02-09) and 23942 (2016-05-23).    February-May 2016 <br />
In selected runs - 130.775.145 events (207.190 Å+Å- and 21.046 MHadr candidates), integral luminosity is 1161.799 ÎÂ^-1 (or 1.1 pb^-1)  <br />

Added runs from 2017. <br />

Registration D-mesons in channels:<br />
D0->K-pi+ (D0bar->K+pi-)           <br />
D+->K-pi+pi+ (D- ->K+pi-pi-)       <br />

Momentum D-meson from decay Psi(3770) -> DD^- constitute pd ~ 260 MeV/c <br />
In decay Psi(3770) born 2 D-mesons                                <br />


./Dmeson 1 1 0 1 0 160 3000 0                                           <br />


0.9 nb^-1 statistic for 2009 year - expect 100 signal events D0->K-pi+  <br />

N=Lint*sigma                                                                 <br />

Lint - integral luminosity (pb-1)                                        <br />
sigma - cross-section (pb, cm^2)                                                   <br />

sigma(DDbar)=6.57 nb   -> sigma(D0D0bar) + sigma(D+D-)                       <br />
sigma(D0D0bar)=3.66 nb                                                       <br />
sigma(D+D-)=2.91 nb                                                          <br />

N=1161.799*3.66=4252 events  D0->K-pi+  *3.80%  => 161.5 *2 = 322*1000=322000       <br />

N=1161.799*2.91=3380 events  D+->K-pi+pi+ (D- ->K+pi-pi-) *9.2% => 310 *2 = 620         <br />

 2*900*3.66*0.0388=255.61440                                                             <br />
 98.4/255.61440=38.5%                                                                    <br />

The criteria pi/K identidication in ATC:                                                       <br />
Nph.e. less then ~0.5-1.0 in momentum range for track 400-1300 MeV/c  - Kaon, otherwise Pion, lenght track is >4 cm. <br />

Example from previous analysis: /home/poluektv/kedr/release/dmass2/kp/bin/dmass_kp.cc  <br />


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

et->Scan("ev.run:ev.evdaq:Dmeson.Mbc:Dmeson.dE");                  <br />
et->Scan("ev.run:ev.evdaq:Dmeson.Mbc:Dmeson.dE","Dmeson.dE>0");    <br />
et->Draw("Dmeson.Mbc","emc.ncls>2 && emc.ncls<6")                  <br />


bzcat /space/runs/daq023665.nat.bz2 | KDisplay -r -e520             <br />














