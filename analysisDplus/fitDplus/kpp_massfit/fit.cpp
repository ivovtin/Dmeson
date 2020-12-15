#include <stdio.h>
#include "TVirtualFitter.h"
#include "TMinuit.h"
#include "TRandom3.h"
#include "TSystem.h"
#include "TString.h"

typedef struct {
  double mbc;
  double de;
  double dp;
} t_point;

int num_sig;
t_point sig[300000];
int num_norm;
t_point norm[5000000];

double min_mbc;
double mid_mbc;
double max_mbc;
double max_de;
double mid_de;
double max_dp;

int cycle;
int no_dp;

int gen_seed;
int norm_seed;

#define BCK_PARS 5
#define DBCK_PARS 14
#define SIG_PARS 30
#define EXP_PARS 5
#define EXP2_PARS 7

double bck_par[BCK_PARS];
double bck_epar[BCK_PARS];

double dbck_gaus_par[DBCK_PARS] = {
  0., 0., 1888.75, -1.512, -251.5, 75.5,
  1.0, 1895.9, 33.66, 5.29, -15.9, 138., 0., 1864.33
};

double dbck_par[DBCK_PARS];
double dbck_epar[DBCK_PARS];

double sig_par_corr[SIG_PARS] = {
//  1864.572136, -0.413509, -0.030059, 0.803902, 1.717566, 47.629182, 
  1864.572136, -0.413509, -0.030059, 1.023902, 2.317566, 47.629182, 
  1888.750000, 10.217552, 21.278622, 20.641600, 0.199009, 
  16.911367, 123.621517, -0.162603, 3.978513, 17.952010, 13.816511, 4.875620, 
  1888.750000, -1.345018, -138.970831, 57.627908, 22.354517, 
  1881.809090, 20.123182, 3.190639, -26.957989, 51.593411, 
  144.109, 1872.757467
};

double sig_par_xs[SIG_PARS] = {
  1864.358135, 3.128730, -0.035154, 0.952214, 2.318660, 47.434301, 
  1888.750000, 9.351257, 22.389010, 9.368806, 0.190371, 
  17.228983, 135.805031, -0.088875, 4.704761, 9.017986, 10.148626, 4.582520, 
  1888.750000, -1.363022, -158.882916, 63.682994, 21.442926, 
  1906.083059, 34.452337, 5.435646, -15.180071, 53.906745, 
  276.070560, 1868.574895
};

double sig_par_xsgm[SIG_PARS] = {
  1864.556452, 1.646712, -0.034027, 1.125386, 2.486065, 49.477989, 
  1888.750000, 6.110003, 21.472286, 3.712464, 0.145991, 
  18.049578, 172.622018, -0.084118, 1.336431, 38.999130, 4.969049, 4.180077, 
  1888.750000, -1.690715, -182.401724, 69.533828, 12.471282, 
  1879.784836, 29.781964, 6.865934, -16.421617, 73.733742, 
  187.836093, 1869.914083
};

double sig_par[SIG_PARS];
double sig_epar[SIG_PARS];

double exp_par[EXP2_PARS];
double exp_epar[EXP2_PARS];

double pdf_bck(double mbc, double de, double dp, double *par) {
  double alpha_mbc = par[0];
  double alpha_de = par[1];
  double ebeam = par[2];
  double twist = par[3];
  double c2_de = par[4];

  if (mbc > ebeam) return 0;
  double dp_max = sqrt(ebeam*ebeam - mbc*mbc);
  if (fabs(dp)<dp_max) {
    double arg = alpha_mbc*(mbc/ebeam-1.);
    double ade = (-alpha_de+(twist*(mbc/ebeam-1.)))*de/1000. - 
                 c2_de*pow(de/1000.,2.);
//    printf("pdf_bck, arg = %f\n", arg);
    if (no_dp) {
      return exp(arg+ade)*dp_max/1000.;
    } 
    else return exp(arg-alpha_de*de/1000.)*(1.+twist*dp*dp/1000./1000.);
  }
  return 0.;
}

