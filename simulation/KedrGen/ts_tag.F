      SUBROUTINE TS_TAG(NGEN,EB,KOD,ICALLS,ICALLS1,ICALLS2)
c***********************************************************************
c                                                                      *
c   TSTAG tests tagging system hitting by sc.electrons                 *
c                                                                      *
c   Input parameters:                                                  *
c                                                                      *     
c     NGEN - number of gamma-gamma generator (302-307)                 *
c     EB - beam energy (GeV)                                           *
c     E,P of particles in commons                                      *
c                                                                      *
c   Output parameters:                                                 *
c                                                                      *
c     KOD=0/1/2 - notag / single tag/ double tag                       *
c     ICALLS    - calls of TSTAG                                       *
c     ICALLS1   - calls of TSTAG with single tag result                *
c     ICALLS1   - calls of TSTAG with double tag result                *
c                                                                      *
c   Author: V.A.Tayursky                                               *
c                                                                      *
c   Last change:    19.04.2002                                         *
c                                                                      *
c***********************************************************************
c
      COMMON /PSEVT/  NPS,KPS(4,100),PPS(4,100)   ! Event, package PST
      COMMON /GGHPRT/ N1,P1(4,20),I1(20)          ! gen. 306,307
      DIMENSION P(4,4)
c 
      DATA ICALL,ICALL2,ICALL2/3*0/
c
      ICALL=ICALL+1
c
c  Preparation of array with scattered electrons
c  P(1-3,i) - momentum (GeV/c),  P(4,i) - energy (GeV)
c
      DO 1 I=1,4
      DO 2 J=1,4
c
      IF(J.LE.2) THEN
        IF(NGEN.GE.302.AND.NGEN.LE.305)  P(I,J)=PPS(I,J)
        IF(NGEN.EQ.306.OR.NGEN.EQ.307)   P(I,J)=P1(I,J)  
      ELSE
        IF(NGEN.EQ.307) P(I,J)=P1(I,J) ! for ee->4e
      END IF
c
2     CONTINUE
1     CONTINUE
c
      IF(NGEN.EQ.307) GOTO 3
c      
c 1. Cuts on momenta of scatted e+, e-
c
      IC1=0
      IC2=0
      IF(P(4,1)/EB.gt.0.45.AND.P(4,1)/EB.LT.0.98) IC1=1
      IF(P(4,2)/EB.gt.0.45.AND.P(4,2)/EB.LT.0.98) IC2=1
c
c 2. Cuts on angles of scatted e+, e-
c
      IC3=0
      IC4=0
      TTE1= SQRT( P(1,1)**2+P(2,1)**2 )/ABS( P(3,1) ) 
      if(ATAN(TTE1).lt.0.01) IC3=1
      TTE2= SQRT( P(1,2)**2+P(2,2)**2 )/ABS( P(3,2) )
      if(ATAN(TTE2).lt.0.01) IC4=1
c
c   Test of hitting the tagging system by scattered electrons
c  -----------------------------------------------------------
c
      KOD=0
c
      IF((IC1.EQ.1.AND.IC3.EQ.1).OR.(IC2.EQ.1.AND.IC4.EQ.1) ) KOD=1
      IF((IC1.EQ.1.AND.IC3.EQ.1).AND.(IC2.EQ.1.AND.IC4.EQ.1)) KOD=2
c
      GOTO 4
c
3     CONTINUE
c
c   TS test for ee->4e
c  -------------------
c 
c 1. Cuts on momenta of scatted e+, e-
c
      IE1=0
      IE2=0
      IE3=0
      IE4=0
      IF(P(4,1)/EB.gt.0.45.AND.P(4,1)/EB.LT.0.98) IE1=1
      IF(P(4,2)/EB.gt.0.45.AND.P(4,2)/EB.LT.0.98) IE2=1
      IF(P(4,3)/EB.gt.0.45.AND.P(4,1)/EB.LT.0.98) IE3=1
      IF(P(4,4)/EB.gt.0.45.AND.P(4,2)/EB.LT.0.98) IE4=1
c
c 2. Cuts on angles of scatted e+, e-
c
      IT1=0
      IT2=0
      IT3=0
      IT4=0
      TTE1= SQRT( P(1,1)**2+P(2,1)**2 )/( P(3,1) )  ! e-
      if(ATAN(TTE1).lt.0.01) IT1=1
      TTE2= SQRT( P(1,2)**2+P(2,2)**2 )/(-P(3,2) )  ! e+
      if(ATAN(TTE2).lt.0.01) IT2=1
      TTE3= SQRT( P(1,3)**2+P(2,3)**2 )/( P(3,3) )  ! e- 
      if(ATAN(TTE3).lt.0.01) IT3=1
      TTE4= SQRT( P(1,4)**2+P(2,4)**2 )/(-P(3,4) )  ! e+
      if(ATAN(TTE4).lt.0.01) IT4=1
c
c   Test of hitting the tagging system by all e-, e+ 
c  -------------------------------------------------
c
      KOD=0
c
      IF((IE1.EQ.1.AND.IT1.EQ.1).OR.(IE2.EQ.1.AND.IT2.EQ.1) ) KOD=1
      IF((IE3.EQ.1.AND.IT3.EQ.1).OR.(IE4.EQ.1.AND.IT4.EQ.1) ) KOD=1
      IF((IE1.EQ.1.AND.IT1.EQ.1).AND.(IE2.EQ.1.AND.IT2.EQ.1)) KOD=2
      IF((IE1.EQ.1.AND.IT1.EQ.1).AND.(IE4.EQ.1.AND.IT4.EQ.1)) KOD=2
      IF((IE2.EQ.1.AND.IT2.EQ.1).AND.(IE3.EQ.1.AND.IT3.EQ.1)) KOD=2
      IF((IE3.EQ.1.AND.IT3.EQ.1).AND.(IE4.EQ.1.AND.IT4.EQ.1)) KOD=2
c
4     ICALLS=ICALL
      IF(KOD.EQ.1) ICALL1=ICALL1+1
      IF(KOD.EQ.2) ICALL2=ICALL2+1
      ICALLS1=ICALL1
      ICALLS2=ICALL2
      return
      END
