/*****************************************************************************
 * Project: RooFit                                                           *
 *                                                                           *
  * This code was autogenerated by RooClassFactory                            * 
 *****************************************************************************/

#ifndef ROOSIGPDF
#define ROOSIGPDF

#include "RooAbsPdf.h"
#include "RooRealProxy.h"
#include "RooCategoryProxy.h"
#include "RooAbsReal.h"
#include "RooAbsCategory.h"
 
class RooSigPdf : public RooAbsPdf {
public:
  RooSigPdf() {} ; 
  RooSigPdf(const char *name, const char *title,
	      RooAbsReal& _mbc,
	      RooAbsReal& _de,
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
	      RooAbsReal& _dbck_mbc_mean1);
  RooSigPdf(const RooSigPdf& other, const char* name=0) ;
  virtual TObject* clone(const char* newname) const { return new RooSigPdf(*this,newname); }
  inline virtual ~RooSigPdf() { }

protected:

  RooRealProxy mbc ;
  RooRealProxy de ;
  RooRealProxy mbc_mean ;
  RooRealProxy de_mean ;
  RooRealProxy mbcde_corr ;
  RooRealProxy mbc_sigma0_l ;
  RooRealProxy mbc_sigma0_r ;
  RooRealProxy de_sigma ;
  RooRealProxy ebeam ;
  RooRealProxy bck ;
  RooRealProxy mbc_sigma2 ;
  RooRealProxy mbcw_shift ;
  RooRealProxy mbcw_frac ;
  RooRealProxy mbcw_sigma ;
  RooRealProxy dew_sigma ;
  RooRealProxy mbcdew_corr ;
  RooRealProxy dpcurv ;
  RooRealProxy mbc_sigma4 ;
  RooRealProxy dbck_alpha_mbc ;
  RooRealProxy dbck_alpha_de ;
  RooRealProxy dbck_ebeam ;
  RooRealProxy dbck_dpcurv ;
  RooRealProxy dbck_de_mean ;
  RooRealProxy dbck_de_width ;
  RooRealProxy dbck_de_frac ;
  RooRealProxy dbck_mbc_mean ;
  RooRealProxy dbck_mbc_sigma0 ;
  RooRealProxy dbck_mbc_sigma1 ;
  RooRealProxy dbck_de_mean1 ;
  RooRealProxy dbck_de_width1 ;
  RooRealProxy dbck_de_frac1 ;
  RooRealProxy dbck_mbc_mean1 ;
  
  Double_t evaluate() const ;

private:

  ClassDef(RooSigPdf,1) // Your description goes here...
};
 
#endif