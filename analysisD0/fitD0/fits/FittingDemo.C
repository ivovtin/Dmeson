// Quadratic background function
Double_t background(Double_t *x, Double_t *par) {
    return par[0] + par[1]*x[0] + par[2]*x[0]*x[0];
}

// Lorentzian Peak function
Double_t lorentzianPeak(Double_t *x, Double_t *par) {
    return (0.5*par[0]*par[1]/TMath::Pi())/TMath::Max(1.e-10,(x[0]-par[2])*(x[0]-par[2])+ .25*par[1]*par[1]);
}

// Sum of background and peak function
Double_t fitFunction(Double_t *x, Double_t *par) {
    return background(x,par) + lorentzianPeak(x,&par[3]);
}

void FittingDemo() {
    // bevington exercise by P. Malzacher, modified by R. Brun
    const int nBins = 60;
    Stat_t data[nBins] = {  6, 1,10,12, 6,13,23,22,15,21,
    23,26,36,25,27,35,40,44,66,81,
    75,57,48,45,46,41,35,36,53,32,
    40,37,38,31,36,44,42,37,32,32,
    43,44,35,33,33,39,29,41,32,44,
    26,39,29,35,32,21,21,15,25,15};
    TH1F *histo = new TH1F("example_9_1","Lorentzian Peak on Quadratic Background",60,0,3);

    for(int i=0; i < nBins;  i++) {
	// we use these methods to explicitly set the content
	// and error instead of using the fill method.
	histo->SetBinContent(i+1,data[i]);
	histo->SetBinError(i+1,TMath::Sqrt(data[i]));
    }
    // create a TF1 with the range from 0 to 3 and 6 parameters
    TF1 *fitFcn = new TF1("fitFcn",fitFunction,0,3,6);

    // first try without starting values for the parameters
    // this defaults to 1 for each param.
    histo->Fit("fitFcn");
    // this results in an ok fit for the polynomial function however
    // the non-linear part (Lorentzian
}
