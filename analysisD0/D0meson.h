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

struct data10
{
    /*
    int vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    //nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,Run;
    nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run; //new 2004
    //float Mbc,Mbckin,InvM,dE,dEkin,dP,dPkin,epmkp,eppkm,Ebeam,rEv,P1,P2,Pt1,Pt2,chi2t1,chi2t2,thetat1,thetat2,phit1,phit2,e1,     //2004
    float Mbc,Mbckin,InvM,dE,dEkin,dP,dPkin,epmkp,eppkm,Ebeam,rEv,P1,P2,Pt1,Pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,
        e2,d1,d2,rr1,rr2,Zip1,Zip2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,chi2kin,Mkin1,Mkin2,Pkin1,Pkin2,Mbc2,dE2,dP2;
	*/

    int vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo;
    float mbc,de,dp,fchi2,epmkp,eppkm,Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,
	e2,d1,d2,rr1,rr2,zip1,zip2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2;
};
data10 Dmeson;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){

	for(int i=1; i<=862; i++)   //signal 2016+2017
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr_v9/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==4){
	//for(int i=1; i<=608; i++)   //signal 2004+2005
	for(int i=1; i<=200; i++)   //signal 2004+2005
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr2004_v4/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==1){              //MC Signal
	for(int i=1; i<=2; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/with_radcor_photos/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	}
    }
    else if (key==2){              //uds BG
	for(int i=1; i<=12; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq_%d.root",i).Data());
	}
    }
    else if (key==3){              //DD BG
	for(int i=1; i<=10; i++)
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/psi3770_to_simD0mesonBkg_eetoDD_%d.root",i).Data());
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
