void abs_mom_cal()
{
   TCanvas *c1 = new TCanvas("c1","",800,400);
   c1->Divide(2,1);

   const Int_t n = 5;
   Float_t k[n]  = {1.0120, 1.0130, 1.0140, 1.0150, 1.0170};

   Float_t de[n]  = {-2.934333, -1.365228, -0.157074, 1.308748, 4.410558};
   Float_t ede[n]  = {4.526921, 4.548665, 4.543611, 4.543008, 4.410558};
   //Float_t mbc[n]  = {1869.817357, 1869.839832, 1869.827134, 1869.832819, 1869.837657};
   Float_t mbc[n]  = {1869.550451-1869.582446, 1869.585479-1869.582446, 1869.582446-1869.582446, 1869.599857-1869.582446, 1869.629509-1869.582446};   //with corr

   //const Int_t n = 4;
   //Float_t k[n]  = {1.000, 1.020, 1.027, 1.030};
   //Float_t de[n]  = {-3.60175, -8.51104, 0.902344, 5.25387};
   //Float_t ede[n]  = {4.526921, 4.548665, 4.543611, 4.543008};
   //Float_t mbc[n]  = {1869.69, 1869.99, 1870.13, 1870.16};

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
   gr1->GetXaxis()->SetRangeUser(-8.0, 10.0);
   gr1->Draw("ape");
   TF1 f1("f1","pol1",-8,10);  //f(x) = p0 + p1*x + p2*x2 +...
   f1->SetParameter(0, -0.00984294);
   f1->SetParameter(1, 0.00871983);
   gr1->Fit("f1");

   TLine* l1 = new TLine(-8.0, -0.020, 10.0, -0.020);
   l1->SetLineColor(kGreen);
   l1->SetLineWidth(3);
   l1->SetLineStyle(2);
   l1->Draw();

   TLine* l2 = new TLine(-8.0, 0.020, 10.0, 0.020);
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

   TLine* l3 = new TLine(1.0115, -0.020, 1.0175, -0.020);
   l3->SetLineColor(kGreen);
   l3->SetLineWidth(3);
   l3->SetLineStyle(2);
   l3->Draw();

   TLine* l4 = new TLine(1.0115, 0.020, 1.0175, 0.020);
   l4->SetLineColor(kGreen);
   l4->SetLineWidth(3);
   l4->SetLineStyle(2);
   l4->Draw();

   c1->Update();
   TString KEDR = "/home/ovtin/public_html/outDmeson/Dplus/systematics/";
   c1->SaveAs(KEDR+"abs_mom_cal.png");
   c1->SaveAs(KEDR+"abs_mom_cal.eps");
   c1->SaveAs(KEDR+"abs_mom_cal.pdf");
}
