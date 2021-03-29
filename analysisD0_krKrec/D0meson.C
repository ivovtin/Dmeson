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

#define PI 3.14159265358979

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
	//*lum = runinfo.intplum;
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
    float min_Mbc=1700.;
    float min_Mbc2=1700.;
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
    TString fout_result_atc;
    TString fout_result;
    TString dir_out="results";
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    //TString list_checkruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/runs_ecor1815.000-1818.000";
    if( key==0 ){           //exp 2016-17
	min_Mbc2=1800;
	//deCut1=-150; deCut2=150;
	deCut1=-100; deCut2=100;
	mbcCut1=1855, mbcCut2=1875;
	//fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data_%d.root",key).Data();
	fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data_test_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_KemcAllowedOff_kNoiseReject3_ATC_1.0_krKrec/";
	fout_result_atc=dir_out + "/" + "kp_exp_2016-17_KemcAllowedOff_kNoiseReject3_ATC_1.0_krKrec.dat";
	fout_result=dir_out + "/" + "kp_exp_2016-17_KemcAllowedOff_kNoiseReject3_1.0_krKrec.dat";
    }
    else if (key==4)        //exp 2004
    {
	min_Mbc2=1800;
	deCut1=-100; deCut2=100;
	mbcCut1=1855, mbcCut2=1875;
	fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data2004_%d.root",key).Data();
	KEDR = "/home/ovtin/public_html/outDmeson/D0/data2004Pcorr/";
        list_badruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/badruns";
	fout_result_atc=dir_out + "/" + "kp_2004_ATC.dat";
	fout_result=dir_out + "/" + "kp_2004.dat";
    }
    else if (key==1)        //sig
    {
	min_Mbc2=1800;
	deCut1=-300; deCut2=300;
	mbcCut1=1800, mbcCut2=1900;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_sig_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Sig_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/";
	fout_result_atc=dir_out + "/" + "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat";
	fout_result=dir_out + "/" + "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0.dat";
    }
    else if (key==2)        //uds
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_BG_continium_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_continium_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/";
	fout_result_atc=dir_out + "/" + "kp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat";
	fout_result=dir_out + "/" + "kp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0.dat";
    }
    else if (key==3)        //ddBG
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=dir_out + "/" + TString::Format("sim_Dmeson_BG_eetoDD_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_eetodd_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/";
	fout_result_atc=dir_out + "/" + "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat";
	fout_result=dir_out + "/" + "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0.dat";
    }

    gSystem->Exec("mkdir " + KEDR);
    gSystem->Exec("cp /store/users/ovtin/outDmeson/demo/index.php " + KEDR);

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
    TH1F* hDBEn=new TH1F("DB Ebeam","DB Ebeam",200,1885.,1889.);

    TH1F *hmbc=new TH1F("M_{bc}","M_{bc}",50,min_Mbc2,1900.);
    TH1F *hmbc_woKinFit=new TH1F("M_{bc} w/o kinFit","M_{bc} w/o kinFit",50,min_Mbc2,1900.);
    TH1F *hmbc_ATC=new TH1F("M_{bc} ATC","M_{bc} ATC",50,min_Mbc2,1900.);

    TH1F* hdE=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdE_ATC=new TH1F("#Delta E ATC","#Delta E ATC",30,-300.,300.);
    TH1F* hdP=new TH1F("#Delta P","#Delta P",200,-1000.,1000.);
    TH1F* hfchi2=new TH1F("MChi2","Minuit Chi2",100,0.,100.);

    TH2D *h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 100,min_Mbc,1900,100,-300,300);
    TH2D *h2MbcdE_ATC=new TH2D("M_{bc}:#Delta E ATC", "M_{bc}:#Delta E ATC", 100,min_Mbc,1900,100,-300,300);
    TH2D *h2MbcdP=new TH2D("M_{bc}:#Delta P", "M_{bc}:#Delta P", 200,-500,500,200,1825,1890);
    TH2D *h2MbcdP_ATC=new TH2D("M_{bc}:#Delta P ATC", "M_{bc}:#Delta P ATC", 200,-500,500,200,1825,1890);

    TH1F* hrr=new TH1F("rr","rr",50,0.,3.);
    TH1F* hZip=new TH1F("zip","zip",100,-50.,50.);
    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",15,-0.5,14.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",12,-0.5,11.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",12,-0.5,11.5);
    TH1F* hmomt=new TH1F("pt","pt",100,0.,3000.);
    TH1F* hmom=new TH1F("p","p",100,0.,3000.);
    TH1F* hmomrec=new TH1F("prec","prec",100,0.,3000.);
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

    TH1F* htofc1=new TH1F("htofc1","htofc1",100,-2.,38.);
    TH1F* httof1=new TH1F("httof1","httof1",100,-15.,15.);
    TH1F* htofc2=new TH1F("htofc2","htofc2",100,-2.,38.);
    TH1F* httof2=new TH1F("httof2","httof2",100,-15.,15.);

    TH1F* hMUnhits=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits1=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits2=new TH1F("munhits","mu.nhits",15,-0.5,15.5);
    TH1F* hMUnhits3=new TH1F("munhits","mu.nhits",15,-0.5,15.5);

    TH1F* hATCcnt=new TH1F("CNT","CNT ATC",160,0.0,159.0);
    TH1F* hATCnpe=new TH1F("Nph.e.","Nph.e. ATC",100,0.0,30.0);

    TTree *forFit = new TTree("forFit","forFit");
    Float_t forFitMbc, forFitdE, forFitdP;
    forFit->Branch("Mbc",&forFitMbc,"Mbc/F");
    forFit->Branch("dE",&forFitdE,"dE/F");
    forFit->Branch("dP",&forFitdP,"dP/F");

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
    /*
    std::vector<int> Eruns;
    string linecheckruns;
    int eruns=0;
    ifstream incheckruns(list_checkruns);
    if (incheckruns.is_open())
    {
	while (getline(incheckruns, linecheckruns))
	{
	    eruns = atoi(linecheckruns.c_str());
	    Eruns.push_back(eruns);
            //cout<<"runcheckruns="<<eruns<<endl;
	}
    }
    incheckruns.close();

    for(int i=0; i<Eruns.size(); ++i) cout << Eruns[i] << ' ';
    */
    int runprev=0;
    std::vector<int> goodruns;

    int nev=0;

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

	if ( *std::find(badruns.begin(), badruns.end(), Dmeson.Run) ) continue;        //skip bad runs
	//if ( *std::find(badruns.begin(), badruns.end(), Dmeson.Run) ) { cout<<"bad run="<<Dmeson.Run<<endl; continue; };        //skip bad runs
	/*if ( *std::find(Eruns.begin(), Eruns.end(), Dmeson.Run) )
	{
	    //cout<<"check run="<<Dmeson.Run<<endl;
	}
	else{
	    continue;
	};
        */
	if( (k %100000)==0 )cout<<k<<endl;

	if(k>0)
	{
	    tt->GetEntry(k-1);
	    runprev=Dmeson.Run;
	    //cout<<"Dmeson.run="<<Dmeson.Run<<endl;
	}

	tt->GetEntry(k);

	if( runprev!=Dmeson.Run
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
	    //cout<<"Dmeson.run="<<Dmeson.Run<<endl;
	    goodruns.push_back(Dmeson.Run);

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

            //static float lum_e=0, lum_p=0;
	    //int buflum[32];
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
	   Dmeson.de>=min_dE && Dmeson.de<=max_dE
           && Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc
	   //&& Dmeson.vrtntrk>=ntrk
	   //&& Dmeson.chi2t1<max_chi2 && Dmeson.chi2t2<max_chi2
	   //&& Dmeson.nhitst1>=min_nhits && Dmeson.nhitst2>=min_nhits
	   //&& Dmeson.nhitst1<=max_nhits && Dmeson.nhitst2<=max_nhits
	   //&& Dmeson.rr1<rrCut && Dmeson.rr2<rrCut
	   //&& fabs(Dmeson.zip1)<zCut && fabs(Dmeson.zip2)<zCut
	   //&& Dmeson.ecls1<eclsCut && Dmeson.ecls2<eclsCut
	   //&& (Dmeson.mulayerhits2+Dmeson.mulayerhits3)<=max_munhits
	   //##########################################################
	   //&& Dmeson.pt1>min_pt && Dmeson.pt1<max_pt && Dmeson.pt2>min_pt && Dmeson.pt2<max_pt
           /*
	   && (Dmeson.Run<23478 || Dmeson.Run>23524)  //7 layer DC with problems
           && (Dmeson.Run<23746 || Dmeson.Run>23808)  //7+6 layer DC with problems
           */
	   //&& (Dmeson.Run<23435 || Dmeson.Run>23808)
	   //&& (Dmeson.Run<23858 || Dmeson.Run>23866)
	   //&& (Dmeson.Run<23886)
	   //&& (Dmeson.mulayerhits1)<=1
           //&& Dmeson.Ebeam>1887.0  //better
           //&& Dmeson.Ebeam<=1886.80
           //&& ( Dmeson.Ebeam>1887.20 && Dmeson.Ebeam<1887.40 )
           //&& Dmeson.Ebeam>1887.4  //better
	   //&& (Dmeson.Run<23809 || Dmeson.Run>23838)
	   //&& (Dmeson.Run>23600 && Dmeson.Run<23800)
	   //&& (Dmeson.Run>23942 && Dmeson.Run<24835)
	   //&& (Dmeson.Run<23495 || Dmeson.Run>23642)
	   //&& (Dmeson.Run<24629 || Dmeson.Run>24647)
	   //&& (Dmeson.Run>=23495 && Dmeson.Run<=23642)
	   //&& (Dmeson.Run>=24629 && Dmeson.Run<=24647)
	   //&& (Dmeson.Run>=23743 && Dmeson.Run<=23905)
	   //&& (Dmeson.Run>=23556 && Dmeson.Run<=23567)
	   //&& (Dmeson.Run>=23211 && Dmeson.Run<=23567)   //>1822.0
	   //&& (Dmeson.Run>=23211 && Dmeson.Run<=23567)   //>1822.0
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

	    hmomrec->Fill(Dmeson.Ppart1);
	    hmomrec->Fill(Dmeson.Ppart2);

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

            htofc1->Fill(Dmeson.tofc1);
            httof1->Fill(Dmeson.ttof1);
            htofc2->Fill(Dmeson.tofc2);
            httof2->Fill(Dmeson.ttof2);

	    hfchi2->Fill(Dmeson.fchi2);

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

		if( Dmeson.mbc>=mbcCut1 && Dmeson.mbc<=mbcCut2 )
		{
		    hDCnhits->Fill(Dmeson.nhitsdc);
		    hVDnhits->Fill(Dmeson.nhitsvd);

		    hMUnhits->Fill(Dmeson.munhits);
		    hMUnhits1->Fill(Dmeson.mulayerhits1);
		    hMUnhits2->Fill(Dmeson.mulayerhits2);
		    hMUnhits3->Fill(Dmeson.mulayerhits3);
		}
	    }

	    double px1 = Dmeson.p1*sin(Dmeson.thetat1/180.*PI)*cos(Dmeson.phit1/180.*PI);
	    double py1 = Dmeson.p1*sin(Dmeson.thetat1/180.*PI)*sin(Dmeson.phit1/180.*PI);
	    double pz1 = Dmeson.p1*cos(Dmeson.thetat1/180.*PI);

	    double px2 = Dmeson.p2*sin(Dmeson.thetat2/180.*PI)*cos(Dmeson.phit2/180.*PI);
	    double py2 = Dmeson.p2*sin(Dmeson.thetat2/180.*PI)*sin(Dmeson.phit2/180.*PI);
	    double pz2 = Dmeson.p2*cos(Dmeson.thetat2/180.*PI);

	    double Mbc_woKinFit = Dmeson.Ebeam*Dmeson.Ebeam - pow(px1+px2,2) - pow(py1+py2,2) - pow(pz1+pz2,2);

	    if (Mbc_woKinFit>0) Mbc_woKinFit = sqrt(Mbc_woKinFit); else Mbc_woKinFit = 0;

	    if( Dmeson.de>=deCut1 && Dmeson.de<=deCut2 &&  Mbc_woKinFit>=min_Mbc2 && Mbc_woKinFit<=max_Mbc )
	    {
		hmbc_woKinFit->Fill(Mbc_woKinFit);
	    }

            //--
	    if( Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		h2MbcdE->Fill(Dmeson.mbc, Dmeson.de);
		h2MbcdP->Fill(Dmeson.dp, Dmeson.mbc);
	    }

	    hdP->Fill(Dmeson.dp);

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

            //=============== ATC identification ================================

	    if( verbose==1 ) cout<<"natccrosst1="<<Dmeson.natccrosst1<<endl;
	    int good_region_t1=0;
	    for(int i=0; i<Dmeson.natccrosst1; i++)
	    {
		if( verbose==1 ) cout<<"atcCNTt1="<<Dmeson.atcCNTt1[i]<<"\t"<<"atcNpet1="<<Dmeson.atcNpet1[i]<<endl;
		if( verbose==1 ) cout<<"single_aerogel_REGION0t1="<<Dmeson.single_aerogel_REGION0t1[i]<<endl;
		if( verbose==1 ) cout<<"wlshitt1="<<Dmeson.wlshitt1[i]<<endl;
		hATCcnt->Fill(Dmeson.atcCNTt1[i]);
		if( Dmeson.single_aerogel_REGION0t1[i]==1 ) good_region_t1++;
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
		if( Dmeson.single_aerogel_REGION0t2[i]==1 ) good_region_t2++;
	    }
	    if( verbose==1 ) cout<<"atcTotalNpet2="<<Dmeson.atcTotalNpet2<<endl;
            hATCnpe->Fill(Dmeson.atcTotalNpet2);

            //very hard suppression
	    //if( (Dmeson.p1>600. && Dmeson.atcTotalNpet1<=0.1) && (Dmeson.p2>600. && Dmeson.atcTotalNpet2<=0.1) ) continue;
	    //if( (Dmeson.p1>600. && Dmeson.atcTotalNpet1>0.1) && (Dmeson.p2>600. && Dmeson.atcTotalNpet2>0.1) ) continue;

            //soft suppression
	    //if( (Dmeson.p1>600. && good_region_t1>=2 && Dmeson.atcTotalNpet1<=0.1) && (Dmeson.p2>600. && good_region_t2>=2 && Dmeson.atcTotalNpet2<=0.1) ) continue;
	    //if( (Dmeson.p1>600. && good_region_t1>=1 && Dmeson.atcTotalNpet1>0.1) && (Dmeson.p2>600. && good_region_t2>=1 && Dmeson.atcTotalNpet2>0.1) ) continue;
	    if( (Dmeson.Ppart1>450. && good_region_t1>=2 && Dmeson.atcTotalNpet1<=0.1) && (Dmeson.Ppart2>450. && good_region_t2>=2 && Dmeson.atcTotalNpet2<=0.1) ) continue;
	    if( (Dmeson.Ppart1>450. && good_region_t1>=1 && Dmeson.atcTotalNpet1>0.1) && (Dmeson.Ppart2>450. && good_region_t2>=1 && Dmeson.atcTotalNpet2>0.1) ) continue;

	    if( Dmeson.de>=min_dE && Dmeson.de<=max_dE  &&  Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
	    {
		if ( verbose==2 )
		{
		    if (Dmeson.de>=deCut1 && Dmeson.de<=deCut2 &&  Dmeson.mbc>=min_Mbc && Dmeson.mbc<=max_Mbc )
		    {
			cout<<Dmeson.Run<<"\t"<<Dmeson.rEv<<"\t"<<Dmeson.mbc<<"\t"<<Dmeson.de<<"\t"<<Dmeson.dp<<endl;
		    }
		}
		ResultATC<< Dmeson.mbc <<"\t"<< Dmeson.de <<"\t"<< Dmeson.dp <<endl;
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
		h2MbcdP_ATC->Fill(Dmeson.dp, Dmeson.mbc);
	    }

	    forFitMbc=Dmeson.mbc;
	    forFitdE=Dmeson.de;
	    forFitdP=Dmeson.dp;
	    forFit->Fill();

	    //if(verbose==1) cout<<"Dmeson.mbc="<<Dmeson.mbc<<"\t"<<"Dmeson.de="<<Dmeson.de<<"\t"<<endl;

            //===================================================================
	}
    }
    Result.close();
    ResultATC.close();

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
    TString nameMbc, nameMbc_woKinFit, nameMbc_ATC, nameMbcdE, nameMbcdE_ATC, nameMbcdP, nameMbcdP_ATC, namedE, namedE_ATC, namedP;
    nameMbc = "Mbc";
    nameMbc_woKinFit = "Mbc_woKinFit";
    nameMbc_ATC = "Mbc_ATC";
    nameMbcdE = "MbcdE";
    nameMbcdE_ATC = "MbcdE_ATC";
    nameMbcdP = "MbcdP";
    nameMbcdP_ATC = "MbcdP_ATC";
    namedE = "dE";
    namedE_ATC = "dE_ATC";
    namedP = "dP";

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
    cc1->SaveAs(KEDR + nameMbcdE_ATC + format1); cc1->SaveAs(KEDR + nameMbcdE_ATC + format2);  cc1->SaveAs(KEDR + nameMbcdE_ATC + format3);

    h2MbcdP->GetXaxis()->SetTitle("#Delta P (MeV/c)");
    h2MbcdP->GetYaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdP->Draw(); cc1->SaveAs(KEDR + nameMbcdP + format1); cc1->SaveAs(KEDR + nameMbcdP + format2);  cc1->SaveAs(KEDR + nameMbcdP + format3);

    h2MbcdP_ATC->GetXaxis()->SetTitle("#Delta P (MeV/c)");
    h2MbcdP_ATC->GetYaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdP_ATC->Draw(); cc1->SaveAs(KEDR + nameMbcdP_ATC + format1); cc1->SaveAs(KEDR + nameMbcdP_ATC + format2);  cc1->SaveAs(KEDR + nameMbcdP_ATC + format3);

    hdE->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE->GetYaxis()->SetTitle("Events/20 MeV");
    hdE->Draw("E1"); cc1->SaveAs(KEDR + namedE + format1); cc1->SaveAs(KEDR + namedE + format2); cc1->SaveAs(KEDR + namedE + format3);

    hdE_ATC->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE_ATC->GetYaxis()->SetTitle("Events/20 MeV");
    hdE_ATC->Draw("E1"); cc1->SaveAs(KEDR + namedE_ATC + format1); cc1->SaveAs(KEDR + namedE_ATC + format2); cc1->SaveAs(KEDR + namedE_ATC + format3);

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

    heclst12diff->GetXaxis()->SetTitle("(e1-e2) (MeV)");
    heclst12diff->Draw(); cc1->SaveAs(KEDR + "eclst12diff" + format2);

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

    hATCcnt->Draw(); cc1->SaveAs(KEDR+"ATCcnt.png");
    hATCnpe->Draw(); cc1->SaveAs(KEDR+"ATCnpe.png");

    fout->Write();
    fout->Close();

}
