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
    //gROOT->ProcessLine(".L RoodSigPdf.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc";
    //TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat";

    //syst  ionization_losses
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_minus1sigma";
    //TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ionization_losses_minus1sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_plus1sigma";
    //TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ionization_losses_plus1sigma_ATC.dat";

    //syst mom res
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A6.9_Z0.0_syst_momres";
    //TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_syst_momres_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A5.1_Z0.0_syst_momres";
    //TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_syst_momres_ATC.dat";

    //syst isr_rnd
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_rnd";
    //TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_syst_isr_rnd_ATC.dat";

    //syst sig shape
    TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_Syst_SigShape";
    TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat";

    //woATC
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_woATC";
    //TString dataFile = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_woATC.dat";


    TString dirPath = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";
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
    //read_par(dirPath + "par/init/sig_def.par", SIG_PARS, par, epar);
    //read_par(dirPath + "par/init/sig_syst_ionization_losses_plus1sigma.par", SIG_PARS, par, epar);
    read_par(dirPath + "par/init/sig_syst.par", SIG_PARS, par, epar);

    /*
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1863.8, 1865.2);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -4., 4.);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -0.5, 0.5);
    RooRealVar mbc_sigma0_l("mbc_sigma0_l", "mbc_sigma0_l", par[3], 0.2, 1.8);
    RooRealVar mbc_sigma0_r("mbc_sigma0_r", "mbc_sigma0_r", par[4], 1.2, 4.0);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], 45., 70.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], 0., 20.);
    RooRealVar mbc_sigma2("mbc_sigma2", "mbc_sigma2", par[8], 10., 35.);
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[9], 0., 4.);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[10], 0., 0.5);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[11], 3., 15.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[12], 80., 150.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[13], -0.5, 0.5);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[14], -1., 0.);
    RooRealVar mbc_sigma4("mbc_sigma4", "mbc_sigma4", par[15], 35., 60.);

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[16], 6., 30.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[17], 1., 5.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[18],par[18],par[18]);
    RooRealVar dbck_dpcurv("dbck_dpcurv", "dbck_dpcurv", par[19], -1., 10.);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[20], -30., -5.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[21], 30., 80.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[22], 50., 150.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[23], 1871., 1878.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[24], 1., 6.);
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[25], 0., 10.);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[26], -40., 0.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[27], 0., 80.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[28], par[28], par[28]);
    RooRealVar dbck_de_frac2("dbck_de_frac2", "dbck_de_frac2", par[29], par[29], par[29]);
    */   
    
    //syst sig shape
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1863.8, 1865.2);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -4., 4.);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -0.5, 0.5);
    RooRealVar mbc_sigma0_l("mbc_sigma0_l", "mbc_sigma0_l", par[3], 0.2, 1.8);
    RooRealVar mbc_sigma0_r("mbc_sigma0_r", "mbc_sigma0_r", par[4], 1.2, 4.0);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], 45., 80.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], 0., 20.);
    RooRealVar mbc_sigma2("mbc_sigma2", "mbc_sigma2", par[8], 10., 35.);
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[9], 0., 4.);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[10], par[10], par[10]);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[11], 3., 15.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[12], 80., 150.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[13], -0.5, 0.5);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[14], -1., 0.);
    RooRealVar mbc_sigma4("mbc_sigma4", "mbc_sigma4", par[15], 35., 70.);

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[16], 6., 30.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[17], -5., 5.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[18],par[18],par[18]);
    RooRealVar dbck_dpcurv("dbck_dpcurv", "dbck_dpcurv", par[19], -10., 10.);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[20], -30., -5.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[21], 30., 90.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[22], 50., 150.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[23], 1871., 1878.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[24], 1., 6.);
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[25], 0., 10.);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[26], -40., 0.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[27], 0., 80.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[28], par[28], par[28]);
    RooRealVar dbck_de_frac2("dbck_de_frac2", "dbck_de_frac2", par[29], par[29], par[29]);
    

    /*
    //wo atc
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[0], 1863.8, 1865.2);
    RooRealVar de_mean("de_mean", "de_mean", par[1], -4., 4.);
    RooRealVar mbcde_corr("mbcde_corr", "mbcde_corr", par[2], -0.5, 0.5);
    RooRealVar mbc_sigma0_l("mbc_sigma0_l", "mbc_sigma0_l", par[3], 0.2, 1.8);
    RooRealVar mbc_sigma0_r("mbc_sigma0_r", "mbc_sigma0_r", par[4], 1.2, 4.0);
    RooRealVar de_sigma("de_sigma", "de_sigma", par[5], 45., 70.);
    RooRealVar ebeam("ebeam", "ebeam", par[6], par[6], par[6]);
    RooRealVar bck("bck", "bck", par[7], 0., 20.);
    RooRealVar mbc_sigma2("mbc_sigma2", "mbc_sigma2", par[8], 10., 35.);
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[9], 0., 4.);
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[10], 0., 0.5);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[11], 3., 15.);
    RooRealVar dew_sigma("dew_sigma", "dew_sigma", par[12], 80., 150.);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[13], -0.5, 0.5);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[14], -1., 0.);
    RooRealVar mbc_sigma4("mbc_sigma4", "mbc_sigma4", par[15], 35., 80.);

    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", par[16], 6., 30.);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", par[17], 1., 5.);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", par[18],par[18],par[18]);
    RooRealVar dbck_dpcurv("dbck_dpcurv", "dbck_dpcurv", par[19], -10., 10.);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", par[20], -50., -5.);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", par[21], 30., 100.);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", par[22], 50., 170.);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", par[23], 1871., 1878.);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", par[24], 1., 6.);
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", par[25], 0., 10.);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", par[26], -45., 0.);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", par[27], 0., 80.);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", par[28], par[28], par[28]);
    RooRealVar dbck_de_frac2("dbck_de_frac2", "dbck_de_frac2", par[29], par[29], par[29]);
    */

   //RooClassFactory::makePdf("RooSigPdf","mbc,de,dp,mbc_mean,de_mean,mbcde_corr,mbc_sigma0_l,mbc_sigma0_r,de_sigma,ebeam,bck,mbc_sigma2,mbcw_shift,
   //mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpcurv,mbc_sigma4,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_dpcurv,dbck_de_mean,dbck_de_width,
   //dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_de_frac2",0,"dpsig*(desig*mbcsig + fabs(mbcw_frac)*desig2*mbcsig2)+fabs(bck)/1e5*pdf_dbck(mbc, de, dp, dbck_par)");  .L RooSigPdf.cxx+ 

    RooSigPdf sig_model("sig_model","sig_model",mbc,de,dp,mbc_mean,de_mean,mbcde_corr,mbc_sigma0_l,mbc_sigma0_r,de_sigma,ebeam,bck,mbc_sigma2,mbcw_shift,mbcw_frac,mbcw_sigma,dew_sigma,mbcdew_corr,dpcurv,mbc_sigma4,dbck_alpha_mbc,dbck_alpha_de,dbck_ebeam,dbck_dpcurv,dbck_de_mean,dbck_de_width,dbck_de_frac,dbck_mbc_mean,dbck_mbc_sigma0,dbck_mbc_sigma1,dbck_de_mean1,dbck_de_width1,dbck_de_frac1,dbck_de_frac2);   
 
    sig_model.Print();

    // Construct unbinned dataset importing tree branches
    //RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    int ndata = data->sumEntries();
    cout<<"ndata="<<ndata<<endl;
       
    //Perform fit and save result
    //RooFitResult* r = sig_model.fitTo(data,RooFit::Minimizer("Minuit2","migrad"),Save());
    //RooFitResult* r = sig_model.fitTo(*data,RooFit::Minimizer("Minuit","minimize"),Save());
    RooFitResult* r = sig_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = sig_model.fitTo(data,Save());
    //Print fit results 
    // ---------------------------------
    // Verbose printing: Basic info, values of constant parameters, initial and
    // final values of floating parameters, global correlations
    r->Print("v");    
    /*
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
    */
               
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

    dp.setBins(80);
    RooPlot* dp_frame = dp.frame(Title(" "));
    dp_frame->SetAxisRange(-600, 600,"X");
    dp.setRange("dPsigRegion", -600, 600);
    data->plotOn(dp_frame, MarkerColor(kBlue), LineColor(kBlue), Range("dPsigRegion"));
    sig_model.plotOn(dp_frame, LineColor(kRed), Range("dPsigRegion"));
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;

    //========= mbc sidebands
    RooPlot* mbc_frame1 = mbc.frame(Title(" "));
    mbc_frame1->SetAxisRange(1800, 1900,"X");
    dp.setRange("dpsigRegion1", -50, 50);
    data->plotOn(mbc_frame1, MarkerColor(kBlue), LineColor(kBlue), CutRange("dpsigRegion1, mbcsigRegion"));
    sig_model.plotOn(mbc_frame1, LineColor(kRed), ProjectionRange("dpsigRegion1, mbcsigRegion"));
    Double_t chi2_mbc1 = mbc_frame1->chiSquare();
    cout << "mbc1 Chi2 : " << chi2_mbc1 << endl;   

    RooPlot* mbc_frame2 = mbc.frame(Title(" "));
    mbc_frame2->SetAxisRange(1800, 1900,"X");
    dp.setRange("dpsigRegion2", -1000, -150);
    dp.setRange("dpsigRegion3", 150, 1000);
    data->plotOn(mbc_frame2, MarkerColor(kBlue), LineColor(kBlue), Range("mbcsigRegion"), CutRange("dpsigRegion2, dpsigRegion3, mbcsigRegion"));
    sig_model.plotOn(mbc_frame2, LineColor(kRed), Range("mbcsigRegion"), ProjectionRange("dpsigRegion2, dpsigRegion3, mbcsigRegion"));
    Double_t chi2_mbc2 = mbc_frame2->chiSquare();
    cout << "mbc2 Chi2 : " << chi2_mbc2 << endl;   

   ///////////////////////////////
    
    TCanvas *c = new TCanvas("signal", "signal", 1000, 600);
    c->Divide(2,2);
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
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    dp_frame->GetXaxis()->SetTitleOffset(1.1);
    dp_frame->GetYaxis()->SetTitleOffset(1.5);
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
    outName="signal_RooFit_" + TypeDir;
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);

    TCanvas *c2 = new TCanvas("signal", "signal", 800, 600);
    c2->Divide(3,2);
 
    c2->cd(1);
    TH1 *hmbcdp2 = data->createHistogram("dp,mbc", 200, 200);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    gStyle->SetOptStat(0);
    hmbcdp2->SetAxisRange(1820, 1900,"Y");
    hmbcdp2->SetAxisRange(-600, 600,"X");
    hmbcdp2->GetXaxis()->SetTitleOffset(1.1);
    hmbcdp2->GetYaxis()->SetTitleOffset(1.5);
    hmbcdp2->SetTitle(" ");
    hmbcdp2->GetYaxis()->SetTitle("M_{bc}, MeV");
    hmbcdp2->GetXaxis()->SetTitle("#Delta P, MeV");
    hmbcdp2->Draw();

    c2->cd(2);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame->Draw();

    c2->cd(3);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame->GetXaxis()->SetTitleOffset(1.1);
    de_frame->GetYaxis()->SetTitleOffset(1.5);
    de_frame->Draw();

    c2->cd(4);
    gPad->SetTopMargin(0.06);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    dp_frame->GetXaxis()->SetTitleOffset(1.1);
    dp_frame->GetYaxis()->SetTitleOffset(1.5);
    dp_frame->Draw();

    c2->cd(5);
    gPad->SetTopMargin(0.06);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame1->SetTitle("|#Delta p|<50 (MeV)");
    mbc_frame1->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame1->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame1->Draw();

    c2->cd(6);
    gPad->SetTopMargin(0.06);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame2->SetTitle("|#Delta p|>150 (MeV)");
    mbc_frame2->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame2->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame2->Draw();

    TString outName2="signal_RooFit_" + TypeDir + "_2";
    c2->SaveAs(KEDR + outName2 + format1);  c2->SaveAs(KEDR + outName2 + format2);  c2->SaveAs(KEDR + outName2 + format3);
 
}

