      SUBROUTINE DDCOSI(S,C)
c***********************************************************************
c
c  Output: S=Sin and C=Cos of random angle
c
c  Correction: 05.06.2007: GRNDM -> RLU
c
c***********************************************************************
      REAL *8 S,C
      REAL *4 RLU
c
 1    RAND=RLU(0)                ! uniform distr.
c
      T1=DBLE(RAND)*2.-1         ! -1 < T1 < +1
c
      RAND=RLU(0)                ! uniform distr.
c
      T2=DBLE(RAND)              !  *4 -> *8
c
      T=t1*t1+t2*t2
      if(T.gt.1.or.t.eq.0)goto 1
      S=dble((t1*t1-t2*t2)/t)    ! S:  0 - +1
      C=dble(2.*t1*t2/t)         ! C: -1 - +1
c
      END
