{
  gROOT->Reset();
  gROOT->DeleteAll();
  gStyle->SetOptStat(0);
  gStyle->SetOptFit(1111);
  gStyle->SetCanvasColor(0);
  gStyle->SetFrameFillColor(0);

  TTree nt;
  nt.ReadFile("stat.dat","m0:m:em:d0:d:ed:bc0:bc:ebc:bd0:bd:ebd");

  TH1F mh("mh","",50, -2., 2.);
  nt->Project("mh","m-1869.540665");

  TH1F dh("dh","",50, -30, 30);
  nt->Project("dh","d-2.828889");

  TH1F mp("mp","",50, -4., 4.);
  nt->Project("mp","(m-1869.540665)/em");

  TH1F dp("dp","",50, -4., 4.);
  nt->Project("dp","(d-2.828889)/ed");

  TCanvas c("c","c",600.,600.);
  
  c.Divide(2,2);
  
  c.cd(1);
  mh.Fit("gaus","l");
  mh.GetXaxis()->SetTitle("M_{bc} residual (MeV)");

  c.cd(2);
  dh.Fit("gaus","l");
  dh.GetXaxis()->SetTitle("#Delta E residual  (MeV)");

  c.cd(3);
  mp.Fit("gaus","l");
  mp.GetXaxis()->SetTitle("M_{bc} pull (MeV)");

  c.cd(4);
  dp.Fit("gaus","l");
  dp.GetXaxis()->SetTitle("#Delta E pull  (MeV)");

  c.Print("toymc_kpp.eps");
}
