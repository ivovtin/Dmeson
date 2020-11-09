{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);

  TNtuple nt("nt","NTuple","mbc:de:dp");

  FILE* file = fopen("dat/kp_dbck.dat","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
  }
  
  fclose(file);

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  file = fopen("gen/dbck_sim.gen","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt2.Fill(mbc,de,dp);
    }
  }
  
  fclose(file);

  TH1F mbc1("mbc1","",50,1800.,1900.);
  TH1F mbc2("mbc2","",50,1800.,1900.);
  nt->Project("mbc1","mbc","abs(de)<300");
  nt2->Project("mbc2","mbc","abs(de)<300");
  double scale = mbc1->GetSumOfWeights()/mbc2->GetSumOfWeights();
  mbc2->Scale(scale);

  TH1F mbcs1("mbcs1","",50,1800.,1900.);
  TH1F mbcs2("mbcs2","",50,1800.,1900.);
  nt->Project("mbcs1","mbc","de<-200");
  nt2->Project("mbcs2","mbc","de<-200");
  mbcs2->Scale(scale);

  TH1F mbcs3("mbcs3","",50,1800.,1900.);
  TH1F mbcs4("mbcs4","",50,1800.,1900.);
  nt->Project("mbcs3","mbc","-200<de&&de<0");
  nt2->Project("mbcs4","mbc","-200<de&&de<0");
  mbcs4->Scale(scale);

  TH1F mbcs5("mbcs5","",50,1800.,1900.);
  TH1F mbcs6("mbcs6","",50,1800.,1900.);
  nt->Project("mbcs5","mbc","0<de");
  nt2->Project("mbcs6","mbc","0<de");
  mbcs6->Scale(scale);

  TH1F de1("de1","",30,-300.,300.);
  TH1F de2("de2","",30,-300.,300.);

  nt->Project("de1","de");
  nt2->Project("de2","de");
  de2->Scale(scale);

  TH1F des1("des1","",30,-300.,300.);
  TH1F des2("des2","",30,-300.,300.);

  nt->Project("des1","de","abs(mbc-1870)<15");
  nt2->Project("des2","de","abs(mbc-1870)<15");
  des2->Scale(scale);

  TH1F des3("des3","",30,-300.,300.);
  TH1F des4("des4","",30,-300.,300.);

  nt->Project("des3","de","mbc<1850");
  nt2->Project("des4","de","mbc<1850");
  des4->Scale(scale);

  TH1F mbcde("mbcde","",30,-300.,300.);

  nt->Project("mbcde","de","abs(de)<100.&&abs(mbc-1870)<10.");
  printf("Events in signal box: %f\n", mbcde->GetSumOfWeights());

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

  c.cd(6);
  des1.Draw("elp");
  des2.Draw("same");

  c.cd(7);
  des3.Draw("elp");
  des4.Draw("same");

  c.cd(8);
  nt->Draw("mbc:de");

  c.cd(9);
  nt2->Draw("mbc:de");
}
