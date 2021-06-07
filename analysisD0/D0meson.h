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
    /*
    int vrtntrk,vrtnip,vrtnbeam,nhitsdc,nhitst1,nhitst2,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
	nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo;
    float mbc,de,dp,prec1,prec2,fchi2,Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,
	e2,d1,d2,rr1,rr2,zip1,zip2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2;
	*/

    int vrtntrk,vrtnip,vrtnbeam,nhitsdc,nhitst1,nhitst2,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],
    aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20];
    float mbc,de,dp,prec1,prec2,fchi2,Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,
	e2,d1,d2,rr1,rr2,zip1,zip2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,ttof1,tofc2,ttof2,atcNpet1[20],atcTotalNpet1,
    atcNpet2[20],atcTotalNpet2,tlent1[20],tlent2[20];

};
data10 Dmeson;

int key;
TChain *tt=new TChain("et");
void chain(){
    if(key==0){
	for(int i=1; i<=693; i++)   //signal 2016+2017
	//for(int i=1; i<=667; i++)   //signal 2016+2017
	{
	        //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0/dataPcorr_1.0110_kNoiseReject3_atc/psi3770_to_D0meson_%d.root",i).Data());
	        tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0/dataPcorr_1.0155_kNoiseReject3_atc_KemcAllowediOn/psi3770_to_D0meson_%d.root",i).Data());
	        //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0/dataPcorr_1.0110_kNoiseReject3_atc_KemcAllowedOn/psi3770_to_D0meson_%d.root",i).Data());
	        //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0/dataPcorr_1.0200_kNoiseReject3_atc_KemcAllowediOn/psi3770_to_D0meson_%d.root",i).Data());
	        //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0/dataPcorr_1.0300_kNoiseReject3_atc_KemcAllowediOn/psi3770_to_D0meson_%d.root",i).Data());
	        //tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0/dataPcorr_1.0155_kNoiseReject3_atc_KemcAllowediOff/psi3770_to_D0meson_%d.root",i).Data());
          /*
	    if( i==42 || i==46 || i==63 || i==72 || i==87 || i==93 || i==120 || i==121 || i==123 || i==172 || i==174 || i==176 || i==177 || i==178 || i==179 || i==181 || i==182
	       || i==183 || i==184 || i==185 || i==186 || i==187 || i==188 || i==189 || i==190 || i==191 || i==192 || i==193 || i==194 || i==195 || i==196 || i==197 || i==198
	       || i==199 || i==200 || i==201 || i==202 || i==203 || i==204 || i==205 || i==206 || i==207 || i==208 || i==209 || i==210 || i==211 || i==212 || i==213 || i==214
	       || i==215 || i==216 || i==217 || i==218 || i==219 || i==220 || i==221 || i==222 || i==223 || i==224 || i==225 || i==226 || i==227 || i==228 || i==230 || i==231
	       || i==232 || i==233 || i==234 || i==235 || i==236 || i==237 || i==238 || i==239 || i==240 || i==241 || i==242 || i==243 || i==244 || i==245 || i==246 || i==247
	       || i==248 || i==249 || i==250 || i==251 || i==252 || i==253 || i==254 || i==255 || i==256 || i==257 || i==258 || i==259 || i==260 || i==261 || i==263 || i==264
	       || i==267 || i==269 || i==271 || i==273 || i==275 || i==278 || i==288 || i==289 || i==368 || i==371 || i==373 || i==374 || i==381 || i==392 || i==393 || i==394
	       || i==395 || i==398 || i==399 || i==400 || i==403 || i==409 || i==418 || i==423 || i==424 || i==442 || i==449 || i==452 || i==459 || i==489 || i==490 || i==492
	       || i==493 || i==494 || i==495 || i==497 || i==498 || i==499 || i==500 || i==502 || i==505 || i==506 || i==507 || i==508 || i==509 || i==512 || i==515 || i==516
	       || i==517 || i==518 || i==519 || i==520 || i==521 || i==522 || i==535 || i==536 || i==538 || i==539 || i==540 || i==542 || i==560 || i==561 || i==562 || i==563
	       || i==565 || i==566 || i==567 || i==568 || i==569 || i==570 || i==572 || i==574 || i==575 || i==576 || i==578 || i==580 || i==585 || i==586 || i==589 || i==590
	       || i==591 || i==592 || i==602 || i==610 || i==613 || i==623 || i==628 || i==634 || i==657 || i==661 || i==662 || i==663 || i==664 || i==665 || i==666 || i==667
	       || i==668 || i==669 || i==670 || i==671 || i==672 || i==673 || i==674 || i==675 || i==676 || i==677 || i==678 || i==679 || i==680 || i==681 || i==682 || i==683
	       || i==684 || i==685 || i==686 || i==687 || i==688 || i==689 || i==690 || i==691 || i==692 || i==693
	      )
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr_1.0173_kNoiseReject3_KemcAllowed-1/psi3770_to_D0meson_%d.root",i).Data());
	    }
	    else{
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr_1.0173_kNoiseReject3/psi3770_to_D0meson_%d.root",i).Data());
	    }
          */
	}
    }
    else if (key==4){
	for(int i=1; i<=482; i++)   //signal 2004+2005
	{
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/D0/dataPcorr2004_1.030/psi3770_to_D0meson_%d.root",i).Data());
	}
    }
    else if (key==1){              //MC Signal
	for(int i=1; i<=114; i++)
	{
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0/Signal/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	}
    }
    else if (key==2){              //uds BG
	for(int i=1; i<=221; i++)
	{
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simD0meson_ee_to_qq_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simD0meson_ee_to_qq_%d.root",i).Data());
	}
    }
    else if (key==3){              //DD BG
	for(int i=1; i<=221; i++)
	{
	    tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simD0mesonBkg_eetoDD_%d.root",i).Data());
	    //tt->Add(TString::Format("/store/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simD0mesonBkg_eetoDD_%d.root",i).Data());
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
