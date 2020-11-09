{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

//  load_sig("dat/kp_exp_1.030.dat");
//  load_sig("dat/kp_exp.dat");
  load_sig("/home/ovtin/development/Dmeson/analysisD0/kp_2004_pcor.dat");
//  load_sig("/home/ovtin/development/Dmeson/analysisD0/kp_2016-17_pcor.dat");
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
  dpcut=0;

  fit_exp();
  write_par("par/exp_fit.par", 5, exp_par, exp_epar);
//  read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double maj = gen_exp("gen/exp_def.gen", 100000, exp_par, 0.);

  double mdcorr = 1864.6 + (exp_par[0]-mdsig) +
                  0.00*(exp_par[1]-desig);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  double tmp_par[5];

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[3] = 0.;
//  gen_maj("gen/exp_sig.gen", 10000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[3] = 0.;
  tmp_par[4] = 0.;
//  gen_maj("gen/exp_bck.gen", 10000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[4] = 0.;
//  gen_maj("gen/exp_dbck.gen", 10000000, tmp_par, maj);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);


}
