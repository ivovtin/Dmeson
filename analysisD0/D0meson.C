#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <vector>
#include <algorithm>

#include "D0meson.h"

using namespace std;
string progname;

int Usage(string status)
{
	cout<<"Usage: "<<progname<<"\t"<<"Data (0 - 2016-17, 4 - 2004) or MC (1 - Signal, 2 - BG continium, 3 - BG DD)"<<endl;
        exit(0);
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
    int ntrk=3;
    int max_munhits=2;
    float min_pt=100.; //MeV
    float max_pt=2000.; //MeV
    float min_Mbc=1700.;;
    if(key==1) min_Mbc=1800.;
    float max_Mbc=1900.;
    float min_dE=-300.;
    float max_dE=300.;
    float eclsCut=1000.;

    float rrCut,zCut,max_chi2,min_nhits,max_nhits;

    if(key!=4){
	//2016-17
	rrCut=0.75;
	zCut=13.;
	max_chi2=70.;
	min_nhits=20.;
        max_nhits=100.;
    }
    else{
        //2004
	rrCut=0.5;
	zCut=12.;
	max_chi2=50.;
	min_nhits=24.;
	max_nhits=50.;
    }
    //*****************************************

    double deCut1, deCut2;
    double mbcCut1, mbcCut2;

    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    TString fout_result;
    TString dir_out="results";
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    if( key==0 ){           //exp 2016-17
	min_Mbc=1700;
	deCut1=-100; deCut2=100;
	mbcCut1=1855, mbcCut2=1875;
	fnameout=dir_out + "/" + TString::Format("exp_Dmeson_data_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v9/";
	list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
	fout_result=dir_out + "/" + "kp_2016-17.dat";
    }
    else if (key==4)        //exp 2004
    {
        min_Mbc=1700;
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
    if(verbose) cout<<"Nentries="<<nentr<<endl;

    setbranchstatus();
    setbranchaddress();

    TH1F* hDncomb=new TH1F("Dmseon.ncomb","Dmseon.ncomb",150,-0.5,149.5);
    TH1F* henergy=new TH1F("Energy","Energy EMC",100,0.,4500.);
    TH1F* hlkrenergy=new TH1F("E_LKr","Energy LKr",100,0.,4500.);
    TH1F* hcsienergy=new TH1F("E_CsI","Energy CsI",100,0.,4500.);
    TH1F* hncls=new TH1F("ncls","emc.ncls",20,-0.5,19.5);
    TH1F* hnlkr=new TH1F("nlkr","emc.nlkr",20,-0.5,19.5);
    TH1F* hncsi=new TH1F("ncsi","emc.ncsi",20,-0.5,19.5);
    TH1F* hep=new TH1F("Etop","E/p",100,-0.5,3.5);
    TH1F* hmbc=new TH1F("Mbc","Mbc",100,0.,2000.);
    TH1F* hmbc_zoom;
    TH1F* hmbckin_zoom;
    if( key==0 || key==4 || key==1){
	hmbc_zoom=new TH1F("M_{bc}","M_{bc}",50,1800.,1900.);
	hmbckin_zoom=new TH1F("M_{bc}","M_{bc}",50,1800.,1900.);
    }
    else{
	hmbc_zoom=new TH1F("M_{bc}","M_{bc}",50,1700.,1900.);
	hmbckin_zoom=new TH1F("M_{bc}","M_{bc}",50,1700.,1900.);
    }
    TH1F* hrr=new TH1F("rr","rr",50,0.,3.);
    TH1F* hZip=new TH1F("ZIP","ZIP",100,-50.,50.);
    TH1F* henass=new TH1F("Energy ass","Energy ass",100,0.,4500.);
    TH1F* hepmkp=new TH1F("epmkp","epmkp",100,-400.,400.);
    TH1F* heppkm=new TH1F("eppkm","eppkm",100,-400.,400.);
    TH1F* hdiffepmkpeppkm=new TH1F("depmkp-deppkm","depmkp-deppkm",100,-100.,100.);
    TH2D *h2depmkpdeppkm=new TH2D("depmkp:deppkm", "depmkp:deppkm", 100,-300,300,100,-300,300);
    TH1F* hdE=new TH1F("#Delta E","#Delta E",200,-2000.,2000.);
    TH1F* hdE_zoom=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdEkin_zoom=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdP=new TH1F("#Delta P","#Delta P",200,-1000.,1000.);
    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",100,1880.,1895.);
    TH2D *h2PpiktodEkpi=new TH2D("Ppik:dekmpip", "Ppik:dekmpip", 200,600,1100,200,-250,250);
    TH2D *h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 100,min_Mbc,1900,100,-300,300);
    TH2D *h2MbcdEkin=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 100,min_Mbc,1900,100,-300,300);
    TH2D *h2MbcdP=new TH2D("M_{bc}:#Delta P", "M_{bc}:#Delta P", 200,-500,500,200,1825,1890);
    TH2D *h2MbckindP=new TH2D("M_{bc}:#Delta P", "M_{bc}:#Delta P", 200,-500,500,200,1825,1890);

    TH1F *hRun;
    if( key==0 )
    {
	hRun = new TH1F("Run","Run", 100, 23206., 26248.);
    }
    else
    {
	hRun = new TH1F("Run","Run", 100, 4100., 4709.);
    }

    TH1F* hnclst1=new TH1F("nclst1","nclst1",6,-0.5,5.5);
    TH1F* heclst1=new TH1F("eclst1","eclst1",100,0.,2500.);
    TH1F* htclst1=new TH1F("tclst1","tclst1",100,-30.,30.);
    TH1F* hpclst1=new TH1F("pclst1","pclst1",100,-20.,20.);

    TH1F* hnclst2=new TH1F("nclst2","nclst2",6,-0.5,5.5);
    TH1F* heclst2=new TH1F("eclst2","eclst2",100,0.,2500.);
    TH1F* htclst2=new TH1F("tclst2","tclst2",100,-30.,30.);
    TH1F* hpclst2=new TH1F("pclst2","pclst2",100,-20.,20.);

    TH1F* heclst12diff=new TH1F("eclst12diff","eclst2",100,-1500.,1500.);

    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",15,-0.5,14.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",12,-0.5,11.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",12,-0.5,11.5);

    TH1F* hmom=new TH1F("Pt","Pt",100,0.,3000.);
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

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

	if ( *find(badruns.begin(), badruns.end(), Dmeson.Run) ) continue;        //skip bad runs
	//if ( *std::find(badruns.begin(), badruns.end(), Dmeson.Run) ) { cout<<"bad run="<<Dmeson.Run<<endl;};        //skip bad runs
        //cout<<"bad run="<<*find(badruns.begin(), badruns.end(), Dmeson.Run)<<endl;

	if( (k %100000)==0 )cout<<k<<endl;

	//if( (key==0 || key==4) && Dmeson.vrtntrk==2 &&  Dmeson.theta2t>172 && Dmeson.phi2t>172 ) continue;

	if(
	   Dmeson.dE>=min_dE && Dmeson.dE<=max_dE
           //&& Dmeson.Mbckin>=min_Mbc && Dmeson.Mbckin<=max_Mbc
           //&& Dmeson.Mbc>=min_Mbc && Dmeson.Mbc<=max_Mbc
	   && Dmeson.vrtntrk>=ntrk
	   && Dmeson.Pt1>min_pt && Dmeson.Pt1<max_pt && Dmeson.Pt2>min_pt && Dmeson.Pt2<max_pt
	   && Dmeson.chi2t1<max_chi2 && Dmeson.chi2t2<max_chi2
	   && Dmeson.nhitst1>=min_nhits && Dmeson.nhitst2>=min_nhits
	   && Dmeson.rr1<rrCut && Dmeson.rr2<rrCut
	   && abs(Dmeson.Zip1)<zCut && abs(Dmeson.Zip2)<zCut
	   //&& abs(Dmeson.Zip1-Dmeson.Zip2)<zCut
	   && Dmeson.ecls1<eclsCut && Dmeson.ecls2<eclsCut
           //&& abs(Dmeson.ecls2-Dmeson.ecls1)<500
	   && Dmeson.nhitst1<=max_nhits && Dmeson.nhitst2<=max_nhits
           //&& Dmeson.munhits<=max_munhits
           && (Dmeson.mulayerhits2+Dmeson.mulayerhits3)<=max_munhits
	  )
	{
	    if ( verbose )
	    {
		cout<<"P1="<<Dmeson.P1<<"\t"<<"P2="<<Dmeson.P2<<endl;
		cout<<"e1/P1="<<Dmeson.e1/Dmeson.P1<<"\t"<<"e2/P2="<<Dmeson.e2/Dmeson.P2<<endl;
		cout<<"(e1+e2)="<<Dmeson.e1+Dmeson.e2<<endl;
		cout<<"rr1="<<Dmeson.rr1<<"\t"<<"rr2="<<Dmeson.rr2<<"\t"<<endl;
		cout<<"Zip1="<<Dmeson.Zip1<<"\t"<<"Zip2="<<Dmeson.Zip2<<"\t"<<endl;
		cout<<"fabs(fabs(Dmeson.Zip1)-fabs(Dmeson.Zip2))="<<fabs(fabs(Dmeson.Zip1)-fabs(Dmeson.Zip2))<<endl;
	    }

	    hDncomb->Fill(Dmeson.ncomb);

	    hEbeam->Fill(Dmeson.Ebeam);
	    hRun->Fill(Dmeson.Run);

	    hrr->Fill(Dmeson.rr1);
	    hrr->Fill(Dmeson.rr2);
	    hZip->Fill(Dmeson.Zip1);
	    hZip->Fill(Dmeson.Zip2);

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

	    hmom->Fill(Dmeson.Pt1);
	    hmom->Fill(Dmeson.Pt2);

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

	    h2PpiktodEkpi->Fill( Dmeson.P1, (Dmeson.eppkm-Dmeson.Ebeam) );

	    hep->Fill(Dmeson.e1/Dmeson.P1);
	    hep->Fill(Dmeson.e2/Dmeson.P2);

	    henass->Fill(Dmeson.e1);
	    henass->Fill(Dmeson.e2);

	    hMUnhits->Fill(Dmeson.munhits);
	    hMUnhits1->Fill(Dmeson.mulayerhits1);
	    hMUnhits2->Fill(Dmeson.mulayerhits2);
	    hMUnhits3->Fill(Dmeson.mulayerhits3);

	    hmbc->Fill(Dmeson.Mbc);
	    hdE->Fill(Dmeson.dE);

	    if( Dmeson.dE>=min_dE && Dmeson.dE<=max_dE  &&  Dmeson.Mbckin>=min_Mbc && Dmeson.Mbckin<=max_Mbc )
	    {
		if ( verbose )
		{
		    cout<<Dmeson.Mbckin<<"\t"<<Dmeson.dE<<"\t"<<Dmeson.dP<<endl;
		}
		Result<< Dmeson.Mbckin <<"\t"<< Dmeson.dE <<"\t"<< Dmeson.dP <<endl;
	    }

	    //fill dE
	    if( Dmeson.Mbc>=mbcCut1 && Dmeson.Mbc<=mbcCut2 )
	    {
		hdE_zoom->Fill(Dmeson.dE);
	    }

	    if( Dmeson.Mbckin>=mbcCut1 && Dmeson.Mbckin<=mbcCut2 )
	    {
		hdEkin_zoom->Fill(Dmeson.dE);
	    }

            //fill Mbc
	    if( Dmeson.dE>=deCut1 && Dmeson.dE<=deCut2 &&  Dmeson.Mbc>=min_Mbc && Dmeson.Mbc<=max_Mbc )
	    {
		hmbc_zoom->Fill(Dmeson.Mbc);
	    }
	    if( Dmeson.dE>=deCut1 && Dmeson.dE<=deCut2  &&  Dmeson.Mbckin>=min_Mbc && Dmeson.Mbckin<=max_Mbc )
	    {
		hmbckin_zoom->Fill(Dmeson.Mbckin);
	    }

            //--
	    if( Dmeson.Mbc>=min_Mbc && Dmeson.Mbc<=max_Mbc )
	    {
		h2MbcdE->Fill(Dmeson.Mbc, Dmeson.dE);
		h2MbcdP->Fill(Dmeson.dP, Dmeson.Mbc);
	    }
	    if( Dmeson.Mbckin>=min_Mbc && Dmeson.Mbckin<=max_Mbc )
	    {
		h2MbcdEkin->Fill(Dmeson.Mbckin, Dmeson.dE);
		h2MbckindP->Fill(Dmeson.dP, Dmeson.Mbckin);
	    }

	    hepmkp->Fill(Dmeson.epmkp-Dmeson.Ebeam);
	    heppkm->Fill(Dmeson.eppkm-Dmeson.Ebeam);

	    hdiffepmkpeppkm->Fill((Dmeson.epmkp-Dmeson.Ebeam)-(Dmeson.eppkm-Dmeson.Ebeam));
	    h2depmkpdeppkm->Fill( (Dmeson.epmkp-Dmeson.Ebeam), (Dmeson.eppkm-Dmeson.Ebeam) );

	    hdP->Fill(Dmeson.dP);

	    forFitMbc=Dmeson.Mbckin;
	    forFitdE=Dmeson.dE;
	    forFitdP=Dmeson.dP;
	    forFit->Fill();

	    if(verbose) cout<<"Dmeson.Mbc="<<Dmeson.Mbc<<"\t"<<"Dmeson.Mbckin="<<Dmeson.Mbckin<<"\t"<<"Dmeson.dE="<<Dmeson.dE<<"\t"<<endl;
	}
    }
    Result.close();


    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    gStyle->SetOptFit(1011);
    cc1->cd();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString nameMbc, nameMbc_zoom, nameMbckin_zoom, nameMbcdE, nameMbcdEkin, nameMbcdP, nameMbckindP, namedE, namedE_zoom, namedEkin_zoom, namedP;
    nameMbc = "Mbc_full";
    nameMbc_zoom = "Mbc_zoom";
    nameMbckin_zoom = "Mbckin_zoom";
    nameMbcdE = "MbcdE";
    nameMbcdEkin = "MbcdEkin";
    nameMbcdP = "MbcdP";
    nameMbckindP = "MbckindP";
    namedE = "dE";
    namedE_zoom = "dE_zoom";
    namedEkin_zoom = "dEkin_zoom";
    namedP = "dP";

    hmbc->Draw("E1"); cc1->SaveAs(KEDR + nameMbc + format1);  cc1->SaveAs(KEDR + nameMbc + format2);   cc1->SaveAs(KEDR + nameMbc + format3);
    hmbc_zoom->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbc_zoom->GetYaxis()->SetTitle("Events/2 MeV");
    hmbc_zoom->Draw("E1"); cc1->SaveAs(KEDR + nameMbc_zoom + format1); cc1->SaveAs(KEDR + nameMbc_zoom + format2); cc1->SaveAs(KEDR + nameMbc_zoom + format3);
    hmbckin_zoom->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbckin_zoom->GetYaxis()->SetTitle("Events/2 MeV");
    hmbckin_zoom->Draw("E1"); cc1->SaveAs(KEDR + nameMbckin_zoom + format1); cc1->SaveAs(KEDR + nameMbckin_zoom + format2); cc1->SaveAs(KEDR + nameMbckin_zoom + format3);
    h2MbcdE->GetXaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdE->GetYaxis()->SetTitle("#Delta E (MeV)");
    h2MbcdE->Draw(); cc1->SaveAs(KEDR + nameMbcdE + format1); cc1->SaveAs(KEDR + nameMbcdE + format2);  cc1->SaveAs(KEDR + nameMbcdE + format3);

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
    h2MbcdEkin->GetXaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdEkin->GetYaxis()->SetTitle("#Delta E (MeV)");
    h2MbcdEkin->Draw("same");
    cc1->SaveAs(KEDR + nameMbcdEkin + format1); cc1->SaveAs(KEDR + nameMbcdEkin + format2);  cc1->SaveAs(KEDR + nameMbcdEkin + format3);

    h2MbcdP->GetXaxis()->SetTitle("#Delta P (MeV)");
    h2MbcdP->GetYaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdP->Draw(); cc1->SaveAs(KEDR + nameMbcdP + format1); cc1->SaveAs(KEDR + nameMbcdP + format2);  cc1->SaveAs(KEDR + nameMbcdP + format3);
    h2MbckindP->GetXaxis()->SetTitle("#Delta P (MeV)");
    h2MbckindP->GetYaxis()->SetTitle("M_{bc} (MeV)");
    h2MbckindP->Draw(); cc1->SaveAs(KEDR + nameMbckindP + format1); cc1->SaveAs(KEDR + nameMbckindP + format2);  cc1->SaveAs(KEDR + nameMbckindP + format3);
    hdE->Draw("E1"); cc1->SaveAs(KEDR + namedE + format1); cc1->SaveAs(KEDR + namedE + format2); cc1->SaveAs(KEDR + namedE + format3);
    hdE_zoom->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE_zoom->GetYaxis()->SetTitle("Events/20 MeV");
    hdE_zoom->Draw("E1"); cc1->SaveAs(KEDR + namedE_zoom + format1); cc1->SaveAs(KEDR + namedE_zoom + format2); cc1->SaveAs(KEDR + namedE_zoom + format3);
    hdEkin_zoom->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdEkin_zoom->GetYaxis()->SetTitle("Events/20 MeV");
    hdEkin_zoom->Draw("E1"); cc1->SaveAs(KEDR + namedEkin_zoom + format1); cc1->SaveAs(KEDR + namedEkin_zoom + format2); cc1->SaveAs(KEDR + namedEkin_zoom + format3);
    hdP->GetXaxis()->SetTitle("#Delta P (MeV)");
    hdP->Draw(); cc1->SaveAs(KEDR + namedP + format1);  cc1->SaveAs(KEDR + namedP + format2); cc1->SaveAs(KEDR + namedP + format3);
    hepmkp->Draw(); cc1->SaveAs(KEDR+"epmkp.png");
    heppkm->Draw(); cc1->SaveAs(KEDR+"eppkm.png");
    hdiffepmkpeppkm->Draw(); cc1->SaveAs(KEDR+"diffepmkpeppkm.png");
    h2depmkpdeppkm->Draw(); cc1->SaveAs(KEDR+"depmkpdeppkm.png");
    hDncomb->Draw(); cc1->SaveAs(KEDR + "Dncomb" + format2);

    hnclst1->Draw(); cc1->SaveAs(KEDR + "nclst1" + format2);
    heclst1->Draw(); cc1->SaveAs(KEDR + "eclst1" + format2);
    htclst1->Draw(); cc1->SaveAs(KEDR + "tclst1" + format2);
    hpclst1->Draw(); cc1->SaveAs(KEDR + "pclst1" + format2);

    hnclst2->Draw(); cc1->SaveAs(KEDR + "nclst2" + format2);
    heclst2->Draw(); cc1->SaveAs(KEDR + "eclst2" + format2);
    htclst2->Draw(); cc1->SaveAs(KEDR + "tclst2" + format2);
    hpclst2->Draw(); cc1->SaveAs(KEDR + "pclst2" + format2);

    heclst12diff->Draw(); cc1->SaveAs(KEDR + "eclst12diff" + format2);

    hrr->Draw(); cc1->SaveAs(KEDR+"rr.png");
    hZip->Draw(); cc1->SaveAs(KEDR+"Zip.png");
    hEbeam->Draw(); cc1->SaveAs(KEDR+"Ebeam.png");
    hRun->Draw(); cc1->SaveAs(KEDR+"Run.png");
    henergy->Draw(); cc1->SaveAs(KEDR+"emc_energy.png");
    hlkrenergy->Draw(); cc1->SaveAs(KEDR+"lkrenergy.png");
    hcsienergy->Draw(); cc1->SaveAs(KEDR+"csienergy.png");
    henass->Draw(); cc1->SaveAs(KEDR+"emc_energy_ass.png");
    h2PpiktodEkpi->Draw(); cc1->SaveAs(KEDR+"PpiktodEkpi.png");
    TProfile *proPpiktodEkpi = h2PpiktodEkpi->ProfileX();
    proPpiktodEkpi->GetXaxis()->SetRangeUser(750,1000); proPpiktodEkpi->GetYaxis()->SetRangeUser(-50,30); proPpiktodEkpi->Draw(); cc1->SaveAs(KEDR+"proPpiktodEkpi.png");
    hmom->Draw(); cc1->SaveAs(KEDR+"pt.png");
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
