#ifndef D0kppp_h
# define D0kppp_h

#include <Riostream.h>
#include <sstream>
#include <TROOT.h>
#include <TCanvas.h>
#include <TPad.h>
#include <TGraph.h>
#include <TGraphErrors.h>
#include <TTree.h>
#include <TF1.h>
#include <TMath.h>
#include "TFile.h"
#include "TVirtualPad.h"
#include <iomanip>
#pragma hdrstop
#include<stdio.h>
#include<stdlib.h>
#include <TH1.h>
#include <TH2.h>
#include <TH3.h>
#include <TStyle.h>
#include <TLine.h>
#include <TEventList.h>
#include <TProfile.h>
#include <vector>
#include <TChain.h>
#include "TMinuit.h"
#include "TRandom3.h"
#include <math.h>
#include "TVirtualFitter.h"
#include <algorithm>
#include <assert.h>
#include <TSystem.h>

struct data10
{
    /*
    int vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,charge4,nhitsdc,nhitst1,nhitst2,nhitst3,nhitst4,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsvdt4,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nhitsxyt4,nhitszt4,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,nvecxyt3,nveczt3,nvect4,nvecxyt4,nveczt4,ncomb,ncls1,ncls2,ncls3,ncls4,ncls,nlkr,ncsi,munhits,mulayerhits1,
    mulayerhits2,mulayerhits3,Run,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],natccrosst3,atcCNTt3[20],natccrosst4,atcCNTt4[20],aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],aerogel_REGIONt3[20],aerogel_REGION0t3[20],aerogel_REGION5t3[20],aerogel_REGION20t3[20],single_aerogel_REGIONt3[20],
    single_aerogel_REGION0t3[20],single_aerogel_REGION5t3[20],single_aerogel_REGION20t3[20],aerogel_REGIONt4[20],aerogel_REGION0t4[20],aerogel_REGION5t4[20],aerogel_REGION20t4[20],single_aerogel_REGIONt4[20],
    single_aerogel_REGION0t4[20],single_aerogel_REGION5t4[20],single_aerogel_REGION20t4[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20],wlshitt3[20],nearwlst3[20],wlshitt4[20],nearwlst4[20];
    float mbc,de,prec1,prec2,prec3,prec4,fchi2,Ebeam,rEv,p1,p2,p3,p4,pt1,pt2,pt3,pt4,thetat1,thetat2,thetat3,thetat4,phit1,phit2,phit3,phit4,chi2t1,chi2t2,chi2t3,chi2t4,e1,e2,e3,e4,rr1,rr2,rr3,rr4,zip1,zip2,zip3,zip4,
	ecls1,ecls2,ecls3,ecls4,tcls1,tcls2,tcls3,tcls4,pcls1,pcls2,pcls3,pcls4,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,timet2,betat2,lengtht2,timet3,betat3,lengtht3,timet4,betat4,lengtht4,
        atcNpet1[20],atcTotalNpet1,atcNpet2[20],atcTotalNpet2,atcNpet3[20],atcTotalNpet3,atcNpet4[20],atcTotalNpet4,tlent1[20],tlent2[20],tlent3[20],tlent4[20];
    */

