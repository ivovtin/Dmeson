#ifndef cosmic_h
# define cosmic_h

#include <Riostream.h>
#include <sstream>
#include <TROOT.h>
#include <TCanvas.h>
#include <TPad.h>
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
    Int_t charge1,charge2,vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
	nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo;
    Float_t Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,e2,d1,d2,rr1,rr2,
	zip1,zip2,x0t1,y0t1,z0t1,x0t2,y0t2,z0t2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2;
};
data10 cosmic;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	for(int i=1; i<=62; i++)   //signal 2016+2017
	{
	    //if( i!=50 && i!=51 && i!=52 ) tt->Add(TString::Format("/store/users/ovtin/outDmeson/cosmic/psi3770_to_cosmic_%d.root",i).Data());
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/cosmic/psi3770_to_cosmic_%d.root",i).Data());
	}
    }
    else if (key==1){              //MC Signal
	//for(int i=1; i<=17; i++)
	//for(int i=1; i<=119; i++)
	for(int i=1; i<=143; i++)
	//for(int i=1; i<=59; i++)
	{
	    if(i<=119)
	    {
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.0_Z0.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.2_Z0.2/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A4.8_Z0.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.9_Z0.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.1_Z0.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/1method/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A3.0_Z1.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.5_Z0.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.5_Z2.5/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z2.5/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A9.5_Z5.5/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z3.5/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A8.0_Z5.5/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.5_Z5.5/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z0.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.0_Z0.0/softcosm/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A4.5_Z0.0_new/psi3770_to_simCosmic_%d.root",i).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.5_Z5.5_new/psi3770_to_simCosmic_%d.root",i).Data());
	    }
            else
	    {
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.0_Z0.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.2_Z0.2/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A4.8_Z0.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.9_Z0.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.1_Z0.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/1method/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A3.0_Z1.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z2.5/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A9.5_Z5.5/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z3.5/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A5.5_Z0.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.5_Z0.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A6.0_Z0.0/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A8.0_Z5.5/psi3770_to_simCosmic_%d.root",i-119).Data());
		//tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/Cosmic/2method_corr_S1.0_A7.5_Z5.5/psi3770_to_simCosmic_%d.root",i-119).Data());
	    }
	}
    }
}

void setbranchstatus(){
    tt->SetBranchStatus("*",0);
    tt->SetBranchStatus("bhabha",1);
}

void setbranchaddress(){
    tt->SetBranchAddress("bhabha",&cosmic);
}

#endif
