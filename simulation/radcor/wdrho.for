C********************************************************************
C    Set of functions to determine Rho widths
C          11.12.96  V.Ivanchenko  
C***************************************************************

c+++ R8 wdrho( R8 e2 ) width of rho(770)
       real*8 function wdrho(e2)
C********************************************************************
C      Width of Rho
C      Ivanchenko V.
C********************************************************************
       implicit none
       include 'fitdata.inc'
       REAL*8 E2,WdRho2Pi
       WdRho=WdRho2Pi(E2)
       end

c+++ R8 wdrho2pi( R8 e2 ) width of rho -> 2pi
       real*8 function wdrho2pi(e2)
C********************************************************************
C      The width of ro->2pi decay.
C      Avvakumov S.
C      Ivanchenko V.
C********************************************************************

       implicit none
       include 'fitdata.inc'

       REAL*8 E2
       REAL*8 PhSp2,CcRho2Pi
       REAL*8 Wsp0,MsRho0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsRho0

       REAL*8  Mspi2,Factor/1.D0/
       LOGICAL CC/.false./
       SAVE    CC,Mspi2,Factor

       if(KLU.or.MsRho.ne.MsRho0)then
         KLU=.false.
         call INIFIT
         MsRho0=MsRho
         Mspi2=4.D0*Mspi**2
         Wsp0=MsRho**2-MsPi2
         if(CcRho2Pi(MsRho*2.D0).ne.1.D0)CC=.true.
       end if

       if(E2.le.MsPi+MsPi)then
         WdRho2Pi=0.D0
         return
       end if

       if(CC)Factor=CcRho2Pi(E2)

       WdRho2Pi=GRho*Factor*(sqrt((E2**2-MsPi2)/Wsp0))**3
     *         *(MsRho/E2)**2
       end

c+++ C16 dprho( R8 s ) inverse propagator of rho(770)
       complex*16 function dprho(s)
C********************************************************************
C      Inverse propagator of Rho 
C      Avvakumov S.
C********************************************************************
       implicit none
       include 'fitdata.inc'
       REAL*8 S,WdRho,E2
       E2=sqrt(S)
       DpRho=dcmplx(MsRho**2-S,-(E2*WdRho(E2)))
       END


       complex*16 function ddprho(e2)
       implicit none
       include 'fitdata.inc'
       real*8 e2, wdrho
       ddprho = dcmplx((msrho-e2)*(msrho+e2),-(e2*wdrho(e2)))
       end


c+++ R8 wdrhopi0g( R8 e2 ) width of rho -> pi0 gamma
       real*8 function wdrhopi0g(e2)
C********************************************************************
C      The width of rho->pi+gamma decay.
C       Ivanchenko V.
C********************************************************************

       implicit none
       include 'fitdata.inc'
       REAL*8 E2,PhSp2,Wsp0,MsRho0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsRho0

       if(KLU.or.MsRho.ne.MsRho0)then
         KLU=.false.
         call INIFIT
         MsRho0=MsRho
         Wsp0=PhSp2(MsRho,MsPi0,0.D0)
       end if

       if(E2.le.MsPi0)then
         WdRhoPi0G=0.D0
         return
       end if
       WdRhoPi0G=GRho*BrRhoPi0G*(PhSp2(E2,MsPi0,0.D0)/Wsp0)**3
       END


c+++ R8 wdrhoetag( R8 e2 ) width of rho -> eta gamma
       real*8 function wdrhoetag(e2)
C********************************************************************
C      The width of rho->eta+gamma decay.
C       Ivanchenko V.
C********************************************************************

       implicit none
       include 'fitdata.inc'
       REAL*8 E2,PhSp2,Wsp0,MsRho0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsRho0

       if(KLU.or.MsRho.ne.MsRho0)then
         KLU=.false.
         call INIFIT
         MsRho0=MsRho
         Wsp0=PhSp2(MsRho,MsEta,0.D0)
       end if

       if(E2.le.MsEta)then
         WdRhoEtaG=0.D0
         return
       end if

       wdrhoetag=grho*brrhoetag*(phsp2(e2,mseta,0.d0)/wsp0)**3
       END
