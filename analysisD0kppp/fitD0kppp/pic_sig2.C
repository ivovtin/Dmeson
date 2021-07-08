{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);
  gStyle->SetHistLineWidth(2);
  gStyle->SetHistLineColor(4);

  TString KEDR="/store/users/ovtin/outDmeson/D0kppp/fitsD0kppp/";
  //TString KEDR="/store/users/ovtin/outDmeson/D0kppp/fitsD0kppp/forTest/";

  //TString type = "tof_S1.0_A6.0_Z0.0";
  TString type = "tof_atc_S1.0_A6.0_Z0.0";

  TNtuple nt("nt","NTuple","mbc:de:dp");

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  //FILE* file = fopen(TString("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kppp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat").Data(),"r");
  FILE* file = fopen(TString("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kppp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat").Data(),"r");

  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
  }

  fclose(file);

  //FILE* file = fopen("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/sig_S1.0_A6.0_Z0.0.gen","r");
  FILE* file = fopen("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_S1.0_A6.0_Z0.0.gen","r");

  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt2.Fill(mbc,de,dp);
    }
  }

  fclose(file);

  TH1F mbc1("mbc1","",50,1800.,1900.);
  TH1F mbc2("mbc2","",50,1800.,1900.);

  nt->Project("mbc1","mbc");
  nt2->Project("mbc2","mbc");
  double scale = mbc1->GetSumOfWeights()/mbc2->GetSumOfWeights();
  mbc2->Scale(scale);

  TH1F mbcs1("mbcs1","",90,1800.,1890.);
  TH1F mbcs2("mbcs2","",90,1800.,1890.);
  nt->Project("mbcs1","mbc","de<-60");
  nt2->Project("mbcs2","mbc","de<-60");
  mbcs2->Scale(scale);

  TH1F mbcs3("mbcs3","",90,1800.,1890.);
  TH1F mbcs4("mbcs4","",90,1800.,1890.);
  nt->Project("mbcs3","mbc","abs(de)<300");
  nt2->Project("mbcs4","mbc","abs(de)<300");
  mbcs4->Scale(scale);

  TH1F mbcs5("mbcs5","",90,1800.,1890.);
  TH1F mbcs6("mbcs6","",90,1800.,1890.);
  nt->Project("mbcs5","mbc","de>60");
  nt2->Project("mbcs6","mbc","de>60");
  mbcs6->Scale(scale);

  TH1F de1("de1","",100,-300., 300.);
  TH1F de2("de2","",100,-300., 300.);

  nt->Project("de1","de","mbc>1855 && mbc<1875 ");
  nt2->Project("de2","de","mbc>1855 && mbc<1875 ");
  de2->Scale(scale);

  TCanvas c("c","c",800,300);
  c.Divide(3,1);

  c.cd(1);
  mbcs4.SetLineColor(2);
  mbcs4.Draw();
  mbcs4.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbcs3.Draw("elpsame");

  c.cd(2);
  de2.SetLineColor(2);
  de2.Draw();
  de2.GetXaxis()->SetTitle("#Delta E (MeV)");
  de1.Draw("elpsame");

  c.cd(3);
  nt->Draw("de:mbc","abs(de)<300&&mbc>1800&&mbc<1890");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");

  c.Print(KEDR+"sig_"+type+".eps");
  c.Print(KEDR+"sig_"+type+".png");
}
