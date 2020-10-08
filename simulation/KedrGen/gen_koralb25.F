      SUBROUTINE GEN_KORALB(ENE,JAK1,JAK2,ISPIN,ITFIN,KEYGSW,IFZET,
     +                   KEYRAD,ITDKRC,ITRANS,XK0,NSTABL,KPART,EVENT)
c*******************************************************************
c
c  Simulation e+e- -> tau+tau-(gamma) using KORAL-B version 2.5
c
c  Input parameters:
c
c	 ENE -  energy of beam (GeV)
c        JAK1,JAK2  - number of tau decay mode
c	        = 1 - electron mode
c               = 2 - muon mode
c       	= 3 - pion mode
c               = 4 - rho mode
c               = 5 - a1 mode
c        	= 6 - K mode
c        	= 7 - K* mode
c       	= 8 - nPi mode
c       	= 0 - inclusive (decays into all), JAK=1,2,3,4,5,6,7,8
c        ISPIN - (1)  switch for spin effects in tau decay
c        ITFIN - (1)  switch, if >1 - generation of other pairs than tau
c        KEYGSW - (1) interference between gamma and Z exchange is inclu
c        IFZET -  (0) switch for full implementation of Z
c        KEYRAD - (1) switch for QED bremmstrahlung
c        ITDKRC - (1) switch for bremmstrahlung in tau decay
c        ITRANS - (1) switch for transverse spin correlations
c        XK0    - (0.005) soft/hard photon cut-off for QED bremss. in Ebeam u.
c
c  Output parameters:
c
c    NSTABL - number of stable particles
c    KPART - GEANT codes of particles
c    EVENT - tracks of stable particles
c
c    RNG = RNF100 (from file gen_ggmmg.f, where RNF100 calls RLU) 
c
c  Correction: 16.05.2003. V.A.Tayursky
c
c  AMPLIT -> KO_AMPLIT
c  SPIN   -> KO_SPIN
c  CHOICE -> KO_CHOICE
c  INITDK -> KO_INITDK
c
c  COMMON /.../ -> /KO.../ except /PH.../
c
c  Last corection: 23.01.2006. V.A.Tayursky
c
c  1) neutrinos included in output event
c  2) in common-block /userpar/ included upar(1)=jak1, upar(2)=jak2
c
c*******************************************************************
c
! ..., IEVENT, ... , NEVENT, ...
#include "gcflag.inc"  
      PARAMETER (NMXHEP=2000)
      COMMON /HEPEVT/ NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
     &JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP)
      DOUBLE PRECISION PHEP,VHEP
c
      DIMENSION IRECORD(2,38),KPART(100),EVENT(6,100)
      REAL *4 E1(3),E2(3),PB1(4),PB2(4),XPR(40)
      INTEGER NPR(40)

      SAVE ICALL,XPR,NPR
c........
c  Array connecting HEP-code(1) with GEANT-code(2)
      DATA IRECORD/11,3, -11,2, 12,4,  13,6, -13,5,
     +     22,1, 111,7, 211,8, -211,9, 221,17, 310,16, 130,10,
     +     321,11, -321,12,
     +     2112,13, -2112,25, 3112,21, -3112,29, 3122,18,
     +    -3122,26, 3212,20, -3212,28, 3222,19, -3222,27, 3312,23,
     +    -3312,31, 3322,22, -3322,30, 3334,24, -3334,32, 1011,45,
     +     1021,46, 1022,47, 100,48, 1012,49, 2212,14, -2212,15,
     +     20022,50/
c
      DATA ICALL/0/
c
      ICALL=ICALL+1
      IF(ICALL.GT.1) GOTO 1
c++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c
c  Input parameters of generator. For more comments see:
c
c   1)  UPDATE TO THE KORALB LONG WRITE UP
c   2)  CHAPTER 5 OF  TAUOLA LONG WRITE UP
c
c++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c
c      ENE    = 1.77849             ! energy of beam (tau experiment)
      SIGENE = 0.0                  ! sigma of beam energy (is not used)
      WRITE(6,7001) ENE,SIGENE
      KFB=-11      ! flavor identifier of beam (electron and positron)
c
      DO I=1,3
        E1(I)=0    ! spin polarization vector of 1-st beam in e rest fra
        E2(I)=0    ! spin polarization vector of 2-nd beam in e rest fra
        PB1(I)=0   ! 3-momentum of 1-st beam
        PB2(I)=0   ! 3-momentum of 2-nd beam
      END DO
c
      PB1(3)=ENE   ! Pz of 1-st beam, GeV/c
      PB2(3)=-ENE  ! Pz of 2-nd beam, GeV/c
      PB1(4)=ENE
      PB2(4)=ENE
      E1(1)=0
      E2(1)=0
      SINW2=.23    ! sin^2 teta of Winberg is used for KEYGSW=1
      INRAN=17     ! >= 1: initialization of RNG in tau pair production
c
      AMZ=91.2     ! mass of Z
      GAMZ=2.5     ! width of Z
      GV=1         ! vector coupling constant g_v
      GA=-1        ! axial coupling constant g_a of tau to W in tau deca
      AMNUTA=0.010 ! mass of nu_tau
c      XK0=0.01     ! soft/hard photon cut-off for QED bremmstahlung
      AMFIN=2.     ! mass of the final state quark for ITFIN > 2
c
      NPR(1)=ISPIN
      NPR(2)=INRAN
      NPR(3)=KEYGSW
      NPR(4)=KEYRAD
      NPR(5)=JAK1
      NPR(6)=JAK2
      NPR(7)=ITFIN
      NPR(8)=ITDKRC
      NPR(9)=ITRANS
      NPR(11)=IFZET
      XPR(1)=AMZ
      XPR(2)=GAMZ
      XPR(6)=SINW2
      XPR(4)=GV
      XPR(5)=GA
      XPR(8)=AMNUTA
      XPR(11)=XK0
      XPR(14)=AMFIN
      XPR(13)=1.0  ! maximum photon energy generated, in sqrt(s/4) units
c
c   Initialization
c
      CALL KORALB(-1,KFB,PB1,E1,-KFB,PB2,E2,XPR,NPR)
c
c      NU=2 ! number of user parameters from simulation in /userpar/,  T.V.A.
c
c-- Generation mode -----------------------------------------------
c
 1    CONTINUE
c
      CALL KORALB(0 ,KFB,PB1,E1,-KFB,PB2,E2,XPR,NPR)
c
      CALL LUHEPC(2) ! converts between /LUJETS/ and /HEPEVT/ records
c
      NSTABL=0       ! counter of stabler particles without neutrino
c
      DO 4 I=1,NHEP
        IF(ISTHEP(I).NE.1) GOTO 4
c
c  Only stable particles. For all neutrino KF-type = 12  -> GEANT-type=4
c
          INU=IABS(IDHEP(I))
c
          IF(INU.EQ.14.OR.INU.EQ.16) INU=12

          NSTABL=NSTABL+1
c
          IF(INU.NE.12) THEN
            KPART(NSTABL)=IDHEP(I)
          ELSE
            KPART(NSTABL)=12
          END IF
c
        DO 6 J=1,3
          EVENT(J,NSTABL)=PHEP(J,I)          ! momentum, GeV/c
          EVENT(J+3,NSTABL)=VHEP(J,I)*100    ! vertex, cm
 6      CONTINUE
c
 4    CONTINUE
c
      DO 5 I=1,NSTABL
c
c  Transformation HEP-code -> GEANT-code
c
        KGEANT=0
c
        DO J=1,38
c
          IF(KPART(I).EQ.IRECORD(1,J)) KGEANT=IRECORD(2,J)
c
        END DO
c
        KPART(I)=KGEANT  ! now particle code is GEANT one
c
c	 PRINT 3,KGEANT,(EVENT(J,I),J=1,6)
c        WRITE(6,3) ICALL,I,KGEANT,(EVENT(J,I),J=1,3)
 5    CONTINUE
c
c
c  Postgeneration, printouts
c
      IF(IEVENT.EQ.NEVENT) CALL KORALB( 1,0,PB1,E1,0,PB2,E2,XPR,NPR)
c
7001  FORMAT(//4(/1X,15(5H=====))
     $ /,' ',     19X,'       THE MONTE CARLO PROGRAM          ',9X,1H ,
     $ /,' ',     19X,'              KORALB                    ',9X,1H ,
     $ /,' ',     19X,' PREP. CERN-TH 7272, MAY 1994 (V.2.4)   ',9X,1H ,
     $  2(/,1X,15(5H=====)),
     $ /,5X ,'ENE   =',F7.2,'  BEAM ENERGY                     ',9X,1H ,
     $ /,5X ,'SIGMA =',F7.2,'  SIGMA OF BEAM ENERGY            ',9X,1H ,
     $  2(/,1X,15(5H=====))/)
      END


      SUBROUTINE KO_CHOICE(MNUM,RR,ICHAN,PROB1,PROB2,PROB3,
     $            AMRX,GAMRX,AMRA,GAMRA,AMRB,GAMRB)
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      AMROP=1.1
      GAMROP=0.36
      AMOM=.782
      GAMOM=0.0084
C     XXXXA CORRESPOND TO S2 CHANNEL !
      IF(MNUM.EQ.0) THEN
       PROB1=0.5
       PROB2=0.5
       AMRX =AMA1
       GAMRX=GAMA1
       AMRA =AMRO
       GAMRA=GAMRO
       AMRB =AMRO
       GAMRB=GAMRO
      ELSEIF(MNUM.EQ.1) THEN
       PROB1=0.5
       PROB2=0.5
       AMRX =1.57
       GAMRX=0.9
       AMRB =AMKST
       GAMRB=GAMKST
       AMRA =AMRO
       GAMRA=GAMRO
      ELSEIF(MNUM.EQ.2) THEN
       PROB1=0.5
       PROB2=0.5
       AMRX =1.57
       GAMRX=0.9
       AMRB =AMKST
       GAMRB=GAMKST
       AMRA =AMRO
       GAMRA=GAMRO
      ELSEIF(MNUM.EQ.3) THEN
       PROB1=0.5
       PROB2=0.5
       AMRX =1.27
       GAMRX=0.3
       AMRA =AMKST
       GAMRA=GAMKST
       AMRB =AMKST
       GAMRB=GAMKST
      ELSEIF(MNUM.EQ.4) THEN
       PROB1=0.5
       PROB2=0.5
       AMRX =1.27
       GAMRX=0.3
       AMRA =AMKST
       GAMRA=GAMKST
       AMRB =AMKST
       GAMRB=GAMKST
      ELSEIF(MNUM.EQ.5) THEN
       PROB1=0.5
       PROB2=0.5
       AMRX =1.27
       GAMRX=0.3
       AMRA =AMKST
       GAMRA=GAMKST
       AMRB =AMRO
       GAMRB=GAMRO
      ELSEIF(MNUM.EQ.6) THEN
       PROB1=0.4
       PROB2=0.4
       AMRX =1.27
       GAMRX=0.3
       AMRA =AMRO
       GAMRA=GAMRO
       AMRB =AMKST
       GAMRB=GAMKST
      ELSEIF(MNUM.EQ.7) THEN
       PROB1=0.0
       PROB2=1.0
       AMRX =1.27
       GAMRX=0.9
       AMRA =AMRO
       GAMRA=GAMRO
       AMRB =AMRO
       GAMRB=GAMRO
      ELSEIF(MNUM.EQ.8) THEN
       PROB1=0.0
       PROB2=1.0
       AMRX =AMROP
       GAMRX=GAMROP
       AMRB =AMOM
       GAMRB=GAMOM
       AMRA =AMRO
       GAMRA=GAMRO
      ELSEIF(MNUM.EQ.101) THEN
       PROB1=.35
       PROB2=.35
       AMRX =1.2
       GAMRX=.46
       AMRB =AMOM
       GAMRB=GAMOM
       AMRA =AMOM
       GAMRA=GAMOM
      ELSEIF(MNUM.EQ.102) THEN
       PROB1=0.0
       PROB2=0.0
       AMRX =1.4
       GAMRX=.6
       AMRB =AMOM
       GAMRB=GAMOM
       AMRA =AMOM
       GAMRA=GAMOM
      ELSE
       PROB1=0.0
       PROB2=0.0
       AMRX =AMA1
       GAMRX=GAMA1
       AMRA =AMRO
       GAMRA=GAMRO
       AMRB =AMRO
       GAMRB=GAMRO
      ENDIF
C
      IF    (RR.LE.PROB1) THEN
       ICHAN=1
      ELSEIF(RR.LE.(PROB1+PROB2)) THEN
       ICHAN=2
        AX   =AMRA
        GX   =GAMRA
        AMRA =AMRB
        GAMRA=GAMRB
        AMRB =AX
        GAMRB=GX
        PX   =PROB1
        PROB1=PROB2
        PROB2=PX
      ELSE
       ICHAN=3
      ENDIF
C
      PROB3=1.0-PROB1-PROB2
      END


      SUBROUTINE KO_INITDK
* ----------------------------------------------------------------------
*     INITIALISATION OF TAU DECAY PARAMETERS  and routines
*
*     called by : KORALZ
* ----------------------------------------------------------------------

      COMMON /KODECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
*
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON /KOTAUBRA / GAMPRT(30),JLIST(30),NCHAN
      COMMON /KOTAUKLE / BRA1,BRK0,BRK0B,BRKS
      REAL*4            BRA1,BRK0,BRK0B,BRKS

      PARAMETER (NMODE=15,NM1=0,NM2=1,NM3=8,NM4=2,NM5=1,NM6=3)
      COMMON /KOTAUDCD /IDFFIN(9,NMODE),MULPIK(NMODE)
     &                ,NAMES
      CHARACTER NAMES(NMODE)*31

      CHARACTER OLDNAMES(7)*31
      CHARACTER*80 bxINIT
      PARAMETER (
     $  bxINIT ='(1x,1h*,g17.8,            16x, a31,a4,a4, 1x,1h*)'
     $ )
      REAL*4 PI
c     REAL POL1(4)
*
*
* LIST OF BRANCHING RATIOS
CAM normalised to e nu nutau channel
CAM                  enu   munu   pinu  rhonu   A1nu   Knu    K*nu   pi
CAM   DATA JLIST  /    1,     2,     3,     4,     5,     6,     7,

*AM   DATA GAMPRT /1.000,0.9730,0.6054,1.2432,0.8432,0.0432,O.O811,0.616
*AM
*AM  multipion decays
*
*    conventions of particles names
*                 K-,P-,K+,  K0,P-,KB,  K-,P0,K0
*                  3, 1,-3  , 4, 1,-4  , 3, 2, 4  ,
*                 P0,P0,K-,  K-,P-,P+,  P-,KB,P0
*                  2, 2, 3  , 3, 1,-1  , 1,-4, 2  ,
*                 ET,P-,P0   P-,P0,GM
*                  9, 1, 2  , 1, 2, 8
*

C
      DIMENSION NOPIK(6,NMODE),NPIK(NMODE)
*AM   outgoing multiplicity and flavors of multi-pion /multi-K modes
      DATA   NPIK  /                4,                    4,
     1                              5,                    5,
     2                              6,                    6,
     3                              3,                    3,
     4                              3,                    3,
     5                              3,                    3,
     6                              3,                    3,
     7                              2                         /

      DATA  NOPIK / -1,-1, 1, 2, 0, 0,     2, 2, 2,-1, 0, 0,
     1              -1,-1, 1, 2, 2, 0,    -1,-1,-1, 1, 1, 0,
     2              -1,-1,-1, 1, 1, 2,    -1,-1, 1, 2, 2, 2,
     3              -3,-1, 3, 0, 0, 0,    -4,-1, 4, 0, 0, 0,
     4              -3, 2,-4, 0, 0, 0,     2, 2,-3, 0, 0, 0,
     5              -3,-1, 1, 0, 0, 0,    -1, 4, 2, 0, 0, 0,
     6               9,-1, 2, 0, 0, 0,    -1, 2, 8, 0, 0, 0,


C AJWMOD fix sign bug, 2/22/99
     7              -3,-4, 0, 0, 0, 0                         /

* LIST OF BRANCHING RATIOS
      NCHAN = NMODE + 7
      DO 1 I = 1,30
      IF (I.LE.NCHAN) THEN
        JLIST(I) = I

        IF(I.EQ. 1) GAMPRT(I) =0.1800
        IF(I.EQ. 2) GAMPRT(I) =0.1751
        IF(I.EQ. 3) GAMPRT(I) =0.1110
        IF(I.EQ. 4) GAMPRT(I) =0.2515
        IF(I.EQ. 5) GAMPRT(I) =0.1790
        IF(I.EQ. 6) GAMPRT(I) =0.0071
        IF(I.EQ. 7) GAMPRT(I) =0.0134
        IF(I.EQ. 8) GAMPRT(I) =0.0450
        IF(I.EQ. 9) GAMPRT(I) =0.0100
        IF(I.EQ.10) GAMPRT(I) =0.0009
        IF(I.EQ.11) GAMPRT(I) =0.0004
        IF(I.EQ.12) GAMPRT(I) =0.0003
        IF(I.EQ.13) GAMPRT(I) =0.0005
        IF(I.EQ.14) GAMPRT(I) =0.0015
        IF(I.EQ.15) GAMPRT(I) =0.0015
        IF(I.EQ.16) GAMPRT(I) =0.0015
        IF(I.EQ.17) GAMPRT(I) =0.0005
        IF(I.EQ.18) GAMPRT(I) =0.0050
        IF(I.EQ.19) GAMPRT(I) =0.0055
        IF(I.EQ.20) GAMPRT(I) =0.0017
        IF(I.EQ.21) GAMPRT(I) =0.0013
        IF(I.EQ.22) GAMPRT(I) =0.0010

        IF(I.EQ. 1) OLDNAMES(I)='  TAU-  -->   E-               '
        IF(I.EQ. 2) OLDNAMES(I)='  TAU-  -->  MU-               '
        IF(I.EQ. 3) OLDNAMES(I)='  TAU-  -->  PI-               '
        IF(I.EQ. 4) OLDNAMES(I)='  TAU-  -->  PI-, PI0          '
        IF(I.EQ. 5) OLDNAMES(I)='  TAU-  -->  A1- (two subch)   '
        IF(I.EQ. 6) OLDNAMES(I)='  TAU-  -->   K-               '
        IF(I.EQ. 7) OLDNAMES(I)='  TAU-  -->  K*- (two subch)   '
        IF(I.EQ. 8) NAMES(I-7)='  TAU-  --> 2PI-,  PI0,  PI+   '
        IF(I.EQ. 9) NAMES(I-7)='  TAU-  --> 3PI0,        PI-   '
        IF(I.EQ.10) NAMES(I-7)='  TAU-  --> 2PI-,  PI+, 2PI0   '
        IF(I.EQ.11) NAMES(I-7)='  TAU-  --> 3PI-, 2PI+,        '
        IF(I.EQ.12) NAMES(I-7)='  TAU-  --> 3PI-, 2PI+,  PI0   '
        IF(I.EQ.13) NAMES(I-7)='  TAU-  --> 2PI-,  PI+, 3PI0   '
        IF(I.EQ.14) NAMES(I-7)='  TAU-  -->  K-, PI-,  K+      '
        IF(I.EQ.15) NAMES(I-7)='  TAU-  -->  K0, PI-, K0B      '

        IF(I.EQ.16) NAMES(I-7)='  TAU-  -->  K-,  K0, PI0      '

        IF(I.EQ.17) NAMES(I-7)='  TAU-  --> PI0  PI0   K-      '
        IF(I.EQ.18) NAMES(I-7)='  TAU-  -->  K-  PI-  PI+      '
        IF(I.EQ.19) NAMES(I-7)='  TAU-  --> PI-  K0B  PI0      '
        IF(I.EQ.20) NAMES(I-7)='  TAU-  --> ETA  PI-  PI0      '
        IF(I.EQ.21) NAMES(I-7)='  TAU-  --> PI-  PI0  GAM      '
        IF(I.EQ.22) NAMES(I-7)='  TAU-  -->  K-  K0            '
      ELSE
        JLIST(I) = 0
        GAMPRT(I) = 0.
      ENDIF
   1  CONTINUE
      DO I=1,NMODE
        MULPIK(I)=NPIK(I)
        DO J=1,MULPIK(I)
         IDFFIN(J,I)=NOPIK(J,I)
        ENDDO
      ENDDO
