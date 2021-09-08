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
#include "ReadNat/read_nat_c.h"
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
#include "VDDCRec/kdcswitches.h"
#include "VDDCRec/mctracks.h"
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

#include "KrdEdxPId/KrdEdxPId.hh"

#include "KcSys/fortran.h"

//#include <minuit.h>
//#include <hbook.h>
#include "TMinuit.h"
#include "TRandom3.h"

#define PI 3.14159265358979
#define THETA_CL_CUT 30.
#define DIST_CL_CUT 20.


using namespace std;
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
	int MCCalibRunNumber;                 //number of run - download from DB calibration for processe MC-file in runs interval
	int MCCalibRunNumberL;                //for ksimreal(NevRate,NumFirstExpRun,NumLastExpRun);
        int NsimRate;                         //for ksimreal(NevRate,NumFirstExpRun,NumLastExpRun);
        float Scale;
        float Ascale;
        float Zscale;
	int NEvents;                          //number of processed events
	int NEvbegin;
	int NEvend;
	float pSF;                            //momentum correction
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
static const struct ProgramParameters def_progpar={false,2,6,1,1,6,100,2000,15,45,2,8,0,0,200,15,"/store/users/ovtin/out.root",0,23682,23943,50,1.,1.,1.,0,0,0,1.0,false,false,0};

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
    Int_t vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,charge4,nhitsdc,nhitst1,nhitst2,nhitst3,nhitst4,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsvdt4,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nhitsxyt4,nhitszt4,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,nvecxyt3,nveczt3,nvect4,nvecxyt4,nveczt4,ncomb,ncls1,ncls2,ncls3,ncls4,ncls,nlkr,ncsi,munhits,mulayerhits1,
    mulayerhits2,mulayerhits3,Run,numn,numo,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],natccrosst3,atcCNTt3[20],natccrosst4,atcCNTt4[20],aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],aerogel_REGIONt3[20],aerogel_REGION0t3[20],aerogel_REGION5t3[20],aerogel_REGION20t3[20],single_aerogel_REGIONt3[20],
    single_aerogel_REGION0t3[20],single_aerogel_REGION5t3[20],single_aerogel_REGION20t3[20],aerogel_REGIONt4[20],aerogel_REGION0t4[20],aerogel_REGION5t4[20],aerogel_REGION20t4[20],single_aerogel_REGIONt4[20],
    single_aerogel_REGION0t4[20],single_aerogel_REGION5t4[20],single_aerogel_REGION20t4[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20],wlshitt3[20],nearwlst3[20],wlshitt4[20],nearwlst4[20],
    kft1,kft2,kft3,kft4; 
   Float_t mbc,de,prec1,prec2,prec3,prec4,fchi2,Ebeam,rEv,p1,p2,p3,p4,pt1,pt2,pt3,pt4,thetat1,thetat2,thetat3,thetat4,phit1,phit2,phit3,phit4,chi2t1,chi2t2,chi2t3,chi2t4,e1,e2,e3,e4,rr1,rr2,rr3,rr4,zip1,zip2,zip3,zip4,
	ecls1,ecls2,ecls3,ecls4,tcls1,tcls2,tcls3,tcls4,pcls1,pcls2,pcls3,pcls4,emcenergy,lkrenergy,csienergy,enn,eno,timet1,betat1,lengtht1,timet2,betat2,lengtht2,timet3,betat3,lengtht3,timet4,betat4,lengtht4,
    atcNpet1[20],atcTotalNpet1,atcNpet2[20],atcTotalNpet2,atcNpet3[20],atcTotalNpet3,atcNpet4[20],atcTotalNpet4,tlent1[20],tlent2[20],tlent3[20],tlent4[20],
    dedxt1,dedxt2,dedxt3,dedxt4,probKt1,probKt2,probKt3,probKt4,resdKt1,resdKt2,resdKt3,resdKt4,probpit1,probpit2,probpit3,probpit4,resdpit1,resdpit2,resdpit3,resdpit4,
    r_track_intersect12, r_track_intersect13, r_track_intersect14, r_track_intersect23, r_track_intersect24, r_track_intersect34;

} DMESON;

static DMESON Dmeson;

double mk = 493.68;
double mpi = 139.57;

int idATC=0;

int dcand_t1;
int dcand_t2;
int dcand_t3;
int dcand_t4;
double ebeam;

int listtr[6],lclpi0[8],lclg[5];
int minElementIndex;

