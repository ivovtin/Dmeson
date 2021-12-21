{
  gROOT.LoadMacro("fit.cpp+");

  init();

  num_norm = 900000;
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
      data_file = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_tof_atc_ATC.dat";
      inPar = "par/bck.par";
      dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
      par_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
      gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_tof_atcPthr600";
  }
  else
  {
       data_file = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0.dat";
       inPar = "par/bck.par";
       dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
       par_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
       gen_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0";
  }

  load_sig("dat/" + dat_dirname + "/" + data_file);
  gSystem->Exec("mkdir par/" + par_dirname);
  read_par(inPar, 5, bck_par, bck_epar);
  fit_bck();
  write_par("par/" + par_dirname + "/bck_S1.0_A6.0_Z0.0.par", 5, bck_par, bck_epar);
  gSystem->Exec("mkdir gen/" + gen_dirname);
  gen_bck("gen/" + gen_dirname + "/bck_S1.0_A6.0_Z0.0.gen", 100000, bck_par, 0.);
}
