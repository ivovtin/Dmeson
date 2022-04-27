{
  gROOT.LoadMacro("fit.cpp+");

  init();

  //num_norm = 1000000;
  num_norm = 2000000;
  mid_de = 100.;
  mid_mbc = 1850.;

  TString data_file;
  TString inPar;
  TString dat_dirname;
  TString par_dirname;
  TString gen_dirname;

  bool atc = 1;

  if(atc){
      inPar = "par/sig_def.par";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_plus1sigma";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ionization_losses_plus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_ionization_losses_minus1sigma";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_ionization_losses_minus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A7.2_Z0.2_syst_momres";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A7.2_Z0.2_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A4.8_Z0.0_syst_momres";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.8_Z0.0_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A6.9_Z0.0_syst_momres";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_syst_momres_ATC.dat";
      dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_S1.0_A5.1_Z0.0_syst_momres";
      data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_plus_sigma";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_syst_isr_plus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_minus_sigma";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_syst_isr_minus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_syst_isr_rnd";
      //data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_syst_isr_rnd_ATC.dat";

      par_dirname = dat_dirname;
      gen_dirname = dat_dirname;

      //par_dirname = dat_dirname + "_Syst_SigShape";
      //gen_dirname = dat_dirname + "_Syst_SigShape";
  }
  else
  {
      inPar = "par/sig_def.par";
      dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_woATC";
      data_file = "kp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_woATC.dat";
      par_dirname = dat_dirname;
      gen_dirname = dat_dirname;
  }

  load_sig("dat/" + dat_dirname + "/" + data_file);
  gSystem->Exec("mkdir par/" + par_dirname);
  read_par(inPar, 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/" + par_dirname + "/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  gSystem->Exec("mkdir gen/" + gen_dirname);
  gen_sig("gen/" + gen_dirname + "/sig_S1.0_A6.0_Z0.0.gen", num_sig, sig_par, 0.);
}
