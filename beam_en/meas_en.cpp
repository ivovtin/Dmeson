#include <unistd.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <algorithm>
#include <math.h>
#include <cfortran.h>
#include<stdlib.h>
#include "stdio.h"
#include <cstdio>
#include <cstdlib>

#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <Riostream.h>
#include <sstream>
#include <TPad.h>
#include <TGraph.h>
#include <TGraphErrors.h>
#include <TTree.h>
#include <TF1.h>
#include <TMath.h>
#include "TFile.h"
#include "TVirtualPad.h"
#include <iomanip>
#pragma hdrstop
#include<stdio.h>
#include<stdlib.h>
#include <TH1.h>
#include <TH2.h>
#include <TH3.h>
#include <TStyle.h>
#include <TLine.h>
#include <TEventList.h>
#include <TProfile.h>
#include <vector>
#include "TRandom3.h"
#include <math.h>
#include "TVirtualFitter.h"
#include <algorithm>
#include <assert.h>
#include "TLegend.h"

#include "KDB/kd_db.h"

using namespace std;

inline char* timestamp(time_t t)
{
    static const char* time_fmt="%b %d %Y %H:%M:%S";
    static char strtime[50];

    struct tm* brtm=localtime(&t);
    strftime(strtime,50,time_fmt,brtm);

    return strtime;
}

void get_run_lumi(int run, double *en, double *en_err, double *lum, int *t) {
  int array[8];
  KdDbConn* conn;
  KDBruninfo runinfo;
  int id;

  conn = kd_db_open(NULL);
  id = kd_db_get_id("runenergy",conn);
  if (kd_db_get_for_run_int(id, run, conn, array, 8)) {
    *en = array[1]/1e6;
    *en_err = array[2]/1e6;
  }
  if (kd_db_get_run_info(run, 1, conn, &runinfo))
  *lum = runinfo.intelum;
  *t = runinfo.livesec;
  kd_db_close(conn);
}