double pdf_dbck(double mbc, double de, double dp, double *par) {
  double alpha_mbc = par[0];
  double alpha_de = par[1];
  double ebeam = par[2];
  double dpcurv = par[3];
  double de_mean = par[4];
  double de_width = par[5];
  double de_frac = par[6];
  double mbc_mean = par[7];
  double mbc_sigma0 = par[8];
  double mbc_sigma1 = par[9];
  double de_mean1 = par[10];
  double de_width1 = par[11];
  double de_frac1 = par[12];
  double mbc_mean1 = par[13];

  if (mbc > ebeam) return 0;
  double dp_max = sqrt(ebeam*ebeam - mbc*mbc);
  if (fabs(dp)<dp_max) {
    double p_mbc = exp(alpha_mbc*(mbc-ebeam)/ebeam);
    double p_de = exp(-alpha_de*de/1000.);
    
//    double mbc_sigma = mbc_sigma0*exp(-de*mbc_sigma1);
//    double mbc_sigma = mbc_sigma0-de*mbc_sigma1;
    
    double p_mbc2 = exp(-pow(mbc-mbc_mean,2)/2./mbc_sigma0/mbc_sigma0);
//    double p_mbc2 = exp((mbc-ebeam)/ebeam*mbc_sigma0);
    double p_mbc3 = exp(-pow(mbc-mbc_mean1,2)/2./mbc_sigma1/mbc_sigma1);
    double p_de2 = exp(-pow(de-de_mean,2)/2./de_width/de_width);
    double p_de3 = exp(-pow(de-de_mean1,2)/2./de_width1/de_width1);
    if (no_dp)
      return (p_mbc*p_de+fabs(de_frac)*p_mbc2*p_de2+
             fabs(de_frac1)*p_mbc3*p_de3)*dp_max/1000.;
    else 
      return (p_mbc*p_de+fabs(de_frac)*p_mbc2*p_de2+
              fabs(de_frac1)*p_mbc3*p_de3)*
           fabs(1.+dpcurv*dp*dp/1000./1000.);
  }
  return 0.;
}

double pdf_sig(double mbc, double de, double dp, double *par) {
//  printf("%f %f\n", par[0], par[1]);
 
  double mbc_mean = par[0];
  double de_mean = par[1];
  double mbcde_corr = par[2];
  double mbc_sigma0_l = par[3];
  double mbc_sigma0_r = par[4];
  double de_sigma = par[5];
  double ebeam = par[6];
  double bck = par[7];
  double mbc_sigma2 = par[8];
  double mbcw_shift = par[9];
  double mbcw_frac = par[10];
  double mbcw_sigma = par[11];
  double dew_sigma = par[12];
  double mbcdew_corr = par[13];
  double dpcurv = par[14];
  double mbc_sigma4 = par[15];

  double dbck_par[14];
  
  for (int i=0; i<14; i++) {
    dbck_par[i] = par[i+16];
  }

//  printf("%f %f\n", mbc, ebeam);
  
  if (mbc > ebeam) return 0;
  if (mbc < min_mbc) return 0;
  if (fabs(de)>max_de) return 0;

  double dp_max = sqrt(ebeam*ebeam - mbc*mbc);

//  printf("%f %f\n", dp, dp_max);
  
  if (fabs(dp)<dp_max) {

    double dde = de - de_mean;
    double dmbc = mbc - mbc_mean - mbcde_corr*dde;
    double fr = fabs(dp)/1000.;

    double dpsig = fabs(1.+dp*dp*dpcurv/1000./1000.);

    double mbc_sigma_l = sqrt(pow(mbc_sigma0_l,2) + 
                         pow(fr*mbc_sigma2,2.) + 
                         pow(fr*fr*mbc_sigma4,2.));
    double mbc_sigma_r = sqrt(pow(mbc_sigma0_r,2) + 
                         pow(fr*mbc_sigma2,2.) + 
                         pow(fr*fr*mbc_sigma4,2.));

    double desig = exp(-dde*dde/2./de_sigma/de_sigma);
    double mbcsig;
    if (dmbc<0)
      mbcsig = exp(-dmbc*dmbc/2./mbc_sigma_l/mbc_sigma_l)/(mbc_sigma_l+mbc_sigma_r);
    else 
      mbcsig = exp(-dmbc*dmbc/2./mbc_sigma_r/mbc_sigma_r)/(mbc_sigma_l+mbc_sigma_r);

    dmbc = mbc - mbc_mean - mbcdew_corr*dde - mbcw_shift;
    double desig2 = exp(-dde*dde/2./dew_sigma/dew_sigma);
    double mbcsig2 = fabs(mbcw_frac)*exp(-dmbc*dmbc/2./mbcw_sigma/mbcw_sigma)/mbcw_sigma;

//    printf("%f %f\n", desig, mbcsig);

    if (no_dp) 
      return dpsig*(desig*mbcsig + fabs(mbcw_frac)*desig2*mbcsig2)*dp_max/1000.+
             fabs(bck)/1e5*pdf_dbck(mbc, de, dp, dbck_par);
    else 
    return dpsig*(desig*mbcsig + fabs(mbcw_frac)*desig2*mbcsig2)
           + fabs(bck)/1e5*pdf_dbck(mbc, de, dp, dbck_par);
  }
  return 0.;
}

