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
    TTree *tree = new TTree("tree", "tree");
    Double_t* br1 = new Double_t ;
    Double_t* br2 = new Double_t ;
    Double_t* br3 = new Double_t ;
    tree->Branch("mbc", br1, "mbc/D");
    tree->Branch("de", br2, "de/D");
    tree->Branch("dp", br3, "dp/D");

    FILE* file = fopen("kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat","r");
    int i=0;
    while (!feof(file)) {
	double fmbc,fde,fdp;
	if (fscanf(file,"%lf %lf %lf", &fmbc,&fde,&fdp) == 3) {
	    *br1 = fmbc;
	    *br2 = fde;
            *br3 = fdp;
	    tree->Fill();
	    i++;
	}
	if (i >= 4000) break;
    }
    fclose(file);

    //variables
    RooRealVar mbc("mbc", "M_{bc} (MeV)", 1700, 1900);
    RooRealVar de("de", "#Delta E (MeV)", -300, 300);
    Double_t minP=-1000;
    Double_t maxP=1000;
    RooRealVar dp("dp", "#Delta P (MeV)", minP, maxP);

    //===========================================================================================
    // Construct unbinned dataset importing tree branches
    RooDataSet data("data", "data", RooArgSet(mbc, de, dp), Import(*tree));
    //===========================================================================================

    double par[30];

    par[0] = 1864.0;  //mean_mbc
    par[1] = -7.0;    //mean_de
    par[2] = 0.0015;  //mbcde_corr
    par[3] = 1.2;     //mbc_sigma0
    par[5] = 110.;    //sigma_de
    par[8] = 50.0;    //mbc_sigma2
    par[9] = 90.0;    //mbcw_shift
    par[10] = 0.10;   //mbcw_frac
    par[11] = 80.0;   //mbcw_sigma
    par[12] = 240.0;  //sigma_de2
    par[13] = -0.016; //mbcdew_corr
    par[14] = -1.0;   //dpcurv
    par[15] = 50.0;   //mbc_sigma4

    //==========================================================================================
    //Create Gauss #1 for dE
    RooRealVar mean_de("mean_de", "mean of gauss for signal peak", par[0], -10, 10);
    RooRealVar sigma_de("sigma_de", "width of gauss for signal peak", par[5], 30.0, 120.0);
    RooGaussian gauss_de("gauss_de", "gauss for signal peak", de, mean_de, sigma_de);
    //Create Gauss #1 for Mbc
    //=========================Mbc=================================================================
    //double dmbc = mbc - mbc_mean - mbcde_corr*dde;
    RooRealVar mean_mbc("mean_mbc", "mean of gauss for Mbc", par[1], 1855, 1880);
    RooRealVar mbcde_corr("mbcde_corr", "correlation coefficient between dE and Mbc", par[2], 0., 0.5);
    RooFormulaVar mean_mbc_wCor("mean_mbc_wCor","mean_mbc + mbcde_corr*(de-mean_de)",RooArgSet(mbc,mean_mbc,mbcde_corr,de,mean_de));
    //double mbc_sigma_l = sqrt(pow(mbc_sigma0_l,2) + pow(fr*mbc_sigma2,2.) + pow(fr*fr*mbc_sigma4,2.));
    RooRealVar mbc_sigma0("mbc_sigma0","mbc_sigma0",par[3],-3.,3.);
    RooRealVar mbc_sigma2("mbc_sigma2","mbc_sigma2",par[8],30.,80.);
    RooRealVar mbc_sigma4("mbc_sigma4","mbc_sigma4",par[15],40.,80.);
    //double fr = fabs(dp)/1000.;
    RooFormulaVar sigma_mbc("sigma_mbc","sqrt(pow(mbc_sigma0,2) + pow(abs(dp)/1000.*mbc_sigma2,2) + pow((abs(dp)/1000.*abs(dp)/1000.*mbc_sigma4),2))",RooArgSet(dp,mbc_sigma0,mbc_sigma2,mbc_sigma4));
    //RooRealVar sigma_mbc("sigma_mbc", "width of gauss for signal peak", 5, 0.0, 10);
    RooGaussian gauss_mbc("gauss_mbc", "gauss for signal peak", mbc, mean_mbc_wCor, sigma_mbc);
    //===============================================================================================

    RooRealVar dpcurv("dpcurv", "dpcurv", par[14], -2.0, 2.0);
    RooGenericPdf dpsig("dpsig","abs(1.+dp*dp*dpcurv/1000./1000.)",RooArgSet(dp,dpcurv));

    //second prod of gauss
    //=================================================================================================
    //Create Gauss #2 for dE and Mbc
    RooRealVar sigma_de2("sigma_de2", "width of gauss for signal peak", par[12], 0.0, 250.0);
    RooGaussian gauss_de2("gauss_de2", "gauss for signal peak", de, mean_de, sigma_de2);

    //dmbc = mbc - mbc_mean - mbcdew_corr*dde - mbcw_shift;
    //double mbcsig2 = fabs(mbcw_frac)*exp(-dmbc*dmbc/2./mbcw_sigma/mbcw_sigma)/mbcw_sigma;
    RooRealVar mbcw_frac("mbcw_frac", "mbcw_frac", par[10], 0.0, 0.50);
    RooRealVar mbcdew_corr("mbcdew_corr", "mbcdew_corr", par[13], -2.0, 2.0);
    RooRealVar mbcw_shift("mbcw_shift", "mbcw_shift", par[9], 0.0, 100.0);
    RooRealVar mbcw_sigma("mbcw_sigma", "mbcw_sigma", par[11], 0.0, 100.0);

    RooGenericPdf gauss_mbc2("gauss_mbc2","abs(mbcw_frac)*exp(-pow((mbc-mean_mbc-mbcdew_corr*(de-mean_de)-mbcw_shift),2)/2./mbcw_sigma/mbcw_sigma)/mbcw_sigma",RooArgSet(mbcw_frac,mbc,mean_mbc,mbcdew_corr,de,mean_de,mbcw_shift,mbcw_sigma));

    //====================Total model for Signal================================================================================
    //RooGenericPdf Sig_model("Sig_model", "dpsig*(gauss_de*gauss_mbc)", RooArgSet(dpsig, gauss_de, gauss_mbc));
    RooGenericPdf Sig_model("Sig_model", "dpsig*(gauss_de*gauss_mbc + abs(mbcw_frac)*gauss_de2*gauss_mbc2)", RooArgSet(dpsig, gauss_de, gauss_mbc, mbcw_frac, gauss_de2, gauss_mbc2));

    Sig_model.fitTo(data,PrintLevel(3));

    RooPlot* mbc_frame = mbc.frame();
    data.plotOn(mbc_frame);
    Sig_model.plotOn(mbc_frame);

    RooPlot* de_frame = de.frame();
    data.plotOn(de_frame);
    Sig_model.plotOn(de_frame);

    RooPlot* dp_frame = dp.frame();
    data.plotOn(dp_frame);
    Sig_model.plotOn(dp_frame);

    TCanvas *c = new TCanvas("Signal", "Signal", 1200, 400);
    c->Divide(3);
    c->cd(1);
    mbc_frame->Draw();
    c->cd(2);
    de_frame->Draw();
    c->cd(3);
    dp_frame->Draw();
}

