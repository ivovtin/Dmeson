
      SUBROUTINE GEN_EEG_BUK(IAX,TETCH,CUTEN,AMAG)
c********************************************************************
c
c   Simulation of elastic e-e+ scattering with rad.corr.
c   with simulation of soft photons radiation ! ! !
c
c   Input: IAX   - number of axis (1-3)
c          TETCH - min. angle of charged particles (deg)
c          CUTEN - min. energy of hard photon (MeV)
c          AMAG  - factor for majoranta
c          QE2TOT - total energy of collision (MeV)
c          QPULST(1-3) - vector of momentum of intial system e- + e+
c
c    Output: common /EEG/, /EEGCOM/...,SLUM - luminosity integral
c
c  Corrections: GRNDM -> RLU. 19.03.2004. V.A.Tayursky
c            
c
c********************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)

      COMMON /EEG/ NQUA,PCMEL(3),PCMPO(3),PCMGA(3)
      COMMON/EEGCOM/ QPULST(3),QE2TOT,SLUM

      DIMENSION OUN(3),QVF(3),CT(3),RM(6),PKS(3),IAXIS(3),OPUL(3)
      DIMENSION PLS(3,32),ITPS(3),EMSS(3),GBET(3)
      REAL *4 PCMEL,PCMPO,PCMGA
      REAL *4 TETCH,CUTEN,AMAG
      INTEGER *2 UTYPF

      EQUIVALENCE (PKS(1),PKXS),(PKS(2),PKYS),(PKS(3),PKZS)
      EQUIVALENCE (CT(1),CT1),(CT(2),EKM),(CT(3),DOPK)
      EQUIVALENCE (QE2TOT,OE2),(OPUL(1),QPULST(1))
      EQUIVALENCE (P3X,PLS(1,3)),(P3Y,PLS(2,3)),(P3Z,PLS(3,3))
      EQUIVALENCE (P4X,PLS(1,2)),(P4Y,PLS(2,2)),(P4Z,PLS(3,2))
      EQUIVALENCE (PKX,PLS(1,1)),(PKY,PLS(2,1)),(PKZ,PLS(3,1))
c
      DATA EMAS/0.5110034D+0/, PI/3.1415927D+0/
      DATA ITPS/1,2,3/, IFIRST/0/
c
      EPS=DSQRT(OE2**2-OPUL(1)**2-OPUL(2)**2-OPUL(3)**2)/2. ! a part.energy,
      PULS= DSQRT(EPS**2-EMAS**2)                           ! momentum
      P2E=(PULS/EPS)**2            ! (P/E)**2
c
      DO I=1,3
        GBET(I)=OPUL(I)/(2.*EPS)
      END DO
c
      EMSS(1)=0
      EMSS(2)=EMAS                 ! e- mass
      EMSS(3)=EMAS                 ! e- mass
      GAMMA=OE2/(2.*EPS)
      IF(IFIRST.NE.0) GO TO 30
c.............
c  First call
      IFIRST=1
      NT=0
      NA=0
      NPRP=0
      NPRM=0
c============================================================
c......  EKM - minimum energy of the quantum (MeV)
c============================================================
      IAXIS(1)=IABS(IAX)
      CT(1)=TETCH
      CT(2)=CUTEN                ! = EKM
      CT(3)=AMAG
      PRINT 10,QE2TOT/2,CT,IAX
c
      IF(IAXIS(1).LT.1.OR.IAXIS(1).GT.3) GOTO 25
      IF(TETCH.LT.0.01.OR.TETCH.GT.80.)  GOTO 25
      IF(CUTEN.LT.0.01.OR.CUTEN.GT.EPS)  GOTO 25
      IF(AMAG.LT.0.01)                   GOTO 25
c
      IAXIS(2)=IAXIS(1)+1
      IF(IAXIS(2).GT.3) IAXIS(2)=1
      IAXIS(3)=IAXIS(2)+1
      IF(IAXIS(3).GT.3) IAXIS(3)=1
      EM1=EMAS/EPS
      EM2=EM1**2
      EM3=EM1*EM2
      EKMAX=EPS*(1.D+0-EM2)
c
      DO 12 I=1,3
        IF(CT(I).LT.0) GO TO  13
        IF(I.EQ.3)  GO TO 12
        R1=EKMAX
        IF(I.LT.2)  R1=90.
        IF(CT(I).GT.R1)  GO TO 13
12    CONTINUE
c
      GO TO 20
13    PRINT 15,CT(I)
      STOP 8
25    PRINT 26
      STOP 8
