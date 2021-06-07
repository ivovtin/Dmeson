c+++ R8 wdsig( R8 e2 ) width of sigma meson
      real*8 function wdsig( e2 )
      implicit none
      include 'fitdata.inc'
      real*8 e2
c
      real*8 wdsigpipi, wdsigpi0pi0
      logical init /.true./
      save init
c
      if ( init ) then
        init = .false.
        call inifit
      endif
      wdsig = (wdsigpipi(e2) + wdsigpi0pi0(e2))/ brsigpipi
      end

c -----------------------
      real*8 function wdsigpipi(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2
c
      real*8 phsp2
      logical init /.true./
      save init
c
      if ( init ) then
        init = .false.
        call inifit
      endif
      if ( e2.le.mspi+mspi .or. mssig.le.mspi+mspi ) then
        wdsigpipi = 0.d0
      else
        wdsigpipi = gsig * brsigpipi * 0.67 *
     &    (phsp2(e2,mspi,mspi)/phsp2(mssig,mspi,mspi))**3
      endif
      end

c ---
      real*8 function wdsigpi0pi0(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2
c
      real*8 phsp2
      logical init /.true./
      save init
c
      if ( init ) then
        init = .false.
        call inifit
      endif
      if ( e2.le.mspi0+mspi0 .or. mssig.le.mspi0+mspi0 ) then
        wdsigpi0pi0 = 0.d0
      else
        wdsigpi0pi0 = gsig * brsigpipi * 0.33 *
     &    (phsp2(e2,mspi0,mspi0)/phsp2(mssig,mspi0,mspi0))**3
      endif
      end

c+++ C16 dpsig( R8 s ) inverse propagator of sigma(600) meson
      complex*16 function dpsig( s )
      implicit none
      include 'fitdata.inc'
      real*8 s, e2
      real*8 wdsig
      e2 = sqrt(s)
      dpsig = dcmplx( mssig**2-s, -(e2*wdsig(e2)) )
      end

c+++ C16 ddpsig( R8 e2 ) inverse propagator of sigma(600) meson
      complex*16 function ddpsig(e2)
      implicit none
      include 'fitdata.inc'
      real*8 e2
      real*8 wdsig
      ddpsig = dcmplx((mssig-e2)*(mssig+e2), -(e2*wdsig(e2)) )
      end

