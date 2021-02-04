void pic_dif_RUNranges()
{
    TString dir_out="/home/ovtin/public_html/outDmeson/demo/";

    gROOT->SetStyle("Plain");

    TFile *inFile1 = TFile::Open("exp_Dmeson_data_1-100_0.root");
    TFile *inFile2 = TFile::Open("exp_Dmeson_data_401-500_0.root");

    TCanvas c("c","c",1200,400);
    c.Divide(3,1);
    c.cd(1);

    TH1F *h1 = (TH1F*)inFile1->Get("M_{bc}");
    h1->SetLineColor(kBlue);
    h1->SetName("M_{bc}");
    h1->SetTitle("");
    h1->GetYaxis()->SetTitle("Number of events");
    h1->GetYaxis()->SetTitleOffset(1.5);
    h1->Draw("");
    gPad->Modified();

    c.cd(2);
    TH1F *h2 = (TH1F*)inFile2->Get("M_{bc}");
    h2->SetLineColor(kRed);
    h2->SetName("M_{bc}");
    h2->SetTitle("");
    h2->GetYaxis()->SetTitle("Number of events");
    h2->GetYaxis()->SetTitleOffset(1.5);
    h2->Draw("");

    c.Update();
    c.Print(dir_out + "test.png");
    c.Print(dir_out + "test.eps");
    //c.Print("test.root");

    Double_t ks = h1->KolmogorovTest(h2);
    cout<<"ks="<<ks<<endl;

}
