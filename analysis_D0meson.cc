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

#define PI 3.14159265358979

using namespace std;

const int Natccr=4;           //number crossing ATC counters on track
const int Ntraks=6;           //number tracks
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
//7)minimal energy of cluster 15 МэВ
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
static const struct ProgramParameters def_progpar={false,2,6,1,1,6,100,2000,15,45,2,8,0,0,200,15,"/store/users/ovtin/out.root",19862,0,false,0};

static struct ProgramParameters progpar(def_progpar);

enum {
	CutLongDcRecord=1,
	CutLongVdRecord,
        AtcEventDamageCut,
        AtcIllegalTrackCut,
	CutTrackNumber,
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

typedef struct {Int_t numHyp; Float_t Mbc[6],InvM[6],dE[6],dP[6],depmkp[6],deppkm[6],Ebeam,rEv,chi2[50],M[50],P1[50],P2[50],P3[50],P4[50];} DMESON;
static DMESON Dmeson;

double mk = 493.68;
double mpi = 139.57;

int listtr[6],lclpi0[8],lclg[5];
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
    if( eTracksAll<progpar.min_track_number )       return CutTrackNumber;
    if( eTracksAll>progpar.max_track_number )       return CutTrackNumber;
    if( eTracksBeam<progpar.min_beam_track_number ) return CutBeamTrackNumber;
    if( eTracksIP<progpar.min_ip_track_number )     return CutIPTrackNumber_min;
    if( eTracksIP>progpar.max_ip_track_number )     return CutIPTrackNumber_max;

    double charge=0;
    for (int t = 0; t< eTracksAll; t++) {
	if( tPt(t)<=progpar.min_momentum )  return MinMomentumCut;
	if( tPt(t)>=progpar.max_momentum )  return MaxMomentumCut;
	if( tCh2(t)>progpar.max_tchi2 )  return Chi2Cut;
	if( tHits(t)<progpar.min_Nhits )  return tHitsCut;
	//charge += tCharge(t);
    }
    //if( (charge)!=0 )  return ChargeCut;   //if sum charge of tracks do not equal 0 then delete event

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
	    return CutClusterEnergy;
	}
	if( semc.dc_emc_ncls[t]<1 )                                 //if track do not have cluster - cut event
	{
	    return Cut_nclntrack;
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

    if( tot_energy<progpar.min_total_energy )           return CutTotalEnergy;
    if( nemc<progpar.min_cluster_number )               return CutMINClusterNumber;
    if( nemc>progpar.max_cluster_number )               return CutMAXClusterNumber;
    if( nlkr<progpar.min_lkrcl_number )                 return CutLkrClusterNumber;
    if( ncsi<progpar.min_csicl_number )                 return CutCsiClusterNumber;

    return 0;
}

int atc_rejection()
{
    //ATC raw record damaged in any way (including when DeltaT is absent or out of range)
    if( atc_rec.eventdamage ) return AtcEventDamageCut;

    //track determined as illegal by atcrec
    if( atc_track.illtrack[0] ) return AtcIllegalTrackCut;

    //no counters on tracks, very strange if occurs
    //if( atc_track.ncnt_on_track[0]==0 ) return NoAtcOnTrackCut;

    return 0;
}

int mu_event_rejection()
{
    if( mu_next_event()>0 ) return MUCut;           //for delete cosmic events

    return 0;
}


