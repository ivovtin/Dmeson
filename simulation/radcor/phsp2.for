C******************************************************************
C      Kinematic function lambda . (Bykling , Kayanti)
C******************************************************************
c+++ R8 phsp2( R8 m0, R8 m1, R8 m2 ) phase space for m0->m1+m2
c       real*8 function phsp2(m1,m2,m3)
c       IMPLICIT NONE
c       real*8 m1,m2,m3
c       REAL*8 prom
c
c       IF (m1.LE.(m2+m3)) THEN
c         PhSp2=0.D0
c         return
c       ENDIF
c       prom=(m1**2-m2**2-m3**2)**2-4.D0*m2**2*m3**2
c       PhSp2=0.5D0*dsqrt(prom)/m1
c       end
      real*8 function phsp2( m1, m2, m3 )
      implicit none
      real*8 m1, m2, m3
      real*8 tm2, tm3

      if ( m1.le.(m2+m3) ) then
        phsp2 = 0.
      else
        tm2 = m2 / m1
        tm3 = m3 / m1
        phsp2 = 0.5d0 * m1 *
     &    sqrt((1.0d0 - (tm2-tm3)**2)*(1.0d0 - (tm2+tm3)**2))
      endif
      end

c+++ R4 phsp2( R4 m0, R4 m1, R4 m2 ) phase space for m0->m1+m2 (drawable)
       real function phsp2r(m1,m2,m3)
       real m1,m2,m3
       real*8 phsp2
       phsp2r = phsp2(dble(m1),dble(m2),dble(m3))
       end
