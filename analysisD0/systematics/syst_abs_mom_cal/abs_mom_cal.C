void abs_mom_cal()
{
   TCanvas *c1 = new TCanvas("c1","",800,400);
   c1->Divide(2,1);

   const Int_t n = 8;
   Float_t k[n]  = {1.0090, 1.0110, 1.0120, 1.0130, 1.0140, 1.0150, 1.0160, 1.0170};
   Float_t de[n]  =  {-5.832543, -2.814794, -1.407912, 0.466446, 1.811023, 3.469988, 4.898390, 6.334714 };
   Float_t ede[n]  = {5.914430, 5.903771, 5.900944, 5.869219, 5.864379, 5.878399, 5.877937, 5.876286 };
   Float_t mbc[n]  = {1864.940609-1864.953709, 1864.947496-1864.953709, 1864.949964-1864.953709, 1864.953709-1864.953709, 1864.955286-1864.953709, 1864.961234-1864.953709, 1864.965966-1864.953709, 1864.968335-1864.953709};

   c1->cd(1);
   TGraphErrors *gr1 = new TGraphErrors(n, de, mbc, ede, NULL);
   //TGraphErrors *gr1 = new TGraphErrors(n, de, mbc, NULL, NULL);
   gr1->SetTitle("");
   gr1->SetMarkerColor(4);
   gr1->SetMarkerStyle(20);
   gr1->SetLineWidth(5.);
   gr1->SetMarkerSize(1.2);
   gr1->SetFillColor(4);

   //gr->GetXaxis()->SetTitle("d#DeltaE, MeV");
   gr1->GetXaxis()->SetTitle("#DeltaE, MeV");
   gr1->GetYaxis()->SetTitleOffset(1.5);
   gr1->GetYaxis()->SetTitle("dM_{bc}, MeV");
   gr1->GetXaxis()->SetRangeUser(-12.0, 12.0);
   gr1->Draw("ape");
   TF1 f1("f1","pol1",-12,12);  //f(x) = p0 + p1*x + p2*x2 +...
   f1->SetParameter(0, -0.00984294);
   //f1->SetParameter(1, 0.00871983);
   f1->SetParameter(1, 0.0005);
   gr1->Fit("f1");

   TLine* l1 = new TLine(-12.0, -0.009, 12.0, -0.009);
   l1->SetLineColor(kGreen);
   l1->SetLineWidth(3);
   l1->SetLineStyle(2);
   l1->Draw();

   TLine* l2 = new TLine(-12.0, 0.009, 12.0, 0.009);
   l2->SetLineColor(kGreen);
   l2->SetLineWidth(3);
   l2->SetLineStyle(2);
   l2->Draw();


   c1->cd(2);
   TGraph *gr2 = new TGraph(n, k, mbc);
   gr2->SetTitle("");
   gr2->SetMarkerColor(4);
   gr2->SetMarkerStyle(20);
   gr2->SetLineWidth(5.);
   gr2->SetMarkerSize(1.2);
   gr2->SetFillColor(4);

   gr2->GetXaxis()->SetTitle("Correction coefficient for momentum");
   gr2->GetYaxis()->SetTitleOffset(1.5);
   gr2->GetYaxis()->SetTitle("dM_{bc}, MeV");
   gr2->GetXaxis()->SetRangeUser(1.000, 1.020);
   TF1 f2("f2","pol1",1.0,1.020);  //f(x) = p0 + p1*x + p2*x2 +...
   gr2->Fit("f2");
   gr2->Draw("ap");

   TLine* l3 = new TLine(1.0084, -0.009, 1.0178, -0.009);
   l3->SetLineColor(kGreen);
   l3->SetLineWidth(3);
   l3->SetLineStyle(2);
   l3->Draw();

   TLine* l4 = new TLine(1.0084, 0.009, 1.0178, 0.009);
   l4->SetLineColor(kGreen);
   l4->SetLineWidth(3);
   l4->SetLineStyle(2);
   l4->Draw();

   c1->Update();
   TString KEDR = "/home/ovtin/public_html/outDmeson/D0/systematics/";
   c1->SaveAs(KEDR+"abs_mom_cal.png");
   c1->SaveAs(KEDR+"abs_mom_cal.eps");
   c1->SaveAs(KEDR+"abs_mom_cal.pdf");
}
