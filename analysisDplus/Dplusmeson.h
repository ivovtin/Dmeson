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
    //int vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitst3,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
    /*
    int vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,nhitst1,nhitst2,nhitst3,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,
    nvecxyt3,nveczt3,ncomb,ncls1,ncls2,ncls3,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run;
    float mbc,de,fchi2,Ebeam,rEv,p1,p2,p3,pt1,pt2,pt3,thetat1,thetat2,thetat3,phit1,phit2,phit3,chi2t1,chi2t2,chi2t3,
	e1,e2,e3,rr1,rr2,rr3,zip1,zip2,zip3,ecls1,ecls2,ecls3,tcls1,tcls2,tcls3,pcls1,pcls2,pcls3,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,
    timet2,betat2,lengtht2,timet3,betat3,lengtht3;
    */
    /*
    int vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,nhitst1,nhitst2,nhitst3,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
	nhitszt2,nhitsxyt3,nhitszt3,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,
    nvecxyt3,nveczt3,ncomb,ncls1,ncls2,ncls3,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run;
    float mbc,de,prec1,prec2,prec3,fchi2,Ebeam,rEv,p1,p2,p3,pt1,pt2,pt3,thetat1,thetat2,thetat3,phit1,phit2,phit3,chi2t1,chi2t2,chi2t3,
	e1,e2,e3,rr1,rr2,rr3,zip1,zip2,zip3,ecls1,ecls2,ecls3,tcls1,tcls2,tcls3,pcls1,pcls2,pcls3,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,
    timet2,betat2,lengtht2,timet3,betat3,lengtht3;
    */
    int vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,nhitst1,nhitst2,nhitst3,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,nvecxyt3,nveczt3,ncomb,ncls1,ncls2,ncls3,ncls,nlkr,ncsi,munhits,mulayerhits1,
    mulayerhits2,mulayerhits3,Run,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],natccrosst3,atcCNTt3[20],aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],aerogel_REGIONt3[20],aerogel_REGION0t3[20],aerogel_REGION5t3[20],aerogel_REGION20t3[20],single_aerogel_REGIONt3[20],
    single_aerogel_REGION0t3[20],single_aerogel_REGION5t3[20],single_aerogel_REGION20t3[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20],wlshitt3[20],nearwlst3[20];
    float mbc,de,prec1,prec2,prec3,fchi2,Ebeam,rEv,p1,p2,p3,pt1,pt2,pt3,thetat1,thetat2,thetat3,phit1,phit2,phit3,chi2t1,chi2t2,chi2t3,e1,e2,e3,rr1,rr2,rr3,zip1,zip2,zip3,
	ecls1,ecls2,ecls3,tcls1,tcls2,tcls3,pcls1,pcls2,pcls3,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,timet2,betat2,lengtht2,timet3,betat3,lengtht3,
        atcNpet1[20],atcTotalNpet1,atcNpet2[20],atcTotalNpet2,atcNpet3[20],atcTotalNpet3,tlent1[20],tlent2[20],tlent3[20];
};
data10 Dmeson;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	//for(int i=1; i<=693; i++)   //signal 2016+2017
	for(int i=1; i<=298; i++)   //signal 2016+2017
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr_1.0170_kNoiseReject3_atc/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==4){
	for(int i=1; i<=482; i++)   //signal 2004
	{
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/data2004/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004/psi3770_to_D0meson_%d.root",i).Data());
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0280/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0295/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.031/psi3770_to_D0meson_%d.root",i).Data());    //best
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0325/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0340/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0360/psi3770_to_D0meson_%d.root",i).Data());
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004_1.0250/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==1){
	for(int i=1; i<=114; i++)   //Signal
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	}
    }
    else if (key==2){
	for(int i=1; i<=221; i++)   //uds BG
	{
	    if( i!=5 && i!=61 && i!=69 && i!=70 && i!=114 && i!=136 && i!=163 && i!=213 && i!=215 )
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq_%d.root",i).Data());
	    }
	}
    }
    else if (key==3){
	for(int i=1; i<=221; i++)   //DD BG
	{
            tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_eetoDD/psi3770_to_simDplusmesonBkg_eetoDD_%d.root",i).Data());
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
