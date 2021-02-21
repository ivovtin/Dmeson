#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <iostream>
#include <vector>
#include <algorithm>

#include "bhabha.h"

#define PI 3.14159265358979

using namespace std;
string progname;

int Usage(string status)
{
	cout<<"Usage: "<<progname<<"\t"<<"Data (0 - 2016-17, 1 - 2004) or MC (2)  Verbose (0 or 1)"<<endl;
        exit(0);
}

int main(int argc, char* argv[])
{
    progname=argv[0];
    //for print DEBUG information
    int verbose=0;
    if( argc>1 )
    {
	key=atoi(argv[1]);
	if(argv[2]!=0) verbose=atoi(argv[2]);
	if( key>4 ){ Usage(progname); return 0;}
	if( key<0 ){ Usage(progname); return 0;}
    }
    else
    {
	Usage(progname);
    }

    //***************preselections*************
    float rrCut,zCut,max_chi2,min_nhits,max_nhits;

    int ntrk=2;
    int max_munhits=0;
    float min_p=500.; //MeV
    float max_p=3000.; //MeV
    float eclsCut=500.;
    float epCut1=0.0;
    float epCut2=10.0;
    float theta2tCut=174;
    float phi2tCut=165;

    if(key==0){
	//2016-17
	rrCut=0.5;
	zCut=13.;
	max_chi2=1000.;
	min_nhits=23.;
        max_nhits=100.;
    }
    if(key==2){
	//2016-17  - sim
	rrCut=0.5;
	zCut=13.;
	max_chi2=1000.;
	min_nhits=23.;
	//min_nhits=10.;
        max_nhits=100.;
	epCut1=0.0;
	epCut2=10.0;
        theta2tCut=178;
	phi2tCut=178;
    }
    else{
        //2004
	rrCut=0.5;
	zCut=13.;
	max_chi2=1000.;
	min_nhits=23.;
	max_nhits=100.;
	//max_nhits=50.;
    }

    //*****************************************

    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    TString fout_result;
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    if( key==0 ){           //exp 2016-17
	fnameout=TString::Format("exp_bhabha_data_%d.root",key).Data();
        //KEDR = "/home/ovtin/public_html/outDmeson/BhaBha/data/";
        KEDR = "/home/ovtin/public_html/outDmeson/BhaBha/data_test/";
	list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    }
    else if (key==1)        //exp 2004
    {
	fnameout=TString::Format("exp_bhabha_data2004_%d.root",key).Data();
	KEDR = "/home/ovtin/public_html/outDmeson/BhaBha/data2004/";
        list_badruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/badruns";
    }
    else if (key==2)        //sig
    {
	fnameout=TString::Format("sim_bhabha_sig_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/BhaBha/simulation/";
    }
    cout<<fnameout<<endl;
    fout = new TFile(fnameout,"RECREATE");

    //include samples
    chain();
    Int_t nentr=tt->GetEntries();
    if(verbose==1) cout<<"Nentries="<<nentr<<endl;

    setbranchstatus();
    setbranchaddress();

    TH1F* hncomb=new TH1F("ncomb","ncomb",150,-0.5,149.5);

    TH1F *hRun;
    if( key!=1 )
    {
	hRun = new TH1F("Run","Run", 1000, 23206., 26248.);
    }
    else
    {
	hRun = new TH1F("Run","Run", 500, 4100., 4709.);
    }

    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",100,1880.,1895.);

    TH1F* hrr=new TH1F("rr","rr",50,0.,3.);
    TH1F* hZip=new TH1F("zip","zip",100,-50.,50.);
    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",15,-0.5,14.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",12,-0.5,11.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",12,-0.5,11.5);
    TH1F* hmomt=new TH1F("pt","pt",100,0.,3000.);
    TH1F* hmom=new TH1F("p","p",100,0.,3000.);
    TH1F* htchi2=new TH1F("tchi2","tchi2",100,0.,100.);
    TH1F* htchi2norm=new TH1F("tchi2_norm","tchi2_norm",100,0.,100.);
    TH1F* htnhits=new TH1F("tnhits","tnhits",80,0.,80.);
    TH1F* htnhitsvd=new TH1F("tnhitsvd","tnhitsvd",8,-0.5,7.5);
    TH1F* htnhitsxy=new TH1F("tnhitsxy","tnhitsxy",50,0.,50.);
    TH1F* htnhitsz=new TH1F("tnhitsz","tnhitsz",50,0.,50.);
    TH1F* htnvec=new TH1F("tnvec","tnvec",30,0.,30.);
    TH1F* htnvecxy=new TH1F("tnvecxy","tnvecxy",30,0.,30.);
    TH1F* htnvecz=new TH1F("tnvecz","tnvecz",30,0.,30.);
    TH1F* htheta=new TH1F("theta","t.theta",185,0.,185.);
    //TH1F* hthetadif=new TH1F("#Delta #theta","#Delta #theta",100,-0.1,0.1);
    TH1F* hthetadif=new TH1F("htheta","#Delta #theta",100,-10.,10.);
    TH1F* hphi=new TH1F("phi","t.phi",180,0.,360.);
    //TH1F* hphidif=new TH1F("#Delta #phi","#Delta #phi",100,-0.03,0.03);
    TH1F* hphidif=new TH1F("hphi","#Delta #phi",100,-5.,5.);
    TH1F* htheta2t=new TH1F("theta2t","theta2t",185,0.,185.);
    TH1F* hphi2t=new TH1F("phi2t","phi2t",185,0.,185.);

    TH1F* henass=new TH1F("Energy ass","Energy ass",100,0.,4500.);
    TH1F* henergy=new TH1F("Energy","Energy EMC",100,0.,4500.);
    TH1F* hlkrenergy=new TH1F("E_LKr","Energy LKr",100,0.,4500.);
    TH1F* hcsienergy=new TH1F("E_CsI","Energy CsI",100,0.,4500.);
    TH1F* hncls=new TH1F("ncls","emc.ncls",20,-0.5,19.5);
    TH1F* hnlkr=new TH1F("nlkr","emc.nlkr",20,-0.5,19.5);
    TH1F* hncsi=new TH1F("ncsi","emc.ncsi",20,-0.5,19.5);
    TH1F* hep=new TH1F("e/p","e/p",100,-0.5,3.5);
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

    TH1F* hpres=new TH1F("hpres","momres",100,-1.0,1.0);

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
    float pres,pp,pm,tp,tm,phim,phip;

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

	if ( *std::find(badruns.begin(), badruns.end(), bhabha.Run) ) continue;        //skip bad runs

	if( (k %100000)==0 )cout<<k<<endl;

	if(k>0)
	{
	    tt->GetEntry(k-1);
	    runprev=bhabha.Run;
	}

	tt->GetEntry(k);

	if(
           /*
           //1 variant
	   bhabha.vrtntrk>=ntrk
           && bhabha.p1>min_p && bhabha.p1<max_p && bhabha.p2>min_p && bhabha.p2<max_p
           && bhabha.nhitst1>min_nhits && bhabha.nhitst2>min_nhits
           && bhabha.rr1<rrCut && bhabha.rr2<rrCut
	   && fabs(bhabha.zip1)<zCut && fabs(bhabha.zip2)<zCut
	   && bhabha.ecls1>eclsCut && bhabha.ecls2>eclsCut
 	   && (bhabha.thetat1>57 && bhabha.thetat1<122 ) && (bhabha.thetat2>57 && bhabha.thetat2<122)
           && (bhabha.p1 + bhabha.p2)>2000.
           */
           //=======================================
	   //2 variant Harlamova dissertation
	   //bhabha.Run>=23275 && bhabha.Run<=23286 &&   //1 - 10.8%
	   //bhabha.Run>=23287 && bhabha.Run<=23317 &&   //2 - 9.8%
	   //bhabha.Run>=23318 && bhabha.Run<=23369 &&   //3 - 11.12%
	   //bhabha.Run>=23403 && bhabha.Run<=23430 &&   //4 - 22% - bad runs
	   //bhabha.Run>=23431 && bhabha.Run<=23472 &&   //5 - 12.05%
	   //bhabha.Run>=23473 && bhabha.Run<=23522 &&   //6 - 13.1% - bad runs
	   //bhabha.Run>=23523 && bhabha.Run<=23550 &&   //7 - 12.42%
	   //bhabha.Run>=23551 && bhabha.Run<=23569 &&   //8 - 11.35%
	   //bhabha.Run>=23670 && bhabha.Run<=23681 &&   //9 - 10.48%
	   //bhabha.Run>=23682 && bhabha.Run<=23715 &&   //10 - 11%
	   //bhabha.Run>=23716 && bhabha.Run<=23742 &&   //11 - 12.5% - bad runs
	   //bhabha.Run>=23743 && bhabha.Run<=23798 &&   //12 - 16% - bad runs
	   //bhabha.Run>=23799 && bhabha.Run<=23838 &&   //13 - 19% - bad runs
	   //bhabha.Run>=23839 && bhabha.Run<=23862 &&   //14 - 11%
	   //bhabha.Run>=23863 && bhabha.Run<=23885 &&   //15 - 10%
	   //bhabha.Run>=23886 && bhabha.Run<=23905 &&   //16 - 11%
	   //bhabha.Run>=23906 && bhabha.Run<=23943 &&   //17 - 11%
	   //bhabha.Run>=24621 && bhabha.Run<=24647 &&   //18 - 16% - bad runs
	   //bhabha.Run>=24676 && bhabha.Run<=24712 &&   //19 - 11%
	   //bhabha.Run>=24790 && bhabha.Run<=24845 &&   //20 - 11%
	   //bhabha.Run>=24846 && bhabha.Run<=24875 &&   //21 - 11%
	   //bhabha.Run>=24876 && bhabha.Run<=24916 &&   //22 - 14% - bad runs
	   //bhabha.Run>=25016 && bhabha.Run<=25044 &&   //23 - 21% - bad runs
	   //bhabha.Run>=25045 && bhabha.Run<=25090 &&   //24 - 13% - bad runs
	   //bhabha.Run>=25091 && bhabha.Run<=25114 &&   //25 - 11%
	   //bhabha.Run>=25115 && bhabha.Run<=25157 &&   //26 - 11%
	   //bhabha.Run>=25158 && bhabha.Run<=25185 &&   //27 - 11%
	   //bhabha.Run>=25186 && bhabha.Run<=25241 &&   //28 - 11%
	   //bhabha.Run>=25352 && bhabha.Run<=25395 &&   //29 - 11%
	   //bhabha.Run>=25396 && bhabha.Run<=25416 &&   //30 - 11%
	   //bhabha.Run>=25417 && bhabha.Run<=25438 &&   //31 - 11%
	   //bhabha.Run>=25439 && bhabha.Run<=25508 &&   //32 - 11%
	   //bhabha.Run>=25559 && bhabha.Run<=25574 &&   //33 - 11%
	   //bhabha.Run>=25575 && bhabha.Run<=25608 &&   //34 - 11%
	   //bhabha.Run>=25609 && bhabha.Run<=25640 &&   //35 - 11%
	   //bhabha.Run>=25641 && bhabha.Run<=25663 &&   //36 - 11%
	   //bhabha.Run>=25664 && bhabha.Run<=25719 &&   //37 - 11%
	   //bhabha.Run>=26051 && bhabha.Run<=26079 &&   //38 - 12% - bad runs
	   //bhabha.Run>=26080 && bhabha.Run<=26102 &&   //39 - 12% - bad runs
	   //bhabha.Run>=26103 && bhabha.Run<=26134 &&   //40 - 11%
	   bhabha.ncls>=2
           && (bhabha.thetat1>40 && bhabha.thetat1<140 ) && (bhabha.thetat2>40 && bhabha.thetat2<140)
           && bhabha.ecls1>700 && bhabha.ecls2>700
           && bhabha.enn<0.1*bhabha.emcenergy
           && bhabha.theta2t>=165
           && bhabha.phi2t>=165
           && bhabha.rr1<rrCut && bhabha.rr2<rrCut
           && fabs(bhabha.zip1)<zCut && fabs(bhabha.zip2)<zCut
           && bhabha.pt1>100 && bhabha.pt2>100
           && (bhabha.mulayerhits2+bhabha.mulayerhits3)<=1
           && bhabha.vrtnip>=2
           && (bhabha.mulayerhits2+bhabha.mulayerhits3)<=max_munhits
           //=======================================
	   //&& bhabha.nhitst1<=max_nhits && bhabha.nhitst2<=max_nhits
	   //bhabha.vrtnip>=1 && bhabha.vrtnip<=3
	   //&& (bhabha.ecls1+bhabha.ecls2)>2000
           //&& bhabha.enn<0.2*bhabha.emcenergy
	   //&& bhabha.munhits<=1
	   //&& (bhabha.e1/bhabha.p1)<epCut2 && (bhabha.e2/bhabha.p2)<epCut2
          )
	{
	    if( bhabha.charge1==1 )
	    {
		pp=bhabha.p1;
		pm=bhabha.p2;
		tp=bhabha.thetat1/180.*PI;
		tm=bhabha.thetat2/180.*PI;
		phip=bhabha.phit1/180.*PI;
                phim=bhabha.phit2/180.*PI;
	    }
	    else
	    {
		pp=bhabha.p2;
		pm=bhabha.p1;
		tp=bhabha.thetat2/180.*PI;
		tm=bhabha.thetat1/180.*PI;
		phip=bhabha.phit2/180.*PI;
                phim=bhabha.phit1/180.*PI;
	    }

	    if ( verbose==1 )
	    {
                cout<<"<<<<<<<<<<<<<<<<<<<<  Next event  >>>>>>>>>>>>>>>>>>"<<endl;
                cout<<"Run="<<bhabha.Run<<"\t"<<"Event="<<bhabha.rEv<<endl;
		cout<<"p1="<<bhabha.p1<<"\t"<<"p2="<<bhabha.p2<<endl;
                /*
		cout<<"e1/p1="<<bhabha.e1/bhabha.p1<<"\t"<<"e2/p2="<<bhabha.e2/bhabha.p2<<endl;
		cout<<"(e1+e2)="<<bhabha.e1+bhabha.e2<<endl;
		cout<<"rr1="<<bhabha.rr1<<"\t"<<"rr2="<<bhabha.rr2<<"\t"<<endl;
		cout<<"zip1="<<bhabha.zip1<<"\t"<<"zip2="<<bhabha.zip2<<"\t"<<endl;
		cout<<"fabs(fabs(bhabha.zip1)-fabs(bhabha.zip2))="<<fabs(fabs(bhabha.zip1)-fabs(bhabha.zip2))<<endl;
		cout<<"bhabha.thetat1="<<bhabha.thetat1<<"\t"<<"bhabha.thetat2="<<bhabha.thetat2<<endl;
		cout<<"fabs(bhabha.thetat1-bhabha.thetat2)="<<fabs(bhabha.thetat1-bhabha.thetat2)<<endl;
                */
	    }

	    pres = (pm*sin(tm)-pp*sin(tp))/(sqrt(2.)*(pm*sin(tm)+pp*sin(tp))/2.);
	    hpres->Fill(pres);

            //cout<<tm*180./PI<<"\t"<<tp*180./PI<<"\t"<<tm+tp-PI<<"\t"<<(tm+tp-PI)*180./PI<<endl;
	    hthetadif->Fill((tm+tp-PI)*180./PI);
            //hphidif->Fill((fabs(phim-phip)-PI)*180./PI);
	    hphidif->Fill( TMath::Max(bhabha.phit1,bhabha.phit2)-TMath::Min(bhabha.phit1,bhabha.phit2)-180. );

	    hncomb->Fill(bhabha.ncomb);

	    hEbeam->Fill(bhabha.Ebeam);
	    hRun->Fill(bhabha.Run);

	    hrr->Fill(bhabha.rr1);
	    hrr->Fill(bhabha.rr2);
	    hZip->Fill(bhabha.zip1);
	    hZip->Fill(bhabha.zip2);

	    hvrtntrk->Fill(bhabha.vrtntrk);
	    hvrtnip->Fill(bhabha.vrtnip);
	    hvrtnbeam->Fill(bhabha.vrtnbeam);

	    htnhits->Fill(bhabha.nhitst1);
	    htnhits->Fill(bhabha.nhitst2);

	    htnhitsvd->Fill(bhabha.nhitsvdt1);
	    htnhitsvd->Fill(bhabha.nhitsvdt2);

	    htnhitsxy->Fill(bhabha.nhitsxyt1);
	    htnhitsxy->Fill(bhabha.nhitsxyt2);

	    htnhitsz->Fill(bhabha.nhitszt1);
	    htnhitsz->Fill(bhabha.nhitszt2);

	    hmomt->Fill(bhabha.pt1);
	    hmomt->Fill(bhabha.pt2);
	    hmom->Fill(bhabha.p1);
	    hmom->Fill(bhabha.p2);

	    htchi2->Fill(bhabha.chi2t1);
	    htchi2->Fill(bhabha.chi2t2);

	    htheta->Fill(bhabha.thetat1);
	    htheta->Fill(bhabha.thetat2);

	    hphi->Fill(bhabha.phit1);
	    hphi->Fill(bhabha.phit2);

            htheta2t->Fill(bhabha.theta2t);
            hphi2t->Fill(bhabha.phi2t);

	    htnvec->Fill(bhabha.nvect1);
	    htnvec->Fill(bhabha.nvect2);

	    htnvecxy->Fill(bhabha.nvecxyt1);
	    htnvecxy->Fill(bhabha.nvecxyt2);

	    htnvecz->Fill(bhabha.nveczt1);
	    htnvecz->Fill(bhabha.nveczt2);

	    hnclst1->Fill(bhabha.ncls1);
	    heclst1->Fill(bhabha.ecls1);
	    htclst1->Fill(bhabha.tcls1);
	    hpclst1->Fill(bhabha.pcls1);

	    hnclst2->Fill(bhabha.ncls2);
	    heclst2->Fill(bhabha.ecls2);
	    htclst2->Fill(bhabha.tcls2);
	    hpclst2->Fill(bhabha.pcls2);

	    heclst12diff->Fill(bhabha.ecls1-bhabha.ecls2);

	    hncls->Fill(bhabha.ncls);
	    hnlkr->Fill(bhabha.nlkr);
	    hncsi->Fill(bhabha.ncsi);
	    henergy->Fill(bhabha.emcenergy);
	    hlkrenergy->Fill(bhabha.lkrenergy);
	    hcsienergy->Fill(bhabha.csienergy);

	    hep->Fill(bhabha.e1/bhabha.p1);
	    hep->Fill(bhabha.e2/bhabha.p2);

	    henass->Fill(bhabha.e1);
	    henass->Fill(bhabha.e2);

	    hnumn->Fill(bhabha.numn);
	    henn->Fill(bhabha.enn);
	    hnumo->Fill(bhabha.numo);
	    heno->Fill(bhabha.eno);

	    hMUnhits->Fill(bhabha.munhits);
	    hMUnhits1->Fill(bhabha.mulayerhits1);
	    hMUnhits2->Fill(bhabha.mulayerhits2);
	    hMUnhits3->Fill(bhabha.mulayerhits3);

            htofc1->Fill(bhabha.tofc1);
            httof1->Fill(bhabha.ttof1);
            htofc2->Fill(bhabha.tofc2);
	    httof2->Fill(bhabha.ttof2);

	}
    }

    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    gStyle->SetOptFit(1011);
    cc1->cd();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";

    hncomb->Draw(); cc1->SaveAs(KEDR + "ncomb" + format2);
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

    hncls->Draw(); cc1->SaveAs(KEDR+"ncls.png");
    hnlkr->Draw(); cc1->SaveAs(KEDR+"nlkr.png");
    hncsi->Draw(); cc1->SaveAs(KEDR+"ncsi.png");
    hep->Draw(); cc1->SaveAs(KEDR+"ep.png");

    htchi2->Draw(); cc1->SaveAs(KEDR+"tchi2.png");
    //*htchi2norm = htchi2->Clone();
    htchi2norm = (TH1F*) htchi2->Clone();
    Double_t a=htchi2norm->GetEntries();
    htchi2norm->Scale(1/a);
    htchi2norm->Draw(); cc1->SaveAs(KEDR+"tchi2_norm.png");
    htnhits->Draw(); cc1->SaveAs(KEDR+"tnhits.png");
    htnhitsvd->Draw(); cc1->SaveAs(KEDR+"tnhitsvd.png");
    htnhitsxy->Draw(); cc1->SaveAs(KEDR+"tnhitsxy.png");
    htnhitsz->Draw(); cc1->SaveAs(KEDR+"tnhitsz.png");
    htnvec->Draw(); cc1->SaveAs(KEDR+"tnvec.png");
    htnvecxy->Draw(); cc1->SaveAs(KEDR+"tnvecxy.png");
    htnvecz->Draw(); cc1->SaveAs(KEDR+"tnvecz.png");
    htheta->Draw(); cc1->SaveAs(KEDR+"theta.png");

    hthetadif->GetXaxis()->SetTitle("#Delta #theta");
    Double_t sc1=hthetadif->GetEntries();
    hthetadif->Scale(1/sc1);
    hthetadif->Fit("gaus","","",-1.0,1.0);
    /*
    TF1 *func3 = new TF1("fit3","[2]*(exp(-pow((x-[0]),2)/2./pow([1],2))+[4]*exp(-pow((x-[0]),2)/2./pow([3],2)))");
    func3->SetParameter(0,0.004);
    func3->SetParameter(1,3.5);
    func3->SetParameter(2,0.06);
    func3->SetParameter(3,0.90);
    func3->SetParameter(4,14.0);
    */
    /*//2004
    func3->SetParameter(0,0.004);
    func3->SetParameter(1,0.11);
    func3->SetParameter(2,0.06);
    func3->SetParameter(3,0.05);
    func3->SetParameter(4,0.8);
    */
    //hthetadif->Fit("fit3","","",-10.,10.);

    hthetadif->Draw(); cc1->SaveAs(KEDR+"thetadif.png"); cc1->SaveAs(KEDR+"thetadif.eps");

    hphi->Draw(); cc1->SaveAs(KEDR+"phi.png");

    hphidif->GetXaxis()->SetTitle("#Delta #phi");
    Double_t sc2=hphidif->GetEntries();
    hphidif->Scale(1/sc2);
    hphidif->Fit("gaus","","",-0.7,0.7);
    /*
    TF1 *func2 = new TF1("fit2","[2]*(exp(-pow((x-[0]),2)/2./pow([1],2))+[4]*exp(-pow((x-[0]),2)/2./pow([3],2)))");
    func2->SetParameter(0,0.004);
    func2->SetParameter(1,0.11);
    func2->SetParameter(2,0.06);
    func2->SetParameter(3,0.05);
    func2->SetParameter(4,0.8);
    hphidif->Fit("fit2","","",-4.,4.);
    */
    hphidif->Draw(); cc1->SaveAs(KEDR+"phidif.png"); cc1->SaveAs(KEDR+"phidif.eps");

    htheta2t->Draw(); cc1->SaveAs(KEDR+"theta2t.png");
    hphi2t->Draw(); cc1->SaveAs(KEDR+"phi2t.png");

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

    hpres->GetXaxis()->SetTitle("#Delta p_{t}/p_{t}");
    Double_t sc3=hpres->GetEntries();
    hpres->Scale(1/sc3);
    hpres->Fit("gaus","","",-0.20,0.20);
    /*
    TF1 *func1 = new TF1("fit1","[2]*(exp(-pow((x-[0]),2)/2./pow([1],2))+[4]*exp(-pow((x-[0]),2)/2./pow([3],2)))");
    func1->SetParameter(0,0.004);
    func1->SetParameter(1,0.11);
    func1->SetParameter(2,0.06);
    func1->SetParameter(3,0.05);
    func1->SetParameter(4,0.8);
    hpres->Fit("fit1","","",-1.,1.);
    */
    hpres->Draw();
    cc1->SaveAs(KEDR+"mom_res.png"); cc1->SaveAs(KEDR+"mom_res.eps");

    fout->Write();
    fout->Close();
}
