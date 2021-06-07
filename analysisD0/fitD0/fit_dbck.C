{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;
  mid_de = 300.;
  mid_mbc = 1700.;

  
  load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_S1.0_A6.0_Z0.0.dat");
  read_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/dbck_sim_S1.0_A6.0_Z0.0.par", 16, dbck_par, dbck_epar);
  gen_dbck("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC/dbck_sim_S1.0_A6.0_Z0.0.gen", 100000, dbck_par, 0.);
  
  /*
  //w/o ATC
  load_sig("/spool/users/ovtin/outDmeson/D0/results/fitsD0/dat/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat");
  read_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/dbck_sim_S1.0_A6.0_Z0.0.par", 16, dbck_par, dbck_epar);
  gen_dbck("/spool/users/ovtin/outDmeson/D0/results/fitsD0/gen/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0/dbck_sim_S1.0_A6.0_Z0.0.gen", 100000, dbck_par, 0.);
 */
}
