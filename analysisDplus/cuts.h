#ifndef cuts_h
# define cuts_h

//for print DEBUG information
bool verbose=0;

int ntrk=3;
int nip=0;
int nbeam=0;
float min_pt=100.; //MeV
float max_pt=2000.; //MeV
float min_Mbc=1700.;
float max_Mbc=1900.;
float min_dE=-300.;
float max_dE=300.;
float eclsCut=1000.;
//2016-17
float rrCut=0.75;
float zCut=13.;
float max_chi2=80.;
float min_nhits=10.;
float tofCut=-1.0;
/*
//2004
float rrCut=0.5;
float zCut=12;
float max_chi2=50;
float min_nhits=24;
float tofCut=-0.8;
*/

#endif
