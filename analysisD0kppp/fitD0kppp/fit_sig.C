{
  gROOT.LoadMacro("fit.cpp+");

  init();

  //num_norm = 2000000;
  num_norm = 1000000;
  mid_de = 100.;
  mid_mbc = 1850.;

  /*
  load_sig("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kppp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat");
  //read_par("par/sig_def.par", 30, sig_par, sig_epar);
  read_par("par/sig.par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  gen_sig("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/sig_S1.0_A6.0_Z0.0.gen", num_sig, sig_par, 0.);
  */

  //with ATC
  load_sig("dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kppp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat");
  //read_par("par/sig_def.par", 30, sig_par, sig_epar);
  read_par("par/sig.par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  gen_sig("gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/sig_S1.0_A6.0_Z0.0.gen", num_sig, sig_par, 0.);

}
