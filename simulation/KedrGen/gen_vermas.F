      SUBROUTINE GEN_VERMAS(EB,IPROC,NIT,NPR,NCAL,FMAJ,PART,IT1,TI1,TS1,
     +                      AVGI1,SD1,CHI2A1)
c**********************************************************************
c
c   Generator of ee -> ee + ll based on program of A.M.Vermaseren
c
c   Simulation - after NIT iterations for determination of grid
c
c   Input:
c
c     EB    - energy of beam in GeV
c
c     IPROC = 1 - e+e- -> e+e- + e+e- (main diagrams)
c             2 - e+e- -> e+e- + e+e- (Bremssthrahlung diagrams only)
c             3 - e+e- -> e+e- + e+e- (main + Bremsstr. diagrams)
c             4 - e+e- -> e+e- + e+e- (main + identical particle eff)
c             5 - e+e- -> e+e- + e+e- (main + Bremsstr. + identical eff)
c             6 - e+e- -> e+e- + mu+mu-   (main diagrams)
c             7 - e+e- -> e+e- + mu+mu-   (main +Bremsstr. diagrams)
c             8 - e+e- -> e+e- + tau+tau- (main diagrams)
c
c     NIT   - if NIT>0, NIT iterations for determination of grid
c               then simulation,

c     NPR  >= 0 - print initial data for VEGGEN and results
c           > 0 - + print grid
c           < 0 - there are not any prints from VEGGEN
c
c     NCAL  - approximate number of integrand evaluations
c     FMAJ  - majoranta for this process and energy, if FMAJ<=0.
c             it is determined by generator
c
c  Output: PART(1,4) - 3-momentum and energy of scattered e+ in GeV 
c          PART(2,4) - 3-momentum and energy of scattered e-  ...
c          PART(3,4) - 3-momentum and energy of prodused  l-  ...
c          PART(4,4) - 3-momentum and energy of produced  l+  ...
c          FMAJ  - majoranta 
c
c
c
c   Last correction: 26.02.2004
c
c**********************************************************************
c      IMPLICIT REAL *8(A-H,M,O-Z)      ! old
      IMPLICIT NONE
      COMMON /VEBVEG1 / NCALL,ITMX,NPRN,IDUM(43)
      COMMON /VEBVEG2 / ITER,NDO,BBB(3),XI(50,10)
      COMMON /VEBVEG4/  CALLS,TI,TSI
      COMMON /VEDATA  / PI,ME,ME2,MU,MU2,E,S,EMP,CONST,FM
      COMMON /VECO / IG,IDB,INP,NER(14),NW(19),NUS,NEV,EV(4,4,50),FMAXI
      REAL *8 ME,ME2,MU,MU2,E,S,EMP,CONST,FM,EV,FMAXI,FXNLL
      REAL *8 BBB,XI,PI,ALF,AVGI,CHI2A,SD,CALLS,TI,TSI
      REAL *4  EB,PART(4,4),FMAJ,AVGI1,SD1,CHI2A1,TI1,TS1
      INTEGER *4 NCALL,ITMX,NPRN,IDUM,ITER,NDO,IG,IDB,INP,NER,NW,NUS,NEV
      INTEGER *4 I,J,ICALL,IGRID,NCAL,NIT,IPROC,NPR,IT1
      SAVE ICALL,IGRID
      EXTERNAL FXNLL
c
      DATA ICALL,IGRID/2*0/
c
      ICALL =ICALL+1         ! counter of calls
c      IDB=1                 ! used for debugging
c
c---------- Initialization ------------------------------
c
      IF(ICALL.EQ.1) THEN
c
	IF(IPROC.LT.1.OR.IPROC.GT.8) THEN
	  PRINT *,' GEN_VERMAS error: IPROC should be 1 - 8, but=',IPROC
	  STOP
	END IF
c
	PRINT 36
	IF(IPROC.EQ.1) PRINT *,' e+e- -> e+e- + e+e- (main diagrams)'
	IF(IPROC.EQ.2) PRINT *,' e+e- -> e+e- + e+e- (only Bremssthrah',
     +                         'lung diagrams)'
	IF(IPROC.EQ.3) PRINT *,' e+e- -> e+e- + e+e- (main + Bremsstr',
     +                         'ahlung diagrams)'
	IF(IPROC.EQ.4) PRINT *,' e+e- -> e+e- + e+e- (main + Bremsstr',
     +                         'ahlung + identical particle effects)'
	IF(IPROC.EQ.5) PRINT *,' e+e- -> e+e- + e+e- (main + identi',
     +                         'cal particle effects)'
	IF(IPROC.EQ.6) PRINT *,' e+e- -> e+e- + mu+ mu- (main diagrams)'
	IF(IPROC.EQ.7) PRINT *,' e+e- -> e+e- + mu+ mu- (main + Bremss',
     +                         'trahlung diagrams)'
	IF(IPROC.EQ.8) PRINT *,' e+e- -> e+e- + tau+ tau- (main diagra',
     +                         'ms)'
	PRINT 37,Eb,NIT,NPR,NCAL,FMAJ
        PRINT 36
c
	INP=0                     ! counter of of weights > majoranta
	FMAXI=0.                  ! for determination of maximum weight
	NCALL=NCAL
	NPRN=NPR
        E=EB                      ! E - energy of beam in GeV
        PI=DACOS(-1.D0)
c
        ME=0.510999D-3            ! electron mass, initial particle
        ME2=ME*ME
        MU=ME                     ! produced particles - electrons
c
        IF(IPROC.EQ.6) MU=0.1056584 ! produced particles - muons
        IF(IPROC.EQ.7) MU=0.1056584 ! produced particles - muons
        IF(IPROC.EQ.8) MU=1.777     ! produced particles - taus
c
	IG=IPROC                  ! process simulated by generator
        MU2=MU*MU
        S=4*E*E
        EMP=ME2/(E+DSQRT((E-ME)*(E+ME)))
        ALF=1./137.04
        CONST=ALF**4*19.733**2/(2.*S*PI**3)
      END IF
c
c---------- End of initialization --------------------------------
c
      IF(IGRID.EQ.1) GOTO 2    ! to generation of events
c
      ITMX=NIT                 ! number of iterations
c
      FM=FMAJ      !  majoranta for this process, energy and kinem. area
c
c      IF(FM.LE.0.) THEN
c
c  default data
c
c      END IF
c
c  NIT iterations, calculation of cross section and grid
c
      CALL VEGGEN(5,FXNLL,AVGI,SD,CHI2A) ! here FXNLL - subr. for ee->ee +ll
c
      IGRID=1   ! grid is determined
      NEV=0     ! events in buffer EV(...)
      NUS=0     ! used events from buffer EV(...)
c
c-----------------------------------------------------------------------
c
 2    CONTINUE
c
c   Generation of events
c
      IF(NUS.EQ.NEV) THEN   ! NUS - used events from buffer EV(...)
	ITMX=1
	NEV=0
c
 3      CALL VEGGEN3(5,FXNLL,AVGI,SD,CHI2A)  ! fill buffer, one iteration
c
	NUS=0               ! number of used events from total NEV
	IF(NEV.EQ.0) GOTO 3
      END IF
c
      NUS=NUS+1


c*************
c      print *,' GEN_VERMAS:  used events NUS=',NUS, '  NEV=',NEV

c
      DO I=1,4
        DO J=1,4
          PART(I,J)=EV(I,J,NUS)
        END DO

      END DO
c
c   For output
c
      IT1=ITER   ! iterations
      TI1=TI     ! int. in last iteration
      TS1=TSI    ! collected integral

      AVGI1=AVGI
      SD1=SD
      CHI2A1=CHI2A
