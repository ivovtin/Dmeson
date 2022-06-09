/***************************************************************************** 
 * Project: RooFit                                                           * 
 *                                                                           * 
 * This code was autogenerated by RooClassFactory                            * 
 *****************************************************************************/ 

// Your description goes here... 

#include "Riostream.h" 

#include "RooudsPdf.h" 
#include "RooAbsReal.h" 
#include "RooAbsCategory.h" 
#include <math.h> 
#include "TMath.h" 

ClassImp(RooudsPdf); 

 RooudsPdf::RooudsPdf(const char *name, const char *title, 
                        RooAbsReal& _mbc,
                        RooAbsReal& _ebeam,
                        RooAbsReal& _alpha_mbc,
                        RooAbsReal& _alpha_de,
                        RooAbsReal& _de,
                        RooAbsReal& _twist,
                        RooAbsReal& _c2_de) :
   RooAbsPdf(name,title), 
   mbc("mbc","mbc",this,_mbc),
   ebeam("ebeam","ebeam",this,_ebeam),
   alpha_mbc("alpha_mbc","alpha_mbc",this,_alpha_mbc),
   alpha_de("alpha_de","alpha_de",this,_alpha_de),
   de("de","de",this,_de),
   twist("twist","twist",this,_twist),
   c2_de("c2_de","c2_de",this,_c2_de)
 { 
 } 


 RooudsPdf::RooudsPdf(const RooudsPdf& other, const char* name) :  
   RooAbsPdf(other,name), 
   mbc("mbc",this,other.mbc),
   ebeam("ebeam",this,other.ebeam),
   alpha_mbc("alpha_mbc",this,other.alpha_mbc),
   alpha_de("alpha_de",this,other.alpha_de),
   de("de",this,other.de),
   twist("twist",this,other.twist),
   c2_de("c2_de",this,other.c2_de)
 { 
 } 



 Double_t RooudsPdf::evaluate() const 
 { 
   // ENTER EXPRESSION IN TERMS OF VARIABLE ARGUMENTS HERE 

   if (mbc > ebeam) return 0;
   double dp_max = sqrt(ebeam*ebeam - mbc*mbc);
   if (fabs(0.1)<dp_max) {
     double arg = alpha_mbc*(mbc/ebeam-1.);
     double ade = (-alpha_de+(twist*(mbc/ebeam-1.)))*de/1000. - c2_de*pow(de/1000.,2.);
     return exp(arg+ade)*dp_max/1000.;
   }
   return 0.;

 } 


