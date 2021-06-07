Double_t fitFunction(Double_t *x, Double_t *par) {
    Double_t mbcfit;
    float y,mb,eb,s,s2;
    mb = par[0];
    eb = 1888.;
    s = par[2]+(x[0]-mb-1864.5)*par[8];
    s2 = par[6]+(x[0]-mb-1864.5)*par[7];
    if ( x<eb )
    {
	y = 1.-x[0]**2/eb**2;
	mbcfit = par[3]*x[0]*sqrt(y)*TMath::Exp(-par[4]*y)+par[9]*x[0]*sqrt(y)*TMath::Exp(-par[10]*y)*(1+par[11]*y+par[12]*y**2+par[13]*y**3);
    }
    else
    {
        mbcfit = 0;
    }

    Double_t arg = 0;
    arg = (x[0]-mb-1864.5);
    mbcfit = mbcfit + par[1]*((1-par[5])*TMath::Exp(-arg*arg/2./(s*s))/s + par[6]*TMath::Exp(-arg*arg/2./(s2*s2))/s2);


}

void fit_signal()
{
    //TH1F *hmbc=new TH1F("M_{bc}","M_{bc}",50,1700.,1900.);
    TH3F *h3=new TH3F("m_{bc}:de:dp","m_{bc}:de:dp",50,1700.,1900.,100,-300,300,100,-200,200);

    FILE* file = fopen("/home/ovtin/development/Dmeson/analysisD0/fitD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC.dat","r");
    int i=0;
    while (!feof(file)) {
	double mbc,de,dp;
	if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
	    h3->Fill(mbc,de,dp);
	    //hmbc->Fill(mbc);
	    i++;
	}
    }

    TF1 *func = new TF1("fitMbc",fitFunction,1700,1900,13);
    func->SetParameter(0,1863.264967);    //mbc_mean
    func->SetParameter(1,-2.280427);      //de_mean
    func->SetParameter(2,-0.000289);      //mbcde_corr
    func->SetParameter(3,0.354540);       //mbc_sigma0_l
    func->SetParameter(4,7.232129);       //mbc_sigma0_r
    func->SetParameter(5,104.357033);     //de_sigma
    func->SetParameter(6,1888.750000);    //ebeam
    func->SetParameter(7,53.201323);      //bck
    func->SetParameter(8,19.465609);      //mbc_sigma2
    func->SetParameter(9,3.171292);       //mbcw_shift
    func->SetParameter(10,0.209450);      //mbcw_frac
    func->SetParameter(11,18.988612);     //mbcw_sigma
    func->SetParameter(12,214.768013);    //dew_sigma
    func->SetParameter(13,-0.003456);     //mbcdew_corr

    //TF1 *func = new TF1("fitMbc",fitFunction,1850,1890,3);
    // Sets initial values and parameter names
    //func->SetParameters(100,1865.,0.200);
    //func->SetParNames("Constant","Mean_value","Sigma");

    /*
    appl comis quit
        real function mbcfit(x)
        common/pawpar/par(14)
        vector bins(3)
        real x,y,mb,eb,s2
        mb = par(1)
        eb = 1888.
        s = par(3)+(x-mb-1864.5)*par(9)
        s2 = par(7)+(x-mb-1864.5)*par(8)
        if (x.lt.eb) then
                y = 1.-x**2/eb**2
                mbcfit = par(4)*x*sqrt(y)*exp(-par(5)*y)+
     +                   par(10)*x*sqrt(y)*exp(-par(11)*y)*
     +                   (1+par(12)*y+par(13)*y**2+par(14)*y**3)
        else
                mbcfit = 0
        endif
        mbcfit = mbcfit + par(2)*
     +  ((1-par(6))*exp(-(x-mb-1864.5)**2/2./s**2)/s+
     +  par(6)*exp(-(x-mb-1864.5)**2/2./s2**2)/s2)
     +          /sqrt(2*3.141592)*(bins(3)-bins(2))/bins(1)
        end
     quit
      */

    //hmbc->Fit("fitMbc");
    h3->Draw("E1");
}
