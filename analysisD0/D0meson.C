#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"

#include "D0meson.h"
#include "cuts.h"

extern void atc_cross();

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
	sim=atoi(argv[1]);
	if( sim>4 ){ Usage(progname); return 0;}
	if( sim<0 ){ Usage(progname); return 0;}
    }
    else
    {
	Usage(progname);
    }

    //determine name output file
    TFile *fout=0;
    TString fnameout;
    TString KEDR;
    if( sim==0 ){
	deCut1=-100; deCut2=100;
	//deCut1=-80; deCut2=120;
	mbcCut1=1855, mbcCut2=1875;
	fnameout=TString::Format("res_exp_Dmeson_data_%d.root",sim).Data();
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/data/";
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v4/";
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v4_runs24613-25687/";
        KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v4_test/";
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/data/datantrack2/";
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v4_datantrack2/";
    }
    else if (sim==4)
    {
	deCut1=-100; deCut2=100;
	//deCut1=-80; deCut2=120;
	mbcCut1=1855, mbcCut2=1875;
	fnameout=TString::Format("res_exp_Dmeson_data2004_%d.root",sim).Data();
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/data2004/";
        KEDR = "/home/ovtin/public_html/outDmeson/D0/data2004Pcorr/";
    }
    else if (sim==1)
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1800, mbcCut2=1900;
	fnameout=TString::Format("res_sim_Dmeson_sig_%d.root",sim).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Sig/";
    }
    else if (sim==2)
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=TString::Format("res_sim_Dmeson_BG_continium_%d.root",sim).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_continium/";
    }
    else if (sim==3)
    {
	deCut1=-300; deCut2=300;
	mbcCut1=1700, mbcCut2=1900;
	fnameout=TString::Format("res_sim_Dmeson_BG_eetoDD_%d.root",sim).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_eetodd/";
    }
    cout<<fnameout<<endl;
    fout = new TFile(fnameout,"RECREATE");

    //include samples
    chain();
    Int_t nentr=tt->GetEntries();
    if(verbose) cout<<"Nentries="<<nentr<<endl;

    setbranchstatus();
    setbranchaddress();

    //gROOT->SetStyle("Plain");
    //gStyle->SetOptStat(0111);

    TH1F* henergy=new TH1F("Energy","Energy EMC",100,0.,4500.);
    TH1F* henlkr=new TH1F("ELKr","Energy LKr",1000,0.,4500.);
    TH1F* hencsi=new TH1F("ECsI","Energy CsI",1000,0.,4500.);
    TH1F* hncls=new TH1F("ncls","emc.ncls",12,-0.5,11.5);
    TH1F* hep=new TH1F("Etop","E/p",100,0.,10.);
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
    TH1F* henass=new TH1F("Energy ass","Energy ass",100,0.,4500.);
    TH1F* hdepmkp=new TH1F("depmkp","depmkp",100,-400.,300.);
    TH1F* hdeppkm=new TH1F("deppkm","deppkm",100,-400.,300.);
    TH1F* hdiffepmkpeppkm=new TH1F("depmkp-deppkm","depmkp-deppkm",100,-100.,100.);
    TH2D *h2depmkpdeppkm=new TH2D("depmkp:deppkm", "depmkp:deppkm", 100,-300,300,100,-300,300);
    TH1F* hdE=new TH1F("#Delta E","#Delta E",200,-2000.,2000.);
    TH1F* hdE_zoom=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdEkin_zoom=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdP=new TH1F("#Delta P","#Delta P",200,-1000.,1000.);
    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",100,1880.,1895.);
    TH2D *h2PpiktodEkpi=new TH2D("Ppik:dekmpip", "Ppik:dekmpip", 200,600,1100,200,-250,250);
    TH2D *h2MbcdE;
    TH2D *h2MbcdEkin;
    if( sim==4 || sim==1 ){
        h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 100,1800,1900,200,-300,300);
        h2MbcdEkin=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 100,1800,1900,200,-300,300);
    }
    else{
        h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 200,1700,1900,200,-300,300);
        h2MbcdEkin=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 200,1700,1900,200,-300,300);
    }
    TH2D *h2MbcdP=new TH2D("M_{bc}:#Delta P", "M_{bc}:#Delta P", 200,-500,500,200,1825,1890);
    TH2D *h2MbckindP=new TH2D("M_{bc}:#Delta P", "M_{bc}:#Delta P", 200,-500,500,200,1825,1890);
    TH1F* hDncomb=new TH1F("Dmseon.ncomb","Dmseon.ncomb",50,0.,50.);

    TH1F *hRun;
    if( sim==0 )
    {
	hRun = new TH1F("Run","Run", 100, 23206., 26248.);
    }
    else
    {
	hRun = new TH1F("Run","Run", 100, 4100., 4709.);
    }

    TH1F* hnclst1=new TH1F("nclst1","nclst1",6,-0.5,5.5);
    TH1F* hnclst2=new TH1F("nclst2","nclst2",6,-0.5,5.5);
    TH1F* heclst1=new TH1F("eclst1","eclst1",100,0.,2500.);
    TH1F* heclst2=new TH1F("eclst2","eclst2",100,0.,2500.);
    TH1F* htclst1=new TH1F("tclst1","tclst1",100,-30.,30.);
    TH1F* htclst2=new TH1F("tclst2","tclst2",100,-30.,30.);
    TH1F* hpclst1=new TH1F("pclst1","pclst1",100,-20.,20.);
    TH1F* hpclst2=new TH1F("pclst2","pclst2",100,-20.,20.);

    TH1F* hvrtntrk=new TH1F("vrt.ntrk","vrt.ntrk",10,-0.5,9.5);
    TH1F* hvrtnip=new TH1F("vrt.nip","vrt.nip",10,-0.5,9.5);
    TH1F* hvrtnbeam=new TH1F("vrt.nbeam","vrt.nbeam",10,-0.5,9.5);

    TH1F* hmom=new TH1F("Pt","Pt",100,0.,3000.);
    TH1F* htchi2=new TH1F("tchi2","tchi2",100,0.,100.);
    TH1F* htnhitsxy=new TH1F("tnhitsxy","tnhitsxy",50,0.,50.);
    TH1F* htnhits=new TH1F("tnhits","tnhits",80,0.,80.);
    TH1F* hnhitsvd=new TH1F("nhitsvd","nhitsvd",10,0.,10.);
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

    TTree *forFit = new TTree("forFit","forFit");
    Float_t forFitMbc, forFitdE, forFitdP;
    forFit->Branch("Mbc",&forFitMbc,"Mbc/F");
    forFit->Branch("dE",&forFitdE,"dE/F");
    forFit->Branch("dP",&forFitdP,"dP/F");

    ofstream Result(TString::Format("run_event.dat"),ios_base::out);

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);

        //if( ev.run<=24613 || ev.run>=25687 ) continue;    //selected only runs from 24613-25687 range
	//if( ev.run>=24613 && ev.run<=25687 ) continue;    //selected runs w/o 24613-25687 range

        //list bad runs for 2016-17
	if (
	    ev.run==23209
	    || ev.run==23211
	    || ev.run==23911
	    || ev.run==23700
	    || ev.run==23699
	    || ev.run==23792
	    || ev.run==23745
	    || ev.run==24850
	    || ev.run==24852
	    || ev.run==24860
	    || ev.run==25086
	    || ev.run==25172
	    || ev.run==25174
	    || ev.run==25175
	    || ev.run==25217
	    || ev.run==25233
	    || ev.run==25327
	    || ev.run==25331
	    || ev.run==25337
	    || ev.run==25338
	    || ev.run==25357
	    || ev.run==25360
	    || ev.run==25365
	    || ev.run==25368
	    || ev.run==25369
	    || ev.run==25370
	    || ev.run==25598
	    || ev.run==25658
	    || ev.run==25659
	    || ev.run==26070
	    || ev.run==26071
	    || ev.run==26099
	    || ev.run==26246
	   ) continue;


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
           //&& vrt.theta2t<172 && vrt.phi2t<172
           && (ev.run!=23911 && ev.run!=23879 && ev.run!=23818 && ev.run!=23758 && ev.run!=23700 && ev.run!=23699 && ev.run!=23644 &&
	   ev.run!=23535 && ev.run!=23930 && ev.run!=23792 && ev.run!=23745 && ev.run!=23701)

	   ////&& (theta[0]>46 && theta[1]>46)
           ////&& (theta[0]<135 && theta[1]<135)
	   ////vrt.ntrk>=ntrk && emc.ncls>=min_tot_ncls && emc.ncls<=max_tot_ncls && mu.nhits<=maxmunhits
	   ////&& emc.energy<3300
           //&& mu.nhits<=maxmunhits
	  )
	{
	    //if( sim==1 && vrt.ntrk>4 ) continue;      //for cut D+->K-pi+pi+ in MC D0->K-pi+

	    //if(verbose && Dmeson.ncomb>0) cout<<"<<<<<<<<<<<<<<<<<<<<<<<<<<< Next event >>>>>>>>>>>>>>>>>>>>>>>>>>>>"<<endl;
	    //if(verbose && Dmeson.ncomb>0) cout<<"ev.run="<<ev.run<<"\t"<<"ev.event="<<ev.event<<"\t"<<"ev.evdaq="<<ev.evdaq<<endl;
	    //if(verbose && Dmeson.ncomb>0) cout<<"Dmeson.ncomb="<<Dmeson.ncomb<<"\t"<<endl;
	    if ( Dmeson.ncomb>0 ) hDncomb->Fill(Dmeson.ncomb);

	    for(int i=0; i<Dmeson.ncomb; i++){

		if(
		   Dmeson.Pt1[i]>min_pt && Dmeson.Pt1[i]<max_pt && Dmeson.Pt2[i]>min_pt && Dmeson.Pt2[i]<max_pt
		   && Dmeson.chi2t1[i]<max_chi2 && Dmeson.chi2t2[i]<max_chi2
		   && Dmeson.nhitst1[i]>=min_nhits && Dmeson.nhitst2[i]>=min_nhits
		   && Dmeson.nhitst1[i]<=max_nhits && Dmeson.nhitst2[i]<=max_nhits
		   //&& Dmeson.Mbc[i]>min_Mbc && Dmeson.Mbc[i]<max_Mbc
		   && Dmeson.Mbckin[i]>=min_Mbc && Dmeson.Mbckin[i]<=max_Mbc
		   && Dmeson.dE[i]>=min_dE && Dmeson.dE[i]<=max_dE
		   && Dmeson.rr1[i]<0.5 && Dmeson.rr2[i]<0.5 && fabs(Dmeson.Zip1[i])<12 && fabs(Dmeson.Zip2[i])<12
		  )
		{
		    if ( verbose )
		    {
			cout<<"emc.energy="<<emc.energy<<"\t"<<"Pt1="<<Dmeson.Pt1[i]<<"\t"<<"Pt2="<<Dmeson.Pt2[i]<<endl;
			cout<<"e1/P1="<<Dmeson.e1[i]/Dmeson.P1[i]<<"\t"<<"e2/P2="<<Dmeson.e2[i]/Dmeson.P2[i]<<endl;
			cout<<"(e1[i]+e2[i])="<<Dmeson.e1[i]+Dmeson.e2[i]<<endl;
			cout<<"chi2t1="<<Dmeson.chi2t1[i]<<"\t"<<"chi2t2="<<Dmeson.chi2t2[i]<<"\t"<<endl;
			cout<<"nhitst1="<<Dmeson.nhitst1[i]<<"\t"<<"nhitst2="<<Dmeson.nhitst2[i]<<"\t"<<endl;
			cout<<"rr1="<<Dmeson.rr1[i]<<"\t"<<"rr2="<<Dmeson.rr2[i]<<"\t"<<endl;
			cout<<"Zip1="<<Dmeson.Zip1[i]<<"\t"<<"Zip2="<<Dmeson.Zip2[i]<<"\t"<<endl;
			cout<<"fabs(fabs(Dmeson.Zip1[i])-fabs(Dmeson.Zip2[i]))="<<fabs(fabs(Dmeson.Zip1[i])-fabs(Dmeson.Zip2[i]))<<endl;
			cout<<i<<"\t"<<"Dmeson.Mbc="<<Dmeson.Mbc[i]<<"\t"<<"Dmeson.Mbckin="<<Dmeson.Mbckin[i]<<"\t"<<"Dmeson.dE="<<Dmeson.dE[i]<<"\t"<<endl;
		    }

		    if( Dmeson.ecls1[i]>1000 || Dmeson.ecls2[i]>1000 ) continue;

		    Result<< ev.run <<"\t"<< ev.evdaq << endl;

		    hEbeam->Fill(Dmeson.Ebeam);
		    hRun->Fill(ev.run);
		    htnhits->Fill(Dmeson.nhitst1[i]);
		    htnhits->Fill(Dmeson.nhitst2[i]);
		    //hnhitsvd->Fill(Dmeson.nhitst1vd[i]);
		    //hnhitsvd->Fill(Dmeson.nhitst2vd[i]);
		    hmom->Fill(Dmeson.Pt1[i]);
		    hmom->Fill(Dmeson.Pt2[i]);
		    htchi2->Fill(Dmeson.chi2t1[i]);
		    htchi2->Fill(Dmeson.chi2t2[i]);

                    hnclst1->Fill(Dmeson.ncls1[i]);
		    hnclst2->Fill(Dmeson.ncls2[i]);
		    heclst1->Fill(Dmeson.ecls1[i]);
		    heclst2->Fill(Dmeson.ecls2[i]);
		    htclst1->Fill(Dmeson.tcls1[i]);
		    htclst2->Fill(Dmeson.tcls2[i]);
		    hpclst1->Fill(Dmeson.pcls1[i]);
		    hpclst2->Fill(Dmeson.pcls2[i]);

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

		    h2PpiktodEkpi->Fill( Dmeson.P1[i], (Dmeson.deppkm[i]-Dmeson.Ebeam) );

		    hep->Fill(Dmeson.e1[i]/Dmeson.P1[i]);
		    hep->Fill(Dmeson.e2[i]/Dmeson.P2[i]);
		    henass->Fill(Dmeson.e1[i]);
		    henass->Fill(Dmeson.e2[i]);

		    hrr->Fill(Dmeson.rr1[i]);
		    hrr->Fill(Dmeson.rr2[i]);
		    hZip->Fill(Dmeson.Zip1[i]);
		    hZip->Fill(Dmeson.Zip2[i]);

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

		    if( Dmeson.dE[i]>deCut1 && Dmeson.dE[i]<deCut2 )
		    {
			hmbckin_zoom->Fill(Dmeson.Mbckin[i]);
		    }
		    if( Dmeson.Mbckin[i]>mbcCut1 && Dmeson.Mbckin[i]<mbcCut2 )
		    {
			//hdEkin_zoom->Fill(Dmeson.dEkin[i]);
			hdEkin_zoom->Fill(Dmeson.dE[i]);
		    }

		    forFitMbc=Dmeson.Mbckin[i];
		    forFitdE=Dmeson.dE[i];
		    forFitdP=Dmeson.dP[i];
		    forFit->Fill();

		    hdepmkp->Fill(Dmeson.depmkp[i]-Dmeson.Ebeam);
		    hdeppkm->Fill(Dmeson.deppkm[i]-Dmeson.Ebeam);
		    hdiffepmkpeppkm->Fill((Dmeson.depmkp[i]-Dmeson.Ebeam)-(Dmeson.deppkm[i]-Dmeson.Ebeam));
		    h2depmkpdeppkm->Fill( (Dmeson.depmkp[i]-Dmeson.Ebeam), (Dmeson.deppkm[i]-Dmeson.Ebeam) );
		    hdP->Fill(Dmeson.dP[i]);
		    h2MbcdE->Fill(Dmeson.Mbc[i], Dmeson.dE[i]);
		    h2MbcdEkin->Fill(Dmeson.Mbckin[i], Dmeson.dE[i]);
		    h2MbcdP->Fill(Dmeson.dP[i], Dmeson.Mbc[i]);
		    h2MbckindP->Fill(Dmeson.dP[i], Dmeson.Mbckin[i]);
		    if(verbose) cout<<i<<"\t"<<"vrt.ntrk="<<vrt.ntrk<<"\t"<<"Dmeson.Mbc="<<Dmeson.Mbc[i]<<"\t"<<"Dmeson.Mbckin="<<Dmeson.Mbckin[i]<<"\t"<<"Dmeson.dE="<<Dmeson.dE[i]<<"\t"<<endl;
		}
	    }

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
    hdepmkp->Draw(); cc1->SaveAs(KEDR+"depmkp.png");
    hdeppkm->Draw(); cc1->SaveAs(KEDR+"deppkm.png");
    hdiffepmkpeppkm->Draw(); cc1->SaveAs(KEDR+"diffepmkpeppkm.png");
    h2depmkpdeppkm->Draw(); cc1->SaveAs(KEDR+"depmkpdeppkm.png");
    hDncomb->Draw(); cc1->SaveAs(KEDR + "Dncomb" + format2);
    hnclst1->Draw(); cc1->SaveAs(KEDR + "nclst1" + format2);
    hnclst2->Draw(); cc1->SaveAs(KEDR + "nclst2" + format2);
    heclst1->Draw(); cc1->SaveAs(KEDR + "eclst1" + format2);
    heclst2->Draw(); cc1->SaveAs(KEDR + "eclst2" + format2);
    htclst1->Draw(); cc1->SaveAs(KEDR + "tclst1" + format2);
    htclst2->Draw(); cc1->SaveAs(KEDR + "tclst2" + format2);
    hpclst1->Draw(); cc1->SaveAs(KEDR + "pclst1" + format2);
    hpclst2->Draw(); cc1->SaveAs(KEDR + "pclst2" + format2);

    hrr->Draw(); cc1->SaveAs(KEDR+"rr.png");
    hZip->Draw(); cc1->SaveAs(KEDR+"Zip.png");
    hEbeam->Draw(); cc1->SaveAs(KEDR+"Ebeam.png");
    hRun->Draw(); cc1->SaveAs(KEDR+"Run.png");
    h2PpiktodEkpi->Draw(); cc1->SaveAs(KEDR+"PpiktodEkpi.png");
    TProfile *proPpiktodEkpi = h2PpiktodEkpi->ProfileX();
    proPpiktodEkpi->GetXaxis()->SetRangeUser(750,1000); proPpiktodEkpi->GetYaxis()->SetRangeUser(-50,30); proPpiktodEkpi->Draw(); cc1->SaveAs(KEDR+"proPpiktodEkpi.png");
    henergy->Draw(); cc1->SaveAs(KEDR+"emc_energy.png");
    henass->Draw(); cc1->SaveAs(KEDR+"emc_energy_ass.png");
    hmom->Draw(); cc1->SaveAs(KEDR+"momentum.png");
    hncls->Draw(); cc1->SaveAs(KEDR+"ncls.png");
    hep->Draw(); cc1->SaveAs(KEDR+"ep.png");
    htchi2->Draw(); cc1->SaveAs(KEDR+"tchi2.png");
    htnhits->Draw(); cc1->SaveAs(KEDR+"tnhits.png");
    hnhitsvd->Draw(); cc1->SaveAs(KEDR+"nhitsvd.png");
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
