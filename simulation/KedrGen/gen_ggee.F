      SUBROUTINE GEN_GGEE(EB0,IREQAC,WEID,WMIN0,WMAX0,THMIN0,THMAX0,FM0)
c*********************************************************************
c                                                                    *
c   e+e- -> e+e-e+e- (Berends et al.)                                * 
c                                                                    *
c   Input parameters:                                                *
c                                                                    *
c   EB0    - Beam energy (GeV)                                       *
c   IREQAC - 0 - only event generation,                              *
c          > 0 - + cross section calculation before event generation,*
c            IREQAC = number of unweighted events for cross-section  * 
c            estimation                                              *
c   WEID(4)- weights (from 0 to 1) of 4 types of diagrams            *
c   WMIN0  - min inv.mass of any e+e- pair                           *
c   WMAX0  - max inv.mass of any e+e- pair                           *
c   THMIN0 - min angle of secondary particle in central detector     *
c   THMIN0 - max angle of secondary particle in central detector     *
c   FM0    - estimated maximum weight                                *
c                                                                    *
c   Generated event in /GGPRT/. RNG = RNF100 from gen_ggmmg.f (=RLU) *
c                                                                    *
c   Corrections:                                                     *
c                                                                    *
c   11.11.2005: deleted: /CENINI/                                    *
c                added: MCB, MCC, MCD                                *
c                modified /SAP/, DOT->DOTGG, names of COMMON-blocks  *
c   03.11.2008: corrected writing of energy of particles in /GGHPRT/ *
c                                                                    *
c*********************************************************************
      IMPLICIT REAL *8 (A-H,O-Z)
      COMMON /GG_EEANGLE/   THPMIN,THPMAX,THMMIN,THMMAX,THMUMI,THMUMA
      COMMON /GG_EEBOUND/   W2MIN,W2MAX
      COMMON /GG_EECHARGE/  QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /GG_EECONST/   ALFA,BARN,PI,TWOPI
      COMMON /GG_EEEDGE/    WDMIN,WDMAX,SDMIN,SDMAX
      COMMON /GG_EEFACTOR/  FACE,FACL,FACM,PROC
      COMMON /GG_EEFTSTAT/  SUMFT,SUMFT2,FTMAX,IEEN
      COMMON /GG_EEINIT/    PB,ET,EP(3),ECH(3)
      COMMON /GG_EEINPUT/   EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EELOG1/    OUTFL(4)
      COMMON /GG_EEMASSES/  XM,XMU,XML,XM2,XMU2,XML2
      COMMON /GG_EEMOMENZ/  Q1,Q2,Q3,Q4,Q5,Q6
      COMMON /GG_EESELECT/  IC,ICH
      COMMON /GG_EEVECTOR/  P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /GG_EEWESTAT/  SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),
     &                      IGEN
      COMMON /GG_EEWECOUN/  IFAIL(4),IACC(4),INUL(4),ICHG(4),IUNDFL(4),
     &                      INEG,IONE,IZERO
      COMMON /GG_EEWEIGHT/  WEIGHT(4),WEEV,IEVACC
      COMMON /GGHPRT/       NUMBPART1,PPARTE(4,20),IPARTIC1(20)
      DIMENSION Q1(5),Q2(5),Q3(5),Q4(5),Q5(5),Q6(5)
      DIMENSION IDUMP(4)
      REAL *4 EB0,WMIN0,WMAX0,THMIN0,THMAX0,FM0,PPARTE,WEID(4)
      REAL *8 MWE,MAXWE
      LOGICAL OUTFL
      SAVE ICALL,IDIA,IFINIS
c
      DATA IDIA   /0/
      DATA ICALL  /0/
      DATA IFINIS /0/
c
c-------------------------------------------------------------
c
      ICALL=ICALL+1
      IF(ICALL.EQ.1) print 1052  ! cross section calculation + generation
c
c=============================================================
c
c             Initial data
c
      IPROC = 5    ! Selected process e+e- -> e+e- + e+e-
      IREJEC = 1   ! Set IREJEC (=1/2) (for strong cuts use IREJECT=1)
      EB   = EB0   ! Beam energy (in GeV)
      Wmin=WMIN0   ! min inv. mass (will be changed to possible, if lower)
      Wmax=WMAX0   ! max inv. mass (will be changed to possible, if larger)
      XM   = 0.000510999D0/EB! Beam particles (electron mass).
      XMU    = 0.1057D0/EB ! Produced particles (muon) (will be changed)
      XML    = 1.784D0/EB  ! Scatered or produced particles (tau) (... also)
      THMUMI = THMIN0      ! Min cut on particle angle (in centarl detector)
      THMUMA = THMAX0      ! Max cut on particle angle (in centarl detector)
c
       ESWE   = FM0        ! estimated maximum weight for generator - from data
       ESFT   = FM0        !
c
c                     ! Minimum and maximum angle of scattered positron.
      THPMIN = 0.D0   ! In case IPROC=2 or 5 these parameters must be equal to
      THPMAX = 180.D0 ! respectively 0 and 180 degrees
c                     ! (due to symmetrization procedure).
c
c                     ! Minimum and maximum angle scattered electron.
      THMMIN = 0.D0   ! In case IPROC=2 or 5 these parameters must be equal to
      THMMAX = 180.D0 ! respectively 0 and 180 degrees
c                     ! (due to symmetrization procedure).
c
c      THMUMI = 0D0   ! Cuts on muon angles (in centarl detector)
c      THMUMA = 180.D0! were taken from data, see before
c
c...Number of weighted events to be generated...............
      ITOT   = 1000000000 !(very big, 10^9, since program used as genrator)
c
c...Relative importance of subgenerators A,B,C and D........
      WAP(1) = WEID(1)   ! should be 0-1  ( from data)
      WAP(2) = WEID(2)  
      WAP(3) = WEID(3) 
      WAP(4) = WEID(4) 
c
      WBP(1) = 1.D0
      WBP(2) = 1.D+02
      WBP(3) = 1.D+05
      WBP(4) = 1.D+05
c
      FACE   = 1.D+03
      FACL   = 1.D+03
      FACM   = 1.D+03
      PROC   = 1.D+09
c
c  Total cross section 
c
      VAP(1) = 1.D0
      VAP(2) = 1.D0
      VAP(3) = 0.5D0
      VAP(4) = 0.5D0
c
      XML    = XM        ! => XM of electron
      XMU    = XM        ! prodused particles have electron mass 
c 
c  Correction the boundries, if necessary
c
      W2MIN0  = 4.D0*XMU*XMU               ! this is a minimum for electrons
      W2min  = (Wmin/EB)**2                ! this is a cut from data
      if(W2min.lt.W2min0) W2min=W2min0
      W2MAX0  = 4.D0*(1.D0-XML)*(1.D0-XML) ! without cuts
      W2max  = (Wmax/EB)**2
      if(W2max.gt.W2max0) W2max=W2max0
c
      QCHARG = 1.D0                        ! QCHARG may not be changed
c
 1006 XM2    = XM*XM
      XMU2   = XMU*XMU
      XML2   = XML*XML
      QCHRG2 = QCHARG*QCHARG
      QCHRG3 = QCHARG*QCHRG2
      QCHRG4 = QCHRG2*QCHRG2
c
      IF(ICALL.EQ.1) CALL START
c
      IF (IREJEC.EQ.2) X = 1.D0
c
c----- Start event loop ----------------------------------------
c
      DO 10 I = 1,ITOT  ! Itot - number of weighted events 
c
        IS     = 1
        ETA0   = RNF100(12)
        IF (ETA0.LT.EP(2)) IS = -1      ! selection of subgenerators
        IF (ETA0.LT.EP(2+IS)) GOTO 1    ! according to approx. cross sections
        IC     = 3 + IS
        GOTO 2
 1      IC     = 2 + IS
 2      CONTINUE
c
        IDUMP(IC) = 0                   ! option for dump
c
        GOTO (3,4,5,6),IC
c
 3      CALL MCA(IPROC,IDUMP(1))
c
        GOTO 7
c
 4      CALL MCB(IPROC,IDUMP(2))
c
        GOTO 7
c
 5      CALL MCC(IPROC,IDUMP(3))
c
        GOTO 7
c
 6      CALL MCD(IPROC,IDUMP(4))
c
 7      CONTINUE
c
        IF(OUTFL(IC)) GOTO 800
c
        PMV       = DSQRT(PM(1)*PM(1)+PM(2)*PM(2)+PM(3)*PM(3))
        PPV       = DSQRT(PP(1)*PP(1)+PP(2)*PP(2)+PP(3)*PP(3))
        QMV       = DSQRT(QM(1)*QM(1)+QM(2)*QM(2)+QM(3)*QM(3))
        QPV       = DSQRT(QP(1)*QP(1)+QP(2)*QP(2)+QP(3)*QP(3))
        CSPM      =  PM(3)/PMV
        CSPP      =  PP(3)/PPV
        CSQM      =  QM(3)/QMV
        CSQP      = -QP(3)/QPV
        THQM      = DACOS(CSQM)/PI*180.D0
        THQP      = DACOS(CSQP)/PI*180.D0
        THPM      = DACOS(CSPM)/PI*180.D0
        THPP      = DACOS(CSPP)/PI*180.D0
c
        IF(THPM.LT.THMUMI.OR.THPM.GT.THMUMA.OR.
     &     THPP.LT.THMUMI.OR.THPP.GT.THMUMA) GOTO 800
        IF(THQM.LT.THMMIN.OR.THQM.GT.THMMAX.OR.
     &     THQP.LT.THPMIN.OR.THQP.GT.THPMAX) GOTO 800
c
        W2MU      = 2.D0*DOTGG(PM,PP)+2.D0*XMU2
        W2MU2     = 2.D0*DOTGG(QM,QP)+2.D0*XMU2
        W2MU3     = 2.D0*DOTGG(QM,PP)+2.D0*XMU2
        W2MU4     = 2.D0*DOTGG(QP,PM)+2.D0*XMU2
c
        IF(W2MU.LT.W2MIN.OR.W2MU.GT.W2MAX) GOTO 800
        IF(IPROC.NE.5.AND.IPROC.NE.2) GOTO 801
        IF(W2MU2.LT.W2MIN.OR.W2MU2.GT.W2MAX) GOTO 800
        IF(W2MU3.LT.W2MIN.OR.W2MU3.GT.W2MAX) GOTO 800
        IF(W2MU4.LT.W2MIN.OR.W2MU4.GT.W2MAX) GOTO 800
c
        GOTO 801
c
 800    WEIGHT(IC) = 0.D0
        WEEV       = 0.D0
        FT         = 0.D0
        INUL(IC)   = INUL(IC) + 1
        IZERO      = IZERO    + 1
c
 801    IEVACC    = 0
        IWE(IC)   = IWE(IC)  + 1
        IGEN      = IGEN     + 1
        IF(WEIGHT(IC).LE.0.D0.OR.WEIGHT(IC).GT.1.D-30) GOTO 17
        WEIGHT(IC) = 0.D0
        WEEV       = 0.D0
        FT         = 0.D0
c
 17     SWE(IC)   = SWE(IC)  + WEIGHT(IC)
        SUM       = SUM      + WEEV
        SWEK(IC)  = SWEK(IC) + WEIGHT(IC)*WEIGHT(IC)
        SUMK      = SUMK     + WEEV*WEEV
        IF (MWE(IC).LT.WEIGHT(IC)) MWE(IC) = WEIGHT(IC)
        IF (MAXWE.LT.WEEV) MAXWE = WEEV
c
c--- Production of events with weight 1 ------------------------
c
        GOTO (25,26), IREJEC
c
 26     ETA1   = RNF100(11)
        IF (ETA1*ESWE.GT.WEIGHT(IC)) GOTO 8
        GOTO 27
c
 25     X = WEEV
c
 27     IEVACC    = 1
        IACC(IC)  = IACC(IC) + 1
        IONE      = IONE     + 1
c
 8      IF (IEVACC.EQ.0) GOTO 10
        IF (X.EQ.0.D0) GOTO 28
c
        IDIA  = IDIA + 1
        Q1(5) = -XM
        Q2(5) =  XM
        Q3(5) = -XML
        Q4(5) =  XML
        Q5(5) = -XMU
        Q6(5) =  XMU
c
        DO IV=1,4
          Q1(IV) = P2(IV)
          Q2(IV) = P1(IV)
          Q3(IV) = QP(IV)
          Q4(IV) = QM(IV)
          Q5(IV) = PP(IV)
          Q6(IV) = PM(IV)
        END DO
c
        INFO  = -1
c       IF (IDIA.EQ.1) INFO = 1
c
        FT    = DIAM(IPROC,INFO)
        FT    = X*FT
 28     CONTINUE
c
        SUMFT = SUMFT  + FT
        SUMFT2= SUMFT2 + FT*FT
        IF (FTMAX.LT.FT) FTMAX = FT
c
c  Rejection algorithm which produces unweighted events
c-------------------------------------------------------
        ETA2  = RNF100(2)
        IF (ETA2*ESFT.GT.FT) GOTO 10 ! to new trial
        IEEN  = IEEN + 1             ! counter of unweighted events
c
c  Produced e+, e- are stored in /GGPRT/ NUMBPART1,PPARTE(4,20),IPARTIC1(20)
c
c        NUMBPART1       - number of particles in event
c        PPARTE(1-3,I)   - momentum of I-th particle, GeV/c
c        PPARTE(4,I)     - its energy, GeV
c        IPARTIC1(I)     - Geant type of I-th particle
c
        NUMBPART1=4
c
        DO I1=1,4
          PPARTE(I1,1)=QM(I1)*EB0  ! scattered particle mom., ener. in GeV 
          PPARTE(I1,2)=QP(I1)*EB0  !     - || -
          PPARTE(I1,3)=PM(I1)*EB0  ! produced particle
          PPARTE(I1,4)=PP(I1)*EB0  !     - || -
        END DO
c
        IPARTIC1(1)=3              ! e-
        IPARTIC1(2)=2              ! e+
        IPARTIC1(3)=3              ! e-
        IPARTIC1(4)=2              ! e+
c
        IF(IREQAC.EQ.0.OR.IFINIS.EQ.1) GOTO 9  ! since program is generator
                                               ! IREQAC - events for cr.sec.
c
        IF(IEEN.EQ.IREQAC) THEN
c
          CALL FINIS3(IPROC,IREJEC)
c
          IFINIS=1
          GOTO 9
        END IF
c
 10   CONTINUE   ! end of cycle on weighted events
c
c--------------- Results ----------------------------------------
c
 9    CONTINUE
c
 30   FORMAT(F10.3,2I10)
 31   FORMAT(4F10.3,I10)
 1052 FORMAT(/,70(1H*)//
     1       ' Monte Carlo simulation of the process: ',
     2       'e+ e- -> e+ e- e+ e-',//,
     3       ' Generator of F.Berends e.a.',
     4        //,70(1H*))
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE MCA(IPROC,IDUMP)
c***********************************************************************
c
c... Multiperipheral subgenerat
c
c... COMMON /MATRIX / containes:
c            XME(1) = exact multiperipheral |MATRIX ELEMENT|^2
c... COMMON /DIAG   / containes:
c            calculated photon propagators and invariant mass^2 muons.
c            These values are used in function DIAG2.
c
c***********************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEBOUND/  W2MIN,W2MAX
      COMMON /GG_EECHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /GG_EECONST/  ALFA,BARN,PI,TWOPI
      COMMON /GG_EECOUNTA/ IREGA1,IREGA2
      COMMON /GG_EEDIAG/   U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /GG_EEGENA/   XLA1,XLA2,XLA3,XLA4(2),SAPA(2)
      COMMON /GG_EEINIT/   PB,ET,EP(3),ECH(3)
      COMMON /GG_EEINPUT/  EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EELOG1/   OUTFL(4)
      COMMON /GG_EEMASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /GG_EEMATRIX/ XME(4)
      COMMON /GG_EEPROSTA/ PROP1,PROP2,PROP3,PROP4
      COMMON /GG_EESAP/    SAP(4),SAPT,CROSEC         ! +
      COMMON /GG_EESELECT/ IC,ICH
      COMMON /GG_EEVECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /GG_EEVECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /GG_EEWECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),IUNDFL(4),
     &                     INEG,IONE,IZERO
      COMMON /GG_EEWEIGHT/ WEIGHT(4),WEEV,IEVACC
      COMMON /GG_EEWESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),
     &                     IGEN
      REAL*8 MWE,MAXWE
      LOGICAL OUTFL
c
c-----------------------------------------------------------------
c
      OUTFL(1) = .FALSE.
      IY =  1
      ETA0=RNF100(IDUM)
      IF (ETA0.LT.SAPA(2)/SAP(1)) IY = -1
      IYY = (-IY+1)/2 + 1
      IF (IYY.EQ.1) IREGA1 = IREGA1 + 1
      IF (IYY.EQ.2) IREGA2 = IREGA2 + 1
c
c----------------W2 generation-------------------------------------
c
      ETA1=RNF100(1)
      IF (IDUMP.EQ.5) print 20
      W2 = W2MAX*W2MIN/(W2MAX*(1.D0-ETA1)+W2MIN*ETA1)
      W  = DSQRT(W2)
c
c-------------Generation electrons energy--------------------------
c
      HYMAX = (1.D0-XM/2.D0)*(1.D0-XM/2.D0)
      IF (IY.EQ.-1) HYMAX = (2.D0*XM-XM2+W2-0.5D0*XM*XM2)/
     .                      (4.D0-2.D0*XM)
      IF (IDUMP.EQ.5) print 21, HYMAX
      HYMIN = (W+XM)*(W+XM)/4.D0
      IF (HYMIN.GT.HYMAX) print 102, HYMIN,HYMAX,W2
      ETA2  = RNF100(2)
      HY    = (HYMIN/HYMAX)**ETA2*HYMAX
      Y     = 1.D0 - HY + XM2/4.D0
      YE    = HY - XM2/4.D0
      IF (IDUMP.EQ.5) print 22, Y,YE
      YY    = DSQRT(Y*Y - XM2)
      ETM   = Y+YY
      YYYM  = XM2/ETM
      DELM  = 0.5D0/(PB*YY*ET*ETM)*XM2*(ETM-ET)*(ETM-ET)
      IF (IDUMP.EQ.5) print 23, DELM
c
c------------Generation of scattering angle electron---------------
c
      ETA3  = RNF100(3)
      HVM = (2.D0*HY*(2.D0+DELM)/(DELM*
     .      (2.D0*HY+2.D0*Y)))**ETA3*(2.D0*HY+2.D0*Y)/
     .      (2.D0+DELM)
      VM  = (2.D0*HY-HVM*DELM)/(HVM-Y)
      IF (IDUMP.EQ.5) print 24, VM
      CTM = 1.D0-VM
      STM = DSQRT(VM*(2.D0-VM))
      THM = DACOS(CTM)*180.D0/PI
      HM  = Y*VM
      DE2A=XM2/2.D0*((2.D0*HM+W2-XM2+2.D0*YYYM*CTM)/(4.D0*HY-W2))**2
      IF (IDUMP.EQ.5) print 25, DE2A
c
C------------GENERATION OF THE FEYNMAN PARAMETER Z-----------------
c
      DELTA=2.D0*DSQRT((2.D0*HY+HM-DE2A*Y)**2+(4.D0+XM2)*DE2A*HM)
      AA=-2.D0*HM-2.D0*YE*DE2A+DE2A*DE2A+XM2*YE+XM2*XM2/4.D0-XM2*DE2A
      BB=4.D0*HY+2.D0*HM-2.D0*Y*DE2A-2.D0*DE2A*DE2A+XM2*DE2A
      CC=2.D0*DE2A+DE2A*DE2A
      IF (IDUMP.EQ.5) print 26, AA,BB,CC
      IF (BB.GT.0.D0) GOTO 1
      Z1 = (-BB+DELTA)/2.D0/AA
      GOTO 11
    1 CONTINUE
      Z1 = (-BB-DELTA)/2.D0/AA
   11 CONTINUE
      Z0 = CC/(AA*Z1)
      HZ = (Z1-Z1*Z0)/(Z0*(1.D0-Z1))
      IF (IDUMP.EQ.5) print 27, Z1,Z0,HZ
      ETA4= RNF100(4)
      HHZ = -1.D0*DABS(Z0/Z1)*HZ**ETA4*DSIGN(1.D0,AA)
      Z=(Z0+HHZ*Z1)/(1.D0+HHZ)
      IF (IDUMP.EQ.5) print 28, HHZ,Z
c
C-----------------GENERATION OF AZIMUTHAL ANGLE---------------------
c
      ETA5 = RNF100(5)
      PHIR = TWOPI*ETA5
      CPG  = DCOS(PHIR)
      SPG  = DSIN(PHIR)
c
C-----------------GENERATION OF CT'---------------------------------
c
      EZ0  = (1.D0-Z)*(1.D0+DE2A)+2.D0*Z-Y*Z+0.5D0*XM2*Z
      EZ2  = (AA*Z+BB)*Z+CC
      IF (IDUMP.EQ.5) print 29, EZ0,EZ2
      EZ   = DSQRT(EZ0*EZ0-EZ2)
      IF (IDUMP.EQ.5) print 29, EZ0,EZ2,EZ
      ETA6 = RNF100(6)
      CTG1 = 2.D0*(1.D0-ETA6)*EZ2/(EZ2+2.D0*ETA6*EZ*(EZ0+EZ))
      CTG  = 1.D0-CTG1
      STG  =DSQRT(CTG1*(2.D0-CTG1))
      IF (IDUMP.EQ.5) print 30, CTG1,CTG,STG
c
C---------------GENERATION OF SCATTERING ANGLE POSITRON--------------
c
      SEZ  = Z*Y*STM/EZ
      CEZ1 = Z*Z*Y*Y*STM*STM/(EZ*(EZ+1.D0-Z+Z*Y*CTM))
      CEZ  = 1.D0-CEZ1
      IF (IDUMP.EQ.5) print 31, SEZ,CEZ1,CEZ
