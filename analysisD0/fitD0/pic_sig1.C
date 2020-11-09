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

  int sig_color = 46;

  TNtuple nt("nt","NTuple","mbc:de:dp");

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  FILE* file = fopen("dat/kp_signal_corr.dat","r");

  int i=0;
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
    i++;
    if (i>10000) break;
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

  TH1F mbc1("mbc1","",50,1800.,1900.);
  TH1F mbc2("mbc2","",50,1800.,1900.);
  
  nt->Project("mbc1","mbc");
  nt2->Project("mbc2","mbc");
  double scale = mbc1->GetSumOfWeights()/mbc2->GetSumOfWeights();
  mbc2->Scale(1.015*scale);

  TH1F de1("de1","",50,-300.,300.);
  TH1F de2("de2","",50,-300.,300.);
  nt->Project("de1","de");
  nt2->Project("de2","de");
  de2->Scale(1.02*scale);

  TCanvas c("c","c",800,300);
  c.Divide(3,1);

  c.cd(1);
  nt->SetMarkerSize(0.1);
  nt->SetMarkerStyle(1);
  nt->Draw("de:mbc","mbc>1800");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");

  c.cd(2);
  mbc1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbc1.SetLineWidth(2);
  mbc1.GetXaxis()->SetNdivisions(505);
  mbc1.Draw("elp");
  mbc2.SetFillColor(sig_color);
  mbc2.Draw("same");
  mbc1.Draw("elpsame");

  c.cd(3);
  de1.GetXaxis()->SetTitle("#DeltaE (MeV)");
  de1.SetLineWidth(2);
  de1.Draw("elp");
  de2.SetFillColor(sig_color);
  de2.Draw("same");
  de1.Draw("elpsame");

}
