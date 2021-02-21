{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

  char *infile;
  char *exp_def;
  char *exp_sig;
  char *exp_bck;
  char *exp_dbck;
  char *exp_fit_par;

  int key = 2016;

  if( key==2004 ) {
      infile = "dat/kp_exp_1.030_2004.dat";
      exp_def = "gen/exp_def_2004.gen";
      exp_sig = "gen/exp_sig_2004.gen";
      exp_bck = "gen/exp_bck_2004.gen";
      exp_dbck = "gen/exp_dbck_2004.gen";
      exp_fit_par = "par/exp_fit_2004.par";
  }
  else{
      
      infile = "dat/kp_exp_1.0173_2016-17.dat";
      exp_def = "gen/exp_def.gen";
      exp_sig = "gen/exp_sig.gen";
      exp_bck = "gen/exp_bck.gen";
      exp_dbck = "gen/exp_dbck.gen";
      exp_fit_par = "par/exp_fit.par";
      /*
      infile = "dat/kp_exp_1.0173_2016-17_woDCnoise.dat";
      exp_def = "gen/exp_def_woDCnoise.gen";
      exp_sig = "gen/exp_sig_woDCnoise.gen";
      exp_bck = "gen/exp_bck_woDCnoise.gen";
      exp_dbck = "gen/exp_dbck_woDCnoise.gen";
      exp_fit_par = "par/exp_fit_woDCnoise.par";
      */
  }

  //load_sig("dat/kp_exp_1.030.dat");
  load_sig(infile);
  
  read_par("par/exp_init.par", 5, exp_par, exp_epar);
  read_par("par/bck_uds.par", 4, bck_par, bck_epar);
  read_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  //read_par("par/sig_def.par", 30, sig_par, sig_epar);
  read_par("par/parold/sig_def.par", 30, sig_par, sig_epar);
  /*
  read_par("par/exp_init_woDCnoise.par", 5, exp_par, exp_epar);
  read_par("par/bck_uds_woDCnoise.par", 4, bck_par, bck_epar);
  read_par("par/dbck_sim_woDCnoise.par", 16, dbck_par, dbck_epar);
  read_par("par/sig_def_woDCnoise.par", 30, sig_par, sig_epar);
  */

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
  write_par(exp_fit_par, 5, exp_par, exp_epar);
//  read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double maj = gen_exp(exp_def, 100000, exp_par, 0.);

  //1864.84 - from PDG
  double mdcorr = 1864.84 + (exp_par[0]-mdsig) +
                  0.00*(exp_par[1]-desig);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  double tmp_par[5];

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[3] = 0.;
  gen_maj(exp_sig, 10000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[3] = 0.;
  tmp_par[4] = 0.;
  gen_maj(exp_bck, 10000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[4] = 0.;
  gen_maj(exp_dbck, 10000000, tmp_par, maj);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

}