int analyse_event()
{
    float EMinPhot=progpar.min_cluster_energy;
    double  WTotal=2*beam_energy;                                                                 //beam_energy - How determined this energy ?
    if( kedrrun_cb_.Header.RunType == 64 ) { WTotal=2*1886.75; }                                  //for MC

    if (progpar.verbose) cout<<"RunNumber="<<kedrraw_.Header.RunNumber<<"\t"<<"WTotal="<<WTotal<<"\t"<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<endl;

    //apply tracks cut conditions
    if(eTracksBeam>=progpar.min_beam_track_number&&eTracksIP>=progpar.min_ip_track_number&&eTracksAll<=progpar.max_track_number)
    {
	if (progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<"\t"<<"eTracksBeam="<<eTracksBeam<<"\t"<<"eTracksIP="<<eTracksIP<<endl;

	copy(&bevent);
	bevent.event=kdcenum_.EvNum;

	unsigned short nhits=mu_next_event();

	copy(&bvertex);
	copy(&bemc);

	//==========================================================================================================
	//kinematic reconstruction
	int ntrfromip=0;
	for (int t=0; t<eTracksAll; t++)                                  //cycle for first track
	{
	    double xx=tX0IP(t)*tX0IP(t);
	    double yy=tY0IP(t)*tY0IP(t);
	    double rr=sqrt(xx+yy);
	    if (progpar.verbose) cout<<"rr="<<rr<<endl;                   //radius begin track

	    if(rr<5) {
		ntrfromip++;
		if(ntrfromip<=6){
		    listtr[ntrfromip-1]=t+1;                             //list identificator of traks ListTr[1:6]
		}
	    }
	}
	int nclnft=0;
	for(int cl=0; cl<semc.emc_ncls; cl++)
	{
	    if(semc.emc_dc_ntrk[cl]==0&&
	       semc.emc_energy[cl]>EMinPhot){
		nclnft++;
		if(nclnft<=8) {
		    lclpi0[nclnft-1]=cl+1;
		}
	    }
	}

	if (progpar.verbose) cout<<"Event="<<eDaqNumber<<"\t"<<"ntrfromip="<<ntrfromip<<"\t"<<"nclnft="<<nclnft<<endl;
	Dmeson.numHyp=0;
	for(int i=0; i<5; i++){
	    Dmeson.chi2[i]=0;
	    Dmeson.M[i]=0;
	    Dmeson.P1[i]=0;
	    Dmeson.P2[i]=0;
	    Dmeson.P3[i]=0;
	    Dmeson.P4[i]=0;
	}

	if(ntrfromip==4&&nclnft<=2) {
	    int qst=0;
	    int ntracks=4;
	    int npi0=0;
	    int ng=0;
	    reckfitmulticpi0gamma(&WTotal,&ntracks,&npi0,&ng,listtr,lclpi0,lclg,&qst);
	    if (progpar.verbose) cout<<"qst:"<<qst<<endl;
	    if(qst>=0){
		if (progpar.verbose) cout<<"NumOfHyp:"<<hNumOfHyp<<endl;
		for(int ih=0; ih<hNumOfHyp; ih++){
		    if (progpar.verbose) cout<<" chi2:"<<hHChi2(ih)<<endl;
		    Dmeson.chi2[ih]=hHChi2(ih);
		    for(int it=0; it<4; it++){
			if (progpar.verbose) cout<<"track:"<<it<<"  Mass:"<<hMPc(ih,it)<<"\t"<< "P:"<<hPPc(ih,it)<<endl;
			if(it==0){
			    Dmeson.M[ih]=hMPc(ih,it);
			    Dmeson.P1[ih]=hPPc(ih,it);
			}
			if(it==1){
			    Dmeson.P2[ih]=hPPc(ih,it);
			}
			if(it==2){
			    Dmeson.P3[ih]=hPPc(ih,it);
			}
			if(it==3){
			    Dmeson.P4[ih]=hPPc(ih,it);
			}
		    }
		}
	    }
	}
	Dmeson.numHyp=hNumOfHyp;
	if (progpar.verbose) cout<<"Dmeson.numHyp="<<Dmeson.numHyp<<"\t"<<"hNumOfHyp="<<hNumOfHyp<<endl;
	//===============================================================================================

	int i=0;

	for (int t1 = 0; t1 < eTracksAll; t1++)                                  //cycle for first track
	{
	    copy(&btrack[t1],t1);
	    copy(&btof[t1],t1);
	    copy(&bmu,t1,nhits);
	    copy(&batc);

	    for(int k=0; k<Natccr;  k++)                                         //cycle for number of crossing ATC counters on track
	    {
		if (progpar.verbose) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Track="<<t1<<"\t"<<"i="<<i<<"\t"<<"atc_track.cnt_cross[t][k]="<<atc_track.cnt_cross[t1][k]<<"\t"<<"atc_rec.npe="<<atc_rec.npe[atc_track.cnt_cross[t1][k]-1]<<endl;
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

	    for (int t2 = 0; t2 < eTracksAll; t2++)                              //cycle for second track
	    {
		if( tCharge(t1)<0 && tCharge(t2)>0 )       		         //condition for part1: K-, part2: pi+    (D0->K-pi+)
		{
		    if (progpar.verbose) cout<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"Ebeam="<<WTotal/2<<"\t"<<"t1="<<t1<<"\t"<<"t2="<<t2<<"\t"<<"tCharge(t1)="<<tCharge(t1)<<"\t"<<"tCharge(t2)="<<tCharge(t2)<<endl;
		    if (progpar.verbose) cout<<"P(t1)="<<tP(t1)<<"\t"<<"P(t2)="<<tP(t2)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<endl;

		    Dmeson.Mbc[i]=0;                                            //Invariant mass or beam consraint mass
		    Dmeson.InvM[i]=0;                                           //also Invariant mass
		    Dmeson.dE[i]=0;
		    Dmeson.dP[i]=0;
		    Dmeson.depmkp[i]=0;
                    Dmeson.deppkm[i]=0;

		    double px1, px2, py1, py2, pz1, pz2;                        //determine momentums
		    px1 = tP(t1)*tVx(t1);
		    px2 = tP(t2)*tVx(t2);
		    py1 = tP(t1)*tVy(t1);
		    py2 = tP(t2)*tVy(t2);
		    pz1 = tP(t1)*tVz(t1);
		    pz2 = tP(t2)*tVz(t2);

		    //Mbc=sqrt(Ebeam^2-(p1+p2)^2)
		    Dmeson.Mbc[i] = (WTotal/2)*(WTotal/2) - pow(px1+px2,2) - pow(py1+py2,2) - pow(pz1+pz2,2);
		    if (Dmeson.Mbc[i]>0) Dmeson.Mbc[i] = sqrt(Dmeson.Mbc[i]); else Dmeson.Mbc[i] = 0;

		    //Invariant mass of two tracks
		    //(p1+p2)^2=p1^2+p2^2+2*p1*p2cos(theta)
		    Dmeson.InvM[i] = pow((WTotal/2),2)-pow(tP(t1),2)-pow(tP(t2),2)-2*tP(t1)*tP(t2)*(tVx(t1)*tVx(t2)+tVy(t1)*tVy(t2)+tVz(t1)*tVz(t2));
		    if ( Dmeson.InvM[i]>0) Dmeson.InvM[i] = sqrt(Dmeson.InvM[i]); else Dmeson.InvM[i] = 0;

		    if (progpar.verbose) cout<<"mbc="<<Dmeson.Mbc[i]<<"\t"<<"InvM="<<Dmeson.InvM[i]<<endl;

		    Dmeson.depmkp[i] =  sqrt(mpi*mpi + tP(t1)*tP(t1)) + sqrt(mk*mk + tP(t2)*tP(t2));
		    Dmeson.deppkm[i] =  sqrt(mpi*mpi + tP(t2)*tP(t2)) + sqrt(mk*mk + tP(t1)*tP(t1));
		    Dmeson.dE[i] = (Dmeson.depmkp[i] + Dmeson.deppkm[i])/2. - WTotal/2;
		    if (progpar.verbose) cout<<"depmkp="<<Dmeson.depmkp[i]<<"\t"<<"deppkm="<<Dmeson.deppkm[i]<<"\t"<<"de="<<Dmeson.dE[i]<<endl;

		    Dmeson.dP[i] = tP(t1)-tP(t2);
		    if (progpar.verbose) cout<<"dP="<< Dmeson.dP[i]<<endl;
		    i++;
		}
	    }
	}
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
    return 0;
}

static const char* optstring="ra:d:b:p:h:s:j:t:e:c:l:k:i:u:q:o:v:n:z:x";

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
            	<<"  -n NEvents     Number events in process "<<def_progpar.NEvents<<")\n"
            	<<"  -z Debug       Print debug information "<<def_progpar.verbose<<")\n"
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
	    char branchname[10];
	    sprintf(branchname,"t%d",i);
	    TBranch* b1=eventTree->Branch(branchname,&btrack[i],trackBranchList);
	    for(int ii=0; ii<Natccr; ii++) {
		char branchname2[10];
		sprintf(branchname2,"t%datccr%d",i,ii);
		eventTree->Branch(branchname2,&bcnt[ii][i],atcCounterBranchList);
	    }
	    for (int ii=0; ii<Nclcr; ii++)
	    {
		char clastername[10];
		sprintf(clastername,"t%dc%d",i,ii);
		eventTree->Branch(clastername,&bcluster[ii][i],towerClusterBranchList);
	    }
	    char tofname[10];
	    sprintf(tofname,"t%dtof",i);
	    eventTree->Branch(tofname,&btof[i],ToFBranchList);
	}

	for (int ii=0; ii<Nclcrg; ii++)
	{
	    char clgammaname[10];
	    sprintf(clgammaname,"clgamma%d",ii);
	    eventTree->Branch(clgammaname,&bclgamma[ii],towerClusterBranchList);
	}

	eventTree->Branch("mu",&bmu,MUBranchList);
	eventTree->Branch("Dmeson",&Dmeson,"numHyp/I"
			  ":Mbc[6]/F:InvM[6]:dE[6]:dP[6]:depmkp[6]:deppkm[6]:Ebeam:rEv:chi2[50]:M[50]:P1[50]:P2[50]:P3[50]:P4[50]");

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
	kf_add_cut(KF_VDDC_SEL,Chi2Cut,"tChi2<50");
	kf_add_cut(KF_VDDC_SEL,tHitsCut,"tHits>=24");
	sprintf(buf,"minimum number of tracks equally %d and maximum number of tracks equally %d<",progpar.min_track_number,progpar.max_track_number);
	kf_add_cut(KF_VDDC_SEL,CutTrackNumber,buf);
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
        //if(verbose)cout<<"analyse_event="<<analyse_event<<endl;

	//Do not reconstruct, read reconstruction records from file
	kf_reco_from_file(progpar.read_reco);

	//Set exclusive event processing
	kf_process_only(progpar.process_only);

	TBenchmark *benchmark=new TBenchmark;
	cout<<" Starting benchmark test"<<endl;
	benchmark->Start("test");

	//Call analysis job
	cout<<"NEvents="<<progpar.NEvents<<"\t"<<"argv[optind]="<<argv[optind]<<"\t"<<"&argv[optind]="<<&argv[optind]<<"\t"<<"argc-optind="<<argc-optind<<endl;               //argv[optind]:/space/runs/daq021949.nat.bz2

//	kf_process(argc-optind,&argv[optind],0);
	kf_process(argc-optind,&argv[optind],progpar.NEvents);             //установка ограничения на число обрабатываемых событий

	benchmark->Show("test");

	if( fout ) {
		fout->Write();         //пишем данные в файл и закрываем его
		fout->Close();
	}

	return 0;
}
