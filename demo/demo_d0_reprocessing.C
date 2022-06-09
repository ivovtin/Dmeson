{
   TString KEDR = "/store/users/ovtin/outDmeson/demo/";

   TCanvas *c1 = new TCanvas("c1","",200,10,400,400);

   c1->SetFillColor(0);
   //c1->SetGrid();
   c1->GetFrame()->SetFillColor(0);
   c1->GetFrame()->SetBorderSize(12);

   const Int_t n = 9;

   Float_t x_pdg = 1864.84;
   Float_t ex_pdg = 0.05;

   Float_t x[n]  = {
                     1864.7,      // MARK II
                     1864.6,      // ACCMOR
                     1864.847,    // CLEO 2007
                     1865.300,    // KEDR 2010
                     1864.750,    // LHCb 2013
                     1864.841,    // BaBar 2013
                     1864.845,    // CLEO 2014
                     1864.95,     // KEDR 2022
                     1865.300     // KEDR 2004-2022
                   };

   Float_t ex[n] = {
                     0.6,                             // MARK II
                     sqrt(0.3*0.3+1.0*1.0),           // ACCMOR
                     sqrt(0.150*0.150+0.095*0.095),   // CLEO  2007
                     sqrt(0.33*0.33+0.23*0.23),       // KEDR 2010
                     sqrt(0.150*0.150+0.110*0.110),   // LHCb 2013
                     sqrt(0.048*0.048+0.063*0.063),   // BaBar 2013
                     sqrt(0.025*0.025+0.057*0.057),   // CLEO 2014
                     sqrt(0.270*0.270+0.106*0.106),   // KEDR 2022
                     sqrt(0.300*0.300+0.031*0.031)    // KEDR 2004-2022
   };

   Float_t sx[n] = {
                     0.,        // MARK II
                     1.0,       // ACCMOR
                     0.095,     // CLEO
                     0.23,      // KEDR
                     0.11,      // LHCb 2013
                     0.063,     // BaBar 2013
                     0.057,     // CLEO 2014
                     0.106,     // KEDR 2022
                     0.031      // KEDR 2004-2022
                   };

   char *exp[n] = {"MARK II","ACCMOR","CLEO 2007","KEDR 2010","LHCb 2013","BaBar 2013","CLEO 2014","KEDR 2022","KEDR 2022*"};

   Float_t y[n]  = {9.,8.,7.,6.,5.,4.,3.,2.,1.};
   Float_t ey[n] = {0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06,0.06};
   Float_t ey0[n] = {0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0};

   Float_t y_pdg = ((float)n+1.5)/2.;
   Float_t ey_pdg = ((float)n+0.5)/2.-0.2;

   TGraphErrors *gr = new TGraphErrors(n,x,y,ex,ey0);
   TGraphErrors *gr_sys = new TGraphErrors(n,x,y,sx,ey);
   TGraphErrors *gr_pdg = new TGraphErrors(1,&x_pdg,&y_pdg,&ex_pdg,&ey_pdg);
   gr->SetTitle("D^{0} mass measurements");
   gr->SetMarkerColor(4);
   gr->SetMarkerStyle(20);
   gr->SetLineWidth(4.);
   gr->SetMarkerSize(1.2);
   gr->SetFillColor(4);
   gr_sys->SetLineWidth(7.);
   gr_sys->SetFillColor(2);
   c1->SetLeftMargin(0.25);
   c1->SetBottomMargin(0.2);

   gr_pdg->SetFillColor(5);

   gr->GetYaxis()->Set(n, 0.5, n+0.5);
   for (int i=1;i<=n;i++) {
      gr->GetYaxis()->SetBinLabel((int)y[i-1],exp[i-1]);
   }
   gr->GetXaxis()->SetNdivisions(505);
   gr->GetYaxis()->SetLabelSize(0.07);
   gr->GetXaxis()->SetTitle("D^{0} mass (MeV)");
   gr->GetXaxis()->SetTitleSize(0.06);
   gr->GetXaxis()->SetLabelSize(0.05);

   gr->GetYaxis()->SetRangeUser(0.5, n+1.);

   gr->Draw("ap");
   gr_pdg->Draw("2same");
   gr_sys->Draw("2same");
   gr->Draw("psame");

   TLine* l = new TLine(x_pdg, y_pdg-ey_pdg, x_pdg, y_pdg+ey_pdg);
   l->Draw();

   TLatex* t = new TLatex();
   t->SetTextSize(0.03);
   char str[100];
   sprintf(str, "PDG: %7.2f #pm %3.2f", x_pdg, ex_pdg);
   t->DrawLatex(x_pdg+0.1, n+0.7, str);

   for (int i=0; i<n; i++) {
     char str[100];
     sprintf(str, "%7.2f #pm %3.2f", x[i], ex[i]);
     t->SetTextSize(0.03);
     t->DrawLatex(x[i]-0.2, y[i]+0.2, str);
   }

   c1->Update();
   c1->Print(KEDR+"d0_reprocessing.eps");
   c1->Print(KEDR+"d0_reprocessing.png");
   c1->Print(KEDR+"d0_reprocessing.pdf");

}
