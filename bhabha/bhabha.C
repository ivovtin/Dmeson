#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <iostream>
#include <vector>
#include <algorithm>

#include "bhabha.h"

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
	verbose=atoi(argv[2]);
	if( key>4 ){ Usage(progname); return 0;}
	if( key<0 ){ Usage(progname); return 0;}
    }
    else
    {
	Usage(progname);
    }

    //***************preselections*************
    int ntrk=2;
    int max_munhits=1;
    float min_pt=100.; //MeV
    float max_pt=2000.; //MeV
    float eclsCut=1000.;

    float rrCut,zCut,max_chi2,min_nhits,max_nhits;

    if(key!=1){
	//2016-17
	rrCut=0.5;
	zCut=13.;
	max_chi2=50.;
	min_nhits=24.;
        max_nhits=50.;
    }
    else{
        //2004
	rrCut=0.5;
	zCut=13.;
	max_chi2=50.;
	min_nhits=24.;
	max_nhits=48.;
	//max_nhits=50.;
    }
    //*****************************************

    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    TString fout_result;
    TString dir_out="results";
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    if( key==0 ){           //exp 2016-17
	fnameout=dir_out + "/" + TString::Format("exp_bhabha_data_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/BhaBha/data/";
	list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
	fout_result=dir_out + "/" + "bhabha_2016-17.dat";
    }
    else if (key==1)        //exp 2004
    {
	fnameout=dir_out + "/" + TString::Format("exp_bhabha_data2004_%d.root",key).Data();
	KEDR = "/home/ovtin/public_html/outDmeson/BhaBha/data2004/";
        list_badruns="/home/ovtin/development/Dmeson/runsbhabha/runs2004/badruns";
	fout_result=dir_out + "/" + "bhabha_2004.dat";
    }
    else if (key==2)        //sig
    {
	fnameout=dir_out + "/" + TString::Format("sim_bhabha_sig_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/BhaBha/simulation_Sig/";
	fout_result=dir_out + "/" + "bhabha_sim.dat";
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
    if( key==0 )
    {
	hRun = new TH1F("Run","Run", 100, 23206., 26248.);
    }
    else
    {
	hRun = new TH1F("Run","Run", 100, 4100., 4709.);
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

	if ( *std::find(badruns.begin(), badruns.end(), bhabha.Run) ) continue;        //skip bad runs

	if( (k %100000)==0 )cout<<k<<endl;

	if(k>0)
	{
	    tt->GetEntry(k-1);
	    runprev=bhabha.Run;
	    //cout<<"bhabha.run="<<bhabha.Run<<endl;
	}

	tt->GetEntry(k);

	if(
	   bhabha.vrtntrk>=ntrk
	   && bhabha.pt1>min_pt && bhabha.pt1<max_pt && bhabha.pt2>min_pt && bhabha.pt2<max_pt
	   && bhabha.chi2t1<max_chi2 && bhabha.chi2t2<max_chi2
	   && bhabha.nhitst1>=min_nhits && bhabha.nhitst2>=min_nhits
	   && bhabha.nhitst1<=max_nhits && bhabha.nhitst2<=max_nhits
	   && bhabha.rr1<rrCut && bhabha.rr2<rrCut
	   && fabs(bhabha.zip1)<zCut && fabs(bhabha.zip2)<zCut
	   && bhabha.ecls1<eclsCut && bhabha.ecls2<eclsCut
           && (bhabha.mulayerhits2+bhabha.mulayerhits3)<=max_munhits
	  )
	{

	    if ( verbose==1 )
	    {
		cout<<"p1="<<bhabha.p1<<"\t"<<"p2="<<bhabha.p2<<endl;
		cout<<"e1/p1="<<bhabha.e1/bhabha.p1<<"\t"<<"e2/p2="<<bhabha.e2/bhabha.p2<<endl;
		cout<<"(e1+e2)="<<bhabha.e1+bhabha.e2<<endl;
		cout<<"rr1="<<bhabha.rr1<<"\t"<<"rr2="<<bhabha.rr2<<"\t"<<endl;
		cout<<"zip1="<<bhabha.zip1<<"\t"<<"zip2="<<bhabha.zip2<<"\t"<<endl;
		cout<<"fabs(fabs(bhabha.zip1)-fabs(bhabha.zip2))="<<fabs(fabs(bhabha.zip1)-fabs(bhabha.zip2))<<endl;
		cout<<"bhabha.thetat1="<<bhabha.thetat1<<"\t"<<"bhabha.thetat2="<<bhabha.thetat2<<endl;
		cout<<"fabs(bhabha.thetat1-bhabha.thetat2)="<<fabs(bhabha.thetat1-bhabha.thetat2)<<endl;
	    }

	    hDncomb->Fill(bhabha.ncomb);

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

    hDncomb->Draw(); cc1->SaveAs(KEDR + "Dncomb" + format2);
    hnclst1->Draw(); cc1->SaveAs(KEDR + "nclst1" + format2);
    heclst1->Draw(); cc1->SaveAs(KEDR + "eclst1" + format2);
    htclst1->Draw(); cc1->SaveAs(KEDR + "tclst1" + format2);
    hpclst1->Draw(); cc1->SaveAs(KEDR + "pclst1" + format2);

    hnclst2->Draw(); cc1->SaveAs(KEDR + "nclst2" + format2);
    heclst2->Draw(); cc1->SaveAs(KEDR + "eclst2" + format2);
    htclst2->Draw(); cc1->SaveAs(KEDR + "tclst2" + format2);
    hpclst2->Draw(); cc1->SaveAs(KEDR + "pclst2" + format2);

    hnumn->Draw(); cc1->SaveAs(KEDR + "hnumn" + format2);
    henn->Draw(); cc1->SaveAs(KEDR + "henn" + format2);
    hnumo->Draw(); cc1->SaveAs(KEDR + "hnumo" + format2);
    heno->Draw(); cc1->SaveAs(KEDR + "heno" + format2);

    heclst12diff->Draw(); cc1->SaveAs(KEDR + "eclst12diff" + format2);

    hrr->Draw(); cc1->SaveAs(KEDR+"rr.png");
    hZip->Draw(); cc1->SaveAs(KEDR+"Zip.png");
    hEbeam->Draw(); cc1->SaveAs(KEDR+"Ebeam.png");
    hRun->Draw(); cc1->SaveAs(KEDR+"Run.png");
    henergy->Draw(); cc1->SaveAs(KEDR+"emc_energy.png");
    hlkrenergy->Draw(); cc1->SaveAs(KEDR+"lkrenergy.png");
    hcsienergy->Draw(); cc1->SaveAs(KEDR+"csienergy.png");
    henass->Draw(); cc1->SaveAs(KEDR+"emc_energy_ass.png");
    hmomt->Draw(); cc1->SaveAs(KEDR+"pt.png");
    hmom->Draw(); cc1->SaveAs(KEDR+"p.png");
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

    fout->Write();
    fout->Close();
}