int main(int argc, char** argv) {

    int year;

    TString KEDR, list_runs;
    TH1F* hEn[3];
    TH1F* herrEn[3];

    TH1F* hx[2];
    TH1F* hy[2];
    TH1F* hz[2];
    TH1F* hsx[2];
    TH1F* hsy[2];
    TH1F* hsz[2];
    TProfile* pr[2];
    TProfile* prtime[2];

    double s_lum_er_en_beam[2];
    double slum[2];

    for(int key=0; key<=1; key++)
    {
	if(key==0) year=2016;
	if(key==1) year=2004;

	if(year==2016){
	    KEDR = "/home/ovtin/public_html/outDmeson/demo/";
	    list_runs = "/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_2016-17_good.dat";
	}
	else{
	    KEDR = "/home/ovtin/public_html/outDmeson/demo/";
	    list_runs = "/home/ovtin/development/Dmeson/runsDmeson/runs2004/goodruns.dat";
	}

        hEn[key] = new TH1F("Energy of beam","Energy of beam",100,1885.,1890.);
        herrEn[key] = new TH1F("Energy error of beam","Energy error of beam",200,-0.0,0.060);

	hx[key] = new TH1F("x","x",100,-0.5,0.0);
	hy[key] = new TH1F("y","y",100,0.5,1.0);
	hz[key] = new TH1F("z","z",100,-2.0,1.0);
	hsx[key] = new TH1F("sx","sx",100,-0.05,0.1);
	hsy[key] = new TH1F("sy","sy",100,-0.05,0.1);
	hsz[key] = new TH1F("sz","sz",100,0.0,1.0);

        if(key==0) pr[key]=new TProfile("Energy_Run","Energy_Run",693,23206.,26248.,1880.,1890);
        if(key!=0) pr[key]=new TProfile("Energy_Run_2004","Energy_Run_2004",482,4100.,4709.,1880.,1890);

	if(key==0) prtime[key]=new TProfile("Energy_Time","Energy_Time",3042,1454284800,1514592000,1880.,1890);
        if(key!=0) prtime[key]=new TProfile("Energy_Time_2004","Energy_Time_2004",3042,1099176021,1104086421,1880.,1890);

	int run;
	string line;
	int i=0;
	ifstream in(list_runs);
	if (in.is_open())
	{
	    while (getline(in, line))
	    {
		i++;
		run = atoi(line.c_str());

		static const int lum_table_id=2007, lum_table_length=7;
		static const int e_table_id=2119, e_table_length=16;

		static float lum_e=0, lum_p=0;
		float beam_energy=0;
		float err_beam_energy=0;
		static float dbbeam_energy=0;

		int buflum[lum_table_length];
		int bufenergy[e_table_length];

		double en=0, en_err=0, lum=0;
		int t;
		get_run_lumi(run, &en, &en_err, &lum, &t);

		KDBconn *conn = kdb_open();

		if (!conn) {
		    printf("Can not connect to database\n");
		}

		time_t runTime_begin=kdb_run_get_begin_time(conn, run);
		time_t runTime_end=kdb_run_get_end_time(conn, run);
		cout<<"Begin time of Run"<<run<<": "<<timestamp(runTime_begin)<<endl;
		cout<<"End time of Run"<<run<<": "<<timestamp(runTime_end)<<endl;
                /*
		if( kdb_read_for_run(conn,lum_table_id,run,buflum,lum_table_length) ) {
		    lum_p=buflum[0]*1E-3;
		    lum_e=buflum[1]*1E-3;
                    cout<<"lum_e="<<lum_e<<endl;
		}
		*/

		kdb_setver(conn,0);
		if( kdb_read_for_run(conn,e_table_id,run,bufenergy,e_table_length) ) {
		    beam_energy=bufenergy[1]*1E-6;
		    err_beam_energy=bufenergy[2]*1E-6;
		}

		int Vrt[32];
                kdb_read_for_run(conn,1214,run,Vrt,32);
                cout<<"x="<<Vrt[2]*0.0001<<"\t"<<"y="<<Vrt[3]*0.0001<<"\t"<<"z="<<Vrt[4]*0.0001<<endl;
                cout<<"sigma_x="<<Vrt[8]*0.0001<<"\t"<<"sigma_y="<<Vrt[9]*0.0001<<"\t"<<"sigma_z="<<Vrt[10]*0.0001<<endl;
		hx[key]->Fill(Vrt[2]*0.0001);
		hy[key]->Fill(Vrt[3]*0.0001);
		hz[key]->Fill(Vrt[4]*0.0001);
		hsx[key]->Fill(Vrt[8]*0.0001);
		hsy[key]->Fill(Vrt[9]*0.0001);
		hsz[key]->Fill(Vrt[10]*0.0001);

		int RunStatus=1;                                       //0-information in the start run; 1-information in the end run; 2 - information in the pause run
		KDBruninfo runinfo;
		if( kdb_run_get_info(conn,run,RunStatus,&runinfo) ) {
		    dbbeam_energy=runinfo.E_setup*1E-3;
		}
		kdb_close(conn);

                if( lum<100000 )
		{
		    s_lum_er_en_beam[key] += lum*0.001*err_beam_energy;
		    slum[key] += lum*0.001;
		}

		printf("RUN DB INFO: i=%d Run=%d  En=%1.4f+-%1.4f\n",i,run,beam_energy,err_beam_energy);
                cout<<"lum = "<<lum*0.001<<"\t"<<"s_lum_er_en_beam = "<<s_lum_er_en_beam[key]<<endl;
	    /*
            if (run==23307 || run==23313 || run==23342 || run==23353 || run==23423
	       || run==23429 || run==23466 || run==23467 || run==23470 || run==23562
               || run==23564 || run==23626 || run==23632 || run==23635 || run==23636
	       || run==23642 || run==23643 || run==23656 || run==23658 || run==23663
	       || run==23665 || run==23666 || run==23667 || run==23668 || run==23669
	       || run==23674 || run==23675 || run==23677 || run==23678 || run==23679
               || run==23688 || run==23689 || run==23691 || run==23693 || run==23694
               || run==23695 || run==23696 || run==23702 || run==23703 || run==23704
               || run==23706 || run==23707 || run==23708 || run==23709 || run==23710
               || run==23712 || run==23713 || run==23714 || run==23721 || run==23722
               || run==23723 || run==23724 || run==23725 || run==23727 || run==23746
               || run==23747 || run==23748 || run==23749 || run==23755 || run==23756
               || run==23757 || run==23759 || run==23809 || run==23811 || run==23812
               || run==23813 || run==23814 || run==23815 || run==23817 || run==23819
               || run==23820 || run==23822 || run==23823 || run==23824 || run==23825
               || run==23826 || run==23828 || run==23829 || run==23830 || run==23831
               || run==23833 || run==23834 || run==23835 || run==23836 || run==23838
               || run==23858 || run==23859 || run==23860 || run==23861 || run==23867
               || run==23868 || run==23869 || run==23872 || run==23876 || run==23877
               || run==23881 || run==23882 || run==23893 || run==23895 || run==23898
               || run==23900 || run==23904 || run==23917 || run==23937 || run==23940
               || run==24814 || run==24819 || run==24821 || run==24822 || run==24831
               || run==24844 || run==24845 || run==24851 || run==24859 || run==24866
               || run==24867 || run==24870 || run==24876 || run==24893 || run==24904
               || run==24915 || run==24916 || run==25064 || run==25074 || run==25079
               || run==25105 || run==25158 || run==25159 || run==25173 || run==25176
               || run==25177 || run==25179 || run==25182 || run==25183 || run==25184
               || run==25198 || run==25200 || run==25209 || run==25210 || run==25211
               || run==25212 || run==25214 || run==25219 || run==25222 || run==25223
               || run==25225 || run==25226 || run==25227 || run==25228 || run==25230
               || run==25236 || run==25347 || run==25349 || run==25351 || run==25358
               || run==25359 || run==25371 || run==25403 || run==25404 || run==25405
               || run==25407 || run==25409 || run==25410 || run==25411 || run==25413
               || run==25414 || run==25415 || run==25421 || run==25423 || run==25425
               || run==25433 || run==25435 || run==25444 || run==25514 || run==25515
               || run==25519 || run==25520 || run==25523 || run==25524 || run==25569
               || run==25599 || run==25605 || run==25622 || run==25628 || run==25637
               || run==25684 || run==26058 || run==26059 || run==26062 || run==26063
               || run==26064 || run==26065 || run==26072 || run==26073 || run==26074
               || run==26075 || run==26077 || run==26078 || run==26079 || run==26091
               || run==26093 || run==26094 || run==26095 || run==26096 || run==26098
               || run==26100 || run==26101 || run==26126 || run==26127 || run==26128
               || run==26129 || run==26131 || run==26132 || run==26133 || run==26134
               || run==26147 || run==26148 || run==26150 || run==26151
	       )   //noise >=8%
	    { */
		hEn[key]->Fill(beam_energy);
		herrEn[key]->Fill(err_beam_energy);

		pr[key]->Fill(run,beam_energy);
		prtime[key]->Fill(runTime_begin,beam_energy);

	    //}
	    }
	}
	in.close();
    }

    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    //gStyle->SetOptStat(1);
    gStyle->SetOptFit(1011);

    TCanvas *cc1 = new TCanvas();
    cc1->cd();

    //for(int k=0; k<=1; k++)
    for(int k=0; k<1; k++)
    {
	//hEn[k]->Draw();    cc1->SaveAs(KEDR+"hEn.png");
	//herrEn[k]->Draw(); cc1->SaveAs(KEDR+"herrEn.png");
	hx[k]->GetXaxis()->SetTitle("x, cm");   hx[k]->Draw();    cc1->SaveAs(KEDR+"hx.png");
	hy[k]->GetXaxis()->SetTitle("y, cm");   hy[k]->Draw();    cc1->SaveAs(KEDR+"hy.png");
	hz[k]->GetXaxis()->SetTitle("z, cm");   hz[k]->Draw();    cc1->SaveAs(KEDR+"hz.png");
	hsx[k]->GetXaxis()->SetTitle("#sigma_x, cm");  hsx[k]->Draw();    cc1->SaveAs(KEDR+"hsx.png");
	hsy[k]->GetXaxis()->SetTitle("#sigma_y, cm");  hsy[k]->Draw();    cc1->SaveAs(KEDR+"hsy.png");
	hsz[k]->GetXaxis()->SetTitle("#sigma_z, cm");  hsz[k]->Draw();    cc1->SaveAs(KEDR+"hsz.png");
    }

    /////////////////////////
    hEn[2] = new TH1F("Energy of beam","Energy of beam",100,1885.,1890.);
    herrEn[2] = new TH1F("Energy error of beam","Energy error of beam",200,-0.0,0.060);

    FILE* file = fopen(TString("beamen.dat").Data(),"r");
    while (!feof(file)) {
	double run,ebeam,err_ebeam,var;
	if (fscanf(file,"%lf %lf %lf %lf", &run,&ebeam,&err_ebeam,&var) == 4) {
	    hEn[2]->Fill(ebeam);
	    herrEn[2]->Fill(err_ebeam);
	}
    }
    fclose(file);
    /////////////////////////

    gStyle->SetOptStat(0);

    TCanvas *cc2 = new TCanvas();
    cc2->cd();
    hEn[0]->SetLineWidth(2);
    hEn[0]->SetLineColor(kRed);
    hEn[0]->GetXaxis()->SetTitle("E_{beam}, MeV");
    hEn[0]->GetYaxis()->SetTitle("a.u.");
    hEn[0]->GetYaxis()->SetRangeUser(0., 130.);
    //hEn[0]->GetYaxis()->SetRangeUser(0., 30.);
    hEn[0]->Draw();
    hEn[1]->SetLineWidth(2);
    hEn[1]->SetLineColor(kBlue);
    hEn[1]->Draw("same");
    hEn[2]->SetLineWidth(2);
    hEn[2]->SetLineColor(kGreen);
    //hEn[2]->Draw("same");
    //TLegend *leg1 = new TLegend(0.1,0.7,0.48,0.9);
    //TLegend *leg1 = new TLegend(0.1,0.7,0.38,0.8);
    //TLegend *leg1 = new TLegend(0.2,0.7,0.30,0.8);
    //TLegend *leg1 = new TLegend(0.15,0.6,0.35,0.8);
    TLegend *leg1 = new TLegend(0.15,0.7,0.30,0.8);
    leg1->AddEntry(hEn[0],"2016-17","l");
    leg1->AddEntry(hEn[1],"2004","l");
    //leg1->AddEntry(hEn[2],"2004 - result 2010","l");
    leg1->Draw("same");
    cc2->SaveAs("/spool/users/ovtin/outDmeson/demo/hEn.png");
    cc2->SaveAs("/spool/users/ovtin/outDmeson/demo/hEn.eps");

    gStyle->SetOptTitle(1);
    TCanvas *cc3 = new TCanvas();
    cc3->cd();
    herrEn[0]->SetLineWidth(2);
    herrEn[0]->SetLineColor(kRed);
    herrEn[0]->SetTitle("Error of beam energy");
    herrEn[0]->GetXaxis()->SetTitle("#Delta E_{beam}, MeV");
    herrEn[0]->GetYaxis()->SetTitle("a.u.");
    herrEn[0]->Draw();
    herrEn[1]->SetLineWidth(2);
    herrEn[1]->SetLineColor(kBlue);
    //herrEn[1]->Draw("same");
    herrEn[2]->SetLineWidth(2);
    herrEn[2]->SetLineColor(kGreen);
    //herrEn[2]->Draw("same");
    //TLegend *leg2 = new TLegend(0.1,0.7,0.48,0.9);
    //TLegend *leg2 = new TLegend(0.35,0.55,0.65,0.75);
    TLegend *leg2 = new TLegend(0.40,0.65,0.65,0.75);
    leg2->AddEntry(herrEn[0],"2016-2017","l");
    //leg2->AddEntry(herrEn[1],"2004","l");
    //leg2->AddEntry(herrEn[2],"2004 - result 2010","l");
    leg2->Draw("same");
    //cc3->SaveAs("/spool/users/ovtin/outDmeson/demo/herrEn.png");
    //cc3->SaveAs("/spool/users/ovtin/outDmeson/demo/herrEn.eps");
    cc3->SaveAs("/spool/users/ovtin/outDmeson/demo/herrEn2016.png");
    cc3->SaveAs("/spool/users/ovtin/outDmeson/demo/herrEn2016.eps");

    gStyle->SetOptStat(0);
    gStyle->SetOptTitle(0);
    TCanvas *cc4 = new TCanvas();
    cc4->cd();
    pr[0]->SetMarkerStyle(20);
    pr[0]->SetMarkerSize(0.5);
    pr[0]->SetMarkerColor(kRed);
    pr[0]->SetLineWidth(2);
    pr[0]->SetLineColor(kRed);
    pr[0]->GetXaxis()->SetTitleSize(0.05);
    pr[0]->GetXaxis()->SetTitleOffset(1.0);
    pr[0]->GetXaxis()->SetLabelSize(0.05);
    pr[0]->GetXaxis()->SetNdivisions(510);
    pr[0]->GetYaxis()->SetRangeUser(1882., 1890.);
    pr[0]->GetYaxis()->SetTitleSize(0.05);
    pr[0]->GetYaxis()->SetTitleOffset(1.00);
    pr[0]->GetYaxis()->SetLabelSize(0.05);
    pr[0]->GetYaxis()->SetNdivisions(205);
    pr[0]->GetYaxis()->SetDecimals();
    pr[0]->GetXaxis()->SetTitle("Run");
    pr[0]->GetYaxis()->SetTitle("E_{beam}, MeV");
    pr[0]->SetTitle("");
    pr[0]->Draw();
    cc4->SaveAs("/spool/users/ovtin/outDmeson/demo/Run_Ebeam_2016.png");
    cc4->SaveAs("/spool/users/ovtin/outDmeson/demo/Run_Ebeam_2016.eps");

    TCanvas *cc5 = new TCanvas();
    cc5->cd();
    pr[1]->SetMarkerStyle(20);
    pr[1]->SetMarkerSize(0.5);
    pr[1]->SetMarkerColor(kBlue);
    pr[1]->SetLineWidth(2);
    pr[1]->SetLineColor(kBlue);
    pr[1]->GetXaxis()->SetTitleSize(0.05);
    pr[1]->GetXaxis()->SetTitleOffset(1.0);
    pr[1]->GetXaxis()->SetLabelSize(0.05);
    pr[1]->GetXaxis()->SetNdivisions(510);
    pr[1]->GetYaxis()->SetRangeUser(1882., 1890.);
    pr[1]->GetYaxis()->SetTitleSize(0.05);
    pr[1]->GetYaxis()->SetTitleOffset(1.00);
    pr[1]->GetYaxis()->SetLabelSize(0.05);
    pr[1]->GetYaxis()->SetNdivisions(205);
    pr[1]->GetYaxis()->SetDecimals();
    pr[1]->GetXaxis()->SetTitle("Run");
    pr[1]->GetYaxis()->SetTitle("E_{beam}, MeV");
    pr[1]->SetTitle("");
    pr[1]->Draw();
    cc5->SaveAs("/spool/users/ovtin/outDmeson/demo/Run_Ebeam_2004.png");
    cc5->SaveAs("/spool/users/ovtin/outDmeson/demo/Run_Ebeam_2004.eps");

    TCanvas *cc6 = new TCanvas();
    cc6->cd();
    prtime[0]->SetMarkerStyle(20);
    prtime[0]->SetMarkerSize(0.5);
    prtime[0]->SetMarkerColor(kRed);
    prtime[0]->SetLineWidth(2);
    prtime[0]->SetLineColor(kRed);
    prtime[0]->GetXaxis()->SetTimeDisplay(1);
    prtime[0]->GetXaxis()->SetTimeFormat("%d/%m/%y%F1970-01-01 00:00:00");
    prtime[0]->GetXaxis()->SetTitleSize(0.05);
    prtime[0]->GetXaxis()->SetTitleOffset(1.0);
    prtime[0]->GetXaxis()->SetLabelSize(0.05);
    prtime[0]->GetXaxis()->SetNdivisions(205);
    prtime[0]->GetYaxis()->SetRangeUser(1882., 1890.);
    prtime[0]->GetYaxis()->SetTitleSize(0.05);
    prtime[0]->GetYaxis()->SetTitleOffset(1.00);
    prtime[0]->GetYaxis()->SetLabelSize(0.05);
    prtime[0]->GetYaxis()->SetNdivisions(205);
    prtime[0]->GetYaxis()->SetDecimals();
    prtime[0]->GetXaxis()->SetTitle("Time(d/m/y)");
    prtime[0]->GetYaxis()->SetTitle("E_{beam}, MeV");
    prtime[0]->SetTitle("");
    prtime[0]->Draw();
    cc6->SaveAs("/spool/users/ovtin/outDmeson/demo/Time_Ebeam_2016.png");
    cc6->SaveAs("/spool/users/ovtin/outDmeson/demo/Time_Ebeam_2016.eps");

    TCanvas *cc7 = new TCanvas();
    cc7->cd();
    prtime[1]->SetMarkerStyle(20);
    prtime[1]->SetMarkerSize(0.5);
    prtime[1]->SetMarkerColor(kBlue);
    prtime[1]->SetLineWidth(2);
    prtime[1]->SetLineColor(kBlue);
    prtime[1]->GetXaxis()->SetTimeDisplay(1);
    prtime[1]->GetXaxis()->SetTimeFormat("%d/%m/%y%F1970-01-01 00:00:00");
    prtime[1]->GetXaxis()->SetTitleSize(0.05);
    prtime[1]->GetXaxis()->SetTitleOffset(1.0);
    prtime[1]->GetXaxis()->SetLabelSize(0.05);
    prtime[1]->GetXaxis()->SetNdivisions(205);
    prtime[1]->GetYaxis()->SetRangeUser(1882., 1890.);
    prtime[1]->GetYaxis()->SetTitleSize(0.05);
    prtime[1]->GetYaxis()->SetTitleOffset(1.00);
    prtime[1]->GetYaxis()->SetLabelSize(0.05);
    prtime[1]->GetYaxis()->SetNdivisions(205);
    prtime[1]->GetYaxis()->SetDecimals();
    prtime[1]->GetXaxis()->SetTitle("Time(d/m/y)");
    prtime[1]->GetYaxis()->SetTitle("E_{beam}, MeV");
    prtime[1]->SetTitle("");
    prtime[1]->Draw();
    cc7->SaveAs("/spool/users/ovtin/outDmeson/demo/Time_Ebeam_2004.png");
    cc7->SaveAs("/spool/users/ovtin/outDmeson/demo/Time_Ebeam_2004.eps");

    for(int k=0; k<=1; k++)
    {
        cout<<"Total lumi = "<<slum[k]<<endl;
	cout<<"sMd = "<<s_lum_er_en_beam[k]/slum[k]<<endl;
    }


    return 0;
}
