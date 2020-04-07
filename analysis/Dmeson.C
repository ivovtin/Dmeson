#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"

#include "Dmeson.h"

extern void atc_cross();

using namespace std;
string progname;

int Usage(string status)
{
	cout<<"Usage: "<<progname<<"\t"<<"1)Range ATC->1,2..  2)Hit in aer(0,1)  3)Hit in wls  4)First cnt   5)End cnt  6)Maximum momentum  7)Data/MC (0,1)"<<endl;
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
    int momentum=5000;
    int fl_sim_exp=0;
    if( argc>1 )
    {
	region=atoi(argv[1]);
	hit_aer=atoi(argv[2]);
	hit_wls=atoi(argv[3]);
	first_cnt=atoi(argv[4]);
	end_cnt=atoi(argv[5]);
	momentum=atoi(argv[6]);
	fl_sim_exp=atoi(argv[7]);
	if(region>10){ Usage(progname); return 0;}
	if(hit_aer>1 || hit_wls>1 || fl_sim_exp>1){ Usage(progname); return 0;}
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
    if( sim!=1 ){
	fnameout=TString::Format("res_%d_%d_%d_%d_exp_Dmeson.root",first_cnt,end_cnt,region,momentum).Data();
    }else
    {
	fnameout=TString::Format("res_%d_%d_%d_%d_sim_Dmeson.root",first_cnt,end_cnt,region,momentum).Data();
    }
    cout<<fnameout<<endl;
    fout = new TFile(fnameout,"RECREATE");

    //include samples
    chain();
    Int_t nentr=tt->GetEntries();
    if(verbose) cout<<"Nentries="<<nentr<<endl;

    setbranchstatus();
    setbranchaddress();

    TH1F* hncls=new TH1F("ncls","emc.ncls",12,-0.5,11.5);
    TH1F* henergy=new TH1F("Energy","Energy EMC",1000,0.,4500.);
    TH1F* henlkr=new TH1F("E_LKr","Energy LKr",1000,0.,4500.);
    TH1F* hencsi=new TH1F("E_CsI","Energy CsI",1000,0.,4500.);
    TH1F* hmom=new TH1F("Momentum","Momentum",1000,0.,5000.);
    TH1F* hmbc=new TH1F("Mbc","Mbc",1000,0.,2000.);
    TH1F* hep=new TH1F("E/p","E/p",100,0.,10.);

    TH1F* h8=new TH1F("theta","t.theta",1000,0.,185.);
    TH1F* h9=new TH1F("phi","t.phi",1000,0.,380.);
    TH1F* h10=new TH1F("theta2t","vrt.theta2t",1000,0.,185.);
    TH1F* h11=new TH1F("phi2t","vrt.phi2t",1000,0.,185.);
    TH1F* h12=new TH1F("cos(theta2t)","cos(theta2t)",100,-1.,1.);
    TH1F* h13=new TH1F("cos(phi2t)","cos(phi2t)",100,-1.,1.);
    TH1F* h14=new TH1F("cos(t.theta)","cos(t.theta)",100,-1.,1.);
    TH1F* h15=new TH1F("cos(t.phi)","cos(t.phi)",100,-1.,1.);
    TH1F* h16=new TH1F("InvMass","InvMass",1000,0.,4000.);
    TH1F* h18=new TH1F("de","de",1000,-10000.,10000.);

    TH1F* h19=new TH1F("t0tof.nhits","t0tof.nhits",20,0.,20.);
    TH1F* h20=new TH1F("t0tof.dchits","t0tof.dchits",20,0.,20.);
    TH1F* h21=new TH1F("t0tof.namps","t0tof.namps",20,0.,20.);
    TH1F* h22=new TH1F("t0tof.ntimes","t0tof.ntimes",20,0.,20.);
    TH1F* h23=new TH1F("t0tof.time","t0tof.time",1000,-150.,150.);
    TH1F* h24=new TH1F("t0tof.beta","t0tof.beta",1000,-1.,5.);
    TH1F* h25=new TH1F("t0tof.length","t0tof.length",1000,0.,250.);

    TH1F* h26=new TH1F("t1tof.nhits","t1tof.nhits",20,0.,20.);
    TH1F* h27=new TH1F("t1tof.dchits","t1tof.dchits",20,0.,20.);
    TH1F* h28=new TH1F("t1tof.namps","t1tof.namps",20,0.,20.);
    TH1F* h29=new TH1F("t1tof.ntimes","t1tof.ntimes",20,0.,20.);
    TH1F* h30=new TH1F("t1tof.time","t1tof.time",1000,-150.,150.);
    TH1F* h31=new TH1F("t1tof.beta","t1tof.beta",1000,-1.,5.);
    TH1F* h32=new TH1F("t1tof.length","t1tof.length",1000,0.,250.);

    TH1F* h33=new TH1F("ratiop1t0p","p1/t0.p",100,0.,10.);
    TH1F* h34=new TH1F("ratiop2t1p","p2/t1.p",100,0.,10.);
    TH1F* h35=new TH1F("S","S",150,0.,1.5);
    TH1F* h40=new TH1F("t0chi2","t0.chi2",1000,0.,1000.);
    TH1F* h41=new TH1F("t1chi2","t1.chi2",1000,0.,1000.);
    TH1F* h42=new TH1F("h42","cos_2t",100,-1.,1.);
    TH1F* h45=new TH1F("t0.nhitsxy","t0.nhitsxy",100,0.,100.);
    TH1F* h46=new TH1F("t1.nhitsxy","t1.nhitsxy",100,0.,100.);
    TH1F* h47=new TH1F("t0.nvecxy","t0.nvecxy",100,0.,100.);
    TH1F* h48=new TH1F("t1.nvecxy","t1.nvecxy",100,0.,100.);
    TH1F* h49=new TH1F("t0.nvec","t0.nvec",100,0.,100.);
    TH1F* h50=new TH1F("t1.nvec","t1.nvec",100,0.,100.);
    TH1F* h51=new TH1F("clgamma0theta","clgamma0.theta",1000,0.,185.);
    TH1F* h52=new TH1F("clgamma1theta","clgamma1.theta",1000,0.,185.);
    TH1F* h53=new TH1F("cos(cl.theta)","cos(cl.theta)",100,-1.,1.);
    TH1F* h58=new TH1F("munhits","mu.nhits",30,0.,30.);
    TH1F* hzero=new TH1F("hzero","Jpsi->pi^{+}pi^{-}pi^{0}",1600,0,1600);
    TH1F* hzero1=new TH1F("hzero1","vrt.theta2t",1000,0.,185.);
    TH1F* hzero2=new TH1F("hzero2","cos(theta2t)",100,-1.,1.);
    TH1F* hzero4=new TH1F("hzero4","Energy",1000,0.,5000.);
    TH1F* hzero5=new TH1F("hzero5","emc.ncls",12,0.,12.);

    char branchname[1];
    char branchname1[161];

    char namepr[0], namepr1[0], namepr2[0];
    if(sim==1)sprintf(namepr,"Simulation");
    if(sim!=1)sprintf(namepr,"Experiment");
    TProfile* prthink=new TProfile(namepr,namepr,50,0,1600,0,500);
    if(sim==1)sprintf(namepr1,"Simulation - 1 layer");
    if(sim!=1)sprintf(namepr1,"Experiment - 1 layer");
    pr1=new TProfile(namepr1,namepr1,50,0,1600,0,500);
    if(sim==1)sprintf(namepr2,"Simulation - 2 layer");
    if(sim!=1)sprintf(namepr2,"Experiment - 2 layer");
    pr2=new TProfile(namepr2,namepr2,50,0,1600,0,500);

    //event loop
    for(int k=0; k<nentr; k++)
    {
	tt->GetEntry(k);
	if(verbose2) cout<<"ev.run="<<ev.run<<"\t"<<"t0.t="<<t0.t<<"\t"<<"t1.t="<<t1.t<<"\t"<<"t2.t="<<t2.t<<"\t"<<"t3.t="<<t3.t<<endl;

	if( (k %100000)==0 )cout<<k<<endl;

	//momentum of particles
	P1=0, P2=0, P3=0, P4;
	P1=t0.p; P2=t1.p; P3=t2.p; P4=t3.p;

	float en0[3], en1[3], en2[3], en3[3], engamma[4];
	en0[0]=t0c0.e; en0[1]=t0c1.e; en0[2]=t0c2.e;      //energy clasters 0,1,2 on first track
	en1[0]=t1c0.e; en1[1]=t1c1.e; en1[2]=t1c2.e;      //energy clasters 0,1,2 on second track
	en2[0]=t2c0.e; en2[1]=t2c1.e; en2[2]=t2c2.e;      //energy clasters 0,1,2 on third track
	en3[0]=t3c0.e; en3[1]=t3c1.e; en3[2]=t3c2.e;      //energy clasters 0,1,2 on four track
	engamma[0]=clgamma0.e; engamma[1]=clgamma1.e; engamma[2]=clgamma2.e; engamma[3]=clgamma3.e;  //energy clasters 0,1,2,3 from Photons
	float e0=0,e1=0,e2=0,e3=0,egamma=0;

	for(int i=0; i<t0.emc_ncls; i++){
	    e0+=en0[i];                                   //sum energy from clasters on first track
	}
	for(int i=0; i<t1.emc_ncls; i++){
	    e1+=en1[i];                                   //sum energy from clasters on second track
	}
	for(int i=0; i<t2.emc_ncls; i++){
	    e2+=en2[i];                                   //sum energy from clasters on thrird track
	}
	for(int i=0; i<t3.emc_ncls; i++){
	    e3+=en3[i];                                   //sum energy from clasters on four track
	}
	for(int i=0; i<(emc.ncls-t0.emc_ncls-t1.emc_ncls); i++)
	{
	    egamma+=engamma[i];                          //sum energy from clasters on Photon
	}

        //Apply cut conditions
	if( t0.emc_ncls>=0 && t1.emc_ncls>=0 && emc.ncls>=0 && emc.ncls<=10 )
	{
	    Nselect++;

	    if(verbose) cout<<ev.run<<"\t"<<ev.evdaq<<"\t"<<"\t"<<t0.p<<"\t"<<t1.p<<"\t"<<P1<<"\t"<<P2<<"\t"<<(P1/t0.p)<<"\t"<<(P2/t1.p)<<"\t"<<(P1/t0.p)/(P2/t1.p)<<"\t"<<(t0.vx*t1.vx+t0.vy*t1.vy+t0.vz*t1.vz)<<"\t"<<clgamma0.vx*clgamma1.vx+clgamma0.vy*clgamma1.vy+clgamma0.vz*clgamma1.vz<<"\t"<<t0c0.e<<"\t"<<t0c1.e<<"\t"<<t1c0.e<<"\t"<<t1c1.e<<"\t"<<clgamma0.e<<"\t"<<clgamma1.e<<"\t"<<emc.ncls<<"\t"<<t0.emc_ncls<<"\t"<<t1.emc_ncls<<"\t"<<emc.ncls-t0.emc_ncls-t1.emc_ncls<<"\t"<<t0tof.nhits<<"\t"<<t1tof.nhits<<endl;

	    henergy->Fill(emc.energy);
	    henlkr->Fill(emc.elkr);
	    hencsi->Fill(emc.ecsi);
	    hmom->Fill(P1); hmom->Fill(P2); hmom->Fill(P3); hmom->Fill(P4);
            for(int i=0; i<4; i++) hmbc->Fill(Dmeson.Mbc[i]);
	    hep->Fill(e0/P1); hep->Fill(e1/P2); hep->Fill(e2/P3); hep->Fill(e3/P4);

	    h8->Fill(t0.theta);
	    h8->Fill(t1.theta);
	    h9->Fill(t0.phi);
	    h9->Fill(t1.phi);
	    h10->Fill(vrt.theta2t);
	    h11->Fill(vrt.phi2t);

	    h12->Fill(cos(pi*(vrt.theta2t)/180));
	    h13->Fill(cos(pi*vrt.phi2t/180));
	    h14->Fill(cos(pi*t0.theta/180));
	    h15->Fill(cos(pi*t0.phi/180));
	    h14->Fill(cos(pi*t1.theta/180));
	    h15->Fill(cos(pi*t1.phi/180));

	    h19->Fill(t0tof.nhits);
	    h20->Fill(t0tof.dchits);
	    h21->Fill(t0tof.namps);
	    h22->Fill(t0tof.ntimes);
	    h23->Fill(t0tof.time[0]);
	    h24->Fill(t0tof.beta[0]);
	    h25->Fill(t0tof.length[0]);

	    h26->Fill(t1tof.nhits);
	    h27->Fill(t1tof.dchits);
	    h28->Fill(t1tof.namps);
	    h29->Fill(t1tof.ntimes);
	    h30->Fill(t1tof.time[1]);
	    h31->Fill(t1tof.beta[1]);
	    h32->Fill(t1tof.length[1]);

	    h33->Fill(P1/t0.p);
	    h34->Fill(P2/t1.p);

	    S=(3/2)*(pow(t0.pt,2)+pow(t1.pt,2))/(pow(t0.p,2)+pow(t1.p,2));
	    h35->Fill(S);

	    h40->Fill(t0.chi2);
	    h41->Fill(t1.chi2);
	    h42->Fill(t0.vx*t1.vx+t0.vy*t1.vy+t0.vz*t1.vz);
	    hncls->Fill(emc.ncls);
	    h45->Fill(t0.nhitsxy);
	    h46->Fill(t1.nhitsxy);
	    h47->Fill(t0.nvecxy);
	    h48->Fill(t1.nvecxy);
	    h49->Fill(t0.nvec);
	    h50->Fill(t1.nvec);
	    h51->Fill(clgamma0.theta);
	    h52->Fill(clgamma1.theta);
	    h53->Fill(cos(pi*(clgamma0.theta-clgamma1.theta)/180));
	    h58->Fill(mu.nhits);

	    if(verbose1)cout<<t0c0.theta<<"\t"<<t1c0.theta<<"\t"<<clgamma0.theta<<"\t"<<clgamma1.theta<<"\t"<<(clgamma0.theta+clgamma1.theta)/2<<"\t"<<clgamma0.theta-clgamma1.theta<<"\t"<<clgamma0.vx*clgamma1.vx+clgamma0.vy*clgamma1.vy+clgamma0.vz*clgamma1.vz<<endl;


            //=====for fill atc=======================================================================
	    kk=0; int kk1=0; int kk2=0; int ii1=0; int ii2=0;
	    //cout<<t0atccr0.aerogel_region5<<"\t"<<t0atccr0.npe<<endl;
	    n00=0, n01=0, n02=0, n03=0, n04=0;
	    n10=0, n11=0, n12=0, n13=0, n14=0;

	    cnt11=0, cnt12=0;
	    cnt21=0, cnt22=0;

            atc_cross();

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

	    //============================================================================

	    float E;
	    E=ev.ebeam;
	    if(sim==1)E=3770/2;          //psi3770

	    Double_t E1, E2;
	    if(t0.q<0)
	    {
		E1=abs(sqrt(P1*P1+m1*m1));   //K-     - 1 track is K-
		E2=abs(sqrt(P2*P2+m2*m2));   //pi+    - 2 track is pi+
	    }
	    else
	    {
		E1=abs(sqrt(P2*P2+m1*m1));    //K-     - 2 track is K-
		E2=abs(sqrt(P1*P1+m2*m2));    //pi+    - 1 track is pi+
	    }

	    Double_t pprod=abs(P1)*abs(P2)*(t0.vx*t1.vx+t0.vy*t1.vy+t0.vz*t1.vz);
	    Double_t InvMass=sqrt(m1*m1+m2*m2+2*(E1*E2-pprod));
	    h16->Fill(InvMass);

	    Double_t mbc=pow(ev.ebeam,2)-pow(P1,2)-pow(P2,2)-P1*P2*(t0.vx*t1.vx+t0.vy*t1.vy+t0.vz*t1.vz);
	    //*mbc = ebeam*ebeam - pow(px1+px2,2)- pow(py1+py2,2) - pow(pz1+pz2,2);
	    if (mbc>0) mbc = sqrt(mbc); else mbc = 0;

	    //if( (P1>400 && P2>1300 && Npe1tr<0.7 && Npe2tr>0.7) || (P1>1300 && P2>400 && Npe1tr>0.7 && Npe2tr<0.7) )
	    //hmbc->Fill(mbc);

	    Double_t ekminuspiplus=0;
	    Double_t ekpluspiminus=0;
	    if(t0.q<0)
	    {
		ekminuspiplus=sqrt(m1*m1 + P1*P1) + sqrt(m2*m2 + P2*P2);
		ekpluspiminus=sqrt(m1*m1 + P2*P2) + sqrt(m2*m2 + P1*P1);
	    }
	    else
	    {
		ekminuspiplus=sqrt(m1*m1 + P2*P2) + sqrt(m2*m2 + P1*P1);
		ekpluspiminus=sqrt(m1*m1 + P1*P1) + sqrt(m2*m2 + P2*P2);
	    }
	    Double_t de = ( ekminuspiplus + ekpluspiminus )/2. - ev.ebeam;
	    h18->Fill(de);

	}  //if  t emc ...
    }

    //cout<<"Natc="<<Natc<<"\t"<<"ATC from selected events, % "<<float(Natc*100/(Nselect*2))<<endl;
    cout<<"Nselect="<<Nselect<<endl;

    if(verbose1) cout<<counter<<endl;

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

    TString KEDR = "/home/ovtin/public_html/outDmeson/";
    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptStat(1111);
    gStyle->SetOptFit(1011);
    gROOT->SetStyle("Plain");
    cc1->cd();
    hmbc->Draw();
    cc1->SaveAs(KEDR+"Mbc.png");
    hmbc->GetXaxis()->SetRangeUser(1600,1900);
    hmbc->Draw();
    cc1->SaveAs(KEDR+"Mbc_zoom.png");
    henergy->Draw();
    cc1->SaveAs(KEDR+"emc_energy.png");
    hmom->Draw();
    cc1->SaveAs(KEDR+"momentum.png");
    hncls->Draw();
    cc1->SaveAs(KEDR+"ncls.png");
    hep->Draw();
    cc1->SaveAs(KEDR+"ep.png");

    fout->Write();
    fout->Close();
}

void atc_cross()
{

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


