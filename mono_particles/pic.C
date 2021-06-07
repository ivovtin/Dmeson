void pic()
{
   TString dir_out="/store/users/ovtin/outDmeson/sim_mono/";

   Double_t Pk[4]={200,500,800,1200};
   Double_t ePk[4]={0,0,0,0};

   Double_t Pp[6]={110,200,500,800,1200,1500};
   Double_t ePp[6]={0,0,0,0,0,0};

   Double_t Pe[4]={500,800,1200,1500};
   Double_t ePe[4]={0,0,0,0};

   TTree *tK[4];
   TFile *fK[4];
   TH1F *hK[4];
   TString inFileK;
   TF1* fitK[4];
   Double_t boardK1[4];
   Double_t boardK2[4];
   Double_t par1K[4];
   Double_t epar1K[4];
   Double_t diffPK[4];

   TCanvas cK("cK","cK",600,600);
   gStyle->SetOptTitle(0);
   gStyle->SetOptStat(1111);
   gStyle->SetOptFit(1011);

   for(int i=0; i<4; i++)
   {
     inFileK = TString::Format("/store/users/ovtin/outDmeson/simulation/mono/kaon/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/mono_%d.root",i+2);
     fK[i] = new TFile(inFileK);
     gDirectory->GetObject("et",tK[i]);
     tK[i]->Print();

     hK[i] = new TH1F(Form("hK%d",i),Form("hK%d",i),200,0.,1500.);
     tK[i]->Draw(Form("bcosm.P >> hK%d",i));

     fitK[i] = new TF1(Form("fitK%d",i),"gaus");
     //if(i==0){ boardK1[i]=100; boardK2[i]=120; }    //110
     if(i==0){ boardK1[i]=155; boardK2[i]=195; }    //200
     if(i==1){ boardK1[i]=460; boardK2[i]=530; }    //500
     if(i==2){ boardK1[i]=730; boardK2[i]=860; }    //800
     if(i==3){ boardK1[i]=1100; boardK2[i]=1300; }  //1200
     hK[i]->Fit(Form("fitK%d",i),"","",boardK1[i],boardK2[i]);
     par1K[i] = fitK[i]->GetParameter(1);
     epar1K[i] = fitK[i]->GetParError(1);
     diffPK[i] = Pk[i] - par1K[i];
     cout<<"par1K="<<par1K[i]<<"\t"<<"epar1K="<<epar1K[i]<<endl;
     cK.Print(dir_out + Form("hK%d.png",i));
   }

   TTree *tp[6];
   TFile *fp[6];
   TH1F *hp[6];
   TString inFilep;
   TF1* fitp[6];
   Double_t boardp1[6];
   Double_t boardp2[6];
   Double_t par1p[6];
   Double_t epar1p[6];
   Double_t diffPp[6];

   TCanvas cp("cp","cp",600,600);
   gStyle->SetOptTitle(0);
   gStyle->SetOptStat(1111);
   gStyle->SetOptFit(1011);

   for(int i=0; i<6; i++)
   {
     inFilep = TString::Format("/store/users/ovtin/outDmeson/simulation/mono/pion/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/mono_%d.root",i+1);
     fp[i] = new TFile(inFilep);
     gDirectory->GetObject("et",tp[i]);
     tp[i]->Print();

     hp[i] = new TH1F(Form("hp%d",i),Form("hp%d",i),200,0.,1800.);
     tp[i]->Draw(Form("bcosm.P >> hp%d",i));

     fitp[i] = new TF1(Form("fitp%d",i),"gaus");
     if(i==0){ boardp1[i]=92; boardp2[i]=117; }     //110
     if(i==1){ boardp1[i]=180; boardp2[i]=212; }    //200
     if(i==2){ boardp1[i]=465; boardp2[i]=530; }    //500
     if(i==3){ boardp1[i]=740; boardp2[i]=860; }    //800
     if(i==4){ boardp1[i]=1080; boardp2[i]=1320; }  //1200
     if(i==5){ boardp1[i]=1340; boardp2[i]=1660; }  //1500
     hp[i]->Fit(Form("fitp%d",i),"","",boardp1[i],boardp2[i]);
     par1p[i] = fitp[i]->GetParameter(1);
     epar1p[i] = fitp[i]->GetParError(1);
     diffPp[i] = Pp[i] - par1p[i];
     cout<<"par1p="<<par1p[i]<<"\t"<<"epar1p="<<epar1p[i]<<endl;
     cp.Print(dir_out + Form("hp%d.png",i));
   }

   TTree *te[4];
   TFile *fe[4];
   TH1F *he[4];
   TString inFilee;
   TF1* fite[4];
   Double_t boarde1[4];
   Double_t boarde2[4];
   Double_t par1e[4];
   Double_t epar1e[4];
   Double_t diffPe[4];

   TCanvas ce("ce","ce",600,600);
   gStyle->SetOptTitle(0);
   gStyle->SetOptStat(1111);
   gStyle->SetOptFit(1011);

   for(int i=0; i<4; i++)
   {
     inFilee = TString::Format("/store/users/ovtin/outDmeson/simulation/mono/electron/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/mono_%d.root",i+1);
     fe[i] = new TFile(inFilee);
     gDirectory->GetObject("et",te[i]);
     te[i]->Print();

     he[i] = new TH1F(Form("he%d",i),Form("he%d",i),200,0.,1800.);
     te[i]->Draw(Form("bcosm.P >> he%d",i));

     fite[i] = new TF1(Form("fite%d",i),"gaus");
     if(i==0){ boarde1[i]=465; boarde2[i]=535; }    //500
     if(i==1){ boarde1[i]=730; boarde2[i]=862; }    //800
     if(i==2){ boarde1[i]=1090; boarde2[i]=1310; }  //1200
     if(i==3){ boarde1[i]=1330; boarde2[i]=1670; }  //1500
     he[i]->Fit(Form("fite%d",i),"","",boarde1[i],boarde2[i]);
     par1e[i] = fite[i]->GetParameter(1);
     epar1e[i] = fite[i]->GetParError(1);
     diffPe[i] = Pe[i] - par1e[i];
     cout<<"par1e="<<par1e[i]<<"\t"<<"epar1e="<<epar1e[i]<<endl;
     ce.Print(dir_out + Form("he%d.png",i));
   }


   TCanvas c1("c1","c1",600,600);
   gStyle->SetOptTitle(0);
   gStyle->SetOptStat(0000);
   gStyle->SetOptFit(0000);
   TGraphErrors *gK = new TGraphErrors(4, Pk, diffPK, ePk, epar1K);
   gK->SetMarkerStyle(20);
   gK->SetMarkerColor(6);
   gK->SetLineColor(6);
   gK->GetXaxis()->SetLimits(0.,1600.);
   gK->GetXaxis()->SetTitle("P (MeV/c)");
   gK->GetYaxis()->SetTitle("#DeltaP (MeV/c)");
   gK->GetYaxis()->SetTitleOffset(1.2);
   gK->Draw("AP");
   TF1 *funcK = new TF1("Kfit","[1]/pow(sqrt(1.-1./pow((sqrt(pow([0],2)+pow(x,2))/[0]),2)),3)+[2]*x");
   funcK->SetParameter(0,500.);
   funcK->SetParameter(1,2.);
   funcK->SetParameter(2,0.);
   funcK->SetLineColor(6);
   gK->Fit("Kfit","","",190,1210);
   //c1.Print(dir_out + "gr_Pdiff_K.png");
   //TCanvas c2("c2","c2",600,600);
   TGraphErrors *gp = new TGraphErrors(6, Pp, diffPp, ePp, epar1p);
   gp->SetMarkerStyle(21);
   gp->SetMarkerColor(5);
   gp->SetLineColor(5);
   //gp->Draw("AP");
   gp->Draw("P");
   TF1 *funcp = new TF1("pfit","[1]/pow(sqrt(1.-1./pow((sqrt(pow([0],2)+pow(x,2))/[0]),2)),3)+[2]*x");
   funcp->SetParameter(0,140.);
   funcp->SetParameter(1,2.);
   funcp->SetParameter(2,0.);
   funcp->SetLineColor(5);
   gp->Fit("pfit","","",100,1510);
   //c2.Print(dir_out + "gr_Pdiff_P.png");
   //TCanvas c3("c3","c3",600,600);
   TGraphErrors *ge = new TGraphErrors(4, Pe, diffPe, ePe, epar1e);
   ge->SetMarkerStyle(22);
   ge->SetMarkerColor(2);
   ge->SetLineColor(2);
   //ge->Draw("AP");
   ge->Draw("P");
   TF1 *funce = new TF1("efit","[1]/pow(sqrt(1.-1./pow((sqrt(pow([0],2)+pow(x,2))/[0]),2)),3)+[2]*x");
   funce->SetParameter(0,0.);
   funce->SetParameter(1,2.);
   funce->SetParameter(2,0.);
   funce->SetLineColor(2);
   ge->Fit("efit","","",490,1510);
   //c3.Print(dir_out + "gr_Pdiff_e.png");

   TLegend *leg = new TLegend(0.80,0.72,0.88,0.85);
   leg->AddEntry(gK,"K","l");
   leg->AddEntry(gp,"#pi","l");
   leg->AddEntry(ge,"e^{-}","l");
   leg->SetTextSize(0.03);
   leg->SetBorderSize(0);  //no border for legend
   leg->SetFillColor(0);
   leg->Draw("same");

   c1.Print(dir_out + "gr_Pdiff.png");

}
