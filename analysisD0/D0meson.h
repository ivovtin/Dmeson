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
#include <algorithm>      // std::min_element, std::max_element
#include <assert.h>

    struct data10
    {
	int vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
	nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,Run;
	//float Mbc,Mbckin,InvM,dE,dEkin,dP,dPkin,epmkp,eppkm,Ebeam,rEv,P1,P2,Pt1,Pt2,chi2t1,chi2t2,thetat1,thetat2,phit1,phit2,e1,     //2004
	float Mbc,Mbckin,InvM,dE,dEkin,dP,dPkin,epmkp,eppkm,Ebeam,rEv,P1,P2,Pt1,Pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,
	    e2,d1,d2,rr1,rr2,Zip1,Zip2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy;
    };
    data10 Dmeson;

    int sim;
    TChain *tt=new TChain("et");
    //include samples Data/MC
    void chain(){
	if(sim==0){

	    for(int i=1; i<=862; i++)   //signal 2016+2017
	    {
		//tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/data/psi3770_to_D0meson_%d.root",i).Data());
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr_v9/psi3770_to_D0meson_%d.root",i).Data());
	    }
	}
	else if (sim==4){
	    for(int i=1; i<=608; i++)   //signal 2004+2005
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/data2004/psi3770_to_D0meson_%d.root",i).Data());
		//tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr2004/psi3770_to_D0meson_%d.root",i).Data());
	    }
	}
	else if (sim==1){
	    for(int i=1; i<=2; i++)
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	    }
	}
	else if (sim==2){
	    for(int i=1; i<=12; i++)
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq_%d.root",i).Data());
	    }
	}
	else if (sim==3){
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

    //********************************************
    //for print DEBUG information
    bool verbose=0;

    //int ntrk=3;
    int ntrk=2; //for sim
    int nip=0;
    int nbeam=0;
    //int max_munhits=2;
    int max_munhits=4;
    float min_pt=100.; //MeV
    float max_pt=2000.; //MeV
    float min_Mbc=1700.;
    //float min_Mbc=1800.;        //sim
    float max_Mbc=1900.;
    float min_dE=-300.;
    float max_dE=300.;
    //float eclsCut=1000.;
    float eclsCut=5000.;       //sim

    //2016-17
    float rrCut=0.75;
    float zCut=13.;
    float max_chi2=70.;
    float min_nhits=20.;
    float tofCut=-1.0;

    /*
     //2004
     float rrCut=0.5;
     float zCut=12;
     float max_chi2=50;
     float min_nhits=24;
     float max_nhits=50;
     */
    //********************************************

    TH1F* hInvM;
    TH1F* hde;

    float pi=TMath::Pi();

    //Mass Kaon and Pion
    Double_t m1=493.667, m2=139.57;

    double deCut1, deCut2;
    double mbcCut1, mbcCut2;

#endif
