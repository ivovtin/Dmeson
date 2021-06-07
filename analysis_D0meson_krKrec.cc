#include <unistd.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <algorithm>    // std::min_element, std::max_element
#include <getopt.h>

#include <stdio.h>
#include <math.h>
#include <cfortran.h>

#include "ReadNat/rr_def.h"
#include "ReadNat/re_def.h"
#include "ReadNat/ss_def.h"
#include "VDDCRec/ktracks.h"
#include "VDDCRec/mtofhits.h"
#include "VDDCRec/ToFTrack.hh"
#include "KrToF/tof_system.h"
#include "KEmcRec/emc_struct.h"
#include "KrAtc/atcrec.h"
#include "KrAtc/atc_to_track.h"
#include "KrVDDCMu/dcmu.h"
#include "KrMu/mu_system.h"
#include "KrMu/mu_event.h"

#include "TTree.h"
#include "TFolder.h"
#include "TH1.h"
#include "TBranch.h"
#include "TFile.h"
#include "TGraphErrors.h"
#include "TBenchmark.h"

#include "KaFramework/kframework.h"
#include "KaFramework/eventbr.h"
#include "KaFramework/vddcbr.h"
#include "KaFramework/emcbr.h"
#include "KaFramework/atcbr.h"
#include "KaFramework/tofbr.h"
#include "KaFramework/mubr.h"
#include "KrAtc/AtcHit.hh"

#include "VDDCRec/kdcswitches.h"
#include "VDDCRec/kdcvd.h"
#include "VDDCRec/kvd.h"
#include "VDDCRec/kdcpar.h"
#include "VDDCRec/ktracks.h"
#include "VDDCRec/khits.h"
#include "VDDCRec/tfit.h"
#include "VDDCRec/ktrkhits.h"
#include "VDDCRec/ktrkfpar.h"
#include "VDDCRec/kglobparam.h"
#include "ReadNat/mcdc_def.h"
#include "ReadNat/dcrawhitspar.h"
//#include "KDisplay/kdisplay_event.h"
//#include "KrdEdxPId/KrdEdxPId.hh"
//#include "ReadNat/mc_def.h"
#include "KEmcRec/emc_system.h"
#include "KEmcRec/emc_struct.h"
//#include "ReadNat/mccardindex.h"
//#include "ReadNat/mccard_def.h"
//#include "KrMu/mu_system.h"
#include "KrKRec/KFitOutMultiCPi0Gamma.h"
#include "KrKRec/RecKFitMultiCPi0Gamma.hh"

#include "KcSys/fortran.h"

//#include <minuit.h>
//#include <kernlib.h>
//#include <hbook.h>
#include "TMinuit.h"
#include "TRandom3.h"

#define PI 3.14159265358979
#define THETA_CL_CUT 30.
#define DIST_CL_CUT 20.

using namespace std;
// data need to be globals to be visible by fcn
TRandom3 rndm;

static const char* progname;

struct ProgramParameters {
	bool read_reco;
	int min_track_number;                 //minimal number of tracks
	int max_track_number;                 //maximal number of tracks
	int min_beam_track_number;            //minimal number of beam tracks
	int min_ip_track_number;              //minimal number of tracks form IP
	int max_ip_track_number;              //maximal number of tracks form IP
        float min_momentum;                   //minimal transverse momentum
        float max_momentum;                   //maximal transverse momentum
	float min_cluster_energy; //MeV       //minimal energy of cluster
	float min_total_energy; //MeV         //minimal total energy
	int min_cluster_number;               //minimal number of clusters with energy large minimal
	int max_cluster_number;               //maximal number of clusters with energy large minimal
	int min_lkrcl_number;                 //minimal number of clusters in LKr
	int min_csicl_number;                 //minimal number of clusters in CsI
        float max_tchi2;                      //fit quality
        float min_Nhits;                      //number hits on track
	const char* rootfile;
	bool simOn;                           //0 - Data, 1 - Simulation
	int MCCalibRunNumber;                 //19862 - number of run - download from DB calibration for processe MC-file in runs interval
	int MCCalibRunNumberL;                //for ksimreal(NevRate,NumFirstExpRun,NumLastExpRun);
        int NsimRate;                         //for ksimreal(NevRate,NumFirstExpRun,NumLastExpRun);
        float Scale;
        float Ascale;
        float Zscale;
	int NEvents;                          //number of processed events
	int NEvbegin;
	int NEvend;
        float pSF;                            //momentum correction
	int Dkine_fit;                       //perfome kinematic fit
        int verbose;                         //print debug information
	bool process_only;                    //process one event only
};
//=======================================================================================================================================
//Selection conditions:
//1)minimal number of tracks 2 (2K and 2pi)
//2)maximal number of tracks 6
//3)minimal number of beam tracks 1
//4)minimal number of tracks form IP 1
//5)maximal number of tracks form IP 6
//6)minimal transverse momentum 100 МэВ/c
//6)maximal transverse momentum 2000 МэВ/c
//7)minimal energy of cluster 15 GeV
//8)sum ennergy on all clusters large 45 MeV
//9)minimal number of clusters with energy large minimal 2
//10)maximal number of clusters with energy large minimal 8
//11) tChi2<200 - fit quality
//12) number hits on track Nhits>15

//....
//10)tracks from VRTX tVertex(t)==1
////11)central tracks 	fabs(tX0(t)-eVertexX)<1 && fabs(tY0(t)-eVertexY)<1 && fabs(tZ0(t)-eVertexZ)<15 )
//=======================================================================================================================================

