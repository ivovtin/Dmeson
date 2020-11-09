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

  FILE* file = fopen("dat/kp_signal_def.dat","r");

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

  FILE* file = fopen("gen/sig_def.gen","r");

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
  nt2->Project("mbc2","1864.5+0.90*(mbc-1864.6)","abs(dp)<50");
  double scale = mbc1->GetSumOfWeights()/mbc2->GetSumOfWeights();
  mbc2->Scale(1.04*scale);

  TH1F mbc3("mbc3","#Delta|p|>150 MeV",70,1830.,1900.);
  TH1F mbc4("mbc4","",70,1830.,1900.);
  
  nt->Project("mbc3","mbc","abs(dp)>150");
  nt2->Project("mbc4","1864.3+1.02*(mbc-1864.6)","abs(dp)>150");
  mbc4->Scale(1.07*scale);

  TCanvas c("c","c",800,300);
  c.Divide(3,1);

  c.cd(1);
  nt->SetMarkerSize(0.15);
  nt->SetMarkerStyle(1);
  nt->Draw("mbc:dp","mbc>1830");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("#Delta|p| (MeV)");
  htemp->GetYaxis()->SetTitle("M_{bc} (MeV)");
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
  mbc3.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbc3.SetLineWidth(2);
  mbc3.GetXaxis()->SetNdivisions(505);
  mbc3.Draw("elp");
  mbc4.SetFillColor(sig_color);
  mbc4.Draw("same");
  mbc3.Draw("elpsame");

}