c
20    I=1
      R1=CT(I)*PI/180.
      CT(I)=DCOS(R1)    !  CT1=CT(1): cosinus of boundary angles (grad)
      ST=DSIN(R1)
      ST05=DSIN(R1/2.)
      COSMA=CT(1)
      EKMIN=EKM
      WT1=0.
      WT2=0.
      R2=(1.-COSMA)*(1.+COSMA)
      R2=9.97867D+8*EM2*COSMA/R2
      BABIN=R2
      EQ1=EKM
c
c...The calculation of weight of the first region
      WT1=1.
      WT1=WT1*R2
c
c...The calculation of weight of the second region
c
c   Some constants
c
      FMAGOR=1.
      FMG=0.
      ALGK=DLOG(EKMAX/EKMIN)
      ALGEPS=EMAS**2
      ALGEPS=DLOG((EPS+PULS)**2/ALGEPS)
c.....
c  Zero scattering angles are not possible
34    CONTINUE
      AL5=(2.*PULS*ST05)**2
      AL11=ALGEPS**2
      SIGM=4.842D+6*ALGK*AL11*DOPK/AL5
      PRINT 35,WT1,SIGM
      WTOT=WT1+WT2+SIGM
c
c=========== Beginning of simulation ===============
c
30    CONTINUE
40    NT=NT+1
      SLUM=SLUM+1./WTOT
c
c  Choice between 1-st and 2-nd regions
c
      CALL DGRNDM(R1,1)
c
      IF(R1*WTOT.GE.WT1    )  GO TO 600
c.......
c   1-st region of cross-section - effective radiation of soft photons
c
      CALL DGRNDM(R2,1)
c
      R3=(1.-COSMA**2)/(2.*(1.+COSMA*(2.*R2-1.)))
      R4=1.-2.*R3
      R5=2.*DSQRT(R3*(1.-R3))
c
      CALL DCOSI(R6,R7)
c
      P3X=-PULS*R4
      P4X=-P3X
      P3Y=PULS*R5*R6
      P3Z=PULS*R5*R7
      P4Y=-P3Y
      P4Z=-P3Z
      T=4.*EPS**2*R3
      R8=1.-2.*R3+3.*R3**2-2.*R3**3+R3**4
      EQ=0.
c......
c   1-st cross-section region
c
c      CALL UM1088(EPS,EKMIN,R4 ,R9)
c
      CALL GEN_EEG_BUK1(EPS,EKMIN,R4 ,R9)
c
      R9=R9+1.
      AVQUA=  R9
      R11=R8*BABIN*R9
c
      CALL DGRNDM(R12,1)
c
      IF(R11.LE.WT1)  GO TO 501
      PRINT 502,R11,WT1
      STOP 8
c
501   IF(R12*WT1.GT.R11)  GO TO 30
c.......
c   Always one quantum is generated
601   CONTINUE
      NQUA=1
c
c   Beginning of generation of quanta
      PKXS=0.
      PKYS=0.
      PKZS=0.
      R3=(ALGEPS*(EPS**2+PULS**2)/(EPS*PULS)-2.)
      R1=R4
c
      DO I=1,2
        R12=(1.-R1)/2.
        R11=DSQRT((1.+R1)/2.)
        R9=DSQRT(EMAS**2+(PULS*R11)**2)
        R8=EPS*PULS*R11/R9
        R10=(EMAS*PULS/R9)**2*R12
        R3=(EPS**2+PULS**2*R1)/(R9*PULS*R11)*
     *     DLOG(((EPS-EMAS+R8)**2+R10)/((EPS-EMAS-R8)**2+R10))-R3
        R1=-R4
      END DO
c
      ALGOM=PI*AVQUA*137.03604/(2.*R3)
c
c  A simple dependence 1/E corrected with factor 1/(1+E/EPS)
c
      DO 1995 IQUA=1,NQUA
602     CONTINUE
c
c  Generation of soft quantum(sinus and cos with respect to -l axis)
c
        CALL DGRNDM(R4,1)
c
        R5=DEXP(-2.*ALGEPS)
        R6=DEXP(-2.*ALGEPS*R4)
        R7=DEXP(-2.*ALGEPS*(1.-R4))
        R4=R6*(1.+R5-R7)/((1.-R5)*(1.+R6))
        R5=1.-R4
        R4=DSQRT(R4*(1.+R5))
        R6=EMAS**2+(PULS*R4)**2
c
        CALL DGRNDM(R7,1)
c
        IF(R7.GT.0.5)  R5=-R5
        R7=EPS-PULS*R5
        R8=EPS+PULS*R5
        IF(R7.LT.EMAS)  R7=R6/R8
        IF(R8.LT.EMAS)  R8=R6/R7

        CALL DGRNDM(R9,1)

        IF(R9.GT.0.5) GO TO 603
