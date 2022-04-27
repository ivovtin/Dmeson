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

  inPar = "par/bck_tmva.par";
  dat_dirname = "KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_atc_tof_dedx_0.80_0.70_Pcuttof380_dedx_OR_atc_with_Cuts_chi255_rr0.5_z12_TMVA";
  data_file = "kpp_uds_KemcAllowedOn_kNoiseReject3_kXTKey1_KcExp0_S1.0_A6.0_Z0.0_atc_tof_dedx_tmva_0.70_ATC.dat";

  par_dirname = dat_dirname + "test";
  gen_dirname = dat_dirname + "test";

  load_sig("dat/" + dat_dirname + "/" + data_file);
  gSystem->Exec("mkdir par/" + par_dirname);
  read_par(inPar, 8, bck_tmva_par, bck_tmva_epar);
  fit_bck_tmva();
  write_par("par/" + par_dirname + "/bck_S1.0_A6.0_Z0.0_tmva.par", 8, bck_tmva_par, bck_tmva_epar);
  gSystem->Exec("mkdir gen/" + gen_dirname);
  gen_bck_tmva("gen/" + gen_dirname + "/bck_S1.0_A6.0_Z0.0.gen", 200000, bck_tmva_par, 0.);
}