//set selection conditions
static const struct ProgramParameters def_progpar={false,2,6,1,1,6,100,2000,15,45,2,8,0,0,200,15,"/store/users/ovtin/out.root",0,23682,23943,50,1.,1.,1.,0,0,0,1.0,0,false,0};

static struct ProgramParameters progpar(def_progpar);

enum {
	CutEvents=1,
	CutLongDcRecord=1,
	CutLongVdRecord,
        AtcEventDamageCut,
        AtcIllegalTrackCut,
	CutTrackNumberMin,
	CutTrackNumberMax,
	CutBeamTrackNumber,
	CutIPTrackNumber_min,
	CutIPTrackNumber_max,
        Cut_CPhi2t,
	Cut_CThe2t,
        EMCthetaCut,
	CutTotalEnergy,
        CutClusterEnergy,
	CutMINClusterNumber,
	CutMAXClusterNumber,
	CutLkrClusterNumber,
	CutCsiClusterNumber,
        Cut_nclntrack,
	OneTrackCut,
	MinMomentumCut,
	MaxMomentumCut,
	NotVertex,
	ChargeCut,
	VectorsZCut,
        HitsVDCut,
	MinXYVectorsCut,
	Chi2Cut,
        tHitsCut,
	tX0Cut,
	tY0Cut,
	tZ0Cut,
        TofCut,
        MUCut,
};

static TTree *eventTree;

typedef struct {
    Int_t vrtntrk,vrtnip,vrtnbeam,ncomb,nhitsdc,nhitst1,nhitst2,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    nveczt2,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],
    aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20];
    Float_t mbc,de,dp,Mpart1,Ppart1,Mpart2,Ppart2,fchi2,Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,
	e2,rr1,rr2,zip1,zip2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,tofc1,ttof1,tofc2,ttof2,atcNpet1[20],atcTotalNpet1,
    atcNpet2[20],atcTotalNpet2,tlent1[20],tlent2[20];
} DMESON;

static DMESON Dmeson;

double mk = 493.68;
double mpi = 139.57;

int listtr[20],lclpi0[8],lclg[5];

int dcand_t1;
int dcand_t2;
double ebeam;

//Rejection prior to reconstruction helps to save CPU time
extern "C" void kemc_energy_(float Ecsi[2],float *Elkr);

int pre_event_rejection()
{
    //maximum track number supposed to be 7
    //maximum record size for DC: Ntracks*maxNhits*HitLength + 10% (spare)
    static const int maxDClen=1940; //=1940
    //maximum record size for VD: Ntracks*maxNhits*Length + 2 (for dT) + 10% (spare)
    static const int maxVDlen=156; //=156

    //if( RawLength(SS_DC)>maxDClen ) return CutLongDcRecord; //too long DC event
    //if( RawLength(SS_VD)>maxVDlen ) return CutLongVdRecord; //too long VD event
    if ( progpar.NEvend!=0 ){
	if ( kedrraw_.Header.Number <= progpar.NEvbegin )    return CutEvents;
	if ( kedrraw_.Header.Number > progpar.NEvend-1 )     return CutEvents;
    }

    return 0;
}

int vddc_event_rejection()
{
    if( eTracksAll<progpar.min_track_number )       return CutTrackNumberMin;
    if( eTracksAll>progpar.max_track_number )       return CutTrackNumberMax;
    if( eTracksBeam<progpar.min_beam_track_number ) return CutBeamTrackNumber;
    if( eTracksIP<progpar.min_ip_track_number )     return CutIPTrackNumber_min;
    if( eTracksIP>progpar.max_ip_track_number )     return CutIPTrackNumber_max;

    /*
    double charge=0;
    for (int t = 0; t< eTracksAll; t++) {
	if( tPt(t)<=progpar.min_momentum )  return MinMomentumCut;
	if( tPt(t)>=progpar.max_momentum )  return MaxMomentumCut;
	if( tCh2(t)>progpar.max_tchi2 )  return Chi2Cut;
	if( tHits(t)<progpar.min_Nhits )  return tHitsCut;
	//charge += tCharge(t);
    }
    //if( (charge)!=0 )  return ChargeCut;   //if sum charge of tracks do not equal 0 then delete event
    */
    return 0;
}

int tof_event_rejection()
{
    //if( kschit_.time_ns[0]<-4 || kschit_.time_ns[0]>4)         return TofCut;
    //if( kschit_.time_ns[1]<-4 || kschit_.time_ns[1]>4)         return TofCut;

    return 0;
}