c
 5    FORMAT(2F8.2,I5,2I3,I6)
 6    FORMAT(/,8X,'E3',5X,'Teta3',5X,'Fi3',10X,
     *            'E5',5X,'Teta5',5X,'Fi5',10X,
     *            'E6',7X,'Teta6',5X,'Fi6',12X,
     *            'E7',5X,'Teta7',5X,'Fi7',/)
 71   FORMAT(/,' Overflows of majoranta =',I4,/)
 7    FORMAT(/,' Simulation of process e+e- -> e+e- + ',A8,//,
     *         ' Regimes: ',4I1,//,'  Majoranta=',1PD10.2,/)
 9    FORMAT(1X,4(3(1PE10.2),2H I))
 10   FORMAT(/,' Number of events =',I4,/)
 14   FORMAT(/,' Energy=',F7.2,' MeV',//,
     *         ' Number of iterations=',I3,//,
     *         ' Write tables to disk',I2,//,
     *         ' Print first 10 events:',I2,/)
 17   FORMAT(' Errors: ',14I5,/)
 31   FORMAT(1X,'N=',I3)
 33   FORMAT(6X,4(1PD12.2))
 34   FORMAT( F10.3)
 35   FORMAT(' Iteration #',I3,': O events with weight 1',/)
 36   FORMAT(/,79(1H*),/)
 37   FORMAT(/,' Ebeam =',F10.5,' GeV',/,
     +         ' NIT   =',I10,' iterations before simulation', /,
     +         ' NPR   =',I10,' - regime of print out',/,
     +         ' NCAL  =',I10,' - points for int. evaluation',/,
     +         ' FMAJ  =',1pE10.1)

      END

c

      FUNCTION FXNLL(X,WGT)
c**********************************************************************
c                                                                     *
c   Function for VEGGEN                                               *
c                                                                     *
c   Simulation of process ee -> ee + ee (mu mu, tau tau) with Vermas. *
c                                                                     *
c   The last iteration event with weight=1 is written in /EVENTS/     *
c                                                                     *
c   Last correction  23.10.87                                         *
c                                                                     *
c**********************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VEDATA  / PI,ME,ME2,MU,MU2,E,S,EMP,CONST,FM
      COMMON /VELABVAR/ EW,E3,E5,E6,E7,PW,P3,P5,P6,P7,GAM1,GAM2
     1               ,AL3,BE5,CTW,STW,CT3,ST3,CT5,ST5,CT6,ST6,CT7,ST7
     2               ,CP3,SP3,CP5,SP5,CP6,SP6,CP7,SP7,W,W2
      COMMON /VEBVEG1 / NCALL,ITMX,IDUM(44)
      COMMON /VEBVEG4 / CALLS,DUMM(2)
      COMMON /VECO / IG,IDB,INP,NER(14),NW(19),NUS,NEV,EV(4,4,50),FMAXI
      DIMENSION X(10),Y(8)
      REAL *4 RLU
      SAVE ICALL
c
      DATA ICALL/0/

c*************************
c      data iacc/0/                ! for test
c
      ICALL=ICALL+1
      IF(IDB.EQ.1) PRINT *,' FXNLL'
c
      IF(ICALL.EQ.1) THEN   ! at first call
c
        DO I=1,19
          NW(I)=0
        END DO
c
      END IF
c
c-----------------------------------------------------------------
c     
c      CALL GRNDM(RN,1)
c
      X(6)=RLU(0)
c
c      CALL GRNDM(RN,1)
c
      X(7)=RLU(0)
c
      DO I=1,7
        Y(I)=X(I)
      END DO
c
c      CALL GRNDM(RN,1)
c
      Y(8)=RLU(0)
      WMIN=0.
c
      CALL EEMUMU(WMIN,DJDX,Y,NERR)
c
      IF (NERR.NE.0) GOTO 11   ! error from EEMUMU
c
      FXNLL=DJDX*CONST*DIASQU(W2)

c.........
c  Filling histogram on weights
      WEI=FXNLL*WGT/CALLS
      IF(WEI.LE.0.) WEI=1.D-20
      IW=DLOG10(WEI)+18
      IF(IW.LT.1) IW=1
      IF(IW.GT.19) IW=19
      NW(IW)=NW(IW)+1
c
      IF(WEI.GT.FM) INP=INP+1    ! number of events with weights > majoranta
      IF(WEI.GT.FMAXI) FMAXI=WEI ! determination of maximum weight

c
c      CALL GRNDM(RN,1)
c
      IF(FM*RLU(0).GT.WEI) GOTO 5 ! rejection to obtain events with weight=1

c***************
c      iacc=iacc+1
c      print *,' FXNLL: ICALL=',icall,' IACC=',iacc,' CALLS=',calls


      IF(NEV.GE.50) GOTO 5    ! max 50 events in buffer for one iteration
      NEV=NEV+1
      PM=DSQRT(E3**2-ME2)
      EV(1,3,NEV)=PM*CT3      ! initial beams along z-axis
      EV(1,1,NEV)=PM*ST3*CP3
      EV(1,2,NEV)=PM*ST3*SP3
      EV(1,4,NEV)=E3
c
      PM=DSQRT(E5**2-ME2)
      EV(2,3,NEV)=PM*CT5          ! along z-axis
      EV(2,1,NEV)=PM*ST5*CP5
      EV(2,2,NEV)=PM*ST5*SP5
      EV(2,4,NEV)=E5
c
      PM=DSQRT(E6**2-MU2)
      EV(3,3,NEV)=PM*CT6          ! along z-axis
      EV(3,1,NEV)=PM*ST6*CP6
      EV(3,2,NEV)=PM*ST6*SP6
      EV(3,4,NEV)=E6
c
      PM=DSQRT(E7**2-MU2)
      EV(4,3,NEV)=PM*CT7          ! along z-axis
      EV(4,1,NEV)=PM*ST7*CP7
      EV(4,2,NEV)=PM*ST7*SP7
      EV(4,4,NEV)=E7
c
 5    CONTINUE
      RETURN
c
11    FXNLL=0.
c
6     FORMAT(5I1,5X,E12.3,Z8)
100   FORMAT(I3,12F6.3)
      RETURN
      END
c

      SUBROUTINE EEMUMU(WMIN,DJDX,X,NERR)
c***********************************************************************
c                                                                      *
c   CALCULATION OF LAB. VAR-S /LABVAR/, SCAL. PRODUCTS FOR \M\**2      *
c                                                                      *
c   WMIN - MIN. EFF. MASS OF PRODUCED PAIR                             *
c   DJDX - PHASE VOLUME FACTOR                                         *
c   X - ARRAY OF RANDOM NUMBERS                                        *
c   NERR - NUMBER OF ERROR                                             *
c                                                                      *
c   Last correction  23.01.2004                                        *
c                                                                      *
c***********************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
c      COMMON /VEERRORS/ NER(14),IDEB
      COMMON /VECO / IG,IDB,INP,NER(14),IDUM(1623)
      COMMON/VEDATA/PI,ME,ME2,MU,MU2,E,S,EMP,CONST,DUMM(1)
      COMMON/VEDOTP/P12,P13,P14,P15,P23,P24,P25,P34,P35,P45,Q1,Q2,Q3,Q4
      COMMON/VEDOTM/P1DQ,P2DQ,P3DQ,P5DQ,Q1DQ
      COMMON/VELABVAR/EW,E3,E5,E6,E7,PW,P3,P5,P6,P7,GAM1,GAM2,AL3,BE5
     1,CTW,STW,CT3,ST3,CT5,ST5,CT6,ST6,CT7,ST7,CP3,SP3,CP5,SP5,CP6,SP6
     2,CP7,SP7,W,W2
      COMMON/VELABV1/ QX,QY,QZ
      COMMON/VEMOM/   RT1,RT2
      COMMON/VEDELTA/ DELTA
      DIMENSION X(8),Y(4)
c
      DATA ICALL/0/
c      DATA ACC/1.D-9/       ! was initialy
      DATA ACC/1.D-8/        ! +
c
      ICALL=ICALL+1
      IF(IDB.EQ.1) PRINT *,' ---------------------------------------'
      IF(IDB.EQ.1) PRINT *,' EEMUMU, ICALL=',ICALL
      NERR=0
      P=E-EMP
      WWMAX=2.*(E-ME)
      WWMIN=2.*MU
      IF(WWMIN.LT.WMIN)  WWMIN=WMIN
      IF(WWMIN.GT.WWMAX) GO TO 11     ! error
      W2MAX=1./(WWMAX*WWMAX)
      W2MIN=1./(WWMIN*WWMIN)
      DW=W2MIN-W2MAX
c
c..Simulation of W according to distr. funct. dF/dW = 1/W**3
c
      W2=1./(W2MIN-DW*X(5))
      W=DSQRT(W2)
      DW=DW*W2*W*DSQRT((W+2.*MU)*(W-2.*MU))/8.
c
c..This includes the factor due to the quasi two-body decay
c
      DO I=1,4
        Y(I)=X(I)
      END DO
c...........
c   CALCULATION OF KINEMATICAL QUANTITIES FOR 2 - > 3 REACTION
c
      CALL INITM(S,W,0,DW)
c
c...CALCULATION OF THE VARIABLES S1, S2, T1, T2 FROM Y1-Y4; DJDX
c
      CALL PICK4(S1,S2,T1,T2,C2,Y,2)
c.......
c   If phase subvolume (C2) in PICK4 =0. - error 12
      IF(C2.EQ.0.D0) GOTO 12
      DJDX=-C2
      RT1=T1
      RT2=T2
c...EW - ENERGY OF PRODUCED SYSTEM
      EW=.25*(S1+S2-2.*ME2)/E
      PW=DSQRT((EW-W)*(EW+W))
      EWMPW=W2/(EW+PW)
      PW=EW-EWMPW
      EP1=DELTA+ME2*(S1+S2+(2.*PW+ME)*(2.*PW-ME))
      EP2=EP1/(S2-S1-4.*P*PW)
      EP1=EP1/(S1-S2-4.*P*PW)
      GAM1=(.5*(T1-T2)+EP1)/(P*PW)
      GAM2=(.5*(T2-T1)+EP2)/(P*PW)
      IF(GAM1.LT.1.) GAM2=2.-GAM1
      IF(GAM2.LT.1.)GAM1=2.-GAM2
      IF(GAM1.LT.1.)CTW=1.-GAM1
      IF(GAM2.LT.1.)CTW=GAM2-1.
      IF(GAM1*GAM2.LT.0.) GOTO 21
      STW=DSQRT(GAM1*GAM2)
c
c     Possible peaking could be along either beam
c
c     If S1.gt.S2 use GAM2 because CTW is almost -1.
c     If S2.gt.S1 use GAM1 because CTW is almost +1.
c
      EME3=.25*(S2-ME2)/E
      EME5=.25*(S1-ME2)/E
c
c  Energy of scattered particles
c
      E3=E-EME3
      E5=E-EME5
      P3=DSQRT((E3-ME)*(E3+ME))
      P5=DSQRT((E5-ME)*(E5+ME))
      E3MP3=ME2/(E3+P3)
      E5MP5=ME2/(E5+P5)
      P3=E3-E3MP3
      P5=E5-E5MP5
      EPA=-ME2*EME3*EME3/(E*E3+P*P3-ME2)
      EPB=-ME2*EME5*EME5/(E*E5+P*P5-ME2)
      AL3=(EPA-.5*T1)/(P*P3)
      BE5=(EPB-.5*T2)/(P*P5)
      IF(AL3.LT.0..OR.BE5.LT.0.) GO TO 13
c........
c  Angles theta of scattered particles
c
      CT3=1.-AL3
      CT5=-1.+BE5
      ST3=DSQRT(AL3*(2.D0-AL3))
      ST5=DSQRT(BE5*(2.D0-BE5))
      IF(S1.GT.S2) GOTO 5
c
      Z13=((PW*GAM1+P3*AL3)*((.5*T2+PW*EMP-EPA)+2.*E*(EMP-E3MP3)-EMP*
     1 (EWMPW+P3*AL3+PW*GAM1))/(2.*E)+PW*E3MP3-(2.*E-EWMPW)*(.5*T2+PW
     2 *EMP-EPA)/(2.*E)-.5*(PW*STW-P3*ST3)**2)/(P3*PW*ST3*STW)
c
      Z15=((PW*GAM1-P5*BE5)*((EPB-.5*T1+PW*EMP)-2.*E*(EMP-E5MP5)+EMP*
     1 (EW+PW-PW*GAM1+P5*BE5))/(2.*E)-PW*E5MP5-.5*(PW*STW-P5*ST5)**2
     2 +(2.*E-EW-PW)*(EPB-.5*T1+PW*EMP)/(2.*E))/(PW*P5*STW*ST5)
      GOTO 6
c
   5  Z13=((PW*GAM2-P3*AL3)*((EPA-.5*T2+PW*EMP)-2.*E*(EMP-E3MP3)+EMP*
     1 (EW+PW-PW*GAM2+P3*AL3))/(2.*E)-PW*E3MP3-.5*(PW*STW-P3*ST3)**2
     2 +(2.*E-EW-PW)*(EPA-.5*T2+PW*EMP)/(2.*E))/(P3*PW*ST3*STW)
c
      Z15=((PW*GAM2+P5*BE5)*((.5*T1+PW*EMP-EPB)+2.*E*(EMP-E5MP5)-EMP*
     1 (EWMPW+P5*BE5+PW*GAM2))/(2.*E)+PW*E5MP5-(2.*E-EWMPW)*(.5*T1+PW
     2 *EMP-EPB)/(2.*E)-.5*(PW*STW-P5*ST5)**2)/(P5*PW*ST5*STW)
c
6     CONTINUE
c
c  Angles FI of scattered particles
c
      CP3=Z13-1.
      CP5=Z15-1.
      IF(DABS(CP3).GT.1.D0.OR.DABS(CP5).GT.1.D0) GOTO 14
      SP=-E3MP3*P5-E5MP5*E3-P3*P5*(AL3+BE5-AL3*BE5+ST3*ST5*CP3*CP5)
     1 +(ME2*(2.*S-S1-S2+ME2)-DELTA)/(2.*S)
      SP=SP/(P3*P5*ST3*ST5)
      IF(Z13.LT.Z15) GO TO 7
      SP3=DSQRT(Z13*(2.D0-Z13))
      IF(X(8).LT..5)SP3=-SP3
      IF(SP3.EQ.0.) GOTO 20
      SP5=SP/SP3
      ACC1=DABS(SP5*SP5+CP5*CP5-1.D0)
      GO TO 8
7     SP5=DSQRT(Z15*(2.D0-Z15))
      IF(X(8).LT..5)SP5=-SP5
      IF(SP5.EQ.0.) GOTO 23
      SP3=SP/SP5
      ACC1=DABS(SP3*SP3+CP3*CP3-1.D0)
8     CONTINUE
c.............
c   ACCURACY IN FI3 < 1.D-9 - ERROR 17
c
      IF(ACC1.GT.ACC) GO TO 17
      CT1P=1.-2.*X(6)
      ST1P=2.D0*DSQRT(X(6)*(1.D0-X(6)))
      PHP=2.*PI*X(7)
      CPHP=DCOS(PHP)
      SPHP=DSIN(PHP)
      EQP=DSQRT((W-2.*MU)*(W+2.*MU))/W
      EQ=EQP*PW*CT1P
      QX=EQP*(W*CTW*ST1P*CPHP+EW*CT1P*STW)
      QY=EQP*W*ST1P*SPHP
      QZ=EQP*(EW*CT1P*CTW-W*STW*ST1P*CPHP)
c
c.... Q = P6 - P7
c
      P1DQ=E*EQ-P*QZ
      P2DQ=E*EQ+P*QZ
      P3DQ=E3*EQ-P3*(QX*ST3*CP3+QY*ST3*SP3+QZ*CT3)
      P5DQ=E5*EQ-P5*(QX*ST5*CP5+QY*ST5*SP5+QZ*CT5)
      Q1DQ=EME3*EQ+(CP3*QX+SP3*QY)*P3*ST3-(EME3-EMP+E3MP3+P3*AL3)*QZ
      E6=.5*(EW+EQ)
      E7=.5*(EW-EQ)
      P6=DSQRT((E6+MU)*(E6-MU))
      P7=DSQRT((E7+MU)*(E7-MU))
      E6MP6=MU2/(E6+P6)
      E7MP7=MU2/(E7+P7)
      P6=E6-E6MP6
      P7=E7-E7MP7
      CT6=.5*(PW*CTW+QZ)/P6
      CT7=.5*(PW*CTW-QZ)/P7
      IF(DABS(CT6).GT.1.D0) GOTO 15
      IF(DABS(CT7).GT.1.D0) GOTO 16
      ST6=DSQRT((1.D0-CT6)*(1.D0+CT6))
      ST7=DSQRT((1.D0-CT7)*(1.D0+CT7))
      CP6=.5*(PW*STW+QX)/(P6*ST6)
      CP7=.5*(PW*STW-QX)/(P7*ST7)
      SP6= .5*QY/(P6*ST6)
      SP7=-.5*QY/(P7*ST7)
      ACC6=DABS(CP6*CP6+SP6*SP6-1.D0)
      ACC7=DABS(CP7*CP7+SP7*SP7-1.D0)
      IF(ACC6.GT.ACC*100.) GO TO 18
      IF(ACC7.GT.ACC*100.) GO TO 19
      RETURN
C
23    NERR=NERR+1   ! Err  N 12
21    NERR=NERR+1   ! Err  N 11
20    NERR=NERR+1   ! Err  N 10
19    NERR=NERR+1   ! Err  N 9
18    NERR=NERR+1   ! Err  N 8
17    NERR=NERR+1   ! Err  N 7
16    NERR=NERR+1   ! Err  N 6
15    NERR=NERR+1   ! Err  N 5
14    NERR=NERR+1   ! Err  N 4
13    NERR=NERR+1   ! Err  N 3
12    NERR=NERR+1   ! Err  N 2
11    NERR=NERR+1   ! Err  N 1
      DJDX=0.
c*******
      IF(IDB.EQ.2)  print *,' EEMUMU: DJDX=0, NERR=',NERR
      NER(NERR)=NER(NERR)+1
      RETURN
      END

c
      SUBROUTINE INITM(SS,WW,INFO,CONST)
c***********************************************************************
C                                                                      *
c   INITM calculates kinem. variables for reaction e e-> ee W ( 2 ->3 )*
c                                                                      *
c   SS         - total energy squared (GeV)                            *
c   WW         - produced mass (GeV)                                   *
c   INFO (>=1) - print information                                     *
c   CONST      - parameter                                             *
c                                                                      *
c***********************************************************************
      IMPLICIT REAL *8(A-H,M,O-Z)
c
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VEDATA  / PI,ME,DUMM(8)
      COMMON /VEINIT/ S,V(5) ,MD(5), M13,M45,MM4,Q,V13,
     1              SQ1,SW,SQM,SWM,SUBS,TMIN,TMAX,DT1,B0(6),C0(6),B1(5),
     2              C1(5),C2(3),AL(14),BE(14),GA(3),DE(9)

c
      IF(IDB.EQ.1) PRINT *,' INITM'
      S=SS
      E=DSQRT(S)/2.D0
      E2=S/4.D0
      M=ME
      M2=M**2
      M4=M2**2
      M6=M2**3
      M8=M2**4
      W=WW
      W2=WW**2
      W4=WW**4
c
      DO 1 I=1,5
        V(I)=M
        MD(I)=M2
 1    CONTINUE
c
      V(4)=W
      MD(4)=W2
c
      M45=(M+W)**2
      M13=2.*M2
      MM4=4.*M2
      Q=S+M2
      V13=4.*M4
      SW=S
      SQ1=4.*E*DSQRT(E2-M2)
      ST=S-W2-2.*W*M
      SL2=ST*ST-4.*S*M2
      SQ2=DSQRT(SL2)
C
      AL(1)  = S*M2
      AL(2)  = -S*M2
      AL(3)  = S*M2*(S-3.*M2-W2)
      AL(4)  = M4
      AL(5)  = 2.*S*M2*W2-2.*M6
      AL(6)  = S*M2*W2*(-2.*S+6.*M2+W2)+M8
      AL(7)  = 0.
      AL(8)  = -2.*W2*M4
      AL(9)  = -S*W4*M2+4.*M6*W2
      AL(10) = S*(S*M2*W4-3.*M4*W4)-2.*M8*W2
      AL(11) = 0.

      AL(12) = M4*W4
      AL(13) = -2.*M6*W4
      AL(14) = M8*W4
c
      BE(1)  = -S
      BE(2)  = -S*(M2-W2)
      BE(3)  = 2.*S
      BE(4)  = S*(2.*M2-2.*W2-S)
      BE(5)  = BE(2)*(S-4.*M2)
      BE(6)  = -S-M2
      BE(7)  = S*(S+W2-M2)+M2*(W2+M2)
      BE(8)  = 5.*S*M4-2.*S**2*M2-W2*S**2+4.*M2*W2*S-2.*M4*W2+M6
      BE(9)  = M2*(M2-W2)*(S**2-3.*S*M2-M4)
      BE(10) = M2
      BE(11) = -4.*M4-M2*W2
      BE(12) = W2*M4+6.*M6
      BE(13) = M6*W2-4.*M8
      BE(14) = M8*(M2-W2)
c
      GA(1) = M6
      GA(2) = -2.*M4
      GA(3) = S*(S-3.*M2)
c
      B0(3) = -2.*M2
c
      B1(1) = -2.*M2*(S-M2)
      B1(2) = 2.*S
      B1(3) = -2.
      B1(4) = 2.*(S-M2)
      B1(5) = 2.
c
      DE(1) = 2.*M4*W2*S
      DE(2) = -2.*M2*(S*W2+2.*M2*W2+M4)
      DE(3) = 4.*M2*(M2+W2)
      DE(4) = -2.*M2
      DE(5) = -4.*M2*W2*S
      DE(6) = 2.*(4.*M4-S*W2-S*M2)
      DE(7) = 2.*S
      DE(8) = 2.*W2*S
      DE(9) = -2.*(S+M2)
c
      IF(INFO.GE.1) PRINT 103,V,S
c
      YMA=-(SW*ST+SQ1*SQ2)/(2.*S)
      TMAX=YMA+2.*M2
      SQM=SQ1/(2.*M2)
      SWM=S/(2.*M2)
      TMIN=W2*M2*(W+2.*M)**2/S/TMAX
      IF(INFO.GE.1) PRINT 100,TMIN,TMAX
c
      DT1=TMAX-TMIN
      SUBS=CONST*PI/(SQ1*4.)
c
c      IF(INFO.GE.2)PRINT 104,S,V,             M1,          M13,M45,MM4
c     1,Q,V13,SQ1,SW,SQM,SWM,SUBS,TMIN,TMAX,DT1,B0,C0,B1,C1,C2,AL,BE,GA
c     2,DE
c
 100  FORMAT(//9H   TMIN =,G18.10/9H   TMAX =,G18.10/)
 103  FORMAT(9H1MASS 1 =,G18.10/9H MASS 2 =,G18.10/9H MASS 3 =,G18.10
     .   /9H MASS 4 =,G18.10/9H MASS 5 =,G18.10/9H    S   =,G18.10//)
 104  FORMAT(//20H VARIABLES IN COMMON/6G20.10/5G20.10/5G20.10/4G20.10
     . /G20.10/3G20.10/6G20.10/6G20.10/2(5G20.10/),3G20.10//2(7G18.10/)/

     .    2(7G18.10/)/3G18.10//7G18.10/2G18.10)
      RETURN
      END
c
      SUBROUTINE PICK4(S1,S2,T1,T2,CON,X,IDOT)
c***********************************************************************
c                                                                      *
c     PICK4 calculates variables S1,S2,T1,T2                           *
c                                                                      *
c   CON  - phase subvolume                                             *
c   IDOT - regime = 0; 1; <0 or >1                                     *
c   X(4) - random numbers                                              *
c   CON  - =0 for error                                                *
c                                                                      *
c  Last correction:  16.10.86                                          *
c                                                                      *
c***********************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VEDOTP/ P12,P13,P14,P15,P23,P24,P25,P34,P35,P45,Q1,Q2,Q3,
     +                Q4
      COMMON /VEINIT/S,V1,V2,V3,V4,V5,M1,M2,M3,M4,M5,M13,M45,MM4,Q,V13,
     +                SQ1
     1,SW,SQM,SWM,SUBS,TMIN,TMAX,DT1,B0(6),C0(6),B1(5),C1(5),C2(3)
     2 ,AL(14),BE(14),GA(3),DE(9)
      COMMON /VEDELTA/ DELTA
      DIMENSION X(4)
c
      IF(IDB.EQ.1) PRINT *,' PICK4'
c
      ZERO=0.D0
      EINS=1.D0
      ZWO=2.D0
      VIER=4.D0
      SIXT=16.D0
      XT1=X(1)
c
c   Simulation of T1. DT1 - weight of d.f.
c
      CALL MAPT1(T1,XT1,TMIN,TMAX,DT1)

c
c************
c      print *,' PICK4:', t1,xt1,tmin,tmax,dt1



      Y=T1-M13
      SM=M45
      IF(V1.NE.0) GOTO 2
      SMAX=Q+Y*SWM+SQM/Y
      GO TO 3
c
2     YB1=T1-((V3-V2)*(V3+V2)+(V1-V2)*(V1-V2))
      YB2=T1-(M13+2.*V1*V2)

c***********
c      print *,YB1,YB2,YB1*YB2

      IF(YB1*YB2.LT.0.) GOTO 1
      YB=SQM*DSQRT(YB1*YB2)
      YC=Q+SWM*Y
      SMAX=YC+YB
      IF(YC-YB.GT.M45) SM=YC-YB
3     DS2=SMAX-SM
c............
c   Calculation of S2
      S2=DS2*X(2)+SM
c
5     A=(S2-T1+M2)**2-MM4*S2
      PB1=B1(1)+S2*(B1(2)+S2*B1(3)+T1*B1(5))+T1*B1(4)
c
      PA=SIXT*((S*T1-SW*S2+GA(3))*T1+(M1*S2+GA(2))*S2+GA(1))*S2
c
      PB=SIXT*((((BE(1)*S2+BE(2))*T1+(BE(3)*S2+BE(4))*S2+BE(5))*T1
     1   +((BE(6)*S2+BE(7))*S2+BE(8))*S2+BE(9))*T1
     2   +(((BE(10)*S2+BE(11))*S2+BE(12))*S2+BE(13))*S2+BE(14))
c
      PC=SIXT*((((T1*AL(1)+S2*AL(2)+AL(3))*T1+(S2*AL(4)+AL(5))*S2+AL(6))
     1  *T1+((S2*AL(7)+AL(8))*S2+AL(9))*S2+AL(10))*T1+((S2*AL(11)+AL(12)
     2   )*S2+AL(13))*S2+AL(14))
c
      IF(PA.GE.0) GOTO 1
c
      PD=PB*PB-VIER*PA*PC



c***********
c      print *,' PICK4: PD=',PD



      IF(PD.LT.0) GOTO 1
C
      PS=DSQRT(PD)
      PBS=PB-PS
      T2MAX=-PBS/(2.*PA)
      T2MIN=PC/(PA*T2MAX)
      XT2=X(3)
c...........
c   Simulation of T2. DT2 - weight of d.f.
c
      CALL MAPT2(T2,XT2,T2MIN,T2MAX,DT2)
c
      D=PA*(T2-T2MAX)*(T2-T2MIN)
      IF(D.LE.0) GOTO 1
c
      PS=DSQRT(D)
      DELTA=DE(1)+S2*(DE(2)+S2*(DE(3)+S2*DE(4)))
     1  +T1*((DE(5)+S2*(DE(6)+S2*DE(7)))+T1*(DE(8)+S2*DE(9)))
      DELMIN=(DELTA+S2*(T2*PB1-PS))/(ZWO*A)
      DDEL=S2*PS/A
      DELTA=DELMIN+DDEL*(EINS-X(4))
c.........
c   Calculation of S1
c
      S1=(S*M4-DELTA)/S2
      GRAM=A*(1.-X(4))*X(4)
      DGRAM=DSQRT(GRAM)
      CON=DT1*DT2*DS2*SUBS/DGRAM
      CON=-CON
      IF(IDOT.EQ.0) RETURN
c
      P12=(S-M1-M2)/ZWO
      P13=(M13-T1)/ZWO
      P14=(S1+T1-T2-M3)/ZWO
      P15=(S+T2-S1-M2)/ZWO
      P23=(S+T1-S2-M1)/ZWO
      P24=(S2+T2-T1-M5)/ZWO
      P25=(M2+M5-T2)/ZWO
      P34=(S1-M3-M4)/ZWO
      P35=(S+M4-S1-S2)/ZWO
      P45=(S2-M4-M5)/ZWO
c
      IF(IDOT.EQ.1) RETURN
c
      Q1=(T2-S1+M1)/ZWO
      Q2=(M1+M4-S1-T1)/ZWO
      Q3=(T1-S2+M2)/ZWO
      Q4=(M2+M4-S2-T2)/ZWO
      RETURN
c...........
c   Errors, CON=0.
1     CON=ZERO
c
      RETURN
      END
c
      SUBROUTINE MAPT1(T,X,TMIN,TMAX,DT)
c
      COMMON /VECO  / IG,IDB,IDUM(1638)
      REAL*8 T,X,TMIN,TMAX,DT,Y
c
      IF(IDB.EQ.1) PRINT *,' MAPT1'
      Y=TMAX/TMIN
      T=TMIN*Y**X
      DT=T*DLOG(Y)
      RETURN
      END
c
      SUBROUTINE MAPT2(T,X,TMIN,TMAX,DT)
c
      COMMON /VECO  / IG,IDB,IDUM(1638)
      REAL*8 T,X,TMIN,TMAX,DT,Y
c
      IF(IDB.EQ.1) PRINT *,' MAPT2'
      Y=TMAX/TMIN
      T=TMIN*Y**X
      DT=T*DLOG(Y)
      RETURN
      END
c
      SUBROUTINE VEGGEN(NDIM,FXN,AVGI,SD,CHI2A)   ! VEGGEN(..)=VEGAS(...)
c***********************************************************************
c                                                                      *
c   SUBROUTINE PERFORMS N-DIMENSIONAL MONTE-CARLO INTEGRATION          *
c    - BY G.P.  LEPAGE  SEPT 1976/ (REV) AUG 1979                      *
c    - ALGORITHM DESCRIBED IN J COMP PHYS 27,192(1978)                 *
c                                                                      *
c   Parameters ITMX, ACC are not used   ???                            *
c                                                                      *
c   Last correction:   4.03.2004                                       *
c                                                                      *
c***********************************************************************
c      IMPLICIT REAL *8(A-H,O-Z)       ! old
      IMPLICIT NONE
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VEBVEG1/  NCALL,ITMX,NPRN,NDEV,XL(10),XU(10),ACC
      COMMON /VEBVEG2/  IT,NDO,SI,SWGT,SCHI,XI(50,10)
      COMMON /VEBVEG3/  ALPH,NDMX,MDS
      COMMON /VEBVEG4/  CALLS,TI,TSI
      REAL *8 D(50,10),DI(50,10),XIN(50),R(50),DX(10),DT(10),X(10)
      REAL *8 FXN,AVGI,SD,CHI2A,XL,XU,ACC,SI,SWGT,SCHI,XI
      REAL *8 ALPH,CALLS,TI,TSI,RAND(10),ONE,DXG,DV2G,XND,XJAC,RC
      REAL *8 XN,DR,XO,FB,F2B,WGT,F,F2,TI2
      REAL *4 RLU                                                ! +
      INTEGER *4 IG,IDB,IDUM,NCALL,ITMX,NPRN,NDEV,NDMX,MDS,IA(10)
      INTEGER *4 KG(10),NDO,IT,NDIM,J,ND,NG,NPG,K,NDM,I,IT1,IAJ,IAJ1
c
      DATA ONE/1.D0/

c
      IF(IDB.EQ.1) PRINT *,' VEGGEN'                                 ! +
      NDO=1
c
      DO J=1,NDIM
        XI(1,J)=ONE
      END DO
c
      ENTRY VEGGEN1(NDIM,FXN,AVGI,SD,CHI2A) ! initializes cummulative
c                                            variables, but not grid (VEGAS1)
      IT=0
      SI=0.
      SWGT=SI
      SCHI=SI
c
      ENTRY VEGGEN2(NDIM,FXN,AVGI,SD,CHI2A) ! no initialization (VEGAS2)
c
      ND=NDMX
      NG=1
      IF(MDS.EQ.0) GO TO 2
      NG=(NCALL/2.)**(1./NDIM)
      MDS=1
      IF((2*NG-NDMX).LT.0) GO TO 2
      MDS=-1
      NPG=NG/NDMX+1
      ND=NG/NPG
      NG=NPG*ND
 2    K=NG**NDIM
      NPG=NCALL/K
      IF(NPG.LT.2) NPG=2
      CALLS=NPG*K
      DXG=ONE/NG
      DV2G=(CALLS*DXG**NDIM)**2/NPG/NPG/(NPG-ONE)
      XND=ND
      NDM=ND-1
      DXG=DXG*XND
      XJAC=ONE/CALLS
c
      DO J=1,NDIM
        DX(J)=XU(J)-XL(J)
        XJAC=XJAC*DX(J)
      END DO
c
c  Rebin, preserving bin density
c
      IF(ND.EQ.NDO) GO TO 8
      RC=NDO/XND
c
      DO 7 J=1,NDIM
        K=0
        XN=0.
        DR=XN
        I=K
 4      K=K+1
        DR=DR+ONE
        XO=XN
        XN=XI(K,J)
 5      IF(RC.GT.DR) GO TO 4
        I=I+1
        DR=DR-RC
        XIN(I)=XN-(XN-XO)*DR
        IF(I.LT.NDM) GO TO 5
c
        DO I=1,NDM
          XI(I,J)=XIN(I)
        END DO
c
        XI(ND,J)=ONE
 7    CONTINUE
c
      NDO=ND
c
 8    IF(NPRN.GE.0) PRINT 200,NDIM,CALLS,IT,ITMX,ACC,NPRN,ALPH, ! init.data
     *                        MDS,ND,(XL(J),XU(J),J=1,NDIM)
c
      ENTRY VEGGEN3(NDIM,FXN,AVGI,SD,CHI2A) ! main integration loop (VEGAS3)
c
 9    IT=IT+1
      IT1=IT            ! +
      TI=0.D0
      TSI=TI
c
      DO 10 J=1,NDIM
        KG(J)=1
c
        DO I=1,ND
          D(I,J)=TI
          DI(I,J)=TI
	END DO
c
 10   CONTINUE
c
 11   FB=0.D0
      F2B=FB
      K=0
 12   K=K+1
c
      DO J=1,NDIM
c
c	CALL GRNDM(RN,1)
c
        RAND(J)=RLU(0)
      END DO
c
      WGT=XJAC
c
      DO 15 J=1,NDIM
        XN=(KG(J)-RAND(J))*DXG+ONE
        IA(J)=XN
        IAJ=IA(J)
        IAJ1=IAJ-1
        IF(IAJ.GT.1) GO TO 13
        XO=XI(IAJ,J)
        RC=(XN-IAJ)*XO
        GO TO 14
c
 13     XO=XI(IAJ,J)-XI(IAJ1,J)
        RC=XI(IAJ1,J)+(XN-IAJ)*XO
c
 14     X(J)=XL(J)+RC*DX(J)
        WGT=WGT*XO*XND
 15   CONTINUE
c
      F=WGT*FXN(X,WGT)
      F2=F*F
      FB=FB+F
      F2B=F2B+F2

c
      DO J=1,NDIM
        IAJ=IA(J)
        DI(IAJ,J)=DI(IAJ,J)+F
        IF(MDS.GE.0)  D(IAJ,J)=D(IAJ,J)+F2
      END DO
c
      IF(K.LT.NPG) GO TO 12
c
      F2B=F2B*NPG

      F2B=DSQRT(F2B)
      F2B=(F2B-FB)*(F2B+FB)
      TI=TI+FB
      TSI=TSI+F2B
      IF(MDS.GE.0) GO TO 18
c
      DO J=1,NDIM
        IAJ=IA(J)
        D(IAJ,J)=D(IAJ,J)+F2B
      END DO
c
 18   K=NDIM
c
 19   KG(K)=MOD(KG(K),NG)+1
      IF(KG(K).NE.1) GO TO 11
      K=K-1
      IF(K.GT.0) GO TO 19
c
c  Compute final results for this iteration
c
      TSI=TSI*DV2G
      TI2=TI*TI
      WGT=ONE/TSI
      SI=SI+TI*WGT
      SWGT=SWGT+WGT
      SCHI=SCHI+TI2*WGT
      AVGI=SI/SWGT
      CHI2A=(SCHI-SI*AVGI)/(IT-.9999)

      SD=DSQRT(ONE/SWGT)
c
      IF(NPRN.LE.0) GO TO 21 ! +
c
      TSI=DSQRT(TSI)
c
      IF(NPRN.GE.1) ! +
     +  WRITE(NDEV,201) IT,TI*1000,TSI*1000,AVGI*1000,SD*1000,CHI2A  ! results
c                                                                    ! of iter. 
      IF(NPRN.NE.2) GO TO 21 ! +
c
      DO 20 J=1,NDIM
c
        WRITE(NDEV,202) J,(XI(I,J),DI(I,J),I=1+NPRN/2,ND,NPRN) ! grid
c
 20   CONTINUE
c
c   Refine grid
c
21    DO 23 J=1,NDIM
        XO=D(1,J)
        XN=D(2,J)
        D(1,J)=(XO+XN)/2.
        DT(J)=D(1,J)
c
        DO I=2,NDM
          D(I,J)=XO+XN
          XO=XN
          XN=D(I+1,J)
          D(I,J)=(D(I,J)+XN)/3.
          DT(J)=DT(J)+D(I,J)
	END DO
c
        D(ND,J)=(XN+XO)/2.
        DT(J)=DT(J)+D(ND,J)
 23   CONTINUE
c
      DO 28 J=1,NDIM
        RC=0.
c
        DO 24 I=1,ND
          R(I)=0.
          IF(D(I,J).LE.0.) GO TO 24
          XO=DT(J)/D(I,J)
          R(I)=((XO-ONE)/XO/DLOG(XO))**ALPH
 24     RC=RC+R(I)
c
        RC=RC/XND
        K=0
        XN=0.
        DR=XN
        I=K
c
 25     K=K+1
        DR=DR+R(K)
        XO=XN
        XN=XI(K,J)
c
 26     IF(RC.GT.DR) GO TO 25
        I=I+1
        DR=DR-RC
        XIN(I)=XN-(XN-XO)*DR/R(K)
        IF(I.LT.NDM) GO TO 26
c
        DO I=1,NDM
          XI(I,J)=XIN(I)
        END DO
c
        XI(ND,J)=ONE
28    CONTINUE
c
      IF(IT.LT.ITMX.AND.ACC*ABS(AVGI).LT.SD) GOTO 9
c
 200  FORMAT('  Input parameters for VEGGEN:',//,'  NDIM=',I3,' NCALL=',
     2 F8.0,' IT=',I5,' ITMX=',I5,' ACC=',G9.3,/,
     4 '  NPRN=', I3, ' ALPH=', F5.2, '  MDS=', I3, '  ND=',I4,/,
     5 '  (XL,XU)=(',G12.6,' , ',G12.6,' )',/,
     6 '          (',G12.6,' , ',G12.6,' )',/,
     7 '          (',G12.6,' , ',G12.6,' )',/,
     8 '          (',G12.6,' , ',G12.6,' )',/,
     9 '          (',G12.6,' , ',G12.6,' )')

 201  FORMAT( /,' Iter. No',I3,': Int=',1PD10.3,' +-',
     1 1PD10.3,' nb',/,
     2 ' Accum. res.: Int=',1PD10.3,' +-',
     3 1PD10.3,' nb  chi**2 per int=',0pF10.3)

c 202  FORMAT(/,' DATA FOR AXIS I2',/,'    X       DELTA I',
c     1 '   X       DELTA I       ','   X       DELTA I',
c     2  /(1X,F7.6,1X,G11.4,5X,F7.6,1X,G11.4,5X,F7.6,1X,G11.4))
 202  FORMAT(/15H DATA FOR AXIS ,I2,/,25H    X       DELTA I     
     1  ,24H   X       DELTA I       ,18H   X       DELTA I   
     2  ,/,(1H ,F7.6,1X,G11.4,5X,F7.6,1X,G11.4,5X,F7.6,1X,G11.4))
 
      RETURN
      END
c
      BLOCK DATA VERMAS
c
c...MAKES DEFAULT PARAMETER ASSIGNEMENTS FOR VEGAS
c
      IMPLICIT REAL *8 (A-H,O-Z)
      COMMON /VEBVEG1/ NCALL,ITMX,NPRN,NDEV,XL(10),XU(10),ACC
      COMMON /VEBVEG2/ IT,NDO,SI,SWGT,SCHI,XI(50,10)
      COMMON /VEBVEG3/ ALPH,NDMX,MDS
c
      DATA NCALL,ITMX,NPRN,NDEV/2000,100,-1,6/
      DATA XL,XU,ACC/10*0.D0,10*1.D0,-1.D0/
      DATA ALPH,NDMX,MDS/1.5D0,50,1/
      DATA IT,NDO,SI,SWGT,SCHI,XI/0,1,3*0.D0,500*1.D0/
c
      END
c
      FUNCTION DIASQU(W2)
c***********************************************************************
c                                                                      *
c  Main subroutine of calculation of |M|^2                             *
c                                                                      *
c  Last correction: 22.01.2004                                         *
c                                                                      *
c***********************************************************************
      IMPLICIT REAL *8(A-H,O-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VELABVAR/ EW,E3,E5,E6,E7,PW,P3,P5,P6,P7,GAM1,GAM2,AL3,BE5
     1,CTW,STW,CT3,ST3,CT5,ST5,CT6,ST6,CT7,ST7,CP3,SP3,CP5,SP5,CP6,SP6
     2,CP7,SP7,W,WSQ
      REAL *4 RLU
c
      IF(IDB.EQ.1) PRINT *,' DIASQU'
c
      IF(IG.EQ.1.OR.IG.EQ.6.OR.IG.EQ.8) THEN
c..........
c  Only main diagrams, rapid calculation |M|^2 for 2gamma prod. 2e,2mu,2tau
        DD=D(W2)
        GOTO 1
      END IF
c......
c  There are other diagrams than main
      IF(IG.EQ.2) DD=SIXDIA(W2)     ! only  Bremsst        for ee->4e
      IF(IG.EQ.3) DD=SIXDIA(W2)     ! main + Bremsst       for ee->4e
      IF(IG.EQ.4) DD=TWODID(W2)     ! main + ident.        for ee->4e
      IF(IG.EQ.5) DD=SIXDID(W2)     ! main + ident.        for ee->4e
      IF(IG.EQ.7) DD=SIXDIA(W2)     ! main + ident.        for ee->2e 2mu
c
 1    DIASQU=DD
c.........
c   Add arbitrary azimuthal angle
c
c      CALL GRNDM(RN,1)
c
      FIR=8.*DATAN(1.D0)*RLU(0)
      FI3=DATAN2(SP3,CP3)+FIR
      FI5=DATAN2(SP5,CP5)+FIR
      FI6=DATAN2(SP6,CP6)+FIR
      FI7=DATAN2(SP7,CP7)+FIR
      SP3=DSIN(FI3)
      CP3=DCOS(FI3)
      SP5=DSIN(FI5)
      CP5=DCOS(FI5)
      SP6=DSIN(FI6)
      CP6=DCOS(FI6)
      SP7=DSIN(FI7)
      CP7=DCOS(FI7)
c
   4  FORMAT(//,' DIASQU: identical part. should be used only for e+e-')
   5  FORMAT(//,' DIASQU: main diagrams should be included',//)
      RETURN
      END
c
      DOUBLE PRECISION FUNCTION D(W2)
c********************************************************************
c
c  |M|^2 for main diagrams
c
c********************************************************************
      IMPLICIT REAL*8 (A-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VEMOM/   T1, T2
      COMMON /VEDOTM/  P1DQ,P2DQ,P3DQ,P5DQ,Q1DQ
      COMMON /VEDELTA/ DELTA
      COMMON /VEDATA/  PI,ME,ME2,MU,MU2,E,S,EMP,CONST,DUMM(1)
      COMMON /VEDOTP/  P1DP2,P13,P1DP4,P15,P23,P2DP4,P25,P34,P35,P45,Q1,
     +                 Q2,Q3,Q4
      INTEGER *4 IG,IDB,IDUM
c
      IF(IDB.EQ.1) PRINT *,' D'
      Q1DQ2=.5*(W2-T1-T2)
      M12=ME2
      M32=ME2
      M22=MU2
      EP=.25*(DELTA-(T1+T2)*2.*P1DP2-2.*P34*(T2-T1-M32)-2.*P45*(T1-T2
     1-M12)+M12*M32+(T1-T2)**2)
      M3222=M32+M22
      M1222=M12+M22
      M1232=M12+M32
      B=Q1DQ**2-Q1DQ2**2
      A2=P2DP4*Q1DQ+P2DQ*Q1DQ2
      A1=P1DP4*Q1DQ-P1DQ*Q1DQ2
      AA=-512.*(P1DP2*Q1DQ**2+P1DP4*P2DQ*Q1DQ-P1DQ*P2DP4*Q1DQ-P1DQ*P2DQ
     1*Q1DQ2-EP*Q1DQ2-.5*T1*(P2DP4*Q1DQ2+P2DQ*Q1DQ)-.5*T2*(P1DP4*Q1DQ2
     1-P1DQ*Q1DQ))**2
     1-128.*(T1*T2*(M1232*B*W2+M22*(Q1DQ**2*(T1+T2)+2.*Q1DQ2*B))+Q1DQ**2
     1*(M12*T2+M32*T1)*(T1*T2+B)+B*T1*M32*(2.*P1DP4-T1-Q1DQ2)**2
     1+B*T2*M12*(2.*P2DP4-T2-Q1DQ2)**2)
     1-512.*(T1*M1222*(A2-.5*T2*Q1DQ)**2+T2*M3222*(A1-.5*T1*Q1DQ)**2
     1+(T1*T2*M1222*M3222+M12*M32*B)*Q1DQ2**2)
     1-128.*T1*T2*B*((2.*P1DP2-P1DP4-P2DP4+Q1DQ2)**2+P1DQ**2+P2DQ**2
     1+.5*(T1**2+T2*(T1+T2))+(2.*P1DP2+Q1DQ2)*(T1+T2)-T2*P2DP4-T1*P1DP4)
     1+64.*T1*T2*A1*A2-128.*(T1*A2+T2*A1-T1*T2*Q1DQ )**2
     1-64.*T1*T2*((2.*B+P1DP4*Q1DQ2-P1DQ*Q1DQ)*(2.*B+P2DP4*Q1DQ2+P2DQ
     1*Q1DQ)-3.*B*(B+P1DP4*P2DP4)+B*P1DQ*P2DQ)
      P=T1*T2*B
      AA=AA/P
      D=AA/P
      RETURN
      END

c

      FUNCTION SIXDIA(XZ)
c********************************************************************
c
c   Matrix element squared e+e- -> e+e- mu+mu- (e+e-)
c
c   Two-photon main and Bremsstrahlung diagrams
c   IG = 2 - only two-photon Bremsstrahlung diagrams
c
c********************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VECO/   IG,IDB,IDUM(1638)
      COMMON /VEMOM/    T1,T2
      COMMON /VEFOUR/   P1(4),P2(4),P3(4),P5(4),P6(4),P7(4),P4(4)
      COMMON /VEDATA/   PI,ME,ME2,MU,MU2,E,S,EMP,CONST,DUMM(1)
      COMMON /VELABVAR/ XXX(33),W2
      COMMON /VEQFOUR/  Q1(4),Q2(4),Q3(4),Q4(4),Q5(4),Q6(4),DUMM1(28)
      COMMON /VEONE/    ONE13,ONE25,ONE67,DUMM2(160)
      COMMON /VETWO/    T6127,T3341,T2565,DUMM3,DUMM4,DUMM5,DUMM6,DUMM7,
     +                DUMM8,DUMM9,DUMM10,DUMM11
      COMMON /VEZSUM/   Z11,Z22,Z33,Z44,Z1,Z2,Z3,Z4
      DIMENSION D(4)
      COMPLEX*16 ONE13(4,4),ONE25(4,4),ONE67(4,4)
      COMPLEX*16 T6127(4,4,4),T3341(4,4,4),T2565(4,4,4)
      COMPLEX*16 Z11(4,4,4),Z22(4,4,4),Z33(4,4,4),Z44(4,4,4),I,Z1,Z2,Z3
      COMPLEX*16 Z4,DUMM3(4,4,4),DUMM4(4,4,4),DUMM5(4,4,4),DUMM6(4,4,4)
      COMPLEX*16 DUMM7(4,4,4),DUMM8(4,4,4),DUMM9(4,4,4),DUMM10(4,4,4)
      COMPLEX*16 DUMM11(4,4,4)
c
      DATA I/(0.0,1.0)/
      DATA D/1.,-1.,-1.,-1./
c
      IF(IDB.EQ.1) PRINT *,' SIXDIA'
      YZ=XZ         ! +
      SE=ME
      SU=MU
c
      CALL DETER4
c
      DO 10 K=1,4
        Q1(K)=P3(K)-P1(K)+P6(K)
        Q2(K)=P1(K)-P3(K)-P7(K)
        Q3(K)=P3(K)+P4(K)
        Q4(K)=P1(K)-P4(K)
        Q5(K)=P4(K)-P2(K)
        Q6(K)=-P4(K)-P5(K)
 10   CONTINUE
c
      CALL ONEG(ONE13,P3,P1,SE,SE,1,1)
c
      CALL ONEG(ONE25,P2,P5,SE,SE,2,2)
c
      CALL ONEG(ONE67,P6,P7,SU,SU,1,2)
c
      CALL TWOGS(T3341,P3,P1,Q3,Q4,SE,SE,SE,1,1)
c
      CALL TWOGS(T2565,P2,P5,Q5,Q6,SE,SE,SE,2,2)
c
      CALL TWOGS(T6127,P6,P7,Q1,Q2,SU,SU,SU,1,2)
c
      DO 1 J1=1,4
c
        DO J2=1,4
          ONE67(J1,J2)=ONE67(J1,J2)*(D(J1)/W2)
          ONE13(J1,J2)=ONE13(J1,J2)*(D(J1)/T1)
          ONE25(J1,J2)=ONE25(J1,J2)*(D(J1)/T2)
	END DO
c
 1    CONTINUE
c
      FAC=1.                 ! main + Br diagrams
      IF(IG.EQ.2) FAC=0.   ! Br diagrams only  +
c
      DO 2 J1=1,4
      DO 2 J2=1,4
      DO 2 J3=1,4
        Z1=0.
        Z2=0.
c
        DO J4=1,4
          Z1=Z1+ONE13(J4,J1)*T6127(J4,J2,J3)*FAC
     &    +ONE67(J4,J3)*T3341(J4,J2,J1)
          Z2=Z2+ONE67(J4,J3)*T2565(J4,J2,J1)
        END DO
c
        Z11(J1,J2,J3)=Z1
        Z22(J1,J2,J3)=Z2
 2    CONTINUE
c
      Y=0.
c***
c   Polarization sums
c***
      DO 4 J1=1,4
      DO 4 J2=1,4
      DO 4 J3=1,4
        Z1=0.
c
        DO J4=1,4
          Z1=Z1+ONE25(J4,J3)*Z11(J1,J4,J2)+ONE13(J4,J1)*Z22(J3,J4,J2)
        END DO
c
        DRE=Z1
        DIM=I*Z1
        Y=Y+DRE*DRE+DIM*DIM
 4    CONTINUE
c
      SIXDIA=Y
      END
c
      SUBROUTINE DETER4
c********************************************************************
c
c   Gram determinant
c
c********************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VEFOUR/   R1(4),R2(4),R3(4),R5(4),R6(4),R7(4),R4(4)
      COMMON /VELABVAR/ EW,E3,E5,E6,E7,PW,P3,P5,P6,P7,GAM1,GAM2,AL3,BE5,
     1                CTW,STW,CT3,ST3,CT5,ST5,CT6,ST6,CT7,ST7,
     2                CP3,SP3,CP5,SP5,CP6,SP6,CP7,SP7,W,W2
      COMMON /VELABV1/   QX,QY,QZ
      COMMON /VEDATA/    PI,ME,ME2,MU,MU2,E,S,EMP,CONST,DUMM(1)
c
      IF(IDB.EQ.1) PRINT *,' DETER4'
      P=E-EMP
      R1(1)=E
      R2(1)=E
      R3(1)=E3
      R4(1)=EW
      R5(1)=E5
      R6(1)=E6
      R7(1)=E7
      R1(4)=P
      R2(4)=-P
      R3(4)=P3*CT3
      R4(4)=PW*CTW
      R5(4)=P5*CT5
      R6(4)=.5*(R4(4)+QZ)
      R7(4)=.5*(R4(4)-QZ)
      R1(2)=0.
      R2(2)=0.
      R3(2)=P3*ST3*CP3
      R4(2)=PW*STW
      R5(2)=P5*ST5*CP5
      R6(2)=.5*(R4(2)+QX)
      R7(2)=.5*(R4(2)-QX)
      R1(3)=0.
      R2(3)=0.
      R3(3)=P3*ST3*SP3
      R4(3)=0.
      R5(3)=P5*ST5*SP5
      R6(3)= .5*QY
      R7(3)=-.5*QY
      RETURN
      END
c
      FUNCTION ASIN(X)
      COMMON /VECO  / IG,IDB,IDUM(1638)
c
      REAL*8 Y,X
c
      IF(IDB.EQ.1) PRINT *,' ASIN'
      Y=DSQRT(1.-X*X)
      ASIN=DATAN2(X,Y)
      RETURN
      END
c
      FUNCTION ACOS(Y)
      COMMON /VECO  / IG,IDB,IDUM(1638)
c
      REAL*8 Y,X
c
      IF(IDB.EQ.1) PRINT *,' ACOS'
      X=DSQRT(1.-Y*Y)
      ACOS=DATAN2(X,Y)
      RETURN
      END

c

      SUBROUTINE USPIN(P,M,U)
c********************************************************************
c
c   Calculation of spinors
c
c   U(J1,J2):  J1 Lorentz index, J2 spin projection index
c   P - 4-momentum
c   M - mass of (anti)fermion
c
c   Incoming fermion spin +1/2, -1/2
c
c********************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMPLEX*16 I,U(4,2)
      DIMENSION P(4)
c
      DATA I/(0.0,1.0)/
c
      IF(IDB.EQ.1) PRINT *,' USPIN'
      SQ=DSQRT(P(1)+M)
      U(1,1)=SQ
      U(2,1)=0.
      U(3,1)=P(4)/SQ
      U(4,1)=(P(2)+I*P(3))/SQ
      U(1,2)=0.
      U(2,2)=SQ
      U(3,2)=(P(2)-I*P(3))/SQ
      U(4,2)=-U(3,1)
      RETURN
c
      ENTRY UBSPIN(P,M,U)
c
C***  OUTGOING FERMION  SPIN +1/2, -1/2
      SQ=DSQRT(P(1)+M)
      U(1,1)=SQ
      U(2,1)=0.
      U(3,1)=-P(4)/SQ
      U(4,1)=(-P(2)+I*P(3))/SQ
      U(1,2)=0.
      U(2,2)=SQ
      U(3,2)=(-P(2)-I*P(3))/SQ
      U(4,2)=-U(3,1)
      RETURN
c
      ENTRY VSPIN(P,M,U)
c
C***  INCOMING ANTIFERMION  SPIN +1/2, -1/2
      SQ=DSQRT(P(1)+M)
      U(1,1)=P(4)/SQ
      U(2,1)=(P(2)+I*P(3))/SQ
      U(3,1)=SQ
      U(4,1)=0.
      U(1,2)=(P(2)-I*P(3))/SQ
      U(2,2)=-U(1,1)
      U(3,2)=0.
      U(4,2)=SQ
      RETURN
c
      ENTRY VBSPIN(P,M,U)
c
C***  OUTGOING ANTIFERMION  SPIN +1/2, -1/2
      SQ=DSQRT(P(1)+M)
      U(1,1)=P(4)/SQ
      U(2,1)=(P(2)-I*P(3))/SQ
      U(3,1)=-SQ
      U(4,1)=0.
      U(1,2)=(P(2)+I*P(3))/SQ
      U(2,2)=-U(1,1)
      U(3,2)=0.
      U(4,2)=-SQ
      RETURN
      END

c

      SUBROUTINE ONEG(ONE,P1,P2,M1,M2,J1,J2)
c******************************************************************
c
c  ONE(K1,K2)  K1 Lorentz index, K2 spin projection index
c
c******************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMPLEX *16 I,ONE(4,4),U1(4,2),U2(4,2)
      DIMENSION P1(4),P2(4)
c
      DATA I/(0.0,1.0)/
c
      IF(IDB.EQ.1) PRINT *,' ONEG'
      IF(J1.EQ.1) GO TO 1
c
      CALL VBSPIN(P1,M1,U1)
c
      GO TO 2
c
   1  CALL UBSPIN(P1,M1,U1)
c
   2  IF(J2.EQ.1) GO TO 3
c
      CALL VSPIN(P2,M2,U2)
c
      GO TO 4
c
   3  CALL USPIN(P2,M2,U2)
c
   4  CONTINUE
      DO 5 J3=1,2
      DO 5 J4=1,2
      J5= J3 + 2*J4 - 2
      ONE(1,J5)=U1(1,J3)*U2(1,J4) + U1(2,J3)*U2(2,J4)
     1         -U1(3,J3)*U2(3,J4) - U1(4,J3)*U2(4,J4)
      ONE(2,J5)=U1(1,J3)*U2(4,J4) + U1(2,J3)*U2(3,J4)
     1         -U1(3,J3)*U2(2,J4) - U1(4,J3)*U2(1,J4)
      ONE(3,J5)=I*(U1(2,J3)*U2(3,J4) - U1(1,J3)*U2(4,J4)
     1           + U1(3,J3)*U2(2,J4) - U1(4,J3)*U2(1,J4))
      ONE(4,J5)=U1(1,J3)*U2(3,J4) - U1(2,J3)*U2(4,J4)
     1         -U1(3,J3)*U2(1,J4) + U1(4,J3)*U2(2,J4)
   5  CONTINUE
      RETURN
      END

c

      FUNCTION SIXDID(XZ)
c******************************************************************
c
c   Matrix element squared e+ e- -> 2e+ 2e-
c   Identical paricle effects included (Kuraev, Shiller)
c   Two photon main and Bremsstrahlung diagrams
c
c******************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VEMOM/  T1,T2
      COMMON /VEFOUR/ P1(4),P2(4),P3(4),P5(4),P6(4),P7(4),P4(4)
      COMMON /VEDATA/ PI,ME,ME2,MU,MU2,E,S,EMP,CONST,DUMM(1)
      COMMON /VELABVAR/XXX(33),W2
      COMMON /VEQFOUR/Q1(4),Q2(4),Q3(4),Q4(4),Q5(4),Q6(4),Q7(4),Q8(4),
     1              Q9(4),Q10(4),Q11(4),Q12(4),Q13(4)
      COMMON /VEONE/  ONE13,ONE25,ONE27,ONE16,ONE67,ONE37,ONE35,ONE65
      COMMON /VETWO/  T3341,T6321,T6781,T3791,T2565,T21067,T27,T25,
     1              T6127,T3147,T6185,T3195
      COMMON /VEZSUM/ Z11,Z22,Z33,Z44,Z1,Z2,Z3,Z4
      COMMON /VEDOTP/ P12,P13,P14,P15,P23,P24,P25,P34,PP35,P45,R1,R2,R3,
     +                R4
      COMMON /VEDOTM/ P1DQ,P2DQ,P3DQ,P5DQ,Q1DQ
      DIMENSION D(4)
      COMPLEX*16 ONE13(4,4),ONE25(4,4),ONE27(4,4),ONE16(4,4)
      COMPLEX*16 ONE67(4,4),ONE37(4,4),ONE35(4,4),ONE65(4,4)
      COMPLEX*16 T3341(4,4,4),T6321(4,4,4),T6781(4,4,4),T3791(4,4,4)
      COMPLEX*16 T2565(4,4,4),T21067(4,4,4),T27(4,4,4),T25(4,4,4)
      COMPLEX*16 T6127(4,4,4),T3147(4,4,4),T6185(4,4,4),T3195(4,4,4)
      COMPLEX*16 Z11(4,4,4),Z22(4,4,4),Z33(4,4,4),Z44(4,4,4),I,Z1,Z2,Z3,
     1           Z4
c
      DATA I/(0.0,1.0)/
      DATA D/1.,-1.,-1.,-1./
c
      IF(IDB.EQ.1) PRINT *,' SIXDID'
      SE=ME
      YZ=XZ         ! +
c
      CALL DETER4
c
      DO 10 K=1,4
        Q1(K)=P3(K)-P1(K)+P6(K)
        Q2(K)=P1(K)-P3(K)-P7(K)
        Q3(K)=P3(K)+P4(K)
        Q4(K)=P1(K)-P4(K)
        Q5(K)=P4(K)-P2(K)
        Q6(K)=-P4(K)-P5(K)
        Q7(K)=P3(K)+P5(K)+P6(K)
        Q8(K)=P1(K)-P3(K)-P5(K)
        Q9(K)=P1(K)-P5(K)-P6(K)
        Q10(K)=-P2(K)+P5(K)+P6(K)
        Q11(K)=-P3(K)-P5(K)-P7(K)
        Q12(K)=-P2(K)+P3(K)+P5(K)
        Q13(K)=-P2(K)+P3(K)+P7(K)
 10   CONTINUE
c
      CALL ONEG(ONE13,P3,P1,SE,SE,1,1)
c
      CALL ONEG(ONE16,P6,P1,SE,SE,1,1)
c
      CALL ONEG(ONE25,P2,P5,SE,SE,2,2)
c
      CALL ONEG(ONE27,P2,P7,SE,SE,2,2)
c
      CALL ONEG(ONE67,P6,P7,SE,SE,1,2)
c
      CALL ONEG(ONE37,P3,P7,SE,SE,1,2)
c
      CALL ONEG(ONE35,P3,P5,SE,SE,1,2)
c
      CALL ONEG(ONE65,P6,P5,SE,SE,1,2)
c
      CALL TWOGS(T3341,P3,P1,Q3,Q4,SE,SE,SE,1,1)
c
      CALL TWOGS(T6321,P6,P1,Q3,Q2,SE,SE,SE,1,1)
c
      CALL TWOGS(T6781,P6,P1,Q7,Q8,SE,SE,SE,1,1)
c
      CALL TWOGS(T3791,P3,P1,Q7,Q9,SE,SE,SE,1,1)
c
      CALL TWOGS(T2565,P2,P5,Q5,Q6,SE,SE,SE,2,2)
c
      CALL TWOGS(T21067,P2,P7,Q10,Q6,SE,SE,SE,2,2)
c
      CALL TWOGS(T27,P2,P7,Q12,Q11,SE,SE,SE,2,2)
c
      CALL TWOGS(T25,P2,P5,Q13,Q11,SE,SE,SE,2,2)
c
      CALL TWOGS(T6127,P6,P7,Q1,Q2,SE,SE,SE,1,2)
c
      CALL TWOGS(T3147,P3,P7,Q1,Q4,SE,SE,SE,1,2)
c
      CALL TWOGS(T6185,P6,P5,Q1,Q8,SE,SE,SE,1,2)
c
      CALL TWOGS(T3195,P3,P5,Q1,Q9,SE,SE,SE,1,2)
c
      P37=2.*ME2+(P34-P3DQ)
      P35=2.*(ME2+PP35)
      P65=2.*ME2+(P45+P5DQ)
      P16=2.*ME2-(P14+P1DQ)
      P27=2.*ME2-(P24-P2DQ)
c
      DO 1 J1=1,4
c
        DO J2=1,4
          ONE13(J1,J2)=ONE13(J1,J2)*(D(J1)/T1)
          ONE16(J1,J2)=ONE16(J1,J2)*(D(J1)/P16)
          ONE25(J1,J2)=ONE25(J1,J2)*(D(J1)/T2)
          ONE27(J1,J2)=ONE27(J1,J2)*(D(J1)/P27)
          ONE67(J1,J2)=ONE67(J1,J2)*(D(J1)/W2)
          ONE37(J1,J2)=ONE37(J1,J2)*(D(J1)/P37)
          ONE35(J1,J2)=ONE35(J1,J2)*(D(J1)/P35)
          ONE65(J1,J2)=ONE65(J1,J2)*(D(J1)/P65)
        END DO
c
 1    CONTINUE
c
      DO 2 J1=1,4
      DO 2 J2=1,4
      DO 2 J3=1,4
      Z1=0.
      Z2=0.
      Z3=0.
      Z4=0.
c
      DO J4=1,4
      Z1=Z1+ ONE13(J4,J1)*T6127(J4,J2,J3) - ONE16(J4,J1)*T3147(J4,J2,J3)
     1     + ONE67(J4,J3)*T3341(J4,J2,J1) - ONE37(J4,J3)*T6321(J4,J2,J1)
      Z2=Z2- ONE13(J4,J1)*T6185(J4,J2,J3) + ONE16(J4,J1)*T3195(J4,J2,J3)
     1     - ONE65(J4,J3)*T3791(J4,J2,J1) + ONE35(J4,J3)*T6781(J4,J2,J1)
      Z3=Z3+ ONE67(J4,J3)*T2565(J4,J2,J1)
     1     - ONE65(J4,J3)*T21067(J4,J2,J1)
      Z4=Z4+ ONE35(J4,J3)*T27(J4,J2,J1)
     1     - ONE37(J4,J3)*T25(J4,J2,J1)
      END DO
c
      Z11(J1,J2,J3)=Z1
      Z22(J1,J2,J3)=Z2
      Z33(J1,J2,J3)=Z3
      Z44(J1,J2,J3)=Z4
 2    CONTINUE
c
      Y=0.
c
      DO 4 J1=1,4
      DO 4 J2=1,4
      DO 4 J3=1,4
      Z1=0.
c
        DO J4=1,4
          Z1=Z1+ONE25(J4,J3)*Z11(J1,J4,J2)+ONE27(J4,J3)*Z22(J1,J4,J2)
     &       +ONE13(J4,J1)*Z33(J3,J4,J2)+ONE16(J4,J1)*Z44(J3,J4,J2)
        END DO
c
        DRE=Z1
        DIM=I*Z1
        Y=Y+DRE*DRE+DIM*DIM
 4    CONTINUE
c
      SIXDID=Y
      END

c

      FUNCTION TWODID(XZ)
c******************************************************************
c
c   Matrix element squared e+ e- -> 2e+ 2e-
c   Identical particle effects included (Schiller)
c   Two photon main diagrams
c
c******************************************************************
      IMPLICIT REAL*8(A-H,M,O-Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMMON /VEMOM/T1,T2
      COMMON /VEFOUR/ P1(4),P2(4),P3(4),P5(4),P6(4),P7(4),P4(4)
      COMMON /VEDATA/ PI,ME,ME2,MU,MU2,E,S,EMP,CONST,DUMM(1)
      COMMON /VELABVAR/XXX(33),W2
      COMMON /VEQFOUR/Q1(4),Q2(4),Q4(4),Q8(4),Q9(4),DUMM1(32)
      COMMON /VEONE/  ONE13,ONE25,ONE27,ONE16,DUMM2(128)
      COMMON /VETWO/  T6127,T3147,T6185,T3195,DUMM3(128,8)
      COMMON /VEZSUM/ Z11,Z22,Z33,Z44,Z1,Z2,Z3,Z4
      COMMON /VEDOTP/ P12,P13,P14,P15,P23,P24,P25,P34,PP35,P45,R1,R2,R3,
     +                R4
      COMMON /VEDOTM/ P1DQ,P2DQ,P3DQ,P5DQ,Q1DQ
      DIMENSION D(4)
      COMPLEX*16 ONE13(4,4),ONE25(4,4),ONE27(4,4),ONE16(4,4)
      COMPLEX*16 T6127(4,4,4),T3147(4,4,4),T6185(4,4,4),T3195(4,4,4)
      COMPLEX*16 Z11(4,4,4),Z22(4,4,4),Z33(4,4,4),Z44(4,4,4),I,Z1,Z2,Z3,
     1           Z4
      DATA I/(0.0,1.0)/
      DATA D/1.,-1.,-1.,-1./
c
      IF(IDB.EQ.1) PRINT *,' TWODID'
      SE=ME
      YZ=XZ         ! +
c
      CALL DETER4
c
      DO K=1,4
        Q1(K)=P3(K)-P1(K)+P6(K)
        Q2(K)=P1(K)-P3(K)-P7(K)
        Q4(K)=P1(K)-P4(K)
        Q8(K)=P1(K)-P3(K)-P5(K)
        Q9(K)=P1(K)-P5(K)-P6(K)
      END DO
c
      CALL ONEG(ONE13,P3,P1,SE,SE,1,1)
c
      CALL ONEG(ONE25,P2,P5,SE,SE,2,2)
c
      CALL ONEG(ONE27,P2,P7,SE,SE,2,2)
c
      CALL ONEG(ONE16,P6,P1,SE,SE,1,1)
c
      CALL TWOGS(T6127,P6,P7,Q1,Q2,SE,SE,SE,1,2)
c
      CALL TWOGS(T3147,P3,P7,Q1,Q4,SE,SE,SE,1,2)
c
      CALL TWOGS(T6185,P6,P5,Q1,Q8,SE,SE,SE,1,2)
c
      CALL TWOGS(T3195,P3,P5,Q1,Q9,SE,SE,SE,1,2)
c
      P16=2.*ME2-(P14+P1DQ)
      P27=2.*ME2-(P24-P2DQ)
c
      DO 1 J1=1,4
      DO 1 J2=1,4
        ONE13(J1,J2)=ONE13(J1,J2)*(D(J1)/T1)
        ONE25(J1,J2)=ONE25(J1,J2)*(D(J1)/T2)
        ONE27(J1,J2)=ONE27(J1,J2)*(D(J1)/P27)
        ONE16(J1,J2)=ONE16(J1,J2)*(D(J1)/P16)
 1    CONTINUE
c
      DO 2 J1=1,4
      DO 2 J2=1,4
      DO 2 J3=1,4
      Z1=0.
      Z2=0.
c
      DO J4=1,4
        Z1=Z1+ ONE13(J4,J1)*T6127(J4,J2,J3)-ONE16(J4,J1)*T3147(J4,J2,J3)
        Z2=Z2- ONE13(J4,J1)*T6185(J4,J2,J3)+ONE16(J4,J1)*T3195(J4,J2,J3)
      END DO
c
      Z11(J1,J2,J3)=Z1
      Z22(J1,J2,J3)=Z2
 2    CONTINUE
c
      Y=0.
c
      DO 4 J1=1,4
      DO 4 J2=1,4
      DO 4 J3=1,4
        Z1=0.
c
        DO J4=1,4
          Z1=Z1+ONE25(J4,J3)*Z11(J1,J4,J2)+ONE27(J4,J3)*Z22(J1,J4,J2)
        END DO
c
        DRE=Z1
        DIM=I*Z1
        Y=Y+DRE*DRE+DIM*DIM
 4    CONTINUE
c
      TWODID=Y
      RETURN
      END

c

      SUBROUTINE TWOGS(TWO,P1,P2,Q1,Q2,M1,M2,M3,J1,J2)
c******************************************************************
c
c***  TWO(K1,K2,K3)  K1,K2 LORENTZ INDICES,  K3 SPIN PROJECTION INDEX
c***        \                 /       +        \                 /
c***         \ (Q1/+M3)/PROP1/       +++        \ (Q2/+M3)/PROP2/
c***  UB(P2)  \             / U(P1)   +  UB(P2)  \             / U(P1)
c***  --->-----*----->-----*----->--     --->-----*----->-----*----->--
c***
c
c******************************************************************
      IMPLICIT REAL*8 (A-H,M,O-Y)
      IMPLICIT COMPLEX *16 (Z)
      COMMON /VECO  / IG,IDB,IDUM(1638)
      COMPLEX *16 TWO(4,4,4),U1(4,2),U2(4,2),QPMP,QPMM,QMPP,QMPM
      COMPLEX *16 I,         QP1,QP2,QM1,QM2,QPPP,QPPM,QMMP,QMMM
      DIMENSION P1(4),P2(4),Q1(4),Q2(4),Z(4,4)
c
      DATA I/(0.0,1.0)/
c
      IF(IDB.EQ.1) PRINT *,' TWOGS'
      PROP1=Q1(1)*Q1(1)-Q1(2)*Q1(2)-Q1(3)*Q1(3)-Q1(4)*Q1(4)-M3*M3
      PROP2=Q2(1)*Q2(1)-Q2(2)*Q2(2)-Q2(3)*Q2(3)-Q2(4)*Q2(4)-M3*M3
      EPM1=(Q1(1)+M3)/PROP1
      EPM2=(Q2(1)+M3)/PROP2
      EMM1=(Q1(1)-M3)/PROP1
      EMM2=(Q2(1)-M3)/PROP2
      QZ1=Q1(4)/PROP1
      QZ2=Q2(4)/PROP2
      QM1=Q1(2)/PROP1 - I*(Q1(3)/PROP1)
      QM2=Q2(2)/PROP2 - I*(Q2(3)/PROP2)
      QP1=Q1(2)/PROP1 + I*(Q1(3)/PROP1)
      QP2=Q2(2)/PROP2 + I*(Q2(3)/PROP2)
      EPPP=EPM1+EPM2
      EPPM=EPM1-EPM2
      EMMP=EMM1+EMM2
      EMMM=EMM1-EMM2
      EPMP=EPM1+EMM2
      EMPP=EMM1+EPM2
      QZP=QZ1+QZ2
      QZM=QZ1-QZ2
      QPPP=QP1+QP2
      QPPM=QP1-QP2
      QMMP=QM1+QM2
      QMMM=QM1-QM2
      QPMP=QP1+QM2
      QPMM=QP1-QM2
      QMPP=QM1+QP2
      QMPM=QM1-QP2
      IF(J1.EQ.1) GO TO 1
c
      CALL VBSPIN(P1,M1,U1)
c
      GO TO 2
c
   1  CALL UBSPIN(P1,M1,U1)
c
   2  IF(J2.EQ.1) GO TO 3
c
      CALL VSPIN(P2,M2,U2)
c
      GO TO 4
c
   3  CALL USPIN(P2,M2,U2)
c
   4  CONTINUE
c
      DO 5 J3=1,2
      DO 5 J4=1,2
      J5= J3 + 2*J4 - 2
c
      DO 6 J6=1,4
      DO 6 J7=1,4
   6  Z(J6,J7)=U1(J6,J3)*U2(J7,J4)
c
      ZM4123=Z(4,1)-Z(2,3)
      ZM4422=Z(4,4)-Z(2,2)
      ZM4321=Z(4,3)-Z(2,1)
      ZM3311=Z(3,3)-Z(1,1)
      ZM3214=Z(3,2)-Z(1,4)
      ZM3113=Z(3,1)-Z(1,3)
      ZM2442=Z(2,4)-Z(4,2)
      ZM1234=Z(1,2)-Z(3,4)
      ZM2314=Z(2,3)-Z(1,4)
      ZM3241=Z(3,2)-Z(4,1)
      ZM1324=Z(1,3)-Z(2,4)
      ZM4231=Z(4,2)-Z(3,1)
      ZM4433=Z(4,4)-Z(3,3)
      ZM1122=Z(1,1)-Z(2,2)
      ZM3443=Z(3,4)-Z(4,3)
      ZM2112=Z(2,1)-Z(1,2)
      ZP1122=Z(1,1)+Z(2,2)
      ZP3344=Z(3,3)+Z(4,4)
      ZP1423=Z(1,4)+Z(2,3)
      ZP4132=Z(4,1)+Z(3,2)
      ZP1221=Z(1,2)+Z(2,1)
      ZP3443=Z(3,4)+Z(4,3)
      TWO(1,1,J5)= EPPP*ZP1122 - EMMP*ZP3344
     1 - QZP*(ZM3113+ZM2442) - QPPP*ZM4123 - QMMP*ZM3214
      TWO(1,2,J5)= EPMP*ZP1423 - EMPP*ZP4132
     1 + QZM*(ZM4321+ZM1234) - QPMP*ZM4422 - QMPP*ZM3311
      TWO(1,3,J5)=I*( EPMP*ZM2314 + EMPP*ZM3241
     1 - QZM*(ZM1234-ZM4321) + QPMM*ZM4422 - QMPM*ZM3311)
      TWO(1,4,J5)= EPMP*ZM1324 + EMPP*ZM4231
     1 - QZP*(ZM4422+ZM3311) - QPPM*ZM4321 - QMMM*ZM1234
C***
      TWO(2,1,J5)= EMPP*ZP1423 - EPMP*ZP4132
     1 - QZM*(ZM4321+ZM1234) - QMPP*ZM4422 - QPMP*ZM3311
      TWO(2,2,J5)= EMMP*ZP1122 - EPPP*ZP3344
     1 + QZP*(ZM3113+ZM2442) - QPPP*ZM3214 - QMMP*ZM4123
      TWO(2,3,J5)=I*( EPPM*ZM4433 + EMMM*ZM1122
     1 + QZM*(ZM3113-ZM2442) + QPPP*ZM3214 - QMMP*ZM4123)
      TWO(2,4,J5)= EPPM*ZM3443 + EMMM*ZM2112
     1 - QZP*(ZP4132-ZP1423) - QPMP*ZM3113 - QMPP*ZM2442
C***
      TWO(3,1,J5)=I*( EMPP*ZM2314 + EPMP*ZM3241
     1 + QZM*(ZM1234-ZM4321) - QMPM*ZM4422 + QPMM*ZM3311)
      TWO(3,2,J5)=I*(-EPPM*ZM4433 - EMMM*ZM1122
     1 - QZM*(ZM3113-ZM2442) + QPPP*ZM3214 - QMMP*ZM4123)
      TWO(3,3,J5)= EMMP*ZP1122 - EPPP*ZP3344
     1+QZP*(ZM3113+ZM2442)+QPPP*ZM3214+QMMP*ZM4123
      TWO(3,4,J5)=I*( EMMM*ZP1221 - EPPM*ZP3443
     1 + QZP*(ZM3214-ZM4123) + QPMM*ZM3113 - QMPM*ZM2442)
C***
      TWO(4,1,J5)= EMPP*ZM1324 + EPMP*ZM4231
     1 - QZP*(ZM4422+ZM3311) + QPPM*ZM4321 + QMMM*ZM1234
      TWO(4,2,J5)=-EPPM*ZM3443 - EMMM*ZM2112
     1 - QZP*(ZP4132-ZP1423) - QMPP*ZM3113 - QPMP*ZM2442
      TWO(4,3,J5)=I*(-EMMM*ZP1221 + EPPM*ZP3443
     1 + QZP*(ZM3214-ZM4123) - QMPM*ZM3113 + QPMM*ZM2442)
      TWO(4,4,J5)= EMMP*ZP1122 - EPPP*ZP3344
     1 - QZP*(ZM3113+ZM2442) + QPPP*ZM4123 + QMMP*ZM3214
   5  CONTINUE
      RETURN
      END

