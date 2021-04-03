#include <stdio.h>
#include "TVirtualFitter.h"
#include "TMinuit.h"
#include "TRandom3.h"
#include "TSystem.h"
#include "TTree.h"

void load_dat_file(TTree* tree, char* filename, int skip=0, int max=1000000) {
    Double_t* br1 = new Double_t ;
    Double_t* br2 = new Double_t ;
    Double_t* br3 = new Double_t ;
    tree->Branch("mbc", br1, "mbc/D");
    tree->Branch("de", br2, "de/D");
    tree->Branch("dp", br3, "dp/D");

  FILE* file = fopen(filename,"r");

  int num_sig = 0;
  int i=0;
  while (!feof(file)) {
     double fmbc,fde,fdp;
     if (fscanf(file,"%lf %lf %lf", &fmbc,&fde,&fdp) == 3) {
        if (i>=skip) {
 	    *br1 = fmbc;
	    *br2 = fde;
            *br3 = fdp;
	    tree->Fill();
	    num_sig++;
	    if (num_sig >= max) break;
        }
        i++;
      }
  }
  fclose(file);
}


void read_par(char * filename, int npar, double* par, double* epar) {
  printf("Reading file %s\n", filename);
 
  FILE* file = fopen(filename, "r");
  for (int i=0; i<npar; i++) {
    int dummy;
    fscanf(file, "%d %lf %lf", &dummy, &par[i], &epar[i]);
    printf("par(%d)=%f +- %f\n", i, par[i], epar[i]);
  }
  fclose(file);
 
}


void write_par(char* filename, int npar, double* par, double* epar) {
  FILE* file = fopen(filename, "w");
  for (int i=0; i<npar; i++) {
    fprintf(file, "%d %lf %lf\n", i, par[i], epar[i]);
  }
  fclose(file);
}


