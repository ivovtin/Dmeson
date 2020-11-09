{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;

  read_par("par/exp_fit.par", 5, exp_par, exp_epar);
  read_par("par/bck_uds.par", 4, bck_par, bck_epar);
  read_par("par/dbck_sim.par", 16, dbck_par, dbck_epar);
  read_par("par/sig_corr.par", 30, sig_par, sig_epar);

  sig_par[7] = 0;

  double mdsig = sig_par[0];
  double desig = sig_par[1];
  
  exp_par[0] = mdsig;
  exp_par[1] = desig;
  
//  double maj = gen_exp("gen/toymc.gen", 900000, exp_par, 0.);

  dpcut=0;
  
  for (int dpcut=-1; dpcut<=1; dpcut++) 
  for (int i=0; i<100; i++) {
    norm_seed = i*88+ 1234;
  
    load_sig("gen/toymc.gen", i*9000, 9000);
    fit_exp();
    double mdcorr = 1864.6 + (exp_par[0]-mdsig) + 
                    0.00*(exp_par[1]-desig);
    FILE* file;
    if (dpcut==-1) file = fopen("toymc3_dpp.dat","a");
    if (dpcut==0) file = fopen("toymc3.dat","a");
    if (dpcut==1) file = fopen("toymc3_dpm.dat","a");
    fprintf(file,"%d %lf %lf\n", i, mdcorr, exp_epar[0]);
    fclose(file);
  }
}
