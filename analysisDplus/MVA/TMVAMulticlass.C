#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
#include "TFile.h"
#include "TTree.h"
#include "TString.h"
#include "TSystem.h"
#include "TROOT.h"
#include "TMVA/Tools.h"
#include "TMVA/Factory.h"
#include "TMVA/DataLoader.h"
#include "TMVA/TMVAMultiClassGui.h"
using namespace TMVA;
void TMVAMulticlass( TString myMethodList = "" )
{
   // This loads the library
   TMVA::Tools::Instance();
   // to get access to the GUI and all tmva macros
   //
   //     TString tmva_dir(TString(gRootDir) + "/tmva");
   //     if(gSystem->Getenv("TMVASYS"))
   //        tmva_dir = TString(gSystem->Getenv("TMVASYS"));
   //     gROOT->SetMacroPath(tmva_dir + "/test/:" + gROOT->GetMacroPath() );
   //     gROOT->ProcessLine(".L TMVAMultiClassGui.C");
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
   std::cout << "==> Start TMVAMulticlass" << std::endl;
   if (myMethodList != "") {
      for (std::map<std::string,int>::iterator it = Use.begin(); it != Use.end(); it++) it->second = 0;
      std::vector<TString> mlist = TMVA::gTools().SplitString( myMethodList, ',' );
      for (UInt_t i=0; i<mlist.size(); i++) {
         std::string regMethod(mlist[i]);
         if (Use.find(regMethod) == Use.end()) {
            std::cout << "Method \"" << regMethod << "\" not known in TMVA under this name. Choose among the following:" << std::endl;
            for (std::map<std::string,int>::iterator it = Use.begin(); it != Use.end(); it++) std::cout << it->first << " ";
            std::cout << std::endl;
            return;
         }
         Use[regMethod] = 1;
      }
   }


   // Create a new root output file.
   TString outfileName = "TMVAMulticlass.root";
   TFile* outputFile = TFile::Open( outfileName, "RECREATE" );
   TMVA::Factory *factory = new TMVA::Factory( "TMVAMulticlass", outputFile,
                                               "!V:!Silent:Color:DrawProgressBar:Transformations=I;D;P;G,D:AnalysisType=multiclass" );
   TMVA::DataLoader *dataloader=new TMVA::DataLoader("dataset");

   //dataloader->AddVariable( "mbc", "mbc", "", 'F' );
   //dataloader->AddVariable( "de",  "de", "", 'F' );

   //dataloader->AddVariable( "prec1",  "prec1", "", 'F' );
   //dataloader->AddVariable( "prec2",  "prec2", "", 'F' );
   //dataloader->AddVariable( "prec3",  "prec3", "", 'F' );

   //dataloader->AddVariable( "P1",  "P1", "", 'F' );
   //dataloader->AddVariable( "P2",  "P2", "", 'F' );
   //dataloader->AddVariable( "P3",  "P3", "", 'F' );

   dataloader->AddVariable( "Pt1",  "Pt1", "", 'F' );
   dataloader->AddVariable( "Pt2",  "Pt2", "", 'F' );
   dataloader->AddVariable( "Pt3",  "Pt3", "", 'F' );
   
   dataloader->AddVariable( "fchi2",  "fchi2", "", 'F' );
  
   dataloader->AddVariable( "vrtntrk",  "vrtntrk", "", 'I' );   
   dataloader->AddVariable( "vrtnip",  "vrtnip", "", 'I' );   

   dataloader->AddVariable( "nhitsvd",  "nhitsvd", "", 'I' );   
   dataloader->AddVariable( "nhitst1",  "nhitst1", "", 'I' );   
   dataloader->AddVariable( "nhitst2",  "nhitst2", "", 'I' );   
   dataloader->AddVariable( "nhitst3",  "nhitst3", "", 'I' ); 
   dataloader->AddVariable( "nhitsxyt1",  "nhitsxyt1", "", 'I' );
   dataloader->AddVariable( "nhitsxyt2",  "nhitsxyt2", "", 'I' );
   dataloader->AddVariable( "nhitsxyt3",  "nhitsxyt3", "", 'I' );
   dataloader->AddVariable( "nhitszt1",  "nhitszt1", "", 'I' );
   dataloader->AddVariable( "nhitszt2",  "nhitszt2", "", 'I' );
   dataloader->AddVariable( "nhitszt3",  "nhitszt3", "", 'I' );

   dataloader->AddVariable( "nvect1",  "nvect1", "", 'I' );
   dataloader->AddVariable( "nvect2",  "nvect2", "", 'I' );
   dataloader->AddVariable( "nvect3",  "nvect3", "", 'I' );
   dataloader->AddVariable( "nvecxyt1",  "nvecxyt1", "", 'I' );
   dataloader->AddVariable( "nvecxyt2",  "nvecxyt2", "", 'I' );
   dataloader->AddVariable( "nvecxyt3",  "nvecxyt3", "", 'I' );
   dataloader->AddVariable( "nveczt1",  "nveczt1", "", 'I' );
   dataloader->AddVariable( "nveczt2",  "nveczt2", "", 'I' );
   dataloader->AddVariable( "nveczt3",  "nveczt3", "", 'I' );

   dataloader->AddVariable( "ncls",  "ncls", "", 'I' );
   dataloader->AddVariable( "nlkr",  "nlkr", "", 'I' );
   dataloader->AddVariable( "ncsi",  "ncsi", "", 'I' );
   dataloader->AddVariable( "ncls1",  "ncls1", "", 'I' );
   dataloader->AddVariable( "ncls2",  "ncls2", "", 'I' );
   dataloader->AddVariable( "ncls3",  "ncls3", "", 'I' );
   dataloader->AddVariable( "emcenergy",  "emcenergy", "", 'F' );
   dataloader->AddVariable( "lkrenergy",  "lkrenergy", "", 'F' );
   dataloader->AddVariable( "csienergy",  "csienergy", "", 'F' );
   dataloader->AddVariable( "e1",  "e1", "", 'F' );
   dataloader->AddVariable( "e2",  "e2", "", 'F' );
   dataloader->AddVariable( "e3",  "e3", "", 'F' );

   dataloader->AddVariable( "munhits",  "munhits", "", 'I' );
   dataloader->AddVariable( "mulayerhits1",  "mulayerhits1", "", 'I' );
   dataloader->AddVariable( "mulayerhits2",  "mulayerhits2", "", 'I' );
   dataloader->AddVariable( "mulayerhits3",  "mulayerhits3", "", 'I' );

   dataloader->AddVariable( "thetat1",  "thetat1", "", 'F' );
   dataloader->AddVariable( "thetat2",  "thetat2", "", 'F' );
   dataloader->AddVariable( "thetat3",  "thetat3", "", 'F' );
   dataloader->AddVariable( "phit1",  "phit1", "", 'F' );
   dataloader->AddVariable( "phit2",  "phit2", "", 'F' );
   dataloader->AddVariable( "phit3",  "phit3", "", 'F' );
   dataloader->AddVariable( "chi2t1",  "chi2t1", "", 'F' );
   dataloader->AddVariable( "chi2t2",  "chi2t2", "", 'F' );
   dataloader->AddVariable( "chi2t3",  "chi2t3", "", 'F' );
   dataloader->AddVariable( "rr1",  "rr1", "", 'F' );
   dataloader->AddVariable( "rr2",  "rr2", "", 'F' );
   dataloader->AddVariable( "rr3",  "rr3", "", 'F' );
   dataloader->AddVariable( "Zip1",  "Zip1", "", 'F' );
   dataloader->AddVariable( "Zip2",  "Zip2", "", 'F' );
   dataloader->AddVariable( "Zip3",  "Zip3", "", 'F' );
    
   //dataloader->AddVariable( "dedxt1",  "dedxt1", "", 'F' );
   //dataloader->AddVariable( "dedxt2",  "dedxt2", "", 'F' );
   //dataloader->AddVariable( "dedxt3",  "dedxt3", "", 'F' );
   dataloader->AddVariable( "probKt1",  "probKt1", "", 'F' );
   dataloader->AddVariable( "probpit2",  "probpit2", "", 'F' );
   dataloader->AddVariable( "probpit3",  "probpit3", "", 'F' );
   
   dataloader->AddVariable( "wlshitt1",  "wlshitt1[5]", "", 'I' );
   dataloader->AddVariable( "wlshitt2",  "wlshitt2[5]", "", 'I' );
   dataloader->AddVariable( "wlshitt3",  "wlshitt3[5]", "", 'I' );
   dataloader->AddVariable( "atcNpet1",  "atcNpet1[5]", "", 'F' );
   dataloader->AddVariable( "atcNpet2",  "atcNpet2[5]", "", 'F' );
   dataloader->AddVariable( "atcNpet3",  "atcNpet3[5]", "", 'F' );

   TChain* signal = new TChain("signal","signal");
   //for(int i=1; i<=5; i++)   //Signal
   //{
   //     signal->Add(TString::Format("/home/ovtin/development/storekedr/outDmeson/simulation/outsimDplus/Signal/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simDplusmesonSignal_%d.root/et",i).Data());
   //}
   signal->Add("/home/ovtin/development/Dmeson/analysisDplus/MVA/infiles/signal.root/et");

   TChain* background1 = new TChain("background1 ","background1 ");
   //for(int i=1; i<=5; i++)   //uds BG
   //{
   //     background1->Add(TString::Format("/home/ovtin/development/storekedr/outDmeson/simulation/outsimDplus/Bkg_continium/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simDplusmeson_ee_to_qq_%d.root/et",i).Data());
   //}
   background1->Add("/home/ovtin/development/Dmeson/analysisDplus/MVA/infiles/uds.root/et");

   TChain* background2 = new TChain("background2 ","background2 ");
   //for(int i=1; i<=5; i++)   //dbck BG
   //{
   //     background2->Add(TString::Format("/home/ovtin/development/storekedr/outDmeson/simulation/outsimDplus/Bkg_eetoDD/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0/psi3770_to_simDplusmesonBkg_eetoDD_%d.root/et",i).Data());
   //}
   background2->Add("/home/ovtin/development/Dmeson/analysisDplus/MVA/infiles/dbck.root/et");

   std::cout << "==>  signal->GetEntries()=" <<signal->GetEntries()<< std::endl;
   std::cout << "==>  background1->GetEntries()=" <<background1->GetEntries()<< std::endl;
   std::cout << "==>  background2->GetEntries()=" <<background2->GetEntries()<< std::endl;

   signal->Print();
   background1->Print();
   background2->Print();

   gROOT->cd( outfileName+TString(":/") );
   dataloader->AddTree(signal,"Signal");
   dataloader->AddTree(background1,"bg1");
   dataloader->AddTree(background2,"bg2");

   TCut Cuts = "Dmeson.vrtntrk>=3 && Dmeson.de>=-300. && Dmeson.de<=300. && Dmeson.mbc>=1700. && Dmeson.mbc<=1900. && Dmeson.prec1>100. && Dmeson.prec1<2000. && Dmeson.prec2>100. && Dmeson.prec2<2000. && Dmeson.prec3>100. && Dmeson.prec3<2000. && Dmeson.chi2t1<55. && Dmeson.chi2t2<55. && Dmeson.chi2t3<55. && Dmeson.nhitst1>23. && Dmeson.nhitst2>23. && Dmeson.nhitst3>23. && Dmeson.nhitst1<=1000. && Dmeson.nhitst2<=1000. && Dmeson.nhitst3<=1000. && Dmeson.rr1<0.5 && Dmeson.rr2<0.5 && Dmeson.rr3<0.5 && abs(Dmeson.Zip1)<12. && abs(Dmeson.Zip2)<12. && abs(Dmeson.Zip3)<12. && Dmeson.ecls1<1000. && Dmeson.ecls2<1000. && Dmeson.ecls3<1000. && (Dmeson.mulayerhits2+Dmeson.mulayerhits3)<=1";
   //TCut Cuts = "Dmeson.vrtntrk>=3 && Dmeson.de>=-300. && Dmeson.de<=300. && Dmeson.mbc>=1700. && Dmeson.mbc<=1900. && Dmeson.prec1>100. && Dmeson.prec1<2000. && Dmeson.prec2>100. && Dmeson.prec2<2000. && Dmeson.prec3>100. && Dmeson.prec3<2000. && Dmeson.chi2t1<100. && Dmeson.chi2t2<100. && Dmeson.chi2t3<100. && Dmeson.nhitst1>23. && Dmeson.nhitst2>23. && Dmeson.nhitst3>23. && Dmeson.nhitst1<=1000. && Dmeson.nhitst2<=1000. && Dmeson.nhitst3<=1000. && Dmeson.rr1<1.0 && Dmeson.rr2<1.0 && Dmeson.rr3<1.0 && abs(Dmeson.Zip1)<12. && abs(Dmeson.Zip2)<12. && abs(Dmeson.Zip3)<12. && Dmeson.ecls1<1000. && Dmeson.ecls2<1000. && Dmeson.ecls3<1000. && (Dmeson.mulayerhits2+Dmeson.mulayerhits3)<=3";
 
   //dataloader->PrepareTrainingAndTestTree( "", "SplitMode=Random:NormMode=NumEvents:!V" );
   dataloader->PrepareTrainingAndTestTree( Cuts, "SplitMode=Random:NormMode=NumEvents:!V" );

   if (Use["BDTG"]) // gradient boosted decision trees
      //factory->BookMethod( dataloader,  TMVA::Types::kBDT, "BDTG", "!H:!V:NTrees=2000:BoostType=Grad:Shrinkage=0.10:UseBaggedBoost:BaggedSampleFraction=0.50:nCuts=20:MaxDepth=5");
      //factory->BookMethod( dataloader,  TMVA::Types::kBDT, "BDTG", "!H:!V:NTrees=1500:BoostType=Grad:Shrinkage=0.10:UseBaggedBoost:BaggedSampleFraction=0.50:nCuts=20:MaxDepth=3");
      factory->BookMethod( dataloader,  TMVA::Types::kBDT, "BDTG", "!H:!V:NTrees=1000:BoostType=Grad:Shrinkage=0.10:UseBaggedBoost:BaggedSampleFraction=0.50:nCuts=20:MaxDepth=2"); //v1 - with mbc, de
   if (Use["MLP"]) // neural network
      factory->BookMethod( dataloader,  TMVA::Types::kMLP, "MLP", "!H:!V:NeuronType=tanh:NCycles=1000:HiddenLayers=N+5,5:TestRate=5:EstimatorType=MSE");
   if (Use["FDA_GA"]) // functional discriminant with GA minimizer
      factory->BookMethod( dataloader,  TMVA::Types::kFDA, "FDA_GA", "H:!V:Formula=(0)+(1)*x0+(2)*x1+(3)*x2+(4)*x3:ParRanges=(-1,1);(-10,10);(-10,10);(-10,10);(-10,10):FitMethod=GA:PopSize=300:Cycles=3:Steps=20:Trim=True:SaveBestGen=1" );
   if (Use["PDEFoam"]) // PDE-Foam approach
      factory->BookMethod( dataloader,  TMVA::Types::kPDEFoam, "PDEFoam", "!H:!V:TailCut=0.001:VolFrac=0.0666:nActiveCells=500:nSampl=2000:nBin=5:Nmin=100:Kernel=None:Compress=T" );
   if (Use["DNN_CPU"]) {
      TString layoutString("Layout=TANH|100,TANH|50,TANH|10,LINEAR");
      TString training0("LearningRate=1e-1, Momentum=0.5, Repetitions=1, ConvergenceSteps=10,"
                        " BatchSize=256, TestRepetitions=10, Multithreading=True");
      TString training1("LearningRate=1e-2, Momentum=0.0, Repetitions=1, ConvergenceSteps=10,"
                        " BatchSize=256, TestRepetitions=7, Multithreading=True");
      TString trainingStrategyString("TrainingStrategy=");
      trainingStrategyString += training0 + "|" + training1;
      TString nnOptions("!H:V:ErrorStrategy=CROSSENTROPY:VarTransform=N:"
                        "WeightInitialization=XAVIERUNIFORM:Architecture=CPU");
      nnOptions.Append(":");
      nnOptions.Append(layoutString);
      nnOptions.Append(":");
      nnOptions.Append(trainingStrategyString);
      factory->BookMethod(dataloader, TMVA::Types::kDNN, "DNN_CPU", nnOptions);
   }
   // Train MVAs using the set of training events
   factory->TrainAllMethods();
   // Evaluate all MVAs using the set of test events
   factory->TestAllMethods();
   // Evaluate and compare performance of all configured MVAs
   factory->EvaluateAllMethods();
   // --------------------------------------------------------------
   // Save the output
   outputFile->Close();
   std::cout << "==> Wrote root file: " << outputFile->GetName() << std::endl;
   std::cout << "==> TMVAMulticlass is done!" << std::endl;
   delete factory;
   delete dataloader;
   // Launch the GUI for the root macros
   if (!gROOT->IsBatch()) TMVAMultiClassGui( outfileName );
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
   TMVAMulticlass(methodList);
   return 0;
}
