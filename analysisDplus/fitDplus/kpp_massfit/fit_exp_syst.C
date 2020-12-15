#include "TString.h"

void do_fit(TString type) {
  load_sig("dat/kpp_exp_1.027.dat");
  read_par("par/exp_init.par", 5, exp_par, exp_epar);
  read_par("par/bck2_uds.par", 5, bck_par, bck_epar);
  read_par("par/dbck_sim.par", 14, dbck_par, dbck_epar);
  read_par("par/sig_corr.fit", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

  fit_exp();

  double mdcorr = 1869.4 + (exp_par[0]-mdsig) + 
                  0.0233*(exp_par[1]-desig);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  FILE* file = fopen("syst.dat","a");

  fprintf(file,"%s %f %f %f %f %f %f\n", type.Data(), mdsig, exp_par[0], exp_epar[0], 
          desig, exp_par[1], exp_epar[1]);

  fclose(file);
}

void do_fit2(TString type) {
  load_sig("dat/kpp_exp_1.027.dat");
  read_par("par/exp_init.par", 7, exp_par, exp_epar);
  read_par("par/bck2_uds.par", 5, bck_par, bck_epar);
  read_par("par/dbck2_sim.par", 14, dbck_par, dbck_epar);
  read_par("par/sig_corr.fit", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

  exp_par[5] = bck_par[0];
  exp_par[6] = bck_par[1];
  exp_epar[5] = bck_epar[0];
  exp_epar[6] = bck_epar[1];

  fit_exp2();

  double mdcorr = 1869.4 + (exp_par[0]-mdsig) + 
                  0.0233*(exp_par[1]-desig);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  FILE* file = fopen("syst.dat","a");

  fprintf(file,"%s %f %f %f %f %f %f\n", type.Data(), mdsig, exp_par[0], exp_epar[0], 
          desig, exp_par[1], exp_epar[1]);

  fclose(file);
}


void fit_exp_syst() {

  gROOT->LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

//  do_fit("corr");
//  do_fit("gm");
//  do_fit("g29");
//  do_fit("mm");
//  do_fit("mp");
//  do_fit("nr1");
//  do_fit("def");
//  do_fit2("udsfit");
//  do_fit("uds_notof");
//  do_fit("uds_notwist");
  do_fit("dbck_notof");
}
