#include "TROOT.h"
#include "TFile.h"
#include "TDirectory.h"
#include "TCanvas.h"
#include <vector>
#include <algorithm>
#include <TMultiGraph.h>
#include <TGraphErrors.h>
#include <Riostream.h>
#include <sstream>
#include <TCanvas.h>
#include <TPad.h>
#include <TGraph.h>
#include <TTree.h>
#include <TF1.h>
#include <TMath.h>
#include "TFile.h"
#include "TVirtualPad.h"
#include <TSystem.h>
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
#include <TLegend.h>
#include <vector>
#include <TChain.h>
#include "TMinuit.h"
#include "TRandom3.h"
#include <math.h>
#include "TVirtualFitter.h"
#include <algorithm>
#include <assert.h>

using namespace std;

int main(int argc, char* argv[])
{
    TString dir_in="/spool/users/ovtin/dcnoises/";
    TString result= dir_in + "draw_dcnoise";
    gSystem->Exec("mkdir "+ result);
    gSystem->Exec("cp /home/ovtin/public_html/index.php "+ result);
    gSystem->Exec("ln -s "+ result + " /home/ovtin/public_html/outDmeson/demo/draw_dcnoise");

    int Nev,Nrnd,NN;
    double N20w,N100w,N1,N2,N3;

    string line1;
    int run;
    vector<int> runs;

    ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_2016-17_good.dat"); //read files with runs
    if (in.is_open())
    {
	while (getline(in, line1))
	{
	    if( line1.size()>=1 && line1[0]!='#' )
	    {
		std::istringstream i_str1(line1);
		i_str1 >> run;
		if( run < 26152 )
		{
		    cout << run << endl;
		    runs.push_back(run);
		}
	    }
	}
    }
    in.close();
    cout << "runs readed..." << endl;
    /*
    TH2D* hDCnoise1 = new TH2D("DC noise, 20 wires","DC noise, 20 wires",3042,1454284800,1514592000,15,0,15);
    TH2D* hDCnoise2 = new TH2D("DC noise, 100 wires","DC noise, 100 wires",3042,1454284800,1514592000,15,0,15);
    */
    TH2D* hDCnoise1 = new TH2D("DC noise, 20 wires","DC noise, 20 wires",3042,23206,26248,25,0,25);
    TH2D* hDCnoise2 = new TH2D("DC noise, 100 wires","DC noise, 100 wires",3042,23206,26248,15,0,15);

    for (vector<int>::iterator it = runs.begin(); it != runs.end(); ++it )
    {
	cout<<*it<<endl;
	TString fin = dir_in + TString::Format("rewrite_out%d.dat",*it).Data();      //read file with dc noise
	string line2;
	ifstream inres(fin);
	if (inres.is_open())
	{
	    while (getline(inres, line2))
	    {
		if( line2.size()>=1 && line2[0]!='#' )
		{
		    std::istringstream i_str2(line2);
		    i_str2 >> Nev >> Nrnd >> NN >> N20w >> N100w >> N1 >> N2 >> N3;
		    //cout<<run<<"\t"<<Nev<<"\t"<<N20w<<endl;
		    //pr1[cnt]->Fill(key,Ksigma);
                    hDCnoise1->Fill(*it,N20w);
		    hDCnoise2->Fill(*it,N100w);
                    //if(N20w>=8.0) cout<<*it<<"\t"<<N20w<<endl;
		}
	    }
	}
	else {
	    cout << "Can't open input text file !"<<endl;
	}
	inres.close();
    }

    TCanvas c("c","c",1800,1200);
    c.Divide(1,2);
    c.cd(1);

    hDCnoise1->SetMarkerStyle(7);
    hDCnoise1->SetMarkerColor(38);
    hDCnoise1->SetMarkerSize(0.5);
    hDCnoise1->SetLineWidth(2);
    hDCnoise1->SetLineColor(1);
    //hDCnoise1->GetXaxis()->SetTimeDisplay(1);
    //hDCnoise1->GetXaxis()->SetTimeFormat("%d/%m/%y%F1970-01-01 00:00:00");
    //hDCnoise1->GetXaxis()->SetTitle("Time(d/m/y)");
    hDCnoise1->GetXaxis()->SetTitle("Runs");
    hDCnoise1->GetYaxis()->SetTitle("DC noise, %");
    hDCnoise1->Draw("");
    /*
    TLine l;
    l.SetLineColor(kRed);
    l.SetLineWidth(3);
    l.DrawLine(23560., 0., 23560., 25.); //1
    l.DrawLine(23943., 0., 23943., 25.); //2
    l.DrawLine(24870., 0., 24870., 25.); //3
    l.DrawLine(25198., 0., 25198., 25.); //4
    l.DrawLine(25524., 0., 25524., 25.); //5
    l.DrawLine(25687., 0., 25687., 25.); //6
    */
    gPad->Modified();
    c.cd(2);

    hDCnoise2->SetMarkerStyle(7);
    hDCnoise2->SetMarkerColor(38);
    hDCnoise2->SetMarkerSize(0.5);
    hDCnoise2->SetLineWidth(2);
    hDCnoise2->SetLineColor(1);
    hDCnoise2->GetXaxis()->SetTitle("Runs");
    hDCnoise2->GetYaxis()->SetTitle("DC noise, %");
    hDCnoise2->Draw("");
    /*TLine l2;
    l2.SetLineColor(kRed);
    l2.SetLineWidth(3);
    l2.DrawLine(23560., 0., 23560., 15.); //1
    l2.DrawLine(23943., 0., 23943., 15.); //2
    l2.DrawLine(24870., 0., 24870., 15.); //3
    l2.DrawLine(25198., 0., 25198., 15.); //4
    l2.DrawLine(25524., 0., 25524., 15.); //5
    l2.DrawLine(25687., 0., 25687., 15.); //6
    */
    gPad->Modified();

    c.Update();
    c.Print(result + "/" + "DCnoise.png");
    c.Print(result + "/" + "DCnoise.eps");
    c.Print(result + "/" + "DCnoise.root");

    cout << "End of program" << endl;
}
