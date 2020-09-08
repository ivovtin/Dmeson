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
        //MC Bckg - continuum
	//int  nhitst1[20],nhitst2[20],ncomb,ncls1[20],ncls2[20];
	//float Mbc[20],Mbckin[20],InvM[20],dE[20],dEkin[20],dP[20],dPkin[20],depmkp[20],deppkm[20],Ebeam,rEv,P1[20],P2[20],Pt1[20],Pt2[20],chi2t1[20],chi2t2[20],e1[20],e2[20],rr1[20],rr2[20],Zip1[20],
	//    Zip2[20],ecls1[20],ecls2[20],tcls1[20],tcls2[20],pcls1[20],pcls2[20];
        //Mbc Sig, Data
	int  nhitst1[50],nhitst2[50],ncomb,ncls1[50],ncls2[50];
	float Mbc[50],Mbckin[50],InvM[50],dE[50],dEkin[50],dP[50],dPkin[50],depmkp[50],deppkm[50],Ebeam,rEv,P1[50],P2[50],Pt1[50],Pt2[50],chi2t1[50],chi2t2[50],e1[50],e2[50],rr1[50],rr2[50],Zip1[50],
	    Zip2[50],ecls1[50],ecls2[50],tcls1[50],tcls2[50],pcls1[50],pcls2[50];
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

	    //for(int i=1; i<=862; i++)   //signal 2016+2017
	    for(int i=1; i<=50; i++)   //signal 2016+2017
	    {
		//tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/data/psi3770_to_D0meson_%d.root",i).Data());
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr_v4/psi3770_to_D0meson_%d.root",i).Data());
	    }
	}
	else if (sim==4){
	    for(int i=1; i<=608; i++)   //signal 2004+2005
	    {
		//tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/data2004/psi3770_to_D0meson_%d.root",i).Data());
		//tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr2004_v1/psi3770_to_D0meson_%d.root",i).Data());
		//tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr2004_v2/psi3770_to_D0meson_%d.root",i).Data());
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/D0/dataPcorr2004/psi3770_to_D0meson_%d.root",i).Data());
	    }
	}
	else if (sim==1){
	    for(int i=1; i<=20; i++)
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Signal/psi3770_to_simD0mesonSignal_%d.root",i).Data());
	    }
	}
	else if (sim==2){
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq1_1.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq1_2.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq1_3.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq1_4.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq2_1.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq2_2.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq2_3.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq2_4.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq3_1.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq3_2.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq3_3.root");
	    tt->Add("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_continium/psi3770_to_simD0meson_ee_to_qq3_4.root");
	}
	else if (sim==3){
	    for(int i=1; i<=20; i++)
	    {
	    		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/simulation/outsimD0/Bkg_eetoDD/psi3770_to_simD0mesonBkg_eetoDD_%d.root",i).Data());
	    }
	}
    }

    void setbranchstatus(){
	tt->SetBranchStatus("*",0);
	tt->SetBranchStatus("ev",1);
	tt->SetBranchStatus("vrt",1);
	tt->SetBranchStatus("emc",1);
	tt->SetBranchStatus("atcev",1);
	tt->SetBranchStatus("t0",1);
	tt->SetBranchStatus("t0atccr0",1);
	tt->SetBranchStatus("t0atccr1",1);
	tt->SetBranchStatus("t0atccr2",1);
	tt->SetBranchStatus("t0atccr3",1);
	tt->SetBranchStatus("t0c0",1);
	tt->SetBranchStatus("t0c1",1);
	tt->SetBranchStatus("t0c2",1);
	//tt->SetBranchStatus("t0tof",1);
	tt->SetBranchStatus("t1",1);
	tt->SetBranchStatus("t1atccr0",1);
	tt->SetBranchStatus("t1atccr1",1);
	tt->SetBranchStatus("t1atccr2",1);
	tt->SetBranchStatus("t1atccr3",1);
	tt->SetBranchStatus("t1c0",1);
	tt->SetBranchStatus("t1c1",1);
	tt->SetBranchStatus("t1c2",1);
	//tt->SetBranchStatus("t1tof",1);
	tt->SetBranchStatus("t2",1);
	tt->SetBranchStatus("t2atccr0",1);
	tt->SetBranchStatus("t2atccr1",1);
	tt->SetBranchStatus("t2atccr2",1);
	tt->SetBranchStatus("t2atccr3",1);
	tt->SetBranchStatus("t2c0",1);
	tt->SetBranchStatus("t2c1",1);
	tt->SetBranchStatus("t2c2",1);
	//tt->SetBranchStatus("t2tof",1);
	tt->SetBranchStatus("t3",1);
	tt->SetBranchStatus("t3atccr0",1);
	tt->SetBranchStatus("t3atccr1",1);
	tt->SetBranchStatus("t3atccr2",1);
	tt->SetBranchStatus("t3atccr3",1);
	tt->SetBranchStatus("t3c0",1);
	tt->SetBranchStatus("t3c1",1);
	tt->SetBranchStatus("t3c2",1);
	//tt->SetBranchStatus("t3tof",1);
	tt->SetBranchStatus("t4",1);
	tt->SetBranchStatus("t4atccr0",1);
	tt->SetBranchStatus("t4atccr1",1);
	tt->SetBranchStatus("t4atccr2",1);
	tt->SetBranchStatus("t4atccr3",1);
	tt->SetBranchStatus("t4c0",1);
	tt->SetBranchStatus("t4c1",1);
	tt->SetBranchStatus("t4c2",1);
	tt->SetBranchStatus("t5",1);
	tt->SetBranchStatus("t5atccr0",1);
	tt->SetBranchStatus("t5atccr1",1);
	tt->SetBranchStatus("t5atccr2",1);
	tt->SetBranchStatus("t5atccr3",1);
	tt->SetBranchStatus("t5c0",1);
	tt->SetBranchStatus("t5c1",1);
	tt->SetBranchStatus("t5c2",1);
	tt->SetBranchStatus("t6",1);
	tt->SetBranchStatus("t6c0",1);
	tt->SetBranchStatus("t6c1",1);
	tt->SetBranchStatus("t6c2",1);
	tt->SetBranchStatus("t7",1);
	tt->SetBranchStatus("t7c0",1);
	tt->SetBranchStatus("t7c1",1);
	tt->SetBranchStatus("t7c2",1);
	tt->SetBranchStatus("t8",1);
	tt->SetBranchStatus("t8c0",1);
	tt->SetBranchStatus("t8c1",1);
	tt->SetBranchStatus("t8c2",1);
	tt->SetBranchStatus("t9",1);
	tt->SetBranchStatus("t9c0",1);
	tt->SetBranchStatus("t9c1",1);
	tt->SetBranchStatus("t9c2",1);

	tt->SetBranchStatus("clgamma0",1);
	tt->SetBranchStatus("clgamma1",1);
	tt->SetBranchStatus("clgamma2",1);
	tt->SetBranchStatus("clgamma3",1);
	tt->SetBranchStatus("mu",1);
	tt->SetBranchStatus("Dmeson",1);
    }

    void setbranchaddress(){
	tt->SetBranchAddress("ev",&ev);
	tt->SetBranchAddress("vrt",&vrt);
	tt->SetBranchAddress("emc",&emc);
	tt->SetBranchAddress("atcev",&atcev);
	tt->SetBranchAddress("t0",&t0);
	tt->SetBranchAddress("t0atccr0",&t0atccr0);
	tt->SetBranchAddress("t0atccr1",&t0atccr1);
	tt->SetBranchAddress("t0atccr2",&t0atccr2);
	tt->SetBranchAddress("t0atccr3",&t0atccr3);
	tt->SetBranchAddress("t0c0",&t0c0);
	tt->SetBranchAddress("t0c1",&t0c1);
	tt->SetBranchAddress("t0c2",&t0c2);
	//tt->SetBranchAddress("t0tof",&t0tof);
	tt->SetBranchAddress("t1",&t1);
	tt->SetBranchAddress("t1atccr0",&t1atccr0);
	tt->SetBranchAddress("t1atccr1",&t1atccr1);
	tt->SetBranchAddress("t1atccr2",&t1atccr2);
	tt->SetBranchAddress("t1atccr3",&t1atccr3);
	tt->SetBranchAddress("t1c0",&t1c0);
	tt->SetBranchAddress("t1c1",&t1c1);
	tt->SetBranchAddress("t1c2",&t1c2);
	//tt->SetBranchAddress("t1tof",&t1tof);
	tt->SetBranchAddress("t2",&t2);
	tt->SetBranchAddress("t2atccr0",&t2atccr0);
	tt->SetBranchAddress("t2atccr1",&t2atccr1);
	tt->SetBranchAddress("t2atccr2",&t2atccr2);
	tt->SetBranchAddress("t2atccr3",&t2atccr3);
	tt->SetBranchAddress("t2c0",&t2c0);
	tt->SetBranchAddress("t2c1",&t2c1);
	tt->SetBranchAddress("t2c2",&t2c2);
	//tt->SetBranchAddress("t2tof",&t2tof);
	tt->SetBranchAddress("t3",&t3);
	tt->SetBranchAddress("t3atccr0",&t3atccr0);
	tt->SetBranchAddress("t3atccr1",&t3atccr1);
	tt->SetBranchAddress("t3atccr2",&t3atccr2);
	tt->SetBranchAddress("t3atccr3",&t3atccr3);
	tt->SetBranchAddress("t3c0",&t3c0);
	tt->SetBranchAddress("t3c1",&t3c1);
	tt->SetBranchAddress("t3c2",&t3c2);
	tt->SetBranchAddress("t4",&t4);
	tt->SetBranchAddress("t4atccr0",&t4atccr0);
	tt->SetBranchAddress("t4atccr1",&t4atccr1);
	tt->SetBranchAddress("t4atccr2",&t4atccr2);
	tt->SetBranchAddress("t4atccr3",&t4atccr3);
	tt->SetBranchAddress("t4c0",&t4c0);
	tt->SetBranchAddress("t4c1",&t4c1);
	tt->SetBranchAddress("t4c2",&t4c2);
	tt->SetBranchAddress("t5",&t5);
	tt->SetBranchAddress("t5atccr0",&t5atccr0);
	tt->SetBranchAddress("t5atccr1",&t5atccr1);
	tt->SetBranchAddress("t5atccr2",&t5atccr2);
	tt->SetBranchAddress("t5atccr3",&t5atccr3);
	tt->SetBranchAddress("t5c0",&t5c0);
	tt->SetBranchAddress("t5c1",&t5c1);
	tt->SetBranchAddress("t5c2",&t5c2);
	tt->SetBranchAddress("t6",&t6);
	tt->SetBranchAddress("t6c0",&t6c0);
	tt->SetBranchAddress("t6c1",&t6c1);
	tt->SetBranchAddress("t6c2",&t6c2);
	tt->SetBranchAddress("t7",&t7);
	tt->SetBranchAddress("t7c0",&t7c0);
	tt->SetBranchAddress("t7c1",&t7c1);
	tt->SetBranchAddress("t7c2",&t7c2);
	tt->SetBranchAddress("t8",&t8);
	tt->SetBranchAddress("t8c0",&t8c0);
	tt->SetBranchAddress("t8c1",&t8c1);
	tt->SetBranchAddress("t8c2",&t8c2);
	tt->SetBranchAddress("t9",&t9);
	tt->SetBranchAddress("t9c0",&t9c0);
	tt->SetBranchAddress("t9c1",&t9c1);
	tt->SetBranchAddress("t9c2",&t9c2);

	//tt->SetBranchAddress("t3tof",&t3tof);
	tt->SetBranchAddress("clgamma0",&clgamma0);
	tt->SetBranchAddress("clgamma1",&clgamma1);
	tt->SetBranchAddress("clgamma2",&clgamma2);
	tt->SetBranchAddress("clgamma3",&clgamma3);
	tt->SetBranchAddress("mu",&mu);
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

    int nhitsxy[10], nvec[10];
    float theta[10], phi[10];

    double deCut1, deCut2;
    double mbcCut1, mbcCut2;

#endif
