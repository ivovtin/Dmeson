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

const int Ntraks=6;
const int Natccr=6;
const int Nclcr=2;

static const char* progname;

struct ProgramParameters {
	bool read_reco;
	int min_track_number;                 //миниммальное число треков
	int max_track_number;                 //максимальное число треков
	int min_beam_track_number;            //миниммальное число пучковых треков
	int min_ip_track_number;              //миниммальное число треков из точки взаимодействия
	int max_ip_track_number;              //максимальное число треков из точки взаимодействия
        float min_momentum;                   //минимальный импульс
        float max_momentum;                   //максимальный импульс
	float min_cluster_energy; //MeV       //минимальная энергия кластера
	float min_total_energy; //MeV         //минимальная общая энергия
	int min_cluster_number;               //минимальное кол-во кластеров с энергией больше минимальной
	int max_cluster_number;               //минимальное кол-во кластеров с энергией больше минимальной
	int min_lkrcl_number;                 //минимальное кол-во кластеров в LKr
	int min_csicl_number;                 //минимальное кол-во кластеров в CsI
	const char* rootfile;
	int MCCalibRunNumber;                 //19862 - номер захода - загрузка из БД калибровок при обработке файла моделирования в заданном интервале заходов
	int NEvents;                          //число обрабатываемых событий
	bool process_only;                    //process one event only
};
//=======================================================================================================================================
//Условия отбора для pi+pi-pi0:
//1)минимальное число треков 2
//2)максимальное число треков 2
//3)миниммальное число пучковых треков 2
//4)минимальное число треков из точки взаимодействия 2
//5)максимальное число треков из точки взаимодействия 2
//6)минимальный поперечный импульс 100 МэВ/c
//6)максимальный поперечный импульс 2000 МэВ/c
//7)минимальная энергия кластера 15 МэВ
//8)Суммарная энергия по всем кластерам больше 45 MeV
//9)минимальное число кластеров 2
//10)максимальное число кластеров 8
//11) tChi2<50 - качество подгонки
//12) Число хитов на треке Nhits>25

//....
//10)треки из вершины tVertex(t)==1
////11)центральные треки 	fabs(tX0(t)-eVertexX)<1 && fabs(tY0(t)-eVertexY)<1 && fabs(tZ0(t)-eVertexZ)<15 )
//=======================================================================================================================================

//отбор по трекам
static const struct ProgramParameters def_progpar={false,4,4,2,2,4,100,2000,15,45,2,8,0,0,"/store/users/ovtin/out.root",19862,0,false};

static struct ProgramParameters progpar(def_progpar);

