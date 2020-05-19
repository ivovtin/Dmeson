#include <unistd.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <algorithm>    // std::min_element, std::max_element

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
//#include <hbook.h>
#include "TMinuit.h"

#define PI 3.14159265358979
#define THETA_CL_CUT 30.
#define DIST_CL_CUT 20.

using namespace std;

const int Natccr=4;           //number crossing ATC counters on track
const int Ntraks=12;           //number tracks
const int Nclcr=4;            //number crossing clusters on track
const int Nclcrg=4;

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
	int MCCalibRunNumber;                 //19862 - number of run - download from DB calibration for processe MC-file in runs interval
	int NEvents;                          //number of processed events
	bool process_only;                    //process one event only
	bool Dkine_fit;                       //perfome kinematic fit
        bool verbose;                         //print debug information
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
static const struct ProgramParameters def_progpar={false,2,6,1,1,6,100,2000,15,45,2,8,0,0,200,15,"/store/users/ovtin/out.root",19862,0,false,false,0};

static struct ProgramParameters progpar(def_progpar);

enum {
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

static TTree *eventTree, *trackTree, *emcTowerTree, *lkrStripTree, *lkrStripTrackTree, *ATCTree, *jpsiTree;
static struct EventBranch bevent;
static struct VertexBranch bvertex;
static struct TrackBranch btrack[Ntraks];
static struct ToFBranch btof[Ntraks];
static struct MUBranch bmu;
static struct EMCBranch bemc;
static struct TowerClusterBranch bcluster[Nclcr][Ntraks];
static struct TowerClusterBranch bclgamma[Nclcrg];
static struct StripClusterBranch bstrip;
static struct StripTrackBranch bstriptrack;

static struct ATCCounterBranch bcnt[Natccr][Ntraks];
static struct ATCBranch batc;

typedef struct {Int_t nhitst1[50],nhitst2[50],nhitst3[50],ncomb,ncls1[50],ncls2[50],ncls3[50]; Float_t Mbc[50],Mbckin[50],dE[50],dEkin[50],
    Ebeam,rEv,P1[50],P2[50],P3[50],Pt1[50],Pt2[50],Pt3[50],chi2t1[50],chi2t2[50],chi2t3[50],e1[50],e2[50],e3[50],rr1[50],rr2[50],
    rr3[50],Zip1[50],Zip2[50],Zip3[50],ecls1[50],ecls2[50],ecls3[50],tcls1[50],tcls2[50],tcls3[50],pcls1[50],pcls2[50],pcls3[50],
    timet1[50],betat1[50],lengtht1[50],timet2[50],betat2[50],lengtht2[50],timet3[50],betat3[50],lengtht3[50]; } DMESON;

static DMESON Dmeson;

double mk = 493.68;
double mpi = 139.57;

int dcand_t1;
int dcand_t2;
int dcand_t3;
double ebeam;

int listtr[6],lclpi0[8],lclg[5];
int minElementIndex;
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

//function
void kine_fcn(Int_t &npar, Double_t *gin, Double_t &f, Double_t *par, Int_t iflag) {
    double pp1 = par[0];
    double pp2 = par[1];

    double ek = ebeam - sqrt(mpi*mpi+pp1*pp1) - sqrt(mpi*mpi+pp2*pp2);
    double pk;
    if (ek < mk) pk = 0.;
    else
	pk = sqrt(ek*ek-mk*mk);

    double p1i = tP(dcand_t2);
    double p2i = tP(dcand_t3);
    double pki = tP(dcand_t1);

    double sp1 = sqrt(ktrrec_h_.FitTrack[dcand_t2][fitSigCC]/
		      pow(ktrrec_h_.FitTrack[dcand_t2][fitC],2)+
		      ktrrec_h_.FitTrack[dcand_t2][fitSigTheThe]/
		      pow(tan(ktrrec_.TETRAK[dcand_t2]/180.*PI),2))*p1i;

    double sp2 = sqrt(ktrrec_h_.FitTrack[dcand_t3][fitSigCC]/
		      pow(ktrrec_h_.FitTrack[dcand_t3][fitC],2)+
		      ktrrec_h_.FitTrack[dcand_t3][fitSigTheThe]/
		      pow(tan(ktrrec_.TETRAK[dcand_t3]/180.*PI),2))*p2i;

    double sk = sqrt(ktrrec_h_.FitTrack[dcand_t1][fitSigCC]/
		     pow(ktrrec_h_.FitTrack[dcand_t1][fitC],2)+
		     ktrrec_h_.FitTrack[dcand_t1][fitSigTheThe]/
		     pow(tan(ktrrec_.TETRAK[dcand_t1]/180.*PI),2))*pki;

    double chi2 = pow((pp1-p1i)/sp1,2) + pow((pp2-p2i)/sp2,2) +
	pow((pk-pki)/sk,2);

    if (progpar.verbose){
	printf("  p1=%lf, p2=%lf, pk=%lf, chi2=%lf\n",
	       pp1, pp2, pk, chi2);
	printf("  s1=%lf, s2=%lf, sk=%lf\n",
	       sp1, sp2, sk);
    }

    f = chi2;
}

void refit(int t, double p, double* phi, double* theta) {
    double p0 = ktrrec_.PTRAK[t];
    double r0 = tRc(t);

    double phi0 = ktrrec_.FITRAK[t]*PI/180.;
    double theta0 = ktrrec_.TETRAK[t]*PI/180.;

    double r = r0*(p/p0);

    ktrk_hits_.RcFixR = r;
    PhiFixR = phi0;
    ThetaFixR = theta0;
    //ktrk_hits_.FixUserR = 1;  //default is 0

    int track = t+1;
    ktrkhits_(&track);

    double phi1 = PhiFixR;
    double theta1 = ThetaFixR;

    double p1 = p*sin(theta0)/sin(theta1);

    if (progpar.verbose) {
	printf("Track refit: p0=%lg, r0=%lg, p=%lg\n", p0, r0, p);
	printf("             phi0=%lg, theta0=%lg\n", phi0, theta0);
	printf("             phi1=%lg, theta1=%lg\n", phi1, theta1);
	printf("             p1=%lg\n", p1);
    }

    *phi = phi1;
    *theta = theta1;
}

void kine_fit(int ip1, int ip2, int ip3, double* mbc, double* de) {
    dcand_t1 = ip1;
    dcand_t2 = ip2;
    dcand_t3 = ip3;

    double p1i = tP(dcand_t2);
    double p2i = tP(dcand_t3);
    double p3i = tP(dcand_t1);

    TMinuit *dMinuit = new TMinuit(2); //initialise Minuit with a maximum of 2 parameters to minimise
    dMinuit->SetFCN(kine_fcn);         //set the function to minimise
    if (progpar.verbose) {
	dMinuit->SetPrintLevel(3);         //set print out level for Minuit
    }
    Double_t arglist[10];
    arglist[0]=1;
    Int_t iflag;
    dMinuit->mnexcm("SET PAR",arglist,1,iflag);    //Interprets command
    double lowerLimit = 0.0;
    double upperLimit = 0.0;
    dMinuit->mnparm(0,"p1", p1i, 1., lowerLimit, upperLimit, iflag);    //set the parameters used in the fit
    dMinuit->mnparm(1,"p2", p2i, 1., lowerLimit, upperLimit, iflag);
    dMinuit->mnexcm("CALL FCN",arglist,1,iflag);                        //call the user defined function, to calculate the value FCN, and print the result out to the screen.
    dMinuit->mnexcm("MIGRAD",arglist,2,iflag);                          //run the minimisation Using MIGRAD

    double pp1, pp2;
    double pk;
    Double_t val[2],err[2],bnd1[2],bnd2[2];
    TString para0,para1;
    int ivar;

    gMinuit->mnpout(0,para0,val[0],err[0],bnd1[0],bnd2[0],ivar);
    pp1 = val[0];
    gMinuit->mnpout(1,para1,val[1],err[1],bnd1[1],bnd2[1],ivar);
    pp2 = val[1];

    double ek = ebeam - sqrt(mpi*mpi+pp1*pp1) - sqrt(mpi*mpi+pp2*pp2);
    if (ek < mk) pk = 0.;
    else
	pk = sqrt(ek*ek-mk*mk);


    if (progpar.verbose) {
	printf("Kinematic fitter: \n");
	printf("  Input: p1=%lf, p2=%lf, pk=%lf\n", p1i, p2i, p3i);
	printf("  Out:   p1=%lf, p2=%lf, pk=%lf\n", pp1, pp2, pk);
    }


    double theta1 = ktrrec_.TETRAK[dcand_t2]/180.*PI;
    double phi1 = ktrrec_.FITRAK[dcand_t2]/180.*PI;

    double theta2 = ktrrec_.TETRAK[dcand_t3]/180.*PI;
    double phi2 = ktrrec_.FITRAK[dcand_t3]/180.*PI;

    double thetak = ktrrec_.TETRAK[dcand_t1]/180.*PI;
    double phik = ktrrec_.FITRAK[dcand_t1]/180.*PI;

    refit(dcand_t2, pp1, &phi1, &theta1);
    refit(dcand_t3, pp2, &phi2, &theta2);
    refit(dcand_t1, pk, &phik, &thetak);

    double px1 = pp1*sin(theta1)*cos(phi1);
    double py1 = pp1*sin(theta1)*sin(phi1);
    double pz1 = pp1*cos(theta1);

    double px2 = pp2*sin(theta2)*cos(phi2);
    double py2 = pp2*sin(theta2)*sin(phi2);
    double pz2 = pp2*cos(theta2);

    double pxk = pk*sin(thetak)*cos(phik);
    double pyk = pk*sin(thetak)*sin(phik);
    double pzk = pk*cos(thetak);

    *mbc = ebeam*ebeam - pow(px1+px2+pxk,2) - pow(py1+py2+pyk,2) - pow(pz1+pz2+pzk,2);
    if (*mbc>0) *mbc = sqrt(*mbc); else *mbc = 0;

    *de = -ebeam + sqrt(mk*mk+pk*pk) + sqrt(mpi*mpi+pp1*pp1) + sqrt(mpi*mpi+pp2*pp2);

    if (progpar.verbose) printf("mbc=%lf, de=%lf\n", *mbc, *de);
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
    double  WTotal=2*beam_energy;                                                                 //beam_energy - How determined this energy ?
    if( kedrrun_cb_.Header.RunType == 64 ) { WTotal=2*1888.75; }                                  //for MC
    ebeam=WTotal/2;

    if (progpar.verbose) cout<<"RunNumber="<<kedrraw_.Header.RunNumber<<"\t"<<"WTotal="<<WTotal<<"\t"<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<endl;


    if (progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<"\t"<<"eTracksBeam="<<eTracksBeam<<"\t"<<"eTracksIP="<<eTracksIP<<endl;

    copy(&bevent);
    bevent.event=kdcenum_.EvNum;

    unsigned short nhits=mu_next_event();

    copy(&bvertex);
    copy(&bemc);

    for(int i=0; i<50; i++){
	Dmeson.Mbc[i]=0;                                            //Invariant mass or beam consraint mass
	Dmeson.dE[i]=0;
	Dmeson.P1[i]=0;
	Dmeson.P2[i]=0;
	Dmeson.P3[i]=0;
	Dmeson.Pt1[i]=0;
	Dmeson.Pt2[i]=0;
	Dmeson.Pt3[i]=0;
	Dmeson.chi2t1[i] = 0;
	Dmeson.chi2t2[i] = 0;
	Dmeson.chi2t3[i] = 0;
	Dmeson.nhitst1[i] = 0;
	Dmeson.nhitst2[i] = 0;
	Dmeson.nhitst3[i] = 0;
	Dmeson.e1[i]=0;
	Dmeson.e2[i]=0;
	Dmeson.e3[i]=0;
	Dmeson.rr1[i] = 0;
	Dmeson.rr2[i] = 0;
	Dmeson.rr3[i] = 0;
	Dmeson.Zip1[i] = 0;
	Dmeson.Zip2[i] = 0;
	Dmeson.Zip3[i] = 0;
	Dmeson.ncls1[i] = 0;
	Dmeson.ncls2[i] = 0;
	Dmeson.ncls3[i] = 0;
	Dmeson.ecls1[i] = 0;
	Dmeson.ecls2[i] = 0;
	Dmeson.ecls3[i] = 0;
	Dmeson.tcls1[i] = 0;
	Dmeson.tcls2[i] = 0;
	Dmeson.tcls3[i] = 0;
	Dmeson.pcls1[i] = 0;
	Dmeson.pcls2[i] = 0;
	Dmeson.pcls3[i] = 0;
	Dmeson.Mbckin[i] = 0;
	Dmeson.dEkin[i] = 0;
	Dmeson.timet1[i] = 0;
	Dmeson.betat1[i] = 0;
	Dmeson.lengtht1[i] = 0;
	Dmeson.timet2[i] = 0;
	Dmeson.betat2[i] = 0;
	Dmeson.lengtht2[i] = 0;
	Dmeson.timet3[i] = 0;
	Dmeson.betat3[i] = 0;
	Dmeson.lengtht3[i] = 0;
    }
    Dmeson.ncomb = 0;

    int i=0;

    for (int t1 = 0; t1 < eTracksAll; t1++)                                  //cycle for first track
    {
	copy(&btrack[t1],t1);
	copy(&btof[t1],t1);
	copy(&bmu,t1,nhits);
	copy(&batc);

	for(int k=0; k<Natccr;  k++)                                         //cycle for number of crossing ATC counters on track
	{
	    //if (progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Track="<<t1<<"\t"<<"i="<<i<<"\t"<<"atc_track.cnt_cross[t][k]="<<atc_track.cnt_cross[t1][k]<<"\t"<<"atc_rec.npe="<<atc_rec.npe[atc_track.cnt_cross[t1][k]-1]<<endl;
	    copy(&bcnt[k][t1],(atc_track.cnt_cross[t1][k]-1),t1);
	}

	for(int c=0; c<semc.dc_emc_ncls[t1]; c++)                            //dc_emc_ncls[NDCH_TRK] - number clusters of emc on track
	{
	    if (progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Track="<<t1<<"\t"<<"semc.dc_emc_ncls[t]="<<semc.dc_emc_ncls[t1]<<endl;
	    copy(&bcluster[c][t1],(semc.dc_emc_cls[t1][c]-1));               //dc_emc_cls[NDCH_TRK][NEMC_CLS] - number clusters
	}

	for(int t=0; t<semc.str_ntracks; t++) {
	    copy(&bstriptrack,t);
	}


	for (int t2 = 0; t2 < eTracksAll; t2++)
	{
	    for (int t3 = 0; t3 < eTracksAll; t3++)
	    {
		if (t2 > t3){
		    //condition for part1: K-, part2: pi+,  part3: pi+    (D+->K-pi+pi+)
		    if ((tCharge(t1) == -1 && tCharge(t2) ==  1 && tCharge(t3) ==  1) || (tCharge(t1) ==  1 && tCharge(t2) == -1 && tCharge(t3) == -1))
		    {
			double xx1=tX0IP(t1)*tX0IP(t1);
			double yy1=tY0IP(t1)*tY0IP(t1);
			double rr1=sqrt(xx1+yy1);
			double xx2=tX0IP(t2)*tX0IP(t2);
			double yy2=tY0IP(t2)*tY0IP(t2);
			double rr2=sqrt(xx2+yy2);
			double xx3=tX0IP(t3)*tX0IP(t3);
			double yy3=tY0IP(t3)*tY0IP(t3);
			double rr3=sqrt(xx3+yy3);

			if (progpar.verbose) cout<<"rr1="<<rr1<<"\t"<<"fabs(tZ0IP(t1))="<<fabs(tZ0IP(t1))<<endl;
			if (progpar.verbose) cout<<"rr2="<<rr2<<"\t"<<"fabs(tZ0IP(t2))="<<fabs(tZ0IP(t2))<<endl;
			if (progpar.verbose) cout<<"rr3="<<rr3<<"\t"<<"fabs(tZ0IP(t3))="<<fabs(tZ0IP(t3))<<endl;

			if ( fabs(tZ0IP(t1))>20. ) continue;
			if ( fabs(tZ0IP(t2))>20. ) continue;
			if ( fabs(tZ0IP(t3))>20. ) continue;
			if ( rr1>8 ) continue;
			if ( rr2>8 ) continue;
			if ( rr3>8 ) continue;

			if( tPt(t1)<=progpar.min_momentum || tPt(t1)>=progpar.max_momentum )  continue;
			if( tCh2(t1)>progpar.max_tchi2 )  continue;
			if( tHits(t1)<progpar.min_Nhits )  continue;

			if( tPt(t2)<=progpar.min_momentum || tPt(t2)>=progpar.max_momentum )  continue;
			if( tCh2(t2)>progpar.max_tchi2 )  continue;
			if( tHits(t2)<progpar.min_Nhits )  continue;

			if( tPt(t3)<=progpar.min_momentum || tPt(t3)>=progpar.max_momentum )  continue;
			if( tCh2(t3)>progpar.max_tchi2 )  continue;
			if( tHits(t3)<progpar.min_Nhits )  continue;

			Dmeson.rr1[i] = rr1;
			Dmeson.rr2[i] = rr2;
			Dmeson.rr3[i] = rr3;
			Dmeson.Zip1[i] = tZ0IP(t1);
			Dmeson.Zip2[i] = tZ0IP(t2);
			Dmeson.Zip3[i] = tZ0IP(t3);

			if (progpar.verbose) cout<<"i="<< i<<endl;
			if (progpar.verbose) cout<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"Ebeam="<<WTotal/2<<"\t"<<"t1="<<t1<<"\t"<<"t2="<<t2<<"\t"<<"t3="<<t3<<"\t"<<"tCharge(t1)="<<tCharge(t1)<<"\t"<<"tCharge(t2)="<<tCharge(t2)<<"\t"<<"tCharge(t3)="<<tCharge(t3)<<endl;
			if (progpar.verbose) cout<<"P(t1)="<<tP(t1)<<"\t"<<"P(t2)="<<tP(t2)<<"\t"<<"P(t3)="<<tP(t3)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tHits(t3)="<<tHits(t3)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<"\t"<<"tCh2(t3)="<<tCh2(t3)<<endl;

			double px1, px2, px3, py1, py2, py3, pz1, pz2, pz3;
			px1 = tP(t1)*tVx(t1);
			px2 = tP(t2)*tVx(t2);
			px3 = tP(t3)*tVx(t3);
			py1 = tP(t1)*tVy(t1);
			py2 = tP(t2)*tVy(t2);
			py3 = tP(t3)*tVy(t3);
			pz1 = tP(t1)*tVz(t1);
			pz2 = tP(t2)*tVz(t2);
			pz3 = tP(t3)*tVz(t3);

			//Mbc=sqrt(Ebeam^2-(p1+p2)^2)
			Dmeson.Mbc[i] = (WTotal/2)*(WTotal/2) - pow(px1+px2+px3,2) - pow(py1+py2+py3,2) - pow(pz1+pz2+pz3,2);
			if (Dmeson.Mbc[i]>0) Dmeson.Mbc[i] = sqrt(Dmeson.Mbc[i]); else Dmeson.Mbc[i] = 0;

			if (progpar.verbose) cout<<"mbc="<<Dmeson.Mbc[i]<<endl;

			Dmeson.dE[i] = sqrt(mk*mk + tP(t1)*tP(t1)) + sqrt(mpi*mpi + tP(t2)*tP(t2)) + sqrt(mpi*mpi + tP(t3)*tP(t3)) - WTotal/2;
			if (progpar.verbose) cout<<"de="<<Dmeson.dE[i]<<endl;

			Dmeson.P1[i] = tP(t1);
			Dmeson.P2[i] = tP(t2);
			Dmeson.P3[i] = tP(t3);
			Dmeson.Pt1[i] = tPt(t1);
			Dmeson.Pt2[i] = tPt(t2);
			Dmeson.Pt3[i] = tPt(t3);
			Dmeson.chi2t1[i] = tCh2(t1);
			Dmeson.chi2t2[i] = tCh2(t2);
			Dmeson.chi2t3[i] = tCh2(t3);
			Dmeson.nhitst1[i] = tHits(t1);
			Dmeson.nhitst2[i] = tHits(t2);
			Dmeson.nhitst3[i] = tHits(t3);

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

			float energy_on_track3=0;
			int cl_tr3=0;
			for(int c3=0; c3<semc.dc_emc_ncls[t3]; c3++)                     //dc_emc_ncls[NDCH_TRK] - number clusters for track
			{
			    cl_tr3=semc.dc_emc_cls[t3][c3]-1;                           //dc_emc_cls[NDCH_TRK][NEMC_CLS]-1 - number of clusters on track
			    energy_on_track3+=semc.emc_energy[cl_tr3];
			}

			Dmeson.e1[i] = energy_on_track1;
			Dmeson.e2[i] = energy_on_track2;
			Dmeson.e3[i] = energy_on_track3;
			if (progpar.verbose) cout<<"Dmeson.e1[i]="<<Dmeson.e1[i]<<"\t"<<"Dmeson.e2[i]="<<Dmeson.e2[i]<<"\t"<<"Dmeson.e3[i]="<<Dmeson.e3[i]<<endl;

			for (int cl=0; cl<semc.emc_ncls; cl++) {

			    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t1]) < THETA_CL_CUT &&
				fabs(clust_dist(t1, cl)) < DIST_CL_CUT) {
				Dmeson.ecls1[i] += semc.emc_energy[cl];
				Dmeson.tcls1[i] = semc.emc_theta[cl]-ktrrec_.TETRAK[t1];
				Dmeson.pcls1[i] = clust_dist(t1, cl);
				Dmeson.ncls1[i]++;
			    }

			    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t2]) < THETA_CL_CUT &&
				fabs(clust_dist(t2, cl)) < DIST_CL_CUT) {
				Dmeson.ecls2[i] += semc.emc_energy[cl];
				Dmeson.tcls2[i] = semc.emc_theta[cl]-ktrrec_.TETRAK[t2];
				Dmeson.pcls2[i] = clust_dist(t2, cl);
				Dmeson.ncls2[i]++;
			    }

			    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t3]) < THETA_CL_CUT &&
				fabs(clust_dist(t3, cl)) < DIST_CL_CUT) {
				Dmeson.ecls3[i] += semc.emc_energy[cl];
				Dmeson.tcls3[i] = semc.emc_theta[cl]-ktrrec_.TETRAK[t3];
				Dmeson.pcls3[i] = clust_dist(t3, cl);
				Dmeson.ncls3[i]++;
			    }
			}

			double mbc, de, dp;
			if (progpar.Dkine_fit)
			{
			    kine_fit(t1, t2, t3, &mbc, &de);
			    Dmeson.Mbckin[i] = mbc;
			    Dmeson.dEkin[i] = de;
			}

			Dmeson.timet1[i]=kschit_.time_ns[t1];
			Dmeson.betat1[i]=kscBhit_.Beta[t1][0];         //v/c
			Dmeson.lengtht1[i]=kscBhit_.len[t1][0];        //длина трека

			Dmeson.timet2[i]=kschit_.time_ns[t2];
			Dmeson.betat2[i]=kscBhit_.Beta[t2][0];         //v/c
			Dmeson.lengtht2[i]=kscBhit_.len[t2][0];        //длина трека

			Dmeson.timet3[i]=kschit_.time_ns[t3];
			Dmeson.betat3[i]=kscBhit_.Beta[t3][0];         //v/c
			Dmeson.lengtht3[i]=kscBhit_.len[t3][0];        //длина трека

			i++;
		    }
		}
	    }
	}
    }
    Dmeson.ncomb = i;
    Dmeson.rEv = kedrraw_.Header.Number;
    Dmeson.Ebeam=WTotal/2;

    int nclg=0;
    for(int cl=0; cl<semc.emc_ncls; cl++)
    {
	if(semc.emc_dc_ntrk[cl]==0)                                               //cluster do not connected with track
	{
	    copy(&bclgamma[nclg],cl);                                             //ncls=semc.emc_emc_ncls[c];       ntracks=semc.emc_dc_ntrk[c];
	    nclg++;
	}
    }

    for(int c=0; c<semc.str_ncls; c++) {
	copy(&bstrip,c);
    }

    if(eNumber%10==0) cout<<"Ev:"<<eNumber<<endl;
    //==================================================================

    eventTree->Fill();


    if( progpar.process_only ) return 1;

    return 0;
}