c      IF (CEZ1.GE.0.D0.AND.CEZ1.LT.1.D-50.AND.
      IF (CEZ1.GE.0.D0.AND.CEZ1.LT.1.D-38.AND.
     .    CTG1.GE.0.D0.AND.CTG1.LT.1.D-20) GOTO 550
      CPROD = CEZ1*CTG1
      GOTO 551
  550 CONTINUE
      IUNDFL(1) = IUNDFL(1) + 1
      CPROD = 0.D0
  551 CONTINUE
      VP   = SEZ*STG*CPG+CEZ1+CTG1-CPROD
      CTP  = 1.D0-VP
      STP  = DSQRT(VP*(2.D0-VP))
      IF (IDUMP.EQ.5) print 32, VP,CTP,STP
      THP  = DACOS(CTP)*180.D0/PI
      CP   = (CEZ*STG*CPG+SEZ*CTG)/STP
      SP   = STG*SPG/STP
c
C----CALCULATION COS ANISOTROPY ANGLE--------------------------------
c
      YH   = 4.D0*YE+XM2+XM2-W2
      CAS = (4.D0*(2.D0-Y)*(2.D0-Y)*XM2-YH*YH)/(4.D0*YY*YY*XM2)
      IF (IDUMP.EQ.5) print 33, YH,CAS
      CA  = 1.D0
      IF (CAS.GT.0.D0) CA = -DSQRT(CAS)
c
C----CALCULATION ZM = COS ANGLE BETWEEN ELECTRON AND POSITRON--------
c
      ZMP  = VM+VP-VM*VP-STM*STP*CP
      ZM   = ZMP-1.D0
      IF (IDUMP.EQ.5) print 34, ZMP,ZM
      IF (ZM.GT.CA) GOTO 200
      DISC = DSQRT(YH*YH-4.D0*XM2*(4.D0*YE+XM2+YY*YY*ZMP*(1.D0-ZM)))
      IF (IDUMP.EQ.5) print 35, DISC
c
C----CALCULATION ENERGY POSITRON-------------------------------------
c
      IF (IY.EQ.-1) GOTO 103
      X    = ((2.D0-Y)*YH-YY*ZM*DISC)/
     .       (2.D0*(4.D0*YE+XM2+YY*YY*ZMP*(1.D0-ZM)))
      IF (IDUMP.EQ.5) print 36, X
      GOTO 104
  103 CONTINUE
      IF (ZM.GT.0.D0) print 110, ZM
      X    = 0.5D0*(YH*YH+4.D0*YY*YY*XM2*ZM*ZM)/
     .       ((2.D0-Y)*YH-YY*ZM*DISC)
      IF (IDUMP.EQ.5) print 37, X
  104 CONTINUE
      IF (X.LT.XM) print 105, X,DISC,Y,YE,YY,YH,ZM
      IF (X.GT.1.D0+XM2/4.D0-(W+XM)*(W+XM)/4.D0) print 106,
     .       X,DISC,Y,YE,YY,YH,ZM
      XX  = DSQRT(X*X-XM2)
      XE  = 1.D0 - X
      ETP  = X+XX
      DELP = 0.5D0/(PB*XX*ET*ETP)*XM2*(ETP-ET)*(ETP-ET)
      IF (IDUMP.EQ.5) print 38, X,XE,DELP
c
C----------DETERMINATION VIRTUAL PHOTON MASSES-----------------------
c
      TM   = -2.D0*PB*YY*(VM+DELM)
      TP   = -2.D0*PB*XX*(VP+DELP)
c
C----------GENERATION TRIVIAL AZIMUTHAL ANGLE------------------------
c
      ETA7 = RNF100(7)
      PHIP = TWOPI*ETA7
      CPP  = DCOS(PHIP)
      SPP  = DSIN(PHIP)
      CPM  = -CP*CPP-SP*SPP
      SPM  =  SP*CPP-CP*SPP
c
C---------CONSTRUCTION 4MOMENTA--------------------------------------
c
      QM(1) =  YY*STM*CPM
      QM(2) =  YY*STM*SPM
      QM(3) =  YY*CTM
      QM(4) =   Y
      QP(1) =  XX*STP*CPP
      QP(2) =  XX*STP*SPP
      QP(3) = -XX*CTP
      QP(4) =   X
c
C---------4MOMENTUM PRODUCED MUON PAIR--------------------------------
c
      HW   = ((XE-YE)*(XE+YE-2.D0)-XM2+XM2)/(XX+YY)
      IF (IDUMP.EQ.5) print 39, HW
      QWX  = -QM(1)-QP(1)
      QWY  = -QM(2)-QP(2)
      QWZ  = HW+VM*YY-VP*XX
      EW   = YE+XE
c
C----------CONSTRUCTION 4MOMENTUM OF VIRTUAL PHOTON-------------------
c
      QKMX  = -QM(1)
      QKMY  = -QM(2)
      QKMZ  = YE*(1.D0+Y)/(PB+YY)+YY*VM
      EQKM  = YE
c
C----------GENERATION MUON ANGLES-------------------------------------
C----------BOOST TO CM SYSTEM OF MUON PAIR----------------------------
c
      EKMCM   =  (W2+TM-TP)/(2.D0*W)
      IF (IDUMP.EQ.5) print 40, EKMCM
      FAC     = -(EKMCM+EQKM)/(EW+W)
      QKMXCM  =  QKMX + FAC*QWX
      QKMYCM  =  QKMY + FAC*QWY
      QKMZCM  =  QKMZ + FAC*QWZ
c
C---------GENERATION POLAR ANGLE OF MUON------------------------------
c
      ACT   = -0.5D0*(W2-TM-TP)
      HB    =  (1.D0-4.D0*XMU2/W2)*((W2-TM-TP)**2-4.D0*TM*TP)
      BCT   =  DSQRT(HB)/2.D0
      IF (IDUMP.EQ.5) print 41, ACT,HB,BCT
      ETA8  =  RNF100(8)
      ETA   =  2.D0*ETA8-1.D0
      APB   =  (XMU2*((W2-TM-TP)**2-4.D0*TM*TP)+TM*TP*W2)/
     .         ((ACT-BCT)*W2)
      IF (IDUMP.EQ.5) print 42, APB
      HCT   =  (APB/(ACT-BCT))**DABS(ETA)
      CTCME =  (APB+HCT*(BCT-ACT))/(BCT*(1.D0+HCT))
      CTCM  =  1.D0-CTCME
      IF (ETA.LT.0.D0) CTCM = -CTCM
      STCM  =  DSQRT(CTCME*(2.D0-CTCME))
      IF (IDUMP.EQ.5) print 43, HCT,CTCME,CTCM
c
C-----------GENERATION OF AZIMUTHAL ANGLE OF MUON----------------------
c
      ETA9  = RNF100(9)
      PHICM = TWOPI*ETA9
      CPCM  = DCOS(PHICM)
      SPCM  = DSIN(PHICM)
      EMCM  = 0.5D0*W
      PMCM  = DSQRT(EMCM*EMCM-XMU2)
      PMXCM = PMCM*STCM*CPCM
      PMYCM = PMCM*STCM*SPCM
      PMZCM = PMCM*CTCM
c
C------------ROTATION BACK TO ORIGINAL Z AXIS--------------------------
c
      XLEN = DSQRT((W2-TM-TP)**2-4.D0*TM*TP)/(2.D0*W)
      IF (IDUMP.EQ.5) print 44, XLEN
      CTRO   = QKMZCM/XLEN
      STRO   = DSQRT(QKMXCM*QKMXCM+QKMYCM*QKMYCM)/XLEN
      IF (STRO.EQ.0.D0) GOTO 60
      CFRO   =  QKMXCM/XLEN/STRO
      SFRO   =  QKMYCM/XLEN/STRO
      PMXRO  =  PMXCM*CTRO*CFRO-PMYCM*SFRO+PMZCM*STRO*CFRO
      PMYRO  =  PMXCM*CTRO*SFRO+PMYCM*CFRO+PMZCM*STRO*SFRO
      PMZRO  = -PMXCM*STRO                +PMZCM*CTRO
      GOTO 61
   60 PMXRO  = PMXCM
      PMYRO  = PMYCM
      PMZRO  = PMZCM
   61 CONTINUE
c
C------------BOOST BACK TO LAB SYSTEM--------------------------
c
      PM(4)  = (EW*EMCM+QWX*PMXRO+QWY*PMYRO+QWZ*PMZRO)/W
      IF (IDUMP.EQ.5) print 45, PM(4)
      FAC1   = (PM(4)+EMCM)/(EW+W)
      PM(1)  = PMXRO + FAC1*QWX
      PM(2)  = PMYRO + FAC1*QWY
      PM(3)  = PMZRO + FAC1*QWZ
      PP(1)  = QWX   - PM(1)
      PP(2)  = QWY   - PM(2)
      PP(3)  = QWZ   - PM(3)
      PP(4)  = EW    - PM(4)
C
      DO 5 I = 1,4
      QMB(I) = -QM(I)
      QPB(I) = -QP(I)
      PMB(I) = -PM(I)
      PPB(I) = -PP(I)
    5 CONTINUE
      DD1    = APB - BCT*CTCME
      DD2    = ACT - BCT + BCT*CTCME
      IF (CTCM.GT.0.D0) GOTO 12
      DDU    = DD1
      DD1    = DD2
      DD2    = DDU
   12 CONTINUE
      PROP1  = TM*TP*DD1
      PROP2  = TM*TP*DD2
      PROP3  = 0.D0
      PROP4  = 0.D0
c
C-----CALCULATION OF 1/4(SPIN SUM) M**2----------------------
C
      U1     = TM
      U2     = TP
      U3     = W2
      U4     = DD1
      U5     = DD2
      U6     = 0.D0
      U7     = 0.D0
      U8     = YE
      U9     = XE
      XME(1) = DIAG2( P1, QM, XM, P2, QP, XM, PM, PP,XMU,IDUMP)
C
C-----CALCULATTION APPROXIMATION-------------------------------
c
      HWE  =  DLOG(HZ)*DSIGN(1.D0,BB)
      IF (IDUMP.EQ.5) print 46, HWE
      WEA1 = XME(1)*TM*TP*DD1*DD2/512.D0
      WEA2 = XX*(4.D0*HY+2.D0*Y*ZMP)/DABS(4.D0*XX-2.D0*XX*Y+
     .                                    2.D0*YY*X*ZM)
      WEA3 = 0.25D0*W2*W2/(ACT*BCT)*DLOG(APB/(ACT-BCT))/XLA3
      WEA4 = (VP+DE2A)/(VP+DELP)/(PB*PB)
      WEA5 = (4.D0*HY+2.D0*HM)*HWE/(DELTA*XLA2)
      WEA6 = 2.D0*HY/(2.D0*HY-Y*DELM)*DLOG(2.D0*HY*
     .        (2.D0+DELM)/(DELM*(2.D0*HY+2.D0*Y)))/XLA1
      WEA7 = DLOG(HYMAX/HYMIN)*DSQRT(1.D0-4.D0*XMU2/W2)/XLA4(IYY)
C
      IF (IDUMP.EQ.5) print 47, WEA1,WEA2,WEA3,WEA4,WEA5,WEA6,WEA7
C
      DO 199 I=1,4
      WEIGHT(I) = 0.D0
  199 CONTINUE
C
      WEIGHT(1) = WEA1*WEA2*WEA3*WEA4*WEA5*WEA6*WEA7/WBP(1)
      WEEV      = WEIGHT(1)
C
      IF (WEIGHT(1).GE.0.D0) GOTO 201
      IFAIL(1)  = IFAIL(1) + 1
      INEG      = INEG     + 1
      IDUMP     = 5
      GOTO 201
C
C-------------EVENT IS GENERATED OUTSIDE PHYSICAL PHASE SPACE-------
c
  200 CONTINUE
      OUTFL(1)  = .TRUE.
      RETURN
  201 CONTINUE
C
      ICH   = 0
      IF (IPROC.NE.5) GOTO 305
C
C INTERCHANGE OF FOUR MOMENTA
c
      IS    = 1
      ETA10 = RNF100(10)
      IF (ETA10.LT.ECH(2)) IS = -1
      IF (ETA10.LT.ECH(2+IS)) GOTO 300
      IP    = 3 + IS
      GOTO 301
  300 CONTINUE
      IP    = 2 + IS
  301 CONTINUE
      GOTO (302,303,304,305),IP
c
  302 CALL CHANGE(QP,PP)
c
      ICH   = 1
      GOTO 305
c
  303 CALL CHANGE(QM,PM)
c
      ICH   = 2
      GOTO 305
c
  304 CALL CHANGE(QP,PP)
c
      CALL CHANGE(QM,PM)
c
      ICH   = 3
  305 CONTINUE
C
C-----Start DUMP information--------------------------------------
c
      IF (WEEV.GE.0.D0) GOTO 1081
      print 1080, WEIGHT(1)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      print  1079
      print  1082, XME(1),WEEV
      IF (IDUMP.LT.2) RETURN
      print  1083
      print  1084, VP,VM,THP,THM,X,Y,TP,TM,DELP,DELM,DE2A,W2,CTCM,
     .          CTCME,Z0,Z1,Z,XME(1),DD1,DD2,IY,IYY
      IF (IDUMP.LT.3) RETURN
      print  999
c      print  1008, W2MIN,W2MAX,S1MIN,S1MAX
      print  1008, W2MIN,W2MAX    ! 06.06.99
      print  1007, XM,XM2,XMU,XMU2,ALFA,BARN,PI,TWOPI
      print  1101, U1,U2,U3
      print  1102, XLA1,XLA2,XLA3,XLA4,SAPA
      print  1103, PB,ET,EP
      print  1002, EB,ESWE,WAP
      print  1104, OUTFL
      print  1106, SAP
      print  1003, P1B,P2B,QMB,QPB,PMB,PPB
      print  1004, P1,P2,QM,QP,PM,PP
      print  1001, IFAIL,IACC,INUL,ICHG,INEG,IONE,IZERO
      print  1005, WEIGHT,WEEV,IEVACC
      print  1000, SWE,SWEK,MWE,SUM,SUMK,MAXWE,IWE,IGEN
c
      IF (IDUMP.LT.4) RETURN
      print  1009
      XPOS = QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2-XM2
      XELE = QM(4)**2-QM(1)**2-QM(2)**2-QM(3)**2-XM2
      XMUP = PP(4)**2-PP(1)**2-PP(2)**2-PP(3)**2-XMU2
      XMUM = PM(4)**2-PM(1)**2-PM(2)**2-PM(3)**2-XMU2
      XW   = EW**2-QWX**2-QWY**2-QWZ**2-W2
      XTM  = EQKM**2-QKMX**2-QKMY**2-QKMZ**2-TM
c
      print  1010, XPOS,XELE,XMUP,XMUM,XW,XTM
      SUMX = QM(1)+QP(1)+PM(1)+PP(1)
      SUMY = QM(2)+QP(2)+PM(2)+PP(2)
      SUMZ = QM(3)+QP(3)+PM(3)+PP(3)
      SUME = 2-QM(4)-QP(4)-PM(4)-PP(4)
      print  1011, SUMX,SUMY,SUMZ,SUME
c
      IF (IDUMP.LT.5) RETURN
      print  2999
      print  3000, ETA0
      print  3001, ETA1
      print  3002, ETA2
      print  3003, ETA3
      print  3004, ETA4
      print  3005, ETA5
      print  3006, ETA6
      print  3007, ETA7
      print  3008, ETA8
      print  3009, ETA9
c
   20 FORMAT(' MCA: ETA1')
   21 FORMAT(' MCA: HYMAX = ',D30.20)
   22 FORMAT(' MCA: Y YE = ',2(D30.20,2X))
   23 FORMAT(' MCA: DELM = ',D30.20)
   24 FORMAT(' MCA: VM = ',D30.20)
   25 FORMAT(' MCA: DE2A = ',D30.20)
   26 FORMAT(' MCA: AA BB CC = ',3(D30.20,2X))
   27 FORMAT(' MCA: Z1 Z0 HZ  = ',3(D30.20,2X))
   28 FORMAT(' MCA: HHZ  Z = ',2(D30.20,2X))
   29 FORMAT(' MCA: EZ0 EZ2 EZ = ',3(D30.20,2X))
   30 FORMAT(' MCA: CTG1 CTG STG = ',3(D30.20,2X))
   31 FORMAT(' MCA: SEZ CEZ1 CEZ = ',3(D30.20,2X))
   32 FORMAT(' MCA: VP CTP STP = ',3(D30.20,2X))
   33 FORMAT(' MCA: YH CAS = ',2(D30.20,2X))
   34 FORMAT(' MCA: ZMP ZM =',2(D30.20,2X))
   35 FORMAT(' MCA: DISC = ',D30.20)
   36 FORMAT(' MCA: IY=1 X = ',D30.20)
   37 FORMAT(' MCA: IY=-1 X = ',D30.20)
   38 FORMAT(' MCA: X XE DELP = ',3(D30.20,2X))
   39 FORMAT(' MCA: HW = ',D30.20)
   40 FORMAT(' MCA: EKMCM = ',D30.20)
   41 FORMAT(' MCA: ACT HB BCT = ',3(D30.20,2X))
   42 FORMAT(' MCA: APB = ',D30.20)
   43 FORMAT(' MCA: HCT CTCME CTCM = ',3(D30.20,2X))
   44 FORMAT(' MCA: XLEN = ',D30.20)
   45 FORMAT(' MCA: PM(4) = ',D30.20)
   46 FORMAT(' MCA: HWE = ',D30.20)
   47 FORMAT(' MCA: WEIGHTS ARE = ',
     .         3(D30.20,2X)/1X,3(D30.20,2X)/1X,D30.20)
  102 FORMAT(' MCA: WARNING : HYMIN > HYMAX '/
     .     1X,'HYMIN = ',D19.6,2X,'HYMAX = ',D19.6,2X,' W2 = ',D19.6)
  105 FORMAT(' MCA: WARNING : X < XMIN '/
     .       ' X  = ',D13.4,' DISC = ',D13.4/
     .       ' Y  = ',D13.4,' YE   = ',D13.4/
     .       ' YY = ',D13.4,' YH   = ',D13.4/
     .       ' ZM = ',D13.4)
  106 FORMAT(' MCA: WARNING : X > XMAX '/
     .       ' X  = ',D13.4,' DISC = ',D13.4/
     .       ' Y  = ',D13.4,' YE   = ',D13.4/
     .       ' YY = ',D13.4,' YH   = ',D13.4/
     .       ' ZM = ',D13.4)
  110 FORMAT(' MCA: $$$ WARNING $$$ : ZM > 0 , ZM = ',D19.6)
  999 FORMAT(' MCA: -----INFORMATION ON COMMON BLOCKS-----------')
 1000 FORMAT(' MCA: COMMON WESTAT CONTAINS '/3(1X,4(D30.20,2X)/),
     .       1X,3(D30.20,2X)/1X,5(I9,2X))
 1001 FORMAT(' MCA: COMMON WECOUN CONTAINS '/4(1X,4(I9,2X)/)/
     .       1X,3(I9,2X))
 1002 FORMAT(' MCA: COMMON INPUT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,4(D30.20,2X))
 1003 FORMAT(' MCA: COMMON VECTOB CONTAINS'/6(1X,4(D30.20,2X)/))
 1004 FORMAT(' MCA: COMMON VECTOR CONTAINS '/6(1X,4(D30.20,2X)/))
 1005 FORMAT(' MCA: COMMON WEIGHT CONTAINS '/1X,4(D30.20,2X)/
     .       1X,D30.20,2X,I9)
 1007 FORMAT(' MCA: COMMON CONST CONTAINS '/2(1X,3(D30.20,2X)/),
     .       1X,2(D30.20,2X))
 1008 FORMAT(' MCA: COMMON BOUND CONTAINS '/2(1X,2(D30.20,2X)/))
 1009 FORMAT(' MCA: ---------INFORMATION ON KINEMATICS-----------')
 1010 FORMAT(' MCA: QP**2-XM2  = ',D30.20,' QM**2-XM2  = ',D30.20/
     .       ' PP**2-XMU2  = ',D30.20,' PM**2-XMU2  = ',D30.20/
     .       ' (QM+QP)**2-W2= ',D30.20,' (P1-QM)**2-TM = ',D30.20)
 1011 FORMAT(' MCA: SUM X COMPONENTS   = ',D30.20,
     .       ' SUM Y COMPONENTS   = ',D30.20/
     .       ' SUM Z COMPONENTS   = ',D30.20,
     .       ' 2-SUM E COMPONENTS = ',D30.20)
 1079 FORMAT (' MCA: -------INFORMATION ON WEIGHTS------------------')
 1080 FORMAT(' MCA: $$$WARNING$$$ : WEIGHT < 0 : WEIGHT = ',D30.20)
 1082 FORMAT(' MCA: XME = ',D30.20,2X,
     .       'WEIGHT = ',D30.20)
 1083 FORMAT (' MCA: --------INFORMATION ON ANGLES AND ENERGIES-----')
 1084 FORMAT(' MCA: VP   = ',D30.20,7X,'VM    = ',D30.20/
     .       ' THP  = ',D30.20,7X,'THM   = ',D30.20/
     .       ' X    = ',D30.20,7X,'Y     = ',D30.20/
     .       ' TP   = ',D30.20,7X,'TM    = ',D30.20/
     .       ' DELP = ',D30.20,7X,'DELM  = ',D30.20/
     .       ' DELW = ',D30.20,7X,'W2    = ',D30.20/
     .       ' CTCM = ',D30.20,7X,'CTCME = ',D30.20/
     .       ' Z0   = ',D30.20,7X,'Z1    = ',D30.20/
     .       ' Z    = ',D30.20,7X,'XME   = ',D30.20/
     .       ' DD1  = ',D30.20,7X,'DD2   = ',D30.20/
     .       ' IY   = ',I9    ,7X,'IYY   = ',I9)
 1101 FORMAT(' MCA: COMMON DIAG CONTAINS '/1X,3(D30.20,2X))
 1102 FORMAT(' MCA: COMMON GENA CONTAINS '/1X,3(D30.20,2X)/
     .       1X,4(D30.20,2X))
 1103 FORMAT(' MCA: COMMON INIT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,3(D30.20,2X))
 1104 FORMAT(' MCA: COMMON LOG CONTAINS '/1X,4L9)
 1106 FORMAT(' MCA: COMMON SAP CONTAINS '/1X,4(D30.20,2X))
 2999 FORMAT(' MCA: -------INFORMATION ON RANDOM NUMBERS----------')
 3000 FORMAT(' MCA: RANDOM NUMBER (SIG1)            = ',D35.25)
 3001 FORMAT(' MCA: RANDOM NUMBER (W2)              = ',D35.25)
 3002 FORMAT(' MCA: RANDOM NUMBER (Y)               = ',D35.25)
 3003 FORMAT(' MCA: RANDOM NUMBER (VM)              = ',D35.25)
 3004 FORMAT(' MCA: RANDOM NUMBER (Z)               = ',D35.25)
 3005 FORMAT(' MCA: RANDOM NUMBER (PHIR)            = ',D35.25)
 3006 FORMAT(' MCA: RANDOM NUMBER (CTG)             = ',D35.25)
 3007 FORMAT(' MCA: RANDOM NUMBER (PHIP)            = ',D35.25)
 3008 FORMAT(' MCA: RANDOM NUMBER (CTCM)            = ',D35.25)
 3009 FORMAT(' MCA: RANDOM NUMBER (PHICM)           = ',D35.25)
c
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE MCB(IPROC,IDUMP)
c***********************************************************************
c
c... Bremsstrahlung subgenerator
c
c... COMMON /MATRIX / CONTAINS :
c            XME(2) = EXACT BREMSSTRAHLUNG /MATRIX ELEMENT/^2
c... COMMON /DIAG   / CONTAINS :
c            CALCULATED PHOTON PROPAGATORS AND INVARIANT MASS^2 MUONS
c            THESE VALUES ARE USED IN FUNCTION DIAG2
c
c***********************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEBOUND/  W2MIN,W2MAX
      COMMON /GG_EECHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /GG_EECONST/  ALFA,BARN,PI,TWOPI
      COMMON /GG_EECOUNTB/ IREGB1,IREGB2,IREGC1,IREGC2,IPROB1,IPROB2
      COMMON /GG_EEDIAG/   U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /GG_EEGENB/   XLB1,XLB2(2),SAPB(2)
      COMMON /GG_EEINIT/   PB,ET,EP(3),ECH(3)
      COMMON /GG_EEINPUT/  EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EELOG1/   OUTFL(4)
      COMMON /GG_EEMASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /GG_EEMATRIX/ XME(4)
      COMMON /GG_EEPROSTA/ PROP1,PROP2,PROP3,PROP4
      COMMON /GG_EESAP/    SAP(4),SAPT,CROSEC        ! +
      COMMON /GG_EESELECT/ IC,ICH
      COMMON /GG_EEVECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /GG_EEVECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /GG_EEWECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),IUNDFL(4),
     &                     INEG,IONE,IZERO
      COMMON /GG_EEWEIGHT/ WEIGHT(4),WEEV,IEVACC
      COMMON /GG_EEWESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),
     &                     IGEN
      DIMENSION PH(4)
      LOGICAL OUTFL
      REAL*8 MWE,MAXWE
c
      OUTFL(2) = .FALSE.
      IY     = 1
      ETA0   = RNF100(IDUM)
      IF (ETA0.LT.SAPB(2)/SAP(2)) IY = -1
      IYY    = (-IY+1)/2 + 1
      IF (IYY.EQ.1) IREGB1 = IREGB1 + 1
      IF (IYY.EQ.2) IREGB2 = IREGB2 + 1
c
c--------W2 GENERATION-------------------------------------------
c
      IF (IDUMP.EQ.5) PRINT 50
 50   FORMAT(' MCB: ETA1')
      ETA1   = RNF100(1)
      W2     = W2MIN*W2MAX/((1.D0-ETA1)*W2MAX+ETA1*W2MIN)
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
c
c--------Y GENERATION--------------------------------------------
c
      IF (IDUMP.EQ.5) PRINT 51
 51   FORMAT(' MCB: YMIN')
      YMIN   = XM2
      YMAX   = (1.D0-O)*(1.D0-O)
      IF (IY.EQ.-1) YMAX = (1.D0-O2)*XM/(2.D0-XM)
      ETA2   = RNF100(2)
      Y      = (YMAX/YMIN)**ETA2*YMIN
      XK0    = 1.D0 + O2 - Y
      XKV2   = XK0*XK0 - W2
      XKV    = DSQRT(XKV2)
      XKM    = 2.D0 - XK0
      XKH    = 2.D0*XK0 - W2
c
c--------CK GENERATION-------------------------------------------
c
      IF (IDUMP.EQ.5) PRINT 52
 52   FORMAT(' MCB: ETA3')
      ETA3   = RNF100(3)
      VK     = ETA3*W2*Y/(2.D0*XKV*(1.D0-ETA3)+0.5D0*W2*Y)
      CK     = 1.D0 - VK
      SK     = DSQRT(VK*(2.D0-VK))
      DEPA   = 0.5D0*XM2*((XKV*VK*(XKM+XKV)+2.D0*Y*W2/(XK0+XKV))/
     .         (2.D0*Y*(XKM+XKV)))**2
c
c--------FEYNMAN PARAMETER GENERATION----------------------------
c
      DELTAA = 2.D0*DSQRT((4.D0*Y*W2/(XKH+2.D0*XKV)+
     .         2.D0*XKV*VK-2.D0*XKV*DEPA)**2+
     .         4.D0*XKV*DEPA*(XKH+2.D0*XKV)*VK)
      IF (IDUMP.EQ.5) PRINT 53,DELTAA
 53   FORMAT(' MCB: DELTAA = ',D35.25)
      CC     = 2.D0*DEPA+DEPA*DEPA
      BB     = 8.D0*Y*W2/(XKH+2.D0*XKV)+4.D0*XKV*VK+
     .         2.D0*XKH*DEPA-2.D0*CC
      AA     = 4.D0*Y*W2-BB-CC
      IF (IDUMP.EQ.5) PRINT 4300,AA,BB,CC
 4300 FORMAT(' MCB: AA BB CC = ',3(D35.25,2X))
      IF (BB.GT.0.D0) GOTO 11
      A1     = (-BB+DELTAA)/(2.D0*AA)
      GOTO 12
   11 CONTINUE
      A1     = (-BB-DELTAA)/(2.D0*AA)
   12 CONTINUE
      A0     = CC/(AA*A1)
      HA     = (A1-A0*A1)/(A0-A0*A1)
      IF (IDUMP.EQ.5) PRINT 4301,A0,A1,HA
 4301 FORMAT(' MCB: A0 A1 HA = ',3(D35.25,2X))
      IF (IDUMP.EQ.5) PRINT 54
   54 FORMAT(' MCB: ETA4')
      ETA4   = RNF100(4)
      HHA    = -1.D0*DABS(A0/A1)*HA**ETA4*DSIGN(1.D0,AA)
      A      = (A0+HHA*A1)/(1.D0+HHA)
c
c-----AZIMUTHAL ANGLE GENERATION----------------------------------
c
      ETA5   = RNF100(5)
      PHIR   = TWOPI*ETA5
      CPG    = DCOS(PHIR)
      SPG    = DSIN(PHIR)
c
c-----CP' GENERATION----------------------------------------------
c
      IF (IDUMP.EQ.5) PRINT 55
   55 FORMAT(' MCB: EA0')
      EA0    = (1.D0-A)*(1.D0+DEPA) + A*XKH
      EA2    = (AA*A+BB)*A+CC
      EAV    = DSQRT(EA0*EA0-EA2)
      ETA6   = RNF100(6)
      VTG    = 2.D0*(1.D0-ETA6)*EA2/(EA2+2.D0*ETA6*EAV*(EA0+EAV))
      CTG    = 1.D0 - VTG
      STG    = DSQRT(VTG*(2.D0-VTG))
c
c-----CALCULATION CP----------------------------------------------
c
      IF (IDUMP.EQ.5) PRINT 56
   56 FORMAT(' MCB: SEA')
      SEA    = -2.D0*A*XKV*SK/EAV
      VA     = 4.D0*A*A*XKV2*SK*SK/(EAV*(EAV+1.D0-A+2.D0*A*XKV*CK))
      CEA    = 1.D0 - VA
      IF (IDUMP.EQ.5) PRINT 57
   57 FORMAT(' MCB: VP')
      IF (VA .GE.0.D0.AND.VA .LT.1.D-38.AND.
     .    VTG.GE.0.D0.AND.VTG.LT.1.D-20) GOTO 550
      CPROD = VA*VTG
      GOTO 551
  550 CONTINUE
      IUNDFL(2) = IUNDFL(2) + 1
      CPROD = 0.D0
  551 CONTINUE
      VP     = VA + VTG - CPROD + SEA*STG*CPG
      CTP    = 1.D0 - VP
      STP    = DSQRT(VP*(2.D0-VP))
      CP     = (CEA*STG*CPG+SEA*CTG)/STP
      SP     = STG*SPG/STP
c
c-----CALCULATION COS ANISOTROPY ANGLE----------------------------
c
      IF (IDUMP.EQ.5) PRINT 58
   58 FORMAT(' MCB: CAS')
      CAS    = (-4.D0*Y*Y+XM2*XKM*XKM)/(XM2*XKV2)
      CA     = 1.D0
      IF (CAS.GT.0.D0) CA = -DSQRT(CAS)
c-----CALCULATION COS(ANGLE BETWEEN QK AND QP)--------------------
      IF (IDUMP.EQ.5) PRINT 59
   59 FORMAT(' MCB: ZMP')
      ZMP    = VK + VP - VK*VP + SK*STP*CP
      ZM     = ZMP - 1.D0
      IF (ZM.GT.CA) GOTO 200
      IF (IDUMP.EQ.5) PRINT 60
   60 FORMAT(' MCB: DISC')
      DISC   = DSQRT(4.D0*Y*Y-4.D0*Y*XM2-XM2*XKV2*ZMP*(1.D0-ZM))
c
c-----CALCULATION ENERGY POSITRON---------------------------------
c
      IF (IY.EQ.-1) GOTO 103
      IF (IDUMP.EQ.5) PRINT 61
   61 FORMAT(' MCB: X IY=1')
      X      = (2.D0*XKM*Y-XKV*ZM*DISC)/(4.D0*Y+XKV2*ZMP*(1.D0-ZM))
      GOTO 104
  103 CONTINUE
      IF (ZM.GT.0.D0) PRINT 110,ZM
  110 FORMAT(' MCB: WARNING : ZM > 0 : ZM = ',D19.6)
      IF (IDUMP.EQ.5) PRINT 62
   62 FORMAT(' X IY=-1')
      X      = (4.D0*Y*Y+XM2*XKV2*ZM*ZM)/
     .         (2.D0*XKM*Y-XKV*ZM*DISC)
  104 CONTINUE
      IF (X.LT.XM) PRINT 105,X,DISC,XK0,XKV,W2,ZM,CAS,CA
  105 FORMAT(' MCB: WARNING : X < XMIN '/
     .       ' X     = ',D19.6,7X,'DISC  = ',D19.6/
     .       ' XK0   = ',D19.6,7X,'XKV   = ',D19.6/
     .       ' W2    = ',D19.6,7X,'ZM    = ',D19.6/
     .       ' CAS   = ',D19.6,7X,'CA    = ',D19.9)
      IF (X.GT.1.D0-XM*O-O2) PRINT 106,X,DISC,XK0,XKV,W2,ZM,CAS,CA
  106 FORMAT(' MCB: X > XMAX '/
     .       ' X     = ',D19.6,7X,'DISC  = ',D19.6/
     .       ' XK0   = ',D19.6,7X,'XKV   = ',D19.6/
     .       ' W2    = ',D19.6,7X,'ZM    = ',D19.6/
     .       ' CAS   = ',D19.6,7X,'CA    = ',D19.6)
      XV     = DSQRT(X*X-XM2)
      ETX    = X + XV
      IF (IDUMP.EQ.5) PRINT 63
   63 FORMAT(' MCB: DE')
      DE     = 0.5D0/(PB*XV*ET*ETX)*XM2*(ETX-ET)*(ETX-ET)
c
c-----GENERATION OF AZIMUTHAL ANGLE QK----------------------------
c
      ETA7   = RNF100(7)
      PHIK   = TWOPI*ETA7
      CPK    = DCOS(PHIK)
      SPK    = DSIN(PHIK)
      CPP    = CP*CPK - SP*SPK
      SPP    = SP*CPK + CP*SPK
c
c--------CONSTRUCTION OF THE 4MOMENTA------------------------------
c
      QKE    = XK0
      QKX    = XKV*SK*CPK
      QKY    = XKV*SK*SPK
      QKZ    = XKV*CK
      QP(1)  =  XV*STP*CPP
      QP(2)  =  XV*STP*SPP
      QP(3)  = -XV*CTP
      QP(4)  =  X
      QM(1)  = -QP(1) - QKX
      QM(2)  = -QP(2) - QKY
      QM(3)  = -QP(3) - QKZ
      QM(4)  = -QP(4) - QKE + 2.D0
c
c--------GENERATION OF MUON PAIR IN ITS CM SYSTEM-------------------
c
      IF (IDUMP.EQ.5) PRINT 64
   64 FORMAT(' MCB: ETA8')
      ETA8   = RNF100(8)
      CMU    = 2.D0*ETA8-1.D0
      SMU    = DSQRT(1.D0-CMU*CMU)
      ETA9   = RNF100(9)
      PHIM   = TWOPI*ETA9
      CPMU   = DCOS(PHIM)
      SPMU   = DSIN(PHIM)
      EKCM   = O
      PKCM   = DSQRT(EKCM*EKCM-XMU2)
      PXCM   = PKCM*SMU*CPMU
      PYCM   = PKCM*SMU*SPMU
      PZCM   = PKCM*CMU
c--------BOOST BACK TO LABORATORY SYSTEM--------------------------
      PM(4)  = (QKE*EKCM+QKX*PXCM+QKY*PYCM+QKZ*PZCM)/W
      FAC    = (PM(4)+EKCM)/(QKE+W)
      PM(1)  = PXCM + FAC*QKX
      PM(2)  = PYCM + FAC*QKY
      PM(3)  = PZCM + FAC*QKZ
      PP(1)  = QKX  - PM(1)
      PP(2)  = QKY  - PM(2)
      PP(3)  = QKZ  - PM(3)
      PP(4)  = QKE  - PM(4)
c-------------------------------------------------------------------
      DO 5 I = 1,4
        QMB(I) = -QM(I)
        QPB(I) = -QP(I)
        PMB(I) = -PM(I)
        PPB(I) = -PP(I)
    5 CONTINUE
c
      IF (IDUMP.EQ.5) PRINT 65
   65 FORMAT(' MCB: T1')
      T1     =  2.D0*XM2-2.D0*DOTGG(P1,QM)
      T2     = -2.D0*XV*PB*(VP+DE)
      Z      = QM(4)
      DD3    = 4.D0*(1.D0-X)
      DD4    = 4.D0*W2*Y/(W2-2.D0*XK0-2.D0*XKV)-2.D0*XM2*XKV/ET
     .         -2.D0*PB*XKV*VK
      DD5    = 4.D0*(1.D0-Z)
      DD6    = 4.D0*W2*Y/(W2-2.D0*XK0-2.D0*XKV)-2.D0*XM2*XKV/ET
     .         -2.D0*PB*XKV*(1.D0+CK)
      PROP1  = T2*W2*DD3
      PROP2  = T2*W2*DD4
      PROP3  = T1*W2*DD5
      PROP4  = T1*W2*DD6
c
c--------CALCULATION OF 1/4(SPIN SUM)/M/^2--------------------------
c
c--------THE CONTRIBUTION OF THE BREMSSTRAHLUNG ON THE---------------
c--------ELECTRON LINE IS CALCULATED---------------------------------
c
      U1     = W2
      U2     = T2
      U3     = T1
      U4     = DD3
      U5     = DD4
      U6     = 0.D0
      U7     = 0.D0
      U8     = PPB(4) - PM(4)
      U9     = P2(4)  - QP(4)
      XMB1   = DIAG2(PPB, PM,XMU, P2, QP, XM, QM,P1B,XM ,IDUMP)
C
C--------THE CONTRIBUTION OF THE BREMSSTRAHLUNG ON THE---------------
C--------POSITRON LINE IS CALCULATED---------------------------------
C
      U1     = T1
      U2     = W2
      U3     = T2
      U4     = DD5
      U5     = DD6
      U6     = 0.D0
      U7     = 0.D0
      U8     = P1(4)  - QM(4)
      U9     = PMB(4) - PP(4)
      XMB2   = DIAG2( P1, QM, XM,PMB, PP,XMU,P2B, QP,XM ,IDUMP)
C
C--------CALCULATION OF THE INTERFERENCE BETWEEN BREMSSTRAHLUNG------
C--------DIAGRAMS ON THE ELECTRON AND POSITRON LINE------------------
C
      U1     = T1
      U2     = T2
      U3     = W2
      U4     = DD3
      U5     = DD4
      U6     = DD5
      U7     = DD6
      U8     = 0.D0
      U9     = 0.D0
      XMB3   = DIAG4( P1, QM, XM, P2, QP, XM, PM, PP,XMU)
C
      XME(2) = XMB1 + XMB2 + XMB3
C
C--------CALCULATION OF THE APPROXIMATION----------------------------
c
      IF (IDUMP.EQ.5) PRINT 66
   66 FORMAT(' MCB: ZV')
      ZV     = DSQRT(QM(1)*QM(1)+QM(2)*QM(2)+QM(3)*QM(3))
      ZP     = (QM(1)*QKX+QM(2)*QKY+QM(3)*QKZ)/(ZV*XKV)
      ZGEM   = 2.D0*XKM*Y/(XKM*XKM-XKV2*ZP*ZP)
      YWIG   = (1.D0-O2)*XM/(2.D0-XM)
      IZZ    = 1
      IF (ZP.LT.0.D0.AND.Y.LT.YWIG.AND.Z.LT.ZGEM) IZZ = 2
      IF (IZZ.EQ.1) IREGC1 = IREGC1 + 1
      IF (IZZ.EQ.2) IREGC2 = IREGC2 + 1
      CM     = QM(3)/ZV
      VM     = 1.D0 - CM
      DEMA   = 0.5D0*XM2*((XKV*(1.D0+CK)*(XKM+XKV)+
     .         2.D0*Y*W2/(XK0+XKV))/(2.D0*Y*(XKM+XKV)))**2
      IF (IDUMP.EQ.5) PRINT 78,DEMA
   78 FORMAT(' MCB: DEMA = ',D35.25)
      DELTAB = 2.D0*DSQRT((XKH+2.D0*XKV*CK-2.D0*XKV*DEMA)**2+
     .         4.D0*XKV*DEMA*(XKH+2.D0*XKV)*(1.D0+CK))
      IF (IDUMP.EQ.5) PRINT 67,DELTAB
   67 FORMAT(' MCB: DELTAB = ',D35.25)
      FF     = 2.D0*DEMA+DEMA*DEMA
      IF (IDUMP.EQ.5) PRINT 70,FF
   70 FORMAT(' MCB: FF = ',D35.25)
      EE     = 2.D0*XKH*(1.D0+DEMA)+4.D0*XKV*CK-2.D0*FF
      IF (IDUMP.EQ.5) PRINT 71,EE
   71 FORMAT(' MCB: EE = ',D35.25)
      DD     = 4.D0*Y*W2-EE-FF
      IF (IDUMP.EQ.5) PRINT 72,DD
   72 FORMAT(' MCB: DD = ',D35.25)
      DF     = 4.D0*Y*W2-2.D0*XKH*(1.D0+DEMA)-4.D0*XKV*CK
      ED     = 4.D0*Y*W2-FF
      EDF    = 4.D0*Y*W2
      IF (IDUMP.EQ.5) PRINT 1234,DF,ED,EDF
 1234 FORMAT(' MCB: D-F, E+D, E+D+F = ',3(D35.25,2X))
      IF (EE.GT.0.D0) GOTO 13
      B1     = (-EE+DELTAB)/(2.D0*DD)
      IF (IDUMP.EQ.5) PRINT 73,B1
   73 FORMAT(' MCB: EE > 0, B1 = ',D35.25)
      GOTO 14
   13 CONTINUE
      B1     = (-EE-DELTAB)/(2.D0*DD)
      IF (IDUMP.EQ.5) PRINT 74,B1
   74 FORMAT(' MCB: EE < 0, B1 = ',D35.25)
   14 CONTINUE
      B0     = FF/(DD*B1)
      IF (IDUMP.EQ.5) PRINT 75,B0
   75 FORMAT(' MCB: B0 = ',D35.25)
      SDELTA = DSIGN(1.D0,EE)*DELTAB
      IF (DABS(FF).GT.DABS(DD)*0.001D0) GOTO 17
c
      EB1    = 2.D0*EDF/(EE+2.D0*DD-SDELTA)
      EB0    = (EE+2.D0*FF+SDELTA)/(EE+SDELTA)
      EB0B1  = EB0/EB1
      GOTO 18
c
   17 CONTINUE
      IF (EE*DF.LT.0.D0) GOTO 15
      EB0B1  = 8.D0*FF*DD*EDF/((EE+SDELTA)*
     .         (EDF-DF-SDELTA)*(EDF+DF+SDELTA))
      GOTO 16
   15 CONTINUE
      EB0B1  = 0.5D0*(EDF+DF-SDELTA)*(EDF-DF+SDELTA)/
     .         ((EE+SDELTA)*EDF)
   16 CONTINUE
   18 CONTINUE
      IF (IDUMP.EQ.5) PRINT 100,EB0B1
  100 FORMAT(' MCB: EB0B1 = ',D35.25)
      HB     = EB0B1*B1/B0
      IF (IDUMP.EQ.5) PRINT 76,HB
   76 FORMAT(' MCB: HB = ',D35.25)
C
      WEA1   = -2.D0*XKV*(VK+0.5D0*W2*Y/XKV)/DD4
      IF (IDUMP.EQ.5) PRINT 90,WEA1
   90 FORMAT(' MCB: WEA1 = ',D35.25)
      WEA2   = -2.D0*XV*(VP+DEPA)/T2
      IF (IDUMP.EQ.5) PRINT 91,WEA2
   91 FORMAT(' MCB: WEA2 = ',D35.25)
      WEA3   = XV/((1.D0-X)*DABS(2.D0*XKM*XV+2.D0*X*XKV*ZM))*
     .         (4.D0*Y*W2/(XKH+2.D0*XKV)+2.D0*XKV*ZMP)
      IF (IDUMP.EQ.5) PRINT 92,WEA3
   92 FORMAT(' MCB: WEA3 = ',D35.25)
      WEA4   = DLOG(HA)*DSIGN(1.D0,BB)/DELTAA*
     .         4.D0*XKV*(VK+0.5D0*W2*Y/XKV)/XLB1
      IF (IDUMP.EQ.5) PRINT 93,WEA4
   93 FORMAT(' MCB: WEA4 = ',D35.25)
      WEA5   = 1.D0 - W2*Y/(4.D0*XKV+W2*Y)
      IF (IDUMP.EQ.5) PRINT 94,WEA5
   94 FORMAT(' MCB: WEA5 = ',D35.25)
      WEA6   = DLOG(YMAX/YMIN)*DSQRT(1.D0-4.D0*XMU2/W2)/
     .         XLB2(IYY)
      IF (IDUMP.EQ.5) PRINT 95,WEA6
   95 FORMAT(' MCB: WEA6 = ',D35.25)
      XMBP1  = 512.D0/(T2*W2*DD3*DD4*WEA1*WEA2*WEA3*WEA4*WEA5*WEA6)
      IF (IDUMP.EQ.5) PRINT 68,XMBP1
   68 FORMAT(' MCB: XMBP1 = ',D35.25)
C      XMBP1  = 8.D0*DELTAA*XLB1*XLB2(IYY)*
C     .         DABS(4.D0*XV-2.D0*XV*XK0+2.D0*X*XKV*ZM)/
C     .         (XV*(4.D0*Y*W2/(XKH+2.D0*XKV)+2.D0*XKV*ZMP)*
C     .          W2*XKV*XKV*(VK     +0.5D0*W2*Y/XKV)**2*XV*(VP+DEPA)*
C     .          DLOG(HA)*DSIGN(1.D0,BB)*
C     .          (1.D0-W2*Y/(4.D0*XKV+W2*Y))*DLOG(YMAX/YMIN)*
C     .          DSQRT(1.D0-4.D0*XMU2/W2))
      WEB1   = -2.D0*XKV*(1.D0+CK+0.5D0*W2*Y/XKV)/DD6
      IF (IDUMP.EQ.5) PRINT  40,WEB1
   40 FORMAT(' MCB: WEB1 = ',D35.25)
      WEB2   = -2.D0*ZV*(VM+DEMA)/T1
      IF (IDUMP.EQ.5) PRINT  41,WEB2
   41 FORMAT(' MCB: WEB2 = ',D35.25)
      IF (IDUMP.EQ.5) PRINT 99,ZV
   99 FORMAT(' MCB: ZV = ',D35.25)
      WEB3   = ZV/((1.D0-Z)*DABS(2.D0*XKM*ZV+2.D0*Z*XKV*ZP))*
     .         (4.D0*Y*W2/(XKH+2.D0*XKV)+2.D0*XKV*(1.D0+ZP))
      IF (IDUMP.EQ.5) PRINT  42,WEB3
   42 FORMAT(' MCB: WEB3 = ',D35.25)
      WEB4   = DLOG(HB)*DSIGN(1.D0,EE)/DELTAB*
     .         4.D0*XKV*(1.D0+CK+0.5D0*W2*Y/XKV)/XLB1
      IF (IDUMP.EQ.5) PRINT  43,WEB4
   43 FORMAT(' MCB: WEB4 = ',D35.25)
      WEB5   = 1.D0 - W2*Y/(4.D0*XKV+W2*Y)
      IF (IDUMP.EQ.5) PRINT  44,WEB5
   44 FORMAT(' MCB: WEB5 = ',D35.25)
      WEB6   = DLOG(YMAX/YMIN)*DSQRT(1.D0-4.D0*XMU2/W2)/
     .         XLB2(IZZ)
      IF (IDUMP.EQ.5) PRINT  45,WEB6
   45 FORMAT(' MCB: WEB6 = ',D35.25)
      XMBP2  = 512.D0/(T1*W2*DD5*DD6*WEB1*WEB2*WEB3*WEB4*WEB5*WEB6)
      IF (IDUMP.EQ.5) PRINT 69,XMBP2
   69 FORMAT(' MCB: XMBP2 = ',D35.25)
C      XMBP2  = 8.D0*DELTAB*XLB1*XLB2(IZZ)*
C     .         DABS(4.D0*ZV-2.D0*ZV*XK0+2.D0*Z*XKV*ZP)/
C     .         (ZV*(XKH+2.D0*XKV*ZP)*
C     .          W2*XKV*XKV*(1.D0+CK+0.5D0*W2*Y/XKV)**2*ZV*(VM+DEMA)*
C     .          DLOG(HB)*DSIGN(1.D0,EE)*
C     .          (1.D0-W2*Y/(4.D0*XKV+W2*Y))*DLOG(YMAX/YMIN)*
C     .          DSQRT(1.D0-4.D0*XMU2/W2))
C
      XMP    = XMBP1 + XMBP2
C
      DO 199 I=1,4
        WEIGHT(I) = 0.D0
  199 CONTINUE
C
      WEIGHT(2) = XME(2)/(XMP*WBP(2))
      WEEV      = WEIGHT(2)
C
      IF (WEIGHT(2).GE.0.D0) GOTO 201
      IFAIL(2)  = IFAIL(2) + 1
      INEG      = INEG + 1
      IDUMP     = 5
      GOTO 201
  200 CONTINUE
      OUTFL(2)  = .TRUE.
      RETURN
  201 CONTINUE
C
C--------SYMMETRIZATION----------------------------------------------
c
      IF (RNF100(IDUMM).LT.0.5D0) GOTO 9
      ICHG(2) = 1
      IPROB2  = IPROB2 + 1
      PROPU  = PROP1
      PROP1  = PROP3
      PROP3  = PROPU
      PROPU  = PROP2
      PROP2  = PROP4
      PROP4  = PROPU
      PH(4)  =  QP(4)
      QP(4)  =  QM(4)
      QM(4)  =  PH(4)
c
      DO 10 I=1,3
        PH(I)  =  QP(I)
        QP(I)  = -QM(I)
        QM(I)  = -PH(I)
        PM(I)  = -PM(I)
        PP(I)  = -PP(I)
   10 CONTINUE
c
      GOTO 8
    9 CONTINUE
      ICHG(2) = 0
      IPROB1 = IPROB1 + 1
    8 CONTINUE
C
      ICH   = 0
      IF (IPROC.NE.5) GOTO 305
c
c INTERCHANGE OF FOUR MOMENTA
c
      IS    = 1
      ETA10 = RNF100(10)
      IF (ETA10.LT.ECH(2)) IS = -1
      IF (ETA10.LT.ECH(2+IS)) GOTO 300
      IP    = 3 + IS
      GOTO 301
  300 CONTINUE
      IP    = 2 + IS
  301 CONTINUE
      GOTO (302,303,304,305),IP
  302 CALL CHANGE(QP,PP)
      ICH   = 1
      GOTO 305
  303 CALL CHANGE(QM,PM)
      ICH   = 2
      GOTO 305
c
  304 CALL CHANGE(QP,PP)
c
      CALL CHANGE(QM,PM)
c
      ICH   = 3
  305 CONTINUE
c
c-----START DUMP INFORMATION---------------------------------------
c
      IF (WEEV.GE.0.D0) GOTO 1081
      PRINT 1080,WEIGHT(2)
 1080 FORMAT(' MCB: WARNING : WEIGHT < 0 : WEIGHT = ',D30.20)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      PRINT 1079
 1079 FORMAT (' MCB: ---------INFORMATION ON WEIGHTS------------------')
      PRINT 1082,XME(2),XMP,WEEV
 1082 FORMAT(' XME = ',D30.20,2X,'XMP = ',D30.20,2X,
     .       'WEIGHT = ',D30.20)
      IF (IDUMP.LT.2) RETURN
      PRINT 1083
 1083 FORMAT (' MCB: ----------INFORMATION ON ANGLES AND ENERGIES-----')
      PRINT 1084,W2,W,Y,XK0,XKM,XKV,VK,CK,X,XV,VP,CTP,ZM,ZMP,
     .           Z,ZV,ZP,VM,DD3,DD4,DD5,DD6,T1,T2,XMB1,XMB2,
     .           XMB3,XMBP1,XMBP2,IYY,IZZ
 1084 FORMAT(' W2   = ',D30.20,3X,'W     = ',D30.20/
     .       ' Y    = ',D30.20,3X,'XK0   = ',D30.20/
     .       ' XKM  = ',D30.20,3X,'XKV   = ',D30.20/
     .       ' VK   = ',D30.20,3X,'CK    = ',D30.20/
     .       ' X    = ',D30.20,3X,'XV    = ',D30.20/
     .       ' VP   = ',D30.20,3X,'CTP   = ',D30.20/
     .       ' ZM   = ',D30.20,3X,'ZMP   = ',D30.20/
     .       ' Z    = ',D30.20,3X,'ZV    = ',D30.20/
     .       ' ZP   = ',D30.20,3X,'VM    = ',D30.20/
     .       ' DD3  = ',D30.20,3X,'DD4   = ',D30.20/
     .       ' DD5  = ',D30.20,3X,'DD6   = ',D30.20/
     .       ' T1   = ',D30.20,3X,'T2    = ',D30.20/
     .       ' XMB1 = ',D30.20,3X,'XMB2  = ',D30.20/
     .       ' XMB3 = ',D30.20/
     .       ' XMBP1= ',D30.20,3X,'XMBP2 = ',D30.20/
     .       ' IYY  = ',I9    ,2X,'IZZ   = ',I9    )
      IF (IDUMP.LT.3) RETURN
      PRINT 999
  999 FORMAT(' MCB: --------INFORMATION ON COMMON BLOCKS--------------')
      PRINT 1008,W2MIN,W2MAX
 1008 FORMAT(' COMMON BOUND CONTAINS '/1X,2(D35.25,2X))
      PRINT 1007,XM,XM2,XMU,XMU2,ALFA,BARN,PI,TWOPI
 1007 FORMAT(' COMMON CONST CONTAINS '/2(1X,3(D35.25,2X)/),
     .       1X,2(D35.25,2X))
      PRINT 1101,U1,U2,U3
 1101 FORMAT(' COMMON DIAG CONTAINS '/1X,3(D30.20,2X))
      PRINT 1102,XLB1,XLB2,SAPB
 1102 FORMAT(' COMMON GENB CONTAINS '/1X,3(D30.20,2X)/
     .       1X,2(D30.20,2X))
      PRINT 1103,PB,ET,EP
 1103 FORMAT(' COMMON INIT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,3(D30.20,2X))
      PRINT 1002,EB,ESWE,WAP
 1002 FORMAT(' COMMON INPUT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,4(D30.20,2X))
      PRINT 1104,OUTFL
 1104 FORMAT(' COMMON LOG CONTAINS '/1X,4L9)
      PRINT 1105,XME
 1105 FORMAT(' COMMON MATRIX CONTAINS '/1X,4(D30.20,2X))
      PRINT 1106,SAP
 1106 FORMAT(' COMMON SAP CONTAINS '/1X,4(D30.20,2X))
      PRINT 1003,P1B,P2B,QMB,QPB,PMB,PPB
 1003 FORMAT(' COMMON VECTOB CONTAINS'/6(1X,4(D30.20,2X)/))
      PRINT 1004,P1,P2,QM,QP,PM,PP
 1004 FORMAT(' COMMON VECTOR CONTAINS '/6(1X,4(D30.20,2X)/))
      PRINT 1001,IFAIL,IACC,INUL,ICHG,INEG,IONE,IZERO
 1001 FORMAT(' COMMON WECOUN CONTAINS '/4(1X,4(I9,2X)/)/
     .       1X,3(I9,2X))
      PRINT 1005,WEIGHT,WEEV,IEVACC
 1005 FORMAT(' COMMON WEIGHT CONTAINS '/1X,4(D30.20,2X)/
     .       1X,D30.20,2X,I9)
      PRINT 1000,SWE,SWEK,MWE,SUM,SUMK,MAXWE,IWE,IGEN
 1000 FORMAT(' COMMON WESTAT CONTAINS '/3(1X,4(D30.20,2X)/),
     .       1X,3(D30.20,2X)/1X,5(I9,2X))
      IF (IDUMP.LT.4) RETURN
      PRINT 1009
 1009 FORMAT('  MCB: -------------INFORMATION ON KINEMATICS-----------')
      XPOS = QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2-XM2
      XELE = QM(4)**2-QM(1)**2-QM(2)**2-QM(3)**2-XM2
      XMUP = PP(4)**2-PP(1)**2-PP(2)**2-PP(3)**2-XMU2
      XMUM = PM(4)**2-PM(1)**2-PM(2)**2-PM(3)**2-XMU2
      XW   = QKE**2-QKX**2-QKY**2-QKZ**2-W2
      PRINT 1010,XPOS,XELE,XMUP,XMUM,XW
 1010 FORMAT(' QP**2        = ',D35.25,' QM**2-XM2     = ',D35.25/
     .       ' PP**2-XMU2   = ',D35.25,' PM**2-XMU2    = ',D35.25/
     .       ' (PM+PP)**2-W2= ',D35.25)
      SUMX = QM(1)+QP(1)+PM(1)+PP(1)
      SUMY = QM(2)+QP(2)+PM(2)+PP(2)
      SUMZ = QM(3)+QP(3)+PM(3)+PP(3)
      SUME = 2-QM(4)-QP(4)-PM(4)-PP(4)
      PRINT 1011,SUMX,SUMY,SUMZ,SUME
 1011 FORMAT(' SUM X COMPONENTS   = ',D35.25,
     .       ' SUM Y COMPONENTS   = ',D35.25/
     .       ' SUM Z COMPONENTS   = ',D35.25,
     .       ' 2-SUM E COMPONENTS = ',D35.25)
      IF (IDUMP.LT.5) RETURN
      PRINT 2999
 2999 FORMAT(' MCB: ---------INFORMATION ON RANDOM NUMBERS------------')
      PRINT 3001,ETA1
 3001 FORMAT(' RANDOM NUMBER (W2)                = ',D35.25)
      PRINT 3002,ETA2
 3002 FORMAT(' RANDOM NUMBER (Y)                 = ',D35.25)
      PRINT 3003,ETA3
 3003 FORMAT(' RANDOM NUMBER (CK)                = ',D35.25)
      PRINT 3004,ETA4
 3004 FORMAT(' RANDOM NUMBER (FEYNMAN PARAMETER) = ',D35.25)
      PRINT 3005,ETA5
 3005 FORMAT(' RANDOM NUMBER (PHIR)              = ',D35.25)
      PRINT 3006,ETA6
 3006 FORMAT(' RANDOM NUMBER (CTG)               = ',D35.25)
      PRINT 3007,ETA7
 3007 FORMAT(' RANDOM NUMBER (PHIK)              = ',D35.25)
      PRINT 3008,ETA8
 3008 FORMAT(' RANDOM NUMBER (CMU)               = ',D35.25)
      PRINT 3009,ETA9
 3009 FORMAT(' RANDOM NUMBER (PHIM)              = ',D35.25)
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE MCC(IPROC,IDUMP)
c*************************************************************************
c
c...Conversion subgenerator
c
c... COMMON /MATRIX / CONTAINS :
c            XME(3) = EXACT CONVERSION /MATRIX ELEMENT/^2
c... COMMON /DIAG   / CONTAINS :
c            CALCULATED PHOTON PROPAGATORS AND INVARIANT MASS^2 MUONS
c            THESE VALUES ARE USED IN FUNCTION DIAG2
c
c*************************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEBOUND/  W2MIN,W2MAX
      COMMON /GG_EECHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /GG_EECONST/  ALFA,BARN,PI,TWOPI
      COMMON /GG_EEDIAG/   U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /GG_EEGENC/   XLC1,XLC2
      COMMON /GG_EEINIT/   PB,ET,EP(3),ECH(3)
      COMMON /GG_EEINPUT/  EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EELOG1/   OUTFL(4)
      COMMON /GG_EEMASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /GG_EEMATRIX/ XME(4)
      COMMON /GG_EEPROSTA/ PROP1,PROP2,PROP3,PROP4
      COMMON /GG_EESAP/    SAP(4),SAPT,CROSEC
      COMMON /GG_EESELECT/ IC,ICH
      COMMON /GG_EEVECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /GG_EEVECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /GG_EEWECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),IUNDFL(4),
     &                     INEG,IONE,IZERO
      COMMON /GG_EEWEIGHT/ WEIGHT(4),WEEV,IEVACC
      COMMON /GG_EEWESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),
     &                     IGEN
      LOGICAL OUTFL
      REAL*8 MWE,MAXWE
c
      OUTFL(3) = .FALSE.
C--------W2 GENERATION----------------------------------------------
      ETA1   = RNF100(1)
      HW2    = (W2MAX*(4.D0-W2MIN)/(W2MIN*(4.D0-W2MAX)))**ETA1*
     .          W2MIN/(4.D0-W2MIN)
      W2     = 4.D0*HW2/(1.D0+HW2)
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
C--------S1 GENERATION----------------------------------------------
      S1MIN  = 4.D0*XML2
      S1MAX  = (2.D0 - W)*(2.D0 - W)
      ETA2   = RNF100(2)
      HS1    = (S1MAX*(4.D0-W2-S1MIN)/(S1MIN*(4.D0-W2-S1MAX)))**ETA2
     .         *S1MIN/(4.D0-W2-S1MIN)
      S1     = HS1*(4.D0-W2)/(HS1+1.D0)
      WS1    = DSQRT(S1)
      XK0    = 1.D0 + O2 - S1/4.D0
      XKV2   = XK0*XK0-W2
      XKV    = DSQRT(XKV2)
C--------CK GENERATION----------------------------------------------
      AH     = -0.5D0*(4.D0 - W2 - S1)
      XLAM   = (4.D0 - W2 - S1)*(4.D0 - W2 - S1) - 4.D0*W2*S1
      WXLAM  = DSQRT(XLAM)
      BH     =  0.5D0*PB*WXLAM
      ABH    = 0.25D0*(XM2*XLAM+4.D0*W2*S1)/(AH-BH)
      ETA3   = RNF100(3)
      ETA    = 2.D0*ETA3 - 1.D0
      HCK    = (ABH/(AH-BH))**DABS(ETA)
      VK     = (ABH+(BH-AH)*HCK)/(BH*(HCK+1.D0))
      CK     = 1.D0 - VK
      IF (ETA.LT.0.D0) CK = -CK
      SK     = DSQRT(VK*(2.D0-VK))
C--------PHIK GENERATION-------------------------------------------
      ETA4   = RNF100(4)
      PHIK   = TWOPI*ETA4
      CPK    = DCOS(PHIK)
      SPK    = DSIN(PHIK)
C--------CONSTRUCTION 4MOMENTA QM+QK AND PM+PK---------------------
      XKX    = XKV*SK*CPK
      XKY    = XKV*SK*SPK
      XKZ    = XKV*CK
      QE     = 2.D0 - XK0
      QX     = -XKX
      QY     = -XKY
      QZ     = -XKZ
C--------GENERATION ELECTRON AND POSITRON IN THEIR CM SYSTEM-------
      ETA5   = RNF100(5)
      CP     = 2.D0*ETA5 - 1.D0
      SP     = DSQRT(1.D0-CP*CP)
      ETA6   = RNF100(6)
      PHIP   = TWOPI*ETA6
      CPP    = DCOS(PHIP)
      SPP    = DSIN(PHIP)
      EQCM   = 0.5D0*WS1
      PQCM   = DSQRT(EQCM*EQCM-XML2)
      QXCM   = PQCM*SP*CPP
      QYCM   = PQCM*SP*SPP
      QZCM   = PQCM*CP
C--------BOOST BACK TO LABORATORY SYSTEM-------------------------
      QM(4)  = (QE*EQCM+QX*QXCM+QY*QYCM+QZ*QZCM)/WS1
      FACQ   = (QM(4)+EQCM)/(QE+WS1)
      QM(1)  = QXCM  + FACQ*QX
      QM(2)  = QYCM  + FACQ*QY
      QM(3)  = QZCM  + FACQ*QZ
      QP(1)  = QX    - QM(1)
      QP(2)  = QY    - QM(2)
      QP(3)  = QZ    - QM(3)
      QP(4)  = QE    - QM(4)
C--------GENERATION OF MUON PAIR IN ITS CM SYSTEM-------------------
      ETA7   = RNF100(7)
      CMU    = 2.D0*ETA7 - 1.D0
      SMU    = DSQRT(1.D0-CMU*CMU)
      ETA8   = RNF100(8)
      PHIM   = TWOPI*ETA8
      CPMU   = DCOS(PHIM)
      SPMU   = DSIN(PHIM)
      EKCM   = O
      PKCM   = DSQRT(EKCM*EKCM-XMU2)
      PXCM   = PKCM*SMU*CPMU
      PYCM   = PKCM*SMU*SPMU
      PZCM   = PKCM*CMU
C--------BOOST BACK TO LABORATORY SYSTEM--------------------------
      PM(4)  = (XK0*EKCM+XKX*PXCM+XKY*PYCM+XKZ*PZCM)/W
      FACP   = (PM(4)+EKCM)/(XK0+W)
      PM(1)  = PXCM + FACP*XKX
      PM(2)  = PYCM + FACP*XKY
      PM(3)  = PZCM + FACP*XKZ
      PP(1)  = XKX  - PM(1)
      PP(2)  = XKY  - PM(2)
      PP(3)  = XKZ  - PM(3)
      PP(4)  = XK0  - PM(4)
C-------------------------------------------------------------------
      DO 5 I = 1,4
      QMB(I) = -QM(I)
      QPB(I) = -QP(I)
      PMB(I) = -PM(I)
      PPB(I) = -PP(I)
    5 CONTINUE
      DD7    = ABH - BH*VK
      DD8    = AH - BH + BH*VK
      IF (CK.GT.0.D0) GOTO 12
      DDU    = DD7
      DD7    = DD8
      DD8    = DDU
   12 CONTINUE
      PROP1  = S1*W2*DD7
      PROP2  = S1*W2*DD8
      PROP3  = 0.D0
      PROP4  = 0.D0
C
C-----CALCULATION OF 1/4(SPIN SUM) /M/^2----------------------
C
      U1     = S1
      U2     = W2
      U3     = 4.D0
      U4     = DD7
      U5     = DD8
      U6     = 0.D0
      U7     = 0.D0
      U8     = QPB(4) - QM(4)
      U9     = PMB(4) - PP(4)
      XME(3) = DIAG2(QPB, QM,XML,PMB, PP,XMU,P2B,P1B, XM,IDUMP)
C
C-----CALCULATTION APPROXIMATION-------------------------------
C
      XMP    = -32.D0*PB*XLC1*XLC2
     .         /(S1*W2*DD7*DD8*DLOG(ABH/(AH-BH))
     .         *DLOG(S1MAX*(4.D0-W2-S1MIN)/(S1MIN*(4.D0-W2-S1MAX)))
     .         *DSQRT(1.D0-4.D0*XML2/S1)*DSQRT(1.D0-4.D0*XMU2/W2))
C
      WE1    = XME(3)*DD7*DD8*W2*S1/32.D0
      WE2    = (4.D0-W2-S1)*XKV*DLOG(ABH/(AH-BH))/(AH*BH*XLC1)*
     .         DSQRT(1.D0-4.D0*XML2/S1)
      WE3    = DLOG(S1MAX*(4.D0-W2-S1MIN)/(S1MIN*(4.D0-W2-S1MAX)))/
     .         XLC2*DSQRT(1.D0-4.D0*XMU2/W2)
      WET    = WE1*WE2*WE3*XMP/XME(3)
      DO 199 I=1,4
      WEIGHT(I) = 0.D0
  199 CONTINUE
C
      WEIGHT(3) = XME(3)/(XMP*WBP(3))
      WEEV      = WEIGHT(3)
C
      IF (WEIGHT(3).GE.0.D0) GOTO 201
      IFAIL(3)  = IFAIL(3) + 1
      INEG      = INEG + 1
      IDUMP     = 5
  201 CONTINUE
C
      ICH   = 0
      IF (IPROC.NE.2.AND.IPROC.NE.5) GOTO 305
      ETA10 = RNF100(10)
      IF (ETA10.LT.0.5D0) GOTO 305
      CALL CHANGE(QM,PM)
      ICH   = 1
  305 CONTINUE
C
C-----START DUMP INFORMATION---------------------------------------
      IF (WEEV.GE.0.D0) GOTO 1081
      PRINT 1080,WEIGHT(3)
 1080 FORMAT(' $$$WARNING$$$ : WEIGHT < 0 : WEIGHT = ',D30.20)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      PRINT 1079
 1079 FORMAT ('0---------INFORMATION ON WEIGHTS------------------')
      PRINT 1082,XME(3),XMP,WEEV
 1082 FORMAT('0XME = ',D30.20,2X,'XMP = ',D30.20,2X,
     .       'WEIGHT = ',D30.20)
      IF (IDUMP.LT.2) RETURN
      PRINT 1083
 1083 FORMAT ('0----------INFORMATION ON ANGLES AND ENERGIES-----')
      PRINT 1084,W2,W,S1,WS1,XK0,XKV,VK,CK,DD7,DD8,XME(3)
 1084 FORMAT(' W2   = ',D30.20,7X,'W     = ',D30.20/
     .       ' S1   = ',D30.20,7X,'WS1   = ',D30.20/
     .       ' XK0  = ',D30.20,7X,'XKV   = ',D30.20/
     .       ' VK   = ',D30.20,7X,'CK    = ',D30.20/
     .       ' DD7  = ',D30.20,7X,'DD8   = ',D30.20/
     .       ' XME  = ',D30.20)
      IF (IDUMP.LT.3) RETURN
      PRINT 999
  999 FORMAT('0--------INFORMATION ON COMMON BLOCKS--------------')
      PRINT 1008,W2MIN,W2MAX
 1008 FORMAT(' COMMON BOUND CONTAINS '/1X,2(D35.25,2X))
      PRINT 1007,XM,XM2,XMU,XMU2,ALFA,BARN,PI,TWOPI
 1007 FORMAT(' COMMON CONST CONTAINS '/2(1X,3(D35.25,2X)/),
     .       1X,2(D35.25,2X))
      PRINT 1101,U1,U2,U3
 1101 FORMAT(' COMMON DIAG CONTAINS '/1X,3(D30.20,2X))
      PRINT 1102,XLC1,XLC2
 1102 FORMAT(' COMMON GENC CONTAINS '/1X,2(D30.20,2X))
      PRINT 1103,PB,ET,EP
 1103 FORMAT(' COMMON INIT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,3(D30.20,2X))
      PRINT 1002,EB,ESWE,WAP
 1002 FORMAT(' COMMON INPUT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,4(D30.20,2X))
      PRINT 1104,OUTFL
 1104 FORMAT(' COMMON LOG CONTAINS '/1X,4L9)
      PRINT 1105,XME
 1105 FORMAT(' COMMON MATRIX CONTAINS '/1X,4(D30.20,2X))
      PRINT 1106,SAP
 1106 FORMAT(' COMMON SAP CONTAINS '/1X,4(D30.20,2X))
      PRINT 1003,P1B,P2B,QMB,QPB,PMB,PPB
 1003 FORMAT(' COMMON VECTOB CONTAINS'/6(1X,4(D30.20,2X)/))
      PRINT 1004,P1,P2,QM,QP,PM,PP
 1004 FORMAT(' COMMON VECTOR CONTAINS '/6(1X,4(D30.20,2X)/))
      PRINT 1001,IFAIL,IACC,INUL,ICHG,INEG,IONE,IZERO
 1001 FORMAT(' COMMON WECOUN CONTAINS '/4(1X,4(I9,2X)/)/
     .       1X,3(I9,2X))
      PRINT 1005,WEIGHT,WEEV,IEVACC
 1005 FORMAT(' COMMON WEIGHT CONTAINS '/1X,4(D30.20,2X)/
     .       1X,D30.20,2X,I9)
      PRINT 1000,SWE,SWEK,MWE,SUM,SUMK,MAXWE,IWE,IGEN
 1000 FORMAT(' COMMON WESTAT CONTAINS '/3(1X,4(D30.20,2X)/),
     .       1X,3(D30.20,2X)/1X,5(I9,2X))
      IF (IDUMP.LT.4) RETURN
      PRINT 1009
 1009 FORMAT('0-------------INFORMATION ON KINEMATICS-----------')
      XPOS = QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2-XML2
      XELE = QM(4)**2-QM(1)**2-QM(2)**2-QM(3)**2-XML2
      XMUP = PP(4)**2-PP(1)**2-PP(2)**2-PP(3)**2-XMU2
      XMUM = PM(4)**2-PM(1)**2-PM(2)**2-PM(3)**2-XMU2
      XW   = XK0**2-XKX**2-XKY**2-XKZ**2-W2
      XQ   =  QE**2- QX**2- QY**2- QZ**2-S1
      PRINT 1010,XPOS,XELE,XMUP,XMUM,XW,XQ
 1010 FORMAT(' QP**2-XML2   = ',D35.25,' QM**2-XML2    = ',D35.25/
     .       ' PP**2-XMU2   = ',D35.25,' PM**2-XMU2    = ',D35.25/
     .       ' (PM+PP)**2-W2= ',D35.25,' (QM+QP)**2-S1 = ',D35.25)
      SUMX = QM(1)+QP(1)+PM(1)+PP(1)
      SUMY = QM(2)+QP(2)+PM(2)+PP(2)
      SUMZ = QM(3)+QP(3)+PM(3)+PP(3)
      SUME = 2-QM(4)-QP(4)-PM(4)-PP(4)
      PRINT 1011,SUMX,SUMY,SUMZ,SUME
 1011 FORMAT(' SUM X COMPONENTS   = ',D35.25,
     .       ' SUM Y COMPONENTS   = ',D35.25/
     .       ' SUM Z COMPONENTS   = ',D35.25,
     .       ' 2-SUM E COMPONENTS = ',D35.25)
      IF (IDUMP.LT.5) RETURN
      PRINT 2999
 2999 FORMAT('0---------INFORMATION ON RANDOM NUMBERS------------')
      PRINT 3001,ETA1
 3001 FORMAT(' RANDOM NUMBER (W2)              = ',D35.25)
      PRINT 3002,ETA2
 3002 FORMAT(' RANDOM NUMBER (S1)              = ',D35.25)
      PRINT 3003,ETA3
 3003 FORMAT(' RANDOM NUMBER (VK)              = ',D35.25)
      PRINT 3004,ETA4
 3004 FORMAT(' RANDOM NUMBER (PHIK)            = ',D35.25)
      PRINT 3005,ETA5
 3005 FORMAT(' RANDOM NUMBER (CP)              = ',D35.25)
      PRINT 3006,ETA6
 3006 FORMAT(' RANDOM NUMBER (PHIP)            = ',D35.25)
      PRINT 3007,ETA7
 3007 FORMAT(' RANDOM NUMBER (CMU)             = ',D35.25)
      PRINT 3008,ETA8
 3008 FORMAT(' RANDOM NUMBER (PHIM)            = ',D35.25)
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE MCD(IPROC,IDUMP)
c*************************************************************************
c
c  Annihilation subgenerator
c
c... COMMON /MATRIX / CONTAINS :
c            XME(4) = EXACT ANNIHILATION /MATRIX ELEMENT/^2
c... COMMON /DIAG   / CONTAINS :
c            CALCULATED PHOTON PROPAGATORS AND INVARIANT MASS^2 MUONS
c            THESE VALUES ARE USED IN FUNCTION DIAG2
c
c*************************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EECHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /GG_EECONST/  ALFA,BARN,PI,TWOPI
      COMMON /GG_EECOUNTD/ IPROD1,IPROD2
      COMMON /GG_EEDIAG/   U1,U2,U3,U4,U5,U6,U7,U8,U9
      COMMON /GG_EEGEND/   XLD1(2),SAPD(2)
      COMMON /GG_EEINIT/   PB,ET,EP(3),ECH(3)
      COMMON /GG_EEINPUT/  EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EELOG1/   OUTFL(4)
      COMMON /GG_EEMASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /GG_EEMATRIX/ XME(4)
      COMMON /GG_EEPROSTA/ PROP1,PROP2,PROP3,PROP4
      COMMON /GG_EESAP/    SAP(4),SAPT,CROSEC
      COMMON /GG_EESELECT/ IC,ICH
      COMMON /GG_EEVECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /GG_EEVECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
      COMMON /GG_EEWECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),IUNDFL(4),
     &                     INEG,IONE,IZERO
      COMMON /GG_EEWEIGHT/ WEIGHT(4),WEEV,IEVACC
      COMMON /GG_EEWESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),
     &                     IGEN
      DIMENSION PH(4)
      LOGICAL OUTFL,AFLAG
      REAL*8 MWE,MAXWE
c
      OUTFL(4) = .FALSE.
C........IF ETA11 > SAPD(2)/SAP(4) E+E- ANNIHILATES INTO E+E- ....
C........IF ETA11 < SAPD(2)/SAP(4) E+E- ANNIHILATES INTO MU+MU-...
      ETA11   = RNF100(IDUM)
      IF (ETA11.LT.SAPD(2)/SAP(4)) GOTO 15
C
      IPROD1 = IPROD1 + 1
      AFLAG  = .TRUE.
      XN1    = XML
      XN12   = XML2
      XN2    = XMU
      XN22   = XMU2
      CHFAC1 = QCHRG2
      CHFAC2 = QCHRG4
      CHFAC3 = QCHRG3
      GOTO 16
   15 CONTINUE
      IPROD2 = IPROD2 + 1
      AFLAG  = .FALSE.
      XN1    = XMU
      XN12   = XMU2
      XN2    = XML
      XN22   = XML2
      CHFAC1 = QCHRG4
      CHFAC2 = QCHRG2
      CHFAC3 = QCHRG3
   16 CONTINUE
C--------W2 GENERATION----------------------------------------------
      WSMIN  = 4.D0*XN22
      WSMAX  = 4.D0*(1.D0-XN1)*(1.D0-XN1)
      ETA1   = RNF100(1)
      W2     = (WSMAX/WSMIN)**ETA1*WSMIN
      W      = DSQRT(W2)
      O2     = W2/4.D0
      O      = W /2.D0
C--------X0 GENERATION----------------------------------------------
      XMIN   = XN1
      XMAX   = 1.D0 - XN1*O - O2
      ETA2   = RNF100(2)
      XE     = ((1.D0-XMIN)/(1.D0-XMAX))**ETA2*(1.D0-XMAX)
      X0     = 1.D0 - XE
      XV2    = X0*X0 - XN12
      XV     = DSQRT(XV2)
C--------Y GENERATION-----------------------------------------------
      HY     = 4.D0*XE + 2.D0*XN12 - W2
      DELT   = DSQRT(HY*HY-4.D0*(2.D0-X0)*(2.D0-X0)*XN12
     .              +4.D0*XV2*XN12)
      YMAX   = ((2.D0-X0)*HY+XV*DELT)/(2.D0*((2.D0-X0)*(2.D0-X0)-XV2))
      YMIN   = ((2.D0-X0)*HY-XV*DELT)/(2.D0*((2.D0-X0)*(2.D0-X0)-XV2))
      ETA3   = RNF100(3)
      YE     = ((1.D0-YMIN)/(1.D0-YMAX))**ETA3*(1.D0-YMAX)
      Y0     = 1.D0 - YE
      YV2    = Y0*Y0 - XN12
      YV     = DSQRT(YV2)
C--------CALCULATION COSINE OF ANGLE BETWEEN QM AND QP--------------
      CZ     = (HY-4.D0*Y0+2.D0*X0*Y0)/(2.D0*XV*YV)
      SZ     = DSQRT(1.D0-CZ*CZ)
C--------PHIP GENERATION--------------------------------------------
      ETA4   = RNF100(4)
      PHIP   = TWOPI*ETA4
      CPP    = DCOS(PHIP)
      SPP    = DSIN(PHIP)
C--------CM GENERATION----------------------------------------------
      ETA5   = RNF100(5)
      CM     = 2.D0*ETA5 - 1.D0
      SM     = DSQRT(1.D0-CM*CM)
      ETA6   = RNF100(6)
      PHIM   = TWOPI*ETA6
      CPM    = DCOS(PHIM)
      SPM    = DSIN(PHIM)
C--------CONSTRUCTION 4MOMENTA QM AND QK----------------------------
      QM(1)  = XV*SM*CPM
      QM(2)  = XV*SM*SPM
      QM(3)  = XV*CM
      QM(4)  = X0
      QP(1)  = YV*( CM*CPM*SZ*CPP-   SPM*SZ*SPP+SM*CPM*CZ    )
      QP(2)  = YV*( CM*SPM*SZ*CPP+   CPM*SZ*SPP+SM*SPM*CZ    )
      QP(3)  = YV*(-SM*    SZ*CPP+              CM*    CZ    )
      QP(4)  = Y0
      QKE    = 2.D0 - X0 - Y0
      QKX    = -QM(1) - QP(1)
      QKY    = -QM(2) - QP(2)
      QKZ    = -QM(3) - QP(3)
      S1     = 2.D0*XN12 + 2.D0*DOTGG(QM,QP)
      WS1    = DSQRT(S1)
C--------GENERATION OF MUON PAIR IN ITS CM SYSTEM-------------------
      ETA7   = RNF100(7)
      CMU    = 2.D0*ETA7 - 1.D0
      SMU    = DSQRT(1.D0-CMU*CMU)
      ETA8   = RNF100(8)
      PHIMU  = TWOPI*ETA8
      CPMU   = DCOS(PHIMU)
      SPMU   = DSIN(PHIMU)
      EKCM   = O
      PKCM   = DSQRT(EKCM*EKCM-XN22)
      PXCM   = PKCM*SMU*CPMU
      PYCM   = PKCM*SMU*SPMU
      PZCM   = PKCM*CMU
C--------BOOST BACK TO LABORATORY SYSTEM-----------------------------
      PM(4)  = (QKE*EKCM+QKX*PXCM+QKY*PYCM+QKZ*PZCM)/W
      FACP   = (PM(4)+EKCM)/(QKE+W)
      PM(1)  = PXCM + FACP*QKX
      PM(2)  = PYCM + FACP*QKY
      PM(3)  = PZCM + FACP*QKZ
      PP(1)  = QKX  - PM(1)
      PP(2)  = QKY  - PM(2)
      PP(3)  = QKZ  - PM(3)
      PP(4)  = QKE  - PM(4)
C-------------------------------------------------------------------
      DO 5 I = 1,4
      QMB(I) = -QM(I)
      QPB(I) = -QP(I)
      PMB(I) = -PM(I)
      PPB(I) = -PP(I)
    5 CONTINUE
      DDA    = 4.D0*(1.D0-X0)
      DDB    = 4.D0*(1.D0-Y0)
      DDC    = 4.D0*(1.D0-PM(4))
      DDD    = 4.D0*(1.D0-PP(4))
      PROP1  = 4.D0*S1*DDC
      PROP2  = 4.D0*S1*DDD
      PROP3  = 4.D0*W2*DDA
      PROP4  = 4.D0*W2*DDB
C
C-----CALCULATION OF 1/4(SPIN SUM) /M/^2----------------------
C
      U1     = 4.D0
      U2     = W2
      U3     = S1
      U4     = DDA
      U5     = DDB
      U6     = 0.D0
      U7     = 0.D0
      U8     = P1(4)  - P2B(4)
      U9     = PMB(4) - PP(4)
      XMD1   = DIAG2( P1,P2B, XM,PMB, PP,XN2, QM, QP,XN1,IDUMP)
C
      U1     = 4.D0
      U2     = S1
      U3     = W2
      U4     = DDC
      U5     = DDD
      U6     = 0.D0
      U7     = 0.D0
      U8     = P1(4)  - P2B(4)
      U9     = QMB(4) - QP(4)
      XMD2   = DIAG2( P1,P2B, XM,QMB, QP,XN1, PM, PP,XN2,IDUMP)
C
      U1     = W2
      U2     = S1
      U3     = 4.D0
      U4     = DDC
      U5     = DDD
      U6     = DDB
      U7     = DDA
      U8     = 0.D0
      U9     = 0.D0
      XMD3   = DIAG4(PPB, PM,XN2,QMB, QP,XN1,P2B,P1B, XM)
C
      XME(4) = XMD1*CHFAC1 + XMD2*CHFAC2 + XMD3*CHFAC3
C
C-----CALCULATION APPROXIMATION-----------------------------------
C
      SWMIN  = 4.D0*XN12
      SWMAX  = 4.D0*(1.D0-XN2)*(1.D0-XN2)
      AMIN   = XN2
      AMAX   = 1.D0 - 0.5D0*XN2*WS1 - 0.25D0*S1
      VX0    = PM(4)
      VXE    = 1.D0 - VX0
      VXV2   = VX0*VX0 - XN22
      VXV    = DSQRT(VXV2)
      VHY    = 4.D0*VXE + 2.D0*XN22 - S1
      VDELT  = DSQRT(VHY*VHY-4.D0*(2.D0-VX0)*(2.D0-VX0)*XN22
     .              +4.D0*VXV2*XN22)
      BMAX   = ((2.D0-VX0)*VHY+VXV*VDELT)/(2.D0*((2.D0-VX0)*
     .          (2.D0-VX0)-VXV2))
      BMIN   = ((2.D0-VX0)*VHY-VXV*VDELT)/(2.D0*((2.D0-VX0)*
     .          (2.D0-VX0)-VXV2))
      XMDP1  = 0.5D0/(W2*(1.D0-QM(4))*(1.D0-QP(4)))*
     .         DLOG(4.D0/WSMIN)*DLOG(4.D0/WSMIN)/
     .        (DLOG((1.D0-YMIN)/(1.D0-YMAX))*
     .         DLOG((1.D0-XMIN)/(1.D0-XMAX))*
     .         DSQRT(1.D0-4.D0*XN22/W2))
      XMDP2  = 0.5D0/(S1*(1.D0-PM(4))*(1.D0-PP(4)))*
     .         DLOG(4.D0/SWMIN)*DLOG(4.D0/SWMIN)/
     .        (DLOG((1.D0-BMIN)/(1.D0-BMAX))*
     .         DLOG((1.D0-AMIN)/(1.D0-AMAX))*
     .         DSQRT(1.D0-4.D0*XN12/S1))
C
      XMP    = XMDP1*CHFAC1 + XMDP2*CHFAC2
C
      ICHG(4) = 0
      IF (AFLAG) GOTO 18
      ICHG(4) = 1
      PROPU = PROP1
      PROP1 = PROP3
      PROP3 = PROPU
      PROPU = PROP2
      PROP2 = PROP4
      PROP4 = PROPU
c
      DO I=1,4
        PH(I)  = QM(I)
        QM(I)  = PM(I)
        PM(I)  = PH(I)
        PH(I)  = QP(I)
        QP(I)  = PP(I)
        PP(I)  = PH(I)
      END DO
c
   18 CONTINUE
C
      DO 199 I=1,4
        WEIGHT(I) = 0.D0
  199 CONTINUE
C
      WEIGHT(4) = XME(4)/(XMP*WBP(4))
      WEEV      = WEIGHT(4)
C
      IF (WEIGHT(4).GE.0.D0) GOTO 201
      IFAIL(4)  = IFAIL(4) + 1
      INEG      = INEG + 1
      IDUMP     = 5
  201 CONTINUE
C
      ICH   = 0
      IF (IPROC.NE.2.AND.IPROC.NE.5) GOTO 305
      ETA10 = RNF100(10)
      IF (ETA10.LT.0.5D0) GOTO 305
      CALL CHANGE(QM,PM)
      ICH   = 1
  305 CONTINUE
c
c-----START DUMP INFORMATION---------------------------------------
      IF (WEEV.GE.0.D0) GOTO 1081
      PRINT 1080,WEIGHT(4)
 1080 FORMAT(' $$$WARNING$$$ : WEIGHT < 0 : WEIGHT = ',D30.20)
 1081 CONTINUE
      IF (IDUMP.LT.1) RETURN
      PRINT 1079
 1079 FORMAT ('0---------INFORMATION ON WEIGHTS------------------')
      PRINT 1082,XME(4),XMP,WEEV
 1082 FORMAT('0XME = ',D30.20,2X,'XMP = ',D30.20,2X,
     .       'WEIGHT = ',D30.20)
      IF (IDUMP.LT.2) RETURN
      PRINT 1083
 1083 FORMAT ('0----------INFORMATION ON ANGLES AND ENERGIES-----')
      PRINT 1084,W2,W,X0,Y0,CZ,SZ,S1,QKE,DDA,DDB,XMD1,XMD2,XMD3,
     .           XMDP1,XMDP2
 1084 FORMAT(' W2   = ',D30.20,7X,'W     = ',D30.20/
     .       ' X0   = ',D30.20,7X,'Y0    = ',D30.20/
     .       ' CZ   = ',D30.20,7X,'SZ    = ',D30.20/
     .       ' S1   = ',D30.20,7X,'QKE   = ',D30.20/
     .       ' DDA  = ',D30.20,7X,'DDB   = ',D30.20/
     .       ' XMD1 = ',D30.20,7X,'XMD2  = ',D30.20/
     .       ' XMD3 = ',D30.20/
     .       ' XMDP1= ',D30.20,7X,'XMDP2 = ',D30.20)
      IF (IDUMP.LT.3) RETURN
      PRINT 999
  999 FORMAT('0--------INFORMATION ON COMMON BLOCKS--------------')
      PRINT 1007,XM,XM2,XMU,XMU2,ALFA,BARN,PI,TWOPI
 1007 FORMAT(' COMMON CONST CONTAINS '/2(1X,3(D35.25,2X)/),
     .       1X,2(D35.25,2X))
      PRINT 1101,U1,U2,U3
 1101 FORMAT(' COMMON DIAG CONTAINS '/1X,3(D30.20,2X))
      PRINT 1102,XLD1,SAPD
 1102 FORMAT(' COMMON GEND CONTAINS '/1X,4(D30.20,2X))
      PRINT 1103,PB,ET,EP
 1103 FORMAT(' COMMON INIT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,3(D30.20,2X))
      PRINT 1002,EB,ESWE,WAP
 1002 FORMAT(' COMMON INPUT CONTAINS '/1X,2(D30.20,2X)/
     .       1X,4(D30.20,2X))
      PRINT 1104,OUTFL
 1104 FORMAT(' COMMON LOG CONTAINS '/1X,4L9)
      PRINT 1105,XME
 1105 FORMAT(' COMMON MATRIX CONTAINS '/1X,4(D30.20,2X))
      PRINT 1106,SAP
 1106 FORMAT(' COMMON SAP CONTAINS '/1X,4(D30.20,2X))
      PRINT 1003,P1B,P2B,QMB,QPB,PMB,PPB
 1003 FORMAT(' COMMON VECTOB CONTAINS'/6(1X,4(D30.20,2X)/))
      PRINT 1004,P1,P2,QM,QP,PM,PP
 1004 FORMAT(' COMMON VECTOR CONTAINS '/6(1X,4(D30.20,2X)/))
      PRINT 1001,IFAIL,IACC,INUL,ICHG,INEG,IONE,IZERO
 1001 FORMAT(' COMMON WECOUN CONTAINS '/4(1X,4(I9,2X)/)/
     .       1X,3(I9,2X))
      PRINT 1005,WEIGHT,WEEV,IEVACC
 1005 FORMAT(' COMMON WEIGHT CONTAINS '/1X,4(D30.20,2X)/
     .       1X,D30.20,2X,I9)
      PRINT 1000,SWE,SWEK,MWE,SUM,SUMK,MAXWE,IWE,IGEN
 1000 FORMAT(' COMMON WESTAT CONTAINS '/3(1X,4(D30.20,2X)/),
     .       1X,3(D30.20,2X)/1X,5(I9,2X))
      IF (IDUMP.LT.4) RETURN
      PRINT 1009
 1009 FORMAT('0-------------INFORMATION ON KINEMATICS-----------')
      XPOS = QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2-XML2
      XELE = QM(4)**2-QM(1)**2-QM(2)**2-QM(3)**2-XML2
      XMUP = PP(4)**2-PP(1)**2-PP(2)**2-PP(3)**2-XMU2
      XMUM = PM(4)**2-PM(1)**2-PM(2)**2-PM(3)**2-XMU2
      XW   = QKE**2-QKX**2-QKY**2-QKZ**2-W2
      PRINT 1010,XPOS,XELE,XMUP,XMUM,XW
 1010 FORMAT(' QP**2-XML2  = ',D35.25,' QM**2-XML2    = ',D35.25/
     .       ' PP**2-XMU2  = ',D35.25,' PM**2-XMU2    = ',D35.25/
     .       ' (PM+PP)**2-W2= ',D35.25)
      SUMX = QM(1)+QP(1)+PM(1)+PP(1)
      SUMY = QM(2)+QP(2)+PM(2)+PP(2)
      SUMZ = QM(3)+QP(3)+PM(3)+PP(3)
      SUME = 2-QM(4)-QP(4)-PM(4)-PP(4)
      PRINT 1011,SUMX,SUMY,SUMZ,SUME
 1011 FORMAT(' SUM X COMPONENTS   = ',D35.25,
     .       ' SUM Y COMPONENTS   = ',D35.25/
     .       ' SUM Z COMPONENTS   = ',D35.25,
     .       ' 2-SUM E COMPONENTS = ',D35.25)
      IF (IDUMP.LT.5) RETURN
      PRINT 2999
 2999 FORMAT('0---------INFORMATION ON RANDOM NUMBERS------------')
      PRINT 3001,ETA1
 3001 FORMAT(' RANDOM NUMBER (W2)              = ',D35.25)
      PRINT 3002,ETA2
 3002 FORMAT(' RANDOM NUMBER (X0)              = ',D35.25)
      PRINT 3003,ETA3
 3003 FORMAT(' RANDOM NUMBER (Y0)              = ',D35.25)
      PRINT 3004,ETA4
 3004 FORMAT(' RANDOM NUMBER (PHIP)            = ',D35.25)
      PRINT 3005,ETA5
 3005 FORMAT(' RANDOM NUMBER (CM)              = ',D35.25)
      PRINT 3006,ETA6
 3006 FORMAT(' RANDOM NUMBER (PHIM)            = ',D35.25)
      PRINT 3007,ETA7
 3007 FORMAT(' RANDOM NUMBER (CMU)             = ',D35.25)
      PRINT 3008,ETA8
 3008 FORMAT(' RANDOM NUMBER (PHIMU)           = ',D35.25)
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE START
c************************************************************************
c
c   This subroutine performes the necessary initialization.
c   It should always be called before generating the first event.
c
c************************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEANGLE/  THPMIN,THPMAX,THMMIN,THMMAX,THMUMI,THMUMA
      COMMON /GG_EEBOUND / W2MIN,W2MAX
      COMMON /GG_EECHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
      COMMON /GG_EECONST/  ALFA,BARN,PI,TWOPI
      COMMON /GG_EEEDGE/   WDMIN,WDMAX,SDMIN,SDMAX
      COMMON /GG_EEFACTOR/ FACE,FACL,FACM,PROC
      COMMON /GG_EEGENA/   XLA1,XLA2,XLA3,XLA4(2),SAPA(2)
      COMMON /GG_EEGENB/   XLB1,XLB2(2),SAPB(2)
      COMMON /GG_EEGENC/   XLC1,XLC2
      COMMON /GG_EEGEND/   XLD1(2),SAPD(2)
      COMMON /GG_EEINIT/   PB,ET,EP(3),ECH(3)
      COMMON /GG_EEINPUT/  EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EEMASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /GG_EEMATRIX/ XME(4)
      COMMON /GG_EESAP/    SAP(4),SAPT,CROSEC         ! +
      COMMON /GG_EEVECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /GG_EEVECTOB/ P1B(4),P2B(4),QMB(4),QPB(4),PMB(4),PPB(4)
c-------------------------------------------------------------
c
      DUMM   = RNF100(-2)    ! Initialization of RNG ??
c
c..Natural constants.......................................
      PI     = 4.D0*DATAN(1.D0)
      TWOPI  = 2.D0*PI
      ALFA   = 1.D0/137.036D0
      ALFA4  = ALFA**4
      BARN   = 3.89385D+05/(EB*EB)
c
c..Central detector                      (is not used for generator)
c      C0     = DCOS(THETA0/180.D0*PI)
c
c..Beam four-momenta.......................................
      PB     = DSQRT(1.D0-XM2)
      ET     = 1.D0 + PB
c
c..Electron beam
      P1(1)  = 0.D0
      P1(2)  = 0.D0
      P1(3)  =  PB
      P1(4)  = 1.D0
c
c..Positron beam
      P2(1)  = 0.D0
      P2(2)  = 0.D0
      P2(3)  = -PB
      P2(4)  = 1.D0
C
      DO I = 1,4
        P1B(I) = -P1(I)
        P2B(I) = -P2(I)
      END DO
C
      SDMIN   = 4.D0*XML2
      SDMAX   = 4.D0*(1.D0-XMU)*(1.D0-XMU)
      WDMIN   = 4.D0*XMU2
      WDMAX   = 4.D0*(1.D0-XML)*(1.D0-XML)
C
      XLA1    = DLOG(16.D0/(XM2*(W2MIN-XM2)))
      XLA2    = DLOG(64.D0/(XM2*(W2MIN-XM2)**2))
      XLA3    = DLOG(2.D0*W2MIN/XMU2)
      XLA4(1) = DLOG((2.D0-XM)*(2.D0-XM)/W2MIN)
      XLA4(2) = 2.D0*XM/W2MIN/100.D0
      SAPA(1) = ALFA4*4.D0/PI*BARN*(1.D0/W2MIN-1.D0/W2MAX)*
     &          XLA1*XLA2*XLA3*XLA4(1)*WAP(1)*WBP(1)*VAP(1)*QCHRG4
      SAPA(2) = ALFA4*4.D0/PI*BARN*(1.D0/W2MIN-1.D0/W2MAX)*
     &          XLA1*XLA2*XLA3*XLA4(2)*WAP(1)*WBP(1)*VAP(1)*QCHRG4
c
c..Total approximate cross section for MCA
      SAP(1)  = SAPA(1) + SAPA(2)
c
      XLB1    = DLOG(16.D0/(XM2*W2MIN))
      XLB2(1) = DLOG(1.D0/XM2)
      XLB2(2) = DLOG(1.D0/XM )
      SAPB(1) = ALFA4*4.D0/PI*BARN*(1.D0/W2MIN-1.D0/W2MAX)*
     &          XLB1*XLB2(1)*WAP(2)*WBP(2)*VAP(2)*QCHRG2
      SAPB(2) = ALFA4*4.D0/PI*BARN*(1.D0/W2MIN-1.D0/W2MAX)*
     &          XLB1*XLB2(2)*WAP(2)*WBP(2)*VAP(2)*QCHRG2
c
c..Total approximate cross section for MCB
      SAP(2)  = SAPB(1) + SAPB(2)
c
      XLC1    = DLOG(4.D0/(W2MIN*XML2))
      XLC2    = DLOG(1.D0/(DSQRT(W2MIN)*XML2))
c
c..Total approximate cross section for MCC
      SAP(3)  = ALFA4*0.0625D0/PI*BARN*DLOG(W2MAX*(4.D0-W2MIN)/
     &          (W2MIN*(4.D0-W2MAX)))*XLC1*XLC2*WAP(3)*WBP(3)*
     &          VAP(3)*QCHRG2
c
      XLD1(1) = DLOG(4.D0/WDMIN)
      XLD1(2) = DLOG(4.D0/SDMIN)
      SAPD(1) = ALFA4/32.D0/PI*BARN*DLOG(WDMAX/WDMIN)*
     &          XLD1(1)**2*WAP(4)*WBP(4)*VAP(4)*QCHRG2
      SAPD(2) = ALFA4/32.D0/PI*BARN*DLOG(SDMAX/SDMIN)*
     &          XLD1(2)**2*WAP(4)*WBP(4)*VAP(4)*QCHRG4
c
c..Total approximate cross section for MCD
      SAP(4)  = SAPD(1) + SAPD(2)
c
      SAPT    = SAP(1) + SAP(2) + SAP(3) + SAP(4)
      EP(1)   =         SAP(1)/SAPT
      EP(2)   = EP(1) + SAP(2)/SAPT
      EP(3)   = EP(2) + SAP(3)/SAPT
c
      ECH(1)  = 0.25D0
      ECH(2)  = 0.5D0
      ECH(3)  = 0.75D0
c
c     print  2, XM,XM2,XMU,XMU2,PI,TWOPI,ALFA,BARN
c      IF(IREQAC.GT.1) 
c      print 3, EB,FACE,FACL,FACM,PROC,ESWE,ESFT
      PRINT 3,EB,FACE,FACL,FACM,PROC,ESWE,ESFT,WAP
      PRINT 4,WDMIN,WDMAX,SDMIN,SDMAX
      Wmin=EB*DSQRT(W2MIN)
      Wmax=EB*DSQRT(W2Max)
c      print  12, W2MIN,W2MAX,THMUMI,THMUMA
c      IF(IREQAC.GT.1)
      print 12, WMIN,WMAX,THMUMI,THMUMA
c     print  5, P1,P2
c      IF(IREQAC.GT.1)
      PRINT 6,SAPA,SAP(1),SAPB,SAP(2),SAP(3),SAPD,SAP(4)
c      print  7, EP
c
 2    FORMAT(  /,'........NATURAL CONSTANTS........'/
     .        2(1X,4(D19.6,2X)/))
 3    FORMAT(             /25X,'Input parameters:'//
     .        7X,'Beam energy                    = ',1PD12.3,' GeV'/
     .        7X,'Suppresion limit FACE          = ',1PD12.3/
     .        7X,'Suppresion limit FACL          = ',1PD12.3/
     .        7X,'Suppresion limit FACM          = ',1PD12.3/
     .        7X,'Suppresion limit PROC          = ',1PD12.3/
     .        7X,'Estimated maximum weight ESWE  = ',1PD12.3/
     .        7X,'Estimated maximum weight ESFT  = ',1PD12.3,/,
     .        7X,'Rel. importance subgenerator A = ',1PD12.3/
     .        7X,'Rel. importance subgenerator B = ',1PD12.3/
     .        7X,'Rel. importance subgenerator C = ',1PD12.3/
     .        7X,'Rel. importance subgenerator D = ',1PD12.3/
c     .        7X,'N of Events requested          = ',I10,//,
     .        1X,70(1H*))
 4    FORMAT(  /,7X,'WDMIN                    = ',1PD19.6/
     .           7X,'WDMAX                    = ',1PD19.6/
     .           7X,'SDMIN                    = ',1PD19.6/
     .           7X,'SDMAX                    = ',1PD19.6)
 5    FORMAT(  /,7X,'Electron beam four-momentum: '/
     .           1X,4(1pD30.20,2X)//
     .           7X,'Positron beam four-momentum: '/
     .           1X,4(1pD30.20,2X))
    6 FORMAT(  /,7X,'Approximate cross sections subgenerator A :,'//
     .           7X,'Region 1    = ',1pD19.6,' nb'/
     .           7X,'Region 2    = ',1pD19.6,' nb'/
     .           7X,'Total       = ',1pD19.6,' nb',//
     .           7X,'Approximate cross sections subgenerator B :,'//
     .           7X,'Region 1    = ',1pD19.6,' nb'/
     .           7X,'Region 2    = ',1pD19.6,' nb'/
     .           7X,'Total       = ',1pD19.6,' nb,'//
     .           7X,'Approximate cross sections subgenerator C :,'//
     .           7X,'Total       = ',1pD19.6,' nb'//
     .           7X,'Approximate cross sections subgenerator D :,'//
     .           7X,'Process 1   = ',1pD19.6,' nb'/
     .           7X,'Process 2   = ',1pD19.6,' nb'/
     .           7X,'Total       = ',1pD19.6,' nb')
 7    FORMAT(  /,7X,'EP(1) = ',1PD19.6/
     .           7X,'EP(2) = ',1PD19.6/
     .           7X,'EP(3) = ',1PD19.6)
 12   FORMAT(  /,7X,'Cuts defined by the user : '//
     .           7X,'Wmin       = ',1PD13.3,' GeV',/
     .           7X,'Wmax       = ',1PD13.3,' GeV',/
     .           7X,'THMUMI     = ',1PD13.3,' Deg',/
     .           7X,'THMUMA     = ',1PD13.3,' Deg',/)
c
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE FINIS3(IPROC,IREJEC)
c*************************************************************************
c
c... FINISH3 prints results on event generation,
c... information on cross section and event statistics.
c
c   Input: IPROC - process
c          IREJEC =1/2 - option
c
c*************************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EECOUNTA/ IREGA1,IREGA2
      COMMON /GG_EECOUNTB/ IREGB1,IREGB2,IREGC1,IREGC2,IPROB1,IPROB2
      COMMON /GG_EECOUNTD/ IPROD1,IPROD2
      COMMON /GG_EEFTSTAT/ SUMFT,SUMFT2,FTMAX,IEEN
      COMMON /GG_EEINPUT/  EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EESAP/    SAP(4),SAPT,CROSEC                   ! +
c     COMMON /GG_EETRANS/  IY
      COMMON /GG_EEWESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),
     &                     IGEN
      COMMON /GG_EEWECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),IUNDFL(4),
     &                     INEG,IONE,IZERO
      DIMENSION SDD(4),SIGMA(4),ERROR(4),EFF(4)
      REAL*8 MWE,MAXWE,MEAN(4),MEANT
