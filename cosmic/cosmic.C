#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <iostream>
#include <vector>
#include <algorithm>
#include "TGraph.h"
#include "TGraphErrors.h"

#include "cosmic.h"

#define PI 3.14159265358979

using namespace std;
string progname;

int Usage(string status)
{
	cout<<"Usage: "<<progname<<"\t"<<"Data (0 - 2016-17) or MC (1)  Verbose (0 or 1)"<<endl;
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
    int min_munhits=1;
    float min_p=500.; //MeV
    float max_p=3000.; //MeV
    float eclsCut=500.;
    float epCut1=0.0;
    float epCut2=10.0;
    float theta2tCut=174;
    float phi2tCut=165;

    if(key==0){
	//2016-17
	rrCut=6.0;
	zCut=15.;
	max_chi2=50.;
	min_nhits=23.;
        max_nhits=100.;
    }
    else{
	//2016-17  - sim
	rrCut=6.0;
	zCut=15.;
	max_chi2=50.;
	min_nhits=23.;
        max_nhits=100.;
	epCut1=0.0;
	epCut2=10.0;
        theta2tCut=178;
	phi2tCut=178;
    }

    //*****************************************

    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    TString fout_result;
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    if( key==0 ){           //exp 2016-17
	fnameout=TString::Format("exp_cosmic_data_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Cosmic/data/";
	list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    }
    else if (key==1)        //sig
    {
        //TString pref_out = "S1.0_A6.0_Z0.0";
        //TString pref_out = "S1.0_A7.2_Z0.2";
        //TString pref_out = "S1.0_A4.8_Z0.0";
        //TString pref_out = "S1.0_A6.9_Z0.0";
        TString pref_out = "S1.0_A5.1_Z0.0";
	fnameout= "sim_cosmic_sig_method2_" + pref_out + ".root";
        KEDR = "/home/ovtin/public_html/outDmeson/Cosmic/simulation_method2_" + pref_out + "/";
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

    TH1F* hncomb=new TH1F("ncomb","ncomb",150,-0.5,149.5);

    TH1F *hRun;
    if( key!=4 )
    {
	hRun = new TH1F("Run","Run", 1000, 23206., 26248.);
    }
    else
    {
	hRun = new TH1F("Run","Run", 500, 4100., 4709.);
    }

    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",100,1880.,1895.);

    TH1F* hrr=new TH1F("rr","rr",50,0.,6.);
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

    TH1F* hprescosm[20];
    TH1F* hthetadifcosm[20];
    TH1F* hphidifcosm[20];
    char name0[20];
    char name1[20];
    for (int j=0; j<=19; j++)
    {
	sprintf(name0,"hpres",j);
	sprintf(name1,"momres",j);
	hprescosm[j] = new TH1F(name0,name0,100,-1.0,1.0);
	hthetadifcosm[j] = new TH1F("htheta","#Delta #theta",100,-10.,10.);
        hphidifcosm[j] = new TH1F("hphi","#Delta #phi",100,-5.,5.);
    }

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
    float prescosm[20];
    double pcosm[20];

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

	if ( *std::find(badruns.begin(), badruns.end(), cosmic.Run) ) continue;        //skip bad runs

	if( (k %100000)==0 )cout<<k<<endl;

	if(k>0)
	{
	    tt->GetEntry(k-1);
	    runprev=cosmic.Run;
	}

	tt->GetEntry(k);

	if(
           //=======================================
	   cosmic.nhitst1>min_nhits && cosmic.nhitst2>min_nhits
	   && 1.<cosmic.thetat1/180.*PI<2.14 && 1.<cosmic.thetat2/180.*PI<2.14
           && cosmic.chi2t1<max_chi2 && cosmic.chi2t2<max_chi2
           //&& cosmic.theta2t>=165
           //&& cosmic.phi2t>=165
           && cosmic.rr1<rrCut && cosmic.rr2<rrCut
           && fabs(cosmic.zip1)<zCut && fabs(cosmic.zip2)<zCut
           && cosmic.pt1>50 && cosmic.pt2>50
	   && (cosmic.mulayerhits2+cosmic.mulayerhits3)>=min_munhits
           //&& cosmic.Run<24500
           //=======================================
          )
	{
	    if( cosmic.charge1==1 )
	    {
		pp=cosmic.p1;
		pm=cosmic.p2;
		tp=cosmic.thetat1/180.*PI;
		tm=cosmic.thetat2/180.*PI;
		phip=cosmic.phit1/180.*PI;
                phim=cosmic.phit2/180.*PI;
	    }
	    else
	    {
		pp=cosmic.p2;
		pm=cosmic.p1;
		tp=cosmic.thetat2/180.*PI;
		tm=cosmic.thetat1/180.*PI;
		phip=cosmic.phit2/180.*PI;
                phim=cosmic.phit1/180.*PI;
	    }

	    if ( verbose==1 )
	    {
                cout<<"<<<<<<<<<<<<<<<<<<<<  Next event  >>>>>>>>>>>>>>>>>>"<<endl;
                cout<<"Run="<<cosmic.Run<<"\t"<<"Event="<<cosmic.rEv<<endl;
		cout<<"p1="<<cosmic.p1<<"\t"<<"p2="<<cosmic.p2<<endl;
                /*
		cout<<"e1/p1="<<cosmic.e1/cosmic.p1<<"\t"<<"e2/p2="<<cosmic.e2/cosmic.p2<<endl;
		cout<<"(e1+e2)="<<cosmic.e1+cosmic.e2<<endl;
		cout<<"rr1="<<cosmic.rr1<<"\t"<<"rr2="<<cosmic.rr2<<"\t"<<endl;
		cout<<"zip1="<<cosmic.zip1<<"\t"<<"zip2="<<cosmic.zip2<<"\t"<<endl;
		cout<<"fabs(fabs(cosmic.zip1)-fabs(cosmic.zip2))="<<fabs(fabs(cosmic.zip1)-fabs(cosmic.zip2))<<endl;
		cout<<"cosmic.thetat1="<<cosmic.thetat1<<"\t"<<"cosmic.thetat2="<<cosmic.thetat2<<endl;
		cout<<"fabs(cosmic.thetat1-cosmic.thetat2)="<<fabs(cosmic.thetat1-cosmic.thetat2)<<endl;
                */
	    }

	    pres = (pm*sin(tm)-pp*sin(tp))/(sqrt(2.)*(pm*sin(tm)+pp*sin(tp))/2.);
	    hpres->Fill(pres);

            //cout<<tm*180./PI<<"\t"<<tp*180./PI<<"\t"<<tm+tp-PI<<"\t"<<(tm+tp-PI)*180./PI<<endl;
	    hthetadif->Fill((tm+tp-PI)*180./PI);
            //hphidif->Fill((fabs(phim-phip)-PI)*180./PI);
	    hphidif->Fill( TMath::Max(cosmic.phit1,cosmic.phit2)-TMath::Min(cosmic.phit1,cosmic.phit2)-180. );


	    for(int k=0; k<=19; k++ )
	    {
		if( (k*100 < (pp*sin(tp)+pm*sin(tm))/2) && ((pp*sin(tp)+pm*sin(tm))/2 < k*100+100) )
		{
		    prescosm[k] = (pm*sin(tm)-pp*sin(tp))/(sqrt(2.)*(pm*sin(tm)+pp*sin(tp))/2.);
		    hprescosm[k]->Fill(prescosm[k]);
                    //pcosm[k] = (pp*sin(tp)+pm*sin(tm))/2);
                    pcosm[k] = k*100;

		    hthetadifcosm[k]->Fill((tm+tp-PI)*180./PI);
		    hphidifcosm[k]->Fill( TMath::Max(cosmic.phit1,cosmic.phit2)-TMath::Min(cosmic.phit1,cosmic.phit2)-180. );
		}
	    }

	    hncomb->Fill(cosmic.ncomb);

	    hEbeam->Fill(cosmic.Ebeam);
	    hRun->Fill(cosmic.Run);

	    hrr->Fill(cosmic.rr1);
	    hrr->Fill(cosmic.rr2);
	    hZip->Fill(cosmic.zip1);
	    hZip->Fill(cosmic.zip2);

	    hvrtntrk->Fill(cosmic.vrtntrk);
	    hvrtnip->Fill(cosmic.vrtnip);
	    hvrtnbeam->Fill(cosmic.vrtnbeam);

	    htnhits->Fill(cosmic.nhitst1);
	    htnhits->Fill(cosmic.nhitst2);

	    htnhitsvd->Fill(cosmic.nhitsvdt1);
	    htnhitsvd->Fill(cosmic.nhitsvdt2);

	    htnhitsxy->Fill(cosmic.nhitsxyt1);
	    htnhitsxy->Fill(cosmic.nhitsxyt2);

	    htnhitsz->Fill(cosmic.nhitszt1);
	    htnhitsz->Fill(cosmic.nhitszt2);

	    hmomt->Fill(cosmic.pt1);
	    hmomt->Fill(cosmic.pt2);
	    hmom->Fill(cosmic.p1);
	    hmom->Fill(cosmic.p2);

	    htchi2->Fill(cosmic.chi2t1);
	    htchi2->Fill(cosmic.chi2t2);

	    htheta->Fill(cosmic.thetat1);
	    htheta->Fill(cosmic.thetat2);

	    hphi->Fill(cosmic.phit1);
	    hphi->Fill(cosmic.phit2);

            htheta2t->Fill(cosmic.theta2t);
            hphi2t->Fill(cosmic.phi2t);

	    htnvec->Fill(cosmic.nvect1);
	    htnvec->Fill(cosmic.nvect2);

	    htnvecxy->Fill(cosmic.nvecxyt1);
	    htnvecxy->Fill(cosmic.nvecxyt2);

	    htnvecz->Fill(cosmic.nveczt1);
	    htnvecz->Fill(cosmic.nveczt2);

	    hnclst1->Fill(cosmic.ncls1);
	    heclst1->Fill(cosmic.ecls1);
	    htclst1->Fill(cosmic.tcls1);
	    hpclst1->Fill(cosmic.pcls1);

	    hnclst2->Fill(cosmic.ncls2);
	    heclst2->Fill(cosmic.ecls2);
	    htclst2->Fill(cosmic.tcls2);
	    hpclst2->Fill(cosmic.pcls2);

	    heclst12diff->Fill(cosmic.ecls1-cosmic.ecls2);

	    hncls->Fill(cosmic.ncls);
	    hnlkr->Fill(cosmic.nlkr);
	    hncsi->Fill(cosmic.ncsi);
	    henergy->Fill(cosmic.emcenergy);
	    hlkrenergy->Fill(cosmic.lkrenergy);
	    hcsienergy->Fill(cosmic.csienergy);

	    hep->Fill(cosmic.e1/cosmic.p1);
	    hep->Fill(cosmic.e2/cosmic.p2);

	    henass->Fill(cosmic.e1);
	    henass->Fill(cosmic.e2);

	    hnumn->Fill(cosmic.numn);
	    henn->Fill(cosmic.enn);
	    hnumo->Fill(cosmic.numo);
	    heno->Fill(cosmic.eno);

	    hMUnhits->Fill(cosmic.munhits);
	    hMUnhits1->Fill(cosmic.mulayerhits1);
	    hMUnhits2->Fill(cosmic.mulayerhits2);
	    hMUnhits3->Fill(cosmic.mulayerhits3);

            htofc1->Fill(cosmic.tofc1);
            httof1->Fill(cosmic.ttof1);
            htofc2->Fill(cosmic.tofc2);
	    httof2->Fill(cosmic.ttof2);

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

    //======================================================================
    double pcosmres[20];
    double err_pcosmres[20];
    double thetadifcosmres[20];
    double err_thetadifcosmres[20];
    double phidifcosmres[20];
    double err_phidifcosmres[20];
    char namefit1[20];
    char namefit2[20];
    char namefit3[20];
    TF1* f1[20];
    TF1* f2[20];
    TF1* f3[20];
    for(int i=0; i<=19; i++)
    {
	sprintf(namefit1,"myfit",i);
	double bound1=-0.30;
	double bound2=0.30;
        /*
	if( key==0 && i==15 )
	{
	    bound1=-0.20;
	    bound2=0.20;
	}
	if( key==1 && i>=11 )
	{
	    bound1=-0.30;
	    bound2=0.35;
	}
	if( key==1 && i==14 )
	{
	    bound1=-0.25;
	    bound2=0.30;
	}
	if( key==1 && i>=15 )
	{
	    bound1=-0.35;
	    bound2=0.40;
	}
        */
        f1[i] = new TF1(namefit1,"gaus",bound1,bound2);
        /*
	f1[i] = new TF1(namefit1,"[2]*(exp(-pow((x-[0]),2)/2./pow([1],2))+[4]*exp(-pow((x-[0]),2)/2./pow([3],2)))");
	f1[i]->SetParameter(0,0.004);
	f1[i]->SetParameter(1,0.11);
	f1[i]->SetParameter(2,0.06);
	f1[i]->SetParameter(3,0.05);
	f1[i]->SetParameter(4,0.8);
        */
	hprescosm[i]->Fit(namefit1,"","",bound1,bound2);
        pcosmres[i]=f1[i]->GetParameter(2);
	err_pcosmres[i]=f1[i]->GetParError(2);
        /*
	pcosmres[i]=abs(f1[i]->GetParameter(3));
	err_pcosmres[i]=f1[i]->GetParError(3);
	if( abs(f1[i]->GetParameter(1))<abs(f1[i]->GetParameter(3)) )
	{
	    pcosmres[i]=abs(f1[i]->GetParameter(1));
	    err_pcosmres[i]=f1[i]->GetParError(1);
	}
        */
	cout<<"i="<<i<<"\t"<<"pcosmres="<<pcosmres[i]<<"\t"<<"err_pcosmres="<<err_pcosmres[i]<<endl;
	hprescosm[i]->Draw();
	cc1->SaveAs(KEDR+TString::Format("cosmpres%d.png",i).Data());

	sprintf(namefit2,"myfit2",i);
        f2[i] = new TF1(namefit2,"gaus",-1.0,1.0);
	hthetadifcosm[i]->Fit(namefit2);
        thetadifcosmres[i]=f2[i]->GetParameter(2);
	err_thetadifcosmres[i]=f2[i]->GetParError(2);
	hthetadifcosm[i]->Draw();
	cc1->SaveAs(KEDR+TString::Format("cosmthetadif%d.png",i).Data());

	sprintf(namefit3,"myfit3",i);
        f3[i] = new TF1(namefit3,"gaus",-0.7,0.7);
	hphidifcosm[i]->Fit(namefit3);
        phidifcosmres[i]=f3[i]->GetParameter(2);
	err_phidifcosmres[i]=f3[i]->GetParError(2);
	hphidifcosm[i]->Draw();
	cc1->SaveAs(KEDR+TString::Format("cosmphidif%d.png",i).Data());
    }

    TGraphErrors* gr1=new TGraphErrors(20,pcosm,pcosmres,0,err_pcosmres);
    //TGraphErrors* gr1=new TGraphErrors(14,pcosm,pcosmres,0,err_pcosmres);
    gr1->SetMarkerStyle(20);
    gr1->SetMarkerColor(4);
    gr1->SetLineWidth(2);
    gr1->SetLineColor(4);
    gr1->GetXaxis()->SetTitle("P_{t} (MeV/c)");
    gr1->GetYaxis()->SetTitle("#Delta p_{t}/p_{t}");
    gr1->SetName("gr1");
    gr1->Draw("ap");
    cc1->SaveAs(KEDR+"cosmpres_p.png");
    fout->WriteTObject(gr1);

    TGraphErrors* gr2=new TGraphErrors(20,pcosm,thetadifcosmres,0,err_thetadifcosmres);
    gr2->SetMarkerStyle(20);
    gr2->SetMarkerColor(4);
    gr2->SetLineWidth(2);
    gr2->SetLineColor(4);
    gr2->GetXaxis()->SetTitle("P_{t} (MeV/c)");
    gr2->GetYaxis()->SetTitle("#Delta #theta");
    gr2->SetName("gr2");
    gr2->Draw("ap");
    cc1->SaveAs(KEDR+"cosmthetadif_p.png");
    fout->WriteTObject(gr2);

    TGraphErrors* gr3=new TGraphErrors(20,pcosm,phidifcosmres,0,err_phidifcosmres);
    gr3->SetMarkerStyle(20);
    gr3->SetMarkerColor(4);
    gr3->SetLineWidth(2);
    gr3->SetLineColor(4);
    gr3->GetXaxis()->SetTitle("P_{t} (MeV/c)");
    gr3->GetYaxis()->SetTitle("#Delta #phi");
    gr3->SetName("gr3");
    gr3->Draw("ap");
    cc1->SaveAs(KEDR+"cosmphidif_p.png");
    fout->WriteTObject(gr3);

    //======================================================================
    fout->Write();
    fout->Close();
}
