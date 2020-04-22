#ifndef cuts_h
# define cuts_h

//for print DEBUG information
bool verbose=0;
bool verbose1=0;
bool verbose2=0;

int ntrk=2;
int nip=0;
int nbeam=0;
float min_pt=100; //MeV
float max_pt=2000; //MeV
//int min_tot_ncls=2;
//int max_tot_ncls=4;
//int maxmunhits=4;
int min_tot_ncls=0;
int max_tot_ncls=10;
int maxmunhits=8;
int mintofnhits=0;
double minenontrk=0.;     //minimal energy on track
//float min_Mbc=1875;
float min_Mbc=1700;
float max_Mbc=1900;
float min_dE=-300;
float max_dE=300;
float max_chi2=50;
float min_nhits=24;

#endif
