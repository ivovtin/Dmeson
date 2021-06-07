      SUBROUTINE GEN_2PRT(IMOD,TE,ANG)
c******************************************************************
c
c  SIMULATION OF TWO-PARTICLE PRODUCTION IN E+E- ANNIHILATION
c
c  INPUT PARAMETERS: IMOD - PROCESS NUMBER:
c                    1 - E+E-,     2 - 2 GAMMA,
c                    3 - MU+MU-,   4 - PI+PI-,
c                    5 - K+K-,     6 - KLKS,
c                    7 - ETAGAMMA, 8 - PI0GAMMA,
c                    9 - ETAPRIMEGAMMA,
c                    TE - TOTAL ENERGY IN GEV,
c                    ANG - MINIMAL POLAR ANGLE IN DEGREES
c  OUTPUT PARAMETERS: NPRT - NUMBER OF FINAL PARTICLES,
c                     QQ(I,K) - FOR THE K-TH PARTICLE
c                     I=1,2,3 - DIRECTION COSINES, I=4 - MOMENTUM,
c                     ISORT(K) - TYPE OF THE K-TH PARTICLE
c
c  Corrections:
c
c  18.03.1991,   Savinov V.: RNDM - REAL*4 FUNCTION 
c  19.03.2004,   Tayursky V.A.: GRNDM -> RLU, /serr/ -> /s1prt/
c  22.02.2007,   Tayursky V.A.: row 23, 24, e- <-> e+
c
c******************************************************************
      IMPLICIT REAL*8 (Q-S)
      COMMON /S1PRT/QQ(5,10),ISORT(10),NPRT,IERPR
      REAL*4 RAND,RLU
      CHARACTER*20 NAPART
      DIMENSION AMAS(2)
c
      IERPR=0
c
      IF(IMOD.GT.9)THEN
c THE MODE NUMBER SHOULD BE LESS THAN 10
        IERPR=1
        RETURN
      END IF
c
      QCLIM=DCOS(ANG*3.1416D0/180.D0)
c
      GO TO (1,2,3,4,5,6,7,8,9),IMOD
c
c  E+E- -> E+E-
    1 ISORT(1)=3   ! corrected e+ -> e-, Feb.2007 
      ISORT(2)=2   ! corrected e- -> e+
c
      IF(ANG.LT.0.1)THEN
C THE MINIMAL POLAR ANGLE FOR E+E- -> E+E- SHOULD NOT BE ZERO
        IERPR=4
        RETURN
      ENDIF
c
      QFM=((3.D0+QCLIM**2)/(1.D0-QCLIM))**2
      GO TO 10
c
c  e+e- -> gamma gamma
    2 ISORT(1)=1
      ISORT(2)=1
      QV=1.D0-(1.022D-3/TE)**2
      QFM=(1.D0+QCLIM**2)/(1.D0-QV*QCLIM**2)
      GO TO 10
c
c  e+e- -> mu+mu-
    3 ISORT(1)=5
      ISORT(2)=6
c
      CALL GFPART(5,NAPART,ITRTYP,AM,CHAR,TLIFE,UB,NB)
c
      RMAS=AM
      QV=1.D0-(2.D0*RMAS/TE)**2
      QFM=2.D0-QV*(1.D0-QCLIM**2)
      GO TO 10
c
c  e+e- -> pi+pi-
    4 ISORT(1)=8
      ISORT(2)=9
      QFM=1.D0
      GO TO 10
c
c  e+e- -> K+K-
    5 ISORT(1)=11
      ISORT(2)=12
      QFM=1.D0
      GO TO 10
c
c  e+e- -> KLKS
    6 ISORT(1)=10
      ISORT(2)=16
      QFM=1.D0
      GOTO 10
c
c  e+e- -> eta gamma
    7 ISORT(1)=17
      ISORT(2)=1
      QFM=1.D0+QCLIM**2
      GO TO 10
c
c  e+e- -> pi0 gamma
    8 ISORT(1)=7
      ISORT(2)=1
      QFM=1.D0+QCLIM**2
      GO TO 10
c
c  e+e- -> eta' gamma
    9 ISORT(1)=49
      ISORT(2)=1
      QFM=1.D0+QCLIM**2
c
c   CHECK OF THE TOTAL ENERGY AND PRODUCTION THRESHOLD
c
 10   CALL GFPART(ISORT(1),NAPART,ITRTYP,AMAS(1),CHAR,TLIFE,UB,NB)
c
      CALL GFPART(ISORT(2),NAPART,ITRTYP,AMAS(2),CHAR,TLIFE,UB,NB)
c
      ETHR=AMAS(1)+AMAS(2)
c
      IF(TE.LE.ETHR) THEN
c
c   TOTAL ENERGY IS LESS THAN PRODUCTION THRESHOLD
        IERPR=2
        RETURN
      ENDIF
c
      IF(TE.GE.20.)THEN
c
c   TOTAL ENERGY SHOULD BE IN GEV
        IERPR=3
        RETURN
      ENDIF
c
c  SIMULATION OF THE ANGLES FOR THE FIRST PARTICLE
c
 20   RAND=RLU(0)
c
      RD=DBLE(RAND)
      QZ=-QCLIM+2.D0*QCLIM*RD
      QZ2=QZ*QZ
c
      RAND=RLU(0)
c
      RD=DBLE(RAND)
c
      GO TO (21,22,23,24,24,24,25,25,25),IMOD
c
 21   IF(((3.D0+QZ2)/(1.D0-QZ))**2.LT.QFM*RD) GOTO 20 ! to new attempt
      GO TO 26
c
 22   IF((1.D0+QZ2)/(1.D0-QV*QZ2).LT.QFM*RD) GOTO 20
      GO TO 26
c
 23   IF((2.D0-QV*(1.D0-QZ2)).LT.QFM*RD) GOTO 20
      GO TO 26
c
 24   IF((1.D0-QZ2).LT.QFM*RD) GOTO 20
      GO TO 26
c
 25   IF((1.D0+QZ2).LT.QFM*RD) GOTO 20
c
 26   QQ(3,1)=QZ
c
      CALL DDCOSI(QCO,QSI)
c
      QZ2=DSQRT(1.D+0-QZ2)
      QQ(1,1)=QZ2*QCO
      QQ(2,1)=QZ2*QSI
c
      DO 30 I=1,3
        QQ(I,2)=-QQ(I,1)
   30 CONTINUE
c
      NPRT=2
      QQ(5,1)=0.5*(TE*TE+AMAS(1)**2-AMAS(2)**2)/TE
      QQ(5,2)=0.5*(TE*TE+AMAS(2)**2-AMAS(1)**2)/TE
      QQ(4,1)=SQRT(QQ(5,1)**2-AMAS(1)**2)
      QQ(4,2)=SQRT(QQ(5,2)**2-AMAS(2)**2)
      END
