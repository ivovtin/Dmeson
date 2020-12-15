#ifndef kspp_h
# define kspp_h

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
    Int_t charge1,charge2,vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
	nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo;
    Float_t Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,invM,e1,e2,d1,d2,r,ix,iy,rr1,rr2,
	zip1,zip2,x0t1,y0t1,z0t1,x0t2,y0t2,z0t2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2;
};
data10 ks;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	for(int i=1; i<=693; i++)   //signal 2016+2017
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Kspp/data/psi3770_to_Kspp_%d.root",i).Data());
	}
    }
    else if (key==1){
	//for(int i=1; i<=482; i++)   //signal 2004+2005
	for(int i=1; i<=13; i++)   //signal 2004+2005
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Kspp/data2004/psi3770_to_Kspp_%d.root",i).Data());
	}
    }
    else if (key==2){              //MC Signal
	for(int i=1; i<=11; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/Kspp/psi3770_to_simKspp_%d.root",i).Data());
	}
    }
}

void setbranchstatus(){
    tt->SetBranchStatus("*",0);
    tt->SetBranchStatus("ks",1);
}

void setbranchaddress(){
    tt->SetBranchAddress("ks",&ks);
}

#endif
