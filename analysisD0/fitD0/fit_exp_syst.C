{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

//  load_sig("dat/kp_exp_1.030.dat");
  load_sig("dat/kp_signal_novp.dat");
  read_par("par/exp_fit.par", 5, exp_par, exp_epar);
  read_par("par/bck_uds.par", 4, bck_par, bck_epar);
  read_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  read_par("par/sig_corr.par", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];
  
  sig_par[7] = 0;

//  exp_epar[0] = 0.;
//  exp_epar[1] = 0.;
//  fit_exp();
//  exp_epar[0] = 0.1;
//  exp_epar[1] = 1.;

  fit_exp();
//  write_par("par/exp_fit.par", 5, exp_par, exp_epar);
//  read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double mdcorr = 1864.6 + (exp_par[0]-mdsig) + 
                  0.00*(exp_par[1]-desig);
                  
  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

}
