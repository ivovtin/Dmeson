C********************************************************************
C    Set of functions to determine Phi widths 
C          11.12.96  V.Ivanchenko  
C***************************************************************
c+++ R8 wdphi( R8 e2 ) width of phi(1020)
       real*8 function wdphi(e2)
C********************************************************************
C      Width of Phi.
C      Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2
       REAL*8 WdPhi2Kc,WdPhiKsKl,WdPhi3Pi,WdPhiEtaG,WdPhiPi0G

       WdPhi=(WdPhi2Kc(E2)+WdPhiKsKl(E2)+WdPhi3Pi(E2)+WdPhiEtaG(E2)+
     #        WdPhiPi0G(E2))/
     #     (BrPhi2Kc+BrPhiKsKl+BrPhi3Pi+BrPhiEtaG+BrPhiPi0G)
       return
       end


c+++ R8 wdphi2kc( R8 e2 ) width of phi -> k+ k-
       real*8 function wdphi2kc(e2)
C********************************************************************
C      The width of FI->K+K- decay.
C      Avvakumov S.
C       Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2,PhSp2,Wsp0,MsPhi0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsPhi0

       if(KLU.or.MsPhi.ne.MsPhi0)then
         KLU=.false.
         call INIFIT
         MsPhi0=MsPhi
         Wsp0=PhSp2(MsPhi,MsKc,MsKc)
       end if

c --- Second logical added by BukinD 29.10.96
       if( e2.le.mskc+mskc .or. wsp0.eq.0 )then
         WdPhi2Kc=0.D0
         return
       end if

       WdPhi2Kc=GPhi*BrPhi2Kc*(PhSp2(E2,MsKc,MsKc)/Wsp0)**3*
     #          (MsPhi/E2)**2
       return
       END

c+++ R8 wdphikskl( R8 e2 ) width of phi -> ks kl 
       real*8 function wdphikskl(e2)
C********************************************************************
C      The width of FI->KsKl decay.
C      Avvakumov S.
C       Ivanchenko V.
C********************************************************************

       implicit none	
       include 'fitdata.inc'
       REAL*8 E2,PhSp2,Wsp0,MsPhi0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsPhi0

       if(KLU.or.MsPhi.ne.MsPhi0)then
         KLU=.false.
         call INIFIT
         MsPhi0=MsPhi
         Wsp0=PhSp2(MsPhi,MsKs,MsKs)
       end if

c --- Second logical added by BukinD 29.10.96
       if( E2.le.MsKs+MsKs .OR. Wsp0.EQ.0 )then
         WdPhiKsKl=0.D0
         return
       end if

       WdPhiKsKl=GPhi*BrPhiKsKl*(PhSp2(E2,MsKs,MsKs)/Wsp0)**3*
     #           (MsPhi/E2)**2
       return
       END

c+++ R8 wdphipi0g( R8 e2 ) width of phi -> pi0 gamma
       real*8 function wdphipi0g(e2)
C********************************************************************
C      The width of phi->pi+gamma decay.
C       Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2,PhSp2,Wsp0,MsPhi0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsPhi0

       if(KLU.or.MsPhi.ne.MsPhi0)then
         KLU=.false.
         call INIFIT
         MsPhi0=MsPhi
         Wsp0=PhSp2(MsPhi,MsPi0,0.D0)
       end if

       if(E2.le.MsPi0)then
         WdPhiPi0G=0.D0
         return
       end if

       WdPhiPi0G=GPhi*BrPhiPi0G*(PhSp2(E2,MsPi0,0.D0)/Wsp0)**3
       return
       END

c+++ R8 wdphietag( R8 e2 ) width of phi -> eta gamma
       real*8 function wdphietag(e2)
C********************************************************************
C      The width of Phi->eta+gamma decay.
C       Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2,PhSp2,Wsp0,MsPhi0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU,Wsp0,MsPhi0

       if(KLU.or.MsPhi.ne.MsPhi0)then
         KLU=.false.
         call INIFIT
         MsPhi0=MsPhi
         Wsp0=PhSp2(MsPhi,MsEta,0.D0)
       end if

       if(E2.le.MsEta)then
         WdPhiEtaG=0.D0
         return
       end if

       WdPhiEtaG=GPhi*BrPhiEtaG*(PhSp2(E2,MsEta,0.D0)/Wsp0)**3
       return
       END

c+++ R8 wdphi2pi( R8 e2 ) width of phi -> 2pi
       real*8 function wdphi2pi(e2)
C********************************************************************
C      The width of omega->2pi decay.
C      Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2,WdRho2Pi
       WdPhi2Pi=GPhi*BrPhi2Pi*WdRho2Pi(E2)/GRho
       return
       END

c+++ C16 dpphi( R8 s ) inverse propagator of phi(1020)
       complex*16 function dpphi(s)
C********************************************************************
C      Inverse propagator of Phi(1020).
C      Avvakumov S.
C      Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 S,E2
       REAL*8 WdPhi
       E2=sqrt(S)
       DpPhi=dcmplx(MsPhi**2-S,-(E2*WdPhi(E2)))
       return
       end

       complex*16 function ddpphi(e2)
       implicit none
       include 'fitdata.inc'
       real*8 e2
       real*8 wdphi
       ddpphi = dcmplx((msphi-e2)*(msphi+e2),-(e2*wdphi(e2)))
       end


c+++ R8 wdphi3pi( R8 e2 ) width of phi -> rho pi -> 3pi
       real*8 function wdphi3pi(e2)
C********************************************************************
C      Width of FI-->ro+pi-->3pi decay , dependent on s.
C      Avvakumov S.  26.05.95
C      IvanchenkoV. - M phi is fixed 
C********************************************************************
       implicit none
       include 'fitdata.inc'
       REAL*8 E2
       REAL*8 Sp3Pi,CcPhi3Pi
       REAL*8 Wsp0,MsPhi0/0.D0/
       LOGICAL KLU/.true./
       SAVE KLU, Wsp0, MsPhi0

       if(KLU.or.MsPhi.ne.MsPhi0)then
         KLU=.false.
         MsPhi0=MsPhi
         Wsp0=Sp3Pi(MsPhi)
       end if

       IF (E2.LT.2.D0*MsPi+MsPi0) THEN
          WdPhi3Pi=0.D0
          return
       ENDIF

       wdphi3pi=gphi*brphi3pi*sp3pi(e2)*ccphi3pi(e2)/wsp0
       end