int emc_event_rejection()
{
    int nemc=0, nlkr=0, ncsi=0;
    float tot_energy=0;
    int nclntrack=0;

    for (int t = 0; t< eTracksAll; t++) {
	float energy_on_track=0;
	int cl_tr=0;
	for(int c=0; c<semc.dc_emc_ncls[t]; c++)                     //dc_emc_ncls[NDCH_TRK] - number clusters for track
	{
	    cl_tr=semc.dc_emc_cls[t][c]-1;                           //dc_emc_cls[NDCH_TRK][NEMC_CLS]-1 - number of clusters on track
	    energy_on_track+=semc.emc_energy[cl_tr];
            if(progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"t="<<t<<"\t"<<"cl_tr="<<cl_tr<<"\t"<<"energy_on_track="<<energy_on_track<<endl;
	}
	if( energy_on_track<progpar.min_cluster_energy )             //if energy cluster large setup minimal energy
	{
	    //return CutClusterEnergy;
	}
	if( semc.dc_emc_ncls[t]<1 )                                 //if track do not have cluster - cut event
	{
	    //return Cut_nclntrack;
	}
    }

    for(int c=0; c<semc.emc_ncls; c++) {                             //cycle for number of clusters in calorimetr
	tot_energy+=semc.emc_energy[c];                              //energy deposit in calorimetr

	if ( semc.emc_dc_ntrk[c]==1 )                                //number clusters which connected with track     //semc.dc_emc_ncls[t]
	{
	    nclntrack++;                                             //sum on all tracks
	}
	nemc++;                                                      //number clusters with energy large minimal
	if( semc.emc_type[c]==1 )
	    nlkr++;
	else
	    ncsi++;
	//semc.emc_theta[c];                                             //angle theta (degree)
	//if(semc.emc_theta[c]<20 || semc.emc_theta[c]>31 || semc.emc_theta[c]<39 || semc.emc_theta[c]>141 || semc.emc_theta[c]<149 || semc.emc_theta[c]>160) return EMCthetaCut;
    }

    //if( tot_energy<progpar.min_total_energy )           return CutTotalEnergy;
    //if( nemc<progpar.min_cluster_number )               return CutMINClusterNumber;
    //if( nemc>progpar.max_cluster_number )               return CutMAXClusterNumber;
    //if( nlkr<progpar.min_lkrcl_number )                 return CutLkrClusterNumber;
    //if( ncsi<progpar.min_csicl_number )                 return CutCsiClusterNumber;

    return 0;
}

int atc_rejection()
{
    //ATC raw record damaged in any way (including when DeltaT is absent or out of range)
    //if( atc_rec.eventdamage ) return AtcEventDamageCut;

    //track determined as illegal by atcrec
    //if( atc_track.illtrack[0] ) return AtcIllegalTrackCut;

    //no counters on tracks, very strange if occurs
    //if( atc_track.ncnt_on_track[0]==0 ) return NoAtcOnTrackCut;

    return 0;
}

int mu_event_rejection()
{
    //if( mu_next_event()>0 ) return MUCut;           //for delete cosmic events

    return 0;
}

double pcorr(double p) {
    double pc = p*fabs(progpar.pSF);
    if (progpar.verbose==3) cout<<"pc="<<pc<<"\t"<<"p="<<p<<"\t"<<"progpar.pSF="<<progpar.pSF<<endl;

    return fabs(pc);
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


int analyse_event()
{
    float EMinPhot=progpar.min_cluster_energy;
    double WTotal=2.*beam_energy;
    if( kedrrun_cb_.Header.RunType == 64 ) {   //for MC
	WTotal=2*1886.75;
    }
    ebeam=WTotal/2.;

    if (progpar.verbose) cout<<"RunNumber="<<kedrraw_.Header.RunNumber<<"\t"<<"Ebeam="<<WTotal/2<<endl;
    if (progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<"\t"<<"eTracksBeam="<<eTracksBeam<<"\t"<<"eTracksIP="<<eTracksIP<<endl;

    //=================================================================================================
    //kinematic reconstruction  - KrKRec
    int ntrfromip=0;
    for(int i=0;i<eTracksAll;i++){
	double xx=tX0IP(i)*tX0IP(i);
	double yy=tY0IP(i)*tY0IP(i);
	double rr=sqrt(xx+yy);

        cout<<"idt="<<i<<"\t"<<"charge="<<tCharge(i)<<"\t"<<"rr="<<rr<<"\t"<<"z="<<tZ0IP(i)<<endl;

	//if( rr<=20 ) {
	if( rr<=0.5 && fabs(tZ0IP(i))<10. ) {
	    ntrfromip++;
	    if(ntrfromip<=20){
		listtr[ntrfromip-1]=i+1;
	    }
	}
    }

    if (progpar.verbose) cout<<"semc.emc_ncls="<<semc.emc_ncls<<endl;

    int nclnft=0;
    for(int cl=0; cl<semc.emc_ncls; cl++)
    {
	if (progpar.verbose) cout<<"cl="<<cl<<endl;
	if(semc.emc_dc_ntrk[cl] == 0 && semc.emc_energy[cl]>EMinPhot){
	    if (progpar.verbose) cout<<"semc.emc_dc_ntrk[cl]="<<semc.emc_dc_ntrk[cl]<<"\t"<<"cl="<<cl<<endl;
	    nclnft++;
	    if(nclnft<=8) {
		lclpi0[nclnft-1]=cl+1;
	    }
	}
    }

    int qst=0;
    //int ntracks=eTracksAll;
    int ntracks=ntrfromip;
    lclg[nclnft-1]=lclpi0[nclnft-1];

    double Mpart[20];
    double Ppart[20];

    //for( int ng=0; ng<nclnft; ng++ )
    for( int ng=0; ng<1; ng++ )
    {
	//for( int npi0=0; npi0<nclnft; npi0++ )
	for( int npi0=0; npi0<1; npi0++ )
	{
	    reckfitmulticpi0gamma(&WTotal,&ntracks,&npi0,&ng,listtr,lclpi0,lclg,&qst);

	    if (progpar.verbose) cout<<"Event="<<eDaqNumber<<"\t"<<"ntracks="<<ntracks<<"\t"<<"ng="<<ng<<"\t"<<"npi0="<<npi0<<endl;
	    if (progpar.verbose) cout<<"qst:"<<qst<<endl;
	    if (progpar.verbose) cout<<"NumOfHyp:"<<hNumOfHyp<<endl;

	    if(qst>=0){
		if (progpar.verbose) cout<<"NumOfHyp:"<<hNumOfHyp<<endl;
		float minhHchi2=10000.;
		for(int ih=0; ih<hNumOfHyp; ih++){
		    if (progpar.verbose) cout<<"chi2:"<<hHChi2(ih)<<endl;
		    int ii1=0, ii2=0;
		    for(int idtr1=0; idtr1<ntracks; idtr1++){
                        int it=listtr[idtr1]-1;
			if (progpar.verbose) cout<<"track:"<<it<<"  Mass:"<<hMPc(ih,it)<<"  P:"<<hPPc(ih,it)<<"\t"<<"tP(t)="<<tP(it)<<"\t"<<"tCharge="<<tCharge(it)<<endl;
			if( (hMPc(ih,it)>493.0 && hMPc(ih,it)<494.0) && tCharge(it)<0 )
			{
			    ii1++;
			}
			if( (hMPc(ih,it)>139.0 && hMPc(ih,it)<140.0) && tCharge(it)>0 )
			{
			    ii2++;
			}
		    }
		    if( ii1>0 && ii2>0 && hHChi2(ih)<minhHchi2 ){
			minhHchi2=hHChi2(ih);
                        for(int idtr2=0; idtr2<ntracks; idtr2++)
			{
			    int i=listtr[idtr2]-1;
			    Ppart[i]=hPPc(ih,i);
			    Mpart[i]=hMPc(ih,i);
			}
		    }
		}
		if(hNumOfHyp>0)
		{
		    int comb=0;

		    for (int tr1 = 0; tr1 < ntracks; tr1++)                                  //cycle for first track
		    {
			int t1=listtr[tr1]-1;

			for (int tr2 = 0; tr2 < ntracks; tr2++)                              //cycle for second track
			{
			    int t2=listtr[tr2]-1;

			    if( ((Mpart[t1]>493.0 && Mpart[t1]<494.0) && tCharge(t1)==-1 ) && ((Mpart[t2]>139.0 && Mpart[t2]) && tCharge(t2)==1) )  //condition for part1: K-(pi-), part2: pi+(K+)    (D0->K-pi+)
			    {
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

				if( tPt(t1)<=progpar.min_momentum || tPt(t1)>=progpar.max_momentum )  continue;
				if( tCh2(t1)>progpar.max_tchi2 )  continue;
				if( tHits(t1)<progpar.min_Nhits )  continue;

				if( tPt(t2)<=progpar.min_momentum || tPt(t2)>=progpar.max_momentum )  continue;
				if( tCh2(t2)>progpar.max_tchi2 )  continue;
				if( tHits(t2)<progpar.min_Nhits )  continue;

				comb++;
				Dmeson.ncomb = comb;

				Dmeson.rr1 = rr1;
				Dmeson.rr2 = rr2;
				Dmeson.zip1 = tZ0IP(t1);
				Dmeson.zip2 = tZ0IP(t2);

				if (progpar.verbose) cout<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"Ebeam="<<WTotal/2<<"\t"<<"t1="<<t1<<"\t"<<"t2="<<t2<<"\t"<<"tCharge(t1)="<<tCharge(t1)<<"\t"<<"tCharge(t2)="<<tCharge(t2)<<endl;
				if (progpar.verbose) cout<<"p(t1)="<<tP(t1)<<"\t"<<"p(t2)="<<tP(t2)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<endl;
				if (progpar.verbose) cout<<"ktrrec_.PTRAK[t1]="<<ktrrec_.PTRAK[t1]<<"\t"<<"ktrrec_.PTRAK[t2]="<<ktrrec_.PTRAK[t2]<<"\t"<<endl;

				Dmeson.p1 = tP(t1);
				Dmeson.p2 = tP(t2);
				Dmeson.pt1 = tPt(t1);
				Dmeson.pt2 = tPt(t2);

				Dmeson.chi2t1 = tCh2(t1);
				Dmeson.chi2t2 = tCh2(t2);

				Dmeson.vrtntrk = eTracksAll;
				Dmeson.vrtnip = eTracksIP;
				Dmeson.vrtnbeam = eTracksBeam;

				//for (eTracksAll=2)
				Dmeson.theta2t=acos(CThe2t)*180./M_PI;
				Dmeson.phi2t=acos(CPhi2t)*180./M_PI;

				Dmeson.thetat1 = tTeta(t1);
				Dmeson.thetat2 = tTeta(t2);

				Dmeson.phit1 = ktrrec_.FITRAK[t1]+(ktrrec_.FITRAK[t1]<0?360:0);;
				Dmeson.phit2 = ktrrec_.FITRAK[t2]+(ktrrec_.FITRAK[t2]<0?360:0);;

				Dmeson.nhitsvd=kvdrec_.NHITVD;
				Dmeson.nhitsdc=kdcrec_.NHIT;

				Dmeson.nhitst1 = tHits(t1);
				Dmeson.nhitst2 = tHits(t2);

				Dmeson.nhitsvdt1 = tHitsVD(t1);
				Dmeson.nhitsvdt2 = tHitsVD(t2);

				Dmeson.nhitsxyt1 = tHitsXY(t1);
				Dmeson.nhitszt1 = tHits(t1)-tHitsXY(t1);

				Dmeson.nhitsxyt2 = tHitsXY(t2);
				Dmeson.nhitszt2 = tHits(t2)-tHitsXY(t2);

				Dmeson.nvect1 = tVectors(t1);
				Dmeson.nvecxyt1 = tVectorsXY(t1);
				Dmeson.nveczt1 = tVectorsZ(t1);

				Dmeson.nvect2 = tVectors(t2);
				Dmeson.nvecxyt2 = tVectorsXY(t2);
				Dmeson.nveczt2 = tVectorsZ(t2);

				Dmeson.ncls=semc.emc_ncls;
				Dmeson.nlkr=emcRec->lkrClusters.size();
				Dmeson.ncsi=emcRec->csiClusters.size();
				Dmeson.emcenergy=0;
				Dmeson.lkrenergy=0;
				Dmeson.csienergy=0;

				for(int c=0; c<semc.emc_ncls; c++) {
				    Dmeson.emcenergy+=semc.emc_energy[c];
				    if( semc.emc_type[c]==1 )
					Dmeson.lkrenergy+=semc.emc_energy[c];
				    else if( semc.emc_type[c]==2 )
					Dmeson.csienergy+=semc.emc_energy[c];
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
				Dmeson.e1 = energy_on_track1;
				Dmeson.e2 = energy_on_track2;
				if (progpar.verbose) cout<<"Dmeson.e1="<<Dmeson.e1<<"\t"<<"Dmeson.e2="<<Dmeson.e2<<endl;

				Dmeson.ecls1=0.;
				Dmeson.ncls1=0;
				Dmeson.ecls2=0.;
				Dmeson.ncls2=0;

				for (int cl=0; cl<semc.emc_ncls; cl++) {

				    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t1]) < THETA_CL_CUT &&
					fabs(clust_dist(t1, cl)) < DIST_CL_CUT) {
					Dmeson.ecls1 += semc.emc_energy[cl];
					Dmeson.tcls1 = semc.emc_theta[cl]-ktrrec_.TETRAK[t1];
					Dmeson.pcls1 = clust_dist(t1, cl);
					Dmeson.ncls1++;
				    }

				    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t2]) < THETA_CL_CUT &&
					fabs(clust_dist(t2, cl)) < DIST_CL_CUT) {
					Dmeson.ecls2 += semc.emc_energy[cl];
					Dmeson.tcls2 = semc.emc_theta[cl]-ktrrec_.TETRAK[t2];
					Dmeson.pcls2 = clust_dist(t2, cl);
					Dmeson.ncls2++;
				    }
				}

				double theta1 = ktrrec_.TETRAK[t1]/180.*PI;
				double phi1 = ktrrec_.FITRAK[t1]/180.*PI;
				double theta2 = ktrrec_.TETRAK[t2]/180.*PI;
				double phi2 = ktrrec_.FITRAK[t2]/180.*PI;

				double px1 = Ppart[t1]*sin(theta1)*cos(phi1);
				double py1 = Ppart[t1]*sin(theta1)*sin(phi1);
				double pz1 = Ppart[t1]*cos(theta1);

				double px2 = Ppart[t2]*sin(theta2)*cos(phi2);
				double py2 = Ppart[t2]*sin(theta2)*sin(phi2);
				double pz2 = Ppart[t2]*cos(theta2);

				double mbc = ebeam*ebeam - pow(px1+px2,2) - pow(py1+py2,2) - pow(pz1+pz2,2);

				if (mbc>0) mbc = sqrt(mbc); else mbc = 0;

				double mk = 493.68;
				double mpi = 139.57;

				//double de = sqrt(mk*mk + Ppart[t1]*Ppart[t1]) + sqrt(mpi*mpi + Ppart[t2]*Ppart[t2]) - ebeam;
				double de = (sqrt(mpi*mpi + tP(t1)*tP(t1)) + sqrt(mk*mk + tP(t2)*tP(t2)) + sqrt(mpi*mpi + tP(t2)*tP(t2)) + sqrt(mk*mk + tP(t1)*tP(t1)))/2. - ebeam;

				double dp = Ppart[t1]-Ppart[t2];

				if (progpar.verbose) cout<<"Selected hyp:"<<"\t"<<"minhHChi2(ih)="<<minhHchi2<<endl;
				if (progpar.verbose) cout<<"Mpart1="<<Mpart[t1]<<"\t"<<"Ppart1="<<Ppart[t1]<<"\t"<<"Mpart2="<<Mpart[t2]<<"\t"<<"Ppart2="<<Ppart[t2]<<endl;
				if (progpar.verbose) cout<<"mbc="<<mbc<<"\t"<<"de="<<de<<"\t"<<"dp="<<dp<<endl;

				Dmeson.fchi2=minhHchi2;

				Dmeson.Mpart1=Mpart[t1];
				Dmeson.Ppart1=Ppart[t1];

				Dmeson.Mpart2=Mpart[t2];
				Dmeson.Ppart2=Ppart[t2];

				Dmeson.mbc=mbc;
				Dmeson.de=de;
				Dmeson.dp=dp;

				Dmeson.rEv = kedrraw_.Header.Number;
				Dmeson.Run = kedrraw_.Header.RunNumber;
				Dmeson.Ebeam=WTotal/2;

				int mu_hits = mu_next_event_good();
				Dmeson.munhits = mu_hits;
				int mu_hit;
				int mu_layer_hits[3] = {0, 0, 0};         //hits in each layer of mu system  - all 3 layer

				for (mu_hit = 0; mu_hit < mu_hits; mu_hit++) {
				    int layer = mu_hit_layer(mu_hit);
				    if (layer >= 1 && layer <= 3) mu_layer_hits[layer-1]++;
				}

				Dmeson.mulayerhits1 = mu_layer_hits[0];
				Dmeson.mulayerhits2 = mu_layer_hits[1];
				Dmeson.mulayerhits3 = mu_layer_hits[2];

				double y1 = cos(kscBhit_.number_B[t1][0]/32.*3.14159265);
				double y2 = cos(kscBhit_.number_B[t2][0]/32.*3.14159265);

				if (y1 > y2) {
				    Dmeson.tofc1 = kscBhit_.number_B[t1][0];
				    Dmeson.ttof1 = kscBhit_.time_B_ns[t1][0];
				    Dmeson.tofc2 = kscBhit_.number_B[t2][0];
				    Dmeson.ttof2 = kscBhit_.time_B_ns[t2][0];
				} else {
				    Dmeson.tofc1 = kscBhit_.number_B[t2][0];
				    Dmeson.ttof1 = kscBhit_.time_B_ns[t2][0];
				    Dmeson.tofc2 = kscBhit_.number_B[t1][0];
				    Dmeson.ttof2 = kscBhit_.time_B_ns[t1][0];
				}

				atc_to_track(t1);
				if (progpar.verbose) cout<<"t1="<<t1<<"\t"<<"atctrackinfo.ncnt="<<atctrackinfo.ncnt<<endl;
				float totalNpe1=0;
				int cnt;
				Dmeson.natccrosst1=atctrackinfo.ncnt;
				for(int i=0; i<atctrackinfo.ncnt; i++)
				{
				    Dmeson.atcCNTt1[i]=atctrackinfo.cnt[i];
				    cnt=atctrackinfo.cnt[i];
				    Dmeson.atcNpet1[i]=atctrackinfo.npe[cnt];

				    Dmeson.tlent1[i]=atctrackinfo.tlen[cnt];
				    Dmeson.wlshitt1[i]=atctrackinfo.wlshit[cnt];
				    Dmeson.nearwlst1[i]=atctrackinfo.nearwls[cnt];

				    Dmeson.aerogel_REGIONt1[i]=atctrackinfo.aerogel_REGION[cnt];
				    Dmeson.aerogel_REGION0t1[i]=atctrackinfo.aerogel_REGION0[cnt];
				    Dmeson.aerogel_REGION5t1[i]=atctrackinfo.aerogel_REGION5[cnt];
				    Dmeson.aerogel_REGION20t1[i]=atctrackinfo.aerogel_REGION20[cnt];

				    Dmeson.single_aerogel_REGIONt1[i]=atctrackinfo.single_aerogel_REGION[cnt];
				    Dmeson.single_aerogel_REGION0t1[i]=atctrackinfo.single_aerogel_REGION0[cnt];
				    Dmeson.single_aerogel_REGION5t1[i]=atctrackinfo.single_aerogel_REGION5[cnt];
				    Dmeson.single_aerogel_REGION20t1[i]=atctrackinfo.single_aerogel_REGION20[cnt];

				    if (progpar.verbose) cout<<"atc cnt="<<Dmeson.atcCNTt1[i]<<"\t"<<"npe="<<Dmeson.atcNpet1[i]<<endl;
				    totalNpe1 += atctrackinfo.npe[cnt];
				}
				if (progpar.verbose) cout<<"t1="<<t1<<"\t"<<"Total ATC Npe="<<totalNpe1<<endl;
				Dmeson.atcTotalNpet1=totalNpe1;

				atc_to_track(t2);
				float totalNpe2=0;
				Dmeson.natccrosst2=atctrackinfo.ncnt;
				if (progpar.verbose) cout<<"t2="<<t2<<"\t"<<"atctrackinfo.ncnt="<<atctrackinfo.ncnt<<endl;
				for(int i=0; i<atctrackinfo.ncnt; i++)
				{
				    Dmeson.atcCNTt2[i]=atctrackinfo.cnt[i];
				    cnt=atctrackinfo.cnt[i];
				    Dmeson.atcNpet2[i]=atctrackinfo.npe[cnt];

				    Dmeson.tlent2[i]=atctrackinfo.tlen[cnt];
				    Dmeson.wlshitt2[i]=atctrackinfo.wlshit[cnt];
				    Dmeson.nearwlst2[i]=atctrackinfo.nearwls[cnt];

				    Dmeson.aerogel_REGIONt2[i]=atctrackinfo.aerogel_REGION[cnt];
				    Dmeson.aerogel_REGION0t2[i]=atctrackinfo.aerogel_REGION0[cnt];
				    Dmeson.aerogel_REGION5t2[i]=atctrackinfo.aerogel_REGION5[cnt];
				    Dmeson.aerogel_REGION20t2[i]=atctrackinfo.aerogel_REGION20[cnt];

				    Dmeson.single_aerogel_REGIONt2[i]=atctrackinfo.single_aerogel_REGION[cnt];
				    Dmeson.single_aerogel_REGION0t2[i]=atctrackinfo.single_aerogel_REGION0[cnt];
				    Dmeson.single_aerogel_REGION5t2[i]=atctrackinfo.single_aerogel_REGION5[cnt];
				    Dmeson.single_aerogel_REGION20t2[i]=atctrackinfo.single_aerogel_REGION20[cnt];

				    if (progpar.verbose) cout<<"atc cnt="<<Dmeson.atcCNTt2[i]<<"\t"<<"npe="<<Dmeson.atcNpet2[i]<<endl;
				    totalNpe2 += atctrackinfo.npe[cnt];
				}
				if (progpar.verbose) cout<<"t2="<<t2<<"\t"<<"Total ATC Npe="<<totalNpe2<<endl;
				Dmeson.atcTotalNpet2=totalNpe2;

				eventTree->Fill();
			    }
			}
		    }
		}
	    }
	}
    }


    if(eNumber%1000==0) cout<<"Ev:"<<eNumber<<endl;
    //==================================================================

    if( progpar.process_only ) return 1;

    return 0;
}

