{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);

  //TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/";
  TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/forTest/";

  TString type = "tof";

  TNtuple nt("nt","NTuple","mbc:de:dp");

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  FILE* file = fopen(TString("dat/kpp_signal_def.dat").Data(),"r");

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

  TH1F mbcs1("mbcs1","",50,1800.,1900.);
  TH1F mbcs2("mbcs2","",50,1800.,1900.);
  nt->Project("mbcs1","mbc","de<-50");
  nt2->Project("mbcs2","mbc","de<-50");
  mbcs2->Scale(scale);

  TH1F mbcs3("mbcs3","",50,1800.,1900.);
  TH1F mbcs4("mbcs4","",50,1800.,1900.);
  nt->Project("mbcs3","mbc","abs(de)<50");
  nt2->Project("mbcs4","mbc","abs(de)<50");
  mbcs4->Scale(scale);

  TH1F mbcs5("mbcs5","",50,1800.,1900.);
  TH1F mbcs6("mbcs6","",50,1800.,1900.);
  nt->Project("mbcs5","mbc","de>50");
  nt2->Project("mbcs6","mbc","de>50");
  mbcs6->Scale(scale);

  TH1F de1("de1","",50,-300.,300.);
  TH1F de2("de2","",50,-300.,300.);

  nt->Project("de1","de");
  nt2->Project("de2","de");
  de2->Scale(scale);

  TCanvas c("c","c",800,800);
  c.Divide(3,3);

  c.cd(1);
  mbc1.Draw("elp");
  mbc2.Draw("same");

  c.cd(2);
  de1.Draw("elp");
  de2.Draw("same");

  c.cd(3);
  mbcs1.Draw("elp");
  mbcs2.Draw("same");

  c.cd(4);
  mbcs3.Draw("elp");
  mbcs4.Draw("same");

  c.cd(5);
  mbcs5.Draw("elp");
  mbcs6.Draw("same");

  c.cd(8);
  nt->Draw("mbc:de");

  c.cd(9);
  nt2->Draw("mbc:de");

}