double pdf_exp(double mbc, double de, double dp, double *par) {
  double mbc_mean = par[0];
  double de_mean = par[1];
  double bck = par[2];
  double dbck = par[3];
  double sig = par[4];

  sig_par[0] = mbc_mean;
  sig_par[1] = de_mean;

  return fabs(sig)*pdf_sig(mbc, de, dp, sig_par) + 
         fabs(bck)/1e5*pdf_bck(mbc, de, dp, bck_par) +
         fabs(dbck)/1e5*pdf_dbck(mbc, de, dp, dbck_par);
}

double pdf_exp2(double mbc, double de, double dp, double *par) {
  double mbc_mean = par[0];
  double de_mean = par[1];
  double bck = par[2];
  double dbck = par[3];
  double sig = par[4];

  bck_par[0] = par[5];
  bck_par[1] = par[6];

  sig_par[0] = mbc_mean;
  sig_par[1] = de_mean;

  return fabs(sig)*pdf_sig(mbc, de, dp, sig_par) + 
         fabs(bck)/1e5*pdf_bck(mbc, de, dp, bck_par) +
         fabs(dbck)/1e5*pdf_dbck(mbc, de, dp, dbck_par);
}


double loglh(int npar, double* par, double (*pdf)(double,double,double,double*)) {
  double integ = 0;

  double mid_frac = 1./(1+(max_mbc-min_mbc)*max_de/(max_mbc-mid_mbc)/mid_de);

  for (int i=0; i<num_norm; i++) {
    double dp = no_dp ? 0 : norm[i].dp;
    double w = (*pdf)(norm[i].mbc, norm[i].de, dp, par);
    integ += (norm[i].mbc > mid_mbc && fabs(norm[i].de) < mid_de) ? mid_frac*w : w;

//    if (i==0 || i==num_norm-1) printf("pdf=%f\n",w);
  }
  double sum = 0;
  int out = 0;
  for (int i=0; i<num_sig; i++) {
    double dp = no_dp ? 0 : sig[i].dp;
    double p = (*pdf)(sig[i].mbc, sig[i].de, dp, par);
    if (p>0) sum += log(p);
    else out++;
  }

  cycle++;
  double f = -2*sum + 2*num_sig*log(integ);

  if (cycle % 10) {
    FILE* file = fopen("fit.tmp","w");
    for (int i=0; i<npar; i++) fprintf(file,"%d %lf %lf\n", i, par[i], 0.1);
    fclose(file);
  }

  printf("\n%d : f=%f, int=%lf, out=%d/%d\n", cycle, f, integ, out, num_sig);
  for (int i=0; i<npar; i++) {
    printf("%2d %13lf  ", i, par[i]);
    if ((i % 4 == 3) || (i==npar-1)) printf("\n");
  }

  return f;
}

