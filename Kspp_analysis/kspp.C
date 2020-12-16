#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <iostream>
#include <vector>
#include <algorithm>

#include "kspp.h"

#define PI 3.14159265358979

using namespace std;
string progname;

int Usage(string status)
{
	cout<<"Usage: "<<progname<<"\t"<<"Data (0 - 2016-17, 1 - 2004) or MC (2)  Verbose (0 or 1)"<<endl;
        exit(0);
}

double msf = 1;
double xcorr = 0;
double scorr = 0;

double pcorr(double p, int type, double ran)
{
    double ms, dedx, k;

    if (type==1) {    //pion
	ms = 134.7;
	dedx = 1.74;
	k = 0.;
    }
    else if(type==2)
    { //kaon
	ms = 228.;
	dedx = 3.095;
	k = 0.;
    }
    else{                //electron
	ms = 0.;
	dedx = 1.24;
	k = 0.29286e-2;
    }
    double gamma = sqrt(ms*ms+p*p)/ms;

    double beta = sqrt(1.-1./gamma/gamma);

    double pc = p+1.*dedx/pow(beta,3) + k*p;

    pc = pc*fabs(msf)*(1.+ran*sqrt(scorr*scorr+pow(xcorr*p/1000.,2)));

    return fabs(pc);
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
	if( key>2 ){ Usage(progname); return 0;}
	if( key<0 ){ Usage(progname); return 0;}
    }
    else
    {
	Usage(progname);
    }

    //***************preselections*************
    int ntrk=3;
    float min_p=100.; //MeV
    float max_p=1600.; //MeV

    float rCut1,rCut2,rrCut,zCut,max_chi2,min_nhits,max_nhits;

    if(key!=1){
	//2016-17
	rCut1=0.5;
	rCut2=20.;
	rrCut=0.0;
	zCut=13.;
	max_chi2=50.;
	min_nhits=24.;
	max_nhits=1000.;
    }
    else{
        //2004
	rCut1=0.5;
	rCut2=20.;
	rrCut=0.0;
	zCut=13.;
	max_chi2=50.;
	min_nhits=24.;
	max_nhits=1000.;
    }
    //*****************************************

    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    TString fout_result;
    TString list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    if( key==0 ){           //exp 2016-17
	fnameout=TString::Format("exp_kspp_data_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Kspp/data/";
	list_badruns="/home/ovtin/development/Dmeson/runsDmeson/sig_runs/badruns";
    }
    else if (key==1)        //exp 2004
    {
	fnameout=TString::Format("exp_kspp_data2004_%d.root",key).Data();
	KEDR = "/home/ovtin/public_html/outDmeson/Kspp/data2004/";
        list_badruns="/home/ovtin/development/Dmeson/runsDmeson/runs2004/badruns";
    }
    else if (key==2)        //sig
    {
	fnameout=TString::Format("sim_kspp_sig_%d.root",key).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Kspp/simulation_Sig/";
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
    if( key==0 )
    {
	hRun = new TH1F("Run","Run", 100, 23206., 26248.);
    }
    else
    {
	hRun = new TH1F("Run","Run", 100, 4100., 4709.);
    }

    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",100,1880.,1895.);

    TH1F* hr=new TH1F("r","r",50,0.,20.);
    TH1F* hrr=new TH1F("rr","rr",50,0.,10.);
    TH1F* hZip=new TH1F("zip","zip",100,-50.,50.);
    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",15,-0.5,14.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",12,-0.5,11.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",12,-0.5,11.5);
    TH1F* hinvM=new TH1F("invM","invM",100,400.,600.);
    TH1F* hinvMcor=new TH1F("invMcor","invMcor",100,400.,600.);
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

    TH1F* hpres=new TH1F("hpres","momres",100,-0.5,0.5);

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

	if ( *std::find(badruns.begin(), badruns.end(), ks.Run) ) continue;        //skip bad runs

	if( (k %100000)==0 )cout<<k<<endl;

	if(k>0)
	{
	    tt->GetEntry(k-1);
	    runprev=ks.Run;
	    //cout<<"ks.run="<<ks.Run<<endl;
	}

	tt->GetEntry(k);

	if(
	   ks.vrtntrk>=ntrk
	   && ks.p1>min_p && ks.p1<max_p && ks.p2>min_p && ks.p2<max_p
	   && ks.chi2t1<max_chi2 && ks.chi2t2<max_chi2
	   && ks.nhitst1>=min_nhits && ks.nhitst1<=max_nhits
	   && ks.r>rCut1 && ks.r<rCut2
	   && ks.rr1>rrCut && ks.rr2>rrCut
	   && fabs(ks.zip1)<zCut && fabs(ks.zip2)<zCut
	   && -1.<abs(ks.zip1-ks.zip2)<3.
	  )
	{
	    pm=ks.p1;
	    pp=ks.p2;
	    tm=ks.thetat1/180.*PI;
	    tp=ks.thetat2/180.*PI;
	    phim=ks.phit1/180.*PI;
	    phip=ks.phit2/180.*PI;

	    if ( fabs((fabs(phip-phim)-PI)*180./PI) < 0.10 ) continue;

	    if ( verbose==1 )
	    {
		cout<<"p1="<<ks.p1<<"\t"<<"p2="<<ks.p2<<endl;
		cout<<"e1/p1="<<ks.e1/ks.p1<<"\t"<<"e2/p2="<<ks.e2/ks.p2<<endl;
		cout<<"(e1+e2)="<<ks.e1+ks.e2<<endl;
		cout<<"rr1="<<ks.rr1<<"\t"<<"rr2="<<ks.rr2<<"\t"<<endl;
		cout<<"zip1="<<ks.zip1<<"\t"<<"zip2="<<ks.zip2<<"\t"<<endl;
		cout<<"fabs(fabs(ks.zip1)-fabs(ks.zip2))="<<fabs(fabs(ks.zip1)-fabs(ks.zip2))<<endl;
		cout<<"ks.thetat1="<<ks.thetat1<<"\t"<<"ks.thetat2="<<ks.thetat2<<endl;
		cout<<"fabs(ks.thetat1-ks.thetat2)="<<fabs(ks.thetat1-ks.thetat2)<<endl;
	    }

            double pxm, pym, pzm, em, pxp, pyp, pzp, ep, mom, invm;

	    double pmcorr = pcorr(pm*sin(tm),1,0)/sin(tm);
	    double ppcorr = pcorr(pp*sin(tp),1,0)/sin(tp);

	    pxm = pmcorr*sin(tm)*cos(phim);
	    pym = pmcorr*sin(tm)*sin(phim);
	    pzm = pmcorr*cos(tm);
	    em = sqrt(pow(139.57,2) + pow(pmcorr,2));

	    pxp = ppcorr*sin(tp)*cos(phip);
	    pyp = ppcorr*sin(tp)*sin(phip);
	    pzp = ppcorr*cos(tp);
	    ep = sqrt(pow(139.57,2) + pow(ppcorr,2));

	    mom = sqrt(pow((pxm+pxp),2) + pow((pym+pyp),2) + pow((pzm+pzp),2));

            if ( mom<=0. ) continue;

	    invm = pow((em+ep),2) - pow((pxm+pxp),2) - pow((pym+pyp),2) - pow((pzm+pzp),2);
	    invm = sqrt(invm);

	    hinvMcor->Fill(invm);
	    hinvM->Fill(ks.invM);

	    pres = (pm*sin(tm)-pp*sin(tp))/(sqrt(2.)*(pm*sin(tm)+pp*sin(tp))/2.);

	    hpres->Fill(pres);

	    hthetadif->Fill((tm+tp-PI)*180./PI);
	    hphidif->Fill((fabs(phim-phip)-PI)*180./PI);

	    hncomb->Fill(ks.ncomb);

	    hEbeam->Fill(ks.Ebeam);
	    hRun->Fill(ks.Run);

	    hr->Fill(ks.r);
	    hrr->Fill(ks.rr1);
	    hrr->Fill(ks.rr2);
	    hZip->Fill(ks.zip1);
	    hZip->Fill(ks.zip2);

	    hvrtntrk->Fill(ks.vrtntrk);
	    hvrtnip->Fill(ks.vrtnip);
	    hvrtnbeam->Fill(ks.vrtnbeam);

	    htnhits->Fill(ks.nhitst1);
	    htnhits->Fill(ks.nhitst2);

	    htnhitsvd->Fill(ks.nhitsvdt1);
	    htnhitsvd->Fill(ks.nhitsvdt2);

	    htnhitsxy->Fill(ks.nhitsxyt1);
	    htnhitsxy->Fill(ks.nhitsxyt2);

	    htnhitsz->Fill(ks.nhitszt1);
	    htnhitsz->Fill(ks.nhitszt2);

	    hmomt->Fill(ks.pt1);
	    hmomt->Fill(ks.pt2);
	    hmom->Fill(ks.p1);
	    hmom->Fill(ks.p2);

	    htchi2->Fill(ks.chi2t1);
	    htchi2->Fill(ks.chi2t2);

	    htheta->Fill(ks.thetat1);
	    htheta->Fill(ks.thetat2);

	    hphi->Fill(ks.phit1);
	    hphi->Fill(ks.phit2);

            htheta2t->Fill(ks.theta2t);
            hphi2t->Fill(ks.phi2t);

	    htnvec->Fill(ks.nvect1);
	    htnvec->Fill(ks.nvect2);

	    htnvecxy->Fill(ks.nvecxyt1);
	    htnvecxy->Fill(ks.nvecxyt2);

	    htnvecz->Fill(ks.nveczt1);
	    htnvecz->Fill(ks.nveczt2);

	    hnclst1->Fill(ks.ncls1);
	    heclst1->Fill(ks.ecls1);
	    htclst1->Fill(ks.tcls1);
	    hpclst1->Fill(ks.pcls1);

	    hnclst2->Fill(ks.ncls2);
	    heclst2->Fill(ks.ecls2);
	    htclst2->Fill(ks.tcls2);
	    hpclst2->Fill(ks.pcls2);

	    heclst12diff->Fill(ks.ecls1-ks.ecls2);

	    hncls->Fill(ks.ncls);
	    hnlkr->Fill(ks.nlkr);
	    hncsi->Fill(ks.ncsi);
	    henergy->Fill(ks.emcenergy);
	    hlkrenergy->Fill(ks.lkrenergy);
	    hcsienergy->Fill(ks.csienergy);

	    hep->Fill(ks.e1/ks.p1);
	    hep->Fill(ks.e2/ks.p2);

	    henass->Fill(ks.e1);
	    henass->Fill(ks.e2);

	    hnumn->Fill(ks.numn);
	    henn->Fill(ks.enn);
	    hnumo->Fill(ks.numo);
	    heno->Fill(ks.eno);

	    hMUnhits->Fill(ks.munhits);
	    hMUnhits1->Fill(ks.mulayerhits1);
	    hMUnhits2->Fill(ks.mulayerhits2);
	    hMUnhits3->Fill(ks.mulayerhits3);

            htofc1->Fill(ks.tofc1);
            httof1->Fill(ks.ttof1);
            htofc2->Fill(ks.tofc2);
	    httof2->Fill(ks.ttof2);

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

    hr->Draw(); cc1->SaveAs(KEDR+"r.png");
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
    hthetadif->GetXaxis()->SetTitle("#Delta #theta");
    Double_t sc1=hthetadif->GetEntries();
    hthetadif->Scale(1/sc1);
    hthetadif->Fit("gaus","","",-1.8,1.8);
    hthetadif->Draw(); cc1->SaveAs(KEDR+"thetadif.png"); cc1->SaveAs(KEDR+"thetadif.eps");
    hphi->Draw(); cc1->SaveAs(KEDR+"phi.png");
    hphidif->GetXaxis()->SetTitle("#Delta #phi");
    Double_t sc2=hphidif->GetEntries();
    hphidif->Scale(1/sc2);
    hphidif->Fit("gaus","","",-0.9,0.9);
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

    TF1 *func1 = new TF1("fitInvM1","[2]*(1+[1]*(x-500.)+[5]*pow((x-500.),2))*([0]+exp(-pow((x-[4]),2)/2./pow([3],2))/sqrt(2*3.141592)/[3]*(600-400)/100)");
    /*
    func1->SetParameter(0,0.05);
    func1->SetParameter(1,-0.2);
    func1->SetParameter(2,1000.);
    func1->SetParameter(3,8.);
    func1->SetParameter(4,498.);
    func1->SetParameter(5,0.);
    */
    func1->SetParameter(0,1.39401e-01);
    func1->SetParameter(1,-1.11893e-03);
    func1->SetParameter(2,3.81878e+03);
    func1->SetParameter(3,1.32897e+01);
    func1->SetParameter(4,4.93039e+02);
    func1->SetParameter(5,-4.25396e-05);
    hinvM->Fit("fitInvM1","","",400,600);
    hinvM->GetXaxis()->SetTitle("M_{#pi#pi} (MeV/c^2)");
    hinvM->Draw("E1"); cc1->SaveAs(KEDR + "invM" + format1);
    hinvM->Draw("E1"); cc1->SaveAs(KEDR + "invM" + format2);

    TF1 *func2 = new TF1("fitInvM2","[2]*(1+[1]*(x-500.)+[5]*pow((x-500.),2))*([0]+exp(-pow((x-[4]),2)/2./pow([3],2))/sqrt(2*3.141592)/[3]*(600-400)/100)");
    /*
    func2->SetParameter(0,0.05);
    func2->SetParameter(1,-0.2);
    func2->SetParameter(2,1000.);
    func2->SetParameter(3,8.);
    func2->SetParameter(4,498.);
    func2->SetParameter(5,0.);
    */
    func2->SetParameter(0,1.39401e-01);
    func2->SetParameter(1,-1.11893e-03);
    func2->SetParameter(2,3.81878e+03);
    func2->SetParameter(3,1.32897e+01);
    func2->SetParameter(4,4.93039e+02);
    func2->SetParameter(5,-4.25396e-05);
    hinvMcor->Fit("fitInvM2","","",400,600);
    //hinvMcor->GetYaxis()->SetRangeUser(0., 300.);
    hinvMcor->GetXaxis()->SetTitle("M_{#pi#pi} (MeV/c^2)");
    hinvMcor->Draw("E1"); cc1->SaveAs(KEDR + "invMcor" + format1);
    hinvMcor->Draw("E1"); cc1->SaveAs(KEDR + "invMcor" + format2);

    hpres->GetXaxis()->SetTitle("#Delta p_{t}/p_{t}");
    Double_t sc3=hpres->GetEntries();
    hpres->Scale(1/sc3);
    hpres->Fit("gaus","","",-0.06,0.06); hpres->Draw();
    cc1->SaveAs(KEDR+"mom_res.png"); cc1->SaveAs(KEDR+"mom_res.eps");

    fout->Write();
    fout->Close();
}
