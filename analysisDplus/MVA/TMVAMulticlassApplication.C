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
    float vrtntrk,vrtnip,vrtnbeam,charge1,charge2,charge3,nhitsdc,nhitst1,nhitst2,nhitst3,nhitsvd,nhitsvdt1,nhitsvdt2,nhitsvdt3,nhitsxyt1,nhitszt1,nhitsxyt2,
    nhitszt2,nhitsxyt3,nhitszt3,nvect1,nvecxyt1,nveczt1,nvect2,nvecxyt2,nveczt2,nvect3,nvecxyt3,nveczt3,ncomb,ncls1,ncls2,ncls3,ncls,nlkr,ncsi,munhits,mulayerhits1,
    mulayerhits2,mulayerhits3,Run,natccrosst1,atcCNTt1[20],natccrosst2,atcCNTt2[20],natccrosst3,atcCNTt3[20],aerogel_REGIONt1[20],aerogel_REGION0t1[20],aerogel_REGION5t1[20],aerogel_REGION20t1[20],single_aerogel_REGIONt1[20],single_aerogel_REGION0t1[20],
    single_aerogel_REGION5t1[20],single_aerogel_REGION20t1[20],aerogel_REGIONt2[20],aerogel_REGION0t2[20],aerogel_REGION5t2[20],aerogel_REGION20t2[20],single_aerogel_REGIONt2[20],
    single_aerogel_REGION0t2[20],single_aerogel_REGION5t2[20],single_aerogel_REGION20t2[20],aerogel_REGIONt3[20],aerogel_REGION0t3[20],aerogel_REGION5t3[20],aerogel_REGION20t3[20],single_aerogel_REGIONt3[20],
    single_aerogel_REGION0t3[20],single_aerogel_REGION5t3[20],single_aerogel_REGION20t3[20],wlshitt1[20],nearwlst1[20],wlshitt2[20],nearwlst2[20],wlshitt3[20],nearwlst3[20],
    kft1,kft2,kft3;
    float mbc,de,prec1,prec2,prec3,fchi2,Ebeam,rEv,P1,P2,P3,Pt1,Pt2,Pt3,thetat1,thetat2,thetat3,phit1,phit2,phit3,chi2t1,chi2t2,chi2t3,e1,e2,e3,rr1,rr2,rr3,Zip1,Zip2,Zip3,
    ecls1,ecls2,ecls3,tcls1,tcls2,tcls3,pcls1,pcls2,pcls3,emcenergy,lkrenergy,csienergy,timet1,betat1,lengtht1,timet2,betat2,lengtht2,timet3,betat3,lengtht3,
    atcNpet1[20],atcTotalNpet1,atcNpet2[20],atcTotalNpet2,atcNpet3[20],atcTotalNpet3,tlent1[20],tlent2[20],tlent3[20],
    dedxt1,dedxt2,dedxt3,probpit1,probpit2,probpit3,resdpit1,resdpit2,resdpit3,probKt1,probKt2,probKt3,resdKt1,resdKt2,resdKt3;

};
data10 Dmeson;

   //reader->AddVariable( "mbc", &Dmeson.mbc);
   //reader->AddVariable( "de",  &Dmeson.de);
  
   //reader->AddVariable( "P1",  &Dmeson.P1);
   //reader->AddVariable( "P2",  &Dmeson.P2);
   //reader->AddVariable( "P3",  &Dmeson.P3);

   reader->AddVariable( "Pt1",  &Dmeson.Pt1);
   reader->AddVariable( "Pt2",  &Dmeson.Pt2);
   reader->AddVariable( "Pt3",  &Dmeson.Pt3);
   
   reader->AddVariable( "fchi2",  &Dmeson.fchi2);
  
   reader->AddVariable( "vrtntrk",  &Dmeson.vrtntrk);
   reader->AddVariable( "vrtnip",  &Dmeson.vrtnip);

   reader->AddVariable( "nhitsvd",  &Dmeson.nhitsvd);
   reader->AddVariable( "nhitst1",  &Dmeson.nhitst1);
   reader->AddVariable( "nhitst2",  &Dmeson.nhitst2);
   reader->AddVariable( "nhitst3",  &Dmeson.nhitst3);
   reader->AddVariable( "nhitsxyt1",  &Dmeson.nhitsxyt1);
   reader->AddVariable( "nhitsxyt2",  &Dmeson.nhitsxyt2);
   reader->AddVariable( "nhitsxyt3",  &Dmeson.nhitsxyt3);
   reader->AddVariable( "nhitszt1",  &Dmeson.nhitszt1);
   reader->AddVariable( "nhitszt2",  &Dmeson.nhitszt2);
   reader->AddVariable( "nhitszt3",  &Dmeson.nhitszt3);
   
   reader->AddVariable( "nvect1",  &Dmeson.nvect1);
   reader->AddVariable( "nvect2",  &Dmeson.nvect2);
   reader->AddVariable( "nvect3",  &Dmeson.nvect3);
   reader->AddVariable( "nvecxyt1",  &Dmeson.nvecxyt1);
   reader->AddVariable( "nvecxyt2",  &Dmeson.nvecxyt2);
   reader->AddVariable( "nvecxyt3",  &Dmeson.nvecxyt3);
   reader->AddVariable( "nveczt1",  &Dmeson.nveczt1);
   reader->AddVariable( "nveczt2",  &Dmeson.nveczt2);
   reader->AddVariable( "nveczt3",  &Dmeson.nveczt3);

   reader->AddVariable( "ncls",  &Dmeson.ncls);
   reader->AddVariable( "nlkr",  &Dmeson.nlkr);
   reader->AddVariable( "ncsi",  &Dmeson.ncsi);
   reader->AddVariable( "ncls1",  &Dmeson.ncls1);
   reader->AddVariable( "ncls2",  &Dmeson.ncls2);
   reader->AddVariable( "ncls3",  &Dmeson.ncls3);
   reader->AddVariable( "emcenergy",  &Dmeson.emcenergy);
   reader->AddVariable( "lkrenergy",  &Dmeson.lkrenergy);
   reader->AddVariable( "csienergy",  &Dmeson.csienergy);
   reader->AddVariable( "e1",  &Dmeson.e1);
   reader->AddVariable( "e2",  &Dmeson.e2);
   reader->AddVariable( "e3",  &Dmeson.e3);

   reader->AddVariable( "munhits",  &Dmeson.munhits);
   reader->AddVariable( "mulayerhits1",  &Dmeson.mulayerhits1);
   reader->AddVariable( "mulayerhits2",  &Dmeson.mulayerhits2);
   reader->AddVariable( "mulayerhits3",  &Dmeson.mulayerhits3);
   reader->AddVariable( "thetat1",  &Dmeson.thetat1);
   reader->AddVariable( "thetat2",  &Dmeson.thetat2);
   reader->AddVariable( "thetat3",  &Dmeson.thetat3);
   reader->AddVariable( "phit1",  &Dmeson.phit1);
   reader->AddVariable( "phit2",  &Dmeson.phit2);
   reader->AddVariable( "phit3",  &Dmeson.phit3);
   reader->AddVariable( "chi2t1",  &Dmeson.chi2t1);
   reader->AddVariable( "chi2t2",  &Dmeson.chi2t2);
   reader->AddVariable( "chi2t3",  &Dmeson.chi2t3);
   reader->AddVariable( "rr1",  &Dmeson.rr1);
   reader->AddVariable( "rr2",  &Dmeson.rr2);
   reader->AddVariable( "rr3",  &Dmeson.rr3);
   reader->AddVariable( "Zip1",  &Dmeson.Zip1);
   reader->AddVariable( "Zip2",  &Dmeson.Zip2);
   reader->AddVariable( "Zip3",  &Dmeson.Zip3);

   //reader->AddVariable( "dedxt1",  &Dmeson.dedxt1);
   //reader->AddVariable( "dedxt2",  &Dmeson.dedxt2);
   //reader->AddVariable( "dedxt3",  &Dmeson.dedxt3);
   reader->AddVariable( "probKt1",  &Dmeson.probKt1);
   reader->AddVariable( "probpit2",  &Dmeson.probpit2);
   reader->AddVariable( "probpit3",  &Dmeson.probpit3);

   // book the MVA methods
   TString dir    = "/home/ovtin/development/Dmeson/analysisDplus/MVA/dataset/weights/";
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
   TString typeFile = "dbck_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0"; 
   //TString typeFile = "exp_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0_1.0140"; 

   //TString typeFile = "exp_all_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0"; 

   TFile *input(0);
   TString fname = "/home/ovtin/development/Dmeson/analysisDplus/MVA/infiles/" + typeFile + ".root";
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
   newfile = new TFile("/home/ovtin/development/Dmeson/analysisDplus/MVA/infiles/" + typeFile +"_new.root","recreate");
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
   TFile *target  = new TFile( "/home/ovtin/development/Dmeson/analysisDplus/MVA/TMVAMulticlassApp_"+ typeFile + ".root","RECREATE" );
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