c
c   Quantum with respect to P2
c   In R7,R8,R9,R10 we put P2.K, P1.K, P4.K, P3.K
c
        CALL DCOSI(R11,R12)
c
        R6=R4*R11
        R4=R4*R12
        R10=P4X*R5+P4Y*R4+P4Z*R6
        OUN(1)=R5
        OUN(2)=R4
        OUN(3)=R6
        R9=EPS-R10
        R10=EPS+R10
        GO TO 604
c.......
c   Quantum with respect to P4
603     R9=R7
        R10=R8
        OUN(1)=P4X/PULS
        OUN(2)=P4Y/PULS
        OUN(3)=P4Z/PULS
c
c        CALL UM1026(OUN,R5,R4)
c
        CALL GEN_EEG_BUK2(OUN,R5,R4)
c
        R7=PULS*OUN(1)
        R8=EPS+R7
        R7=EPS-R7
c.........
c   Calculation of penalty function
604     CONTINUE
        R11=EPS**2
        R13=1./R10+1./R9
        R14=1./R8+1./R7
        R12=( (R13*(P3Y*OUN(3)-P3Z*OUN(2)))**2+
     *      (R13*(P3Z*OUN(1)-P3X*OUN(3))-R14*PULS*OUN(3))**2+
     *      (R13*(P3X*OUN(2)-P3Y*OUN(1))+R14*PULS*OUN(2))**2)/
     *   (2.*(2.*EPS)**2*(1./(R7*R8)+1./(R9*R10)))
        IF(R12.GE.0.AND.R12.LE.1.)  GO TO 605
        PRINT 606,R12,P4X,P4Y,P4Z,OUN
        GO TO 602
c
605     CALL DGRNDM(R11,1)
c
        IF(R11.GT.R12)  GO TO 602
c.........
c  Quantum is accepted, now generation of energy
c
        CALL DGRNDM(R12,1)
c
        R11=DEXP(-R12*ALGOM)
        R11=EKMIN*R11/(1.+EKMIN*(1.-R11)/EPS)
c**********
c	print *,' 6: ',r12,algom,eps

        EQ=EQ+R11
        PKX= R11*OUN(1)
        PKXS=PKXS+PKX
        PKY= R11*OUN(2)
        PKYS=PKYS+PKY
        PKZ= R11*OUN(3)
        PKZS=PKZS+PKZ
c**********
c	print *,' 7: ',ekmin,r11
c.......
c   If there are more than 1 quantum, then shift to the end of array
        IF(NQUA.LE.1.OR.IQUA.EQ.NQUA)   GO TO 1995
	IND=NQUA-IQUA+3
        PLS(1,IND)=PKX
        PLS(2,IND)=PKY
        PLS(3,IND)=PKZ
1995  CONTINUE
c........
c   All quanta were generated, correction of P3 and P4
      R7=PKXS*P4X+PKYS*P4Y+PKZS*P4Z
      R5=(2.*EPS-EQ)**2-PKXS**2-PKYS**2-PKZS**2-4.*EMAS**2
      IF(R5.LT.0.)  R5=0.
      R6=DSQRT(R5+4.*EMAS**2)
      R5=DSQRT(R5)/(2.*PULS)
      R6=1./(R6*(R6+2.*EPS-EQ))
c
      DO 607 I=2,3
      DO 607 J=1,3
        PLS(J,I)=-PKS(J)/2.+R5*(PLS(J,I)+R6*R7*PKS(J)*(5-2*I))
607   CONTINUE
c
      EPS3=DSQRT(EMAS**2+P3X**2+P3Y**2+P3Z**2)
      EPS4=DSQRT(EMAS**2+P4X**2+P4Y**2+P4Z**2)
      GO TO 9999
600   CONTINUE
c
c   Generation of energy of gamma-quantum
c
      NQUA=1
c
      CALL DGRNDM(R1,1)
c
      EQ=EKMIN*DEXP(R1*ALGK)
      EPSZ=EPS*(EPS-EQ)
      IF(EPSZ.LE.0)  GO TO 30
      EPSZ=DSQRT(EPSZ)
      PULZ=EPS*DSQRT(1.D+0-EQ/EPS-EM2)
      ALGEPZ=EMAS**2
      ALGEPZ=    DLOG((EPSZ+PULZ)**2/ALGEPZ)
      IF(ALGEPZ.LT.0.01)  GO TO 30
c
c   Generation of angles TETK and TET0
c
      ITTS=1
c
      CALL DGRNDM(R1,1)
