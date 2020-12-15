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

using namespace std;

int main(int argc, char** argv) {

    TH1F* hde=new TH1F("#Delta E","#Delta E",30,-300.,300.);
    TH1F* hmbc=new TH1F("M_{bc}","M_{bc}",55,1790.,1900.);
    TH1F* hde2=new TH1F("#Delta E2","#Delta E2",30,-300.,300.);
    TH1F* hmbc2=new TH1F("M_{bc}2","M_{bc}2",55,1790.,1900.);

    //FILE* file1 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/old/kpp_exp_tof2.dat","r");
    //FILE* file1 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/old/kpp_exp_old.dat","r");
    //FILE* file1 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/old/kpp_exp_tof.dat","r");
    //FILE* file1 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/old/kpp_exp_tof3.dat","r");
    //FILE* file1 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/old/kpp_exp_notof.dat","r");
    //FILE* file1 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/old/kpp_exp_fake.dat","r");
    //FILE* file1 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/old/kpp_exp_fake2.dat","r");
    //FILE* file1 = fopen("/spool/users/vd_group/dmass/fit/kpp_massfit_modtof/dat/kpp_exp_modtof.dat","r");
    //FILE* file1 = fopen("/spool/users/vd_group/dmass/fit/kpp_massfit_tight/dat/kpp_exp_tight.dat","r");      //best
    //FILE* file1 = fopen("/spool/users/vd_group/dmass/fit/kpp_massfit_tight0/dat/kpp_exp_tight0.dat","r");
    FILE* file1 = fopen("/spool/users/vd_group/dmass/fit/kpp_massfit/dat/kpp_exp_1.027.dat","r");              //best
    //FILE* file1 = fopen("/spool/users/vd_group/dmass/fit/kpp_massfit_high/dat/kpp_exp_high.dat","r");
    double mbc, de, dummy;
    while(!feof(file1)) {
	if (fscanf(file1,"%lf %lf %lf", &mbc, &de, &dummy) != 3) break;
	if( abs(de)<70 ) hmbc->Fill(mbc);
        if( abs(mbc-1870)<10 ) hde->Fill(de);
    }
    fclose(file1);

    FILE* file2 = fopen("/home/ovtin/development/Dmeson/analysisDplus/fitDplus/dat/kpp_2004.dat","r");
    double mbc2, de2, dummy2;
    while (!feof(file2)) {
	if (fscanf(file2,"%lf %lf %lf", &mbc2, &de2, &dummy2) != 3) break;
	if( abs(de2)<70 ) hmbc2->Fill(mbc2);
	if( abs(mbc2-1870)<10 ) hde2->Fill(de2);
    }
    fclose(file2);

    TCanvas *cc1 = new TCanvas();
    gStyle->SetOptTitle(0);
    gStyle->SetOptStat(1111);
    gStyle->SetOptFit(1011);
    cc1->cd();
    hmbc->GetXaxis()->SetTitle("M_{bc} (MeV)");
    hmbc->GetYaxis()->SetTitle("Events/2 MeV");
    hmbc->SetLineColor(kRed);
    hmbc->Sumw2();
    Double_t n1=hmbc->GetEntries();
    hmbc->Scale(1/n1);
    hmbc->Draw();
    hmbc2->SetLineColor(kBlue);
    hmbc2->Sumw2();
    Double_t n2=hmbc2->GetEntries();
    hmbc2->Scale(1/n2);
    hmbc2->Draw("SAME");
    cc1->SaveAs("mbc_compare.eps");
    cc1->SaveAs("mbc_compare.root");

    TCanvas *cc2 = new TCanvas();
    cc2->cd();
    hde->GetXaxis()->SetTitle("#Delta E (MeV)");
    hde->GetYaxis()->SetTitle("Events/20 MeV");
    hde->SetLineColor(kRed);
    hde->Sumw2();
    Double_t n3=hde->GetEntries();
    hde->Scale(1/n3);
    hde->Draw();
    hde2->SetLineColor(kBlue);
    hde2->Sumw2();
    Double_t n4=hde2->GetEntries();
    hde2->Scale(1/n4);
    hde2->Draw("SAME");
    cc2->SaveAs("de_compare.eps");
    cc2->SaveAs("de_compare.root");

    return 0;
}
