#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooGaussian.h"
#include "TCanvas.h"
#include "RooPlot.h"
#include "TAxis.h"
using namespace RooFit;

void fit_binned_Mbc()
{
    //read prepared root file with variables
    //TFile *file = TFile::Open("res_0_160_1_0_exp_Dmeson_2004.root");
    //TFile *file = TFile::Open("res_0_160_1_0_exp_Dmeson_2016-17.root");
    TFile *file = TFile::Open("res_0_160_1_0_exp_Dmeson_runs24613-25687.root");
    TH1 *Mbc = (TH1F*)file->Get("M_{bc}");                               //take histo
    Mbc->SetLineColor(kRed);

    // --- Observable ---
    RooRealVar mes("Mbc", "M_{bc} (MeV)", 1800, 1900);
    // Create a binned dataset that imports contents of TH1 and associates its contents to observable 'x'
    RooDataHist dh("dh", "dh", mes, Import(*Mbc));

    // --- Build Gaussian signal PDF ---
    RooRealVar sigmean("mean", "mean", 1869, 1865, 1878);
    RooRealVar sigwidth("sigma", "sigma", 3., 0., 8.);
    RooGaussian gauss("gauss", "gaussian PDF", mes, sigmean, sigwidth);

    // --- Build Argus background PDF ---
    RooRealVar argpar("argpar", "argus shape parameter", -20.0, -100., -1.);
    RooArgusBG argus("argus", "Argus PDF", mes, RooConst(1888), argpar);

    // --- Construct signal+background PDF ---
    RooRealVar nsig("nsig", "#signal events", 200, 0., 10000);
    RooRealVar nbkg("nbkg", "#background events", 800, 0., 10000);
    RooAddPdf sum("sum", "g+a", RooArgList(gauss, argus), RooArgList(nsig, nbkg));

    // --- Perform extended ML fit of composite PDF to toy data ---
    sum.fitTo(dh, Extended());

    // Draw all frames on a canvas
    TCanvas *c = new TCanvas("Mbc", "Mbc", 800, 600);
    //c->Divide(2);
    //c->cd(1);

    // --- Plot toy data and composite PDF overlaid ---
    RooPlot *frame = mes.frame();
    dh.plotOn(frame);
    sum.plotOn(frame, LineColor(kRed));
    sum.plotOn(frame, Components(argus), LineStyle(kDashed));
    //sum.plotOn(frame, Components(argus), DrawOption("F"), FillColor(kOrange), LineStyle(kDashed), MoveToBack());
    sum.paramOn(frame,Layout(0.70,0.9,0.90));
    frame->getAttText()->SetTextSize(0.027);
    //dh.statOn(frame);
    frame->Draw();

    // Please note that error bars shown (Poisson or SumW2) are for visualization only, the are NOT used
    // in a maximum likelihood fit
    //
    // A (binned) ML fit will ALWAYS assume the Poisson error interpretation of data (the mathematical definition
    // of likelihood does not take any external definition of errors). Data with non-unit weights can only be correctly
    // fitted with a chi^2 fit (see rf602_chi2fit.C)

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    KEDR = "/home/ovtin/public_html/outDmeson/Dplus/fits/Mbc";
    c->SaveAs(KEDR + format1);  c->SaveAs(KEDR + format2);  c->SaveAs(KEDR + format3);

}

