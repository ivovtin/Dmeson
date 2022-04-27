/*****************************************************************************
 * Project: RooFit                                                           *
 *                                                                           *
  * This code was autogenerated by RooClassFactory                            * 
 *****************************************************************************/

#ifndef ROOUDSPDF
#define ROOUDSPDF

#include "RooAbsPdf.h"
#include "RooRealProxy.h"
#include "RooCategoryProxy.h"
#include "RooAbsReal.h"
#include "RooAbsCategory.h"
 
class RooudsPdf : public RooAbsPdf {
public:
  RooudsPdf() {} ; 
  RooudsPdf(const char *name, const char *title,
	      RooAbsReal& _mbc,
	      RooAbsReal& _ebeam,
	      RooAbsReal& _alpha_mbc,
	      RooAbsReal& _alpha_de,
	      RooAbsReal& _de,
	      RooAbsReal& _dpcurv,
	      RooAbsReal& _dp);
  RooudsPdf(const RooudsPdf& other, const char* name=0) ;
  virtual TObject* clone(const char* newname) const { return new RooudsPdf(*this,newname); }
  inline virtual ~RooudsPdf() { }

protected:

  RooRealProxy mbc ;
  RooRealProxy ebeam ;
  RooRealProxy alpha_mbc ;
  RooRealProxy alpha_de ;
  RooRealProxy de ;
  RooRealProxy dpcurv ;
  RooRealProxy dp ;
  
  Double_t evaluate() const ;

private:

  ClassDef(RooudsPdf,1) // Your description goes here...
};
 
#endif
