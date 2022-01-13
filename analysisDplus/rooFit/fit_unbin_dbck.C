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
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/RoodbckPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/load_read_write_C.so)

#define DBCK_PARS 14

using namespace RooFit;

void fit_unbin_dbck()
{
    //gROOT->ProcessLine(".L RoodbckPdf.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_TOFfullPrange";
    TString dataFile = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_TOFfullPrange_ATC.dat";

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
    RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    int ndata = data->sumEntries();
    cout<<"ndata="<<ndata<<endl;


    double par[DBCK_PARS];
    double epar[DBCK_PARS];
    read_par(dirPath + "par/init/dbck.par", DBCK_PARS, par, epar);

    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], 0., 80.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], 0., 11.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar dpcurv("dpcurv", "dpcurv", par[3], -5., 10.);
    RooRealVar de_mean("de_mean", "de_mean", par[4], -300., 0.);
    RooRealVar de_width("de_width", "de_width", par[5], 10., 110.);
    RooRealVar de_frac("de_frac", "de_frac", par[6], -10., 30.);
    RooRealVar mbc_mean("mbc_mean", "mbc_mean", par[7], 1000., 2500.);
    RooRealVar mbc_sigma0("mbc_sigma0", "mbc_sigma0", par[8], 0., 80.);
    RooRealVar mbc_sigma1("mbc_sigma1", "mbc_sigma1", par[9], -600., 0.);
    RooRealVar de_mean1("de_mean1", "de_mean1", par[10], -600., 0.);
    RooRealVar de_width1("de_width1", "de_width1", par[11], 0., 600.);
    RooRealVar de_frac1("de_frac1", "de_frac1", par[12], -100000., 100000.);
    RooRealVar mbc_mean1("mbc_mean1", "mbc_mean1", par[13], 0.0, 10000.);

    //RooClassFactory::makePdf("RoodbckPdf","mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,mbc_mean1",0,"fabs(de_frac1)");  
    //.L RoodbckPdf.cxx+ 

    RoodbckPdf dbck_model("dbck_model","dbck_model",mbc,ebeam,alpha_mbc,alpha_de,de,dpcurv,de_mean,de_width,de_frac,mbc_mean,mbc_sigma0,mbc_sigma1,de_mean1,de_width1,de_frac1,mbc_mean1);

    dbck_model.Print();
       
    //Perform fit and save result
    //RooFitResult* r = dbck_model.fitTo(*data,RooFit::Minimizer("Minuit2","migrad"),Save());
    //RooFitResult* r = dbck_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save());
    RooFitResult* r = dbck_model.fitTo(*data,RooFit::Minimizer("Minuit","minimize"),Save());
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
    par[13] = mbc_mean1.getVal();

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
    epar[13] = mbc_mean1.getError();
       
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
     
    TCanvas *c = new TCanvas("dbck", "dbck", 1000, 600);
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
    outName="dbck_RooFit_"+TypeDir;
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

