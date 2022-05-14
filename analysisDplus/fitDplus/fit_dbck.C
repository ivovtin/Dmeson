{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 2000000;
  mid_de = 300.;
  mid_mbc = 1700.;

  TString data_file;
  TString inPar;
  TString dat_dirname;
  TString par_dirname;
  TString gen_dirname;

  bool final = 1;

  if (final){
      inPar = "par/dbck.par";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A7.2_Z0.2";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A7.2_Z0.2_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A4.8_Z0.0";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.8_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A6.9_Z0.0";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.9_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A7.2_Z0.0";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A7.2_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_momres_S1.0_A5.1_Z0.0";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A5.1_Z0.0_atc_tof_dedx_syst_momres_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_plus1sigma";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_plus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_minus1sigma";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_minus1sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_ionization_losses_rndGauss";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_ionization_losses_rndGauss_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_plus_sigma";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_plus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_minus_sigma";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_minus_sigma_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_syst_isr_rnd";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_syst_isr_rnd_ATC.dat";
      //////////
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_ATC.dat";
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_TMVA";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_tmva_0.50_ATC.dat";

      /*
      inPar = "par/dbck_syst_shape.par";

      par_dirname = dat_dirname + "_Syst_DbckShape";
      gen_dirname = dat_dirname + "_Syst_DbckShape";
      */

      dat_dirname = "2004_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_dedx_tof_0.97_0.10_Pcuttof380_with_Cuts_chi255_rr0.5_z12_nmaxhits54";
      data_file = "kpp_dbck_2004_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0_dedx_tof_ATC.dat";

      //dat_dirname = "2004_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_tof_with_Cuts_chi250_rr0.5_z12";
      //data_file = "kpp_dbck_2004_KemcAllowedOff_kNoiseReject3_kXTKey1_KcExp0_S1.0_A4.5_Z0.0_tof_ATC.dat";

      par_dirname = dat_dirname;
      gen_dirname = dat_dirname;

  }
  else
  {
      inPar = "par/dbck.par";
      ////////
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_ATC.dat";
      ////////
      //dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
      //data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_ATC.dat";
      ////////
      dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_dedx_Pcuttof380_with_Cuts_chi255_rr0.5_z12";
      data_file = "kpp_dbck_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_dedx_ATC.dat";

      par_dirname = dat_dirname;
      gen_dirname = dat_dirname;
  }

  load_sig("dat/" + dat_dirname + "/" + data_file);
  gSystem->Exec("mkdir par/" + par_dirname);
  read_par(inPar, 14, dbck_par, dbck_epar);
  fit_dbck();
  write_par("par/" + par_dirname + "/dbck_S1.0_A6.0_Z0.0.par", 14, dbck_par, dbck_epar);
  gSystem->Exec("mkdir gen/" + gen_dirname);
  gen_dbck("gen/" + gen_dirname + "/dbck_S1.0_A6.0_Z0.0.gen", 100000, dbck_par, 0.);

}
