#include <stdio.h>
#include <iostream.h>
#include <unistd.h>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <algorithm>    // std::min_element, std::max_element
#include <getopt.h>
#include <math.h>
#include <cfortran.h>

#include "TTree.h"
#include "TFolder.h"
#include "TH1.h"
#include "TBranch.h"
#include "TFile.h"
#include "TGraphErrors.h"
#include "TBenchmark.h"

#include "ReadNat/kcalls.h"
#include "ReadNat/rr_def.h"
#include "ReadNat/re_def.h"
#include "ReadNat/ss_def.h"
#include "ReadNat/mc_def.h"
#include "ReadNat/trg_argmask_c.h"
#include "ReadNat/trg_df.h"
#include "ReadNat/read_nat_c.h"

#include "VDDCRec/kdcvd.h"
#include "VDDCRec/ktracks.h"
#include "VDDCRec/khits.h"
#include "VDDCRec/kdcswitches.h"
#include "VDDCRec/kedr_trigger.h"
#include "VDDCRec/ksettrgdb.h"
#include "VDDCRec/kdcvd.h"
#include "VDDCRec/ktrkadccharge.h"
#include "KrToF/sc_hits.h"
#include "VDDCRec/kvd.h"
#include "VDDCRec/ktof.h"
#include "VDDCRec/ktracks.h"
#include "VDDCRec/kglobparam.h"
#include "VDDCRec/kdcpar.h"

#include "KrAtc/atcrec.h"
#include "KrAtc/atc_to_track.h"
#include "KrAtc/AtcHit.hh"
#include "KrToF/tof_system.h"
#include "KrToF/tofrec.h"
#include "KsToF/tofsim.h"
#include "KDisplay/kdisplay_event.h"
#include "KEmcRec/emc_system.h"
#include "KrVDDCMu/dcmu.h"
#include "KrMu/mu_system.h"
#include "KrMu/mu_event.h"
#include "KrMu/mu_status.h"
#include "KrMu/mu_res.h"
#include "KrVDDCMu/dcmu.h"

#include "KDB/kdb.h"

#define PI 3.14159265358979
#define THETA_CL_CUT 30.
#define DIST_CL_CUT 20.

using namespace std;

int bad_listtof1[128]=
{
  //1 2 3 4 5 6 7 8 9 10,
    0,0,0,0,0,0,0,0,0,0,
  //11,12,13,14,15,16,17,18,19,20
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //21,22,23,24,25,26,27,28,29,30
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //31,32,33,34,35,36,37,38,39,40
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //41,42,43,44,45,46,47,48,49,50
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //51,52,53,54,55,56,57,58,59,60
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //61,62,63,64,65,66,67,68,69,70
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //71,72,73,74,75,76,77,78,79,80
     0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  //81,82,83,84,85,86,87,88,89,90
     0,0, 0, 0, 0, 0, 0, 0, 0, 0,
  //91,92,93,94,95,96,97,98,99,100
     0, 2, 0,  0,  0, 0, 0, 0, 0, 0,
  //101,102,103,104,105,106,107,108,109,110
     0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  //111,112,113,114,115,116,117,118,119,120
     0, 0,   0,  0,  0,  0,  0,  0,  0,  0,
  //121,122,123,124,125,126,127,128
     0, 0,   0,  0,  0,  0,  0,  0
};

extern "C" void kedr_trigger_print_(int *mode);

static TTree *eventTree;

typedef struct {
    Int_t charge1,charge2,vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo;
    Float_t Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,e2,d1,d2,rr1,rr2,
	zip1,zip2,x0t1,y0t1,z0t1,x0t2,y0t2,z0t2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2;
} BhaBha;

static BhaBha bhabha;

int numn, numo;
double enn, eno, pxn, pxo, pyn, pyo, pzn, pzo;
double ebeam;

static int last_event=0;
static float lum_e=0, lum_p=0;
float beam_energy=0;
float err_beam_energy=0;
static float dbbeam_energy=0;

