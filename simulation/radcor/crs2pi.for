C================================================================
C     Cross Section e+e- -> Pi+ Pi- without 
C================================================================
C         22.04.96   V.Ivanchenko
C================================================================
c+++ R8 cr2pi( R8 e2 ) cross section ee -> pi+ pi-
       real*8 function cr2pi(e2)
       implicit none	
       include 'fitdata.inc'
       real*8 e2,e22

c --- functions
        real*8 wdom2pi, wdrho2pi, wdphi2pi
        complex*16 dprho, dpom, dpphi

c --- Locals
       complex*16 amp, xr, xo, xf
       logical klu/.true./
	save klu

       if(klu)then
         call inifit
         klu=.false.
       end if

       xr  = dcmplx(cos(deg2rad*phrho),sin(deg2rad*phrho))
       xo  = dcmplx(cos(deg2rad*phom2pi),sin(deg2rad*phom2pi))
       xf  = dcmplx(cos(deg2rad*phphi2pi),sin(deg2rad*phphi2pi))
       e22 = e2**2

       amp=sqrt(wdrho2pi(e2)*msrho**3*brrhoee*grho)*xr/dprho(e22)
     @    +
     @     sqrt(wdom2pi(e2)*msom**3*bromee*gom)*xo/dpom(e22)
     @    +
     @     sqrt(wdphi2pi(e2)*msphi**3*brphiee*gphi)*xf/dpphi(e22)

       cr2pi=12.d0*pi*mevnb*(abs(amp))**2/e2**3
       end
