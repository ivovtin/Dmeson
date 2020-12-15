{

  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);

  int bck_color = 394;
  int dbck_color = 591;
  int sig_color = 625;

  TNtuple exp_nt("exp_nt","NTuple","mbc:de:dp");
  FILE* file = fopen("dat/kpp_exp_1.027.dat","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      exp_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple sig_nt("sig_nt","NTuple","mbc:de:dp");
  file = fopen("gen/exp_sig.gen","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      sig_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple bck_nt("bck_nt","NTuple","mbc:de:dp");
  file = fopen("gen/exp_bck.gen","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      bck_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple dbck_nt("dbck_nt","NTuple","mbc:de:dp");
  file = fopen("gen/exp_dbck.gen","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      dbck_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TH1F exp_dp("exp_dp","DP (MeV)",30,-300.,300.);
  TH1F sig_dp("sig_dp","DP (MeV)",30,-300.,300.);
  TH1F bck_dp("bck_dp","DP (MeV)",30,-300.,300.);
  TH1F dbck_dp("dbck_dp","DP (MeV)",30,-300.,300.);
  exp_nt->Project("exp_dp","de");
  sig_nt->Project("sig_dp","de");
  bck_nt->Project("bck_dp","de");
  dbck_nt->Project("dbck_dp","de");
  double scale = exp_dp->GetSumOfWeights()/
    (sig_dp->GetSumOfWeights()+bck_dp->GetSumOfWeights()+dbck_dp->GetSumOfWeights());
  sig_dp->Scale(scale);
  bck_dp->Scale(scale);
  dbck_dp->Scale(scale);

  printf("Scale=%f\n", scale);
  printf("Signal=%f\n", sig_dp->GetSumOfWeights());

  TH1F exp_mbc("exp_mbc","",55,1790.,1900.);
  TH1F sig_mbc("sig_mbc","Mbc (MeV)",55,1790.,1900.);
  TH1F bck_mbc("bck_mbc","Mbc (MeV)",55,1790.,1900.);
  TH1F dbck_mbc("dbck_mbc","Mbc (MeV)",55,1790.,1900.);
  exp_nt->Project("exp_mbc","mbc","abs(de)<70");
  sig_nt->Project("sig_mbc","mbc","abs(de)<70");
  bck_nt->Project("bck_mbc","mbc","abs(de)<70");
  dbck_nt->Project("dbck_mbc","mbc","abs(de)<70");
  sig_mbc->Scale(scale);
  bck_mbc->Scale(scale);
  dbck_mbc->Scale(scale);
  exp_mbc.GetXaxis()->SetNdivisions(505);
  sig_mbc.GetXaxis()->SetNdivisions(505);
  bck_mbc.GetXaxis()->SetNdivisions(505);
  dbck_mbc.GetXaxis()->SetNdivisions(505);

  TH1F exp_de("exp_de","",30,-300.,300);
  TH1F sig_de("sig_de","DE (MeV)",30,-300.,300);
  TH1F bck_de("bck_de","DE (MeV)",30,-300.,300);
  TH1F dbck_de("dbck_de","DE (MeV)",30,-300.,300);
  exp_nt->Project("exp_de","de","abs(mbc-1870)<10");
  sig_nt->Project("sig_de","de","abs(mbc-1870)<10");
  bck_nt->Project("bck_de","de","abs(mbc-1870)<10");
  dbck_nt->Project("dbck_de","de","abs(mbc-1870)<10");
  sig_de->Scale(scale);
  bck_de->Scale(scale);
  dbck_de->Scale(scale);

  TH1F sig_mbcde("sig_mbcde","",30,-300.,300);
  TH1F bck_mbcde("bck_mbcde","DE (MeV)",30,-300.,300);
  TH1F dbck_mbcde("dbck_mbcde","DE (MeV)",30,-300.,300);
  sig_nt->Project("sig_mbcde","de","abs(mbc-1870)<10&&abs(de)<70");
  bck_nt->Project("bck_mbcde","de","abs(mbc-1870)<10&&abs(de)<70");
  dbck_nt->Project("dbck_mbcde","de","abs(mbc-1870)<10&&abs(de)<70");
  bck_mbcde->Scale(scale);
  dbck_mbcde->Scale(scale);

  printf("Backgrounds:\n UDS bck=%f\n DD bck=%f\n", bck_mbcde->GetSumOfWeights(), 
         dbck_mbcde->GetSumOfWeights());

  TCanvas c("c","c",800,300);
  c.Divide(3,1);

  c.cd(1);
  THStack mbc_hs("mbc_hs","");
  mbc_hs->Add(&bck_mbc);
  bck_mbc->SetFillColor(bck_color);
  mbc_hs->Add(&dbck_mbc);
  dbck_mbc->SetFillColor(dbck_color);
  mbc_hs->Add(&sig_mbc);
  sig_mbc->SetFillColor(sig_color);

  exp_mbc.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbc.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbc.Draw("elp");
  mbc_hs->Draw("same");
  exp_mbc.SetLineWidth(2);
  exp_mbc.Draw("elpsame");

  c.cd(2);
  THStack de_hs("de_hs","");
  de_hs->Add(&bck_de);
  bck_de->SetFillColor(bck_color);
  de_hs->Add(&dbck_de);
  dbck_de->SetFillColor(dbck_color);
  de_hs->Add(&sig_de);
  sig_de->SetFillColor(sig_color);

  exp_de.GetXaxis()->SetTitle("#DeltaE (MeV)");
  exp_de.GetYaxis()->SetTitle("Events/20 MeV");
  exp_de.Draw("elp");
  de_hs->Draw("same");
  exp_de.SetLineWidth(2);
  exp_de.Draw("elpsame");

  c.cd(3);
  c.GetPad(2)->SetLeftMargin(4.);
  exp_nt.SetMarkerSize(0.3);
  exp_nt.SetMarkerStyle(20);
  exp_nt.Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");
  TEllipse e(1869., 0., 15., 70.);
  e.SetLineColor(sig_color);
  e.SetLineWidth(3);
  e.Draw();

  c.Print("exp.eps");
}
