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
#include "RooSigPdf.h"
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/RooSigPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/load_read_write_C.so)

#define SIG_PARS 30

using namespace RooFit;

void generate_fit_unbin_signal()
{
    // Create  component  pdfs in  Mbc, dE, dP
    // ----------------------------------------------------------------
    RooRealVar mbc("mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar de("de", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dp("dp", "#Delta P (MeV)", minP, maxP);

    double par[SIG_PARS];
    double epar[SIG_PARS];
    //read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/init/sig_def.par", SIG_PARS, par, epar);
    //read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/sig_sim_Minuit_migrad.par", SIG_PARS, par, epar);
    //read_par("/home/ovtin/development/Dmeson/analysisD0/fitD0/par/parold/sig.par", SIG_PARS, par, epar);
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/sig_sim.par", SIG_PARS, par, epar);

    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], par[0], par[0]);
    RooRealVar de_mean("de_mean", "de_mean", par[1], par[1], par[1]);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], par[2], par[2]);
    RooRealVar mbc_sigma0_l("mbc_sigma0_l", "mbc_sigma0_l", par[3], par[3], par[3]);
    RooRealVar mbc_sigma0_r("mbc_sigma0_r", "mbc_sigma0_r", par[4], par[4], par[4]);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], par[5], par[5]);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], par[7], par[7]);
    RooRealVar mbc_sigma2("mbc_sigma2", "mbc_sigma2", par[8], par[8], par[8]);
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[9], par[9], par[9]);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[10], par[10], par[10]);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[11], par[11], par[11]);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[12], par[12], par[12]);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[13], par[13], par[13]);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[14], par[14], par[14]);
    RooRealVar mbc_sigma4("mbc_sigma4", "mbc_sigma4", par[15], par[15], par[15]);

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[16], par[16], par[16]);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[17], par[17], par[17]);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[18],par[18],par[18]);
    RooRealVar dbck_dpcurv("dbck_dpcurv", "dbck_dpcurv", par[19], par[19], par[19]);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[20], par[20], par[20]);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[21], par[21], par[21]);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[22], par[22], par[22]);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[23], par[23], par[23]);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[24], par[24], par[24]);
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[25], par[25], par[25]);  
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[26], par[26], par[26]);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[27], par[27], par[27]);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[28], par[28], par[28]);
    RooRealVar dbck_de_frac2("dbck_de_frac2", "dbck_de_frac2", par[29], par[29], par[29]);
    RooRealVar dbck_mbc_shift("dbck_mbc_shift", "dbck_mbc_shift", 0., 0., 0.);
    RooRealVar dbck_mbc_sigma2("dbck_mbc_sigma2", "dbck_mbc_sigma2", par[25], par[25], par[25]);

    //RooClassFactory::makePdf("RooSigPdf","mbc,de,dp,mbc_mean,de_mean,mbcde_corr,mbc_sigma0_l,mbc_sigma0_r,de_sigma,ebeam,bck,mbc_sigma2,mbcw_shift,
    //mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpcurv,mbc_sigma4,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_dpcurv,dbck_de_mean,dbck_de_width,
    //dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_de_frac2,dbck_mbc_shift,dbck_mbc_sigma2",0,"dpsig*(desig*mbcsig + fabs(mbcw_frac)*desig2*mbcsig2)+fabs(bck)/1e5*pdf_dbck(mbc, de, dp, dbck_par)");  .L RooSigPdf.cxx+ 
    RooSigPdf sig_model("sig_model","sig_model",mbc,de,dp,mbc_mean,de_mean,mbcde_corr,mbc_sigma0_l,mbc_sigma0_r,de_sigma,ebeam,bck,mbc_sigma2,mbcw_shift,mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpcurv,mbc_sigma4,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_dpcurv,dbck_de_mean,dbck_de_width,dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_de_frac2,dbck_mbc_shift,dbck_mbc_sigma2);   
    
    sig_model.Print();

    //Generate an unbinned toy MC set
    RooDataSet* data = (RooDataSet*) sig_model.generate(RooArgSet(mbc,de,dp), 99116);
       
    RooAbsReal::defaultIntegratorConfig()->method2D().setLabel("RooMCIntegrator");

    mbc.setBins(100);
    RooPlot* mbc_frame = mbc.frame(Title(" "));
    mbc_frame->SetAxisRange(1800, 1900,"X");
    mbc.setRange("mbcsigRegion", 1800, 1900);
    data->plotOn(mbc_frame, MarkerColor(kBlue), LineColor(kBlue), Range("mbcsigRegion"));
    sig_model.plotOn(mbc_frame, LineColor(kRed), Range("mbcsigRegion"));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
 
    de.setBins(30);    
    RooPlot* de_frame = de.frame(Title(" "));
    de_frame->SetAxisRange(-300, 300,"X");
    de.setRange("desigRegion", -300, 300);
    data->plotOn(de_frame, MarkerColor(kBlue), LineColor(kBlue), Range("desigRegion"));
    sig_model.plotOn(de_frame, LineColor(kRed), Range("desigRegion"));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
 
    dp.setBins(80);   
    RooPlot* dp_frame = dp.frame(Title(" "));
    dp_frame->SetAxisRange(-600, 600,"X");
    dp.setRange("dPsigRegion", -600, 600);
    data->plotOn(dp_frame, MarkerColor(kBlue), LineColor(kBlue), Range("dPsigRegion"));
    sig_model.plotOn(dp_frame, LineColor(kRed), Range("dPsigRegion"));
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;
     
    TCanvas *c = new TCanvas("generate_signal", "generate_signal", 1000, 600);
    c->Divide(2,2);
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
    c->cd(4);
    TH1 *hmbcdp = data->createHistogram("dp,mbc", 200, 200);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    gStyle->SetOptStat(0);
    hmbcdp->SetAxisRange(1820, 1900,"Y");
    hmbcdp->SetAxisRange(-600, 600,"X");
    hmbcdp->GetXaxis()->SetTitleOffset(1.1);
    hmbcdp->GetYaxis()->SetTitleOffset(1.5);
    hmbcdp->SetTitle(" ");
    hmbcdp->GetYaxis()->SetTitle("M_{bc}, MeV");
    hmbcdp->GetXaxis()->SetTitle("#Delta P, MeV");
    hmbcdp->Draw(); 

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";
    outName="generate_signal_RooFit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

