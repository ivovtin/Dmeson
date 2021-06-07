C********************************************************************
       SUBROUTINE AFcnst
C********************************************************************
C    Inicialisation of parameters for calculation
C          Phi -> a0 gamma -> eta pi0 gamma,
C       Phi -> f0 gamma -> pi0 pi0 gamma decays
C  Parameters are stored in /gR980a/ and described in a0f0data.inc
C                         Al.Berdugin
C********************************************************************
C
       implicit none	
       include 'a0f0data.inc'
       logical KLU/.false./
       save KLU
       if(KLU)return
       KLU=.true.
C
C========= Inicialisation
C
       PhPhiA0=0.D0
       PhPhiF0=0.D0
       gA0EtaPi=sqrt(1.32D6*3.1415926D0)
       gA0KcKc=gA0EtaPi/1.6D0
       gA0EtapPi=1.2D0*gA0KcKc
       gF0KcKc=gA0KcKc
       gF02Pi=sqrt(1.D0/12.D0)*gF0KcKc
       gF02Pi0=sqrt(0.5)*gF02Pi
       gF02Eta=0.91D0*gF0KcKc
       gF0EtaEtap=0.96*gF0KcKc
       gF02Etap=0.51*gF0KcKc
       MsSigma=1480.D0
       GSigma=300.D0
       gSigma2Pi=sqrt(7.2D0*3.1415926D0)
       return
       END
C
       SUBROUTINE pra0f0
C********************************************************************
C         Print of parameters for calculation
C          Phi -> a0 gamma -> eta pi0 gamma,
C       Phi -> f0 gamma -> pi0 pi0 gamma decays,
C               if model not 2qaurk
C  Parameters are stored in /gR980a/ and described in a0f0data.inc
C                         Al.Berdugin
C********************************************************************
C
       implicit none
       include 'fitdata.inc'
       include 'a0f0data.inc'
       call IniFit
       call afcnst
       print 1,MsF0,gF0KcKc,gF02Pi,gF02Pi0,gF02Eta,
     #         gF0EtaEtap,gF02Etap
1      format(2x,'### const interection for f0 ###',/,
     #        6x,'mass f0 = ',E12.5,/,
     #        4x,'gF0K+K-       = ',E11.4,/,
     #        4x,'gF0Pi+Pi-     = ',E11.4,/,
     #        4x,'gF0Pi0Pi0     = ',E11.4,/,
     #        4x,'gF0Eta0Eta0   = ',E11.4,/,
     #        4x,'gF0Eta0Eta0p  = ',E11.4,/,
     #        4x,'gF0Eta0pEta0p = ',E11.4)
       print 2,MsA0,gA0KcKc,gA0EtaPi,gA0EtapPi
2      format(2x,'### const interection for a0 ###',/,
     #        6x,'mass a0 = ',E12.5,/,
     #        4x,'gA0K+K-       = ',E11.4,/,
     #        4x,'gA0Eta0Pi0    = ',E11.4,/,
     #        4x,'gA0Eta0pPi0   = ',E11.4)
       print 3,MsSigma,GSigma,gSigma2Pi,PhPhiF0
3      format(2x,'### const interaction for Sigma ###',/,
     #        6x,'mass Sigma = ',E12.5,/,
     #        4x,'GSigma        = ',E12.5,/,
     #        4X,'gSigma2Pi     = ',E12.5,/,
     #        4X,'PhPhiF0       = ',E12.5)
       return
       END