c
      IF(R1.GT.0.5)  ITTS=2
c
c   Choice T(ITTS=1)  or  TS(ITTS=2)  was done
c
c  At calculation of  TETK and TETZ at the same time it is
c  necessary to calculate t+,t-,ts+,ts-
c
c  Independent simulation of TETK and TET0
c
      R10=1.
      R4=ALGEPZ
c
      DO 41 I=1,2
c
        CALL DGRNDM(R1,1)
c
        R2=DEXP(R4)
        R1=R4*R1
        IF(R1.GT.1.D-6)  R1=1.-DEXP(-R1)
        R4=2.*R10*R1/((R2-1.)*(1./R2+1.-R1))
        R1=R10-R4
        R5=1.-R10
        IF((R5+R4)*(1.+R1).LT.0.) GOTO 30
        R5=DSQRT((R5+R4)*(1.+R1))
c
        CALL DGRNDM(R2,1)
c
        IF(R2.GT.0.5) R1=-R1
        IF(I.EQ.2)  GO TO 41
c.......
c  For angle TETK additional calculations
        COTZ=R1
        SINZ=R5
c
c  Energies and momentums of final particles
c
        EPS3=EPS+(PULZ*COTZ/EPSZ-1.D+0)*EQ/2.D+0
        EPS4=2.D+0*EPS-EPS3-EQ
        P3=EPS3**2-EMAS**2
        IF(P3.LE.0)  GO TO 30
        P3=DSQRT(P3)
        P4=EPS4**2-EMAS**2
        IF(P4.LE.0)  GO TO 30
        P4=DSQRT(P4)
        P3X=(COTZ*PULZ*(EQ-2.D+0*EPS)
     *     -EPSZ*EQ)/(2.D+0*EPSZ*P3)
        P4X=(-COTZ*PULZ*(EQ-2.D+0*EPS)
     *     -EPSZ*EQ)/(2.D+0*EPSZ*P4)
        P3X=DABS(P3X)
        P4X=DABS(P4X)
        IF(P3X.LT.P4X)  P3X=P4X
        R10=1.
        IF(P3X.LT.CT1)  GO TO 42
        R10=CT1*P3X+ST*DSQRT(DABS(1.-P3X**2))
42      R4=EPS+PULS*R10
        R5=EPS-PULS*R10
        R2=EMAS**2
        IF(R4*R5.LT.R2)  R5=R2/R4
        R4=DLOG(R4/R5)
        RM(4)=(EPS*ALGEPZ*R4)/((EPS-EQ)*ALGEPS**2)
41    CONTINUE
c
      COTK=R1
      SINK=R5
c
c  Calculation of boundaries of variation of invariants t,ts
c
      R1=(2.*EPS-EQ)*(EPS-PULS*PULZ*COTK*COTZ/EPSZ)-2.*EMAS**2
      R2=2.*PULS*PULZ*SINK*SINZ
      R3=EQ*(PULS*COTK-PULZ*EPS*COTZ/EPSZ)
      A1MB=R1-R2+R3
      A2MB=R1-R2-R3
      A1PB=A1MB+2.*R2
      A2PB=A2MB+2.*R2
c
c  That is time to generate FIP
c
c  Isotropic distribution in FIP
c
      CALL DCOSI(COF,SIF)
c
      R1=1.-COF
      IF(DABS(R1).LT.0.1)  R1=SIF**2/(1.+COF)
      R1=2.*R1*PULS*PULZ*SINZ*SINK
c
c  Calculation of invariants t and ts
c
      T=-A1MB-R1
      TS=-A2MB-R1
c
c  Calculation of vectors of momentums P3 and P4
c
200   P3X=(COTK*COTZ*PULZ*(EQ-2.D+0*EPS)-2.D+0*EPSZ*PULZ*
     *    SINK*SINZ*COF-EPSZ*EQ*COTK)/(2.D+0*EPSZ)
      PKX=EQ*COTK
      P4X=-P3X-PKX
      R1=DABS(P3X/P3)
      R2=DABS(P4X/P4)
      IF(R1.GT.CT1.OR.R2.GT.CT1)  GO TO 30
      P3Y=-PULZ*SINZ*SIF
      P3Z=SINK*COTZ*PULZ*(EQ-2.D+0*EPS)/(2.D+0*EPSZ)+
     *        COTK*COF*SINZ*PULZ-SINK*EQ/2.D+0
      PKZ=EQ*SINK
      P4Y=-P3Y
      P4Z=-P3Z-PKZ
