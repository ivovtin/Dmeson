#ifndef bhabha_h
# define bhabha_h

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
    Int_t charge1,charge2,vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
	nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo;
    Float_t Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,e2,d1,d2,rr1,rr2,
	zip1,zip2,x0t1,y0t1,z0t1,x0t2,y0t2,z0t2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2;
};
data10 bhabha;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	//tt->Add("/spool/users/ovtin/bhabha_out_23551-23569.root");
	for(int i=1; i<=693; i++)   //signal 2016+2017
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/bhabha/data/psi3770_to_bhabha_%d.root",i).Data());
	}
    }
    else if (key==1){
	for(int i=1; i<=482; i++)   //signal 2004+2005
	{
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/bhabha/data2004/psi3770_to_bhabha_%d.root",i).Data());
	}
    }
    else if (key==2){              //MC Signal
	//tt->Add("/spool/users/ovtin/bhabha_out_sim.root");
	//for(int i=1; i<=124; i++)
	for(int i=1; i<=1; i++)
	{
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/KsimSystErr2/psi3770_to_simBhaBha_%d.root",i).Data());
	    tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/psi3770_to_simBhaBha_%d.root",i).Data());
	}
	//for(int i=121; i<=124; i++)
	//{
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/woCorScales/psi3770_to_simBhaBha_%d.root",i).Data());
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23275-23286_1.0_0.8/psi3770_to_simBhaBha_%d.root",i).Data());   //1   1
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23287-23317_1.0_0.3/psi3770_to_simBhaBha_%d.root",i).Data());   //2   2-4
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23318-23369_1.4_1.0/psi3770_to_simBhaBha_%d.root",i).Data());   //3   5-9 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23403-23430_1.3_1.0/psi3770_to_simBhaBha_%d.root",i).Data());   //4   10-11 - bad data in runs !!!
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23431-23472_1.2_0.9/psi3770_to_simBhaBha_%d.root",i).Data());   //5   12-15 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23473-23522_2.2_1.5/psi3770_to_simBhaBha_%d.root",i).Data());   //6   16-19 - bad data in runs !!!
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23523-23550_2.0_1.3/psi3770_to_simBhaBha_%d.root",i).Data());   //7   20-22 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23551-23569_1.8_1.1/psi3770_to_simBhaBha_%d.root",i).Data());   //8   23-24
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23645-23681_1.2_0.81/psi3770_to_simBhaBha_%d.root",i).Data());  //9   25-26 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23682-23715_1.5_0.8/psi3770_to_simBhaBha_%d.root",i).Data());   //10  27-29
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23716-23742_1.5_1.7/psi3770_to_simBhaBha_%d.root",i).Data());   //11  30-32
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23743-23798_1.5_1.7/psi3770_to_simBhaBha_%d.root",i).Data());   //11  33-34
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23839-23862_1.6_1.3/psi3770_to_simBhaBha_%d.root",i).Data());   //14  36-37
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23863-23885_1.1_0.7/psi3770_to_simBhaBha_%d.root",i).Data());   //15  38-40
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23886-23905_1.0_0.9/psi3770_to_simBhaBha_%d.root",i).Data());   //16  41-42
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/23906-23943_1.9_1.5/psi3770_to_simBhaBha_%d.root",i).Data());   //17  43-44  - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24621-24675_2.9_2.4/psi3770_to_simBhaBha_%d.root",i).Data());   //18  45-50  - bad
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24676-24712_1.6_1.1/psi3770_to_simBhaBha_%d.root",i).Data());   //19  51-54
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24790-24845_1.6_1.0/psi3770_to_simBhaBha_%d.root",i).Data());   //20  55-58
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24846-24875_1.4_1.0/psi3770_to_simBhaBha_%d.root",i).Data());   //21  59-61 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/24876-24916_2.4_1.7/psi3770_to_simBhaBha_%d.root",i).Data());   //22  62-64
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25045-25090_2.3_1.6/psi3770_to_simBhaBha_%d.root",i).Data());   //24  65-69
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25091-25114_1.6_1.1/psi3770_to_simBhaBha_%d.root",i).Data());   //25  70-71 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25115-25157_1.6_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //26  72-75 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25158-25185_1.6_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //27  76-78 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25186-25241_1.5_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //28  79-84
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25352-25395_1.4_1.1/psi3770_to_simBhaBha_%d.root",i).Data());   //29  85-89 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25396-25416_1.9_1.3/psi3770_to_simBhaBha_%d.root",i).Data());   //30  90-91
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25417-25438_1.6_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //31  92-95
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25439-25508_1.9_1.3/psi3770_to_simBhaBha_%d.root",i).Data());   //32  96-98
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25559-25574_1.5_1.1/psi3770_to_simBhaBha_%d.root",i).Data());   //33  99-100
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25575-25608_1.2_1.0/psi3770_to_simBhaBha_%d.root",i).Data());   //34  101-103
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25609-25640_1.6_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //35  104-107
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25641-25663_1.6_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //36  108-109
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/25664-25719_1.6_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //37  110-113
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/26051-26079_1.8_1.3/psi3770_to_simBhaBha_%d.root",i).Data());   //38  114-116
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/26080-26102_1.6_1.2/psi3770_to_simBhaBha_%d.root",i).Data());   //39  117-120 - good
	    //tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/BhaBha/26103-26134_1.4_1.0/psi3770_to_simBhaBha_%d.root",i).Data());   //40  121-124
	//}
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
