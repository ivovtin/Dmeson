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
#include "RooProdPdf.h"
#include "TAxis.h"
#include "RoodbckPdf.h"
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/RoodbckPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/load_read_write_C.so)

#define DBCK_PARS 16

using namespace RooFit;

void generate_fit_unbin_dbck()
{
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

    double par[DBCK_PARS];
    double epar[DBCK_PARS];
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/init/dbck_sim.par", DBCK_PARS, par, epar);
    //read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/dbck_sim.par", DBCK_PARS, par, epar);

    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], par[0], par[0]);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], par[1], par[1]);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[3], par[3], par[3]);
    RooRealVar de_mean("de_mean", "de_mean", par[4], par[4], par[4]);
    RooRealVar de_width("de_width", "de_width", par[5], par[5], par[5]);
    RooRealVar de_frac("de_frac", "de_frac", par[6], par[6], par[6]);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[7], par[7], par[7]);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[8], par[8], par[8]);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[9], par[9], par[9]);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[10], par[10], par[10]);
    RooRealVar de_width1("de_width1", "de_width1", par[11], par[11], par[11]);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[12], par[12], par[12]);
    RooRealVar de_frac2("de_frac2", "de_frac2", par[13], par[13], par[13]);
    RooRealVar mbc_shift("mbc_shift", "mbc_shift", par[14], par[14], par[14]);
    RooRealVar mbc_sigma2("mbc_sigma2", "mbc_sigma2", par[15], par[15], par[15]);

    
    //RooClassFactory::makePdf("RoodbckPdf","mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,de_frac2,mbc_shift,mbc_sigma2",0,"(p_mbc*p_de+fabs(de_frac)*p_mbc2*p_de2+fabs(de_frac1)*p_mbc3*p_de3 + fabs(de_frac2)*p_mbc4*p_de4)*fabs(1.+dpcurv*dp*dp/1000./1000.)");  .L RoodbckPdf.cxx+ 
    RoodbckPdf dbck_model("dbck_model","dbck_model",mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,de_frac2,mbc_shift,mbc_sigma2);   
 
    dbck_model.Print();

    //Generate an unbinned toy MC set
    RooDataSet *data = dbck_model.generate(RooArgSet(mbc,de,dp),20000);    
               
    RooAbsReal::defaultIntegratorConfig()->method2D().setLabel("RooMCIntegrator");
 
    RooPlot *mbc_frame = mbc.frame(Title(" "));
    data->plotOn(mbc_frame, MarkerColor(kBlue), LineColor(kBlue));
    dbck_model.plotOn(mbc_frame, LineColor(kRed));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;    

    RooPlot *de_frame = de.frame(Title(" "));
    data->plotOn(de_frame, MarkerColor(kBlue), LineColor(kBlue));
    dbck_model.plotOn(de_frame, LineColor(kRed));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    
    RooPlot *dp_frame = dp.frame(Title(" "));
    data->plotOn(dp_frame, MarkerColor(kBlue), LineColor(kBlue));
    dbck_model.plotOn(dp_frame, LineColor(kRed));
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;
    
    TCanvas* c = new TCanvas("generate_dbck", "generate_dbck", 1400, 400);
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

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString KEDR = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";
    TString outName="generate_dbck_RooFit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

