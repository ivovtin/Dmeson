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
#include "RooudsPdf.h"
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/RooudsPdf_cxx.so)
R__LOAD_LIBRARY(/home/ovtin/development/Dmeson/analysisDplus/rooFit/load_read_write_C.so)

#define BCK_PARS 5

using namespace RooFit;

void fit_unbin_uds()
{
    //gROOT->ProcessLine(".L RooudsPdf.cxx+");
    //gROOT->ProcessLine(".L load_read_write.C++");

    //atc+dedx+tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //isr syst
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_plus_sigma";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_minus_sigma";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_rnd";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

    //ionization_losses syst
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_plus1sigma";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_dedx_ionization_losses_plus1sigma_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_minus1sigma";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_dedx_ionization_losses_minus1sigma_ATC.dat";

    //syst_momres
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A5.1_Z0.0";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";

    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A6.9_Z0.0";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";

    //BG uds shape
    TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_Syst_BGudsShape";
    TString dataFile = "kpp_pions_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";


    //atc+dedx
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_dedx_ATC.dat";

    //atc+tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_ATC.dat";

    //tof
    //TString TypeDir = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
    //TString dataFile = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_ATC.dat";

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
    RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));

    int ndata = data.sumEntries();
    cout<<"ndata="<<ndata<<endl;

    double par[BCK_PARS];
    double epar[BCK_PARS];
    read_par(dirPath + "par/init/bck.par", BCK_PARS, par, epar);

    RooRealVar alpha_mbc("alpha_mbc", "alpha_mbc", par[0], -10., 20.);
    RooRealVar alpha_de("alpha_de", "alpha_de", par[1], -3., 3.);
    RooRealVar ebeam("ebeam", "ebeam", par[2],par[2],par[2]);
    RooRealVar twist("twist", "twist", par[3], 0., 40.);
    RooRealVar c2_de("c2_de", "c2_de", par[4], 0., 10.);
    //RooClassFactory::makePdf("RooudsPdf","mbc,ebeam,alpha_mbc,alpha_de,de,twist,c2_de",0,"exp(alpha_mbc*(mbc/ebeam-1.)+(-alpha_de+(twist*(mbc/ebeam-1.)))*de/1000.-c2_de*de*de/1000./1000.)*sqrt(ebeam*ebeam - mbc*mbc)/1000.");  .L RooudsPdf.cxx+ 
    RooudsPdf uds_model("uds_model","uds_model",mbc,ebeam,alpha_mbc,alpha_de,de,twist,c2_de);   
    
    uds_model.Print();

    //Perform fit and save result
    //RooFitResult* r = uds_model.fitTo(data,RooFit::Minimizer("Minuit2","migrad"),Save());
    RooFitResult* r = uds_model.fitTo(data,RooFit::Minimizer("Minuit","migrad"),Save());
    //RooFitResult* r = uds_model.fitTo(data,RooFit::Minimizer("Minuit","minimize"),Save());
    //Print fit results 
    // ---------------------------------
    // Verbose printing: Basic info, values of constant parameters, initial and
    // final values of floating parameters, global correlations
    r->Print("v");    
    //Access basic information
    cout << "EDM = " << r->edm() << endl ;
    cout << "-log(L) at minimum = " << r->minNll() << endl ; 
    /*
    //Access list of final fit parameter values
    cout << "final value of floating parameters" << endl ;
    r->floatParsFinal().Print("s") ;
    //Extract covariance and correlation matrix as TMatrixDSym
    const TMatrixDSym& cor = r->correlationMatrix() ;
    const TMatrixDSym& cov = r->covarianceMatrix() ;
    //Print correlation, covariance matrix
    cout << "correlation matrix" << endl ;
    cor.Print() ;
    cout << "covariance matrix" << endl ;
    cov.Print() ;
    */
     
    par[0] = alpha_mbc.getVal();
    par[1] = alpha_de.getVal();
    par[2] = ebeam.getVal();
    par[3] = twist.getVal();
    par[4] = c2_de.getVal();

    epar[0] = alpha_mbc.getError();
    epar[1] = alpha_de.getError();
    epar[2] = ebeam.getError();
    epar[3] = twist.getError();
    epar[4] = c2_de.getError();
      
    gSystem->Exec("mkdir " + dirPath + "par/" + TypeDir);
 
    write_par(dirPath + "par/" + TypeDir + "/"+ "bck_uds_ATC_S1.0_A6.0_Z0.0.par", BCK_PARS, par, epar);

    RooAbsReal::defaultIntegratorConfig()->method2D().setLabel("RooMCIntegrator");

    mbc.setBins(100);
    RooPlot* mbc_frame = mbc.frame(Title(" "));
    data.plotOn(mbc_frame, MarkerColor(kBlue), LineColor(kBlue));
    uds_model.plotOn(mbc_frame, LineColor(kRed));
    Double_t chi2_mbc = mbc_frame->chiSquare();
    cout << "mbc Chi2 : " << chi2_mbc << endl;
    
    de.setBins(30);
    RooPlot* de_frame = de.frame(Title(" "));
    data.plotOn(de_frame, MarkerColor(kBlue), LineColor(kBlue));
    uds_model.plotOn(de_frame, LineColor(kRed));
    Double_t chi2_de = de_frame->chiSquare();
    cout << "de Chi2 : " << chi2_de << endl;
    
    //Define the sidebands  
    RooPlot* de_frame1 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion1", 1700, 1800);
    data.plotOn(de_frame1, MarkerColor(kBlue), LineColor(kBlue), CutRange("MbcsigRegion1"));
    uds_model.plotOn(de_frame1, LineColor(kRed), ProjectionRange("MbcsigRegion1"));
    Double_t chi2_de1 = de_frame1->chiSquare();
    cout << "de1 Chi2 : " << chi2_de1 << endl;

    RooPlot* de_frame2 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion2", 1800, 1850);
    data.plotOn(de_frame2, MarkerColor(kBlue), LineColor(kBlue), CutRange("MbcsigRegion2"));
    uds_model.plotOn(de_frame2, LineColor(kRed), ProjectionRange("MbcsigRegion2"));
    Double_t chi2_de2 = de_frame2->chiSquare();
    cout << "de2 Chi2 : " << chi2_de2 << endl;

    RooPlot* de_frame3 = de.frame(Title(" "));
    mbc.setRange("MbcsigRegion3", 1850, 1900);
    data.plotOn(de_frame3, MarkerColor(kBlue), LineColor(kBlue), CutRange("MbcsigRegion3"));
    uds_model.plotOn(de_frame3, LineColor(kRed), ProjectionRange("MbcsigRegion3"));
    Double_t chi2_de3 = de_frame3->chiSquare();
    cout << "de3 Chi2 : " << chi2_de3 << endl;

 
    TCanvas *c = new TCanvas("uds", "uds", 1200, 800);
    c->Divide(3,2);
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
    TH1 *hmbcde = data.createHistogram("mbc,de", 100, 100);
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
    de_frame1->SetTitle("M_{bc}<1800 MeV");
    de_frame1->GetXaxis()->SetTitleOffset(1.1);
    de_frame1->GetYaxis()->SetTitleOffset(1.5);
    de_frame1->Draw();
    c->cd(5);
    gPad->SetLeftMargin(0.11);
    gPad->SetRightMargin(0.03);
    de_frame2->SetTitle("1800<M_{bc}<1850 MeV");
    de_frame2->GetXaxis()->SetTitleOffset(1.1);
    de_frame2->GetYaxis()->SetTitleOffset(1.5);
    de_frame2->Draw();
    c->cd(6);
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
    outName="uds_RooFit_" + TypeDir;
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
}

