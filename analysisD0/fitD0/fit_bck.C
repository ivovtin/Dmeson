{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 900000;
  mid_de = 300.;
  mid_mbc = 1700.;

  load_sig("dat/kp_uds.dat");
  read_par("par/bck_uds.par", 4, bck_par, bck_epar);
  fit_bck();
  write_par("par/bck_uds.par", 4, bck_par, bck_epar);
  gen_bck("gen/bck_uds.gen", 100000, bck_par, 0.);
}