int numn, numo;
double enn, eno, pxn, pxo, pyn, pyo, pzn, pzo;

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

    //if(progpar.verbose) cout<<"NEvbegin="<<progpar.NEvbegin<<"\t"<<"NEvend="<<progpar.NEvend<<endl;
    if ( progpar.NEvend!=0 ){
	if ( kedrraw_.Header.Number <= progpar.NEvbegin )    return CutEvents;
	if ( kedrraw_.Header.Number > progpar.NEvend-1 )      return CutEvents;
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

int match_dir(int mc, int rec) {
  double x1 = mctracks_cb_.Vx[mc];
  double y1 = mctracks_cb_.Vy[mc];
  double z1 = mctracks_cb_.Vz[mc];

  double x2 = ktrrec_.VxTRAK[rec];
  double y2 = ktrrec_.VyTRAK[rec];
  double z2 = ktrrec_.VzTRAK[rec];

  double prod = x1*x2 + y1*y2 + z1*z2;

//  printf("match: prod=%f, chmc = %d, chrec= %d\n", prod, mctracks_cb_.Ch[mc], ktrrec_.CHTRAK[rec]);

  return (prod>0.95);
}

double pcorr(double p, int type) {
    double ms, dedx, k;

    if (type==1) {    //pion
	ms = 149.484;
	dedx = 1.30782;
	k = 0.;
    }
    else if(type==2)  //kaon
    {
	ms = 502.997;
	dedx = 1.28546;
	k = 0.;
    }
    else if(type==3)  //muon
    {
	ms = 138.315;
	dedx = 1.06861;
	k = 0.;
    }
    else{                //electron
	ms = 0.;
	dedx = 1.57548;
	k = 0.748772e-2;
    }

    double gamma = sqrt(ms*ms+p*p)/ms;

    double beta = sqrt(1.-1./gamma/gamma);

    double pc = p+1.*dedx/pow(beta,3) + k*p;

    pc = pc*fabs(progpar.pSF);
    if (progpar.verbose==3) cout<<"pc="<<pc<<"\t"<<"p="<<p<<"\t"<<"progpar.pSF="<<progpar.pSF<<endl;

    return fabs(pc);
}

//function
void kine_fcn(Int_t &npar, Double_t *gin, Double_t &f, Double_t *parval, Int_t iflag) {
    double pp2 = parval[0];
    double pp3 = parval[1];
    double pp4 = parval[2];

    double ek = ebeam - sqrt(mpi*mpi+pp2*pp2) - sqrt(mpi*mpi+pp3*pp3) - sqrt(mpi*mpi+pp4*pp4);
    double pp1;
    if (ek < mk) pp1 = 0.;
    else
	pp1 = sqrt(ek*ek-mk*mk);

    double pki = pcorr(tP(dcand_t1),2);   //kaon
    double p2i = pcorr(tP(dcand_t2),1);   //pion
    double p3i = pcorr(tP(dcand_t3),1);   //pion
    double p4i = pcorr(tP(dcand_t4),1);   //pion

    double sk = sqrt(ktrrec_h_.FitTrack[dcand_t1][fitSigCC]/
		     pow(ktrrec_h_.FitTrack[dcand_t1][fitC],2)+
		     ktrrec_h_.FitTrack[dcand_t1][fitSigTheThe]/
		     pow(tan(ktrrec_.TETRAK[dcand_t1]/180.*PI),2))*pki;

    double sp2 = sqrt(ktrrec_h_.FitTrack[dcand_t2][fitSigCC]/
		      pow(ktrrec_h_.FitTrack[dcand_t2][fitC],2)+
		      ktrrec_h_.FitTrack[dcand_t2][fitSigTheThe]/
		      pow(tan(ktrrec_.TETRAK[dcand_t2]/180.*PI),2))*p2i;

    double sp3 = sqrt(ktrrec_h_.FitTrack[dcand_t3][fitSigCC]/
		      pow(ktrrec_h_.FitTrack[dcand_t3][fitC],2)+
		      ktrrec_h_.FitTrack[dcand_t3][fitSigTheThe]/
		      pow(tan(ktrrec_.TETRAK[dcand_t3]/180.*PI),2))*p3i;

    double sp4 = sqrt(ktrrec_h_.FitTrack[dcand_t4][fitSigCC]/
		      pow(ktrrec_h_.FitTrack[dcand_t4][fitC],2)+
		      ktrrec_h_.FitTrack[dcand_t4][fitSigTheThe]/
		      pow(tan(ktrrec_.TETRAK[dcand_t4]/180.*PI),2))*p4i;

    double chi2 = pow((pp1-pki)/sk,2) + pow((pp2-p2i)/sp2,2) + pow((pp3-p3i)/sp3,2) + pow((pp4-p4i)/sp4,2);

    if (progpar.verbose>=2) cout<<"idATC="<<idATC<<"\t"<<"pki="<<pki<<"\t"<<"p2i="<<p2i<<"\t"<<"p3i="<<p3i<<"\t"<<"p4i="<<p4i<<"\t"<<"pp1="<<pp1<<"\t"<<"pp2="<<pp2<<"\t"<<"pp3="<<pp3<<"\t"<<"pp4="<<pp4<<"\t"<<"chi2="<<chi2<<endl;

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

    int track = t+1;
    //ktrkhits_(&track);

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

void kine_fit(int ip1, int ip2, int ip3, int ip4, double* mbc, double* de, double* prec1, double* prec2, double* prec3, double* prec4, double* fchi2, int enable) {
    dcand_t1 = ip1;   //kaon
    dcand_t2 = ip2;   //pion
    dcand_t3 = ip3;   //pion
    dcand_t4 = ip4;   //pion

    double p1i = pcorr(tP(dcand_t1),2);   //kaon
    double p2i = pcorr(tP(dcand_t2),1);   //pion
    double p3i = pcorr(tP(dcand_t3),1);   //pion
    double p4i = pcorr(tP(dcand_t4),1);   //pion

    double pp1, pp2, pp3, pp4;
    *fchi2 = 0;

    if (enable) {
	TMinuit *dMinuit = new TMinuit(3); //initialise Minuit with a maximum of 2 parameters to minimise
	dMinuit->SetFCN(kine_fcn);         //set the function to minimise
	dMinuit->SetPrintLevel(progpar.verbose-1); //set print out level for Minuit
	Double_t arglist[2];
	arglist[0]=1;
	Int_t iflag=0;
	dMinuit->mnexcm("SET ERR",arglist,2,iflag);    //Interprets command
	//gMinuit->mninit(1,1,1);
	double lowerLimit = 0.0;
	double upperLimit = 0.0;
	dMinuit->mnparm(0,"p2", p2i, 0.5, lowerLimit, upperLimit, iflag);    //set the parameters used in the fit
	dMinuit->mnparm(1,"p2", p3i, 0.5, lowerLimit, upperLimit, iflag);
	dMinuit->mnparm(2,"p3", p4i, 0.5, lowerLimit, upperLimit, iflag);
	//dMinuit->mnexcm("CALL FCN",arglist,1,iflag);                        //call the user defined function, to calculate the value FCN, and print the result out to the screen.
	arglist[0] = 5000;  //maximum number of function calls after which the calculation will be stopped even if it has not yet converged.
	arglist[1] = 1.; //The optional argument [tolerance] specifies required tolerance on the function value at the minimum. The default tolerance is 0.1, and the minimization will stop when the estimated vertical distance to the minimum (EDM) is less than 0.001*[tolerance]*UP (see [SET ERRordef]).
	dMinuit->mnexcm("MIGRAD",arglist,2,iflag);                          //run the minimisation Using MIGRAD

	Double_t val[3],err[3],bnd1[3],bnd2[3];
	TString para0,para1,para2;
	int ivar;

	gMinuit->mnpout(0,para0,val[0],err[0],bnd1[0],bnd2[0],ivar);
	pp2 = val[0];
	gMinuit->mnpout(1,para1,val[1],err[1],bnd1[1],bnd2[1],ivar);
	pp3 = val[1];
	gMinuit->mnpout(2,para2,val[2],err[2],bnd1[2],bnd2[2],ivar);
	pp4 = val[2];

	double ek = ebeam - sqrt(mpi*mpi+pp2*pp2) - sqrt(mpi*mpi+pp3*pp3) - sqrt(mpi*mpi+pp4*pp4);
	if (ek < mk) pp1 = 0.;
	else
	    pp1 = sqrt(ek*ek-mk*mk);

	if (progpar.verbose) printf("  val0=%lf, val1=%lf, val2=%lf\n",val[0], val[1], val[2]);

	Double_t fmin;
	Double_t edm,errdef;
	Int_t nvpar,nparx,icstat;
	gMinuit->mnstat(fmin,edm,errdef,nvpar,nparx,icstat);
	*fchi2 = fmin;
	if (progpar.verbose) printf(" Minimal function value: %8.3lf  \n",fmin);

    } else {
	pp1 = p1i;
	pp2 = p2i;
	pp3 = p3i;
	pp4 = p4i;
    }

    if (progpar.verbose) {
	printf("Kinematic fitter: \n");
	printf("  Input: pk=%lf, p2=%lf, p3=%lf, p4=%lf\n", p1i, p2i, p3i, p4i);
	printf("  Out:   pk=%lf, p2=%lf, p3=%lf, p4=%lf\n", pp1, pp2, pp3, pp4);
    }

    double thetak = ktrrec_.TETRAK[dcand_t1]/180.*PI;
    double phik = ktrrec_.FITRAK[dcand_t1]/180.*PI;

    double theta1 = ktrrec_.TETRAK[dcand_t2]/180.*PI;
    double phi1 = ktrrec_.FITRAK[dcand_t2]/180.*PI;

    double theta2 = ktrrec_.TETRAK[dcand_t3]/180.*PI;
    double phi2 = ktrrec_.FITRAK[dcand_t3]/180.*PI;

    double theta3 = ktrrec_.TETRAK[dcand_t4]/180.*PI;
    double phi3 = ktrrec_.FITRAK[dcand_t4]/180.*PI;

    if (enable) {
	refit(dcand_t1, pp1, &phik, &thetak);
	refit(dcand_t2, pp2, &phi1, &theta1);
	refit(dcand_t3, pp3, &phi2, &theta2);
	refit(dcand_t4, pp4, &phi3, &theta3);
    }
    double pxk = pp1*sin(thetak)*cos(phik);
    double pyk = pp1*sin(thetak)*sin(phik);
    double pzk = pp1*cos(thetak);

    double px1 = pp2*sin(theta1)*cos(phi1);
    double py1 = pp2*sin(theta1)*sin(phi1);
    double pz1 = pp2*cos(theta1);

    double px2 = pp3*sin(theta2)*cos(phi2);
    double py2 = pp3*sin(theta2)*sin(phi2);
    double pz2 = pp3*cos(theta2);

    double px3 = pp4*sin(theta3)*cos(phi3);
    double py3 = pp4*sin(theta3)*sin(phi3);
    double pz3 = pp4*cos(theta3);

    *mbc = ebeam*ebeam - pow(px1+px2+px3+pxk,2) - pow(py1+py2+py3+pyk,2) - pow(pz1+pz2+pz3+pzk,2);
    if (*mbc>0) *mbc = sqrt(*mbc); else *mbc = 0;

    if (progpar.verbose) printf("pk=%lf, pp2=%lf, pp3=%lf, pp4=%lf\n", pp1, pp2, pp3, pp4);

    if( idATC==1 ){            //piK
	*de = sqrt(mpi*mpi+p1i*p1i) + sqrt(mk*mk + p4i*p4i) + sqrt(mpi*mpi+p2i*p2i) + sqrt(mpi*mpi+p3i*p3i) - ebeam;
    }
    if( idATC==2 ){            //Kpi
	*de = sqrt(mk*mk+p1i*p1i) + sqrt(mpi*mpi + p4i*p4i) + sqrt(mpi*mpi+p2i*p2i) + sqrt(mpi*mpi+p3i*p3i) - ebeam;
    }
    else{
	*de = sqrt(mk*mk + p1i*p1i) + sqrt(mpi*mpi+p4i*p4i) + sqrt(mpi*mpi+p2i*p2i) + sqrt(mpi*mpi+p3i*p3i) - ebeam;
    }

    *prec1 = pp1;
    *prec2 = pp2;
    *prec3 = pp3;
    *prec4 = pp4;

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

void others(int t1, int t2, int t3, int t4, int* num, double *en) {
    int t, cl;
    *num = 0;
    *en = 0.;
    for (t=0; t<eTracksAll; t++) if ( t != t1 && t != t2 && t != t3 && t != t4 ) {
	(*num)++;
	for (cl=0; cl<semc.emc_ncls; cl++) {
	    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t]) < THETA_CL_CUT &&
		fabs(clust_dist(t, cl)) < DIST_CL_CUT) {
		*en += semc.emc_energy[cl];
	    }
	}
    }
    //  printf("numo=%d\n", *num);
}


