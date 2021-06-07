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
  bool atc = 1;

  if( key==2004 ) {
      infile = "dat/kp_exp_1.030_2004.dat";
      exp_def = "gen/exp_def_2004.gen";
      exp_sig = "gen/exp_sig_2004.gen";
      exp_bck = "gen/exp_bck_2004.gen";
      exp_dbck = "gen/exp_dbck_2004.gen";
      exp_fit_par = "par/exp_fit_2004.par";
  }
  else{
      if(atc){
         infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_ATC_1.0155.dat";
         exp_def = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_def_S1.0_A6.0_Z0.0.gen";
         exp_sig = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_sig_S1.0_A6.0_Z0.0.gen";
         exp_bck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_bck_S1.0_A6.0_Z0.0.gen";
         exp_dbck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_dbck_S1.0_A6.0_Z0.0.gen";
         exp_fit_par = "par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_fit_S1.0_A6.0_Z0.0.par";
      }
      else{
         infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0155.dat";
         exp_def = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_def_S1.0_A6.0_Z0.0.gen";
         exp_sig = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_sig_S1.0_A6.0_Z0.0.gen";
         exp_bck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_bck_S1.0_A6.0_Z0.0.gen";
         exp_dbck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_dbck_S1.0_A6.0_Z0.0.gen";
         exp_fit_par = "par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_fit_S1.0_A6.0_Z0.0.par";
      }
  }

  //load_sig("dat/kp_exp_1.030.dat");
  load_sig(infile);

  read_par("par/exp_init.par", 5, exp_par, exp_epar);

  if(atc){
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/bck_uds_S1.0_A6.0_Z0.0.par", 4, bck_par, bck_epar);
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/dbck_sim_S1.0_A6.0_Z0.0.par", 16, dbck_par, dbck_epar);
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  }
  else{
     read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/bck_uds_S1.0_A6.0_Z0.0.par", 4, bck_par, bck_epar);
     read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/dbck_sim_S1.0_A6.0_Z0.0.par", 16, dbck_par, dbck_epar);
     read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  }

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
