void draw_crossec()
{
    gStyle->SetPalette(1);
    gStyle->SetPadGridX(kTRUE);
    gStyle->SetPadGridY(kTRUE);

    /*
    TGraph *g = new TGraph("rccs2_def.dat", "%*s %lg %lg");
    g->Draw("AL");
    */

    FILE *f = fopen("crosssection_BESIII_2017.dat","r");
    Int_t i=0;
    float n[100];
    float e[34],cross1[34],cross2[34];
    while (!feof(f)){
	fscanf(f,"%f %f %*f %f %*f\n",&e[i],&cross1[i],&cross2[i]);
	cout<<"i="<<i<<"\t"<<"e="<<e[i]<<"\t"<<"cross1="<<cross1[i]<<"\t"<<"cross2="<<cross2[i]<<endl;
	i++;
    }
    TGraph *gr = new TGraph(i,e,cross1);
    gr->SetMarkerStyle(21);
    gr->Draw("alp");

    /*
    FILE *f = fopen("rccs2_def.dat","r");
    Int_t i=0;
    float n[100];
    float e[100],cross[100],e_mean[100];
    while (!feof(f)){
	fscanf(f,"%f %f %f\n",&n[i],&e[i],&cross[i]);
        e_mean[i]=e[i]/2;
	cout<<"i="<<i<<"\t"<<"e="<<e[i]<<"\t"<<"cross="<<cross[i]<<endl;
	i++;
    }
    TGraph *gr = new TGraph(i,e_mean,cross);
    gr->SetMarkerStyle(21);
    gr->Draw("alp");
    */
}



