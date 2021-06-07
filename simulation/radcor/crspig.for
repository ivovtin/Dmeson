C================================================================
C     Cross Section e+e- -> Pi0 + Gamma without Rho-Omega mixing
C================================================================
C         16.04.96   V.Ivanchenko
C================================================================
c+++ R8 crpi0g( R8 e2 ) cross section ee -> pi0 gamma
       real*8 function crpi0g(e2)
       implicit none
       include 'fitdata.inc'
       real*8 e2,e22

c --- functions
       real*8 wdompi0g, wdrhopi0g, wdphipi0g
       complex*16 dprho, dpom, dpphi

c --- locals
	complex*16 amp, xr, xo, xf
        logical klu/.true./
	save klu

       if(klu)then
         call inifit
         klu=.false.
       end if

       xr  = dcmplx(cos(deg2rad*phrho),sin(deg2rad*phrho))
       xo  = dcmplx(cos(deg2rad*phom),sin(deg2rad*phom))
       xf  = dcmplx(cos(deg2rad*phphi),sin(deg2rad*phphi))
       e22 = e2**2

       amp = sqrt(wdrhopi0g(e2)*msrho**3*brrhoee*grho)*xr/dprho(e22)
     &   +
     &   sqrt(wdompi0g(e2)*msom**3*bromee*gom)*xo/dpom(e22)
     &   +
     &   sqrt(wdphipi0g(e2)*msphi**3*brphiee*gphi)*xf/dpphi(e22)

       crpi0g=12.d0*pi*mevnb*(abs(amp))**2/e2**3
       end



C================================================================
C     Cross Section e+e- -> Eta + Gamma without Rho-Omega mixing
C================================================================
C         16.04.96   V.Ivanchenko
C================================================================
c+++ R8 cretag( R8 e2 ) cross section ee -> eta gamma
	real*8 function cretag(e2)
	implicit none
	include 'fitdata.inc'
	real*8 e2,e22

c --- functions
        real*8 wdometag, wdrhoetag, wdphietag
        complex*16 dprho, dpom, dpphi

c --- locals
	complex*16 amp, xr, xo, xf
	logical klu/.true./
        save klu


       if(klu)then
         call inifit
         klu=.false.
       end if

       xr  = dcmplx(cos(deg2rad*phrho),sin(deg2rad*phrho))
       xo  = dcmplx(cos(deg2rad*phom),sin(deg2rad*phom))
       xf  = dcmplx(cos(deg2rad*phphi),sin(deg2rad*phphi))
       e22 = e2**2

       amp=sqrt(wdrhoetag(e2)*msrho**3*brrhoee*grho)*xr/dprho(e22)
     &    +
     &     sqrt(wdometag(e2)*msom**3*bromee*gom)*xo/dpom(e22)
     &    +
     &     sqrt(wdphietag(e2)*msphi**3*brphiee*gphi)*xf/dpphi(e22)

       cretag=12.d0*pi*mevnb*(abs(amp))**2/e2**3
       end