static const char* optstring="ra:d:b:p:h:s:j:t:e:c:l:k:i:u:q:o:v:n:f:z:x";

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
            	<<"  -v MCCalibRunNumber    MCCalibRunNumber (default to "<<def_progpar.MCCalibRunNumber<<")\n"
            	<<"  -n NEvents     Number events in process "<<def_progpar.NEvents<<"\n"
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
                        case 'v': progpar.MCCalibRunNumber=atoi(optarg); break;
                        case 'n': progpar.NEvents=atoi(optarg); break;
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
	eventTree->Branch("ev",&bevent,eventBranchList);
        eventTree->Branch("vrt",&bvertex,vertexBranchList);
	eventTree->Branch("emc",&bemc,emcBranchList);
	eventTree->Branch("atcev",&batc,atcBranchList);

	for(int i=0; i<Ntraks; i++) {
	    char branchname[20];
	    sprintf(branchname,"t%d",i);
	    TBranch* b1=eventTree->Branch(branchname,&btrack[i],trackBranchList);
	    for(int ii=0; ii<Natccr; ii++) {
		char branchname2[20];
		sprintf(branchname2,"t%datccr%d",i,ii);
		eventTree->Branch(branchname2,&bcnt[ii][i],atcCounterBranchList);
	    }
	    for (int ii=0; ii<Nclcr; ii++)
	    {
		char clastername[20];
		sprintf(clastername,"t%dc%d",i,ii);
		eventTree->Branch(clastername,&bcluster[ii][i],towerClusterBranchList);
	    }
	    char tofname[20];
	    sprintf(tofname,"t%dtof",i);
	    eventTree->Branch(tofname,&btof[i],ToFBranchList);
	}

	for (int ii=0; ii<Nclcrg; ii++)
	{
	    char clgammaname[20];
	    sprintf(clgammaname,"clgamma%d",ii);
	    eventTree->Branch(clgammaname,&bclgamma[ii],towerClusterBranchList);
	}

	eventTree->Branch("mu",&bmu,MUBranchList);
	eventTree->Branch("Dmeson",&Dmeson,"nhitst1[50]/I:nhitst2[50]:nhitst3[50]:ncomb:ncls1[50]:ncls2[50]:ncls3[50]"
			  ":Mbc[50]/F:Mbckin[50]:dE[50]:dEkin[50]:Ebeam:rEv:P1[50]:P2[50]:P3[50]:Pt1[50]:Pt2[50]:Pt2[50]:chi2t1[50]:chi2t2[50]:chi2t3[50]:e1[50]"
			  ":e2[50]:e3[50]:rr1[50]:rr2[50]:rr3[50]:Zip1[50]:Zip2[50]:Zip3[50]:ecls1[50]:ecls2[50]:ecls3[50]:tcls1[50]:tcls2[50]:tcls3[50]:pcls1[50]"
			  ":pcls2[50]:pcls3[50]:timet1[50]:betat1[50]:lengtht1[50]:timet2[50]:betat2[50]:lengtht2[50]:timet3[50]:betat3[50]:lengtht3[50]");

	eventTree->Branch("strcls",&bstrip,stripClusterBranchList);
	eventTree->Branch("strtrk",&bstriptrack,stripTrackBranchList);

//----------------- Configure kframework -----------------//
	//Set kframework signal handling
	kf_install_signal_handler(1);

	//Set subsystems to be used
        kf_use(KF_VDDC_SYSTEM|KF_TOF_SYSTEM|KF_ATC_SYSTEM|KF_EMC_SYSTEM|KF_MU_SYSTEM);

	//Register to kframework used cuts
	char buf[100];
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

        kf_MCCalibRunNumber(progpar.MCCalibRunNumber);

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
