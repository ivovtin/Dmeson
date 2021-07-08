{
  gROOT.LoadMacro("fit.cpp+");

  TString type = "fake";
//  TString type = "moddedx";

  init();

  num_norm = 2000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

  load_sig("dat/kpp_exp_"+type+".dat");
  read_par("par/exp.par", 5, exp_par, exp_epar);
  read_par("par/bck.par", 5, bck_par, bck_epar);
  read_par("par/dbck.par", 14, dbck_par, dbck_epar);
  read_par("par/sig_def.par", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

//  exp_epar[0] = 0.;
//  exp_epar[1] = 0.;
//  fit_exp();

//  exp_epar[0] = 0.1;
//  exp_epar[1] = 1.;

  fit_exp();
  write_par("par/exp_"+type+".par", 5, exp_par, exp_epar);
//  read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double mdcorr = 1869.4 + (exp_par[0]-mdsig) - 
                  0.00*(exp_par[1]-desig);
                  
  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

}
