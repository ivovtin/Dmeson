{
  gROOT.LoadMacro("fit.cpp+");

  init();

  //num_norm = 2000000;
  //num_norm = 1000;   //01:25:39
  //num_norm = 20000;  //01:03:16
  //num_norm = 200000; //00:54:53
  //num_norm = 500000;
  num_norm = 100000;
  mid_de = 100.;
  mid_mbc = 1850.;

  //load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_signal_def.dat");
  //load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_signal_def.dat", 500000.);
  load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_signal_def.dat", 100000.);
  read_par("par/sig.par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/sig_def.par", 30, sig_par, sig_epar);
  gen_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/sig_def.gen", num_sig, sig_par, 0.);
}
