      SUBROUTINE KEDRGEN1(EACT)
c*****************************************************************
c
c   Generation of primary tracks kinematics: generators 201-300
c
c   Output: EACT - actual energy (GeV) of beam in cms. EACT=0 - special
c
c   Changes: see A_history
c
c*****************************************************************
      Implicit NONE

      Integer *4 IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN,
     &           IEOTRI,IEVENT,ISWIT,IFINIT,NEVENT,NRNDM
      COMMON/GCFLAG/IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN
     &        ,IEOTRI,IEVENT,ISWIT(10),IFINIT(20),NEVENT,NRNDM(2)

      Real *4 PI,TWOPI,PIBY2,DEGRAD,RADDEG,CLIGHT,BIG,EMASS
      COMMON/GCONST/PI,TWOPI,PIBY2,DEGRAD,RADDEG,CLIGHT,BIG,EMASS

      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)

#include "../../../KedrSim/pkin.inc"

c      Real *4 EPART,PXPART,PYPART,PZPART
c      Integer *4 NTRACK,IPARTICLE
c      COMMON /PKIN/     NTRACK,IPARTICLE(50),EPART(50),    ! for output file
c     &                  PXPART(50),PYPART(50),PZPART(50)
      
      Real *4 GENPAR
      Integer *4 KHEP,KGEN
      COMMON /KEDR_GEN/ KHEP,KGEN,GENPAR(20)        ! parameters for generators
      
      Real *4 PARU,PARJ
      Integer *4 MSTU,MSTJ
      COMMON /LUDAT1/   MSTU(200),PARU(200),MSTJ(200),PARJ(200)

      Real *4 PMAS,PARF,VCKM
      Integer *4 KCHG
      COMMON /LUDAT2/   KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)

      Real *4 BRAT
      Integer *4 MDCY,MDME,KFDP
      COMMON /LUDAT3/   MDCY(500,3),MDME(2000,2),BRAT(2000),KFDP(2000,5)

      REAL *8 P1,Q1,P2,Q2,PHOT
      Integer *4 NPHOT
      COMMON /BHMOMSET/ P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT  ! for BHWIDE

      INTEGER NMXHEP
      PARAMETER (NMXHEP=2000)

      REAL*8  PHEP,  VHEP         ! to be real*4 / *8  depending on host
      Integer *4 NEVHEP,NHEP,ISTHEP,IDHEP,JMOHEP,JDAHEP
      COMMON /HEPEVT/             ! for PHOTOS
     $      NEVHEP,               ! serial number
     $      NHEP,                 ! number of particles
     $      ISTHEP(NMXHEP),       ! status code
     $      IDHEP(NMXHEP),        ! particle ident KF
     $      JMOHEP(2,NMXHEP),     ! parent particles
     $      JDAHEP(2,NMXHEP),     ! childreen particles
     $      PHEP(5,NMXHEP),       ! four-momentum, mass [GeV]
     $      VHEP(4,NMXHEP)        ! vertex [mm]

      COMMON /PHOQED/
     $     QEDRAD(NMXHEP)         ! PHOTOS flag
c
      LOGICAL QEDRAD
      REAL *8 CMSENE,THMINP,THMAXP,THMINE,THMAXE
      REAL *8 ENMINP,ENMINE,ACOLLI,EPSCMS
      REAL *8 QP(4),QM(4),QG(4),PMASS,WIDTH,CHRG,SPIN,CTAU
      Real *4 RESULT,PROB,PROB_MAX,TMIN,THETA,TET,CTET,EBEAM
      Real *4 ECM_PSI,ECM,R,RLU,PLAB(3),ETAU,CPHI,PHI,ST,T,Q,EACT
      Integer *4 I,IFSR,KF,NUND,KF0,NDEC2,KGFROMKF,KS,MOD,IE
      Integer *4 IGENPAR(20),NLUND,itype,IDC,IND,LUCOMP,KC,NDEC1
      INTEGER *4 ISR,ITHEVENT,NDAUG,KFL(100),KML(100),NTE,KFL0
      REAL *8 PXL(100),PYL(100),PZL(100),EL(100)
      CHARACTER *12 NAME
      CHARACTER *8  T212(17)  ! text for generator 212
      CHARACTER *4  T2121(2),T2122(2)  ! text for generator 212
      CHARACTER *7  T211A(3)  ! text-1 for generator 211
      CHARACTER *19 T211B(3)  ! text-2 for generator 211
c
      SAVE
c
      DATA T212/'e+e-','mu+mu-','pi+pi-','K+K-','p anti-p','n anti-n',  ! 212
     &          'e mu','      ','      ','    ','e+e-','mu+mu-',
     &          'pi+pi-','K+K-','p anti-p','n anti-n','e mu'/
      DATA T2121/' 0  ',' -  '/  ! J/psi
      DATA T2122/' 0  ','0.28'/  ! psi'
c      
      DATA T211A/'J/psi  ','psi(2S)','Someth '/
      DATA T211B/'gamma + eta_c      ',
     &           'gamma + eta(548)   ',
     &           'gamma + eta-pr(958)'/ 
c
      DO I=1,20
 	IGENPAR(I)=GENPAR(I)   ! +
      END DO
c
      NLUND=GENPAR(2)          ! for gen.
