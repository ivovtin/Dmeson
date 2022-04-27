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

  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_TMVA";
  //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0200_atc_tof_dedx_tmva_0.70_ATC.dat";
  dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_tmva_0.70_ATC.dat";

  par_dirname = dat_dirname;
  gen_dirname = dat_dirname + "test";

  infile = "dat/" + dat_dirname + "/" + dataFile;
  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0200_test.par";
  exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0140_test.par";
  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0140.par";
  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0130.par";
  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0150.par";
  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0170.par";
  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0120.par";
  gSystem->Exec("mkdir gen/" + gen_dirname);
  exp_def = "gen/" + gen_dirname + "/exp_def_S1.0_A6.0_Z0.0.gen";
  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0.gen";
  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0.gen";
  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0.gen";

  load_sig(infile);

  read_par("par/exp.par", 5, exp_par, exp_epar);

  read_par("par/" + par_dirname + "/bck_S1.0_A6.0_Z0.0_tmva.par", 8, bck_tmva_par, bck_tmva_epar);
  read_par("par/" + par_dirname + "/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
  read_par("par/" + par_dirname + "/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

  //exp_par[5] = bck_par[0];
  //exp_epar[5] = bck_epar[0];
  //exp_par[6] = bck_par[1];
  //exp_epar[6] = bck_epar[1];

  sig_par[7] = 0;  // Zero Dbck fraction

  //exp_epar[0] = 0.;
  //exp_epar[1] = 0.;
  //fit_exp();

  //exp_epar[0] = 0.1;
  //exp_epar[1] = 1.;

  fit_exp_tmva();
  write_par(exp_fit_par, 5, exp_par, exp_epar);
  //read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double maj = gen_exp_tmva(exp_def, 100000, exp_par, 0.);

  double mdcorr = 1869.5 + (exp_par[0]-mdsig) +
                  0.008*(exp_par[1]-desig);
  //                 0.012*(exp_par[1]-desig);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  double tmp_par[5];

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[3] = 0.;
  gen_maj_tmva(exp_sig, 5000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[3] = 0.;
  tmp_par[4] = 0.;
  gen_maj_tmva(exp_bck, 5000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[4] = 0.;
  gen_maj_tmva(exp_dbck, 5000000, tmp_par, maj);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);
}