*
*
* --- COEFFICIENTS TO FIX RATIO OF:
* --- A1 3CHARGED/ A1 1CHARGED 2 NEUTRALS MATRIX ELEMENTS (MASLESS LIM.)
* --- PROBABILITY OF K0 TO BE KS
* --- PROBABILITY OF K0B TO BE KS
* --- RATIO OF COEFFICIENTS FOR K*--> K0 PI-
* --- ALL COEFFICENTS SHOULD BE IN THE RANGE (0.0,1.0)
* --- THEY MEANING IS PROBABILITY OF THE FIRST CHOICE ONLY IF ONE
* --- NEGLECTS MASS-PHASE SPACE EFFECTS
      BRA1=0.5
      BRK0=0.5
      BRK0B=0.5
      BRKS=0.6667
*

      GFERMI = 1.16637E-5
      CCABIB = 0.975
      GV     = 1.0
      GA     =-1.0



* ZW 13.04.89 HERE WAS AN ERROR
      SCABIB = SQRT(1.-CCABIB**2)
      PI =4.*ATAN(1.)
      GAMEL  = GFERMI**2*AMTAU**5/(192*PI**3)
*
*      CALL DEXAY(-1,pol1)
*
      RETURN
      END


      FUNCTION DCDMAS(IDENT)
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
*
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      IF      (IDENT.EQ. 1) THEN
        APKMAS=AMPI
      ELSEIF  (IDENT.EQ.-1) THEN
        APKMAS=AMPI
      ELSEIF  (IDENT.EQ. 2) THEN
        APKMAS=AMPIZ
      ELSEIF  (IDENT.EQ.-2) THEN
        APKMAS=AMPIZ
      ELSEIF  (IDENT.EQ. 3) THEN
        APKMAS=AMK
      ELSEIF  (IDENT.EQ.-3) THEN
        APKMAS=AMK
      ELSEIF  (IDENT.EQ. 4) THEN
        APKMAS=AMKZ
      ELSEIF  (IDENT.EQ.-4) THEN
        APKMAS=AMKZ
      ELSEIF  (IDENT.EQ. 8) THEN
        APKMAS=0.0001
      ELSEIF  (IDENT.EQ.-8) THEN
        APKMAS=0.0001
      ELSEIF  (IDENT.EQ. 9) THEN
        APKMAS=0.5488
      ELSEIF  (IDENT.EQ.-9) THEN
        APKMAS=0.5488
      ELSE
        PRINT *, 'STOP IN APKMAS, WRONG IDENT=',IDENT
        STOP
      ENDIF
      DCDMAS=APKMAS
      END


      FUNCTION LUNPIK(ID,ISGN)
      COMMON /KOTAUKLE / BRA1,BRK0,BRK0B,BRKS
      REAL*4            BRA1,BRK0,BRK0B,BRKS
      REAL*4 XIO(1),RLU
c
      IDENT=ID*ISGN

      IF      (IDENT.EQ. 1) THEN
        IPKDEF=-211
      ELSEIF  (IDENT.EQ.-1) THEN
        IPKDEF= 211
      ELSEIF  (IDENT.EQ. 2) THEN
        IPKDEF=111
      ELSEIF  (IDENT.EQ.-2) THEN
        IPKDEF=111
      ELSEIF  (IDENT.EQ. 3) THEN
        IPKDEF=-321
      ELSEIF  (IDENT.EQ.-3) THEN
        IPKDEF= 321

      ELSEIF  (IDENT.EQ. 4) THEN
*
* K0 --> K0_LONG (IS 130) / K0_SHORT (IS 310) = 1/1
c
        XIO(1)=RLU(0)
c        CALL GRNDM(XIO,1)
c
        IF (XIO(1).GT.BRK0) THEN
          IPKDEF= 130
        ELSE
          IPKDEF= 310
        ENDIF
      ELSEIF  (IDENT.EQ.-4) THEN
*
* K0B--> K0_LONG (IS 130) / K0_SHORT (IS 310) = 1/1
c
        XIO(1)=RLU(0)
c        CALL GRNDM(XIO,1)
c
        IF (XIO(1).GT.BRK0B) THEN
          IPKDEF= 130
        ELSE
          IPKDEF= 310
        ENDIF
      ELSEIF  (IDENT.EQ. 8) THEN
        IPKDEF= 22
      ELSEIF  (IDENT.EQ.-8) THEN
        IPKDEF= 22
      ELSEIF  (IDENT.EQ. 9) THEN
        IPKDEF= 221
      ELSEIF  (IDENT.EQ.-9) THEN
        IPKDEF= 221
      ELSE
        PRINT *, 'STOP IN IPKDEF, WRONG IDENT=',IDENT
        STOP
      ENDIF
      LUNPIK=IPKDEF
      END


      SUBROUTINE TAURDF(KTO)
c**********************************************************************
c
c THIS ROUTINE CAN BE CALLED BEFORE ANY TAU+ OR TAU- EVENT IS GENERATED
c IT CAN BE USED TO GENERATE TAU+ AND TAU- SAMPLES OF DIFFERENT
c CONTENTS
c
c*********************************************************************
      COMMON /KOTAUKLE / BRA1,BRK0,BRK0B,BRKS
      REAL*4            BRA1,BRK0,BRK0B,BRKS
      COMMON /KOTAUBRA / GAMPRT(30),JLIST(30),NCHAN
c
      IF (KTO.EQ.1) THEN
C     ==================
C AJWMOD: Set the BRs for (A1+ -> rho+ pi0) and (K*+ -> K0 pi+)
      BRA1 = PKORB(4,1)
      BRKS = PKORB(4,3)
      BRK0  = PKORB(4,5)
      BRK0B  = PKORB(4,6)
      ELSE
C     ====
C AJWMOD: Set the BRs for (A1+ -> rho+ pi0) and (K*+ -> K0 pi+)
      BRA1 = PKORB(4,2)
      BRKS = PKORB(4,4)
      BRK0  = PKORB(4,5)
      BRK0B  = PKORB(4,6)
      ENDIF
C     =====
      END


      SUBROUTINE INIPHY(XK00)
* ----------------------------------------------------------------------
*     INITIALISATION OF PARAMETERS
*     USED IN QED and/or GSW ROUTINES
* ----------------------------------------------------------------------
      COMMON /KOQEDPRM /ALFINV,ALFPI,XK0
      REAL*8           ALFINV,ALFPI,XK0
      REAL*8 PI8,XK00
*
      PI8    = 4.D0*DATAN(1.D0)
      ALFINV = 137.03604D0
      ALFPI  = 1D0/(ALFINV*PI8)
      XK0=XK00
      END


      SUBROUTINE INIMAS
C ----------------------------------------------------------------------
C     INITIALISATION OF MASSES
C
C     called by : KORALZ
C ----------------------------------------------------------------------
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
*
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
C IN-COMING / OUT-GOING  FERMION MASSES
      AMTAU  = 1.7842
C --- let us update tau mass ...
      AMTAU  = 1.777
      AMNUTA = 0.010
      AMEL   = 0.0005111
      AMNUE  = 0.0
      AMMU   = 0.105659
      AMNUMU = 0.0
*
* MASSES USED IN TAU DECAYS

      AMPIZ  = 0.134964
      AMPI   = 0.139568
      AMRO   = 0.773
      GAMRO  = 0.145
*C    GAMRO  = 0.666
      AMA1   = 1.251
      GAMA1  = 0.599
      AMK    = 0.493667
      AMKZ   = 0.49772
      AMKST  = 0.8921
      GAMKST = 0.0513
C
C
C IN-COMING / OUT-GOING  FERMION MASSES
!!      AMNUTA = PKORB(1,2)
!!      AMNUE  = PKORB(1,4)
!!      AMNUMU = PKORB(1,6)
C
C MASSES USED IN TAU DECAYS  Cleo settings
!!      AMPIZ  = PKORB(1,7)
!!      AMPI   = PKORB(1,8)
!!      AMRO   = PKORB(1,9)
!!      GAMRO  = PKORB(2,9)
      AMA1   = 1.275   !! PKORB(1,10)
      GAMA1  = 0.615   !! PKORB(2,10)
!!      AMK    = PKORB(1,11)
!!      AMKZ   = PKORB(1,12)
!!      AMKST  = PKORB(1,13)
!!      GAMKST = PKORB(2,13)
C
      RETURN
      END


*AJW 1 version of CURR from KORALB.

      SUBROUTINE CURR_CLEO(MNUM,PIM1,PIM2,PIM3,PIM4,HADCUR)
C     ==================================================================
C AJW, 11/97 - based on original CURR from TAUOLA:
C     hadronic current for 4 pi final state
C     R. Fisher, J. Wess and F. Wagner Z. Phys C3 (1980) 313
C     R. Decker Z. Phys C36 (1987) 487.
C     M. Gell-Mann, D. Sharp, W. Wagner Phys. Rev. Lett 8 (1962) 261.
C BUT, rewritten to be more general and less "theoretical",
C  using parameters tuned by Vasia and DSC.
C     ==================================================================

      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL  PIM1(4),PIM2(4),PIM3(4),PIM4(4)
      COMPLEX HADCUR(4)

      INTEGER K,L,MNUM,K1,K2,I,J,KK
c      INTEGER IRO
      REAL PA(4),PB(4),PAA(4)
      REAL AA(4,4),PP(4,4)
      REAL A,XM,XG,G1,G2,G,AMRO2,GAMRO2,AMRO3,GAMRO3,AMOM,GAMOM
      REAL FRO,COEF1,FPI,COEF2,QQ,SK,DENOM,SIG,QQA,SS23,SS24,SS34,QP1P2
      REAL QP1P3,QP1P4,P1P2,P1P3,P1P4,SIGN
      REAL PKORB,AMPA
      COMPLEX ALF0,ALF1,ALF2,ALF3
      COMPLEX LAM0,LAM1,LAM2,LAM3
      COMPLEX BET1,BET2,BET3
      COMPLEX FORM1,FORM2,FORM3,FORM4,FORM2PI
      COMPLEX BWIGM,FPIKM
c     COMPLEX WIGFOR,FPIKMD
      COMPLEX AMPL(7),AMPR
      COMPLEX BWIGN
C
      BWIGN(A,XM,XG)=1.0/CMPLX(A-XM**2,XM*XG)
C***********************************************************************
C
C --- masses and constants
      IF (G1.NE.12.924) THEN
      G1=12.924
      G2=1475.98
      FPI=93.3E-3
      G =G1*G2
      FRO=0.266*AMRO**2
      COEF1=2.0*SQRT(3.0)/FPI**2
      COEF2=FRO*G

C masses and widths for for rho-prim and rho-bis:
      AMRO2 = 1.465
      GAMRO2= 0.310
      AMRO3=1.700
      GAMRO3=0.235
C
      AMOM  = PKORB(1,14)
      GAMOM = PKORB(2,14)
      AMRO2 = PKORB(1,21)
      GAMRO2= PKORB(2,21)
      AMRO3 = PKORB(1,22)
      GAMRO3= PKORB(2,22)
C
C Amplitudes for (pi-pi-pi0pi+) -> PS, rho0, rho-, rho+, omega.
      AMPL(1) = CMPLX(PKORB(3,31)*COEF1,0.)
      AMPL(2) = CMPLX(PKORB(3,32)*COEF1,0.)*CEXP(CMPLX(0.,PKORB(3,42)))
      AMPL(3) = CMPLX(PKORB(3,33)*COEF1,0.)*CEXP(CMPLX(0.,PKORB(3,43)))
      AMPL(4) = CMPLX(PKORB(3,34)*COEF1,0.)*CEXP(CMPLX(0.,PKORB(3,44)))
      AMPL(5) = CMPLX(PKORB(3,35)*COEF2,0.)*CEXP(CMPLX(0.,PKORB(3,45)))
C Amplitudes for (pi0pi0pi0pi-) -> PS, rho-.
      AMPL(6) = CMPLX(PKORB(3,36)*COEF1)
      AMPL(7) = CMPLX(PKORB(3,37)*COEF1)
C
C rho' contributions to rho' -> pi-omega:
      ALF0 = CMPLX(PKORB(3,51),0.0)
      ALF1 = CMPLX(PKORB(3,52)*AMRO**2,0.0)
      ALF2 = CMPLX(PKORB(3,53)*AMRO2**2,0.0)
      ALF3 = CMPLX(PKORB(3,54)*AMRO3**2,0.0)
C rho' contribtions to rho' -> rhopipi:
      LAM0 = CMPLX(PKORB(3,55),0.0)
      LAM1 = CMPLX(PKORB(3,56)*AMRO**2,0.0)
      LAM2 = CMPLX(PKORB(3,57)*AMRO2**2,0.0)
      LAM3 = CMPLX(PKORB(3,58)*AMRO3**2,0.0)
C rho contributions to rhopipi, rho -> 2pi:
      BET1 = CMPLX(PKORB(3,59)*AMRO**2,0.0)
      BET2 = CMPLX(PKORB(3,60)*AMRO2**2,0.0)
      BET3 = CMPLX(PKORB(3,61)*AMRO3**2,0.0)
C
      END IF
C**************************************************
C
C --- initialization of four vectors
      DO 7 K=1,4
      DO 8 L=1,4
 8    AA(K,L)=0.0
      HADCUR(K)=CMPLX(0.0)
      PAA(K)=PIM1(K)+PIM2(K)+PIM3(K)+PIM4(K)
      PP(1,K)=PIM1(K)
      PP(2,K)=PIM2(K)
      PP(3,K)=PIM3(K)
 7    PP(4,K)=PIM4(K)
C
      IF (MNUM.EQ.1) THEN
C ===================================================================
C pi- pi- p0 pi+ case                                            ====
C ===================================================================
       QQ=PAA(4)**2-PAA(3)**2-PAA(2)**2-PAA(1)**2

C  Add M(4pi)-dependence to rhopipi channels:
       FORM4= LAM0+LAM1*BWIGN(QQ,AMRO,GAMRO)
     *            +LAM2*BWIGN(QQ,AMRO2,GAMRO2)
     *            +LAM3*BWIGN(QQ,AMRO3,GAMRO3)

C --- loop over five contributions of the rho-pi-pi
       DO 201 K1=1,3
       DO 201 K2=3,4
C
         IF (K2.EQ.K1) THEN
           GOTO 201
         ELSEIF (K2.EQ.3) THEN
C rho-
            AMPR = AMPL(3)
            AMPA = AMPIZ
         ELSEIF (K1.EQ.3) THEN
C rho+
            AMPR = AMPL(4)
            AMPA = AMPIZ
         ELSE
C rho0
            AMPR = AMPL(2)
            AMPA = AMPI
         END IF
C
         SK=(PP(K1,4)+PP(K2,4))**2-(PP(K1,3)+PP(K2,3))**2
     $     -(PP(K1,2)+PP(K2,2))**2-(PP(K1,1)+PP(K2,1))**2

C -- definition of AA matrix
C -- cronecker delta
        DO 202 I=1,4
         DO 203 J=1,4
 203     AA(I,J)=0.0
 202    AA(I,I)=1.0
C ... and the rest ...
        DO 204 L=1,4
         IF (L.NE.K1.AND.L.NE.K2) THEN
          DENOM=(PAA(4)-PP(L,4))**2-(PAA(3)-PP(L,3))**2
     $         -(PAA(2)-PP(L,2))**2-(PAA(1)-PP(L,1))**2
          DO 205 I=1,4
          DO 205 J=1,4
                      SIG= 1.0
           IF(J.NE.4) SIG=-SIG
           AA(I,J)=AA(I,J)
     $            -SIG*(PAA(I)-2.0*PP(L,I))*(PAA(J)-PP(L,J))/DENOM
 205      CONTINUE
         ENDIF
 204    CONTINUE
C
C --- lets add something to HADCURR
C        FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKM(SQRT(QQ),AMPI,AMPI)
C        FORM1= AMPL(1)+AMPR*FPIKM(SQRT(SK),AMPI,AMPI)

        FORM2PI= BET1*BWIGM(SK,AMRO,GAMRO,AMPA,AMPI)
     1          +BET2*BWIGM(SK,AMRO2,GAMRO2,AMPA,AMPI)
     2          +BET3*BWIGM(SK,AMRO3,GAMRO3,AMPA,AMPI)
        FORM1= AMPL(1)+AMPR*FORM2PI
C
       DO 206 I=1,4
       DO 206 J=1,4
        HADCUR(I)=HADCUR(I)+FORM1*FORM4*AA(I,J)*(PP(K1,J)-PP(K2,J))
 206   CONTINUE
C --- end of the rho-pi-pi current (5 possibilities)
 201   CONTINUE
C
C ===================================================================
C Now modify the coefficient for the omega-pi current:              =
C ===================================================================
       IF (AMPL(5).EQ.CMPLX(0.,0.)) GOTO 311

C Overall rho+rhoprime for the 4pi system:
C       FORM2=AMPL(5)*(BWIGN(QQ,AMRO,GAMRO)+ELPHA*BWIGN(QQ,AMROP,GAMROP)
C Modified M(4pi)-dependence:
       FORM2=AMPL(5)*(ALF0+ALF1*BWIGN(QQ,AMRO,GAMRO)
     *                    +ALF2*BWIGN(QQ,AMRO2,GAMRO2)
     *                    +ALF3*BWIGN(QQ,AMRO3,GAMRO3))
C
C --- there are two possibilities for omega current
C --- PA PB are corresponding first and second pi-s
       DO 301 KK=1,2
        DO 302 I=1,4
         PA(I)=PP(KK,I)
         PB(I)=PP(3-KK,I)
 302    CONTINUE
C --- lorentz invariants
         QQA=0.0
         SS23=0.0
         SS24=0.0
         SS34=0.0
         QP1P2=0.0
         QP1P3=0.0
         QP1P4=0.0
         P1P2 =0.0
         P1P3 =0.0
         P1P4 =0.0
        DO 303 K=1,4
                     SIGN=-1.0
         IF (K.EQ.4) SIGN= 1.0
         QQA=QQA+SIGN*(PAA(K)-PA(K))**2
         SS23=SS23+SIGN*(PB(K)  +PIM3(K))**2
         SS24=SS24+SIGN*(PB(K)  +PIM4(K))**2
         SS34=SS34+SIGN*(PIM3(K)+PIM4(K))**2
         QP1P2=QP1P2+SIGN*(PAA(K)-PA(K))*PB(K)
         QP1P3=QP1P3+SIGN*(PAA(K)-PA(K))*PIM3(K)
         QP1P4=QP1P4+SIGN*(PAA(K)-PA(K))*PIM4(K)
         P1P2=P1P2+SIGN*PA(K)*PB(K)
         P1P3=P1P3+SIGN*PA(K)*PIM3(K)
         P1P4=P1P4+SIGN*PA(K)*PIM4(K)
 303    CONTINUE
C
C omega -> rho pi for the 3pi system:
C       FORM3=BWIGN(QQA,AMOM,GAMOM)*(BWIGN(SS23,AMRO,GAMRO)+
C     $        BWIGN(SS24,AMRO,GAMRO)+BWIGN(SS34,AMRO,GAMRO))
C No omega -> rho pi; just straight omega:
        FORM3=BWIGN(QQA,AMOM,GAMOM)
C
        DO 304 K=1,4
         HADCUR(K)=HADCUR(K)+FORM2*FORM3*(
     $             PB  (K)*(QP1P3*P1P4-QP1P4*P1P3)
     $            +PIM3(K)*(QP1P4*P1P2-QP1P2*P1P4)
     $            +PIM4(K)*(QP1P2*P1P3-QP1P3*P1P2) )
 304    CONTINUE
 301   CONTINUE
 311   CONTINUE
C
      ELSE
C ===================================================================
C pi0 pi0 p0 pi- case                                            ====
C ===================================================================
       QQ=PAA(4)**2-PAA(3)**2-PAA(2)**2-PAA(1)**2

C --- loop over three contribution of the non-omega current
       DO 101 K=1,3
        SK=(PP(K,4)+PIM4(4))**2-(PP(K,3)+PIM4(3))**2
     $    -(PP(K,2)+PIM4(2))**2-(PP(K,1)+PIM4(1))**2

C -- definition of AA matrix
C -- cronecker delta
        DO 102 I=1,4
         DO 103 J=1,4
 103     AA(I,J)=0.0
 102    AA(I,I)=1.0
C
C ... and the rest ...
        DO 104 L=1,3
         IF (L.NE.K) THEN
          DENOM=(PAA(4)-PP(L,4))**2-(PAA(3)-PP(L,3))**2
     $         -(PAA(2)-PP(L,2))**2-(PAA(1)-PP(L,1))**2
          DO 105 I=1,4
          DO 105 J=1,4
                      SIG=1.0
           IF(J.NE.4) SIG=-SIG
           AA(I,J)=AA(I,J)
     $            -SIG*(PAA(I)-2.0*PP(L,I))*(PAA(J)-PP(L,J))/DENOM
 105      CONTINUE
         ENDIF
 104    CONTINUE

C --- lets add something to HADCURR
C       FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKMD(SQRT(QQ),AMPI,AMPI)
CCCCCCCCCCCCC       FORM1=WIGFOR(SK,AMRO,GAMRO)        (tests)
C       FORM1= FPIKM(SQRT(SK),AMPI,AMPI) *FPIKM(SQRT(QQ),AMPI,AMPI)
       FORM1 = AMPL(6)+AMPL(7)*FPIKM(SQRT(SK),AMPI,AMPI)

        DO 106 I=1,4
        DO 106 J=1,4
         HADCUR(I)=HADCUR(I)+FORM1*AA(I,J)*(PP(K,J)-PP(4,J))
 106    CONTINUE
C --- end of the non omega current (3 possibilities)
 101   CONTINUE

      ENDIF
      END



*AJW 1 version of a1 form factor
      COMPLEX FUNCTION F3PI(IFORM,QQ,SA,SB)
C.......................................................................
C.
C. F3PI - 1 version of a1 form factor, used in TAUOLA
C.
C. Inputs    : None
C.           :
C. Outputs   : None
C.
C. COMMON    : None
C.
C. Calls     :
C. Called    : by FORM1-FORM3 in $C_CVSSRC/korb/koralb/formf.F
C. Author    : Alan Weinstein 2/98
C.
C. Detailed description
C.   First determine whether we are doing pi-2pi0 or 3pi.
C.   Then implement full form-factor from fit:
C.   [(rho-pi S-wave) + (rho-prim-pi S-wave) +
C.    (rho-pi D-wave) + (rho-prim-pi D-wave) +
C.    (f2 pi D-wave) + (sigmapi S-wave) + (f0pi S-wave)]
C.   based on fit to pi-2pi0 by M. Schmidler, CBX 97-64-Update (4/22/98)
C.   All the parameters in this routine are hard-coded!!
C.
C.......................................................................

* -------------------- Argument declarations ---------------

      INTEGER IFORM
      REAL QQ,SA,SB
* -------------------- EXTERNAL declarations ---------------
*
      REAL PKORB
      COMPLEX BWIGML
* -------------------- SEQUENCE declarations ---------------
*
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'F3PI' )
*
      INTEGER IFIRST,IDK
      REAL MRO,GRO,MRP,GRP,MF2,GF2,MF0,GF0,MSG,GSG
      REAL M1,M2,M3,M1SQ,M2SQ,M3SQ,MPIZ,MPIC
      REAL S1,S2,S3,R,PI
      REAL F134,F150,F15A,F15B,F167
      REAL F34A,F34B,F35,F35A,F35B,F36A,F36B
      COMPLEX BT1,BT2,BT3,BT4,BT5,BT6,BT7
      COMPLEX FRO1,FRO2,FRP1,FRP2
      COMPLEX FF21,FF22,FF23,FSG1,FSG2,FSG3,FF01,FF02,FF03
      COMPLEX FA1A1P,FORMA1

