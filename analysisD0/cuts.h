#ifndef cuts_h
# define cuts_h

//for print DEBUG information
bool verbose=0;

int ntrk=3;
//int ntrk=2;
int nip=0;
int nbeam=0;
float min_pt=100; //MeV
float max_pt=2000; //MeV
//int min_tot_ncls=0;
//int max_tot_ncls=30;
int maxmunhits=15; //4
int mintofnhits=0;
double minenontrk=0.;     //minimal energy on track
//float min_Mbc=1875;
float min_Mbc=1700;
float max_Mbc=1900;
float min_dE=-300;
float max_dE=300;
float max_chi2=50;
float min_nhits=24;
//float max_nhits=48;
float max_nhits=100;

#endif
