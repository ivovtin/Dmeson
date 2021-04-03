#include "TMath.h"
#include "TFormula.h"
#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooGaussian.h"
#include "RooFitResult.h"
#include "TCanvas.h"
#include "RooPlot.h"
#include "TH2.h"
#include "TAxis.h"
#include "TStyle.h"
#include "RooudsPdf.h"
R__LOAD_LIBRARY(RooudsPdf_cxx.so)

using namespace RooFit;

void fit_unbin_uds()
{
    //gROOT->SetStyle("Plain");

    gROOT->ProcessLine(".L RooudsPdf.cxx+");
    
    TTree *tree = new TTree("tree", "tree");
    Double_t* br1 = new Double_t ;
    Double_t* br2 = new Double_t ;
    Double_t* br3 = new Double_t ;
    tree->Branch("mbc", br1, "mbc/D");
    tree->Branch("de", br2, "de/D");
    tree->Branch("dp", br3, "dp/D");

    FILE* file = fopen("kp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat","r");
    int i=0;
    while (!feof(file)) {
	double fmbc,fde,fdp;
	if (fscanf(file,"%lf %lf %lf", &fmbc,&fde,&fdp) == 3) {
	    *br1 = fmbc;
	    *br2 = fde;
            *br3 = fdp;
	    tree->Fill();
	    i++;
	}
	//if (i >= 4000) break;
    }
    fclose(file);

    // Create  component  pdfs in  Mbc and dE
    // ----------------------------------------------------------------
    RooRealVar mbc("mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar de("de", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dp("dp", "#Delta P (MeV)", minP, maxP);

    // Construct unbinned dataset importing tree branches
    RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    //RooDataSet data("data", "data", RooArgSet(mbc, de), Import(*tree));

    int ndata = data.sumEntries();
    cout<<"ndata="<<ndata<<endl;

    double par[4];
    par[0] = 7.745104;     //alpha_mbc
    par[1] = 1.155407;  //alpha_de
    par[2] = 1888.750;  //ebeam
    par[3] = 3.240319;  //dpcurv

    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], -10., 50.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], -5., 5.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[3], -5., 10.);
    //RooClassFactory::makePdf("RooudsPdf","mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp",0,"exp(alpha_mbc*(mbc*mbc/ebeam/ebeam-1.)-alpha_de*de/1000.)*(1.+dpcurv*dp*dp/1000./1000.)");  .L RooudsPdf.cxx+ 
    RooudsPdf uds_model("uds_model","uds_model",mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp);   
    
    uds_model.Print();

    // --- Perform fit of composite PDF to data ---
    uds_model.fitTo(data);
    //uds_model.fitTo(data,RooFit::Minimizer("Minuit2","minimize"));

    RooPlot* mbc_frame = mbc.frame();
    data.plotOn(mbc_frame);
    uds_model.plotOn(mbc_frame);
    
    RooPlot* de_frame = de.frame();
    data.plotOn(de_frame);
    uds_model.plotOn(de_frame);
    
    RooPlot* dp_frame = dp.frame();
    data.plotOn(dp_frame);
    uds_model.plotOn(dp_frame);
     
    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/store/users/ovtin/outDmeson/D0/results/fitsD0/";

    TCanvas *c = new TCanvas("Signal", "Signal", 1200, 400);
    c->Divide(3);
    c->cd(1);
    mbc_frame->Draw();
    c->cd(2);
    de_frame->Draw();
    c->cd(3);
    dp_frame->Draw();
    outName="uds_RooFit";
    //c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

