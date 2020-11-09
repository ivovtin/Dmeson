{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;
  mid_de = 300.;
  mid_mbc = 1700.;

  load_sig("dat/kp_dbck.dat");
  read_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  gen_dbck("gen/dbck_sim.gen", 100000, dbck_par, 0.);
}
