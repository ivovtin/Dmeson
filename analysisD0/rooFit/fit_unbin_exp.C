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
    TTree *tree = new TTree("tree", "tree");
    load_dat_file(tree,"/home/ovtin/development/Dmeson/analysisD0/rooFit/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_ATC_1.0110.dat");

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
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/init/exp_fit.par", EXP_PARS, exp_par, exp_epar);

    RooRealVar Bck("Bck", "Bck", exp_par[2], 0., 2000.);
    RooRealVar DBck("DBck", "DBck", exp_par[3], 0., 1500.);
    //RooRealVar Sig("Sig", "Sig", exp_par[4], 0., 1000.);
    RooRealVar Sig("Sig", "Sig", exp_par[4], exp_par[4], exp_par[4]);

    double sig_par[SIG_PARS];
    double sig_epar[SIG_PARS];
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/sig_sim.par", SIG_PARS, sig_par, sig_epar);
    //read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/sig_sim_Minuit2_migrad.par", SIG_PARS, sig_par, sig_epar);
    //read_par("/home/ovtin/development/Dmeson/analysisD0/fitD0/par/parold/sig.par", SIG_PARS, sig_par, sig_epar);
    //read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/sig_sim_Minuit_migrad_update4.par", SIG_PARS, sig_par, sig_epar);
    sig_par[7] = 0;

    RooRealVar sig_mbc_mean("sig_mbc_mean", "sig_mbc_mean", exp_par[0],  1864.4, 1865.6);
    RooRealVar sig_de_mean("sig_de_mean", "sig_de_mean", exp_par[1], -7., 7.);
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
    RooRealVar sig_dbck_mbc_shift("sig_dbck_mbc_shift", "sig_dbck_mbc_shift", 0., 0., 0.);
    RooRealVar sig_dbck_mbc_sigma2("sig_dbck_mbc_sigma2", "sig_dbck_mbc_sigma2", sig_par[25], sig_par[25], sig_par[25]);

    RooSigPdf sig_model("sig_model","sig_model", mbc, de, dp, sig_mbc_mean, sig_de_mean, sig_mbcde_corr, sig_mbc_sigma0_l, sig_mbc_sigma0_r, sig_de_sigma, sig_ebeam, sig_bck, sig_mbc_sigma2, sig_mbcw_shift, sig_mbcw_frac, sig_mbcw_sigma, sig_dew_sigma, sig_mbcdew_corr, sig_dpcurv, sig_mbc_sigma4, sig_dbck_alpha_mbc, sig_dbck_alpha_de, sig_dbck_ebeam, sig_dbck_dpcurv, sig_dbck_de_mean, sig_dbck_de_width, sig_dbck_de_frac, sig_dbck_mbc_mean, sig_dbck_mbc_sigma0, sig_dbck_mbc_sigma1, sig_dbck_de_mean1, sig_dbck_de_width1, sig_dbck_de_frac1, sig_dbck_de_frac2, sig_dbck_mbc_shift, sig_dbck_mbc_sigma2);      
    sig_model.Print();

    double dbck_par[DBCK_PARS];
    double dbck_epar[DBCK_PARS];
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/dbck_sim.par", DBCK_PARS, dbck_par, dbck_epar);
    
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
    read_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/bck_uds.par", BCK_PARS, uds_par, uds_epar);

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

    //RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save());
    RooFitResult* r = exp_model.fitTo(*data, RooFit::Minimizer("Minuit","minimize"), Save(), PrintLevel(-1), BatchMode(true));
    //RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit2","migrad"),Save());

    r->Print("v");
    cout << "EDM = " << r->edm() << endl;
    cout << "-log(L) at minimum = " << r->minNll()<<endl;
    cout << "final value of floating parameters"<<endl;
    r->floatParsFinal().Print("s");
    const TMatrixDSym& cor = r->correlationMatrix();
    const TMatrixDSym& cov = r->covarianceMatrix();
    cout<<"correlation matrix"<<endl;
    cor.Print() ;
    cout<<"covariance matrix"<<endl;
    cov.Print();

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

    write_par("/home/ovtin/development/Dmeson/analysisD0/rooFit/par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/out/exp.par", EXP_PARS, exp_par, exp_epar);

    mbc.setBins(100);
    RooPlot* mbc_frame = mbc.frame(Title(" "));
    mbc_frame->SetAxisRange(1790, 1900,"X");
    de.setRange("dEsigRegion", -100, 100);   
    data->plotOn(mbc_frame, CutRange("dEsigRegion"));
    exp_model.plotOn(mbc_frame, LineColor(kRed), ProjectionRange("dEsigRegion"), RooFit::Name("Signal"));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    //exp_model.plotOn(mbc_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("dEsigRegion"), RooFit::Name("uds"));
    //exp_model.plotOn(mbc_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("dEsigRegion"), RooFit::Name("dbck"));
   
    de.setBins(30);
    RooPlot* de_frame = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion", 1855, 1875);   
    data->plotOn(de_frame, CutRange("MbcsigRegion"));
    exp_model.plotOn(de_frame, LineColor(kRed), ProjectionRange("MbcsigRegion"));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    //exp_model.plotOn(de_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("MbcsigRegion"));
    //exp_model.plotOn(de_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("MbcsigRegion"));
   
    dp.setBins(50);
    RooPlot* dp_frame = dp.frame(Title(" "));
    dp_frame->SetAxisRange(-600, 600,"X");
    dp.setRange("dPsigRegion", -600, 600);   
    data->plotOn(dp_frame, CutRange("dPsigRegion"));
    exp_model.plotOn(dp_frame, LineColor(kRed), ProjectionRange("dPsigRegion"));
    Double_t chi2_dp = dp_frame->chiSquare();
    cout << "dp Chi2 : " << chi2_dp << endl;
    //exp_model.plotOn(dp_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("dPsigRegion"));
    //exp_model.plotOn(dp_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("dPsigRegion"));
    
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

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    TString KEDR = "/home/ovtin/development/Dmeson/analysisD0/rooFit/";
    outName="exp_RooFit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

