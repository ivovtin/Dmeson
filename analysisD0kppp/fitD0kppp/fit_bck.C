{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 900000;
  mid_de = 300.;
  mid_mbc = 1700.;
  /*
  load_sig("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kppp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat");
  read_par("par/bck.par", 5, bck_par, bck_epar);
  fit_bck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/bck_S1.0_A6.0_Z0.0.par", 5, bck_par, bck_epar);
  gen_bck("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/bck_S1.0_A6.0_Z0.0.gen", 100000, bck_par, 0.);
  */

  //with ATC
  load_sig("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kppp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat");
  read_par("par/bck.par", 6, bck_par, bck_epar);
  fit_bck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/bck_S1.0_A6.0_Z0.0.par", 6, bck_par, bck_epar);
  gen_bck("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/bck_S1.0_A6.0_Z0.0.gen", 100000, bck_par, 0.);

}
