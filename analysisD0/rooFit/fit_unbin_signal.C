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

void fit_unbin_signal()
{
    //gROOT->SetStyle("Plain");
    //gROOT->ProcessLine(".L RoodSigPdf.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    TTree *tree = new TTree("tree", "tree");
    //load_dat_file(tree,"/home/ovtin/development/Dmeson/analysisD0/rooFit/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat");
    load_dat_file(tree,"/home/ovtin/development/Dmeson/analysisD0/rooFit/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat",0,8000);

    // Create  component  pdfs in  Mbc, dE, dP
    // ----------------------------------------------------------------
    RooRealVar mbc("mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar de("de", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dp("dp", "#Delta P (MeV)", minP, maxP);

    // Construct unbinned dataset importing tree branches
    RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));

    int ndata = data.sumEntries();
    cout<<"ndata="<<ndata<<endl;

    double par[SIG_PARS];
    double epar[SIG_PARS];
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_def.par", SIG_PARS, par, epar);

    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1800., 1900.);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -300., -150.);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -300., -150.);
    RooRealVar mbc_sigma0_l("mbc_sigma0_l", "mbc_sigma0_l", par[3], -300., -150.);
    RooRealVar mbc_sigma0_r("mbc_sigma0_r", "mbc_sigma0_r", par[4], -300., -150.);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], -300., -150.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], -300., -150.);
    RooRealVar mbc_sigma2("mbc_sigma2", "mbc_sigma2", par[8], -300., -150.);
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[9], -300., -150.);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[10], -300., -150.);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[11], -300., -150.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[12], -300., -150.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[13], -300., -150.);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[14], -300., -150.);
    RooRealVar mbc_sigma4("mbc_sigma4", "mbc_sigma4", par[15], -300., -150.);

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[16], 5., 14.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[17], 5., 11.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[18],par[18],par[18]);
    RooRealVar dbck_dpcurv("dbck_dpcurv", "dbck_dpcurv", par[19], -5., 8.);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[20], -300., -150.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[21], 50., 110.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[22], -10., 5.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[23], 1800., 1900.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[24], 20., 58.);
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[25], 20., 50.);  
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[26], 130., 220.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[27], 80., 140.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[28], -0.5, 0.5);
    RooRealVar dbck_de_frac2("dbck_de_frac2", "dbck_de_frac2", par[29], -2.0, 8.);
    RooRealVar dbck_mbc_shift("dbck_mbc_shift", "dbck_mbc_shift", 0., -1.0, 8.);
    RooRealVar dbck_mbc_sigma2("dbck_mbc_sigma2", "dbck_mbc_sigma2", par[25], -20., -6.);

    //RooClassFactory::makePdf("RooSigPdf","mbc,de,dp,mbc_mean,de_mean,mbcde_corr,mbc_sigma0_l,mbc_sigma0_r,de_sigma,ebeam,bck,mbc_sigma2,mbcw_shift,
    //mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpcurv,mbc_sigma4,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_dpcurv,dbck_de_mean,dbck_de_width,
    //dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_de_frac2,dbck_mbc_shift,dbck_mbc_sigma2",0,"dpsig*(desig*mbcsig + fabs(mbcw_frac)*desig2*mbcsig2)+fabs(bck)/1e5*pdf_dbck(mbc, de, dp, dbck_par)");  .L RooSigPdf.cxx+ 
    RooSigPdf sig_model("sig_model","sig_model",mbc,de,dp,mbc_mean,de_mean,mbcde_corr,mbc_sigma0_l,mbc_sigma0_r,de_sigma,ebeam,bck,mbc_sigma2,mbcw_shift,mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpcurv,mbc_sigma4,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_dpcurv,dbck_de_mean,dbck_de_width,dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_de_frac2,dbck_mbc_shift,dbck_mbc_sigma2);   
    
    sig_model.Print();
       
    //Perform fit and save result
    //RooFitResult* r = sig_model.fitTo(data,RooFit::Minimizer("Minuit2","migrad"),Save());
    //RooFitResult* r = sig_model.fitTo(data,RooFit::Minimizer("Minuit","minimize"),Save());
    RooFitResult* r = sig_model.fitTo(data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = sig_model.fitTo(data,Save());
    //Print fit results 
    // ---------------------------------
    // Verbose printing: Basic info, values of constant parameters, initial and
    // final values of floating parameters, global correlations
    r->Print("v");    
    //Access basic information
    cout << "EDM = " << r->edm() << endl;
    cout << "-log(L) at minimum = " << r->minNll()<<endl; 
    //Access list of final fit parameter values
    cout << "final value of floating parameters"<<endl;
    r->floatParsFinal().Print("s");
    //Extract covariance and correlation matrix as TMatrixDSym
    const TMatrixDSym& cor = r->correlationMatrix();
    const TMatrixDSym& cov = r->covarianceMatrix();
    //Print correlation, covariance matrix
    cout<<"correlation matrix"<<endl;
    cor.Print() ;
    cout<<"covariance matrix"<<endl;
    cov.Print();
               
    par[0] = mbc_mean.getVal();
    par[1] = de_mean.getVal();
    par[2] = mbcde_corr.getVal();
    par[3] = mbc_sigma0_l.getVal();
    par[4] = mbc_sigma0_r.getVal();
    par[5] = de_sigma.getVal();
    par[6] = ebeam.getVal();
    par[7] = bck.getVal();
    par[8] = mbc_sigma2.getVal();
    par[9] = mbcw_shift.getVal();
    par[10] = mbcw_frac.getVal();
    par[11] = mbcw_sigma.getVal();
    par[12] = dew_sigma.getVal();
    par[13] = mbcdew_corr.getVal();
    par[14] = dpcurv.getVal();
    par[15] = mbc_sigma4.getVal();
    par[16] = dbck_alpha_mbc.getVal();
    par[17] = dbck_alpha_de.getVal();
    par[18] = dbck_ebeam.getVal();
    par[19] = dbck_dpcurv.getVal();
    par[20] = dbck_de_mean.getVal();
    par[21] = dbck_de_width.getVal();
    par[22] = dbck_de_frac.getVal();
    par[23] = dbck_mbc_mean.getVal();
    par[24] = dbck_mbc_sigma0.getVal();
    par[25] = dbck_mbc_sigma1.getVal();
    par[26] = dbck_de_mean1.getVal();
    par[27] = dbck_de_width1.getVal();
    par[28] = dbck_de_frac1.getVal();
    par[29] = dbck_de_frac2.getVal();

    epar[0] = mbc_mean.getError();
    epar[1] = de_mean.getError();
    epar[2] = mbcde_corr.getError();
    epar[3] = mbc_sigma0_l.getError();
    epar[4] = mbc_sigma0_r.getError();
    epar[5] = de_sigma.getError();
    epar[6] = ebeam.getError();
    epar[7] = bck.getError();
    epar[8] = mbc_sigma2.getError();
    epar[9] = mbcw_shift.getError();
    epar[10] = mbcw_frac.getError();
    epar[11] = mbcw_sigma.getError();
    epar[12] = dew_sigma.getError();
    epar[13] = mbcdew_corr.getError();
    epar[14] = dpcurv.getError();
    epar[15] = mbc_sigma4.getError(); 
    epar[16] = dbck_alpha_mbc.getError();
    epar[17] = dbck_alpha_de.getError();
    epar[18] = dbck_ebeam.getError();
    epar[19] = dbck_dpcurv.getError();
    epar[20] = dbck_de_mean.getError();
    epar[21] = dbck_de_width.getError();
    epar[22] = dbck_de_frac.getError();
    epar[23] = dbck_mbc_mean.getError();
    epar[24] = dbck_mbc_sigma0.getError();
    epar[25] = dbck_mbc_sigma1.getError();
    epar[26] = dbck_de_mean1.getError();
    epar[27] = dbck_de_width1.getError();
    epar[28] = dbck_de_frac1.getError();
    epar[29] = dbck_de_frac2.getError();
       
    write_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/sig_sim.par", SIG_PARS, par, epar);

    RooPlot* mbc_frame = mbc.frame();
    data.plotOn(mbc_frame);
    sig_model.plotOn(mbc_frame);
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    
    RooPlot* de_frame = de.frame();
    data.plotOn(de_frame);
    sig_model.plotOn(de_frame);
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    
    RooPlot* dp_frame = dp.frame();
    data.plotOn(dp_frame);
    sig_model.plotOn(dp_frame);
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;
     
    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";

    TCanvas *c = new TCanvas("signal", "signal", 1200, 400);
    c->Divide(3);
    c->cd(1);
    mbc_frame->Draw();
    c->cd(2);
    de_frame->Draw();
    c->cd(3);
    dp_frame->Draw();
    outName="signal_RooFit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}
