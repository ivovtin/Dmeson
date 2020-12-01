{
  gROOT.LoadMacro("fit.cpp+");

  TString type = "tof";

  init();

  num_norm = 2000000;
  mid_de = 300.;
  mid_mbc = 1700.;

  load_sig("dat/kpp_dbck.dat");
  read_par("par/dbck.par", 14, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/dbck.par", 14, dbck_par, dbck_epar);
  gen_dbck("gen/dbck.gen", 100000, dbck_par, 0.);
}
