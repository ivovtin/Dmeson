#include <stdio.h>
#include "TMath.h"
#include "TFormula.h"
#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooGaussian.h"
#include "RooFitResult.h"
#include "RooAddPdf.h"
#include "TCanvas.h"
#include "TLegend.h"
#include "RooPlot.h"
#include "TH2.h"
#include "TAxis.h"
#include "TStyle.h"
#include "RooSigPdf.h"
#include "RoodbckPdf.h"
#include "RooudsPdf.h"
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/RooSigPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/RoodbckPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/RooudsPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisD0/rooFit/load_read_write_C.so)

#define SIG_PARS 30
#define DBCK_PARS 16
#define BCK_PARS 4
#define EXP_PARS 5

using namespace RooFit;

void fit_unbin_exp()
{
    bool draw = 1;

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc";
    //TString dataFile = t"kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ATC.dat";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0090_atc_dedx_ATC.dat";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0110_atc_dedx_ATC.dat";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0120_atc_dedx_ATC.dat";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_dedx_ATC.dat";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_atc_dedx_ATC.dat";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0160_atc_dedx_ATC.dat";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0170_atc_dedx_ATC.dat";
  
    //syst ionization_losses
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_plus1sigma";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ionization_losses_plus1sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_minus1sigma";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ionization_losses_minus1sigma_ATC.dat";

    //syst mom res
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A6.9_Z0.0_syst_momres";
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A5.1_Z0.0_syst_momres";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ATC.dat";

    //syst isr rnd
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_rnd";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ATC.dat";

    //syst uds shape
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_Syst_BGudsShape";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ATC.dat";

    //syst dbck shape
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_Syst_BGdbckShape";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ATC.dat";

    //syst sig shape
    TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_Syst_SigShape";
    TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_dedx_ATC.dat";
    

    //wo ATC
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_woATC";
    //TString dataFile = "kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_woATC.dat";


    TString dirPath = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";
    TString dataPath = dirPath + "dat/" + TypeDir +"/" + dataFile;

    TTree *tree = new TTree("tree", "tree");
    load_dat_file(tree, dataPath);

    RooAbsReal::defaultIntegratorConfig()->method2D().setLabel("RooMCIntegrator");

    // Create  component  pdfs in  Mbc, dE, dP
    // ----------------------------------------------------------------
    RooRealVar mbc("mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar de("de", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dp("dp", "#Delta P (MeV)", minP, maxP);

    double exp_par[EXP_PARS];
    double exp_epar[EXP_PARS];
    //read_par(dirPath + "par/init/exp_init.par", EXP_PARS, exp_par, exp_epar);
    read_par(dirPath + "par/init/exp_init_good.par", EXP_PARS, exp_par, exp_epar);

    RooRealVar Bck("Bck", "Bck", exp_par[2], 0., 30000.);
    RooRealVar DBck("DBck", "DBck", exp_par[3], 0., 10000.);
    RooRealVar Sig("Sig", "Sig", exp_par[4], 0., 1000.);

    double sig_par[SIG_PARS];
    double sig_epar[SIG_PARS];
    read_par(dirPath + "par/" + TypeDir + "/sig_ATC_S1.0_A6.0_Z0.0.par", SIG_PARS, sig_par, sig_epar);

    //sig_par[7] = 0;

    double mdsigPar = sig_par[0];
    double desigPar = sig_par[1];

    RooRealVar sig_mbc_mean("sig_mbc_mean", "sig_mbc_mean", exp_par[0],  exp_par[0]-10.0, exp_par[0]+10.0);
    RooRealVar sig_de_mean("sig_de_mean", "sig_de_mean", exp_par[1], -10.0, 10.0);
    //RooRealVar sig_de_mean("sig_de_mean", "sig_de_mean", exp_par[1], -20.0, 20.0);
    RooRealVar sig_mbcde_corr("sig_mbcde_corr", "sig_mbcde_corr", sig_par[2], sig_par[2], sig_par[2]);
    RooRealVar sig_mbc_sigma0_l("sig_mbc_sigma0_l", "sig_mbc_sigma0_l", sig_par[3], sig_par[3], sig_par[3]);
    RooRealVar sig_mbc_sigma0_r("sig_mbc_sigma0_r", "sig_mbc_sigma0_r", sig_par[4], sig_par[4], sig_par[4]);
    RooRealVar sig_de_sigma("sig_de_sigma", "sig_de_sigma", sig_par[5], sig_par[5], sig_par[5]);
    RooRealVar sig_ebeam("sig_ebeam", "sig_ebeam", sig_par[6], sig_par[6], sig_par[6]);
    RooRealVar sig_bck("sig_bck", "sig_bck", sig_par[7], sig_par[7], sig_par[7]);
    RooRealVar sig_mbc_sigma2("sig_mbc_sigma2", "sig_mbc_sigma2", sig_par[8], sig_par[8], sig_par[8]);
    RooRealVar sig_mbcw_shift("sig_mbcw_shift", "sig_mbcw_shift", sig_par[9], sig_par[9], sig_par[9]);
    RooRealVar sig_mbcw_frac("sig_mbcw_frac", "sig_mbcw_frac", sig_par[10], sig_par[10], sig_par[10]);
    RooRealVar sig_mbcw_sigma("sig_mbcw_sigma", "sig_mbcw_sigma", sig_par[11], sig_par[11], sig_par[11]);
    RooRealVar sig_dew_sigma("sig_dew_sigma", "sig_dew_sigma", sig_par[12], sig_par[12], sig_par[12]);
    RooRealVar sig_mbcdew_corr("sig_mbcdew_corr", "sig_mbcdew_corr", sig_par[13], sig_par[13], sig_par[13]);
    RooRealVar sig_dpcurv("sig_dpcurv", "sig_dpcurv", sig_par[14], sig_par[14], sig_par[14]);
    RooRealVar sig_mbc_sigma4("sig_mbc_sigma4", "sig_mbc_sigma4", sig_par[15], sig_par[15], sig_par[15]);

    RooRealVar sig_dbck_alpha_mbc("sig_dbck_alpha_mbc", "sig_dbck_alpha_mbc", sig_par[16], sig_par[16], sig_par[16]);
    RooRealVar sig_dbck_alpha_de("sig_dbck_alpha_de", "sig_dbck_alpha_de", sig_par[17], sig_par[17], sig_par[17]);
    RooRealVar sig_dbck_ebeam("sig_dbck_ebeam", "sig_dbck_ebeam", sig_par[18],sig_par[18],sig_par[18]);
    RooRealVar sig_dbck_dpcurv("sig_dbck_dpcurv", "sig_dbck_dpcurv", sig_par[19], sig_par[19], sig_par[19]);
    RooRealVar sig_dbck_de_mean("sig_dbck_de_mean", "sig_dbck_de_mean", sig_par[20], sig_par[20], sig_par[20]);
    RooRealVar sig_dbck_de_width("sig_dbck_de_width", "sig_dbck_de_width", sig_par[21], sig_par[21], sig_par[21]);
    RooRealVar sig_dbck_de_frac("sig_dbck_de_frac", "sig_dbck_de_frac", sig_par[22], sig_par[22], sig_par[22]);
    RooRealVar sig_dbck_mbc_mean("sig_dbck_mbc_mean", "sig_dbck_mbc_mean", sig_par[23], sig_par[23], sig_par[23]);
    RooRealVar sig_dbck_mbc_sigma0("sig_dbck_mbc_sigma0", "sig_dbck_mbc_sigma0", sig_par[24], sig_par[24], sig_par[24]);
    RooRealVar sig_dbck_mbc_sigma1("sig_dbck_mbc_sigma1", "sig_dbck_mbc_sigma1", sig_par[25], sig_par[25], sig_par[25]);
    RooRealVar sig_dbck_de_mean1("sig_dbck_de_mean1", "sig_dbck_de_mean1", sig_par[26], sig_par[26], sig_par[26]);
    RooRealVar sig_dbck_de_width1("sig_dbck_de_width1", "sig_dbck_de_width1", sig_par[27], sig_par[27], sig_par[27]);
    RooRealVar sig_dbck_de_frac1("sig_dbck_de_frac1", "sig_dbck_de_frac1", sig_par[28], sig_par[28], sig_par[28]);
    RooRealVar sig_dbck_de_frac2("sig_dbck_de_frac2", "sig_dbck_de_frac2", sig_par[29], sig_par[29], sig_par[29]);

    RooSigPdf sig_model("sig_model","sig_model", mbc, de, dp, sig_mbc_mean, sig_de_mean, sig_mbcde_corr, sig_mbc_sigma0_l, sig_mbc_sigma0_r, sig_de_sigma, sig_ebeam, sig_bck, sig_mbc_sigma2, sig_mbcw_shift, sig_mbcw_frac, sig_mbcw_sigma, sig_dew_sigma, sig_mbcdew_corr, sig_dpcurv, sig_mbc_sigma4, sig_dbck_alpha_mbc, sig_dbck_alpha_de, sig_dbck_ebeam, sig_dbck_dpcurv, sig_dbck_de_mean, sig_dbck_de_width, sig_dbck_de_frac, sig_dbck_mbc_mean, sig_dbck_mbc_sigma0, sig_dbck_mbc_sigma1, sig_dbck_de_mean1, sig_dbck_de_width1, sig_dbck_de_frac1, sig_dbck_de_frac2);      
    sig_model.Print();

    double dbck_par[DBCK_PARS];
    double dbck_epar[DBCK_PARS];
    read_par(dirPath + "par/" + TypeDir + "/dbck_sim_ATC_S1.0_A6.0_Z0.0.par", DBCK_PARS, dbck_par, dbck_epar);   
 
    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", dbck_par[0], dbck_par[0], dbck_par[0]);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", dbck_par[1], dbck_par[1], dbck_par[1]);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", dbck_par[2], dbck_par[2], dbck_par[2]);
    RooRealVar dbck_dpcurv("dbck_dpcurv", "dbck_dpcurv", dbck_par[3], dbck_par[3], dbck_par[3]);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", dbck_par[4], dbck_par[4], dbck_par[4]);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", dbck_par[5], dbck_par[5], dbck_par[5]);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", dbck_par[6], dbck_par[6], dbck_par[6]);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", dbck_par[7], dbck_par[7], dbck_par[7]);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", dbck_par[8], dbck_par[8], dbck_par[8]);
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", dbck_par[9], dbck_par[9], dbck_par[9]);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", dbck_par[10], dbck_par[10], dbck_par[10]);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", dbck_par[11], dbck_par[11], dbck_par[11]);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", dbck_par[12], dbck_par[12], dbck_par[12]);
    RooRealVar dbck_de_frac2("dbck_de_frac2", "dbck_de_frac2", dbck_par[13], dbck_par[13], dbck_par[13]);
    RooRealVar dbck_mbc_shift("dbck_mbc_shift", "dbck_mbc_shift", dbck_par[14], dbck_par[14], dbck_par[14]);
    RooRealVar dbck_mbc_sigma2("dbck_mbc_sigma2", "dbck_mbc_sigma2", dbck_par[15], dbck_par[15], dbck_par[15]);

    RoodbckPdf dbck_model("dbck_model","dbck_model", mbc, dbck_ebeam, dbck_alpha_mbc, dbck_alpha_de, de, dbck_dpcurv, dp, dbck_de_mean, dbck_de_width, dbck_de_frac, dbck_mbc_mean, dbck_mbc_sigma0, dbck_mbc_sigma1, dbck_de_mean1, dbck_de_width1, dbck_de_frac1, dbck_de_frac2, dbck_mbc_shift, dbck_mbc_sigma2);
    dbck_model.Print();

    double uds_par[BCK_PARS];
    double uds_epar[BCK_PARS];
    read_par(dirPath + "par/" + TypeDir + "/bck_uds_ATC_S1.0_A6.0_Z0.0.par", BCK_PARS, uds_par, uds_epar);

    RooRealVar uds_alpha_mbc("uds_alpha_mbc", "uds_alpha_mbc", uds_par[0], uds_par[0], uds_par[0]);
    RooRealVar uds_alpha_de("uds_alpha_de", "uds_alpha_de", uds_par[1], uds_par[1], uds_par[1]);
    RooRealVar uds_ebeam("uds_ebeam", "uds_ebeam", uds_par[2], uds_par[2], uds_par[2]);
    RooRealVar uds_dpcurv("uds_dpcurv", "uds_dpcurv", uds_par[3], uds_par[3], uds_par[3]);
    RooudsPdf uds_model("uds_model","uds_model", mbc, uds_ebeam, uds_alpha_mbc, uds_alpha_de, de, uds_dpcurv, dp);
    uds_model.Print();

    //Total experimental model for D^0 - meson
    RooAddPdf exp_model("exp_model", "uds_model+dbck_model+sig_model", RooArgList(uds_model, dbck_model, sig_model),RooArgList(Bck,DBck,Sig));

    //Construct unbinned dataset importing tree branches
    //RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    int ndata = data->sumEntries();
    cout<<"ndata="<<ndata<<endl;

    RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = exp_model.fitTo(*data, RooFit::Minimizer("Minuit","minimize"), Save(), PrintLevel(-1), BatchMode(true));
    //RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit2","migrad"),Save());
    //RooFitResult* r = exp_model.fitTo(*data, "e", Save()); //Perform extended MLL fit

    r->Print("v");
    cout << "EDM = " << r->edm() << endl;
    cout << "-log(L) at minimum = " << r->minNll()<<endl;
    /*
    cout << "final value of floating parameters"<<endl;
    r->floatParsFinal().Print("s");
    const TMatrixDSym& cor = r->correlationMatrix();
    const TMatrixDSym& cov = r->covarianceMatrix();
    cout<<"correlation matrix"<<endl;
    cor.Print() ;
    cout<<"covariance matrix"<<endl;
    cov.Print();
    */
    exp_par[0] = sig_mbc_mean.getVal();
    exp_par[1] = sig_de_mean.getVal();
    exp_par[2] = Bck.getVal();
    exp_par[3] = DBck.getVal();
    exp_par[4] = Sig.getVal();

    exp_epar[0] = sig_mbc_mean.getError();
    exp_epar[1] = sig_de_mean.getError();
    exp_epar[2] = Bck.getError();
    exp_epar[3] = DBck.getError();
    exp_epar[4] = Sig.getError();

    cout << "exp_par[0] =" << exp_par[0] << " +- " << exp_epar[0] <<endl;
    cout << "exp_par[1] =" << exp_par[1] << " +- " << exp_epar[1] <<endl;
    cout << "exp_par[2] =" << exp_par[2] << " +- " << exp_epar[2] <<endl;
    cout << "exp_par[3] =" << exp_par[3] << " +- " << exp_epar[3] <<endl;
    cout << "exp_par[4] =" << exp_par[4] << " +- " << exp_epar[4] <<endl;

    double mdcorr = 1864.84 + (exp_par[0]-mdsigPar) + 0.00*(exp_par[1]-desigPar);;
    cout << "M_D = " << mdcorr <<" +- " << exp_epar[0] << endl;

    gSystem->Exec("mkdir " + dirPath + "par/" + TypeDir);
    write_par(dirPath + "par/" + TypeDir + "/"+ "exp_ATC_S1.0_A6.0_Z0.0.par", EXP_PARS, exp_par, exp_epar);

    mbc.setBins(100);
    RooPlot* mbc_frame = mbc.frame(Title(" "));
    mbc_frame->SetAxisRange(1790, 1900,"X");
    de.setRange("dEsigRegion", -100, 100);   
    data->plotOn(mbc_frame, CutRange("dEsigRegion"), RooFit::Name("Data"));
    exp_model.plotOn(mbc_frame, LineColor(kRed), ProjectionRange("dEsigRegion"), RooFit::Name("Fit function"));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    exp_model.plotOn(mbc_frame, Components(sig_model), LineStyle(kDashed), LineColor(kMagenta), ProjectionRange("dEsigRegion"), RooFit::Name("Signal"));
    exp_model.plotOn(mbc_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("dEsigRegion"), RooFit::Name("uds"));
    exp_model.plotOn(mbc_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("dEsigRegion"), RooFit::Name("dbck"));

    de.setBins(30);
    RooPlot* de_frame = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion", 1855, 1875);   
    data->plotOn(de_frame, CutRange("MbcsigRegion"));
    exp_model.plotOn(de_frame, LineColor(kRed), ProjectionRange("MbcsigRegion"));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    exp_model.plotOn(de_frame, Components(sig_model), LineStyle(kDashed), LineColor(kMagenta), ProjectionRange("MbcsigRegion"));
    exp_model.plotOn(de_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("MbcsigRegion"));
    exp_model.plotOn(de_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("MbcsigRegion"));
   
    dp.setBins(50);
    RooPlot* dp_frame = dp.frame(Title(" "));
    dp_frame->SetAxisRange(-600, 600,"X");
    dp.setRange("dPsigRegion", -600, 600);   
    data->plotOn(dp_frame, CutRange("dPsigRegion"));
    exp_model.plotOn(dp_frame, LineColor(kRed), ProjectionRange("dPsigRegion"));
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;
    exp_model.plotOn(dp_frame, Components(sig_model), LineStyle(kDashed), LineColor(kMagenta), ProjectionRange("dPsigRegion"));
    exp_model.plotOn(dp_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("dPsigRegion"));
    exp_model.plotOn(dp_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("dPsigRegion"));

    float total_Chi2 = chi2_mbc + chi2_de + chi2_dp;
    cout<< "total_Chi2 = " << total_Chi2 <<endl;
    
    //Define the sidebands 
    //========= mbc sidebands de cut
    RooPlot* mbc_frame1 = mbc.frame(Title(" "));
    de.setRange("desigRegion1", -300, -200);
    data->plotOn(mbc_frame1, CutRange("desigRegion1"));
    exp_model.plotOn(mbc_frame1, LineColor(kRed), ProjectionRange("desigRegion1"));
    Double_t chi2_mbc1 = mbc_frame1->chiSquare();
    cout << "mbc1 Chi2 : " << chi2_mbc1 << endl;

    RooPlot* mbc_frame2 = mbc.frame(Title(" "));
    de.setRange("desigRegion2", -200, 0);
    data->plotOn(mbc_frame2, CutRange("desigRegion2"));
    exp_model.plotOn(mbc_frame2, LineColor(kRed), ProjectionRange("desigRegion2"));
    Double_t chi2_mbc2 = mbc_frame2->chiSquare();
    cout << "mbc2 Chi2 : " << chi2_mbc2 << endl;

    RooPlot* mbc_frame3 = mbc.frame(Title(" "));
    de.setRange("desigRegion3", 0, 300);
    data->plotOn(mbc_frame3, CutRange("desigRegion3"));
    exp_model.plotOn(mbc_frame3, LineColor(kRed), ProjectionRange("desigRegion3"));
    Double_t chi2_mbc3 = mbc_frame3->chiSquare();
    cout << "mbc3 Chi2 : " << chi2_mbc3 << endl;

    //========= mbc sidebands dp cut
    RooPlot* mbc_frame4 = mbc.frame(Title(" "));
    dp.setRange("dpsigRegion1", -100, 100);
    data->plotOn(mbc_frame4, CutRange("dpsigRegion1"));
    exp_model.plotOn(mbc_frame4, LineColor(kRed), ProjectionRange("dpsigRegion1"));
    Double_t chi2_mbc4 = mbc_frame4->chiSquare();
    cout << "mbc4 Chi2 : " << chi2_mbc4 << endl;

    RooPlot* mbc_frame5 = mbc.frame(Title(" "));
    dp.setRange("dpsigRegion2", -1000, -100);
    dp.setRange("dpsigRegion3", 100, 1000);
    data->plotOn(mbc_frame5, CutRange("dpsigRegion2, dpsigRegion3"));
    exp_model.plotOn(mbc_frame5, LineColor(kRed), ProjectionRange("dpsigRegion2, dpsigRegion3"));
    Double_t chi2_mbc5 = mbc_frame5->chiSquare();
    cout << "mbc5 Chi2 : " << chi2_mbc5 << endl;

    //========= de sidebands mbc cut
    RooPlot* de_frame1 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion1", 1700, 1800);
    data->plotOn(de_frame1, CutRange("MbcsigRegion1"));
    exp_model.plotOn(de_frame1, LineColor(kRed), ProjectionRange("MbcsigRegion1"));
    Double_t chi2_de1 = de_frame1->chiSquare();
    cout << "de1 Chi2 : " << chi2_de1 << endl;

    RooPlot* de_frame2 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion2", 1800, 1850);
    data->plotOn(de_frame2, CutRange("MbcsigRegion2"));
    exp_model.plotOn(de_frame2, LineColor(kRed), ProjectionRange("MbcsigRegion2"));
    Double_t chi2_de2 = de_frame2->chiSquare();
    cout << "de2 Chi2 : " << chi2_de2 << endl;

    RooPlot* de_frame3 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion3", 1850, 1900);
    data->plotOn(de_frame3, CutRange("MbcsigRegion3"));
    exp_model.plotOn(de_frame3, LineColor(kRed), ProjectionRange("MbcsigRegion3"));
    Double_t chi2_de3 = de_frame3->chiSquare();
    cout << "de3 Chi2 : " << chi2_de3 << endl;
    
    ///////////////////
   
    //get N events
    mbc.setRange("signal",1855,1875);
    de.setRange("signal",-100,100);
    RooAbsReal* fsigregion_exp = exp_model.createIntegral(RooArgSet(mbc, de),NormSet(RooArgSet(mbc, de)),Range("signal"));
    RooAbsReal* fsigregion_sig = sig_model.createIntegral(RooArgSet(mbc, de),NormSet(RooArgSet(mbc, de)),Range("signal"));
    RooAbsReal* fsigregion_uds = uds_model.createIntegral(RooArgSet(mbc, de),NormSet(RooArgSet(mbc, de)),Range("signal"));
    RooAbsReal* fsigregion_dbck = dbck_model.createIntegral(RooArgSet(mbc, de),NormSet(RooArgSet(mbc, de)),Range("signal"));

    Double_t n_exp_events = fsigregion_exp->getVal()*(Sig.getVal() + Bck.getVal() + DBck.getVal()) - fsigregion_uds->getVal()*Bck.getVal() - fsigregion_dbck->getVal()*DBck.getVal();
    Double_t n_sig_events = fsigregion_sig->getVal()*Sig.getVal();
    Double_t n_bkg_uds_events = fsigregion_uds->getVal()*Bck.getVal();
    Double_t n_bkg_dbck_events = fsigregion_dbck->getVal()*DBck.getVal();
    Double_t total_nevents = fsigregion_exp->getVal()*(Sig.getVal() + Bck.getVal() + DBck.getVal());

    cout<<"n_exp_events = "<<n_exp_events<<endl;
    cout<<"n_sig_events = "<<n_sig_events<<endl;
    cout<<"n_uds_events = "<<n_bkg_uds_events<<endl;
    cout<<"n_bkg_dbck_events = "<<n_bkg_dbck_events<<endl;
    cout<<"total_nevents = "<<total_nevents<<endl;

    if(draw){
    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";

    //Plot likelihood scan
    RooAbsReal* nll = exp_model.createNLL(*data);

    RooPlot* nll_frame_mbc = sig_mbc_mean.frame(Title(" "));
    nll->plotOn(nll_frame_mbc, ShiftToZero());

    RooPlot* nll_frame_de = sig_de_mean.frame(Title(" "));
    nll->plotOn(nll_frame_de, ShiftToZero());

    TCanvas *cnll = new TCanvas("nll","nll",800, 400);
    cnll->Divide(2);
    cnll->cd(1);
    gPad->SetLeftMargin(0.15);
    nll_frame_mbc->GetYaxis()->SetTitleOffset(1.4);
    nll_frame_mbc->Draw();
    cnll->cd(2);
    gPad->SetLeftMargin(0.15);
    nll_frame_de->GetYaxis()->SetTitleOffset(1.4);
    nll_frame_de->Draw();

    TString outNll = "exp_RooFit_"+TypeDir + "_NLL";
    cnll->SaveAs(KEDR + outNll + format1);  cnll->SaveAs(KEDR + outNll + format2);  cnll->SaveAs(KEDR + outNll + format3);

    TCanvas *c = new TCanvas("exp", "exp", 1000, 600);
    c->Divide(2,2);
    c->cd(1);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame->Draw();
    auto leg = new TLegend(0.2,0.7,0.4,0.9);
    leg->AddEntry(mbc_frame->findObject("Data"),"Data", "p");
    leg->AddEntry(mbc_frame->findObject("Fit function"),"Fit function", "L");
    leg->AddEntry(mbc_frame->findObject("Signal"),"Signal", "L");
    leg->AddEntry(mbc_frame->findObject("dbck"),"D#bar{D} bck", "L");
    leg->AddEntry(mbc_frame->findObject("uds"),"uds bck", "L");
    leg->Draw("same");
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
    double deCut1=-100, deCut2=100;
    double mbcCut1=1855, mbcCut2=1875; 
    TLine line5(mbcCut1,-300,mbcCut1,300);
    line5.SetLineColor(kMagenta);
    line5.SetLineWidth(3);
    TLine line6(mbcCut2,-300,mbcCut2,300);
    line6.SetLineColor(kMagenta);
    line6.SetLineWidth(3);
    TLine line7(1700,deCut1,1900,deCut1);
    line7.SetLineColor(kMagenta);
    line7.SetLineWidth(3);
    TLine line8(1700,deCut2,1900,deCut2);
    line8.SetLineColor(kMagenta);
    line8.SetLineWidth(3);
    hmbcde->Draw(); 
    line5.Draw("same");
    line6.Draw("same");
    line7.Draw("same");
    line8.Draw("same");

    outName="exp_RooFit_" + TypeDir;
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);

    TCanvas *c2 = new TCanvas("exp2", "exp2", 1200, 400);
    c2->Divide(3,1);
    c2->cd(1);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame->Draw();
    auto leg2 = new TLegend(0.2,0.7,0.4,0.9);
    leg2->AddEntry(mbc_frame->findObject("Data"),"Data", "p");
    leg2->AddEntry(mbc_frame->findObject("Fit function"),"Fit function", "L");
    leg2->AddEntry(mbc_frame->findObject("Signal"),"Signal", "L");
    leg2->AddEntry(mbc_frame->findObject("dbck"),"D#bar{D} bck", "L");
    leg2->AddEntry(mbc_frame->findObject("uds"),"uds bck", "L");
    leg2->Draw("same");
    c2->cd(2);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame->GetXaxis()->SetTitleOffset(1.1);
    de_frame->GetYaxis()->SetTitleOffset(1.5);
    de_frame->Draw();
    c2->cd(3);
    TH1 *hmbcde2 = data->createHistogram("mbc,de", 100, 100);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    gStyle->SetOptStat(0);
    hmbcde2->GetXaxis()->SetTitleOffset(1.1);
    hmbcde2->GetYaxis()->SetTitleOffset(1.5);
    hmbcde2->SetTitle(" ");
    hmbcde2->GetXaxis()->SetTitle("M_{bc}, MeV");
    hmbcde2->GetYaxis()->SetTitle("#Delta E, MeV");
    TLine line9(mbcCut1,-300,mbcCut1,300);
    line9.SetLineColor(kMagenta);
    line9.SetLineWidth(3);
    TLine line10(mbcCut2,-300,mbcCut2,300);
    line10.SetLineColor(kMagenta);
    line10.SetLineWidth(3);
    TLine line11(1700,deCut1,1900,deCut1);
    line11.SetLineColor(kMagenta);
    line11.SetLineWidth(3);
    TLine line12(1700,deCut2,1900,deCut2);
    line12.SetLineColor(kMagenta);
    line12.SetLineWidth(3);
    hmbcde2->Draw();
    line9.Draw("same");
    line10.Draw("same");
    line11.Draw("same");
    line12.Draw("same");

    c2->SaveAs(KEDR + outName + "_reduce" + format1);  c2->SaveAs(KEDR + outName + "_reduce" + format2);  c2->SaveAs(KEDR + outName + "_reduce" + format3);

    TCanvas *c3 = new TCanvas("exp3", "exp3", 400, 400);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame->Draw();
    auto leg3 = new TLegend(0.2,0.7,0.4,0.9);
    leg3->AddEntry(mbc_frame->findObject("Data"),"Data", "p");
    leg3->AddEntry(mbc_frame->findObject("Fit function"),"Fit function", "L");
    leg3->AddEntry(mbc_frame->findObject("Signal"),"Signal", "L");
    leg3->AddEntry(mbc_frame->findObject("dbck"),"D#bar{D} bck", "L");
    leg3->AddEntry(mbc_frame->findObject("uds"),"uds bck", "L");
    leg3->Draw("same");
    c3->SaveAs(KEDR + outName + "_mbc" + format1);  c3->SaveAs(KEDR + outName + "_mbc" + format2);  c3->SaveAs(KEDR + outName + "_mbc" + format3);

    TCanvas *c4 = new TCanvas("exp4", "exp4", 400, 400);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame->GetXaxis()->SetTitleOffset(1.1);
    de_frame->GetYaxis()->SetTitleOffset(1.5);
    de_frame->Draw();
    c4->SaveAs(KEDR + outName + "_de" + format1);  c4->SaveAs(KEDR + outName + "_de" + format2);  c4->SaveAs(KEDR + outName + "_de" + format3);


    TCanvas *c5 = new TCanvas("exp", "exp", 1200, 600);
    c5->Divide(3,2);
    
    c5->cd(1);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame1->SetTitle("#Delta E<-200 (MeV)");
    mbc_frame1->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame1->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame1->Draw();
        
    c5->cd(2);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame2->SetTitle("-200<#Delta E<0 (MeV)");
    mbc_frame2->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame2->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame2->Draw();
    
    c5->cd(3);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame3->SetTitle("#Delta E>0 (MeV)");
    mbc_frame3->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame3->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame3->Draw();
    
    c5->cd(4);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame1->SetTitle("M_{bc}<1800 MeV");
    de_frame1->GetXaxis()->SetTitleOffset(1.1);
    de_frame1->GetYaxis()->SetTitleOffset(1.5);
    de_frame1->Draw();
    
    c5->cd(5);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame2->SetTitle("1800<M_{bc}<1850 MeV");
    de_frame2->GetXaxis()->SetTitleOffset(1.1);
    de_frame2->GetYaxis()->SetTitleOffset(1.5);
    de_frame2->Draw();
    
    c5->cd(6);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame3->SetTitle("M_{bc}>1850 MeV");
    de_frame3->GetXaxis()->SetTitleOffset(1.1);
    de_frame3->GetYaxis()->SetTitleOffset(1.5);
    de_frame3->Draw();    

    c5->SaveAs(KEDR + outName + "_2" + format1);  c5->SaveAs(KEDR + outName + "_2" + format2);  c5->SaveAs(KEDR + outName + "_2" + format3);    


    TCanvas *c6 = new TCanvas("exp", "exp", 1200, 300);
    c6->Divide(4,1);

    c6->cd(1);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame->Draw();
    auto leg4 = new TLegend(0.2,0.7,0.4,0.9);
    leg4->AddEntry(mbc_frame->findObject("Data"),"Data", "p");
    leg4->AddEntry(mbc_frame->findObject("Fit function"),"Fit function", "L");
    leg4->AddEntry(mbc_frame->findObject("Signal"),"Signal", "L");
    leg4->AddEntry(mbc_frame->findObject("dbck"),"D#bar{D} bck", "L");
    leg4->AddEntry(mbc_frame->findObject("uds"),"uds bck", "L");
    leg4->Draw("same");

    c6->cd(2);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame->GetXaxis()->SetTitleOffset(1.1);
    de_frame->GetYaxis()->SetTitleOffset(1.5);
    de_frame->Draw();

    c6->cd(3);
    TH1 *hmbcde3 = data->createHistogram("mbc,de", 100, 100);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    gStyle->SetOptStat(0);
    hmbcde3->GetXaxis()->SetTitleOffset(1.1);
    hmbcde3->GetYaxis()->SetTitleOffset(1.5);
    hmbcde3->SetTitle(" ");
    hmbcde3->GetXaxis()->SetTitle("M_{bc}, MeV");
    hmbcde3->GetYaxis()->SetTitle("#Delta E, MeV");
    TLine line13(mbcCut1,-300,mbcCut1,300);
    line13.SetLineColor(kMagenta);
    line13.SetLineWidth(3);
    TLine line14(mbcCut2,-300,mbcCut2,300);
    line14.SetLineColor(kMagenta);
    line14.SetLineWidth(3);
    TLine line15(1700,deCut1,1900,deCut1);
    line15.SetLineColor(kMagenta);
    line15.SetLineWidth(3);
    TLine line16(1700,deCut2,1900,deCut2);
    line16.SetLineColor(kMagenta);
    line16.SetLineWidth(3);
    hmbcde3->Draw();
    line13.Draw("same");
    line14.Draw("same");
    line15.Draw("same");
    line16.Draw("same");

    c6->cd(4);
    gPad->SetTopMargin(0.03);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    dp_frame->GetXaxis()->SetTitleOffset(1.1);
    dp_frame->GetYaxis()->SetTitleOffset(1.5);
    dp_frame->Draw();
 
    c6->SaveAs(KEDR + outName + "_3" + format1);  c6->SaveAs(KEDR + outName + "_3" + format2);  c6->SaveAs(KEDR + outName + "_3" + format3);

    TCanvas *c7 = new TCanvas("exp", "exp", 1600, 600);
    c7->Divide(4,2);
    
    c7->cd(1);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame1->SetTitle("#Delta E<-200 (MeV)");
    mbc_frame1->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame1->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame1->Draw();
        
    c7->cd(2);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame2->SetTitle("-200<#Delta E<0 (MeV)");
    mbc_frame2->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame2->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame2->Draw();
    
    c7->cd(3);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame3->SetTitle("#Delta E>0 (MeV)");
    mbc_frame3->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame3->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame3->Draw();

    c7->cd(4);
    gPad->SetTopMargin(0.06);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame4->SetTitle("|#Delta p|<100 (MeV)");
    mbc_frame4->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame4->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame4->Draw();

    c7->cd(5);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame1->SetTitle("M_{bc}<1800 MeV");
    de_frame1->GetXaxis()->SetTitleOffset(1.1);
    de_frame1->GetYaxis()->SetTitleOffset(1.5);
    de_frame1->Draw();
    
    c7->cd(6);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame2->SetTitle("1800<M_{bc}<1850 MeV");
    de_frame2->GetXaxis()->SetTitleOffset(1.1);
    de_frame2->GetYaxis()->SetTitleOffset(1.5);
    de_frame2->Draw();
    
    c7->cd(7);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame3->SetTitle("M_{bc}>1850 MeV");
    de_frame3->GetXaxis()->SetTitleOffset(1.1);
    de_frame3->GetYaxis()->SetTitleOffset(1.5);
    de_frame3->Draw();    

    c7->cd(8);
    gPad->SetTopMargin(0.06);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame5->SetTitle("|#Delta p|>100 (MeV)");
    mbc_frame5->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame5->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame5->Draw();    

    c7->SaveAs(KEDR + outName + "_4" + format1);  c7->SaveAs(KEDR + outName + "_4" + format2);  c7->SaveAs(KEDR + outName + "_4" + format3);    

    } 
}

