{
  gROOT.LoadMacro("fit.cpp+");

  TString type = "tof";

  init();

  num_norm = 2000000;
  mid_de = 100.;
  mid_mbc = 1850.;

  load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_signal_def.dat");
  read_par("par/sig.par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/sig_def.par", 30, sig_par, sig_epar);
  gen_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/sig_def.gen", num_sig, sig_par, 0.);
}