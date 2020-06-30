#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"

#include "Dplusmeson.h"
#include "cuts.h"

extern void atc_cross();

using namespace std;
string progname;

int Usage(string status)
{
	cout<<"Usage: "<<progname<<"\t"<<"1)Range ATC->1,2..  2)Hit in aer(0,1)  3)Hit in wls  4)First cnt   5)End cnt  6)Data/MC (0,1)"<<endl;
        exit(0);
}

int main(int argc, char* argv[])
{
    progname=argv[0];
    int region=1;
    int hit_aer=1;
    int hit_wls=0;
    int first_cnt=0;
    int end_cnt=160;
    int fl_sim_exp=0;
    if( argc>1 )
    {
	region=atoi(argv[1]);
	hit_aer=atoi(argv[2]);
	hit_wls=atoi(argv[3]);
	first_cnt=atoi(argv[4]);
	end_cnt=atoi(argv[5]);
	fl_sim_exp=atoi(argv[6]);
	if(region>10){ Usage(progname); return 0;}
	if(hit_aer>1 || hit_wls>1 || fl_sim_exp>4){ Usage(progname); return 0;}
	if(hit_aer<0 || hit_wls<0 || fl_sim_exp<0){ Usage(progname); return 0;}
	if(first_cnt<0 || first_cnt>160){ Usage(progname); return 0;}
	if(end_cnt<0 || first_cnt>160){ Usage(progname); return 0;}
    }
    else
    {
	Usage(progname);
    }

    //determine name output file
    TFile *fout=0;
    TString fnameout;
    sim=fl_sim_exp;
    TString KEDR;
    if( sim==0 ){
	deCut1=-100; deCut2=40;
	mbcCut1=1860, mbcCut2=1880;
	fnameout=TString::Format("res_%d_%d_%d_%d_exp_Dmeson.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Dplus/data/";
    }
    else if (sim==4)
    {
	deCut1=-100; deCut2=40;
	mbcCut1=1860, mbcCut2=1880;
	fnameout=TString::Format("res_%d_%d_%d_%d_exp_Dmeson_2004.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Dplus/data2004/";
    }
    else if (sim==1)
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=TString::Format("res_%d_%d_%d_%d_sim_Dmeson_sig.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Dplus/simulation_Sig/";
    }
    else if (sim==2)
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=TString::Format("res_%d_%d_%d_%d_sim_Dmeson_Bkg_continium.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Dplus/simulation_Bkg_continium/";
    }
    else if (sim==3)
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=TString::Format("res_%d_%d_%d_%d_sim_Dmeson_Bkg_eetoDD.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/Dplus/simulation_Bkg_eetodd/";
    }
    cout<<fnameout<<endl;
    fout = new TFile(fnameout,"RECREATE");

    //include samples
    chain();
    Int_t nentr=tt->GetEntries();
    if(verbose) cout<<"Nentries="<<nentr<<endl;

    setbranchstatus();
    setbranchaddress();

    TH1F* henergy=new TH1F("Energy","Energy EMC",100,0.,4500.);
    TH1F* henlkr=new TH1F("E_LKr","Energy LKr",1000,0.,4500.);
    TH1F* hencsi=new TH1F("E_CsI","Energy CsI",1000,0.,4500.);
    TH1F* hncls=new TH1F("ncls","emc.ncls",12,-0.5,11.5);
    TH1F* hep=new TH1F("E/p","E/p",100,0.,10.);
    TH1F* hmbc=new TH1F("Mbc","Mbc",100,0.,2000.);
    TH1F* hmbc_zoom;
    TH1F* hmbckin_zoom;
    if( sim==0 || sim==4 || sim==1 ){
	hmbc_zoom=new TH1F("M_{bc}","M_{bc}",50,1800.,1900.);
	hmbckin_zoom=new TH1F("M_{bc}","M_{bc}",50,1800.,1900.);
    }
    else{
	hmbc_zoom=new TH1F("M_{bc}","M_{bc}",50,1700.,1900.);
	hmbckin_zoom=new TH1F("M_{bc}","M_{bc}",50,1700.,1900.);
    }
    TH1F* hrr=new TH1F("rr","rr",50,0.,10.);
    TH1F* hZip=new TH1F("ZIP","ZIP",100,-50.,50.);
    TH1F* henass=new TH1F("Energy_ass","Energy ass",100,0.,4500.);
    TH1F* hdE=new TH1F("#Delta E","#Delta E",200,-2000.,2000.);
    TH1F* hdE_zoom=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdEkin_zoom=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",100,1880.,1895.);
    TH2D *h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 200,1700,1900,200,-300,300);
    TH2D *h2MbcdEkin=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 200,1700,1900,200,-300,300);
    TH1F* hDncomb=new TH1F("Dmseon.ncomb","Dmseon.ncomb",50,0.,50.);

    TH1F* htime=new TH1F("time","time",140,-40.,100.);
    TH1F* hbeta=new TH1F("beta","beta",50,0.,4.);
    TH1F* hlength=new TH1F("length","length",160,0.,160.);
    TH2D *h2betaP=new TH2D("P:1/#beta", "P:1/#beta", 1000,0,1000,100,0,2.5);

    TH1D *hdtof1=new TH1D("dtof1", "dtof1",100,-10.,10);

    TH1F* hnclst1=new TH1F("nclst1","nclst1",6,-0.5,5.5);
    TH1F* heclst1=new TH1F("eclst1","eclst1",100,0.,2500.);
    TH1F* htclst1=new TH1F("tclst1","tclst1",100,-30.,30.);
    TH1F* hpclst1=new TH1F("pclst1","pclst1",100,-20.,20.);

    TH1F* hnclst2=new TH1F("nclst2","nclst2",6,-0.5,5.5);
    TH1F* heclst2=new TH1F("eclst2","eclst2",100,0.,2500.);
    TH1F* htclst2=new TH1F("tclst2","tclst2",100,-30.,30.);
    TH1F* hpclst2=new TH1F("pclst2","pclst2",100,-20.,20.);

    TH1F* hnclst3=new TH1F("nclst3","nclst3",6,-0.5,5.5);
    TH1F* heclst3=new TH1F("eclst3","eclst3",100,0.,2500.);
    TH1F* htclst3=new TH1F("tclst3","tclst3",100,-30.,30.);
    TH1F* hpclst3=new TH1F("pclst3","pclst3",100,-20.,20.);

    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",10,-0.5,9.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",10,-0.5,9.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",10,-0.5,9.5);

    TH1F* hmom=new TH1F("Pt","Pt",100,0.,3000.);
    TH1F* htchi2=new TH1F("tchi2","tchi2",100,0.,100.);
    TH1F* htnhitsxy=new TH1F("tnhitsxy","tnhitsxy",50,0.,50.);
    TH1F* htnhits=new TH1F("tnhits","tnhits",80,0.,80.);
    TH1F* htnvecxy=new TH1F("tnvecxy","tnvecxy",30,0.,30.);
    TH1F* htnvec=new TH1F("tnvec","tnvec",30,0.,30.);
    TH1F* htheta=new TH1F("theta","t.theta",185,0.,185.);
    TH1F* hphi=new TH1F("phi","t.phi",180,0.,360.);
    TH1F* hcostheta=new TH1F("cos(t.theta)","cos(t.theta)",100,-1.,1.);
    TH1F* hcosphi=new TH1F("cos(t.phi)","cos(t.phi)",100,-1.,1.);

    TH1F* hMUnhits=new TH1F("munhits","mu.nhits",30,-0.5,29.5);

    TH1F* htofnhits=new TH1F("tof.nhits","tof.nhits",20,-0.5,19.5);
    TH1F* htofdchits=new TH1F("tof.dchits","tof.dchits",20,-0.5,19.5);
    TH1F* htofnamps=new TH1F("tof.namps","tof.namps",20,-0.5,19.5);
    TH1F* htofntimes=new TH1F("tof.ntimes","tof.ntimes",20,-0.5,19.5);

    hInvM=new TH1F("InvMass","InvMass",1000,0.,4000.);

    char branchname[1];
    char branchname1[161];

    char namepr[0], namepr1[0], namepr2[0];
    if(sim==1)sprintf(namepr,"Simulation");
    if(sim!=1)sprintf(namepr,"Experiment");
    prthink=new TProfile(namepr,namepr,50,0,1600,0,500);
    if(sim==1)sprintf(namepr1,"Simulation - 1 layer");
    if(sim!=1)sprintf(namepr1,"Experiment - 1 layer");
    pr1=new TProfile(namepr1,namepr1,50,0,1600,0,500);
    if(sim==1)sprintf(namepr2,"Simulation - 2 layer");
    if(sim!=1)sprintf(namepr2,"Experiment - 2 layer");
    pr2=new TProfile(namepr2,namepr2,50,0,1600,0,500);

    ofstream Result(TString::Format("run_event.dat"),ios_base::out);

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

	if( (k %100000)==0 )cout<<k<<endl;

        theta[0]=0; theta[1]=0; theta[2]=0; theta[3]=0; theta[4]=0; theta[5]=0;
        theta[0]=t0.theta; theta[1]=t1.theta; theta[2]=t2.theta; theta[3]=t3.theta; theta[4]=t4.theta; theta[5]=t5.theta;
        phi[0]=0; phi[1]=0; phi[2]=0; phi[3]=0; phi[4]=0; phi[5]=0;
        phi[0]=t0.phi; phi[1]=t1.phi; phi[2]=t2.phi; phi[3]=t3.phi; phi[4]=t4.phi; phi[5]=t5.phi;
        nhitsxy[0]=0; nhitsxy[1]=0; nhitsxy[2]=0; nhitsxy[3]=0; nhitsxy[4]=0; nhitsxy[5]=0;
        nhitsxy[0]=t0.nhitsxy; nhitsxy[1]=t1.nhitsxy; nhitsxy[2]=t2.nhitsxy; nhitsxy[3]=t3.nhitsxy; nhitsxy[4]=t4.nhitsxy; nhitsxy[5]=t5.nhitsxy;
        nvec[0]=0; nvec[1]=0; nvec[2]=0; nvec[3]=0; nvec[4]=0; nvec[5]=0;
        nvec[0]=t0.nvec; nvec[1]=t1.nvec; nvec[2]=t2.nvec; nvec[3]=t3.nvec; nvec[4]=t4.nvec; nvec[5]=t5.nvec;

        //Apply cut conditions - determine in cuts.h
	if(
	   vrt.ntrk>=ntrk
	   //vrt.ntrk>=ntrk && emc.ncls>=min_tot_ncls && emc.ncls<=max_tot_ncls && mu.nhits<=maxmunhits
	   //&& emc.energy<3300
           //&& vrt.theta2t<172 && vrt.phi2t<172
           //&& (theta[0]>46 && theta[1]>46)
	   //&& (theta[0]<135 && theta[1]<135)
           && (ev.run!=23911 && ev.run!=23879 && ev.run!=23818 && ev.run!=23758 && ev.run!=23700 && ev.run!=23699 && ev.run!=23644 &&
	   ev.run!=23535 && ev.run!=23930 && ev.run!=23792 && ev.run!=23745 && ev.run!=23701)
	  )
	{
	    Nselect++;
	    if(verbose) cout<<"<<<<<<<<<<<<<<<<<<<<<<<<<<< Next event >>>>>>>>>>>>>>>>>>>>>>>>>>>>"<<endl;
	    if(verbose) cout<<"ev.run="<<ev.run<<"\t"<<"ev.event="<<ev.event<<"\t"<<"ev.evdaq="<<ev.evdaq<<endl;

	    if(verbose) cout<<"Dmeson.ncomb="<<Dmeson.ncomb<<"\t"<<endl;
	    if ( Dmeson.ncomb>0 ) hDncomb->Fill(Dmeson.ncomb);

	    for(int i=0; i<Dmeson.ncomb; i++){
		if(
		   Dmeson.Pt1[i]>min_pt && Dmeson.Pt1[i]<max_pt && Dmeson.Pt2[i]>min_pt && Dmeson.Pt2[i]<max_pt && Dmeson.Pt3[i]>min_pt && Dmeson.Pt3[i]<max_pt
		   && Dmeson.chi2t1[i]<max_chi2 && Dmeson.chi2t2[i]<max_chi2 && Dmeson.chi2t3[i]<max_chi2
		   && Dmeson.nhitst1[i]>min_nhits && Dmeson.nhitst2[i]>min_nhits && Dmeson.nhitst3[i]>min_nhits
		   && Dmeson.nhitst1[i]<max_nhits && Dmeson.nhitst2[i]<max_nhits && Dmeson.nhitst3[i]<max_nhits
		   && Dmeson.Mbckin[i]>min_Mbc && Dmeson.Mbckin[i]<max_Mbc
		   && Dmeson.dE[i]>min_dE && Dmeson.dE[i]< max_dE
		   && Dmeson.rr1[i]<0.5 && Dmeson.rr2[i]<0.5 && Dmeson.rr3[i]<0.5 && fabs(Dmeson.Zip1[i])<10 && fabs(Dmeson.Zip2[i])<10 && fabs(Dmeson.Zip3[i])<10
		   //&& Dmeson.rr1[i]<3 && Dmeson.rr2[i]<3 && Dmeson.rr3[i]<3 && fabs(Dmeson.Zip1[i])<20 && fabs(Dmeson.Zip2[i])<20 && fabs(Dmeson.Zip3[i])<20
		  )
		{
                    if( Dmeson.ecls1[i]>1000 || Dmeson.ecls2[i]>1000 || Dmeson.ecls3[i]>1000) continue;

		    htime->Fill(Dmeson.timet1[i]);
		    hbeta->Fill(Dmeson.betat1[i]);
		    hlength->Fill(Dmeson.lengtht1[i]);

		    htime->Fill(Dmeson.timet2[i]);
		    hbeta->Fill(Dmeson.betat2[i]);
		    hlength->Fill(Dmeson.lengtht2[i]);

		    htime->Fill(Dmeson.timet3[i]);
		    hbeta->Fill(Dmeson.betat3[i]);
		    hlength->Fill(Dmeson.lengtht3[i]);

		    //tof = sqrt(494.*494. + p*p)/p*tlen/30.    time=len/v       beta=v/c    v=beta*c   beta=sqrt(1-(mc^2)^2/E^2)  E^2=(mc^2)^2+(pc)^2
                    tof1=sqrt(494.*494. + Dmeson.P1[i]*Dmeson.P1[i])/Dmeson.P1[i]*Dmeson.lengtht1[i]/30.;
		    dtof1=Dmeson.timet1[i]-tof1;

		    //if( dtof1<-1.0 || dtof1>1.0 ) continue;           //!!!!!
		    //if( dtof1<-0.8 || dtof1>0.8 ) continue;
		    if( dtof1<-0.8 ) continue;
		    //if( dtof1<-0.8 && Dmeson.betat1[i]>0 ) continue;          //for Kaon - it is t1, P1

		    hdtof1->Fill(dtof1);
                    if ( Dmeson.betat1[i]>0 ) h2betaP->Fill(Dmeson.P1[i], 1/Dmeson.betat1[i]);
                    if ( Dmeson.betat2[i]>0 ) h2betaP->Fill(Dmeson.P2[i], 1/Dmeson.betat2[i]);
                    if ( Dmeson.betat3[i]>0 ) h2betaP->Fill(Dmeson.P3[i], 1/Dmeson.betat3[i]);


		    Result<< ev.run <<"\t"<< ev.evdaq << endl;

		    if ( verbose )
		    {
			cout<<"emc.energy="<<emc.energy<<"\t"<<"P1="<<Dmeson.P1[i]<<"\t"<<"P2="<<Dmeson.P2[i]<<endl;
			cout<<"e1/P1="<<Dmeson.e1[i]/Dmeson.P1[i]<<"\t"<<"e2/P2="<<Dmeson.e2[i]/Dmeson.P2[i]<<endl;
			cout<<"(e1[i]+e2[i])="<<Dmeson.e1[i]+Dmeson.e2[i]<<endl;
			cout<<"rr1="<<Dmeson.rr1[i]<<"\t"<<"rr2="<<Dmeson.rr2[i]<<"\t"<<endl;
			cout<<"Zip1="<<Dmeson.Zip1[i]<<"\t"<<"Zip2="<<Dmeson.Zip2[i]<<"\t"<<endl;
			cout<<"fabs(fabs(Dmeson.Zip1[i])-fabs(Dmeson.Zip2[i]))="<<fabs(fabs(Dmeson.Zip1[i])-fabs(Dmeson.Zip2[i]))<<endl;
		    }

		    hEbeam->Fill(Dmeson.Ebeam);
		    htnhits->Fill(Dmeson.nhitst1[i]);
		    htnhits->Fill(Dmeson.nhitst2[i]);
		    hmom->Fill(Dmeson.Pt1[i]);
		    hmom->Fill(Dmeson.Pt2[i]);
		    hmom->Fill(Dmeson.Pt3[i]);
		    htchi2->Fill(Dmeson.chi2t1[i]);
		    htchi2->Fill(Dmeson.chi2t2[i]);
		    htchi2->Fill(Dmeson.chi2t3[i]);

                    hnclst1->Fill(Dmeson.ncls1[i]);
		    heclst1->Fill(Dmeson.ecls1[i]);
		    htclst1->Fill(Dmeson.tcls1[i]);
		    hpclst1->Fill(Dmeson.pcls1[i]);

		    hnclst2->Fill(Dmeson.ncls2[i]);
		    heclst2->Fill(Dmeson.ecls2[i]);
		    htclst2->Fill(Dmeson.tcls2[i]);
		    hpclst2->Fill(Dmeson.pcls2[i]);

		    hnclst3->Fill(Dmeson.ncls3[i]);
		    heclst3->Fill(Dmeson.ecls3[i]);
		    htclst3->Fill(Dmeson.tcls3[i]);
		    hpclst3->Fill(Dmeson.pcls3[i]);

		    //===
		    hvrtntrk->Fill(vrt.ntrk);
		    hvrtnip->Fill(vrt.nip);
		    hvrtnbeam->Fill(vrt.nbeam);
		    henergy->Fill(emc.energy);
		    henlkr->Fill(emc.elkr);
		    hencsi->Fill(emc.ecsi);
		    hncls->Fill(emc.ncls);
		    hMUnhits->Fill(mu.nhits);
		    htofnhits->Fill(t0tof.nhits);
		    htofdchits->Fill(t0tof.dchits);
		    htofnamps->Fill(t0tof.namps);
		    htofntimes->Fill(t0tof.ntimes);

		    for(int k=0; k<vrt.ntrk; k++){
			htheta->Fill(theta[k]);
			hphi->Fill(phi[k]);
			htnhitsxy->Fill(nhitsxy[k]);
			htnvec->Fill(nvec[k]);
			hcostheta->Fill(cos(pi*theta[k]/180));
			hcosphi->Fill(cos(pi*phi[k]/180));
		    }
		    //===

		    hep->Fill(Dmeson.e1[i]/Dmeson.P1[i]);
		    hep->Fill(Dmeson.e2[i]/Dmeson.P2[i]);
		    hep->Fill(Dmeson.e3[i]/Dmeson.P3[i]);
		    henass->Fill(Dmeson.e1[i]);
		    henass->Fill(Dmeson.e2[i]);
		    henass->Fill(Dmeson.e3[i]);

		    hrr->Fill(Dmeson.rr1[i]);
		    hrr->Fill(Dmeson.rr2[i]);
		    hrr->Fill(Dmeson.rr3[i]);
		    hZip->Fill(Dmeson.Zip1[i]);
		    hZip->Fill(Dmeson.Zip2[i]);
		    hZip->Fill(Dmeson.Zip3[i]);

		    hmbc->Fill(Dmeson.Mbc[i]);
		    hdE->Fill(Dmeson.dE[i]);

		    if( Dmeson.dE[i]>deCut1 && Dmeson.dE[i]<deCut2 )
		    {
			hmbc_zoom->Fill(Dmeson.Mbc[i]);
		    }
		    if( Dmeson.Mbc[i]>mbcCut1 && Dmeson.Mbc[i]<mbcCut2 )
		    {
			hdE_zoom->Fill(Dmeson.dE[i]);
		    }

		    if( Dmeson.dEkin[i]>deCut1 && Dmeson.dEkin[i]<deCut2 )
		    {
			hmbckin_zoom->Fill(Dmeson.Mbckin[i]);
		    }
		    if( Dmeson.Mbckin[i]>mbcCut1 && Dmeson.Mbckin[i]<mbcCut2 )
		    {
			hdEkin_zoom->Fill(Dmeson.dE[i]);
		    }

		    h2MbcdE->Fill(Dmeson.Mbc[i], Dmeson.dE[i]);
		    //h2MbcdEkin->Fill(Dmeson.Mbckin[i], Dmeson.dEkin[i]);
		    h2MbcdEkin->Fill(Dmeson.Mbckin[i], Dmeson.dE[i]);
		    if(verbose) cout<<i<<"\t"<<"vrt.ntrk="<<vrt.ntrk<<"\t"<<"Dmeson.Mbc="<<Dmeson.Mbc[i]<<"\t"<<"Dmeson.dE="<<Dmeson.dE[i]<<"\t"<<endl;
		}
	    }

	    //atc_cross();
	}
    }
    Result.close();

    if(verbose) cout<<counter<<endl;

    TF1* myfit=new TF1("myfit","[0]+[1]*(x^2-[2]^2)/(x^2)*(TMath::Erf(x-[2])+1)/2",200.,1450.);
    myfit->SetParameter(0,prthink->GetMinimum());
    myfit->SetParameter(1,prthink->GetMaximum());
    myfit->SetParameter(2,430);
    myfit->SetParNames("#mu_{0}","#mu_{max}","P_{thr}");
    if(sim!=1)
    {
	myfit->SetLineColor(kRed);
	prthink->SetLineColor(kRed);
    }
    else
    {
	myfit->SetLineColor(kBlue);
	prthink->SetLineColor(kBlue);
    }
    prthink->Fit("myfit","","",200,1450);
    cout<<"pr->GetMinimum()="<<prthink->GetMinimum()<<"\t"<<"pr->GetMaximum()"<<prthink->GetMaximum()<<endl;
    prthink->SetXTitle("P, MeV/c");
    prthink->SetYTitle("N_{ph.e.}");
    prthink->Draw("prof");


    TF1* myfit1=new TF1("myfit1","[0]+[1]*(x^2-[2]^2)/(x^2)*(TMath::Erf(x-[2])+1)/2",200.,1450.);
    myfit1->SetParameter(0,pr1->GetMinimum());
    myfit1->SetParameter(1,pr1->GetMaximum());
    myfit1->SetParameter(2,90);
    myfit1->SetParNames("#mu_{0}","#mu_{max}","P_{thr}");
    if(sim!=1)
    {
	myfit1->SetLineColor(kRed);
	pr1->SetLineColor(kRed);
    }
    else
    {
	myfit1->SetLineColor(kBlue);
	pr1->SetLineColor(kBlue);
    }
    pr1->Fit("myfit1","","",200,1450);
    cout<<"pr1->GetMinimum()="<<pr1->GetMinimum()<<"\t"<<"pr1->GetMaximum()"<<pr1->GetMaximum()<<endl;
    pr1->SetXTitle("P, MeV/c");
    pr1->SetYTitle("N_{ph.e.}");
    pr1->Draw("prof");


    TF1* myfit2=new TF1("myfit2","[0]+[1]*(x^2-[2]^2)/(x^2)*(TMath::Erf(x-[2])+1)/2",200.,1450.);
    myfit2->SetParameter(0,pr2->GetMinimum());
    myfit2->SetParameter(1,pr2->GetMaximum());
    myfit2->SetParameter(2,90);
    myfit2->SetParNames("#mu_{0}","#mu_{max}","P_{thr}");
    if(sim!=1)
    {
	myfit2->SetLineColor(kRed);
	pr2->SetLineColor(kRed);
    }
    else
    {
	myfit2->SetLineColor(kBlue);
	pr2->SetLineColor(kBlue);
    }
    pr2->Fit("myfit2","","",200,1450);
    cout<<"pr2->GetMinimum()="<<pr2->GetMinimum()<<"\t"<<"pr2->GetMaximum()"<<pr2->GetMaximum()<<endl;
    pr2->SetXTitle("P, MeV/c");
    pr2->SetYTitle("N_{ph.e.}");
    pr2->Draw("prof");

    TGraphErrors* gr1=new TGraphErrors(14,p_all,eff,err_p_all,err_eff);
    gr1->SetMarkerStyle(20);
    gr1->SetLineWidth(2);
    if(sim!=1)
    {
	gr1->SetMarkerColor(2);
	gr1->SetLineColor(2);
    }
    else
    {
	gr1->SetMarkerColor(kBlue);
	gr1->SetLineColor(kBlue);
    }
    gr1->SetTitle("Efficiency&Momentum");
    gr1->GetXaxis()->SetTitle("P, MeV/c");
    gr1->GetYaxis()->SetTitle("Efficiency");
    gr1->Write("Think_Efficiency&Momentum");

    TGraphErrors* gr2=new TGraphErrors(14,p_all,eff1,err_p_all,err_eff1);
    gr2->SetMarkerStyle(20);
    gr2->SetLineWidth(2);
    if(sim!=1)
    {
	gr2->SetMarkerColor(2);
	gr2->SetLineColor(2);
    }
    else
    {
	gr2->SetMarkerColor(kBlue);
	gr2->SetLineColor(kBlue);
    }
    gr2->SetTitle("Efficiency&Momentum");
    gr2->GetXaxis()->SetTitle("P, MeV/c");
    gr2->GetYaxis()->SetTitle("Efficiency");
    gr2->Write("1layer_Efficiency&Momentum");

    TGraphErrors* gr3=new TGraphErrors(14,p_all,eff2,err_p_all,err_eff2);
    gr3->SetMarkerStyle(20);
    gr3->SetLineWidth(2);
    if(sim!=1)
    {
	gr3->SetMarkerColor(2);
	gr3->SetLineColor(2);
    }
    else
    {
	gr3->SetMarkerColor(kBlue);
	gr3->SetLineColor(kBlue);
    }
    gr3->SetTitle("Efficiency&Momentum");
    gr3->GetXaxis()->SetTitle("P, MeV/c");
    gr3->GetYaxis()->SetTitle("Efficiency");
    gr3->Write("2layer_Efficiency&Momentum");

    TH1F *h38 = (TH1F*) hmbc->Clone();
    h38->SetName("h38");
    Double_t bb=h38->GetEntries();
    h38->Scale(1/bb);
    h38->GetXaxis()->SetTitle("m(#pi#pi), MeV/c^{2}");

    if(sim!=1)
    {
	h38->SetLineColor(kRed);
    }
    else
    {
	h38->SetLineColor(kBlue);
    }

    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    //gStyle->SetOptStat(0);
    gStyle->SetOptFit(1011);
    //gROOT->SetStyle("Plain");
    cc1->cd();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString nameMbc, nameMbc_zoom, nameMbckin_zoom, nameMbcdE, nameMbcdEkin, namedE, namedE_zoom, namedEkin_zoom;
    nameMbc = "Mbc_full";
    nameMbc_zoom = "Mbc_zoom";
    nameMbckin_zoom = "Mbckin_zoom";
    nameMbcdE = "MbcdE";
    nameMbcdEkin = "MbcdEkin";
    namedE = "dE";
    namedE_zoom = "dE_zoom";
    namedEkin_zoom = "dEkin_zoom";

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
    if( sim==0 || sim==4 ){
	line1.Draw("same");
	line2.Draw("same");
	line3.Draw("same");
	line4.Draw("same");
    }
    h2MbcdEkin->GetXaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdEkin->GetYaxis()->SetTitle("#Delta E (MeV)");
    h2MbcdEkin->Draw("same");
    cc1->SaveAs(KEDR + nameMbcdEkin + format1); cc1->SaveAs(KEDR + nameMbcdEkin + format2);  cc1->SaveAs(KEDR + nameMbcdEkin + format3);

    hdE->Draw("E1"); cc1->SaveAs(KEDR + namedE + format1); cc1->SaveAs(KEDR + namedE + format2); cc1->SaveAs(KEDR + namedE + format3);
    hdE_zoom->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE_zoom->GetYaxis()->SetTitle("Events/20 MeV");
    hdE_zoom->Draw("E1"); cc1->SaveAs(KEDR + namedE_zoom + format1); cc1->SaveAs(KEDR + namedE_zoom + format2); cc1->SaveAs(KEDR + namedE_zoom + format3);
    hdEkin_zoom->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdEkin_zoom->GetYaxis()->SetTitle("Events/20 MeV");
    hdEkin_zoom->Draw("E1"); cc1->SaveAs(KEDR + namedEkin_zoom + format1); cc1->SaveAs(KEDR + namedEkin_zoom + format2); cc1->SaveAs(KEDR + namedEkin_zoom + format3);
    hDncomb->Draw(); cc1->SaveAs(KEDR + "Dncomb" + format2);

    hnclst1->Draw(); cc1->SaveAs(KEDR + "nclst1" + format2);
    heclst1->Draw(); cc1->SaveAs(KEDR + "eclst1" + format2);
    htclst1->Draw(); cc1->SaveAs(KEDR + "tclst1" + format2);
    hpclst1->Draw(); cc1->SaveAs(KEDR + "pclst1" + format2);

    hnclst2->Draw(); cc1->SaveAs(KEDR + "nclst2" + format2);
    heclst2->Draw(); cc1->SaveAs(KEDR + "eclst2" + format2);
    htclst2->Draw(); cc1->SaveAs(KEDR + "tclst2" + format2);
    hpclst2->Draw(); cc1->SaveAs(KEDR + "pclst2" + format2);

    hnclst3->Draw(); cc1->SaveAs(KEDR + "nclst3" + format2);
    heclst3->Draw(); cc1->SaveAs(KEDR + "eclst3" + format2);
    htclst3->Draw(); cc1->SaveAs(KEDR + "tclst3" + format2);
    hpclst3->Draw(); cc1->SaveAs(KEDR + "pclst3" + format2);

    htime->Draw(); cc1->SaveAs(KEDR + "time" + format2); cc1->SaveAs(KEDR + "time" + format3);
    hbeta->Draw(); cc1->SaveAs(KEDR + "beta" + format2); cc1->SaveAs(KEDR + "beta" + format3);
    hlength->Draw(); cc1->SaveAs(KEDR + "length" + format2); cc1->SaveAs(KEDR + "length" + format3);
    h2betaP->Draw(); cc1->SaveAs(KEDR + "betatoP" + format2); cc1->SaveAs(KEDR + "betatoP" + format3);
    hdtof1->Draw(); cc1->SaveAs(KEDR + "dtof1" + format2); cc1->SaveAs(KEDR + "dtof1" + format3);

    hrr->Draw(); cc1->SaveAs(KEDR+"rr.png");
    hZip->Draw(); cc1->SaveAs(KEDR+"Zip.png");
    hEbeam->Draw(); cc1->SaveAs(KEDR+"Ebeam.png");
    henergy->Draw(); cc1->SaveAs(KEDR+"emc_energy.png");
    henass->Draw(); cc1->SaveAs(KEDR+"emc_energy_ass.png");
    hmom->Draw(); cc1->SaveAs(KEDR+"momentum.png");
    hncls->Draw(); cc1->SaveAs(KEDR+"ncls.png");
    hep->Draw(); cc1->SaveAs(KEDR+"ep.png");
    htchi2->Draw(); cc1->SaveAs(KEDR+"tchi2.png");
    htnhits->Draw(); cc1->SaveAs(KEDR+"tnhits.png");
    htnhitsxy->Draw(); cc1->SaveAs(KEDR+"tnhitsxy.png");
    htnvecxy->Draw(); cc1->SaveAs(KEDR+"tnvecxy.png");
    htnvec->Draw(); cc1->SaveAs(KEDR+"tnvec.png");
    htheta->Draw(); cc1->SaveAs(KEDR+"theta.png");
    hphi->Draw(); cc1->SaveAs(KEDR+"phi.png");
    hMUnhits->Draw(); cc1->SaveAs(KEDR+"MUnhits.png");
    hcostheta->Draw(); cc1->SaveAs(KEDR+"costheta.png");
    hcosphi->Draw(); cc1->SaveAs(KEDR+"cosphi.png");
    hvrtntrk->Draw(); cc1->SaveAs(KEDR+"vrtntrk.png");
    hvrtnip->Draw(); cc1->SaveAs(KEDR+"vrtnip.png");
    hvrtnbeam->Draw(); cc1->SaveAs(KEDR+"vrtnbeam.png");
    htofnhits->Draw(); cc1->SaveAs(KEDR+"tofnhits.png");
    htofnamps->Draw(); cc1->SaveAs(KEDR+"tofnamps.png");
    htofntimes->Draw(); cc1->SaveAs(KEDR+"tofntimes.png");

    fout->Write();
    fout->Close();
}

