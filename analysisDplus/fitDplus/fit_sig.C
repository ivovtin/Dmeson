{
  gROOT.LoadMacro("fit.cpp+");

  TString type = "tof";

  init();

  num_norm = 2000000;
  mid_de = 100.;
  mid_mbc = 1850.;

  //load_sig("dat/kpp_signal_nopair.dat");
  load_sig("dat/kpp_signal_def.dat");
  //read_par("par/sig_corr.par", 30, sig_par, sig_epar);
  read_par("par/sig_def.par", 30, sig_par, sig_epar);
  fit_sig();
  //write_par("par/sig_nopair.par", 30, sig_par, sig_epar);
  write_par("par/sig_def.par", 30, sig_par, sig_epar);
  gen_sig("gen/sig.gen", num_sig, sig_par, 0.);
}
