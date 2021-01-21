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

#include "VDDCRec/kdcvd.h"
#include "VDDCRec/ktracks.h"
#include "VDDCRec/khits.h"
#include "VDDCRec/kdcswitches.h"
#include "KrAtc/atcrec.h"
#include "KrAtc/atc_to_track.h"
#include "KrAtc/AtcHit.hh"
#include "KrToF/tof_system.h"
#include "KrToF/tofrec.h"
#include "KDisplay/kdisplay_event.h"
#include "KEmcRec/emc_system.h"
#include "KrVDDCMu/dcmu.h"
#include "KrMu/mu_system.h"
#include "KrMu/mu_event.h"
#include "KrMu/mu_status.h"
#include "KDB/kdb.h"

#define PI 3.14159265358979
#define THETA_CL_CUT 30.
#define DIST_CL_CUT 20.

using namespace std;

//set selection conditions
//static const struct ProgramParameters def_progpar={false,2,6,1,1,6,100,2000,15,45,2,8,0,0,200,15,"/store/users/ovtin/out.root",0,23682,23943,50,1.,1.,1.,0,0,0,false,0};

//static struct ProgramParameters progpar(def_progpar);

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
/*
static const char* optstring="ra:d:b:p:h:s:j:t:e:c:l:k:i:u:q:o:D:v:m:M:S:A:Z:n:w:g:z:x";

void Usage(int status)
{
	cout.precision(3);
	cout<<"Usage:\n"
		<<progname<<" [OPTIONS] run|nat_file|run_list_file...\n\n"
		<<"Reconstruction of events with VRTX, DC, ATC, TOF, EMC, MU systems.\n"
		<<"Options:\n"
		<<"  -r             Read VDDC&EMC reconstructed info from file (reconstruct by default)\n"
		<<"  -a tracks      Minimum total tracks number required (default to "<<def_progpar.min_track_number<<")\n"
		<<"  -d tracks      Maximum total tracks number required (default to "<<def_progpar.max_track_number<<")\n"
		<<"  -b tracks      Minimum beam tracks number required (default to "<<def_progpar.min_beam_track_number<<")\n"
		<<"  -p tracks      Minumum IP tracks number required (default to "<<def_progpar.min_ip_track_number<<")\n"
		<<"  -h tracks      Maximum IP tracks number required (default to "<<def_progpar.max_ip_track_number<<")\n"
            	<<"  -s Momentum    Lower limit of momentum cut, MeV/c (default: "<<def_progpar.min_momentum<<")\n"
            	<<"  -j Momentum    Maximum limit of momentum cut, MeV/c (default: "<<def_progpar.max_momentum<<")\n"
 	        <<"  -t energy      EMC cluster energy threshold (default to "<<def_progpar.min_cluster_energy<<" MeV)\n"
 		<<"  -e energy      Minumum total energy in EMC (default to "<<def_progpar.min_total_energy<<" MeV)\n"
		<<"  -c clusters    Minumum number of clusters in both calorimeters (default to "<<def_progpar.min_cluster_number<<")\n"
		<<"  -l clusters    Maximum number of clusters in both calorimeters (default to "<<def_progpar.max_cluster_number<<")\n"
		<<"  -k clusters    Minumum number of clusters in LKr calorimeter (default to "<<def_progpar.min_lkrcl_number<<")\n"
		<<"  -i clusters    Minumum number of clusters in CsI calorimeter (default to "<<def_progpar.min_csicl_number<<")\n"
	        <<"  -u max_tchi2   Maximum fit quality on track  (default to "<<def_progpar.max_tchi2<<")\n"
	        <<"  -q min_Nhits   Nininum number hits on track (default to "<<def_progpar.min_Nhits<<")\n"
	        <<"  -o RootFile    Output ROOT file name (default to "<<def_progpar.rootfile<<")\n"
            	<<"  -D simOn       Data or Simulation (default to "<<def_progpar.simOn<<")\n"
            	<<"  -v MCCalibRunNumber    First MCCalibRunNumber (default to "<<def_progpar.MCCalibRunNumber<<")\n"
            	<<"  -m MCCalibRunNumberL   Last MCCalibRunNumberL (default to "<<def_progpar.MCCalibRunNumberL<<")\n"
            	<<"  -M NsimRate    Rate for ksimreal (default to "<<def_progpar.NsimRate<<")\n"
            	<<"  -S Scale       kdcscalesysterr(scale) (default to "<<def_progpar.Scale<<")\n"
            	<<"  -A Ascale      kdcscalesysterraz(ascale, zscale) (default to "<<def_progpar.Ascale<<")\n"
            	<<"  -Z Zscale      kdcscalesysterraz(ascale, zscale) (default to "<<def_progpar.Zscale<<")\n"
            	<<"  -n NEvents     Number events in process "<<def_progpar.NEvents<<"\n"
            	<<"  -w NEvbegin    First event to process "<<def_progpar.NEvbegin<<"\n"
            	<<"  -g NEvend      End event in process "<<def_progpar.NEvend<<"\n"
            	<<"  -z Debug       Print debug information "<<def_progpar.verbose<<"\n"
		<<"  -x             Process the events specified after file exclusively and print debug information"
	    <<endl;
	exit(status);
}
*/
int main(int argc,char *argv[]) {
    /*
    progname=argv[0];
    //if no arguments print usage help
    if( argc==1 ) Usage(0);

    int opt;
    //----------------- Process options -----------------//
    while( (opt=getopt(argc,argv,optstring))>0 ) {
	switch( opt ) {
	case '?': Usage(1); break;
	case 'r': progpar.read_reco=true; break;
	case 'a': progpar.min_track_number=atoi(optarg); break;
	case 'd': progpar.max_track_number=atoi(optarg); break;
	case 'b': progpar.min_beam_track_number=atoi(optarg); break;
	case 'p': progpar.min_ip_track_number=atoi(optarg); break;
	case 'h': progpar.max_ip_track_number=atoi(optarg); break;
	case 's': progpar.min_momentum=atof(optarg); break;
	case 'j': progpar.max_momentum=atof(optarg); break;
	case 't': progpar.min_cluster_energy=atof(optarg); break;
	case 'e': progpar.min_total_energy=atof(optarg); break;
	case 'c': progpar.min_cluster_number=atoi(optarg); break;
	case 'l': progpar.max_cluster_number=atoi(optarg); break;
	case 'k': progpar.min_lkrcl_number=atoi(optarg); break;
	case 'i': progpar.min_csicl_number=atoi(optarg); break;
	case 'u': progpar.max_tchi2=atoi(optarg); break;
	case 'q': progpar.min_Nhits=atoi(optarg); break;
	case 'o': progpar.rootfile=optarg; break;
	case 'D': progpar.simOn=atoi(optarg); break;
	case 'v': progpar.MCCalibRunNumber=atoi(optarg); break;
	case 'm': progpar.MCCalibRunNumberL=atoi(optarg); break;
	case 'M': progpar.NsimRate=atoi(optarg); break;
	case 'S': progpar.Scale=atof(optarg); break;
	case 'A': progpar.Ascale=atof(optarg); break;
	case 'Z': progpar.Zscale=atof(optarg); break;
	case 'n': progpar.NEvents=atoi(optarg); break;
	case 'w': progpar.NEvbegin=atoi(optarg); break;
	case 'g': progpar.NEvend=atoi(optarg); break;
	case 'z': progpar.verbose=atoi(optarg); break;
	case 'x': progpar.process_only=true; break;
	default : Usage(1);
	}
    }
    */
    //default parameters
    int run=23207,Nevents=100,cosmic=0,RecMode=0;
    bool draw=false;
    //for command string arguments
    int iarg;
    //for event reading in and reconstructuion
    char fname[80];
    int openerr,runerr,readerr,closeerr,recselect=0;
    // for access to tracks
    int sim=0;
    // command string arguments
    for(iarg=1; iarg < argc; iarg++) {
	sscanf(argv[iarg],"-R%d",&run);
	sscanf(argv[iarg],"-N%d",&Nevents);
	sscanf(argv[iarg],"-x%d",&draw);
	sscanf(argv[iarg],"-cosmic%d",&cosmic);
	sscanf(argv[iarg],"-sim%d",&sim);
    }

    //----------------- Initialize ROOT file and trees -----------------//
    TFile *fout=0;
    //Create root file if exclusive event processing is not set
    //fout = new TFile(progpar.rootfile,"RECREATE");
    fout = new TFile("/spool/users/ovtin/out_test.root","RECREATE");

    eventTree = new TTree("et","Event tree");
    eventTree->SetAutoSave(500000000);  // autosave when 0.5 Gbyte written
    eventTree->Branch("bhabha",&bhabha,"charge1/I:charge2:vrtntrk:vrtnip:vrtnbeam:nhitst1:nhitst2:nhitsvdt1:nhitsvdt2:nhitsxyt1:nhitszt1:nhitsxyt2:nhitszt2:nvect1:nvecxyt1:nveczt1:nvect2:nvecxyt2"
		      ":nveczt2:ncomb:ncls1:ncls2:ncls:nlkr:ncsi:munhits:mulayerhits1:mulayerhits2:mulayerhits3:Run:numn:numo"
		      ":Ebeam/F:rEv:p1:p2:pt1:pt2:chi2t1:chi2t2:theta2t:phi2t:thetat1:thetat2:phit1:phit2:e1"
		      ":e2:d1:d2:rr1:rr2:zip1:zip2:x0t1:y0t1:z0t1:x0t2:y0t2:z0t2:ecls1:ecls2:tcls1:tcls2:pcls1:pcls2:emcenergy:lkrenergy:csienergy:enn:eno:tofc1:ttof1:tofc2:ttof2");

    //semc_cards.EMC_MASTER=0;

    kdcswitches_.KsimSystErr = 2; //or 1
    //kdcswitches_.kCosmInSigRuns = 0;
    //kdcswitches_.kIPalternative = 1;
    ///kdcswitches_.KemcAllowed = -1;

    // general initialization
    if(sim)
    {
/*	kdcsimxt();
	kdcsimsigma();
	kdcsimsysterr();               //simulation system. errors of calibration
*/	
	ksimreal(50,23272,23282);
    }

    if( cosmic ) {
	puts("cosmic ray reconstruction");
	kdcvdcosmic();
    }
    // open run file
    //if(sim)  sprintf(fname,"/space/sim/archive/olddata/sim%06d.dat",run);
    //if(sim)  sprintf(fname,"/spool/users/ovtin/outDmeson/simulation/BhaBha/simee000001.dat");
    if(sim)  sprintf(fname,"/spool/users/ovtin/simDmeson000021.dat");
    else    sprintf(fname,"/space/runs/daq%06d.nat",run);
    tof_init();
    emc_init();
    atc_init();

    kedr_open_nat(fname,&openerr);
    if( openerr) {
	printf("open error for %s\n",fname);
	exit(1);
    }

    get_run_data(run);
    tof_run(run);
    emc_run(run, 0);
    atc_run(run);

    while(1)
    {
	// read event
	kedr_read_nat(&readerr);
	if(readerr) break;

	// event reconstruction
	kdcvdrec(RecMode,&recselect);
	tof_event();
	emc_event();
	atc_event();

	if(eNumber%1000==0) cout<<"Ev:"<<eNumber<<endl;

	double WTotal=2.*beam_energy;
	if( kedrrun_cb_.Header.RunType == 64 ) {   //for MC
	    WTotal=2*1886.75;
	}
	ebeam=WTotal/2.;

        int i=0;

	if(eTracksAll==2) {                                                          //take only BhaBha events
	    //draw event
	    if( draw ) kdisplay_event();

	    for (int t1 = 0; t1 < eTracksAll; t1++)                                  //cycle for first track
	    {
		for (int t2 = 0; t2 < eTracksAll; t2++)                              //cycle for second track
		{
		    if( tCharge(t1)==-1 && tCharge(t2)==1 )
		    {
		        //cout<<"p(t1)="<<tP(t1)<<"\t"<<"p(t2)="<<tP(t2)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<endl;

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

			//if (progpar.verbose) cout<<"i="<< i<<endl;
			//if (progpar.verbose) cout<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"Ebeam="<<WTotal/2<<"\t"<<"t1="<<t1<<"\t"<<"t2="<<t2<<"\t"<<"tCharge(t1)="<<tCharge(t1)<<"\t"<<"tCharge(t2)="<<tCharge(t2)<<endl;
			//if (progpar.verbose) cout<<"p(t1)="<<tP(t1)<<"\t"<<"p(t2)="<<tP(t2)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<endl;

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

    return 0;

}
