      subroutine crs_proc( i, de, d_crs )
      implicit none
      integer i
      real*8 de, d_crs

      write (6,1)
      write (6,*) 'CRS_PROC: You must use your own routine crs_proc!'
      write (6,1)
      stop
1     format(80('*'))

      end
