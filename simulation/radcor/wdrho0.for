C********************************************************************
C    Set of functions to determine Rho widths
C          09.08.99  D.Bukin (references to the work of N.N.Achasov
c	             "Rho primes in analyzing e+e- annihilation...",
c                    Phys.Rev. D55 (1997) 2663-2671,
c                    hep-ph/9609216      
C          11.12.96  V.Ivanchenko
C***************************************************************


c+++ R8 wdrho( R8 e2 ) width of rho(770)
      real*8 function wdrho(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, wdrho2pi, wdrhoompi
      wdrho = wdrho2pi(e2) + wdrhoompi(e2)
      end


c+++ R8 wdrho2pi( R8 e2 ) width of rho -> 2pi
c+++    depends on MsRho, MsPi, gRhoPiPi
      real*8 function wdrho2pi(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, s, qpp3, cpgrhopipi, ccrho2pi
      logical firstpass /.true./
      save firstpass
c
      if ( firstpass ) then
        call inifit
        firstpass = .false.
      endif
      if ( e2.le.mspi*2 ) then
        wdrho2pi = 0.
      else
        s = e2**2
        qpp3 = (s/4.0d0 - mspi**2)**1.5d0
        wdrho2pi = cpgrhopipi()**2 / 6.0d0 / pi * qpp3 / s *
     &    ccrho2pi(e2)
      endif
c      write (6,*) 'wdrho2pi:', wdrho2pi
c      write (6,*) 'wdrho2pi, cpgrhopipi:', wdrho2pi, cpgrhopipi()
      end

      real*8 function wdrhoompi(e2)
      implicit none
      real*8 e2
      include 'fitdata.inc'
      real*8 qomp3, cpgrhoompi, ccrhoompi, phsp2
c
      if ( e2.le.(msom+mspi0) ) then
        wdrhoompi = 0.0d0
      else
        wdrhoompi = cpgrhoompi()**2 / 12.0d0 / pi *
     &    phsp2(e2,msom,mspi0)**3 *
     &    ccrhoompi(e2)
      endif
c      write (6,*) 'wdrhoompi, ccrhoompi(e2):', wdrhoompi, ccrhoompi(e2)
      end

c+++ C16 dprho( R8 s ) inverse propagator of rho(770)
      complex*16 function dprho(s)
C********************************************************************
C      Inverse propagator of Rho 
C      Avvakumov S.
C********************************************************************
      implicit none
      real*8 s
      include 'fitdata.inc'
      real*8 e2
      real*8 wdrho
      if ( s.gt.0 ) then
        e2=sqrt(s)
        dprho = dcmplx( msrho**2 - s, -e2 * wdrho(e2) )
      else
        dprho = (0.0d0,0.0d0)
      endif
      end

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
        wsp0=phsp2(msrho,mspi0,0.d0)
      end if

      if(E2.le.MsPi0)then
        WdRhoPi0G=0.D0
        return
      end if
      wdrhopi0g=grho*brrhopi0g*(phsp2(e2,mspi0,0.d0)/wsp0)**3
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