int intersect(double vdrad, double x0, double y0, double trad,
              double *phi1, double *phi2) {

  double tdist = sqrt(x0*x0 + y0*y0);
  double tang;
  double dang;
  double frac, num, denum;

  if (fabs(x0) > 1e-10) {
    tang=atan(y0/x0);
  } else {
    tang=PI/2.;
  }
  if (x0<0) tang+=PI;
  tang = (tang/2./PI-floor(tang/2./PI))*2.*PI;

  num = vdrad*vdrad + tdist*tdist - trad*trad;
  denum = 2.*vdrad*tdist;

//  printf("x0=%f y0=%f trad=%f vdrad=%f tang=%f tdist=%f num=%f denum=%f\n",
//         x0, y0, trad, vdrad, tang, tdist, num, denum);

  if (denum > 1e-10) {
    frac = num/denum;
    if (frac > -1. && frac < 1.) {
      dang = acos(frac);
      *phi1 = tang + dang;
      *phi2 = tang - dang;
      return (1);
    }
  }
  return (0);
}


// Coordinates of intersection of two tracks in (x,y) plane.
// Return distance from intersection point to detector axis
double track_intersect(int t1, int t2, double *x, double *y) {
  double x1   = tXc(t1);
  double y1   = tYc(t1);
  double rad1 = tRc(t1);
  double ph01 = tPh0(t1);
  double x2   = tXc(t2);
  double y2   = tYc(t2);
  double rad2 = tRc(t2);
  double ph02 = tPh0(t2);
  double vdrad = rad2;
  double x0 = x1-x2;
  double y0 = y1-y2;
  double phi1, phi2;
  if (intersect(vdrad, x0, y0, rad1, &phi1, &phi2)) {
    double ix1 = x2 + rad2*cos(phi1);
    double iy1 = y2 + rad2*sin(phi1);
    double ix2 = x2 + rad2*cos(phi2);
    double iy2 = y2 + rad2*sin(phi2);
//    printf("  %f %f\n",ix1,iy1);
//    printf("  %f %f\n",ix2,iy2);
    double r1 = sqrt(ix1*ix1 + iy1*iy1);
    double r2 = sqrt(ix2*ix2 + iy2*iy2);
    double phi, rmin;
    if (r1<r2) {
      rmin = r1;
      phi = phi1+PI;
      *x = ix1;
      *y = iy1;
    } else {
      rmin = r2;
      phi = phi2+PI;
      *x = ix2;
      *y = iy2;
    }
    return (rmin);
  }
//  getchar();
  return (-1.);
}


