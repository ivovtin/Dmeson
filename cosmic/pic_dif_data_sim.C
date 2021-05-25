void pic_dif_data_sim()
{
    TString dir_out="/home/ovtin/public_html/outDmeson/Cosmic/";

    gROOT->SetStyle("Plain");

    TFile *inData = TFile::Open("exp_cosmic_data_0.root");
    TFile *inSim = TFile::Open("sim_cosmic_sig_1.root");

    TCanvas c("c","c",1200,1200);
    c.Divide(1,3);

    c.cd(1);

    TGraphErrors *gr1 = (TGraphErrors*)inData->Get("gr1");
    gr1->SetLineColor(kBlue);
    gr1->SetName("data");
    gr1->SetTitle("");
    gr1->SetMinimum(0.);
    gr1->SetMaximum(0.13);
    gr1->GetYaxis()->SetTitleOffset(0.5);
    gr1->GetXaxis()->SetTitleSize(0.050);
    gr1->GetYaxis()->SetTitleSize(0.050);
    gr1->Draw("AP");

    TGraphErrors *gr2 = (TGraphErrors*)inSim->Get("gr1");
    gr2->SetLineColor(kRed);
    gr2->GetYaxis()->SetTitleOffset(0.5);
    gr2->GetXaxis()->SetTitleSize(0.050);
    gr2->GetYaxis()->SetTitleSize(0.050);
    gr2->SetName("sim");
    gr2->SetTitle("");
    gr2->SetMinimum(0.);
    gr2->SetMaximum(0.13);
    gr2->SetMarkerStyle(21);
    gr2->SetMarkerColor(kRed);
    gr2->Draw("P");

    TLegend *leg = new TLegend(0.15,0.72,0.25,0.85);
    leg->AddEntry(gr1,"Data","l");
    leg->AddEntry(gr2,"Simulation","l");
    leg->SetTextSize(0.05);
    leg->Draw("same");

    c.cd(2);
    TGraphErrors *gr3 = (TGraphErrors*)inData->Get("gr2");
    gr3->SetLineColor(kBlue);
    gr3->GetYaxis()->SetTitleOffset(0.5);
    gr3->GetXaxis()->SetTitleSize(0.050);
    gr3->GetYaxis()->SetTitleSize(0.050);
    gr3->SetName("data");
    gr3->SetTitle("");
    gr3->SetMinimum(0.);
    gr3->SetMaximum(2.4);
    gr3->Draw("AP");

    TGraphErrors *gr4 = (TGraphErrors*)inSim->Get("gr2");
    gr4->SetLineColor(kRed);
    gr4->GetYaxis()->SetTitleOffset(0.5);
    gr4->GetXaxis()->SetTitleSize(0.050);
    gr4->GetYaxis()->SetTitleSize(0.050);
    gr4->SetName("sim");
    gr4->SetTitle("");
    gr4->SetMinimum(0.);
    gr4->SetMaximum(2.4);
    gr4->SetMarkerStyle(21);
    gr4->SetMarkerColor(kRed);
    gr4->Draw("P");

    c.cd(3);
    TGraphErrors *gr5 = (TGraphErrors*)inData->Get("gr3");
    gr5->SetLineColor(kBlue);
    gr5->GetYaxis()->SetTitleOffset(0.5);
    gr5->GetXaxis()->SetTitleSize(0.050);
    gr5->GetYaxis()->SetTitleSize(0.050);
    gr5->SetName("data");
    gr5->SetTitle("");
    gr5->SetMinimum(0.);
    gr5->SetMaximum(1.6);
    gr5->Draw("AP");

    TGraphErrors *gr6 = (TGraphErrors*)inSim->Get("gr3");
    gr6->SetLineColor(kRed);
    gr6->GetYaxis()->SetTitleOffset(0.5);
    gr6->GetXaxis()->SetTitleSize(0.050);
    gr6->GetYaxis()->SetTitleSize(0.050);
    gr6->SetName("sim");
    gr6->SetTitle("");
    gr6->SetMinimum(0.);
    gr6->SetMaximum(1.6);
    gr6->SetMarkerStyle(21);
    gr6->SetMarkerColor(kRed);
    gr6->Draw("P");

    c.Update();
    c.Print(dir_out + "compare_data_sim_2016-17_method2_corr_S1.0_A7.5_Z5.5.png");
    c.Print(dir_out + "compare_data_sim_2016-17_method2_corr_S1.0_A7.5_Z5.5.eps");
    c.Print("compare_data_sim_2016-17.root");
}
