{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 900000;
  mid_de = 300.;
  mid_mbc = 1700.;

  //load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_uds.dat");
  load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/kp_uds_woDCnoise.dat");
  read_par("par/bck_uds.par", 4, bck_par, bck_epar);
  fit_bck();
  //write_par("par/bck_uds.par", 4, bck_par, bck_epar);
  write_par("par/bck_uds_woDCnoise.par", 4, bck_par, bck_epar);
  //gen_bck("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/bck_uds.gen", 100000, bck_par, 0.);
  gen_bck("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/bck_uds_woDCnoise.gen", 100000, bck_par, 0.);
}
