#include "RooRealVar.h"
#include "RooDataSet.h"
#include "RooGaussian.h"
#include "TCanvas.h"
#include "RooPlot.h"
#include "TAxis.h"
using namespace RooFit;

void fit_unbinned_Mbc()
{
    //read prepared root file with variables
    //TFile *file = TFile::Open("res_0_160_1_0_exp_Dmeson_data2016-17_ntracks3_Pcorr_v4.root");
    //TFile *file = TFile::Open("res_0_160_1_0_exp_Dmeson_data2016-17_ntracks3.root");
    //TFile *file = TFile::Open("res_0_160_1_0_exp_Dmeson_Pcorr2004_v3.root");
    TFile *file = TFile::Open("res_0_160_1_0_sim_Dmeson_sig.root");
    TTree *tree = (TTree*)file->Get("forFit");

    // --- Observable ---
    RooRealVar mes("Mbc", "Mbc (MeV)", 1800, 1900);

    // Construct unbinned dataset importing tree branches
    RooDataSet ds("ds", "ds", RooArgSet(mes), Import(*tree));

    // --- Build Gaussian signal PDF ---
    RooRealVar sigmean("sigmean", "B^{#pm} mass", 1865, 1855, 1875);
    RooRealVar sigwidth("sigwidth", "B^{#pm} width", 10., 0., 20.);
    RooGaussian gauss("gauss", "gaussian PDF", mes, sigmean, sigwidth);

    // --- Build Argus background PDF ---
    RooRealVar argpar("argpar", "argus shape parameter", -20.0, -100., -1.);
    RooArgusBG argus("argus", "Argus PDF", mes, RooConst(1890), argpar);

    // --- Construct signal+background PDF ---
    RooRealVar nsig("nsig", "#signal events", 200, 0., 10000);
    RooRealVar nbkg("nbkg", "#background events", 800, 0., 10000);
    RooAddPdf sum("sum", "g+a", RooArgList(gauss, argus), RooArgList(nsig, nbkg));

    // --- Perform extended ML fit of composite PDF to toy data ---
    sum.fitTo(ds, Extended());

    // Draw all frames on a canvas
    TCanvas *c = new TCanvas("Mbc", "Mbc", 800, 600);
    //c->Divide(2);
    //c->cd(1);

    // --- Plot toy data and composite PDF overlaid ---
    RooPlot *frame = mes.frame();
    ds.plotOn(frame);
    sum.plotOn(frame, LineColor(kRed));
    //sum.plotOn(frame, Components(argus), LineStyle(kDashed));
    sum.plotOn(frame, Components(argus), DrawOption("F"), FillColor(kOrange), LineStyle(kDashed), MoveToBack());
    frame->Draw();

    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    KEDR = "/home/ovtin/public_html/outDmeson/D0/fits/Mbc";
    c->SaveAs(KEDR + format1);  c->SaveAs(KEDR + format2);  c->SaveAs(KEDR + format3);

}

