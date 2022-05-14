{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
  //mid_de = 100.;
  //mid_mbc = 1700.;

  TString dataFile;
  TString dat_dirname;
  TString gen_dirname;
  TString par_dirname;
  TString infile;
  TString exp_def;
  TString exp_sig;
  TString exp_bck;
  TString exp_dbck;
  TString exp_fit_par;

  //int key = 2016;
  int key = 2004;
  bool final = 1;

  if( key==2004 ) {

      dat_dirname = "2004_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_dedx_tof_0.97_0.10_Pcuttof380_with_Cuts_chi255_rr0.5_z12_nmaxhits54";
      dataFile = "kpp_exp_2004_KemcAllowedOn_kNoiseReject3_1.0200_dedx_tof_ATC.dat";

      //dat_dirname = "2004_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_tof_with_Cuts_chi250_rr0.5_z12";
      //dataFile = "kpp_exp_2004_KemcAllowedOff_kNoiseReject3_1.0250_tof_ATC.dat";

      par_dirname = dat_dirname;
      gen_dirname = dat_dirname;
      //gen_dirname = dat_dirname+"_k1.0250";
      //gen_dirname = dat_dirname+"_k1.0170";

      infile = "dat/" + dat_dirname + "/" + dataFile;
      exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A4.5_Z0.0_k1.0250.par";
      //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A4.5_Z0.0_k1.0200.par";
      //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A4.5_Z0.0_k1.0170.par";

      gSystem->Exec("mkdir gen/" + gen_dirname);
      exp_def = "gen/" + gen_dirname + "/exp_def_S1.0_A4.5_Z0.0.gen";
      exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A4.5_Z0.0.gen";
      exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A4.5_Z0.0.gen";
      exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A4.5_Z0.0.gen";

  }
  else{
      if(final){
	  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_plus1sigma";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_minus1sigma";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_rndGauss";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A7.2_Z0.2";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A4.8_Z0.0";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A6.9_Z0.0";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A7.2_Z0.0";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A5.1_Z0.0";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_plus_sigma";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_minus_sigma";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_rnd";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_TMVA";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_atc_tof_dedx_ATC.dat";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_tmva_0.50_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_ionization_losses_plus1sigma_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_ionization_losses_minus1sigma_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_ionization_losses_rndGauss_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_dedx_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0130_atc_tof_dedx_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_atc_tof_dedx_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0170_atc_tof_dedx_ATC.dat";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0120_atc_tof_dedx_ATC.dat";
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp1_atc_tof_dedx_0.80_0.70_Pcuttof380_20012022_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0150_atc_tof_dedx_KcExp1_kXTKey1_ATC.dat";
	  //dat_dirname = "KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp1_atc_tof_dedx_0.80_0.70_Pcuttof380_20012022_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOff_kNoiseReject3_1.0150_atc_tof_dedx_KcExp1_kXTKey1_ATC.dat";

	  par_dirname = dat_dirname;
	  gen_dirname = dat_dirname;

	  //par_dirname = dat_dirname + "_Syst_SigShape";
	  //gen_dirname = dat_dirname + "_Syst_SigShape";

	  //par_dirname = dat_dirname + "_Syst_BGudsShape";
	  //gen_dirname = dat_dirname + "_Syst_BGudsShape";

	  //par_dirname = dat_dirname + "_Syst_DbckShape";
	  //gen_dirname = dat_dirname + "_Syst_DbckShape";

	  //gen_dirname = dat_dirname + "_1.0130";
	  //gen_dirname = dat_dirname + "_1.0150";
	  //gen_dirname = dat_dirname + "_1.0170";
	  //gen_dirname = dat_dirname + "_1.0120";
	  //gen_dirname = dat_dirname + "_1.0140";
	  gen_dirname = dat_dirname + "_1.0140_test";

	  infile = "dat/" + dat_dirname + "/" + dataFile;
	  exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0140_test.par";
	  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0140.par";
	  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0130.par";
	  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0150.par";
	  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0170.par";
	  //exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0_k1.0120.par";
	  gSystem->Exec("mkdir gen/" + gen_dirname);
	  exp_def = "gen/" + gen_dirname + "/exp_def_S1.0_A6.0_Z0.0.gen";
	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
      else{
          ///////
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_tof_ATC.dat";
          ///////
	  //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
          //dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_tof_ATC.dat";
          ///////
	  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
          dataFile = "kpp_exp_2016-17_KemcAllowedOn_kNoiseReject3_1.0140_atc_dedx_ATC.dat";

	  par_dirname = dat_dirname;
	  gen_dirname = dat_dirname;

	  infile = "dat/" + dat_dirname + "/" + dataFile;
	  exp_fit_par = "par/" + par_dirname + "/exp_fit_S1.0_A6.0_Z0.0.par";
          gSystem->Exec("mkdir gen/" + gen_dirname);
	  exp_def = "gen/" + gen_dirname + "/exp_def_S1.0_A6.0_Z0.0.gen";
	  exp_sig = "gen/" + gen_dirname + "/exp_sig_S1.0_A6.0_Z0.0.gen";
	  exp_bck = "gen/" + gen_dirname + "/exp_bck_S1.0_A6.0_Z0.0.gen";
	  exp_dbck = "gen/" + gen_dirname + "/exp_dbck_S1.0_A6.0_Z0.0.gen";
      }
  }

  load_sig(infile);

  //read_par("par/exp.par", 5, exp_par, exp_epar);
  read_par("par/exp_fit_2004.par", 5, exp_par, exp_epar);

  read_par("par/" + par_dirname + "/bck_S1.0_A6.0_Z0.0.par", 5, bck_par, bck_epar);
  read_par("par/" + par_dirname + "/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
  read_par("par/" + par_dirname + "/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);

  double mdsig = sig_par[0];
  double desig = sig_par[1];

  exp_par[5] = bck_par[0];
  exp_epar[5] = bck_epar[0];
  exp_par[6] = bck_par[1];
  exp_epar[6] = bck_epar[1];

  sig_par[7] = 0;  // Zero Dbck fraction

  //exp_epar[0] = 0.;
  //exp_epar[1] = 0.;
  //fit_exp();

  //exp_epar[0] = 0.1;
  //exp_epar[1] = 1.;

  fit_exp();
  write_par(exp_fit_par, 5, exp_par, exp_epar);
  //read_par("par/exp_def.par", 5, exp_par, exp_epar);

  double maj = gen_exp(exp_def, 100000, exp_par, 0.);

  double mdcorr = 1869.5 + (exp_par[0]-mdsig) +
                  0.008*(exp_par[1]-desig);
  //                 0.012*(exp_par[1]-desig);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);

  double tmp_par[5];

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[3] = 0.;
  gen_maj(exp_sig, 5000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[3] = 0.;
  tmp_par[4] = 0.;
  gen_maj(exp_bck, 5000000, tmp_par, maj);

  for(int i=0; i<5; i++) tmp_par[i] = exp_par[i];
  tmp_par[2] = 0.;
  tmp_par[4] = 0.;
  gen_maj(exp_dbck, 5000000, tmp_par, maj);

  printf("M_D = %f +- %f\n", mdcorr, exp_epar[0]);
}
