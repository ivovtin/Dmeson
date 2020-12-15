{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);
  gStyle->SetHistLineWidth(2);
  gStyle->SetHistLineColor(4);

  TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/";
  //TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/forTest/";

  TString type = "tof";

  TNtuple nt("nt","NTuple","mbc:de:dp");

  FILE* file = fopen(TString("dat/kpp_uds.dat").Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
  }

  fclose(file);

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  file = fopen(TString("gen/bck.gen").Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt2.Fill(mbc,de,dp);
    }
  }

  fclose(file);

  TH1F de1("de1","",30,-300.,300.);
  TH1F de2("de2","",30,-300.,300.);
  de2.SetLineColor(2);

  nt->Project("de1","de");
  nt2->Project("de2","de");
  double scale = de1->GetSumOfWeights()/de2->GetSumOfWeights();

  de2->Scale(scale);

  TH1F mbc1("mbc1","",80,1700.,1900.);
  TH1F mbc2("mbc2","",80,1700.,1900.);
  mbc2.SetLineColor(2);

  nt->Project("mbc1","mbc","abs(de)<300");
  nt2->Project("mbc2","mbc","abs(de)<300");
  mbc2->Scale(scale);

  TH1F de3("de3","M_{bc}<1800 MeV",30,-300.,300.);
  TH1F de4("de4","M_{bc}<1800 MeV",30,-300.,300.);
  de4.SetLineColor(2);

  nt->Project("de3","de","mbc<1800");
  nt2->Project("de4","de","mbc<1800");
  de4->Scale(scale);

  TH1F de5("de5","1800<M_{bc}<1850 MeV",30,-300.,300.);
  TH1F de6("de6","1800<M_{bc}<1850 MeV",30,-300.,300.);
  de6.SetLineColor(2);

  nt->Project("de5","de","mbc>1800&&mbc<1850");
  nt2->Project("de6","de","mbc>1800&&mbc<1850");
  de6->Scale(scale);

  TH1F de7("de7","M_{bc}>1850 MeV",30,-300.,300.);
  TH1F de8("de8","M_{bc}>1850 MeV",30,-300.,300.);
  de8.SetLineColor(2);

  nt->Project("de7","de","mbc>1850");
  nt2->Project("de8","de","mbc>1850");
  de8->Scale(scale);

  TCanvas c("c","c",800,600);
  c.Divide(3,2);

  c.cd(1);
  mbc1.Draw("elp");
  mbc1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbc2.Draw("same");

  c.cd(2);
  de1.Draw("elp");
  de1.GetXaxis()->SetTitle("#Delta E (MeV)");
  de2.Draw("same");

  c.cd(3);
  nt->Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");

  c.cd(4);
  de3.Draw("elp");
  de3.GetXaxis()->SetTitle("#Delta E (MeV)");
  de4.Draw("same");

  c.cd(5);
  de5.Draw("elp");
  de5.GetXaxis()->SetTitle("#Delta E (MeV)");
  de6.Draw("same");

  c.cd(6);
  de7.Draw("elp");
  de7.GetXaxis()->SetTitle("#Delta E (MeV)");
  de8.Draw("same");

  c.Print(KEDR+"uds"+type+".eps");
  c.Print(KEDR+"uds"+type+".png");
}
