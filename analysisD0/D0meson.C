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

#include "D0meson.h"

using namespace std;
string progname;

int Usage(string status)
{
    cout<<"Usage: "<<progname<<"\t"<<"Data (0 - 2016-17, 4 - 2004) or MC (1 - Signal, 2 - BG continium, 3 - BG DD)  Verbose (0 or 1)"<<endl;
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
    *t = runinfo.livesec;
    kd_db_close(conn);
}

int main(int argc, char* argv[])
{
    progname=argv[0];
    //for print DEBUG information
    int verbose=0;
    if( argc>1 )
    {
	key=atoi(argv[1]);
	verbose=atoi(argv[2]);
	if( key>4 ){ Usage(progname); return 0;}
	if( key<0 ){ Usage(progname); return 0;}
    }
    else
    {
	Usage(progname);
    }

    //***************preselections*************
    int ntrk=3;
    int max_munhits=2;
    float min_pt=100.; //MeV
    float max_pt=2000.; //MeV
    float min_Mbc=1700.;;
    float min_Mbc2=1700.;;
    if(key==1) min_Mbc=1800.;
    float max_Mbc=1900.;
    float min_dE=-300.;
    float max_dE=300.;
    float eclsCut=1000.;

    float rrCut,zCut,max_chi2,min_nhits,max_nhits;

    if(key!=4){
	//2016-17
	rrCut=0.5;
	zCut=13.;
	max_chi2=1000.;
	min_nhits=24.;
        max_nhits=1000.;
    }
    else{
        //2004
	rrCut=0.5;
	zCut=13.;
	max_chi2=1000.;
	min_nhits=24.;
	//max_nhits=48.;
	max_nhits=1000.;
    }
    //*****************************************

    double deCut1, deCut2;
    double mbcCut1, mbcCut2;

    time_t runTime_begin;
    time_t runTime_end;
    double slum;

    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    TString fout_result;
    TString dir_out="results";
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    if( key==0 ){           //exp 2016-17
	min_Mbc=1700;
	min_Mbc2=1800;
	deCut1=-150; deCut2=150;
	//deCut1=-100; deCut2=100;
	mbcCut1=1855, mbcCut2=1875;
	//fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data_401-500_%d.root",key).Data();
	fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data_%d.root",key).Data();
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr/";
        KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorrTest/";
	//KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorrRuns401-500/";
	//KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorrEbeamgt1887.4/";
	gSystem->Exec("mkdir " + KEDR);
        gSystem->Exec("cp /store/users/ovtin/outDmeson/demo/index.php " + KEDR);
	list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
	fout_result=dir_out + "/" + "kp_exp_1.0173_2016-17.dat";
	//fout_result=dir_out + "/" + "kp_exp_1.0173_2016-17_SkipBadRuns.dat";
    }
    else if (key==4)        //exp 2004
    {
        min_Mbc=1700;
	min_Mbc2=1800;
	deCut1=-100; deCut2=100;
	mbcCut1=1855, mbcCut2=1875;
	fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data2004_%d.root",key).Data();
	KEDR = "/home/ovtin/public_html/outDmeson/D0/data2004Pcorr/";
        list_badruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/badruns";
	fout_result=dir_out + "/" + "kp_2004.dat";
    }
    else if (key==1)        //sig
    {
        min_Mbc=1800;
	deCut1=-300; deCut2=300;
	mbcCut1=1800, mbcCut2=1900;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_sig_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Sig/";
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Sig_test/";
	fout_result=dir_out + "/" + "kp_signal_def.dat";
    }
    else if (key==2)        //uds
    {
	min_Mbc=1700;
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_BG_continium_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_continium/";
	fout_result=dir_out + "/" + "kp_uds.dat";
    }
    else if (key==3)        //ddBG
    {
	min_Mbc=1700;
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_BG_eetoDD_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_eetodd/";
	fout_result=dir_out + "/" + "kp_dbck.dat";
    }
    cout<<fnameout<<endl;
    fout = new TFile(fnameout,"RECREATE");

    //include samples
    chain();
    Int_t nentr=tt->GetEntries();
    if(verbose==1) cout<<"Nentries="<<nentr<<endl;

    setbranchstatus();
    setbranchaddress();

    TH1F* hDncomb=new TH1F("Dmseon.ncomb","Dmseon.ncomb",150,-0.5,149.5);

    TH1F *hRun;
    TH1F *hTime;
    TH1F *hRunSigMbcCut;
    TH1F *hRunSigdECut;
    TH2D* hLum;
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

    TH1F* hmbc;
    if( key==0 || key==4 || key==1){
	hmbc=new TH1F("M_{bc}","M_{bc}",50,1800.,1900.);
    }
    else{
	hmbc=new TH1F("M_{bc}","M_{bc}",50,1700.,1900.);
    }
    TH1F* hdE=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdP=new TH1F("#Delta P","#Delta P",200,-1000.,1000.);
    TH1F* hfchi2=new TH1F("MChi2","Minuit Chi2",100,0.,100.);

    TH2D *h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 100,min_Mbc,1900,100,-300,300);
    TH2D *h2MbcdP=new TH2D("M_{bc}:#Delta P", "M_{bc}:#Delta P", 200,-500,500,200,1825,1890);

    TH1F* hrr=new TH1F("rr","rr",50,0.,3.);
    TH1F* hZip=new TH1F("zip","zip",100,-50.,50.);
    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",15,-0.5,14.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",12,-0.5,11.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",12,-0.5,11.5);
    TH1F* hmomt=new TH1F("pt","pt",100,0.,3000.);
    TH1F* hmom=new TH1F("p","p",100,0.,3000.);
    TH1F* hmomrec=new TH1F("prec","prec",100,0.,3000.);
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

    TH1F* henass=new TH1F("Energy ass","Energy ass",100,0.,4500.);
    TH1F* henergy=new TH1F("Energy","Energy EMC",100,0.,4500.);
    TH1F* hlkrenergy=new TH1F("E_LKr","Energy LKr",100,0.,4500.);
    TH1F* hcsienergy=new TH1F("E_CsI","Energy CsI",100,0.,4500.);
    TH1F* hncls=new TH1F("ncls","emc.ncls",20,-0.5,19.5);
    TH1F* hnlkr=new TH1F("nlkr","emc.nlkr",20,-0.5,19.5);
    TH1F* hncsi=new TH1F("ncsi","emc.ncsi",20,-0.5,19.5);
    TH1F* hep=new TH1F("Etop","E/p",100,-0.5,3.5);
    TH1F* hnclst1=new TH1F("nclst1","nclst1",6,-0.5,5.5);
    TH1F* heclst1=new TH1F("eclst1","eclst1",100,0.,2500.);
    TH1F* htclst1=new TH1F("tclst1","tclst1",100,-30.,30.);
    TH1F* hpclst1=new TH1F("pclst1","pclst1",100,-20.,20.);
    TH1F* hnclst2=new TH1F("nclst2","nclst2",6,-0.5,5.5);
    TH1F* heclst2=new TH1F("eclst2","eclst2",100,0.,2500.);
    TH1F* htclst2=new TH1F("tclst2","tclst2",100,-30.,30.);
    TH1F* hpclst2=new TH1F("pclst2","pclst2",100,-20.,20.);
    TH1F* heclst12diff=new TH1F("eclst12diff","eclst2",100,-1500.,1500.);
    TH1F* hnumn=new TH1F("numn","Number of neutral clss",10,-0.5,10.5);
    TH1F* henn=new TH1F("enn","Energy of neutrals cls",100,0.,2500.);
    TH1F* hnumo=new TH1F("numo","Number of others cls",10,-0.5,10.5);
    TH1F* heno=new TH1F("eno","Energy of others cls",100,0.,2500.);

    TH1F* htofc1=new TH1F("htofc1","htofc1",100,-2.,38.);
    TH1F* httof1=new TH1F("httof1","httof1",100,-15.,15.);
    TH1F* htofc2=new TH1F("htofc2","htofc2",100,-2.,38.);
    TH1F* httof2=new TH1F("httof2","httof2",100,-15.,15.);

    TH1F* hMUnhits=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits1=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits2=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits3=new TH1F("munhits","mu.nhits",15,-0.5,15.5);

    TTree *forFit = new TTree("forFit","forFit");
    Float_t forFitMbc, forFitdE, forFitdP;
    forFit->Branch("Mbc",&forFitMbc,"Mbc/F");
    forFit->Branch("dE",&forFitdE,"dE/F");
    forFit->Branch("dP",&forFitdP,"dP/F");

    ofstream Result(TString::Format(fout_result),ios_base::out);

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
    std::vector<int> goodruns;

    int nev=0;

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

	if ( *std::find(badruns.begin(), badruns.end(), Dmeson.Run) ) continue;        //skip bad runs
	//if ( *std::find(badruns.begin(), badruns.end(), Dmeson.Run) ) { cout<<"bad run="<<Dmeson.Run<<endl; continue; };        //skip bad runs

	if( (k %100000)==0 )cout<<k<<endl;

	if(k>0)
	{
	    tt->GetEntry(k-1);
	    runprev=Dmeson.Run;
	    //cout<<"Dmeson.run="<<Dmeson.Run<<endl;
	}

	tt->GetEntry(k);

	if( runprev!=Dmeson.Run )
	{
	    //cout<<"Dmeson.run="<<Dmeson.Run<<endl;
	    goodruns.push_back(Dmeson.Run);

	    KDBconn* conn = kdb_open();

	    if (!conn) {
		printf("Can not connect to database\n");
	    }

	    runTime_begin=kdb_run_get_begin_time(conn, Dmeson.Run);
	    runTime_end=kdb_run_get_end_time(conn, Dmeson.Run);
	    cout<<"||||||||||||||||||||||||=======  Next RUN ========|||||||||||||||||||||||||||||||||"<<endl;
	    cout<<"Begin time of Run"<<Dmeson.Run<<": "<<timestamp(runTime_begin)<<endl;
	    cout<<"End time of Run"<<Dmeson.Run<<": "<<timestamp(runTime_end)<<endl;

            static const int lum_table_id=2007, lum_table_length=7;
	    static const int e_table_id=2119, e_table_length=16;

            //static float lum_e=0, lum_p=0;
	    //int buflum[lum_table_length];
	    //if( kdb_read_for_run(conn,lum_table_id,Dmeson.Run,buflum,lum_table_length) ) {
	    //	lum_p=buflum[0]*1E-3;
	    //	lum_e=buflum[1]*1E-3;
	    //}
	    //kdb_setver(conn,0);
	    //cout<<"Lum_p="<<lum_p<<"\t"<<"Lum_e="<<lum_e<<"\t"<<"slum_p="<<slum_p<<"\t"<<"slum_e="<<slum_e<<endl;
            //if( lum_p<100 ) slum_p += lum_p; //nb^-1
            //if( lum_e<100 ) slum_e += lum_e; //nb^-1
 
	    float beam_energy=0;     
            int bufenergy[e_table_length];
	    if( kdb_read_for_run(conn,e_table_id,Dmeson.Run,bufenergy,e_table_length) ) {
		beam_energy=bufenergy[1]*1E-6;
	    }
	    kdb_close(conn);

            cout<<"DB beam energy is "<<beam_energy<<endl; 
              
	    double en=0, en_err=0, lum=0;
	    int t;
            get_run_lumi(Dmeson.Run, &en, &en_err, &lum, &t);
	    cout<<"Lum="<<lum*0.001<<"\t"<<"slum="<<slum<<endl;
            if( lum*0.001>0. && lum*0.001<100. ) slum += lum*0.001; //nb^-1
            hLum->Fill(runTime_begin,lum*0.001);
	}

	//if( (key==0 || key==4) && Dmeson.vrtntrk==2 &&  Dmeson.theta2t>172 && Dmeson.phi2t>172 ) continue;

	if(
	   Dmeson.de>=min_dE && Dmeson.de<=max_dE
           && Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc
	   && Dmeson.vrtntrk>=ntrk
	   && Dmeson.pt1>min_pt && Dmeson.pt1<max_pt && Dmeson.pt2>min_pt && Dmeson.pt2<max_pt
	   && Dmeson.chi2t1<max_chi2 && Dmeson.chi2t2<max_chi2
	   && Dmeson.nhitst1>=min_nhits && Dmeson.nhitst2>=min_nhits
	   && Dmeson.nhitst1<=max_nhits && Dmeson.nhitst2<=max_nhits
	   && Dmeson.rr1<rrCut && Dmeson.rr2<rrCut
	   && fabs(Dmeson.zip1)<zCut && fabs(Dmeson.zip2)<zCut
	   && Dmeson.ecls1<eclsCut && Dmeson.ecls2<eclsCut
	   && (Dmeson.mulayerhits2+Dmeson.mulayerhits3)<=max_munhits
	   //&& (Dmeson.mulayerhits1)<=1
           //&& Dmeson.Ebeam>1887.0  //better
           //&& Dmeson.Ebeam<=1886.80
           //&& ( Dmeson.Ebeam>1887.20 && Dmeson.Ebeam<1887.40 )
           //&& Dmeson.Ebeam>1887.4  //better
	   //&& (Dmeson.Run<23809 || Dmeson.Run>23838)
	   //&& (Dmeson.Run>23600 && Dmeson.Run<23800)
	   //&& (Dmeson.Run>23942 && Dmeson.Run<24835)
	   && (Dmeson.Run<23495 || Dmeson.Run>23642)
	   && (Dmeson.Run<24629 || Dmeson.Run>24647)
	   )
	{
	    if ( verbose==1 )
	    {
                cout<<"<<<<<<<<<<<<<<<<<<<<<<<<<<< Next combination >>>>>>>>>>>>>>>>>>>>>>>>>>>>"<<endl;
                cout<<"run="<<Dmeson.Run<<"\t"<<"event="<<Dmeson.rEv<<"\t"<<"Ebeam="<<Dmeson.Ebeam<<endl;
                cout<<"Dmeson.ncomb="<<Dmeson.ncomb<<"\t"<<endl;
		cout<<"p1="<<Dmeson.p1<<"\t"<<"p2="<<Dmeson.p2<<endl;
		cout<<"e1/p1="<<Dmeson.e1/Dmeson.p1<<"\t"<<"e2/p2="<<Dmeson.e2/Dmeson.p2<<endl;
		cout<<"(e1+e2)="<<Dmeson.e1+Dmeson.e2<<endl;
		cout<<"rr1="<<Dmeson.rr1<<"\t"<<"rr2="<<Dmeson.rr2<<"\t"<<endl;
		cout<<"zip1="<<Dmeson.zip1<<"\t"<<"zip2="<<Dmeson.zip2<<"\t"<<endl;
		cout<<"fabs(fabs(Dmeson.zip1)-fabs(Dmeson.zip2))="<<fabs(fabs(Dmeson.zip1)-fabs(Dmeson.zip2))<<endl;
		cout<<"Dmeson.thetat1="<<Dmeson.thetat1<<"\t"<<"Dmeson.thetat2="<<Dmeson.thetat2<<endl;
		cout<<"fabs(Dmeson.thetat1-Dmeson.thetat2)="<<fabs(Dmeson.thetat1-Dmeson.thetat2)<<endl;
	        cout<<"mulayerhits1="<<Dmeson.mulayerhits1<<"\t"<<"mulayerhits2="<<Dmeson.mulayerhits2<<"\t"<<"mulayerhits3="<<Dmeson.mulayerhits3<<endl;
            }

            nev++;
	    //if( key==1 && nev>8000 ) continue;

	    hDncomb->Fill(Dmeson.ncomb);

	    hEbeam->Fill(Dmeson.Ebeam);
	    hRun->Fill(Dmeson.Run);
	    hTime->Fill(runTime_begin);

	    hrr->Fill(Dmeson.rr1);
	    hrr->Fill(Dmeson.rr2);
	    hZip->Fill(Dmeson.zip1);
	    hZip->Fill(Dmeson.zip2);

	    hvrtntrk->Fill(Dmeson.vrtntrk);
	    hvrtnip->Fill(Dmeson.vrtnip);
	    hvrtnbeam->Fill(Dmeson.vrtnbeam);

	    htnhits->Fill(Dmeson.nhitst1);
	    htnhits->Fill(Dmeson.nhitst2);

	    htnhitsvd->Fill(Dmeson.nhitsvdt1);
	    htnhitsvd->Fill(Dmeson.nhitsvdt2);

	    htnhitsxy->Fill(Dmeson.nhitsxyt1);
	    htnhitsxy->Fill(Dmeson.nhitsxyt2);

	    htnhitsz->Fill(Dmeson.nhitszt1);
	    htnhitsz->Fill(Dmeson.nhitszt2);

	    hmomt->Fill(Dmeson.pt1);
	    hmomt->Fill(Dmeson.pt2);

	    hmom->Fill(Dmeson.p1);
	    hmom->Fill(Dmeson.p2);

	    hmomrec->Fill(Dmeson.prec1);
	    hmomrec->Fill(Dmeson.prec2);

	    htchi2->Fill(Dmeson.chi2t1);
	    htchi2->Fill(Dmeson.chi2t2);

	    htheta->Fill(Dmeson.thetat1);
	    htheta->Fill(Dmeson.thetat2);

	    hphi->Fill(Dmeson.phit1);
	    hphi->Fill(Dmeson.phit2);

	    htnvec->Fill(Dmeson.nvect1);
	    htnvec->Fill(Dmeson.nvect2);

	    htnvecxy->Fill(Dmeson.nvecxyt1);
	    htnvecxy->Fill(Dmeson.nvecxyt2);

	    htnvecz->Fill(Dmeson.nveczt1);
	    htnvecz->Fill(Dmeson.nveczt2);

	    hnclst1->Fill(Dmeson.ncls1);
	    heclst1->Fill(Dmeson.ecls1);
	    htclst1->Fill(Dmeson.tcls1);
	    hpclst1->Fill(Dmeson.pcls1);

	    hnclst2->Fill(Dmeson.ncls2);
	    heclst2->Fill(Dmeson.ecls2);
	    htclst2->Fill(Dmeson.tcls2);
	    hpclst2->Fill(Dmeson.pcls2);

	    heclst12diff->Fill(Dmeson.ecls1-Dmeson.ecls2);

	    hncls->Fill(Dmeson.ncls);
	    hnlkr->Fill(Dmeson.nlkr);
	    hncsi->Fill(Dmeson.ncsi);
	    henergy->Fill(Dmeson.emcenergy);
	    hlkrenergy->Fill(Dmeson.lkrenergy);
	    hcsienergy->Fill(Dmeson.csienergy);

	    hep->Fill(Dmeson.e1/Dmeson.p1);
	    hep->Fill(Dmeson.e2/Dmeson.p2);

	    henass->Fill(Dmeson.e1);
	    henass->Fill(Dmeson.e2);

	    hnumn->Fill(Dmeson.numn);
	    henn->Fill(Dmeson.enn);
	    hnumo->Fill(Dmeson.numo);
	    heno->Fill(Dmeson.eno);

	    hMUnhits->Fill(Dmeson.munhits);
	    hMUnhits1->Fill(Dmeson.mulayerhits1);
	    hMUnhits2->Fill(Dmeson.mulayerhits2);
	    hMUnhits3->Fill(Dmeson.mulayerhits3);

            htofc1->Fill(Dmeson.tofc1);
            httof1->Fill(Dmeson.ttof1);
            htofc2->Fill(Dmeson.tofc2);
            httof2->Fill(Dmeson.ttof2);

	    hfchi2->Fill(Dmeson.fchi2);

	    if( Dmeson.de>=min_dE && Dmeson.de<=max_dE  &&  Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		if ( verbose==2 )
		{
		    if (Dmeson.de>=deCut1 && Dmeson.de<=deCut2 &&  Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
		    {
			cout<<Dmeson.Run<<"\t"<<Dmeson.rEv<<"\t"<<Dmeson.mbc<<"\t"<<Dmeson.de<<"\t"<<Dmeson.dp<<endl;
		    }
		}
		Result<< Dmeson.mbc <<"\t"<< Dmeson.de <<"\t"<< Dmeson.dp <<endl;
	    }

	    //fill dE
	    if( Dmeson.mbc>=mbcCut1 && Dmeson.mbc<=mbcCut2 )
	    {
		hdE->Fill(Dmeson.de);
		hRunSigMbcCut->Fill(Dmeson.Run);
	    }

            //fill Mbc
	    if( Dmeson.de>=deCut1 && Dmeson.de<=deCut2 &&  Dmeson.mbc>=min_Mbc2 && Dmeson.mbc<=max_Mbc )
	    {
		hmbc->Fill(Dmeson.mbc);
		hRunSigdECut->Fill(Dmeson.Run);
		/*if( Dmeson.mbc>=1800 && Dmeson.mbc<=1850 ){
		    cout<<"<<<<<<<<<<<<<<<<<<<<<<<<<<< Next combination >>>>>>>>>>>>>>>>>>>>>>>>>>>>"<<endl;
		    cout<<"run="<<Dmeson.Run<<"\t"<<"event="<<Dmeson.rEv<<endl;
		    cout<<"Dmeson.ncomb="<<Dmeson.ncomb<<"\t"<<endl;
		    cout<<"p1="<<Dmeson.p1<<"\t"<<"p2="<<Dmeson.p2<<endl;
		    cout<<"e1/p1="<<Dmeson.e1/Dmeson.p1<<"\t"<<"e2/p2="<<Dmeson.e2/Dmeson.p2<<endl;
		    cout<<"(e1+e2)="<<Dmeson.e1+Dmeson.e2<<endl;
		    cout<<"rr1="<<Dmeson.rr1<<"\t"<<"rr2="<<Dmeson.rr2<<"\t"<<endl;
		    cout<<"zip1="<<Dmeson.zip1<<"\t"<<"zip2="<<Dmeson.zip2<<"\t"<<endl;
		    cout<<"fabs(fabs(Dmeson.zip1)-fabs(Dmeson.zip2))="<<fabs(fabs(Dmeson.zip1)-fabs(Dmeson.zip2))<<endl;
		    cout<<"Dmeson.thetat1="<<Dmeson.thetat1<<"\t"<<"Dmeson.thetat2="<<Dmeson.thetat2<<endl;
		    cout<<"fabs(Dmeson.thetat1-Dmeson.thetat2)="<<fabs(Dmeson.thetat1-Dmeson.thetat2)<<endl;
		    cout<<"mulayerhits1="<<Dmeson.mulayerhits1<<"\t"<<"mulayerhits2="<<Dmeson.mulayerhits2<<"\t"<<"mulayerhits3="<<Dmeson.mulayerhits3<<endl;
		    cout<<"Run="<<Dmeson.Run<<"\t"<<"event="<<Dmeson.rEv<<"\t"<<Dmeson.mbc<<"\t"<<Dmeson.de<<"\t"<<endl;
                    cout<<"numn="<<Dmeson.numn<<"\t"<<"enn="<<Dmeson.enn<<"\t"<<"numo="<<Dmeson.numo<<"\t"<<"eno="<<Dmeson.eno<<endl;
		}
                */
	    }

            //--
	    if( Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		h2MbcdE->Fill(Dmeson.mbc, Dmeson.de);
		h2MbcdP->Fill(Dmeson.dp, Dmeson.mbc);
	    }

	    hdP->Fill(Dmeson.dp);

	    forFitMbc=Dmeson.mbc;
	    forFitdE=Dmeson.de;
	    forFitdP=Dmeson.dp;
	    forFit->Fill();

	    if(verbose==1) cout<<"Dmeson.mbc="<<Dmeson.mbc<<"\t"<<"Dmeson.de="<<Dmeson.de<<"\t"<<endl;
	}
    }
    Result.close();

    sort(goodruns.begin(), goodruns.end());
    cout << "Sorted \n";
    int NgoodRuns=0;
    for (vector<int>::iterator it=goodruns.begin(); it!=goodruns.end(); ++it)
    {
	cout<<' '<<*it;
	cout<<'\n';
	NgoodRuns++;
    }
    cout<<"NgoodRuns="<<NgoodRuns<<endl;

    printf("Total Integral Luminosity = %f\n", slum);

    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    gStyle->SetOptFit(1011);
    cc1->cd();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString nameMbc, nameMbcdE, nameMbcdP, namedE, namedP;
    nameMbc = "Mbc";
    nameMbcdE = "MbcdE";
    nameMbcdP = "MbcdP";
    namedE = "dE";
    namedP = "dP";

    hmbc->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbc->GetYaxis()->SetTitle("Events/2 MeV");
    hmbc->Draw("E1"); cc1->SaveAs(KEDR + nameMbc + format1); cc1->SaveAs(KEDR + nameMbc + format2); cc1->SaveAs(KEDR + nameMbc + format3);

    h2MbcdE->GetXaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdE->GetYaxis()->SetTitle("#Delta E (MeV)");
    h2MbcdE->Draw();
    TLine line1(mbcCut1,-300,mbcCut1,300);
    line1.SetLineColor(kGreen);
    line1.SetLineWidth(3);
    TLine line2(mbcCut2,-300,mbcCut2,300);
    line2.SetLineColor(kGreen);
    line2.SetLineWidth(3);
    TLine line3(1700,deCut1,1900,deCut1);
    line3.SetLineColor(kGreen);
    line3.SetLineWidth(3);
    TLine line4(1700,deCut2,1900,deCut2);
    line4.SetLineColor(kGreen);
    line4.SetLineWidth(3);
    if( key==0 || key==4 ){
	line1.Draw("same");
	line2.Draw("same");
	line3.Draw("same");
	line4.Draw("same");
    }
    cc1->SaveAs(KEDR + nameMbcdE + format1); cc1->SaveAs(KEDR + nameMbcdE + format2);  cc1->SaveAs(KEDR + nameMbcdE + format3);

    h2MbcdP->GetXaxis()->SetTitle("#Delta P (MeV/c)");
    h2MbcdP->GetYaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdP->Draw(); cc1->SaveAs(KEDR + nameMbcdP + format1); cc1->SaveAs(KEDR + nameMbcdP + format2);  cc1->SaveAs(KEDR + nameMbcdP + format3);

    hdE->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE->GetYaxis()->SetTitle("Events/20 MeV");
    hdE->Draw("E1"); cc1->SaveAs(KEDR + namedE + format1); cc1->SaveAs(KEDR + namedE + format2); cc1->SaveAs(KEDR + namedE + format3);

    hdP->GetXaxis()->SetTitle("#Delta P (MeV/c)");
    hdP->Draw(); cc1->SaveAs(KEDR + namedP + format1);  cc1->SaveAs(KEDR + namedP + format2); cc1->SaveAs(KEDR + namedP + format3);
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

    hnumn->Draw(); cc1->SaveAs(KEDR + "hnumn" + format2);
    henn->Draw(); cc1->SaveAs(KEDR + "henn" + format2);
    hnumo->Draw(); cc1->SaveAs(KEDR + "hnumo" + format2);
    heno->Draw(); cc1->SaveAs(KEDR + "heno" + format2);

    heclst12diff->GetXaxis()->SetTitle("(e1-e2) (MeV)");
    heclst12diff->Draw(); cc1->SaveAs(KEDR + "eclst12diff" + format2);

    hrr->GetXaxis()->SetTitle("r_{ip}, cm");
    hrr->Draw(); cc1->SaveAs(KEDR+"rr.png");

    hZip->GetXaxis()->SetTitle("Z_{ip}, cm");
    hZip->Draw(); cc1->SaveAs(KEDR+"Zip.png");

    hEbeam->GetXaxis()->SetTitle("E_{beam} (MeV)");
    hEbeam->Draw(); cc1->SaveAs(KEDR+"Ebeam.png");

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

    htofc1->Draw(); cc1->SaveAs(KEDR+"htofc1.png");
    httof1->Draw(); cc1->SaveAs(KEDR+"httof1.png");
    htofc2->Draw(); cc1->SaveAs(KEDR+"htofc2.png");
    httof2->Draw(); cc1->SaveAs(KEDR+"httof2.png");

    hMUnhits->Draw(); cc1->SaveAs(KEDR+"munhits.png");
    hMUnhits1->Draw(); cc1->SaveAs(KEDR+"munhits1.png");
    hMUnhits2->Draw(); cc1->SaveAs(KEDR+"munhits2.png");
    hMUnhits3->Draw(); cc1->SaveAs(KEDR+"munhits3.png");

    hvrtntrk->Draw(); cc1->SaveAs(KEDR+"vrtntrk.png");
    hvrtnip->Draw(); cc1->SaveAs(KEDR+"vrtnip.png");
    hvrtnbeam->Draw(); cc1->SaveAs(KEDR+"vrtnbeam.png");
    hfchi2->Draw(); cc1->SaveAs(KEDR+"minuitChi2.png");

    fout->Write();
    fout->Close();

}
