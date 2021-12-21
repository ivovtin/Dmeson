{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
  //mid_de = 100.;
  //mid_mbc = 1700.;

  TString dataFile;
  TString dat_dirname;
  TString gen_dirname;
  TString par_dirname;
  TString infile;
  TString exp_def;
  TString exp_sig;
  TString exp_bck;
  TString exp_dbck;
  TString exp_fit_par;

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
	  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_tof_atc_ATC.dat";
	  gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600_test";
	  par_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600_test";

	  infile = "dat/" + dat_dirname + "/" + dataFile;
	  exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0.par";
	  gSystem->Exec("mkdir gen/" + gen_dirname);
	  exp_def = "gen/" + gen_dirname + "/exp_def_S1.0_A6.0_Z0.0.gen";
	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
      else{
	  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150.dat";
	  gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
	  par_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";

	  infile = "dat/" + dat_dirname + "/" + dataFile;
	  exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0.par";
          gSystem->Exec("mkdir gen/" + gen_dirname);
	  exp_def = "gen/" + gen_dirname + "/exp_def_S1.0_A6.0_Z0.0.gen";
	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
  }

  load_sig(infile);

  //read_par("par/exp_tof2.par", 5, exp_par, exp_epar);
  //read_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/exp_fit_S1.0_A6.0_Z0.0.par", 5, exp_par, exp_epar);
  read_par("par/exp_fit_S1.0_A6.0_Z0.0_test.par", 5, exp_par, exp_epar);

  read_par("par/" + par_dirname + "/bck_S1.0_A6.0_Z0.0.par", 5, bck_par, bck_epar);
  read_par("par/" + par_dirname + "/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
  read_par("par/" + par_dirname + "/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

  exp_par[5] = bck_par[0];
  exp_epar[5] = bck_epar[0];
  exp_par[6] = bck_par[1];
  exp_epar[6] = bck_epar[1];

  sig_par[7] = 0;  // Zero Dbck fraction

  //exp_epar[0] = 0.;
  //exp_epar[1] = 0.;
  //fit_exp();

  //exp_epar[0] = 0.1;
  //exp_epar[1] = 1.;

  fit_exp();
  write_par(exp_fit_par, 5, exp_par, exp_epar);
  //read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double maj = gen_exp(exp_def, 100000, exp_par, 0.);

  double mdcorr = 1869.5 + (exp_par[0]-mdsig) +
                  0.008*(exp_par[1]-desig);
  //                 0.012*(exp_par[1]-desig);

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
