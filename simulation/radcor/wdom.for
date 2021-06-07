C********************************************************************
C    Set of functions to determine Omega widths 
C          11.12.96  V.Ivanchenko  
C***************************************************************
c+++ R8 wdom( R8 e2 ) width of omega(782)
       real*8 function wdom(e2)
C********************************************************************
C      Width of omega .
C      Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       real*8 e2

c --- Functions
       real*8 wdom3pi,wdompi0g,wdometag,wdom2pi
       wdom=(wdom3pi(e2)+wdompi0g(e2)+wdometag(e2)+wdom2pi(e2))/
     #      (brom3pi+brompi0g+brometag+brom2pi)
       end

c+++ R8 wdom3pi( R8 e2 ) width of omega->rho pi ->3pi
       real*8 function wdom3pi(e2)
C********************************************************************
C      Width of omega-->ro+pi-->3pi decay , depended on s.
C      Avvakumov S.  14.11.94
C      Ivanchenko V. 29.03.96
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       real*8 e2
c --- Functions
       REAL*8 Sp3Pi,CcOm3Pi
c --- Locals
       REAL*8 Wsp0,MsOm0/0.D0/,Factor/1.D0/
       LOGICAL KLU/.true./,CC/.false./
       SAVE KLU,CC,Wsp0,MsOm0,Factor

       if(KLU.or.MsOm.ne.MsOm0)then
         KLU=.false.
         call inifit
         msom0=msom
         wsp0=sp3pi(msom)
         if(CcOm3Pi(MsOm*2.D0).ne.1.D0)CC=.true.
       end if

       if ( e2.lt.2.d0*mspi+mspi0 ) then
          wdom3pi=0.d0
          return
       endif

       if(CC)Factor=CcOm3Pi(E2)

       wdom3pi=gom*brom3pi*sp3pi(e2)*factor/wsp0
       end


c+++ R8 wdompi0g( R8 e2 ) width of omega -> pi0 gamma
       real*8 function wdompi0g(e2)
C********************************************************************
C      The width of omega->pi+gamma decay.
C      Avvakumov S.
C       Ivanchenko V.
C********************************************************************

       implicit none	
       include 'fitdata.inc'
       REAL*8 E2,PhSp2
       REAL*8 Wsp0,MsOm0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsOm0

       if(KLU.or.MsOm.ne.MsOm0)then
         klu=.false.
         call inifit
         MsOm0=MsOm
         Wsp0=PhSp2(MsOm,MsPi0,0.D0)
       end if

       if(E2.le.MsPi0)then
         WdOmPi0G=0.D0
         return
       end if
       WdOmPi0G=GOm*BrOmPi0G*(PhSp2(E2,MsPi0,0.D0)/Wsp0)**3
       END


c+++ R8 wdometag( R8 e2 ) width of omega -> eta gamma
       real*8 function wdometag(e2)
C********************************************************************
C      The width of omega->eta+gamma decay.
C       Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2
       REAL*8 PhSp2
       REAL*8 Wsp0,MsOm0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsOm0

       if(KLU.or.MsOm.ne.MsOm0)then
         KLU=.false.
         call INIFIT
         MsOm0=MsOm
         Wsp0=PhSp2(MsOm,MsEta,0.D0)
       end if

       if(E2.le.MsEta)then
         WdOmEtaG=0.D0
         return
       end if
       WdOmEtaG=GOm*BrOmEtaG*(PhSp2(E2,MsEta,0.D0)/Wsp0)**3
       END


c+++ R8 wdom2pi( R8 e2 ) width of omega -> 2pi
       real*8 function wdom2pi(e2)
C********************************************************************
C      The width of omega->2pi decay.
C      Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       real*8 e2
       real*8 wdrho2pi
       WdOm2Pi=GOm*BrOm2Pi*WdRho2Pi(E2)/GRho
       end


c+++ C16 dpom( R8 s ) inverse propagator of omega
       complex*16 function dpom(s)
C********************************************************************
C      Inverse propagator of omega .
C      Avvakumov S.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       real*8 s,e2
c --- Functions
       real*8 wdom
       if ( s.gt.0 ) then
         e2=sqrt(s)
         dpom=dcmplx(msom**2-s,-(e2*wdom(e2)))
       else
         dpom = (0.0d0,0.0d0)
       endif
       end

       complex*16 function ddpom(e2)
       implicit none
       include 'fitdata.inc'
       real*8 e2
       real*8 wdom
       ddpom = dcmplx((msom-e2)*(msom+e2), -(e2*wdom(e2)) )
       end
