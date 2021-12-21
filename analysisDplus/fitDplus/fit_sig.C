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

  bool atc = 1;

  //with ATC
  if (atc ){
      data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_atc_ATC.dat";
      //inPar = "par/sig_def.par";
      //inPar = "par/sig.par";
      inPar = "par/KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_ATC_v0/sig_S1.0_A6.0_Z0.0.par";
      dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
      par_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
      gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
  }
  else
  {
       data_file = "kpp_signal_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat";
       inPar = "par/sig.par";
       dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
       par_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
       gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
  }

  load_sig("dat/" + dat_dirname + "/" + data_file);
  gSystem->Exec("mkdir par/" + par_dirname);
  read_par(inPar, 30, sig_par, sig_epar);
  fit_sig();
  write_par("par/" + par_dirname + "/sig_S1.0_A6.0_Z0.0.par", 30, sig_par, sig_epar);
  gSystem->Exec("mkdir gen/" + gen_dirname);
  gen_sig("gen/" + gen_dirname + "/sig_S1.0_A6.0_Z0.0.gen", num_sig, sig_par, 0.);

}
