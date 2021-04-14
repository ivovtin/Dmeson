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

using namespace RooFit;

void fit_unbinned_MCSignal()
{
    //read prepared root file with variables
    TFile *file = TFile::Open("res_0_160_1_0_sim_Dmeson_sig.root");
    TTree *tree = (TTree*)file->Get("forFit");

    // Create  component  pdfs in  Mbc and dE
    // ----------------------------------------------------------------
    RooRealVar Mbc("Mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar dE("dE", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dP("dP", "#Delta P (MeV)", minP, maxP);

    //==========================dE================================================================
    //Signal peak
    RooRealVar meandE("meandE", "mean of gauss for signal peak", -2.547, -30, 30);
    RooRealVar sigmadE("sigmadE", "width of gauss for signal peak", 49.22, 0.0, 80);
    RooGaussian gauss("peak_gauss", "gauss for signal peak", dE, meandE, sigmadE);

    //Background - polynomial
    RooRealVar c1("c1", "slope of background", -0.000574, -10, 10);
    RooRealVar c2("c2", "slope of background", -0.00000792, -10, 10);
    RooPolynomial bkgdE("bkgdE", "function for background", dE, RooArgList(c1,c2));
    //=============================================================================================

    //Signal peak
    //=========================Mbc=================================================================
    /*
    RooRealVar mean("mean", "mean of gauss for signal peak", 1864, 1855, 1880);
    RooRealVar sigma("sigma", "width of gauss for signal peak", 15, 0.0, 30);
    RooRealVar r("r", "width of gauss for signal peak", 2, 0.001, 10);
    RooRealVar gamma("gamma", "gamma", 0.5, 0.0, 0.99);
    //RooFormulaVar assym_gauss("assym_gauss","2/(sqrt(2*TMath::Pi()*sigma**2)*(r+1))*(gamma*exp(-(Mbc-mean)**2/(2*sigma**2))+(1-gamma)*exp(-(Mbc-mean)**2/(2*r**2*sigma**2)))",RooArgList(Mbc,mean,sigma,r,gamma));
    RooGaussian *assym_gauss = new RooGaussian("peak_gauss", "gauss for signal peak", Mbc, mean, sigma);
    //RooTestFunc assym_gauss("assym_gauss", "gauss for signal peak", Mbc, mean, sigma);
    //RooAbsPdf* model = bindPdf("model",ROOT::Math::gaussian_pdf,Mbc,sigma,mean);
    //RooAbsReal* model = bindFunction("model",TMath::gaussian_pdf,Mbc,sigma,mean);
    */

    RooRealVar mean("mean", "mean of gauss for signal peak", 1864.64, 1860, 1870);
    RooRealVar sigma("sigma", "width of gauss for signal peak", 4.522, 0.0, 10);
    RooRealVar alpha("alpha", "alpha", 0.980, 0.0, 10);                    //Gaussian tail
    RooRealVar n("n", "n", 6.83, 0.0, 30);                                 //normalization
    RooRealVar cor("cor", "correlation coefficient", 1.0, -5., 5.);

    RooFormulaVar meancor("correlations","mean+cor*(dE-meandE)",RooArgList(mean,cor,dE,meandE));
    //RooCBShape CBShape("CBShape", "Crystal Ball Function", Mbc, mean, sigma, alpha, n);
    //RooCBShape CBShapeCor("CBShapeCor", "Crystal Ball Function", dE, meandE, sigma, alpha, n);
    RooGaussian CBShape("CBShape", "Crystal Ball Function", Mbc, meancor, sigma);

    //Background - Argus
    RooRealVar k1("k1", "k1", 1887.43, 1880, 1892);
    RooRealVar k2("k2", "k2", -9.7, -30, 5);
    RooRealVar k3("k3", "k3", 0.393, 0, 1);
    RooArgusBG bkgMbc("bkgMbc","Argus PDF",Mbc,k1,k2,k3);

    //RooFormulaVar varcor("correlations","Mbc-cor*dE",RooArgList(Mbc,cor,dE));
    //RooArgusBG bkgMbc("bkgMbc","Argus PDF",varcor,k1,k2,k3);

    //===============================================================================================

    RooRealVar nsig("nsig", "yield signal peak", 37000, 0, 1000000);
    RooRealVar nbkg("nbkg", "yield of background", 70000, 0, 1000000);

    //RooAddPdf model("modeldE", "sum of signal and background PDF's", RooArgList(gauss, bkgdE), RooArgList(nbkg, nsig));   //dE
    //RooAddPdf model("modelMbc", "sum of signal and background PDF's", RooArgList(CBShape, bkgMbc), RooArgList(nsig, nbkg));    //Mbc
    //RooAddPdf modeldE("modeldE", "sum of signal and background PDF's", RooArgList(gauss, bkgdE), RooArgList(nbkg, nsig));   //dE
    //RooAddPdf modelMbc("modelMbc", "sum of signal and background PDF's", RooArgList(CBShape, bkgMbc), RooArgList(nsig, nbkg));    //Mbc
    //RooProdPdf model("model","model",modelMbc,modeldE);
    RooProdPdf model("model","model",CBShape,gauss);

    // Construct unbinned dataset importing tree branches
    RooDataSet data("data", "data", RooArgSet(Mbc, dE, dP), Import(*tree));

    // --- Perform fit of composite PDF to data ---
    model.fitTo(data);
    //model.fitTo(data, Extended());

    // Create and fill ROOT 2D histogram (20x20 bins) with contents of dataset
    TH1 *hh_data = data.createHistogram("Mbc,dE", 50, 50);

    // Plot x distribution of data and projection of gaussxy on x = Int(dy) gaussxy(x,y)
    RooPlot *xframe = Mbc.frame();
    data.plotOn(xframe);
    model.plotOn(xframe, Components(bkgMbc), LineColor(kGreen));
    model.plotOn(xframe,LineColor(kRed));
    //model.paramOn(xframe,Layout(0.67,0.9,0.90));
    //xframe->getAttText()->SetTextSize(0.025);

    // Plot x distribution of data and projection of gaussxy on y = Int(dx) gaussxy(x,y)
    RooPlot *yframe = dE.frame();
    data.plotOn(yframe);
    // Plot just the background.
    model.plotOn(yframe, Components(bkgdE), LineColor(kGreen));
    model.plotOn(yframe,LineColor(kRed));
    //model.paramOn(yframe,Layout(0.67,0.9,0.90));
    //yframe->getAttText()->SetTextSize(0.027);

    // Make canvas and draw RooPlots
    TCanvas *c = new TCanvas("fits", "fits", 800, 600);
    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    KEDR = "/home/ovtin/public_html/outDmeson/D0/fits/MCSignal/";

    gPad->SetLeftMargin(0.15);
    hh_data->GetZaxis()->SetTitleOffset(1.4);
    hh_data->Draw("lego");
    outName="Mbc_dE";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);

    gPad->SetLeftMargin(0.15);
    xframe->GetYaxis()->SetTitleOffset(1.4);
    xframe->Draw();
    outName="Mbc";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);

    gPad->SetLeftMargin(0.15);
    yframe->GetYaxis()->SetTitleOffset(1.4);
    yframe->Draw();
    outName="dE";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);

    TCanvas *can1 = new TCanvas("fits", "fits", 1200, 600);
    can1->Divide(3);
    can1->cd(1);
    hh_data->Draw("lego");
    can1->cd(2);
    xframe->Draw();
    can1->cd(3);
    yframe->Draw();

}

