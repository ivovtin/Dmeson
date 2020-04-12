#include <stdio.h>
#include <math.h>
#include <string>
#include <unistd.h>
#include <iostream>
#include <sstream>
#include <fstream>
#include <string>
#include <list>
#include <algorithm>    // std::min_element, std::max_element
#include <cfortran.h>

#include "VDDCRec/kdcvd.h"
#include "ReadNat/read_nat_c.h"
#include "ReadNat/re_def.h"
#include "KDisplay/kdisplay_event.h"

#include <cfortran.h>
#include <hbook.h>

using namespace std;

int loop(int run1, int run2) {
  char fname[256];
  int run, stat;
  cout<<"run1="<<run1<<"\t"<<"run2="<<run2<<endl;
  for (run=run1; run<=run2; run++) {
    sprintf(fname,"/space/runs/daq%6.6d.nat.bz2",run);
    int stat;
    kedr_open_nat(fname,&stat);
    while(1) {
      kedr_read_nat(&stat);
      if (stat) break;

      FILE* file = fopen("run_event.dat","r");
      while (!feof(file)) {
        double r,ev;
        if (fscanf(file,"%lf %lf",&r, &ev) == 2) {
          if ((int)r == run && (int)ev == kedrraw_.Header.Number) {
            int recselect;
            kdcvdrec(0,&recselect);
            kdisplay_event();
          }
        }
      }
      fclose(file);
    }
    kedr_close_nat(&stat);
  }
  return (1);
}

int main(int argc, char *argv[]) {
  int run1, run2;

  if (argc < 3) return(0);

  sscanf(argv[1],"%d",&run1);
  sscanf(argv[2],"%d",&run2);

  loop(run1, run2);

  return 0;
}
