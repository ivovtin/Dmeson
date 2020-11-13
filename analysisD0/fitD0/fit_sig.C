{
  gROOT.LoadMacro("fit.cpp+");

  TString type = "tof";

  init();

  //num_norm = 2000000;
  num_norm = 200;
  mid_de = 100.;
  mid_mbc = 1850.;

  load_sig("/spool/users/ovtin/outDmeson/fitsD0/dat/kp_signal_novp.dat");
  read_par("par/sig_corr.par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/sig_novp.par", 30, sig_par, sig_epar);
//  gen_sig("/spool/users/ovtin/outDmeson/fitsD0/gen/sig_corr.gen", num_sig, sig_par, 0.);
}
