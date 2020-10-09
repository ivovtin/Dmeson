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
#include "KDB/kd_db.h"

using namespace std;

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

    int start_run, stop_run;
    int run=0;
    double err = 0;
    double slum = 0;
    int tt=0;
    double en=0, en_err=0, lum=0;
    int t;

    int nbads=0;

    string line;
    //int line;
    int i=0;
    //ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runs2004/allrunsDmeson2005"); //signal
    ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_signal_20042020.dat"); //signal
    //ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_signal_25112019.dat"); //signal
    if (in.is_open())
    {
	while (getline(in, line))
	{
	    i++;
	    run = atoi(line.c_str());

	    get_run_lumi(run, &en, &en_err, &lum, &t);
	    //if( lum*0.001<0.50 && run>=4100 && run<=4709 ) {
	    if( lum*0.001<1.00 && run>=23206 && run<=26248 ) {
		//printf("%i %d %f %f %f %d\n",i,run,en,en_err,lum*0.001,t);
		printf("%d\n",run);
                nbads++;
	    }
	    //if( lum<100000 ) slum += lum*0.001;  //nb^-1
	    //if( lum<100000 && run>=4100 && run<=4709 ) slum += lum*0.001;  //nb^-1
            //if( lum*0.001<0.50 && run>=4100 && run<=4709 ) slum += lum*0.001;  //nb^-1
            if( lum*0.001<1.00 && run>=23206 && run<=26248 ) slum += lum*0.001;  //nb^-1
	    //if( lum<100000 && run>=24613 && run<=25687 ) slum += lum*0.001;  //nb^-1
	}
    }
    in.close();

    printf("Total Lumi = %f\n", slum);
    printf("Number bad runs = %i\n", nbads);
}