c
c---------------------------------------------------------------
c
      DO 1 I = 1,4
        IF (IWE(I).EQ.0) GOTO 11
        MEAN(I)  = SWE(I)/DFLOAT(IWE(I))
        SDD(I)   = DSQRT(SWEK(I)-SWE(I)*SWE(I)/DFLOAT(IWE(I)))/
     .           DFLOAT(IWE(I))
        SIGMA(I) = MEAN(I)*SAP(I)
        ERROR(I) = SDD(I) *SAP(I)
        IF (MWE(I).NE.0.D0) EFF(I) = MEAN(I)/MWE(I)*100.D0
        GOTO 1
11      CONTINUE
        MEAN(I)  = 0.D0
        SDD(I)   = 0.D0
        SIGMA(I) = 0.D0
        ERROR(I) = 0.D0
1     CONTINUE
c
c---------------------------------------------------------------
c
      GOTO (101,102,103,104,105) ,IPROC
  101 PRINT 201
      GOTO 106
  102 PRINT 202
      GOTO 106
  103 PRINT 203
      GOTO 106
  104 PRINT 204
      GOTO 106
  105 PRINT 205
c
  106 CONTINUE
      PRINT 3
      IF (IREJEC.EQ.2.AND.MWE(1).GT.ESWE) PRINT 12
      PRINT 4,MWE(1),SWE(1),MEAN(1),SDD(1),SAP(1),SIGMA(1),ERROR(1),
     .        IWE(1),IACC(1),INUL(1),IFAIL(1),IUNDFL(1)
      PRINT 13,IREGA1,IREGA2
      IF (MWE(1).NE.0.D0) PRINT 10,EFF(1)
      PRINT 5
      IF (IREJEC.EQ.2.AND.MWE(2).GT.ESWE) PRINT 12
      PRINT 4,MWE(2),SWE(2),MEAN(2),SDD(2),SAP(2),SIGMA(2),ERROR(2),
     .        IWE(2),IACC(2),INUL(2),IFAIL(2),IUNDFL(2)
      PRINT 14,IREGB1,IREGB2,IREGC1,IREGC2,IPROB1,IPROB2
      IF (MWE(2).NE.0.D0) PRINT 10,EFF(2)
      PRINT 6
      IF (IREJEC.EQ.2.AND.MWE(3).GT.ESWE) PRINT 12
      PRINT 4,MWE(3),SWE(3),MEAN(3),SDD(3),SAP(3),SIGMA(3),ERROR(3),
     .        IWE(3),IACC(3),INUL(3),IFAIL(3),IUNDFL(3)
      IF (MWE(3).NE.0.D0) PRINT 10,EFF(3)
      PRINT 7
      IF (IREJEC.EQ.2.AND.MWE(4).GT.ESWE) PRINT 12
      PRINT 4,MWE(4),SWE(4),MEAN(4),SDD(4),SAP(4),SIGMA(4),ERROR(4),
     .        IWE(4),IACC(4),INUL(4),IFAIL(4),IUNDFL(4)
      PRINT 15,IPROD1,IPROD2
      IF (MWE(4).NE.0.D0) PRINT 10,EFF(4)
