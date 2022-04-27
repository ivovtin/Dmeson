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
#include "RooSigPdfNewSyst.h"
#include "RoodbckPdfNew.h"
#include "RooudsPdf.h"
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/RooSigPdfNewSyst_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/RoodbckPdfNew_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/RooudsPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/load_read_write_C.so)

#define SIG_PARS 22
#define DBCK_PARS 13
#define BCK_PARS 5
#define EXP_PARS 5

using namespace RooFit;

void fit_unbin_exp_newSystSig()
{
    bool draw = 1;
    TString inExpPar = "init/exp_fitNew.par";

    //atc+tof+dedx
    TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
    TString dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_ATC.dat";
    TString coef = "1.0140";

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

    double exp_par[EXP_PARS];
    double exp_epar[EXP_PARS];
    read_par(dirPath + "par/" + inExpPar, EXP_PARS, exp_par, exp_epar);

    RooRealVar Bck("Bck", "Bck", exp_par[2], 0., 50000.);
    RooRealVar DBck("DBck", "DBck", exp_par[3], 0., 20000.);
    RooRealVar Sig("Sig", "Sig", exp_par[4], 0., 10000.);

    TypeDir = TypeDir + "_Syst";

    double sig_par[SIG_PARS];
    double sig_epar[SIG_PARS];
    read_par(dirPath + "par/" + TypeDir + "/sig_ATC_S1.0_A6.0_Z0.0.par", SIG_PARS, sig_par, sig_epar);

    double mdsigPar = sig_par[0];
    double desigPar = sig_par[1];

    RooRealVar sig_mbc_mean("sig_mbc_mean", "sig_mbc_mean", exp_par[0],  exp_par[0]-10.0, exp_par[0]+10.0);
    RooRealVar sig_de_mean("sig_de_mean", "sig_de_mean", exp_par[1], -10.0, 10.0);
    RooRealVar sig_mbcde_corr("sig_mbcde_corr", "sig_mbcde_corr", sig_par[2], sig_par[2], sig_par[2]);
    RooRealVar sig_mbc_sigma_l("sig_mbc_sigma_l", "sig_mbc_sigma_l", sig_par[3], sig_par[3], sig_par[3]);
    RooRealVar sig_mbc_sigma_r("sig_mbc_sigma_r", "sig_mbc_sigma_r", sig_par[4], sig_par[4], sig_par[4]);
    RooRealVar sig_de_sigma("sig_de_sigma", "sig_de_sigma", sig_par[5], sig_par[5], sig_par[5]);
    RooRealVar sig_ebeam("sig_ebeam", "sig_ebeam", sig_par[6], sig_par[6], sig_par[6]);
    RooRealVar sig_bck("sig_bck", "sig_bck", sig_par[7], sig_par[7], sig_par[7]);
    RooRealVar sig_dpsig("sig_dpsig", "sig_dpsig", sig_par[8], sig_par[8], sig_par[8]);

    RooRealVar sig_dbck_alpha_mbc("sig_dbck_alpha_mbc", "sig_dbck_alpha_mbc", sig_par[9], sig_par[9], sig_par[9]);
    RooRealVar sig_dbck_alpha_de("sig_dbck_alpha_de", "sig_dbck_alpha_de", sig_par[10], sig_par[10], sig_par[10]);
    RooRealVar sig_dbck_ebeam("sig_dbck_ebeam", "sig_dbck_ebeam", sig_par[11],sig_par[11],sig_par[11]);
    RooRealVar sig_dbck_de_mean("sig_dbck_de_mean", "sig_dbck_de_mean", sig_par[12], sig_par[12], sig_par[12]);
    RooRealVar sig_dbck_de_width("sig_dbck_de_width", "sig_dbck_de_width", sig_par[13], sig_par[13], sig_par[13]);
    RooRealVar sig_dbck_de_frac("sig_dbck_de_frac", "sig_dbck_de_frac", sig_par[14], sig_par[14], sig_par[14]);
    RooRealVar sig_dbck_mbc_mean("sig_dbck_mbc_mean", "sig_dbck_mbc_mean", sig_par[15], sig_par[15], sig_par[15]);
    RooRealVar sig_dbck_mbc_sigma0("sig_dbck_mbc_sigma0", "sig_dbck_mbc_sigma0", sig_par[16], sig_par[16], sig_par[16]);
    RooRealVar sig_dbck_mbc_sigma1("sig_dbck_mbc_sigma1", "sig_dbck_mbc_sigma1", sig_par[17], sig_par[17], sig_par[17]);
    RooRealVar sig_dbck_de_mean1("sig_dbck_de_mean1", "sig_dbck_de_mean1", sig_par[18], sig_par[18], sig_par[18]);
    RooRealVar sig_dbck_de_width1("sig_dbck_de_width1", "sig_dbck_de_width1", sig_par[19], sig_par[19], sig_par[19]);
    RooRealVar sig_dbck_de_frac1("sig_dbck_de_frac1", "sig_dbck_de_frac1", sig_par[20], sig_par[20], sig_par[20]);
    RooRealVar sig_dbck_mbc_mean1("sig_dbck_mbc_mean1", "sig_dbck_mbc_mean1", sig_par[21], sig_par[21], sig_par[21]);

    RooSigPdfNewSyst sig_model("sig_model","sig_model", mbc, de, sig_mbc_mean, sig_de_mean, sig_mbcde_corr, sig_mbc_sigma_l, sig_mbc_sigma_r, sig_de_sigma, sig_ebeam, sig_bck, sig_dpsig, sig_dbck_alpha_mbc, sig_dbck_alpha_de, sig_dbck_ebeam, sig_dbck_de_mean, sig_dbck_de_width, sig_dbck_de_frac, sig_dbck_mbc_mean, sig_dbck_mbc_sigma0, sig_dbck_mbc_sigma1, sig_dbck_de_mean1, sig_dbck_de_width1, sig_dbck_de_frac1, sig_dbck_mbc_mean1);      
    sig_model.Print();

    double dbck_par[DBCK_PARS];
    double dbck_epar[DBCK_PARS];
    read_par(dirPath + "par/" + TypeDir + "/dbck_sim_ATC_S1.0_A6.0_Z0.0.par", DBCK_PARS, dbck_par, dbck_epar);
    
    RooRealVar dbck_alpha_mbc("dbck_alpha_mbc", "dbck_alpha_mbc", dbck_par[0], dbck_par[0], dbck_par[0]);
    RooRealVar dbck_alpha_de("dbck_alpha_de", "dbck_alpha_de", dbck_par[1], dbck_par[1], dbck_par[1]);
    RooRealVar dbck_ebeam("dbck_ebeam", "dbck_ebeam", dbck_par[2], dbck_par[2], dbck_par[2]);
    RooRealVar dbck_de_mean("dbck_de_mean", "dbck_de_mean", dbck_par[3], dbck_par[3], dbck_par[3]);
    RooRealVar dbck_de_width("dbck_de_width", "dbck_de_width", dbck_par[4], dbck_par[4], dbck_par[4]);
    RooRealVar dbck_de_frac("dbck_de_frac", "dbck_de_frac", dbck_par[5], dbck_par[5], dbck_par[5]);
    RooRealVar dbck_mbc_mean("dbck_mbc_mean", "dbck_mbc_mean", dbck_par[6], dbck_par[6], dbck_par[6]);
    RooRealVar dbck_mbc_sigma0("dbck_mbc_sigma0", "dbck_mbc_sigma0", dbck_par[7], dbck_par[7], dbck_par[7]);
    RooRealVar dbck_mbc_sigma1("dbck_mbc_sigma1", "dbck_mbc_sigma1", dbck_par[8], dbck_par[8], dbck_par[8]);
    RooRealVar dbck_de_mean1("dbck_de_mean1", "dbck_de_mean1", dbck_par[9], dbck_par[9], dbck_par[9]);
    RooRealVar dbck_de_width1("dbck_de_width1", "dbck_de_width1", dbck_par[10], dbck_par[10], dbck_par[10]);
    RooRealVar dbck_de_frac1("dbck_de_frac1", "dbck_de_frac1", dbck_par[11], dbck_par[11], dbck_par[11]);
    RooRealVar dbck_mbc_mean1("dbck_mbc_mean1", "dbck_mbc_mean1", dbck_par[12], dbck_par[12], dbck_par[12]);

    RoodbckPdfNew dbck_model("dbck_model","dbck_model", mbc, dbck_ebeam, dbck_alpha_mbc, dbck_alpha_de, de, dbck_de_mean, dbck_de_width, dbck_de_frac, dbck_mbc_mean, dbck_mbc_sigma0, dbck_mbc_sigma1, dbck_de_mean1, dbck_de_width1, dbck_de_frac1, dbck_mbc_mean1);

    dbck_model.Print();

    double uds_par[BCK_PARS];
    double uds_epar[BCK_PARS];
    read_par(dirPath + "par/" + TypeDir + "/bck_uds_ATC_S1.0_A6.0_Z0.0.par", BCK_PARS, uds_par, uds_epar);

    RooRealVar uds_alpha_mbc("uds_alpha_mbc", "uds_alpha_mbc", uds_par[0], uds_par[0], uds_par[0]);
    RooRealVar uds_alpha_de("uds_alpha_de", "uds_alpha_de", uds_par[1], uds_par[1], uds_par[1]);
    RooRealVar uds_ebeam("uds_ebeam", "uds_ebeam", uds_par[2], uds_par[2], uds_par[2]);
    RooRealVar uds_twist("uds_twist", "uds_twist", uds_par[3], uds_par[3], uds_par[3]);
    RooRealVar uds_c2_de("uds_c2_de", "uds_c2_de", uds_par[4], uds_par[4], uds_par[4]);
    RooudsPdf uds_model("uds_model","uds_model", mbc, uds_ebeam, uds_alpha_mbc, uds_alpha_de, de, uds_twist, uds_c2_de);
    uds_model.Print();

    //Total experimental model for D^+ - meson
    RooAddPdf exp_model("exp_model", "uds_model+dbck_model+sig_model", RooArgList(uds_model, dbck_model, sig_model),RooArgList(Bck,DBck,Sig));

    //Construct unbinned dataset importing tree branches
    RooDataSet* data= new RooDataSet("data", "data", RooArgSet(mbc, de), Import(*tree));
    int ndata = data->sumEntries();
    cout<<"ndata="<<ndata<<endl;

    //ROOT::Math::MinimizerOptions::SetDefaultTolerance(1.E-8);
    //ROOT::Math::MinimizerOptions::SetDefaultTolerance(1.0); 
    //ROOT::Math::MinimizerOptions::setEps(1.0); 
    //RooMinimizer::setEps(1.0);
    //ROOT::Math::MinimizerOptions::SetDefaultMaxIterations(10000); 
    //ROOT::Math::MinimizerOptions::SetDefaultMaxFunctionCalls(10);

    //RooAbsReal::defaultIntegratorConfig()->Print("v");
    //RooAbsReal::defaultIntegratorConfig()->setEpsAbs(1e-1);
    //RooAbsReal::defaultIntegratorConfig()->setEpsRel(1e-1);

    RooAbsReal* nll = exp_model.createNLL(*data);
    //RooMinimizer m(*nll) ; // create Minimizer class
    //m.setEps(100.0);
    //m.setMaxIterations(10000);
    //m.minimize("Minuit","Migrad"); // minimize using Minuit
    //m.hesse();  //Call HESSE
    //m.minos();  //Call MINOS for ‘param

    //RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save(),PrintLevel(1));
    RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = exp_model.fitTo(*data,Extended(true),Save());
    //RooFitResult* r = exp_model.fitTo(*data, RooFit::Minimizer("Minuit","minimize"), Save());
    //RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit2","migrad"),Save());
    //RooFitResult* r = exp_model.fitTo(*data,RooFit::Minimizer("Minuit2","minimize"),Save());
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

    double mdcorr = 1869.5 + (exp_par[0]-mdsigPar) + 0.008*(exp_par[1]-desigPar);
    cout << "M_D = " << mdcorr <<" +- " << exp_epar[0] << endl; 

    RooAbsReal::defaultIntegratorConfig()->method2D().setLabel("RooMCIntegrator");

    mbc.setBins(100);
    RooPlot* mbc_frame = mbc.frame(Title(" "));
    mbc_frame->SetAxisRange(1790, 1900,"X");
    de.setRange("dEsigRegion", -70, 70);   
    data->plotOn(mbc_frame, CutRange("dEsigRegion"), RooFit::Name("Data"));
    exp_model.plotOn(mbc_frame, LineColor(kRed), ProjectionRange("dEsigRegion"), RooFit::Name("Fit function"));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    exp_model.plotOn(mbc_frame, Components(sig_model), LineStyle(kDashed), LineColor(kMagenta), ProjectionRange("dEsigRegion"), RooFit::Name("Signal"));
    exp_model.plotOn(mbc_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("dEsigRegion"), RooFit::Name("uds"));
    exp_model.plotOn(mbc_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("dEsigRegion"), RooFit::Name("dbck"));
   
    de.setBins(30);
    RooPlot* de_frame = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion", 1860, 1880);   
    data->plotOn(de_frame, CutRange("MbcsigRegion"));
    exp_model.plotOn(de_frame, LineColor(kRed), ProjectionRange("MbcsigRegion"));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    exp_model.plotOn(de_frame, Components(sig_model), LineStyle(kDashed), LineColor(kMagenta), ProjectionRange("MbcsigRegion"));
    exp_model.plotOn(de_frame, Components(uds_model), LineStyle(kDashed), LineColor(kGreen), ProjectionRange("MbcsigRegion"));
    exp_model.plotOn(de_frame, Components(RooArgSet(uds_model, dbck_model)), LineStyle(kDashed), LineColor(kBlue), ProjectionRange("MbcsigRegion"));

    //Define the sidebands 
    //========= mbc sidebands
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

    //========= de sidebands
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

    //get N events
    mbc.setRange("signal",1860,1880);
    de.setRange("signal",-70,70);
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

    gSystem->Exec("mkdir " + dirPath + "par/" + TypeDir);
    write_par(dirPath + "par/" + TypeDir + "/"+ "exp_ATC_S1.0_A6.0_Z0.0_" + coef + ".par", EXP_PARS, exp_par, exp_epar);
 
    if(draw){
    	TString format1=".eps";
    	TString format2=".png";
    	TString format3=".pdf";
    	TString outName;
    	TString KEDR = "/home/ovtin/development/Dmeson/analysisDplus/rooFit/";
 
    	//Plot likelihood scan   
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

    	TString outNll = "exp_RooFit_"+TypeDir + "_NLL_" + coef;;
    	cnll->SaveAs(KEDR + outNll + format1);  cnll->SaveAs(KEDR + outNll + format2);  cnll->SaveAs(KEDR + outNll + format3);

    	TCanvas *c = new TCanvas("exp", "exp", 1200, 1200);
    	c->Divide(3,3);
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
    	double deCut1=-70, deCut2=70;
    	double mbcCut1=1860, mbcCut2=1880; 
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

    	outName="exp_RooFit_"+TypeDir + "_" + coef;
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
   
   	}
   
 }

