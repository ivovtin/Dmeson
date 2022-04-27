#ifndef Dplusmeson_h
# define Dplusmeson_h

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
    int vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,nhitsdc,nhitst1,nhitst2,nhitst3,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,nvecxyt3,nveczt3,ncomb,ncls1,ncls2,ncls3,ncls,nlkr,ncsi,munhits,mulayerhits1,
    mulayerhits2,mulayerhits3,Run,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],natccrosst3,atcCNTt3[20],aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],aerogel_REGIONt3[20],aerogel_REGION0t3[20],aerogel_REGION5t3[20],aerogel_REGION20t3[20],single_aerogel_REGIONt3[20],
    single_aerogel_REGION0t3[20],single_aerogel_REGION5t3[20],single_aerogel_REGION20t3[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20],wlshitt3[20],nearwlst3[20],
    kft1,kft2,kft3;
    float mbc,de,prec1,prec2,prec3,fchi2,Ebeam,rEv,p1,p2,p3,pt1,pt2,pt3,thetat1,thetat2,thetat3,phit1,phit2,phit3,chi2t1,chi2t2,chi2t3,e1,e2,e3,rr1,rr2,rr3,zip1,zip2,zip3,
    ecls1,ecls2,ecls3,tcls1,tcls2,tcls3,pcls1,pcls2,pcls3,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,timet2,betat2,lengtht2,timet3,betat3,lengtht3,
    atcNpet1[20],atcTotalNpet1,atcNpet2[20],atcTotalNpet2,atcNpet3[20],atcTotalNpet3,tlent1[20],tlent2[20],tlent3[20],
    dedxt1,dedxt2,dedxt3,probpit1,probpit2,probpit3,resdpit1,resdpit2,resdpit3,probKt1,probKt2,probKt3,resdKt1,resdKt2,resdKt3;

};
data10 Dmeson;

float MVA;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
        /*
	for(int i=1; i<=693; i++)   //signal 2016+2017
        {
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0150_kNoiseReject3_atc_KemcAllowedOff_dedx_tof_KcExp1_kXTKey1/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0150_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_KcExp1_kXTKey1/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0150_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_%d.root",i).Data());
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_1.20/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_0.80/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_plus1sigma/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0140_kNoiseReject3_atc_KemcAllowedOn_dedx_tof_ionization_losses_minus1sigma/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0130_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0170_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0120_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0200_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr_1.0300_kNoiseReject3_atc_KemcAllowedOn_dedx_tof/psi3770_to_D0meson_%d.root",i).Data());
	}
        */
	tt->Add("/store/users/ovtin/outDmeson/Dplus/TMVA/exp_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_1.0140_new.root");
    }
    else if (key==4){
	for(int i=1; i<=482; i++)   //signal 2004
	{
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/data2004/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.031/psi3770_to_D0meson_%d.root",i).Data());    //best
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0250_kNoiseReject3_KemcAllowedOn/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==1){
        /*
	for(int i=1; i<=114; i++)   //Signal
	{
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_plus1sigma/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_minus1sigma/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A7.2_Z0.2_syst_momres/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.8_Z0.0_syst_momres/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.9_Z0.0_syst_momres/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A7.2_Z0.0_syst_momres/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A5.1_Z0.0_syst_momres/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_syst_isr_plus_sigma/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_syst_isr_minus_sigma/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_syst_isr_rnd/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	}
        */
	tt->Add("/store/users/ovtin/outDmeson/Dplus/TMVA/signal_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_new.root");
    }
    else if (key==2){
        /*
	for(int i=1; i<=330; i++)   //uds BG
	//for(int i=1; i<=110; i++)   //pions BG
	{
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_1.20/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_0.80/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_plus1sigma/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_minus1sigma/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A7.2_Z0.2_syst_momres/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.8_Z0.0_syst_momres/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.9_Z0.0_syst_momres/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A7.2_Z0.0_syst_momres/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A5.1_Z0.0_syst_momres/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_pions/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simDplusmeson_pions_%d.root",i).Data());
	}
        */
	tt->Add("/store/users/ovtin/outDmeson/Dplus/TMVA/uds_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_new.root");
    }
    else if (key==3){
        /*
	for(int i=1; i<=216; i++)   //DD BG
	{
	    if( i!=5 && i!=61 && i!=69 && i!=70 && i!=114 && i!=136 )
	    {
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_plus1sigma/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_ionization_losses_minus1sigma/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A7.2_Z0.2_syst_momres/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A4.8_Z0.0_syst_momres/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.9_Z0.0_syst_momres/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A7.2_Z0.0_syst_momres/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A5.1_Z0.0_syst_momres/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_syst_isr_plus_sigma/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_syst_isr_minus_sigma/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_syst_isr_rnd/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
	    }
	}
        */
	tt->Add("/store/users/ovtin/outDmeson/Dplus/TMVA/dbck_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_new.root");
    }
}

void setbranchstatus(){
    tt->SetBranchStatus("*",0);
    tt->SetBranchStatus("Dmeson",1);
    tt->SetBranchStatus("MVA",1);
}

void setbranchaddress(){
    tt->SetBranchAddress("Dmeson",&Dmeson);
    tt->SetBranchAddress("MVA",&MVA);
}

#endif
