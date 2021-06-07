C================================================================
C     Cross Section e+e- -> Pi+ Pi- Pi0
C================================================================
C         22.04.96   V.Ivanchenko
C================================================================
c+++ R8 cr3pi( R8 e2 ) cross section ee -> pi+ pi- pi0
       real*8 function cr3pi(e2)
       implicit none	
       include 'fitdata.inc'
       real*8 e2,e22

c --- functions
        real*8 wdom3pi, wdphi3pi
        complex*16 dpom, dpphi

c --- locals
	complex*16 amp, xf, xo
	logical klu/.true./
	save klu

       if(klu)then
         call inifit
         klu=.false.
       end if

       xo  = dcmplx(cos(deg2rad*phom),sin(deg2rad*phom))
       xf  = dcmplx(cos(deg2rad*phphi),sin(deg2rad*phphi))
       e22 = e2**2

       amp=
     @     sqrt(wdom3pi(e2)*msom**3*bromee*gom)*xo/dpom(e22)
     @    +
     @     sqrt(wdphi3pi(e2)*msphi**3*brphiee*gphi)*xf/dpphi(e22)

       cr3pi=12.d0*pi*mevnb*(abs(amp))**2/e2**3
       end
