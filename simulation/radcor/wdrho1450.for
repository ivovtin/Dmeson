C********************************************************************
C               RHO(1450) width
C         14.09.98   Viacheslav Shary
C***************************************************************

C********************************************************************
C      Width of Rho1450
C      Viacheslav Shary
C********************************************************************
c+++ R8 wdrho1450( R8 e2 ) width of rhop(1450)
      real*8 function wdrho1450(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, wdrho1450ompi0, wdrho1450pipi
      wdrho1450 = 
     &  (wdrho1450ompi0(e2) + wdrho1450pipi(e2)) /
     &  (brrho1450ompi0 + brrho1450pipi)
      end

c+++ C16 ddprho1450( R8 e2 ) inverse propagator of rho(1450)
      complex*16 function ddprho1450(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2
      real*8 wdrho1450
      ddprho1450 = dcmplx((msrho1450-e2)*(msrho1450+e2),
     &  -(e2*wdrho1450(e2)))
      end


C********************************************************************
C      Inverse propagator of Rho1450 
C      Viacheslav Shary
C********************************************************************
c+++ C16 dprho1450( R8 s ) inverse propagator of rhop(1450)
      complex*16 function dprho1450(s)
      implicit none
      real*8 s
      complex*16 ddprho1450
      dprho1450 = ddprho1450(sqrt(s))
      end


c --- the dependence of rho(1450) -> omega pi0 width
      real*8 function wdrho1450ompi0(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, phsp2
      logical init /.true./
      save init

      if ( init ) then
        init = .false.
        call inifit
      endif

      if ( e2.le.mspi0+msom .or. msrho1450.le.msom+mspi0 ) then
        wdrho1450ompi0 = 0.d0
      else
        wdrho1450ompi0 = grho1450 * brrho1450ompi0 *
     &    (phsp2(e2,msom,mspi0)/phsp2(msrho1450,msom,mspi0))**3
      endif
      end

c --- the dependence of rho(1450) -> pi pi width
      real*8 function wdrho1450pipi(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, phsp2
      logical init /.true./
      save init
      real*8 msrho0, wsp0, mspi2, mspi20
      save msrho0, wsp0, mspi2, mspi20

      if ( init ) then
        init = .false.
        call inifit
        msrho0 = -1
      endif
      if ( msrho0 .ne. msrho1450 .or. mspi20.ne.mspi ) then
        msrho0 = msrho1450
        mspi20 = mspi
        mspi2 = 2*mspi20
        wsp0 = (msrho0-mspi2)*(msrho0+mspi2)
      endif

      if ( e2.le.mspi2 .or. msrho1450.le.mspi2 ) then
        wdrho1450pipi = 0.d0
      else
        wdrho1450pipi = grho1450 * brrho1450pipi *
     &    sqrt((e2-mspi2)*(e2+mspi2)/wsp0)**3 *
     &    (msrho0/e2)**2
      endif
      end