static const char* optstring="ra:d:b:p:h:s:j:t:e:c:l:k:i:u:q:o:D:v:m:M:S:A:Z:n:w:g:y:f:z:x";

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
            	<<"  -y SF          Momentum correction "<<def_progpar.pSF<<"\n"
            	<<"  -f Fit         Performe kinematic fit "<<def_progpar.Dkine_fit<<"\n"
            	<<"  -z Debug       Print debug information "<<def_progpar.verbose<<"\n"
		<<"  -x             Process the events specified after file exclusively and print debug information"
	    <<endl;
	exit(status);
}

int main(int argc, char* argv[])
{
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
                        case 'y': progpar.pSF=atof(optarg); break;
                        case 'f': progpar.Dkine_fit=atoi(optarg); break;
                        case 'z': progpar.verbose=atoi(optarg); break;
			case 'x': progpar.process_only=true; break;
			default : Usage(1);
		}
	}

	if( progpar.min_track_number<progpar.min_beam_track_number ||
	   progpar.min_beam_track_number<progpar.min_ip_track_number ) {
	    cerr<<"Error in parameters specification, should be MinTotalTracks>=MinBeamTracks>=MinIPTracks"<<endl;
	    return 1;
	}

	char timestr[161];
	time_t curtime=time(NULL);

	strftime(timestr,161,"%F %T %z",localtime(&curtime));
	cout<<"Current time "<<timestr<<endl;
	cout<<" Writing output trees to "<<progpar.rootfile<<endl;


