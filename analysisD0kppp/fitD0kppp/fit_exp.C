{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
  //mid_de = 100.;
  //mid_mbc = 1700.;

  char *infile;
  char *exp_def;
  char *exp_sig;
  char *exp_bck;
  char *exp_dbck;
  char *exp_fit_par;

  int key = 2016;
  bool atc = 1;

  if( key==2004 ) {
      infile = "dat/kpp_2004.dat";
      exp_def = "gen/exp_def_2004.gen";
      exp_sig = "gen/exp_sig_2004.gen";
      exp_bck = "gen/exp_bck_2004.gen";
      exp_dbck = "gen/exp_dbck_2004.gen";
      exp_fit_par = "par/exp_fit_2004.par";
  }
  else{
      if(atc){
	  infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_ATC.dat";
	  //infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0135_ATC.dat";
	  //infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0125_ATC.dat";
	  //infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0165_ATC.dat";
	  //infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_ntrphe1.5_ATC.dat";
	  exp_def = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_def_S1.0_A6.0_Z0.0.gen";
	  exp_sig = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_dbck_S1.0_A6.0_Z0.0.gen";
	  exp_fit_par = "par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/exp_fit_S1.0_A6.0_Z0.0.par";
      }
      else{
	  infile = "dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150.dat";
	  exp_def = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_def_S1.0_A6.0_Z0.0.gen";
	  exp_sig = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_dbck_S1.0_A6.0_Z0.0.gen";
	  exp_fit_par = "par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_fit_S1.0_A6.0_Z0.0.par";
      }
  }


  load_sig(infile);

  //read_par("par/exp_tof2.par", 5, exp_par, exp_epar);
  read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_fit_S1.0_A6.0_Z0.0.par", 5, exp_par, exp_epar);

  if(atc){
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/bck_S1.0_A6.0_Z0.0.par", 5, bck_par, bck_epar);
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  }
  else{
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/bck_S1.0_A6.0_Z0.0.par", 5, bck_par, bck_epar);
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
      read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  }

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
  write_par(exp_fit_par, 5, exp_par, exp_epar);
//  read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double maj = gen_exp(exp_def, 100000, exp_par, 0.);

  double mdcorr = 1869.5 + (exp_par[0]-mdsig) +
                  0.008*(exp_par[1]-desig);
//                  0.012*(exp_par[1]-desig);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  double tmp_par[5];

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[3] = 0.;
  gen_maj(exp_sig, 5000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[3] = 0.;
  tmp_par[4] = 0.;
  gen_maj(exp_bck, 5000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[4] = 0.;
  gen_maj(exp_dbck, 5000000, tmp_par, maj);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);
}