* -------------------- SAVE     declarations ---------------
*
* -------------------- DATA  initializations ---------------
*
      DATA IFIRST/0/
* ----------------- Executable code starts here ------------
*
C. Hard-code the fit parameters:
      IF (IFIRST.EQ.0) THEN
        IFIRST = 1
C rho, rhoprime, f2(1275), f0(1186), sigma(made up!)
        MRO = 0.7743
        GRO = 0.1491
        MRP = 1.370
        GRP = 0.386
        MF2 = 1.275
        GF2 = 0.185
        MF0 = 1.186
        GF0 = 0.350
        MSG = 0.860
        GSG = 0.880
        MPIZ = PKORB(1,7)
        MPIC = PKORB(1,8)

C Fit coefficients for each of the contributions:
        PI = 3.14159
        BT1 = CMPLX(1.,0.)
        BT2 = CMPLX(0.12,0.)*CEXP(CMPLX(0., 0.99*PI))
        BT3 = CMPLX(0.37,0.)*CEXP(CMPLX(0.,-0.15*PI))
        BT4 = CMPLX(0.87,0.)*CEXP(CMPLX(0., 0.53*PI))
        BT5 = CMPLX(0.71,0.)*CEXP(CMPLX(0., 0.56*PI))
        BT6 = CMPLX(2.10,0.)*CEXP(CMPLX(0., 0.23*PI))
        BT7 = CMPLX(0.77,0.)*CEXP(CMPLX(0.,-0.54*PI))

        PRINT *,' In F3pi: add (rho-pi S-wave) + (rhop-pi S-wave) +'
        PRINT *,'              (rho-pi D-wave) + (rhop-pi D-wave) +'
        PRINT *,'   (f2 pi D-wave) + (sigmapi S-wave) + (f0pi S-wave)'
      END IF

C Initialize to 0:
      F3PI = CMPLX(0.,0.)

C.   First determine whether we are doing pi-2pi0 or 3pi.
C     PKORB is set up to remember what flavor of 3pi it gave to KORALB,
C     since KORALB doesnt bother to remember!!
      R = PKORB(4,11)
      IF (R.EQ.0.) THEN
C it is 2pi0pi-
        IDK = 1
        M1 = MPIZ
        M2 = MPIZ
        M3 = MPIC
      ELSE
C it is 3pi
        IDK = 2
        M1 = MPIC
        M2 = MPIC
        M3 = MPIC
      END IF
      M1SQ = M1*M1
      M2SQ = M2*M2
      M3SQ = M3*M3

C.   Then implement full form-factor from fit:
C.   [(rho-pi S-wave) + (rho-prim-pi S-wave) +
C.    (rho-pi D-wave) + (rho-prim-pi D-wave) +
C.    (f2 pi D-wave) + (sigmapi S-wave) + (f0pi S-wave)]
C.   based on fit to pi-2pi0 by M. Schmidler, CBX 97-64-Update (4/22/98)

C Note that for FORM1, the arguments are S1, S2;
C           for FORM2, the arguments are S2, S1;
C           for FORM3, the arguments are S3, S1.
C Here, we implement FORM1 and FORM2 at the same time,
C so the above switch is just what we need!

      IF (IFORM.EQ.1.OR.IFORM.EQ.2) THEN
        S1 = SA
        S2 = SB
        S3 = QQ-SA-SB+M1SQ+M2SQ+M3SQ
        IF (S3.LE.0..OR.S2.LE.0.) RETURN

        IF (IDK.EQ.1) THEN
C it is 2pi0pi-
C Lorentz invariants for all the contributions:
          F134 = -(1./3.)*((S3-M3SQ)-(S1-M1SQ))
          F150 =  (1./18.)*(QQ-M3SQ+S3)*(2.*M1SQ+2.*M2SQ-S3)/S3
          F167 =  (2./3.)

C Breit Wigners for all the contributions:
          FRO1 = BWIGML(S1,MRO,GRO,M2,M3,1)
          FRP1 = BWIGML(S1,MRP,GRP,M2,M3,1)
          FRO2 = BWIGML(S2,MRO,GRO,M3,M1,1)
          FRP2 = BWIGML(S2,MRP,GRP,M3,M1,1)
          FF23 = BWIGML(S3,MF2,GF2,M1,M2,2)
          FSG3 = BWIGML(S3,MSG,GSG,M1,M2,0)
          FF03 = BWIGML(S3,MF0,GF0,M1,M2,0)

          F3PI = BT1*FRO1+BT2*FRP1+
     1       BT3*CMPLX(F134,0.)*FRO2+BT4*CMPLX(F134,0.)*FRP2+
     1       BT5*CMPLX(F150,0.)*FF23+
     1       BT6*CMPLX(F167,0.)*FSG3+BT7*CMPLX(F167,0.)*FF03

C         F3PI = FPIKM(SQRT(S1),M2,M3)
        ELSEIF (IDK.EQ.2) THEN
C it is 3pi
C Lorentz invariants for all the contributions:
          F134 = -(1./3.)*((S3-M3SQ)-(S1-M1SQ))
          F15A = -(1./2.)*((S2-M2SQ)-(S3-M3SQ))
          F15B = -(1./18.)*(QQ-M2SQ+S2)*(2.*M1SQ+2.*M3SQ-S2)/S2
          F167 = -(2./3.)

C Breit Wigners for all the contributions:
          FRO1 = BWIGML(S1,MRO,GRO,M2,M3,1)
          FRP1 = BWIGML(S1,MRP,GRP,M2,M3,1)
          FRO2 = BWIGML(S2,MRO,GRO,M3,M1,1)
          FRP2 = BWIGML(S2,MRP,GRP,M3,M1,1)
          FF21 = BWIGML(S1,MF2,GF2,M2,M3,2)
          FF22 = BWIGML(S2,MF2,GF2,M3,M1,2)
          FSG2 = BWIGML(S2,MSG,GSG,M3,M1,0)
          FF02 = BWIGML(S2,MF0,GF0,M3,M1,0)

          F3PI = BT1*FRO1+BT2*FRP1+
     1       BT3*CMPLX(F134,0.)*FRO2+BT4*CMPLX(F134,0.)*FRP2
     1      -BT5*CMPLX(F15A,0.)*FF21-BT5*CMPLX(F15B,0.)*FF22
     1      -BT6*CMPLX(F167,0.)*FSG2-BT7*CMPLX(F167,0.)*FF02

C         F3PI = FPIKM(SQRT(S1),M2,M3)
        END IF

      ELSE IF (IFORM.EQ.3) THEN
        S3 = SA
        S1 = SB
        S2 = QQ-SA-SB+M1SQ+M2SQ+M3SQ
        IF (S1.LE.0..OR.S2.LE.0.) RETURN

        IF (IDK.EQ.1) THEN
C it is 2pi0pi-
C Lorentz invariants for all the contributions:
          F34A = (1./3.)*((S2-M2SQ)-(S3-M3SQ))
          F34B = (1./3.)*((S3-M3SQ)-(S1-M1SQ))
          F35  =-(1./2.)*((S1-M1SQ)-(S2-M2SQ))

C Breit Wigners for all the contributions:
          FRO1 = BWIGML(S1,MRO,GRO,M2,M3,1)
          FRP1 = BWIGML(S1,MRP,GRP,M2,M3,1)
          FRO2 = BWIGML(S2,MRO,GRO,M3,M1,1)
          FRP2 = BWIGML(S2,MRP,GRP,M3,M1,1)
          FF23 = BWIGML(S3,MF2,GF2,M1,M2,2)

          F3PI =
     1       BT3*(CMPLX(F34A,0.)*FRO1+CMPLX(F34B,0.)*FRO2)+
     1       BT4*(CMPLX(F34A,0.)*FRP1+CMPLX(F34B,0.)*FRP2)+
     1       BT5*CMPLX(F35,0.)*FF23

C         F3PI = CMPLX(0.,0.)
        ELSEIF (IDK.EQ.2) THEN
C it is 3pi
C Lorentz invariants for all the contributions:
          F34A = (1./3.)*((S2-M2SQ)-(S3-M3SQ))
          F34B = (1./3.)*((S3-M3SQ)-(S1-M1SQ))
          F35A = -(1./18.)*(QQ-M1SQ+S1)*(2.*M2SQ+2.*M3SQ-S1)/S1
          F35B =  (1./18.)*(QQ-M2SQ+S2)*(2.*M3SQ+2.*M1SQ-S2)/S2
          F36A = -(2./3.)
          F36B =  (2./3.)

C Breit Wigners for all the contributions:
          FRO1 = BWIGML(S1,MRO,GRO,M2,M3,1)
          FRP1 = BWIGML(S1,MRP,GRP,M2,M3,1)
          FRO2 = BWIGML(S2,MRO,GRO,M3,M1,1)
          FRP2 = BWIGML(S2,MRP,GRP,M3,M1,1)
          FF21 = BWIGML(S1,MF2,GF2,M2,M3,2)
          FF22 = BWIGML(S2,MF2,GF2,M3,M1,2)
          FSG1 = BWIGML(S1,MSG,GSG,M2,M3,0)
          FSG2 = BWIGML(S2,MSG,GSG,M3,M1,0)
          FF01 = BWIGML(S1,MF0,GF0,M2,M3,0)
          FF02 = BWIGML(S2,MF0,GF0,M3,M1,0)

          F3PI =
     1       BT3*(CMPLX(F34A,0.)*FRO1+CMPLX(F34B,0.)*FRO2)+
     1       BT4*(CMPLX(F34A,0.)*FRP1+CMPLX(F34B,0.)*FRP2)
     1      -BT5*(CMPLX(F35A,0.)*FF21+CMPLX(F35B,0.)*FF22)
     1      -BT6*(CMPLX(F36A,0.)*FSG1+CMPLX(F36B,0.)*FSG2)
     1      -BT7*(CMPLX(F36A,0.)*FF01+CMPLX(F36B,0.)*FF02)

C         F3PI = CMPLX(0.,0.)
        END IF
      END IF

C Add overall a1/a1prime:
      FORMA1 = FA1A1P(QQ)
      F3PI = F3PI*FORMA1

      RETURN
      END


C **********************************************************
      COMPLEX FUNCTION BWIGML(S,M,G,M1,M2,L)
C **********************************************************
C     L-WAVE BREIT-WIGNER
C **********************************************************
      REAL S,M,G,M1,M2
      INTEGER L,IPOW
      REAL MSQ,W,WGS,MP,MM,QS,QM

      MP = (M1+M2)**2
      MM = (M1-M2)**2
      MSQ = M*M
      W = SQRT(S)
      WGS = 0.0
      IF (W.GT.(M1+M2)) THEN
        QS=SQRT(ABS((S   -MP)*(S   -MM)))/W
        QM=SQRT(ABS((MSQ -MP)*(MSQ -MM)))/M
        IPOW = 2*L+1
        WGS=G*(MSQ/W)*(QS/QM)**IPOW
      ENDIF

      BWIGML=CMPLX(MSQ,0.)/CMPLX(MSQ-S,-WGS)

      RETURN
      END


C=======================================================================
      COMPLEX FUNCTION FA1A1P(XMSQ)
C     ==================================================================
C     complex form-factor for a1+a1prime.                       AJW 1/98
C     ==================================================================

      REAL XMSQ
      REAL PKORB,WGA1
      REAL XM1,XG1,XM2,XG2,XM1SQ,XM2SQ,GG1,GG2,GF,FG1,FG2
      COMPLEX BET,F1,F2
      INTEGER IFIRST/0/

      IF (IFIRST.EQ.0) THEN
        IFIRST = 1

C The user may choose masses and widths that differ from nominal:
        XM1 = PKORB(1,10)
        XG1 = PKORB(2,10)
        XM2 = PKORB(1,17)
        XG2 = PKORB(2,17)
        BET = CMPLX(PKORB(3,17),0.)
C scale factors relative to nominal:
        GG1 = XM1*XG1/(1.3281*0.806)
        GG2 = XM2*XG2/(1.3281*0.806)

        XM1SQ = XM1*XM1
        XM2SQ = XM2*XM2
      END IF

      GF = WGA1(XMSQ)
      FG1 = GG1*GF
      FG2 = GG2*GF
      F1 = CMPLX(-XM1SQ,0.0)/CMPLX(XMSQ-XM1SQ,FG1)
      F2 = CMPLX(-XM2SQ,0.0)/CMPLX(XMSQ-XM2SQ,FG2)
      FA1A1P = F1+BET*F2

      RETURN
      END


C=======================================================================
      FUNCTION WGA1(QQ)

C mass-dependent M*Gamma of a1 through its decays to
C.   [(rho-pi S-wave) + (rho-pi D-wave) +
C.    (f2 pi D-wave) + (f0pi S-wave)]
C.  AND simple K*K S-wave

      REAL QQ,WGA1
      DOUBLE PRECISION MKST,MK,MK1SQ,MK2SQ,C3PI,CKST
      DOUBLE PRECISION S,WGA1C,WGA1N,WG3PIC,WG3PIN,GKST
      INTEGER IFIRST
C-----------------------------------------------------------------------
C
      IF (IFIRST.NE.987) THEN
        IFIRST = 987
C
C Contribution to M*Gamma(m(3pi)^2) from S-wave K*K:
        MKST = 0.894D0
        MK = 0.496D0
        MK1SQ = (MKST+MK)**2
        MK2SQ = (MKST-MK)**2
C coupling constants squared:
        C3PI = 0.2384D0**2
        CKST = 4.7621D0**2*C3PI
      END IF

C-----------------------------------------------------------------------
C Parameterization of numerical integral of total width of a1 to 3pi.
C From M. Schmidtler, CBX-97-64-Update.
      S = DBLE(QQ)
      WG3PIC = WGA1C(S)
      WG3PIN = WGA1N(S)

C Contribution to M*Gamma(m(3pi)^2) from S-wave K*K, if above threshold
      GKST = 0.D0
      IF (S.GT.MK1SQ) GKST = SQRT((S-MK1SQ)*(S-MK2SQ))/(2.*S)

      WGA1 = SNGL(C3PI*(WG3PIC+WG3PIN)+CKST*GKST)

      RETURN
      END


C=======================================================================
      DOUBLE PRECISION FUNCTION WGA1C(S)
C
C parameterization of m*Gamma(m^2) for pi-2pi0 system
C
      DOUBLE PRECISION S,STH,Q0,Q1,Q2,P0,P1,P2,P3,P4,G1_IM
C
      PARAMETER(Q0 =   5.80900D0,Q1 =  -3.00980D0,Q2 =   4.57920D0,
     1          P0 = -13.91400D0,P1 =  27.67900D0,P2 = -13.39300D0,
     2          P3 =   3.19240D0,P4 =  -0.10487D0)
C
      PARAMETER (STH   = 0.1753D0)
C---------------------------------------------------------------------

      IF(S.LT.STH) THEN
       G1_IM = 0.D0
      ELSEIF((S.GT.STH).AND.(S.LT.0.823D0)) THEN
       G1_IM = Q0*(S-STH)**3*(1. + Q1*(S-STH) + Q2*(S-STH)**2)
      ELSE
       G1_IM = P0 + P1*S + P2*S**2+ P3*S**3 + P4*S**4
      ENDIF

      WGA1C = G1_IM
      RETURN
      END


C=======================================================================
      DOUBLE PRECISION FUNCTION WGA1N(S)
C
C parameterization of m*Gamma(m^2) for pi-pi+pi- system
C
      DOUBLE PRECISION S,STH,Q0,Q1,Q2,P0,P1,P2,P3,P4,G1_IM
C
      PARAMETER(Q0 =   6.28450D0,Q1 =  -2.95950D0,Q2 =   4.33550D0,
     1          P0 = -15.41100D0,P1 =  32.08800D0,P2 = -17.66600D0,
     2          P3 =   4.93550D0,P4 =  -0.37498D0)
C
      PARAMETER (STH   = 0.1676D0)
C---------------------------------------------------------------------

      IF(S.LT.STH) THEN
       G1_IM = 0.D0
      ELSEIF((S.GT.STH).AND.(S.LT.0.823D0)) THEN
       G1_IM = Q0*(S-STH)**3*(1. + Q1*(S-STH) + Q2*(S-STH)**2)
      ELSE
       G1_IM = P0 + P1*S + P2*S**2+ P3*S**3 + P4*S**4
      ENDIF

      WGA1N = G1_IM
      RETURN
      END


      FUNCTION FORMOM(XMAA,XMOM)
C     ==================================================================
C     formfactorfor pi-pi0 gamma final state
C      R. Decker, Z. Phys C36 (1987) 487.
C     ==================================================================
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMMON /KODECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON /KOTESTA1/ KEYA1
      COMPLEX BWIGN,FORMOM
c
c      DATA ICONT /1/
c
* THIS INLINE FUNCT. CALCULATES THE SCALAR PART OF THE PROPAGATOR
      BWIGN(XM,AM,GAMMA)=1./CMPLX(XM**2-AM**2,GAMMA*AM)
* HADRON CURRENT
c
      FRO  =0.266*AMRO**2
      ELPHA=- 0.1
      AMROP = 1.7
      GAMROP= 0.26
      AMOM  =0.782
      GAMOM =0.0085
      AROMEG= 1.0
      GCOUP=12.924
      GCOUP=GCOUP*AROMEG
      FQED  =SQRT(4.0*3.1415926535/137.03604)
      FORMOM=FQED*FRO**2/SQRT(2.0)*GCOUP**2*BWIGN(XMOM,AMOM,GAMOM)
     $     *(BWIGN(XMAA,AMRO,GAMRO)+ELPHA*BWIGN(XMAA,AMROP,GAMROP))
     $     *(BWIGN( 0.0,AMRO,GAMRO)+ELPHA*BWIGN( 0.0,AMROP,GAMROP))
      END


C=======================================================================
      COMPLEX FUNCTION FK1AB(XMSQ,INDX)