//----------------- Initialize ROOT file and trees -----------------//
	TFile *fout=0;
	//Create root file if exclusive event processing is not set
	if( !progpar.process_only )
		fout = new TFile(progpar.rootfile,"RECREATE");

	eventTree = new TTree("et","Event tree");
	eventTree->SetAutoSave(500000000);  // autosave when 0.5 Gbyte written
	eventTree->Branch("Dmeson",&Dmeson,"vrtntrk/I:vrtnip:vrtnbeam:ncomb:nhitsdc:nhitst1:nhitst2:nhitsvd:nhitsvdt1:nhitsvdt2:nhitsxyt1:nhitszt1:nhitsxyt2:nhitszt2:nvect1:nvecxyt1:nveczt1:nvect2:nvecxyt2"
			  ":nveczt2:ncls1:ncls2:ncls:nlkr:ncsi:munhits:mulayerhits1:mulayerhits2:mulayerhits3:Run:natccrosst1:atcCNTt1[20]:natccrosst2:atcCNTt2[20]"
			  ":aerogel_REGIONt1[20]:aerogel_REGION0t1[20]:aerogel_REGION5t1[20]:aerogel_REGION20t1[20]:single_aerogel_REGIONt1[20]"
			  ":single_aerogel_REGION0t1[20]:single_aerogel_REGION5t1[20]:single_aerogel_REGION20t1[20]:aerogel_REGIONt2[20]:aerogel_REGION0t2[20]:aerogel_REGION5t2[20]"
			  ":aerogel_REGION20t2[20]:single_aerogel_REGIONt2[20]:single_aerogel_REGION0t2[20]:single_aerogel_REGION5t2[20]:single_aerogel_REGION20t2[20]"
                          ":wlshitt1[20]:nearwlst1[20]:wlshitt2[20]:nearwlst2[20]"
			  ":mbc/F:de:dp:Mpart1:Ppart1:Mpart2:Ppart2:fchi2:Ebeam:rEv:p1:p2:pt1:pt2:chi2t1:chi2t2:theta2t:phi2t:thetat1:thetat2:phit1:phit2:e1"
			  ":e2:rr1:rr2:zip1:zip2:ecls1:ecls2:tcls1:tcls2:pcls1:pcls2:emcenergy:lkrenergy:csienergy:tofc1:ttof1:tofc2:ttof2:atcNpet1[20]:atcTotalNpet1"
			  ":atcNpet2[20]:atcTotalNpet2:tlent1[20]:tlent2[20]");