//Get last valid event and RDM energy for the run from DB
static bool get_run_data(int run)
{
	static const int lum_table_id=2007, lum_table_length=7;
	static const int e_table_id=2119, e_table_length=16;

	bool rc=false;
	last_event=0;
	beam_energy=0;

	int buflum[lum_table_length];
	int bufenergy[e_table_length];

	KDBconn *conn = kdb_open();

	if (!conn) {
		cerr<<"Can not connect to database"<<endl;
		return false;
	}
	if( kdb_read_for_run(conn,lum_table_id,run,buflum,lum_table_length) ) {
		lum_p=buflum[0]*1E-3;
		lum_e=buflum[1]*1E-3;
		last_event=buflum[2];

		rc=true;
	}
	kdb_setver(conn,0);
	if( kdb_read_for_run(conn,e_table_id,run,bufenergy,e_table_length) ) {
		beam_energy=bufenergy[1]*1E-6;
		rc=true;
	}

        //===========================================================
	int RunStatus=1;                                       //0-information in the start run; 1-information in the end run; 2 - information in the pause run
	KDBruninfo runinfo;
	if( kdb_run_get_info(conn,run,RunStatus,&runinfo) ) {
        last_event=runinfo.nread;
        dbbeam_energy=runinfo.E_setup*1E-3;
	rc=true;
	}
        //===========================================================
	kdb_close(conn);

	if( rc )
		cout<<" RUN DB INFO: LastEvent="<<last_event<<", LumP="<<lum_p<<", LumE="<<lum_e<<", Energy="<<beam_energy<<endl;
	else
		cerr<<" No run info in lmrunscan for this run!"<<endl;

	return rc;
}

// Distance of track to cluster (in x,y plane)
double clust_dist(int t, int cl) {
    double cx = semc.emc_x[cl];
    double cy = semc.emc_y[cl];
    double cz = semc.emc_z[cl];

    double tx   = tXc(t);
    double ty   = tYc(t);
    double tr   = tRc(t);

    double r = sqrt(pow(tx-cx,2) + pow(ty-cy,2)) - tr;

    if (fabs(semc.emc_phi[cl]-ktrrec_.FITRAK[t]) < 90. ||
	fabs(semc.emc_phi[cl]-ktrrec_.FITRAK[t] - 360.) < 90. ||
	fabs(semc.emc_phi[cl]-ktrrec_.FITRAK[t] + 360.) < 90. ) {
	return r;
    }
    return sqrt(cx*cx+cy*cy);
}

void neutrals(int *num, double *en, double* px, double* py, double* pz) {
    int cl, t;
    *num = 0;
    *en = 0.;
    *px = 0.;
    *py = 0.;
    *pz = 0.;
    //  printf("ncls=%d\n", semc.emc_ncls);
    for (cl=0; cl<semc.emc_ncls; cl++) {
	int assigned = 0;
	for (t=0; t<eTracksAll; t++) {
	    //      printf("%f %f %f\n", semc.emc_theta[cl], ktrrec_.TETRAK[t],
	    //        clust_dist(t, cl));
	    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t]) < THETA_CL_CUT &&
		fabs(clust_dist(t, cl)) < DIST_CL_CUT) {
		assigned = 1;
	    }
	}
	if (!assigned && semc.emc_energy[cl] > 0.) {
	    //      printf("neutral: %d %f\n", assigned, semc.emc_energy[cl]);
	    (*num)++;
	    *en += semc.emc_energy[cl];
	    *px += semc.emc_energy[cl]*sin(semc.emc_theta[cl]*PI/180.)*cos(semc.emc_phi[cl]*PI/180.);
	    *py += semc.emc_energy[cl]*sin(semc.emc_theta[cl]*PI/180.)*sin(semc.emc_phi[cl]*PI/180.);
	    *pz += semc.emc_energy[cl]*cos(semc.emc_theta[cl]*PI/180.);
	}
    }
    //  printf("numn=%d\n", *num);
}

void others(int t1, int t2, int* num, double *en, double *px, double* py, double* pz) {
    int t, cl;
    *num = 0;
    *en = 0.;
    *px = 0.;
    *py = 0.;
    *pz = 0.;
    for (t=0; t<eTracksAll; t++) if (t != t1 && t != t2 && ktrrec_.PTRAK[t1] > 100.) {
	(*num)++;
	for (cl=0; cl<semc.emc_ncls; cl++) {
	    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t]) < THETA_CL_CUT &&
		fabs(clust_dist(t, cl)) < DIST_CL_CUT) {
		*en += semc.emc_energy[cl];
	    }
	}
	*px += ktrrec_.PTRAK[t1]*sin(ktrrec_.TETRAK[t1]*PI/180.)*cos(ktrrec_.FITRAK[t1]*PI/180.);
	*py += ktrrec_.PTRAK[t1]*sin(ktrrec_.TETRAK[t1]*PI/180.)*sin(ktrrec_.FITRAK[t1]*PI/180.);
	*pz += ktrrec_.PTRAK[t1]*cos(ktrrec_.TETRAK[t1]*PI/180.);
    }
    //  printf("numo=%d\n", *num);
}