C     ==================================================================
C     complex form-factor for a1+a1prime.                       AJW 1/98
C     ==================================================================

      COMPLEX F1,F2,AMPA,AMPB
      INTEGER IFIRST,INDX
      DATA IFIRST/0/

      IF (IFIRST.EQ.0) THEN
        IFIRST = 1
        XM1 = PKORB(1,19)
        XG1 = PKORB(2,19)
        XM2 = PKORB(1,20)
        XG2 = PKORB(2,20)

        XM1SQ = XM1*XM1
        GF1 = GFUN(XM1SQ)
        GG1 = XM1*XG1/GF1
        XM2SQ = XM2*XM2
        GF2 = GFUN(XM2SQ)
        GG2 = XM2*XG2/GF2
      END IF

      IF (INDX.EQ.1) THEN
        AMPA = CMPLX(PKORB(3,81),0.)
        AMPB = CMPLX(PKORB(3,82),0.)
      ELSE IF (INDX.EQ.2) THEN
        AMPA = CMPLX(PKORB(3,83),0.)
        AMPB = CMPLX(PKORB(3,84),0.)
      ELSEIF (INDX.EQ.3) THEN
        AMPA = CMPLX(PKORB(3,85),0.)
        AMPB = CMPLX(PKORB(3,86),0.)
      ELSEIF (INDX.EQ.4) THEN
        AMPA = CMPLX(PKORB(3,87),0.)
        AMPB = CMPLX(PKORB(3,88),0.)
      END IF

      GF = GFUN(XMSQ)
      FG1 = GG1*GF
      FG2 = GG2*GF
      F1 = CMPLX(-XM1SQ,0.0)/CMPLX(XMSQ-XM1SQ,FG1)
      F2 = CMPLX(-XM2SQ,0.0)/CMPLX(XMSQ-XM2SQ,FG2)
      FK1AB = AMPA*F1+AMPB*F2

      RETURN
      END


      FUNCTION FORM1(MNUM,QQ,S1,SDWA)
C     ==================================================================
C     formfactorfor F1 for 3 scalar final state
C     R. Fisher, J. Wess and F. Wagner Z. Phys C3 (1980) 313
C     H. Georgi, Weak interactions and modern particle theory,
C     The Benjamin/Cummings Pub. Co., Inc. 1984.
C     R. Decker, E. Mirkes, R. Sauer, Z. Was Karlsruhe preprint TTP92-25
C     and erratum !!!!!!
C     ==================================================================
C
      COMPLEX FORM1,FPIKM,BWIGM
c      COMPLEX WIGNER,WIGFOR
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST

      COMPLEX FORMA1,FORMK1,FORMRO,FORMKS
      COMPLEX FA1A1P,FK1AB,F3PI
C
      IF     (MNUM.EQ.0) THEN
C ------------  3 pi hadronic state (a1)
C       FORMRO = FPIKM(SQRT(S1),AMPI,AMPI)
C       FORMRO = F3PI(1,QQ,S1,SDWA)
C       FORMA1 = FA1A1P(QQ)
C       FORM1 = FORMA1*FORMRO
       FORM1 = F3PI(1,QQ,S1,SDWA)

      ELSEIF (MNUM.EQ.1) THEN
C ------------ K- pi- K+ (K*0 K-)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMPI,AMK)
       FORMA1 = FA1A1P(QQ)
       FORM1 = FORMA1*FORMKS

      ELSEIF (MNUM.EQ.2) THEN
C ------------ K0 pi- K0B (K*- K0)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMPI,AMK)
       FORMA1 = FA1A1P(QQ)
       FORM1 = FORMA1*FORMKS

      ELSEIF (MNUM.EQ.3) THEN
C ------------ K- pi0 K0 (K*0 K-)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMPI,AMK)
       FORMA1 = FA1A1P(QQ)
       FORM1 = FORMA1*FORMKS

      ELSEIF (MNUM.EQ.4) THEN
C ------------ pi0 pi0 K-  (K*-pi0)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMPI,AMK)
       FORMK1 = FK1AB(QQ,3)
       FORM1 = FORMK1*FORMKS

      ELSEIF (MNUM.EQ.5) THEN
C ------------ K- pi- pi+ (rho0 K-)
       FORMK1 = FK1AB(QQ,4)
       FORMRO = FPIKM(SQRT(S1),AMPI,AMPI)
       FORM1 = FORMK1*FORMRO

      ELSEIF (MNUM.EQ.6) THEN
C ------------ pi- K0B pi0 (pi- K*0B)
       FORMK1 = FK1AB(QQ,1)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMK,AMPI)
       FORM1 = FORMK1*FORMKS

      ELSEIF (MNUM.EQ.7) THEN
C -------------- eta pi- pi0 final state
       FORM1=0.0
      ENDIF

      END


      FUNCTION FORM2(MNUM,QQ,S1,SDWA)
C     ==================================================================
C     formfactorfor F2 for 3 scalar final state
C     R. Fisher, J. Wess and F. Wagner Z. Phys C3 (1980) 313
C     H. Georgi, Weak interactions and modern particle theory,
C     The Benjamin/Cummings Pub. Co., Inc. 1984.
C     R. Decker, E. Mirkes, R. Sauer, Z. Was Karlsruhe preprint TTP92-25
C     and erratum !!!!!!
C     ==================================================================
C
      COMPLEX FORM2,FPIKM,BWIGM
c      COMPLEX WIGNER,WIGFOR
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST

      COMPLEX FORMA1,FORMK1,FORMRO,FORMKS
      COMPLEX FA1A1P,FK1AB,F3PI

      IF     (MNUM.EQ.0) THEN
C ------------  3 pi hadronic state (a1)
C       FORMRO = FPIKM(SQRT(S1),AMPI,AMPI)
C       FORMRO = F3PI(2,QQ,S1,SDWA)
C       FORMA1 = FA1A1P(QQ)
C       FORM2 = FORMA1*FORMRO
       FORM2 = F3PI(2,QQ,S1,SDWA)

      ELSEIF (MNUM.EQ.1) THEN
C ------------ K- pi- K+ (rho0 pi-)
       FORMRO = FPIKM(SQRT(S1),AMK,AMK)
       FORMA1 = FA1A1P(QQ)
       FORM2 = FORMA1*FORMRO

      ELSEIF (MNUM.EQ.2) THEN
C ------------ K0 pi- K0B (rho0 pi-)
       FORMRO = FPIKM(SQRT(S1),AMK,AMK)
       FORMA1 = FA1A1P(QQ)
       FORM2 = FORMA1*FORMRO

      ELSEIF (MNUM.EQ.3) THEN
C ------------ K- pi0 K0 (rho- pi0)
       FORMRO = FPIKM(SQRT(S1),AMK,AMK)
       FORMA1 = FA1A1P(QQ)
       FORM2 = FORMA1*FORMRO

      ELSEIF (MNUM.EQ.4) THEN
C ------------ pi0 pi0 K-  (K*-pi0)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMPI,AMK)
       FORMK1 = FK1AB(QQ,3)
       FORM2 = FORMK1*FORMKS

      ELSEIF (MNUM.EQ.5) THEN
C ------------ K- pi- pi+  (K*0B pi-)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMPI,AMK)
       FORMK1 = FK1AB(QQ,1)
       FORM2 = FORMK1*FORMKS
C
      ELSEIF (MNUM.EQ.6) THEN
C ------------ pi- K0B pi0 (rho- K0B)
       FORMRO = FPIKM(SQRT(S1),AMPI,AMPI)
       FORMK1 = FK1AB(QQ,2)
       FORM2 = FORMK1*FORMRO
C
      ELSEIF (MNUM.EQ.7) THEN
C -------------- eta pi- pi0 final state
       FORM2=0.0
      ENDIF
C
      END


      COMPLEX FUNCTION BWIGM(S,M,G,XM1,XM2)
C **********************************************************
C     P-WAVE BREIT-WIGNER  FOR RHO
C **********************************************************
      REAL S,M,G,XM1,XM2
      REAL PI,QS,QM,W,GS
      DATA INIT /0/
C ------------ PARAMETERS --------------------
      IF (INIT.EQ.0) THEN
      INIT=1
      PI=3.141592654
C -------  BREIT-WIGNER -----------------------
         ENDIF
       IF (S.GT.(XM1+XM2)**2) THEN
         QS=SQRT(ABS((S   -(XM1+XM2)**2)*(S   -(XM1-XM2)**2)))/SQRT(S)
         QM=SQRT(ABS((M**2-(XM1+XM2)**2)*(M**2-(XM1-XM2)**2)))/M
         W=SQRT(S)
         GS=G*(M/W)**2*(QS/QM)**3
       ELSE
         GS=0.0
       ENDIF
         BWIGM=M**2/CMPLX(M**2-S,-SQRT(S)*GS)
      RETURN
      END


      COMPLEX FUNCTION FPIKM(W,XM1,XM2)
C **********************************************************
C     PION FORM FACTOR
C **********************************************************
      COMPLEX BWIGM
      REAL ROM,ROG,ROM1,ROG1,BETA1,PI,PIM,S,W
      EXTERNAL BWIG
      DATA  INIT /0/
C
C ------------ PARAMETERS --------------------
      IF (INIT.EQ.0 ) THEN
      INIT=1
      PI=3.141592654
      PIM=.140
      ROM=0.773
      ROG=0.145
      ROM1=1.370
      ROG1=0.510
      BETA1=-0.145
      ENDIF
C -----------------------------------------------
      S=W**2
      FPIKM=(BWIGM(S,ROM,ROG,XM1,XM2)+BETA1*BWIGM(S,ROM1,ROG1,XM1,XM2))
     & /(1+BETA1)
      RETURN
      END


      COMPLEX FUNCTION FPIKMD(W,XM1,XM2)
C **********************************************************
C     PION FORM FACTOR
C **********************************************************
      COMPLEX BWIGM
      REAL ROM,ROG,ROM1,ROG1,PI,PIM,S,W
      EXTERNAL BWIG
      DATA  INIT /0/
C
C ------------ PARAMETERS --------------------
      IF (INIT.EQ.0 ) THEN
      INIT=1
      PI=3.141592654
      PIM=.140
      ROM=0.773
      ROG=0.145
      ROM1=1.500
      ROG1=0.220
      ROM2=1.750
      ROG2=0.120
      BETA=6.5
      DELTA=-26.0
      ENDIF
C -----------------------------------------------
      S=W**2
      FPIKMD=(DELTA*BWIGM(S,ROM,ROG,XM1,XM2)
     $      +BETA*BWIGM(S,ROM1,ROG1,XM1,XM2)
     $      +     BWIGM(S,ROM2,ROG2,XM1,XM2))
     & /(1+BETA+DELTA)
      RETURN
      END


      FUNCTION FORM3(MNUM,QQ,S1,SDWA)
C     ==================================================================
C     formfactorfor F3 for 3 scalar final state
C     R. Fisher, J. Wess and F. Wagner Z. Phys C3 (1980) 313
C     H. Georgi, Weak interactions and modern particle theory,
C     The Benjamin/Cummings Pub. Co., Inc. 1984.
C     R. Decker, E. Mirkes, R. Sauer, Z. Was Karlsruhe preprint TTP92-25
C     and erratum !!!!!!
C     ==================================================================
C
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST

      COMPLEX FORM3,BWIGM
      COMPLEX FORMA1,FORMK1,FORMKS
c      COMPLEX FORMRO
      COMPLEX FA1A1P,FK1AB,F3PI
C
      IF (MNUM.EQ.0) THEN
C ------------  3 pi hadronic state (a1)
C       FORMRO = FPIKM(SQRT(S1),AMPI,AMPI)
C       FORMRO = F3PI(3,QQ,S1,SDWA)
C       FORMA1 = FA1A1P(QQ)
C       FORM3 = FORMA1*FORMRO
       FORM3 = F3PI(3,QQ,S1,SDWA)

      ELSEIF (MNUM.EQ.3) THEN
C ------------ K- pi0 K0  (K*- K0)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMPIZ,AMK)
       FORMA1 = FA1A1P(QQ)
       FORM3 = FORMA1*FORMKS

      ELSEIF (MNUM.EQ.6) THEN
C ------------ pi- K0B pi0 (K*- pi0)
       FORMKS = BWIGM(S1,AMKST,GAMKST,AMK,AMPI)
       FORMK1 = FK1AB(QQ,3)
       FORM3 = FORMK1*FORMKS

      ELSE
       FORM3=CMPLX(0.,0.)
      ENDIF

      END


      FUNCTION FORM4(MNUM,QQ,S1,S2,S3)
C     ==================================================================
C     formfactorfor F4 for 3 scalar final state
C     R. Decker, in preparation
C     R. Decker, E. Mirkes, R. Sauer, Z. Was Karlsruhe preprint TTP92-25
C     and erratum !!!!!!
C     ==================================================================
C
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMPLEX FORM4
c      COMPLEX WIGNER,FPIKM
c      REAL*4 M
c


C ---- this formfactor is switched off .. .
       FORM4=CMPLX(0.0,0.0)

      END


      FUNCTION FORM5(MNUM,QQ,S1,S2)
C     ==================================================================
C     formfactorfor F5 for 3 scalar final state
C     G. Kramer, W. Palmer, S. Pinsky, Phys. Rev. D30 (1984) 89.
C     G. Kramer, W. Palmer             Z. Phys. C25 (1984) 195.
C     R. Decker, E. Mirkes, R. Sauer, Z. Was Karlsruhe preprint TTP92-25
C     and erratum !!!!!!
C     ==================================================================
C
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
      COMPLEX FORM5,FPIKM,FPIKMD,BWIGM
c      COMPLEX WIGNER

      IF     (MNUM.EQ.0) THEN
C ------------  3 pi hadronic state (a1)
        FORM5=0.0
      ELSEIF (MNUM.EQ.1) THEN
C ------------ K- pi- K+
         ELPHA=-0.2
         FORM5=FPIKMD(SQRT(QQ),AMPI,AMPI)/(1+ELPHA)
     $        *(       FPIKM(SQRT(S2),AMPI,AMPI)
     $          +ELPHA*BWIGM(S1,AMKST,GAMKST,AMPI,AMK))
      ELSEIF (MNUM.EQ.2) THEN
C ------------ K0 pi- K0B
         ELPHA=-0.2
         FORM5=FPIKMD(SQRT(QQ),AMPI,AMPI)/(1+ELPHA)
     $        *(       FPIKM(SQRT(S2),AMPI,AMPI)
     $          +ELPHA*BWIGM(S1,AMKST,GAMKST,AMPI,AMK))
      ELSEIF (MNUM.EQ.3) THEN
C ------------ K- K0 pi0
        FORM5=0.0
      ELSEIF (MNUM.EQ.4) THEN
C ------------ pi0 pi0 K-
        FORM5=0.0
      ELSEIF (MNUM.EQ.5) THEN
C ------------ K- pi- pi+
        ELPHA=-0.2
        FORM5=BWIGM(QQ,AMKST,GAMKST,AMPI,AMK)/(1+ELPHA)
     $       *(       FPIKM(SQRT(S1),AMPI,AMPI)
     $         +ELPHA*BWIGM(S2,AMKST,GAMKST,AMPI,AMK))
      ELSEIF (MNUM.EQ.6) THEN
C ------------ pi- K0B pi0
        ELPHA=-0.2
        FORM5=BWIGM(QQ,AMKST,GAMKST,AMPI,AMKZ)/(1+ELPHA)
     $       *(       FPIKM(SQRT(S2),AMPI,AMPI)
     $         +ELPHA*BWIGM(S1,AMKST,GAMKST,AMPI,AMK))
      ELSEIF (MNUM.EQ.7) THEN
C -------------- eta pi- pi0 final state
       FORM5=FPIKMD(SQRT(QQ),AMPI,AMPI)*FPIKM(SQRT(S1),AMPI,AMPI)
      ENDIF
C
      END


      FUNCTION WIGFOR(S,XM,XGAM)
      COMPLEX WIGFOR,WIGNOR
      WIGNOR=CMPLX(-XM**2,XM*XGAM)
      WIGFOR=WIGNOR/CMPLX(S-XM**2,XM*XGAM)
      END


      COMPLEX FUNCTION BWIGA1(QA)
C     ================================================================
C     breit-wigner enhancement of a1
C     ================================================================
      COMPLEX WIGNER
      COMMON /KOPARMAS/ AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU,
     %                 AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1,
     %                 AMK,AMKZ,AMKST,GAMKST

C
      REAL*4           AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU,
     %                 AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1,
     %                 AMK,AMKZ,AMKST,GAMKST

      WIGNER(A,B,C)=CMPLX(1.0,0.0)/CMPLX(A-B**2,B*C)
      GAMAX=GAMA1*GFUN(QA)/GFUN(AMA1**2)
      BWIGA1=-AMA1**2*WIGNER(QA,AMA1,GAMAX)
      RETURN
      END


      COMPLEX FUNCTION BWIGEPS(QEPS)
C     =============================================================
C     breit-wigner enhancement of epsilon
C     =============================================================
      REAL QEPS,MEPS,GEPS
      MEPS=1.300
      GEPS=.600
      BWIGEPS=CMPLX(MEPS**2,-MEPS*GEPS)/
     %        CMPLX(MEPS**2-QEPS,-MEPS*GEPS)
      RETURN
      END


      COMPLEX FUNCTION FRHO4(W,XM1,XM2)
C     ===========================================================
C     rho-type resonance factor with higher radials, to be used
C     by CURR for the four pion mode
C     ===========================================================
      COMPLEX BWIGM
      COMMON /KOTAU4PI/ GOMEGA,GAMMA1,GAMMA2,ROM1,ROG1,BETA1,
     .                ROM2,ROG2,BETA2
      REAL*4          GOMEGA,GAMMA1,GAMMA2,ROM1,ROG1,BETA1,
     .                ROM2,ROG2,BETA2
      REAL ROM,ROG,PI,PIM,S,W
      EXTERNAL BWIG
c
      DATA  INIT /0/
C
C ------------ PARAMETERS --------------------
      IF (INIT.EQ.0 ) THEN
      INIT=1
      PI=3.141592654
      PIM=.140
      ROM=0.773
      ROG=0.145
      ENDIF
C -----------------------------------------------
      S=W**2
c	       print *,'rom2,rog2 =',rom2,rog2
      FRHO4=(BWIGM(S,ROM,ROG,XM1,XM2)+BETA1*BWIGM(S,ROM1,ROG1,XM1,XM2)
     & +BETA2*BWIGM(S,ROM2,ROG2,XM1,XM2))
     & /(1+BETA1+BETA2)
      RETURN
      END


      SUBROUTINE KORALB(MMODE,KFB1,PPB1,EE1,KFB2,PPB2,EE2,XPAR,NPAR)