void fit_func_bck(int &, double *, double &f, double *par, int) {
  f = loglh(BCK_PARS, par, &pdf_bck);
}

void fit_func_dbck(int &, double *, double &f, double *par, int) {
  f = loglh(DBCK_PARS, par, &pdf_dbck);
}

void fit_func_sig(int &, double *, double &f, double *par, int) {
  f = loglh(SIG_PARS, par, &pdf_sig);
}

void fit_func_exp(int &, double *, double &f, double *par, int) {
  f = loglh(EXP_PARS, par, &pdf_exp);
}

void fit_func_exp2(int &, double *, double &f, double *par, int) {
  f = loglh(EXP2_PARS, par, &pdf_exp2);
}

void init() {
  min_mbc = 1700.;
  mid_mbc = 1850.;
  max_mbc = 1900.;
  mid_de = 100.;
  max_de = 300.;
  num_norm = 4000000;
  no_dp = 1;
  
  gen_seed = 12345;
  norm_seed = 1;

  max_dp = sqrt(max_mbc*max_mbc-min_mbc*min_mbc);
}

void make_norm() {
  TRandom3 rnd(norm_seed);

  for (int i=0; i<num_norm/2; i++) {
    norm[i].mbc = min_mbc + (max_mbc-min_mbc)*rnd.Rndm();
    norm[i].de = (2.*rnd.Rndm()-1.)*max_de;
    norm[i].dp = (2.*rnd.Rndm()-1.)*max_dp;
  }
  for (int i=num_norm/2; i<num_norm; i++) {
    norm[i].mbc = mid_mbc + (max_mbc-mid_mbc)*rnd.Rndm();
    norm[i].de = (2.*rnd.Rndm()-1.)*mid_de;
    norm[i].dp = (2.*rnd.Rndm()-1.)*max_dp;
  }
  
}

double gen(TString filename, int num, double* par, double maj, 
     double (*pdf)(double, double, double, double*)) {
  TRandom3 rnd(gen_seed);
  
  double maj1 = maj;
  
  FILE* file = fopen(filename,"w");
  
  for (int i=-1000; i<num; i++) {
    if ((i) % 1000 == 0) printf("Generating event %d\n", i);
  
    for (int j=0; j<100000; j++) {
      double mbc = min_mbc + (max_mbc-min_mbc)*rnd.Rndm();
      double de = (2.*rnd.Rndm()-1.)*max_de;
      double dp = (2.*rnd.Rndm()-1.)*max_dp;
      double f = maj1*rnd.Rndm();
      
      double fp = (*pdf)(mbc, de, no_dp ? 0 : dp, par);
    
      if (fp > maj1) {
        maj1 = 1.5*fp;
        printf("Updated majorant: %f\n", maj1);
      }

      if (f < fp) {
        if (i>=0) fprintf(file,"%f %f %f\n", mbc, de, dp);
        break;
      }
      
      if (j==100000-1) printf("Failed. F=%f, maj=%f\n", fp, maj1);
    }
    
  }
  
  fclose(file);
  
  return maj1;
  
}

double gen_bck(TString filename, int num, double* par, double maj) {
  return gen(filename,num,par,maj,&pdf_bck);
}

double gen_dbck(TString filename, int num, double* par, double maj) {
  return gen(filename,num,par,maj,&pdf_dbck);
}

double gen_sig(TString filename, int num, double* par, double maj) {
  return gen(filename,num,par,maj,&pdf_sig);
}

double gen_exp(TString filename, int num, double* par, double maj) {
  return gen(filename,num,par,maj,&pdf_exp);
}

