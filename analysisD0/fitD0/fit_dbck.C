{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 1000000;
  mid_de = 300.;
  mid_mbc = 1700.;

  TString data_file;
  TString inPar;
  TString dat_dirname;
  TString par_dirname;
  TString gen_dirname;

  bool atc = 1;

  //with ATC
  if (atc ){
      inPar = "par/dbck_sim.par";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_plus1sigma";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ionization_losses_plus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_minus1sigma";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ionization_losses_minus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A7.2_Z0.2_syst_momres";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A7.2_Z0.2_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A4.8_Z0.0_syst_momres";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.8_Z0.0_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A6.9_Z0.0_syst_momres";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_syst_momres_ATC.dat";
      dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A5.1_Z0.0_syst_momres";
      data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_plus_sigma";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_syst_isr_plus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_minus_sigma";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_syst_isr_minus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_rnd";
      //data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_syst_isr_rnd_ATC.dat";

      par_dirname = dat_dirname;
      gen_dirname = dat_dirname;

      //inPar = "par/dbck_sim_syst_shape.par";
      //par_dirname = dat_dirname + "_Syst_DbckShape";
      //gen_dirname = dat_dirname + "_Syst_DbckShape";
  }
  else
  {
       inPar = "par/dbck_sim.par";
       dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_woATC";
       data_file = "kp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_woATC.dat";
       par_dirname = dat_dirname;
       gen_dirname = dat_dirname;
  }

  load_sig("dat/" + dat_dirname + "/" + data_file);
  gSystem->Exec("mkdir par/" + par_dirname);
  read_par(inPar, 16, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/" + par_dirname + "/dbck_S1.0_A6.0_Z0.0.par", 16, dbck_par, dbck_epar);
  gSystem->Exec("mkdir gen/" + gen_dirname);
  gen_dbck("gen/" + gen_dirname + "/dbck_S1.0_A6.0_Z0.0.gen", 100000, dbck_par, 0.);
}
