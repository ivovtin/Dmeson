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
  //gStyle->SetHistLineWidth(3);
  //gStyle->SetHatchesLineWidth(3);

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

  bool final = 1;

  //TFile *fout=0;
  //fout = new TFile("result_hists.root","RECREATE");

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
      if (final){
	  //atc_tof_dedx
          dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_TMVA";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_tmva_0.50_ATC.dat";
          prefOutfile = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_k1.0140_TMVA";

	  gen_dirname = dat_dirname;
	  //gen_dirname = dat_dirname + "_Syst_SigShape";


	  //mbcmax = 50.;
	  //rmax = 50.;

	  mbcmax = 90.;
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
          //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_tof_ATC.dat";
          //prefOutfile = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_k1.0140";
	  //mbcmax = 140;
	  //rmax = 150.;

	  //atc_tof
          //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_ATC.dat";
          //prefOutfile = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_k1.0140";
	  //mbcmax = 100;
	  //rmax = 100.;

	  //atc_dedx
          dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_dedx_ATC.dat";
          prefOutfile = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_k1.0140";
	  mbcmax = 110;
	  rmax = 110.;

	  gen_dirname = dat_dirname;


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

  /////////////////////////////////////////////////////////////////

  TH1F exp_mbcs1("exp_mbcs1","#Delta E<-200 MeV",55,1790.,1900.);
  TH1F sig_mbcs1("sig_mbcs1","#Delta E<-200 MeV",55,1790.,1900.);
  TH1F bck_mbcs1("bck_mbcs1","#Delta E<-200 MeV",55,1790.,1900.);
  TH1F dbck_mbcs1("dbck_mbcs1","#Delta E<-200 MeV",55,1790.,1900.);
  exp_nt->Project("exp_mbcs1","mbc","de<-200");
  sig_nt->Project("sig_mbcs1","mbc","de<-200");
  bck_nt->Project("bck_mbcs1","mbc","de<-200");
  dbck_nt->Project("dbck_mbcs1","mbc","de<-200");
  sig_mbcs1->Scale(scale);
  bck_mbcs1->Scale(scale);
  dbck_mbcs1->Scale(scale);

  TH1F exp_mbcs2("exp_mbcs2","-200<#Delta E<0 MeV",55,1790.,1900.);
  TH1F sig_mbcs2("sig_mbcs2","-200<#Delta E<0 MeV",55,1790.,1900.);
  TH1F bck_mbcs2("bck_mbcs2","-200<#Delta E<0 MeV",55,1790.,1900.);
  TH1F dbck_mbcs2("dbck_mbcs2","-200<#Delta E<0 MeV",55,1790.,1900.);
  exp_nt->Project("exp_mbcs2","mbc","-200<de&&de<0");
  sig_nt->Project("sig_mbcs2","mbc","-200<de&&de<0");
  bck_nt->Project("bck_mbcs2","mbc","-200<de&&de<0");
  dbck_nt->Project("dbck_mbcs2","mbc","-200<de&&de<0");
  sig_mbcs2->Scale(scale);
  bck_mbcs2->Scale(scale);
  dbck_mbcs2->Scale(scale);

  TH1F exp_mbcs3("exp_mbcs3","#Delta E>0 MeV",55,1790.,1900.);
  TH1F sig_mbcs3("sig_mbcs3","#Delta E>0 MeV",55,1790.,1900.);
  TH1F bck_mbcs3("bck_mbcs3","#Delta E>0 MeV",55,1790.,1900.);
  TH1F dbck_mbcs3("dbck_mbcs3","#Delta E>0 MeV",55,1790.,1900.);
  exp_nt->Project("exp_mbcs3","mbc","0<de");
  sig_nt->Project("sig_mbcs3","mbc","0<de");
  bck_nt->Project("bck_mbcs3","mbc","0<de");
  dbck_nt->Project("dbck_mbcs3","mbc","0<de");
  sig_mbcs3->Scale(scale);
  bck_mbcs3->Scale(scale);
  dbck_mbcs3->Scale(scale);

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
  exp_mbc.SetLineColor(1);
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
  exp_de.SetLineColor(1);
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

  ////////////////////////////////////////////////
  //gStyle->SetHistLineWidth(1.);
  //gStyle->SetHatchesLineWidth(1.);

  TCanvas c4("c4","c4",1000,800);
  c4.Divide(3,2);

  rmax = 80.;
  mbcmax = 80;
  //demax = 50;

  c4.cd(1);
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

  exp_mbcs1->GetYaxis()->SetRangeUser(0, mbcmax);
  exp_mbcs1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs1.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs1.Draw("elp");
  mbcs1_hs->Draw("same");
  exp_mbcs1.SetLineWidth(2);
  exp_mbcs1.SetLineColor(1);
  exp_mbcs1.Draw("elpsame");

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

  c4.Update();

  c4.cd(2);
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

  exp_mbcs2->GetYaxis()->SetRangeUser(0, mbcmax);
  exp_mbcs2.GetXaxis()->SetTitle("M_{bc} (MeV)");
  exp_mbcs2.GetYaxis()->SetTitle("Events/2 MeV");
  exp_mbcs2.Draw("elp");
  mbcs2_hs->Draw("same");
  exp_mbcs2.SetLineWidth(2);
  exp_mbcs2.SetLineColor(1);
  exp_mbcs2.Draw("elpsame");

  c4.Update();

  c4.cd(3);
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

  c4.Update();

  c4.cd(4);
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

  //exp_des1->GetYaxis()->SetRangeUser(0, 270);
  exp_des1->GetYaxis()->SetRangeUser(0, 170);
  exp_des1.GetXaxis()->SetTitle("#Delta E (MeV)");
  exp_des1.GetYaxis()->SetTitle("Events/20 MeV");
  exp_des1.Draw("elp");
  des1_hs->Draw("same");
  exp_des1.SetLineWidth(2);
  exp_des1.SetLineColor(1);
  exp_des1.Draw("elpsame");

  c4.Update();

  c4.cd(5);
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

  //exp_des2->GetYaxis()->SetRangeUser(0, 160);
  exp_des2->GetYaxis()->SetRangeUser(0, 120);
  exp_des2.GetXaxis()->SetTitle("#Delta E (MeV)");
  exp_des2.GetYaxis()->SetTitle("Events/20 MeV");
  exp_des2.Draw("elp");
  des2_hs->Draw("same");
  exp_des2.SetLineWidth(2);
  exp_des2.SetLineColor(1);
  exp_des2.Draw("elpsame");

  c4.Update();

  c4.cd(6);
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

  exp_des3->GetYaxis()->SetRangeUser(0, 130);
  exp_des3.GetXaxis()->SetTitle("#Delta E (MeV)");
  exp_des3.GetYaxis()->SetTitle("Events/20 MeV");
  exp_des3.Draw("elp");
  des3_hs->Draw("same");
  exp_des3.SetLineWidth(2);
  exp_des3.SetLineColor(1);
  exp_des3.Draw("elpsame");

  c4.Update();

  c4.Print(KEDR + outfile3 + "_4.eps");
  c4.Print(KEDR + outfile3 + "_4.png");



  //fout->Write();
  //fout->Close();
}
