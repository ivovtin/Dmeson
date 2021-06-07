C================================================================
C      Cross Section e+e- -> K+ K-  
C================================================================
C         22.04.96   V.Ivanchenko
C================================================================
c+++ R8 cr2kc( R8 e2 ) cross section ee -> k+k-
        real*8 function cr2kc(e2)
	implicit none
        include 'fitdata.inc'
        REAL*8 E2,E22

c --- Functions
	COMPLEX*16 DpRho, DpOm, DpPhi
        REAL*8 WdPhi2Kc

c --- Locals
	COMPLEX*16 AMP, XR, XO, XF
	LOGICAL KLU/.true./

	SAVE KLU

	if (KLU) then
	  call inifit
	  KLU=.false.
	endif

	XR  = DCMPLX( cos(PhRho*DEG2RAD), sin(PhRho*DEG2RAD) )
	XO  = DCMPLX( cos(PhOm*DEG2RAD), sin(PhOm*DEG2RAD) )
	XF  = DCMPLX( cos(PhPhi*DEG2RAD), sin(PhPhi*DEG2RAD) )
        E22 = E2**2

	AMP = sqrt(WdPhi2Kc(E2)) * (
     @      sqrt(MsPhi**3*BrPhiEe*GPhi)*XF/DpPhi(E22)
     @    - sqrt(MsRho**3*BrRhoEe*GRho*0.5D0)*XR/DpRho(E22)
     @    - sqrt( MsOm**3*BrOmEe*GOm*0.5D0 )*XO/DpOm(E22)  )

	Cr2Kc=12.D0*Pi*MeVnb*(abs(AMP))**2/E2**3
	end


C================================================================
C     Cross Section e+e- -> Ks Kl  
C================================================================
C         22.04.96   V.Ivanchenko
C================================================================
c+++ R8 crkskl( R8 e2 )  cross section ee -> ks kl
       real*8 function crkskl(e2)
       implicit none
       include 'fitdata.inc'
       REAL*8 E2,E22

c --- Functions
	complex*16 dprho, dpom, dpphi
	real*8 wdphikskl

c --- Locals
       complex*16 amp, xr, xo, xf
       logical klu/.true./

       save klu

       if (KLU) then
         call inifit
         KLU=.false.
       endif

       xr  = dcmplx(cos(deg2rad*phrho),sin(deg2rad*phrho))
       xo  = dcmplx(cos(deg2rad*phom),sin(deg2rad*phom))
       xf  = dcmplx(cos(deg2rad*phphi),sin(deg2rad*phphi))
       e22 = e2**2

       amp=sqrt(wdphikskl(e2))*
     @    (sqrt(MsRho**3*BrRhoEe*GRho*0.5D0)*XR/DpRho(E22)
     @    -
     @     sqrt(MsOm**3*BrOmEe*GOm*0.5D0)*XO/DpOm(E22)
     @    +
     @     sqrt(MsPhi**3*BrPhiEe*GPhi)*XF/DpPhi(E22))

       CrKsKl=12.D0*Pi*MeVnb*(abs(AMP))**2/E2**3
       end
