{
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

  int bck_color = 8;
  int dbck_color = 9;
  int sig_color = 2;

  int bck_style = 3505;
  int dbck_style = 3544;
  int sig_style = 3595;

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
  TString corr;

  int mbcmax;
  int mbcmax2;
  int mbcmax3;
  int demax;
  int dpmax;
  double rmax;

  TString KEDR = "/spool/users/ovtin/outDmeson/D0/results/fitsD0/";
  //TString KEDR = "/spool/users/ovtin/outDmeson/D0/results/fitsD0/forTest/";

  int key = 2016;
  bool atc=1;
  //bool atc=0;

  float decut1=100.;
  float decut2=-100.;

  if( key==2004 ) {
      infile = "dat/kp_exp_1.030_2004.dat";
      mbcmax = 38;
      mbcmax2 = 15;
      mbcmax3 = 25;
      demax = 29;
      dpmax = 70;
      rmax = 40.;
      outfile1 = "exp_2004";
      exp_sig = "gen/exp_sig_2004.gen";
      exp_bck = "gen/exp_bck_2004.gen";
      exp_dbck = "gen/exp_dbck_2004.gen";
  }
  else{
      mbcmax2 = 30;
      mbcmax3 = 28;
      if(atc)
      {
	  mbcmax = 50;
	  rmax = 50.;
	  demax = 41;
	  dpmax = 90;

	  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc";
          corr = "1.0130";
	  dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_" + corr + "_atc_dedx_ATC.dat";
          prefOutfile = "KemcAllowedOn_kNoiseReject3_" + corr + "_atc";

	  gen_dirname = dat_dirname;

	  infile = "dat/" + dat_dirname + "/" + dataFile;

	  outfile1 = "exp2016-17_mbc_" + prefOutfile;
	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0_" + corr + ".gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0_" + corr + ".gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0_" + corr + ".gen";
      }
      else
      {
	  mbcmax = 68; //105
	  rmax = 68.; //95.
	  demax = 62; //48
	  dpmax = 175; //170

	  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_woATC";
          corr = "1.0130";
	  dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_" + corr + "_woATC.dat";
          prefOutfile = "KemcAllowedOn_kNoiseReject3_" + corr + "_woATC";

	  gen_dirname = dat_dirname;

	  infile = "dat/" + dat_dirname + "/" + dataFile;

	  outfile1 = "exp2016-17_mbc_" + prefOutfile;

	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0_" + corr + ".gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0_" + corr + ".gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0_" + corr + ".gen";
      }
  }

  TNtuple exp_nt("exp_nt","NTuple","mbc:de:dp");
  FILE* file = fopen(TString(infile).Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      exp_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple sig_nt("sig_nt","NTuple","mbc:de:dp");
  file = fopen(TString(exp_sig).Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      sig_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple bck_nt("bck_nt","NTuple","mbc:de:dp");
  file = fopen(TString(exp_bck).Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      bck_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple dbck_nt("dbck_nt","NTuple","mbc:de:dp");
  file = fopen(TString(exp_dbck).Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      dbck_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TH1F exp_dp("exp_dp","",30,-600.,600.);
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
  exp_nt->Project("exp_mbc","mbc",Form("abs(de)<%f",decut1));
  sig_nt->Project("sig_mbc","mbc",Form("abs(de)<%f",decut1));
  bck_nt->Project("bck_mbc","mbc",Form("abs(de)<%f",decut1));
  dbck_nt->Project("dbck_mbc","mbc",Form("abs(de)<%f",decut1));

  sig_mbc->Scale(scale);
  bck_mbc->Scale(scale);
  dbck_mbc->Scale(scale);

  TH1F exp_mbcs1("exp_mbcs1","|#Delta|P||<100 MeV",55,1790.,1900.);
  TH1F sig_mbcs1("sig_mbcs1","Mbc (MeV)",55,1790.,1900.);
  TH1F bck_mbcs1("bck_mbcs1","Mbc (MeV)",55,1790.,1900.);
  TH1F dbck_mbcs1("dbck_mbcs1","Mbc (MeV)",55,1790.,1900.);
  exp_nt->Project("exp_mbcs1","mbc","abs(de)<100&&abs(dp)<100");
  sig_nt->Project("sig_mbcs1","mbc","abs(de)<100&&abs(dp)<100");
  bck_nt->Project("bck_mbcs1","mbc","abs(de)<100&&abs(dp)<100");
  dbck_nt->Project("dbck_mbcs1","mbc","abs(de)<100&&abs(dp)<100");

  sig_mbcs1->Scale(scale);
  bck_mbcs1->Scale(scale);
  dbck_mbcs1->Scale(scale);

  TH1F exp_mbcs2("exp_mbcs2","|#Delta|P||>100 MeV",55,1790.,1900.);
  TH1F sig_mbcs2("sig_mbcs2","Mbc (MeV)",55,1790.,1900.);
  TH1F bck_mbcs2("bck_mbcs2","Mbc (MeV)",55,1790.,1900.);
  TH1F dbck_mbcs2("dbck_mbcs2","Mbc (MeV)",55,1790.,1900.);
  exp_nt->Project("exp_mbcs2","mbc","abs(de)<100&&abs(dp)>100");
  sig_nt->Project("sig_mbcs2","mbc","abs(de)<100&&abs(dp)>100");
  bck_nt->Project("bck_mbcs2","mbc","abs(de)<100&&abs(dp)>100");
  dbck_nt->Project("dbck_mbcs2","mbc","abs(de)<100&&abs(dp)>100");

  sig_mbcs2->Scale(scale);
  bck_mbcs2->Scale(scale);
  dbck_mbcs2->Scale(scale);

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

  TH1F exp_mbcde("exp_mbcde","",30,-300.,300);
  TH1F sig_mbcde("sig_mbcde","",30,-300.,300);
  TH1F bck_mbcde("bck_mbcde","DE (MeV)",30,-300.,300);
  TH1F dbck_mbcde("dbck_mbcde","DE (MeV)",30,-300.,300);
  exp_nt->Project("exp_mbcde","de",Form("abs(mbc-1865)<10&&abs(de)<%f",decut1));
  sig_nt->Project("sig_mbcde","de",Form("abs(mbc-1865)<10&&abs(de)<%f",decut1));
  bck_nt->Project("bck_mbcde","de",Form("abs(mbc-1865)<10&&abs(de)<%f",decut1));
  dbck_nt->Project("dbck_mbcde","de",Form("abs(mbc-1865)<10&&abs(de)<%f",decut1));
  sig_mbcde->Scale(scale);
  bck_mbcde->Scale(scale);
  dbck_mbcde->Scale(scale);

  printf("Signal = %f\n", sig_mbcde->GetSumOfWeights());
  printf("exp Signal = %f\n", exp_mbcde->GetSumOfWeights());
  printf("exp Signal - BG = %f\n", exp_mbcde->GetSumOfWeights()-bck_mbcde->GetSumOfWeights()-dbck_mbcde->GetSumOfWeights());
  printf("Backgrounds:\n UDS bck=%f\n DD bck=%f\n", bck_mbcde->GetSumOfWeights(),
	 dbck_mbcde->GetSumOfWeights());

  ////////////////////////////////////////////////////
  TH1F exp_mbcs3("exp_mbcs3","#Delta E<-200 MeV",55,1790.,1900.);
  TH1F sig_mbcs3("sig_mbcs3","#Delta E<-200 MeV",55,1790.,1900.);
  TH1F bck_mbcs3("bck_mbcs3","#Delta E<-200 MeV",55,1790.,1900.);
  TH1F dbck_mbcs3("dbck_mbcs3","#Delta E<-200 MeV",55,1790.,1900.);
  exp_nt->Project("exp_mbcs3","mbc","de<-200");
  sig_nt->Project("sig_mbcs3","mbc","de<-200");
  bck_nt->Project("bck_mbcs3","mbc","de<-200");
  dbck_nt->Project("dbck_mbcs3","mbc","de<-200");
  sig_mbcs3->Scale(scale);
  bck_mbcs3->Scale(scale);
  dbck_mbcs3->Scale(scale);

  TH1F exp_mbcs4("exp_mbcs4","-200<#Delta E<0 MeV",55,1790.,1900.);
  TH1F sig_mbcs4("sig_mbcs4","-200<#Delta E<0 MeV",55,1790.,1900.);
  TH1F bck_mbcs4("bck_mbcs4","-200<#Delta E<0 MeV",55,1790.,1900.);
  TH1F dbck_mbcs4("dbck_mbcs4","-200<#Delta E<0 MeV",55,1790.,1900.);
  exp_nt->Project("exp_mbcs4","mbc","-200<de&&de<0");
  sig_nt->Project("sig_mbcs4","mbc","-200<de&&de<0");
  bck_nt->Project("bck_mbcs4","mbc","-200<de&&de<0");
  dbck_nt->Project("dbck_mbcs4","mbc","-200<de&&de<0");
  sig_mbcs4->Scale(scale);
  bck_mbcs4->Scale(scale);
  dbck_mbcs4->Scale(scale);

  TH1F exp_mbcs5("exp_mbcs5","#Delta E>0 MeV",55,1790.,1900.);
  TH1F sig_mbcs5("sig_mbcs5","#Delta E>0 MeV",55,1790.,1900.);
  TH1F bck_mbcs5("bck_mbcs5","#Delta E>0 MeV",55,1790.,1900.);
  TH1F dbck_mbcs5("dbck_mbcs5","#Delta E>0 MeV",55,1790.,1900.);
  exp_nt->Project("exp_mbcs5","mbc","0<de");
  sig_nt->Project("sig_mbcs5","mbc","0<de");
  bck_nt->Project("bck_mbcs5","mbc","0<de");
  dbck_nt->Project("dbck_mbcs5","mbc","0<de");
  sig_mbcs5->Scale(scale);
  bck_mbcs5->Scale(scale);
  dbck_mbcs5->Scale(scale);

  //-----------------------------

  TH1F exp_des1("exp_des1","M_{bc}<1800 MeV",30,-300.,300.);
  TH1F sig_des1("sig_des1","M_{bc}<1800 MeV",30,-300.,300.);
  TH1F bck_des1("bck_des1","M_{bc}<1800 MeV",30,-300.,300.);
  TH1F dbck_des1("dbck_des1","M_{bc}<1800 MeV",30,-300.,300.);
  exp_nt->Project("exp_des1","de","mbc<1800");
  sig_nt->Project("sig_des1","de","mbc<1800");
  bck_nt->Project("bck_des1","de","mbc<1800");
  dbck_nt->Project("dbck_des1","de","mbc<1800");
  sig_des1->Scale(scale);
  bck_des1->Scale(scale);
  dbck_des1->Scale(scale);

  TH1F exp_des2("exp_des2","1800<M_{bc}<1850 MeV",30,-300.,300.);
  TH1F sig_des2("sig_des2","1800<M_{bc}<1850 MeV",30,-300.,300.);
  TH1F bck_des2("bck_des2","1800<M_{bc}<1850 MeV",30,-300.,300.);
  TH1F dbck_des2("dbck_des2","1800<M_{bc}<1850 MeV",30,-300.,300.);
  exp_nt->Project("exp_des2","de","mbc<1850&&mbc>1800");
  sig_nt->Project("sig_des2","de","mbc<1850&&mbc>1800");
  bck_nt->Project("bck_des2","de","mbc<1850&&mbc>1800");
  dbck_nt->Project("dbck_des2","de","mbc<1850&&mbc>1800");
  sig_des2->Scale(scale);
  bck_des2->Scale(scale);
  dbck_des2->Scale(scale);

  TH1F exp_des3("exp_des3","M_{bc}>1850 MeV",30,-300.,300.);
  TH1F sig_des3("sig_des3","M_{bc}>1850 MeV",30,-300.,300.);
  TH1F bck_des3("bck_des3","M_{bc}>1850 MeV",30,-300.,300.);
  TH1F dbck_des3("dbck_des3","M_{bc}>1850 MeV",30,-300.,300.);
  exp_nt->Project("exp_des3","de","mbc>1850");
  sig_nt->Project("sig_des3","de","mbc>1850");
  bck_nt->Project("bck_des3","de","mbc>1850");
  dbck_nt->Project("dbck_des3","de","mbc>1850");
  sig_des3->Scale(scale);
  bck_des3->Scale(scale);
  dbck_des3->Scale(scale);


  ///////////////////////////////////////////////////

  TCanvas c("c","c",1000,600);
  c.Divide(3,2);

  c.cd(1);
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

  exp_mbc->GetYaxis()->SetRangeUser(0, mbcmax);
  exp_mbc.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbc.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbc.Draw("elp");
  mbc_hs->Draw("same");
  exp_mbc.SetLineWidth(2);
  exp_mbc.SetLineColor(1);
  exp_mbc.Draw("elpsame");

  TBox b;
  TLatex t;
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

  c.cd(2);
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

  exp_de->GetYaxis()->SetRangeUser(0, demax);
  exp_de.GetXaxis()->SetTitle("#DeltaE (MeV)");
  exp_de.GetYaxis()->SetTitle("Events/20 MeV");
  exp_de.Draw("elp");
  de_hs->Draw("same");
  exp_de.SetLineWidth(2);
  exp_de.SetLineColor(1);
  exp_de.Draw("elpsame");

  c.Update();

  c.cd(3);
  THStack dp_hs("hs","");
  dp_hs->Add(&bck_dp);
  bck_dp->SetFillColor(bck_color);
  bck_dp->SetFillStyle(bck_style);
  dp_hs->Add(&dbck_dp);
  dbck_dp->SetFillColor(dbck_color);
  dbck_dp->SetFillStyle(dbck_style);
  dp_hs->Add(&sig_dp);
  sig_dp->SetFillColor(sig_color);
  sig_dp->SetFillStyle(sig_style);

  exp_dp->GetYaxis()->SetRangeUser(0, dpmax);
  exp_dp.GetXaxis()->SetTitle("#Delta|p| (MeV)");
  exp_dp.GetYaxis()->SetTitle("Events/40 MeV");
  exp_dp.Draw("elp");
  dp_hs->Draw("same");
  exp_dp.SetLineWidth(2);
  exp_dp.SetLineColor(1);
  exp_dp.Draw("elpsame");

  c.Update();

  c.cd(4);
  THStack mbcs1_hs("mbcs1_hs","");
  mbcs1_hs->Add(&bck_mbcs1);
  bck_mbcs1->SetFillColor(bck_color);
  bck_mbcs1->SetFillStyle(bck_style);
  mbcs1_hs->Add(&dbck_mbcs1);
  dbck_mbcs1->SetFillColor(dbck_color);
  dbck_mbcs1->SetFillStyle(dbck_style);
  mbcs1_hs->Add(&sig_mbcs1);
  sig_mbcs1->SetFillColor(sig_color);
  sig_mbcs1->SetFillStyle(sig_style);

  exp_mbcs1->GetYaxis()->SetRangeUser(0, mbcmax2);
  exp_mbcs1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs1.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs1.Draw("elp");
  mbcs1_hs->Draw("same");
  exp_mbcs1.SetLineWidth(2);
  exp_mbcs1.SetLineColor(1);
  exp_mbcs1.Draw("elpsame");

  c.Update();

  c.cd(5);
  THStack mbcs2_hs("mbcs2_hs","");
  mbcs2_hs->Add(&bck_mbcs2);
  bck_mbcs2->SetFillColor(bck_color);
  bck_mbcs2->SetFillStyle(bck_style);
  mbcs2_hs->Add(&dbck_mbcs2);
  dbck_mbcs2->SetFillColor(dbck_color);
  dbck_mbcs2->SetFillStyle(dbck_style);
  mbcs2_hs->Add(&sig_mbcs2);
  sig_mbcs2->SetFillColor(sig_color);
  sig_mbcs2->SetFillStyle(sig_style);

  exp_mbcs2->GetYaxis()->SetRangeUser(0, mbcmax3);
  exp_mbcs2.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs2.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs2.Draw("elp");
  mbcs2_hs->Draw("same");
  exp_mbcs2.SetLineWidth(2);
  exp_mbcs2.SetLineColor(1);
  exp_mbcs2.Draw("elpsame");

  c.Update();

  c.cd(6);
  c.GetPad(5)->SetLeftMargin(4.);
  exp_nt.SetMarkerSize(0.5);
  exp_nt.SetMarkerStyle(20);
  exp_nt.SetLineColor(1);
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
  l.SetLineWidth(2);

  l.DrawLine(1855., -300., 1855., 300);
  l.DrawLine(1875., -300., 1875., 300);
  l.DrawLine(1700., decut2, 1900., decut2);
  l.DrawLine(1700.,  decut1, 1900.,  decut1);

  c.Update();

  c.Print(KEDR + outfile1 + "_2.eps");
  c.Print(KEDR + outfile1 + "_2.png");

  ////////////////////////////////////////////
  TCanvas c2("c2","c2",700,600);
  c2.Divide(2,2);

  c2.cd(1);
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

  exp_mbc->GetYaxis()->SetRangeUser(0, mbcmax);
  exp_mbc.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbc.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbc.Draw("elp");
  mbc_hs->Draw("same");
  exp_mbc.SetLineWidth(2);
  exp_mbc.SetLineColor(1);
  exp_mbc.Draw("elpsame");

  TBox b;
  TLatex t;
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

  c2.Update();

  c2.cd(2);
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

  exp_de->GetYaxis()->SetRangeUser(0, demax);
  exp_de.GetXaxis()->SetTitle("#DeltaE (MeV)");
  exp_de.GetYaxis()->SetTitle("Events/20 MeV");
  exp_de.Draw("elp");
  de_hs->Draw("same");
  exp_de.SetLineWidth(2);
  exp_de.SetLineColor(1);
  exp_de.Draw("elpsame");

  c2.Update();

  c2.cd(3);
  THStack dp_hs("hs","");
  dp_hs->Add(&bck_dp);
  bck_dp->SetFillColor(bck_color);
  bck_dp->SetFillStyle(bck_style);
  dp_hs->Add(&dbck_dp);
  dbck_dp->SetFillColor(dbck_color);
  dbck_dp->SetFillStyle(dbck_style);
  dp_hs->Add(&sig_dp);
  sig_dp->SetFillColor(sig_color);
  sig_dp->SetFillStyle(sig_style);

  exp_dp->GetYaxis()->SetRangeUser(0, dpmax);
  exp_dp.GetXaxis()->SetTitle("#Delta|p| (MeV)");
  exp_dp.GetYaxis()->SetTitle("Events/40 MeV");
  exp_dp->GetYaxis()->SetTitleOffset(1.3);
  exp_dp.Draw("elp");
  dp_hs->Draw("same");
  exp_dp.SetLineWidth(2);
  exp_dp.SetLineColor(1);
  exp_dp.Draw("elpsame");

  c2.Update();

  c2.cd(4);
  exp_nt.SetMarkerSize(0.5);
  exp_nt.SetMarkerStyle(20);
  exp_nt.Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.1);
  htemp->SetTitle("");
  TLine l;
  l.SetLineColor(sig_color);
  l.SetLineWidth(2);

  l.DrawLine(1855., -300., 1855., 300);
  l.DrawLine(1875., -300., 1875., 300);
  l.DrawLine(1700., decut2, 1900., decut2);
  l.DrawLine(1700.,  decut1, 1900.,  decut1);

  c2.Update();

  c2.Print(KEDR + outfile1 + ".eps");
  c2.Print(KEDR + outfile1 + ".png");


  ////////////////////////////////////////////////
  TCanvas c3("c3","c3",900,900);
  c3.Divide(3,3);

  rmax = 28.;
  mbcmax = 38;
  //demax = 50;

  c3.cd(1);
  THStack mbcs1_hs("mbcs1_hs","");
  mbcs1_hs->Add(&bck_mbcs1);
  bck_mbcs1->SetFillColor(bck_color);
  bck_mbcs1->SetFillStyle(bck_style);
  mbcs1_hs->Add(&dbck_mbcs1);
  dbck_mbcs1->SetFillColor(dbck_color);
  dbck_mbcs1->SetFillStyle(dbck_style);
  mbcs1_hs->Add(&sig_mbcs1);
  sig_mbcs1->SetFillColor(sig_color);
  sig_mbcs1->SetFillStyle(sig_style);

  exp_mbcs1->GetYaxis()->SetRangeUser(0, mbcmax2);
  exp_mbcs1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs1.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs1.Draw("elp");
  mbcs1_hs->Draw("same");
  exp_mbcs1.SetLineWidth(2);
  exp_mbcs1.SetLineColor(1);
  exp_mbcs1.Draw("elpsame");

  TBox b;
  TLatex t;
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

  c3.Update();

  c3.cd(2);
  THStack mbcs2_hs("mbcs2_hs","");
  mbcs2_hs->Add(&bck_mbcs2);
  bck_mbcs2->SetFillColor(bck_color);
  bck_mbcs2->SetFillStyle(bck_style);
  mbcs2_hs->Add(&dbck_mbcs2);
  dbck_mbcs2->SetFillColor(dbck_color);
  dbck_mbcs2->SetFillStyle(dbck_style);
  mbcs2_hs->Add(&sig_mbcs2);
  sig_mbcs2->SetFillColor(sig_color);
  sig_mbcs2->SetFillStyle(sig_style);

  exp_mbcs2->GetYaxis()->SetRangeUser(0, mbcmax3);
  exp_mbcs2.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs2.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs2.Draw("elp");
  mbcs2_hs->Draw("same");
  exp_mbcs2.SetLineWidth(2);
  exp_mbcs2.SetLineColor(1);
  exp_mbcs2.Draw("elpsame");

  c3.Update();

  c3.cd(3);
  THStack dp_hs("hs","");
  dp_hs->Add(&bck_dp);
  bck_dp->SetFillColor(bck_color);
  bck_dp->SetFillStyle(bck_style);
  dp_hs->Add(&dbck_dp);
  dbck_dp->SetFillColor(dbck_color);
  dbck_dp->SetFillStyle(dbck_style);
  dp_hs->Add(&sig_dp);
  sig_dp->SetFillColor(sig_color);
  sig_dp->SetFillStyle(sig_style);

  exp_dp->GetYaxis()->SetRangeUser(0, dpmax);
  exp_dp.GetXaxis()->SetTitle("#Delta|p| (MeV)");
  exp_dp.GetYaxis()->SetTitle("Events/40 MeV");
  exp_dp.Draw("elp");
  dp_hs->Draw("same");
  exp_dp.SetLineWidth(2);
  exp_dp.SetLineColor(1);
  exp_dp.Draw("elpsame");

  c3.Update();

  c3.cd(4);
  THStack mbcs3_hs("mbcs3_hs","");
  mbcs3_hs->Add(&bck_mbcs3);
  bck_mbcs3->SetFillColor(bck_color);
  bck_mbcs3->SetFillStyle(bck_style);
  mbcs3_hs->Add(&dbck_mbcs3);
  dbck_mbcs3->SetFillColor(dbck_color);
  dbck_mbcs3->SetFillStyle(dbck_style);
  mbcs3_hs->Add(&sig_mbcs3);
  sig_mbcs3->SetFillColor(sig_color);
  sig_mbcs3->SetFillStyle(sig_style);

  exp_mbcs3->GetYaxis()->SetRangeUser(0, mbcmax);
  exp_mbcs3.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs3.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs3.Draw("elp");
  mbcs3_hs->Draw("same");
  exp_mbcs3.SetLineWidth(2);
  exp_mbcs3.SetLineColor(1);
  exp_mbcs3.Draw("elpsame");

  c3.Update();

  c3.cd(5);
  THStack mbcs4_hs("mbcs4_hs","");
  mbcs4_hs->Add(&bck_mbcs4);
  bck_mbcs4->SetFillColor(bck_color);
  bck_mbcs4->SetFillStyle(bck_style);
  mbcs4_hs->Add(&dbck_mbcs4);
  dbck_mbcs4->SetFillColor(dbck_color);
  dbck_mbcs4->SetFillStyle(dbck_style);
  mbcs4_hs->Add(&sig_mbcs4);
  sig_mbcs4->SetFillColor(sig_color);
  sig_mbcs4->SetFillStyle(sig_style);

  exp_mbcs4->GetYaxis()->SetRangeUser(0, mbcmax);
  exp_mbcs4.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs4.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs4.Draw("elp");
  mbcs4_hs->Draw("same");
  exp_mbcs4.SetLineWidth(2);
  exp_mbcs4.SetLineColor(1);
  exp_mbcs4.Draw("elpsame");

  c3.Update();

  c3.cd(6);
  THStack mbcs5_hs("mbcs5_hs","");
  mbcs5_hs->Add(&bck_mbcs5);
  bck_mbcs5->SetFillColor(bck_color);
  bck_mbcs5->SetFillStyle(bck_style);
  mbcs5_hs->Add(&dbck_mbcs5);
  dbck_mbcs5->SetFillColor(dbck_color);
  dbck_mbcs5->SetFillStyle(dbck_style);
  mbcs5_hs->Add(&sig_mbcs5);
  sig_mbcs5->SetFillColor(sig_color);
  sig_mbcs5->SetFillStyle(sig_style);

  exp_mbcs5->GetYaxis()->SetRangeUser(0, mbcmax);
  exp_mbcs5.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs5.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs5.Draw("elp");
  mbcs5_hs->Draw("same");
  exp_mbcs5.SetLineWidth(2);
  exp_mbcs5.SetLineColor(1);
  exp_mbcs5.Draw("elpsame");

  c3.Update();

  c3.cd(7);
  THStack des1_hs("des1_hs","");
  des1_hs->Add(&bck_des1);
  bck_des1->SetFillColor(bck_color);
  bck_des1->SetFillStyle(bck_style);
  des1_hs->Add(&dbck_des1);
  dbck_des1->SetFillColor(dbck_color);
  dbck_des1->SetFillStyle(dbck_style);
  des1_hs->Add(&sig_des1);
  sig_des1->SetFillColor(sig_color);
  sig_des1->SetFillStyle(sig_style);

  exp_des1->GetYaxis()->SetRangeUser(0, 55);
  exp_des1.GetXaxis()->SetTitle("#Delta E (MeV)");
  exp_des1.GetYaxis()->SetTitle("Events/20 MeV");
  exp_des1.Draw("elp");
  des1_hs->Draw("same");
  exp_des1.SetLineWidth(2);
  exp_des1.SetLineColor(1);
  exp_des1.Draw("elpsame");

  c3.Update();

  c3.cd(8);
  THStack des2_hs("des2_hs","");
  des2_hs->Add(&bck_des2);
  bck_des2->SetFillColor(bck_color);
  bck_des2->SetFillStyle(bck_style);
  des2_hs->Add(&dbck_des2);
  dbck_des2->SetFillColor(dbck_color);
  dbck_des2->SetFillStyle(dbck_style);
  des2_hs->Add(&sig_des2);
  sig_des2->SetFillColor(sig_color);
  sig_des2->SetFillStyle(sig_style);

  exp_des2->GetYaxis()->SetRangeUser(0, 55);
  exp_des2.GetXaxis()->SetTitle("#Delta E (MeV)");
  exp_des2.GetYaxis()->SetTitle("Events/20 MeV");
  exp_des2.Draw("elp");
  des2_hs->Draw("same");
  exp_des2.SetLineWidth(2);
  exp_des2.SetLineColor(1);
  exp_des2.Draw("elpsame");

  c3.Update();

  c3.cd(9);
  THStack des3_hs("des3_hs","");
  des3_hs->Add(&bck_des3);
  bck_des3->SetFillColor(bck_color);
  bck_des3->SetFillStyle(bck_style);
  des3_hs->Add(&dbck_des3);
  dbck_des3->SetFillColor(dbck_color);
  dbck_des3->SetFillStyle(dbck_style);
  des3_hs->Add(&sig_des3);
  sig_des3->SetFillColor(sig_color);
  sig_des3->SetFillStyle(sig_style);

  exp_des3->GetYaxis()->SetRangeUser(0, 45);
  exp_des3.GetXaxis()->SetTitle("#Delta E (MeV)");
  exp_des3.GetYaxis()->SetTitle("Events/20 MeV");
  exp_des3.Draw("elp");
  des3_hs->Draw("same");
  exp_des3.SetLineWidth(2);
  exp_des3.SetLineColor(1);
  exp_des3.Draw("elpsame");

  c3.Update();

  c3.Print(KEDR + outfile1 + "_3.eps");
  c3.Print(KEDR + outfile1 + "_3.png");

}