//----------------- Configure kframework -----------------//
	//Set kframework signal handling
	kf_install_signal_handler(1);

        kdcswitches_.kNoiseReject=3;      //Cut for DC noise  (0 - not cut, 1 - standart, 2 - soft, 3 - hard)
	//kdcswitches_.KemcAllowed=-1;      //off use strips for track reconstruction
	//kdcswitches_.KtofAllowed=0;       //use of TOF for track search
	//kdcswitches_.kIPalternative = 1;  //alternative track candidate with IP (on)
	kdcswitches_.kCosmInSigRuns = 0;  //search for cosmic in signal runs (on)

        kf_MCCalibRunNumber(progpar.simOn,progpar.MCCalibRunNumber,progpar.MCCalibRunNumberL,progpar.NsimRate,progpar.Scale,progpar.Ascale,progpar.Zscale);

	//Set subsystems to be used
        kf_use(KF_VDDC_SYSTEM|KF_TOF_SYSTEM|KF_ATC_SYSTEM|KF_EMC_SYSTEM|KF_MU_SYSTEM);

	//Register to kframework used cuts
	char buf[100];
	kf_add_cut(KF_PRE_SEL,CutEvents,"Cut events");
	kf_add_cut(KF_PRE_SEL,CutLongDcRecord,"DC event length >1940 words");
	kf_add_cut(KF_PRE_SEL,CutLongVdRecord,"VD event length >156 words");

	sprintf(buf,"momentum <= %5.fMeV/c",progpar.min_momentum);
	kf_add_cut(KF_VDDC_SEL,MinMomentumCut,buf);
	sprintf(buf,"momentum >= %5.fMeV/c",progpar.max_momentum);
	kf_add_cut(KF_VDDC_SEL,MaxMomentumCut,buf);
	kf_add_cut(KF_VDDC_SEL,ChargeCut,"Charge from track: (tCharge(0)+tCharge(1))!=0");
	kf_add_cut(KF_VDDC_SEL,Chi2Cut,"tChi2>50");
	kf_add_cut(KF_VDDC_SEL,tHitsCut,"tHits<24");
	sprintf(buf,"minimum number of tracks equally %d<",progpar.min_track_number);
	kf_add_cut(KF_VDDC_SEL,CutTrackNumberMin,buf);
	sprintf(buf,"maximum number of tracks equally %d<",progpar.max_track_number);
	kf_add_cut(KF_VDDC_SEL,CutTrackNumberMax,buf);
	sprintf(buf,"number of beam tracks <%d",progpar.min_beam_track_number);
	kf_add_cut(KF_VDDC_SEL,CutBeamTrackNumber,buf);
	sprintf(buf,"number of IP tracks <%d",progpar.min_ip_track_number);
	kf_add_cut(KF_VDDC_SEL,CutIPTrackNumber_min,"IP tracks cut");
	sprintf(buf,"number of IP tracks >%d",progpar.max_ip_track_number);
	kf_add_cut(KF_VDDC_SEL,CutIPTrackNumber_max,"IP tracks cut");
        kf_add_cut(KF_ATC_SEL,AtcEventDamageCut,"damaged record");
        kf_add_cut(KF_ATC_SEL,AtcIllegalTrackCut,"illegal track");

	sprintf(buf,"total EMC energy <%5.fMeV",progpar.min_total_energy);
	kf_add_cut(KF_EMC_SEL,CutTotalEnergy,buf);
	sprintf(buf,"cluster EMC energy <%5.fMeV",progpar.min_cluster_energy);
	kf_add_cut(KF_EMC_SEL,CutClusterEnergy,buf);
	sprintf(buf,"number of clusters <%d",progpar.min_cluster_number);
	kf_add_cut(KF_EMC_SEL,CutMINClusterNumber,buf);
	sprintf(buf,"number of clusters >%d",progpar.max_cluster_number);
	kf_add_cut(KF_EMC_SEL,CutMAXClusterNumber,buf);
	kf_add_cut(KF_EMC_SEL,Cut_nclntrack,"nclntrack cut");

	//Register selection routines
	kf_register_selection(KF_PRE_SEL,pre_event_rejection);
	kf_register_selection(KF_VDDC_SEL,vddc_event_rejection);
	kf_register_selection(KF_TOF_SEL,tof_event_rejection);
        kf_register_selection(KF_ATC_SEL,atc_rejection);
	kf_register_selection(KF_EMC_SEL,emc_event_rejection);
	kf_register_selection(KF_MU_SEL,mu_event_rejection);

	//Set automatic cosmic run determination
	kf_cosmic(-1);  //auto
//	kf_cosmic(0);  //beam

	kf_modify_header(1);     //Modify header flag. REDE energy read from DB will be written to header

	//Register an analysis routine
	kf_register_analysis(analyse_event);
        if(progpar.verbose) cout<<"analyse_event="<<analyse_event<<endl;

	//Do not reconstruct, read reconstruction records from file
	kf_reco_from_file(progpar.read_reco);

	//Set exclusive event processing
	kf_process_only(progpar.process_only);

	TBenchmark *benchmark=new TBenchmark;
	cout<<" Starting benchmark test"<<endl;
	benchmark->Start("test");

	//Call analysis job
	if (progpar.verbose) cout<<"NEvents="<<progpar.NEvents<<"\t"<<"argv[optind]="<<argv[optind]<<"\t"<<"&argv[optind]="<<&argv[optind]<<"\t"<<"argc-optind="<<argc-optind<<endl;               //argv[optind]:/space/runs/daq021949.nat.bz2
	kf_process(argc-optind,&argv[optind],progpar.NEvents);             //установка ограничения на число обрабатываемых событий

	benchmark->Show("test");

	if( fout ) {
		fout->Write();         //пишем данные в файл и закрываем его
		fout->Close();
	}

	return 0;
}