c
c------------------------------------------------------------------
c
      IF (IREJEC.EQ.1) GOTO 500
      MEANT  = SUM/DFLOAT(IGEN)
      SDDT   = DSQRT(SUMK-SUM*SUM/DFLOAT(IGEN))/DFLOAT(IGEN)
      SIGMAT = MEANT*SAPT
      ERRORT = SDDT *SAPT
c
c------------------------------------------------------------------
c
      PRINT 8
      PRINT 9,MAXWE,SUM,MEANT,SDDT,SAPT,SIGMAT,ERRORT,
     .        IGEN,IONE,IZERO,INEG
  500 CONTINUE
c
c------------------------------------------------------------------
c
      IF (IONE.EQ.0) GOTO 25
      XONE   = DFLOAT(IONE)
      FTMEAN = SUMFT/XONE
      FERROR = DSQRT(SUMFT2-SUMFT*SUMFT/XONE)/XONE
      GOTO (501,502) ,IREJEC
  501 CROSEC = FTMEAN*SAPT
      ERCROS = FERROR*SAPT
      GOTO 503
  502 CROSEC = FTMEAN*SIGMAT
      ERCROS = FTMEAN*ERRORT + FERROR*SIGMAT
  503 CONTINUE
c
c------------------------------------------------------------------
c
      IF (FTMAX.GT.ESFT) PRINT 504
      PRINT 20,FTMAX,SUMFT,FTMEAN,FERROR,CROSEC,ERCROS,IEEN
