{
    TFile  *f1 = new TFile( "result_hists.root");
    TH1F *h1 = (TH1F*)f1->Get("exp_mbc");
    TH1F *h2 = (TH1F*)f1->Get("bck_mbc");
    TH1F *h3 = (TH1F*)f1->Get("dbck_mbc");
    h1->Add(h2,-1);
    h1->Add(h3,-1);
    TCanvas *c = new TCanvas();
    h1->Draw();
    c->Print("exp_minus_mc.root");
}
