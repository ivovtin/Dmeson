void pic_dif_data_sim()
{
    TString dir_out="/home/ovtin/public_html/outDmeson/Kspp/";

    gROOT->SetStyle("Plain");

    TFile *inData = TFile::Open("exp_kspp_data_0.root");
    //TFile *inData = TFile::Open("exp_kspp_data2004_1.root");
    TFile *inSim = TFile::Open("sim_kspp_sig_2.root");

    TCanvas c("c","c",600,400);

    TH1F *h1 = (TH1F*)inData->Get("invMcor");
    h1->SetLineColor(kBlue);
    h1->SetName("data");
    h1->SetTitle("");
    h1->GetYaxis()->SetTitle("Number of events");
    h1->GetYaxis()->SetTitleOffset(1.5);
    h1->GetListOfFunctions()->ls();
    TF1 *fun1 = h1->GetFunction("fitInvM2");
    h1->GetListOfFunctions()->Remove(fun1);
    Double_t sc1=h1->GetEntries();
    h1->Scale(1/sc1);
    h1->Draw("");

    TH1F *h2 = (TH1F*)inSim->Get("invMcor");
    h2->SetLineColor(kRed);
    h2->SetName("sim");
    h2->SetTitle("");
    h2->GetYaxis()->SetTitle("Number of events");
    h2->GetYaxis()->SetTitleOffset(1.5);
    h2->GetListOfFunctions()->ls();
    TF1 *fun2 = h2->GetFunction("fitInvM2");
    h2->GetListOfFunctions()->Remove(fun2);
    Double_t sc2=h2->GetEntries();
    h2->Scale(1/sc2);
    h2->Draw("sames");
    TPaveStats *st1 = (TPaveStats*)h1->FindObject("stats");
    st1->SetX1NDC(.70);
    st1->SetX2NDC(.90);
    st1->SetY1NDC(.70);
    st1->SetY2NDC(.90);
    st1->SetTextColor(4);
    TPaveStats *st2 = (TPaveStats*)h2->FindObject("stats");
    st2->SetX1NDC(.70);
    st2->SetX2NDC(.90);
    st2->SetY1NDC(.50);
    st2->SetY2NDC(.70);
    st2->SetTextColor(2);
    gPad->Modified();

    c.Update();
    c.Print(dir_out + "compare_data_sim_2016-17.png");
    c.Print(dir_out + "compare_data_sim_2016-17.eps");
    c.Print("compare_data_sim_2016-17.root");
    //c.Print(dir_out + "compare_data_sim_2004.png");
    //c.Print(dir_out + "compare_data_sim_2004.eps");
    //c.Print("compare_data_sim_2004.root");
}
