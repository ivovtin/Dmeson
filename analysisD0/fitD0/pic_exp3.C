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
  /*
  int bck_color = 41;
  int dbck_color = 38;
  int sig_color = 50;

  int bck_style = 3505;
  int dbck_style = 3544;
  int sig_style = 3595;
  */
  int bck_color = 8;
  int dbck_color = 9;
  int sig_color = 2;

  int bck_style = 3505;
  int dbck_style = 3544;
  int sig_style = 3595;

  //TString KEDR = "/spool/users/ovtin/outDmeson/D0/results/fitsD0/";
  TString KEDR = "/spool/users/ovtin/outDmeson/D0/results/fitsD0/forTest/";

  int key = 2016;

  char *infile;
  int mbcmax;
  int mbcmax2;
  int mbcmax3;
  int demax;
  int dpmax;
  double rmax;
  TString outfile1;
  char *exp_sig;
  char *exp_bck;
  char *exp_dbck;

  bool atc=1;

  float decut1=100.;
  float decut2=-100.;
  //float decut1=150.;
  //float decut2=-150.;

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
      mbcmax = 85; //105
      mbcmax2 = 40;
      mbcmax3 = 45;
      demax = 72; //48
      dpmax = 270; //170
      rmax = 70.; //95.
      if(atc){
	  mbcmax = 62;
	  demax = 43;
	  dpmax = 133;
	  rmax = 62.;
      }

      //infile = "dat/kp_exp_1.0173_2016-17.dat";
      //infile = "dat/kp_exp_1.0173_2016-17_woDCnoise.dat";
      //infile = "dat/kp_exp_1.0173_2016-17_KemcAllowedOff_kNoiseReject3.dat";
      //infile = "dat/kp_exp_1.0173_2016-17_merge.dat";
      //infile = "dat/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0/kp_exp_1.0173_2016-17_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0.dat";

      if(atc || key==2004){
          infile = "dat/KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_exp_2016-17_KemcAllowedOff_kNoiseReject3_ATC_1.0155.dat";
          outfile1 = "exp2016-17_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0";
          exp_sig = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_sig_S1.0_A6.0_Z0.0.gen";
          exp_bck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_bck_S1.0_A6.0_Z0.0.gen";
          exp_dbck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
      else{
          infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0155.dat";
          outfile1 = "exp2016-17_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0";
          exp_sig = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_sig_S1.0_A6.0_Z0.0.gen";
          exp_bck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_bck_S1.0_A6.0_Z0.0.gen";
          exp_dbck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
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
  //file = fopen("gen/genold/exp_sig.gen","r");
  //file = fopen("gen/genold/sig_def.gen","r");
  file = fopen(exp_sig,"r");
  //file = fopen("gen/sig_def.gen","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      sig_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple bck_nt("bck_nt","NTuple","mbc:de:dp");
  //file = fopen("gen/genold/exp_bck.gen","r");
  //file = fopen("gen/genold/bck_uds.gen","r");
  file = fopen(exp_bck,"r");
  //file = fopen("gen/bck_uds.gen","r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      bck_nt.Fill(mbc,de,dp);
    }
  }
  fclose(file);

  TNtuple dbck_nt("dbck_nt","NTuple","mbc:de:dp");
  //file = fopen("gen/genold/exp_dbck.gen","r");
  //file = fopen("gen/genold/dbck_sim.gen","r");
  file = fopen(exp_dbck,"r");
  //file = fopen("gen/dbck_sim.gen","r");
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
  /*
  exp_nt->Project("exp_mbcs1","mbc","abs(de)<150&&abs(dp)<140");
  sig_nt->Project("sig_mbcs1","mbc","abs(de)<150&&abs(dp)<140");
  bck_nt->Project("bck_mbcs1","mbc","abs(de)<150&&abs(dp)<140");
  dbck_nt->Project("dbck_mbcs1","mbc","abs(de)<150&&abs(dp)<140");
  */
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
  /*
  exp_nt->Project("exp_mbcs2","mbc","abs(de)<150&&abs(dp)>140");
  sig_nt->Project("sig_mbcs2","mbc","abs(de)<150&&abs(dp)>140");
  bck_nt->Project("bck_mbcs2","mbc","abs(de)<150&&abs(dp)>140");
  dbck_nt->Project("dbck_mbcs2","mbc","abs(de)<150&&abs(dp)>140");
  */
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

  printf("exp Signal = %f\n", exp_mbcde->GetSumOfWeights());
  printf("exp Signal - BG = %f\n", exp_mbcde->GetSumOfWeights()-bck_mbcde->GetSumOfWeights()-dbck_mbcde->GetSumOfWeights());
  printf("Backgrounds:\n UDS bck=%f\n DD bck=%f\n", bck_mbcde->GetSumOfWeights(),
         dbck_mbcde->GetSumOfWeights());

/*
  TH1F de1("de1","DE (MeV)",30,-300.,300.);
  TH1F de2("de2","DE (MeV)",30,-300.,300.);
  nt->Project("de1","de","abs(mbc-1865)<10");
  nt2->Project("de2","de","abs(mbc-1865)<10");
  de2->Scale(scale);
*/

  TCanvas c("c","c",700,600);
  c.Divide(2,2);

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
  exp_de.Draw("elpsame");

  /*
  TH1F* sum_h= new TH1F(bck_de);
  sum_h->Add(dbck_de,1.);
  //sum_h->Add(sig_de,1.);
  sum_h->SetLineColor(kBlue);
  sum_h->Draw("same,hist");


  TH1F* hdE1exp=new TH1F("hdE1exp","hdE1exp",30,-300.,300.);
  hdE1exp = (TH1F*) exp_de->Clone();
  //cout<<hdE1exp->GetRMS()<<endl;
  cout<<de_hs->GetRMS()<<endl;
  TH1F* hdE1sim=new TH1F("hdE1sim","hdE1sim",30,-300.,300.);
  //hdE1sim = (TH1F*) sig_de->Clone();
  TList * histKeys = de_hs->GetHists();
  histKeys->Print();
  //hdE1sim = (TH1F*) de_hs->Clone();
  //Double_t deKT = hdE1exp->KolmogorovTest(hdE1sim);
  //cout<<"deKT="<<deKT<<endl;
  */
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
//  dp_hs->Draw();

  exp_dp->GetYaxis()->SetRangeUser(0, dpmax);
  exp_dp.GetXaxis()->SetTitle("#Delta|p| (MeV)");
  exp_dp.GetYaxis()->SetTitle("Events/40 MeV");
  exp_dp->GetYaxis()->SetTitleOffset(1.3);
  exp_dp.Draw("elp");
  dp_hs->Draw("same");
  exp_dp.SetLineWidth(2);
  exp_dp.Draw("elpsame");

  c.Update();

  c.cd(4);
  //c.GetPad(4)->SetLeftMargin(4.);
  exp_nt.SetMarkerSize(0.5);
  exp_nt.SetMarkerStyle(20);
  exp_nt.Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.1);
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
  /*
  l.DrawLine(1855., -300., 1855., 300);
  l.DrawLine(1875., -300., 1875., 300);
  l.DrawLine(1700., -150., 1900., -150);
  l.DrawLine(1700.,  150., 1900.,  150);
  */
  c.Update();

  c.Print(KEDR + outfile1 + ".eps");
  c.Print(KEDR + outfile1 + ".png");

}
