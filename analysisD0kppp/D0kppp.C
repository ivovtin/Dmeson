#include <unistd.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <algorithm>
#include <cfortran.h>

#include <stdlib.h>
#include <stdio.h>
#include <cstdio>
#include <cstdlib>

#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <vector>

#include <getopt.h>
#include <math.h>
#include "KDB/kdb.h"
#include "KDB/kd_db.h"

#include "D0kppp.h"

#define PI 3.14159265358979

using namespace std;
string progname;

int Usage(string status)
{
	cout<<"Usage: "<<progname<<"\t"<<"Data (0 - 2016-17, 4 - 2004) or MC (1 - Signal, 2 - BG continium, 3 - BG DD)"<<endl;
	exit(0);
}

inline char* timestamp(time_t t)
{
    static const char* time_fmt="%b %d %Y %H:%M:%S";
    static char strtime[50];

    struct tm* brtm=localtime(&t);
    strftime(strtime,50,time_fmt,brtm);

    return strtime;
}

void get_run_lumi(int run, double *en, double *en_err, double *lum, int *t) {
    int array[8];
    KdDbConn* conn;
    KDBruninfo runinfo;
    int id;

    conn = kd_db_open(NULL);
    id = kd_db_get_id("runenergy",conn);
    if (kd_db_get_for_run_int(id, run, conn, array, 8)) {
	*en = array[1]/1e6;
	*en_err = array[2]/1e6;
    }
    if (kd_db_get_run_info(run, 1, conn, &runinfo))
	*lum = runinfo.intelum;
	//*lum = runinfo.intplum;
    *t = runinfo.livesec;
    kd_db_close(conn);
}

