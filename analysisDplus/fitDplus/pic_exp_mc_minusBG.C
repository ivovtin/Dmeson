{
    TFile  *f1 = new TFile( "result_hists.root");
    TH1F *h1 = (TH1F*)f1->Get("exp_mbc");
    TH1F *h2 = (TH1F*)f1->Get("bck_mbc");
    TH1F *h3 = (TH1F*)f1->Get("dbck_mbc");
    TH1F *h4 = (TH1F*)f1->Get("sig_mbc");
    h1->Add(h2,-1);
    h1->Add(h3,-1);
    TCanvas *c = new TCanvas();
    h1->Draw();
    h4->Draw("same");

    TString KEDR = "/store/users/ovtin/outDmeson/Dplus/results/fitsDplus/";
    //TString KEDR = "/store/users/ovtin/outDmeson/Dplus/results/fitsDplus/forTest/";

    TString outfile = "exp_mc_compare_Dplus_mbc";

    c.Print(KEDR + outfile + ".eps");
    c.Print(KEDR + outfile + ".png");
    c.Print("exp_minus_mc.root");

    Double_t KT = h1->KolmogorovTest(h4);
    Double_t chi2 = h1->Chi2Test(h4,"CHI2");

    //cout<<"KT="<<KT<<endl;
    cout<<"KT="<<KT<<"\t"<<"chi2="<<chi2<<endl;

}
