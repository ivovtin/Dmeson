void pic_compare_exp_mc()
{
   TTree *t1 = new TTree("t1", "exp");
   TTree *t2 = new TTree("t2", "total mc");
   TTree *t3 = new TTree("t3", "sig mc");
   TTree *t4 = new TTree("t4", "bck mc");
   TTree *t5 = new TTree("t5", "dbck mc");

   t1->ReadFile("/home/ovtin/development/Dmeson/analysisD0/fitD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_ATC_1.0140.dat", "mbc1/D:de1/D:dp1/D");
   t2->ReadFile("/home/ovtin/development/Dmeson/analysisD0/fitD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_def_S1.0_A6.0_Z0.0.gen", "mbc2/D:de2/D:dp2/D");
   t3->ReadFile("/home/ovtin/development/Dmeson/analysisD0/fitD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_bck_S1.0_A6.0_Z0.0.gen", "mbc3/D:de3/D:dp3/D");
   t4->ReadFile("/home/ovtin/development/Dmeson/analysisD0/fitD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_dbck_S1.0_A6.0_Z0.0.gen", "mbc4/D:de4/D:dp4/D");
   t5->ReadFile("/home/ovtin/development/Dmeson/analysisD0/fitD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_sig_S1.0_A6.0_Z0.0.gen", "mbc5/D:de5/D:dp5/D");

   TH1F *hmbc1=new TH1F("hmbc1","hmbc1",100,1800,1900.);
   TH1F* hdE1=new TH1F("hdE1","hdE1",60,-300.,300.);
   TH1F* hdp1=new TH1F("hdp1","hdp1",200,-1000.,1000.);

   TH1F *hmbc2=new TH1F("hmbc2","hmbc2",100,1800,1900.);
   TH1F* hdE2=new TH1F("hdE2","hdE2",60,-300.,300.);
   TH1F* hdp2=new TH1F("hdp2","hdp2",200,-1000.,1000.);

   TH1F *hmbc3=new TH1F("hmbc3","hmbc3",100,1800,1900.);
   TH1F* hdE3=new TH1F("hdE3","hdE3",60,-300.,300.);
   TH1F* hdp3=new TH1F("hdp3","hdp3",200,-1000.,1000.);

   TH1F *hmbc4=new TH1F("hmbc4","hmbc4",100,1800,1900.);
   TH1F* hdE4=new TH1F("hdE4","hdE4",60,-300.,300.);
   TH1F* hdp4=new TH1F("hdp4","hdp4",200,-1000.,1000.);

   TH1F *hmbc5=new TH1F("hmbc5","hmbc5",100,1800,1900.);
   TH1F* hdE5=new TH1F("hdE5","hdE5",60,-300.,300.);
   TH1F* hdp5=new TH1F("hdp5","hdp5",200,-1000.,1000.);

   TCanvas c("c","c",600,900);
   c.Divide(1,3);

   c.cd(1);
  /*
   t3->Draw("mbc3 >> hmbc3","de3>-100 && de3<100");
   //hmbc3->Scale(scale);
   //hmbc3->SetLineColor(kGreen);
   //hmbc3->GetXaxis()->SetRangeUser(1800.,1900.);
   //hmbc3->Draw("hist,same");
   t4->Draw("mbc4 >> hmbc4","de4>-100 && de4<100");
   //hmbc4->Scale(scale);
   t5->Draw("mbc5 >> hmbc5","de5>-100 && de5<100");
   //hmbc5->Scale(scale);

   THStack *mbc_hs = new THStack("mbc_hs","");
   mbc_hs->Add(hmbc3);
   hmbc3->SetFillColor(8);
   hmbc3->SetFillStyle(3505);
   mbc_hs->Add(hmbc4);
   hmbc4->SetFillColor(9);
   hmbc4->SetFillStyle(3544);
   mbc_hs->Add(hmbc5);
   hmbc5->SetFillColor(2);
   hmbc5->SetFillStyle(3595);
   mbc_hs->Draw("hist");
  */
   /*
    t1->Draw("mbc1 >> hmbc1","de1>-100 && de1<100","norm,same");
    double scale = (hmbc3->GetSumOfWeights()+hmbc4->GetSumOfWeights()+hmbc5->GetSumOfWeights())/hmbc1->GetSumOfWeights();
    hmbc1->SetLineColor(kBlue);
    hmbc1->Scale(scale);
    hmbc1->Draw("hist,same");
    */
   /*
   t2->Draw("mbc2 >> hmbc2","de2>-100 && de2<100","norm,same");
   double scale = (hmbc3->GetSumOfWeights()+hmbc4->GetSumOfWeights()+hmbc5->GetSumOfWeights())/hmbc2->GetSumOfWeights();
   hmbc2->SetLineColor(kBlue);
   hmbc2->Scale(scale);
   hmbc2->Draw("hist,same");
   */

   t1->Draw("mbc1 >> hmbc1","de1>-100 && de1<100");
   hmbc1->SetLineColor(kRed);
   hmbc1->GetXaxis()->SetRangeUser(1800.,1900.);
   t2->Draw("mbc2 >> hmbc2","de2>-100 && de2<100");
   hmbc2->SetLineColor(kBlue);
   hmbc2->GetXaxis()->SetRangeUser(1800.,1900.);
   double scale = hmbc1->GetSumOfWeights()/hmbc2->GetSumOfWeights();
   hmbc2->Scale(scale);
   hmbc1->Draw("hist");
   hmbc2->Draw("hist,same");

   Double_t KT = hmbc1->KolmogorovTest(hmbc2);
   Double_t chi2 = hmbc1->Chi2Test(hmbc2);
   cout<<"KT="<<KT<<"\t"<<"chi2="<<chi2<<endl;

   c.cd(2);
   t1->Draw("de1 >> hdE1","mbc1>1855 && mbc1<1875","norm");
   hdE1->SetLineColor(kRed);
   hdE1->GetXaxis()->SetRangeUser(-300.,300.);
   t2->Draw("de2 >> hdE2","mbc2>1855 && mbc2<1875","norm,same");
   hdE2->SetLineColor(kBlue);
   hdE2->GetXaxis()->SetRangeUser(-300.,300.);
   hdE2->Scale(scale);
   hdE1->Draw("hist");
   hdE2->Draw("hist,same");

   Double_t KT = hdE1->KolmogorovTest(hdE2);
   Double_t chi2 = hdE1->Chi2Test(hdE2);
   cout<<"KT="<<KT<<"\t"<<"chi2="<<chi2<<endl;

   c.cd(3);
   t1->Draw("dp1 >> hdp1","dp1>-1000 && dp1<1000","norm");
   hdp1->SetLineColor(kRed);
   t2->Draw("dp2 >> hdp2","dp2>-1000 && dp2<1000","norm,same");
   hdp2->SetLineColor(kBlue);
   hdp2->Scale(scale);
   hdp1->Draw("hist");
   hdp2->Draw("hist,same");

   Double_t KT = hdp1->KolmogorovTest(hdp2);
   Double_t chi2 = hdp1->Chi2Test(hdp2);
   cout<<"KT="<<KT<<"\t"<<"chi2="<<chi2<<endl;

   c.Update();
   TString dir_out="/home/ovtin/public_html/outDmeson/D0/fitsD0/";
   c.Print(dir_out + "compare_exp_sim.png");
   c.Print(dir_out + "compare_exp_sim.eps");
}
