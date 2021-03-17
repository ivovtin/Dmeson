void draw_crossec()
{
    gStyle->SetPalette(1);
    gStyle->SetPadGridX(kTRUE);
    gStyle->SetPadGridY(kTRUE);

    /*
    TGraph *g = new TGraph("rccs2_def.dat", "%*s %lg %lg");
    g->Draw("AL");
    */
    /*
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
    */

    /*
    FILE *f = fopen("/home/ovtin/development/Dmeson/simulation/simDplus/rccs.dat","r");
    Int_t i=0;
    float n[100];
    float e[100],cross[100],e_mean[100];
    float total_cross;
    float cross_cor[100];
    while (!feof(f)){
	fscanf(f,"%f %f %f\n",&n[i],&e[i],&cross[i]);
        e_mean[i]=e[i]/2;
	cout<<"i="<<i<<"\t"<<"e="<<e[i]<<"\t"<<"cross="<<cross[i]<<endl;
        //cross_cor[i]=5.2924*cross[i];
	total_cross+=cross[i];
	i++;
    }
    cout<<"Sum of cross = "<<total_cross<<endl;
    TGraph *gr = new TGraph(i,e_mean,cross);
    gr->SetMarkerStyle(21);
    gr->Draw("alp");

    //cout << "Integral = " << gr->Integral(0,i) << endl;
    cout << "Integral = " << gr->Integral() << endl;
    */


    //FILE *f = fopen("crosssection_BESIII_2017_eetoD0D0.dat","r");
    FILE *f = fopen("crosssection_BESIII_2017_eetoD+D-.dat","r");
    Int_t i=0;
    float n[34];
    float e[34],cross[34],cross2[34];
    while (!feof(f)){
	fscanf(f,"%f %f %f\n",&n[i],&e[i],&cross[i]);
	cout<<"i="<<i<<"\t"<<"e="<<e[i]<<"\t"<<"cross="<<cross[i]<<endl;
	//cross2[i]=cross[i]/98.4194;
        cross2[i]=cross[i]/87.6202;
        //cout<<"\t"<<i<<"\t"<<e[i]<<"\t"<<cross2[i]<<"\t"<<endl;
        //printf ("%.6f\n", cross2[i]);
        i++;
    }
    //TGraph *gr = new TGraph(i,e,cross);
    TGraph *gr = new TGraph(i,e,cross2);
    gr->SetMarkerStyle(21);
    gr->Draw("alp");
    cout<<gr->Integral()<<endl;

    Int_t ii=0;
    float e_spline[101],cross_spline[101];
    Double_t ev,x;
    for ( Double_t k = 3734.0; k <= 3864.0; k+=1.3) {
      ev = gr->Eval(k);           //Interpolate points in this graph at x using a TSpline.
      printf("        %d  %g     %g\n", ii+1, k, ev);
      e_spline[ii]=k;
      cross_spline[ii]=ev;
      ii++;
    }

    TGraph *gr2 = new TGraph(ii,e_spline,cross_spline);
    gr2->SetMarkerStyle(22);
    gr2->SetLineColor(kRed);
    gr2->Draw("same, alp");

}