C     **************************************************************
C=======================================================================
C=======================================================================
C============================KORAL-B====================================
C=======================================================================
C=======================================================================
C
C     ****************************************************************
C     *          *************************************               *
C     *          ***           KORAL-B             ***               *
C     *          ***         VERSION 2.5           ***               *
C     *          ***          MARCH 1995           ***               *
C     *          *************************************               *
C     *                                                              *
C     *                      AUTHORS                                 *
C     *           STANISLAW JADACH AND  ZBIGNIEW WAS                 *
C     *         JAGELLONIAN UNIVERSITY, KRAKOW, POLAND               *
C     *                                                              *
C     *     THE MONTE CARLO PROGRAM SIMULATING   THE   PROCESS       *
C     *         E+  E-   INTO   TAU+  TAU-  ( PHOTON )               *
C     *     IN QED TO ORDER  ALPHA**3  INCLUDING ALL EFFECTS         *
C     *     DUE TO SPIN AND FINITE MASS OF TAU. Z0 CONTRIBUTION      *
C     *     INCLUDED   IN   THE   LOW   ENERGY  APPROXIMATION.       *
C     ****************************************************************
C
C    IMPORTANT NOTE:
C    THIS PROGRAM WILL BE SLOWLY BUT GRADUALLY IMPROVED.
C    BEFORE USING THIS PROGRAM YOU MAY CONTACT Z. WAS
C    THROUGH EARNET/BITNET, WASM AT CERNVM,
C    AND, PERHAPS, YOU WILL GET  A BETTER VERSION.
C    ANY REMARK ON THE PROGRAM,
C    ON ANY NOTICED ERROR OR ANY OTHER PROBLEM IS WELCOMED.
C=================
C PARAMETERS:   =
C=================
C MODE=-1 INITIALIZATION OR REINITIALIZATION MODE,
C         PRIOR TO GENERATION, OBLIGATORY.
C     = 0 GENERATION MODE, M.C. EVENT IS GENERATED.
C     = 1 POSTGENERATION MODE, PRONTOUTS, OPTIONAL.
C
C IF MODE=-1 THEN ALL PARAMETERS ARE INPUT DATA:
C    =======
C KFB1 =11,-11 FLAVOUR CODE OF FIRST BEAM, KF1=11  FOR ELECTRON.
C KFB2 =11,-11 FLAVOUR CODE OF SECOND BEAM, KF2=-11 FOR POSITRON.
C PB1 = FOUR MOMENTUM OF THE FIRST BEAM.
C PB2 = FOUR MOMENTUM OF THE SECOND BEAM.
C EE1 = SPIN POLARIZATION VECTOR FOR THE FIRST BEAM.
C EE2 = SPIN POLARIZATION VECTOR FOR THE SECOND BEAM,
C       BOTH IN THE CORRESPONDING BEAM PARTICLE REST FRAME
C       AND IN BOTH CASES THIRD AXIS DIRECTED ALONG FIRST BEAM,
C       I.E. EE1(3) AND -EE2(3) ARE HELICITIES.
C       POLARIZATION MAY BE LONGITUDINAL TRANSVERSE AND ANY OTHER.
C
C OTHER INPUT PARAMETERS ARE HIDEN IN XPAR AND NPAR.
C NPAR(1)=ISPIN
C NPAR(2)=INRAN
C NPAR(3)=KEYGSW
C NPAR(4)=KEYRAD
C NPAR(5)=JAK1
C NPAR(6)=JAK2
C NPAR(7)=TYPE OF THE FINAL STATE FERMION  =(1,2,501,506) DEFINES
C         TAU,MU AND QUARKS.
C NPAR(8)=BREMSSTRAHLUNG IN DECAYS ON/OFF (1/0)
C XPAR( 1)=AMZ     =MASS OF Z0 BOSON
C XPAR( 4)=GV
C XPAR( 5)=AV
C XPAR( 6)=SINW2, ONLY FOR KEYGSW=1,
C XPAR( 8)=AMNUTA, MASS OF TAU NEUTRINO IN DECAY.
C XPAR(11)=XK0, THE INFRARED CUTOFF.
C XPAR(14)=AMFIN, FINAL STATE MASS (ONLY FOR ITFIN=501-506 NOT DUMMY)
C -------
C ISPIN =0,1  SPIN EFFECTS IN DECAY SWITCHED OFF,ON.
C INRAN = INITIALISATION CONSTANT FOR RAND. NUM. GEN. RNF100, POSITIVE.
C KEYGSW, IMPLEMENTATION LEVEL OF GLASHOW-SALAM-WEINBERG MODEL:
C = 0, N0 Z0, ONLY PHOTON EXCHANGE,
C = 1, PHOTON - Z0 INTERFERENCE
C KEYRAD=0, NO QED BREMSSTRAHLUNG,
C       =1, WITH QED BREMSSTRAHLUNG.
C JAK1,JAK2, DECAY TYPE FOR TAU+ AND TAU-.
C DECAY MODES INCLUDED ARE:
C JAK=1 ELECTRON DECAY
C JAK=2 MU  DECAY,
C JAK=3 PI DECAY,
C JAK=4 RHO DECAY,
C JAK=5 A1  DECAY
C JAK=6 K DECAY,
C JAK=7 K* DECAY,
C JAK=8 NPI DECAY
C JAK=0 INCLUSIVE:  JAK=1,2,3,...
C JAK=-1 NO DECAY.
C GV AND GA ARE COUPLING CONSTANTS OF W-BOSON OF TO TAU LEPTON,
C GV=1,GA=-1 REPRESENT THE STANDARD V-A COUPLING.
C XK0  IS THE INFRARED CUTOFF IN THE PROGRAM, IT IS A DUMMY
C PARAMETER AND NONE OF RESULTS SHOULD DEPEND ON IT,
C ITS VALUE MAY BE CHOOSEN IN THE RANGE 0.001 TO 0.05 ROUGHLY.
C
C ELSE IF MODE=0 THEN ALL PARAMETERS ARE IGNORED
C         ======
C ELSE IF MODE=1 THEN
C         ======
C NPAR(20)= NEVTOT, NO. OF GENERATED EVENTS,
C XPAR(20)= CSTCM,  INTEGRATED TOTAL CROSS SECTION IN CM**2 UNITS,
C ARE OUTPUT INFORMATION PROVIDED FOR THE USER.
C ENDIF

      IMPLICIT LOGICAL(A-H,O-Z)

      REAL   *4 PPB1(4),EE1(3),PPB2(4),EE2(3),XPAR(40)
      INTEGER*4 NPAR(40)

C COMMONS COMMUNICATING WITH PRODUCTION PART
      COMMON /KOCONTRL/ SWT(6),ISPIN
      REAL*8           SWT
      REAL*8           CSTCMT,ERREL

C THESE COMMUNICATE WITH DECAY PACKAGE TAUOLA
      COMMON /KOBEAMS / XPB1(4),XPB2(4),KF1,KF2
      REAL*4           XPB1,   XPB2
      COMMON /KOIDFC  / IDFF
      COMMON /KODECPAR / GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      REAL*4            GFERMI,GV,GA,CCABIB,SCABIB,GAMEL
      COMMON /KOPARMAS / AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      REAL*4            AMTAU,AMNUTA,AMEL,AMNUE,AMMU,AMNUMU
     *                 ,AMPIZ,AMPI,AMRO,GAMRO,AMA1,GAMA1
     *                 ,AMK,AMKZ,AMKST,GAMKST
C
      COMMON /KOTAURAD / XK0DEC,ITDKRC
      REAL*8            XK0DEC
      COMMON /KOZNOWY /  AMZ,GAMZ
      REAL*8            AMZ,GAMZ
      COMMON /KONEWZET/  IFZET,ITRANS
      COMMON /KOCMSLAB/  GAMLAB
      REAL*4            GAMLAB
      COMMON /KOJAKI   / JAK1,JAK2,JAKP,JAKM,KTOM
      COMMON /KOINOUT /  NINP,NOUT
      COMMON /KOREINIT/   IFINI
      COMMON /KOVACPOL/  IFVAC
      REAL*8 PB1(4), E1(3), PB2(4), E2(3)
      REAL*8 SINW2,ENE,SUMPT,EM1,EM2,XK0
      REAL*8 AMFIN,XKMM
      REAL*8 HDUM(4)
c
      DATA IWARM/0/
c
      MODE =MMODE
c
      IF(MODE.EQ.-1) THEN
C    ===================
c
c    Initialization mode
c
C    ===================

        IEVEN=0
        IFINI=0
CCC        IF(IWARM.NE.0) GOTO 910
        NINP=5
        NOUT=6
        IWARM=IWARM+1
        KF1=KFB1
        KF2=KFB2
        ISPIN1=    NPAR(1)
c        INRAN=    NPAR(2)  ! V.A.T.

        KEYGSW=   NPAR(3)
        KEYRAD=   NPAR(4)
        JAK1  =   NPAR(5)
        JAK2  =   NPAR(6)
        ITFIN =   NPAR(7)
        ITDKRC=   NPAR(8)
        ITRANS=   NPAR(9)
        IFZET =   NPAR(11)

        AMZ   = DBLE(XPAR(1))
        GAMZ  = DBLE(XPAR(2))
        SINW2 = DBLE(XPAR(6))

C vacuum polarization deep switch; 1/0 vac pol on/off

        IFVAC=1

C W-BOSON COUPLINGS TO FINAL STATE FERMION (IN DECAY) FROM INPUT
        GV=XPAR( 4)

        GA=XPAR( 5)

C TAU-NEUTRINO MASS
        AMNUTA= XPAR(8)

C INFRARED CUT-OFF
        XK0= DBLE(XPAR(11))
        XK0DEC=XK0
        XKMM=DBLE(XPAR(13))

        IF(XK0.LT.1D-3.OR.XK0.GT.1D-1) GOTO 908

C FINAL STATE QUAR MASS
        IF(ITFIN.GT.100)  AMFIN=XPAR(14)

        DO 15 I=1,4
          XPB1(I)=PPB1(I)
          XPB2(I)=PPB2(I)
          PB1(I)=PPB1(I)
          PB2(I)=PPB2(I)
   15   CONTINUE
c
        ENE=DSQRT((PB1(4)+PB2(4))**2-(PB1(3)+PB2(3))**2)/2D0
        GAMLAB=( (PB1(4)+PB2(4)) + (PB1(3)+PB2(3)) )/2D0/ENE
c

        DO 26 I=1,3
        E1(I)=EE1(I)
   26   E2(I)=EE2(I)
c
c  PRINT INPUT PARAMETERS
c
        WRITE(6,7000) KF1,KF2,PB1(3),PB1(4),PB2(3),PB2(4)
     &  ,E1(1),E1(2),E1(3),E2(1),E2(2),E2(3)

        WRITE(6,7001)
c     $  ITFIN,ISPIN1,INRAN,KEYGSW,KEYRAD,JAK1,JAK2,ITDKRC,ITRANS,!
     $  ITFIN,ISPIN1,       KEYGSW,KEYRAD,JAK1,JAK2,ITDKRC,ITRANS,!  V.Tayursky
     $  IFZET
        WRITE(6,7002) AMZ,gamz,SINW2,GV,GA,AMNUTA,XK0
c
c  CHECKS
c
        IF(IABS(KF1).NE.11.OR.IABS(KF2).NE.11) GOTO 900
        IF(KF1*KF2.GT.0) GOTO 900
        IF(DABS(SINW2).GT.1D0) GOTO 905
        IF(KEYRAD.LT.0.OR.KEYRAD.GT.1) GOTO 907
        IF(KEYRAD.EQ.1.AND.IFZET.EQ.1) GOTO 907
        SUMPT=0.
c
        DO 20 I=1,2
        SUMPT=SUMPT+PB1(I)
  20    SUMPT=SUMPT+PB2(I)
c
        IF(SUMPT.GT.0.0001) GOTO 902
        IF (    (PB1(3)).NE.DABS(PB1(4))
     &  .OR.DABS(PB2(3)).NE.DABS(PB2(4))
     &   ) GOTO 903
        EM1=DSQRT(E1(1)**2+E1(2)**2+E1(3)**2)
        EM2=DSQRT(E2(1)**2+E2(2)**2+E2(3)**2)
        IF(EM1.GT.1D0.OR.EM2.GT.1D0) GOTO 904

C INITIALISATION OF TAU DECAY PACKAGE TAUOLA
C ******************************************
        IF (IWARM.EQ.1) THEN

          CALL INIMAS

          CALL KO_INITDK

          CALL INIPHY(XK0DEC)

C INITIALIZATION OF PHOTOS

          CALL PHOINI

        ELSE
          WRITE(6,9910) IWARM
        ENDIF

C DETERMINE WHETHER BEAM ALONG Z-AXIS IS AN ELECTR. OR POSITRON
C FOR IDE<0 PB1 (ALONG Z-AXIS) REPRESENTS POSITRON
        IDE= 2*KFB1/IABS(KFB1)
