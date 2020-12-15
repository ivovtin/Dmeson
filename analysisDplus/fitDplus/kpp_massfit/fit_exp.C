{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

  load_sig("dat/kpp_2004.dat");
  read_par("par/exp_init.par", 5, exp_par, exp_epar);
  read_par("par/bck2_uds.par", 5, bck_par, bck_epar);
  read_par("par/dbck2_sim.par", 14, dbck_par, dbck_epar);
  read_par("par/sig_tof.fit", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

//  exp_epar[0] = 0.;
//  exp_epar[1] = 0.;
//  fit_exp();

//  exp_epar[0] = 0.1;
//  exp_epar[1] = 1.;

  fit_exp();
  write_par("par/exp_tof.par", 5, exp_par, exp_epar);
//  read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double maj = gen_exp("gen/exp_def.gen", 100000, exp_par, 0.);
  
  double mdcorr = 1869.4 + (exp_par[0]-mdsig) + 
                  0.0233*(exp_par[1]-desig);
                  
  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  double tmp_par[5]; 
  
  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[3] = 0.;
  gen_maj("gen/exp_sig.gen", 5000000, tmp_par, maj);
  
  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[3] = 0.;
  tmp_par[4] = 0.;
  gen_maj("gen/exp_bck.gen", 5000000, tmp_par, maj);
  
  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[4] = 0.;
  gen_maj("gen/exp_dbck.gen", 5000000, tmp_par, maj);
  
  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);
}
