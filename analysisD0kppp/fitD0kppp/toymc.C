{
  gROOT.LoadMacro("fit.cpp+");

  TString type = "tof";

  init();

  num_norm = 2000000;
//  mid_de = 100.;
//  mid_mbc = 1700.;

  load_sig("dat/kpp_exp_"+type+".dat");
  read_par("par/exp.par", 5, exp_par, exp_epar);
  read_par("par/bck.par", 5, bck_par, bck_epar);
  read_par("par/dbck.par", 14, dbck_par, dbck_epar);
  read_par("par/sig.par", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];
  double udssig = exp_par[2];
  double dbcksig = exp_par[3];
  
  int num_gen = num_sig;

  for (int i=0; i<10000; i++) {
    read_par("par/exp.par", 5, exp_par, exp_epar);

    gen_exp("gen/toymc.gen", num_gen, exp_par, 0.);
    load_sig("gen/toymc.gen");
    fit_exp();
    
    FILE* file = fopen("stat.dat","a");
    
    fprintf(file, "%f %f %f %f %f %f %f %f %f %f %f %f\n", 
            mdsig, exp_par[0], exp_epar[0], desig, exp_par[1], exp_epar[1], 
            udssig, exp_par[2], exp_epar[2], dbcksig, exp_par[3], exp_epar[3]);
            
    fclose(file);
  } 
}