enum {                                                                          //перечисление
	CutLongDcRecord=1,
	CutLongVdRecord,
        AtcEventDamageCut,
        AtcIllegalTrackCut,
//      NoAtcOnTrackCut,
        CutTotalEnergyFast,
	CutTrackNumber,
	CutBeamTrackNumber,
	CutIPTrackNumber_min,
	CutIPTrackNumber_max,
        Cut_CPhi2t,            //для отброса событий по расколлинеарности по углам
	Cut_CThe2t,
        EMCthetaCut,
//        Cut_10per_Energy,      //отбрасываю события если выделившаяся энергия в калориметре не приписанная двум рассматриваемым кластерам превышает 10% от полной
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
static struct TrackBranch btrack[6];
static struct ToFBranch btof[6];
static struct MUBranch bmu;
static struct EMCBranch bemc;
static struct TowerClusterBranch bcluster[4][3];
static struct TowerClusterBranch bclgamma[4];
static struct StripClusterBranch bstrip;
static struct StripTrackBranch bstriptrack;

static struct ATCCounterBranch bcnt[6][6];
static struct ATCBranch batc;

//TH1F *hpx;
//struct piBranch {
//        Int_t numHyp;
//	Float_t  chi2,M1,P1,M2,P2;
//};
//static struct piBranch bpi;
//static const char* piBranchList="numHyp/I:chi2/F:M1:P1:M2:P2";

typedef struct {Int_t numHyp; Float_t chi2[5],M[5],P1[5],P2[5];} JPSI;
static JPSI jpsi;

typedef struct {Float_t Mbc[4],InvM[4],dE[4],dP[4],E_KminusP[4],E_KplusP[4],E_PminusK[4],E_PplusK[4],Ebeam,rEv;} DMESON;
static DMESON Dmeson;
//static TH1F *hbeam;

float Ekminuspiplus, Ekpluspiminus, Pminus, Pplus;

int listtr[6],lclpi0[8],lclg[5];
//Rejection prior to reconstruction helps to save CPU time
extern "C" void kemc_energy_(float Ecsi[2],float *Elkr);

//предварительный отброс события
int pre_event_rejection()
{
    //maximum track number supposed to be 7
	//maximum record size for DC: Ntracks*maxNhits*HitLength + 10% (spare)
	static const int maxDClen=1940; //=1940
	//maximum record size for VD: Ntracks*maxNhits*Length + 2 (for dT) + 10% (spare)
	static const int maxVDlen=156; //=156

	//if( RawLength(SS_DC)>maxDClen ) return CutLongDcRecord; //too long DC event

	//if( RawLength(SS_VD)>maxVDlen ) return CutLongVdRecord; //too long VD event

	float Ecsi[2], Elkr;
	kemc_energy_(Ecsi,&Elkr);

    //Total energy deposition should be more than progpar.min_total_energy
//	if( Ecsi[0]+Ecsi[1]+Elkr<progpar.min_total_energy ) return CutTotalEnergyFast;

	return 0;
}

int vddc_event_rejection()
{
	if( eTracksAll<progpar.min_track_number )       return CutTrackNumber;
	if( eTracksAll>progpar.max_track_number )       return CutTrackNumber;
	if( eTracksBeam<progpar.min_beam_track_number ) return CutBeamTrackNumber;
	if( eTracksIP<progpar.min_ip_track_number )     return CutIPTrackNumber_min;
	if( eTracksIP>progpar.max_ip_track_number )     return CutIPTrackNumber_max;

        int charge=0;
	for (int t = 0; t< eTracksAll; t++) {
	    if( tPt(t)<=progpar.min_momentum )  return MinMomentumCut;
	    if( tPt(t)>=progpar.max_momentum )  return MaxMomentumCut;
	    if( tCh2(t)>50 )  return Chi2Cut;
	    if( tHits(t)<25 )  return tHitsCut;         //15
            charge += tCharge(t);
	}

	if( (charge)!=0 )  return ChargeCut;   //если сумма зарядов треков не равна 0 то отбрасываем

	return 0;
}

int tof_event_rejection()
{
//    if( kschit_.time_ns[0]<-4 || kschit_.time_ns[0]>4)         return TofCut;
//    if( kschit_.time_ns[1]<-4 || kschit_.time_ns[1]>4)         return TofCut;

    return 0;
}

int emc_event_rejection()
{
	int nemc=0, nlkr=0, ncsi=0;
	float tot_energy=0;
	float two_cluster_energy=0;
        int nclntrack=0;
//        int add_nemc;                                                //дополнительное кол-во сработавших кластеров
//	float add_nemc_energy=0;                                       //энергия доп-х сработавших кластеров

	for(int c=0; c<semc.emc_ncls; c++) {                           //цикл по числу кластеров в калориметре
		tot_energy+=semc.emc_energy[c];                        //подсчет энергии выделившейся в калориметре
		if( semc.emc_energy[c]>progpar.min_cluster_energy ) {  //если энергия кластера больше установленной минимальной энергии
			nemc++;                                        //число кластеров с энергией больше минимальной
                        two_cluster_energy+=semc.emc_energy[c];        //сумма энергий в кластерах с энергией больше минимальной энергии кластера
			if( semc.emc_type[c]==1 )
				nlkr++;
			else
				ncsi++;
		}
		else {
	                return CutClusterEnergy;
                //      add_nemc++;
		//      add_nemc_energy+=semc.emc_energy[c];
		}

		if ( semc.emc_dc_ntrk[c]==1 )            //если кластер привязан к треку то считаем их число      //semc.dc_emc_ncls[t]
		{
		    nclntrack++;
		}

        //if(semc.emc_theta[c]<20 || semc.emc_theta[c]>31 || semc.emc_theta[c]<39 || semc.emc_theta[c]>141 || semc.emc_theta[c]<149 || semc.emc_theta[c]>160) return EMCthetaCut;
	}

        //semc.emc_theta[c];            //угол theta в градусах

//	cout<<"tot_energy="<<tot_energy<<"\t"<<"two_cluster_energy="<<two_cluster_energy<<endl;

	//отбрасываем если какое-либо условие не выполняется
            //        if(tot_energy-two_cluster_energy>0.1*tot_energy)    return  Cut_10per_Energy;
	if( tot_energy<progpar.min_total_energy )           return CutTotalEnergy;
	if( nemc<progpar.min_cluster_number )               return CutMINClusterNumber;
	if( nemc>progpar.max_cluster_number )               return CutMAXClusterNumber;
	//if( nlkr<progpar.min_lkrcl_number )                 return CutLkrClusterNumber;
	//if( ncsi<progpar.min_csicl_number )                 return CutCsiClusterNumber;
       /*
	if ( nclntrack<2 || semc.dc_emc_ncls[0]<1 || semc.dc_emc_ncls[1]<1 )  {   //общее число привязанных кластеров должно быть не меньше 2-х и к каждому треку должен быть привязан хотя бы 1 кластер
	    //cout<<"Ev:"<<eNumber<<"\t"<<"nclntrack="<<nclntrack<<"\t"<<"semc.dc_emc_ncls[0]="<<semc.dc_emc_ncls[0]<<"\t"<<"semc.dc_emc_ncls[1]="<<semc.dc_emc_ncls[1]<<endl;
	    return Cut_nclntrack;
	}
        */
	//if(add_nemc<3&&add_nemc_energy>120)               return Cut_add_nemc;
           //if(add_nemc<2&&add_nemc_energy>160)               return Cut_add_nemc;

	return 0;
}

int atc_rejection()          //отброс событий в АЧС
{
    //ATC raw record damaged in any way (including when DeltaT is absent or out of range)     //сырые данные повреждены
    if( atc_rec.eventdamage ) return AtcEventDamageCut;

    //track determined as illegal by atcrec                                                   //трек не определяется в atcrec
    if( atc_track.illtrack[0] ) return AtcIllegalTrackCut;

    //no counters on tracks, very strange if occurs                                           //нет счетчика на трек
//    if( atc_track.ncnt_on_track[0]==0 ) return NoAtcOnTrackCut;

    return 0;
}

int mu_event_rejection()
{
    //if( mu_next_event()>0 ) return MUCut;           //отброс космики

    return 0;
}


int analyse_event()         //анализ события
{
    bool info=false;
    //bool info=true;
    //float EMinPhot=50.;
    float EMinPhot=15.;
    double  WTotal=2*beam_energy;
    if( kedrrun_cb_.Header.RunType == 64 ) { WTotal=2*1886.75; }
    //cout<<"RunNumber="<<kedrraw_.Header.RunNumber<<"\t"<<"WTotal="<<WTotal<<"\t"<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<endl;

    if(eTracksBeam>=3&&eTracksIP>=3&&eTracksAll<=4) {

	if (info) cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"eTracksAll="<<eTracksAll<<"\t"<<"eTracksBeam="<<eTracksBeam<<"\t"<<"eTracksIP="<<eTracksIP<<endl;

	//=====================================================================================

	int t1, t2, t3, t4;
	int i=0;

	for (t1 = 0; t1 < eTracksAll; t1++) {
	    for (t2 = 0; t2 < eTracksAll; t2++) {
		double p1pi=0, p2pi=0, p1ki=0, p2ki=0;
		//condition for part1: K-, part2: pi+    (D0->K-pi+)
		if( tCharge(t1)<0 && tCharge(t2)>0 ) {
		    if (info) cout<<"Raw event="<<kedrraw_.Header.Number<<"\t"<<"Ebeam="<<beam_energy<<"\t"<<"t1="<<t1<<"\t"<<"t2="<<t2<<"\t"<<"tCharge(t1)="<<tCharge(t1)<<"\t"<<"tCharge(t2)="<<tCharge(t2)<<endl;
		    if (info) cout<<"P(t1)="<<tP(t1)<<"\t"<<"P(t2)="<<tP(t2)<<"\t"<<"tHits(t1)="<<tHits(t1)<<"\t"<<"tHits(t2)="<<tHits(t2)<<"\t"<<"tCh2(t1)="<<tCh2(t1)<<"\t"<<"tCh2(t2)="<<tCh2(t2)<<endl;
		    Dmeson.Mbc[i]=0;
		    Dmeson.InvM[i]=0;
	   	    Dmeson.dE[i]=0;
		    Dmeson.dP[i]=0;
		    Dmeson.E_KminusP[i]=0;
		    Dmeson.E_KplusP[i]=0;
		    Dmeson.E_PminusK[i]=0;
		    Dmeson.E_PplusK[i]=0;
		    double mk = 493.68;
		    double mpi = 139.57;

		    double px1, px2, py1, py2, pz1, pz2;
		    px1 = tP(t1)*tVx(t1);
		    px2 = tP(t2)*tVx(t2);
		    py1 = tP(t1)*tVy(t1);
		    py2 = tP(t2)*tVy(t2);
		    pz1 = tP(t1)*tVz(t1);
		    pz2 = tP(t2)*tVz(t2);

		    //Mbc=sqrt(Ebeam^2-(p1+p2)^2)
		    Dmeson.Mbc[i] = beam_energy*beam_energy - pow(px1+px2,2) - pow(py1+py2,2) - pow(pz1+pz2,2);
		    if (Dmeson.Mbc[i]>0) Dmeson.Mbc[i] = sqrt(Dmeson.Mbc[i]); else Dmeson.Mbc[i] = 0;

		    //Invariant mass of two tracks
		    //(p1+p2)^2=p1^2+p2^2+2*p1*p2cos(theta)
		    Dmeson.InvM[i] = pow(beam_energy,2)-pow(tP(t1),2)-pow(tP(t2),2)-2*tP(t1)*tP(t2)*(tVx(t1)*tVx(t2)+tVy(t1)*tVy(t2)+tVz(t1)*tVz(t2));
		    if ( Dmeson.InvM[i]>0) Dmeson.InvM[i] = sqrt(Dmeson.InvM[i]); else Dmeson.InvM[i] = 0;

		    if (info) cout<<"mbc="<<Dmeson.Mbc[i]<<"\t"<<"InvM="<<Dmeson.InvM[i]<<endl;

		    p1ki = tP(t1);
		    p1pi = tP(t2);
		    Dmeson.E_KminusP[i] = sqrt(mk*mk + p1ki*p1ki) + sqrt(mpi*mpi + p1pi*p1pi);
		    Dmeson.E_PminusK[i] = sqrt(mk*mk + p1pi*p1pi) + sqrt(mpi*mpi + p1ki*p1ki);

		    for(t3=0; t3<eTracksAll; t3++  ){
			for(t4=0; t4<eTracksAll; t4++  ){
			    if ( t3!=t1 && t3!=t2 && t4!=t1 && t4!=t2 && tCharge(t1)!=tCharge(t3) ){
				if ( tCharge(t3)>0 && tCharge(t4)<0 )
				{
				    p2ki = tP(t3);
				    p2pi = tP(t4);
				    if (info) cout<<"P(t3)="<<tP(t3)<<"\t"<<"P(t4)="<<tP(t4)<<endl;
				}
			    }
			}
		    }
		    Dmeson.E_KplusP[i] = sqrt(mk*mk + p2ki*p2ki) + sqrt(mpi*mpi + p2pi*p2pi);
		    Dmeson.E_PplusK[i] = sqrt(mk*mk + p2pi*p2pi) + sqrt(mpi*mpi + p2ki*p2ki);
		    //dE = (EkminusP + EkplusP)*0.5 - beamenergy;
		    Dmeson.dE[i] = (Dmeson.E_KminusP[i] + Dmeson.E_KplusP[i])/2. - beam_energy;
		    if (info) cout<<"E_KminusP="<< Dmeson.E_KminusP[i]<<"\t"<<"E_KplusP="<<Dmeson.E_KplusP[i]<<"\t"<<"de="<<Dmeson.dE[i]<<endl;
		    if (info) cout<<"E_PminusK="<< Dmeson.E_PminusK[i]<<"\t"<<"E_PplusK="<<Dmeson.E_PplusK[i]<<endl;

		    Dmeson.dP[i] = tP(t1)-tP(t2);
		    if (info) cout<<"dP="<< Dmeson.dP[i]<<endl;
		    i++;
		}
	    }
	}
	Dmeson.rEv = kedrraw_.Header.Number;
	//=====================================================================================

	int ntrfromip=0;

	Dmeson.Ebeam=beam_energy;

	copy(&bevent);
	bevent.event=kdcenum_.EvNum;                 //take succesive event number from VDDCRec

	unsigned short nhits=mu_next_event();

	copy(&bvertex);
	copy(&bemc);

	for(int t=0; t<eTracksAll; t++)                            //цикл по числу треков
	{
	    //		if(sqrt(pow(tX0(t),2)+pow(tY0(t),2)+pow(tZ0(t),2))<30)    {          //cut area in DC       30 - радиус сферы в см
	    //		if( fabs(tX0(t)-eVertexX)<1 && fabs(tY0(t)-eVertexY)<1 && fabs(tZ0(t)-eVertexZ)<15 )    {          //cut area in DC       30 - радиус сферы в см
	    //cout<<"tX0(t)="<<tX0(t)<<"   tY0(t)="<<tY0(t)<<"    tZ0(t)="<<tZ0(t)<<endl;   //coordinates begin track
	    //cout<<"eVertexX="<<eVertexX<<"   eVertexY="<<eVertexY<<"    eVertexZ="<<eVertexZ<<endl;   //координаты восстановленной вершины
	    //============================================================
	    double xx=tX0IP(t)*tX0IP(t);
	    double yy=tY0IP(t)*tY0IP(t);
	    double rr=sqrt(xx+yy);
	    //cout<<"rr="<<rr<<endl;   //radius begin track

	    //if(rr<3) {
	    if(rr<5) {
		ntrfromip++;
		if(ntrfromip<=6){
		    listtr[ntrfromip-1]=t+1;                //Список идентификаторов треков ListTr[1:6]
		}
	    }
                //============================================================
	    copy(&btrack[t],t);
	    copy(&btof[t],t);
	    copy(&bmu,t,nhits);
	    copy(&batc);

	    for(int k=0; k<6; k++)                    //цикл по числу пересеченных счетчиков на трек
	    {
		//                  cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Track="<<t<<"\t"<<"i="<<i<<"\t"<<"atc_track.cnt_cross[t][i]="<<atc_track.cnt_cross[t][i]<<"\t"<<"atc_rec.npe="<<atc_rec.npe[atc_track.cnt_cross[t][i]-1]<<endl;
		copy(&bcnt[k][t],(atc_track.cnt_cross[t][k]-1),t);
	    }

	    for(int c=0; c<semc.dc_emc_ncls[t]; c++)                      //dc_emc_ncls[NDCH_TRK] - число кластеров emc, соответствующих данному треку
	    {
		//cout<<"Event="<<kdcenum_.EvNum<<"\t"<<"Track="<<t<<"\t"<<"semc.dc_emc_ncls[t]="<<semc.dc_emc_ncls[t]<<endl;
		copy(&bcluster[c][t],(semc.dc_emc_cls[t][c]-1)); //?????     //dc_emc_cls[NDCH_TRK][NEMC_CLS] - номера таких кластеров
	    }


	    for(int t=0; t<semc.str_ntracks; t++) {
		copy(&bstriptrack,t);
	    }
	}

	int nclg=0;
	for(int cl=0; cl<semc.emc_ncls; cl++)       //цикл по числу кластеров
	{
	    if(semc.emc_dc_ntrk[cl]==0)            //если кластер не привязан к треку
	    {
		copy(&bclgamma[nclg],cl);               //	ncls=semc.emc_emc_ncls[c];       ntracks=semc.emc_dc_ntrk[c];
		nclg++;
	    }
	}
	//cout<<"Event="<<eDaqNumber<<"\t"<<endl;

	for(int c=0; c<semc.str_ncls; c++) {
	    copy(&bstrip,c);
	}
            /*
            //====================================================================
	    int nclnft=0;
	    for(int cl=0; cl<semc.emc_ncls; cl++)       //цикл по числу кластеров
	    {
		if(semc.emc_dc_ntrk[cl]==0&&            //если кластер не привязан к треку и его энергия больше минимальной (50 МэВ)
		   semc.emc_energy[cl]>EMinPhot){
		    nclnft++;                           //подсчитываем число таких кластеров
		    if(nclnft<=8) {
			lclpi0[nclnft-1]=cl+1;          //Список идентификаторов кластеров для построения  pi0 ListPi0[1:8]

            }
		}
	    }

	    //cout<<"Event="<<eDaqNumber<<"\t"<<"ntrfromip="<<ntrfromip<<"\t"<<"nclnft="<<nclnft<<endl;   //radius begin track
            //cout<<"tP(0)="<<tP(0)<<"\t"<<"tP(1)="<<tP(1)<<endl;
	    jpsi.numHyp=0;
	    for(int i=0; i<5; i++){
	    jpsi.chi2[i]=0;
	    jpsi.M[i]=0;
	    jpsi.P1[i]=0;
	    jpsi.P2[i]=0;
	    }

	    if(ntrfromip==2&&nclnft==0) {
		//printf("nclnft==0 event %d: %d tracks, %d from I.P., %d close to beam line\n",eDaqNumber,eTracksAll,eTracksIP,eTracksBeam);
		int qst=0;
		int ntracks=2;
		int npi0=0;
		int ng=0;
		//lclg[0]=lclpi0[0];
		reckfitmulticpi0gamma(&WTotal,&ntracks,&npi0,&ng,listtr,lclpi0,lclg,&qst);
		//cout<<"qst:"<<qst<<endl;
		if(qst>=0){
		    //cout<<"NumOfHyp:"<<hNumOfHyp<<endl;
		    for(int ih=0; ih<hNumOfHyp; ih++){
			//cout<<" chi2:"<<hHChi2(ih)<<endl;
			jpsi.chi2[ih]=hHChi2(ih);
			for(int it=0; it<2; it++){
			    //cout<<"track:"<<it<<"  Mass:"<<hMPc(ih,it)<<"\t"<< "P:"<<hPPc(ih,it)<<endl;
			    if(it==0){
				jpsi.M[ih]=hMPc(ih,it);
				jpsi.P1[ih]=hPPc(ih,it);
			    }
			    if(it==1){
				jpsi.P2[ih]=hPPc(ih,it);
			    }
			}
		    }
		}
	    }

	    if(ntrfromip==2&&nclnft<=2) {
		//printf("nclnft==1 event %d: %d tracks, %d from I.P., %d close to beam line\n",eDaqNumber,eTracksAll,eTracksIP,eTracksBeam);
		int qst=0;
		int ntracks=2;
		int npi0=0;
		int ng=1;
		//lclg[0]=lclpi0[0];
		reckfitmulticpi0gamma(&WTotal,&ntracks,&npi0,&ng,listtr,lclpi0,lclg,&qst);
		//cout<<"qst:"<<qst<<endl;
		if(qst>=0){
		    //cout<<"NumOfHyp:"<<hNumOfHyp<<endl;
		    for(int ih=0; ih<hNumOfHyp; ih++){
			//cout<<" chi2:"<<hHChi2(ih)<<endl;
			jpsi.chi2[ih]=hHChi2(ih);
			for(int it=0; it<2; it++){
			    //cout<<"track:"<<it<<"  Mass:"<<hMPc(ih,it)<<"\t"<< "P:"<<hPPc(ih,it)<<endl;
			    if(it==0){
				jpsi.M[ih]=hMPc(ih,it);
				jpsi.P1[ih]=hPPc(ih,it);
			    }
			    if(it==1){
				jpsi.P2[ih]=hPPc(ih,it);
			    }
			}
		    }
		}
	    }

	    //hpx->Fill(hNumOfHyp);
	    jpsi.numHyp=hNumOfHyp;
            */


                if(eNumber%10==0) cout<<"Ev:"<<eNumber<<endl;
	    //==================================================================

            eventTree->Fill();


	    if( progpar.process_only ) return 1;

	    return 0;

	}
}


//static const char* optstring="ra:b:p:t:e:c:k:i:o:v:x";
static const char* optstring="ra:d:b:p:h:s:j:t:e:c:l:k:i:o:v:n:x";

void Usage(int status)
{                   //static const struct ProgramParameters def_progpar={false,1,0,0,50,300,1,0,0,"/store/users/ovtin/out.root",false};
	cout.precision(3);
	cout<<"Usage:\n"
		<<progname<<" [OPTIONS] run|nat_file|run_list_file...\n\n"
		<<"Reconstruction of BhaBha events with DC and search of hits in ATC system.\n"
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
	        <<"  -o RootFile    Output ROOT file name (default to "<<def_progpar.rootfile<<")\n"
            	<<"  -v MCCalibRunNumber    MCCalibRunNumber (default to "<<def_progpar.MCCalibRunNumber<<")\n"
            	<<"  -n NEvents     Number events in process "<<def_progpar.NEvents<<")\n"
		<<"  -x             Process the events specified after file exclusively and print debug information"
		<<endl;
	exit(status);
}

int main(int argc, char* argv[])
{
	progname=argv[0];

	//If no arguments print usage help
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
			case 't': progpar.min_cluster_energy=atof(optarg); break;
			case 'e': progpar.min_total_energy=atof(optarg); break;
			case 'c': progpar.min_cluster_number=atoi(optarg); break;
			case 'l': progpar.max_cluster_number=atoi(optarg); break;
			case 'k': progpar.min_lkrcl_number=atoi(optarg); break;
			case 'i': progpar.min_csicl_number=atoi(optarg); break;
		        case 'o': progpar.rootfile=optarg; break;
                        case 'v': progpar.MCCalibRunNumber=atoi(optarg); break;
                        case 'n': progpar.NEvents=atoi(optarg); break;
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
		fout = new TFile(progpar.rootfile,"RECREATE");        //fout = new TFile(progpar.rootfile,"RECREATE","",7);

	eventTree = new TTree("et","Event tree");
	eventTree->SetAutoSave(500000000);  // autosave when 0.5 Gbyte written
	eventTree->Branch("ev",&bevent,eventBranchList);
        eventTree->Branch("vrt",&bvertex,vertexBranchList);
	eventTree->Branch("emc",&bemc,emcBranchList);
	eventTree->Branch("atcev",&batc,atcBranchList);

	//for(int i=0; i<Ntraks; i++) {
	for(int i=0; i<6; i++) {
	//char branchname[Ntraks];
	char branchname[6];
	sprintf(branchname,"t%d",i);
	TBranch* b1=eventTree->Branch(branchname,&btrack[i],trackBranchList);
	  //for(int ii=0; ii<Natccr; ii++) {
	  for(int ii=0; ii<6; ii++) {
	      //char branchname2[Natccr];
	      char branchname2[6];
	      sprintf(branchname2,"t%datccr%d",i,ii);
	      eventTree->Branch(branchname2,&bcnt[ii][i],atcCounterBranchList);
	  }
	  //for (int ii=0; ii<Nclcr; ii++)
	  for (int ii=0; ii<3; ii++)
	  {
	      //char clastername[Nclcr];
	      char clastername[3];
	      sprintf(clastername,"t%dc%d",i,ii);
	      eventTree->Branch(clastername,&bcluster[ii][i],towerClusterBranchList);
	  }
	  //char tofname[Ntraks];
	  char tofname[6];
	  sprintf(tofname,"t%dtof",i);
          eventTree->Branch(tofname,&btof[i],ToFBranchList);
	}

	//for (int ii=0; ii<Nclcr; ii++)
	for (int ii=0; ii<4; ii++)
	{
	    //char clgammaname[Nclcr];
	    char clgammaname[4];
	    sprintf(clgammaname,"clgamma%d",ii);
	    eventTree->Branch(clgammaname,&bclgamma[ii],towerClusterBranchList);
	}

	eventTree->Branch("mu",&bmu,MUBranchList);
	eventTree->Branch("jpsi",&jpsi,"numHyp/I:chi2[5]/F:M[5]:P1[5]:P2[5]");
	eventTree->Branch("Dmeson",&Dmeson,"Mbc[4]/F:InvM[4]:dE[4]:dP[4]:E_KminusP[4]:E_KplusP[4]:E_PminusK[4]:E_PplusK[4]:Ebeam:rEv");

	eventTree->Branch("strcls",&bstrip,stripClusterBranchList);
	eventTree->Branch("strtrk",&bstriptrack,stripTrackBranchList);

	//jpsiTree = new TTree("jpsi","pi+pi-pi0 tree");
	//jpsiTree->Branch("jpsi",&jpsi,"numHyp/I:chi2[5]/F:M[5]:P1[5]:P2[5]");
	//piTree->Branch("pi",&bpi,piBranchList);
	//hpx=new TH1F("hyp","This is the hyp distribution",6,0,6);

	//TH1F;
	//hbeam = new TH1F("hbeam", "Energy of beam", 4096, 0, 4096);

//----------------- Configure kframework -----------------//
	//Set kframework signal handling
	kf_install_signal_handler(1);

	//Set subsystems to be used
        kf_use(KF_VDDC_SYSTEM|KF_TOF_SYSTEM|KF_ATC_SYSTEM|KF_EMC_SYSTEM|KF_MU_SYSTEM);                             //устанавливаем, какие будем использовать системы

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
        cout<<"analyse_event="<<analyse_event<<endl;

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