c
201   CALL DCOSI(R1,R2)
c
c  Rotation at random angle FIK
c
      PKY=-PKZ*R2
      PKZ=PKZ*R1
      R3=P3Y*R1-P3Z*R2
      P3Z=P3Y*R2+P3Z*R1
      P3Y=R3
      R3=P4Y*R1-P4Z*R2
      P4Z=P4Y*R2+P4Z*R1
      P4Y=R3
c
c  Calculation of all invariants: R1-R6=s,t,u,ss,ts,us
c  R7-R10=K1,K2,K3,K4
c
      R1=(2.D+0*EPS)**2
      R2=T
      R3=(EPS-EPS3)**2-(P3X-PULS)**2-P3Y**2-P3Z**2
      R9=EPS+PULS*COTK
      R10=EPS-PULS*COTK
      IF(R9.LT.EMAS) R9=(EMAS**2+(PULS*SINK)**2)/R10
      IF(R10.LT.EMAS) R10=(EMAS**2+(PULS*SINK)**2)/R9
      R7=2.D+0*EQ*R9
      R8=2.D+0*EQ*R10
      R10=2.D+0*EPS*EQ/EPSZ
      R11= EPSZ+PULZ*COTZ
      R12= EPSZ-PULZ*COTZ
      IF(R11.LT.EMAS)  R11=(EMAS**2+(PULZ*SINZ)**2)/R12
      IF(R12.LT.EMAS)  R12=(EMAS**2+(PULZ*SINZ)**2)/R11
      R9=R10*R11
      R10=R10*R12
      R4=(2.D+0*EPSZ)**2
      R5=TS
      R6=R3+R9-R8
      R11=R2+R5
      R12=R2-R5
      RM(1)=(-(R1+R2)*R12**2+R8*R11*R12+2.*R9*R2*R12-
     *   (R8+R9)*(R2*R9+R5*R8)+4.*EMAS**2*(
     *   2.*R1*R11+R11*R12-(R8+R9)*R11))/
     *   ((4.*EPS*EQ)**2*(-R2-R5))
      RM(2)=(R1*R4*(R1**2+R4**2)+R2*R5*(R2**2+R5**2)+
     *   R3*R6*(R3**2+R6**2))/(4.D+0*(2.D+0*EPS)**8)
      TEST1=(2.*EQ)**2*(-R2-R5)
      TEST2=(2.*EPS)**10
      TEST3=TEST1*TEST2
      TEST16=EMAS**2/TEST3
      R1=R1/1000.
      R2=R2/1000.
      R3=R3/1000.
      R4=R4/1000.
      R5=R5/1000.
      R6=R6/1000.
      R7=R7/1000.
      R8=R8/1000.
      R9=R9/1000.
      R10=R10/1000.
      SUM1=R1*R5*R8*R9*R10*(R4**2+R2**2+R4*R2)**2/(R7*R4*R2)
      SUM2=R1*R2*R7*R9*R10*(R4**2+R5**2+R4*R5)**2/(R8*R4*R5)
      SUM3=R4*R5*R7*R8*R10*(R1**2+R2**2+R1*R2)**2/(R9*R1*R2)
      SUM4=R4*R2*R7*R8*R9 *(R1**2+R5**2+R1*R5)**2/(R10*R1*R5)
      TEST1=SUM1+SUM2+SUM3+SUM4
      TEST2=10.**18
      TEST1=TEST1*TEST2
      R1=R1*1000.
      R2=R2*1000.
      R3=R3*1000.
      R4=R4*1000.
      R5=R5*1000.
      R6=R6*1000.
      R7=R7*1000.
      R8=R8*1000.
      R9=R9*1000.
      R10=R10*1000.
      TEST1=TEST1*TEST16
      RM(3)=TEST1
c
c  Calculation RM(5)
c
      R11=-T
      IF(ITTS.EQ.2) R11=-TS
      RM(5)=AL5/R11
c
c  Calculation RM(6) - probability density in new variables
c
91    CONTINUE
      RM(6)=(RM(1)*RM(2)-RM(3))*RM(4)*RM(5)/DOPK
c
      CALL DGRNDM(X,1)
c
c  Some tests and prints
c
      DP3=P3X**2+P3Y**2+P3Z**2 -P3**2
      DP4=P4X**2+P4Y**2+P4Z**2 -P4**2
      DIN1=R1+R2+R3+R4+R5+R6-8.D+0*EMAS**2
      DIN2=R7+R8-R9-R10
      DM3=EPS3**2-P3**2-EMAS**2
      DM4=EPS4**2-P4**2-EMAS**2
c
      IF(NT.GE.0) GO TO 300
      PRINT 301,DP3,DP4,DIN1,DIN2,DM3,DM4,RM
      PRINT 303,EPS,EQ,COTZ,SINZ,COTK,SINK,COF,SIF,
     *      P3X,P3Y,P3Z,P4X,P4Y,P4Z,PKX,PKY,PKZ,RM
