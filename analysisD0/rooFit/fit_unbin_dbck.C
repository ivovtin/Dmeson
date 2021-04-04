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
#include "RoodbckPdf.h"
R__LOAD_LIBRARY(RoodbckPdf_cxx.so)
R__LOAD_LIBRARY(load_read_write_C.so)

#define DBCK_PARS 16

using namespace RooFit;

void fit_unbin_dbck()
{
    //gROOT->SetStyle("Plain");
    //gROOT->ProcessLine(".L RoodbckPdf.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    TTree *tree = new TTree("tree", "tree");
    load_dat_file(tree,"dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat");
    //load_dat_file(tree,"dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat",0,8000);

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

    double par[DBCK_PARS];
    double epar[DBCK_PARS];
    read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/dbck_sim.par", DBCK_PARS, par, epar);
    //read_par("par/dbck_sim9.par", DBCK_PARS, par, epar);

    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], 5., 14.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], 5., 11.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[3], -5., 8.);
    RooRealVar de_mean("de_mean", "de_mean", par[4], -300., -150.);
    RooRealVar de_width("de_width", "de_width", par[5], 50., 110.);
    RooRealVar de_frac("de_frac", "de_frac", par[6], -10., 5.);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[7], 1800., 1900.);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[8], 20., 58.);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[9], 20., 50.);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[10], 130., 220.);
    RooRealVar de_width1("de_width1", "de_width1", par[11], 80., 140.);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[12], -0.5, 0.5);
    RooRealVar de_frac2("de_frac2", "de_frac2", par[13], -2.0, 8.);
    RooRealVar mbc_shift("mbc_shift", "mbc_shift", par[14], -1.0, 8.);
    RooRealVar mbc_sigma2("mbc_sigma2", "mbc_sigma2", par[15], -20., -6.);

    /*
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
    */
    //RooClassFactory::makePdf("RoodbckPdf","mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,de_frac2,mbc_shift,mbc_sigma2",0,"(p_mbc*p_de+fabs(de_frac)*p_mbc2*p_de2+fabs(de_frac1)*p_mbc3*p_de3 + fabs(de_frac2)*p_mbc4*p_de4)*fabs(1.+dpcurv*dp*dp/1000./1000.)");  .L RoodbckPdf.cxx+ 
    RoodbckPdf dbck_model("dbck_model","dbck_model",mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,dp,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,de_frac2,mbc_shift,mbc_sigma2);   
    
    dbck_model.Print();
       
    //Perform fit and save result
    //RooFitResult* r = dbck_model.fitTo(data,RooFit::Minimizer("Minuit2","migrad"),Save());
    //RooFitResult* r = dbck_model.fitTo(data,RooFit::Minimizer("Minuit","minimize"),Save());
    RooFitResult* r = dbck_model.fitTo(data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = dbck_model.fitTo(data,Save());
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
                
    par[0] = alpha_mbc.getVal();
    par[1] = alpha_de.getVal();
    par[2] = ebeam.getVal();
    par[3] = dpcurv.getVal();
    par[4] = de_mean.getVal();
    par[5] = de_width.getVal();
    par[6] = de_frac.getVal();
    par[7] = mbc_mean.getVal();
    par[8] = mbc_sigma0.getVal();
    par[9] = mbc_sigma1.getVal();
    par[10] = de_mean1.getVal();
    par[11] = de_width1.getVal();
    par[12] = de_frac1.getVal();
    par[13] = de_frac2.getVal();
    par[14] = mbc_shift.getVal();
    par[15] = mbc_sigma2.getVal();

    epar[0] = alpha_mbc.getError();
    epar[1] = alpha_de.getError();
    epar[2] = ebeam.getError();
    epar[3] = dpcurv.getError();
    epar[4] = de_mean.getError();
    epar[5] = de_width.getError();
    epar[6] = de_frac.getError();
    epar[7] = mbc_mean.getError();
    epar[8] = mbc_sigma0.getError();
    epar[9] = mbc_sigma1.getError();
    epar[10] = de_mean1.getError();
    epar[11] = de_width1.getError();
    epar[12] = de_frac1.getError();
    epar[13] = de_frac2.getError();
    epar[14] = mbc_shift.getError();
    epar[15] = mbc_sigma2.getError();
       
    write_par("par/dbck_sim.par", DBCK_PARS, par, epar);

    RooPlot* mbc_frame = mbc.frame();
    data.plotOn(mbc_frame);
    dbck_model.plotOn(mbc_frame);
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    
    RooPlot* de_frame = de.frame();
    data.plotOn(de_frame);
    dbck_model.plotOn(de_frame);
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    
    RooPlot* dp_frame = dp.frame();
    data.plotOn(dp_frame);
    dbck_model.plotOn(dp_frame);
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;
     
    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/store/users/ovtin/outDmeson/D0/results/fitsD0/";

    TCanvas *c = new TCanvas("dbck", "dbck", 1200, 400);
    c->Divide(3);
    c->cd(1);
    mbc_frame->Draw();
    c->cd(2);
    de_frame->Draw();
    c->cd(3);
    dp_frame->Draw();
    outName="dbck_RooFit";
    //c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

