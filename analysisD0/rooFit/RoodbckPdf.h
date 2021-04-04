/*****************************************************************************
 * Project: RooFit                                                           *
 *                                                                           *
  * This code was autogenerated by RooClassFactory                            * 
 *****************************************************************************/

#ifndef ROODBCKPDF
#define ROODBCKPDF

#include "RooAbsPdf.h"
#include "RooRealProxy.h"
#include "RooCategoryProxy.h"
#include "RooAbsReal.h"
#include "RooAbsCategory.h"
 
class RoodbckPdf : public RooAbsPdf {
public:
  RoodbckPdf() {} ; 
  RoodbckPdf(const char *name, const char *title,
	      RooAbsReal& _mbc,
	      RooAbsReal& _ebeam,
	      RooAbsReal& _alpha_mbc,
	      RooAbsReal& _alpha_de,
	      RooAbsReal& _de,
	      RooAbsReal& _dpcurv,
	      RooAbsReal& _dp,
	      RooAbsReal& _de_mean,
	      RooAbsReal& _de_width,
	      RooAbsReal& _de_frac,
	      RooAbsReal& _mbc_mean,
	      RooAbsReal& _mbc_sigma0,
	      RooAbsReal& _mbc_sigma1,
	      RooAbsReal& _de_mean1,
	      RooAbsReal& _de_width1,
	      RooAbsReal& _de_frac1,
	      RooAbsReal& _de_frac2,
	      RooAbsReal& _mbc_shift,
	      RooAbsReal& _mbc_sigma2);
  RoodbckPdf(const RoodbckPdf& other, const char* name=0) ;
  virtual TObject* clone(const char* newname) const { return new RoodbckPdf(*this,newname); }
  inline virtual ~RoodbckPdf() { }

protected:

  RooRealProxy mbc ;
  RooRealProxy ebeam ;
  RooRealProxy alpha_mbc ;
  RooRealProxy alpha_de ;
  RooRealProxy de ;
  RooRealProxy dpcurv ;
  RooRealProxy dp ;
  RooRealProxy de_mean ;
  RooRealProxy de_width ;
  RooRealProxy de_frac ;
  RooRealProxy mbc_mean ;
  RooRealProxy mbc_sigma0 ;
  RooRealProxy mbc_sigma1 ;
  RooRealProxy de_mean1 ;
  RooRealProxy de_width1 ;
  RooRealProxy de_frac1 ;
  RooRealProxy de_frac2 ;
  RooRealProxy mbc_shift ;
  RooRealProxy mbc_sigma2 ;
  
  Double_t evaluate() const ;

private:

  ClassDef(RoodbckPdf,1) // Your description goes here...
};
 
#endif