c
300   IF(RM(6).LE.1.D+0.AND.RM(6).GE.0)  GO TO 302
      IF(RM(6).GE.0)  GO TO 309
      NPRM=NPRM+1
      IF(NPRM.GT.0)  GO TO 302
      PRINT 310,NT
      GO TO 308
c
c  Overflow of majoranta
c
309   CONTINUE
      NPRP=NPRP+1
      FMG=RM(6)
      IF(NPRP.GT.3.AND.RM(6).LE.FMAGOR)  GO TO 302
      IF(FMAGOR.LT.RM(6)) FMAGOR=RM(6)
      PRINT 307,RM(6),NT,NPRP
308   CONTINUE
c*************
c      PRINT 303,EPS,EQ,COTZ,SINZ,COTK,SINK,COF,SIF,
c     *      P3X,P3Y,P3Z,P4X,P4Y,P4Z,PKX,PKY,PKZ,RM
c      PRINT 311,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10
c      PRINT 301,DP3,DP4,DIN1,DIN2,DM3,DM4,RM
c*************
302   CONTINUE
      IF(FMG.GE.RM(6))  GO TO 312
      FMG=RM(6)
      PRINT 313,FMG,NT
312   CONTINUE
      IF(RM(6).LT.X)  GO TO 30
9999  CONTINUE
c
c   Good event
c
c   putting particles into the buffer
c
      NPAR=2+NQUA
c
      DO 305 I=1,NPAR
        R1=0.
        R2=0.
        R3=0.
c
        DO J=1,3
          R1=R1+GBET(J)**2
          R3=R3+PLS(J,I)**2
          R2=R2+GBET(J)*PLS(J,I)
	END DO
c
        IF (R3.LT.1.E-6)  GO TO 305
        IQUA=I
        IF(IQUA.GT.3) IQUA=1
        UTYPF=ITPS(IQUA)
        ENERGF=GAMMA*DSQRT(R3+EMSS(IQUA)**2)+R2
        R4=0.
c*************
c	if(utypf.eq.1) print *
c	if(utypf.eq.1) print *,' 8: ',(pls(j,1),j=1,3)
c	if(utypf.eq.1) print *,' 9: ',energf,r3
c
        DO J=1,3
          R5=0.
          IF(R1.GT.1.E-5) R5=(GAMMA-1.)*GBET(J)*R2/R1
          R5=PLS(J,I)+GBET(J)*DSQRT(R3+EMSS(IQUA)**2)+R5
          JJ1=IAXIS(J)
          QVF(JJ1)=R5
          IF(J.EQ.1.AND.IAX.LT.0) QVF(JJ1)=-QVF(JJ1)
          R4=R4+R5**2
	END DO
c
        DO J=1,3
          QVF(J)=QVF(J)/DSQRT(R4)
	END DO
c
        PM=DSQRT(ENERGF*ENERGF-EMSS(IQUA)*EMSS(IQUA))/1000.
c
        IF (UTYPF.EQ.2) THEN
          PCMEL(1)=PM*QVF(1)  !  e-
          PCMEL(2)=PM*QVF(2)
          PCMEL(3)=PM*QVF(3)
        ENDIF
c
        IF (UTYPF.EQ.3) THEN
          PCMPO(1)=PM*QVF(1)  !  e+
          PCMPO(2)=PM*QVF(2)
          PCMPO(3)=PM*QVF(3)
        ENDIF
c
        IF (UTYPF.EQ.1) THEN
c******
c	  print *,' 10 ',pm*1000
          PCMGA(1)=PM*QVF(1)  !  photon
          PCMGA(2)=PM*QVF(2)
          PCMGA(3)=PM*QVF(3)
        ENDIF
305   CONTINUE
c
      NA=NA+1
c
10    FORMAT(//,1X,64(1H*),//,
     * '   Simulating program for electron scattering at the positron',/,
     * '   with photon radiation  UM1086:  21.04.90 (Bukin)',//,
     * 2x, 1PD10.3,' - beam energy (MeV)',/,
     * 2x, 1PD10.3,' - min. angle of ch. particle with the',
     * '  beam (deg)',/,
     * 2X, D10.3,' - boundary between soft and hard photons (MeV) ',/,
     * 2X, D10.3,' - additional factor to the majoranta ',/,
     * 2X, I10,' - the number of beam axis',//,
     * 1X,64(1H*),/)
