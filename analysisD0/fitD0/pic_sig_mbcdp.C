{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);
  gStyle->SetPadTopMargin(0.06);
  gStyle->SetPadRightMargin(0.06);
  gStyle->SetPadBottomMargin(0.15);
  gStyle->SetPadLeftMargin(0.17);
  gStyle->SetLabelSize(0.06,"xyz");
  gStyle->SetTitleSize(0.06,"xyz");
  gStyle->SetTitleOffset(1.2,"xyz");
  gStyle->SetNdivisions(505);

  int sig_color = 625;

  TNtuple nt("nt","NTuple","mbc:de:dp");

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  FILE* file = fopen("dat/kp_signal_corr.dat","r");

  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
  }
  
  fclose(file);

  FILE* file = fopen("gen/sig_corr.gen","r");

  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt2.Fill(mbc,de,dp);
    }
  }
  
  fclose(file);

  TH1F mbc1("mbc1","#Delta|p|<50 MeV",70,1830.,1900.);
  TH1F mbc2("mbc2","",70,1830.,1900.);
  
  nt->Project("mbc1","mbc","abs(dp)<50");
  nt2->Project("mbc2","1864.8+0.92*(mbc-1865)","abs(dp)<50");
  double scale = mbc1->GetSumOfWeights()/mbc2->GetSumOfWeights();
  mbc2->Scale(1.04*scale);

  TH1F mbc3("mbc3","#Delta|p|>150 MeV",70,1830.,1900.);
  TH1F mbc4("mbc4","",70,1830.,1900.);
  
  nt->Project("mbc3","mbc","abs(dp)>150");
  nt2->Project("mbc4","1864.8+1.2*(mbc-1865)","abs(dp)>150");
  mbc4->Scale(1.04*scale);

  TCanvas c("c","c",300,300);

  c.cd();
  nt->SetMarkerSize(0.15);
  nt->SetMarkerStyle(1);
  nt->Draw("mbc:dp","mbc>1830");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("#Delta|p| (MeV)");
  htemp->GetYaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");

  c.Print("sig_mbcdp.eps");
}
