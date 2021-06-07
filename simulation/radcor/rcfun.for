c --- function to transmit crosssection from crs_proc to rcvcs
      function rcfun( e )
      implicit none
      real*8 rcfun, e
      integer rcprocnum
      real*8 dreale
      logical bornxsect
      common / rcfun_cmn / dreale, rcprocnum, bornxsect
      real*8 d_crs
      real*8 rceffener

      call crs_proc( rcprocnum, e, d_crs )
      rcfun = d_crs
      if ( dreale.gt.0 .and. .not.bornxsect ) then
        rcfun = rcfun * rceffener( rcprocnum, dreale, e )
      endif
      end
