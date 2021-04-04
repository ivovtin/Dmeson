/***************************************************************************** 
 * Project: RooFit                                                           * 
 *                                                                           * 
 * This code was autogenerated by RooClassFactory                            * 
 *****************************************************************************/ 

// Your description goes here... 

#include "Riostream.h" 

#include "RoodbckPdf.h" 
#include "RooAbsReal.h" 
#include "RooAbsCategory.h" 
#include <math.h> 
#include "TMath.h" 

ClassImp(RoodbckPdf); 

 RoodbckPdf::RoodbckPdf(const char *name, const char *title, 
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
                        RooAbsReal& _mbc_sigma2) :
   RooAbsPdf(name,title), 
   mbc("mbc","mbc",this,_mbc),
   ebeam("ebeam","ebeam",this,_ebeam),
   alpha_mbc("alpha_mbc","alpha_mbc",this,_alpha_mbc),
   alpha_de("alpha_de","alpha_de",this,_alpha_de),
   de("de","de",this,_de),
   dpcurv("dpcurv","dpcurv",this,_dpcurv),
   dp("dp","dp",this,_dp),
   de_mean("de_mean","de_mean",this,_de_mean),
   de_width("de_width","de_width",this,_de_width),
   de_frac("de_frac","de_frac",this,_de_frac),
   mbc_mean("mbc_mean","mbc_mean",this,_mbc_mean),
   mbc_sigma0("mbc_sigma0","mbc_sigma0",this,_mbc_sigma0),
   mbc_sigma1("mbc_sigma1","mbc_sigma1",this,_mbc_sigma1),
   de_mean1("de_mean1","de_mean1",this,_de_mean1),
   de_width1("de_width1","de_width1",this,_de_width1),
   de_frac1("de_frac1","de_frac1",this,_de_frac1),
   de_frac2("de_frac2","de_frac2",this,_de_frac2),
   mbc_shift("mbc_shift","mbc_shift",this,_mbc_shift),
   mbc_sigma2("mbc_sigma2","mbc_sigma2",this,_mbc_sigma2)
 { 
 } 


 RoodbckPdf::RoodbckPdf(const RoodbckPdf& other, const char* name) :  
   RooAbsPdf(other,name), 
   mbc("mbc",this,other.mbc),
   ebeam("ebeam",this,other.ebeam),
   alpha_mbc("alpha_mbc",this,other.alpha_mbc),
   alpha_de("alpha_de",this,other.alpha_de),
   de("de",this,other.de),
   dpcurv("dpcurv",this,other.dpcurv),
   dp("dp",this,other.dp),
   de_mean("de_mean",this,other.de_mean),
   de_width("de_width",this,other.de_width),
   de_frac("de_frac",this,other.de_frac),
   mbc_mean("mbc_mean",this,other.mbc_mean),
   mbc_sigma0("mbc_sigma0",this,other.mbc_sigma0),
   mbc_sigma1("mbc_sigma1",this,other.mbc_sigma1),
   de_mean1("de_mean1",this,other.de_mean1),
   de_width1("de_width1",this,other.de_width1),
   de_frac1("de_frac1",this,other.de_frac1),
   de_frac2("de_frac2",this,other.de_frac2),
   mbc_shift("mbc_shift",this,other.mbc_shift),
   mbc_sigma2("mbc_sigma2",this,other.mbc_sigma2)
 { 
 } 



 Double_t RoodbckPdf::evaluate() const 
 { 
   // ENTER EXPRESSION IN TERMS OF VARIABLE ARGUMENTS HERE 
   //return (p_mbc*p_de+fabs(de_frac)*p_mbc2*p_de2+fabs(de_frac1)*p_mbc3*p_de3 + fabs(de_frac2)*p_mbc4*p_de4)*fabs(1.+dpcurv*dp*dp/1000./1000.) ; 
   
   //double mbc_mean1 = 1865.1;
   //double mbc_mean1 = 1864.8;
   //double mbc_mean1 = 1865.5; //+ 
   //double mbc_mean1 = 1865.3;
   //double mbc_mean1 = 1865.6;
   //double mbc_mean1 = 1865.4;
   //double mbc_mean1 = 1865.0; //+
   double mbc_mean1 = 1864.5;

   if (mbc > ebeam) return 0;
   double dp_max = sqrt(ebeam*ebeam - mbc*mbc);
   if (fabs(dp)<dp_max) {
     double p_mbc = exp(alpha_mbc*(mbc*mbc-ebeam*ebeam)/ebeam/ebeam);
     double p_de = exp(-alpha_de*de/1000.);

     //double mbc_sigma = mbc_sigma0*exp(-de*mbc_sigma1);
     //double mbc_sigma = mbc_sigma0-de*mbc_sigma1;

     double p_mbc2 = exp(-pow(mbc-mbc_mean,2)/2./mbc_sigma0/mbc_sigma0);
     //double p_mbc2 = exp((mbc-ebeam)/ebeam*mbc_sigma0);
     double p_mbc3 = exp(-pow(mbc-mbc_mean1-mbc_shift,2)/2./mbc_sigma1/mbc_sigma1);
     double p_mbc4 = exp(-pow(mbc-mbc_mean1+mbc_shift,2)/2./mbc_sigma2/mbc_sigma2);
     double p_de2 = exp(-pow(de-de_mean,2)/2./de_width/de_width);
     double p_de3 = exp(-pow(de-de_mean1,2)/2./de_width1/de_width1);
     double p_de4 = exp(-pow(de+de_mean1,2)/2./de_width1/de_width1);
     return (p_mbc*p_de+fabs(de_frac)*p_mbc2*p_de2+fabs(de_frac1)*p_mbc3*p_de3 + fabs(de_frac2)*p_mbc4*p_de4)*fabs(1.+dpcurv*dp*dp/1000./1000.);
     //return (p_mbc*p_de+fabs(de_frac)*p_mbc2*p_de2+fabs(de_frac1)*p_mbc3*p_de3)*fabs(1.+dpcurv*dp*dp/1000./1000.);
     //return p_mbc*p_de*fabs(1.+dpcurv*dp*dp/1000./1000.);
   }
   return 0.;
 } 



