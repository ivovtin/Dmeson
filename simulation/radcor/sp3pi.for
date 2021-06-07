C********************************************************************
c   Width of V -> rho + pi -> 3 pi is defined as
c       G = gvrp**2/(4.*pi)*W(E)
C
C    Sp3pi function determines W(E).
C
C    W(mom)=E**3/1000.*(E/781.94)**5*(1.-(414.12/E)**2)**4*B(E)
C    Dependence B(E) tabulated in PS3PI(200) array.
C
C    Array B(E) is filled by WRhoPi program.
c
C          11.12.96  V.Druzhinin  
c          24.06.99  D.Bukin (inifit, sp3pir)
c***************************************************************
c+++ R8 sp3pi( R8 e2 ) phase space of omega -> rho pi -> 3pi
       real*8 function sp3pi(e2)
       implicit none	
       include 'fitdata.inc'
       real*8 e2
       integer*4 i
       logical init /.true./
       save init

c --- initialization inserted on 24.06.1999
       if ( init ) then
         call inifit
         init = .false.
       endif
       if(E2.le.Emin)then
	 Sp3Pi=0.
       else	
         I = min(int((E2-EMIN)/ESTEP)+1,NPOINT-1)
         sp3pi=(ps3pi(i)+((e2-emin)/estep-float(i-1))
     &     *(ps3pi(i+1)-ps3pi(i)))
     &     *e2**3/1000.d0*(e2/msom)**5
     &     *(1.d0-(414.12d0/e2)**2)**4
       endif 
       END

c+++ R4 sp3pi( R4 e2 ) phase space of omega-> rho pi ->3pi (drawable)
       real function sp3pir(ee)
       implicit none
       real ee
       real*8 sp3pi
       sp3pir = sp3pi(dble(ee))
       end