    int vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,charge4,nhitsdc,nhitst1,nhitst2,nhitst3,nhitst4,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsvdt4,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nhitsxyt4,nhitszt4,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,nvecxyt3,nveczt3,nvect4,nvecxyt4,nveczt4,ncomb,ncls1,ncls2,ncls3,ncls4,ncls,nlkr,ncsi,munhits,mulayerhits1,
    mulayerhits2,mulayerhits3,Run,numn,numo,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],natccrosst3,atcCNTt3[20],natccrosst4,atcCNTt4[20],aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],aerogel_REGIONt3[20],aerogel_REGION0t3[20],aerogel_REGION5t3[20],aerogel_REGION20t3[20],single_aerogel_REGIONt3[20],
    single_aerogel_REGION0t3[20],single_aerogel_REGION5t3[20],single_aerogel_REGION20t3[20],aerogel_REGIONt4[20],aerogel_REGION0t4[20],aerogel_REGION5t4[20],aerogel_REGION20t4[20],single_aerogel_REGIONt4[20],
    single_aerogel_REGION0t4[20],single_aerogel_REGION5t4[20],single_aerogel_REGION20t4[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20],wlshitt3[20],nearwlst3[20],wlshitt4[20],nearwlst4[20],
    kft1,kft2,kft3,kft4;
   float mbc,de,prec1,prec2,prec3,prec4,fchi2,Ebeam,rEv,p1,p2,p3,p4,pt1,pt2,pt3,pt4,thetat1,thetat2,thetat3,thetat4,phit1,phit2,phit3,phit4,chi2t1,chi2t2,chi2t3,chi2t4,e1,e2,e3,e4,rr1,rr2,rr3,rr4,zip1,zip2,zip3,zip4,
        ecls1,ecls2,ecls3,ecls4,tcls1,tcls2,tcls3,tcls4,pcls1,pcls2,pcls3,pcls4,emcenergy,lkrenergy,csienergy,enn,eno,timet1,betat1,lengtht1,timet2,betat2,lengtht2,timet3,betat3,lengtht3,timet4,betat4,lengtht4,
    atcNpet1[20],atcTotalNpet1,atcNpet2[20],atcTotalNpet2,atcNpet3[20],atcTotalNpet3,atcNpet4[20],atcTotalNpet4,tlent1[20],tlent2[20],tlent3[20],tlent4[20],
    dedxt1,dedxt2,dedxt3,dedxt4,probKt1,probKt2,probKt3,probKt4,resdKt1,resdKt2,resdKt3,resdKt4,probpit1,probpit2,probpit3,probpit4,resdpit1,resdpit2,resdpit3,resdpit4,
    r_track_intersect12, r_track_intersect13, r_track_intersect14, r_track_intersect23, r_track_intersect24, r_track_intersect34;

};
data10 Dmeson;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	for(int i=1; i<=693; i++)   //signal 2016+2017for(int i=1; i<=560; i++)   //signal 2016+2017
	//for(int i=1; i<=544; i++)   //signal 2016+2017for(int i=1; i<=560; i++)   //signal 2016+2017
        {
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0280_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0260_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0240_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0220_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0200_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0180_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0160_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0110_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0140_kNoiseReject3_KemcAllowedOn_kinFit/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0kppp/dataPcorr_1.0140_kNoiseReject3_KemcAllowedOn_woKinFit/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==4){
	for(int i=1; i<=482; i++)   //signal 2004
	{
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/data2004/psi3770_to_D0meson_%d.root",i).Data());
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0280/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.031/psi3770_to_D0meson_%d.root",i).Data());    //best
	}
    }
    else if (key==1){
	for(int i=1; i<=114; i++)   //Signal
	{
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0_kppp/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_kinFit/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0_kppp/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_woKinFit/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	}
    }
    else if (key==2){
	for(int i=1; i<=221; i++)   //uds BG
	{
	    if( i!=5 && i!=61 && i!=69 && i!=70 && i!=114 && i!=136 && i!=163 && i!=213 && i!=215 )
	    {
		tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0_kppp/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simD0meson_ee_to_qq_%d.root",i).Data());
	    }
	}
    }
    else if (key==3){
	for(int i=1; i<=221; i++)   //DD BG
	//for(int i=18; i<=221; i++)   //DD BG
	{
	    if( i!=5 && i!=6 && i!=7 &&i!=8 && i!=9 && i!=10 && i!=50 && i!=56 && i!=61 && i!=67 && i!=69 && i!=70 && i!=73 && i!=106 && i!=114 && i!=136 && i!=139 && i!=163 && i!=213 && i!=215 )
	    {
		tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0_kppp/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_v5/psi3770_to_simD0mesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0_kppp/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_v12/psi3770_to_simD0mesonBkg_eetoDD_%d.root",i).Data());
	    }
	}
    }
}

void setbranchstatus(){
    tt->SetBranchStatus("*",0);
    tt->SetBranchStatus("Dmeson",1);
}

void setbranchaddress(){
    tt->SetBranchAddress("Dmeson",&Dmeson);
}

#endif
