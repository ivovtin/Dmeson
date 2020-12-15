#include "TSystem.h"
#include "TString.h"

void do_fit(TString type) {
  load_sig("dat/kpp_signal_"+type+".dat");
  read_par("par/sig_"+type+".fit", 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/sig_"+type+".fit", 30, sig_par, sig_epar);
//  gen_sig("gen/sig_"+type+".gen", num_sig, sig_par, 0.);
}

void fit_sig_syst() {
  gROOT->LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
  mid_de = 100.;
  mid_mbc = 1850.;
  
//  do_fit("corr");
//  do_fit("gm");
//  do_fit("g29");
//  do_fit("mm");
//  do_fit("mp");
//  do_fit("nr1");
//  do_fit("def");
  do_fit("corr_1.02");
  do_fit("corr_0.98");
}
