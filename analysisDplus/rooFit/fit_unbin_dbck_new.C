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
#include "RoodbckPdfNew.h"
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/RoodbckPdfNew_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/load_read_write_C.so)

#define DBCK_PARS 13

using namespace RooFit;

void fit_unbin_dbck_new()
{
    //gROOT->ProcessLine(".L RoodbckPdfNew.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    //atc+dedx+tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //isr syst
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_plus_sigma";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_plus_sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_minus_sigma";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_minus_sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_rnd";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_rnd_ATC.dat";

    //ionization_losses syst
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_plus1sigma";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_plus1sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_minus1sigma";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_minus1sigma_ATC.dat";

    //syst_momres
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A5.1_Z0.0";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A6.9_Z0.0";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";

    //BG dbck syst shape
    TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_Syst_BGdbckShape";
    TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //atc+dedx
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_dedx_ATC.dat";

    //atc+tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_ATC.dat";

    //tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_ATC.dat";

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

    // Construct unbinned dataset importing tree branches
    //RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de), Import(*tree));
    int ndata = data->sumEntries();
    cout<<"ndata="<<ndata<<endl;


    double par[DBCK_PARS];
    double epar[DBCK_PARS];
    //read_par(dirPath + "par/init/dbckNew.par", DBCK_PARS, par, epar);
    //read_par(dirPath + "par/init/dbck_atc_dedx.par", DBCK_PARS, par, epar);
    //read_par(dirPath + "par/init/dbck_atc_tof.par", DBCK_PARS, par, epar);
    //read_par(dirPath + "par/init/dbck_tof.par", DBCK_PARS, par, epar);
    read_par(dirPath + "par/init/dbck_syst.par", DBCK_PARS, par, epar);
    
    /*
    //atc+tof+dedx
    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], 0., 30.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], -8., 8.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar de_mean("de_mean", "de_mean", par[3], -250., -100.);
    RooRealVar de_width("de_width", "de_width", par[4], 10., 80.);
    RooRealVar de_frac("de_frac", "de_frac", par[5], -30., 30.);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[6], 1840., 1880.);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[7], 0., 30.);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[8], -500., 0.);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[9], -500., 0.);
    RooRealVar de_width1("de_width1", "de_width1", par[10], 0., 400.);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[11], -400000., 100000.);
    RooRealVar mbc_mean1("mbc_mean1", "mbc_mean1", par[12], 0.0, 5000.);
    */

    //atc+tof+dedx  - BG dbck syst shape
    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], 0., 30.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], -8., 8.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar de_mean("de_mean", "de_mean", par[3], -250., -100.);
    RooRealVar de_width("de_width", "de_width", par[4], 10., 80.);
    RooRealVar de_frac("de_frac", "de_frac", par[5], par[5], par[5]);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[6], 1840., 1880.);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[7], 0., 30.);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[8], -500., 0.);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[9], -500., 0.);
    RooRealVar de_width1("de_width1", "de_width1", par[10], 0., 400.);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[11], par[11], par[11]);
    RooRealVar mbc_mean1("mbc_mean1", "mbc_mean1", par[12], 0.0, 5000.);
 
    
    /*
    //atc+dedx
    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], 0., 30.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], 0., 10.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar de_mean("de_mean", "de_mean", par[3], -250., -50.);
    RooRealVar de_width("de_width", "de_width", par[4], 10., 80.);
    RooRealVar de_frac("de_frac", "de_frac", par[5], 0., 30.);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[6], 1840., 1880.);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[7], 0., 30.);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[8], -500., 0.);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[9], -500., 0.);
    RooRealVar de_width1("de_width1", "de_width1", par[10], 0., 400.);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[11], -450000., 0.);
    RooRealVar mbc_mean1("mbc_mean1", "mbc_mean1", par[12], 0.0, 6000.);
    */
    /*    
    //atc+tof
    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], 0., 30.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], 0., 10.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar de_mean("de_mean", "de_mean", par[3], -250., -50.);
    RooRealVar de_width("de_width", "de_width", par[4], 10., 80.);
    RooRealVar de_frac("de_frac", "de_frac", par[5], 0., 30.);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[6], 1840., 1880.);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[7], 0., 30.);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[8], -600., 0.);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[9], -500., 0.);
    RooRealVar de_width1("de_width1", "de_width1", par[10], 0., 400.);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[11], -500000., 0.);
    RooRealVar mbc_mean1("mbc_mean1", "mbc_mean1", par[12], 0.0, 6000.);
    */
    /*
    //tof
    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], 0., 30.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], 0., 10.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar de_mean("de_mean", "de_mean", par[3], -250., -50.);
    RooRealVar de_width("de_width", "de_width", par[4], 10., 80.);
    RooRealVar de_frac("de_frac", "de_frac", par[5], 0., 30.);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[6], 1840., 1880.);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[7], 0., 30.);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[8], -600., 0.);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[9], -500., 0.);
    RooRealVar de_width1("de_width1", "de_width1", par[10], 0., 400.);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[11], -1000000., 0.);
    RooRealVar mbc_mean1("mbc_mean1", "mbc_mean1", par[12], 0.0, 6000.);
    */
    //RooClassFactory::makePdf("RoodbckPdfNew","mbc,ebeam,alpha_mbc,alpha_de,de,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,mbc_mean1",0,"fabs(de_frac1)");  
    //.L RoodbckPdfNew.cxx+ 

    RoodbckPdfNew dbck_model("dbck_model","dbck_model",mbc,ebeam,alpha_mbc,alpha_de,de,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,mbc_mean1);

    dbck_model.Print();
       
    //Perform fit and save result
    //RooFitResult* r = dbck_model.fitTo(*data,RooFit::Minimizer("Minuit2","migrad"),Save());
    RooFitResult* r = dbck_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = dbck_model.fitTo(*data,RooFit::Minimizer("Minuit","minimize"),Save());
    //RooFitResult* r = dbck_model.fitTo(*data,Save());
    //Print fit results 
    // ---------------------------------
    // Verbose printing: Basic info, values of constant parameters, initial and
    // final values of floating parameters, global correlations
    r->Print("v");    
    //Access basic information
    cout << "EDM = " << r->edm() << endl;
    cout << "-log(L) at minimum = " << r->minNll()<<endl; 
    //Access list of final fit parameter values
    //cout << "final value of floating parameters"<<endl;
    //r->floatParsFinal().Print("s");
    //Extract covariance and correlation matrix as TMatrixDSym
    //const TMatrixDSym& cor = r->correlationMatrix();
    //const TMatrixDSym& cov = r->covarianceMatrix();
    //Print correlation, covariance matrix
    //cout<<"correlation matrix"<<endl;
    //cor.Print() ;
    //cout<<"covariance matrix"<<endl;
    //cov.Print();
                
    par[0] = alpha_mbc.getVal();
    par[1] = alpha_de.getVal();
    par[2] = ebeam.getVal();
    par[3] = de_mean.getVal();
    par[4] = de_width.getVal();
    par[5] = de_frac.getVal();
    par[6] = mbc_mean.getVal();
    par[7] = mbc_sigma0.getVal();
    par[8] = mbc_sigma1.getVal();
    par[9] = de_mean1.getVal();
    par[10] = de_width1.getVal();
    par[11] = de_frac1.getVal();
    par[12] = mbc_mean1.getVal();

    epar[0] = alpha_mbc.getError();
    epar[1] = alpha_de.getError();
    epar[2] = ebeam.getError();
    epar[3] = de_mean.getError();
    epar[4] = de_width.getError();
    epar[5] = de_frac.getError();
    epar[6] = mbc_mean.getError();
    epar[7] = mbc_sigma0.getError();
    epar[8] = mbc_sigma1.getError();
    epar[9] = de_mean1.getError();
    epar[10] = de_width1.getError();
    epar[11] = de_frac1.getError();
    epar[12] = mbc_mean1.getError();
       
    gSystem->Exec("mkdir " + dirPath + "par/" + TypeDir);
    write_par(dirPath + "par/" + TypeDir + "/"+ "dbck_sim_ATC_S1.0_A6.0_Z0.0.par", DBCK_PARS, par, epar);

    RooAbsReal::defaultIntegratorConfig()->method2D().setLabel("RooMCIntegrator");

    mbc.setBins(100);
    RooPlot* mbc_frame = mbc.frame(Title(" "));
    data->plotOn(mbc_frame, MarkerColor(kBlue), LineColor(kBlue));
    dbck_model.plotOn(mbc_frame, LineColor(kRed));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    
    de.setBins(30);
    RooPlot* de_frame = de.frame(Title(" "));
    data->plotOn(de_frame, MarkerColor(kBlue), LineColor(kBlue));
    dbck_model.plotOn(de_frame, LineColor(kRed));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;

    
    //Define the sidebands 
    //========= mbc sidebands
    RooPlot* mbc_frame1 = mbc.frame(Title(" "));
    de.setRange("desigRegion1", -300, -200);
    data->plotOn(mbc_frame1, MarkerColor(kBlue), LineColor(kBlue), CutRange("desigRegion1"));
    dbck_model.plotOn(mbc_frame1, LineColor(kRed), ProjectionRange("desigRegion1"));
    Double_t chi2_mbc1 = mbc_frame1->chiSquare();
    cout << "mbc1 Chi2 : " << chi2_mbc1 << endl;

    RooPlot* mbc_frame2 = mbc.frame(Title(" "));
    de.setRange("desigRegion2", -200, 0);
    data->plotOn(mbc_frame2, MarkerColor(kBlue), LineColor(kBlue), CutRange("desigRegion2"));
    dbck_model.plotOn(mbc_frame2, LineColor(kRed), ProjectionRange("desigRegion2"));
    Double_t chi2_mbc2 = mbc_frame2->chiSquare();
    cout << "mbc2 Chi2 : " << chi2_mbc2 << endl;

    RooPlot* mbc_frame3 = mbc.frame(Title(" "));
    de.setRange("desigRegion3", 0, 300);
    data->plotOn(mbc_frame3, MarkerColor(kBlue), LineColor(kBlue), CutRange("desigRegion3"));
    dbck_model.plotOn(mbc_frame3, LineColor(kRed), ProjectionRange("desigRegion3"));
    Double_t chi2_mbc3 = mbc_frame3->chiSquare();
    cout << "mbc3 Chi2 : " << chi2_mbc3 << endl;

    //========= de sidebands
    RooPlot* de_frame1 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion1", 1700, 1800);
    data->plotOn(de_frame1, MarkerColor(kBlue), LineColor(kBlue), CutRange("MbcsigRegion1"));
    dbck_model.plotOn(de_frame1, LineColor(kRed), ProjectionRange("MbcsigRegion1"));
    Double_t chi2_de1 = de_frame1->chiSquare();
    cout << "de1 Chi2 : " << chi2_de1 << endl;

    RooPlot* de_frame2 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion2", 1800, 1850);
    data->plotOn(de_frame2, MarkerColor(kBlue), LineColor(kBlue), CutRange("MbcsigRegion2"));
    dbck_model.plotOn(de_frame2, LineColor(kRed), ProjectionRange("MbcsigRegion2"));
    Double_t chi2_de2 = de_frame2->chiSquare();
    cout << "de2 Chi2 : " << chi2_de2 << endl;

    RooPlot* de_frame3 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion3", 1850, 1900);
    data->plotOn(de_frame3, MarkerColor(kBlue), LineColor(kBlue), CutRange("MbcsigRegion3"));
    dbck_model.plotOn(de_frame3, LineColor(kRed), ProjectionRange("MbcsigRegion3"));
    Double_t chi2_de3 = de_frame3->chiSquare();
    cout << "de3 Chi2 : " << chi2_de3 << endl;
     
    TCanvas *c = new TCanvas("dbck", "dbck", 1200, 1200);
    c->Divide(3,3);
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
    c->cd(4);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame1->SetTitle("#Delta E<-200 (MeV)");
    mbc_frame1->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame1->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame1->Draw();
    c->cd(5);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame2->SetTitle("-200<#Delta E<0 (MeV)");
    mbc_frame2->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame2->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame2->Draw();
    c->cd(6);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    mbc_frame3->SetTitle("#Delta E>0 (MeV)");
    mbc_frame3->GetXaxis()->SetTitleOffset(1.1);
    mbc_frame3->GetYaxis()->SetTitleOffset(1.5);
    mbc_frame3->Draw();
    c->cd(7);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame1->SetTitle("M_{bc}<1800 MeV");
    de_frame1->GetXaxis()->SetTitleOffset(1.1);
    de_frame1->GetYaxis()->SetTitleOffset(1.5);
    de_frame1->Draw();
    c->cd(8);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame2->SetTitle("1800<M_{bc}<1850 MeV");
    de_frame2->GetXaxis()->SetTitleOffset(1.1);
    de_frame2->GetYaxis()->SetTitleOffset(1.5);
    de_frame2->Draw();
    c->cd(9);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame3->SetTitle("M_{bc}>1850 MeV");
    de_frame3->GetXaxis()->SetTitleOffset(1.1);
    de_frame3->GetYaxis()->SetTitleOffset(1.5);
    de_frame3->Draw();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/home/ovtin/development/Dmeson/analysisDplus/rooFit/";
    outName="dbck_RooFit_"+TypeDir;
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
    
}

