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

struct data10
{
    int vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitst3,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,
    nvecxyt3,nveczt3,ncomb,ncls1,ncls2,ncls3,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run;
    float mbc,de,fchi2,Ebeam,rEv,p1,p2,p3,pt1,pt2,pt3,thetat1,thetat2,thetat3,phit1,phit2,phit3,chi2t1,chi2t2,chi2t3,
	e1,e2,e3,rr1,rr2,rr3,zip1,zip2,zip3,ecls1,ecls2,ecls3,tcls1,tcls2,tcls3,pcls1,pcls2,pcls3,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,
    timet2,betat2,lengtht2,timet3,betat3,lengtht3;

};
data10 Dmeson;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	for(int i=1; i<=693; i++)   //signal 2016+2017
	{
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/data/psi3770_to_D0meson_%d.root",i).Data());
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr_1.0155/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==4){
	for(int i=1; i<=482; i++)   //signal 2004
	{
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/data2004/psi3770_to_D0meson_%d.root",i).Data());
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==1){
	//for(int i=1; i<=5; i++)
	for(int i=1; i<=3; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	}
    }
    else if (key==2){
    	for(int i=1; i<=12; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simD0meson_ee_to_qq_%d.root",i).Data());
	}
    }
    else if (key==3){
	for(int i=1; i<=10; i++)
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
