{
/*
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
  gStyle->SetTitleOffset(1.1,"xyz");
  gStyle->SetNdivisions(505);
*/

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

  int mbcmax;
  double rmax;
  TString prefOutfile;
  TString dat_dirname;
  TString dataFile;
  TString gen_dirname;
  TString infile;
  TString outfile1;
  TString outfile2;
  TString outfile3;
  TString exp_sig;
  TString exp_bck;
  TString exp_dbck;

  int key = 2016;

  bool atc = 1;

  TFile *fout=0;
  fout = new TFile("result_hists.root","RECREATE");

  //TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/";
  TString KEDR="/spool/users/ovtin/outDmeson/Dplus/results/fitsDplus/forTest/";

  if( key==2004 ) {
      infile = "dat/kpp_2004.dat";
      mbcmax = 45;
      rmax = 46.;
      outfile1 = "kpp_exp_mbc_2004";
      outfile2 = "kpp_exp_de_2004";
      outfile3 = "kpp_exp_mbcde_2004";
      exp_sig = "gen/exp_sig_2004.gen";
      exp_bck = "gen/exp_bck_2004.gen";
      exp_dbck = "gen/exp_dbck_2004.gen";
  }
  else{
      if (atc ){
          dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_tof_atc_ATC.dat";
          gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600_test";
	  prefOutfile = "KemcAllowedOn_kNoiseReject3_1.0150_tof_atcPthr600_test";

	  //mbcmax = 50;
	  //rmax = 50.;
	  mbcmax = 90;
	  rmax = 90.;

	  infile = "dat/" + dat_dirname + "/" + dataFile;

	  outfile1 = "kpp_exp_mbc_" + prefOutfile;
	  outfile2 = "kpp_exp_de_" + prefOutfile;
	  outfile3 = "kpp_exp_mbcde_" + prefOutfile;

	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
      else{
          dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150.dat";
          gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
          prefOutfile = "KemcAllowedOn_kNoiseReject3_1.0150";

	  mbcmax = 120;
	  rmax = 120.;

	  infile = "dat/" + dat_dirname + "/" + dataFile;

	  outfile1 = "kpp_exp_mbc_" + prefOutfile;
	  outfile2 = "kpp_exp_de_" + prefOutfile;
	  outfile3 = "kpp_exp_mbcde_" + prefOutfile;

	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
  }

  int bck_color = 8;
  int dbck_color = 9;
  int sig_color = 2;
  int bck_style = 3505;
  int dbck_style = 3544;
  int sig_style = 3595;

  TString type = "tof2";

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

  TCanvas c("c","c",800,800);
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
  //double rmax = 46.;
  b.SetFillColor(sig_color);
  b.SetFillStyle(sig_style);
  b.SetLineColor(1);
  b.SetLineStyle(1);
  b.SetLineWidth(1);
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

//  c3.GetPad(0)->SetLeftMargin(4.);
  exp_nt.SetMarkerSize(0.5);
  exp_nt.SetMarkerStyle(20);
  exp_nt.Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");
//  TEllipse e(1869., 0., 15., 70.);
//  e.SetLineColor(sig_color);
//  e.SetLineWidth(3);
//  e.Draw();
  TLine l;
  l.SetLineColor(sig_color);
  l.SetLineWidth(3);
  l.DrawLine(1860., -300., 1860., 300);
  l.DrawLine(1880., -300., 1880., 300);
  l.DrawLine(1700., -70., 1900., -70);
  l.DrawLine(1700.,  70., 1900.,  70);

  c3.Update();

  c3.Print(KEDR + outfile3 + ".eps");
  c3.Print(KEDR + outfile3 + ".png");

  fout->Write();
  fout->Close();
}
