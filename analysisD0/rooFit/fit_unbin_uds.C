#include <stdio.h>
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
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/RooudsPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/load_read_write_C.so)

#define BCK_PARS 4

using namespace RooFit;

void fit_unbin_uds()
{
    //gROOT->SetStyle("Plain");
    //gROOT->ProcessLine(".L RooudsPdf.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    TTree *tree = new TTree("tree", "tree");
    load_dat_file(tree,"/home/ovtin/development/Dmeson/analysisD0/rooFit/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat");

    // Create  component  pdfs in  Mbc, dE, dP
    // ----------------------------------------------------------------
    RooRealVar mbc("mbc", "M_{bc} (MeV)", 1700, 1900);
    mbc.setBins(50);
    RooRealVar de("de", "#Delta E (MeV)", -300, 300);
    de.setBins(30);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dp("dp", "#Delta P (MeV)", minP, maxP);
    dp.setBins(200);

    // Construct unbinned dataset importing tree branches
    RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));

    int ndata = data.sumEntries();
    cout<<"ndata="<<ndata<<endl;

    double par[BCK_PARS];
    double epar[BCK_PARS];
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/init/bck_uds.par", BCK_PARS, par, epar);

    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], -10., 50.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], -5., 5.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[3], -5., 10.);
    //RooClassFactory::makePdf("RooudsPdf","mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp",0,"exp(alpha_mbc*(mbc*mbc/ebeam/ebeam-1.)-alpha_de*de/1000.)*(1.+dpcurv*dp*dp/1000./1000.)");  .L RooudsPdf.cxx+ 
    RooudsPdf uds_model("uds_model","uds_model",mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp);   
    
    uds_model.Print();

    //Perform fit and save result
    RooFitResult* r = uds_model.fitTo(data,RooFit::Minimizer("Minuit2","migrad"),Save());
    //Print fit results 
    // ---------------------------------
    // Verbose printing: Basic info, values of constant parameters, initial and
    // final values of floating parameters, global correlations
    r->Print("v");    
    //Access basic information
    cout << "EDM = " << r->edm() << endl ;
    cout << "-log(L) at minimum = " << r->minNll() << endl ; 
    //Access list of final fit parameter values
    cout << "final value of floating parameters" << endl ;
    r->floatParsFinal().Print("s") ;
    //Extract covariance and correlation matrix as TMatrixDSym
    const TMatrixDSym& cor = r->correlationMatrix() ;
    const TMatrixDSym& cov = r->covarianceMatrix() ;
    //Print correlation, covariance matrix
    cout << "correlation matrix" << endl ;
    cor.Print() ;
    cout << "covariance matrix" << endl ;
    cov.Print() ;
        
    par[0] = alpha_mbc.getVal();
    par[1] = alpha_de.getVal();
    par[2] = ebeam.getVal();
    par[3] = dpcurv.getVal();

    epar[0] = alpha_mbc.getError();
    epar[1] = alpha_de.getError();
    epar[2] = ebeam.getError();
    epar[3] = dpcurv.getError();
       
    write_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/bck_uds.par", BCK_PARS, par, epar);

    RooAbsReal::defaultIntegratorConfig()->method2D().setLabel("RooMCIntegrator");

    RooPlot* mbc_frame = mbc.frame(Title(" "));
    data.plotOn(mbc_frame, MarkerColor(kBlue), LineColor(kBlue));
    uds_model.plotOn(mbc_frame, LineColor(kRed));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    
    RooPlot* de_frame = de.frame(Title(" "));
    data.plotOn(de_frame, MarkerColor(kBlue), LineColor(kBlue));
    uds_model.plotOn(de_frame, LineColor(kRed));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    
    RooPlot* dp_frame = dp.frame(Title(" "));
    data.plotOn(dp_frame, MarkerColor(kBlue), LineColor(kBlue));
    uds_model.plotOn(dp_frame, LineColor(kRed));
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;
     
    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";

    TCanvas *c = new TCanvas("uds", "uds", 1400, 400);
    c->Divide(3);
    c->cd(1);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame->GetXaxis()->SetTitleOffset(1.2);
    mbc_frame->GetYaxis()->SetTitleOffset(1.6);
    mbc_frame->Draw();
    c->cd(2);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame->GetXaxis()->SetTitleOffset(1.2);
    de_frame->GetYaxis()->SetTitleOffset(1.6);
    de_frame->Draw();
    c->cd(3);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    dp_frame->GetXaxis()->SetTitleOffset(1.2);
    dp_frame->GetYaxis()->SetTitleOffset(1.6); 
    dp_frame->Draw();
    outName="uds_RooFit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