double gen_maj(TString filename, int num, double* par, double maj) {
  TRandom3 rnd(gen_seed);
  
  FILE* file = fopen(filename,"w");
  
  double maj1 = maj;
  
  for (int i=-1000; i<num; i++) {
    if ((i) % 100000 == 0) printf("Generating event %d\n", i);

    double mbc = min_mbc + (max_mbc-min_mbc)*rnd.Rndm();
    double de = (2.*rnd.Rndm()-1.)*max_de;
    double dp = (2.*rnd.Rndm()-1.)*max_dp;
    double f = maj*rnd.Rndm();
      
    double fp = pdf_exp(mbc, de, no_dp ? 0 : dp, par);
    
    if (fp > maj1) {
      maj1 = 1.5*fp;
      printf("Updated majorant: %f\n", maj1);
    }

    if (f < fp && i>0) fprintf(file,"%f %f %f\n", mbc, de, dp);
  }
  
  fclose(file);
  
  return maj1;
}

void load_sig(TString filename, int skip=0, int max=1000000) {
  FILE* file = fopen(filename,"r");

  num_sig = 0;
  
  int i=0;

  while (!feof(file)) {
    double mbc,de,dp;
    if (fscanf(file,"%lf %lf %lf", &mbc,&de,&dp) == 3) {
      if (i>=skip) {
        sig[num_sig].mbc = mbc;
        sig[num_sig].de = de;
        sig[num_sig].dp = dp;
        num_sig++;
        if (num_sig >= max) break;
      }
      i++;
    }
  }
  
  fclose(file);
}

void read_par(TString filename, int npar, double* par, double* epar) {
  FILE* file = fopen(filename, "r");
  if (!file) {
    printf("Error opening file %s\n", filename.Data());
    return;
  }
  printf("Reading file %s\n", filename.Data());
  
  for (int i=0; i<npar; i++) {
    int dummy;
    fscanf(file, "%d %lf %lf", &dummy, &par[i], &epar[i]);
    printf("%s : par(%d)=%f +- %f\n", filename.Data(), i, par[i], epar[i]);
  }
  fclose(file);
}

void write_par(TString filename, int npar, double* par, double* epar) {
  FILE* file = fopen(filename, "w");
  for (int i=0; i<npar; i++) {
    fprintf(file, "%d %lf %lf\n", i, par[i], epar[i]);
  }
  fclose(file);
}

void fit_bck() {
  make_norm();

  TVirtualFitter *minuit = TVirtualFitter::Fitter(0, 4);
  minuit->SetFCN(fit_func_bck);

  minuit->SetParameter(0, "C_mbc",    bck_par[0], bck_epar[0], 0,0);
  minuit->SetParameter(1, "C_de" ,    bck_par[1], bck_epar[1], 0,0);
  minuit->SetParameter(2, "Ebeam",    bck_par[2], bck_epar[2], 0,0);
  minuit->SetParameter(3, "DPcurv",   bck_par[3], bck_epar[3], 0,0);
  minuit->SetParameter(4, "C2_de",    bck_par[4], bck_epar[4], 0,0);

  double arglist[100];

  arglist[0] = 3;
  minuit->ExecuteCommand("FIX", arglist, 1);

//  if (no_dp) {
//    arglist[0] = 4;
//    minuit->ExecuteCommand("FIX", arglist, 1);
//  }

  arglist[0] = 1;
  minuit->ExecuteCommand("MIGRAD", arglist, 0);

  for (int i=0; i<BCK_PARS; i++) {
    bck_par[i] = minuit->GetParameter(i);
    bck_epar[i] = minuit->GetParError(i);
  }
}

