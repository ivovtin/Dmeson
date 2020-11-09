{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);

  TNtuple nt("nt","NTuple","mbc:de:dp");

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

//  FILE* file = fopen("dat/kp_signal_split.dat","r");
  FILE* file = fopen("dat/kp_signal_def.dat","r");

  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
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


  TH1F mbc1("mbc1","Mbc",50,1800.,1900.);
  TH1F mbc2("mbc2","Mbc",50,1800.,1900.);

  nt->Project("mbc1","mbc");
  nt2->Project("mbc2","mbc");
  double scale = mbc1->GetSumOfWeights()/mbc2->GetSumOfWeights();
  mbc2->Scale(scale);

  TH1F mbcs1("mbcs1","Mbc, |DP|<50 MeV",50,1800.,1900.);
  TH1F mbcs2("mbcs2","Mbc, |DP|<50 MeV",50,1800.,1900.);
  nt->Project("mbcs1","mbc","abs(dp)<50");
  nt2->Project("mbcs2","mbc","abs(dp)<50");
  mbcs2->Scale(scale*1.1);

  TH1F mbcs5("mbcs5","Mbc, |DP|>150 MeV",50,1800.,1900.);
  TH1F mbcs6("mbcs6","Mbc, |DP|>150 MeV",50,1800.,1900.);
  nt->Project("mbcs5","mbc","abs(dp)>150");
  nt2->Project("mbcs6","mbc","abs(dp)>150");
  mbcs6->Scale(scale*0.9);

  TH1F de1("de1","DE",50,-300.,300.);
  TH1F de2("de2","DE",50,-300.,300.);
  nt->Project("de1","de");
  nt2->Project("de2","de");
  de2->Scale(scale);

  TH1F dp1("dp1","DP",50,-600.,600.);
  TH1F dp2("dp2","DP",50,-600.,600.);
  nt->Project("dp1","dp");
  nt2->Project("dp2","dp");
  dp2->Scale(scale);

  TCanvas c("c","c",800,600);
  c.Divide(3,2);

  c.cd(1);
  nt->Draw("mbc:dp","mbc>1830");

  c.cd(2);
  mbc1.Draw("elp");
  mbc2.Draw("same");

  c.cd(3);
  de1.Draw("elp");
  de2.Draw("same");

  c.cd(4);
  dp1.Draw("elp");
  dp2.Draw("same");

  c.cd(5);
  mbcs1.Draw("elp");
  mbcs2.Draw("same");

  c.cd(6);
  mbcs5.Draw("elp");
  mbcs6.Draw("same");

  c.Print("mbc_dp.eps");
}
