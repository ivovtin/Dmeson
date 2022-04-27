#include <iomanip>
#include "TRandom3.h"
#include "TRandom1.h"

TRandom1 *r1=new TRandom1();
//TRandom3 *r1=new TRandom3();

void draw_crossec_rnd()
{
    gStyle->SetPalette(1);
    gStyle->SetPadGridX(kTRUE);
    gStyle->SetPadGridY(kTRUE);

    TCanvas c1("c1","c1",800,600);
    c1.cd();

    TString pref_out = "BESIII_2017_eetoD0D0";
    //TString pref_out = "BESIII_2017_eetoD+D-";
    TString dir_out="/home/ovtin/public_html/outDmeson/crossection/";
    TString filename = "crosssection_BESIII_2017.dat";

    //TString syst = "none";
    //TString syst = "plus";
    //TString syst = "minus";
    TString syst = "rnd";

    float normD0 = 0;
    float normDp = 0;

    FILE *file1 = fopen(TString(filename).Data(),"r");
    Int_t i=0;
    float n[34];
    float e[34],crossD0[34],er_crossD0[34],crossDp[34],er_crossDp[34],cross2[34];
    while (!feof(file1)){
	fscanf(file1,"%*f %f %f %f %f %f\n",&e[i],&crossD0[i],&er_crossD0[i],&crossDp[i],&er_crossDp[i]);
	if(syst=="none")
	{
	    crossD0[i] = crossD0[i];
	    crossDp[i] = crossDp[i];
	}
	if(syst=="plus")
	{
	    crossD0[i] = crossD0[i] + er_crossD0[i];
	    crossDp[i] = crossDp[i] + er_crossDp[i];
	}
	if(syst=="minus")
	{
	    crossD0[i] = crossD0[i] - er_crossD0[i];
	    crossDp[i] = crossDp[i] - er_crossDp[i];
	}
	if(syst=="rnd")
	{
            normD0 = r1->Gaus(crossD0[i],er_crossD0[i]);
	    normDp = r1->Gaus(crossDp[i],er_crossDp[i]);
            //normD0 = r1->Uniform(crossD0[i]-er_crossD0[i],crossD0[i]+er_crossD0[i]);
	    //normDp = r1->Uniform(crossDp[i]-er_crossDp[i],crossDp[i]+er_crossDp[i]);
	    cout<<"crossD0="<<crossD0[i]<<"\t"<<"normD0="<<normD0<<"\t"<<"er_crossD0="<<er_crossD0[i]<<endl;
	    cout<<"crossDp="<<crossDp[i]<<"\t"<<"normDp="<<normDp<<"\t"<<"er_crossDp="<<er_crossDp[i]<<endl;
            crossD0[i] = normD0;
            crossDp[i] = normDp;
	}
	if( crossD0[i]<0. ) crossD0[i]=0.;
	if( crossDp[i]<0. ) crossDp[i]=0.;
	i++;
    }
    cout<<"i="<<i<<endl;
    TGraph *gr1 = new TGraph(i,e,crossD0);
    gr1->SetMarkerStyle(21);
    gr1->Draw("alp");
    TGraph *gr2 = new TGraph(i,e,crossDp);
    gr2->SetMarkerStyle(21);
    gr2->Draw("alp");

    //cout << "Integral = " << gr->Integral(0,i) << endl;
    cout << "Integral_gr1 = " << gr1->Integral() << endl;
    cout << "Integral_gr2 = " << gr2->Integral() << endl;

    for(int i=0; i<34; i++){
	cout<<"i="<<i<<"\t"<<"e="<<e[i]<<"\t"<<"crossD0="<<crossD0[i]<<"\t"<<"crossDp="<<crossDp[i]<<endl;
	if ( pref_out == "BESIII_2017_eetoD0D0")
	{
	    cross2[i]=crossD0[i]/gr1->Integral();
	}else{
	    cross2[i]=crossDp[i]/gr2->Integral();
	}
    }

    TGraph *gr3 = new TGraph(i,e,cross2);
    gr3->SetMarkerStyle(21);
    gr3->Draw("alp");
    cout<<gr3->Integral()<<endl;

    Int_t ii=0;
    float e_spline[101],cross_spline[101];
    Double_t ev,x;
    ofstream outFile;
    outFile.open ("crossection_new.dat");
    for ( Double_t k = 3734.0; k <= 3864.0; k+=1.3) {
      ev = gr3->Eval(k);           //Interpolate points in this graph at x using a TSpline.
      printf("        %d  %g     %g\n", ii+1, k, ev);
      if((ii+1)<10){
	  outFile<<fixed<<setprecision(1)<<"         "<<ii+1<<"  "<<k;
      }
      else if((ii+1)==100){
	  outFile<<fixed<<setprecision(1)<<"       "<<ii+1<<"  "<<k;
      }
      else{
	  outFile<<fixed<<setprecision(1)<<"\t"<<ii+1<<"  "<<k;
      }
      outFile<<scientific<<setprecision(6)<<"     "<<ev<<"\n";
      e_spline[ii]=k;
      cross_spline[ii]=ev;
      ii++;
    }
    outFile.close();

    gSystem->Exec("sed -e 's/e/E/g' crossection_new.dat > crosssection_" + pref_out + "_" + syst + "_eval.dat");

    TGraph *gr4 = new TGraph(ii,e_spline,cross_spline);
    gr4->SetMarkerStyle(22);
    gr4->SetLineColor(kRed);
    //gr4->Draw("same, alp");

    c1.Update();
    if(syst=="none"){
	c1.SaveAs(dir_out + "crosssection_" + pref_out + ".png");
	c1.SaveAs(dir_out + "crosssection_" + pref_out + ".eps");
    }
    else{
	c1.SaveAs(dir_out + "crosssection_" + pref_out + "_" + syst + ".png");
	c1.SaveAs(dir_out + "crosssection_" + pref_out + "_" + syst +".eps");
    }

    /*
    TGraph *g = new TGraph("rccs2_def.dat", "%*s %lg %lg");
    g->Draw("AL");
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
    */
}