int analyse_event()
{
    float EMinPhot=progpar.min_cluster_energy;
    double  WTotal=2*beam_energy;                                                                 //beam_energy - How determined this energy ?
    if( kedrrun_cb_.Header.RunType == 64 ) {
        kmctracks();
	WTotal=2*1888.75;
    }                                  //for MC
    ebeam=WTotal/2.;

    if (progpar.verbose) cout<<"RunNumber="<<kedrraw_.Header.RunNumber<<"\t"<<"WTotal="<<WTotal<<"\t"<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<endl;
    if (progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<"\t"<<"eTracksBeam="<<eTracksBeam<<"\t"<<"eTracksIP="<<eTracksIP<<endl;

    int i=0;

    for (int t1 = 0; t1 < eTracksAll; t1++)                                  //cycle for first track
    {
	for (int t2 = 0; t2 < eTracksAll; t2++)
	{
	    for (int t3 = 0; t3 < eTracksAll; t3++)
	    {
		if ( (t2 > t3) ){
		    for (int t4 = 0; t4 < eTracksAll; t4++)
		    {
			if ( (t4 != t1) ){
			    //condition for part1: K-,  part2: pi+,  part3: pi+,  part4: pi-    (D0->K-pi+pi+pi-)
			    if ((tCharge(t1) == -1 && tCharge(t2) ==  1 && tCharge(t3) ==  1 && tCharge(t4) ==  -1) || (tCharge(t1) ==  1 && tCharge(t2) == -1 && tCharge(t3) == -1 && tCharge(t4) == 1))
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
				double xx4=tX0IP(t4)*tX0IP(t4);
				double yy4=tY0IP(t4)*tY0IP(t4);
				double rr4=sqrt(xx4+yy4);

				if ( fabs(tZ0IP(t1))>20. ) continue;
				if ( fabs(tZ0IP(t2))>20. ) continue;
				if ( fabs(tZ0IP(t3))>20. ) continue;
				if ( fabs(tZ0IP(t4))>20. ) continue;
				if ( rr1>8. ) continue;
				if ( rr2>8. ) continue;
				if ( rr3>8. ) continue;
				if ( rr4>8. ) continue;

                                double ix, iy;
                                Dmeson.r_track_intersect12 = track_intersect(t1,t2,&ix, &iy);
                                Dmeson.r_track_intersect13 = track_intersect(t1,t3,&ix, &iy);
                                Dmeson.r_track_intersect14 = track_intersect(t1,t4,&ix, &iy);

                                Dmeson.r_track_intersect23 = track_intersect(t2,t3,&ix, &iy);
                                Dmeson.r_track_intersect24 = track_intersect(t2,t4,&ix, &iy);

                                Dmeson.r_track_intersect34 = track_intersect(t3,t4,&ix, &iy);


				if (progpar.verbose) cout<<"rr1="<<rr1<<"\t"<<"fabs(tZ0IP(t1))="<<fabs(tZ0IP(t1))<<endl;
				if (progpar.verbose) cout<<"rr2="<<rr2<<"\t"<<"fabs(tZ0IP(t2))="<<fabs(tZ0IP(t2))<<endl;
				if (progpar.verbose) cout<<"rr3="<<rr3<<"\t"<<"fabs(tZ0IP(t3))="<<fabs(tZ0IP(t3))<<endl;
				if (progpar.verbose) cout<<"rr4="<<rr4<<"\t"<<"fabs(tZ0IP(t4))="<<fabs(tZ0IP(t4))<<endl;

				if( tPt(t1)<=progpar.min_momentum || tPt(t1)>=progpar.max_momentum )  continue;
				if( tCh2(t1)>progpar.max_tchi2 )  continue;
				if( tHits(t1)<progpar.min_Nhits )  continue;

				if( tPt(t2)<=progpar.min_momentum || tPt(t2)>=progpar.max_momentum )  continue;
				if( tCh2(t2)>progpar.max_tchi2 )  continue;
				if( tHits(t2)<progpar.min_Nhits )  continue;

				if( tPt(t3)<=progpar.min_momentum || tPt(t3)>=progpar.max_momentum )  continue;
				if( tCh2(t3)>progpar.max_tchi2 )  continue;
				if( tHits(t3)<progpar.min_Nhits )  continue;

				if( tPt(t4)<=progpar.min_momentum || tPt(t4)>=progpar.max_momentum )  continue;
				if( tCh2(t4)>progpar.max_tchi2 )  continue;
				if( tHits(t4)<progpar.min_Nhits )  continue;

				Dmeson.rr1 = rr1;
				Dmeson.rr2 = rr2;
				Dmeson.rr3 = rr3;
				Dmeson.rr4 = rr4;
				Dmeson.zip1 = tZ0IP(t1);
				Dmeson.zip2 = tZ0IP(t2);
				Dmeson.zip3 = tZ0IP(t3);
				Dmeson.zip4 = tZ0IP(t4);

				if (progpar.verbose) cout<<"i="<< i<<endl;
				if (progpar.verbose) cout<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"Ebeam="<<WTotal/2<<"\t"<<"t1="<<t1<<"\t"<<"t2="<<t2<<"\t"<<"t3="<<t3<<"\t"<<"t4="<<t4<<"\t"<<"tCharge(t1)="<<tCharge(t1)<<"\t"<<"tCharge(t2)="<<tCharge(t2)<<"\t"<<"tCharge(t3)="<<tCharge(t3)<<"\t"<<"tCharge(t4)="<<tCharge(t4)<<endl;
				if (progpar.verbose) cout<<"P(t1)="<<tP(t1)<<"\t"<<"P(t2)="<<tP(t2)<<"\t"<<"P(t3)="<<tP(t3)<<"\t"<<"P(t4)="<<tP(t4)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tHits(t3)="<<tHits(t3)<<"\t"<<"tHits(t4)="<<tHits(t4)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<"\t"<<"tCh2(t3)="<<tCh2(t3)<<"\t"<<"tCh2(t4)="<<tCh2(t4)<<endl;
				if (progpar.verbose) cout<<"Pcor(t1)="<<pcorr(tP(t1),2)<<"\t"<<"Pcor(t2)="<<pcorr(tP(t2),1)<<"\t"<<"Pcor(t3)="<<pcorr(tP(t3),1)<<"\t"<<"Pcor(t4)="<<pcorr(tP(t4),1)<<endl;

				double px1, px2, px3, px4, py1, py2, py3, py4, pz1, pz2, pz3, pz4;
				px1 = pcorr(tP(t1),2)*tVx(t1);
				px2 = pcorr(tP(t2),1)*tVx(t2);
				px3 = pcorr(tP(t3),1)*tVx(t3);
				px4 = pcorr(tP(t4),1)*tVx(t4);
				py1 = pcorr(tP(t1),2)*tVy(t1);
				py2 = pcorr(tP(t2),1)*tVy(t2);
				py3 = pcorr(tP(t3),1)*tVy(t3);
				py4 = pcorr(tP(t4),1)*tVy(t4);
				pz1 = pcorr(tP(t1),2)*tVz(t1);
				pz2 = pcorr(tP(t2),1)*tVz(t2);
				pz3 = pcorr(tP(t3),1)*tVz(t3);
				pz4 = pcorr(tP(t4),1)*tVz(t4);

				Dmeson.p1 = tP(t1);      //kaon
				Dmeson.p2 = tP(t2);      //pion
				Dmeson.p3 = tP(t3);      //pion
				Dmeson.p4 = tP(t4);      //pion

				Dmeson.pt1 = tPt(t1);
				Dmeson.pt2 = tPt(t2);
				Dmeson.pt3 = tPt(t3);
				Dmeson.pt4 = tPt(t4);

				Dmeson.vrtntrk = eTracksAll;
				Dmeson.vrtnip = eTracksIP;
				Dmeson.vrtnbeam = eTracksBeam;

				Dmeson.thetat1 = tTeta(t1);
				Dmeson.thetat2 = tTeta(t2);
				Dmeson.thetat3 = tTeta(t3);
				Dmeson.thetat4 = tTeta(t4);

				Dmeson.phit1 = ktrrec_.FITRAK[t1]+(ktrrec_.FITRAK[t1]<0?360:0);;
				Dmeson.phit2 = ktrrec_.FITRAK[t2]+(ktrrec_.FITRAK[t2]<0?360:0);;
				Dmeson.phit3 = ktrrec_.FITRAK[t3]+(ktrrec_.FITRAK[t3]<0?360:0);;
				Dmeson.phit4 = ktrrec_.FITRAK[t4]+(ktrrec_.FITRAK[t4]<0?360:0);;

				Dmeson.chi2t1 = tCh2(t1);
				Dmeson.chi2t2 = tCh2(t2);
				Dmeson.chi2t3 = tCh2(t3);
				Dmeson.chi2t4 = tCh2(t4);

				Dmeson.charge1 = ktrrec_.CHTRAK[t1];
				Dmeson.charge2 = ktrrec_.CHTRAK[t2];
				Dmeson.charge3 = ktrrec_.CHTRAK[t3];
				Dmeson.charge4 = ktrrec_.CHTRAK[t4];

				Dmeson.nhitsvd=kvdrec_.NHITVD;
				Dmeson.nhitsdc=kdcrec_.NHIT;

				Dmeson.nhitst1 = tHits(t1);
				Dmeson.nhitst2 = tHits(t2);
				Dmeson.nhitst3 = tHits(t3);
				Dmeson.nhitst4 = tHits(t4);

				Dmeson.nhitsvdt1 = tHitsVD(t1);
				Dmeson.nhitsvdt2 = tHitsVD(t2);
				Dmeson.nhitsvdt3 = tHitsVD(t3);
				Dmeson.nhitsvdt4 = tHitsVD(t4);

				Dmeson.nhitsxyt1 = tHitsXY(t1);
				Dmeson.nhitszt1 = tHits(t1)-tHitsXY(t1);

				Dmeson.nhitsxyt2 = tHitsXY(t2);
				Dmeson.nhitszt2 = tHits(t2)-tHitsXY(t2);

				Dmeson.nhitsxyt3 = tHitsXY(t3);
				Dmeson.nhitszt3 = tHits(t3)-tHitsXY(t3);

				Dmeson.nhitsxyt4 = tHitsXY(t4);
				Dmeson.nhitszt4 = tHits(t4)-tHitsXY(t4);

				Dmeson.nvect1 = tVectors(t1);
				Dmeson.nvecxyt1 = tVectorsXY(t1);
				Dmeson.nveczt1 = tVectorsZ(t1);

				Dmeson.nvect2 = tVectors(t2);
				Dmeson.nvecxyt2 = tVectorsXY(t2);
				Dmeson.nveczt2 = tVectorsZ(t2);

				Dmeson.nvect3 = tVectors(t3);
				Dmeson.nvecxyt3 = tVectorsXY(t3);
				Dmeson.nveczt3 = tVectorsZ(t3);

				Dmeson.nvect4 = tVectors(t4);
				Dmeson.nvecxyt4 = tVectorsXY(t4);
				Dmeson.nveczt4 = tVectorsZ(t4);

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
				for(int c2=0; c2<semc.dc_emc_ncls[t2]; c2++)
				{
				    cl_tr2=semc.dc_emc_cls[t2][c2]-1;
				    energy_on_track2+=semc.emc_energy[cl_tr2];
				}

				float energy_on_track3=0;
				int cl_tr3=0;
				for(int c3=0; c3<semc.dc_emc_ncls[t3]; c3++)
				{
				    cl_tr3=semc.dc_emc_cls[t3][c3]-1;
				    energy_on_track3+=semc.emc_energy[cl_tr3];
				}

				float energy_on_track4=0;
				int cl_tr4=0;
				for(int c4=0; c4<semc.dc_emc_ncls[t4]; c4++)
				{
				    cl_tr4=semc.dc_emc_cls[t4][c4]-1;
				    energy_on_track4+=semc.emc_energy[cl_tr4];
				}

				Dmeson.e1 = energy_on_track1;
				Dmeson.e2 = energy_on_track2;
				Dmeson.e3 = energy_on_track3;
				Dmeson.e4 = energy_on_track4;
				if (progpar.verbose) cout<<"Dmeson.e1="<<Dmeson.e1<<"\t"<<"Dmeson.e2="<<Dmeson.e2<<"\t"<<"Dmeson.e3="<<Dmeson.e3<<"\t"<<"Dmeson.e4="<<Dmeson.e4<<endl;

				Dmeson.ecls1=0;
				Dmeson.ncls1=0;
				Dmeson.ecls2=0;
				Dmeson.ncls2=0;
				Dmeson.ecls3=0;
				Dmeson.ncls3=0;
				Dmeson.ecls4=0;
				Dmeson.ncls4=0;

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

				    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t3]) < THETA_CL_CUT &&
					fabs(clust_dist(t3, cl)) < DIST_CL_CUT) {
					Dmeson.ecls3 += semc.emc_energy[cl];
					Dmeson.tcls3 = semc.emc_theta[cl]-ktrrec_.TETRAK[t3];
					Dmeson.pcls3 = clust_dist(t3, cl);
					Dmeson.ncls3++;
				    }

				    if (fabs(semc.emc_theta[cl]-ktrrec_.TETRAK[t4]) < THETA_CL_CUT &&
					fabs(clust_dist(t4, cl)) < DIST_CL_CUT) {
					Dmeson.ecls4 += semc.emc_energy[cl];
					Dmeson.tcls4 = semc.emc_theta[cl]-ktrrec_.TETRAK[t4];
					Dmeson.pcls4 = clust_dist(t4, cl);
					Dmeson.ncls4++;
				    }

				}

				neutrals(&numn, &enn, &pxn, &pyn, &pzn);
				others(t1, t2, t3, t4, &numo, &eno);

				Dmeson.numn = numn;
				Dmeson.enn = enn;
				Dmeson.numo = numo;
				Dmeson.eno = eno;


				double tof = 0;

				if ( kedrrun_cb_.Header.RunType == 64 ) {
				    int tmc;
				    for (tmc=0; tmc < mctracks_cb_.Ntracks; tmc++) {
					if (match_dir(tmc, t1) &&
					    (abs(mctracks_cb_.kf[tmc]) == 211 ||
					     abs(mctracks_cb_.kf[tmc]) == 321)) {
					    double p = ktrrec_.PTRAK[t1];
					    double th = ktrrec_.TETRAK[t1]/180*PI;
					    double tlen = kscBhit_.len[t1][0];
					    int id = mctracks_cb_.kf[tmc];
					    if (abs(id) == 211) tof = sqrt(139.*139. + p*p)/p*tlen/30.;
					    if (abs(id) == 321) tof = sqrt(494.*494. + p*p)/p*tlen/30.;

					    float r1 = 0, r2 = 0;
					    rndm.Rannor(r1, r2);    //Return 2 numbers distributed following a gaussian with mean=0 and sigma=1.
					    if (progpar.verbose) cout<<"r1="<<r1<<"\t"<<"r2="<<r2<<endl;
					    //RANECU(r2, 1, 1);       //RANECU generates a sequence of uniformly distributed random numbers in the interval (0,1).
					    r2 = rndm.Rndm();

					    tof += r1*0.420;
					    if (progpar.verbose) cout<<"r2="<<r2<<"\t"<<"tof="<<tof<<endl;
					    if (r2 < 0.15) tof = 0.;

					    if (progpar.verbose) printf("Tr %d, MC %d, id=%d, p=%f, th=%f, l=%f, tof=%f\n",t1, tmc, id, p, th, tlen, tof);
					}
				    }
				}

				Dmeson.timet1 = kedrrun_cb_.Header.RunType != 64 ? kscBhit_.time_B_ns[t1][0] : tof;
				Dmeson.betat1=kscBhit_.Beta[t1][0];         //v/c
				Dmeson.lengtht1 = kscBhit_.len[t1][0];

				Dmeson.timet2 = kscBhit_.time_B_ns[t2][0];
				Dmeson.betat2 = kscBhit_.Beta[t2][0];
				Dmeson.lengtht2 = kscBhit_.len[t2][0];

				Dmeson.timet3 = kscBhit_.time_B_ns[t3][0];
				Dmeson.betat3 = kscBhit_.Beta[t3][0];
				Dmeson.lengtht3 = kscBhit_.len[t3][0];

				Dmeson.timet4 = kscBhit_.time_B_ns[t4][0];
				Dmeson.betat4 = kscBhit_.Beta[t4][0];
				Dmeson.lengtht4 = kscBhit_.len[t4][0];

				if (progpar.verbose)  cout<<"timet1="<<Dmeson.timet1<<"\t"<<"timet2="<<Dmeson.timet2<<"\t"<<"timet3="<<Dmeson.timet3<<"\t"<<"timet4="<<Dmeson.timet4<<endl;

				i++;
				Dmeson.ncomb = i;
				Dmeson.rEv = kedrraw_.Header.Number;
				Dmeson.Run = kedrraw_.Header.RunNumber;
				Dmeson.Ebeam=WTotal/2.;

				int mu_hits = mu_next_event_good();
				Dmeson.munhits = mu_hits;
				int mu_hit;
				int mu_layer_hits[3] = {0, 0, 0};    //hits in each layer of mu system  - all 3 layer

				for (mu_hit = 0; mu_hit < mu_hits; mu_hit++) {
				    int layer = mu_hit_layer(mu_hit);
				    if (layer >= 1 && layer <= 3) mu_layer_hits[layer-1]++;
				}

				Dmeson.mulayerhits1 = mu_layer_hits[0];
				Dmeson.mulayerhits2 = mu_layer_hits[1];
				Dmeson.mulayerhits3 = mu_layer_hits[2];

				atc_to_track(t1);
				if (progpar.verbose) cout<<"t1="<<t1<<"\t"<<"atctrackinfo.ncnt="<<atctrackinfo.ncnt<<endl;
				float totalNpe1=0;
				int cnt;
				int good_region_t1=0;
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

				    if( Dmeson.wlshitt1[i]!=1 ) good_region_t1++;
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

				atc_to_track(t3);
				float totalNpe3=0;
				Dmeson.natccrosst3=atctrackinfo.ncnt;
				if (progpar.verbose) cout<<"t3="<<t3<<"\t"<<"atctrackinfo.ncnt="<<atctrackinfo.ncnt<<endl;
				for(int i=0; i<atctrackinfo.ncnt; i++)
				{
				    Dmeson.atcCNTt3[i]=atctrackinfo.cnt[i];
				    cnt=atctrackinfo.cnt[i];
				    Dmeson.atcNpet3[i]=atctrackinfo.npe[cnt];

				    Dmeson.tlent3[i]=atctrackinfo.tlen[cnt];
				    Dmeson.wlshitt3[i]=atctrackinfo.wlshit[cnt];
				    Dmeson.nearwlst3[i]=atctrackinfo.nearwls[cnt];

				    Dmeson.aerogel_REGIONt3[i]=atctrackinfo.aerogel_REGION[cnt];
				    Dmeson.aerogel_REGION0t3[i]=atctrackinfo.aerogel_REGION0[cnt];
				    Dmeson.aerogel_REGION5t3[i]=atctrackinfo.aerogel_REGION5[cnt];
				    Dmeson.aerogel_REGION20t3[i]=atctrackinfo.aerogel_REGION20[cnt];

				    Dmeson.single_aerogel_REGIONt3[i]=atctrackinfo.single_aerogel_REGION[cnt];
				    Dmeson.single_aerogel_REGION0t3[i]=atctrackinfo.single_aerogel_REGION0[cnt];
				    Dmeson.single_aerogel_REGION5t3[i]=atctrackinfo.single_aerogel_REGION5[cnt];
				    Dmeson.single_aerogel_REGION20t3[i]=atctrackinfo.single_aerogel_REGION20[cnt];

				    if (progpar.verbose) cout<<"atc cnt="<<Dmeson.atcCNTt3[i]<<"\t"<<"npe="<<Dmeson.atcNpet3[i]<<endl;
				    totalNpe3 += atctrackinfo.npe[cnt];
				}
				if (progpar.verbose) cout<<"t3="<<t3<<"\t"<<"Total ATC Npe="<<totalNpe3<<endl;
				Dmeson.atcTotalNpet3=totalNpe3;

				atc_to_track(t4);
				float totalNpe4=0;
				Dmeson.natccrosst4=atctrackinfo.ncnt;
				int good_region_t4=0;
				if (progpar.verbose) cout<<"t4="<<t4<<"\t"<<"atctrackinfo.ncnt="<<atctrackinfo.ncnt<<endl;
				for(int i=0; i<atctrackinfo.ncnt; i++)
				{
				    Dmeson.atcCNTt4[i]=atctrackinfo.cnt[i];
				    cnt=atctrackinfo.cnt[i];
				    Dmeson.atcNpet4[i]=atctrackinfo.npe[cnt];

				    Dmeson.tlent4[i]=atctrackinfo.tlen[cnt];
				    Dmeson.wlshitt4[i]=atctrackinfo.wlshit[cnt];
				    Dmeson.nearwlst4[i]=atctrackinfo.nearwls[cnt];

				    Dmeson.aerogel_REGIONt4[i]=atctrackinfo.aerogel_REGION[cnt];
				    Dmeson.aerogel_REGION0t4[i]=atctrackinfo.aerogel_REGION0[cnt];
				    Dmeson.aerogel_REGION5t4[i]=atctrackinfo.aerogel_REGION5[cnt];
				    Dmeson.aerogel_REGION20t4[i]=atctrackinfo.aerogel_REGION20[cnt];

				    Dmeson.single_aerogel_REGIONt4[i]=atctrackinfo.single_aerogel_REGION[cnt];
				    Dmeson.single_aerogel_REGION0t4[i]=atctrackinfo.single_aerogel_REGION0[cnt];
				    Dmeson.single_aerogel_REGION5t4[i]=atctrackinfo.single_aerogel_REGION5[cnt];
				    Dmeson.single_aerogel_REGION20t4[i]=atctrackinfo.single_aerogel_REGION20[cnt];

				    if (progpar.verbose) cout<<"atc cnt="<<Dmeson.atcCNTt4[i]<<"\t"<<"npe="<<Dmeson.atcNpet4[i]<<endl;
				    totalNpe4 += atctrackinfo.npe[cnt];

				    if( Dmeson.wlshitt4[i]!=1 ) good_region_t4++;
				}
				if (progpar.verbose) cout<<"t4="<<t4<<"\t"<<"Total ATC Npe="<<totalNpe4<<endl;
				Dmeson.atcTotalNpet4=totalNpe4;

				double npetrh=0.5;

				//if( ( good_region_t1>=1 && Dmeson.atcTotalNpet1>npetrh) && (good_region_t4>=1 && Dmeson.atcTotalNpet4<=npetrh) ){ idATC=1;}  //pi - t1, K - t4
				//if( (good_region_t1>=1 && Dmeson.atcTotalNpet1<=npetrh) && (good_region_t4>=1 && Dmeson.atcTotalNpet4>npetrh) ){ idATC=2;}  //K - t1, pi -t4

				double mbc, de, prec1, prec2, prec3, prec4, fchi2;

				kine_fit(t1, t2, t3, t4, &mbc, &de, &prec1, &prec2, &prec3, &prec4, &fchi2, progpar.Dkine_fit);
				idATC=0;
				Dmeson.mbc = mbc;
				Dmeson.de = de;
				Dmeson.fchi2 = fchi2;
				Dmeson.prec1 = prec1;
				Dmeson.prec2 = prec2;
				Dmeson.prec3 = prec3;
				Dmeson.prec4 = prec4;

                                //DC identification
				Dmeson.dedxt1 = dcinfo.dedx[t1];
				Dmeson.dedxt2 = dcinfo.dedx[t2];
				Dmeson.dedxt3 = dcinfo.dedx[t3];
				Dmeson.dedxt4 = dcinfo.dedx[t4];

			        Dmeson.probpit1 = dcinfo.p[t1][2];
                                Dmeson.probpit2 = dcinfo.p[t2][2];
                                Dmeson.probpit3 = dcinfo.p[t3][2];
                                Dmeson.probpit4 = dcinfo.p[t4][2];
                                Dmeson.resdpit1 = dcinfo.d[t1][2];
                                Dmeson.resdpit2 = dcinfo.d[t2][2];
                                Dmeson.resdpit3 = dcinfo.d[t3][2];
                                Dmeson.resdpit4 = dcinfo.d[t4][2];

 				Dmeson.probKt1 = dcinfo.p[t1][3];
				Dmeson.probKt2 = dcinfo.p[t2][3];
				Dmeson.probKt3 = dcinfo.p[t3][3];
				Dmeson.probKt4 = dcinfo.p[t4][3];
				Dmeson.resdKt1 = dcinfo.d[t1][3];
				Dmeson.resdKt2 = dcinfo.d[t2][3];
				Dmeson.resdKt3 = dcinfo.d[t3][3];
				Dmeson.resdKt4 = dcinfo.d[t4][3];

                                if (progpar.verbose) cout<<"dcinfo.st[t1]="<<dcinfo.st[t1]<<"\t"<<"dcinfo.st[t2]="<<dcinfo.st[t2]<<"\t"<<"dcinfo.st[t3]="<<dcinfo.st[t3]<<"\t"<<"dcinfo.st[t4]="<<dcinfo.st[t4]<<endl;
                                if (progpar.verbose) cout<<"dcinfo.bhypo[t1]="<<dcinfo.bhypo[t1]<<"\t"<<"dcinfo.bhypo[t2]="<<dcinfo.bhypo[t2]<<"\t"<<"dcinfo.bhypo[t3]="<<dcinfo.bhypo[t3]<<"\t"<<"dcinfo.bhypo[t4]="<<dcinfo.bhypo[t4]<<"\t"<<endl;
                                if (progpar.verbose) cout<<"dedxt1="<<Dmeson.dedxt1<<"\t"<<"dedxt2="<<Dmeson.dedxt2<<"\t"<<"dedxt3="<<Dmeson.dedxt3<<"\t"<<"dedxt4="<<Dmeson.dedxt4<<endl;
				if (progpar.verbose) cout<<"Pion "<<"probt1="<<dcinfo.p[t1][2]<<"\t"<<"probt2="<<dcinfo.p[t2][2]<<"\t"<<"probt3="<<dcinfo.p[t3][2]<<"\t"<<"probt4="<<dcinfo.p[t4][2]<<endl;
				if (progpar.verbose) cout<<"Kaon "<<"probt1="<<dcinfo.p[t1][3]<<"\t"<<"probt2="<<dcinfo.p[t2][3]<<"\t"<<"probt3="<<dcinfo.p[t3][3]<<"\t"<<"probt4="<<dcinfo.p[t4][3]<<endl;

                                Dmeson.kft1 = mctracks_cb_.kf[t1]; 
                                Dmeson.kft2 = mctracks_cb_.kf[t2]; 
                                Dmeson.kft3 = mctracks_cb_.kf[t3]; 
                                Dmeson.kft4 = mctracks_cb_.kf[t4]; 
                                
                                if (progpar.verbose) cout<<"kft1="<<Dmeson.kft1<<"\t"<<"kft2="<<Dmeson.kft2<<"\t"<<"kft3="<<Dmeson.kft3<<"\t"<<"kft4="<<Dmeson.kft4<<"\t"<<endl;
	
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
            	<<"  -v MCCalibRunNumber    MCCalibRunNumber (default to "<<def_progpar.MCCalibRunNumber<<")\n"
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
	eventTree->Branch("Dmeson",&Dmeson,"vrtntrk/I:vrtnip:vrtnbeam:charge1:charge2:charge3:charge4:nhitsdc:nhitst1:nhitst2:nhitst3:nhitst4:nhitsvd:nhitsvdt1:nhitsvdt2:nhitsvdt3:nhitsvdt4"
			  ":nhitsxyt1:nhitszt1:nhitsxyt2:nhitszt2:nhitsxyt3:nhitszt3:nhitsxyt4:nhitszt4:nvect1:nvecxyt1:nveczt1:nvect2:nvecxyt2:nveczt2:nvect3:nvecxyt3"
			  ":nveczt3:nvect4:nvecxyt4:nveczt4:ncomb:ncls1:ncls2:ncls3:ncls4:ncls:nlkr:ncsi:munhits:mulayerhits1:mulayerhits2:mulayerhits3:Run:numn:numo:natccrosst1:atcCNTt1[20]:natccrosst2:atcCNTt2[20]"
			  ":natccrosst3:atcCNTt3[20]:natccrosst4:atcCNTt4[20]:aerogel_REGIONt1[20]:aerogel_REGION0t1[20]:aerogel_REGION5t1[20]:aerogel_REGION20t1[20]:single_aerogel_REGIONt1[20]"
                          ":single_aerogel_REGION0t1[20]:single_aerogel_REGION5t1[20]:single_aerogel_REGION20t1[20]:aerogel_REGIONt2[20]:aerogel_REGION0t2[20]:aerogel_REGION5t2[20]"
			  ":aerogel_REGION20t2[20]:single_aerogel_REGIONt2[20]:single_aerogel_REGION0t2[20]:single_aerogel_REGION5t2[20]:single_aerogel_REGION20t2[20]"
			  ":aerogel_REGIONt3[20]:aerogel_REGION0t3[20]:aerogel_REGION5t3[20]:aerogel_REGION20t3[20]:single_aerogel_REGIONt3[20]:single_aerogel_REGION0t3[20]"
			  ":single_aerogel_REGION5t3[20]:single_aerogel_REGION20t3[20]:aerogel_REGIONt4[20]:aerogel_REGION0t4[20]:aerogel_REGION5t4[20]:aerogel_REGION20t4[20]:single_aerogel_REGIONt4[20]"
			  ":single_aerogel_REGION0t4[20]:single_aerogel_REGION5t4[20]:single_aerogel_REGION20t4[20]:wlshitt1[20]:nearwlst1[20]:wlshitt2[20]:nearwlst2[20]:wlshitt3[20]:nearwlst3[20]:wlshitt4[20]:nearwlst4[20]"
                          ":kft1:kft2:kft3:kft4" 
			  ":mbc/F:de:prec1:prec2:prec3:prec4:fchi2:Ebeam:rEv:P1:P2:P3:P4:Pt1:Pt2:Pt3:Pt4:thetat1:thetat2:thetat3:thetat4:phit1:phit2:phit3:phit4:chi2t1:chi2t2:chi2t3:chi2t4:e1"
			  ":e2:e3:e4:rr1:rr2:rr3:rr4:Zip1:Zip2:Zip3:Zip4:ecls1:ecls2:ecls3:ecls4:tcls1:tcls2:tcls3:tcls4:pcls1"
			  ":pcls2:pcls3:pcls4:emcenergy:lkrenergy:csienergy:enn:eno:timet1:betat1:lengtht1:timet2:betat2:lengtht2:timet3:betat3:lengtht3:timet4:betat4:lengtht4:atcNpet1[20]:atcTotalNpet1"
			  ":atcNpet2[20]:atcTotalNpet2:atcNpet3[20]:atcTotalNpet3:atcNpet4[20]:atcTotalNpet4:tlent1[20]:tlent2[20]:tlent3[20]:tlent4[20]"
                          ":dedxt1:dedxt2:dedxt3:dedxt4:probKt1:probKt2:probKt3:probKt4:resdKt1:resdKt2:resdKt3:resdKt4:probpit1:probpit2:probpit3:probpit4:resdpit1:resdpit2:resdpit3:resdpit4"
                          ":r_track_intersect12:r_track_intersect13:r_track_intersect14:r_track_intersect23:r_track_intersect24:r_track_intersect34"
			 );
	//----------------- Configure kframework -----------------//
	//Set kframework signal handling
	kf_install_signal_handler(1);

        kdcswitches_.kNoiseReject=3;   //Cut for DC noise  (0 - not cut, 1 - standart, 2 - soft, 3 - hard)
        kdcswitches_.KemcAllowed=0;
	//kdcswitches_.KemcAllowed=-1;  //off use strips for track reconstruction

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