int main(int argc, char* argv[])
{
    progname=argv[0];
    if( argc>1 )
    {
	key=atoi(argv[1]);
	if( key>4 ){ Usage(progname); return 0;}
	if( key<0 ){ Usage(progname); return 0;}
    }
    else
    {
	Usage(progname);
    }

    //for print DEBUG information
    bool verbose=0;

    //***************preselections*************
    int ntrk=4;
    int max_munhits=2;
    float min_p=100.; //MeV
    float max_p=2000.; //MeV
    float min_Mbc=1700.;
    float max_Mbc=1900.;
    float min_dE=-300.;
    float max_dE=300.;
    float eclsCut=1000.;
    float min_Mbc2=1800.;
    float max_Mbc2=1900.;

    float rrCut,zCut,max_chi2,min_nhits,max_nhits,tofCut;

    if(key!=4){
	//2016-17
	rrCut=0.75;
	zCut=13.;
	max_chi2=1000.;
	min_nhits=23.;
	max_nhits=1000;
        tofCut=0.80;
        //tofCut=0.70;
        //tofCut=1.0;
    }
    else{
        //2004
	rrCut=0.5;
	zCut=12;
	max_chi2=1000;
	min_nhits=23;
	max_nhits=1000;
	tofCut=0.80;
    }
    //*****************************************

    bool readDB=1;

    bool ftof=1;       //on/off tof indentification
    //===========

    double deCut1, deCut2;
    double mbcCut1, mbcCut2;

    time_t runTime_begin;
    time_t runTime_end;
    double slum;

    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    TString dir_out="results";
    TString fout_result=dir_out + "/" + "fout_result.dat";
    TString fout_result_atc;
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    TString out_pref = "KemcAllowedOn_kNoiseReject3_1.0240_KinFit";
    if( key==0 ){
        min_Mbc2=1800.; max_Mbc2=1900.;
	//deCut1=-100; deCut2=100;
	//deCut1=-40; deCut2=20;
	//deCut1=-40; deCut2=40;
	//deCut1=-60; deCut2=40;
	deCut1=-60; deCut2=60;
	mbcCut1=1858, mbcCut2=1873;
	fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data_%d.root",key).Data();
	KEDR = "/home/ovtin/public_html/outDmeson/D0kppp/dataPcorr_" + out_pref + "_ATC/";
        fout_result=dir_out + "/" + "kppp_exp_2016-17_" + out_pref + ".dat";
        fout_result_atc=dir_out + "/" + "kppp_exp_2016-17_" + out_pref + "_ATC.dat";
    }
    else if (key==4)
    {
        min_Mbc2=1800.; max_Mbc2=1900.;
	deCut1=-70; deCut2=70;
	mbcCut1=1855, mbcCut2=1875;
	fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data2004_%d.root",key).Data();
        //KEDR = "/home/ovtin/public_html/outDmeson/Dplus/data2004/";
        KEDR = "/home/ovtin/public_html/outDmeson/D0kppp/data2004Pcorr/";
        list_badruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/badruns";
        fout_result=dir_out + "/" + "kppp_2004.dat";
        fout_result_atc=dir_out + "/" + "kppp_2004_ATC.dat";
    }
    else if (key==1)
    {
	min_Mbc2=1800;
	deCut1=-100; deCut2=100;
	mbcCut1=1855, mbcCut2=1875;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_sig_%d.root",key).Data();
        out_pref = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_KinFit_v2";
	KEDR = "/home/ovtin/public_html/outDmeson/D0kppp/simulation_Sig_" + out_pref + "_ATC/";
        fout_result=dir_out + "/" + "kppp_signal_" + out_pref + ".dat";
        fout_result_atc=dir_out + "/" + "kppp_signal_" + out_pref + "_ATC.dat";
    }
    else if (key==2)
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_BG_continium.root",key).Data();
        out_pref = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0";
	KEDR = "/home/ovtin/public_html/outDmeson/D0kppp/simulation_Bkg_continium_" + out_pref + "_ATC/";
        fout_result=dir_out + "/" + "kppp_uds_" + out_pref + ".dat";
        fout_result_atc=dir_out + "/" + "kppp_uds_" + out_pref + "_ATC.dat";
    }
    else if (key==3)
    {
	//deCut1=-300; deCut2=300;
	//mbcCut1=1700, mbcCut2=1900;
	deCut1=-60; deCut2=60;
	mbcCut1=1858, mbcCut2=1873;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_BG_eetoDD_%d.root",key).Data();
        out_pref = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_test";
	KEDR = "/home/ovtin/public_html/outDmeson/D0kppp/simulation_Bkg_eetodd_" + out_pref + "_ATC/";
        fout_result=dir_out + "/" + "kppp_dbck_" + out_pref + ".dat";
        fout_result_atc=dir_out + "/" + "kpp_dbck_" + out_pref + "_ATC.dat";
    }

    gSystem->Exec("mkdir " + KEDR);
    gSystem->Exec("cp /store/users/ovtin/outDmeson/demo/index.php " + KEDR);

    cout<<fnameout<<endl;
    fout = new TFile(fnameout,"RECREATE");

    //include samples
    chain();
    Int_t nentr=tt->GetEntries();
    if(verbose) cout<<"Nentries="<<nentr<<endl;

    setbranchstatus();
    setbranchaddress();

    TH1F* henergy=new TH1F("Energy","Energy EMC",100,0.,4500.);
    TH1F* hlkrenergy=new TH1F("E_LKr","Energy LKr",1000,0.,4500.);
    TH1F* hcsienergy=new TH1F("E_CsI","Energy CsI",1000,0.,4500.);
    TH1F* hncls=new TH1F("ncls","emc.ncls",20,-0.5,19.5);
    TH1F* hnlkr=new TH1F("nlkr","emc.nlkr",20,-0.5,19.5);
    TH1F* hncsi=new TH1F("ncsi","emc.ncsi",20,-0.5,19.5);
    TH1F* hep=new TH1F("E/p","E/p",100,-0.5,3.5);

    TH1F* hrr=new TH1F("rr","rr",50,0.,3.);
    TH1F* hZip=new TH1F("ZIP","ZIP",100,-50.,50.);
    TH1F* henass=new TH1F("Energy_ass","Energy ass",100,0.,4500.);

    TH1F* hDncomb=new TH1F("Dmseon.ncomb","Dmseon.ncomb",150,-0.5,149.5);

    TH1F *hTime;
    TH1F *hRunSigMbcCut;
    TH1F *hRunSigdECut;
    TH2D* hLum;

    TH1F *hRun;
    if( key!=4 )
    {
        hRun = new TH1F("Run","Run", 3042, 23206., 26248.);
	hTime = new TH1F("Time","Time", 3042,1454284800,1514592000);
	hRunSigMbcCut = new TH1F("RunSigMbcCut","RunSigMbcCut", 3042, 23206., 26248.);
	hRunSigdECut = new TH1F("RunSigdECut","RunSigdECut", 3042, 23206., 26248.);
	hLum = new TH2D("Luminosity","Luminosity",3042,1454284800,1514592000,20,0,20);
    }
    else
    {
	hRun = new TH1F("Run","Run", 100, 4100., 4709.);
	hTime = new TH1F("Time","Time", 3042,1072915200,1135900800);
	hRunSigMbcCut = new TH1F("RunSigMbcCut","RunSigMbcCut", 100, 4100., 4709.);
	hRunSigdECut = new TH1F("RunSigdECut","RunSigdECut", 100, 4100., 4709.);
	hLum = new TH2D("Luminosity","Luminosity",3042,1072915200,1135900800,20,0,20);
    }

    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",200,1885.,1889.);
    TH1F* hDBEn=new TH1F("DB Ebeam","DB Ebeam",200,1885.,1889.);

    TH1F* hmbc=new TH1F("M_{bc}","M_{bc}",50,min_Mbc2,max_Mbc2);
    TH1F *hmbc_woKinFit=new TH1F("M_{bc} w/o kinFit","M_{bc} w/o kinFit",50,min_Mbc2,max_Mbc2);
    TH1F *hmbc_ATC=new TH1F("M_{bc} ATC","M_{bc} ATC",50,min_Mbc2,max_Mbc2);

    TH1F* hdE=new TH1F("#Delta E","#Delta E",30,min_dE,max_dE);
    TH1F* hdE_ATC=new TH1F("#Delta E ATC","#Delta E ATC",30,min_dE,max_dE);

    TH1F* hfchi2=new TH1F("MChi2","Minuit Chi2",100,0.,100.);

    TH2D* h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 100,min_Mbc,max_Mbc,200,min_dE,max_dE);
    TH2D *h2MbcdE_ATC=new TH2D("M_{bc}:#Delta E ATC", "M_{bc}:#Delta E ATC", 100,min_Mbc,max_Mbc,100,min_dE,max_dE);

    TH1F* htimetof=new TH1F("TOF time","TOF time",140,-40.,100.);
    TH1F* hbeta=new TH1F("beta","beta",50,0.,4.);
    TH1F* hlength=new TH1F("length","length",160,0.,160.);
    TH2D *h2betaP=new TH2D("P:1/#beta", "P:1/#beta", 1000,0,1000,100,0,3.0);

    TH1D *hdtof1_K=new TH1D("dtof1_K", "dtof1_K",100,-10.,10);
    TH1D *hdtof1_pi=new TH1D("dtof1_pi", "dtof1_pi",100,-10.,10);
    TH1D *hdtof4_K=new TH1D("dtof4_K", "dtof4_K",100,-10.,10);
    TH1D *hdtof2_pi=new TH1D("dtof2_pi", "dtof2_pi",100,-10.,10);
    TH1D *hdtof3_pi=new TH1D("dtof3_pi", "dtof3_pi",100,-10.,10);
    TH1D *hdtof4_pi=new TH1D("dtof4_pi", "dtof4_pi",100,-10.,10);
    TH1D *htimeresk=new TH1D("timeresk", "timeresk",100,0.,6.);

    TH1F* hnclst1=new TH1F("nclst1","nclst1",20,-0.5,19.5);
    TH1F* heclst1=new TH1F("eclst1","eclst1",100,0.,2000.);
    TH1F* htclst1=new TH1F("tclst1","tclst1",130,-30.,100.);
    TH1F* hpclst1=new TH1F("pclst1","pclst1",100,-20.,20.);

    TH1F* hnclst2=new TH1F("nclst2","nclst2",20,-0.5,19.5);
    TH1F* heclst2=new TH1F("eclst2","eclst2",100,0.,2000.);
    TH1F* htclst2=new TH1F("tclst2","tclst2",130,-30.,100.);
    TH1F* hpclst2=new TH1F("pclst2","pclst2",100,-20.,20.);

    TH1F* hnclst3=new TH1F("nclst3","nclst3",20,-0.5,19.5);
    TH1F* heclst3=new TH1F("eclst3","eclst3",100,0.,2000.);
    TH1F* htclst3=new TH1F("tclst3","tclst3",130,-30.,100.);
    TH1F* hpclst3=new TH1F("pclst3","pclst3",100,-20.,20.);

    TH1F* hnclst4=new TH1F("nclst4","nclst4",20,-0.5,19.5);
    TH1F* heclst4=new TH1F("eclst4","eclst4",100,0.,2000.);
    TH1F* htclst4=new TH1F("tclst4","tclst4",130,-30.,100.);
    TH1F* hpclst4=new TH1F("pclst4","pclst4",100,-20.,20.);

    TH1F* hnumn=new TH1F("numn","Number of neutral clss",10,-0.5,10.5);
    TH1F* henn=new TH1F("enn","Energy of neutrals cls",100,0.,2500.);
    TH1F* hnumo=new TH1F("numo","Number of others cls",10,-0.5,10.5);
    TH1F* heno=new TH1F("eno","Energy of others cls",100,0.,2500.);

    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",15,-0.5,14.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",12,-0.5,11.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",12,-0.5,11.5);

    TH1F* hmom=new TH1F("P","P",100,0.,3000.);
    TH1F* hmomt=new TH1F("Pt","Pt",100,0.,3000.);
    TH1F* hmomrec=new TH1F("P","P",100,0.,3000.);
    TH1F* hDCnhits=new TH1F("DCnhits","DCnhits",500,0.,500.);
    TH1F* hVDnhits=new TH1F("VDnhits","VDnhits",100,0.,100.);
    TH1F* htchi2=new TH1F("tchi2","tchi2",100,0.,100.);

    TH1F* htnhits=new TH1F("tnhits","tnhits",80,0.,80.);
    TH1F* htnhitsvd=new TH1F("tnhitsvd","tnhitsvd",8,-0.5,7.5);
    TH1F* htnhitsxy=new TH1F("tnhitsxy","tnhitsxy",50,0.,50.);
    TH1F* htnhitsz=new TH1F("tnhitsz","tnhitsz",50,0.,50.);

    TH1F* htnvec=new TH1F("tnvec","tnvec",30,0.,30.);
    TH1F* htnvecxy=new TH1F("tnvecxy","tnvecxy",30,0.,30.);
    TH1F* htnvecz=new TH1F("tnvecz","tnvecz",30,0.,30.);

    TH1F* htheta=new TH1F("theta","t.theta",185,0.,185.);
    TH1F* hphi=new TH1F("phi","t.phi",180,0.,360.);

    TH1F* hMUnhits=new TH1F("munhits","mu.nhits",30,-0.5,29.5);
    TH1F* hMUnhits1=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits2=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits3=new TH1F("munhits","mu.nhits",15,-0.5,15.5);

    TH1F* hATCcnt=new TH1F("CNT","CNT ATC",160,0.0,159.0);
    TH1F* hATCnpe=new TH1F("Nph.e.","Nph.e. ATC",100,0.0,30.0);
    TProfile* pr1=new TProfile("#K","#K npe/Momentum",60,0,1200,0,50);
    TProfile* pr2=new TProfile("#pi","#pi npe/Momentum",60,0,1200,0,50);

    TH1F* hdedx=new TH1F("dedx","dedx",150,0.0,1500.0);
    TH1F* hprob=new TH1F("prob","prob",100,0.0,1.0);
    TH1F* hresd=new TH1F("resd","resd",150,0.0,1500.0);

    TTree *forFit = new TTree("forFit","forFit");
    Float_t forFitMbc, forFitdE, forFitdP;
    forFit->Branch("Mbc",&forFitMbc,"Mbc/F");
    forFit->Branch("dE",&forFitdE,"dE/F");

    ofstream Result(TString::Format(fout_result),ios_base::out);
    ofstream ResultATC(TString::Format(fout_result_atc),ios_base::out);

    std::vector<int> badruns;
    string line;
    int run=0;
    ifstream in(list_badruns);
    if (in.is_open())
    {
	while (getline(in, line))
	{
	    run = atoi(line.c_str());
	    badruns.push_back(run);
	}
    }
    in.close();

    int runprev=0;

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

        if ( *find(badruns.begin(), badruns.end(), Dmeson.Run) ) continue;        //skip bad runs
	//if ( *std::find(badruns.begin(), badruns.end(), Dmeson.Run) ) { cout<<"bad run="<<Dmeson.Run<<endl;};        //skip bad runs

	if( (k %100000)==0 )cout<<k<<endl;

	if(k>0)
	{
	    tt->GetEntry(k-1);
	    runprev=Dmeson.Run;
	    //cout<<"Dmeson.run="<<Dmeson.Run<<endl;
	}

	tt->GetEntry(k);

	if( readDB && runprev!=Dmeson.Run)
	{
	    KDBconn* conn = kdb_open();

	    if (!conn) {
		printf("Can not connect to database\n");
	    }

	    runTime_begin=kdb_run_get_begin_time(conn, Dmeson.Run);
	    runTime_end=kdb_run_get_end_time(conn, Dmeson.Run);
	    if(verbose==1)
	    {
		cout<<"||||||||||||||||||||||||=======  Next RUN ========|||||||||||||||||||||||||||||||||"<<endl;
		cout<<"Begin time of Run"<<Dmeson.Run<<": "<<timestamp(runTime_begin)<<endl;
		cout<<"End time of Run"<<Dmeson.Run<<": "<<timestamp(runTime_end)<<endl;
	    }
            //static const int lum_table_id=2007, lum_table_length=24;
	    static const int e_table_id=2119, e_table_length=16;

	    float beam_energy=0;
            int bufenergy[e_table_length];
	    if( kdb_read_for_run(conn,e_table_id,Dmeson.Run,bufenergy,e_table_length) ) {
		beam_energy=bufenergy[1]*1E-6;
	    }
	    kdb_close(conn);

            hDBEn->Fill(beam_energy);
	    if(verbose==1) cout<<"DB beam energy is "<<beam_energy<<endl;

	    double en=0, en_err=0, lum=0;
	    int t;
            get_run_lumi(Dmeson.Run, &en, &en_err, &lum, &t);
	    if(verbose==1) cout<<"Lum="<<lum*0.001<<"\t"<<"slum="<<slum<<endl;
            if( lum*0.001>0. && lum*0.001<100. ) slum += lum*0.001; //nb^-1
	    hLum->Fill(runTime_begin,lum*0.001);
	}

	if(
	   Dmeson.vrtntrk>=ntrk
           && Dmeson.de>=min_dE && Dmeson.de<=max_dE
           && Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc
           //&& Dmeson.prec1>450 && Dmeson.prec2>450 && Dmeson.prec3>450 && Dmeson.prec4>450
	   //&& Dmeson.p1>min_p && Dmeson.p1<max_p && Dmeson.p2>min_p && Dmeson.p2<max_p && Dmeson.p3>min_p && Dmeson.p3<max_p && Dmeson.p4>min_p && Dmeson.p4<max_p
	   && Dmeson.chi2t1<max_chi2 && Dmeson.chi2t2<max_chi2 && Dmeson.chi2t3<max_chi2 && Dmeson.chi2t4<max_chi2
	   && Dmeson.nhitst1>min_nhits && Dmeson.nhitst2>min_nhits && Dmeson.nhitst3>min_nhits && Dmeson.nhitst4>min_nhits
	   && Dmeson.nhitst1<=max_nhits && Dmeson.nhitst2<=max_nhits && Dmeson.nhitst3<=max_nhits && Dmeson.nhitst4<=max_nhits
	   && Dmeson.rr1<rrCut && Dmeson.rr2<rrCut && Dmeson.rr3<rrCut && Dmeson.rr4<rrCut
	   && fabs(Dmeson.zip1)<zCut && fabs(Dmeson.zip2)<zCut && fabs(Dmeson.zip3)<zCut && fabs(Dmeson.zip4)<zCut
           && Dmeson.ecls1<eclsCut && Dmeson.ecls2<eclsCut && Dmeson.ecls3<eclsCut && Dmeson.ecls4<eclsCut
	   && (Dmeson.mulayerhits2+Dmeson.mulayerhits3)<=max_munhits
	   //&& (Dmeson.mulayerhits1)<=0
           /*
	   && (Dmeson.Run<=23403 || Dmeson.Run>=23430)
	   && (Dmeson.Run<=23743 || Dmeson.Run>=23838)
	   && (Dmeson.Run<=24621 || Dmeson.Run>=24647)
	   && (Dmeson.Run<=25016 || Dmeson.Run>=25044)
	   */
           /*
           && (Dmeson.Run!=23307 && Dmeson.Run!=23313 && Dmeson.Run!=23342 && Dmeson.Run!=23353 && Dmeson.Run!=23423
               && Dmeson.Run!=23429 && Dmeson.Run!=23466 && Dmeson.Run!=23467 && Dmeson.Run!=23470 && Dmeson.Run!=23562
               && Dmeson.Run!=23564 && Dmeson.Run!=23626 && Dmeson.Run!=23632 && Dmeson.Run!=23635 && Dmeson.Run!=23636
               && Dmeson.Run!=23642 && Dmeson.Run!=23643 && Dmeson.Run!=23656 && Dmeson.Run!=23658 && Dmeson.Run!=23663
               && Dmeson.Run!=23665 && Dmeson.Run!=23666 && Dmeson.Run!=23667 && Dmeson.Run!=23668 && Dmeson.Run!=23669
               && Dmeson.Run!=23674 && Dmeson.Run!=23675 && Dmeson.Run!=23677 && Dmeson.Run!=23678 && Dmeson.Run!=23679
               && Dmeson.Run!=23688 && Dmeson.Run!=23689 && Dmeson.Run!=23691 && Dmeson.Run!=23693 && Dmeson.Run!=23694
               && Dmeson.Run!=23695 && Dmeson.Run!=23696 && Dmeson.Run!=23702 && Dmeson.Run!=23703 && Dmeson.Run!=23704
               && Dmeson.Run!=23706 && Dmeson.Run!=23707 && Dmeson.Run!=23708 && Dmeson.Run!=23709 && Dmeson.Run!=23710
               && Dmeson.Run!=23712 && Dmeson.Run!=23713 && Dmeson.Run!=23714 && Dmeson.Run!=23721 && Dmeson.Run!=23722
               && Dmeson.Run!=23723 && Dmeson.Run!=23724 && Dmeson.Run!=23725 && Dmeson.Run!=23727 && Dmeson.Run!=23746
               && Dmeson.Run!=23747 && Dmeson.Run!=23748 && Dmeson.Run!=23749 && Dmeson.Run!=23755 && Dmeson.Run!=23756
               && Dmeson.Run!=23757 && Dmeson.Run!=23759 && Dmeson.Run!=23809 && Dmeson.Run!=23811 && Dmeson.Run!=23812
               && Dmeson.Run!=23813 && Dmeson.Run!=23814 && Dmeson.Run!=23815 && Dmeson.Run!=23817 && Dmeson.Run!=23819
               && Dmeson.Run!=23820 && Dmeson.Run!=23822 && Dmeson.Run!=23823 && Dmeson.Run!=23824 && Dmeson.Run!=23825
               && Dmeson.Run!=23826 && Dmeson.Run!=23828 && Dmeson.Run!=23829 && Dmeson.Run!=23830 && Dmeson.Run!=23831
               && Dmeson.Run!=23833 && Dmeson.Run!=23834 && Dmeson.Run!=23835 && Dmeson.Run!=23836 && Dmeson.Run!=23838
               && Dmeson.Run!=23858 && Dmeson.Run!=23859 && Dmeson.Run!=23860 && Dmeson.Run!=23861 && Dmeson.Run!=23867
               && Dmeson.Run!=23868 && Dmeson.Run!=23869 && Dmeson.Run!=23872 && Dmeson.Run!=23876 && Dmeson.Run!=23877
               && Dmeson.Run!=23881 && Dmeson.Run!=23882 && Dmeson.Run!=23893 && Dmeson.Run!=23895 && Dmeson.Run!=23898
               && Dmeson.Run!=23900 && Dmeson.Run!=23904 && Dmeson.Run!=23917 && Dmeson.Run!=23937 && Dmeson.Run!=23940
               && Dmeson.Run!=24814 && Dmeson.Run!=24819 && Dmeson.Run!=24821 && Dmeson.Run!=24822 && Dmeson.Run!=24831
               && Dmeson.Run!=24844 && Dmeson.Run!=24845 && Dmeson.Run!=24851 && Dmeson.Run!=24859 && Dmeson.Run!=24866
               && Dmeson.Run!=24867 && Dmeson.Run!=24870 && Dmeson.Run!=24876 && Dmeson.Run!=24893 && Dmeson.Run!=24904
               && Dmeson.Run!=24915 && Dmeson.Run!=24916 && Dmeson.Run!=25064 && Dmeson.Run!=25074 && Dmeson.Run!=25079
               && Dmeson.Run!=25105 && Dmeson.Run!=25158 && Dmeson.Run!=25159 && Dmeson.Run!=25173 && Dmeson.Run!=25176
               && Dmeson.Run!=25177 && Dmeson.Run!=25179 && Dmeson.Run!=25182 && Dmeson.Run!=25183 && Dmeson.Run!=25184
               && Dmeson.Run!=25198 && Dmeson.Run!=25200 && Dmeson.Run!=25209 && Dmeson.Run!=25210 && Dmeson.Run!=25211
               && Dmeson.Run!=25212 && Dmeson.Run!=25214 && Dmeson.Run!=25219 && Dmeson.Run!=25222 && Dmeson.Run!=25223
               && Dmeson.Run!=25225 && Dmeson.Run!=25226 && Dmeson.Run!=25227 && Dmeson.Run!=25228 && Dmeson.Run!=25230
               && Dmeson.Run!=25236 && Dmeson.Run!=25347 && Dmeson.Run!=25349 && Dmeson.Run!=25351 && Dmeson.Run!=25358
               && Dmeson.Run!=25359 && Dmeson.Run!=25371 && Dmeson.Run!=25403 && Dmeson.Run!=25404 && Dmeson.Run!=25405
               && Dmeson.Run!=25407 && Dmeson.Run!=25409 && Dmeson.Run!=25410 && Dmeson.Run!=25411 && Dmeson.Run!=25413
               && Dmeson.Run!=25414 && Dmeson.Run!=25415 && Dmeson.Run!=25421 && Dmeson.Run!=25423 && Dmeson.Run!=25425
               && Dmeson.Run!=25433 && Dmeson.Run!=25435 && Dmeson.Run!=25444 && Dmeson.Run!=25514 && Dmeson.Run!=25515
               && Dmeson.Run!=25519 && Dmeson.Run!=25520 && Dmeson.Run!=25523 && Dmeson.Run!=25524 && Dmeson.Run!=25569
               && Dmeson.Run!=25599 && Dmeson.Run!=25605 && Dmeson.Run!=25622 && Dmeson.Run!=25628 && Dmeson.Run!=25637
               && Dmeson.Run!=25684 && Dmeson.Run!=26058 && Dmeson.Run!=26059 && Dmeson.Run!=26062 && Dmeson.Run!=26063
               && Dmeson.Run!=26064 && Dmeson.Run!=26065 && Dmeson.Run!=26072 && Dmeson.Run!=26073 && Dmeson.Run!=26074
               && Dmeson.Run!=26075 && Dmeson.Run!=26077 && Dmeson.Run!=26078 && Dmeson.Run!=26079 && Dmeson.Run!=26091
               && Dmeson.Run!=26093 && Dmeson.Run!=26094 && Dmeson.Run!=26095 && Dmeson.Run!=26096 && Dmeson.Run!=26098
               && Dmeson.Run!=26100 && Dmeson.Run!=26101 && Dmeson.Run!=26126 && Dmeson.Run!=26127 && Dmeson.Run!=26128
               && Dmeson.Run!=26129 && Dmeson.Run!=26131 && Dmeson.Run!=26132 && Dmeson.Run!=26133 && Dmeson.Run!=26134
               && Dmeson.Run!=26147 && Dmeson.Run!=26148 && Dmeson.Run!=26150 && Dmeson.Run!=26151
              )   //noise <8%
              */
              /*
              && (Dmeson.Run==23307 || Dmeson.Run==23313 || Dmeson.Run==23342 || Dmeson.Run==23353 || Dmeson.Run==23423
               || Dmeson.Run==23429 || Dmeson.Run==23466 || Dmeson.Run==23467 || Dmeson.Run==23470 || Dmeson.Run==23562
               || Dmeson.Run==23564 || Dmeson.Run==23626 || Dmeson.Run==23632 || Dmeson.Run==23635 || Dmeson.Run==23636
               || Dmeson.Run==23642 || Dmeson.Run==23643 || Dmeson.Run==23656 || Dmeson.Run==23658 || Dmeson.Run==23663
               || Dmeson.Run==23665 || Dmeson.Run==23666 || Dmeson.Run==23667 || Dmeson.Run==23668 || Dmeson.Run==23669
               || Dmeson.Run==23674 || Dmeson.Run==23675 || Dmeson.Run==23677 || Dmeson.Run==23678 || Dmeson.Run==23679
               || Dmeson.Run==23688 || Dmeson.Run==23689 || Dmeson.Run==23691 || Dmeson.Run==23693 || Dmeson.Run==23694
               || Dmeson.Run==23695 || Dmeson.Run==23696 || Dmeson.Run==23702 || Dmeson.Run==23703 || Dmeson.Run==23704
               || Dmeson.Run==23706 || Dmeson.Run==23707 || Dmeson.Run==23708 || Dmeson.Run==23709 || Dmeson.Run==23710
               || Dmeson.Run==23712 || Dmeson.Run==23713 || Dmeson.Run==23714 || Dmeson.Run==23721 || Dmeson.Run==23722
               || Dmeson.Run==23723 || Dmeson.Run==23724 || Dmeson.Run==23725 || Dmeson.Run==23727 || Dmeson.Run==23746
               || Dmeson.Run==23747 || Dmeson.Run==23748 || Dmeson.Run==23749 || Dmeson.Run==23755 || Dmeson.Run==23756
               || Dmeson.Run==23757 || Dmeson.Run==23759 || Dmeson.Run==23809 || Dmeson.Run==23811 || Dmeson.Run==23812
               || Dmeson.Run==23813 || Dmeson.Run==23814 || Dmeson.Run==23815 || Dmeson.Run==23817 || Dmeson.Run==23819
               || Dmeson.Run==23820 || Dmeson.Run==23822 || Dmeson.Run==23823 || Dmeson.Run==23824 || Dmeson.Run==23825
               || Dmeson.Run==23826 || Dmeson.Run==23828 || Dmeson.Run==23829 || Dmeson.Run==23830 || Dmeson.Run==23831
               || Dmeson.Run==23833 || Dmeson.Run==23834 || Dmeson.Run==23835 || Dmeson.Run==23836 || Dmeson.Run==23838
               || Dmeson.Run==23858 || Dmeson.Run==23859 || Dmeson.Run==23860 || Dmeson.Run==23861 || Dmeson.Run==23867
               || Dmeson.Run==23868 || Dmeson.Run==23869 || Dmeson.Run==23872 || Dmeson.Run==23876 || Dmeson.Run==23877
               || Dmeson.Run==23881 || Dmeson.Run==23882 || Dmeson.Run==23893 || Dmeson.Run==23895 || Dmeson.Run==23898
               || Dmeson.Run==23900 || Dmeson.Run==23904 || Dmeson.Run==23917 || Dmeson.Run==23937 || Dmeson.Run==23940
               || Dmeson.Run==24814 || Dmeson.Run==24819 || Dmeson.Run==24821 || Dmeson.Run==24822 || Dmeson.Run==24831
               || Dmeson.Run==24844 || Dmeson.Run==24845 || Dmeson.Run==24851 || Dmeson.Run==24859 || Dmeson.Run==24866
               || Dmeson.Run==24867 || Dmeson.Run==24870 || Dmeson.Run==24876 || Dmeson.Run==24893 || Dmeson.Run==24904
               || Dmeson.Run==24915 || Dmeson.Run==24916 || Dmeson.Run==25064 || Dmeson.Run==25074 || Dmeson.Run==25079
               || Dmeson.Run==25105 || Dmeson.Run==25158 || Dmeson.Run==25159 || Dmeson.Run==25173 || Dmeson.Run==25176
               || Dmeson.Run==25177 || Dmeson.Run==25179 || Dmeson.Run==25182 || Dmeson.Run==25183 || Dmeson.Run==25184
               || Dmeson.Run==25198 || Dmeson.Run==25200 || Dmeson.Run==25209 || Dmeson.Run==25210 || Dmeson.Run==25211
               || Dmeson.Run==25212 || Dmeson.Run==25214 || Dmeson.Run==25219 || Dmeson.Run==25222 || Dmeson.Run==25223
               || Dmeson.Run==25225 || Dmeson.Run==25226 || Dmeson.Run==25227 || Dmeson.Run==25228 || Dmeson.Run==25230
               || Dmeson.Run==25236 || Dmeson.Run==25347 || Dmeson.Run==25349 || Dmeson.Run==25351 || Dmeson.Run==25358
               || Dmeson.Run==25359 || Dmeson.Run==25371 || Dmeson.Run==25403 || Dmeson.Run==25404 || Dmeson.Run==25405
               || Dmeson.Run==25407 || Dmeson.Run==25409 || Dmeson.Run==25410 || Dmeson.Run==25411 || Dmeson.Run==25413
               || Dmeson.Run==25414 || Dmeson.Run==25415 || Dmeson.Run==25421 || Dmeson.Run==25423 || Dmeson.Run==25425
               || Dmeson.Run==25433 || Dmeson.Run==25435 || Dmeson.Run==25444 || Dmeson.Run==25514 || Dmeson.Run==25515
               || Dmeson.Run==25519 || Dmeson.Run==25520 || Dmeson.Run==25523 || Dmeson.Run==25524 || Dmeson.Run==25569
               || Dmeson.Run==25599 || Dmeson.Run==25605 || Dmeson.Run==25622 || Dmeson.Run==25628 || Dmeson.Run==25637
               || Dmeson.Run==25684 || Dmeson.Run==26058 || Dmeson.Run==26059 || Dmeson.Run==26062 || Dmeson.Run==26063
               || Dmeson.Run==26064 || Dmeson.Run==26065 || Dmeson.Run==26072 || Dmeson.Run==26073 || Dmeson.Run==26074
               || Dmeson.Run==26075 || Dmeson.Run==26077 || Dmeson.Run==26078 || Dmeson.Run==26079 || Dmeson.Run==26091
               || Dmeson.Run==26093 || Dmeson.Run==26094 || Dmeson.Run==26095 || Dmeson.Run==26096 || Dmeson.Run==26098
               || Dmeson.Run==26100 || Dmeson.Run==26101 || Dmeson.Run==26126 || Dmeson.Run==26127 || Dmeson.Run==26128
               || Dmeson.Run==26129 || Dmeson.Run==26131 || Dmeson.Run==26132 || Dmeson.Run==26133 || Dmeson.Run==26134
               || Dmeson.Run==26147 || Dmeson.Run==26148 || Dmeson.Run==26150 || Dmeson.Run==26151
               )   //noise >=8%
               */
	  )
	{
	    hDncomb->Fill(Dmeson.ncomb);
	    hRun->Fill(Dmeson.Run);
            hTime->Fill(runTime_begin);
	    hEbeam->Fill(Dmeson.Ebeam);

	    if(verbose) cout<<"<<<<<<<<<<<<<<<<<<<<<<<<<<< Next event >>>>>>>>>>>>>>>>>>>>>>>>>>>>"<<endl;
	    if(verbose) cout<<"run="<<Dmeson.Run<<"\t"<<"event="<<Dmeson.rEv<<endl;
	    if(verbose) cout<<"Dmeson.ncomb="<<Dmeson.ncomb<<"\t"<<endl;

	    htimetof->Fill(Dmeson.timet1);
	    hbeta->Fill(Dmeson.betat1);
	    hlength->Fill(Dmeson.lengtht1);

	    htimetof->Fill(Dmeson.timet2);
	    hbeta->Fill(Dmeson.betat2);
	    hlength->Fill(Dmeson.lengtht2);

	    htimetof->Fill(Dmeson.timet3);
	    hbeta->Fill(Dmeson.betat3);
	    hlength->Fill(Dmeson.lengtht3);

	    htimetof->Fill(Dmeson.timet4);
	    hbeta->Fill(Dmeson.betat4);
	    hlength->Fill(Dmeson.lengtht4);

	    if ( verbose )
	    {
		cout<<"p1="<<Dmeson.p1<<"\t"<<"p2="<<Dmeson.p2<<"\t"<<"p3="<<Dmeson.p3<<endl;
		cout<<"e1/p1="<<Dmeson.e1/Dmeson.p1<<"\t"<<"e2/p2="<<Dmeson.e2/Dmeson.p2<<"\t"<<"e3/p3="<<Dmeson.e3/Dmeson.p3<<endl;
		cout<<"rr1="<<Dmeson.rr1<<"\t"<<"rr2="<<Dmeson.rr2<<"\t"<<"rr3="<<Dmeson.rr3<<"\t"<<endl;
		cout<<"zip1="<<Dmeson.zip1<<"\t"<<"zip2="<<Dmeson.zip2<<"\t"<<"zip3="<<Dmeson.zip3<<"\t"<<endl;
	    }

	    hvrtntrk->Fill(Dmeson.vrtntrk);
	    hvrtnip->Fill(Dmeson.vrtnip);
	    hvrtnbeam->Fill(Dmeson.vrtnbeam);

	    htnhits->Fill(Dmeson.nhitst1);
	    htnhits->Fill(Dmeson.nhitst2);
	    htnhits->Fill(Dmeson.nhitst3);
	    htnhits->Fill(Dmeson.nhitst4);

	    htnhitsvd->Fill(Dmeson.nhitsvdt1);
	    htnhitsvd->Fill(Dmeson.nhitsvdt2);
	    htnhitsvd->Fill(Dmeson.nhitsvdt3);
	    htnhitsvd->Fill(Dmeson.nhitsvdt4);

	    htnhitsxy->Fill(Dmeson.nhitsxyt1);
	    htnhitsxy->Fill(Dmeson.nhitsxyt2);
	    htnhitsxy->Fill(Dmeson.nhitsxyt3);
	    htnhitsxy->Fill(Dmeson.nhitsxyt4);

	    htnhitsz->Fill(Dmeson.nhitszt1);
	    htnhitsz->Fill(Dmeson.nhitszt2);
	    htnhitsz->Fill(Dmeson.nhitszt3);
	    htnhitsz->Fill(Dmeson.nhitszt4);

	    hmom->Fill(Dmeson.p1);
	    hmom->Fill(Dmeson.p2);
	    hmom->Fill(Dmeson.p3);
	    hmom->Fill(Dmeson.p4);

	    hmomt->Fill(Dmeson.pt1);
	    hmomt->Fill(Dmeson.pt2);
	    hmomt->Fill(Dmeson.pt3);
	    hmomt->Fill(Dmeson.pt4);

	    hmomrec->Fill(Dmeson.prec1);
	    hmomrec->Fill(Dmeson.prec2);
	    hmomrec->Fill(Dmeson.prec3);
	    hmomrec->Fill(Dmeson.prec4);

	    htheta->Fill(Dmeson.thetat1);
	    htheta->Fill(Dmeson.thetat2);
	    htheta->Fill(Dmeson.thetat3);
	    htheta->Fill(Dmeson.thetat4);

	    hphi->Fill(Dmeson.phit1);
	    hphi->Fill(Dmeson.phit2);
	    hphi->Fill(Dmeson.phit3);
	    hphi->Fill(Dmeson.phit4);

	    htchi2->Fill(Dmeson.chi2t1);
	    htchi2->Fill(Dmeson.chi2t2);
	    htchi2->Fill(Dmeson.chi2t3);
	    htchi2->Fill(Dmeson.chi2t4);

	    htnvec->Fill(Dmeson.nvect1);
	    htnvec->Fill(Dmeson.nvect2);
	    htnvec->Fill(Dmeson.nvect3);
	    htnvec->Fill(Dmeson.nvect4);

	    htnvecxy->Fill(Dmeson.nvecxyt1);
	    htnvecxy->Fill(Dmeson.nvecxyt2);
	    htnvecxy->Fill(Dmeson.nvecxyt3);
	    htnvecxy->Fill(Dmeson.nvecxyt4);

	    htnvecz->Fill(Dmeson.nveczt1);
	    htnvecz->Fill(Dmeson.nveczt2);
	    htnvecz->Fill(Dmeson.nveczt3);
	    htnvecz->Fill(Dmeson.nveczt4);

	    hnclst1->Fill(Dmeson.ncls1);
	    heclst1->Fill(Dmeson.ecls1);
	    htclst1->Fill(Dmeson.tcls1);
	    hpclst1->Fill(Dmeson.pcls1);

	    hnclst2->Fill(Dmeson.ncls2);
	    heclst2->Fill(Dmeson.ecls2);
	    htclst2->Fill(Dmeson.tcls2);
	    hpclst2->Fill(Dmeson.pcls2);

	    hnclst3->Fill(Dmeson.ncls3);
	    heclst3->Fill(Dmeson.ecls3);
	    htclst3->Fill(Dmeson.tcls3);
	    hpclst3->Fill(Dmeson.pcls3);

	    hnclst4->Fill(Dmeson.ncls4);
	    heclst4->Fill(Dmeson.ecls4);
	    htclst4->Fill(Dmeson.tcls4);
	    hpclst4->Fill(Dmeson.pcls4);

	    hncls->Fill(Dmeson.ncls);
	    hnlkr->Fill(Dmeson.nlkr);
	    hncsi->Fill(Dmeson.ncsi);
	    henergy->Fill(Dmeson.emcenergy);
	    hlkrenergy->Fill(Dmeson.lkrenergy);
	    hcsienergy->Fill(Dmeson.csienergy);
            /*
            hnumn->Fill(Dmeson.numn);
	    henn->Fill(Dmeson.enn);
	    hnumo->Fill(Dmeson.numo);
	    heno->Fill(Dmeson.eno);
            */
	    hep->Fill(Dmeson.e1/Dmeson.p1);
	    hep->Fill(Dmeson.e2/Dmeson.p2);
	    hep->Fill(Dmeson.e3/Dmeson.p3);
	    hep->Fill(Dmeson.e4/Dmeson.p4);
	    henass->Fill(Dmeson.e1);
	    henass->Fill(Dmeson.e2);
	    henass->Fill(Dmeson.e3);
	    henass->Fill(Dmeson.e4);

	    hrr->Fill(Dmeson.rr1);
	    hrr->Fill(Dmeson.rr2);
	    hrr->Fill(Dmeson.rr3);
	    hrr->Fill(Dmeson.rr4);
	    hZip->Fill(Dmeson.zip1);
	    hZip->Fill(Dmeson.zip2);
	    hZip->Fill(Dmeson.zip3);
	    hZip->Fill(Dmeson.zip4);

            //cout<<"(z0k-z0p1)="<<fabs(Dmeson.zip1-Dmeson.zip2)<<"\t"<<"(z0k-z0p2)="<<fabs(Dmeson.zip1-Dmeson.zip3)<<"\t"<<"z0k="<<fabs(Dmeson.zip1)<<endl;

	    hMUnhits->Fill(Dmeson.munhits);
	    hMUnhits1->Fill(Dmeson.mulayerhits1);
	    hMUnhits2->Fill(Dmeson.mulayerhits2);
	    hMUnhits3->Fill(Dmeson.mulayerhits3);

	    hfchi2->Fill(Dmeson.fchi2);

            //if ( Dmeson.numn>=2 && Dmeson.enn>=120 ) continue;
            //if ( Dmeson.vrtntrk>=4 && Dmeson.numn>=2 ) continue;

            
            hdedx->Fill(Dmeson.dedxt1);
            hdedx->Fill(Dmeson.dedxt2);
            hdedx->Fill(Dmeson.dedxt3);
	    hdedx->Fill(Dmeson.dedxt4);

            if(Dmeson.probKt1>0.) hprob->Fill(Dmeson.probKt1);
            if(Dmeson.probKt2>0.) hprob->Fill(Dmeson.probKt2);
            if(Dmeson.probKt3>0.) hprob->Fill(Dmeson.probKt3);
            if(Dmeson.probKt4>0.) hprob->Fill(Dmeson.probKt4);

            hresd->Fill(Dmeson.resdKt1);
            hresd->Fill(Dmeson.resdKt2);
            hresd->Fill(Dmeson.resdKt3);
            hresd->Fill(Dmeson.resdKt4);

	    //=============== for ATC identification ================================

	    if( verbose==1 ) cout<<"natccrosst1="<<Dmeson.natccrosst1<<endl;
	    int good_region_t1=0;
	    for(int i=0; i<Dmeson.natccrosst1; i++)
	    {
		if( verbose==1 ) cout<<"atcCNTt1="<<Dmeson.atcCNTt1[i]<<"\t"<<"atcNpet1="<<Dmeson.atcNpet1[i]<<endl;
		if( verbose==1 ) cout<<"single_aerogel_REGION0t1="<<Dmeson.single_aerogel_REGION0t1[i]<<endl;
		if( verbose==1 ) cout<<"wlshitt1="<<Dmeson.wlshitt1[i]<<endl;
		hATCcnt->Fill(Dmeson.atcCNTt1[i]);
		//if( Dmeson.single_aerogel_REGION0t1[i]==1 ) good_region_t1++;
                if( Dmeson.wlshitt1[i]!=1 ) good_region_t1++;
	    }
	    if( verbose==1 ) cout<<"atcTotalNpet1="<<Dmeson.atcTotalNpet1<<endl;
            hATCnpe->Fill(Dmeson.atcTotalNpet1);

	    if( verbose==1 ) cout<<"natccrosst2="<<Dmeson.natccrosst2<<endl;
	    int good_region_t2=0;
	    for(int i=0; i<Dmeson.natccrosst2; i++)
	    {
		if( verbose==1 ) cout<<"atcCNTt2="<<Dmeson.atcCNTt2[i]<<"\t"<<"atcNpet2="<<Dmeson.atcNpet2[i]<<endl;
		if( verbose==1 ) cout<<"single_aerogel_REGION0t2="<<Dmeson.single_aerogel_REGION0t2[i]<<endl;
		if( verbose==1 ) cout<<"wlshitt2="<<Dmeson.wlshitt2[i]<<endl;
		hATCcnt->Fill(Dmeson.atcCNTt2[i]);
		//if( Dmeson.single_aerogel_REGION0t2[i]==1 ) good_region_t2++;
                if( Dmeson.wlshitt2[i]!=1 ) good_region_t2++;
	    }
	    if( verbose==1 ) cout<<"atcTotalNpet2="<<Dmeson.atcTotalNpet2<<endl;
            hATCnpe->Fill(Dmeson.atcTotalNpet2);

	    if( verbose==1 ) cout<<"natccrosst3="<<Dmeson.natccrosst3<<endl;
	    int good_region_t3=0;
	    for(int i=0; i<Dmeson.natccrosst3; i++)
	    {
		if( verbose==1 ) cout<<"atcCNTt3="<<Dmeson.atcCNTt3[i]<<"\t"<<"atcNpet3="<<Dmeson.atcNpet3[i]<<endl;
		if( verbose==1 ) cout<<"single_aerogel_REGION0t3="<<Dmeson.single_aerogel_REGION0t3[i]<<endl;
		if( verbose==1 ) cout<<"wlshitt3="<<Dmeson.wlshitt3[i]<<endl;
		hATCcnt->Fill(Dmeson.atcCNTt3[i]);
		//if( Dmeson.single_aerogel_REGION0t3[i]==1 ) good_region_t3++;
                if( Dmeson.wlshitt3[i]!=1 ) good_region_t3++;
	    }
	    if( verbose==1 ) cout<<"atcTotalNpet3="<<Dmeson.atcTotalNpet3<<endl;
            hATCnpe->Fill(Dmeson.atcTotalNpet3);

	    if( verbose==1 ) cout<<"natccrosst4="<<Dmeson.natccrosst4<<endl;
	    int good_region_t4=0;
	    for(int i=0; i<Dmeson.natccrosst4; i++)
	    {
		if( verbose==1 ) cout<<"atcCNTt4="<<Dmeson.atcCNTt4[i]<<"\t"<<"atcNpet4="<<Dmeson.atcNpet4[i]<<endl;
		if( verbose==1 ) cout<<"single_aerogel_REGION0t4="<<Dmeson.single_aerogel_REGION0t4[i]<<endl;
		if( verbose==1 ) cout<<"wlshitt4="<<Dmeson.wlshitt4[i]<<endl;
		hATCcnt->Fill(Dmeson.atcCNTt4[i]);
		//if( Dmeson.single_aerogel_REGION0t4[i]==1 ) good_region_t4++;
                if( Dmeson.wlshitt4[i]!=1 ) good_region_t4++;
	    }
	    if( verbose==1 ) cout<<"atcTotalNpet4="<<Dmeson.atcTotalNpet4<<endl;
            hATCnpe->Fill(Dmeson.atcTotalNpet4);

	    //=========================================================================
            //==================TOF identification=====================================

	    //tof = sqrt(494.*494. + p*p)/p*tlen/30.    time=len/v       beta=v/c    v=beta*c   beta=sqrt(1-(mc^2)^2/E^2)  E^2=(mc^2)^2+(pc)^2

	    if( ftof==1 && fabs(Dmeson.thetat1/180.*PI-PI/2.)>0.9 ) continue;

	    float tof1_K,dtof1_K;

	    //tof1_K=sqrt(494.*494. + Dmeson.p1*Dmeson.p1)/Dmeson.p1*Dmeson.lengtht1/30.;
	    tof1_K=sqrt(494.*494. + Dmeson.prec1*Dmeson.prec1)/Dmeson.prec1*Dmeson.lengtht1/30.;

	    float tofk_corr1_K;
	    tofk_corr1_K = Dmeson.timet1;

	    if (ftof==1 && tofk_corr1_K==0) continue;

	    if (tofk_corr1_K<1.) tofk_corr1_K = tofk_corr1_K+5.5;
	    if (tofk_corr1_K<1.) tofk_corr1_K = tofk_corr1_K+5.5;
	    if (tofk_corr1_K<1.) tofk_corr1_K = tofk_corr1_K+5.5;
	    if (tofk_corr1_K>6.5) tofk_corr1_K = tofk_corr1_K-5.5;
	    if (tofk_corr1_K>6.5) tofk_corr1_K = tofk_corr1_K-5.5;
	    if (tofk_corr1_K>6.5) tofk_corr1_K = tofk_corr1_K-5.5;

	    dtof1_K=(tofk_corr1_K-tof1_K);

	    float tof1_pi,dtof1_pi;

	    //tof1_pi=sqrt(140.*140. + Dmeson.p1*Dmeson.p1)/Dmeson.p1*Dmeson.lengtht1/30.;
	    tof1_pi=sqrt(140.*140. + Dmeson.prec1*Dmeson.prec1)/Dmeson.prec1*Dmeson.lengtht1/30.;

	    float tofk_corr1_pi;
	    tofk_corr1_pi = Dmeson.timet1;

	    //if (ftof==1 && tofk_corr1_pi==0) continue;

	    if (tofk_corr1_pi<1.) tofk_corr1_pi = tofk_corr1_pi+5.5;
	    if (tofk_corr1_pi<1.) tofk_corr1_pi = tofk_corr1_pi+5.5;
	    if (tofk_corr1_pi<1.) tofk_corr1_pi = tofk_corr1_pi+5.5;
	    if (tofk_corr1_pi>6.5) tofk_corr1_pi = tofk_corr1_pi-5.5;
	    if (tofk_corr1_pi>6.5) tofk_corr1_pi = tofk_corr1_pi-5.5;
	    if (tofk_corr1_pi>6.5) tofk_corr1_pi = tofk_corr1_pi-5.5;

	    dtof1_pi=(tofk_corr1_pi-tof1_pi);

	    //if( ftof==1 && fabs(Dmeson.thetat4/180.*PI-PI/2.)>0.9 ) continue;

	    float tof4_K,dtof4_K;

	    //tof4_K=sqrt(494.*494. + Dmeson.p4*Dmeson.p4)/Dmeson.p4*Dmeson.lengtht4/30.;
	    tof4_K=sqrt(494.*494. + Dmeson.prec4*Dmeson.prec4)/Dmeson.prec4*Dmeson.lengtht4/30.;

	    float tofk_corr4_K;
	    tofk_corr4_K = Dmeson.timet4;

	    //if (ftof==1 && tofk_corr4_K==0) continue;

	    if (tofk_corr4_K<1.) tofk_corr4_K = tofk_corr4_K+5.5;
	    if (tofk_corr4_K<1.) tofk_corr4_K = tofk_corr4_K+5.5;
	    if (tofk_corr4_K<1.) tofk_corr4_K = tofk_corr4_K+5.5;
	    if (tofk_corr4_K>6.5) tofk_corr4_K = tofk_corr4_K-5.5;
	    if (tofk_corr4_K>6.5) tofk_corr4_K = tofk_corr4_K-5.5;
	    if (tofk_corr4_K>6.5) tofk_corr4_K = tofk_corr4_K-5.5;

	    dtof4_K=(tofk_corr4_K-tof4_K);


	    float tof2_pi,dtof2_pi;

	    tof2_pi=sqrt(140.*140. + Dmeson.prec2*Dmeson.prec2)/Dmeson.prec2*Dmeson.lengtht2/30.;

	    float tofk_corr2_pi;
	    tofk_corr2_pi = Dmeson.timet2;

	    if (tofk_corr2_pi<1.) tofk_corr2_pi = tofk_corr2_pi+5.5;
	    if (tofk_corr2_pi<1.) tofk_corr2_pi = tofk_corr2_pi+5.5;
	    if (tofk_corr2_pi<1.) tofk_corr2_pi = tofk_corr2_pi+5.5;
	    if (tofk_corr2_pi>6.5) tofk_corr2_pi = tofk_corr2_pi-5.5;
	    if (tofk_corr2_pi>6.5) tofk_corr2_pi = tofk_corr2_pi-5.5;
	    if (tofk_corr2_pi>6.5) tofk_corr2_pi = tofk_corr2_pi-5.5;

	    dtof2_pi=(tofk_corr2_pi-tof2_pi);


	    float tof3_pi,dtof3_pi;

	    tof3_pi=sqrt(140.*140. + Dmeson.prec3*Dmeson.prec3)/Dmeson.prec3*Dmeson.lengtht3/30.;

	    float tofk_corr3_pi;
	    tofk_corr3_pi = Dmeson.timet3;

	    if (tofk_corr3_pi<1.) tofk_corr3_pi = tofk_corr3_pi+5.5;
	    if (tofk_corr3_pi<1.) tofk_corr3_pi = tofk_corr3_pi+5.5;
	    if (tofk_corr3_pi<1.) tofk_corr3_pi = tofk_corr3_pi+5.5;
	    if (tofk_corr3_pi>6.5) tofk_corr3_pi = tofk_corr3_pi-5.5;
	    if (tofk_corr3_pi>6.5) tofk_corr3_pi = tofk_corr3_pi-5.5;
	    if (tofk_corr3_pi>6.5) tofk_corr3_pi = tofk_corr3_pi-5.5;

	    dtof3_pi=(tofk_corr3_pi-tof3_pi);

	    float tof4_pi,dtof4_pi;

	    //tof4_pi=sqrt(140.*140. + Dmeson.p4*Dmeson.p4)/Dmeson.p4*Dmeson.lengtht4/30.;
	    tof4_pi=sqrt(140.*140. + Dmeson.prec4*Dmeson.prec4)/Dmeson.prec4*Dmeson.lengtht4/30.;

	    float tofk_corr4_pi;
	    tofk_corr4_pi = Dmeson.timet4;

	    //if (ftof==1 && tofk_corr4_pi==0) continue;

	    if (tofk_corr4_pi<1.) tofk_corr4_pi = tofk_corr4_pi+5.5;
	    if (tofk_corr4_pi<1.) tofk_corr4_pi = tofk_corr4_pi+5.5;
	    if (tofk_corr4_pi<1.) tofk_corr4_pi = tofk_corr4_pi+5.5;
	    if (tofk_corr4_pi>6.5) tofk_corr4_pi = tofk_corr4_pi-5.5;
	    if (tofk_corr4_pi>6.5) tofk_corr4_pi = tofk_corr4_pi-5.5;
	    if (tofk_corr4_pi>6.5) tofk_corr4_pi = tofk_corr4_pi-5.5;

	    dtof4_pi=(tofk_corr4_pi-tof4_pi);

	    if ( Dmeson.betat1>0 ) h2betaP->Fill(Dmeson.p1, 1/Dmeson.betat1);
	    if ( Dmeson.betat2>0 ) h2betaP->Fill(Dmeson.p2, 1/Dmeson.betat2);
	    if ( Dmeson.betat3>0 ) h2betaP->Fill(Dmeson.p3, 1/Dmeson.betat3);
	    if ( Dmeson.betat4>0 ) h2betaP->Fill(Dmeson.p4, 1/Dmeson.betat4);


            if( ftof==1 && fabs(dtof1_K)>tofCut ) continue;
	    if( ftof==1 && dtof1_K>1000. ) continue;

	    //if( ftof==1 && dtof4_K>-0.5 ) continue;
	    if( ftof==1 && dtof1_pi<0.5 ) continue;
	    if( ftof==1 && fabs(dtof2_pi)>1.0 ) continue;
            if( ftof==1 && fabs(dtof3_pi)>1.0 ) continue;
            if( ftof==1 && fabs(dtof4_pi)>1.0 ) continue;

	    hdtof1_K->Fill(dtof1_K);
	    hdtof1_pi->Fill(dtof1_pi);
	    hdtof4_K->Fill(dtof4_K);
	    hdtof2_pi->Fill(dtof2_pi);
	    hdtof3_pi->Fill(dtof3_pi);
	    hdtof4_pi->Fill(dtof4_pi);

	    if( Dmeson.lengtht1 < 80. && Dmeson.p1>800. ) {
		htimeresk->Fill(tofk_corr1_K/Dmeson.lengtht1*72.);
	    }

            //fill de
	    if( Dmeson.mbc>=mbcCut1 && Dmeson.mbc<=mbcCut2 )
	    {
		hdE->Fill(Dmeson.de);
                hRunSigMbcCut->Fill(Dmeson.Run);
	    }

            //fill mbc
	    if( Dmeson.de>=deCut1 && Dmeson.de<=deCut2 && Dmeson.mbc>=min_Mbc2 && Dmeson.mbc<=max_Mbc )
	    {
		hmbc->Fill(Dmeson.mbc);
		hRunSigdECut->Fill(Dmeson.Run);

		if( Dmeson.mbc>=mbcCut1 && Dmeson.mbc<=mbcCut2 )
		{
		    hDCnhits->Fill(Dmeson.nhitsdc);
		    hVDnhits->Fill(Dmeson.nhitsvd);
		}
	    }

            double px1 = Dmeson.p1*sin(Dmeson.thetat1/180.*PI)*cos(Dmeson.phit1/180.*PI);
	    double py1 = Dmeson.p1*sin(Dmeson.thetat1/180.*PI)*sin(Dmeson.phit1/180.*PI);
	    double pz1 = Dmeson.p1*cos(Dmeson.thetat1/180.*PI);

	    double px2 = Dmeson.p2*sin(Dmeson.thetat2/180.*PI)*cos(Dmeson.phit2/180.*PI);
	    double py2 = Dmeson.p2*sin(Dmeson.thetat2/180.*PI)*sin(Dmeson.phit2/180.*PI);
	    double pz2 = Dmeson.p2*cos(Dmeson.thetat2/180.*PI);

	    double px3 = Dmeson.p3*sin(Dmeson.thetat3/180.*PI)*cos(Dmeson.phit3/180.*PI);
	    double py3 = Dmeson.p3*sin(Dmeson.thetat3/180.*PI)*sin(Dmeson.phit3/180.*PI);
	    double pz3 = Dmeson.p3*cos(Dmeson.thetat3/180.*PI);

	    double px4 = Dmeson.p4*sin(Dmeson.thetat4/180.*PI)*cos(Dmeson.phit4/180.*PI);
	    double py4 = Dmeson.p4*sin(Dmeson.thetat4/180.*PI)*sin(Dmeson.phit4/180.*PI);
	    double pz4 = Dmeson.p4*cos(Dmeson.thetat4/180.*PI);

	    double Mbc_woKinFit = Dmeson.Ebeam*Dmeson.Ebeam - pow(px1+px2+px3+px4,2) - pow(py1+py2+py3+py4,2) - pow(pz1+pz2+pz3+pz4,2);

	    if (Mbc_woKinFit>0) Mbc_woKinFit = sqrt(Mbc_woKinFit); else Mbc_woKinFit = 0;

	    if( Dmeson.de>=deCut1 && Dmeson.de<=deCut2 &&  Mbc_woKinFit>=min_Mbc2 && Mbc_woKinFit<=max_Mbc )
	    {
		hmbc_woKinFit->Fill(Mbc_woKinFit);
	    }

            if( Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		h2MbcdE->Fill(Dmeson.mbc, Dmeson.de);
	    }

	    if( Dmeson.de>=min_dE && Dmeson.de<=max_dE  &&  Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		Result<< Dmeson.mbc <<"\t"<< Dmeson.de <<"\t"<< 0.1000000 <<endl;
	    }

	    if(verbose) cout<<"Dmeson.mbc="<<Dmeson.mbc<<"\t"<<"Dmeson.de="<<Dmeson.de<<"\t"<<endl;


	    //=============== ATC identification ================================
	    double npetrh=0.5;
	    double Pcut1=450.;
	    double Pcut2=1500.;

            //cout<<Dmeson.prec1<<"\t"<<Dmeson.prec2<<"\t"<<Dmeson.prec3<<"\t"<<Dmeson.prec4<<endl;

	    //ATC suppression - if not Kaon
	    if( Dmeson.prec1>Pcut1 && Dmeson.prec1<Pcut2 && good_region_t1>=1 && Dmeson.atcTotalNpet1>npetrh ) continue;

            //if not pions
	    if( Dmeson.prec2>Pcut1 && Dmeson.prec2<Pcut2 && good_region_t2>=1 && Dmeson.atcTotalNpet2<npetrh ) continue;
	    if( Dmeson.prec3>Pcut1 && Dmeson.prec3<Pcut2 && good_region_t3>=1 && Dmeson.atcTotalNpet3<npetrh ) continue;
            if( Dmeson.prec4>Pcut1 && Dmeson.prec4<Pcut2 && good_region_t4>=1 && Dmeson.atcTotalNpet4<npetrh ) continue;

	    pr1->Fill(Dmeson.prec1, Dmeson.atcTotalNpet1);
	    pr2->Fill(Dmeson.prec2, Dmeson.atcTotalNpet2);
	    pr2->Fill(Dmeson.prec3, Dmeson.atcTotalNpet3);
	    pr2->Fill(Dmeson.prec3, Dmeson.atcTotalNpet4);


	    if( Dmeson.de>=min_dE && Dmeson.de<=max_dE  &&  Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		if ( verbose==2 )
		{
		    if (Dmeson.de>=deCut1 && Dmeson.de<=deCut2 &&  Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
		    {
			cout<<Dmeson.Run<<"\t"<<Dmeson.rEv<<"\t"<<Dmeson.mbc<<"\t"<<Dmeson.de<<endl;
		    }
		}
		ResultATC<< Dmeson.mbc <<"\t"<< Dmeson.de <<"\t"<< 0.1000000 <<endl;
	    }

	    //fill dE
	    if( Dmeson.mbc>=mbcCut1 && Dmeson.mbc<=mbcCut2 )
	    {
		hdE_ATC->Fill(Dmeson.de);
	    }

            //fill Mbc
	    if( Dmeson.de>=deCut1 && Dmeson.de<=deCut2 &&  Dmeson.mbc>=min_Mbc2 && Dmeson.mbc<=max_Mbc )
	    {
		hmbc_ATC->Fill(Dmeson.mbc);
	    }

	    if( Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		h2MbcdE_ATC->Fill(Dmeson.mbc, Dmeson.de);
	    }

	    forFitMbc=Dmeson.mbc;
	    forFitdE=Dmeson.de;
	    forFit->Fill();

	    if(verbose==1) cout<<"Dmeson.mbc="<<Dmeson.mbc<<"\t"<<"Dmeson.de="<<Dmeson.de<<"\t"<<endl;
	    //===================================================================


	    //cout<<Dmeson.vrtntrk<<"\t"<<Dmeson.numn<<"\t"<<Dmeson.enn<<endl;

	}
    }
    Result.close();
    ResultATC.close();

    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    gStyle->SetOptFit(1011);
    cc1->cd();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString nameMbc, nameMbc_woKinFit, nameMbc_ATC, nameMbcdE, nameMbcdE_ATC, namedE, namedE_ATC;
    nameMbc = "Mbc";
    nameMbc_woKinFit = "Mbc_woKinFit";
    nameMbc_ATC = "Mbc_ATC";
    nameMbcdE = "MbcdE";
    nameMbcdE_ATC = "MbcdE_ATC";
    namedE = "dE";
    namedE_ATC = "dE_ATC";

    hmbc->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbc->GetYaxis()->SetTitle("Events/2 MeV");
    hmbc->Draw("E1"); cc1->SaveAs(KEDR + nameMbc + format1); cc1->SaveAs(KEDR + nameMbc + format2); cc1->SaveAs(KEDR + nameMbc + format3);

    hmbc_woKinFit->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbc_woKinFit->GetYaxis()->SetTitle("Events/2 MeV");
    hmbc_woKinFit->Draw("E1"); cc1->SaveAs(KEDR + nameMbc_woKinFit + format1); cc1->SaveAs(KEDR + nameMbc_woKinFit + format2); cc1->SaveAs(KEDR + nameMbc_woKinFit + format3);

    hmbc_ATC->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbc_ATC->GetYaxis()->SetTitle("Events/2 MeV");
    hmbc_ATC->Draw("E1"); cc1->SaveAs(KEDR + nameMbc_ATC + format1); cc1->SaveAs(KEDR + nameMbc_ATC + format2); cc1->SaveAs(KEDR + nameMbc_ATC + format3);

    h2MbcdE->GetXaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdE->GetYaxis()->SetTitle("#Delta E (MeV)");
    h2MbcdE->Draw();
    TLine line1(mbcCut1,-300,mbcCut1,300);
    line1.SetLineColor(kGreen);
    line1.SetLineWidth(3);
    TLine line2(mbcCut2,-300,mbcCut2,300);
    line2.SetLineColor(kGreen);
    line2.SetLineWidth(3);
    TLine line3(min_Mbc,deCut1,max_Mbc,deCut1);
    line3.SetLineColor(kGreen);
    line3.SetLineWidth(3);
    TLine line4(min_Mbc,deCut2,max_Mbc,deCut2);
    line4.SetLineColor(kGreen);
    line4.SetLineWidth(3);
    if( key==0 || key==4 ){
	line1.Draw("same");
	line2.Draw("same");
	line3.Draw("same");
	line4.Draw("same");
    }
    cc1->SaveAs(KEDR + nameMbcdE + format1); cc1->SaveAs(KEDR + nameMbcdE + format2);  cc1->SaveAs(KEDR + nameMbcdE + format3);

    h2MbcdE_ATC->GetXaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdE_ATC->GetYaxis()->SetTitle("#Delta E (MeV)");
    h2MbcdE_ATC->Draw();
    TLine line5(mbcCut1,-300,mbcCut1,300);
    line5.SetLineColor(kGreen);
    line5.SetLineWidth(3);
    TLine line6(mbcCut2,-300,mbcCut2,300);
    line6.SetLineColor(kGreen);
    line6.SetLineWidth(3);
    TLine line7(1700,deCut1,1900,deCut1);
    line7.SetLineColor(kGreen);
    line7.SetLineWidth(3);
    TLine line8(1700,deCut2,1900,deCut2);
    line8.SetLineColor(kGreen);
    line8.SetLineWidth(3);
    if( key==0 || key==4 ){
	line5.Draw("same");
	line6.Draw("same");
	line7.Draw("same");
	line8.Draw("same");
    }
    cc1->SaveAs(KEDR + nameMbcdE_ATC + format1); cc1->SaveAs(KEDR + nameMbcdE_ATC + format2); cc1->SaveAs(KEDR + nameMbcdE_ATC + format3);

    hdE->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE->GetYaxis()->SetTitle("Events/20 MeV");
    hdE->Draw("E1"); cc1->SaveAs(KEDR + namedE + format1); cc1->SaveAs(KEDR + namedE + format2); cc1->SaveAs(KEDR + namedE + format3);

    hdE_ATC->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE_ATC->GetYaxis()->SetTitle("Events/20 MeV");
    hdE_ATC->Draw("E1"); cc1->SaveAs(KEDR + namedE_ATC + format1); cc1->SaveAs(KEDR + namedE_ATC + format2); cc1->SaveAs(KEDR + namedE_ATC + format3);

    hDncomb->Draw(); cc1->SaveAs(KEDR + "Dncomb" + format2);

    hnclst1->Draw(); cc1->SaveAs(KEDR + "nclst1" + format2);
    heclst1->GetXaxis()->SetTitle("e1 (MeV)");
    heclst1->Draw(); cc1->SaveAs(KEDR + "eclst1" + format2);
    htclst1->Draw(); cc1->SaveAs(KEDR + "tclst1" + format2);
    hpclst1->Draw(); cc1->SaveAs(KEDR + "pclst1" + format2);

    hnclst2->Draw(); cc1->SaveAs(KEDR + "nclst2" + format2);
    heclst2->GetXaxis()->SetTitle("e2 (MeV)");
    heclst2->Draw(); cc1->SaveAs(KEDR + "eclst2" + format2);
    htclst2->Draw(); cc1->SaveAs(KEDR + "tclst2" + format2);
    hpclst2->Draw(); cc1->SaveAs(KEDR + "pclst2" + format2);

    hnclst3->Draw(); cc1->SaveAs(KEDR + "nclst3" + format2);
    heclst3->Draw(); cc1->SaveAs(KEDR + "eclst3" + format2);
    htclst3->Draw(); cc1->SaveAs(KEDR + "tclst3" + format2);
    hpclst3->Draw(); cc1->SaveAs(KEDR + "pclst3" + format2);

    hnclst4->Draw(); cc1->SaveAs(KEDR + "nclst4" + format2);
    heclst4->Draw(); cc1->SaveAs(KEDR + "eclst4" + format2);
    htclst4->Draw(); cc1->SaveAs(KEDR + "tclst4" + format2);
    hpclst4->Draw(); cc1->SaveAs(KEDR + "pclst4" + format2);

    hnumn->Draw(); cc1->SaveAs(KEDR + "hnumn" + format2);
    henn->Draw(); cc1->SaveAs(KEDR + "henn" + format2);
    hnumo->Draw(); cc1->SaveAs(KEDR + "hnumo" + format2);
    heno->Draw(); cc1->SaveAs(KEDR + "heno" + format2);

    htimetof->Draw(); cc1->SaveAs(KEDR + "time_tof" + format2); cc1->SaveAs(KEDR + "time_tof" + format3);
    hbeta->Draw(); cc1->SaveAs(KEDR + "beta" + format2); cc1->SaveAs(KEDR + "beta" + format3);
    hlength->Draw(); cc1->SaveAs(KEDR + "length" + format2); cc1->SaveAs(KEDR + "length" + format3);

    h2betaP->GetXaxis()->SetTitle("P (MeV/c)");
    h2betaP->GetYaxis()->SetTitle("1/#beta");
    h2betaP->Draw(); cc1->SaveAs(KEDR + "betatoP" + format2); cc1->SaveAs(KEDR + "betatoP" + format3);

    hdtof1_K->GetXaxis()->SetTitle("#DeltaTOF (ns)");
    hdtof1_K->Draw(); cc1->SaveAs(KEDR + "dtof1_K" + format2); cc1->SaveAs(KEDR + "dtof1_K" + format3);

    hdtof1_pi->GetXaxis()->SetTitle("#DeltaTOF (ns)");
    hdtof1_pi->Draw(); cc1->SaveAs(KEDR + "dtof1_pi" + format2); cc1->SaveAs(KEDR + "dtof1_pi" + format3);

    hdtof4_K->GetXaxis()->SetTitle("#DeltaTOF (ns)");
    hdtof4_K->Draw(); cc1->SaveAs(KEDR + "dtof4_K" + format2); cc1->SaveAs(KEDR + "dtof4_K" + format3);

    hdtof2_pi->GetXaxis()->SetTitle("#DeltaTOF (ns)");
    hdtof2_pi->Draw(); cc1->SaveAs(KEDR + "dtof2_pi" + format2); cc1->SaveAs(KEDR + "dtof2_pi" + format3);

    hdtof3_pi->GetXaxis()->SetTitle("#DeltaTOF (ns)");
    hdtof3_pi->Draw(); cc1->SaveAs(KEDR + "dtof3_pi" + format2); cc1->SaveAs(KEDR + "dtof3_pi" + format3);

    hdtof4_pi->GetXaxis()->SetTitle("#DeltaTOF (ns)");
    hdtof4_pi->Draw(); cc1->SaveAs(KEDR + "dtof4_pi" + format2); cc1->SaveAs(KEDR + "dtof4_pi" + format3);

    htimeresk->GetXaxis()->SetTitle("TOF (ns)");
    htimeresk->Fit("gaus","","",2.,4.);
    htimeresk->Draw(); cc1->SaveAs(KEDR + "timeresk" + format2); cc1->SaveAs(KEDR + "timeresk" + format3);

    hrr->GetXaxis()->SetTitle("r_{ip}, cm");
    hrr->Draw(); cc1->SaveAs(KEDR+"rr.png");

    hZip->GetXaxis()->SetTitle("Z_{ip}, cm");
    hZip->Draw(); cc1->SaveAs(KEDR+"Zip.png");

    hEbeam->GetXaxis()->SetTitle("E_{beam} (MeV)");
    hEbeam->Draw(); cc1->SaveAs(KEDR+"Ebeam.png");

    hDBEn->GetXaxis()->SetTitle("E_{beam} (MeV)");
    hDBEn->Draw(); cc1->SaveAs(KEDR+"DBEbeam.png");

    hRun->Draw(); cc1->SaveAs(KEDR+"Run.png");
    hTime->GetXaxis()->SetTimeDisplay(1);
    hTime->GetXaxis()->SetTimeFormat("%d/%m/%y%F1970-01-01 00:00:00");
    hTime->Draw(); cc1->SaveAs(KEDR+"Time.png");
    hRunSigMbcCut->Draw(); cc1->SaveAs(KEDR+"RunSigMbcCut.png");
    hRunSigdECut->Draw(); cc1->SaveAs(KEDR+"RunSigdECut.png");
    hLum->SetMarkerStyle(7);
    hLum->SetMarkerColor(38);
    hLum->SetMarkerSize(0.5);
    hLum->SetLineWidth(2);
    hLum->SetLineColor(1);
    hLum->GetXaxis()->SetTimeDisplay(1);
    hLum->GetXaxis()->SetTimeFormat("%d/%m/%y%F1970-01-01 00:00:00");
    hLum->GetXaxis()->SetTitle("Time(d/m/y)");
    hLum->GetYaxis()->SetTitle("Integral luminosity, nb^{-1}");
    hLum->Draw(); cc1->SaveAs(KEDR+"Luminosity.png");

    henergy->GetXaxis()->SetTitle("E (MeV)");
    henergy->Draw(); cc1->SaveAs(KEDR+"emc_energy.png");
    hlkrenergy->GetXaxis()->SetTitle("E (MeV)");
    hlkrenergy->Draw(); cc1->SaveAs(KEDR+"lkrenergy.png");
    hcsienergy->GetXaxis()->SetTitle("E (MeV)");
    hcsienergy->Draw(); cc1->SaveAs(KEDR+"csienergy.png");
    henass->GetXaxis()->SetTitle("e (MeV)");
    henass->Draw(); cc1->SaveAs(KEDR+"emc_energy_ass.png");

    hmomt->GetXaxis()->SetTitle("P (MeV/c)");
    hmomt->Draw(); cc1->SaveAs(KEDR+"pt.png");

    hmom->GetXaxis()->SetTitle("P (MeV/c)");
    hmom->Draw(); cc1->SaveAs(KEDR+"p.png");

    hmomrec->GetXaxis()->SetTitle("P (MeV/c)");
    hmomrec->Draw(); cc1->SaveAs(KEDR+"prec.png");

    hncls->Draw(); cc1->SaveAs(KEDR+"ncls.png");
    hnlkr->Draw(); cc1->SaveAs(KEDR+"nlkr.png");
    hncsi->Draw(); cc1->SaveAs(KEDR+"ncsi.png");
    hep->Draw(); cc1->SaveAs(KEDR+"ep.png");
    hDCnhits->Draw(); cc1->SaveAs(KEDR+"DCnhits.png");
    hVDnhits->Draw(); cc1->SaveAs(KEDR+"VDnhits.png");
    htchi2->Draw(); cc1->SaveAs(KEDR+"tchi2.png");
    htnhits->Draw(); cc1->SaveAs(KEDR+"tnhits.png");
    htnhitsvd->Draw(); cc1->SaveAs(KEDR+"tnhitsvd.png");
    htnhitsxy->Draw(); cc1->SaveAs(KEDR+"tnhitsxy.png");
    htnhitsz->Draw(); cc1->SaveAs(KEDR+"tnhitsz.png");
    htnvec->Draw(); cc1->SaveAs(KEDR+"tnvec.png");
    htnvecxy->Draw(); cc1->SaveAs(KEDR+"tnvecxy.png");
    htnvecz->Draw(); cc1->SaveAs(KEDR+"tnvecz.png");
    htheta->Draw(); cc1->SaveAs(KEDR+"theta.png");
    hphi->Draw(); cc1->SaveAs(KEDR+"phi.png");

    hMUnhits->Draw(); cc1->SaveAs(KEDR+"munhits.png");
    hMUnhits1->Draw(); cc1->SaveAs(KEDR+"munhits1.png");
    hMUnhits2->Draw(); cc1->SaveAs(KEDR+"munhits2.png");
    hMUnhits3->Draw(); cc1->SaveAs(KEDR+"munhits3.png");

    hvrtntrk->Draw(); cc1->SaveAs(KEDR+"vrtntrk.png");
    hvrtnip->Draw(); cc1->SaveAs(KEDR+"vrtnip.png");
    hvrtnbeam->Draw(); cc1->SaveAs(KEDR+"vrtnbeam.png");
    hfchi2->Draw(); cc1->SaveAs(KEDR+"minuitChi2.png");

    hATCcnt->Draw(); cc1->SaveAs(KEDR+"ATCcnt.png");
    hATCnpe->Draw(); cc1->SaveAs(KEDR+"ATCnpe.png");
    pr2->SetXTitle("P, MeV/c");
    pr2->SetYTitle("N_{ph.e.}");
    pr2->SetMaximum(12.0);
    pr2->Draw("prof");
    pr1->SetXTitle("P, MeV/c");
    pr1->SetYTitle("N_{ph.e.}");
    pr1->SetLineColor(kRed);
    pr1->Draw("same");
    cc1->SaveAs(KEDR+"ATC_npe_p.png");

    hdedx->Draw();  cc1->SaveAs(KEDR+"dedx.png");
    hprob->Draw();  cc1->SaveAs(KEDR+"prob.png");
    hresd->Draw();  cc1->SaveAs(KEDR+"resd.png");

    fout->Write();
    fout->Close();
}

