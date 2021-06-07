c---------------------------------------------------
c        rho(1700) width
c .... (C) 1999, Budker Institute of Nuclear Physics
c     27.06.1999 Dmitry Bukin (D.A.Bukin@inp.nsk.su)
c                adopted from V.Shary's wdrho1450
c---------------------------------------------------

c+++ R8 wdrho1700( R8 e2 ) width of rho(1700)
      real*8 function wdrho1700(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, wdrho1700ompi0, wdrho1700pipi
      wdrho1700 = 
     &  (wdrho1700ompi0(e2) + wdrho1700pipi(e2))/
     &  (brrho1700ompi0 + brrho1700pipi)
      end

c+++ C16 ddprho1700( R8 e2 ) inverse propagator of rho(1700)
      complex*16 function ddprho1700(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2
      real*8 wdrho1700
      ddprho1700 = dcmplx((msrho1700-e2)*(msrho1700+e2),
     &  -(e2*wdrho1700(e2)))
      end

c+++ C16 dprho1700( R8 s ) inverse propagator of rhop(1700)
      complex*16 function dprho1700(s)
      implicit none
      real*8 s
      complex*16 ddprho1700
      dprho1700 = ddprho1700(sqrt(s))
      end

c --- the dependence of rho(1700) -> omega pi0 width
      real*8 function wdrho1700ompi0(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, phsp2
      logical init /.true./
      save init

      if ( init ) then
        init = .false.
        call inifit
      endif

      if ( e2.le.mspi0+msom .or. msrho1700.le.msom+mspi0 ) then
        wdrho1700ompi0 = 0.d0
      else
        wdrho1700ompi0 = grho1700 * brrho1700ompi0 *
     &    (phsp2(e2,msom,mspi0)/phsp2(msrho1700,msom,mspi0))**3
      endif
      end


c --- the dependence of rho(1700) -> pi pi width
      real*8 function wdrho1700pipi(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2, phsp2
      logical init /.true./
      real*8 msrho0, wsp0, mspi2, mspi20
      save msrho0, wsp0, mspi2, mspi20
      save init

      if ( init ) then
        init = .false.
        call inifit
        msrho0 = -1
      endif
      if ( msrho0.ne.msrho1700 .or. mspi20.ne.mspi ) then
        msrho0 = msrho1700
        mspi20 = mspi
        mspi2 = 2*mspi20
        wsp0 = (msrho0 - mspi2)*(msrho0+mspi2)
      endif

      if ( e2.le.mspi2 .or. msrho1700.le.mspi2 ) then
        wdrho1700pipi = 0.d0
      else
        wdrho1700pipi = grho1700 * brrho1700pipi *
     &    sqrt((e2-mspi2)*(e2+mspi2)/wsp0)**3 *
     &    (msrho0/e2)**2
      endif
      end
