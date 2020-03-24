# Dmeson - pacckage for analysis

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

������ KDisplay ��� ��������� ������������� ������� � �������������� <br />
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
In selected runs - 130.775.145 events (207.190 �+�- and 21.046 MHadr candidates), integral luminosity is 1161.799 ��^-1 (or 1.1 pb^-1)  <br />

Added runs from 2017. <br />

Registration D-mesons in channels:<br />
D0->K-pi+ (D0bar->K+pi-)           <br />
D+->K-pi+pi+ (D- ->K+pi-pi-)       <br />

������� D-������ �� ������� Psi(3770) -> DD^- ���������� pd ~ 260 MeV/c <br />
� ������� Psi(3770) ��������� 2 D-������                                <br />


./Dmeson 1 1 0 1 0 160 3000 0                                           <br />


0.9 ��^-1 ���������� 2009 ���� - ��������� 100 ���������� ������� D0->K-pi+  <br />

N=Lint*sigma                                                                 <br />

Lint - ������������ ���������� (pb-1)                                        <br />
sigma - ������� (pb, cm^2)                                                   <br />

sigma(DDbar)=6.57 ��   -> sigma(D0D0bar) + sigma(D+D-)                       <br />
sigma(D0D0bar)=3.66 ��                                                       <br />
sigma(D+D-)=2.91 ��                                                          <br />

N=1161.799*3.66=4252 �������  D0->K-pi+  *3.80%  => 161.5 *2 = 322*1000=322000       <br />

N=1161.799*2.91=3380 �������  D+->K-pi+pi+ (D- ->K+pi-pi-) *9.2% => 310 *2 = 620         <br />

 2*900*3.66*0.0388=255.61440                                                             <br />
 98.4/255.61440=38.5%                                                                    <br />


�������� pi/K-������������� � ATC:                                                       <br />
����� �.�. ������ ~0.5-1.0 � ��������� ��������� ����� 400-1300 ���/�  - ����, ����� ����, <br />
����� ����� ��� ���� >4��.                                                                 <br />

/home/poluektv/kedr/release/dmass2/kp/bin/dmass_kp.cc                                      <br />


Events                                                                                        <br />
Run 23930:                                                                                     <br />
Event=12208	Raw event=12439	eTracksAll=4	eTracksBeam=4	eTracksIP=4    +   -e12195     <br />


root [5] et->Scan("ev.run:ev.evdaq");                              <br />
************************************                               <br />
*    Row   *    ev.run *  ev.evdaq *                               <br />
************************************                               <br />
*        0 *     23206 *     70250 *                                <br />
*        1 *     23215 *     32843 *                               <br />
*        9 *     23218 *      3306 *              !!! --           <br />
*       14 *     23219 *      4596 *              !!!               <br />
*       15 *     23219 *     16396 *              !!!               <br />
*       16 *     23219 *     20915 *              !!!               <br />
*       24 *     23220 *     19317 *              !!!                <br />
*       25 *     23220 *     31429 *              !!!               <br />

 et->Scan("ev.run:ev.evdaq:Dmeson.Mbc:Dmeson.dE");                  <br />
 et->Scan("ev.run:ev.evdaq:Dmeson.Mbc:Dmeson.dE","Dmeson.dE>0");    <br />
 et->Draw("Dmeson.Mbc","emc.ncls>2 && emc.ncls<6")                  <br />


 bzcat /space/runs/daq023665.nat.bz2 | KDisplay -r -e520             <br />

root [18] sqrt(493.68*493.68+pow(758.2,2))+sqrt(pow(139.57,2)+pow(766.1,2))      <br />
(const double)1.68346790663866659e+03                                            <br />
root [19]                                                                        <br />
root [19] sqrt(493.68*493.68+pow(925,2))+sqrt(pow(139.57,2)+pow(711.5,2))        <br />
(const double)1.77355653679083707e+03                                            <br />
                                                                                 <br />
root [22] (1683.46+1773.5)/2-1864                                                <br />
(const double)(-1.35519999999999982e+02)                                         <br />
root [23]                                                                        <br />
                                                                                 <br />
ot [23] sqrt(493.68*493.68+pow(758.2,2))+sqrt(pow(139.57,2)+pow(925.0,2))        <br />
(const double)1.84022843439040207e+03                                            <br />
root [24]                                                                        <br />
root [24]                                                                        <br />
root [24] sqrt(493.68*493.68+pow(766.1,2))+sqrt(pow(139.57,2)+pow(711.5,2))      <br />
(const double)1.63644860632750351e+03                                            <br />
root [25]                                                                        <br />
root [25]                                                                        <br />
root [25] (1840.22+1636.4)/2-1864                                                <br />
(const double)(-1.25690000000000055e+02)                                         <br />
                                                                                 <br />
root [26] sqrt(493.68*493.68+pow(711.5,2))+sqrt(pow(139.57,2)+pow(925.0,2))      <br />
(const double)1.80146815651558472e+03                                            <br />
root [27] sqrt(493.68*493.68+pow(766.1,2))+sqrt(pow(139.57,2)+pow(758.2,2))      <br />
(const double)1.68232763868963229e+03                                            <br />
root [28]                                                                        <br />
root [28] (1801.46+1682.32)/2-1864                                               <br />
(const double)(-1.22110000000000127e+02)                                         <br />















