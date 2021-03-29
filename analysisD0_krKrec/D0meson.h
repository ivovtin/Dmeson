#ifndef D0meson_h
# define D0meson_h

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
    int vrtntrk,vrtnip,vrtnbeam,ncomb,nhitsdc,nhitst1,nhitst2,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    nveczt2,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],
    aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20];
    float mbc,de,dp,Mpart1,Ppart1,Mpart2,Ppart2,fchi2,Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,e2,rr1,rr2,zip1,zip2,ecls1,ecls2,
    tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,tofc1,ttof1,tofc2,ttof2,atcNpet1[20],atcTotalNpet1,atcNpet2[20],atcTotalNpet2,tlent1[20],tlent2[20];
};
data10 Dmeson;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	//for(int i=1; i<=693; i++)   //signal 2016+2017
	for(int i=1; i<=100; i++)   //signal 2016+2017
	{
	        tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr_1.0_kNoiseReject3_atc_KemcAllowed-1_krKrec/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==4){
	for(int i=1; i<=482; i++)   //signal 2004+2005
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr2004_1.030/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==1){              //MC Signal
	for(int i=1; i<=114; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	}
    }
    else if (key==2){              //uds BG
	for(int i=1; i<=221; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/psi3770_to_simD0meson_ee_to_qq_%d.root",i).Data());
	}
    }
    else if (key==3){              //DD BG
	for(int i=1; i<=221; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/psi3770_to_simD0mesonBkg_eetoDD_%d.root",i).Data());
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
