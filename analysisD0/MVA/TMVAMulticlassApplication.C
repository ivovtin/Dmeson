#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
#include <vector>
#include "TFile.h"
#include "TTree.h"
#include "TString.h"
#include "TSystem.h"
#include "TROOT.h"
#include "TStopwatch.h"
#include "TH1F.h"
#include "TMVA/Tools.h"
#include "TMVA/Reader.h"
using namespace TMVA;
void TMVAMulticlassApplication( TString myMethodList = "" )
{
   TMVA::Tools::Instance();
   //---------------------------------------------------------------
   // Default MVA methods to be trained + tested
   std::map<std::string,int> Use;
   Use["MLP"]             = 0;
   Use["BDTG"]            = 1;
   Use["DNN_CPU"] = 0;
   Use["FDA_GA"]          = 0;
   Use["PDEFoam"]         = 0;
   //---------------------------------------------------------------
   std::cout << std::endl;
   std::cout << "==> Start TMVAMulticlassApp" << std::endl;
   if (myMethodList != "") {
      for (std::map<std::string,int>::iterator it = Use.begin(); it != Use.end(); it++) it->second = 0;
      std::vector<TString> mlist = gTools().SplitString( myMethodList, ',' );
      for (UInt_t i=0; i<mlist.size(); i++) {
         std::string regMethod(mlist[i]);
         if (Use.find(regMethod) == Use.end()) {
            std::cout << "Method \"" << regMethod << "\" not known in TMVA under this name. Choose among the following:" << std::endl;
            for (std::map<std::string,int>::iterator it = Use.begin(); it != Use.end(); it++) std::cout << it->first << " " << std::endl;
            std::cout << std::endl;
            return;
         }
         Use[regMethod] = 1;
      }
   }
   // create the Reader object
   TMVA::Reader *reader = new TMVA::Reader( "!Color:!Silent" );
   // create a set of variables and declare them to the reader
   // - the variable names must corresponds in name and type to
   // those given in the weight file(s) that you use


struct data10
{
    float vrtntrk,vrtnip,vrtnbeam,nhitsdc,nhitst1,nhitst2,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsxyt1,nhitszt1,nhitsxyt2,nhitszt2,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,
    nveczt2,ncomb,ncls1,ncls2,ncls,nlkr,ncsi,munhits,mulayerhits1,mulayerhits2,mulayerhits3,Run,numn,numo,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],
    aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20],kft1,kft2;
    float mbc,de,dp,prec1,prec2,fchi2,Ebeam,rEv,p1,p2,pt1,pt2,chi2t1,chi2t2,theta2t,phi2t,thetat1,thetat2,phit1,phit2,e1,
        e2,d1,d2,rr1,rr2,zip1,zip2,ecls1,ecls2,tcls1,tcls2,pcls1,pcls2,emcenergy,lkrenergy,csienergy,enn,eno,tofc1,timet1,betat1,lengtht1,tofc2,timet2,betat2,lengtht2,atcNpet1[20],atcTotalNpet1,
    atcNpet2[20],atcTotalNpet2,tlent1[20],tlent2[20],dedxt1,dedxt2,probpit1,probpit2,resdpit1,resdpit2,probKt1,probKt2,resdKt1,resdKt2;
};
data10 Dmeson;

   //reader->AddVariable( "mbc", &Dmeson.mbc);
   //reader->AddVariable( "de",  &Dmeson.de);
  
   reader->AddVariable( "p1",  &Dmeson.p1);
   reader->AddVariable( "p2",  &Dmeson.p2);

   reader->AddVariable( "pt1",  &Dmeson.pt1);
   reader->AddVariable( "pt2",  &Dmeson.pt2);
  
   reader->AddVariable( "vrtntrk",  &Dmeson.vrtntrk);
   reader->AddVariable( "vrtnip",  &Dmeson.vrtnip);
   reader->AddVariable( "nhitsvd",  &Dmeson.nhitsvd);
   reader->AddVariable( "nhitst1",  &Dmeson.nhitst1);
   reader->AddVariable( "nhitst2",  &Dmeson.nhitst2);
   reader->AddVariable( "nhitsxyt1",  &Dmeson.nhitsxyt1);
   reader->AddVariable( "nhitsxyt2",  &Dmeson.nhitsxyt2);
   reader->AddVariable( "nhitszt1",  &Dmeson.nhitszt1);
   reader->AddVariable( "nhitszt2",  &Dmeson.nhitszt2);
   reader->AddVariable( "ncls",  &Dmeson.ncls);
   reader->AddVariable( "nlkr",  &Dmeson.nlkr);
   reader->AddVariable( "ncsi",  &Dmeson.ncsi);
   reader->AddVariable( "emcenergy",  &Dmeson.emcenergy);
   reader->AddVariable( "lkrenergy",  &Dmeson.lkrenergy);
   reader->AddVariable( "csienergy",  &Dmeson.csienergy);
   reader->AddVariable( "munhits",  &Dmeson.munhits);
   reader->AddVariable( "mulayerhits1",  &Dmeson.mulayerhits1);
   reader->AddVariable( "mulayerhits2",  &Dmeson.mulayerhits2);
   reader->AddVariable( "mulayerhits3",  &Dmeson.mulayerhits3);
   reader->AddVariable( "thetat1",  &Dmeson.thetat1);
   reader->AddVariable( "thetat2",  &Dmeson.thetat2);
   reader->AddVariable( "phit1",  &Dmeson.phit1);
   reader->AddVariable( "phit2",  &Dmeson.phit2);
   reader->AddVariable( "chi2t1",  &Dmeson.chi2t1);
   reader->AddVariable( "chi2t2",  &Dmeson.chi2t2);
   reader->AddVariable( "rr1",  &Dmeson.rr1);
   reader->AddVariable( "rr2",  &Dmeson.rr2);
   reader->AddVariable( "zip1",  &Dmeson.zip1);
   reader->AddVariable( "zip2",  &Dmeson.zip2);

   // book the MVA methods
   TString dir    = "/home/ovtin/development/Dmeson/analysisD0/MVA/dataset/weights/";
   TString prefix = "TMVAMulticlass";
   for (std::map<std::string,int>::iterator it = Use.begin(); it != Use.end(); it++) {
      if (it->second) {
        TString methodName = TString(it->first) + TString(" method");
        TString weightfile = dir + prefix + TString("_") + TString(it->first) + TString(".weights.xml");
        reader->BookMVA( methodName, weightfile );
      }
   }
   // book output histograms
   UInt_t nbin = 100;
   TH1F *histMLP_signal(0), *histBDTG_signal(0), *histFDAGA_signal(0), *histPDEFoam_signal(0), *histDNNCPU_signal(0);
   if (Use["MLP"]) histMLP_signal    = new TH1F( "MVA_MLP_signal",    "MVA_MLP_signal",    nbin, 0., 1.1 );
   if (Use["BDTG"]) histBDTG_signal  = new TH1F( "MVA_BDTG_signal",   "MVA_BDTG_signal",   nbin, 0., 1.1 );
   if (Use["DNN_CPU"]) histDNNCPU_signal = new TH1F("MVA_DNNCPU_signal", "MVA_DNNCPU_signal", nbin, 0., 1.1);
   if (Use["FDA_GA"]) histFDAGA_signal = new TH1F( "MVA_FDA_GA_signal", "MVA_FDA_GA_signal", nbin, 0., 1.1 );
   if (Use["PDEFoam"]) histPDEFoam_signal = new TH1F( "MVA_PDEFoam_signal", "MVA_PDEFoam_signal", nbin, 0., 1.1 );


   //TString typeFile = "signal_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0"; 
   //TString typeFile = "uds_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0"; 
   //TString typeFile = "dbck_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0"; 
   TString typeFile = "exp_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0"; 

   TFile *input(0);
   TString fname = "/home/ovtin/development/Dmeson/analysisD0/MVA/infiles/" + typeFile + ".root";
   if (!gSystem->AccessPathName( fname )) {
      input = TFile::Open( fname ); // check if file in local directory exists
   }
   if (!input) {
      std::cout << "ERROR: could not open data file, please generate example data first!" << std::endl;
      exit(1);
   }
   std::cout << "--- TMVAMulticlassApp : Using input file: " << input->GetName() << std::endl;
   // prepare the tree
   // - here the variable names have to corresponds to your tree
   // - you can use the same variables as above which is slightly faster,
   //   but of course you can use different ones and copy the values inside the event loop
   TTree* theTree = (TTree*)input->Get("et");

   std::cout << "--- Select signal sample" << std::endl;

   theTree->SetBranchAddress("Dmeson",&Dmeson);

   std::cout << "--- Processing: " << theTree->GetEntries() << " events" << std::endl;

   TFile *newfile; 
   newfile = new TFile("/home/ovtin/development/Dmeson/analysisD0/MVA/infiles/" + typeFile +"_new.root","recreate");
   TTree *newtree = theTree->CloneTree();
    
   Float_t MVA=0;
   TBranch *brMVA = newtree->Branch("MVA",&MVA,"MVA/F");

   TStopwatch sw;
   sw.Start();
   for (Long64_t ievt=0; ievt<theTree->GetEntries();ievt++) {
   //for (Long64_t ievt=0; ievt<5000;ievt++) {
      if (ievt%1000 == 0){
         std::cout << "--- ... Processing event: " << ievt << std::endl;
      }
      theTree->GetEntry(ievt);

      //cout<<Dmeson.mbc<<endl;

      if (Use["MLP"]) 
	histMLP_signal->Fill((reader->EvaluateMulticlass( "MLP method" ))[0]);
      if (Use["BDTG"]) histBDTG_signal->Fill((reader->EvaluateMulticlass( "BDTG method" ))[0]);  
      if (Use["BDTG"]) MVA=(reader->EvaluateMulticlass( "BDTG method" ))[0];  
	 //cout<<(reader->EvaluateMulticlass( "BDTG method" ))[0]<<endl;
      if (Use["DNN_CPU"]) 
	histDNNCPU_signal->Fill((reader->EvaluateMulticlass("DNN_CPU method"))[0]);
      if (Use["FDA_GA"]) 
	histFDAGA_signal->Fill((reader->EvaluateMulticlass( "FDA_GA method" ))[0]);
      if (Use["PDEFoam"]) 
	histPDEFoam_signal->Fill((reader->EvaluateMulticlass( "PDEFoam method" ))[0]);

      brMVA->Fill();
   }
   
   newtree->Write("", TObject::kOverwrite);
   newtree->Print();
   newfile->Write();

   // get elapsed time
   sw.Stop();
   std::cout << "--- End of event loop: "; sw.Print();
   TFile *target  = new TFile( "/home/ovtin/development/Dmeson/analysisD0/MVA/TMVAMulticlassApp_"+ typeFile + ".root","RECREATE" );
   if (Use["MLP"]) 
	histMLP_signal->Write();
   if (Use["BDTG"]) histBDTG_signal->Write();
   if (Use["DNN_CPU"]) 
	histDNNCPU_signal->Write();
   if (Use["FDA_GA"]) 
	histFDAGA_signal->Write();
   if (Use["PDEFoam"]) 
	histPDEFoam_signal->Write();
   target->Close();
   std::cout << "--- Created root file: \"TMVMulticlassApp.root\" containing the MVA output histograms" << std::endl;
   delete reader;
   std::cout << "==> TMVAMulticlassApp is done!" << std::endl << std::endl;
}
int main( int argc, char** argv )
{
   // Select methods (don't look at this code - not of interest)
   TString methodList;
   for (int i=1; i<argc; i++) {
      TString regMethod(argv[i]);
      if(regMethod=="-b" || regMethod=="--batch") continue;
      if (!methodList.IsNull()) methodList += TString(",");
      methodList += regMethod;
   }
   TMVAMulticlassApplication(methodList);
   return 0;
}
