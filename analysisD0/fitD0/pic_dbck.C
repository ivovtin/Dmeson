{
  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);
  gStyle->SetHistLineWidth(2);
  gStyle->SetHistLineColor(4);

  //TString KEDR="/spool/users/ovtin/outDmeson/D0/results/fitsD0/";
  TString KEDR="/store/users/ovtin/outDmeson/D0/results/fitsD0/forTest/";

  //TString dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc";
  //TString data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat";
  //TString type = "S1.0_A6.0_Z0.0_"+dat_dirname;

  TString dat_dirname = "2004_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0";
  TString data_file = "kp_dbck_2004_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0_ATC.dat";
  TString type = "S1.0_A4.5_Z0.0_"+dat_dirname;

  TString gen_dirname = dat_dirname;

  //Syst_DbckShape
  //TString gen_dirname = dat_dirname + "_Syst_DbckShape";
  //type = type + "_Syst_DbckShape";


  TNtuple nt("nt","NTuple","mbc:de:dp");

  FILE* file = fopen(TString("dat/" + dat_dirname + "/" + data_file).Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt.Fill(mbc,de,dp);
    }
  }

  fclose(file);

  TNtuple nt2("nt2","NTuple","mbc:de:dp");

  file = fopen(TString("gen/" + gen_dirname + "/dbck_S1.0_A6.0_Z0.0.gen").Data(),"r");
  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      nt2.Fill(mbc,de,dp);
    }
  }

  fclose(file);

  TH1F mbc1("mbc1","",80,1700.,1900.);
  TH1F mbc2("mbc2","",80,1700.,1900.);
  nt->Project("mbc1","mbc","abs(de)<300");
  nt2->Project("mbc2","mbc","abs(de)<300");
  double scale = mbc1->GetSumOfWeights()/mbc2->GetSumOfWeights();
  mbc2->Scale(scale);

  TH1F mbcs1("mbcs1","#Delta E<-200 MeV",80,1700.,1900.);
  TH1F mbcs2("mbcs2","#Delta E<-200 MeV",80,1700.,1900.);
  nt->Project("mbcs1","mbc","de<-200");
  nt2->Project("mbcs2","mbc","de<-200");
  mbcs2->Scale(scale);

  TH1F mbcs3("mbcs3","-200<#Delta E<0 MeV",80,1700.,1900.);
  TH1F mbcs4("mbcs4","-200<#Delta E<0 MeV",80,1700.,1900.);
  nt->Project("mbcs3","mbc","-200<de&&de<0");
  nt2->Project("mbcs4","mbc","-200<de&&de<0");
  mbcs4->Scale(scale);

  TH1F mbcs5("mbcs5","#Delta E>0 MeV",80,1700.,1900.);
  TH1F mbcs6("mbcs6","#Delta E>0 MeV",80,1700.,1900.);
  nt->Project("mbcs5","mbc","0<de");
  nt2->Project("mbcs6","mbc","0<de");
  mbcs6->Scale(scale);

  TH1F de1("de1","",30,-300.,300.);
  TH1F de2("de2","",30,-300.,300.);

  nt->Project("de1","de");
  nt2->Project("de2","de");
  de2->Scale(scale);

  TH1F des1("des1","M_{bc}<1800 MeV",30,-300.,300.);
  TH1F des2("des2","M_{bc}<1800 MeV",30,-300.,300.);

  nt->Project("des1","de","mbc<1800");
  nt2->Project("des2","de","mbc<1800");
  des2->Scale(scale);

  TH1F des3("des3","1800<M_{bc}<1850 MeV",30,-300.,300.);
  TH1F des4("des4","1800<M_{bc}<1850 MeV",30,-300.,300.);

  nt->Project("des3","de","mbc<1850&&mbc>1800");
  nt2->Project("des4","de","mbc<1850&&mbc>1800");
  des4->Scale(scale);

  TH1F des5("des5","M_{bc}>1850 MeV",30,-300.,300.);
  TH1F des6("des6","M_{bc}>1850 MeV",30,-300.,300.);

  nt->Project("des5","de","mbc>1850");
  nt2->Project("des6","de","mbc>1850");
  des6->Scale(scale);

  TH1F mbcde("mbcde","",30,-300.,300.);

  nt->Project("mbcde","de","abs(de)<100.&&abs(mbc-1870)<10.");
  printf("Events in signal box: %f\n", mbcde->GetSumOfWeights());

  TH1F dp1("dp1","",100,-800.,800.);
  TH1F dp2("dp2","",100,-800.,800.);
  dp2.SetLineColor(2);

  nt->Project("dp1","dp","abs(de)<300.&&mbc>1700.");
  nt2->Project("dp2","dp","abs(de)<300.&&mbc>1700.");
  double scale_dp = dp1->GetSumOfWeights()/dp2->GetSumOfWeights();
  dp2->Scale(scale_dp);

  TCanvas c("c","c",800,800);
  c.Divide(3,3);

  c.cd(1);
  mbc1.Draw("elp");
  mbc1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbc2.SetLineColor(2);
  mbc2.Draw("same");

  c.cd(2);
  de1.Draw("elp");
  de1.GetXaxis()->SetTitle("#Delta E (MeV)");
  de2.SetLineColor(2);
  de2.Draw("same");

  c.cd(3);
  nt->Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");

  c.cd(4);
  mbcs1.Draw("elp");
  mbcs1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbcs2.SetLineColor(2);
  mbcs2.Draw("same");

  c.cd(5);
  mbcs3.Draw("elp");
  mbcs3.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbcs4.SetLineColor(2);
  mbcs4.Draw("same");

  c.cd(6);
  mbcs5.Draw("elp");
  mbcs5.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbcs6.SetLineColor(2);
  mbcs6.Draw("same");

  c.cd(7);
  des1.Draw("elp");
  des1.GetXaxis()->SetTitle("#Delta E (MeV)");
  des2.SetLineColor(2);
  des2.Draw("same");

  c.cd(8);
  des3.Draw("elp");
  des3.GetXaxis()->SetTitle("#Delta E (MeV)");
  des4.SetLineColor(2);
  des4.Draw("same");

  c.cd(9);
  des5.Draw("elp");
  des5.GetXaxis()->SetTitle("#Delta E (MeV)");
  des6.SetLineColor(2);
  des6.Draw("same");

  //c.cd(9);
  //nt2->Draw("mbc:de");

  c.Print(KEDR+"dbck_"+type+".eps");
  c.Print(KEDR+"dbck_"+type+".png");

  ///////////////////////////////////////
  TCanvas c2("c2","c2",1000,300);
  c2.Divide(4,1);

  c2.cd(1);
  mbc1.Draw("elp");
  mbc1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbc2.SetLineColor(2);
  mbc2.Draw("same");

  c2.cd(2);
  de1.Draw("elp");
  de1.GetXaxis()->SetTitle("#Delta E (MeV)");
  de2.SetLineColor(2);
  de2.Draw("same");

  c2.cd(3);
  nt->Draw("de:mbc");
  TH2F* htemp = (TH2F*)gPad->GetPrimitive("htemp");
  htemp->GetXaxis()->SetTitle("M_{bc} (MeV)");
  htemp->GetYaxis()->SetTitle("#DeltaE (MeV)");
  htemp->GetYaxis()->SetTitleOffset(1.3);
  htemp->SetTitle("");

  c2.cd(4);
  dp1.Draw("elp");
  dp1.GetXaxis()->SetTitle("#Delta|p| (MeV)");
  dp2.SetLineColor(2);
  dp2.Draw("same");

  c2.Print(KEDR+"dbck_"+type+"_2.eps");
  c2.Print(KEDR+"dbck_"+type+"_2.png");

  ////////////////////////////////////////////////
  TCanvas c3("c3","c3",800,500);
  c3.Divide(3,2);

  c3.cd(1);
  mbcs1.Draw("elp");
  mbcs1.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbcs2.SetLineColor(2);
  mbcs2.Draw("same");

  c3.cd(2);
  mbcs3.Draw("elp");
  mbcs3.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbcs4.SetLineColor(2);
  mbcs4.Draw("same");

  c3.cd(3);
  mbcs5.Draw("elp");
  mbcs5.GetXaxis()->SetTitle("M_{bc} (MeV)");
  mbcs6.SetLineColor(2);
  mbcs6.Draw("same");

  c3.cd(4);
  des1.Draw("elp");
  des1.GetXaxis()->SetTitle("#Delta E (MeV)");
  des2.SetLineColor(2);
  des2.Draw("same");

  c3.cd(5);
  des3.Draw("elp");
  des3.GetXaxis()->SetTitle("#Delta E (MeV)");
  des4.SetLineColor(2);
  des4.Draw("same");

  c3.cd(6);
  des5.Draw("elp");
  des5.GetXaxis()->SetTitle("#Delta E (MeV)");
  des6.SetLineColor(2);
  des6.Draw("same");

  c3.Print(KEDR+"dbck_"+type+"_3.eps");
  c3.Print(KEDR+"dbck_"+type+"_3.png");

  ///////////////////////////////////////
}
