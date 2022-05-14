#ifndef bhabhaATC_h
# define bhabhaATC_h

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
#include <TSystem.h>
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
#include <vector>
#include <TMultiGraph.h>
#include <TGraphErrors.h>
#include <TLegend.h>

struct dataATC
{
    Int_t charge1,charge2,vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],
    aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20];
    Float_t Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,e2,d1,d2,rr1,rr2,
	zip1,zip2,x0t1,y0t1,z0t1,x0t2,y0t2,z0t2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2,atcNpet1[20],atcTotalNpet1,
    atcNpet2[20],atcTotalNpet2,tlent1[20],tlent2[20];
};
dataATC bhabha;

int key;
TChain *tt=new TChain("et");
void chain(){
    for(int i=1; i<=122; i++)
    {
	tt->Add(TString::Format("/store/users/ovtin/outDmeson/bhabha/data2022/bhabha_%d.root",i).Data());
    }
}

void setbranchstatus(){
    tt->SetBranchStatus("*",0);
    tt->SetBranchStatus("bhabha",1);
}

void setbranchaddress(){
    tt->SetBranchAddress("bhabha",&bhabha);
}

#endif
