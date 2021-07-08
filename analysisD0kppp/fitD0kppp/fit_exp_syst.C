{
  gROOT.LoadMacro("fit.cpp+");

  TString type = "tof2";
//  TString type = "moddedx";

  init();

  num_norm = 2000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

//  load_sig("dat/kpp_exp_tof2.dat");
  load_sig("dat/kpp_signal_nopair.dat");
  read_par("par/exp_tof2.par", 5, exp_par, exp_epar);
  read_par("par/bck.par", 5, bck_par, bck_epar);
  read_par("par/dbck.par", 14, dbck_par, dbck_epar);
  read_par("par/sig_corr.par", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

  exp_par[5] = bck_par[0];
  exp_epar[5] = bck_epar[0];
  exp_par[6] = bck_par[1];
  exp_epar[6] = bck_epar[1];

  sig_par[7] = 0;  // Zero Dbck fraction

//  exp_epar[0] = 0.;
//  exp_epar[1] = 0.;
//  fit_exp();

//  exp_epar[0] = 0.1;
//  exp_epar[1] = 1.;

  fit_exp();
  
  double mdcorr = 1869.4 + (exp_par[0]-mdsig) - 
                  0.008*(exp_par[1]-desig);
                  
  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

}