void fit_dbck() {
  make_norm();

  TVirtualFitter *minuit = TVirtualFitter::Fitter(0, 14);
  minuit->SetFCN(fit_func_dbck);

  minuit->SetParameter(0, "C_mbc",     dbck_par[0], dbck_epar[0], 0,0);
  minuit->SetParameter(1, "C_de" ,     dbck_par[1], dbck_epar[1], 0,0);
  minuit->SetParameter(2, "Ebeam",     dbck_par[2], dbck_epar[2], 0,0);
  minuit->SetParameter(3, "DPcurv",    dbck_par[3], dbck_epar[3], 0,0);
  minuit->SetParameter(4, "DEmean" ,   dbck_par[4], dbck_epar[4], 0,0);
  minuit->SetParameter(5, "DEsigma",   dbck_par[5], dbck_epar[5], 0,0);
  minuit->SetParameter(6, "DEfrac",    dbck_par[6], dbck_epar[6], 0,0);
  minuit->SetParameter(7, "MBCmean",   dbck_par[7], dbck_epar[7], 0,0);
  minuit->SetParameter(8, "MBCsig0",   dbck_par[8], dbck_epar[8], 0,0);
  minuit->SetParameter(9, "MBCsig1",   dbck_par[9], dbck_epar[9], 0,0);
  minuit->SetParameter(10, "DE1mean" , dbck_par[10], dbck_epar[10], 0,0);
  minuit->SetParameter(11, "DE1sigma", dbck_par[11], dbck_epar[11], 0,0);
  minuit->SetParameter(12, "DE1frac",  dbck_par[12], dbck_epar[12], 0,0);
  minuit->SetParameter(13, "MBC1mean", dbck_par[13], dbck_epar[13], 0,0);

  double arglist[100];

  arglist[0] = 3;
  minuit->ExecuteCommand("FIX", arglist, 1);

  if (no_dp) {
    arglist[0] = 4;
    minuit->ExecuteCommand("FIX", arglist, 1);
  }
  
  arglist[0] = 1;
  minuit->ExecuteCommand("MIGRAD", arglist, 0);

  for (int i=0; i<DBCK_PARS; i++) {
    dbck_par[i] = minuit->GetParameter(i);
    dbck_epar[i] = minuit->GetParError(i);
  }

}

void fit_sig() {
  make_norm();

  TVirtualFitter *minuit = TVirtualFitter::Fitter(0, 30);
  minuit->SetFCN(fit_func_sig);

  minuit->SetParameter(0, "MbcMean",   sig_par[0], sig_epar[0], 0,0);
  minuit->SetParameter(1, "DEMean" ,   sig_par[1], sig_epar[1], 0,0);
  minuit->SetParameter(2, "Corr",      sig_par[2], sig_epar[2], 0,0);
  minuit->SetParameter(3, "MbcSl",     sig_par[3], sig_epar[3], 0,0);
  minuit->SetParameter(4, "MbcSr" ,    sig_par[4], sig_epar[4], 0,0);
  minuit->SetParameter(5, "DES",       sig_par[5], sig_epar[5], 0,0);
  minuit->SetParameter(6, "EBeam",     sig_par[6], sig_epar[6], 0,0);
  minuit->SetParameter(7, "BCK",       sig_par[7], sig_epar[7], 0,0);
  minuit->SetParameter(8, "MbcS2",     sig_par[8], sig_epar[8], 0,0);
  minuit->SetParameter(9, "MbcWShift", sig_par[9], sig_epar[9], 0,0);
  minuit->SetParameter(10, "MbcWFrac", sig_par[10], sig_epar[10], 0,0);
  minuit->SetParameter(11, "MbcWSigma",sig_par[11], sig_epar[11], 0,0);
  minuit->SetParameter(12, "DEWSigma", sig_par[12], sig_epar[12], 0,0);
  minuit->SetParameter(13, "CorrW",    sig_par[13], sig_epar[13], 0,0);
  minuit->SetParameter(14, "DPcurv",   sig_par[14], sig_epar[14], 0,0);
  minuit->SetParameter(15, "MbcS4",    sig_par[15], sig_epar[15], 0,0);
  minuit->SetParameter(16, "C_mbc",    sig_par[16], sig_epar[16], 0,0);
  minuit->SetParameter(17, "C_de" ,    sig_par[17], sig_epar[17], 0,0);
  minuit->SetParameter(18, "Ebeam",    sig_par[18], sig_epar[18], 0,0);
  minuit->SetParameter(19, "DPcurv",   sig_par[19], sig_epar[19], 0,0);
  minuit->SetParameter(20, "DEmean" ,  sig_par[20], sig_epar[20], 0,0);
  minuit->SetParameter(21, "DEsigma",  sig_par[21], sig_epar[21], 0,0);
  minuit->SetParameter(22, "DEfrac",   sig_par[22], sig_epar[22], 0,0);
  minuit->SetParameter(23, "MBCmean",  sig_par[23], sig_epar[23], 0,0);
  minuit->SetParameter(24, "MBCsig0",  sig_par[24], sig_epar[24], 0,0);
  minuit->SetParameter(25, "MBCsig1",  sig_par[25], sig_epar[25], 0,0);
  minuit->SetParameter(26, "DE1mean" , sig_par[26], sig_epar[26], 0,0);
  minuit->SetParameter(27, "DE1sigma", sig_par[27], sig_epar[27], 0,0);
  minuit->SetParameter(28, "DE1frac",  sig_par[28], sig_epar[28], 0,0);
  minuit->SetParameter(29, "MBC1mean", sig_par[29], sig_epar[29], 0,0);

  double arglist[100];

  arglist[0] = 19;
  minuit->ExecuteCommand("FIX", arglist, 1);

  arglist[0] = 7;
  minuit->ExecuteCommand("FIX", arglist, 1);
  
  if (no_dp) {
    arglist[0] = 9;
    minuit->ExecuteCommand("FIX", arglist, 1);
    arglist[0] = 15;
    minuit->ExecuteCommand("FIX", arglist, 1);
    arglist[0] = 16;
    minuit->ExecuteCommand("FIX", arglist, 1);
    arglist[0] = 20;
    minuit->ExecuteCommand("FIX", arglist, 1);
  }
  
  arglist[0] = 1;
  minuit->ExecuteCommand("MIGRAD", arglist, 0);

  for (int i=0; i<SIG_PARS; i++) {
    sig_par[i] = minuit->GetParameter(i);
    sig_epar[i] = minuit->GetParError(i);
  }


}