c
c-------------------------------------------------------------------
c
c      Determination of process for simulation from data card
c      =======================================================
c
c* KGEN=201-299: Yu.I.Skovpen & V.A.Tayursky & E.M.Baldin
c
      IF(KGEN.EQ.201) GOTO 200 ! e+ e- -> e+ e- (gamma)
      IF(KGEN.EQ.202) GOTO 200 ! e+ e- -> mu+ mu- (gamma)
      IF(KGEN.EQ.203) GOTO 200 ! e+ e- -> tau+ tau- (gamma)
      IF(KGEN.EQ.204) GOTO 200 ! e+ e- -> gamma gamma (gamma)
      IF(KGEN.EQ.205) GOTO 205 ! e+ e- -> QQbar
      IF(KGEN.EQ.206) GOTO 205 ! e+ e- -> ggg
      IF(KGEN.EQ.207) GOTO 207 ! e+ e- -> e+ e- (gamma) [ BHWIDE ]
      IF(KGEN.EQ.210) GOTO 210 ! e+ e- -> J/psi
      IF(KGEN.EQ.211) GOTO 211 ! e+ e- -> J/psi, psi' -> gamma + eta_c; ...
      IF(KGEN.EQ.212) GOTO 212 ! e+ e- -> J/psi -> 2 particles +  PHOTOS
      IF(KGEN.EQ.213) GOTO 213 ! e+ e- -> psi(psi')->e+e-(interf.) + PHOTOS
      IF(KGEN.EQ.214) GOTO 214 ! e+ e- -> J/psi (BES-generator)             
      IF(KGEN.EQ.215) GOTO 215 ! e+ e- -> psi' (BES-generator)              
      IF(KGEN.EQ.216) GOTO 216 ! e+ e- -> continuum (BES-generator)   
      IF(KGEN.EQ.217) GOTO 217 ! e+ e- -> continuum (LUARLW, Hu Haiming,BES-II)
      IF(KGEN.EQ.281) GOTO 281 ! e+ e- -> QQ -> one gamma
      IF(KGEN.EQ.282) GOTO 281 ! e+ e- -> QQ -> one charged pi
      IF(KGEN.EQ.283) GOTO 281 ! e+ e- -> QQ -> only gammas
      IF(KGEN.EQ.284) GOTO 281 ! e+ e- -> QQ -> only charged pi's
c
      PRINT *,' Wrong generator number! See the KEDR WWW page '
      GOTO 500
c
c------------------------------------------------------------------
c
c  QED generators of F.Berends (KGEN=201-204) 
c
c  201: e+e-(g), 202: mu+mu-(g), 203: tau+tau-(g), 204: gg(g)
c
 200  NTRACK=0
      EACT=GENPAR(1)         ! actual energy of beam in cms             
c
      CALL QED(QP,QM,QG)
c
      IF(KGEN.NE.203) THEN                  !========================
c
c  Process is not equal to tau+tau-(gamma)
c
        IF(KGEN.EQ.201) ITYPE=3  ! GEANT type of 1-st final particle
        IF(KGEN.EQ.202) ITYPE=5  
        IF(KGEN.EQ.204) ITYPE=1
        PLAB(1)=QP(1)            
        PLAB(2)=QP(2)
        PLAB(3)=QP(3)
c
        NTRACK=NTRACK+1
        IPARTICLE(NTRACK)=ITYPE
        EPART(NTRACK)=QP(4)
        PXPART(NTRACK)=QP(1)
        PYPART(NTRACK)=QP(2)
        PZPART(NTRACK)=QP(3)
c
        IF(KGEN.eq.201) ITYPE=2   ! GEANT type of 2-nd final particle
        IF(KGEN.eq.202) ITYPE=6
        IF(KGEN.eq.204) ITYPE=1
        PLAB(1)=QM(1)
        PLAB(2)=QM(2)
        PLAB(3)=QM(3)
c
        NTRACK=NTRACK+1
        IPARTICLE(NTRACK)=ITYPE
        EPART(NTRACK)=QM(4)
        PXPART(NTRACK)=QM(1)
        PYPART(NTRACK)=QM(2)
        PZPART(NTRACK)=QM(3)
c
      END IF                                 ! ===========================
c
      IF(QG(4).GT.0.D0) THEN                 ! vvvvvvvvvvvvvvvvvvvvvvvvvvv
c
c + radiative photon
c   
        ITYPE=1
        PLAB(1)=QG(1)
        PLAB(2)=QG(2)
        PLAB(3)=QG(3)
c
        NTRACK=NTRACK+1
        IPARTICLE(NTRACK)=ITYPE
        EPART(NTRACK)=QG(4)
        PXPART(NTRACK)=QG(1)
        PYPART(NTRACK)=QG(2)
        PZPART(NTRACK)=QG(3)
c
      END IF                                ! ^^^^^^^^^^^^^^^^^^^^^^^^
c
c----------------------------------------------------------------------
c
c  KGEN=203: e+e- -> tau+tau-(gamma) (Generator of Berends)
c
      IF(KGEN.EQ.203) THEN                  !=========== tau-block
c
c  Selection of tau+ decay mode should be at each event
c          
        KC=LUCOMP(-15)    ! JetSet   (tau+)
        IND=MDCY(KC,2)    ! 1-st index of position in table of decay channel
        NDEC1=IGENPAR(2)  ! # of decay mode of tau+ in run
c
        DO I=1,37
          IDC=IND+I-1     ! all decay channels are included
          MDME(IDC,1)=1
        END DO
c
        IF(NDEC1.GE.1.AND.NDEC1.LE.37) THEN
c
c  Selection of tau+ decay channal, modification /ludat3/
c
          DO I=1,37  
            IDC=IND+I-1
            IF(I.EQ.NDEC1) THEN
              MDME(IDC,1)=1
 	    ELSE
              MDME(IDC,1)=0
 	    END IF
c
          END DO
c
 	END IF            ! end of mode selecton for tau+ decay
c
        Q=SQRT(QP(1)**2+QP(2)**2+QP(3)**2)
        T=ACOS(QP(3)/Q)
        ST=SIN(T)
c
        IF(ABS(ST).LT.1.E-4) THEN
c
          R=RLU(0)
c
          PHI=6.28318*R
        ELSE
          CPHI=QP(1)/Q/ST
c
          IF(ABS(CPHI).GT.1.) THEN
            WRITE(6,*)' WARNING, gukine_s: CPHI=',CPHI
            CPHI=1.
          END IF
c
          PHI=ACOS(CPHI)
          IF(QP(2).LT.0.) PHI=6.28318-PHI
        END IF
c
        ETAU=QP(4)
c
        CALL LU1ENT(-1,-15,ETAU,T,PHI)   ! tau+
c
        CALL LUEXEC                      ! management of tau+ decays
c
        IF(N.LE.0) THEN
          PRINT *,' Error in GUKINE_S: tau+ generation, n <=0'
          STOP
        END IF 
c
        DO I=1,N
          KS=K(I,1)
          KF=K(I,2)
c
          IF(KS.EQ.1.OR.KS.EQ.4) THEN
            ITYPE=KGFROMKF(KF)
c
            IF(ITYPE.NE.0) THEN
              PLAB(1)=P(I,1)
              PLAB(2)=P(I,2)
              PLAB(3)=P(I,3)
              NTRACK=NTRACK+1
              IPARTICLE(NTRACK)=ITYPE
              EPART(NTRACK)=P(I,4)
              PXPART(NTRACK)=P(I,1)
              PYPART(NTRACK)=P(I,2)
              PZPART(NTRACK)=P(I,3)
c
            ELSE
              write(6,*)'!!!!! warning ----- unknown type of particle'
c
              CALL PstPPar(KF,NAME,PMASS,WIDTH,CHRG,SPIN,CTAU)
c
              WRITE (6,*)'KS,KF,NAME=',KS,KF,' ',NAME
            END IF
          END IF
c
        END DO
c
c  Preparation for tau- generation
c
        Q=SQRT(QM(1)**2+QM(2)**2+QM(3)**2)
        T=ACOS(QM(3)/q)
        ST=SIN(t)
c
        IF(ABS(ST).LT.1.E-4) THEN
c
          R=RLU(0)
c
          PHI=6.28318*R
        ELSE
          CPHI=QM(1)/Q/ST
          IF(ABS(CPHI).GT.1.) THEN
            WRITE (6,*)' WARNING ','CPHI=',CPHI
            CPHI=1.
          END IF
c
          PHI=ACOS(CPHI)
          IF(QM(2).LT.0.) PHI=6.28318-PHI
        END IF
c
c  Selection of tau- decay mode should be at each event
c          
        KC=LUCOMP(15)     ! JetSet   (tau-)
        IND=MDCY(KC,2)    ! 1-st index of position in table of decay channel
        NDEC2=IGENPAR(3)  ! # of decay mode of tau- in run
c
        DO I=1,37
          IDC=IND+I-1     ! all decay channels are included
          MDME(IDC,1)=1
        END DO
c
        IF(NDEC2.GE.1.AND.NDEC2.LE.37) THEN
c
c  Selection of decay channal, modification /ludat3/
c
          DO I=1,37
            IDC=IND+I-1
            IF(I.EQ.NDEC2) THEN
              MDME(IDC,1)=1
            ELSE
              MDME(IDC,1)=0
            END IF
          END DO
c
        END IF                ! end of mode selecton for tau+ decay
c
        ETAU=QM(4)
c
        CALL LU1ENT(-2,15,ETAU,T,PHI)      ! add tau-    
c
        CALL LUEXEC                        ! management of tau decays
c
      END IF                    !========================= end of tau-block
c
      IF(KGEN.EQ.203) GOTO 299  ! for tau+tau-(g)
c
      GOTO 500                  ! for e+e-(g), mu+mu-(g), gg(g)
c
c--------------------------------------------------------------------
c
c   KGEN=207 - e+ e- -> e+ e- (gamma)      ( Generator BHWIDE 1.0.4 )
c
 207  NTRACK=0
c
      EACT=GENPAR(1)           ! actual energy of beam in cms      
      CMSENE=2.*GENPAR(1)
      THMINP=GENPAR(2)
      THMAXP=GENPAR(3)
      THMINE=GENPAR(4)
      THMAXE=GENPAR(5)
      ENMINP=GENPAR(6)
      ENMINE=GENPAR(7)
      ACOLLI=GENPAR(8)
      EPSCMS=GENPAR(9)
c
      CALL GEN_BHW104(IEVENT,NEVENT,
     *  CMSENE,THMINP,THMAXP,THMINE,THMAXE,ENMINP,ENMINE,ACOLLI,EPSCMS)
c
c  Store BHW particles for output file 
c
      ITYPE=2         ! e+
      PLAB(1)=-p2(1)
      PLAB(2)=-p2(2)
      PLAB(3)=-p2(3)
c
c      CALL GSKINE(PLAB,ITYPE,NVERT,0,0,NT)
c
      NTRACK=NTRACK+1
      IPARTICLE(NTRACK)=ITYPE
      EPART(NTRACK)=P2(4)
      PXPART(NTRACK)=-P2(1)
      PYPART(NTRACK)=-P2(2)
      PZPART(NTRACK)=-P2(3)
c
      ITYPE=3         !  e-
      PLAB(1)=-Q2(1)
      PLAB(2)=-Q2(2)
      PLAB(3)=-Q2(3)
c
      NTRACK=NTRACK+1
      IPARTICLE(NTRACK)=ITYPE
      EPART(NTRACK)=Q2(4)
      PXPART(NTRACK)=-Q2(1)
      PYPART(NTRACK)=-Q2(2)
      PZPART(NTRACK)=-Q2(3)
c
      IF(NPHOT.GT.0) THEN
        ITYPE=1               ! rad.photons
c
        DO I=1,NPHOT
          PLAB(1)=-PHOT(I,1)
          PLAB(2)=-PHOT(I,2)
          PLAB(3)=-PHOT(I,3)
c
          NTRACK=NTRACK+1
          IPARTICLE(NTRACK)=ITYPE
          EPART(NTRACK)=PHOT(I,4)
          PXPART(NTRACK)=-PHOT(I,1)
          PYPART(NTRACK)=-PHOT(I,2)
          PZPART(NTRACK)=-PHOT(I,3)
c
        END DO
c
      END IF
c
      GOTO 500                        ! end of block of BHWIDE
c
c----------------------------------------------------------------------
c
c  KGEN=205 - e+e- -> QQ         /on base of Jetset 7.4/
c  KGEN=206 - e+e- -> ggg
c
 205  CONTINUE 
      EACT=GENPAR(1)        ! actual energy of beam in cms
c
      IF(IEVENT.EQ.1) THEN                                   !  print title
        IF(KGEN.EQ.205) PRINT 2051,GENPAR(1),NLUND,IGENPAR(3)
        IF(KGEN.EQ.206) PRINT 2061,GENPAR(1),NLUND
      END IF
c
      NTRACK=0
c
c      CALL gsvert(VERTEX,0,0,0,0,nvert)
c
      ECM=2.*GENPAR(1)                        ! total energy
c
      IF(KGEN.EQ.205) THEN
        IF(GENPAR(3).GT.0.5) MSTJ(107)=1      ! 1: include Init.state rad.corr          
c
        CALL LUEEVT(NLUND,ECM)  ! annihilation in continuum

      END IF
c
      IF(KGEN.EQ.206) CALL LUONIA(NLUND,ECM)  ! 
c
      GOTO 299
c
c-----------------------------------------------------------------------
c
c  KGEN=210: e+ e- -> J/psi  /on base of Jetset 7.4/
c 
c  GENPAR(1) = 0: all
c            = 1: rndmflav
c
 210  NTRACK=0
c
      KC=LUCOMP(443)                   ! J/psi
      ECM=PMAS(KC,1)                   ! mass of J/psi
      EACT=ECM/2                       ! actual energy of beam in cms
c
      IF(IEVENT.EQ.1) THEN
         IF(GENPAR(1).LT.0.5) PRINT 2101,ECM    !  print title 
         IF(GENPAR(1).GT.0.5) PRINT 2102,ECM   
      END IF
c
 2103 CALL LU1ENT(-1,443,ECM,0.,0.)
c
      CALL LUEXEC
c
      IF(GENPAR(1).LT.0.5) GOTO 2104
c
      NUND=0                   ! number of undecayed particles
c
      DO I=1,N
        KS=K(I,1)              ! status of particle
        IF(KS.GT.0.AND.KS.LT.5) NUND=NUND+1 
      END DO
c
c   Should not be final states: e+e- or mu+mu-
c
      IF(NUND.EQ.2) THEN       ! 2 final particles
c
        DO I=1,N
          KS=K(I,1)            ! status
          KF=K(I,2)            ! type of particle
c
          IF(KS.GT.0.and.KS.LT.5) THEN
            ITYPE=KGFROMKF(KF) ! Geant-type from kf-type of particle
c
            IF(ITYPE.EQ.0) THEN
              PRINT *, ' Gen.210: unknown type of particle', K(I,2)
              STOP
            END IF
c
            IF(IABS(KF).EQ.11)   GOTO 2103
            IF(IABS(KF).EQ.13)   GOTO 2103
          END IF
        END DO
      END IF
c
 2104 CONTINUE
c
c========== test print of /LUJETS/ ===========================

c      print *,' Test print of /LUJETS/:'
c      print *,' N=',N
c      print 987,K(1,1),K(1,2),K(1,3),K(1,4),K(1,5)
c      print 988,K(2,1),K(2,2),K(2,3),K(2,4),K(2,5)      
c      print 989,K(3,1),K(3,2),K(3,3),K(3,4),K(3,5)
c987   format(' K(1,1-5)=',5I8)
c988   format(' K(2,1-5)=',5I8)
c989   format(' K(3,1-5)=',5I8)
c      print 887,P(1,1),P(1,2),P(1,3),P(1,4),P(1,5)
c      print 888,P(2,1),P(2,2),P(2,3),P(2,4),P(2,5)
c      print 889,P(3,1),P(3,2),P(3,3),P(3,4),P(3,5) 
c887   format(' P(1,1-5)=',5F8.4)
c888   format(' P(2,1-5)=',5F8.4)
c889   format(' P(3,1-5)=',5F8.4)
c
      GOTO 299
c
c-------------------------------------------------------------------
c
c  KGEN=211:
c  e+ e- -> J/psi, psi' -> gamma eta_c; gamma eta(548); gamma eta'(958)  
c
 211  NTRACK=0
      EACT=GENPAR(1)/2 ! actual beam energy in cms
      NDEC1=IGENPAR(2) !  mode: 1 = gamma eta_c; 2 = gamma eta; 3 = gamma eta'
c
      IF(NDEC1.LT.1.OR.NDEC1.GT.3) THEN
        PRINT *,' Gen. 211, error: MODE=',NDEC1
        STOP
      END IF
c
      ECM_PSI=GENPAR(1)                           ! CMS energy
c
      IF(IEVENT.EQ.1) THEN                        ! print title
c
        IF(ABS(ECM_PSI-3.09692).LT.0.001) THEN    ! J/psi
          PRINT 2111,ECM_PSI,T211A(1),T211B(NDEC1) 
          GOTO 2112
        END IF
c
        IF(ABS(ECM_PSI-3.68609).LT.0.001) THEN    ! psi(2S)
          PRINT 2111,ECM_PSI,T211A(2),T211B(NDEC1)
          GOTO 2112
        END IF
c
        PRINT 2111,ECM_PSI,T211A(3),T211B(NDEC1)  ! something                   
c
      END IF
c
 2112 IF(NDEC1.EQ.1) CALL LU2ENT(1,22,441,ECM_PSI)  ! 22-photon, 441-eta_c
c
      IF(NDEC1.EQ.2) CALL LU2ENT(1,22,221,ECM_PSI)  ! 22-photon, 221-eta
c
      IF(NDEC1.EQ.3) CALL LU2ENT(1,22,331,ECM_PSI)  ! 22-photon, 331-eta'
c
 298  R=RLU(0)  
c
      CTET=-1.+2.*R
      R=RLU(0)
c
      IF(2.*R.GT.(1.+CTET**2)) GOTO 298
c
      TET=ACOS(CTET)
      R=RLU(0)
      PHI=TWOPI*R
c
      CALL LUROBO(TET,PHI,0,0,0,)   ! rotation 
c
      CALL LUEXEC                   ! chain of decays 
c            
      GOTO 299
c      
c-------------------------------------------------------------------
c
c      KGEN=281-284
c
c  281: e+ e- -> QQ -> one gamma
c  282: e+ e- -> QQ -> one charged pi
c  283: e+ e- -> QQ -> only gammas
c  284: e+ e- -> QQ -> only charged pi's
c
 281  IF(IEVENT.EQ.1) THEN
        IF(KGEN.EQ.281) PRINT 2811,GENPAR(1)  !  print title
        IF(KGEN.EQ.282) PRINT 2821,GENPAR(1)
        IF(KGEN.EQ.283) PRINT 2831,GENPAR(1)
        IF(KGEN.EQ.284) PRINT 2841,GENPAR(1)
      END IF
c
      NTRACK=0
      EACT=GENPAR(1)             ! actual beam energy in cms
      ECM=2.*GENPAR(1)
c
 295  CALL LUEEVT(0,ecm)
c
      IF(N.GT.0) THEN           ! number of particles >0
c
        DO I=1,N
          ITYPE=0
          IF(K(I,2).EQ.22)   ITYPE=1
          IF(K(I,2).EQ.211)  ITYPE=8
          IF(K(I,2).EQ.-211) ITYPE=9
c
          IF( (ITYPE.EQ.1.and.(KGEN.EQ.281.OR.KGEN.EQ.283)).OR. 
     *    ((ITYPE.EQ.8.OR.ITYPE.EQ.9).AND.
     *    (KGEN.EQ.282.OR.KGEN.EQ.284)) ) THEN
            PLAB(1)=P(I,1)
            PLAB(2)=P(I,2)
            PLAB(3)=P(I,3)
            NTRACK=NTRACK+1
            IPARTICLE(NTRACK)=ITYPE
            EPART(NTRACK)=P(I,4)
            PXPART(NTRACK)=P(I,1)
            PYPART(NTRACK)=P(I,2)
            PZPART(NTRACK)=P(I,3)
c
          END IF
c
          IF(NTRACK.EQ.1.AND.(KGEN.EQ.281.OR.KGEN.EQ.282)) GOTO 296
c
        END DO
c
      END IF
c
      IF(NTRACK.EQ.0) GOTO 295
c
 296  CONTINUE
c
      GOTO 500
c
 299  CONTINUE
c
      IF(N.GT.0) THEN
c
        DO I=1,N
          KS=K(I,1)
          KF=K(I,2)
c
          IF(KS.EQ.1.OR.KS.EQ.4) THEN
            ITYPE=KGFROMKF(KF)
c
            IF(ITYPE.NE.0) THEN
              PLAB(1)=P(I,1)
              PLAB(2)=P(I,2)
              PLAB(3)=P(I,3)
              NTRACK=NTRACK+1
              IPARTICLE(NTRACK)=ITYPE
              EPART(NTRACK)=P(I,4)
              PXPART(NTRACK)=P(I,1)   
              PYPART(NTRACK)=P(I,2)
              PZPART(NTRACK)=P(I,3)
c
            ELSE 
              WRITE (6,*)'!!!!! warning ----- unknown type of particle'
c
              CALL PstPPar(KF,NAME,PMASS,WIDTH,CHRG,SPIN,CTAU)
c
              WRITE (6,*)'KS,KF,NAME=',KS,KF,' ',NAME
            END IF
c
          END IF
c      
        END DO
c
      END IF
c
      GOTO 500   ! RETURN
c
c---------------------------------------------------------------------
c
 212  CONTINUE
c
c  KGEN=212:  e+ e- -> J/psi / psi(2S) -> 2 particles
c
c Dec=1.: J/psi -> e+e- (J=1/2)
c Dec=2.: J/psi -> mu+mu- (J=1/2)
c Dec=3.: J/psi -> pi+pi- (J=0)
c Dec=4.: J/psi -> K+K-   (J=0)
c Dec=5.: J/psi -> proton anti-proton (J=1/2)
c Dec=6.: J/psi -> neutron anti-neutron (J=1/2)
c Dec=7.: J/psi -> e+mu- or e-mu+ (arbitary)
c Dec=11.: psi' -> e+e- (J=1/2)
c Dec=12.: psi' -> mu+mu- (J=1/2)
c Dec=13.: psi' -> pi+pi- (J=0)
c Dec=14.: psi' -> K+K-   (J=0)
c Dec=15.: psi' -> proton anti-proton (J=1/2)
c Dec=16.: psi' -> neutron anti-neutron (J=1/2)
c Dec=17.: psi' -> e+mu- or e-mu+ (arbitary)
c
      IF(IGENPAR(1).LT.1.OR.IGENPAR(1).GT.17.OR.(IGENPAR(1).GT.7.AND.
     &   IGENPAR(1).LT.11)) THEN
        WRITE (6,*)' Generator 212: wrong parameter DEC =',IGENPAR(1),
     +             ', but should be 1-7, 11-17' 
        STOP
      END IF
c
      IF(IGENPAR(3).LT.0.OR.IGENPAR(3).GT.2) THEN
        WRITE (6,*)' Generator 212: wrong parameter AD =',IGENPAR(3),
     +             ', but should be 0-2'
        STOP
      END IF
c
      KF0=443                             ! J/psi 
      IF(IGENPAR(1).GT.10) KF0=30443      ! psi(2S)
      KC=LUCOMP(KF0)                         
      ECM=PMAS(KC,1)                      ! mass of J/psi or psi(2S)
      EACT=ECM/2                          ! actual beam energy in cms
c
      IF(IEVENT.EQ.1) THEN                ! print title
        IF(IGENPAR(1).LE.7) THEN 
          PRINT 2121,IGENPAR(1),T212(IGENPAR(1)),IGENPAR(2),IGENPAR(3),
     &    ECM,T2121(IGENPAR(4)+1)  
        ELSE
          PRINT 2122,IGENPAR(1),T212(IGENPAR(1)),IGENPAR(2),IGENPAR(3),
     &    ECM,T2122(IGENPAR(4)+1) 
        END IF
c
        IF(IGENPAR(2).EQ.1) CALL PHOINI      ! initialization of PHOTOS 
c
      END IF      
c
      NTRACK=0
c
 2120 CONTINUE
c
      CALL LU1ENT(-1,KF0,ECM,0.,0.)   ! add J/psi or psi(2S) to event record
c
      IF(IGENPAR(4).EQ.0) THEN                                     ! 21.05.2013
        MSTJ(24)=0     ! /LUDAT1/ switch off broadering of J/psi, psi(2S)
        MSTU(10)=1     ! /LUDAT1/ use mass from P(1,5)
        P(1,5)=ECM     ! mass in /LUJETS/ 
      END IF
c
      CALL LUEXEC              ! fragmetation and decay chain
c
      NUND=0	               ! number of undecayed particles
c
      DO I=1,N
        KS=K(I,1)              ! status of particle
        IF(KS.GT.0.AND.KS.LT.5) NUND=NUND+1
      END DO
c
      IF(NUND.NE.2) GOTO 2120  ! should be 2 stable part. (without FSR)
c
c  Now only 2 particles in final state 
c
      DO I=1,N
        KS=K(I,1)            ! status
        KF=K(I,2)            ! type of particle
c
        IF(KS.GT.0.AND.KS.LT.5) THEN
          ITYPE=KGFROMKF(KF) ! Geant-type from kf-type of particle
c
          IF(ITYPE.EQ.0) THEN
            PRINT *, ' Gen.212: unknown type of particle', K(I,2)
            STOP
          END IF
c
          IF(IGENPAR(1).EQ.1.AND.IABS(KF).NE.11)   GOTO 2120 ! J/psi
          IF(IGENPAR(1).EQ.2.AND.IABS(KF).NE.13)   GOTO 2120
          IF(IGENPAR(1).EQ.3.AND.IABS(KF).NE.211)  GOTO 2120
          IF(IGENPAR(1).EQ.4.AND.IABS(KF).NE.321)  GOTO 2120
          IF(IGENPAR(1).EQ.5.AND.IABS(KF).NE.2212) GOTO 2120
          IF(IGENPAR(1).EQ.6.AND.IABS(KF).NE.2112) GOTO 2120
          IF(IGENPAR(1).EQ.7.AND.IABS(KF).NE.11)   GOTO 2120
c
          IF(IGENPAR(1).EQ.11.AND.IABS(KF).NE.11)   GOTO 2120 ! psi'
          IF(IGENPAR(1).EQ.12.AND.IABS(KF).NE.13)   GOTO 2120
          IF(IGENPAR(1).EQ.13.AND.IABS(KF).NE.211)  GOTO 2120
          IF(IGENPAR(1).EQ.14.AND.IABS(KF).NE.321)  GOTO 2120
          IF(IGENPAR(1).EQ.15.AND.IABS(KF).NE.2212) GOTO 2120
          IF(IGENPAR(1).EQ.16.AND.IABS(KF).NE.2112) GOTO 2120
          IF(IGENPAR(1).EQ.17.AND.IABS(KF).NE.11)   GOTO 2120
        END IF
c
      END DO

c========== test print of /LUJETS/  ========================================================

c      print *,' Test print of /LUJETS/:'
c      print *,' N=',N
c      print 987,K(1,1),K(1,2),K(1,3),K(1,4),K(1,5)
c      print 988,K(2,1),K(2,2),K(2,3),K(2,4),K(2,5)      
c      print 989,K(3,1),K(3,2),K(3,3),K(3,4),K(3,5)
c987   format(' K(1,1-5)=',5I8)
c988   format(' K(2,1-5)=',5I8)
c989   format(' K(3,1-5)=',5I8)
c      print 887,K(1,2),P(1,1),P(1,2),P(1,3),P(1,4),P(1,5) 
c      print 888,K(2,2),P(2,1),P(2,2),P(2,3),P(2,4),P(2,5) 
c      print 889,P(3,1),P(3,2),P(3,3),P(3,4),P(3,5) 
887   format('K(1,2)=',I4,' P(1,1-5)=',5F8.4)
888   format('K(2,2)=',I4,' P(2,1-5)=',5F8.4)
c889   format(' P(3,1-5)=',5F8.4)

c========================================================================
c
c    Correction of parameters for modes DEC=7 or 17 (e mu)
c
      IF(IGENPAR(1).EQ.7.OR.IGENPAR(1).EQ.17) THEN 

        DO I=1,N
          KS=K(I,1)            ! status
c
          IF(KS.GT.0.AND.KS.LT.5) THEN
            R=SQRT(EACT**2-0.1056584**2)             ! abs. mom.
            PHI=SQRT(P(I,1)**2+P(I,2)**2+P(I,3)**2)
            P(I,1)=P(I,1)*R/PHI
            P(I,2)=P(I,2)*R/PHI               ! 1-st particle: e->mu
            P(I,3)=P(I,3)*R/PHI
c            
            IF(K(I,2).EQ.11)  K(I,2)=13       ! type of particle
            IF(K(I,2).EQ.-11) K(I,2)=-13
            P(I,5)=0.1056584
            GOTO 2124
          END IF
c
        END DO
c
      END IF
c
 2124 CONTINUE
c 
      IF(IGENPAR(3).EQ.0) GOTO 2123                 ! isotr. angular distr. 
c
c  Simulation of ang. dist.
c
      PHI=ATAN2(P(2,2),P(2,1))                      ! angle fi
      THETA=ATAN(SQRT(P(2,1)**2+P(2,2)**2)/P(2,3))  ! ange theta
c
c  Simulation of angular distribution since in jetset7.4 it is isotropic
c  
      IF(IGENPAR(1).EQ.3.OR.IGENPAR(1).EQ.4.OR.     ! pi+, pi-, K+, K- :     
     &  IGENPAR(1).EQ.13.OR.IGENPAR(1).EQ.14) THEN  ! ds/do ~ sin(theta)**2
        IF (SIN(THETA)**2.LT.RLU(0)) GOTO 2120      ! 
      END IF
c                                                       
      IF(IGENPAR(1).LT.3.OR.IGENPAR(1).GT.14.OR.     ! fermions, spin 1/2
     &  (IGENPAR(1).GT.4.AND.IGENPAR(1).LT.13)) THEN ! e,mu,p,pbar,n,nbar
c
        IF(IGENPAR(3).EQ.2) THEN                     ! ds/do ~ sin(theta)**2
          IF(SIN(THETA)**2.LT.RLU(0)) GOTO 2120
        END IF
c                                                       
        IF (1.+COS(THETA)**2.LT.2.*RLU(0)) GOTO 2120 ! ds/do ~ 1+cos^2(teta)
c
      END IF
c
 2123 CONTINUE 
c      CALL LUROBO(THETA,PHI,0.,0.,0.)
c
      IF(IGENPAR(2).EQ.1) THEN  ! switch on FSR with PHOTOS
c
        CALL LUHEPC(1)          ! Conversion from JETSET to /HEPEVT/ standard   
c
        NEVHEP=IEVENT
c
c        CALL PHODMP             ! Write event record before emission...
c
        CALL PHOTOS(1)        ! Generate photon(s)...
c
c        PRINT 9050            ! Write event record...
c        PRINT 9040
c
c        CALL PHODMP           ! Write event record after emission...
c
c        PRINT 9000
c        PRINT 9010
c        PRINT 9020
c        PRINT 9030
c        PRINT 9020
c        PRINT 9010
 9000 FORMAT(1H1)
 9010 FORMAT(1H ,80('*'))
 9020 FORMAT(1H ,'*',78X,'*')
 9030 FORMAT(1H ,'**** PHOTOS Test Run has successfully ended',32X,
     &' ****')
 9040 FORMAT(1H ,26X,'=== after PHOTOS: ===')
 9050 FORMAT(1H0,80('='))
c
        CALL LUHEPC(2)       ! Conversion from /HEPEVT/ to JETSET standard
c
      END IF
c
      DO I=1,N
        KS=K(I,1)            ! status
        KF=K(I,2)            ! type of particle
c
        IF(KS.GT.0.AND.KS.LT.5) THEN
          ITYPE=KGFROMKF(KF) ! Geant-type from kf-type of particle
          PLAB(1)=P(I,1)
          PLAB(2)=P(I,2)
          PLAB(3)=P(I,3)
          NTRACK=NTRACK+1
          IPARTICLE(NTRACK)=ITYPE
          EPART(NTRACK)=P(I,4)
          PXPART(NTRACK)=P(I,1)
          PYPART(NTRACK)=P(I,2)
          PZPART(NTRACK)=P(I,3)
c
        END IF
c
      END DO
c
      GOTO 500
c
c-----------------------------------------------------------------------
c
 213  CONTINUE
c
c  KGEN=213: e+ e- -> J/psi(psi') -> e+e- (interference) only the part,
c            which has angular distribution
 
c    ds       [1+cos(theta)]^2
c    --   ~  ----------------
c    do       [1-cos(theta)] 
c
c         + r.c. in final state with help of PHITOS
c
c  GENE 213 Theta_min FSR     - card of job 
c
c  Theta_min - minimal angle
c  FSR=1.: inclusion of FSR by 1 or 2 photons with means PHOTOS

c  Initialization of parameters of generator
c
      TMIN=GENPAR(1)*PI/180. ! Tmin - theta_min in radians
      IFSR=IGENPAR(2)        ! key for Final State Radiation inclusion
c
      IF(TMIN.LE.0.OR.TMIN.GE.PI) THEN                  ! Test of Theta_min
        PRINT *, ' Generator 213:  Theta_min=',TMIN*180/PI,
     &           ', but should be between 0 and 180'
        STOP
      END IF
c
      KF0=443                            ! J/psi
      IF(IGENPAR(3).EQ.1) KF0 = 30443    ! psi'
      KC=LUCOMP(KF0)
      ECM=PMAS(KC,1)                     ! mass of J/psi (psi')
      EACT=ECM/2                         ! actual beam energy in cms
c
      IF(IEVENT.EQ.1) THEN
        IF(KF0.EQ.443) PRINT 2131,GENPAR(1),IFSR,ECM,T2121(IGENPAR(4)+1) !J/psi
        IF(KF0.EQ.30443) PRINT 2132,GENPAR(1),IFSR,ECM,T2122(IGENPAR(4)+1)!psi'
c
        IF(IFSR.EQ.1) CALL PHOINI        ! initialization of PHOTOS
c
      END IF      
c
      NTRACK=0
c
 2130 CONTINUE
c
      CALL LU1ENT(-1,KF0,ECM,0.,0.)      ! add J/psi to event record
c
      IF(IGENPAR(4).EQ.0) THEN           ! 29.05.2013
        MSTJ(24)=0     ! /LUDAT1/ exclude widering of J/psi, psi(2S)
        MSTU(10)=1     ! /LUDAT1/ use mass from P(1,5)
        P(1,5)=ECM     ! mass in /LUJETS/
      END IF
c
      CALL LUEXEC                        ! fragmetation and decay chain
c
      NUND=0                             ! number of undecayed particles
c
      DO I=1,N
        KS=K(I,1)                        ! status of particle
        IF(KS.GT.0.AND.KS.LT.5) NUND=NUND+1
      END DO
c
      IF(NUND.NE.2) GOTO 2130  ! should be 2 stable part. (without f.s.r.c.)
c
c  Now only 2 stable particles in final state
c
      DO I=1,N
        KS=K(I,1)            ! status
        KF=K(I,2)            ! type of particle
c
        IF(KS.GT.0.AND.KS.LT.5) THEN
          ITYPE=KGFROMKF(KF) ! Geant-type from kf-type of particle
c
          IF(ITYPE.EQ.0) THEN
            PRINT *, ' Gen.213: unknown type of particle', K(I,2)
            STOP
          END IF
c
          IF(IABS(KF).NE.11) GOTO 2130 ! select only e+-
        END IF
c
      END DO
c
c  Simulation of angular distribution for e- (in jetset7.4 it is isotropic)
c
      THETA=ATAN(SQRT(P(2,1)**2+P(2,2)**2)/P(2,3)) ! theta(e-): from +Z-direct.  
      IF(K(2,2).EQ.-11) THETA=ATAN(SQRT(P(3,1)**2+P(3,2)**2)/P(3,3))
      IF(THETA.LT.0.) THETA=PI+THETA
      IF(THETA.LT.TMIN) GOTO 2130
c
      PROB_MAX=4./(1.-COS(TMIN))   !  maximum of distribution over theta
      PROB=PROB_MAX*RLU(0)
      RESULT=(1.+COS(THETA))**2/(1.-COS(THETA))
      IF (RESULT.LT.PROB) GOTO 2130                 ! to new attempt
c
      IF(IFSR.EQ.1) THEN      ! include FSR by means of PHOTOS

        CALL LUHEPC(1)        ! Conversion from JETSET to /HEPEVT/ standard

        NEVHEP=IEVENT

        CALL PHOTOS(1)        ! Generate photon(s)...

        CALL LUHEPC(2)        ! Conversion from /HEPEVT/ to JETSET standard
c
      END IF
c
      DO I=1,N
        KS=K(I,1)               ! status
        KF=K(I,2)               ! type of particle
c
        IF(KS.GT.0.AND.KS.LT.5) THEN
          ITYPE=KGFROMKF(KF)    ! Geant-type from kf-type of particle
c
          IF(ITYPE.EQ.0) THEN
            PRINT *, ' Gen.213: unknown type of particle', K(I,2)
            GOTO 2130           ! to new attempt 
          END IF
c
          PLAB(1)=P(I,1)
          PLAB(2)=P(I,2)
          PLAB(3)=P(I,3)
          NTRACK=NTRACK+1
          IPARTICLE(NTRACK)=ITYPE
          EPART(NTRACK)=P(I,4)   
          PXPART(NTRACK)=P(I,1)  
          PYPART(NTRACK)=P(I,2)  
          PZPART(NTRACK)=P(I,3)  
c
        END IF
c
      END DO
c
      GOTO 500
c
c-----------------------------------------------------------------------
c
 214  CONTINUE   ! J/psi
      IE=1
      MOD=IGENPAR(1)
      GOTO 2141
 215  CONTINUE
      IE=2
      MOD=IGENPAR(1)
      GOTO 2141 
 216  CONTINUE
      EBEAM=GENPAR(1)
c    
 2141 CALL GEN_BES(IE,MOD,EBEAM,GENPAR(2))
c
      NTRACK=0
c
c**********************
      DO I=1,N
        KS=K(I,1)               ! status
        KF=K(I,2)               ! type of particle
c
        IF(KS.EQ.1.OR.KS.EQ.4) THEN

c********************** 
c          print *,' 2: ',I,K(I,1),K(I,2),K(I,3),P(I,1)

          ITYPE=KGFROMKF(KF)    ! Geant-type from kf-type of particle
c
          IF(ITYPE.EQ.0) THEN  
            PRINT *,' Generator ',KGEN,': unknown type of part.', K(I,2)
            STOP
          END IF
c
          PLAB(1)=P(I,1)
          PLAB(2)=P(I,2)
          PLAB(3)=P(I,3)
          NTRACK=NTRACK+1
          IPARTICLE(NTRACK)=ITYPE
          EPART(NTRACK)=P(I,4)   
          PXPART(NTRACK)=P(I,1)  
          PYPART(NTRACK)=P(I,2)  
          PZPART(NTRACK)=P(I,3)  
c
        END IF
c
      END DO
c
      GOTO 500
c
c-----------------------------------------------------------------------
c
 217  CONTINUE                    ! generator LUARLW (Hu Haiming, BES)
      EACT=GENPAR(1)   !  Ebeam (GeV)      
      ECM=2.*EACT      !  CM energy 
      KFL0=0           !  q0-q0bar flavor: 0 - all flavors
      ISR=IGENPAR(2)   !  Initial state radiation
      ITHEVENT=IEVENT  !  Current event sequence number
      NTE=NEVENT       !  Number of events to be processed
      IF(IEVENT.EQ.1) PRINT 2171,EACT,ISR
c
      CALL GEN_LUARLW(KFL0,ISR,ITHEVENT,ECM,NTE,NDAUG,KFL,KML,PXL,PYL,
     &                PZL,EL)
c
c-----------------------------------------------------------------------
c
c  ECM : the CM energy of e+e- beams
c  KF(I_DAUG), KM(I_DAUG), PX, PY, PZ, E - for I_th daugther: KF-type,
c  mother and vector of 4-momentum 
c
c-----------------------------------------------------------------------
c
      NTRACK=0
c
      DO I=1,NDAUG
        ITYPE=KGFROMKF(KFL(I))    ! Geant-type from kf-type of particle
c
        IF(ITYPE.EQ.0) THEN
          PRINT *,' Generator ',KGEN,': unknown type of part.', KFL(I)
          STOP
        END IF
c
        PLAB(1)=PXL(I)
        PLAB(2)=PYL(I)
        PLAB(3)=PZL(I)
        NTRACK=NTRACK+1
        IPARTICLE(NTRACK)=ITYPE
        EPART(NTRACK)=EL(I)
        PXPART(NTRACK)=PXL(I)
        PYPART(NTRACK)=PYL(I)
        PZPART(NTRACK)=PZL(I)
c
      END DO
c
 500  CONTINUE
 2051 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 205 (on base of Jetset 7.4): e+e- -> q anti-q',//,
     +  ' Ebeam =',F8.4,' GeV',/,
     +  ' Nf =',I2,/,
     +  ' Initial state radiation =',I2,//,
     +  1x,60(1H*),/)
 2061 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 206 (on base of Jetset 7.4): e+e- -> ggg',//,
     +  ' Ebeam =',F8.4,' GeV',/,
     +  ' N =',I2,//,
     +  1x,60(1H*),/)
 2101 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 210 (on base of Jetset 7.4): J/psi -> all',//,
     +  ' Ecms =',F8.4,' GeV',//,
     +  1x,60(1H*),/)
 2102 FORMAT(/,1x,60(1H*),//,
     + ' Generator # 210 (on base of Jetset 7.4): J/psi -> rndmflav',//,
     +  ' Ecms =',F8.4,' GeV',//,
     +  1x,60(1H*),/)
 2111 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 211 (on base of Jetset 7.4)',//,
     +  ' Ecms =',F8.4,' GeV',/,1X,A7,'-> ',A19,//,   
     +         1x,60(1H*),/)
 2121 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 212 (on base of Jetset 7.4)',//,
     &  ' Dec=',I2,': J/psi -> ',A8,/,
     &   ' Final state radiation =',I2,/,
     &   ' Angular distribution =',I2,/,
     &   ' Ecm=',F8.4,' GeV',/,
     &   ' Width of J/psi =',A4,' MeV',//, 
     +  1x,60(1H*),/)
 2122 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 212 (on base of Jetset 7.4)',//,
     &  ' Dec=',I2,': psi(2S) -> ',A8,/, 
     &   ' Final state radiation =',I2,/,
     &   ' Angular distribution =',I2,/, 
     &   ' Ecm =',F8.4,' GeV',/,
     &   ' Width of psi(2S) =',A4,' MeV',//,
     +  1x,60(1H*),/)
 2131 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 213 (on base of Jetset 7.4)',//,
     &  ' e+e- -> J/psi -> e+e- (interference)',/,
     &  ' Minimum angle theta =',F6.2,' Deg',/,
     &   ' Final state radiation =',I2,/,
     &   ' Ecm=',F8.4,' GeV',/,
     &   ' Width of J/psi =',A4,' MeV',//,  
     +  1x,60(1H*),/)
 2132 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 213 (on base of Jetset 7.4)',//,
     &  ' e+e- -> psi(2S) -> e+e- (interference)',/,
     &  ' Minimum angle theta =',F6.2,' Deg',/,
     &   ' Final state radiation =',I2,/,
     &   ' Ecm=',F8.4,' GeV',/,
     &   ' Width of psi(2S) =',A4,' MeV',//,  
     +  1x,60(1H*),/)
 2811 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 281 (on base of Jetset 7.4):',
     &  ' e+e- -> QQ -> one gamma',//,
     +  ' Ebeam =',F8.4,' GeV',//,
     +  1x,60(1H*),/)
 2821 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 282 (on base of Jetset 7.4):',
     &  ' e+e- -> QQ -> one charged pi',//,
     +  ' Ebeam =',F8.4,' GeV',//,
     +  1x,60(1H*),/)
 2831 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 283 (on base of Jetset 7.4):',
     &  ' e+e- -> QQ -> only gammas',//,
     +  ' Ebeam =',F8.4,' GeV',//,
     +  1x,60(1H*),/)
 2841 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 284 (on base of Jetset 7.4):',
     &  ' e+e- -> QQ -> only charged pions',//,
     +  ' Ebeam =',F8.4,' GeV',//,
     +  1x,60(1H*),/)
 2171 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 217 (LUARLW, on base of Jetset 7.4):',
     &  ' e+e- -> coninuum',//,
     +  ' Ebeam =',F8.4,' GeV',/,
     +  ' Initial state radiation =',I2,//,
     +  1x,60(1H*),/)
c
      END
