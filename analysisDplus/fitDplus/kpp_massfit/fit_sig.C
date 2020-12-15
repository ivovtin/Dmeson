{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
  mid_de = 100.;
  mid_mbc = 1850.;
  
  TString type = "tof";

  load_sig("dat/kpp_signal_def.dat");
  read_par("par/sig_"+type+".par", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/sig_"+type+".fit", 30, sig_par, sig_epar);
  gen_sig("gen/sig_"+type+".gen", num_sig, sig_par, 0.);
}
