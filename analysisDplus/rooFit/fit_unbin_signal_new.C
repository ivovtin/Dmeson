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
#include "RooSigPdfNew.h"
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/RooSigPdfNew_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/load_read_write_C.so)

#define SIG_PARS 27

using namespace RooFit;

void fit_unbin_signal_new()
{
    //gROOT->ProcessLine(".L RooSigPdfNew.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    //atc+dedx+tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //syst isr syst
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_plus_sigma";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_plus_sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_minus_sigma";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_minus_sigma_ATC.dat";
    
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_rnd";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_rnd_ATC.dat";

    //syst ionization_losses syst
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_plus1sigma";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_plus1sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_minus1sigma";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_minus1sigma_ATC.dat";

    //syst_momres
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A5.1_Z0.0";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A6.9_Z0.0";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";

    //Syst Sig shape
    TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_Syst_SigShape";
    TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //atc+dedx
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_dedx_ATC.dat";
 
    //atc+tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_ATC.dat";
 
    //tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_ATC.dat";         

    TString dirPath = "/home/ovtin/development/Dmeson/analysisDplus/rooFit/";
    TString dataPath = dirPath + "dat/" + TypeDir +"/" + dataFile;

    TTree *tree = new TTree("tree", "tree");
    load_dat_file(tree, dataPath);

    // Create  component  pdfs in  Mbc, dE, dP
    // ----------------------------------------------------------------
    RooRealVar mbc("mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar de("de", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dp("dp", "#Delta P (MeV)", minP, maxP);

    double par[SIG_PARS];
    double epar[SIG_PARS];
    //read_par(dirPath + "par/init/sigNew.par", SIG_PARS, par, epar);
    read_par(dirPath + "par/init/sig_syst.par", SIG_PARS, par, epar);
    //atc_dedx or atc_tof
    //read_par(dirPath + "par/init/sig_atc_dedx.par", SIG_PARS, par, epar);

    
    /*
    //atc+tof+dedx
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1869.2, 1870.0);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -1.0, 1.0);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -0.01, 0.01);
    RooRealVar mbc_sigma_l("mbc_sigma_l", "mbc_sigma_l", par[3], 2.0, 3.1);
    RooRealVar mbc_sigma_r("mbc_sigma_r", "mbc_sigma_r", par[4], 2.0, 3.1);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], 30., 45.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], 0., 0.1 );
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[8], 0., 1.);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[9], 0., 1.);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[10], 3., 10.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[11], 60., 90.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[12], -0.05, 0.01);
    RooRealVar dpsig("dpsig", "dpsig", par[13], 0., 1.0);   

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[14], 50., 80.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[15], -6., 0.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[16], par[16], par[16]);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[17], -11., 0.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[18], 100., 220.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[19], -700., -100.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[20], 1500., 3500.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[21], 100., 350.);
    
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[22], 300., 800.);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[23], -350., -100.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[24], 0., 130.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[25], 0., 8.);
    RooRealVar dbck_mbc_mean1("dbck_mbc_mean1", "dbck_mbc_mean1", par[26], 0., 800.);
    */

    /*
    //atc+tof+dedx syst isr rnd
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1869.2, 1870.30);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -5.0, 5.0);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -0.01, 0.01);
    RooRealVar mbc_sigma_l("mbc_sigma_l", "mbc_sigma_l", par[3], 2.0, 3.2);
    RooRealVar mbc_sigma_r("mbc_sigma_r", "mbc_sigma_r", par[4], 2.0, 3.2);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], 30., 45.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], 0., 0.1 );
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[8], 0., 5.);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[9], 0., 1.);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[10], 3., 10.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[11], 60., 90.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[12], -0.05, 0.01);
    RooRealVar dpsig("dpsig", "dpsig", par[13], 0., 1.0);   

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[14], 50., 100.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[15], -6., 0.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[16], par[16], par[16]);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[17], -15., 0.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[18], 100., 220.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[19], -700., -100.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[20], 1500., 3500.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[21], 100., 350.);
    
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[22], 300., 800.);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[23], -350., -100.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[24], 0., 200.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[25], 0., 9.);
    RooRealVar dbck_mbc_mean1("dbck_mbc_mean1", "dbck_mbc_mean1", par[26], 0., 800.);
    */ 

    
    //atc+tof+dedx  - Syst Sig Shape
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1869.2, 1870.30);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -5.0, 5.0);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -0.01, 0.01);
    RooRealVar mbc_sigma_l("mbc_sigma_l", "mbc_sigma_l", par[3], 2.3, 5.00);
    RooRealVar mbc_sigma_r("mbc_sigma_r", "mbc_sigma_r", par[4], 2.3, 5.00);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], 30., 60.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], 0., 0.1 );
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[8], 0., 1.);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[9], par[9], par[9]);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[10], 3., 10.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[11], 60., 90.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[12], -0.05, 0.01);
    RooRealVar dpsig("dpsig", "dpsig", par[13], 0., 1.0);   

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[14], 20., 80.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[15], -6., 0.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[16], par[16], par[16]);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[17], -15., 0.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[18], 100., 220.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[19], -50000., -100.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[20], 1500., 3500.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[21], 0., 350.);
    
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[22], 0., 2000.);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[23], -350., 0.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[24], 0., 400.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[25], 0., 9.);
    RooRealVar dbck_mbc_mean1("dbck_mbc_mean1", "dbck_mbc_mean1", par[26], 0., 20000.);
      

    /*
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1869.0, 1870.5);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -1.5, 1.5);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -0.01, 0.01);
    RooRealVar mbc_sigma_l("mbc_sigma_l", "mbc_sigma_l", par[3], 2.0, 3.3);
    RooRealVar mbc_sigma_r("mbc_sigma_r", "mbc_sigma_r", par[4], 2.0, 3.3);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], 20., 50.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], 0., 0.1 );
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[8], 0., 0.8);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[9], 0., 0.8);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[10], 4., 10.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[11], 60., 90.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[12], -0.01, 0.0);
    RooRealVar dpsig("dpsig", "dpsig", par[13], 0., 0.8);   

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[14], 20., 60.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[15], -7., 0.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[16], par[16], par[16]);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[17], -45., -10.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[18], 80., 190.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[19], -1800., -1000.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[20], 1500., 3000.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[21], 200., 320.);
    
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[22], 400., 800.);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[23], -350., -100.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[24], 60., 130.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[25], 0., 10.);
    RooRealVar dbck_mbc_mean1("dbck_mbc_mean1", "dbck_mbc_mean1", par[26], 400., 900.);
    */ 
 
    //RooClassFactory::makePdf("RooSigPdfNew","mbc,de,mbc_mean,de_mean,mbcde_corr,mbc_sigma0_l,mbc_sigma0_r,de_sigma,ebeam,bck,mbcw_shift,mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpsig,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_de_mean,dbck_de_width,dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_mbc_mean1",0,"fabs(mbcw_frac)+mbc+de");  
   
    //.L RooSigPdfNew.cxx+ 
    
    RooSigPdfNew sig_model("sig_model","sig_model",mbc,de,mbc_mean,de_mean,mbcde_corr,mbc_sigma_l,mbc_sigma_r,de_sigma,ebeam,bck,mbcw_shift,mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpsig,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_de_mean,dbck_de_width,dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_mbc_mean1);
    
    sig_model.Print();

    // Construct unbinned dataset importing tree branches
    //RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    //RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de), Import(*tree));
    int ndata = data->sumEntries();
    cout<<"ndata="<<ndata<<endl;
       
    //Perform fit and save result
    //RooFitResult* r = sig_model.fitTo(data,RooFit::Minimizer("Minuit2","migrad"),Save());
    RooFitResult* r = sig_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = sig_model.fitTo(*data,RooFit::Minimizer("Minuit","minimize"),Save());
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
    /*
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
    */               
    par[0] = mbc_mean.getVal();
    par[1] = de_mean.getVal();
    par[2] = mbcde_corr.getVal();
    par[3] = mbc_sigma_l.getVal();
    par[4] = mbc_sigma_r.getVal();
    par[5] = de_sigma.getVal();
    par[6] = ebeam.getVal();
    par[7] = bck.getVal();
    par[8] = mbcw_shift.getVal();
    par[9] = mbcw_frac.getVal();
    par[10] = mbcw_sigma.getVal();
    par[11] = dew_sigma.getVal();
    par[12] = mbcdew_corr.getVal();
    par[13] = dpsig.getVal();
    par[14] = dbck_alpha_mbc.getVal();
    par[15] = dbck_alpha_de.getVal();
    par[16] = dbck_ebeam.getVal();
    par[17] = dbck_de_mean.getVal();
    par[18] = dbck_de_width.getVal();
    par[19] = dbck_de_frac.getVal();
    par[20] = dbck_mbc_mean.getVal();
    par[21] = dbck_mbc_sigma0.getVal();
    par[22] = dbck_mbc_sigma1.getVal();
    par[23] = dbck_de_mean1.getVal();
    par[24] = dbck_de_width1.getVal();
    par[25] = dbck_de_frac1.getVal();
    par[26] = dbck_mbc_mean1.getVal();

    epar[0] = mbc_mean.getError();
    epar[1] = de_mean.getError();
    epar[2] = mbcde_corr.getError();
    epar[3] = mbc_sigma_l.getError();
    epar[4] = mbc_sigma_r.getError();
    epar[5] = de_sigma.getError();
    epar[6] = ebeam.getError();
    epar[7] = bck.getError();
    epar[8] = mbcw_shift.getError();
    epar[9] = mbcw_frac.getError();
    epar[10] = mbcw_sigma.getError();
    epar[11] = dew_sigma.getError();
    epar[12] = mbcdew_corr.getError();
    epar[13] = dpsig.getError();
    epar[14] = dbck_alpha_mbc.getError();
    epar[15] = dbck_alpha_de.getError();
    epar[16] = dbck_ebeam.getError();
    epar[17] = dbck_de_mean.getError();
    epar[18] = dbck_de_width.getError();
    epar[19] = dbck_de_frac.getError();
    epar[20] = dbck_mbc_mean.getError();
    epar[21] = dbck_mbc_sigma0.getError();
    epar[22] = dbck_mbc_sigma1.getError();
    epar[23] = dbck_de_mean1.getError();
    epar[24] = dbck_de_width1.getError();
    epar[25] = dbck_de_frac1.getError();
    epar[26] = dbck_mbc_mean1.getError();
      
    gSystem->Exec("mkdir " + dirPath + "par/" + TypeDir); 
    write_par(dirPath + "par/" + TypeDir + "/"+ "sig_ATC_S1.0_A6.0_Z0.0.par", SIG_PARS, par, epar);

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

    TCanvas *c = new TCanvas("signal", "signal", 1200, 400);
    c->Divide(3,1);
    c->cd(1);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame->Draw();
    c->cd(2);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame->GetXaxis()->SetTitleOffset(1.1);
    de_frame->GetYaxis()->SetTitleOffset(1.5);
    de_frame->Draw();
    c->cd(3);
    TH1 *hmbcde = data->createHistogram("mbc,de", 100, 100);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    gStyle->SetOptStat(0);
    hmbcde->GetXaxis()->SetTitleOffset(1.1);
    hmbcde->GetYaxis()->SetTitleOffset(1.5);
    hmbcde->SetTitle(" ");
    hmbcde->GetXaxis()->SetTitle("M_{bc}, MeV");
    hmbcde->GetYaxis()->SetTitle("#Delta E, MeV");
    hmbcde->Draw();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/home/ovtin/development/Dmeson/analysisDplus/rooFit/";
    outName="signal_RooFit_"+ TypeDir;
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