int main(int argc,char *argv[]) {
    //default parameters
    int run1=23280,run2=23280,Nevents=1000000,cosmic=0,RecMode=0;
    bool draw=false;
    //for command string arguments
    int iarg;
    //for event reading in and reconstructuion
    char fname[80];
    int openerr,runerr,readerr,closeerr,recselect=0;
    // for access to tracks
    int sim=0;
    int Nsw=1;

    // command string arguments
    for(iarg=1; iarg < argc; iarg++) {
	sscanf(argv[iarg],"-RF%d",&run1);
	sscanf(argv[iarg],"-RL%d",&run2);
	sscanf(argv[iarg],"-N%d",&Nevents);
	sscanf(argv[iarg],"-x%d",&draw);
	sscanf(argv[iarg],"-cosmic%d",&cosmic);
	sscanf(argv[iarg],"-sim%d",&sim);
	sscanf(argv[iarg],"-Nsw%d",&Nsw);
    }

    for(int run=run1; run<=run2; run++)
    {
        TString rootfile;
        int rungood;
        bool goodrun=false;

        /*
	string line;
	ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_2016-17_good.dat");
	if (in.is_open())
	{
	    while (getline(in, line))
	    {
		rungood = atoi(line.c_str());
                if(run==rungood) goodrun=true;
	    }
	}
	in.close();

	if( !sim && !goodrun ) continue;
        */

	if(sim) rootfile="/spool/users/ovtin/bhabha_out_sim.root";
	else rootfile=TString::Format("/spool/users/ovtin/bhabha_out_%d.root",run).Data();
	cout<<"root output file is "<<rootfile<<endl;
        Int_t NumCurrentSim=0;

	//----------------- Initialize ROOT file and trees -----------------//
	TFile *fout=0;
	//Create root file if exclusive event processing is not set
	fout = new TFile(rootfile,"RECREATE");

	eventTree = new TTree("et","Event tree");
	eventTree->SetAutoSave(500000000);  // autosave when 0.5 Gbyte written
	eventTree->Branch("bhabha",&bhabha,"charge1/I:charge2:vrtntrk:vrtnip:vrtnbeam:nhitst1:nhitst2:nhitsvdt1:nhitsvdt2:nhitsxyt1:nhitszt1:nhitsxyt2:nhitszt2:nvect1:nvecxyt1:nveczt1:nvect2:nvecxyt2"
			  ":nveczt2:ncomb:ncls1:ncls2:ncls:nlkr:ncsi:munhits:mulayerhits1:mulayerhits2:mulayerhits3:Run:numn:numo"
			  ":Ebeam/F:rEv:p1:p2:pt1:pt2:chi2t1:chi2t2:theta2t:phi2t:thetat1:thetat2:phit1:phit2:e1"
			  ":e2:d1:d2:rr1:rr2:zip1:zip2:x0t1:y0t1:z0t1:x0t2:y0t2:z0t2:ecls1:ecls2:tcls1:tcls2:pcls1:pcls2:emcenergy:lkrenergy:csienergy:enn:eno:tofc1:ttof1:tofc2:ttof2");

	//kdcswitches_.KtofAllowed=-2;
	//semc_cards.EMC_MASTER=0;
	//kdcswitches_.kCosmInSigRuns = 0;
	//kdcswitches_.kIPalternative = 1;
	//kdcswitches_.KemcAllowed = -1;
        //kdcswitches_.KmuAllowed=1;
 
	kdcswitches_.kXTKey=1;
        kdcswitches_.KcExp=0;       
 
        cout<<"kdcswitches_.kXTKey="<<kdcswitches_.kXTKey<<"\t"<<"kdcswitches_.KcExp="<<kdcswitches_.KcExp<<endl;

	if(sim)
        {
             //tof_initAlternative(bad_listtof1);
             tof_sim();
        }
        else
        {
             tof_init();
        }

	// general initialization
	if(sim)
	{
	    kdcswitches_.KsimSystErr = 1; //or 2
	    //kdcsimxt();
	    //kdcsimsigma();
	    //kdcsimsysterr();               //simulation system. errors of calibration
	    //kdcnosimxt();                    //x(t) is not simulated
	    //kdcsimsigma();                   //call simulation experimental resolution
	    //ksimreal(50,23272,23282);
	    //ksimreal(1,23566,23566);
	    ksimreal(Nsw,run1,run2);
	}
	/*
	 int mode=0;
	 int ierr;
	 kedr_read_trg_("trigger.dat",&ierr,sizeof("trigger.dat"));
	 if(!ierr) {
	 printf("trigger with formula in 'trigger.dat' initialized\n");// take trigger formula from "trigger.dat"
	 mode=1;
	 kedr_trigger_print_(&mode);
	 }else{
	 ksettrgdb(&run);
	 printf("trigger for run %d initialized\n",run);// no file "trigger.dat", take trigger formula from DB
	 }
	 */

	if( cosmic>0 )
	    kdcvdcosmic();
	else if( cosmic==0 )
	    kdcvdnocosmic();

        if(mu_default_init(1))  cout<<"Mu init error"<<endl;
        if(mu_init_status())  cout<<"Mu init status error"<<endl;

	// open run file
	//if(sim)  sprintf(fname,"/spool/users/ovtin/outDmeson/simulation/BhaBha/simee0000020.dat");
	if(sim)  sprintf(fname,"/store/sim/ee/Bhabha/1885/theta-15-165-IPzero-Field6kGs.dat.bz2");
	else    sprintf(fname,"/space/runs/daq%06d.nat",run);

	kedr_open_nat(fname,&openerr);
	if( openerr) {
	    printf("open error for %s\n",fname);
	    exit(1);
	}

        if (!sim){
	    get_run_data(run);
            if(mu_get_db_status(run))  cout<<"Mu status error"<<endl;
            if(mu_get_db_clbr_for_run(run)<0)  cout<<"Mu calib error"<<endl;
	    tof_run(run);
        }

        if( sim && NumCurrentSim!=NSimRun&&NSimRun!=0 )
        {
            tof_run(NSimRun);
            tof_sim_real(NSimRun, 1, 1);
            if(mu_get_db_status(NSimRun))  cout<<"Mu status error"<<endl;
            if(mu_get_db_clbr_for_run(NSimRun)<0)  cout<<"Mu calib error"<<endl;
            NumCurrentSim=NSimRun;
        }

        eNumber=0;

	while(1)
	{
	    // read event
	    kedr_read_nat(&readerr);
	    if(readerr) break;

            kmctracks_();

	    kdcvdrec(RecMode,&recselect);

	    tof_event();
	    //atc_event();

	    if(eNumber%1000==0) cout<<"Ev:"<<eNumber<<endl;

	    double WTotal=2.*beam_energy;
	    if( kedrrun_cb_.Header.RunType == 64 ) {   //for MC
		WTotal=2*1886.75;
	    }
	    ebeam=WTotal/2.;

	    int i=0;

	    if(eTracksAll==2)
	    {                                                          //take only BhaBha events
		//draw event
		if( draw ) kdisplay_event();

		for (int t1 = 0; t1 < eTracksAll; t1++)                                  //cycle for first track
		{
		    for (int t2 = 0; t2 < eTracksAll; t2++)                              //cycle for second track
		    {
			if( tCharge(t1)==-1 && tCharge(t2)==1 )
			{
			    //cout<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"\t"<<"t1="<<t1<<"\t"<<"t2="<<t2<<"\t"<<"tCharge(t1)="<<tCharge(t1)<<"\t"<<"tCharge(t2)="<<tCharge(t2)<<endl;
			    //cout<<"p(t1)="<<tP(t1)<<"\t"<<"p(t2)="<<tP(t2)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<endl;
			    //cout<<"Phit1="<<ktrrec_.FITRAK[t1]+(ktrrec_.FITRAK[t1]<0?360:0)<<"\t"<<"Phit2="<<ktrrec_.FITRAK[t2]+(ktrrec_.FITRAK[t2]<0?360:0)<<"\t"<<"tTeta(t1)="<<tTeta(t1)<<"\t"<<"tTeta(t2)="<<tTeta(t2)<<endl;

			    double xx1=tX0IP(t1)*tX0IP(t1);
			    double yy1=tY0IP(t1)*tY0IP(t1);
			    double rr1=sqrt(xx1+yy1);
			    double xx2=tX0IP(t2)*tX0IP(t2);
			    double yy2=tY0IP(t2)*tY0IP(t2);
			    double rr2=sqrt(xx2+yy2);

			    if ( fabs(tZ0IP(t1))>30. ) continue;
			    if ( fabs(tZ0IP(t2))>30. ) continue;
			    if ( rr1>8 ) continue;
			    if ( rr2>8 ) continue;

			    double d1 = sqrt(pow(tXc(t1),2) + pow(tYc(t1),2)) - tRc(t1);
			    double d2 = sqrt(pow(tXc(t2),2) + pow(tYc(t2),2)) - tRc(t2);
			    /*
			     if( tPt(t1)<=100 || tPt(t1)>=2000 )  continue;
			     if( tCh2(t1)>100 )  continue;
			     if( tHits(t1)<0 )  continue;

			     if( tPt(t2)<=100 || tPt(t2)>=2000 )  continue;
			     if( tCh2(t2)>100 )  continue;
			     if( tHits(t2)<0 )  continue;
			     */
			    bhabha.d1 = d1;
			    bhabha.d2 = d2;
			    bhabha.rr1 = rr1;
			    bhabha.rr2 = rr2;
			    bhabha.zip1 = tZ0IP(t1);
			    bhabha.zip2 = tZ0IP(t2);

			    bhabha.x0t1 = ktrrec_.X0TRAK[t1];
			    bhabha.y0t1 = ktrrec_.Y0TRAK[t1];
			    bhabha.z0t1 = ktrrec_.Z0TRAK[t1];

			    bhabha.x0t2 = ktrrec_.X0TRAK[t2];
			    bhabha.y0t2 = ktrrec_.Y0TRAK[t2];
			    bhabha.z0t2 = ktrrec_.Z0TRAK[t2];

			    bhabha.p1 = tP(t1);
			    bhabha.p2 = tP(t2);

			    bhabha.pt1 = tPt(t1);
			    bhabha.pt2 = tPt(t2);

			    bhabha.chi2t1 = tCh2(t1);
			    bhabha.chi2t2 = tCh2(t2);

			    bhabha.charge1 = ktrrec_.CHTRAK[t1];
			    bhabha.charge2 = ktrrec_.CHTRAK[t2];

			    bhabha.vrtntrk = eTracksAll;
			    bhabha.vrtnip = eTracksIP;
			    bhabha.vrtnbeam = eTracksBeam;

			    //for (eTracksAll=2)
			    bhabha.theta2t=acos(CThe2t)*180./M_PI;
			    bhabha.phi2t=acos(CPhi2t)*180./M_PI;

			    bhabha.thetat1 = tTeta(t1);
			    bhabha.thetat2 = tTeta(t2);

			    bhabha.phit1 = ktrrec_.FITRAK[t1]+(ktrrec_.FITRAK[t1]<0?360:0);
			    bhabha.phit2 = ktrrec_.FITRAK[t2]+(ktrrec_.FITRAK[t2]<0?360:0);

			    bhabha.nhitst1 = tHits(t1);
			    bhabha.nhitst2 = tHits(t2);

			    bhabha.nhitsvdt1 = tHitsVD(t1);
			    bhabha.nhitsvdt2 = tHitsVD(t2);

			    bhabha.nhitsxyt1 = tHitsXY(t1);
			    bhabha.nhitszt1 = tHits(t1)-tHitsXY(t1);

			    bhabha.nhitsxyt2 = tHitsXY(t2);
			    bhabha.nhitszt2 = tHits(t2)-tHitsXY(t2);

			    bhabha.nvect1 = tVectors(t1);
			    bhabha.nvecxyt1 = tVectorsXY(t1);
			    bhabha.nveczt1 = tVectorsZ(t1);

			    bhabha.nvect2 = tVectors(t2);
			    bhabha.nvecxyt2 = tVectorsXY(t2);
			    bhabha.nveczt2 = tVectorsZ(t2);

			    bhabha.ncls=semc.emc_ncls;
			    bhabha.nlkr=emcRec->lkrClusters.size();
			    bhabha.ncsi=emcRec->csiClusters.size();
			    bhabha.emcenergy=0;
			    bhabha.lkrenergy=0;
			    bhabha.csienergy=0;

			    for(int c=0; c<semc.emc_ncls; c++) {
				bhabha.emcenergy+=semc.emc_energy[c];
				if( semc.emc_type[c]==1 )
				    bhabha.lkrenergy+=semc.emc_energy[c];
				else if( semc.emc_type[c]==2 )
				    bhabha.csienergy+=semc.emc_energy[c];
			    }

			    float energy_on_track1=0;
			    int cl_tr1=0;
			    for(int c1=0; c1<semc.dc_emc_ncls[t1]; c1++)                     //dc_emc_ncls[NDCH_TRK] - number clusters for track
			    {
				cl_tr1=semc.dc_emc_cls[t1][c1]-1;                           //dc_emc_cls[NDCH_TRK][NEMC_CLS]-1 - number of clusters on track
				energy_on_track1+=semc.emc_energy[cl_tr1];
			    }
			    float energy_on_track2=0;
			    int cl_tr2=0;
			    for(int c2=0; c2<semc.dc_emc_ncls[t2]; c2++)                     //dc_emc_ncls[NDCH_TRK] - number clusters for track
			    {
				cl_tr2=semc.dc_emc_cls[t2][c2]-1;                           //dc_emc_cls[NDCH_TRK][NEMC_CLS]-1 - number of clusters on track
				energy_on_track2+=semc.emc_energy[cl_tr2];
			    }
			    bhabha.e1 = energy_on_track1;
			    bhabha.e2 = energy_on_track2;
			    //cout<<"bhabha.e1="<<bhabha.e1<<"\t"<<"bhabha.e2="<<bhabha.e2<<endl;

			    bhabha.ecls1=0.;
			    bhabha.ncls1=0;
			    bhabha.ecls2=0.;
			    bhabha.ncls2=0;

			    for (int cl=0; cl<semc.emc_ncls; cl++) {

				if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t1]) < THETA_CL_CUT &&
				    fabs(clust_dist(t1, cl)) < DIST_CL_CUT) {
				    bhabha.ecls1 += semc.emc_energy[cl];
				    bhabha.tcls1 = semc.emc_theta[cl]-ktrrec_.TETRAK[t1];
				    bhabha.pcls1 = clust_dist(t1, cl);
				    bhabha.ncls1++;
				}

				if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t2]) < THETA_CL_CUT &&
				    fabs(clust_dist(t2, cl)) < DIST_CL_CUT) {
				    bhabha.ecls2 += semc.emc_energy[cl];
				    bhabha.tcls2 = semc.emc_theta[cl]-ktrrec_.TETRAK[t2];
				    bhabha.pcls2 = clust_dist(t2, cl);
				    bhabha.ncls2++;
				}
			    }

			    neutrals(&numn, &enn, &pxn, &pyn, &pzn);
			    others(t1, t2, &numo, &eno, &pxo, &pyo, &pzo);

			    bhabha.numn = numn;
			    bhabha.enn = enn;
			    bhabha.numo = numo;
			    bhabha.eno = eno;

			    i++;
			    bhabha.ncomb = i;
			    bhabha.rEv = kedrraw_.Header.Number;
			    bhabha.Run = kedrraw_.Header.RunNumber;
			    bhabha.Ebeam=WTotal/2;

			    int mu_hits = mu_next_event_good();
			    bhabha.munhits = mu_hits;
			    int mu_hit;
			    int mu_layer_hits[3] = {0, 0, 0};

			    for (mu_hit = 0; mu_hit < mu_hits; mu_hit++) {
				int layer = mu_hit_layer(mu_hit);
				if (layer >= 1 && layer <= 3) mu_layer_hits[layer-1]++;
			    }

			    bhabha.mulayerhits1 = mu_layer_hits[0];
			    bhabha.mulayerhits2 = mu_layer_hits[1];
			    bhabha.mulayerhits3 = mu_layer_hits[2];

			    double y1 = cos(kscBhit_.number_B[t1][0]/32.*3.14159265);
			    double y2 = cos(kscBhit_.number_B[t2][0]/32.*3.14159265);

			    if (y1 > y2) {
				bhabha.tofc1 = kscBhit_.number_B[t1][0];
				bhabha.ttof1 = kscBhit_.time_B_ns[t1][0];
				bhabha.tofc2 = kscBhit_.number_B[t2][0];
				bhabha.ttof2 = kscBhit_.time_B_ns[t2][0];
			    } else {
				bhabha.tofc1 = kscBhit_.number_B[t2][0];
				bhabha.ttof1 = kscBhit_.time_B_ns[t2][0];
				bhabha.tofc2 = kscBhit_.number_B[t1][0];
				bhabha.ttof2 = kscBhit_.time_B_ns[t1][0];
			    }

			    eventTree->Fill();
			}

		    }
		}
	    }
	    if( eNumber > Nevents) break;
	}

	kedr_close_nat(&closeerr);

	if( fout ) {
	    fout->Write();
	    fout->Close();
	}

	if(sim) break;
    }

    return 0;

}
