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
  gStyle->SetNdivisions(510);
  gStyle->SetHistLineWidth(3);
  gStyle->SetHatchesLineWidth(3);

/*
  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);
  gStyle->SetPadTopMargin(0.06);
  gStyle->SetPadRightMargin(0.06);
  gStyle->SetPadBottomMargin(0.15);
  gStyle->SetPadLeftMargin(0.15);
  gStyle->SetLabelSize(0.06,"xyz");
  gStyle->SetTitleSize(0.06,"xyz");
  gStyle->SetTitleOffset(1.1,"xyz");
  gStyle->SetNdivisions(510);
  */

  //TFile *fout=0;
  //fout = new TFile("result_hists.root","RECREATE");
  /*
  int bck_color = 41;
  int dbck_color = 38;
  int sig_color = 50;
  */
  int bck_color = 8;
  int dbck_color = 9;
  int sig_color = 2;

  int bck_style = 3505;
  int dbck_style = 3544;
  int sig_style = 3595;

  TString KEDR = "/spool/users/ovtin/outDmeson/D0/results/fitsD0/";
  //TString KEDR = "/spool/users/ovtin/outDmeson/D0/results/fitsD0/forTest/";

  int key = 2016;

  char *infile;
  int mbcmax;
  double rmax;
  TString outfile1;
  TString outfile2;
  TString outfile3;
  char *exp_sig;
  char *exp_bck;
  char *exp_dbck;

  if( key==2004 ) {
      infile = "dat/kp_exp_1.030_2004.dat";
      mbcmax = 35;
      rmax = 35.;
      outfile1 = "kp_exp_mbc_2004";
      outfile2 = "kp_exp_de_2004";
      outfile3 = "kp_exp_mbcde_2004";
      outfile4 = "kp_exp_expminusBG_2004";
      exp_sig = "gen/exp_sig_2004.gen";
      exp_bck = "gen/exp_bck_2004.gen";
      exp_dbck = "gen/exp_dbck_2004.gen";
  }
  else{
      //infile = "dat/kp_exp_1.0240_2016-17.dat";
      //infile = "dat/kp_exp_1.0185_2016-17.dat";
      infile = "dat/kp_exp_1.0173_2016-17.dat";
      mbcmax = 90;
      rmax = 90.;
      outfile1 = "kp_exp_mbc";
      outfile2 = "kp_exp_de";
      outfile3 = "kp_exp_mbcde";
      outfile4 = "kp_exp_expminusBG";
      exp_sig = "gen/exp_sig.gen";
      exp_bck = "gen/exp_bck.gen";
      exp_dbck = "gen/exp_dbck.gen";
  }

  TNtuple exp_nt("exp_nt","NTuple","mbc:de:dp");
  FILE* file = fopen(infile,"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      exp_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple sig_nt("sig_nt","NTuple","mbc:de:dp");
  file = fopen(exp_sig,"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      sig_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple bck_nt("bck_nt","NTuple","mbc:de:dp");
  file = fopen(exp_bck,"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      bck_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple dbck_nt("dbck_nt","NTuple","mbc:de:dp");
  file = fopen(exp_dbck,"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      dbck_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TH1F exp_dp("exp_dp","DP (MeV)",30,-600.,600.);
  TH1F sig_dp("sig_dp","DP (MeV)",30,-600.,600.);
  TH1F bck_dp("bck_dp","DP (MeV)",30,-600.,600.);
  TH1F dbck_dp("dbck_dp","DP (MeV)",30,-600.,600.);

  exp_nt->Project("exp_dp","dp");
  sig_nt->Project("sig_dp","dp");
  bck_nt->Project("bck_dp","dp");
  dbck_nt->Project("dbck_dp","dp");
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
  /* 
  exp_nt->Project("exp_mbc","mbc","abs(de)<100");
  sig_nt->Project("sig_mbc","mbc","abs(de)<100");
  bck_nt->Project("bck_mbc","mbc","abs(de)<100");
  dbck_nt->Project("dbck_mbc","mbc","abs(de)<100");
  */
  exp_nt->Project("exp_mbc","mbc","abs(de)<150");
  sig_nt->Project("sig_mbc","mbc","abs(de)<150");
  bck_nt->Project("bck_mbc","mbc","abs(de)<150");
  dbck_nt->Project("dbck_mbc","mbc","abs(de)<150");
  sig_mbc->Scale(scale);
  bck_mbc->Scale(scale);
  dbck_mbc->Scale(scale);
//  exp_mbc.GetXaxis()->SetNdivisions(505);
//  sig_mbc.GetXaxis()->SetNdivisions(505);
//  bck_mbc.GetXaxis()->SetNdivisions(505);
//  dbck_mbc.GetXaxis()->SetNdivisions(505);

  TH1F exp_de("exp_de","",30,-300.,300);
  TH1F sig_de("sig_de","DE (MeV)",30,-300.,300);
  TH1F bck_de("bck_de","DE (MeV)",30,-300.,300);
  TH1F dbck_de("dbck_de","DE (MeV)",30,-300.,300);
  exp_nt->Project("exp_de","de","abs(mbc-1865)<10");
  sig_nt->Project("sig_de","de","abs(mbc-1865)<10");
  bck_nt->Project("bck_de","de","abs(mbc-1865)<10");
  dbck_nt->Project("dbck_de","de","abs(mbc-1865)<10");
  sig_de->Scale(scale);
  bck_de->Scale(scale);
  dbck_de->Scale(scale);

  TH1F sig_mbcde("sig_mbcde","",30,-300.,300);
  TH1F bck_mbcde("bck_mbcde","DE (MeV)",30,-300.,300);
  TH1F dbck_mbcde("dbck_mbcde","DE (MeV)",30,-300.,300);
  /*
  sig_nt->Project("sig_mbcde","de","abs(mbc-1865)<10&&abs(de)<100");
  bck_nt->Project("bck_mbcde","de","abs(mbc-1865)<10&&abs(de)<100");
  dbck_nt->Project("dbck_mbcde","de","abs(mbc-1865)<10&&abs(de)<100");
  */
  sig_nt->Project("sig_mbcde","de","abs(mbc-1865)<10&&abs(de)<150");
  bck_nt->Project("bck_mbcde","de","abs(mbc-1865)<10&&abs(de)<150");
  dbck_nt->Project("dbck_mbcde","de","abs(mbc-1865)<10&&abs(de)<150");
  bck_mbcde->Scale(scale);
  dbck_mbcde->Scale(scale);

  printf("Backgrounds:\n UDS bck=%f\n DD bck=%f\n", bck_mbcde->GetSumOfWeights(),
         dbck_mbcde->GetSumOfWeights());

  TCanvas c("c","c",800,800);
//  c.Divide(3,1);

//  c.cd(1);
  c.cd();
  THStack mbc_hs("mbc_hs","");
  mbc_hs->Add(&bck_mbc);
  bck_mbc->SetFillColor(bck_color);
  bck_mbc->SetFillStyle(bck_style);
  mbc_hs->Add(&dbck_mbc);
  dbck_mbc->SetFillColor(dbck_color);
  dbck_mbc->SetFillStyle(dbck_style);
  mbc_hs->Add(&sig_mbc);
  sig_mbc->SetFillColor(sig_color);
  sig_mbc->SetFillStyle(sig_style);

  exp_mbc.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbc.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbc.SetMarkerStyle(20);
  exp_mbc.SetMarkerSize(1.7);
  exp_mbc.Draw("e");
  exp_mbc->GetYaxis()->SetRangeUser(0, mbcmax);
  mbc_hs->Draw("same");
  exp_mbc.SetLineWidth(4);
  exp_mbc.Draw("esame");

  TBox b;
  TLatex t;
  //double rmax = 50.;
  b.SetFillColor(sig_color);
  b.SetFillStyle(sig_style);
  b.SetLineColor(1);
  b.SetLineStyle(1);
  b.SetLineWidth(3);
  b.DrawBox(1795,rmax*0.90,1815,rmax*0.84);
  b.SetFillStyle(0);
  b.DrawBox(1795,rmax*0.90,1815,rmax*0.84);
  t.DrawLatex(1820,rmax*0.84,"Signal");
  b.SetFillColor(dbck_color);
  b.SetFillStyle(dbck_style);
  b.DrawBox(1795,rmax*0.80,1815,rmax*0.74);
  b.SetFillStyle(0);
  b.DrawBox(1795,rmax*0.80,1815,rmax*0.74);
  t.DrawLatex(1820,rmax*0.74,"D#bar{D} bck");
  b.SetFillColor(bck_color);
  b.SetFillStyle(bck_style);
  b.DrawBox(1795,rmax*0.70,1815,rmax*0.64);
  b.SetFillStyle(0);
  b.DrawBox(1795,rmax*0.70,1815,rmax*0.64);
  t.DrawLatex(1820,rmax*0.64,"uds bck");

  c.Update();

  c.Print(KEDR + outfile1 + ".eps");
  c.Print(KEDR + outfile1 + ".png");

  TCanvas c2("c2","c2",800,800);
  c2.cd();

  THStack de_hs("de_hs","");
  de_hs->Add(&bck_de);
  bck_de->SetFillColor(bck_color);
  bck_de->SetFillStyle(bck_style);
  de_hs->Add(&dbck_de);
  dbck_de->SetFillColor(dbck_color);
  dbck_de->SetFillStyle(dbck_style);
  de_hs->Add(&sig_de);
  sig_de->SetFillColor(sig_color);
  sig_de->SetFillStyle(sig_style);

  exp_de.GetXaxis()->SetTitle("#DeltaE (MeV)");
  exp_de.GetYaxis()->SetTitle("Events/20 MeV");
  exp_de.SetMarkerStyle(20);
  exp_de.SetMarkerSize(1.7);
  exp_de.Draw("e");
  de_hs->Draw("same");
  exp_de.SetLineWidth(4);
  exp_de.Draw("esame");

  c2.Update();

  c2.Print(KEDR + outfile2 + ".eps");
  c2.Print(KEDR + outfile2 + ".png");

  TCanvas c3("c3","c3",800,800);
  c3.cd();

  c3.cd();
//  c3.SetLeftMargin(4.);
  exp_nt.SetMarkerSize(0.7);
  exp_nt.SetMarkerStyle(20);
  exp_nt.Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");
//  TEllipse e(1870., 0., 15., 70.);
//  e.SetLineColor(sig_color);
//  e.SetLineWidth(3);
//  e.Draw();
  TLine l;
  l.SetLineColor(sig_color);
  l.SetLineWidth(3);
  /*
  l.DrawLine(1855., -300., 1855., 300);
  l.DrawLine(1875., -300., 1875., 300);
  l.DrawLine(1700., -100., 1900., -100);
  l.DrawLine(1700.,  100., 1900.,  100);
  */
  l.DrawLine(1850., -300., 1850., 300);
  l.DrawLine(1880., -300., 1880., 300);
  l.DrawLine(1700., -150., 1900., -150);
  l.DrawLine(1700.,  150., 1900.,  150);

  c3.Update();

  c3.Print(KEDR + outfile3 + ".eps");
  c3.Print(KEDR + outfile3 + ".png");

  //fout->Write();
  //fout->Close();

}
