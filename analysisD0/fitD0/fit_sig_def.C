{
  gROOT.LoadMacro("fit.cpp+");

  init();

  //num_norm = 2000000;
  //num_norm = 1000;   //01:25:39
  //num_norm = 20000;  //01:03:16
  //num_norm = 200000; //00:54:53
  //num_norm = 1000000;
  //num_norm = 500000;
  num_norm = 1000000;  //nev*60
  mid_de = 100.;
  mid_mbc = 1850.;

  
  load_sig("/store/users/ovtin/outDmeson/D0/results/fitsD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0.dat");
  //load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_signal_def.dat", 10000.);
  read_par("par/sig_def.par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  //gen_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/sig_def.gen", num_sig, sig_par, 0.);
  gen_sig("/store/users/ovtin/outDmeson/D0/results/fitsD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_S1.0_A6.0_Z0.0.gen", num_sig, sig_par, 0.);
  
  /*
  // w/o ATC
  load_sig("/store/users/ovtin/outDmeson/D0/results/fitsD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat");
  read_par("par/sig_def.par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  gen_sig("/store/users/ovtin/outDmeson/D0/results/fitsD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/sig_S1.0_A6.0_Z0.0.gen", num_sig, sig_par, 0.);
  */
}
