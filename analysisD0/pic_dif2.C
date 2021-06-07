void pic_dif2()
{
   TTree *t1 = new TTree("t1", "old sim 2004");
   TTree *t2 = new TTree("t2", "new sim 2004");
   TTree *t3 = new TTree("t2", "new exp");

   t1->ReadFile("/home/ovtin/development/Dmeson/analysisD0/results/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_v0.dat", "mbc1/D:de1/D:dp1/D");
   t2->ReadFile("/home/ovtin/development/Dmeson/analysisD0/results/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_v1.dat", "mbc2/D:de2/D:dp2/D");
   t3->ReadFile("/home/ovtin/development/Dmeson/analysisD0/results/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_v2.dat", "mbc3/D:de3/D:dp3/D");
   //t3->ReadFile("/home/ovtin/development/Dmeson/analysisD0/results/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat", "mbc3/D:de3/D:dp3/D");

   TH1F *hmbc1=new TH1F("hmbc1","hmbc1",100,1800,1900.);
   TH1F* hdE1=new TH1F("hdE1","hdE1",60,-300.,300.);
   TH1F* hdp1=new TH1F("hdp1","hdp1",200,-1000.,1000.);

   TH1F *hmbc2=new TH1F("hmbc2","hmbc2",100,1800,1900.);
   TH1F* hdE2=new TH1F("hdE2","hdE2",60,-300.,300.);
   TH1F* hdp2=new TH1F("hdp2","hdp2",200,-1000.,1000.);

   TH1F *hmbc3=new TH1F("hmbc3","hmbc3",100,1800,1900.);
   TH1F* hdE3=new TH1F("hdE3","hdE3",60,-300.,300.);
   TH1F* hdp3=new TH1F("hdp3","hdp3",200,-1000.,1000.);

   TCanvas c("c","c",600,900);
   c.Divide(1,3);

   c.cd(1);
   t1->Draw("mbc1 >> hmbc1","de1>-100 && de1<100","norm");
   hmbc1->SetLineColor(kRed);
   hmbc1->GetXaxis()->SetRangeUser(1800.,1900.);
   t2->Draw("mbc2 >> hmbc2","de2>-100 && de2<100","norm,same");
   hmbc2->SetLineColor(kBlue);
   hmbc2->GetXaxis()->SetRangeUser(1800.,1900.);
   t3->Draw("mbc3 >> hmbc3","de3>-100 && de3<100","norm,same");
   hmbc3->SetLineColor(kGreen);
   hmbc3->GetXaxis()->SetRangeUser(1800.,1900.);
   hmbc1->Draw("hist");
   hmbc2->Draw("hist,same");
   hmbc3->Draw("hist,same");

   c.cd(2);
   t1->Draw("de1 >> hdE1","mbc1>1855 && mbc1<1875","norm");
   hdE1->SetLineColor(kRed);
   hdE1->GetXaxis()->SetRangeUser(-300.,300.);
   t2->Draw("de2 >> hdE2","mbc2>1855 && mbc2<1875","norm,same");
   hdE2->SetLineColor(kBlue);
   hdE2->GetXaxis()->SetRangeUser(-300.,300.);
   t3->Draw("de3 >> hdE3","mbc3>1855 && mbc3<1875","norm,same");
   hdE3->SetLineColor(kGreen);
   hdE3->GetXaxis()->SetRangeUser(-300.,300.);
   hdE1->Draw("hist");
   hdE2->Draw("hist,same");
   hdE3->Draw("hist,same");

   c.cd(3);
   t1->Draw("dp1 >> hdp1","dp1>-1000 && dp1<1000","norm");
   hdp1->SetLineColor(kRed);
   t2->Draw("dp2 >> hdp2","dp2>-1000 && dp2<1000","norm,same");
   hdp2->SetLineColor(kBlue);
   t3->Draw("dp3 >> hdp3","dp3>-1000 && dp3<1000","norm,same");
   hdp3->SetLineColor(kGreen);
   hdp1->Draw("hist");
   hdp2->Draw("hist,same");
   hdp3->Draw("hist,same");

   c.Update();
   TString dir_out="/home/ovtin/public_html/outDmeson/D0/";
   c.Print(dir_out + "compare_sims.png");
   c.Print(dir_out + "compare_sims.eps");
}
