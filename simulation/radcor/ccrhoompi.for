c+++
      real*8 function ccrhoompi(e2)
      implicit none
      real*8 e2
      include 'fitdata.inc'
      logical firstpass /.true./
      save firstpass
c
      if ( firstpass ) then
        call inifit
        firstpass = .false.
      endif
      ccrhoompi = ((1.0d0 + (rrho*msrho)**2)/(1.0d0 + (rrho*e2)**2))**2
      end
