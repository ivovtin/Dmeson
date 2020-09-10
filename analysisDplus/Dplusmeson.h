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
#include <algorithm>      // std::min_element, std::max_element
#include <assert.h>

    //structure for ATC
    struct data
    {
	int i, t, ntrk, triggered,zero,fitted,estimated,neightrig,wlshit,nearwls,aerogel_region,aerogel_region0,
	aerogel_region5,aerogel_region20,active_region,active_region0,active_region5,active_region20,test,
	single_aerogel_region,single_aerogel_region0,single_aerogel_region5,single_aerogel_region20,single_active_region,
	single_active_region0,single_active_region5,single_active_region20,single_test,
	in_aerogel_region,in_aerogel_region0,in_aerogel_region5,in_aerogel_region20,in_active_region,in_active_region0,in_active_region5,in_active_region20,in_test,
	out_aerogel_region,out_aerogel_region0,out_aerogel_region5,out_aerogel_region20,out_active_region,out_active_region0,out_active_region5,out_active_region20,out_test;
	float amp, rtime,time,chi2,npe,npen,tlen,pathwls,rin,phiin,zin,rout,phiout,zout,rwls,phiwls,zwls,neighnpe,Rin_gl,Phiin_gl,Zin_gl,Rout_gl,Phiout_gl,Zout_gl;
    };
    data atccr;
    //for first track
    data t0atccr0;
    data t0atccr1;
    data t0atccr2;
    data t0atccr3;
    //for second track
    data t1atccr0;
    data t1atccr1;
    data t1atccr2;
    data t1atccr3;
    //for third track
    data t2atccr0;
    data t2atccr1;
    data t2atccr2;
    data t2atccr3;
    //for four track
    data t3atccr0;
    data t3atccr1;
    data t3atccr2;
    data t3atccr3;
    //for five track
    data t4atccr0;
    data t4atccr1;
    data t4atccr2;
    data t4atccr3;
    //for six track
    data t5atccr0;
    data t5atccr1;
    data t5atccr2;
    data t5atccr3;

    //structure for track from DC
    struct data2
    {
	int t,q,ip,nvec,nvecxy,nvecz,nhits,nhitsxy,nhitsz,nhitsvd;
	float p,pt,theta,phi,chi2,rc,xc,yc,zc,za,ph0,ph1,ph2,x0,x1,x2,y0,y1,y2,z0,z1,z2,vx,vy,vz;
	int emc_ncls, atc_ncnt;
    };
    data2 t0;
    data2 t1;
    data2 t2;
    data2 t3;
    data2 t4;
    data2 t5;
    data2 t6;
    data2 t7;
    data2 t8;
    data2 t9;
    data2 t10;

    //TOF system
    struct data3
    {
	int nhits, dchits, namps, ntimes;
	float time[2], length[2], beta[2], phi[2];
	int type[2];
    };
    data3 t0tof;
    //data3 t1tof;
    //data3 t2tof;
    //data3 t3tof;

    //EM-Calorymeter
    struct data4
    {
	int ncls,ncls_trk,nlkr,ncsi,nstrcls,nstrtrk;
	float energy,elkr,ecsi;
    };
    data4 emc;

    struct data5
    {
	int c,lkr,csi,ncells;
	float e,x,y,z,vx,vy,vz,theta,phi,rho,dtheta,dphi,drho,thetastr,phistr;
	int qlty,ncellsbad,str_ncls,str_ntrk,dc_ntrk,emc_ncls;
    };
    data5 t0c0;
    data5 t0c1;
    data5 t0c2;
    data5 t1c0;
    data5 t1c1;
    data5 t1c2;
    data5 t2c0;
    data5 t2c1;
    data5 t2c2;
    data5 t3c0;
    data5 t3c1;
    data5 t3c2;
    data5 t4c0;
    data5 t4c1;
    data5 t4c2;
    data5 t5c0;
    data5 t5c1;
    data5 t5c2;
    data5 t6c0;
    data5 t6c1;
    data5 t6c2;
    data5 t7c0;
    data5 t7c1;
    data5 t7c2;
    data5 t8c0;
    data5 t8c1;
    data5 t8c2;
    data5 t9c0;
    data5 t9c1;
    data5 t9c2;
    data5 clgamma0;
    data5 clgamma1;
    data5 clgamma2;
    data5 clgamma3;

    //MU system
    struct data7
    {
	int nhits,dcmuhits,octant,layer;
	int status;
    };
    data7 mu;

    //event, run, ebeam...
    struct data8
    {
	int event,evdaq,run,quality;
	float ebeam;
    };
    data8 ev;

    //VRTX detector
    struct data9
    {
	int ntrk, nip, nbeam;
	float x, y, z;
	float sig_x, sig_y, sig_z;
	float theta2t, phi2t;
    };
    data9 vrt;

    struct data10
    {
	int vrtntrk,vrtnip,vrtnbeam,nhitst1,nhitst2,nhitst3,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
	nhitszt2,nhitsxyt3,nhitszt3,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,
	nvecxyt3,nveczt3,ncomb,ncls1,ncls2,ncls3,ncls,nlkr,ncsi,munhits,Run;
	float Mbc,Mbckin,dE,dEkin,Ebeam,rEv,P1,P2,P3,Pt1,Pt2,Pt3,thetat1,thetat2,thetat3,phit1,phit2,phit3,chi2t1,chi2t2,chi2t3,
	    e1,e2,e3,rr1,rr2,rr3,Zip1,Zip2,Zip3,ecls1,ecls2,ecls3,tcls1,tcls2,tcls3,pcls1,pcls2,pcls3,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,
	timet2,betat2,lengtht2,timet3,betat3,lengtht3;
    };
    data10 Dmeson;

   //atc
    struct data11
    {
	int natc_cr, natc_hits, natc_thr, rawdt;
	float dt;
    };
    data11 atcev;

    std::vector< float > npe1;
    float Kdiff,kx1,kx2,kx3,kx4;

    int sim;
    TChain *tt=new TChain("et");
    //include samples Data/MC
    void chain(){
	if(sim==0){
	    for(int i=1; i<=862; i++)   //signal 2016+2017
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/data/psi3770_to_D0meson_%d.root",i).Data());
	    }
	}
	else if (sim==4){
	    for(int i=1; i<=608; i++)   //signal 2004
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/data2004/psi3770_to_D0meson_%d.root",i).Data());
		//tt->Add(TString::Format("/spool/users/ovtin/outDmeson/Dplus/dataPcorr2004/psi3770_to_D0meson_%d.root",i).Data());
	    }
	}
	else if (sim==1){
	    //for(int i=1; i<=20; i++)
	    for(int i=1; i<=5; i++)
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Signal/psi3770_to_simDplusmesonSignal_%d.root",i).Data());
	    }
	}
	else if (sim==2){
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq1_1.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq1_2.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq1_3.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq1_4.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq2_1.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq2_2.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq2_3.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq2_4.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq3_1.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq3_2.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq3_3.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimDplus/Bkg_continium/psi3770_to_simDplusmeson_ee_to_qq3_4.root");
	}
	else if (sim==3){
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

    TH1F* hInvM;
    TH1F* hde;

    vector<float> chi2min;
    float mom=0;

    float pi=TMath::Pi();

    float S;

    int npipi=0;
    //Mass Kaon and Pion
    Double_t m1=493.667, m2=139.57;

    float tof1,dtof1;

    double deCut1, deCut2;
    double mbcCut1, mbcCut2;

#endif