c
   25 CONTINUE
c
c------------------------------------------------------------------
c
    3 FORMAT(  /,2X,'Contribution from the multiperipheral ',
     .              'Feynman diagrams')
    4 FORMAT(  /,2X,'Maximum weight                  = ',1PD14.3/
     .           2X,'Sum of weights                  = ',1PD14.3/
     .           2X,'Mean weight                     = ',1PD14.3,
     .           2X,'+-',1PD11.3/
     .           2X,'Approximate cross section       = ',1PD14.3/
     .           2X,'Exact       cross section       = ',1PD14.3,
     .              '  +-',1PD11.3,' nb'/
     .           2X,'Generated events              = ',I10/
     .           2X,'Accepted  events              = ',I10/
     .           2X,'Events with weight = 0        = ',I10/
     .           2X,'Events with weight < 0        = ',I10/  
     .           2X,'Underflows                    = ',I10)
    5 FORMAT(  /,2X,'Contribution from the bremsstrahlung ',
     .              'Feynman diagrams')
    6 FORMAT(  /,2X,'Contribution from the two gamma conversion ',
     .              'Feynman diagrams')
    7 FORMAT(  /,2X,'Contribution from the annihilation ',
     .              'Feynman diagrams')
    8 FORMAT(  /,2X,'Total result')
    9 FORMAT(  /,2X,'Maximum of all weights         = ',1PD14.3/ 
     .           2X,'Sum of all weights             = ',1PD14.3/ 
     .           2X,'Mean of all weights            = ',1PD14.3,
     .           1X,'+-',1PD11.3/
     .           2X,'Total approx. cross section    = ',1PD14.3, 
     .              ' nb',/
     .           2X,'Total exact   cross section    = ',1PD14.3,
     .           1X,'+-',1PD11.3,' nb'/
     .           2X,' Generated events             = ',I9/ 
     .           2X,' Accepted events              = ',I9/   
     .           2X,' Events with weight = 0       = ',I9/ 
     .           2X,' Events with weight < 0       = ',I9)
   10 FORMAT(2X,'Efficiency                      = ',1PD14.3,    
     .          ' percent')
   12 FORMAT(' FINIS3: WARNING: estimated maximum weight ESWE',
     .       ' is too small')
   13 FORMAT(2X,'Events generated in region 1  = ',I9/
     .       2X,'Events generated in region 2  = ',I9)
   14 FORMAT(2X,'Events generated in region 1  = ',I9/
     .       2X,'Events generated in region 2  = ',I9/
     .       2X,'Events lie       in region 3  = ',I9/
     .       2X,'Events lie       in region 4  = ',I9/
     .       2X,'Events of process 1           = ',I9/
     .       2X,'Events of process 2           = ',I9)
   15 FORMAT(2X,'Events of process 1           = ',I9/
     .       2X,'Events of process 2           = ',I9)
   20 FORMAT(  /,70(1H*)//30X,'Final results'//          
     .           2X,'Maximum FTweight                = ',1PD13.3/
     .           2X,'Sum of FTweights                = ',1PD13.3/
     .           2X,'Mean FTweight                   = ',1PD13.3,
     .           1X,'+-',1PD11.3/                        
     .           2X,'Exact total cross section       = ',1PD13.3,
     .           1X,'+-',1PD11.3,' nb'/                  
     .           2X,'Unweighted events               = ',I9//
     .           ,70(1H*))                               
  201 FORMAT(/1x,70(1H-),///2X,'Results of the Monte Carlo simulation ',
     .              'of e+ e- ---> mu+ mu- l+ l-',//)
  202 FORMAT(/1x,70(1H-),///2X,'Results of the Monte Carlo simulation ',
     .              'of e+ e- ---> mu+ mu- mu+ mu-'/)
  203 FORMAT(/1x,70(1H-),///2X,'Results of the Monte Carlo simulation ',
     .              'of e+ e- ---> e+ e- mu+ mu-'/)
  204 FORMAT(/1x,70(1H-),///2X,'Results of the Monte Carlo simulation ',
     .              'of e+ e- ---> e+ e- l+ l-'/)
  205 FORMAT(/1x,70(1H-),///2X,'Results of the Monte Carlo simulation ',
     .              'of e+ e- ---> e+ e- e+ e-'/)
  504 FORMAT(' *****WARNING***** estimated maximum weight ESFT',
     .       ' is too small')
C
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      BLOCK DATA EE_TO_4E
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEREDUCE/ ISEL(6,3),ILZ(6,3,32)
      COMMON /GG_EECOUNTA/ IREGA1,IREGA2
      COMMON /GG_EECOUNTB/ IREGB1,IREGB2,IREGC1,IREGC2,IPROB1,IPROB2
      COMMON /GG_EECOUNTD/ IPROD1,IPROD2
      COMMON /GG_EEFTSTAT/ SUMFT,SUMFT2,FTMAX,IEEN
      COMMON /GG_EEWESTAT/ SWE(4),SWEK(4),MWE(4),SUM,SUMK,MAXWE,IWE(4),
     .                     IGEN
      COMMON /GG_EEWECOUN/ IFAIL(4),IACC(4),INUL(4),ICHG(4),IUNDFL(4),
     .                INEG,IONE,IZERO
      REAL*8 MWE,MAXWE
      DATA ISEL/18*0/,ILZ/576*0/
      DATA SWE/4*0.D0/,SWEK/4*0.D0/,MWE/4*0.D0/,SUM/0.D0/,SUMK/0.D0/,
     .     MAXWE/0.D0/,SUMFT/0.D0/,SUMFT2/0.D0/,FTMAX/0.D0/,
     .     IWE/4*0/,IFAIL/4*0/,IACC/4*0/,INUL/4*0/,IUNDFL/4*0/,
C    .     INEG/0/,IONE/0/,IZERO/0/,IEEN/0/,IY/6341/,
     .     INEG/0/,IONE/0/,IZERO/0/,IEEN/0/,
     .     IREGA1/0/,IREGA2/0/,IREGB1/0/,IREGB2/0/,IREGC1/0/,
     .     IREGC2/0/,IPROB1/0/,IPROB2/0/,IPROD1/0/,IPROD2/0/
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION DIAM(IPROC,INF)
c
c...Function DIAM calculates the complete MATRIX ELEMENT**2
c...for a given set of 4momenta (Q1,...Q6).
c...It uses SPINOX for initialization, GETRID for reduction
c...and for the actual calculation GRAAF.
c...Also results on subsets of Feynman graphs (multipheripheral,
c...bremsstrahlung, conversion and annihilation) are calculated.
c...Also the final weight is calculated. DIAM(5,INF) equals this
c...final weight.
c
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 DIAG,GRAAF,TEL
      COMMON /GG_EEINOUT/ B(6)
      COMMON /GG_EEINPUT/ EB,ESWE,ESFT,WAP(4),WBP(4),VAP(4)
      COMMON /GG_EEPRESTO/ TOTAAL,TCHANN,BREMSS,CONVER,ANNIHI
      COMMON /GG_EEREDUCE/ ISEL(6,3),ILZ(6,3,32)
      DIMENSION L(6)
      DIMENSION DIAG(6,6,64)
      DIMENSION AT(64),AM(4,64),AB(4,64),AC(2,64),AA(2,64)
      DIMENSION TCHANN(4),BREMSS(4),CONVER(2),ANNIHI(2)
C
C-----INITIALIZATION-------------------------------------------------
      DATA DIAG/2304*(0.D0,0.D0)/,AT/64*0.D0/,AM/256*0.D0/,
     .     AB/256*0.D0/,AC/128*0.D0/,AA/128*0.D0/
      DATA INIT/0/
c
      IF (INIT.NE.0) GOTO 001
      INIT = 1
      B(1) = -1.D0
      B(2) = -1.D0
      B(3) =  1.D0
      B(4) =  1.D0
      B(5) =  1.D0
      B(6) =  1.D0
  001 CONTINUE
c
      CALL SPINOX(INF)
c
      CALL GETRID(IPROC,INF)
C
      DO 9999 I1=2,2
      L(1)  = 2*I1 - 3
c
      DO 9999 I2=1,2
      L(2)  = 2*I2 - 3
c
      DO 9999 I3=1,2
      L(3)  = 2*I3 - 3
c
      DO 9999 I4=1,2
      L(4)  = 2*I4 - 3
c
      DO 9999 I5=1,2
      L(5)  = 2*I5 - 3
c
      DO 9999 I6=1,2
      L(6)  = 2*I6 - 3
      LZ  = 33 - 16*L(1) - 8*L(2) - 4*L(3) - 2*L(4) -
     .              L(5) - (L(6)+1)/2
c
      DO 9998 IGR = 1,6
c
      CALL GROUP(IGR,K1,K2,K3,K4,K5,K6,IREL)
c
      DO 9997 IPER = 1,6
C
      CALL PERMU(IPER,K1,K2,K3,K4,K5,K6,J1,J2,J3,J4,J5,J6)
C
      DIAG(IGR,IPER,LZ) = (0.D0,0.D0)
      XSEL = CHOICE(IPROC,IGR,IPER)
      IF (XSEL.EQ.0.D0) GOTO 9997
      JPER = (IPER+1)/2
      IF (ISEL(IGR,JPER   ).EQ.0) GOTO 9997
      IF ( ILZ(IGR,JPER,LZ).EQ.0) GOTO 9997
      DIAG(IGR,IPER,LZ) = DFLOAT(IREL)*XSEL*
     . GRAAF(J1,L(J1),J2,L(J2),J3,L(J3),
     .                J4,L(J4),J5,L(J5),J6,L(J6),INF)
C
      IF (INF.GE.2) print  2, L,LZ,IGR,IPER,LZ,DIAG(IGR,IPER,LZ)
    2 FORMAT('0 DIAG ARRAY CONTENTS : '/
     .       '  L(I),LZ = ',7I4/
     .       '  DIAG(',I2,',',I2,',',I2,') = ',2D15.6/)
 9997 CONTINUE
 9998 CONTINUE
c
c CALCULATE TOTAL AND SUBTOTAL SQUARES OF AMPLITUDES
c
      TEL=(0.D0,0.D0)
c
      DO 330 IG=1,6
      DO 330 IP=1,6
      TEL = TEL + DIAG(IG,IP,LZ)
  330 CONTINUE
c
      AT(LZ) = CDABS(TEL)**2
C
      AM(1,LZ) = CDABS( DIAG( 6, 3,LZ) + DIAG( 6, 4,LZ) )**2
      AM(2,LZ) = CDABS( DIAG( 5, 3,LZ) + DIAG( 5, 4,LZ) )**2
      AM(3,LZ) = CDABS( DIAG( 4, 1,LZ) + DIAG( 4, 2,LZ) )**2
      AM(4,LZ) = CDABS( DIAG( 3, 1,LZ) + DIAG( 3, 2,LZ) )**2
C
      AB(1,LZ) = CDABS( DIAG( 6, 1,LZ) + DIAG( 6, 2,LZ)
     .                + DIAG( 6, 5,LZ) + DIAG( 6, 6,LZ) )**2
      AB(2,LZ) = CDABS( DIAG( 5, 1,LZ) + DIAG( 5, 2,LZ)
     .                + DIAG( 5, 5,LZ) + DIAG( 5, 6,LZ) )**2
      AB(3,LZ) = CDABS( DIAG( 4, 3,LZ) + DIAG( 4, 4,LZ)
     .                + DIAG( 4, 5,LZ) + DIAG( 4, 6,LZ) )**2
      AB(4,LZ) = CDABS( DIAG( 3, 3,LZ) + DIAG( 3, 4,LZ)
     .                + DIAG( 3, 5,LZ) + DIAG( 3, 6,LZ) )**2
C
      AC(1,LZ) = CDABS( DIAG( 1, 5,LZ) + DIAG( 1, 6,LZ) )**2
      AC(2,LZ) = CDABS( DIAG( 2, 5,LZ) + DIAG( 2, 6,LZ) )**2
C
      AA(1,LZ) = CDABS( DIAG( 1, 1,LZ) + DIAG( 1, 2,LZ)
     .                + DIAG( 1, 3,LZ) + DIAG( 1, 4,LZ) )**2
      AA(2,LZ) = CDABS( DIAG( 2, 1,LZ) + DIAG( 2, 2,LZ)
     .                + DIAG( 2, 3,LZ) + DIAG( 2, 4,LZ) )**2
C
      IF(INF.GE.2) print  329, AT(LZ),(AM(M4,LZ),M4=1,4),
     . (AB(M4,LZ),M4=1,4),(AC(M2,LZ),M2=1,2),(AA(M2,LZ),M2=1,2)
  329 FORMAT(' CONTRIBUTIONS: TOT,M,B,C,A :',D15.6/2(6(D15.6,2X)/))
 9999 CONTINUE
C
C SUM OVER HELICITIES
      TOTAAL = 0.D0
c
      DO 9996 M2=1,2
      M4 = M2+ 2
      TCHANN(M2) = 0.D0
      TCHANN(M4) = 0.D0
      BREMSS(M2) = 0.D0
      BREMSS(M4) = 0.D0
      CONVER(M2) = 0.D0
      ANNIHI(M2) = 0.D0
 9996 CONTINUE
c
      DO 331 LHEL=1,64
      TOTAAL = TOTAAL + AT(LHEL)
c
      DO 331 M2=1,2
      M4 = M2 + 2
      TCHANN(M2) = TCHANN(M2) + AM(M2,LHEL)
      TCHANN(M4) = TCHANN(M4) + AM(M4,LHEL)
      BREMSS(M2) = BREMSS(M2) + AB(M2,LHEL)
      BREMSS(M4) = BREMSS(M4) + AB(M4,LHEL)
      CONVER(M2) = CONVER(M2) + AC(M2,LHEL)
      ANNIHI(M2) = ANNIHI(M2) + AA(M2,LHEL)
  331 CONTINUE
c
c  Select your favorite process.
c  Factor 1/2 takes averaging over e+e- spins into account.
c
      TOTAAL = 0.5D0*TOTAAL
c
      DO 333 M2=1,2
      M4 = M2 + 2
      TCHANN(M2) = 0.5D0*TCHANN(M2)*WAP(1)
      TCHANN(M4) = 0.5D0*TCHANN(M4)*WAP(1)
      BREMSS(M2) = 0.5D0*BREMSS(M2)*WAP(2)
      BREMSS(M4) = 0.5D0*BREMSS(M4)*WAP(2)
      CONVER(M2) = 0.5D0*CONVER(M2)*WAP(3)
      ANNIHI(M2) = 0.5D0*ANNIHI(M2)*WAP(4)
  333 CONTINUE
c
      IF (INF.GE.1) print  332, TOTAAL,TCHANN,BREMSS,CONVER,ANNIHI
  332 FORMAT('0---------------- FINALLY : --------------'/
     .       ' SUM OF ALL FEYNMAN DIAGRAMS =',D15.6/
     .       ' MULTIPERIPHERAL GRAPHS ONLY =',4(D15.6,2X)/
     .       '  BREMSSTRAHLUNG GRAPHS ONLY =',4(D15.6,2X)/
     .       '  TWO-PHOTON CONVERSION ONLY =',2(D15.6,2X)/
     .       '   ANNIHILATION CHANNEL ONLY =',2(D15.6,2X))
      GOTO (1001,1002,1003,1004,1005) , IPROC
 1001 SUM1 = CONVER(1)+ANNIHI(1)
      DIAM = TOTAAL/SUM1
      RETURN
 1002 SUM2 = CONVER(1)+CONVER(2)+ANNIHI(1)+ANNIHI(2)
      DIAM = TOTAAL/SUM2
      RETURN
 1003 SUM3 = TCHANN(1)+BREMSS(1)+CONVER(1)+ANNIHI(1)
      DIAM = TOTAAL/SUM3
      RETURN
 1004 SUM4 = TCHANN(1)+BREMSS(1)+CONVER(1)+ANNIHI(1)
      DIAM = TOTAAL/SUM4
      RETURN
 1005 SUM5 = TCHANN(1)+TCHANN(2)+TCHANN(3)+TCHANN(4)+
     .       BREMSS(1)+BREMSS(2)+BREMSS(3)+BREMSS(4)+
     .       CONVER(1)+CONVER(2)+
     .       ANNIHI(1)+ANNIHI(2)
      DIAM = TOTAAL/SUM5
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION DIAG2(P1,Q1,M1,P2,Q2,M2,P3,Q3,M3,IDUMP)
c************************************************************************
c
c... DIAG2 calculates the MATRIX ELEMENT^2 of two gauge
c    invariant Feinman diagrams.
c... DIAG2 is used in MCA, MCB, MCC and MCD to calculate XME.
c
c************************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEDIAG/ T1,T2,W2,DD1,DD2,DD3,DD4,R14,R24
      REAL*8 M1,M2,M3,M1K,M2K,M3K
      DIMENSION P1(4),Q1(4),P2(4),Q2(4),P3(4),Q3(4),
     .          D1(4),D2(4),E1(4),E2(4),R1(4),R2(4)
C-------------------------------------------------------------------
      M1K=M1*M1
      M2K=M2*M2
      M3K=M3*M3
      IF (IDUMP.EQ.5) print  99, T1,T2,W2,DD1,DD2,DD3,DD4,R14,R24
c
      DO 1 I=1,4
      D1(I) = P1(I) + Q1(I)
      D2(I) = P2(I) + Q2(I)
      R1(I) = P1(I) - Q1(I)
      R2(I) = P2(I) - Q2(I)
    1 CONTINUE
c
      IF (IDUMP.EQ.5) print  100, R1(4),R2(4)
      Z1    = - D1(4)/R14
      Z2    = - D2(4)/R24
c
      IF (IDUMP.EQ.5) print  101, R14,R24
      DO 2 I=1,4
      E1(I) = D1(I) + Z1*R1(I)
      E2(I) = D2(I) + Z2*R2(I)
    2 CONTINUE
c
C-------------------------------------------------------------------
C      T1    = DOTGG(R1,R1)
C      T2    = DOTGG(R2,R2)
C      W2    = DOTGG(P3,Q3)*2.D0+2.D0*M3K
      Q11   = DOTGG(P3,D1)
      Q12   = DOTGG(P3,D2)
      Q21   = DOTGG(Q3,D1)
      Q22   = DOTGG(Q3,D2)
      P11   = DOTGG(P3,E1)-0.5D0*Z1*T1
      P12   = DOTGG(P3,E2)-0.5D0*Z2*T2
      P21   = DOTGG(Q3,E1)-0.5D0*Z1*T1
      P22   = DOTGG(Q3,E2)-0.5D0*Z2*T2
      D     = DOTGG(E1,E2)
      D0    = DOTGG(D1,D2)
c
      IF (IDUMP.EQ.5) print  102, D,D0
C      DD1   = T1-2.D0*DOTGG(P3,R1)
C      DD2   = T2-2.D0*DOTGG(P3,R2)
C-------------------------------------------------------------------
      XM1   = (P11*P11+T1*(0.25D0*T1+M3K+M1K))*
     .        (P22*P22+T2*(0.25D0*T2+M3K+M2K))
c
      IF (IDUMP.EQ.5) print  103, XM1
      XM2   = (P21*P21+T1*(0.25D0*T1+M3K+M1K))*
     .        (P12*P12+T2*(0.25D0*T2+M3K+M2K))
c
      IF (IDUMP.EQ.5) print  104, XM2
      XM3   = 2.D0*P11*P12*P21*P22+D*DD1*P12*P21+D*DD2*P11*P22+
     .        0.25D0*D*D*DD1*DD2-M1K*M2K*(T1+T2-W2)**2-
     .        2.D0*P11*P21*T2*(0.25D0*T2+M3K+M2K)-
     .        2.D0*P12*P22*T1*(0.25D0*T1+M3K+M1K)-
     .        M1K*T2*(Q12+Q22)**2-M2K*T1*(Q11+Q21)**2-
     .        0.25D0*(DD1-DD2)**2*(M2K*T1+M1K*T2)
c
      IF (IDUMP.EQ.5) print  105, XM3
      XM4   = 0.0625D0*T1*T2*(-4.D0*(Q11-Q21)**2-4.D0*(Q12-Q22)**2-
     .        4.D0*D0*D0-(W2+T1+T2)**2-16.D0*(W2-T1-T2)*M3K-
     .        16.D0*W2*(M1K+M2K)+
     .        32.D0*(0.25D0*T1-M1K-M3K)*(0.25D0*T2-M2K-M3K))
c
      IF (IDUMP.EQ.5) print  106, XM4
      IF (IDUMP.EQ.5) print  108, DD1,DD2,T1,T2
c
c-------------------------------------------------------------------
c
      DIAG2  = -(XM1/DD1/DD1+XM2/DD2/DD2+(XM3+XM4)/DD1/DD2)/
     .          T1/T2/T1/T2*32.D0
c
      IF (IDUMP.EQ.5) print  107, DIAG2
c
   99 FORMAT(' DIAG2: COMMON /DIAG/ = '/5(1X,2(D35.25,2X)/))
  100 FORMAT(' DIAG2: R1(4) R2(4) = ',2(D35.25,2X))
  101 FORMAT(' DIAG2: R14 R24     = ',2(D35.25,2X))
  102 FORMAT(' DIAG2: D D0 = ',2(D35.25,2X))
  103 FORMAT(' DIAG2: XM1 = ',D35.25)
  104 FORMAT(' DIAG2: XM2 = ',D35.25)
  105 FORMAT(' DIAG2: XM3 = ',D35.25)
  106 FORMAT(' DIAG2: XM4 = ',D35.25)
  107 FORMAT(' DIAG2 = ',D35.25)
  108 FORMAT(' DIAG2: DD1,DD2,T1,T2=',/,2(1x,2D35.25/))
c
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION DIAG4(P1,Q1,M1,P2,Q2,M2,P3,Q3,M3)
c***********************************************************************
c
c...Interference calculation between 4 bremsstrahlung or
c...annihilation graphs. (More precisely: the interference between
c...bremsstrahlung from the electron and bremsstrahlung from the
c...positron line.)
c...DIAG4 is used in MCB and MCD.
c
c***********************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 M1,M2,M3,M1K,M2K,M3K,M12
      COMMON /GG_EEDIAG/ T1,T2,W2,D3,D4,D5,D6,U8,U9
      DIMENSION P1(4),Q1(4),P2(4),Q2(4),P3(4),Q3(4),E(4)
C------------------------------------------------------------------
      M1K  = M1*M1
      M2K  = M2*M2
      M3K  = M3*M3
      M12  = M1K+M2K
C------------------------------------------------------------------
      DO 1 I=1,4
        E(I) = Q3(I) - P3(I)
    1 CONTINUE
c
      DP1P2  = DOTGG(P1,P2)
      DQ1Q2  = DOTGG(Q1,Q2)
      DP1Q2  = DOTGG(P1,Q2)
      DP2Q1  = DOTGG(P2,Q1)
      DP1Q1  = DOTGG(P1,Q1)
      DP2Q2  = DOTGG(P2,Q2)
C------------------------------------------------------------------
      S      =  2.D0*DP1P2+M12
      SE     =  2.D0*DP1P2
      SW     =  2.D0*DP1P2-M12
      U1     = -2.D0*DP1Q2+M12
      U1E    = -2.D0*DP1Q2
      U1W    = -2.D0*DP1Q2-M12
      U2     = -2.D0*DP2Q1+M12
      U2E    = -2.D0*DP2Q1
      U2W    = -2.D0*DP2Q1-M12
      S1     =  2.D0*DQ1Q2+M12
      S1E    =  2.D0*DQ1Q2
      S1W    =  2.D0*DQ1Q2-M12
C      T1     = -2.D0*DP1Q1+2.D0*M1K
C      T2     = -2.D0*DP2Q2+2.D0*M2K
C      W2     =  2.D0*M3K + 2.D0*DOTGG(P3,Q3)
c
      P11    =  DOTGG(E,P2)
      P12    =  DOTGG(E,P1)
      P21    =  DOTGG(E,Q2)
      P22    =  DOTGG(E,Q1)
C------------------------------------------------------------------
C      D3     =  SE  + U1E + T2
C      D4     =  S1E + U2E + T2
C      D5     =  SE  + U2E + T1
C      D6     =  S1E + U1E + T1
C------------------------------------------------------------------
      X1 = 32.D0*(P11+P21)*(P12+P22)
     .   + 32.D0*((SW *SW +U1W*U2W-2.D0*M12*M12)*P22*P21-
     .             W2*(M1K*P11*P22+M2K*P12*P21))/(D3*D5)
     .   + 32.D0*((U1W*U1W+SW *S1W-2.D0*M12*M12)*P11*P22-
     .             W2*(M1K*P21*P22+M2K*P11*P12))/(D3*D6)
     .   + 32.D0*((U2W*U2W+SW *S1W-2.D0*M12*M12)*P12*P21-
     .             W2*(M1K*P11*P12+M2K*P21*P22))/(D4*D5)
     .   + 32.D0*((S1W*S1W+U1W*U2W-2.D0*M12*M12)*P11*P12-
     .             W2*(M1K*P12*P21+M2K*P11*P22))/(D4*D6)
      X2 = 16.D0*W2*((P11+P12)**2+(P12-P21)**2)*
     .     (SE/(D3*D5)-U1E/(D3*D6)-U2E/(D4*D5)+S1E/(D4*D6))
      X3 = -32.D0*(SW *P22*(P11+P12)+U1W*P22*(P11-P22))/D3
     .     -32.D0*(S1W*P12*(P21+P22)+U2W*P12*(P21-P12))/D4
     .     -32.D0*(SW *P21*(P11+P12)-U2W*P21*(P11-P22))/D5
     .     -32.D0*(S1W*P11*(P21+P22)-U1W*P11*(P21-P12))/D6
      X4 = 8.D0*W2*(SE*SE+U1E*U1E+U2E*U2E+S1E*S1E)*
     .     (SE/(D3*D5)-U1E/(D3*D6)-U2E/(D4*D5)+S1E/(D4*D6))
      X5 = 4.D0*(4.D0*M3K-W2)*((S-S1)**2-(U1-U2)**2)*
     .     (T2/(D3*D4)+T1/(D5*D6))
      X6 = -8.D0*(4.D0*M3K+W2)*W2*T1*T2*((S-S1)**2-(U1-U2)**2)/
     .     (D3*D4*D5*D6)
      X7 = 16.D0*W2*M12*(T1+T2+W2)*
     .     (SE/(D3*D5)-U1E/(D3*D6)-U2E/(D4*D5)+S1E/(D4*D6))
      X8 = -32.D0*M1K*W2*(S -U1)/D3
     .     -32.D0*M1K*W2*(S1-U2)/D4
     .     -32.D0*M2K*W2*(S -U2)/D5
     .     -32.D0*M2K*W2*(S1-U1)/D6
      X9 = 4.D0*(4.D0*M3K-W2)*(W2*(S1-S )+(T1-T2)*(U1-U2))*SE /(D3*D5)
     .    -4.D0*(4.D0*M3K-W2)*(W2*(U2-U1)+(T1-T2)*(S -S1))*U1E/(D3*D6)
     .    -4.D0*(4.D0*M3K-W2)*(W2*(U1-U2)+(T1-T2)*(S1-S ))*U2E/(D4*D5)
     .    +4.D0*(4.D0*M3K-W2)*(W2*(S -S1)+(T1-T2)*(U2-U1))*S1E/(D4*D6)
C------------------------------------------------------------------
      DIAG4 = (X1+X2+X3+X4+X5+X6+X7+X8+X9)/(T1*T2*W2*W2)
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION DOTGG(A,B)
c-------------------------------------------------------------------
c  DOTGG PRODUCT OF FOUR-VECTORS IN MINKOWSKI METRIC
c-------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION A(4),B(4)
      DOTGG   = A(4)*B(4)-A(1)*B(1)-A(2)*B(2)-A(3)*B(3)
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE GETRID(IPROC,INF)
c
c...GETRID determines which of the suppressed spin configurations
c...will be omitted during the summation of the exact
c...|MATRIX ELEMENT|**2 over all the possible spin configurations.
c...This speeds up the calculation of the final weight considerably.
c
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEMASSES/ XM,XMU,XML,XM2,XMU2,XML2
      COMMON /GG_EEPROP1/ PROP(6,3)
      COMMON /GG_EEREDUCE/ ISEL(6,3),ILZ(6,3,32)
      COMMON /GG_EEVECTOR/ P1(4),P2(4),QM(4),QP(4),PM(4),PP(4)
      COMMON /GG_EEFACTOR/ FCE,FCL,FCM,PROC
      DIMENSION VP1QM(4),VP2QP(4),VP1PM(4),VP2PP(4),
     .          SQMQP(4),SQMPP(4),SPMQP(4),SPMPP(4)
      DIMENSION I12(3),J12(32),I34(3),J34(32),I56(3),J56(32),
     .          I45(3),J45(32),I36(3),J36(32),I13(3),J13(32),
     .          I26(3),J26(32),I15(3),J15(32),I24(3),J24(32)
      DIMENSION II(6,8,32),IT(3)
c
      DATA J12/1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
     .         0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0/
      DATA J34/1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1,
     .         1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1/
      DATA J56/1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1,
     .         1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,1/
      DATA J45/1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1,
     .         1,1,0,0,0,0,1,1,1,1,0,0,0,0,1,1/
      DATA J36/1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1,
     .         1,0,1,0,1,0,1,0,0,1,0,1,0,1,0,1/
      DATA J13/1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,
     .         1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0/
      DATA J26/1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,
     .         0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1/
      DATA J15/1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,
     .         1,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0/
      DATA J24/1,1,1,1,0,0,0,0,1,1,1,1,0,0,0,0,
     .         0,0,0,0,1,1,1,1,0,0,0,0,1,1,1,1/
C
      DATA INIT/0/
c
      IF (INIT.NE.0) GOTO 1
      INIT = 1
      FACE = FCE*XM2
      FACM = FCM*XMU2
      FACL = FCL*XML2
c
      DO 2 J=1,32
      II(1,1,J) = 1
      II(1,2,J) = J56(J)
      II(1,3,J) = J34(J)
      II(1,4,J) = J56(J)*J34(J)
      II(1,5,J) = J12(J)
      II(1,6,J) = J56(J)*J12(J)
      II(1,7,J) = J34(J)*J12(J)
      II(1,8,J) = II(1,7,J)*J56(J)
      II(2,1,J) = 1
      II(2,2,J) = J36(J)
      II(2,3,J) = J45(J)
      II(2,4,J) = J36(J)*J45(J)
      II(2,5,J) = J12(J)
      II(2,6,J) = J36(J)*J12(J)
      II(2,7,J) = J45(J)*J12(J)
      II(2,8,J) = II(2,7,J)*J36(J)
      II(3,1,J) = 1
      II(3,2,J) = J26(J)
      II(3,3,J) = J45(J)
      II(3,4,J) = J26(J)*J45(J)
      II(3,5,J) = J13(J)
      II(3,6,J) = J26(J)*J13(J)
      II(3,7,J) = J45(J)*J13(J)
      II(3,8,J) = II(3,7,J)*J26(J)
      II(4,1,J) = 1
      II(4,2,J) = J26(J)
      II(4,3,J) = J34(J)
      II(4,4,J) = J26(J)*J34(J)
      II(4,5,J) = J15(J)
      II(4,6,J) = J26(J)*J15(J)
      II(4,7,J) = J34(J)*J15(J)
      II(4,8,J) = II(4,7,J)*J26(J)
      II(5,1,J) = 1
      II(5,2,J) = J36(J)
      II(5,3,J) = J24(J)
      II(5,4,J) = J36(J)*J24(J)
      II(5,5,J) = J15(J)
      II(5,6,J) = J36(J)*J15(J)
      II(5,7,J) = J24(J)*J15(J)
      II(5,8,J) = II(5,7,J)*J36(J)
      II(6,1,J) = 1
      II(6,2,J) = J56(J)
      II(6,3,J) = J24(J)
      II(6,4,J) = J56(J)*J24(J)
      II(6,5,J) = J13(J)
      II(6,6,J) = J56(J)*J13(J)
      II(6,7,J) = J24(J)*J13(J)
      II(6,8,J) = II(6,7,J)*J56(J)
    2 CONTINUE
c
    1 CONTINUE
c
      DO 4 I=1,4
      VP1QM(I) = P1(I) - QM(I)
      VP2QP(I) = P2(I) - QP(I)
      VP1PM(I) = P1(I) - PM(I)
      VP2PP(I) = P2(I) - PP(I)
      SQMQP(I) = QM(I) + QP(I)
      SQMPP(I) = QM(I) + PP(I)
      SPMQP(I) = PM(I) + QP(I)
      SPMPP(I) = PM(I) + PP(I)
    4 CONTINUE
c
      WE = 4.D0
      WL = DOTGG(SQMQP,SQMQP)
      WM = DOTGG(SPMPP,SPMPP)
      W1 = DOTGG(SPMQP,SPMQP)
      W2 = DOTGG(SQMPP,SQMPP)
      AT1 = DOTGG(VP2QP,VP2QP)
      AT2 = DOTGG(VP1QM,VP1QM)
      AT3 = DOTGG(VP2PP,VP2PP)
      AT4 = DOTGG(VP1PM,VP1PM)
      T1 = DABS(AT1)
      T2 = DABS(AT2)
      T3 = DABS(AT3)
      T4 = DABS(AT4)
      E1 = 4.D0*(1.D0-PP(4))
      E2 = 4.D0*(1.D0-PM(4))
      E3 = 4.D0*(1.D0-QP(4))
      E4 = 4.D0*(1.D0-QM(4))
      AD1 = WM-2.D0*DOTGG(P2,SPMPP)
      AD2 = WL-2.D0*DOTGG(P2,SQMQP)
      AD3 = W1-2.D0*DOTGG(P2,SPMQP)
      AD4 = W2-2.D0*DOTGG(P2,SQMPP)
      AD5 = AT1-2.D0*DOTGG(PP,VP2QP)
      AD6 = AT1-2.D0*DOTGG(PM,VP2QP)
      D1 = DABS(AD1)
      D2 = DABS(AD2)
      D3 = DABS(AD3)
      D4 = DABS(AD4)
      D5 = DABS(AD5)
      D6 = DABS(AD6)
c
      PROP(1,1) = WE*WM*E3*E4
      PROP(1,2) = WE*WL*E1*E2
      PROP(1,3) = WL*WM*D1*D2
c
      GOTO(1001,2001,3001,3001,4001),IPROC
c
 1001 CONTINUE
      PROMIN = DMIN1(PROP(1,1),PROP(1,2),PROP(1,3))
c
      DO 1002 I=1,3
      ISEL(1,I) = 1
      IF (PROP(1,I)/PROMIN.GT.PROC) ISEL(1,I) = 0
 1002 CONTINUE
c
      DO 1003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 1003 CONTINUE
c
      IF (WE.LE.FACE)               I12(1) = 1
      IF (E3.LE.FACL.OR.E4.LE.FACL) I34(1) = 1
      IF (WM.LE.FACM)               I56(1) = 1
      IF (WL.LE.FACL)               I34(2) = 1
      IF (E1.LE.FACM.OR.E2.LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.D2.LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
c
      DO 1004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 1004 J=1,32
      ILZ(1,I,J) = II(1,IT(I),J)
 1004 CONTINUE
c
      IF (INF.LT.0) RETURN
      print  110, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  110 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      print  100,(PROP(1,J),J=1,3),PROMIN
  100 FORMAT(' PROP(1,J) (J=1,3) = '/' ',3(D15.4,2X)/
     .       ' MINIMUM = ',D15.4)
      print  101,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,32),I=1,3)
  101 FORMAT(' ISEL(1,J) (J=1,3) = ',3I4//
     .       ' ILZ(1,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      RETURN
C
 2001 CONTINUE
      PROP(2,1) = WE*W1*E1*E4
      PROP(2,2) = WE*W2*E2*E3
      PROP(2,3) = W1*W2*D3*D4
      PROMIN = DMIN1(PROP(1,1),PROP(1,2),PROP(1,3),
     .               PROP(2,1),PROP(2,2),PROP(2,3))
c
      DO 2002 IGR=1,2
      DO 2002 I=1,3
      ISEL(IGR,I) = 1
      IF (PROP(IGR,I)/PROMIN.GT.PROC) ISEL(IGR,I) = 0
 2002 CONTINUE
c
      DO 2003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 2003 CONTINUE
c
      IF (WE.LE.FACE)               I12(1) = 1
      IF (E3.LE.FACM.OR.E4.LE.FACM) I34(1) = 1
      IF (WM.LE.FACM)               I56(1) = 1
      IF (WL.LE.FACM)               I34(2) = 1
      IF (E1.LE.FACM.OR.E2.LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.D2.LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
c
      DO 2004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 2004 J=1,32
      ILZ(1,I,J) = II(1,IT(I),J)
 2004 CONTINUE
c
      DO 2005 I=1,3
      I12(I) = -1
      I45(I) = -1
      I36(I) = -1
 2005 CONTINUE
c
      IF (WE.LE.FACE)               I12(1) = 1
      IF (E1.LE.FACM.OR.E4.LE.FACM) I45(1) = 1
      IF (W1.LE.FACM)               I36(1) = 1
      IF (W2.LE.FACM)               I45(2) = 1
      IF (E2.LE.FACM.OR.E3.LE.FACM) I36(2) = 1
      IF (D3.LE.FACE.OR.D4.LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I45(3) = I45(2)
      I36(3) = I36(1)
c
      DO 2006 I=1,3
      IT(I) = 5 - 2*I12(I) - I45(I) - (I36(I)+1)/2
      DO 2006 J=1,32
      ILZ(2,I,J) = II(2,IT(I),J)
 2006 CONTINUE
c
      IF (INF.LT.0) RETURN
      print  210, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  210 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      print  211, WE,W1,E1,E4,WE,W2,E2,E3,W1,W2,D3,D4
  211 FORMAT(' WE = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' W1 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'D3 = ',D15.4,2X,'D4 = ',D15.4)
      print  200,((PROP(I,J),J=1,3),I=1,2),PROMIN
  200 FORMAT(' PROP(I,J) (J=1,3 I=1,2) = '/2(' ',3(D15.4,2X)/),
     .       ' MINIMUM = ',D15.4)
      print  201,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,32),I=1,3)
  201 FORMAT(' ISEL(1,J) (J=1,3) = ',3I4//
     .       ' ILZ(1,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      print  202,(ISEL(2,J),J=1,3),
     .              ((ILZ(2,I,J),J=1,32),I=1,3)
  202 FORMAT(' ISEL(2,J) (J=1,3) = ',3I4//
     .       ' ILZ(2,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      RETURN
c
 3001 CONTINUE
c
      PROP(6,1) = WM*T1*D2*E3
      PROP(6,2) = T1*T2*D5*D6
      PROP(6,3) = WM*T2*D1*E4
      PROMIN = DMIN1(PROP(1,1),PROP(1,2),PROP(1,3),
     .               PROP(6,1),PROP(6,2),PROP(6,3))
c
      DO 3002 IGR=1,6,5
      DO 3002 I=1,3
      ISEL(IGR,I) = 1
      IF (PROP(IGR,I)/PROMIN.GT.PROC) ISEL(IGR,I) = 0
 3002 CONTINUE
c
      DO 3003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 3003 CONTINUE
c
      IF (WE.LE.FACE)               I12(1) = 1
      IF (E3.LE.FACE.OR.E4.LE.FACE) I34(1) = 1
      IF (WM.LE.FACM)               I56(1) = 1
      IF (WL.LE.FACE)               I34(2) = 1
      IF (E1.LE.FACM.OR.E2.LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.D2.LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
c
      DO 3004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 3004 J=1,32
      ILZ(1,I,J) = II(1,IT(I),J)
 3004 CONTINUE
c
      DO 3005 I=1,3
      I13(I) = -1
      I24(I) = -1
      I56(I) = -1
 3005 CONTINUE
c
      IF (T1.LE.FACE)               I13(1) = 1
      IF (D2.LE.FACE.OR.E3.LE.FACE) I24(1) = 1
      IF (WM.LE.FACM)               I56(1) = 1
      IF (T2.LE.FACE)               I24(2) = 1
      IF (D5.LE.FACM.OR.D6.LE.FACM) I56(2) = 1
      IF (D1.LE.FACE.OR.E4.LE.FACE) I13(3) = 1
      I13(2) = I13(1)
      I24(3) = I24(2)
      I56(3) = I56(1)
c
      DO 3006 I=1,3
      IT(I) = 5 - 2*I13(I) - I24(I) - (I56(I)+1)/2
      DO 3006 J=1,32
      ILZ(6,I,J) = II(6,IT(I),J)
 3006 CONTINUE
c
      IF (INF.LT.0) RETURN
      print  310, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  310 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      print  311, WM,T1,D2,E3,T1,T2,D5,D6,WM,T2,D1,E4
  311 FORMAT(' WM = ',D15.4,2X,'T1 = ',D15.4,2X,
     .        'D2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' T1 = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D5 = ',D15.4,2X,'D6 = ',D15.4/
     .       ' WM = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'E4 = ',D15.4)
      print  300,(PROP(1,J),J=1,3),
     .                        (PROP(6,I),I=1,3),PROMIN
  300 FORMAT(' PROP(I,J) (J=1,3 I=1 OR 6) = '/2(' ',3(D15.4,2X)/),
     .       ' MINIMUM = ',D15.4)
      print  301,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,32),I=1,3)
  301 FORMAT(' ISEL(1,J) (J=1,3) = ',3I4//
     .       ' ILZ(1,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      print  302,(ISEL(6,J),J=1,3),
     .              ((ILZ(6,I,J),J=1,32),I=1,3)
  302 FORMAT(' ISEL(6,J) (J=1,3) = ',3I4//
     .       ' ILZ(6,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      RETURN
 4001 CONTINUE
      PROP(2,1) = WE*W1*E1*E4
      PROP(2,2) = WE*W2*E2*E3
      PROP(2,3) = W1*W2*D3*D4
C
      PROP(3,1) = T1*T4*D2*D5
      PROP(3,2) = T1*W2*E3*D3
      PROP(3,3) = T4*W2*E2*D4
C
      PROP(4,1) = T3*T4*D4*D5
      PROP(4,2) = T3*WL*E1*D1
      PROP(4,3) = T4*WL*E2*D2
C
      PROP(5,1) = T3*W1*D4*E1
      PROP(5,2) = T3*T2*D5*D1
      PROP(5,3) = T2*W1*D3*E4
C
      PROP(6,1) = WM*T1*D2*E3
      PROP(6,2) = T1*T2*D5*D6
      PROP(6,3) = WM*T2*D1*E4
C
      PROMIN = DMIN1(PROP(1,1),PROP(1,2),PROP(1,3),
     .               PROP(2,1),PROP(2,2),PROP(2,3),
     .               PROP(3,1),PROP(3,2),PROP(3,3),
     .               PROP(4,1),PROP(4,2),PROP(4,3),
     .               PROP(5,1),PROP(5,2),PROP(5,3),
     .               PROP(6,1),PROP(6,2),PROP(6,3))
c
      DO 4002 IGR=1,6
      DO 4002 I=1,3
      ISEL(IGR,I) = 1
      IF (PROP(IGR,I)/PROMIN.GT.PROC) ISEL(IGR,I) = 0
 4002 CONTINUE
c
      DO 4003 I=1,3
      I12(I) = -1
      I34(I) = -1
      I56(I) = -1
 4003 CONTINUE
c
      IF (WE.LE.FACE)               I12(1) = 1
      IF (E3.LE.FACE.OR.E4.LE.FACE) I34(1) = 1
      IF (WM.LE.FACE)               I56(1) = 1
      IF (WL.LE.FACE)               I34(2) = 1
      IF (E1.LE.FACE.OR.E2.LE.FACE) I56(2) = 1
      IF (D1.LE.FACE.OR.D2.LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I34(3) = I34(2)
      I56(3) = I56(1)
c
      DO 4004 I=1,3
      IT(I) = 5 - 2*I12(I) - I34(I) - (I56(I)+1)/2
      DO 4004 J=1,32
      ILZ(1,I,J) = II(1,IT(I),J)
 4004 CONTINUE
c
      DO 4005 I=1,3
      I12(I) = -1
      I45(I) = -1
      I36(I) = -1
 4005 CONTINUE
c
      IF (WE.LE.FACE)               I12(1) = 1
      IF (E1.LE.FACE.OR.E4.LE.FACE) I45(1) = 1
      IF (W1.LE.FACE)               I36(1) = 1
      IF (W2.LE.FACE)               I45(2) = 1
      IF (E2.LE.FACE.OR.E3.LE.FACE) I36(2) = 1
      IF (D3.LE.FACE.OR.D4.LE.FACE) I12(3) = 1
      I12(2) = I12(1)
      I45(3) = I45(2)
      I36(3) = I36(1)
c
      DO 4006 I=1,3
      IT(I) = 5 - 2*I12(I) - I45(I) - (I36(I)+1)/2
      DO 4006 J=1,32
      ILZ(2,I,J) = II(2,IT(I),J)
 4006 CONTINUE
c
      DO 4007 I=1,3
      I13(I) = -1
      I45(I) = -1
      I26(I) = -1
 4007 CONTINUE
c
      IF (T1.LE.FACE)               I13(1) = 1
      IF (D5.LE.FACE.OR.D2.LE.FACE) I45(1) = 1
      IF (T4.LE.FACE)               I26(1) = 1
      IF (W2.LE.FACE)               I45(2) = 1
      IF (E3.LE.FACE.OR.D3.LE.FACE) I26(2) = 1
      IF (E2.LE.FACE.OR.D4.LE.FACE) I13(3) = 1
      I13(2) = I13(1)
      I45(3) = I45(2)
      I26(3) = I26(1)
c
      DO 4008 I=1,3
      IT(I) = 5 - 2*I13(I) - I45(I) - (I26(I)+1)/2
      DO 4008 J=1,32
      ILZ(3,I,J) = II(3,IT(I),J)
 4008 CONTINUE
c
      DO 4009 I=1,3
      I15(I) = -1
      I34(I) = -1
      I26(I) = -1
 4009 CONTINUE
c
      IF (T3.LE.FACE)               I15(1) = 1
      IF (D5.LE.FACE.OR.D4.LE.FACE) I34(1) = 1
      IF (T4.LE.FACE)               I26(1) = 1
      IF (WL.LE.FACE)               I34(2) = 1
      IF (E1.LE.FACE.OR.D1.LE.FACE) I26(2) = 1
      IF (E2.LE.FACE.OR.D2.LE.FACE) I15(3) = 1
      I15(2) = I15(1)
      I34(3) = I34(2)
      I26(3) = I26(1)
c
      DO 4010 I=1,3
      IT(I) = 5 - 2*I15(I) - I34(I) - (I26(I)+1)/2
      DO 4010 J=1,32
      ILZ(4,I,J) = II(4,IT(I),J)
 4010 CONTINUE
c
      DO 4011 I=1,3
      I15(I) = -1
      I24(I) = -1
      I36(I) = -1
 4011 CONTINUE
c
      IF (T3.LE.FACE)               I15(1) = 1
      IF (D4.LE.FACE.OR.E1.LE.FACE) I24(1) = 1
      IF (W1.LE.FACE)               I36(1) = 1
      IF (T2.LE.FACE)               I24(2) = 1
      IF (D5.LE.FACE.OR.D1.LE.FACE) I36(2) = 1
      IF (D3.LE.FACE.OR.E4.LE.FACE) I15(3) = 1
      I15(2) = I15(1)
      I24(3) = I24(2)
      I36(3) = I36(1)
c
      DO 4012 I=1,3
      IT(I) = 5 - 2*I15(I) - I24(I) - (I36(I)+1)/2
      DO 4012 J=1,32
      ILZ(5,I,J) = II(5,IT(I),J)
 4012 CONTINUE
c
      DO 4013 I=1,3
      I13(I) = -1
      I24(I) = -1
      I56(I) = -1
 4013 CONTINUE
c
      IF (T1.LE.FACE)               I13(1) = 1
      IF (D2.LE.FACE.OR.E3.LE.FACE) I24(1) = 1
      IF (WM.LE.FACE)               I56(1) = 1
      IF (T2.LE.FACE)               I24(2) = 1
      IF (D5.LE.FACE.OR.D6.LE.FACE) I56(2) = 1
      IF (D1.LE.FACE.OR.E4.LE.FACE) I13(3) = 1
      I13(2) = I13(1)
      I24(3) = I24(2)
      I56(3) = I56(1)
c
      DO 4014 I=1,3
      IT(I) = 5 - 2*I13(I) - I24(I) - (I56(I)+1)/2
      DO 4014 J=1,32
      ILZ(6,I,J) = II(6,IT(I),J)
 4014 CONTINUE
c
      IF (INF.LT.0) RETURN
      print  410, WE,WM,E3,E4,WE,WL,E1,E2,WL,WM,D1,D2
  410 FORMAT(' WE = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E2 = ',D15.4/
     .       ' WL = ',D15.4,2X,'WM = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'D2 = ',D15.4)
      print  411, WE,W1,E1,E4,WE,W2,E2,E3,W1,W2,D3,D4
  411 FORMAT(' WE = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'E4 = ',D15.4/
     .       ' WE = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' W1 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'D3 = ',D15.4,2X,'D4 = ',D15.4)
      print  412, T1,T4,D2,D5,T1,W2,E3,D3,T4,W2,E2,D4
  412 FORMAT(' T1 = ',D15.4,2X,'T4 = ',D15.4,2X,
     .        'D2 = ',D15.4,2X,'D5 = ',D15.4/
     .       ' T1 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E3 = ',D15.4,2X,'D3 = ',D15.4/
     .       ' T4 = ',D15.4,2X,'W2 = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'D4 = ',D15.4)
      print  413, T3,T4,D4,D5,T3,WL,E1,D1,T4,WL,E2,D2
  413 FORMAT(' T3 = ',D15.4,2X,'T4 = ',D15.4,2X,
     .        'D4 = ',D15.4,2X,'D5 = ',D15.4/
     .       ' T3 = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E1 = ',D15.4,2X,'D1 = ',D15.4/
     .       ' T4 = ',D15.4,2X,'WL = ',D15.4,2X,
     .        'E2 = ',D15.4,2X,'D2 = ',D15.4)
      print  414, T3,W1,D4,E1,T3,T2,D5,D1,T2,W1,D3,E4
  414 FORMAT(' T3 = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'D4 = ',D15.4,2X,'E1 = ',D15.4/
     .       ' T3 = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D5 = ',D15.4,2X,'D1 = ',D15.4/
     .       ' T2 = ',D15.4,2X,'W1 = ',D15.4,2X,
     .        'D3 = ',D15.4,2X,'E4 = ',D15.4)
      print  415, WM,T1,D2,E3,T1,T2,D5,D6,WM,T2,D1,E4
  415 FORMAT(' WM = ',D15.4,2X,'T1 = ',D15.4,2X,
     .        'D2 = ',D15.4,2X,'E3 = ',D15.4/
     .       ' T1 = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D5 = ',D15.4,2X,'D6 = ',D15.4/
     .       ' WM = ',D15.4,2X,'T2 = ',D15.4,2X,
     .        'D1 = ',D15.4,2X,'E4 = ',D15.4)
      print  400,((PROP(I,J),J=1,3),I=1,6),PROMIN
  400 FORMAT(' PROP(I,J) (J=1,3 I=1,6) = '/6(' ',3(D15.4,2X)/),
     .       ' MINIMUM = ',D15.4)
      print  401,(ISEL(1,J),J=1,3),
     .              ((ILZ(1,I,J),J=1,32),I=1,3)
  401 FORMAT(' ISEL(1,J) (J=1,3) = ',3I4//
     .       ' ILZ(1,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      print  402,(ISEL(2,J),J=1,3),
     .              ((ILZ(2,I,J),J=1,32),I=1,3)
  402 FORMAT(' ISEL(2,J) (J=1,3) = ',3I4//
     .       ' ILZ(2,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      print  403,(ISEL(3,J),J=1,3),
     .              ((ILZ(3,I,J),J=1,32),I=1,3)
  403 FORMAT(' ISEL(3,J) (J=1,3) = ',3I4//
     .       ' ILZ(3,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      print  404,(ISEL(4,J),J=1,3),
     .              ((ILZ(4,I,J),J=1,32),I=1,3)
  404 FORMAT(' ISEL(4,J) (J=1,3) = ',3I4//
     .       ' ILZ(4,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      print  405,(ISEL(5,J),J=1,3),
     .              ((ILZ(5,I,J),J=1,32),I=1,3)
  405 FORMAT(' ISEL(5,J) (J=1,3) = ',3I4//
     .       ' ILZ(5,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      print  406,(ISEL(6,J),J=1,3),
     .              ((ILZ(6,I,J),J=1,32),I=1,3)
  406 FORMAT(' ISEL(6,J) (J=1,3) = ',3I4//
     .       ' ILZ(6,I,J) (J=1,32 I=1,3) = '/
     .       3(' ',32I4/))
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE SPINOX(INFO)
c
c...Calculation scalar products between spinors: S, T, Y.
c...The spinor part of the amplitude will be expressed in terms
c...of these scalar products.
c...This subroutine is called from function DIAM
c
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 S,T
      COMMON /GG_EEMOMENZ/ P1,P2,P3,P4,P5,P6
      COMMON /GG_EEPRODUX/ S,T,Y,Z,X,D
      DIMENSION P1(5),P2(5),P3(5),P4(5),P5(5),P6(5)
      DIMENSION Q(5,6),R(6,6),S(6,6),T(6,6),D(6,6)
      DIMENSION X(6),Y(6,6),Z(6)
      EQUIVALENCE ( P1(1) , Q(1,1) )
c
      DO 1 I=1,6
      Z(I) = DSQRT( 2.*( Q(4,I) - Q(1,I) )  )
    1 X(I) = Q(5,I)/Z(I)
c
      DO 2 I=1,6
      DO 2 J=1,6
    2 R(I,J) = Z(I)/Z(J)
c
      DO 3 I=1,6
      DO 3 J=I,6
      S(I,J) = DCMPLX( Q(2,I) , Q(3,I) ) * R(J,I)
     .       - DCMPLX( Q(2,J) , Q(3,J) ) * R(I,J)
      T(I,J) = -DCONJG( S(I,J) )
    3 Y(I,J) = X(I)*Z(J) + X(J)*Z(I)
c
      DO 4 I=2,6
      IMIN1=I-1
      DO 4 J=1,IMIN1
      S(I,J) = -S(J,I)
      T(I,J) = -T(J,I)
    4 Y(I,J) =  Y(J,I)
c
      DO 5 I=1,6
      DO 5 J=1,I
    5 D(I,J) = S(I,J)*T(J,I) + (X(I)*Z(J))**2 + (X(J)*Z(I))**2
c
      DO 6 I=1,5
      I1=I+1
      DO 6 J=I1,6
    6 D(I,J)=D(J,I)
c
      IF(INFO.LT.1) RETURN
      print  100
      print  101, (P1(I),P2(I),P3(I),P4(I),P5(I),P6(I),I=1,5)
      print  102, (Z(I),X(I),I=1,6)
      print  103, ((R(I,J),J=1,6),I=1,6)
      print  104, ((S(I,J),J=1,6),I=1,6)
      print  105, ((T(i,j),j=1,6),i=1,6)
      print  106, ((Y(I,J),J=1,6),I=1,6)
c
  100 FORMAT(' ',40(1H-),' SPINOX INFO ',40(1H-))
  101 FORMAT('0INPUT FOUR-VECTORS WITH MASSES',/,(6D15.6))
  102 FORMAT('0MATRICES Z(ROW) AND X(ROW)',/,(2D15.6))
  103 FORMAT('0MATRIX R(ROW,COLUMN)',/,(6D15.6))
  104 FORMAT('0MATRIX S(ROW,COLUMN)',/,(6('  ',2D10.3)))
  105 FORMAT('0MATRIX T(ROW,COLUMN)',/,(6('  ',2D10.3)))
  106 FORMAT('0MATRIX Y(ROW,COLUMN)',/,(6('  ',D15.6)))
  107 FORMAT('0MATRIX D(ROW,COLUMN)',/,(6('  ',D15.6)))
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION ZZ(P1,L1,P2,L2,P3,L3,P4,L4,INFO)
c
c...Calculation of all the Z functions:
c...these are Lorentz contracted spinor currents with different
c...spins L1,L2,L3,L4
c
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 ZZ,S,T
      INTEGER P1,P2,P3,P4
      DIMENSION S(6,6),T(6,6),Y(6,6),D(6,6),X(6),Z(6)
      COMMON /GG_EEPRODUX/ S,T,Y,Z,X,D
c
      LZ=9-4*L1-2*L2-L3-(L4+1)/2
c
      GOTO(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16),LZ
c
    1 ZZ= -2.*( S(P1,P3)*T(P2,P4) - Z(P1)*Z(P2)*X(P3)*X(P4)
     .                            - Z(P3)*Z(P4)*X(P1)*X(P2) )
      GOTO 17
    2 ZZ= -2.*Z(P2)*(    S(P1,P3)*X(P4)
     .                 - S(P1,P4)*X(P3) )
      GOTO 17
    3 ZZ= -2.*Z(P1)*(    T(P2,P3)*X(P4)
     .                 - T(P2,P4)*X(P3) )
      GOTO 17
    4 ZZ= -2.*( S(P1,P4)*T(P2,P3) - Z(P1)*Z(P2)*X(P3)*X(P4)
     .                            - Z(P3)*Z(P4)*X(P1)*X(P2) )
      GOTO 17
    5 ZZ= -2.*Z(P4)*(    S(P3,P1)*X(P2)
     .                 - S(P3,P2)*X(P1) )
      GOTO 17
    6 ZZ=(0.D0,0.D0)
      GOTO 17
    7 ZZ=  2.*( X(P2)*Z(P1) - X(P1)*Z(P2) )
     .       *( X(P4)*Z(P3) - X(P3)*Z(P4) )
      GOTO 17
    8 ZZ=  2.*Z(P3)*(    S(P1,P4)*X(P2)
     .                 - S(P2,P4)*X(P1) )
      GOTO 17
    9 ZZ=  2.*Z(P3)*(    T(P1,P4)*X(P2)
     .                 - T(P2,P4)*X(P1) )
      GOTO 17
   10 ZZ=  2.*( X(P2)*Z(P1) - X(P1)*Z(P2) )
     .       *( X(P4)*Z(P3) - X(P3)*Z(P4) )
      GOTO 17
   11 ZZ=(0.D0,0.D0)
      GOTO 17
   12 ZZ=  2.*Z(P4)*(    T(P1,P3)*X(P2)
     .                 - T(P2,P3)*X(P1) )
      GOTO 17
   13 ZZ= -2.*( S(P2,P3)*T(P1,P4) - Z(P1)*Z(P2)*X(P3)*X(P4)
     .                            - Z(P3)*Z(P4)*X(P1)*X(P2) )
      GOTO 17
   14 ZZ= -2.*Z(P1)*(    S(P2,P3)*X(P4)
     .                 - S(P2,P4)*X(P3) )
      GOTO 17
   15 ZZ= -2.*Z(P2)*(    T(P1,P3)*X(P4)
     .                 - T(P1,P4)*X(P3) )
      GOTO 17
   16 ZZ= -2.*( S(P2,P4)*T(P1,P3) - Z(P1)*Z(P2)*X(P3)*X(P4)
     .                            - Z(P3)*Z(P4)*X(P1)*X(P2) )
   17 IF(INFO.LT.5) RETURN
      print  18,L1,L2,L3,L4,LZ,ZZ
   18 FORMAT(' ZZ:   L1,L2,L3,L4,  LZ,  ZZ =',4I3,I6,D20.6,D15.6)
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION GRAAF(P1,L1,P2,L2,P3,L3,P4,L4,P5,L5,P6,L6,INF)
c
c...Function GRAAF calculates the complete amplitude of a given
c...amplitude.
c...GRAAF is called from function DIAM for every Feynman diagram.
c
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EEINOUT/ B(6)
      COMMON /GG_EEMOMENZ/ Q1,Q2,Q3,Q4,Q5,Q6
      COMMON /GG_EEPRODUX/ S,T,Y,Z,X,D
      DIMENSION Q(5,6),S(6,6),T(6,6),Y(6,6),D(6,6),X(6),Z(6)
      DIMENSION Q1(5),Q2(5),Q3(5),Q4(5),Q5(5),Q6(5),QQ(5)
      EQUIVALENCE ( Q1(1) , Q(1,1) )
      COMPLEX*16 ZZ,S,T,GRAAF
      INTEGER P1,P2,P3,P4,P5,P6
c
      GRAAF = (0.D0,0.D0)
c
      DO 1 I=1,2
      IL  = 2*I - 3
      GRAAF = GRAAF + B(P3)*ZZ(P1,L1,P2,L2,P3,L3,P3,IL,INF)*
     .                      ZZ(P3,IL,P4,L4,P5,L5,P6,L6,INF)
     .              + B(P1)*ZZ(P1,L1,P2,L2,P3,L3,P1,IL,INF)*
     .                      ZZ(P1,IL,P4,L4,P5,L5,P6,L6,INF)
     .              + B(P2)*ZZ(P1,L1,P2,L2,P3,L3,P2,IL,INF)*
     .                      ZZ(P2,IL,P4,L4,P5,L5,P6,L6,INF)
      IF (INF.GE.4) print  2,IL,P1,L1,P2,L2,P3,L3,P4,L4,P5,L5,P6,L6,
     .                      GRAAF
    2 FORMAT(' GRAAF: IL,P(I),L(I),GRAAF =',I3,' ',6(2I3,' '),2D15.6)
    1 CONTINUE
c
      PROP1 = 0.5D0*D(P1,P1)+0.5D0*D(P2,P2)+B(P1)*B(P2)*D(P1,P2)
      APROP1 = DABS(PROP1)
      PRO1 = 0.5D0*D(P1,P1)+0.5D0*D(P2,P2)+2.D0*B(P1)*B(P2)*
     . ( (Q(4,P1)*Q(4,P1)*(Q(1,P2)*Q(1,P2)+Q(2,P2)*Q(2,P2)+
     .                     Q(5,P2)*Q(5,P2))+
     .    Q(3,P2)*Q(3,P2)*(Q(1,P1)*Q(1,P1)+Q(2,P1)*Q(2,P1)+
     .                     Q(5,P1)*Q(5,P1)))/
     .   (Q(4,P1)*Q(4,P2)+Q(3,P1)*Q(3,P2))-
     .   Q(2,P1)*Q(2,P2) - Q(1,P1)*Q(1,P2) )
      X1   = PROP1/PRO1
c
c      CALL HISTO1(3,8HPRO1 QUO,20,0.D0,2.D0,X1,1.D0)
c
      IF (APROP1.LT.1.D-10) PROP1 = PRO1
      PROP2 = 0.5D0*D(P5,P5)+0.5D0*D(P6,P6)+B(P5)*B(P6)*D(P5,P6)
      APROP2 = DABS(PROP2)
      PRO2 =  0.5D0*D(P5,P5)+0.5D0*D(P6,P6)+2.D0*B(P5)*B(P6)*
     . ( (Q(4,P5)*Q(4,P5)*(Q(1,P6)*Q(1,P6)+Q(2,P6)*Q(2,P6)+
     .                     Q(5,P6)*Q(5,P6))+
     .    Q(3,P6)*Q(3,P6)*(Q(1,P5)*Q(1,P5)+Q(2,P5)*Q(2,P5)+
     .                     Q(5,P5)*Q(5,P5)))/
     .   (Q(4,P5)*Q(4,P6)+Q(3,P5)*Q(3,P6))-
     .   Q(2,P5)*Q(2,P6) - Q(1,P5)*Q(1,P6) )
      X2   = PROP2/PRO2
c
c      CALL HISTO1(4,8HPRO2 QUO,20,0.D0,2.D0,X2,1.D0)
c
      IF (APROP2.LT.1.D-10) PROP2 = PRO2
      PROP3 = 0.5D0*D(P1,P1)+0.5D0*D(P2,P2)+B(P1)*B(P2)*D(P1,P2)+
     .                  B(P1)*B(P3)*D(P1,P3)+B(P2)*B(P3)*D(P2,P3)
      APROP3 = DABS(PROP3)
c
      DO 8 I=1,4
      QQ(I) = B(P1)*Q(I,P1) + B(P2)*Q(I,P2)
    8 CONTINUE
c
      QQ(5) = PROP1
      PRO3 = PROP1 + 2.D0*B(P3)*
     .  ( (QQ(4)*QQ(4)*(Q(1,P3)*Q(1,P3)+Q(2,P3)*Q(2,P3)+
     .                  Q(5,P3)*Q(5,P3))+
     .     Q(3,P3)*Q(3,P3)*(QQ(1)*QQ(1)+QQ(2)*QQ(2)+QQ(5)))/
     .    (QQ(4)*Q(4,P3)+QQ(3)*Q(3,P3))-
     .     QQ(1)*Q(1,P3)-QQ(2)*Q(2,P3) )
c
      DO 9 I=1,4
      QQ(I) = B(P5)*Q(I,P5) + B(P6)*Q(I,P6)
    9 CONTINUE
c
      QQ(5) = PROP2
      PRO4 = PROP2 + 2.D0*B(P4)*
     .  ( (QQ(4)*QQ(4)*(Q(1,P4)*Q(1,P4)+Q(2,P4)*Q(2,P4)+
     .                  Q(5,P4)*Q(5,P4))+
     .     Q(3,P4)*Q(3,P4)*(QQ(1)*QQ(1)+QQ(2)*QQ(2)+QQ(5)))/
     .    (QQ(4)*Q(4,P4)+QQ(3)*Q(3,P4))-
     .     QQ(1)*Q(1,P4)-QQ(2)*Q(2,P4) )
      IF (APROP3.GT.1.D-10) GOTO 6
      APROP1 = DABS(PROP1)
      APROP2 = DABS(PROP2)
      IF (APROP1.GT.APROP2) GOTO 7
      X3    = PROP3/PRO3
c
      PROP3 = PRO3
      GOTO 6
    7 CONTINUE
      X4    = PROP3/PRO4
c
      PROP3 = PRO4
    6 CONTINUE
      PROP = PROP1*PROP2*PROP3
      GRAAF = GRAAF/PROP
      IF (INF.GE.3) print 3,PROP,GRAAF
    3 FORMAT(' GRAAF:------------------ PROP,GRAAF =',3D15.6)
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE GROUP(IG,K1,K2,K3,K4,K5,K6,IREL)
c--------------------------------------------------------------
c  This subroutine orders the labels of the momenta into the
c  correct groups
c--------------------------------------------------------------
      K1 = 1
      K3 = 4
      K5 = 6
c
      GOTO (1,2,3,4,5,6),IG
c
    1 CONTINUE
      K2 = 2
      K4 = 3
      K6 = 5
      IREL =  1
      RETURN
c
    2 CONTINUE
      K2 = 2
      K4 = 5
      K6 = 3
      IREL = -1
      RETURN
c
    3 CONTINUE
      K2 = 3
      K4 = 5
      K6 = 2
      IREL =  1
      RETURN
c
    4 CONTINUE
      K2 = 5
      K4 = 3
      K6 = 2
      IREL = -1
      RETURN
c
    5 CONTINUE
      K2 = 5
      K4 = 2
      K6 = 3
      IREL =  1
      RETURN
c
    6 CONTINUE
      K2 = 3
      K4 = 2
      K6 = 5
      IREL = -1
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE PERMU(IP,L1,L2,L3,L4,L5,L6,K1,K2,K3,K4,K5,K6)
c---------------------------------------------------------------
c  Orders the momentum labels according to the permutation number
c  inside a given group: according to table 2.
c---------------------------------------------------------------
c
      GOTO (1,2,3,4,5,6),IP
c
    1 K1=L1
      K2=L2
      K3=L3
      K4=L4
      K5=L5
      K6=L6
      RETURN
c
    2 K1=L5
      K2=L6
      K3=L3
      K4=L4
      K5=L1
      K6=L2
      RETURN
c
    3 K1=L3
      K2=L4
      K3=L5
      K4=L6
      K5=L1
      K6=L2
      RETURN
c
    4 K1=L1
      K2=L2
      K3=L5
      K4=L6
      K5=L3
      K6=L4
      RETURN
c
    5 K1=L5
      K2=L6
      K3=L1
      K4=L2
      K5=L3
      K6=L4
      RETURN
c
    6 K1=L3
      K2=L4
      K3=L1
      K4=L2
      K5=L5
      K6=L6
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE CHANGE(A,B)
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION A(4),B(4),C(4)
c
      DO 1 I=1,4
      C(I) = A(I)
      A(I) = B(I)
      B(I) = C(I)
    1 CONTINUE
c
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION CHOICE(IPROCS,IGROUP,IPERMU)
c------------------------------------------------------------------
c Selection routine for various 'sub'processes of E E ---> E E E E
c IPROCS=1: MU+(Q3)  L+(Q5) MU-(Q4)  L-(Q6)
c        2: MU+(Q3) MU+(Q5) MU-(Q4) MU-(Q6)
c        3:  E+(Q3) MU+(Q5)  E-(Q4) MU-(Q6)
c        4:  E+(Q3)  L+(Q5)  E-(Q4)  L-(Q6)
c        5:  E+(Q3)  E+(Q5)  E-(Q4)  E-(Q6)
c------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /GG_EECHARGE/ QCHARG,QCHRG2,QCHRG3,QCHRG4
c
      CHOICE = 0.D0
c
      GOTO (1,2,3,4,5),IPROCS
c
    1 CONTINUE
      IF (IGROUP.NE.1) RETURN
      IF (IPERMU.EQ.3. OR.IPERMU.EQ.4) CHOICE = QCHRG2
      IF (IPERMU.NE.3.AND.IPERMU.NE.4) CHOICE = QCHARG
      RETURN
c
    2 CONTINUE
      IF (IGROUP.EQ.1.OR.IGROUP.EQ.2) CHOICE = 1.D0
      RETURN
c
    3 CONTINUE
      IF (IGROUP.EQ.1.OR.IGROUP.EQ.6) CHOICE = 1.D0
      RETURN
c
    4 CONTINUE
      IF (IGROUP.NE.1.AND.IGROUP.NE.6) RETURN
      IF (IPERMU.EQ.3. OR.IPERMU.EQ.4) CHOICE = QCHRG2
      IF (IPERMU.NE.3.AND.IPERMU.NE.4) CHOICE = QCHARG
      RETURN
c
    5 CONTINUE
      CHOICE = 1.D0
      RETURN
      END
