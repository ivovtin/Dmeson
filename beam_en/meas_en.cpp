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

#include "KDB/kd_db.h"

using namespace std;

int main(int argc, char** argv) {

    int year=2004;

    TString KEDR, list_runs;

    if(year==2016){
	KEDR = "/home/ovtin/public_html/outDmeson/D0/dataPcorr_v11/";
	list_runs = "/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_2016-17_good.dat";
    }
    else{
	KEDR = "/home/ovtin/public_html/outDmeson/D0/data2004Pcorr/";
        list_runs = "/home/ovtin/development/Dmeson/runsDmeson/runs2004/goodruns.dat";
    }

    TH1F* hEn=new TH1F("Energy of beam","Energy of beam",100,1885.,1890.);
    TH1F* herrEn=new TH1F("Energy error of beam","Energy error of beam",100,-0.0,0.010);

    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    gStyle->SetOptFit(1011);
    cc1->cd();

    int run;
    string line;
    int i=0;
    ifstream in(list_runs); //signal - 2004
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
            hEn->Fill(beam_energy);
            herrEn->Fill(err_beam_energy);
	}
    }
    in.close();
    hEn->Draw(); cc1->SaveAs(KEDR+"hEn.png");
    herrEn->Draw(); cc1->SaveAs(KEDR+"herrEn.png");

    return 0;
}
