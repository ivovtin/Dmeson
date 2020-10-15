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
    int data=2016;
    //int data=2004;
    //int data=1;

    TFile* file;

    TString KEDR;
    if( data==2016 ){
        file = TFile::Open("res_exp_Dmeson_data_0.root");
        //KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v9/Mbc_fit";
        KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v9_ntrack2/Mbc_fit";
    }
    else if (data==2004)
    {
	file = TFile::Open("res_exp_Dmeson_data2004_4.root");
        KEDR = "/home/ovtin/public_html/outDmeson/D0/data2004Pcorr/Mbc_fit";
    }
    else if (data==1)
    {
	file = TFile::Open("res_sim_Dmeson_sig_1.root");
        KEDR = "/home/ovtin/public_html/outDmeson/D0/simulation_Sig/Mbc_fit";
    }

    //TH1 *Mbc = (TH1F*)file->Get("Mkin_{bc}");                               //take histo
    TH1 *Mbc = (TH1F*)file->Get("M_{bc}");                               //take histo
    Mbc->SetLineColor(kRed);

    // --- Observable ---
    RooRealVar mes("Mbc", "M_{bc} (MeV)", 1800, 1900);
    // Create a binned dataset that imports contents of TH1 and associates its contents to observable 'x'
    RooDataHist dh("dh", "dh", mes, Import(*Mbc));

    // --- Build Gaussian signal PDF ---
    RooRealVar sigmean("mean", "mean", 1865, 1860, 1875);
    RooRealVar sigwidth("sigma", "sigma", 2., 0., 10.);
    RooGaussian gauss("gauss", "gaussian PDF", mes, sigmean, sigwidth);

    // --- Build Argus background PDF ---
    RooRealVar argpar("argpar", "argus shape parameter", -20.0, -100., -1.);
    RooArgusBG argus("argus", "Argus PDF", mes, RooConst(1893), argpar);

    // --- Construct signal+background PDF ---
    RooRealVar nsig("nsig", "#signal events", 200, 0., 100000);
    RooRealVar nbkg("nbkg", "#background events", 800, 0., 100000);
    RooAddPdf sum("sum", "g+a", RooArgList(gauss, argus), RooArgList(nsig, nbkg));

    // --- Perform extended ML fit of composite PDF to toy data ---
    sum.fitTo(dh, Extended());

    // Draw all frames on a canvas
    TCanvas *c = new TCanvas("Mbc", "Mbc", 800, 600);
    //c->Divide(2);
    //c->cd(1);

    mes.setRange("signal",1855.,1875.);      //signal region
    RooAbsReal* fsigregion_sum = sum.createIntegral(mes,NormSet(mes),Range("signal"));
    RooAbsReal* fsigregion_bkg = argus.createIntegral(mes,NormSet(mes),Range("signal"));

    Double_t nsigevents = fsigregion_sum->getVal()*(nsig.getVal()+nbkg.getVal())-fsigregion_bkg->getVal()*nbkg.getVal();
    Double_t nbkgevents = fsigregion_bkg->getVal()*nbkg.getVal();

    Double_t fsig = nsigevents/(fsigregion_sum->getVal()*(nsig.getVal()+nbkg.getVal()));

    cout<<"nsigevents="<<nsigevents<<"\t"<<"nbkgevents="<<nbkgevents<<endl;   //This is the number of signal events in the signal region


    // --- Plot toy data and composite PDF overlaid ---
    RooPlot *frame = mes.frame();
    dh.plotOn(frame);
    sum.plotOn(frame, LineColor(kRed));
    sum.plotOn(frame, Components(argus), LineStyle(kDashed));
    //sum.plotOn(frame, Components(argus), DrawOption("F"), FillColor(kOrange), LineStyle(kDashed), MoveToBack());
    sum.paramOn(frame,Layout(0.70,0.9,0.90));
    // Print structure of composite p.d.f.
    //sum.Print("t");
    //Double_t chi2 = frame->chiSquare();
    //TPaveLabel *t1 = new TPaveLabel(0.7,0.6,0.9,0.68, Form("#chi^{2} = %f", chi2));
    //frame->addObject(t1);
    frame->getAttText()->SetTextSize(0.027);
    //dh.statOn(frame);
    cout << "chi^2 = " << frame->chiSquare() << endl;
    frame->SetTitle( "M_{bc} (MeV)" );
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
    c->SaveAs(KEDR + format1);  c->SaveAs(KEDR + format2);  c->SaveAs(KEDR + format3);

}

