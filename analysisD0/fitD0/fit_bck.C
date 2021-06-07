{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 900000;
  mid_de = 300.;
  mid_mbc = 1700.;

  
  load_sig("/store/users/ovtin/outDmeson/D0/results/fitsD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0.dat");
  read_par("par/bck_uds.par", 4, bck_par, bck_epar);
  fit_bck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/bck_uds_S1.0_A6.0_Z0.0.par", 4, bck_par, bck_epar);
  gen_bck("/store/users/ovtin/outDmeson/D0/results/fitsD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/bck_uds_S1.0_A6.0_Z0.0.gen", 100000, bck_par, 0.);
  
  /*
  // w/o ATC
  load_sig("/store/users/ovtin/outDmeson/D0/results/fitsD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat");
  read_par("par/bck_uds.par", 4, bck_par, bck_epar);
  fit_bck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/bck_uds_S1.0_A6.0_Z0.0.par", 4, bck_par, bck_epar);
  gen_bck("/store/users/ovtin/outDmeson/D0/results/fitsD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/bck_uds_S1.0_A6.0_Z0.0.gen", 100000, bck_par, 0.);
  */
}
