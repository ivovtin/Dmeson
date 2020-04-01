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
	    for(int i=1; i<=50; i++)
	    {
		tt->Add(TString::Format("/spool/users/ovtin/psi3770_to_D0meson_%d.root",i).Data());
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

    TFile *fout=0;
    TString fnameout;
    char branchname[1];
    char branchname1[161];

    TH1F* h1=new TH1F("E/p","E/p",100,0.,10.);
    TH1F* h2=new TH1F("Energy","Energy",1000,0.,5000.);
    TH1F* h3=new TH1F("E_LKr","Energy LKr",1000,0.,5000.);
    TH1F* h4=new TH1F("E_CsI","Energy CsI",1000,0.,5000.);
    TH1F* h7=new TH1F("Momentum","Momentum",1000,0.,5000.);
    TH1F* h8=new TH1F("theta","t.theta",1000,0.,185.);
    TH1F* h9=new TH1F("phi","t.phi",1000,0.,380.);
    TH1F* h10=new TH1F("theta2t","vrt.theta2t",1000,0.,185.);
    TH1F* h11=new TH1F("phi2t","vrt.phi2t",1000,0.,185.);
    TH1F* h12=new TH1F("cos(theta2t)","cos(theta2t)",100,-1.,1.);
    TH1F* h13=new TH1F("cos(phi2t)","cos(phi2t)",100,-1.,1.);
    TH1F* h14=new TH1F("cos(t.theta)","cos(t.theta)",100,-1.,1.);
    TH1F* h15=new TH1F("cos(t.phi)","cos(t.phi)",100,-1.,1.);
    TH1F* h16=new TH1F("InvMass","InvMass",1000,0.,4000.);
    TH1F* h17=new TH1F("Mbc","Mbc",1000,0.,4000.);
    TH1F* h18=new TH1F("de","de",1000,-10000.,10000.);

    TH1F* h19=new TH1F("t0tof.nhits","t0tof.nhits",20,0.,20.);
    TH1F* h20=new TH1F("t0tof.dchits","t0tof.dchits",20,0.,20.);
    TH1F* h21=new TH1F("t0tof.namps","t0tof.namps",20,0.,20.);
    TH1F* h22=new TH1F("t0tof.ntimes","t0tof.ntimes",20,0.,20.);
    TH1F* h23=new TH1F("t0tof.time","t0tof.time",1000,-150.,150.);
    TH1F* h24=new TH1F("t0tof.beta","t0tof.beta",1000,-1.,5.);
    TH1F* h25=new TH1F("t0tof.length","t0tof.length",1000,0.,250.);

    TH1F* h26=new TH1F("t1tof.nhits","t1tof.nhits",20,0.,20.);
    TH1F* h27=new TH1F("t1tof.dchits","t1tof.dchits",20,0.,20.);
    TH1F* h28=new TH1F("t1tof.namps","t1tof.namps",20,0.,20.);
    TH1F* h29=new TH1F("t1tof.ntimes","t1tof.ntimes",20,0.,20.);
    TH1F* h30=new TH1F("t1tof.time","t1tof.time",1000,-150.,150.);
    TH1F* h31=new TH1F("t1tof.beta","t1tof.beta",1000,-1.,5.);
    TH1F* h32=new TH1F("t1tof.length","t1tof.length",1000,0.,250.);

    TH1F* h33=new TH1F("ratiop1t0p","p1/t0.p",100,0.,10.);
    TH1F* h34=new TH1F("ratiop2t1p","p2/t1.p",100,0.,10.);
    TH1F* h35=new TH1F("S","S",150,0.,1.5);
    TH1F* h40=new TH1F("t0chi2","t0.chi2",1000,0.,1000.);
    TH1F* h41=new TH1F("t1chi2","t1.chi2",1000,0.,1000.);
    TH1F* h42=new TH1F("h42","cos_2t",100,-1.,1.);
    TH1F* h43=new TH1F("ncls","emc.ncls",12,0.,12.);
    TH1F* h45=new TH1F("t0.nhitsxy","t0.nhitsxy",100,0.,100.);
    TH1F* h46=new TH1F("t1.nhitsxy","t1.nhitsxy",100,0.,100.);
    TH1F* h47=new TH1F("t0.nvecxy","t0.nvecxy",100,0.,100.);
    TH1F* h48=new TH1F("t1.nvecxy","t1.nvecxy",100,0.,100.);
    TH1F* h49=new TH1F("t0.nvec","t0.nvec",100,0.,100.);
    TH1F* h50=new TH1F("t1.nvec","t1.nvec",100,0.,100.);
    TH1F* h51=new TH1F("clgamma0theta","clgamma0.theta",1000,0.,185.);
    TH1F* h52=new TH1F("clgamma1theta","clgamma1.theta",1000,0.,185.);
    TH1F* h53=new TH1F("cos(cl.theta)","cos(cl.theta)",100,-1.,1.);
    TH1F* h58=new TH1F("munhits","mu.nhits",30,0.,30.);
    TH1F* hzero=new TH1F("hzero","Jpsi->pi^{+}pi^{-}pi^{0}",1600,0,1600);
    TH1F* hzero1=new TH1F("hzero1","vrt.theta2t",1000,0.,185.);
    TH1F* hzero2=new TH1F("hzero2","cos(theta2t)",100,-1.,1.);
    TH1F* hzero4=new TH1F("hzero4","Energy",1000,0.,5000.);
    TH1F* hzero5=new TH1F("hzero5","emc.ncls",12,0.,12.);

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
    int Npred=0;


#endif