C
C       DETERMINE WHETHER QP REPRESENT PARTICLE OR  ANTIPART.
C                                      (IDF<0)  OR   (IDF>0
C
C       FINAL FERMION  TYPE ETC.
        IF(ITFIN .EQ. 1) THEN
C TAU CASE
C TAU MASS
        AMFIN=AMTAU
        AMTAU=AMFIN
C*MWG* TAU  CASE: PDG-CODE OF TAU- IS 15
          IDF= 2*KFB1/IABS(KFB1)
          IDFF = 15*IDF/IABS(IDF)
        ELSEIF(ITFIN .EQ. 2) THEN
C MUON CASE
        AMFIN=AMMU
C*MWG* MUON CASE: PDG-code of mu- is 13
          IDF= 2*KFB1/IABS(KFB1)
          IDFF = 13*IDF/IABS(IDF)
C DECAY SUPRESSED
          JAK1=-1
          JAK2=-1
        ELSE
C QUARK CASE, MASS FROM THE INPUT (AMFIN WAS OVERWRITTEN IN
C                                  INITIALIZATION OF TAUOLA)
          AMFIN=XPAR(14)
          JAK1=-1
          JAK2=-1
          IAA  = ABS(ITFIN)-500
          IF (IAA .EQ. 2 .OR. IAA .EQ. 4 .OR. IAA .EQ. 6) THEN
            IDF= 3*KFB1/IABS(KFB1)
          ELSE
            IDF= 4*KFB1/IABS(KFB1)
          END IF
          IDFF = SIGN(IAA,IDF)
        ENDIF
c
        WRITE(6,7003) AMFIN
C SWITCHING OFF Z0
        IF(KEYGSW.EQ.0) SINW2=-.5
C SWITCHING OFF BREMSSTRAHLUNG
        IF(KEYRAD.EQ.0) ENE=-ABS(ENE)

C PRODUCTION PART INITIALIZATION

       CALL STARB(ENE,AMFIN,IDE,IDF,AMZ,SINW2,INRAN,XK0,XKMM)

C       ------------------------------------------------------
C ISPIN REDEFINED
        ISPIN=   ISPIN1
        IF(ISPIN.LT.0.OR.ISPIN.GT.1) GOTO 906

        IF (IWARM.EQ.1) CALL DEKAY(-1,HDUM)

        IFINI=1

      ELSEIF(MODE.EQ.0) THEN
C     ======================
C     ======================

        IF(IWARM.EQ.0) GOTO 911
        IEVEN=IEVEN+1

        CALL KORAL(E1,E2)

C       -----------------

        CALL KINCOP

C*MWG* FILLING HEPEVT RECORD WITH BEAMS FERMIONS AND PHOTON
C TAU CASE

        CALL BTOHEP

C       -----------
C TAU DECAYS, REST OF ADMINISTRATION
        KTO=11

        CALL DEKAY(KTO,HDUM)

C       --------------------
        KTO=12

        CALL DEKAY(KTO,HDUM)

C       --------------------
        IF (ITDKRC.EQ.1) THEN

         CALL PHOTOS(3)

         CALL PHOTOS(4)

        ENDIF
      ELSEIF(MODE.EQ.1) THEN
C     ======================

C     ======================

        CALL FINISB(CSTCMT,ERREL)

C       ------------------
C CALCULATE PARTIAL DECAY WIDTHS

        CALL DEKAY(100,HDUM)

C       --------------------
        NPAR(10)=IEVEN
        XPAR(10)=CSTCMT
        WRITE(6,7010) IEVEN,CSTCMT,ERREL
      ELSE
C     ====
        GOTO 901
      ENDIF
C     =====
      RETURN
  900 PRINT 9900
 9900 FORMAT(' KORALB: NONSENSE VALUE OF BEAM IDENTIFIER')
      STOP
  901 PRINT 9901
 9901 FORMAT(' KORALB: NONSENCE VALUE OF MODE ')
      STOP
  902 PRINT 9902
 9902 FORMAT(' KORALB: NO TRANSV. MOM. ALLOWED FOR BEAMS ')
      STOP
  903 PRINT 9903
 9903 FORMAT(' KORALB: SOME WRONG BEAM MOM. COMPONENT    ')
      STOP
  904 PRINT 9904
 9904 FORMAT(' KORALB: BAD POLARISATION VECTORS ')
      STOP
  905 PRINT 9905
 9905 FORMAT(' KORALB: BAD SINW2 ')
      STOP
  906 PRINT 9906
 9906 FORMAT(' KORALB: BAD ISPIN ')
      STOP
  907 PRINT 9907
 9907 FORMAT(' KORALB: BAD KEYRAD, IFZET')
      STOP
  908 PRINT 9908
 9908 FORMAT(' KORALB: BAD XK0   ')
      STOP
C  910 PRINT 9910
 9910 FORMAT(' KORALB: PARTIAL REINITIALISATION, IWARM=',I4,/,
     $       ' NOTE1: TAUOLA is not reinitialized',/,
     $       ' NOTE2: Random numbers reinitialized partially')
C      STOP
  911 PRINT 9911
 9911 FORMAT(' KORALB: LACK OF INITIALISATION')
      STOP
 7000 FORMAT(//1H1,15(5H*****)
     $ /,' *',     25X,'=KORALB VERSION 2.5 INPUT PARAMETERS ==',9X,1H*,
     $ /,' *',     25X,'==========MARCH 1995===================',9X,1H*,
     $ /,' *',I20  ,5X,'KF1    =  FIRST BEAM IDENTIFIER        ',9X,1H*,
     $ /,' *',I20  ,5X,'KF2    =  SECOND BEAM IDENTIFIER       ',9X,1H*,
     $ /,' *',     25X,'==== FOUR MOMENTA OF THE BEAMS ========',9X,1H*,
     $ /,' *',F20.9,5X,'PB1(3) =  FIRST BEAM, 3-RD COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'PB1(4) =              0-TH COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'PB2(3) = SECOND BEAM, 3-RD COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'PB2(4) =              0-TH COMPONENT   ',9X,1H*,
     $ /,' *',     25X,'==== SPIN VECTORS OF THE BEAMS ========',9X,1H*,
     $ /,' *',F20.9,5X,'E1(1)  =  FIRST BEAM, 1-ST COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E1(2)  =              2-ND COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E1(3)  =              3-RD COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E2(1)  = SECOND BEAM  1-ST COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E2(2)  =              2-ND COMPONENT   ',9X,1H*,
     $ /,' *',F20.9,5X,'E2(3)  =              3-RD COMPONENT   ',9X,1H*)
 7001 FORMAT(
     $   ' *',     25X,'==== INPUT PARAMS IN NPAR =============',9X,1H*,
     $ /,' *',I20  ,5X,'ITFIN  =  TYPE OF THE FINAL STATE      ',9X,1H*,
     $ /,' *',I20  ,5X,'ISPIN  =  SPIN EFFECTS SWITCH          ',9X,1H*,
c     $ /,' *',I20  ,5X,'INRAN  =  RANDOM NUMB. INITIALISATION  ',9X,1H*,
     $ /,' *',I20  ,5X,'KEYGSW =  GSW IMPLEMENTATION LEVEL     ',9X,1H*,
     $ /,' *',I20  ,5X,'KEYRAD =  BREMSSTRAHLUNG   SWITCH      ',9X,1H*,
     $ /,' *',I20  ,5X,'JAK1   =  DECAY TYPE TAU+              ',9X,1H*,
     $ /,' *',I20  ,5X,'JAK2   =  DECAY TYPE TAU-              ',9X,1H*,
     $ /,' *',I20  ,5X,'ITDKRC =  BREM. IN DECAY SWITCH        ',9X,1H*,
     $ /,' *',I20  ,5X,'ITRANS =  TRANSVERSE SPIN CORR. SWITCH ',9X,1H*,
     $ /,' *',I20  ,5X,'IFZET  =  NEW IMPLEMENT. OF Z SWITCH   ',9X,1H*)
 7002 FORMAT(
     $   ' *',     25X,'==== INPUT PARAMS IN XPAR =============',9X,1H*,
     $ /,' *',F20.9,5X,'AMZ   = MASS OF Z0 BOSON               ',9X,1H*,
     $ /,' *',F20.9,5X,'GAMZ  = WIDTH OF Z0 BOSON              ',9X,1H*,
     $ /,' *',F20.9,5X,'SINW2 =  SIN**2(THETAWEINBERG)         ',9X,1H*,
     $ /,' *',F20.9,5X,'GV    = VECTOR COUPLING CONST. IN DECAY',9X,1H*,
     $ /,' *',F20.9,5X,'GA    = AXIAL  COUPLING CONST. IN DECAY',9X,1H*,
     $ /,' *',F20.9,5X,'AMNUTA= MASS OF TAU-NEUTRINO  IN DECAY ',9X,1H*,
     $ /,' *',F20.9,5X,'XK0   = SOFT/HARD PHOTON CUT OFF       ',9X,1H*,
     $  /,1X,15(5H*****)/)
 7003 FORMAT(
     $   ' *',     25X,'==KORALB-INITIALIZATION THROUGH TAUOLA=',9X,1H*,
     $ /,' *',F20.9,5X,'AMFIN = MASS OF FINAL STATE FERMION    ',9X,1H*,
     $  /,1X,15(5H*****)/)
 7010 FORMAT(///1X,15(5H*****)
     $ /,' *',     25X,'==KORALB VERSION 2.5 FINAL REPORT======',9X,1H*,
     $ /,' *',     25X,'=========== MARCH 1995=================',9X,1H*,
     $ /,' *',I20  ,5X,'NUMBER OF THE GENERATED EVENTS         ',9X,1H*,
     $ /,' *',E20.5,5X,'TOTAL CROSS SECTION   CM**2            ',9X,1H*,
     $ /,' *',F20.9,5X,'RELATIVE ERROR                         ',9X,1H*,
     $  /,1X,15(5H*****)/)
      END


      SUBROUTINE BTOHEP
C ----------------------------------------------------------------------
C
C Koral-B to HEPEVT
C
C this routine fills the HEPEVT common block
C with event kinematics from Koral-B:
C *  initial beam particles (positions 1,2)
C *  primary fermions of final state (3,4)
C *  radiative photon (5)
C
C WRITTEN BY MARTIN W. GRUENEWALD AND Z. WAS (91/02/02)
C
C called by KORAL-B
C
C ----------------------------------------------------------------------
C
      COMMON /KOUTIL4 / QP(4),QM(4),PH(4)
      COMMON /KOBEAMS / XPB1(4),XPB2(4),KFB1,KFB2
      COMMON /KOIDFC  / IDFF
      COMMON /KOTAUPOS / NPA,NPB
      COMMON /KOCMSLAB / GAMLAB
C
      AMEL=0.511E-3
      AM=AMEL
C
C --- Position of first and second tau in LUND common
      NPA=3
      NPB=4
C initial state (1,2)

      CALL FILHEP(1,3,KFB1,0,0,0,0,XPB1,AM,.FALSE.)

      CALL FILHEP(2,3,KFB2,0,0,0,0,XPB2,AM,.FALSE.)
C
C primary final state fermions (3,4)
      AM=QP(4)**2-QP(1)**2-QP(2)**2-QP(3)**2
      IF(AM.LT.0.0) THEN
C
C only due to rounding errors
        AM=0.0
      ELSE
        AM=SQRT(AM)
      ENDIF

      CALL BOSTR3(GAMLAB,QP,QP)

      CALL BOSTR3(GAMLAB,QM,QM)

      CALL FILHEP(3,1, IDFF,1,2,0,0,QP,AM,.FALSE.)

      CALL FILHEP(4,1,-IDFF,1,2,0,0,QM,AM,.FALSE.)
C
C radiative photon (5) (PDG-code for gamma is 22)
      IF (PH(4).GT.0.0) THEN

        CALL BOSTR3(GAMLAB,PH,PH)

        CALL FILHEP(5,1,22,1,2,0,0,PH,0.0,.true.)

      ENDIF
C
      RETURN
      END


      SUBROUTINE KINCOP
C     *****************
C  COPYING UTIL INTO UTIL4 AND UTIL8
      IMPLICIT LOGICAL(A-H,O-Z)
      COMMON /KOUTIL  /  QP(4), QM(4), PH(4)
      REAL*8            QP   , QM   , PH
      COMMON /KOUTIL8 / DQP(4),DQM(4),DPH(4)
      REAL*8           DQP   ,DQM   ,DPH
      COMMON /KOUTIL4 / AQP(4),AQM(4),APH(4)
      REAL*4           AQP   ,AQM   ,APH
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      REAL*8           ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      DO 30 I=1,4
      DQP(I)=QP(I)*ENE
      DQM(I)=QM(I)*ENE
      DPH(I)=PH(I)*ENE
      AQP(I)=QP(I)*ENE
      AQM(I)=QM(I)*ENE
 30   APH(I)=PH(I)*ENE
      RETURN
      END


      SUBROUTINE TRALO4(KTO,AP,BP,AM)
C     *******************************
      COMMON /KOCMSLAB / GAMLAB
C REAL*4 VERSION OF TRALOR plus boost to lab
      REAL*4 AP(4),BP(4),AM
      REAL*8 DP(4),AMAST
      DO 30 I=1,4
  30  DP(I)=AP(I)

      CALL TRALOR(KTO,DP)

      DO 31 I=1,4
  31  AP(I)=DP(I)
      AM=AMAST(DP)
C additional boost from (CMS) to LAB system

      CALL BOSTR3(GAMLAB,AP,AP)

      RETURN
      END


      SUBROUTINE KORAL(E1,E2)
C     ***********************
C=======================================================================
C==================COMPUT. PHYS. COMMUN. PART ==========================
C=======================================================================
C THIS IS PART OF KORALB ALMOST IDENTICAL TO THAT PUBLISHED
C IN COMPUTER PHYSICS COMMUNICATIONS 36, (1985) 191,
C BY S. JADACH AND Z. WAS
C CORRECTIONS WITH RESPECT TO CPC VERSION MARKED WITH C;; (SJ)
C CORRECTIONS WITH RESPECT TO CPC VERSION MARKED WITH *$  (ZW)
C     ****************************************************************
C     *  THIS IS CENTRAL MENAGER    ROUTINE FOR TAUPAIR PRODUCTION   *
C     *  PROCESS IT CALLS OTHER ROUTINES CALCULATES THE SPIN WEIGHT  *
C     *  WHICH IS NEXT USED TO DECIDE WHETHER EVENT IS ACCEPTED OR   *
C     *  REJECTED. THIS WEIGHING AND REJECTING PROCEDURE INTRODUCES  *
C     *  CORRELATION IN THE DECAYS OF TWO TAUS AND OTHER SPIN        *
C     *  EFFECTS. E1 AND E2 ARE POLARISATION VECTORS OF E+ AND E-    *
C     ****************************************************************
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /KOUTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON /KOCONTRL/ SWT(6),ISPIN
      DIMENSION E1(3),E2(3),SA(4),SB(4),H1(4),H2(4)
      COMPLEX*16 T1(4,4),T2(4,4),S(4,4),E(4,4)
      COMPLEX*16 ZERO,ROT,TOT
      REAL*4 RRR,RLU
      LOGICAL LSOF,LHAR
      COMMON /KOREINIT/ IFINI
C     number of generations to calculate maximal weight.
c
      DATA INIT /0/
      DATA NUMSTA /500/
c
      ZERO=DCMPLX(0.D0,0.D0)
      IF (IFINI.EQ.0) INIT=0
C-----IF ELECTRONS ARE UNPOLARIZED WE TAKE EASIER PATH
      SUM=0.
      DO 30 I=1,3
   30 SUM=SUM+E1(I)**2+E2(I)**2
C-----
C-----
      IF (INIT.EQ.0) THEN
      INIT=1
      XLSP=1.05
      DO KKK=1,NUMSTA

      CALL EVENTB

      KTO=1

      CALL DEKAY(KTO,H1)

      KTO=2

      CALL DEKAY(KTO,H2)

      H1(4)=1.
      H2(4)=1.

      CALL KO_SPIN(E,H1,H2)

C-----ROTATION OF THE INITIAL POLARIZATION TO THE DYNAMIC COORDINATES
      SA(1)= CG*E1(1)+SG*E1(2)
      SA(2)=-SG*E1(1)+CG*E1(2)
      SA(3)=E1(3)
      SA(4)=1.
      SB(1)= CG*E2(1)+SG*E2(2)
      SB(2)=-SG*E2(1)+CG*E2(2)
      SB(3)=E2(3)
      SB(4)=1.

      CALL KO_SPIN(S,SA,SB)

C---- CALCULATION OF THE SPIN WEIGHT FOR POLARIZED ELECTRONS
      LSOF= XK.EQ.0.
      LHAR= .NOT.LSOF
      TOT=ZERO

      CALL KO_AMPLIT(0,T1,T2)

      DO 210 I=1,4
      DO 210 J=1,4
      IF(LSOF) TOT=TOT+DCONJG(T1(I,J))*T2(I,J)+DCONJG(T2(I,J))*T1(I,J)
      IF(LHAR) TOT=TOT+DCONJG(T1(I,J))*T1(I,J)+DCONJG(T2(I,J))*T2(I,J)
 210  CONTINUE
      ROT=ZERO

      CALL KO_AMPLIT(1,T1,T2)

      DO 200 I=1,4
      DO 200 J=1,4
      DO 200 K=1,4
      DO 200 L=1,4
      IF(LSOF) ROT=ROT+
     +S(K,L)*(DCONJG(T1(K,I))*T2(L,J)+DCONJG(T2(K,I))*T1(L,J))*E(J,I)
      IF(LHAR) ROT=ROT+
     +S(K,L)*(DCONJG(T1(K,I))*T1(L,J)+DCONJG(T2(K,I))*T2(L,J))*E(J,I)
  200 CONTINUE
      WT=DREAL(ROT/TOT)
      XLSP=MAX(XLSP,1.2*WT)
      ENDDO

      ENDIF
C ---
C     GENERATION
C ---
   50 CALL EVENTB
c
      KTO=1

      CALL DEKAY(KTO,H1)

      KTO=2

      CALL DEKAY(KTO,H2)

      H1(4)=1.
      H2(4)=1.

      CALL KO_SPIN(E,H1,H2)

C-----ROTATION OF THE INITIAL POLARIZATION TO THE DYNAMIC COORDINATES
      SA(1)= CG*E1(1)+SG*E1(2)
      SA(2)=-SG*E1(1)+CG*E1(2)
      SA(3)=E1(3)
      SA(4)=1.
      SB(1)= CG*E2(1)+SG*E2(2)
      SB(2)=-SG*E2(1)+CG*E2(2)
      SB(3)=E2(3)
      SB(4)=1.

      CALL KO_SPIN(S,SA,SB)

C---- CALCULATION OF THE SPIN WEIGHT FOR POLARIZED ELECTRONS
      LSOF= XK.EQ.0.
      LHAR= .NOT.LSOF
      TOT=ZERO

      CALL KO_AMPLIT(0,T1,T2)

      DO 110 I=1,4
      DO 110 J=1,4
      IF(LSOF) TOT=TOT+DCONJG(T1(I,J))*T2(I,J)+DCONJG(T2(I,J))*T1(I,J)
      IF(LHAR) TOT=TOT+DCONJG(T1(I,J))*T1(I,J)+DCONJG(T2(I,J))*T2(I,J)
 110  CONTINUE
      ROT=ZERO

      CALL KO_AMPLIT(1,T1,T2)

      DO 100 I=1,4
      DO 100 J=1,4
      DO 100 K=1,4
      DO 100 L=1,4
      IF(LSOF) ROT=ROT+
     +S(K,L)*(DCONJG(T1(K,I))*T2(L,J)+DCONJG(T2(K,I))*T1(L,J))*E(J,I)
      IF(LHAR) ROT=ROT+
     +S(K,L)*(DCONJG(T1(K,I))*T1(L,J)+DCONJG(T2(K,I))*T2(L,J))*E(J,I)
  100 CONTINUE
      WT=DREAL(ROT/TOT)
      SWT(4)=SWT(4)+1.
      SWT(5)=SWT(5)+WT
      SWT(6)=SWT(6)+WT*WT
c
      RRR=RLU(0)
c      CALL GRNDM(RRR,1)
c
      R=XLSP*RRR
      IF(R.GT.WT) GOTO 50
      RETURN
      END


      SUBROUTINE KO_AMPLIT(MODE,T1,T2)
C********************************************************************
C  IN THIS ROUTINE THE COMPLEX SPIN AMPLITUDES FOR THE TAU          *
C  PRODUCTION PROCESS ARE CALCULATED                                *
C********************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
C
      COMMON /KOCONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON /KOWEAK  / QCE,QCF,CVE,CVF,CAE,CAF,ZPROP
      COMMON /KOUTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON /KOBOXY  / Z1,Z2,Z3
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON /KOSIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON /KONEWZET/ IFZET,ITRANS
      COMPLEX*16 T1(4,4),T2(4,4),ZERO,FAC,TCI(4,4),TCF(4,4)
      COMPLEX*16 ONEC,IMAG,F2,ZH,Z1,Z2,Z3,ZFAC
      ZERO=DCMPLX(0.D0,0.D0)
      IMAG=DCMPLX(0.D0,1.D0)
      ONEC=DCMPLX(1.D0,0.D0)
C
      IF(XK.GT.0.) GOTO 300
C  ********************************************
C  *                                          *
C  *       SOFT PHOTON CASE                   *
C  *                                          *
C  ********************************************
      C=C1
      S=S1
      DO 10 I=1,4
      DO 10 IJ=1,4
 10   T1(I,IJ)=ZERO
C-----BORN AMPLITUDE
      T1(1,1)=       ONEC
      T1(2,2)=     C*ONEC
      T1(2,4)= AMF*S*IMAG
C     TERMS PROPORTIONAL TO BORN
      A=ALF1*QEF
      FAC=(1.+SOF1+A*BRM)*ONEC
      DO 20 I=1,4
      DO 20 J=1,4
 20   T2(I,J)=T1(I,J)*FAC
C-----BOX CONTRIBUTIONS
      T2(1,1)=T2(1,1)+A*Z1
      T2(2,2)=T2(2,2)+A*Z2
      T2(2,4)=T2(2,4)+A*Z3*IMAG*AMF
C-----FINAL FERMION F2-VERTEX CONTRIBUTION
      F2IM=-QF2*ALF1*PI*AMF2/(4.*BT1)
      F2=DCMPLX(F2RE,F2IM)
      T2(1,1)=T2(1,1)+2.*F2
      T2(2,2)=T2(2,2)+2.*C*F2
      T2(2,4)=T2(2,4)+2.*S/AMF*IMAG*F2
C---- NEW Z IMPLEMENTATION.
      IF(IFZET.EQ.1.AND.MODE.EQ.1) THEN

      CALL ZNEW(ZFAC,ENE)

      ZFAC=ZFAC/QCE/QCF
      T1(1,1)=T1(1,1)+ZFAC*(CVE*CVF+C*CAE*CAF)*ONEC
      T1(1,2)=T1(1,2)+ZFAC*(CVE*CAF+C*CAE*CVF)*ONEC
      T1(2,1)=T1(2,1)+ZFAC*(CAE*CVF+C*CVE*CAF)*ONEC
      T1(2,2)=T1(2,2)+ZFAC*(CAE*CAF+C*CVE*CVF)*ONEC
C
      T2(1,1)=T2(1,1)+ZFAC*(CVE*CVF+C*CAE*CAF)*ONEC
      T2(1,2)=T2(1,2)+ZFAC*(CVE*CAF+C*CAE*CVF)*ONEC
      T2(2,1)=T2(2,1)+ZFAC*(CAE*CVF+C*CVE*CAF)*ONEC
      T2(2,2)=T2(2,2)+ZFAC*(CAE*CAF+C*CVE*CVF)*ONEC
      ENDIF
C-----WEAK BOSON Z0 CONTRIBUTION GIVES GAMMA-Z0 INTERFERENCE
C-----THIS CAN BE REASONABLE FOR ENE .LE. 20 GEV
      IF (QEF.EQ.0.) RETURN
      IF(IFZET.EQ.0.AND.MODE.EQ.1) THEN

      CALL ZNEW(ZFAC,ENE)

      ZFAC=ZFAC/QCE/QCF
      T2(1,1)=T2(1,1)+ZFAC*(CVE*CVF+C*CAE*CAF)*ONEC
      T2(1,2)=T2(1,2)+ZFAC*(CVE*CAF+C*CAE*CVF)*ONEC
      T2(2,1)=T2(2,1)+ZFAC*(CAE*CVF+C*CVE*CAF)*ONEC
      T2(2,2)=T2(2,2)+ZFAC*(CAE*CAF+C*CVE*CVF)*ONEC
      ENDIF
      RETURN
  300 CONTINUE
C  *******************************************
C  *                                         *
C  *       HARD PHOTON CASE                  *
C  *                                         *
C  *******************************************
      Y=SQRT(1.-XK)
      BB=.5*XK/Y
      GB=(1.-.5*XK)/Y
      AM=AMF/Y
      HINI= QCE/Y/BB/(AEL2+S1**2)
      HFIN= QCF/BB/(AM**2+V**2*S2**2)
C-----
      TCI(1,1)= (-BB*SF                              )*HINI*ONEC
      TCI(1,2)= ( BB*C2*CF                           )*HINI*IMAG
      TCI(1,3)=                                             ZERO
      TCI(1,4)= ( AM*BB*S2*CF                        )*HINI*ONEC
      TCI(2,1)= ( BB*C1*CF                           )*HINI*IMAG
      TCI(2,2)= (-BB*C1*C2*SF                        )*HINI*ONEC
      TCI(2,3)=                                             ZERO
      TCI(2,4)= ( AM*BB*C1*S2*SF                     )*HINI*IMAG
      TCI(3,1)= (-GB*CF                              )*HINI*ONEC
      TCI(3,2)= (-GB*C2*SF                           )*HINI*IMAG
      TCI(3,3)=                                             ZERO
      TCI(3,4)= (-AM*GB*S2*SF                        )*HINI*ONEC
      TCI(4,1)= (-GB*C1*SF                           )*HINI*IMAG
      TCI(4,2)= (-GB*C1*C2*CF+S1*S2                  )*HINI*ONEC
      TCI(4,3)=                                             ZERO
      TCI(4,4)= ( AM*(GB*C1*S2*CF+S1*C2)             )*HINI*IMAG
C-----
      TCF(1,1)= (-BB*V*S2*SF                         )*HFIN*ONEC
      TCF(1,2)= ( BB*V*S2*C2*CF                      )*HFIN*IMAG
      TCF(1,3)= ( AM*BB*SF                           )*HFIN*IMAG
      TCF(1,4)= (-AM*BB*V*C2*C2*CF                   )*HFIN*ONEC
      TCF(2,1)= ( BB*V*S2*C1*CF                      )*HFIN*IMAG
      TCF(2,2)= (-BB*V*S2*C2*C1*SF                   )*HFIN*ONEC
      TCF(2,3)= ( AM*BB*C1*CF                        )*HFIN*ONEC
      TCF(2,4)= (-AM*BB*V*C2*C2*C1*SF                )*HFIN*IMAG
      TCF(3,1)= (-GB*V*S2*CF                         )*HFIN*ONEC
      TCF(3,2)= (-GB*V*S2*C2*SF                      )*HFIN*IMAG
      TCF(3,3)= ( AM*BB*CF                           )*HFIN*IMAG
      TCF(3,4)= (-AM*V*(GB*S2*S2-BB)*SF              )*HFIN*ONEC
      TCF(4,1)= (-GB*V*S2*C1*SF                      )*HFIN*IMAG
      TCF(4,2)= (-V*S2*(GB*C1*C2*CF-S1*S2)           )*HFIN*ONEC
      TCF(4,3)= (-AM*BB*C1*SF                        )*HFIN*ONEC
      TCF(4,4)= ( AM*V*((GB*S2*S2-BB)*C1*CF+S2*C2*S1))*HFIN*IMAG
      DO 140 K=1,4
      DO 140 I=1,2
      ZH=TCF(I,K)
      TCF(I  ,K)=    ZH*CF-TCF(I+2,K)*SF
  140 TCF(I+2,K)=    ZH*SF+TCF(I+2,K)*CF

C-----
*$ CORRECTION 16 11 87 Z.W.
      SGX=C1*SQRT(AEL2)
*$ CORRECTION 16 11 87 Z.W.
      SGX1= SGX*BB/GB
      DO 150 K=1,4
      T1(1,K)= S1*TCI(1,K)+TCF(1,K)
      T1(2,K)=(S1*TCI(2,K)+TCF(2,K))*IMAG
*$ CORRECTION 16 11 87 Z.W.
      T1(3,K)=-SGX*TCI(1,K)*IMAG*C1
      T1(4,K)=-SGX*TCI(2,K)
C-----
      T2(1,K)= S1*TCI(3,K)+TCF(3,K)
      T2(2,K)=(S1*TCI(4,K)+TCF(4,K))*IMAG
*$ CORRECTION 16 11 87 Z.W.
      T2(3,K)=-SGX1*TCI(3,K)*IMAG*C1
 150  T2(4,K)=-SGX1*TCI(4,K)
      RETURN
      END


      SUBROUTINE ZNEW(ZPROP,ENE)
      IMPLICIT REAL*8 (A-H,O-Z)
      common /KOznowy/ amz,gamz
       COMPLEX*16 ZPROP
c
       S   =4D0*ENE**2
       ZPROP=S/DCMPLX(S-AMZ**2,GAMZ*S/AMZ)
      END


      SUBROUTINE KO_SPIN(V,E1,F1)
C     modified routine SPIN(....
C     **********************
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 V(4,4)
      DIMENSION E(4),F(4),E1(4),F1(4)
      COMMON /KONEWZET/ IFZET,ITRANS
      COMMON /KOCONTRL/ SWT(6),ISPIN
      COMMON /KOREINIT/ IFINI
c
      DATA ZER/0./
      DATA init/0/
C     DATA itrans/0/
c
      IF (IFINI.EQ.0) INIT=0
C
      if (init.eq.0) then
       init=1
       write(6,*) 'SPIN: itrans=',itrans,'   *****'
      endif
      if (itrans.eq.0) then
       do 7 k=1,4
        E(K)=E1(K)
        F(K)=F1(K)
 7     continue
        E(1)=0.0
        F(1)=0.0
        E(2)=0.0
        F(2)=0.0
        IF (ISPIN.EQ.0) THEN
          E(3)=0.0
          F(3)=0.0
        ENDIF
       V(1,1)=DCMPLX( E(4)*F(4) -E(1)*F(1) +E(2)*F(2) +E(3)*F(3),  ZER)
       V(2,2)=DCMPLX( E(4)*F(4) +E(1)*F(1) -E(2)*F(2) +E(3)*F(3),  ZER)
       V(3,3)=DCMPLX( E(4)*F(4) -E(1)*F(1) -E(2)*F(2) -E(3)*F(3),  ZER)
       V(4,4)=DCMPLX( E(4)*F(4) +E(1)*F(1) +E(2)*F(2) -E(3)*F(3),  ZER)
       V(1,2)=DCMPLX( E(3)*F(4) +E(4)*F(3), E(1)*F(2) +E(2)*F(1))
       V(3,4)=DCMPLX( E(3)*F(4) -E(4)*F(3),-E(1)*F(2) +E(2)*F(1))
       V(1,3)=DCMPLX( E(4)*F(1) -E(1)*F(4),-E(2)*F(3) +E(3)*F(2))
       V(2,4)=DCMPLX( E(4)*F(1) +E(1)*F(4), E(2)*F(3) +E(3)*F(2))
       V(1,4)=DCMPLX( E(3)*F(1) +E(1)*F(3), E(4)*F(2) +E(2)*F(4))
       V(2,3)=DCMPLX( E(3)*F(1) -E(1)*F(3), E(4)*F(2) -E(2)*F(4))
       V(1,4)=DCMPLX( E(3)*F(1) +E(1)*F(3), E(4)*F(2) +E(2)*F(4))
       V(2,3)=DCMPLX( E(3)*F(1) -E(1)*F(3), E(4)*F(2) -E(2)*F(4))
      else
       do 8 k=1,4
        E(K)=E1(K)
        F(K)=F1(K)
 8    continue
        IF (ISPIN.EQ.0) THEN
          E(1)=0.0
          F(1)=0.0
          E(2)=0.0
          F(2)=0.0
          E(3)=0.0
          F(3)=0.0
        ENDIF
       V(1,1)=DCMPLX( E(4)*F(4) -E(1)*F(1) +E(2)*F(2) +E(3)*F(3),  ZER)
       V(2,2)=DCMPLX( E(4)*F(4) +E(1)*F(1) -E(2)*F(2) +E(3)*F(3),  ZER)
       V(3,3)=DCMPLX( E(4)*F(4) -E(1)*F(1) -E(2)*F(2) -E(3)*F(3),  ZER)
       V(4,4)=DCMPLX( E(4)*F(4) +E(1)*F(1) +E(2)*F(2) -E(3)*F(3),  ZER)
       V(1,2)=DCMPLX( E(3)*F(4) +E(4)*F(3), E(1)*F(2) +E(2)*F(1))
       V(3,4)=DCMPLX( E(3)*F(4) -E(4)*F(3),-E(1)*F(2) +E(2)*F(1))
       V(1,3)=DCMPLX( E(4)*F(1) -E(1)*F(4),-E(2)*F(3) +E(3)*F(2))
       V(2,4)=DCMPLX( E(4)*F(1) +E(1)*F(4), E(2)*F(3) +E(3)*F(2))
       V(1,4)=DCMPLX( E(3)*F(1) +E(1)*F(3), E(4)*F(2) +E(2)*F(4))
       V(2,3)=DCMPLX( E(3)*F(1) -E(1)*F(3), E(4)*F(2) -E(2)*F(4))
       V(1,4)=DCMPLX( E(3)*F(1) +E(1)*F(3), E(4)*F(2) +E(2)*F(4))
       V(2,3)=DCMPLX( E(3)*F(1) -E(1)*F(3), E(4)*F(2) -E(2)*F(4))
      endif
      V(2,1)=DCONJG(V(1,2))
      V(4,3)=DCONJG(V(3,4))
      V(3,1)=DCONJG(V(1,3))
      V(4,1)=DCONJG(V(1,4))
      V(4,2)=DCONJG(V(2,4))
      V(3,2)=DCONJG(V(2,3))
      RETURN
      END


      SUBROUTINE STARB(ENE1,AMF1,IDE1,IDF1,AMZ1,SINW1,INRAN,XK1,XKMM)
C     ***************************************************************
C     ****************************************************************
C     *                                                              *
C     *  START IS ROUTINE SETING INITIAL VALUES TO CERTAIN VARIABLES *
C     *  AND PRINTING SOME USEFULL OUTPUT                            *
C     *  MUST BE CALLED BY USER BEFORE FIRST EVENT IS GENERATED      *
C     *  ENE=ABS(ENE1) IS BEAM ENERY IN GEV UNITS, NEGATIVE VALUE    *
C     *  CAUSES SWITCHING OFF RADIATIVE CORRECTIONS. SINW2 IN THE    *
C     *  SQUARE OF THE WEINBERG ANGLE, SWITCHING OFF Z0 CONTRIBUTION *
C     *  MAY BE ACHIEVED BY SETING SINW2=-0.5   .                    *
C     *  INRAN -INITIALISATION CONSTANT FOR RANDOM NUMBER GENERATOR  *
C     *  ANY POSITIVE INTEGER.                                       *
C     ****************************************************************
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /KOCONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON /KOUTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON /KOSIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON /KOWEAK  / QCE,QCF,CVE,CVF,CAE,CAF,ZPROP
      COMMON /KOINOUT / NINP,NOUT
      COMMON /KOCONTRL/ SWT(6),ISPIN
      COMMON /KORNF   / INIRAN,NGEN
      COMMON /KOVACPOL/ IFVAC
C     ****************************************************************
C     *  FIRST VERSION WRITTEN   20.04.1982, NO SPIN YET.            *
C     *  SECOND VERSION  20.03.1983,                                 *
C     *  SPIN CORRELATIONS IN THE DOUBLE DECAY INCLUDED.             *
C     *  THIRD VERSION 22.12.1983,                                   *
C     *  INITIAL SPIN INCLUDED.                                      *
C     ****************************************************************
C
      ENE=ABS(ENE1)
C-----PHOTON MINIMUM AND MAXIMUM ENERGY IN UNITS OF BEAM ENERGY ENE
      XKMIN=0.0
      XKMAX=XKMM
C;;   XK0=0.01
      XK0=XK1
      INIRAN=INRAN
      PI=4.*ATAN(1.)
      ALFA=1./137.036
      ALF1=ALFA/PI
C-----SWITCHING OFF RADIATIVE CORRECTIONS
      IF(ENE1.LT.0.) ALF1=0.
      IF(ENE1.LT.0.) XKMAX=.9*XK0
      CMTR=389.385E-30
      DO 6 I=1,6
   6  SWT(I)=1.
C.....WARNING, THE ABOVE ASIGNMENTS IS NOT AN ERROR, IT IS FOR PURPOSE.
      ISPIN=1
      NGEN=9
      DUMMY=RNF100(-2)
      AEL=.51110034E-3/ENE
C     FINAL FERMION MASS
C;;   AMFIN=1.782
      AMFIN=AMF1
      AMF=AMFIN/ENE
      AEL2=AEL**2
      AMF2=AMF**2
      BT1=SQRT(1.-AMF)*SQRT(1.+AMF)
      SVAR=4.*ENE**2
      ALGEL= LOG(4./AEL2)
      ALGMF= LOG(4./AMF2)
C     ****************************************************************
C     *   FERMION CHARGES                                            *
C     *   QCE  INCOMING (BEAM)   FERMION CHARGE                      *
C     *   QCF  OUTGOING FERMION  ( HEAVY LEPTON )  CHARGE            *
C     *   SINW2  SIN OF WEIBERG ANGLE SQUARED                        *
C     *   ELECTRON COUPLING CONSTANTS  CVE , CAE                     *
C     *   AND TAU COUPLING CONSTANTS   CVF , CAF                     *
C     ****************************************************************
C     FOR QUARK PRODUCTION IDFIN SCHOULD BE CHANGED APROPRIATELY
C;;   IDFIN=-2
C;;   CALL SETWS(   -2,SINW2,QCE,CVE,CAE,AMZ,GAMM)
C;;   CALL SETWS(IDFIN,SINW2,QCF,CVF,CAF,AMZ,GAMM)

C;;;  WEAK COUPLING CONSTANTS
C     IDE IS THE INCOMING FERMION IDENTIFIER
C     IDF IS THE OUTGOING FERMION IDENTIFIER
C     IDF=2   MUON,TAU...
C     IDF=3   UP QUARK   ( U,C,T...)
C     IDF=4   DOWN QUARK  ( D,S,B...)
C     IDF NEGATIVE DENOTES ANTIPARTICLE
C     IDE=-2   INCOMING POSITRON
      IDE= IDE1
      IDF= IDF1
      SINW2=ABS(SINW1)

      CALL SETCUP(-IDE,SINW2,QCE,CVE,CAE)

      CALL SETCUP(-IDF,SINW2,QCF,CVF,CAF)

      AMZ=AMZ1

C-----SWITCHING OFF Z0 CONTRIBUTION FOR TESTS
      IF(SINW1.GT. 0D0) GOTO 15
      AMZ=10000.
      CAE=0.
      CVE=0.
   15 ZPROP=0.
C   15 ZPROP=0./(1.-AMZ**2/ENE**2/4.)
      QE2=QCE**2
      QF2=QCF**2
      QEF=QCE*QCF
      COLR=1.
      IF(IABS(IDF).NE.2) COLR=3.
      SIG0=COLR*4.*QE2*QF2*PI*ALFA**2/3./SVAR
C------------------   SOFT PHOTON PARAMETERS
      ALK0= LOG(XK0)
      BETI=QE2*2.*ALF1*(ALGEL-1.)
      DSXI=BETI*ALK0+QE2*ALF1*(1.5*ALGEL-2.+PI*PI/3.)
      Y= LOG((1.+BT1)**2/AMF2)
      ATH2=QF2*Y
      BETF=QF2*2*ALF1*((1.+BT1**2)/(2.*BT1)*Y-1.)
      DSXF=BETF*(ALK0+.5*ALGMF)+QF2*ALF1*((3.+2.*BT1**2)/(2.*BT1)*Y
     $-2.-(1.+BT1**2)/(2.*BT1)*(Y**2+4.*DILOGT(2*BT1/(1.+BT1))-PI**2))
      F2RE=-QF2*ALF1*.25*AMF2/BT1*Y
      PIREL=ALF1*(5./9.-1./3.*ALGEL)
      PIRMU=ALF1*(5./9.-1./3.* LOG(SVAR/.10566**2))
      PIRTA=ALF1*(8./9.-BT1**2/3.-BT1/6.*(3.-BT1**2)*Y)
      PIRE=PIREL+PIRTA+PIRMU+PIRET(SVAR)
      IF (IFVAC.EQ.0) THEN
        WRITE(6,*) 'Vaccum polarization switched off: pire set to zero'
        PIRE=0.0
      ENDIF
      IF(ALF1.EQ.0.) PIRE=0.
      ZCON=2.*ZPROP/QCE/QCF*CVE*CVF
      SOFT=DSXI+DSXF-2.*PIRE+ZCON
      SOF1=DSXI+DSXF-2.*PIRE
C
      IF(XKMIN.LT.XK0) XKMIN=0.
      XKMAX= MAX (XKMAX,XK0)
      XKMAX= MIN (XKMAX,(1.-AMF2))
C
c      WRITE(6,1000) ENE,SINW2,INIRAN   ! Corrected by V.Tayursky
      WRITE(6,1000) ENE,SINW2
      WRITE(6,1004) AMZ,CVE,CAE,CVF,CAF
C
      CSOFT=0.
      IF(XKMIN.EQ.0.) CSOFT=XKDEF(XK0)
      CSTOT=XKDEF(XKMAX)-XKDEF(XKMIN)
      WRITE(6,1006) CSOFT,CSTOT
C
      SIG0CM=SIG0*CMTR
      WRITE(6,1010)    SIG0CM
      IF(ALF1.EQ.0.) WRITE(6,1017)
      DUMM=RRGEN(-5.D0)
C
      RETURN
 1000 FORMAT(//,1H0,10(10H**********)//
     -  /20X,    40HSTART PARAMETERS ARE ...                ,
     -  /50X,    10HENERGY    ,F10.4,10H  GEV     ,
     -  /50X,    10HSINW2     ,F10.4)
c     -  /50X,    10HINRAN     ,I10)
 1004 FORMAT(1H0,
     -  /20X,    40HMASS OF ELECTROWEAK BOSON Z0 IS  (GEV)  ,F10.4,
     -  /20X,    30HCOUPLIG CONSTANTS: CVE, CAE    ,2F10.4,
     -  /20X,    30H                   CVF, CAF    ,2F10.4)
 1006 FORMAT(1H0,
     -  /20X,    40HCONTRIBUTIONS TO SOFT CROSS SECT. ARE...,
     -  /20X,    40HBORN + SOFT PHOTON + VERTEX CORR. INIT. ,F10.4,
     -  /20X,    40HTOTAL CROSS SECTION - APPROXIMATE       ,F10.4)
 1010 FORMAT(1H ,
     -  /20X,    40HALL ABOVE CROSS SECTIONS ARE GIVEN IN   ,
     -  /20X,    40HUNITS OF THE LOWEST ORDER ( POINTLIKE ) ,
     -  /20X,    40HONE PHOTON CROSS-SECTION  SIG0 WHICH IS ,
     -  /20X,    10HEQUAL TO  ,E20.5,6H CM**2)
 1017 FORMAT(1H0,
     -  /20X,    40HNO RAD. CORRECTIONS, ONLY LOWEST ORDER    )
      END


      SUBROUTINE SETCUP(IDF,SIN2,QC,CV,CA)
C     ************************************
C SETCUP CALCULATES CV,CA WHICH CORRESPOND TO A GIVEN VALUE
C OF TEH WEINBERG ANGLE.
C NOTE THAT SIGN OF AXIAL COUPL CONST. MAY BE DIFFERENT FROM CHOICES IN
C THE LITERATURE. IT IS OPPOSITE TO THAT IN CERN BOOKLET.
C IDF IS QUARK OR LEPTON IDENTIFIER, QC ITS CHARGE  (S.J.)
      IMPLICIT REAL*8(A-H,O-Z)
      B=1./SQRT(16.*SIN2*(1.-SIN2))
      IDFERM=IABS(IDF)
      GO TO (1,2,3,4), IDFERM
C     NOT USED  ( NEUTRINO )
    1 QC=0.
      CV=B
      CA=B
      GO TO 500
C     ELECTRON, MUON ...
    2 QC=-1.
      CV=(-1.+4.*SIN2)*B
      CA=-B
      GO TO 500
C     UP QUARKS
    3 QC=2./3.
      CV=(1.-8./3.*SIN2)*B
      CA=B
      GO TO 500
C     DOWN QUARKS
    4 QC=-1./3.
      CV=(-1.+4./3.*SIN2)*B
      CA=-B
  500 IF(IDF.GT.0) RETURN
C     ANTIPARTICLES
      QC=-QC
      CV=-CV
      CA=+CA
      RETURN
      END


      FUNCTION PIRET(S)
C     *****************
      IMPLICIT REAL*8(A-H,O-Z)
C-----IT RETURNS THE VALUE OF THE HADRONIC CONTRIBUTION TO VACUUM
C-----POLARISATION, USING PARAMETRISATION OF H. BURKHARD TASSO NOTE
C-----NO. 192, DECEMBER 1981.
      IF(S.LT.1.)
     $                PIRET=-1.3450E-9 -2.3020E-3* LOG(1.+4.091*S)
      IF(S.GT.1.0.AND.S.LT.64)
     $                PIRET=-1.5120E-3 -2.8220E-3* LOG(1.+1.218*S)
      IF(S.GT.64)
     $                PIRET=-1.1344E-3 -3.0680E-3* LOG(1.+0.99992*S)
      RETURN
      END


      SUBROUTINE EVENTB
C     ****************
      IMPLICIT REAL*8(A-H,O-Z)
C     ****************************************************************
C     *  EVENT IS CENTRAL  ROUTINE FOR SIMULATION OF THE SPINLESS    *
C     *  EVENTS, IT GENERATES ALL ANGULAR VARIABLES AND THE MONENTA  *
C     *  OF TAU+ TAU- AND GAMMA (IF PRESENT).                        *
C     ****************************************************************
      COMMON /KOCONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON /KOUTIL  / QP(4),QM(4),PH(4)
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      COMMON /KOUTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON /KOWEAK  / QCE,QCF,CVE,CVF,CAE,CAF,ZPROP
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON /KOCONTRL/ SWT(6),ISPIN
      COMMON /KOSIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      REAL*4 RRR,RLU
      FUND(C1,S1,C2,S2)=(1.-.5*XK*(1.-C1))**2+
     +( XKT*S1*S2*CF-(1.-.5*XK)*C1*C2-.5*XK*C2 )**2
C-----
    1 CONTINUE
      R=RNF100(1)
C-----RAW  XK-DISTRIBUTION ,  CHOICE BETWEEN SOFT AND HARD EMISSION
      XK=RRGEN(R)
      IF(XK.GT.XK0) GO TO 20
C-----****************************************************************
C-----SOFT PHOTON EMISSION, FIRST THE ANGULAR DISTRIBUTION
C-----WITH ONLY C-SYMETRIC COMPONENT
   10 FIG=2.*PI*RNF100(4)
   11 XK=0.
      C1=1.-2.*RNF100(6)
      S1=SQRT((1.-C1)*(1.+C1))
      C2=1.
      S2=0.
      CF=1.
      SF=0.
      V=BT1
      WT=((2.-(S1*V)**2)*(1.+SOFT)+4.*F2RE)/(2.*(1.+SOFT))
      IF(RNF100(8).GT.WT) GO TO 11
C-----****************************************************************
C-----IMPOSING  C-ODD (INTERFERENCE,BOX ETC.) TERMS

      CALL BRMBOX

      IF(QEF.NE.0.) ZCONA=4.*ZPROP/QCE/QCF*CAE*CAF
      IF(QEF.EQ.0.) ZCONA=0.
      WT=.5*( 1. + ( ALF1*QEF*((2.-(S1*V)**2)*BRM+BOX) +C1*V*ZCONA)
     $            /((2.-(S1*V)**2)*(1.+SOFT)+4.*F2RE)   )
      IF(RNF100(9).GT.WT) GO TO 10
      GO TO 400
C-----****************************************************************
C-----   HARD PHOTON BREMSSTRAHLUNG,
C.....1  MODELING XK-DISTRIBUTION
C.....2  CHOICE BETWEEN INITIAL AND FINAL BREMSSTRAHLUNG
C.....3  GENERATING ANGULAR VARIABLES
C------------------------
C.....1111111111111111111111111111111111111111111111111111111111111111
   20 CONTINUE
      XK1=1.-XK
      XKT=SQRT(XK1)
      V=SQRT(ABS(1.-AMF2/XK1))
      EPS1=AMF2/XK1/(1.+V)
      U=1.-.5*AEL2
      EPS=.5*AEL2
      ROIT=.5*BETI*(1.+XK1*XK1)/XK/XK1
      ROFT=1.5*QF2*ALF1*(1.+XK1*XK1-2.*AMF2)/XK*ATH2
      ROI=BETI*(1.+XK1**2)/XK/XK1*V*(3.-V**2)/4.
      ROF=QF2*ALF1/XK*( (1.+XK1*XK1-AMF2*XK-.50*AMF2**2)*
     $   LOG((1.+V)**2*XK1/AMF2) -((2.+AMF2)*XK1+XK**2)*V )
      WT=(ROI+ROF)/(ROIT+ROFT)
      SWT(1)=SWT(1)+1.
      SWT(2)=SWT(2)+WT
      SWT(3)=SWT(3)+WT*WT
      IF(RNF100(2).GT.WT) GO TO 1
C.....2222222222222222222222222222222222222222222222222222222222222222
   25 CONTINUE
      IF(RNF100(3)-ROI/(ROI+ROF)) 31,1,41
C-----
C.....3333333333333333333333333333333333333333333333333333333333333333
C-----INITIAL STATE RADIATION, ANGULAR VARIABLES
C-----
   31 FIG=2.*PI*RNF100(4)
      R=RNF100(5)
      DEL1=EPS*((2.-EPS)/EPS)**R
      DEL2=2.-DEL1
      RRR=RLU(0)
c      CALL GRNDM(RRR,1)

      IF(RRR.GT.0.5) GO TO 35
      A=DEL1
      DEL1=DEL2
      DEL2=A
   35 C1=1.-DEL1
      S1=SQRT((DEL1-EPS)*(DEL2-EPS))
      ZET1=1.-V+2.*V*RNF100(6)
      ZET2=2.-ZET1
      C2=1.-ZET1
      S2=SQRT((ZET1-EPS1)*(ZET2-EPS1))
      FI=2.*PI*RNF100(7)
      CF=COS(FI)
      SF=SIN(FI)
      D1=2.*FUND( C1, S1, C2, S2)+2.*AMF2/XK1*(1.-.5*XK*DEL1)**2
      D2=2.*FUND(-C1,-S1, C2, S2)+2.*AMF2/XK1*(1.-.5*XK*DEL2)**2
      WT=(D1*(1.-AEL2/XK1/DEL2)+D2*(1.-AEL2/XK1/DEL1) )
     $    /(4.*(1.+XK1*XK1))
      IF(RNF100(8).GT.WT) GO TO 31
      GO TO 200
C.....2222222222222222222222222222222222222222222222222222222222222222
C-----FINAL STATE RADIATION, ANGULAR VARIABLES
C-----
   41 FIG=2.*PI*RNF100(4)
      DEL1=EPS+2.*U*RNF100(5)
      DEL2=2.-DEL1
      C1=1.-DEL1
      S1=SQRT((DEL1-EPS)*(DEL2-EPS))
      R=RNF100(6)
      ZET1=EPS1*((2.-EPS1)/EPS1)**R
      ZET2=2.-ZET1
c
      RRR=RLU(0)
c      CALL GRNDM(RRR,1)
c
      IF(RRR.GT.0.5) GO TO 45
      A=ZET1
      ZET1=ZET2
      ZET2=A
   45 C2=1.-ZET1
      S2=SQRT((ZET1-EPS1)*(ZET2-EPS1))
      FI=2.*PI*RNF100(7)
      CF=COS(FI)
      SF=SIN(FI)
      D1=2.*FUND(-C2,-S2,-C1,-S1)+2.*AMF2
      D2=2.*FUND( C2, S2,-C1,-S1)+2.*AMF2
      D3=AMF2*XK*XK*(1.+C1*C1)-8.*AMF2*XK
      WT=(D1*(1.-AMF2/ZET2)+D2*(1.-AMF2/ZET1)+D3)
     $   /(4.*(1.+XK1*XK1)-2.*AMF2)
      IF(RNF100(8).GT.WT) GO TO 41
C-----****************************************************************
C-----INTRODUCING INTERFRRENCE TERMS IN GENERATED ANGULAR DISTRIBU-
C-----TIONS FOR HARD BREMSSTRAHLUNG EVENTS.
  200 CONTINUE
      WT=.5*WINTH(DUM)
      IF(RNF100(9).GT.WT) GO TO 25
C-----UNTIL THIS POINT VARIABLES C2 AND S2 WERE MULTIPLIED BY V.
      C2=C2/V
      S2=S2/V
C-----
C-----CONSTRUCTION MOMENTA OUT OF ANGULAR VARIABLES USING TRALOR
  400 CONTINUE
      CG=COS(FIG)
      SG=SIN(FIG)
      DO 420 I=1,3
      QP(I)=0.
  420 QM(I)=0.
      QP(4)=AMF

      CALL TRALOR(1,QP)

      QM(4)=AMF

      CALL TRALOR(2,QM)

      DO 430 I=1,4
  430 PH(I)=-QP(I)-QM(I)
      PH(4)=2.+PH(4)
      IF(XK.EQ.0.) PH(4)=0.
C
      RETURN
      END


      SUBROUTINE BRMBOX
C     *****************
      IMPLICIT REAL*8(A-H,O-Z)
C     ****************************************************************
C     *                                                              *
C     *  CONTRIBUTIONS FROM THE SOFT BREMSSTRAHLUNG AD BOX DIAGR.    *
C     *  SPIN AMPLITUDES FOR FINITE PART OF BOX CONTIBUTIONS         *
C     ****************************************************************
      COMMON /KOCONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON /KOSIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON /KOUTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      COMMON /KOBOXY  / Z1,Z2,Z3
      COMPLEX*16 Z1,Z2,Z3,ZERO,AA,BB,FD,FQ,ALP,ALM
      EQUIVALENCE (ALGEL,AE),(ALGMF,AF)
      COMMON /KOREINIT/ IFINI
c
      DATA ENIT/0./
c      data iik /0/
c
      IF (IFINI.EQ.0) ENIT=0.
C
      IF(ENIT.EQ.ENE) GO TO 10
      ENIT=ENE
      ALK0= LOG(XK0)
      ZERO=DCMPLX(0.D0,0.D0)
      ALP=DCMPLX(AE+AF,2.D0*PI)
      ALM=DCMPLX(AE-AF,0.D0)
      BTR=(1.+BT1)**2/AMF2
      FDRE=.5*(AE*AE+PI*PI/3.)
      FQRE=.5*( LOG(BTR)**2+PI*PI/3.+4.*DILOGT(-1/BTR))/BT1
      FD=DCMPLX(FDRE,-PI*AE)
      FQ=DCMPLX(FQRE,-PI* LOG(BTR))
   10 CONTINUE
      BRM=0.
      Z1=ZERO
      Z2=ZERO
      Z3=ZERO
      V=BT1
      DO 20 I=1,2
      SGN=1.
      IF(I.NE.1) SGN=-1.
      C=SGN*C1
      S=SGN*S1
      TR=2.-2.*C*V-AMF2
      DL=.5*TR/S/S/V/V
      RO=(V-C)/TR
      X=(1.-C*V)/SQRT(TR)
      X2=X*X
      Y=.5*(SQRT(TR)+AMF2/(1.+V))
      BRM=BRM+SGN*(
     $   2*(DILOGT(-X/(1.-Y))-DILOGT((1-X)/(1.-Y))-DILOGT((1+X)/Y)
     $  +DILOGT(X/Y))+ LOG(Y/(1.-Y))**2-DILOGT(X2)+.5* LOG(X2)**2
     $   - LOG(X2)* LOG(1.-X2)   )
      A1=2.* LOG(.5*(1.-C*V))+AE+AF
      B1= LOG(.5*(1.-C*V))**2-2.*DILOGT(.5*TR/(1.-C*V))
     $                                       -.5*AE*AE-.5*AF*AF
      AA=DCMPLX(A1,0.D0)
      BB=DCMPLX(B1,PI*A1)
      Z1=Z1+(        V*RO*AA    +(DL-1.)*BB            +DL*FD
     $       +(1.-V*C*DL)*FQ        -.5*ALP   +.5*AMF2/TR*ALM )*SGN
      Z2=Z2           +RO*AA       -C*DL*BB     +C*(1.-DL)*FD
     $        +(V*DL+C-V)*FQ      -.5/V*ALP +.5*AMF2/TR/V*ALM
      Z3=Z3         -S/TR*AA-.5*TR/S/V/V*BB     +S*(1.-DL)*FD
     $       +.5*C*TR/V/S*FQ                       +S/TR*ALM
   20 CONTINUE
      BRM=BRM+4.* LOG((1.-V*C1)/(1.+V*C1))*ALK0
C      BRM=0.0
C      Z1=ZERO
C      Z3=ZERO
C      Z2=ZERO
C      IF (IIK.NE.5) THEN
C       IIK=5
C      write(6,*) 'boxy wyzerowane'
C      endif
      BOX=DREAL(Z1+C1*Z2+AMF2*S1*Z3)
      RETURN
      END


      SUBROUTINE TRALOR(KTO,VEC)
C     **************************
      IMPLICIT REAL*8(A-H,O-Z)
C
C     ******************************************************************
C     *   TRALOR TRANSFORMES FOUR-VECTOR VEC FROM TAU REST SYSTEM      *
C     *   TO LAB SYSTEM. RECOMMENDED TO USE  FOR DECAY PRODUCTS.       *
C     *   KTO=1,2 DENOTES TAU+ AND TAU- CORRESPONDINGLY                *
C     ******************************************************************
C
      COMMON /KOUTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      DIMENSION VEC(4),VEC1(4),TL(4,4)
C IBLAD=1 makes program as with the error which was removed april/may 93
C IBLAD=0 is the right choice.
      DATA IBLAD / 0/
C
      Y=SQRT(1.-XK)
      A=Y/AMF
      B=SQRT((A-1.)*(A+1.))
      IF(KTO.EQ.2) B=-B
      BB=.5*XK/Y
      GB=(1.-.5*XK)/Y
C
      IF (XK.GT.0.2*XK0) THEN
        H1= C1*S2*CF+GB*S1*C2
        H2=-S1*S2*CF+GB*C1*C2
        TL(1,1)= CF
        TL(1,2)=-C2*SF
        TL(1,3)=-A*S2*SF
        TL(1,4)=-B*S2*SF
        TL(2,1)= C1*SF
        TL(2,2)= C1*C2*CF-GB*S1*S2
        TL(2,3)=-B*BB*S1+A*H1
        TL(2,4)=-A*BB*S1+B*H1
        TL(3,1)=-S1*SF
        TL(3,2)=-S1*C2*CF-GB*C1*S2
        TL(3,3)=-B*BB*C1+A*H2
        TL(3,4)=-A*BB*C1+B*H2
        TL(4,1)= 0.
        TL(4,2)= BB*S2
        TL(4,3)= B*GB-A*BB*C2
        TL(4,4)= A*GB-B*BB*C2
      ELSE
        H1=-S1
        IF (IBLAD.EQ.1) H1=S1
        H2= C1
        TL(1,1)= 1.0
        TL(1,2)= 0.0
        TL(1,3)= 0.0
        TL(1,4)= 0.0
        TL(2,1)= 0.0
        TL(2,2)= H2
        TL(2,3)= A*H1
        TL(2,4)= B*H1
        TL(3,1)= 0.0
        TL(3,2)=-H1
        TL(3,3)= A*H2
        TL(3,4)= B*H2
        TL(4,1)= 0.
        TL(4,2)= 0.
        TL(4,3)= B
        TL(4,4)= A
      ENDIF
C
      DO 100 I=1,4
  100 VEC1(I)=VEC(I)
      DO 110 I=1,4
      SUM=0.
      DO 105 J=1,4
  105 SUM=SUM+TL(I,J)*VEC1(J)
  110 VEC(I)=SUM
C     ROTATION ARROUND THE BEAM
      A=VEC(1)
      VEC(1)=CG*A-SG*VEC(2)
      VEC(2)=SG*A+CG*VEC(2)
C
      RETURN
      END


      FUNCTION WINTH(DUM)
C     *******************
      IMPLICIT REAL*8(A-H,O-Z)
C     ****************************************************************
C     * HERE THE CONTRIBUTION FROM THE INTERFERENCE OF THE INITIAL   *
C     * AND FINAL STATE BREMSSTRAHLUNG IS CALCULATED FOR USE IN      *
C     * SUBROUTINE EVENT  ( HARD BREMSSTARHLUNG ONLY)                *
C     ****************************************************************
C
      COMMON /KOCONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON /KOUTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      EQUIVALENCE (AMF2,AM),(AEL2,AL)
C
      Z1=SQRT(1.-XK)*S1*S2*CF-(1.-.5*XK)*C1*C2
      Z2=1.-.5*XK
      T = Z1+Z2+.5*XK*( C1-C2)
      U1=-Z1+Z2+.5*XK*(-C1-C2)
      U =-Z1+Z2+.5*XK*( C1+C2)
      T1= Z1+Z2+.5*XK*(-C1+C2)
      TT=T*T
      UU=U*U
      TT1=T1*T1
      UU1=U1*U1
      SS=2.
      SP=2.*(1.-XK)
      X1=XK*(1.-C1)
      X2=XK*(1.+C1)
      IF(C1.GT.0.9) X1=XK*(AEL2+S1**2)/(1.+C1)
      IF(C1.LT.-.9) X2=XK*(AEL2+S1**2)/(1.-C1)
      Y1=XK*(1.-C2)
      Y2=XK*(1.+C2)
      AINI=(TT+UU+AM/SP*(T+U)**2)*(1.-AL/SP*X1/X2)
     $   +(TT1+UU1+AM/SP*(T1+U1)**2)*(1.-AL/SP*X2/X1)
      AINI=AINI*QE2/(SP*X1*X2)
      AFIN=(TT+UU1+AM*SS)*(1.-AM*(Y1+Y2)/Y2/SS)
     $    +(UU+TT1+AM*SS)*(1.-AM*(Y1+Y2)/Y1/SS)
     $    +AM*(X1*X1+X2*X2)/SS-4.*AM*(SS-SP)
      AFIN=AFIN*QF2/(SS*Y1*Y2)
      ANTR=(TT+TT1+UU+UU1+AM*SS+AM*SP)
     $     *(T*X2*Y2+T1*X1*Y1-U*X2*Y1-U1*X1*Y2)
     $      +AM*X1*X2*((SS-SP)*(T+T1-U-U1)-(X1-X2)*(Y1-Y2))
      ANTR=ANTR*QEF/(SS*SP*X1*X2*Y1*Y2)
      WINTH=1.+ANTR/(AINI+AFIN)
      RETURN
      END


      SUBROUTINE FINISB(CSTCMT,ERREL)
C     ************************
      IMPLICIT REAL*8(A-H,O-Z)
C**********************************************************************
C     FINISH CALCULATES TOTAL CROSS SECTION FOR GENERATED EVENTS      I
C     USING AVERAGE WEIGHTS. IT GIVES STATISTICAL ERRORS DEPENDING ON I
C     THE NUMBER OF THE GENERATED EVENTS.                             I
C     CSTOT IS TOTAL EXACT CROSS SECTION GIVEN IN  CM**2              I
C     TO BE USED TO RENORMALISE HISTOGRAMS IN  CM**2 UNITS            I
C**********************************************************************
      COMMON /KOSIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON /KOCONTRL/ SWT(6),ISPIN
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      COMMON /KOINOUT / NINP,NOUT
C;;
C
      AWTA=0.
      DWTA=0.
      IF(SWT(1).EQ.0.) GO TO 10
      AWTA=SWT(2)/SWT(1)
      DWTA=SQRT(SWT(3)/SWT(2)**2-1./SWT(1))*100.
   10 AWTB=SWT(5)/SWT(4)
      DWTB=SQRT(SWT(6)/SWT(5)**2-1./SWT(4))*100.
C-----
      CSOFT=0.
      IF(XKMIN.EQ.0.) CSOFT=XKDEF(XK0)
      CSTOT=XKDEF(XKMAX)-XKDEF(XKMIN)
      CSHAR=CSTOT-CSOFT
C-----
      CSTOT=(CSOFT+AWTA*CSHAR)*AWTB
      DWTT=AWTA*CSHAR/(CSOFT+AWTA*CSHAR)
      DWTT=DWTT*DWTA+DWTB
      CSTCM=CSTOT*SIG0CM
C;;
      ERREL=SQRT((DWTT*DWTA)**2+DWTB**2)/100.
      CSTCMT=CSTCM

      NEVA=INT(SWT(1)-1.)
      NEVB=INT(SWT(4)-1.)
C
      WRITE(6,1000)       NEVA,AWTA,DWTA,
     $                       NEVB,AWTB,DWTB,
     $                           CSTOT,DWTT
C
 1000 FORMAT(1H0,10(10H**********),/,7H FINISB,//
     -  /21X, 20H NO. OF CRUDE EVENTS,20H      AVERAGE WEIGHT,
     -                                20H      PERCENT ERRORS,
     -  /11X, 20HHARD BREMSS. WEIGHT ,I10, F20.6,F10.2,
     -  /11X, 20HSPIN WEIGHT         ,I10, F20.6,F10.2,
     - //11X, 40HTOTAL EXACT CROSS SECT. IN SIG0 UNITS
     -                                   , F10.6,F10.2)
      RETURN
      END


      FUNCTION XKDEF(XK)
C     ******************
      IMPLICIT REAL*8(A-H,O-Z)
C
C     ****************************************************************
C     *                                                              *
C     *  DEFINES RAW CROSS SECTION FOR PHOT. MOMENTUM  .LT. XK       *
C     *  USED IN RRGEN TO GENERATE RAW XK DISTRIBUTION               *
C     *                                                              *
C     ****************************************************************
C
      COMMON /KOSIGMA / SIG0,SIG0CM,SOFT,SOF1,F2RE,BRM,BOX
      COMMON /KOCONST / PI,ALFA,ALF1,QE2,QF2,QEF
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      COMMON /KOENERG / ENE,AEL2,AMF2,AMF,ALGEL,ALGMF,BETI,BT1,ATH2
      COMMON /KOREINIT/ IFINI
c
      FUNH(X)=BETI*( LOG(X)-.5*X-.5* LOG(1.-X))
     $   +3.*ALF1*ATH2*((1.-AMF2)* LOG(X)-X+.25*X*X)
C
      DATA ENIT /.0/
c
      IF (IFINI.EQ.0) ENIT=0.
      IF(ENIT.EQ.ENE) GO TO 10
      ENIT=ENE
      SOFSIG=BT1*((1.+.5*AMF2)*(1.+SOFT)+3.*F2RE)
      SUDIS0=SOFSIG-FUNH(XK0)
      SUDIST=SUDIS0+FUNH(1.-AMF2)
   10 CONTINUE
      IF(XK.GT.0.) GO TO 110
      XKDEF=0.
      RETURN
  110 IF(XK.GT.XK0) GO TO 120
      XKDEF=SOFSIG*XK/XK0
      RETURN
  120 IF(XK.GT.(1.-AMF2)) GO TO 140
      XKDEF=SUDIS0+FUNH(XK)
      RETURN
  140 XKDEF=SUDIST
      RETURN
      END


      FUNCTION RRGEN(R)
C     *****************
      IMPLICIT REAL*8(A-H,O-Z)
C
C     ****************************************************************
C     *                                                              *
C     *  RRGEN IS GENERAL ROUTINE GENERATING ARBITRARY ONE DIM.      *
C     *  DISTRIBUTION DEFINED THROUGH XKDEF FUNCTION.                *
C     *  IT MEMORIZES THE SCHAPE OF DISTRIBUTION IN XX-MATRIX STEP   *
C     *  BY STEP WITH BETTER AND BETTER PRECISSION.  MATRIX XX       *
C     *  IS UPDATED AT THE MOMENT WHEN CERTAIN NUMBER OF EVENTS      *
C     *  (THAT LISTET IN MATRIX LIST ) HAS BEEN GENERATED.           *
C     *                                                              *
C     ****************************************************************
C
      COMMON /KOUTIL2 / XK0,XKMIN,XKMAX
      DIMENSION  XX(1025),LIST(11)
      DATA LIST
     $/1,2,3,4,64,256,1024,4096,16384,65536,-1/
      DATA IEV,LEN /0,1024/
C
      IEV=IEV+1
      IF(R.LT.0.) IEV=1
      IF(IEV.NE.1) GO TO 10
      IP=1
      EPS =.05/FLOAT(LEN)
      EPS1=.00025
      ID=LEN
      IW=1
      XW=1.
      XX(1)=XKMIN
      XX(LEN+1)=XKMAX
      F0=XKDEF(XKMIN)
      DF=XKDEF(XKMAX)-F0
   10 CONTINUE
      IF(IEV.NE.LIST(IP))GO TO 300
      IP=IP+1
      DO 100 I=1,IW
      IA1=ID*(I-1)+1
      IA2=IA1+ID
      IA=(IA1+IA2)/2
C     ITERATION COME ON
      X1=XX(IA1)
      X2=XX(IA2)
      IF((X2-X1).LT.EPS1) GO TO 31
      Y1=XKDEF(X1)
      Y2=XKDEF(X2)
      Y=FLOAT(IA-1)/FLOAT(LEN)
      DO 30  ITER=1,30
      X=.5*(X1+X2)
      F=(XKDEF(X)-F0)/DF
      IF(Y-F) 20,31,21
   20 X2=X
      Y2=Y
      GO TO 23
   21 X1=X
      Y1=Y
   23 IF((Y2-Y1) .LT.EPS.AND.(X2-X1).LT.EPS1) GO TO 31
   30 CONTINUE
   31 XX(IA)=.5*(X1+X2)
C     END OF ITERATION
  100 CONTINUE
      ID=ID/2
      IW=IW*2
      XW=XW*2.
C
  300 CONTINUE
      I=INT(.5*XW*R)
      IA1=2*I*ID+1
      IA2=IA1+ID
      IA3=IA2+ID
      X1=XX(IA1)
      X2=XX(IA2)
      X3=XX(IA3)
      Y=R*XW-FLOAT(2*I)
      X=.5*(Y-1.)*(Y-2.)*X1-Y*(Y-2.)*X2+.5*Y*(Y-1)*X3
      X= MAX (X,X1)
      X= MIN (X,X3)
      RRGEN=X
      RETURN
C=======================================================================
C===================END OF CPC PART ====================================
C=======================================================================
      END

