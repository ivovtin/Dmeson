/***************************************************************************** 
 * Project: RooFit                                                           * 
 *                                                                           * 
 * This code was autogenerated by RooClassFactory                            * 
 *****************************************************************************/ 

// Your description goes here... 

#include "Riostream.h" 

#include "RooSigPdf.h" 
#include "RooAbsReal.h" 
#include "RooAbsCategory.h" 
#include <math.h> 
#include "TMath.h" 

ClassImp(RooSigPdf); 

 RooSigPdf::RooSigPdf(const char *name, const char *title, 
                        RooAbsReal& _mbc,
                        RooAbsReal& _de,
                        RooAbsReal& _dp,
                        RooAbsReal& _mbc_mean,
                        RooAbsReal& _de_mean,
                        RooAbsReal& _mbcde_corr,
                        RooAbsReal& _mbc_sigma0_l,
                        RooAbsReal& _mbc_sigma0_r,
                        RooAbsReal& _de_sigma,
                        RooAbsReal& _ebeam,
                        RooAbsReal& _bck,
                        RooAbsReal& _mbc_sigma2,
                        RooAbsReal& _mbcw_shift,
                        RooAbsReal& _mbcw_frac,
                        RooAbsReal& _mbcw_sigma,
                        RooAbsReal& _dew_sigma,
                        RooAbsReal& _mbcdew_corr,
                        RooAbsReal& _dpcurv,
                        RooAbsReal& _mbc_sigma4,
                        RooAbsReal& _dbck_alpha_mbc,
                        RooAbsReal& _dbck_alpha_de,
                        RooAbsReal& _dbck_ebeam,
                        RooAbsReal& _dbck_dpcurv,
                        RooAbsReal& _dbck_de_mean,
                        RooAbsReal& _dbck_de_width,
                        RooAbsReal& _dbck_de_frac,
                        RooAbsReal& _dbck_mbc_mean,
                        RooAbsReal& _dbck_mbc_sigma0,
                        RooAbsReal& _dbck_mbc_sigma1,
                        RooAbsReal& _dbck_de_mean1,
                        RooAbsReal& _dbck_de_width1,
                        RooAbsReal& _dbck_de_frac1,
                        RooAbsReal& _dbck_de_frac2,
                        RooAbsReal& _dbck_mbc_shift,
                        RooAbsReal& _dbck_mbc_sigma2) :
   RooAbsPdf(name,title), 
   mbc("mbc","mbc",this,_mbc),
   de("de","de",this,_de),
   dp("dp","dp",this,_dp),
   mbc_mean("mbc_mean","mbc_mean",this,_mbc_mean),
   de_mean("de_mean","de_mean",this,_de_mean),
   mbcde_corr("mbcde_corr","mbcde_corr",this,_mbcde_corr),
   mbc_sigma0_l("mbc_sigma0_l","mbc_sigma0_l",this,_mbc_sigma0_l),
   mbc_sigma0_r("mbc_sigma0_r","mbc_sigma0_r",this,_mbc_sigma0_r),
   de_sigma("de_sigma","de_sigma",this,_de_sigma),
   ebeam("ebeam","ebeam",this,_ebeam),
   bck("bck","bck",this,_bck),
   mbc_sigma2("mbc_sigma2","mbc_sigma2",this,_mbc_sigma2),
   mbcw_shift("mbcw_shift","mbcw_shift",this,_mbcw_shift),
   mbcw_frac("mbcw_frac","mbcw_frac",this,_mbcw_frac),
   mbcw_sigma("mbcw_sigma","mbcw_sigma",this,_mbcw_sigma),
   dew_sigma("dew_sigma","dew_sigma",this,_dew_sigma),
   mbcdew_corr("mbcdew_corr","mbcdew_corr",this,_mbcdew_corr),
   dpcurv("dpcurv","dpcurv",this,_dpcurv),
   mbc_sigma4("mbc_sigma4","mbc_sigma4",this,_mbc_sigma4),
   dbck_alpha_mbc("dbck_alpha_mbc","dbck_alpha_mbc",this,_dbck_alpha_mbc),
   dbck_alpha_de("dbck_alpha_de","dbck_alpha_de",this,_dbck_alpha_de),
   dbck_ebeam("dbck_ebeam","dbck_ebeam",this,_dbck_ebeam),
   dbck_dpcurv("dbck_dpcurv","dbck_dpcurv",this,_dbck_dpcurv),
   dbck_de_mean("dbck_de_mean","dbck_de_mean",this,_dbck_de_mean),
   dbck_de_width("dbck_de_width","dbck_de_width",this,_dbck_de_width),
   dbck_de_frac("dbck_de_frac","dbck_de_frac",this,_dbck_de_frac),
   dbck_mbc_mean("dbck_mbc_mean","dbck_mbc_mean",this,_dbck_mbc_mean),
   dbck_mbc_sigma0("dbck_mbc_sigma0","dbck_mbc_sigma0",this,_dbck_mbc_sigma0),
   dbck_mbc_sigma1("dbck_mbc_sigma1","dbck_mbc_sigma1",this,_dbck_mbc_sigma1),
   dbck_de_mean1("dbck_de_mean1","dbck_de_mean1",this,_dbck_de_mean1),
   dbck_de_width1("dbck_de_width1","dbck_de_width1",this,_dbck_de_width1),
   dbck_de_frac1("dbck_de_frac1","dbck_de_frac1",this,_dbck_de_frac1),
   dbck_de_frac2("dbck_de_frac2","dbck_de_frac2",this,_dbck_de_frac2),
   dbck_mbc_shift("dbck_mbc_shift","dbck_mbc_shift",this,_dbck_mbc_shift),
   dbck_mbc_sigma2("dbck_mbc_sigma2","dbck_mbc_sigma2",this,_dbck_mbc_sigma2)
 { 
 } 


 RooSigPdf::RooSigPdf(const RooSigPdf& other, const char* name) :  
   RooAbsPdf(other,name), 
   mbc("mbc",this,other.mbc),
   de("de",this,other.de),
   dp("dp",this,other.dp),
   mbc_mean("mbc_mean",this,other.mbc_mean),
   de_mean("de_mean",this,other.de_mean),
   mbcde_corr("mbcde_corr",this,other.mbcde_corr),
   mbc_sigma0_l("mbc_sigma0_l",this,other.mbc_sigma0_l),
   mbc_sigma0_r("mbc_sigma0_r",this,other.mbc_sigma0_r),
   de_sigma("de_sigma",this,other.de_sigma),
   ebeam("ebeam",this,other.ebeam),
   bck("bck",this,other.bck),
   mbc_sigma2("mbc_sigma2",this,other.mbc_sigma2),
   mbcw_shift("mbcw_shift",this,other.mbcw_shift),
   mbcw_frac("mbcw_frac",this,other.mbcw_frac),
   mbcw_sigma("mbcw_sigma",this,other.mbcw_sigma),
   dew_sigma("dew_sigma",this,other.dew_sigma),
   mbcdew_corr("mbcdew_corr",this,other.mbcdew_corr),
   dpcurv("dpcurv",this,other.dpcurv),
   mbc_sigma4("mbc_sigma4",this,other.mbc_sigma4),
   dbck_alpha_mbc("dbck_alpha_mbc",this,other.dbck_alpha_mbc),
   dbck_alpha_de("dbck_alpha_de",this,other.dbck_alpha_de),
   dbck_ebeam("dbck_ebeam",this,other.dbck_ebeam),
   dbck_dpcurv("dbck_dpcurv",this,other.dbck_dpcurv),
   dbck_de_mean("dbck_de_mean",this,other.dbck_de_mean),
   dbck_de_width("dbck_de_width",this,other.dbck_de_width),
   dbck_de_frac("dbck_de_frac",this,other.dbck_de_frac),
   dbck_mbc_mean("dbck_mbc_mean",this,other.dbck_mbc_mean),
   dbck_mbc_sigma0("dbck_mbc_sigma0",this,other.dbck_mbc_sigma0),
   dbck_mbc_sigma1("dbck_mbc_sigma1",this,other.dbck_mbc_sigma1),
   dbck_de_mean1("dbck_de_mean1",this,other.dbck_de_mean1),
   dbck_de_width1("dbck_de_width1",this,other.dbck_de_width1),
   dbck_de_frac1("dbck_de_frac1",this,other.dbck_de_frac1),
   dbck_de_frac2("dbck_de_frac2",this,other.dbck_de_frac2),
   dbck_mbc_shift("dbck_mbc_shift",this,other.dbck_mbc_shift),
   dbck_mbc_sigma2("dbck_mbc_sigma2",this,other.dbck_mbc_sigma2)
 { 
 } 



 Double_t RooSigPdf::evaluate() const 
 { 
   // ENTER EXPRESSION IN TERMS OF VARIABLE ARGUMENTS HERE 
   //return dpsig*(desig*mbcsig + fabs(mbcw_frac)*desig2*mbcsig2)+fabs(bck)/1e5*pdf_dbck(mbc, de, dp, dbck_par) ; 
  double min_mbc = 1700.;
  double max_mbc = 1900.;
  double max_de = 300.;
  double dbck_mbc_mean1 = 1865.1;

  if (mbc > ebeam) return 0;
  if (mbc < min_mbc) return 0;
  if (fabs(de)>max_de) return 0;

  double dp_max = sqrt(ebeam*ebeam - mbc*mbc);

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

    double p_mbc = exp(dbck_alpha_mbc*(mbc*mbc-dbck_ebeam*dbck_ebeam)/dbck_ebeam/dbck_ebeam);
    double p_de = exp(-dbck_alpha_de*de/1000.);
    
    double p_mbc2 = exp(-pow(mbc-dbck_mbc_mean,2)/2./dbck_mbc_sigma0/dbck_mbc_sigma0);
    double p_mbc3 = exp(-pow(mbc-dbck_mbc_mean1-dbck_mbc_shift,2)/2./dbck_mbc_sigma1/dbck_mbc_sigma1);
    double p_mbc4 = exp(-pow(mbc-dbck_mbc_mean1+dbck_mbc_shift,2)/2./dbck_mbc_sigma2/dbck_mbc_sigma2);
    double p_de2 = exp(-pow(de-dbck_de_mean,2)/2./dbck_de_width/dbck_de_width);
    double p_de3 = exp(-pow(de-dbck_de_mean1,2)/2./dbck_de_width1/dbck_de_width1);
    double p_de4 = exp(-pow(de+dbck_de_mean1,2)/2./dbck_de_width1/dbck_de_width1);

    return dpsig*(desig*mbcsig + fabs(mbcw_frac)*desig2*mbcsig2) + fabs(bck)/1e5*(p_mbc*p_de+fabs(dbck_de_frac)*p_mbc2*p_de2+fabs(dbck_de_frac1)*p_mbc3*p_de3 + fabs(dbck_de_frac2)*p_mbc4*p_de4)*fabs(1.+dpcurv*dp*dp/1000./1000.);
  }
  return 0.;

 } 