15    FORMAT(//T10,'+++ UM1086: Error - not valid value',1PD12.2//)
26    FORMAT(//' UM1086: Error in the input parameters')
35    FORMAT(' The weights of first and second cross-section ',
     * 'region are calculated:',//,1p2D11.3,/)
301   FORMAT(/T10,'+++++++++++   Some  tests +++++++++++'/
     * T5,'DP3=',1PD10.3,'  DP4=',D10.3,'   DIN1=',D10.3,
     *  ' DIN2=',D10.3,'  DM3=',D10.3,'   DM4=',D10.3/
     *  T5,'M1-M6=',6D15.3)
303   FORMAT(
     *  T5,'EPS=',1PD12.5,'    EQUAN=',D12.5,'   COS,SIN(TET0)=',
     * 2D13.5,'   COS,SIN(TETK)=',2D13.5/'     COS,SIN(FP)=',2D13.5//
     *  T5,'P3=',3D13.5,'  P4=',3D13.5/'       PK=',3D13.5//
     *  T5,'M1-M6=',6D13.5/)
307   FORMAT(//T5,'++++  UM1086: Error - overflow of majoranta',
     *' in',F6.1,' times',',  Number of event=',I10/
     *T5,' overflow was ',I6,' times'/)
310   FORMAT(//T5,'++++  UM1086: Error - negative cross-section',
     * ',  Number of event=',I6/)
311   FORMAT(/,'      Values of invariants:',/
     * ,'  S,T,U,SS,TS,US=',1P,6D12.4,//
     * ,'  K1,K2,K3,K4=',4D12.4)
313   FORMAT(/,' +++ UM1086: Current maximum of the function:',
     *1PD10.3,', sample N',I8)
502   FORMAT(//T10,'+++ UM1086: Warning - cross-section without',
     *' radiation',1PD10.3,
     *' is more then majorant',D10.3/)
606   FORMAT(/T10,'+++ UM1086: Error in algorithm - abnormal',
     *' value of penalty function in first area',1PD10.3//
     *T5,'P4=',3D12.4,5X,'K=',3E12.4/)
c
      RETURN
      END

c      SUBROUTINE UM1088(EB,E0,COST,DELT)
      SUBROUTINE GEN_EEG_BUK1(EB,E0,COST,DELT)    
c************************************************************
c
c   Subroutine of calculation of rad.corrections according to
c   "DISTRIBUTIONS IN THE PROCESS E+E- =>E+E-(G)",
c   F.A.BERENDS,R.KLEISS,NUCLEAR PHYSICS B 228(1983)537-551
c
c   EB   - energy of one beam (MeV)
c   E0   - maximum energy of photon (MeV)
c   COST - cosinus of scattering angle
c   DELT - rad.correction for accompany radiation and virtual quanta
c
c************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION TAB(3,3),RLOG(2)
c
      DATA  TAB /782.6D+0,    9.9D+0,    0.72D+0,
     *           769.0D+0,  154.0D+0,    6.60D+0,
     *           1019.6D+0,   4.2D+0,    1.30D+0 /
      DATA PI/3.1415927D+0/, A/137.03604D+0/
c
      RLOG(1)=DLOG((1.+COST)/2.)
      RLOG(2)=DLOG((1.-COST)/2.)
      U=2.*DLOG(3.913868*EB)
      V=U+RLOG(1)
      W=U+RLOG(2)
      X=U*(1.-12.*COST+12.*COST**2-4.*COST**3+3.*COST**4)
     * -V*(5.-7.*COST+3.*COST**2-COST**3)
     * +W*(31.+5.*COST+9.*COST**2+3.*COST**3)
     * +0.5*U**2*(3.+7.*COST-5.*COST**2-3.*COST**3-2.*COST**4)
     * +V**2*(3.-3.*COST+COST**2-COST**3)
     * -0.5*W**2*(9.+7.*COST+11.*COST**2+5.*COST**3)
     * -2.*U*V*(2.*COST-COST**2-COST**4)
     * -U*W*(21.+3.*COST+9.*COST**2-3.*COST**3+2.*COST**4)
     * +2.*V*W*(6.+5.*COST+4.*COST**2+COST**3)
     * -(36.+24.*COST**2+4.*COST**4)
     * +PI**2/3.*(18.-15.*COST+12.*COST**2-3.*COST**3+4.*COST**4)
      X=X/(3.+COST**2)**2
c
      DO 1 I=1,2
        RS=2*I-3
        RX=(1.+RS*COST)/2.
        RSUM=0.
        Q=2.*RX**2
c
        DO 2 K=3,5
          Q=Q*RX
          RSUM=RSUM+Q/(K**2*(K-2)*(K-1))
2       CONTINUE
c
        RSUM=RSUM+RX*(5.-2.*RX)/2.+(1.-RX)*(3.-RX)/2.*RLOG(I)
      X=X+RS*2.*RSUM
1     CONTINUE
c
      X=X-4.*(1.-U+V-W)*DLOG(E0/EB)+U**2-V**2+W**2-2.*PI**2/3.
c..........
c  Vacuum polarization with lepton loops
      Q=2.*(DLOG(EB**2*(1.-COST)*0.00095173)-1.666666)
c..........
c  Hadron polarization of vacuum
      RS=2.*EB**2*(1.-COST)
      RSUM=0.
c
      DO 3 I=1,3
        RX=TAB(1,I)**2
        U =TAB(2,I)**2
        RSUM=RSUM+TAB(3,I)*(RS+RX-U)/(TAB(1,I)*((RS+RX)**2+RX*U))
3     CONTINUE
c
      U=6.*RS*A*RSUM/1000.
      DELT=(X+Q)/(PI*A)+U
c
      RETURN
      END

c      SUBROUTINE UM1026(RUNIT,RCT,RST)
      SUBROUTINE GEN_EEG_BUK2(RUNIT,RCT,RST)
c
c  Rotation of vector
c
c     RCT: COS(TET),  RST: SIN(TET)
c
c
      IMPLICIT REAL *8(A-H,O-Z)

      COMMON/EEGCOM/ QPULST(3),QE2TOT,SLUM
      DIMENSION RUNIT(3),RM(3,3)
c
      IF(RUNIT(1) .LT.1.5)  THEN
200     QQ=1.D+0
        IF(RUNIT(3).LT.0.) QQ=-1.D+0
        Q1=1.+RUNIT(3)*QQ
        Q2=RUNIT(1)**2+RUNIT(2)**2
        IF(DABS(1.D+0-Q2-RUNIT(3)**2).GT.1.E-6 )  THEN
          PRINT 1,RUNIT
6         RSUM=0.
c
          DO I=1,3
            RSUM=RSUM+RUNIT(I)**2
          END DO
c
          RSUM=DSQRT(RSUM)
c
          DO I=1,3
            RUNIT(I)=RUNIT(I)/RSUM
          END DO
c
          GO TO 200
        END IF
c
        Q1=1./Q1
        RM(1,1)=(Q1*RUNIT(1)**2-1.)*QQ
        RM(2,1)=(Q1*RUNIT(1)*RUNIT(2))*QQ
        RM(3,1)=RUNIT(1)
        RM(1,2)=Q1*RUNIT(1)*RUNIT(2)*QQ
        RM(2,2)=(Q1*RUNIT(2)**2-1.)*QQ
        RM(3,2)=RUNIT(2)
c
        DO I=1,3
          RM(I,3)=RUNIT(I)
        END DO
c
        CALL DCOSI(RC,RS)
c
      END IF
c
      RSUM=1.
c
      DO 2 I=1,3
        Q2=RM(I,3)*RCT+RM(I,1)*RST*RC+RM(I,2)*RST*RS
        RSUM=RSUM-Q2**2
        RUNIT(I)=Q2
2     CONTINUE
c
      IF(DABS(RSUM).GT.1.E-4)  THEN
        PRINT 3,RUNIT,RM,RCT,RST
        STOP 8
      END IF
c
      Q1=1.+RSUM*0.5
c
      DO 4 I=1,3
        RUNIT(I)=RUNIT(I)*Q1
4     CONTINUE
c
1     FORMAT(/,' ??? UM1026: ERROR - VECTOR IS NOT NORMILIZED:',
     *        1P,3D15.7/)
3     FORMAT(/,' ??? UM1026: Error in program ? rotated vector',
     *  ' appeared to be unnormalized:'//
     *                    T25,1P,3D15.5//
     *  T10,'   OPTY =',3(T25,1P,3D15.5/),
     *  T10,'COS(TETA)=',D15.5,'     SIN(TETA)=',D15.5/)
      RETURN
      END

      SUBROUTINE DCOSI(C,S)
c
c  sin and cos of random angle
c
      IMPLICIT REAL *8(A-H,O-Z)
c
      PI=3.1415926535
c
      CALL DGRNDM(RD,1)
c
      ANG=2*PI*RD
      C=DCOS(ANG)
      S=DSIN(ANG)
c
      RETURN
      END

      SUBROUTINE DGRNDM(XD,N)
c
c   Random numbers generator for PC is used
c
      REAL *8 XD
c
c      CALL GRNDM(X,N)
      X=RLU(0)
c
      XD=X
      N1=N
      RETURN
      END
