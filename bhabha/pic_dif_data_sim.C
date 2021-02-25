void pic_dif_data_sim()
{
    TString dir_out="/home/ovtin/public_html/outDmeson/BhaBha/";

    gROOT->SetStyle("Plain");

    TFile *inData = TFile::Open("exp_bhabha_data_0.root");
    TFile *inSim = TFile::Open("sim_bhabha_sig_2.root");

    TCanvas c("c","c",1200,400);
    c.Divide(3,1);

    c.cd(1);

    TH1F *hpres1 = (TH1F*)inData->Get("hpres");
    hpres1->SetLineColor(kBlue);
    hpres1->SetName("data");
    hpres1->SetTitle("");
    hpres1->SetMaximum(0.065);
    hpres1->GetYaxis()->SetTitle("Number of events");
    hpres1->GetYaxis()->SetTitleOffset(1.5);
    hpres1->GetListOfFunctions()->ls();
    TF1 *fun1 = hpres1->GetFunction("gaus");
    //TF1 *fun1 = hpres1->GetFunction("fit1");
    hpres1->GetListOfFunctions()->Remove(fun1);
    hpres1->Draw("");
    TH1F *hpres2 = (TH1F*)inSim->Get("hpres");
    hpres2->SetLineColor(kRed);
    hpres2->SetName("sim");
    hpres2->SetTitle("");
    hpres2->GetYaxis()->SetTitle("Number of events");
    hpres2->GetYaxis()->SetTitleOffset(1.5);
    hpres2->GetListOfFunctions()->ls();
    TF1 *fun2 = hpres2->GetFunction("gaus");
    //TF1 *fun2 = hpres2->GetFunction("fit1");
    hpres2->GetListOfFunctions()->Remove(fun2);
    /*
    TPaveStats *st2 = (TPaveStats*)hpres2->FindObject("stats");
    if(st2){
      st2->SetName("sim");
      TList *list2 = st2->GetListOfLines();
      TText *p1 = st2->GetLineWith("Prob");
      TText *p2 = st2->GetLineWith("Constant");
      TText *p3 = st2->GetLineWith("Mean");
      TText *p4 = st2->GetLineWith("Sigma");
      list2->Remove(p1);
      list2->Remove(p2);
      list2->Remove(p3);
      list2->Remove(p4);
      st2->Modify();
      st2->Print();
    }
    */
    hpres2->Draw("sames");
    TPaveStats *st1 = (TPaveStats*)hpres1->FindObject("stats");
    st1->SetX1NDC(.70);
    st1->SetX2NDC(.90);
    st1->SetY1NDC(.70);
    st1->SetY2NDC(.90);
    st1->SetTextColor(4);
    TPaveStats *st2 = (TPaveStats*)hpres2->FindObject("stats");
    st2->SetX1NDC(.70);
    st2->SetX2NDC(.90);
    st2->SetY1NDC(.50);
    st2->SetY2NDC(.70);
    st2->SetTextColor(2);
    gPad->Modified();

    c.cd(2);

    TH1F *hphi1 = (TH1F*)inData->Get("hphi");
    hphi1->SetLineColor(kBlue);
    hphi1->SetName("data");
    hphi1->SetMaximum(0.11);
    hphi1->SetTitle("");
    hphi1->GetYaxis()->SetTitle("Number of events");
    hphi1->GetYaxis()->SetTitleOffset(1.5);
    hphi1->GetListOfFunctions()->ls();
    TF1 *fun3 = hphi1->GetFunction("gaus");
    //TF1 *fun3 = hphi1->GetFunction("fit2");
    hphi1->GetListOfFunctions()->Remove(fun3);
    hphi1->Draw("");

    TH1F *hphi2 = (TH1F*)inSim->Get("hphi");
    hphi2->SetLineColor(kRed);
    hphi2->SetName("sim");
    hphi2->SetTitle("");
    hphi2->GetYaxis()->SetTitle("Number of events");
    hphi2->GetYaxis()->SetTitleOffset(1.5);
    hphi2->GetListOfFunctions()->ls();
    TF1 *fun4 = hphi2->GetFunction("gaus");
    //TF1 *fun4 = hphi2->GetFunction("fit2");
    hphi2->GetListOfFunctions()->Remove(fun4);
    hphi2->Draw("sames");
    TPaveStats *st3 = (TPaveStats*)hphi1->FindObject("stats");
    st3->SetX1NDC(.70);
    st3->SetX2NDC(.90);
    st3->SetY1NDC(.70);
    st3->SetY2NDC(.90);
    st3->SetTextColor(4);
    TPaveStats *st4 = (TPaveStats*)hphi2->FindObject("stats");
    st4->SetX1NDC(.70);
    st4->SetX2NDC(.90);
    st4->SetY1NDC(.50);
    st4->SetY2NDC(.70);
    st4->SetTextColor(2);
    gPad->Modified();

    c.cd(3);
    TH1F *htheta1 = (TH1F*)inData->Get("htheta");
    htheta1->SetLineColor(kBlue);
    htheta1->SetMinimum(0.);
    htheta1->SetMaximum(0.135);
    htheta1->SetName("data");
    htheta1->SetTitle("");
    htheta1->GetYaxis()->SetTitle("Number of events");
    htheta1->GetYaxis()->SetTitleOffset(1.5);
    htheta1->GetListOfFunctions()->ls();
    TF1 *fun5 = htheta1->GetFunction("gaus");
    //TF1 *fun5 = htheta1->GetFunction("fit3");
    htheta1->GetListOfFunctions()->Remove(fun5);
    htheta1->Draw("");

    TH1F *htheta2 = (TH1F*)inSim->Get("htheta");
    htheta2->SetLineColor(kRed);
    htheta2->SetName("sim");
    htheta2->SetTitle("");
    htheta2->GetYaxis()->SetTitle("Number of events");
    htheta2->GetYaxis()->SetTitleOffset(1.5);
    htheta2->GetListOfFunctions()->ls();
    TF1 *fun6 = htheta2->GetFunction("gaus");
    //TF1 *fun6 = htheta2->GetFunction("fit3");
    htheta2->GetListOfFunctions()->Remove(fun6);
    htheta2->Draw("sames");
    TPaveStats *st5 = (TPaveStats*)htheta1->FindObject("stats");
    st5->SetX1NDC(.70);
    st5->SetX2NDC(.90);
    st5->SetY1NDC(.70);
    st5->SetY2NDC(.90);
    st5->SetTextColor(4);
    TPaveStats *st6 = (TPaveStats*)htheta2->FindObject("stats");
    st6->SetX1NDC(.70);
    st6->SetX2NDC(.90);
    st6->SetY1NDC(.50);
    st6->SetY2NDC(.70);
    st6->SetTextColor(2);
    gPad->Modified();

    c.Update();
    c.Print(dir_out + "compare_data_sim_2016-17_23551-23569.png");
    c.Print(dir_out + "compare_data_sim_2016-17_23551-23569.eps");
    c.Print("compare_data_sim_2016-17.root");
}
