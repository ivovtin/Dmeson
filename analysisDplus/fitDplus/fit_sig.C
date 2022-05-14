{
  gROOT.LoadMacro("fit.cpp+");

  init();

  //num_norm = 2000000;
  num_norm = 1000000;
  mid_de = 100.;
  mid_mbc = 1850.;

  TString data_file;
  TString inPar;
  TString dat_dirname;
  TString par_dirname;
  TString gen_dirname;

  bool final = 1;

  if (final){

      //inPar = "par/sig.par";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A7.2_Z0.2";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A7.2_Z0.2_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A4.8_Z0.0";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.8_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A6.9_Z0.0";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A7.2_Z0.0";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A7.2_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A5.1_Z0.0";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_plus1sigma";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_plus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_minus1sigma";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_minus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_rndGauss";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_rndGauss_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_plus_sigma";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_plus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_minus_sigma";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_minus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_rnd";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_rnd_ATC.dat";

      //inPar = "par/sig_tmva.par";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_TMVA";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_tmva_0.50_ATC.dat";

      //inPar = "par/sig_1gauss.par";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";

      //par_dirname = dat_dirname + "_Syst_SigShape";
      //gen_dirname = dat_dirname + "_Syst_SigShape";

      //2004
      inPar = "par/sig2004.par";

      dat_dirname = "2004_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_dedx_tof_0.97_0.10_Pcuttof380_with_Cuts_chi255_rr0.5_z12_nmaxhits54";
      data_file = "kpp_signal_2004_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0_dedx_tof_ATC.dat";

      //dat_dirname = "2004_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_tof_with_Cuts_chi250_rr0.5_z12";
      //data_file = "kpp_signal_2004_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0_tof_ATC.dat";

      par_dirname = dat_dirname;
      gen_dirname = dat_dirname;

  }
  else
  {
      inPar = "par/sig.par";
      /////////
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_ATC.dat";
      /////////
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_ATC.dat";
      /////////
      dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
      data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_dedx_ATC.dat";

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
