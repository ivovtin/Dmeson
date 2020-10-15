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

void fit_unbinned_MCBkg_continuum()
{
    //gROOT->SetStyle("Plain");

    //read prepared root file with variables
    TFile *file = TFile::Open("res_sim_Dmeson_BG_continium_2.root");
    TTree *tree = (TTree*)file->Get("forFit");

    // Create  component  pdfs in  Mbc and dE
    // ----------------------------------------------------------------
    RooRealVar Mbc("Mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar dE("dE", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dP("dP", "#Delta E (MeV)", minP, maxP);

    // Create parameters
    RooRealVar k1("k1", "k1", 1887.5, 1886, 1890);
    RooRealVar k2("k2", "k2", -5.366, -20, -1);
    RooRealVar k3("k3", "k3", 0.4993, 0, 1);
    RooRealVar k4("k4", "k4", 0.0029898, 0, 2);
    RooRealVar k5("k5", "k5", 7.11, 0, 12);

    // --- Build Argus background PDF ---
    RooArgusBG modelMbc("modelMbc","Argus PDF",Mbc,k1,k2,k3);
    //RooArgusBG model("argus","Argus PDF",Mbc,k1,k2,k3);
                                        //m, m0, c, p

    //If you want to use a function that RooFit doesn't provide, you can use a RooGenericPdf
    //RooGenericPdf model("model", "exp(-k1*(1-(Mbc<Ebeam)**2/Ebeam**2) - k2*dE)*(1+k3*(abs(dP) < sqrt(Ebeam*Ebeam - Mbc*Mbc))**2)", RooArgList(k1, Mbc, Ebeam, k2, dE, k3, dP));
    //RooGenericPdf model("model", "(Mbc<k1)*TMath::Power(1-(Mbc/k1)*(Mbc/k1),k3)*exp(k2*(1-(Mbc/k1)*(Mbc/k1)))", RooArgList(Mbc,k1,k2,k3));
    //RooGenericPdf modeldEdP("modeldEdP", "exp(-k4*dE)*(1+k5*(abs(dP)**2))", RooArgList(k4, dE, k5, dP));
    RooGenericPdf modeldE("modeldE", "exp(-k4*dE)", RooArgList(k4, dE));
    RooProdPdf model("model","model",modelMbc,modeldE);


    // Construct unbinned dataset importing tree branches
    RooDataSet data("data", "data", RooArgSet(Mbc, dE, dP), Import(*tree));

    // --- Perform fit of composite PDF to data ---
    model.fitTo(data);

    // Create and fill ROOT 2D histogram (20x20 bins) with contents of dataset
    TH1 *hh_data = data.createHistogram("Mbc,dE", 50, 50);

    // Plot x distribution of data and projection of gaussxy on x = Int(dy) gaussxy(x,y)
    //RooPlot *xframe = Mbc.frame(Title("Mbc projection"));
    RooPlot *xframe = Mbc.frame();
    data.plotOn(xframe);
    model.plotOn(xframe,LineColor(kRed));
    //model.plotOn(xframe,LineStyle(kDashed),LineColor(kRed));
    //xframe->SetMinimum(50);
    xframe->SetMaximum(480);
    // Left edge of box starts at 55% of Xaxis)
    //myPdf->paramOn(frame,Layout(xmin,ymin,ymax)) ;
    model.paramOn(xframe,Layout(0.67,0.9,0.90));
    xframe->getAttText()->SetTextSize(0.027);
    xframe->SetTitle("M_{bc} (MeV)");
    //data.statOn(xframe);

    // Plot x distribution of data and projection of gaussxy on y = Int(dx) gaussxy(x,y)
    //RooPlot *yframe = dE.frame(Title("dE projection"));
    RooPlot *yframe = dE.frame();
    data.plotOn(yframe);
    model.plotOn(yframe,LineColor(kRed));
    model.paramOn(yframe,Layout(0.67,0.9,0.90));
    yframe->getAttText()->SetTextSize(0.027);
    yframe->SetTitle("#Delta E (MeV)");
    //data.statOn(yframe);

    // Make canvas and draw RooPlots
    TCanvas *c = new TCanvas("fits", "fits", 800, 600);
    TString format1=".eps";
    TString format2=".png";
    TString format3=".pdf";
    TString outName;
    KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Bkg_continium/";
    gPad->SetLeftMargin(0.15);
    hh_data->GetZaxis()->SetTitleOffset(1.4);
    hh_data->Draw("lego");
    outName="Mbc_dE_fit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
    gPad->SetLeftMargin(0.15);
    xframe->GetYaxis()->SetTitleOffset(1.4);
    xframe->Draw();
    outName="Mbc_fit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);
    gPad->SetLeftMargin(0.15);
    yframe->GetYaxis()->SetTitleOffset(1.4);
    yframe->Draw();
    outName="dE_fit";
    c->SaveAs(KEDR + outName + format1);  c->SaveAs(KEDR + outName + format2);  c->SaveAs(KEDR + outName + format3);

    TCanvas *c1 = new TCanvas("fits", "fits", 1200, 600);
    c1->Divide(3);
    c1->cd(1);
    hh_data->Draw("lego");
    c1->cd(2);
    xframe->Draw();
    c1->cd(3);
    yframe->Draw();

}

