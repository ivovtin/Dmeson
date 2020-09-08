#include <unistd.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <algorithm>    // std::min_element, std::max_element
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

    string line;
    //int line;
    int i=0;
    ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_Psi2_signal_20042020.dat"); //signal
    //ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runs_list_Psi3770_signal_25112019.dat"); //signal
    //ifstream in("/home/ovtin/development/Dmeson/runsDmeson/runsIgnoreList.txt"); //signal
    if (in.is_open())
    {
	while (getline(in, line))
	{
	    i++;
	    run = atoi(line.c_str());

	    //==============================================

	    //list bad runs for 2016-17
	    if (
		run==23209
		|| run==23211
		|| run==23911
		|| run==23700
		|| run==23699
		|| run==23792
		|| run==23745
		|| run==24850
		|| run==24852
		|| run==24860
		|| run==25086
		|| run==25172
		|| run==25174
		|| run==25175
		|| run==25217
		|| run==25233
		|| run==25327
		|| run==25331
		|| run==25337
		|| run==25338
		|| run==25357
		|| run==25360
		|| run==25365
		|| run==25368
		|| run==25369
		|| run==25370
		|| run==25598
		|| run==25658
		|| run==25659
		|| run==26070
		|| run==26071
		|| run==26099
		|| run==26246
	       ) continue;

            //==============================================

	    get_run_lumi(run, &en, &en_err, &lum, &t);
	    printf("%i %d %f %f %f %d\n",i,run,en,en_err,lum*0.001,t);
	    if( lum<100000 ) slum += lum*0.001;  //nb^-1
	    //if( lum<100000 && run>=24613 && run<=25687 ) slum += lum*0.001;  //nb^-1
	}
    }
    in.close();

    printf("Total Lumi = %f\n", slum);
}
