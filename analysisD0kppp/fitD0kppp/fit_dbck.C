{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
  mid_de = 300.;
  mid_mbc = 1700.;
  /*
  load_sig("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat");
  read_par("par/dbck.par", 14, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
  gen_dbck("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/dbck_S1.0_A6.0_Z0.0.gen", 100000, dbck_par, 0.);
  */

  //with ATC
  load_sig("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat");
  read_par("par/dbck.par", 14, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
  gen_dbck("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/dbck_S1.0_A6.0_Z0.0.gen", 100000, dbck_par, 0.);

}