void fit_exp() {
  make_norm();

  TVirtualFitter *minuit = TVirtualFitter::Fitter(0, 8);
  minuit->SetFCN(fit_func_exp);

  minuit->SetParameter(0, "MD",   exp_par[0], exp_epar[0], 0,0);
  minuit->SetParameter(1, "DE" ,  exp_par[1], exp_epar[1], 0,0);
  minuit->SetParameter(2, "Bck",  exp_par[2], exp_epar[2], 0,0);
  minuit->SetParameter(3, "DBck", exp_par[3], exp_epar[3], 0,0);
  minuit->SetParameter(4, "Sig",  exp_par[4], exp_epar[4], 0,0);

  double arglist[100];

  arglist[0] = 5;
  minuit->ExecuteCommand("FIX", arglist, 1);
  arglist[0] = 1;
  minuit->ExecuteCommand("MIGRAD", arglist, 0);

  for (int i=0; i<EXP_PARS; i++) {
    exp_par[i] = minuit->GetParameter(i);
    exp_epar[i] = minuit->GetParError(i);
  }

}

void fit_exp2() {
  make_norm();

  TVirtualFitter *minuit = TVirtualFitter::Fitter(0, 8);
  minuit->SetFCN(fit_func_exp2);

  minuit->SetParameter(0, "MD",   exp_par[0], exp_epar[0], 0,0);
  minuit->SetParameter(1, "DE" ,  exp_par[1], exp_epar[1], 0,0);
  minuit->SetParameter(2, "Bck",  exp_par[2], exp_epar[2], 0,0);
  minuit->SetParameter(3, "DBck", exp_par[3], exp_epar[3], 0,0);
  minuit->SetParameter(4, "Sig",  exp_par[4], exp_epar[4], 0,0);
  minuit->SetParameter(5, "CMbc", exp_par[5], exp_epar[5], 0,0);
  minuit->SetParameter(6, "CDE",  exp_par[6], exp_epar[6], 0,0);

  double arglist[100];

  arglist[0] = 5;
  minuit->ExecuteCommand("FIX", arglist, 1);
  arglist[0] = 1;
  minuit->ExecuteCommand("MIGRAD", arglist, 0);

  for (int i=0; i<EXP2_PARS; i++) {
    exp_par[i] = minuit->GetParameter(i);
    exp_epar[i] = minuit->GetParError(i);
  }

}
