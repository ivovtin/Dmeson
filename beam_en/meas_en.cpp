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


int main(int argc, char** argv) {

    int year;

    TString KEDR, list_runs;
    TH1F* hEn[2];
    TH1F* herrEn[2];

    for(int key=0; key<=1; key++)
    {
	if(key==0) year=2016;
	if(key==1) year=2004;

	if(year==2016){
	    KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v11/";
	    list_runs = "/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_2016-17_good.dat";
	}
	else{
	    KEDR = "/home/ovtin/public_html/outDmeson/D0/data2004Pcorr/";
	    list_runs = "/home/ovtin/development/Dmeson/runsDmeson/runs2004/goodruns.dat";
	}

        hEn[key] = new TH1F("Energy of beam","Energy of beam",100,1885.,1890.);
        herrEn[key] = new TH1F("Energy error of beam","Energy error of beam",100,-0.0,0.010);

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

		KDBconn *conn = kdb_open();

		if (!conn) {
		    printf("Can not connect to database\n");
		}

		time_t runTime_begin=kdb_run_get_begin_time(conn, run);
		time_t runTime_end=kdb_run_get_end_time(conn, run);
		cout<<"Begin time of Run"<<run<<": "<<timestamp(runTime_begin)<<endl;
		cout<<"End time of Run"<<run<<": "<<timestamp(runTime_end)<<endl;

		if( kdb_read_for_run(conn,lum_table_id,run,buflum,lum_table_length) ) {
		    lum_p=buflum[0]*1E-3;
		    lum_e=buflum[1]*1E-3;
		}
		kdb_setver(conn,0);
		if( kdb_read_for_run(conn,e_table_id,run,bufenergy,e_table_length) ) {
		    beam_energy=bufenergy[1]*1E-6;
		    err_beam_energy=bufenergy[2]*1E-6;
		}

		int RunStatus=1;                                       //0-information in the start run; 1-information in the end run; 2 - information in the pause run
		KDBruninfo runinfo;
		if( kdb_run_get_info(conn,run,RunStatus,&runinfo) ) {
		    dbbeam_energy=runinfo.E_setup*1E-3;
		}
		kdb_close(conn);

		printf("RUN DB INFO: i=%d Run=%d  En=%1.4f+-%1.4f\n",i,run,beam_energy,err_beam_energy);
		hEn[key]->Fill(beam_energy);
		herrEn[key]->Fill(err_beam_energy);
	    }
	}
	in.close();
    }

    gStyle->SetOptTitle(0);
    //gStyle->SetOptStat(1111);
    gStyle->SetOptStat(0);
    gStyle->SetOptFit(1011);

    TCanvas *cc1 = new TCanvas();
    cc1->cd();

    for(int k=0; k<=1; k++)
    {
	hEn[k]->Draw(); cc1->SaveAs(KEDR+"hEn.png");
	herrEn[k]->Draw(); cc1->SaveAs(KEDR+"herrEn.png");
    }

    TCanvas *cc2 = new TCanvas();
    cc2->cd();
    hEn[0]->SetLineWidth(2);
    hEn[0]->SetLineColor(kRed);
    hEn[0]->GetXaxis()->SetTitle("Beam energy, MeV");
    hEn[0]->GetYaxis()->SetRangeUser(0., 130.);
    hEn[0]->Draw();
    hEn[1]->SetLineWidth(2);
    hEn[1]->SetLineColor(kBlue);
    hEn[1]->Draw("same");
    //TLegend *leg1 = new TLegend(0.1,0.7,0.48,0.9);
    //TLegend *leg1 = new TLegend(0.1,0.7,0.38,0.8);
    TLegend *leg1 = new TLegend(0.2,0.7,0.30,0.8);
    leg1->AddEntry(hEn[0],"2016","l");
    leg1->AddEntry(hEn[1],"2004","l");
    leg1->Draw("same");
    cc2->SaveAs("/spool/users/ovtin/outDmeson/demo/hEn.png");

    TCanvas *cc3 = new TCanvas();
    cc3->cd();
    herrEn[0]->SetLineWidth(2);
    herrEn[0]->SetLineColor(kRed);
    herrEn[0]->GetXaxis()->SetTitle("Error beam energy, MeV");
    herrEn[0]->Draw();
    herrEn[1]->SetLineWidth(2);
    herrEn[1]->SetLineColor(kBlue);
    herrEn[1]->Draw("same");
    //TLegend *leg2 = new TLegend(0.1,0.7,0.48,0.9);
    TLegend *leg2 = new TLegend(0.3,0.7,0.48,0.8);
    leg2->AddEntry(hEn[0],"2016","l");
    leg2->AddEntry(hEn[1],"2004","l");
    leg2->Draw("same");
    cc3->SaveAs("/spool/users/ovtin/outDmeson/demo/herrEn.png");

    return 0;
}
