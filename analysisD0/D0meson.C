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
	if(hit_aer>1 || hit_wls>1 || fl_sim_exp>3){ Usage(progname); return 0;}
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
	fnameout=TString::Format("res_%d_%d_%d_%d_exp_Dmeson.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/data/";
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/data2005/";
    }
    else if (sim==1)
    {
	fnameout=TString::Format("res_%d_%d_%d_%d_sim_Dmeson_sig.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Sig/";
    }
    else if (sim==2)
    {
	fnameout=TString::Format("res_%d_%d_%d_%d_sim_Dmeson_Bkg_continium.root",first_cnt,end_cnt,region,max_pt).Data();
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_continium/";
    }
    else if (sim==3)
    {
	fnameout=TString::Format("res_%d_%d_%d_%d_sim_Dmeson_Bkg_eetoDD.root",first_cnt,end_cnt,region,max_pt).Data();
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

    TH1F* henergy=new TH1F("Energy","Energy EMC",100,0.,4500.);
    TH1F* henlkr=new TH1F("E_LKr","Energy LKr",1000,0.,4500.);
    TH1F* hencsi=new TH1F("E_CsI","Energy CsI",1000,0.,4500.);
    TH1F* hncls=new TH1F("ncls","emc.ncls",12,-0.5,11.5);
    TH1F* hep=new TH1F("E/p","E/p",100,0.,10.);
    TH1F* hmbc=new TH1F("Mbc_full","Mbc_full",100,0.,2000.);
    TH1F* hmbc_zoom;
    TH1F* hmbckin_zoom;
    if( sim==0 || sim==1 ){
	hmbc_zoom=new TH1F("M_{bc}","M_{bc}",50,1800.,1900.);
	hmbckin_zoom=new TH1F("M_{bckin}","M_{bckin}",50,1800.,1900.);
    }
    else{
	hmbc_zoom=new TH1F("M_{bc}","M_{bc}",50,1700.,1900.);
	hmbckin_zoom=new TH1F("M_{bckin}","M_{bckin}",50,1700.,1900.);
    }
    TH1F* hrr=new TH1F("rr","rr",50,0.,10.);
    TH1F* hZip=new TH1F("ZIP","ZIP",100,-50.,50.);
    TH1F* henass=new TH1F("Energy_ass","Energy ass",100,0.,4500.);
    TH1F* hdepmkp=new TH1F("depmkp","depmkp",100,-400.,300.);
    TH1F* hdeppkm=new TH1F("deppkm","deppkm",100,-400.,300.);
    TH1F* hdiffepmkpeppkm=new TH1F("depmkp-deppkm","depmkp-deppkm",100,-100.,100.);
    TH2D *h2depmkpdeppkm=new TH2D("depmkp:deppkm", "depmkp:deppkm", 100,-300,300,100,-300,300);
    TH1F* hdE=new TH1F("#Delta E_full","#Delta E_full",200,-2000.,2000.);
    TH1F* hdE_zoom=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hdEkin_zoom=new TH1F("#Delta Ekin","#Delta Ekin",30,-300.,300.);
    TH1F* hdP=new TH1F("#Delta P","#Delta P",200,-1000.,1000.);
    TH1F* hEbeam=new TH1F("Ebeam","Ebeam",100,1880.,1895.);
    TH2D *h2PpiktodEkpi=new TH2D("Ppik:dekmpip", "Ppik:dekmpip", 200,600,1100,200,-250,250);
    TH2D *h2MbcdE=new TH2D("M_{bc}:#Delta E", "M_{bc}:#Delta E", 200,1700,1900,200,-300,300);
    TH2D *h2MbcdEkin=new TH2D("M_{bckin}:#Delta Ekin", "M_{bckin}:#Delta Ekin", 200,1700,1900,200,-300,300);
    TH2D *h2MbcdP=new TH2D("M_{bc}:#Delta P", "M_{bc}:#Delta P", 200,-500,500,200,1825,1890);
    TH1F* hDncomb=new TH1F("Dmseon.ncomb","Dmseon.ncomb",20,0.,20.);


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
	   //vrt.ntrk>=ntrk && emc.ncls>=min_tot_ncls && emc.ncls<=max_tot_ncls && mu.nhits<=maxmunhits
	   //&& emc.energy<3300
           && vrt.theta2t<172 && vrt.phi2t<172
           //&& (theta[0]>46 && theta[1]>46)
           //&& (theta[0]<135 && theta[1]<135)
	  )
	{
	    Nselect++;
	    if(verbose) cout<<"<<<<<<<<<<<<<<<<<<<<<<<<<<< Next event >>>>>>>>>>>>>>>>>>>>>>>>>>>>"<<endl;
	    if(verbose) cout<<"ev.run="<<ev.run<<"\t"<<"ev.event="<<ev.event<<"\t"<<"ev.evdaq="<<ev.evdaq<<endl;

	    if(verbose) cout<<"Dmeson.ncomb="<<Dmeson.ncomb<<"\t"<<endl;
	    if ( Dmeson.ncomb>0 ) hDncomb->Fill(Dmeson.ncomb);

	    for(int i=0; i<Dmeson.ncomb; i++){
		if(
		   Dmeson.Pt1[i]>min_pt && Dmeson.Pt1[i]<max_pt && Dmeson.Pt2[i]>min_pt && Dmeson.Pt2[i]<max_pt
		   && Dmeson.chi2t1[i]<max_chi2 && Dmeson.chi2t2[i]<max_chi2
		   && Dmeson.nhitst1[i]>min_nhits && Dmeson.nhitst2[i]>min_nhits
		   && Dmeson.nhitst1[i]<max_nhits && Dmeson.nhitst2[i]<max_nhits
		   && Dmeson.Mbc[i]>min_Mbc && Dmeson.Mbc[i]<max_Mbc
		   && Dmeson.dE[i]>min_dE && Dmeson.dE[i]< max_dE
		   && Dmeson.rr1[i]<0.5 && Dmeson.rr2[i]<0.5 && fabs(Dmeson.Zip1[i])<10 && fabs(Dmeson.Zip2[i])<10
		  )
		{
                    if( Dmeson.ecls1[i]>1000 || Dmeson.ecls2[i]>1000 ) continue;

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

		    //if (Dmeson.dE[i]>-100 && Dmeson.dE[i]< 100 )
		    if (Dmeson.dE[i]>-140 && Dmeson.dE[i]< 60 )
		    {
			hmbc_zoom->Fill(Dmeson.Mbc[i]);
		    }
		    if( Dmeson.Mbc[i]>1855 && Dmeson.Mbc[i]<1875  )
		    {
			hdE_zoom->Fill(Dmeson.dE[i]);
		    }

		    //if (Dmeson.dEkin[i]>-100 && Dmeson.dEkin[i]< 100 )
		    if (Dmeson.dEkin[i]>-140 && Dmeson.dEkin[i]< 60 )
		    {
			hmbckin_zoom->Fill(Dmeson.Mbckin[i]);
		    }
		    if( Dmeson.Mbckin[i]>1855 && Dmeson.Mbckin[i]<1875  )
		    {
			hdEkin_zoom->Fill(Dmeson.dEkin[i]);
		    }

		    hdepmkp->Fill(Dmeson.depmkp[i]-Dmeson.Ebeam);
		    hdeppkm->Fill(Dmeson.deppkm[i]-Dmeson.Ebeam);
		    hdiffepmkpeppkm->Fill((Dmeson.depmkp[i]-Dmeson.Ebeam)-(Dmeson.deppkm[i]-Dmeson.Ebeam));
		    h2depmkpdeppkm->Fill( (Dmeson.depmkp[i]-Dmeson.Ebeam), (Dmeson.deppkm[i]-Dmeson.Ebeam) );
		    hdP->Fill(Dmeson.dP[i]);
		    h2MbcdE->Fill(Dmeson.Mbc[i], Dmeson.dE[i]);
		    h2MbcdEkin->Fill(Dmeson.Mbckin[i], Dmeson.dEkin[i]);
		    h2MbcdP->Fill(Dmeson.dP[i], Dmeson.Mbc[i]);
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
    TString nameMbc, nameMbc_zoom, nameMbckin_zoom, nameMbcdE, nameMbcdEkin, nameMbcdP, namedE, namedE_zoom, namedEkin_zoom, namedP;
    nameMbc = "Mbc_full";
    nameMbc_zoom = "Mbc_zoom";
    nameMbckin_zoom = "Mbckin_zoom";
    nameMbcdE = "MbcdE";
    nameMbcdEkin = "MbcdEkin";
    nameMbcdP = "MbcdP";
    namedE = "dE";
    namedE_zoom = "dE_zoom";
    namedEkin_zoom = "dEkin_zoom";
    namedP = "dP";

    hmbc->Draw("E1"); cc1->SaveAs(KEDR + nameMbc + format1);  cc1->SaveAs(KEDR + nameMbc + format2);   cc1->SaveAs(KEDR + nameMbc + format3);
    hmbc_zoom->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbc_zoom->GetYaxis()->SetTitle("Events/2 MeV");
    hmbc_zoom->Draw("E1"); cc1->SaveAs(KEDR + nameMbc_zoom + format1); cc1->SaveAs(KEDR + nameMbc_zoom + format2); cc1->SaveAs(KEDR + nameMbc_zoom + format3);
    hmbckin_zoom->GetXaxis()->SetTitle("M_{bckin} (MeV)");
    hmbckin_zoom->GetYaxis()->SetTitle("Events/2 MeV");
    hmbckin_zoom->Draw("E1"); cc1->SaveAs(KEDR + nameMbckin_zoom + format1); cc1->SaveAs(KEDR + nameMbckin_zoom + format2); cc1->SaveAs(KEDR + nameMbckin_zoom + format3);
    h2MbcdE->GetXaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdE->GetYaxis()->SetTitle("#Delta E (MeV)");
    h2MbcdE->Draw(); cc1->SaveAs(KEDR + nameMbcdE + format1); cc1->SaveAs(KEDR + nameMbcdE + format2);  cc1->SaveAs(KEDR + nameMbcdE + format3);
    h2MbcdEkin->GetXaxis()->SetTitle("M_{bckin} (MeV)");
    h2MbcdEkin->GetYaxis()->SetTitle("#Delta Ekin (MeV)");
    h2MbcdEkin->Draw(); cc1->SaveAs(KEDR + nameMbcdEkin + format1); cc1->SaveAs(KEDR + nameMbcdEkin + format2);  cc1->SaveAs(KEDR + nameMbcdEkin + format3);
    h2MbcdP->GetXaxis()->SetTitle("#Delta P (MeV)");
    h2MbcdP->GetYaxis()->SetTitle("M_{bc} (MeV)");
    h2MbcdP->Draw(); cc1->SaveAs(KEDR + nameMbcdP + format1); cc1->SaveAs(KEDR + nameMbcdP + format2);  cc1->SaveAs(KEDR + nameMbcdP + format3);
    hdE->Draw("E1"); cc1->SaveAs(KEDR + namedE + format1); cc1->SaveAs(KEDR + namedE + format2); cc1->SaveAs(KEDR + namedE + format3);
    hdE_zoom->GetXaxis()->SetTitle("#Delta E (MeV)");
    hdE_zoom->GetYaxis()->SetTitle("Events/20 MeV");
    hdE_zoom->Draw("E1"); cc1->SaveAs(KEDR + namedE_zoom + format1); cc1->SaveAs(KEDR + namedE_zoom + format2); cc1->SaveAs(KEDR + namedE_zoom + format3);
    hdEkin_zoom->GetXaxis()->SetTitle("#Delta Ekin (MeV)");
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

/*
void atc_cross()
{
	    kk=0; int kk1=0; int kk2=0; int ii1=0; int ii2=0;
	    //cout<<t0atccr0.aerogel_region5<<"\t"<<t0atccr0.npe<<endl;
	    n00=0, n01=0, n02=0, n03=0, n04=0;
	    n10=0, n11=0, n12=0, n13=0, n14=0;

	    cnt11=0, cnt12=0;
	    cnt21=0, cnt22=0;

	    float Npe1tr=0., Npe2tr=0.;
	    //if(kk1==1 && ( (n00+n01+n02+n03)>0 || ( (n00+n01+n02+n03)==0 && ii1==1 ) ) )
	    //if( kk1==1 && (n00+n01+n02+n03)>0 )
	    if( kk1==1 && ii1>1 && cnt11==1 && cnt12==1 )
	    {
		prthink->Fill(P1,(n00+n01+n02+n03+n04));

		//if( (n00+n01+n02+n03)==0 )przero->Fill(P1,(n00+n01+n02+n03));
		if( (n00+n01+n02+n03+n04)<=0.02 )
		{
		    hzero->Fill(P1);
		    hzero1->Fill(vrt.theta2t);
		    hzero2->Fill(cos(pi*(vrt.theta2t)/180));
		    hzero4->Fill(emc.energy);
		    hzero5->Fill(emc.ncls);
		}

		Natc++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt0.npe="<<n00+n01+n02+n03+n04<<"\t"<<endl;
		Npe1tr=n00+n01+n02+n03+n04;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if((n00+n01+n02+n03+n04)<=thicknpetrh)
			{
			    num_npezero[ii]=++num_npezero[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if((n00+n01+n02+n03+n04)>thicknpetrh){num_npenotzero[ii]=++num_npenotzero[ii];}
			num_npetotal[ii]=++num_npetotal[ii];
			eff[ii]=num_npenotzero[ii]/num_npetotal[ii];
			err_eff[ii]=sqrt(num_npenotzero[ii])/num_npetotal[ii];
		    }
		}
	    }
	    //if(kk2==1 && ( (n10+n11+n12+n13)>0 || ( (n10+n11+n12+n13)==0 && ii2==1 ) )  )
	    //if( kk2==1 && (n10+n11+n12+n13)>0 )
	    if( kk2==1 && ii2>1 && cnt21==1 && cnt22==1 )
	    {
		prthink->Fill(P2,(n10+n11+n12+n13+n14));

		//if( (n10+n11+n12+n13)==0 )przero->Fill(P2,(n10+n11+n12+n13));
		if( (n10+n11+n12+n13+n14)<=0.02 )
		{
		    hzero->Fill(P2);
		    hzero1->Fill(vrt.theta2t);
		    hzero2->Fill(cos(pi*(vrt.theta2t)/180));
		    hzero4->Fill(emc.energy);
		    hzero5->Fill(emc.ncls);
		}

		Natc++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt1.npe="<<n10+n11+n12+n13<<"\t"<<endl;
		Npe2tr=n10+n11+n12+n13;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if((n10+n11+n12+n13+n14)<=thicknpetrh)
			{
			    num_npezero[ii]=++num_npezero[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if((n10+n11+n12+n13+n14)>thicknpetrh){num_npenotzero[ii]=++num_npenotzero[ii];}
			num_npetotal[ii]=++num_npetotal[ii];
			eff[ii]=num_npenotzero[ii]/num_npetotal[ii];
			err_eff[ii]=sqrt(num_npenotzero[ii])/num_npetotal[ii];
		    }
		}
	    }

	    if(verbose2) cout<<"ev.run="<<ev.run<<"\t"<<"Npe1tr="<<Npe1tr<<"\t"<<"Npe2tr="<<Npe2tr<<"\t"<<endl;


    //=======================
	    //First track hit in 0, 1, 2, 3, 4 counters ATC from first layer and get number of Nph.e....
	    if( t0atccr0.aerogel_region0==1 && t0atccr0.wlshit==0 && ( (t0atccr0.i>=ncnt1l1 && t0atccr0.i<ncnt1l2) ) )
	    {
		pr1->Fill(P1,t0atccr0.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr0.npe<<"\t"<<"t0atccr0.i="<<t0atccr0.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if(t0atccr0.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t0atccr0.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }
	    //Second track hit in 0, 1, 2, 3, 4 counters ATC from first layer and get number of Nph.e....
	    if( t1atccr0.aerogel_region0==1 && t1atccr0.wlshit==0 && ( (t1atccr0.i>=ncnt1l1 && t1atccr0.i<ncnt1l2) ) )
	    {
		pr1->Fill(P2,t1atccr0.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr0.npe<<"\t"<<"t1atccr0.i="<<t1atccr0.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr0.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr0.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }
	    if( t0atccr1.aerogel_region0==1 && t0atccr1.wlshit==0 && ( (t0atccr1.i>=ncnt1l1 && t0atccr1.i<ncnt1l2) ) )
	    {
		pr1->Fill(P1,t0atccr1.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr1.npe<<"\t"<<"t0atccr1.i="<<t0atccr1.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if(t0atccr1.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t0atccr1.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }
	    if( t1atccr1.aerogel_region0==1 && t1atccr1.wlshit==0 && ( (t1atccr1.i>=ncnt1l1 && t1atccr1.i<ncnt1l2) ) )
	    {
		pr1->Fill(P2,t1atccr1.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr1.npe<<"\t"<<"t1atccr1.i="<<t1atccr1.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr1.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr1.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }
	    if( t0atccr2.aerogel_region0==1 && t0atccr2.wlshit==0 && ( (t0atccr2.i>=ncnt1l1 && t0atccr2.i<ncnt1l2) ) )
	    {
		pr1->Fill(P1,t0atccr2.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr2.npe<<"\t"<<"t0atccr2.i="<<t0atccr2.i<<endl;

		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if(t0atccr2.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t0atccr2.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }
	    if( t1atccr2.aerogel_region0==1 && t1atccr2.wlshit==0 && ( (t1atccr2.i>=ncnt1l1 && t1atccr2.i<ncnt1l2) ) )
	    {
		pr1->Fill(P2,t1atccr2.npe);kk=1;  counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr2.npe<<"\t"<<"t1atccr2.i="<<t1atccr2.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr2.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr2.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }
	    if( t0atccr3.aerogel_region0==1 && t0atccr3.wlshit==0 && ( (t0atccr3.i>=ncnt1l1 && t0atccr3.i<ncnt1l2) ) )
	    {
		pr1->Fill(P1,t0atccr3.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr3.npe<<"\t"<<"t0atccr3.i="<<t0atccr3.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if(t0atccr3.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t0atccr3.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }
	    if( t1atccr3.aerogel_region0==1 && t1atccr3.wlshit==0 && ( (t1atccr3.i>=ncnt1l1 && t1atccr3.i<ncnt1l2) ) )
	    {
		pr1->Fill(P2,t1atccr3.npe); kk=1;  counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr3.npe<<"\t"<<"t1atccr3.i="<<t1atccr3.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr3.npe<=npetrh)
			{
			    num_npezero1[ii]=++num_npezero1[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr3.npe>npetrh){num_npenotzero1[ii]=++num_npenotzero1[ii];}
			num_npetotal1[ii]=++num_npetotal1[ii];
			eff1[ii]=num_npenotzero1[ii]/num_npetotal1[ii];
			err_eff1[ii]=sqrt(num_npenotzero1[ii])/num_npetotal1[ii];
		    }
		}
	    }

	    //============================
	    //First track hit in 0, 1, 2, 3, 4 counters ATC from second layer and get number of Nph.e....
	    if( t0atccr0.aerogel_region0==1 && t0atccr0.wlshit==0 && ( (t0atccr0.i>=ncnt2l1 && t0atccr0.i<ncnt2l2) ) )
	    {
		pr2->Fill(P1,t0atccr0.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr0.npe<<"\t"<<"t0atccr0.i="<<t0atccr0.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		       {
			   if(t0atccr0.npe<=npetrh)
			   {
			       num_npezero2[ii]=++num_npezero2[ii];
			       //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			   }
			   if(t0atccr0.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			   num_npetotal2[ii]=++num_npetotal2[ii];
			   eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			   err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		       }
		}
	    }
	    //Second track hit in 0, 1, 2, 3, 4 counters ATC from second layer and get number of Nph.e....
	    if( t1atccr0.aerogel_region0==1 && t1atccr0.wlshit==0 && ( (t1atccr0.i>=ncnt2l1 && t1atccr0.i<ncnt2l2) ) )
	    {
		pr2->Fill(P2,t1atccr0.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr0.npe<<"\t"<<"t1atccr0.i="<<t1atccr0.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr0.npe<=npetrh)
			{
			    num_npezero2[ii]=++num_npezero2[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr0.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			num_npetotal2[ii]=++num_npetotal2[ii];
			eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		    }
		}
	    }
	    if( t0atccr1.aerogel_region0==1 && t0atccr1.wlshit==0 && ( (t0atccr1.i>=ncnt2l1 && t0atccr1.i<ncnt2l2) ) )
	    {
		pr2->Fill(P1,t0atccr1.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr1.npe<<"\t"<<"t0atccr1.i="<<t0atccr1.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if(t0atccr1.npe<=npetrh)
			{
			    num_npezero2[ii]=++num_npezero2[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t0atccr1.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			num_npetotal2[ii]=++num_npetotal2[ii];
			eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		    }
		}
	    }
	    if( t1atccr1.aerogel_region0==1 && t1atccr1.wlshit==0 && ( (t1atccr1.i>=ncnt2l1 && t1atccr1.i<ncnt2l2) ) )
	    {
		pr2->Fill(P2,t1atccr1.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr1.npe<<"\t"<<"t1atccr1.i="<<t1atccr1.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr1.npe<=npetrh)
			{
			    num_npezero2[ii]=++num_npezero2[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr1.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			num_npetotal2[ii]=++num_npetotal2[ii];
			eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		    }
		}
	    }
	    if( t0atccr2.aerogel_region0==1 && t0atccr2.wlshit==0 && ( (t0atccr2.i>=ncnt2l1 && t0atccr2.i<ncnt2l2) ) )
	    {
		pr2->Fill(P1,t0atccr2.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr2.npe<<"\t"<<"t0atccr2.i="<<t0atccr2.i<<endl;

		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if(t0atccr2.npe<=npetrh)
			{
			    num_npezero2[ii]=++num_npezero2[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t0atccr2.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			num_npetotal2[ii]=++num_npetotal2[ii];
			eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		    }
		}
	    }
	    if( t1atccr2.aerogel_region0==1 && t1atccr2.wlshit==0 && ( (t1atccr2.i>=ncnt2l1 && t1atccr2.i<ncnt2l2) ) )
	    {
		pr2->Fill(P2,t1atccr2.npe);kk=1;  counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr2.npe<<"\t"<<"t1atccr2.i="<<t1atccr2.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr2.npe<=npetrh)
			{
			    num_npezero2[ii]=++num_npezero2[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr2.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			num_npetotal2[ii]=++num_npetotal2[ii];
			eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		    }
		}
	    }
	    if( t0atccr3.aerogel_region0==1 && t0atccr3.wlshit==0 && ( (t0atccr3.i>=ncnt2l1 && t0atccr3.i<ncnt2l2) ) )
	    {
		pr2->Fill(P1,t0atccr3.npe); kk=1; counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t0atccr3.npe<<"\t"<<"t0atccr3.i="<<t0atccr3.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P1>100*ii&&P1<100+100*ii)
		    {
			if(t0atccr3.npe<=npetrh)
			{
			    num_npezero2[ii]=++num_npezero2[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t0atccr3.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			num_npetotal2[ii]=++num_npetotal2[ii];
			eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		    }
		}
	    }
	    if( t1atccr3.aerogel_region0==1 && t1atccr3.wlshit==0 && ( (t1atccr3.i>=ncnt2l1 && t1atccr3.i<ncnt2l2) ) )
	    {
		pr2->Fill(P2,t1atccr3.npe); kk=1;  counter++;
		if(verbose1) cout<<"ev.run="<<ev.run<<"\t"<<"cnt.npe="<<t1atccr3.npe<<"\t"<<"t1atccr3.i="<<t1atccr3.i<<endl;
		for(int ii=0; ii<=14; ii++)
		{
		    p_all[ii]=100*ii+50;
		    err_p_all[ii]=50;
		    if(P2>100*ii&&P2<100+100*ii)
		    {
			if(t1atccr3.npe<=npetrh)
			{
			    num_npezero2[ii]=++num_npezero2[ii];
			    //cout<<"cnt.npe="<<cnt.npe<<"\t"<<"t.p="<<t.p<<"\t"<<ii<<"\t"<<"num_npezero[ii]="<<num_npezero[ii]<<endl;
			}
			if(t1atccr3.npe>npetrh){num_npenotzero2[ii]=++num_npenotzero2[ii];}
			num_npetotal2[ii]=++num_npetotal2[ii];
			eff2[ii]=num_npenotzero2[ii]/num_npetotal2[ii];
			err_eff2[ii]=sqrt(num_npenotzero2[ii])/num_npetotal2[ii];
		    }
		}
	    }
	    //================================

	    if( t0atccr0.aerogel_region0==1 && t0atccr0.wlshit==0 && ( (t0atccr0.i>=ncnt1l1 && t0atccr0.i<ncnt1l2) || (t0atccr0.i>=ncnt2l1 && t0atccr0.i<ncnt2l2) ) )
	    {
		n00=t0atccr0.npe;   kk1=1;  ii1++;
		if(t0atccr0.i>=ncnt1l1 && t0atccr0.i<ncnt1l2)cnt11=1;
		if(t0atccr0.i>=ncnt2l1 && t0atccr0.i<ncnt2l2)cnt12=1;
	    }

	    if( t0atccr1.aerogel_region0==1 && t0atccr1.wlshit==0 && ( (t0atccr1.i>=ncnt1l1 && t0atccr1.i<ncnt1l2) || (t0atccr1.i>=ncnt2l1 && t0atccr1.i<ncnt2l2) ) )
	    {
		n01=t0atccr1.npe;   kk1=1;   ii1++;
		if(t0atccr1.i>=ncnt1l1 && t0atccr1.i<ncnt1l2)cnt11=1;
		if(t0atccr1.i>=ncnt2l1 && t0atccr1.i<ncnt2l2)cnt12=1;
	    }
	    if( t0atccr2.single_aerogel_region0==1 && t0atccr2.wlshit==0 && ( (t0atccr2.i>=ncnt1l1 && t0atccr2.i<ncnt1l2) || (t0atccr2.i>=ncnt2l1 && t0atccr2.i<ncnt2l2) ) )
	    {
		n02=t0atccr2.npe;   kk1=1;   ii1++;
		if(t0atccr2.i>=ncnt1l1 && t0atccr2.i<ncnt1l2)cnt11=1;
		if(t0atccr2.i>=ncnt2l1 && t0atccr2.i<ncnt2l2)cnt12=1;
	    }
	    if( t0atccr3.aerogel_region0==1 && t0atccr3.wlshit==0 && ( (t0atccr3.i>=ncnt1l1 && t0atccr3.i<ncnt1l2) || (t0atccr3.i>=ncnt2l1 && t0atccr3.i<ncnt2l2) ) )
	    {
		n03=t0atccr3.npe; kk1=1;    ii1++;
		if(t0atccr3.i>=ncnt1l1 && t0atccr3.i<ncnt1l2)cnt11=1;
		if(t0atccr3.i>=ncnt2l1 && t0atccr3.i<ncnt2l2)cnt12=1;
	    }
	    if( t0atccr4.aerogel_region0==1 && t0atccr4.wlshit==0 && ( (t0atccr4.i>=ncnt1l1 && t0atccr4.i<ncnt1l2) || (t0atccr4.i>=ncnt2l1 && t0atccr4.i<ncnt2l2) ) )
	    {
		n04=t0atccr4.npe; kk1=1;    ii1++;
		if(t0atccr4.i>=ncnt1l1 && t0atccr4.i<ncnt1l2)cnt11=1;
		if(t0atccr4.i>=ncnt2l1 && t0atccr4.i<ncnt2l2)cnt12=1;
	    }

	    if( t1atccr0.aerogel_region0==1 && t1atccr0.wlshit==0 && ( (t1atccr0.i>=ncnt1l1 && t1atccr0.i<ncnt1l2) || (t1atccr0.i>=ncnt2l1 && t1atccr0.i<ncnt2l2) ) )
	    {
		n10=t1atccr0.npe;  kk2=1;   ii2++;
		if(t1atccr0.i>=ncnt1l1 && t1atccr0.i<ncnt1l2)cnt21=1;
		if(t1atccr0.i>=ncnt2l1 && t1atccr0.i<ncnt2l2)cnt22=1;
	    }
	    if( t1atccr1.aerogel_region0==1 && t1atccr1.wlshit==0 && ( (t1atccr1.i>=ncnt1l1 && t0atccr1.i<ncnt1l2) || (t1atccr1.i>=ncnt2l1 && t1atccr1.i<ncnt2l2) ) )
	    {
		n11=t1atccr1.npe;  kk2=1;   ii2++;
		if(t1atccr1.i>=ncnt1l1 && t1atccr1.i<ncnt1l2)cnt21=1;
		if(t1atccr1.i>=ncnt2l1 && t1atccr1.i<ncnt2l2)cnt22=1;
	    }
	    if( t1atccr2.aerogel_region0==1 && t1atccr2.wlshit==0 && ( (t1atccr2.i>=ncnt1l1 && t1atccr2.i<ncnt1l2) || (t1atccr2.i>=ncnt2l1 && t1atccr2.i<ncnt2l2) ) )
	    {
		n12=t1atccr2.npe;  kk2=1;   ii2++;
		if(t1atccr2.i>=ncnt1l1 && t1atccr2.i<ncnt1l2)cnt21=1;
		if(t1atccr2.i>=ncnt2l1 && t1atccr2.i<ncnt2l2)cnt22=1;
	    }
	    if( t1atccr3.aerogel_region0==1 && t1atccr3.wlshit==0 && ( (t1atccr3.i>=ncnt1l1 && t1atccr3.i<ncnt1l2) || (t1atccr3.i>=ncnt2l1 && t1atccr3.i<ncnt2l2) ) )
	    {
		n13=t1atccr3.npe;  kk2=1;   ii2++;
		if(t1atccr3.i>=ncnt1l1 && t1atccr3.i<ncnt1l2)cnt21=1;
		if(t1atccr3.i>=ncnt2l1 && t1atccr3.i<ncnt2l2)cnt22=1;
	    }
	    if( t1atccr4.aerogel_region0==1 && t1atccr4.wlshit==0 && ( (t1atccr4.i>=ncnt1l1 && t1atccr4.i<ncnt1l2) || (t1atccr4.i>=ncnt2l1 && t1atccr4.i<ncnt2l2) ) )
	    {
		n14=t1atccr4.npe;  kk2=1;   ii2++;
		if(t1atccr4.i>=ncnt1l1 && t1atccr4.i<ncnt1l2)cnt21=1;
		if(t1atccr4.i>=ncnt2l1 && t1atccr4.i<ncnt2l2)cnt22=1;
	    }

}
*/

