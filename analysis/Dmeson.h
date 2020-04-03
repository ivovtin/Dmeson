#ifndef Dmeson_h
# define Dmeson_h

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
    data t0atccr4;
    //for second track
    data t1atccr0;
    data t1atccr1;
    data t1atccr2;
    data t1atccr3;
    data t1atccr4;

    //structure for track from DC
    struct data2
    {
	int t,q,ip,nvec,nvecxy,nvecz,nhits,nhitsxy,nhitsz,nhitsvd;
	float p,pt,theta,phi,chi2,rc,xc,yc,zc,za,ph0,ph1,ph2,x0,x1,x2,y0,y1,y2,z0,z1,z2,vx,vy,vz;
	int emc_ncls, atc_ncnt;
    };
    data2 t0;
    data2 t1;

    //TOF system
    struct data3
    {
	int nhits, dchits, namps, ntimes;
	float time[2], length[2], beta[2], phi[2];
	int type[2];
    };
    data3 t0tof;
    data3 t1tof;

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

    //kinematic reconstruction
    struct data10
    {
	int numHyp;
	float chi2[5],M[5],P1[5],P2[5];
    };
    data10 jpsi;

   //atc
    struct data11
    {
	int natc_cr, natc_hits, natc_thr, rawdt;
	float dt;
    };
    data11 atcev;

    std::vector< float > npe1;
    float Kdiff,kx1,kx2,kx3,kx4;

    bool sim;
    TChain *tt=new TChain("et");

    //include samples Data/MC
    void chain(){
	if(sim!=1){
	    for(int i=1; i<=245; i++)
	    {
		tt->Add(TString::Format("/spool/users/ovtin/outDmeson/psi3770_to_D0meson_%d.root",i).Data());
	    }
	}
	else{
	    tt->Add("/home/ovtin/development/ATC/Jpsi_to_3pi/sim_jpsito3pi/jpsito3pi_sim_31.root");
	    tt->Add("/home/ovtin/development/ATC/Jpsi_to_3pi/sim_jpsito3pi/jpsito3pi_sim_32.root");
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
	tt->SetBranchStatus("t0atccr4",1);
	tt->SetBranchStatus("t0c0",1);
	tt->SetBranchStatus("t0c1",1);
	tt->SetBranchStatus("t0c2",1);
	tt->SetBranchStatus("t0tof",1);
	tt->SetBranchStatus("t1",1);
	tt->SetBranchStatus("t1atccr0",1);
	tt->SetBranchStatus("t1atccr1",1);
	tt->SetBranchStatus("t1atccr2",1);
	tt->SetBranchStatus("t1atccr3",1);
	tt->SetBranchStatus("t1atccr4",1);
	tt->SetBranchStatus("t1c0",1);
	tt->SetBranchStatus("t1c1",1);
	tt->SetBranchStatus("t1c2",1);
	tt->SetBranchStatus("t1tof",1);
	tt->SetBranchStatus("clgamma0",1);
	tt->SetBranchStatus("clgamma1",1);
	tt->SetBranchStatus("clgamma2",1);
	tt->SetBranchStatus("clgamma3",1);
	tt->SetBranchStatus("mu",1);
	tt->SetBranchStatus("jpsi",1);
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
	tt->SetBranchAddress("t0atccr4",&t0atccr4);
	tt->SetBranchAddress("t0c0",&t0c0);
	tt->SetBranchAddress("t0c1",&t0c1);
	tt->SetBranchAddress("t0c2",&t0c2);
	tt->SetBranchAddress("t0tof",&t0tof);
	tt->SetBranchAddress("t1",&t1);
	tt->SetBranchAddress("t1atccr0",&t1atccr0);
	tt->SetBranchAddress("t1atccr1",&t1atccr1);
	tt->SetBranchAddress("t1atccr2",&t1atccr2);
	tt->SetBranchAddress("t1atccr3",&t1atccr3);
	tt->SetBranchAddress("t1atccr4",&t1atccr4);
	tt->SetBranchAddress("t1c0",&t1c0);
	tt->SetBranchAddress("t1c1",&t1c1);
	tt->SetBranchAddress("t1c2",&t1c2);
	tt->SetBranchAddress("t1tof",&t1tof);
	tt->SetBranchAddress("clgamma0",&clgamma0);
	tt->SetBranchAddress("clgamma1",&clgamma1);
	tt->SetBranchAddress("clgamma2",&clgamma2);
	tt->SetBranchAddress("clgamma3",&clgamma3);
	tt->SetBranchAddress("mu",&mu);
	tt->SetBranchAddress("jpsi",&jpsi);
    }

    TProfile* pr1;
    TProfile* pr2;

    vector<float> chi2min;
    float mom=0;

    float pi=TMath::Pi();

    const int n=15;
    float eff[n]={0};
    float err_eff[n]={0};
    double num_npenotzero[n]={0};
    double num_npetotal[n]={0};
    float p_all[n]={0};
    float err_p_all[n]={0};
    float num_npezero[n]={0};

    float eff1[n]={0};
    float err_eff1[n]={0};
    double num_npenotzero1[n]={0};
    double num_npetotal1[n]={0};
    float num_npezero1[n]={0};

    float eff2[n]={0};
    float err_eff2[n]={0};
    double num_npenotzero2[n]={0};
    double num_npetotal2[n]={0};
    float num_npezero2[n]={0};

    float S;

    int npipi=0;
    //Mass Kaon and Pion
    Double_t m1=493.667, m2=139.57;
    //trheshold for ATC counter in number of photoelectrons
    float npetrh=0.5;
    float thicknpetrh=0.5;
    //counters for first and second layers ATC
    int ncnt1l1=0, ncnt1l2=80;
    int ncnt2l1=80, ncnt2l2=160;

    //for print DEBUG information
    bool verbose=0;
    bool verbose1=0;
    bool verbose2=0;

    int counter=0;

    int Natc=0;
    int Nselect=0;

    int kk; int kk1; int kk2; int ii1; int ii2;

    Double_t P11, P22;
    float n00, n01, n02, n03, n04;
    float n10, n11, n12, n13, n14;
    int cnt11, cnt12;
    int cnt21, cnt22;


#endif
