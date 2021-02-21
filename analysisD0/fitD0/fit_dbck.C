{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;
  mid_de = 300.;
  mid_mbc = 1700.;

  //load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_dbck.dat");
  load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_dbck_woDCnoise.dat");
  read_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  fit_dbck();
  //write_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  write_par("par/dbck_sim_woDCnoise.par", 16, dbck_par, dbck_epar);
  //gen_dbck("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/dbck_sim.gen", 100000, dbck_par, 0.);
  gen_dbck("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/dbck_sim_woDCnoise.gen", 100000, dbck_par, 0.);
}
