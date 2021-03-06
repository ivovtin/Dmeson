{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);
  gStyle->SetHistLineWidth(2);
  gStyle->SetHistLineColor(4);

  //TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/";
  TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/forTest/";

  TString type = "tof";

  TNtuple nt("nt","NTuple","mbc:de:dp");

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  FILE* file = fopen(TString("dat/kpp_signal_def.dat").Data(),"r");
  //FILE* file = fopen(TString("dat/old/kpp_signal_def.dat").Data(),"r");

  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
  }

  fclose(file);

  FILE* file = fopen("gen/sig.gen","r");

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

  TH1F mbcs1("mbcs1","",80,1850.,1890.);
  TH1F mbcs2("mbcs2","",80,1850.,1890.);
  nt->Project("mbcs1","mbc","de<-50");
  nt2->Project("mbcs2","mbc","de<-50");
  mbcs2->Scale(scale);

  TH1F mbcs3("mbcs3","",80,1850.,1890.);
  TH1F mbcs4("mbcs4","",80,1850.,1890.);
  nt->Project("mbcs3","mbc","abs(de)<200");
  nt2->Project("mbcs4","mbc","abs(de)<200");
  mbcs4->Scale(scale);

  TH1F mbcs5("mbcs5","",80,1850.,1890.);
  TH1F mbcs6("mbcs6","",80,1850.,1890.);
  nt->Project("mbcs5","mbc","de>50");
  nt2->Project("mbcs6","mbc","de>50");
  mbcs6->Scale(scale);

  TH1F de1("de1","",80,-200., 200.);
  TH1F de2("de2","",80,-200., 200.);

  nt->Project("de1","de","mbc>1850");
  nt2->Project("de2","de","mbc>1850");
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
  nt->Draw("de:mbc","abs(de)<200&&mbc>1850&&mbc<1890");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");

  c.Print(KEDR+"sig_"+type+".eps");
  c.Print(KEDR+"sig_"+type+".png");
}
