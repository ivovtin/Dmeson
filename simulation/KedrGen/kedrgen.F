c       Random number generator for RadCor
	double precision function frand(par)
	real par
	double precision r

c	print *,'FunRand called'

	call rm48(r,1)
	frand = r

	end
c
      SUBROUTINE KEDRGEN(KGEN0,EACT,VERG)
c***********************************************************************
c
c   Main subroutine for generation of primary tracks kinematics
c   instead of GUKINE of early version of simulation.
c
c   KEDRGEN is called from GUKINE (package KedrSim)
c
c   Input:  KGEN0 - initial value of KGEN
c
c   Output: EACT - actual energy (GeV) of beam in c.m.s. EACT=0 - special
c           VERG(3) - vertex from generators
c
c   Last changes: see file  A_history
c
c***********************************************************************
      Implicit NONE
c
      Integer *4 IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN,
     &           IEOTRI,IEVENT,ISWIT,IFINIT,NEVENT,NRNDM
      COMMON/GCFLAG/IDEBUG,IDEMIN,IDEMAX,ITEST,IDRUN,IDEVT,IEORUN
     +        ,IEOTRI,IEVENT,ISWIT(10),IFINIT(20),NEVENT,NRNDM(2)

c#include "gcflag.inc"  /* ievent,nevent*/

       Real *4 PI,TWOPI,PIBY2,DEGRAD,RADDEG,CLIGHT,BIG,EMASS
       COMMON/GCONST/PI,TWOPI,PIBY2,DEGRAD,RADDEG,CLIGHT,BIG,EMASS
c#include "gconst.inc"  /* pi,twopi,...*/

      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)
c#include "lujets.inc"  /*  N,K(4000,5),P(4000,5),V(4000,5)*/

      Real *4 PKINE,AMASS,CHARGE,TLIFE,VERT,PVERT
      Integer *4 IKINE,ITRA,ISTAK,IVERT,IPART,ITRTYP,NAPART,IPAOLD
      COMMON/GCKINE/IKINE,PKINE(10),ITRA,ISTAK,IVERT,IPART,ITRTYP
     +      ,NAPART(5),AMASS,CHARGE,TLIFE,VERT(3),PVERT(4),IPAOLD
c#include "gckine.inc"     /* ikine,pkine(10),...*/

      Real*4 PCMEL,PCMPO,PCMGA                   ! for Bukin's Bhabha gen.
      Integer *4 NQUA
      COMMON /EEG/NQUA,PCMEL(3),PCMPO(3),PCMGA(3)
      Real *8 QPULST,QE2TOT,SLUM
      COMMON /EEGCOM/   QPULST(3),QE2TOT,SLUM

c#include "../KedrSim/pkin.inc"

      Real *4 EPART,PXPART,PYPART,PZPART
      Integer *4 NTRACK,IPARTICLE
      COMMON /PKIN/    NTRACK,IPARTICLE(50),EPART(50),    ! - for output file
     +                 PXPART(50),PYPART(50),PZPART(50)

      Real *4 Sigma_X, Sigma_Y, Sigma_Z,Beam_Theta, Beam_Phi
      Integer *4 Sigbeam_flag
      COMMON /Beam_sigma/ Sigbeam_flag, Sigma_X, Sigma_Y, Sigma_Z,
     +      Beam_Theta, Beam_Phi

      Real *4 VER,VERTEX
      COMMON /VER_EVENT/VER(3),VERTEX(3)      ! center of int. area from data
                                              ! real vertex
      Real *4    mu_resolution, mu_efficiency
      Integer *4 mu_debug, mu_write
      COMMON /MU_PAR/ mu_resolution, mu_efficiency, mu_write, mu_debug

      Real *4 FIEL, FIEAN
      COMMON /FIEL/ FIEL, FIEAN

      Real *8 QQ
      Integer *4 ISORT,NPRT,IERPR
      COMMON /S1PRT/    QQ(5,10),ISORT(10),NPRT,IERPR ! Eidelman's generators

      Real *4 pmas,parf,vckm
      Integer *4 kchg
      COMMON /LUDAT2/   kchg(500,3),pmas(500,4),parf(2000),vckm(4,4)

      Real *4 BRAT
      Integer *4 MDCY,MDME,KFDP
      COMMON /LUDAT3/   MDCY(500,3),MDME(2000,2),BRAT(2000),KFDP(2000,5)

      Real *4 GENPAR
      Integer *4 KHEP,KGEN
      COMMON /KEDR_GEN/ KHEP,KGEN,GENPAR(20)  ! parameters for generators

      Integer *4 NPIND,INDP
      COMMON /PSPIND/   NPIND,INDP(600)       ! GEANT -> HEP codes

      Real *4 BDEC
      Integer *4 NDEC,KDEC,MDEC
      COMMON /PSDEC/    NDEC,KDEC(3,100),MDEC(1000),BDEC(1000) ! PST decays

      Real *8 pPart,mPart
      Integer *4 KfTyp,IParent,IChilds,NPS
      COMMON /PSEVT/ pPart(4,100),mPart(100),KfTyp(100),
     &               IParent(100),IChilds(2,100),NPS

      Integer *4 KSIFL
      COMMON /KSI/ KSIFL                       ! for interactive Geant

      Integer *4 IGENRNG,ISKIP
      COMMON /GEN_RNG/  IGENRNG,ISKIP          ! flag for RNG for generators

      Real *4 RRLU
      Integer *4 MRLU
      COMMON /LUDATR/   MRLU(6),RRLU(100)

c      Real *4 Wtot,Wmin,dWtot,x,phi,theta         ! for gen 60
      REAL Mpsi3770,Wtot,Wmin,dWtot,x,phi,theta         ! for gen 60
      real dnpp

      INTEGER NMXHEP
      PARAMETER (NMXHEP=2000)
      COMMON /HEPEVT/             ! for PHOTOS
     $      nevhep,               ! serial number
     $      nhep,                 ! number of particles
     $      isthep(nmxhep),       ! status code
     $      idhep(nmxhep),        ! particle ident KF
     $      jmohep(2,nmxhep),     ! parent particles
     $      jdahep(2,nmxhep),     ! childreen particles
     $      phep(5,nmxhep),       ! four-momentum, mass [GeV]
     $      vhep(4,nmxhep)        ! vertex [mm]
      REAL*8  phep,  vhep         ! to be real*4 / *8  depending on host
      INTEGER nevhep,nhep,isthep,idhep,jmohep, jdahep

      COMMON /rcordt/             ! Cross section for RadCor
     +	     rccs0(1000),rcben(1000),rcndt
      double precision rccs0, rcben
      integer rcndt
      save /rcordt/
      external frand
      Real *4 rcfen,rcfth,rcffi

      Real *4 PLAB(3),UB(20),PSTO(4),PPMIN,PPMAX,SECGG102
      Real *4 amass_mu,charge_mu,tlife_mu,PLBX
      Real *4 SECMM102,B102,A102,SECEE102,X102,PLL,ANG,EN,VERX
      Real *4 TET,CTET,PPP,PMU,GRX,RLU,ECOSM1,ECOSM2,RA,AL,CHPAR
      Real *4 PEL,PPO,PG,TE_MINM,EG_MINM,pamass,pcharge,ptlife
      Real *4 CTET1,CTET2,R,PP,PSTMASS,PSTWIDTH,PSTCHRG,PSTSPIN,PSTCTAU
      Real *4 TH,PH,EACT,VERG(3)
      Integer *4 IGENPAR(20),KF,IMOD,KS,KODHEP,nwb,JJ
      Integer *4 ITYPE,IHEP,itrtype,J,KFFROMKG,LUCOMP
      Integer *4 I,KGEN0,IPRTRK
      Character *21 NAMPART
      Character *12 ANAME
      Character *9 NAM2P(8),NAM3PI(2)
      Character *20 CHNPAR
c
      SAVE
c
      DATA  Mpsi3770/3.7735/                     ! for gen 60
      DATA QPULST/3*0./                         ! for gen. 51
      DATA NAM2P/' e+ e-    ',' 2 gamma  ',' mu+ mu-  ',' pi+ pi-  ', ! for
     +           ' K+ K-    ',' KL KS    ',' eta gamma',' pi0 gamma'/ ! gen.102
      DATA NAM3PI/' rho pi  ','3pi ph.s.'/
c

      IF(KSIFL.EQ.1) THEN                ! for interactive Geant
        KGEN=IKINE
c
        DO I=1,10
          GENPAR(I)=PKINE(I)
        END DO
c
      END IF
c
      DO I=1,20
        IGENPAR(I)=GENPAR(I)
      END DO
c
      DO I=1,3
        VERG(I)=0. ! def. vertex from generator
      END DO
c
c     Determination of process for simulation from GENE (IKINE) card
c     ==============================================================
c
      IF (KGEN.EQ.1) GOTO 1   ! single particle,  parameters GENPAR(1-6)
      IF (KGEN.EQ.2) GOTO 2   ! generator of user, GENPAR(1-20)
      IF (KGEN.EQ.3) GOTO 3   ! single particle,  parameters GENPAR(1-7)
      IF (KGEN.EQ.51) GOTO 51 ! e+e- -> e+e- (gamma), Bukin
      IF (KGEN.EQ.52) GOTO 52 ! cosmic muons with energy spectrum (obsolete)
      IF (KGEN.EQ.53) GOTO 53 ! cosmic muons (E.M.Baldin)
      IF (KGEN.EQ.60) GOTO 60 ! e+e- -> psi''->D+D-,D0 D0~ (A. Shamov)
      IF (KGEN.EQ.70) GOTO 70 ! e+e- -> psi''->D+D-,D0 D0~ (A. Shamov)
      IF (KGEN.GE.102.AND.KGEN.LE.103) GOTO 1000 ! Eidelman's cods
c
c
c-- KGEN=201-300: generators,  V.A.Tayursky, Yu.I.Skovpen -----------
c
      if(KGEN.GE.201.AND.KGEN.LE.300) then
c
        CALL KEDRGEN1(EACT)
c
        KGEN=KGEN0                    ! returns initial value
        GOTO 2000
      END IF
c
c-- KGEN=301-400: generators of V.A.Tayursky ---------------------------
c
      IF(KGEN.GE.301.AND.KGEN.LE.400) THEN
c
        CALL KEDRGEN2(EACT,VERG)      ! VERG - vertex from generators
c
        KGEN=KGEN0                    ! returns initial value
 	GOTO 2000
      END IF
c
      PRINT *,' Wrong generator number! See the KEDR WWW page '
      RETURN
c
c=======================================================================
c
c Generator # 1 (KGEN=1) - particle type GENPAR(1), parameters from GENPAR(2-6)
c
 1    CONTINUE
c
      EACT=0.
      ITYPE = GENPAR(1)+0.5  ! GEANT particle type: is it in /PSPIND/ ?
c
      IF(ITYPE.LT.0.OR.(ITYPE.GT.33.AND.ITYPE.LT.44).OR.ITYPE.GT.NPIND)
     + THEN
        print *,' '
        print *,' Error in generator # 1: wrong particle type = ',itype
        print *,' '
        stop
      END IF
c
      IHEP=KFFROMKG(ITYPE)    ! HEP(Lund)-type of particle from GEANT one
c
      CALL PstPPar(IHEP,ANAME,PSTMASS,PSTWIDTH,PSTCHRG,PSTSPIN,PSTCTAU) ! par
c
      IF(IEVENT.EQ.1) PRINT 105,GENPAR(1),ANAME,(GENPAR(j),j=2,6)
      PP=GENPAR(2)           ! particle momentum GeV/c
c
      IF(PP.LE.0.) THEN
        print *,' '
        print *,' Error in generator # 1: Momentum should be > 0'
        print *,' '
       STOP
      END IF
c
      R=RLU(0)
c
      CTET1=COS(GENPAR(3)*DEGRAD)
      CTET2=COS(GENPAR(4)*DEGRAD)
      CTET=CTET1+(CTET2-CTET1)*R
      TET=ACOS(CTET)
c
      R=RLU(0)
c
      PHI=(GENPAR(5)+(GENPAR(6)-GENPAR(5))*R)*DEGRAD
      PLAB(1)=PP*SIN(TET)*COS(PHI)
      PLAB(2)=PP*SIN(TET)*SIN(PHI)
      PLAB(3)=PP*COS(TET)
c
      CALL GFPART(itype,nampart,itrtype,pamass,pcharge,ptlife,ub,nwb)
c
      IF(NDEC.EQ.0) GOTO 501          ! to GEANT without decays with PST
c
c  There are PST-decays in /PSDEC/
c
      NPS=0                           ! to fill /PSEVT/ from the beginning
c
c  Parameters of decaying particle
c
      KF=INDP(ITYPE)                  ! KF-code of particle
c
      DO J=1,NDEC                     ! are there decays for this particle
        JJ=0                          ! in /PSDEC/?
        IF(KF.EQ.KDEC(1,J)) THEN
          JJ=J
        END IF
      END DO
c
      IF(JJ.EQ.0) GOTO 501            ! to GEANT without decays with PST
c
      PSTO(1)=PLAB(1)                 ! Px
      PSTO(2)=PLAB(2)                 ! Py
      PSTO(3)=PLAB(3)                 ! Pz
      PSTO(4)=SQRT(PP**2+PAMASS**2)   ! Energy
c
      CALL PstStore(KF,0,0,0,PSTO)   ! store initial particle in /PSEVT/
c
      CALL PstDec(1)                 ! simulation of chain of its decays
c
      NTRACK=0
c
      DO 502 I=1,NPS
        IF(KfTyp(I).NE.0) goto 502  ! should be last daughter of int.res.
        ITYPE=0
        KODHEP=KfTyp(I)
c
        CALL PstPCode1(KODHEP,ITYPE)  ! KF code -> GEANT code
c
 	IF(ITYPE.EQ.0) THEN
          print *,' KEDRGEN: for generator # 1 unknown type of particle',
     +	  KfTyp(I)
 	  STOP
        END IF
c
        NTRACK=NTRACK+1
        IPARTICLE(NTRACK)=ITYPE
        EPART(NTRACK)=Ppart(4,I)
        PXPART(NTRACK)=PLAB(1)
        PYPART(NTRACK)=PLAB(2)
        PZPART(NTRACK)=PLAB(3)
c
 502  CONTINUE
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000
c
 501  CONTINUE
c
      NTRACK=0
      NTRACK=NTRACK+1
      IPARTICLE(NTRACK)=itype
      EPART(NTRACK)=SQRT(PP**2+PAMASS**2)
      PXPART(NTRACK)=PLAB(1)
      PYPART(NTRACK)=PLAB(2)
      PZPART(NTRACK)=PLAB(3)
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000
c
c---------------------------------------------------------------
c
c  Generator of user (#2)
c
 2    CALL GEN_USERA(VERTEX,IPRTRK)
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000

c==============================================================================
c
c  Generator # 3 - particle type GENPAR(1), parameters from GENPAR(2-7)
c
 3    CONTINUE
c
      EACT=0.
      ITYPE = GENPAR(1)+0.5  ! GEANT particle type: is it in /PSPIND/ ?
      IF(ITYPE.LT.0.OR.(ITYPE.GT.33.AND.ITYPE.LT.44).OR.ITYPE.GT.NPIND)
     + THEN
        print *,' '
        print *,' Error in generator # 3: wrong particle type = ',itype
        print *,' '
        stop
      END IF
c
      IHEP=KFFROMKG(ITYPE)    ! HEP(Lund)-type of particle from GEANT one
c
      CALL PstPPar(IHEP,ANAME,PSTMASS,PSTWIDTH,PSTCHRG,PSTSPIN,PSTCTAU) ! par
c
      IF(IEVENT.EQ.1) PRINT 108,GENPAR(1),ANAME,(GENPAR(j),j=2,7)
      PPMIN=GENPAR(2)           ! particle min momentum GeV/c
      PPMAX=GENPAR(3)           ! particle max momentum GeV/c
c
      IF(PPMIN.LE.0.OR.PPMAX.LE.0.OR.PPMIN.gt.PPMAX) THEN
        print *,' '
        print *,' Error in generator # 3: Momentum incorrect '
        print *,' '
       STOP
      END IF
c
      R=RLU(0)
      PP=PPMIN+(PPMAX-PPMIN)*R
c
      R=RLU(0)
c
      CTET1=COS(GENPAR(4)*DEGRAD)
      CTET2=COS(GENPAR(5)*DEGRAD)
      CTET=CTET1+(CTET2-CTET1)*R
      TET=ACOS(CTET)
c
      R=RLU(0)
c
      PHI=(GENPAR(6)+(GENPAR(7)-GENPAR(6))*R)*DEGRAD
      PLAB(1)=PP*SIN(TET)*COS(PHI)
      PLAB(2)=PP*SIN(TET)*SIN(PHI)
      PLAB(3)=PP*COS(TET)
c
      CALL GFPART(itype,nampart,itrtype,pamass,pcharge,ptlife,ub,nwb)
c
      IF(NDEC.EQ.0) GOTO 3501          ! to GEANT without decays with PST
c
c  There are PST-decays in /PSDEC/
c
      NPS=0                           ! to fill /PSEVT/ from the beginning
c
c  Parameters of decaying particle
c
      KF=INDP(ITYPE)                  ! KF-code of particle
c
      DO J=1,NDEC                     ! are there decays for this particle
        JJ=0                          ! in /PSDEC/?
        IF(KF.EQ.KDEC(1,J)) THEN
          JJ=J
        END IF
      END DO
c
      IF(JJ.EQ.0) GOTO 3501           ! to GEANT without decays with PST
c
      PSTO(1)=PLAB(1)                 ! Px
      PSTO(2)=PLAB(2)                 ! Py
      PSTO(3)=PLAB(3)                 ! Pz
      PSTO(4)=SQRT(PP**2+PAMASS**2)   ! Energy
c
      CALL PstStore(KF,0,0,0,PSTO)   ! store initial particle in /PSEVT/
c
      CALL PstDec(1)                 ! simulation of chain of its decays
c
      NTRACK=0
c
      DO 3502 I=1,NPS
        IF(KfTyp(I).NE.0) goto 3502  ! should be last daughter of int.res.
        ITYPE=0
        KODHEP=KfTyp(I)
c
        CALL PstPCode1(KODHEP,ITYPE)  ! KF code -> GEANT code
c
 	IF(ITYPE.EQ.0) THEN
          print *,' GUKINE: for generator # 3 unknown type of particle',
     +	  KfTyp(I)
 	  STOP
        END IF
c
        NTRACK=NTRACK+1
        IPARTICLE(NTRACK)=ITYPE
        EPART(NTRACK)=pPart(4,I)
        PXPART(NTRACK)=pPart(1,I)
        PYPART(NTRACK)=pPart(2,I)
        PZPART(NTRACK)=pPart(3,I)
c
 3502 CONTINUE
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000
c
 3501 CONTINUE
c
      NTRACK=0
      NTRACK=NTRACK+1
      IPARTICLE(NTRACK)=ITYPE
      EPART(NTRACK)=SQRT(PP**2+PAMASS**2)
      PXPART(NTRACK)=PLAB(1)
      PYPART(NTRACK)=PLAB(2)
      PZPART(NTRACK)=PLAB(3)
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000
c
c---------------------------------------------------------------
c
c*..KGEN=51 - e+e- -> e+e- (gamma), Bukin UM1086
c
 51   CONTINUE
c
      EACT=GENPAR(1)
      QE2TOT = (2*GENPAR(1))*1000. ! total e+ and e- beams energy in MeV
c
c  Parameters for UM1086:
c
c  3 - number of e+e- axis
c  GENPAR(2) - min energy of photon (GeV)
c  GENPAR(3) - min angle of charged particle (deg.)
c  GENPAR(4) - additional factor for majoranta
c
      EG_MINM=GENPAR(2)*1000.
      TE_MINM=GENPAR(3)
c
      CALL GEN_EEG_BUK(3,TE_MINM,EG_MINM,GENPAR(4))
c
      IF(IEVENT.EQ.NEVENT) PRINT 15,SLUM,NEVENT
c
      PEL=SQRT(PCMEL(1)*PCMEL(1)+PCMEL(2)*PCMEL(2)+PCMEL(3)*PCMEL(3))
      PPO=SQRT(PCMPO(1)*PCMPO(1)+PCMPO(2)*PCMPO(2)+PCMPO(3)*PCMPO(3))
      PG =SQRT(PCMGA(1)*PCMGA(1)+PCMGA(2)*PCMGA(2)+PCMGA(3)*PCMGA(3))
c
      NTRACK=0
      NTRACK=NTRACK+1
      IPARTICLE(NTRACK)=3
      EPART(NTRACK)=SQRT(PCMEL(1)**2+PCMEL(2)**2+PCMEL(3)**2+5.11E-4**2)
      PXPART(NTRACK)=PCMEL(1)
      PYPART(NTRACK)=PCMEL(2)
      PZPART(NTRACK)=PCMEL(3)
c
      NTRACK=NTRACK+1
      IPARTICLE(NTRACK)=2
      EPART(NTRACK)=SQRT(PCMPO(1)**2+PCMPO(2)**2+PCMPO(3)**2+5.11E-4**2)
      PXPART(NTRACK)=PCMPO(1)
      PYPART(NTRACK)=PCMPO(2)
      PZPART(NTRACK)=PCMPO(3)
c
      IF (NQUA.EQ.0) GOTO 2000
c
      NTRACK=NTRACK+1
      IPARTICLE(NTRACK)=1
      EPART(NTRACK)=SQRT(PCMGA(1)**2+PCMGA(2)**2+PCMGA(3)**2)
      PXPART(NTRACK)=PCMGA(1)
      PYPART(NTRACK)=PCMGA(2)
      PZPART(NTRACK)=PCMGA(3)
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000
c
c------------------------------------------------------------
c
c*..KGEN=52 - cosmic muons with energy spectrum: obsolete
c
 52   CONTINUE
      IPART=5        ! mu+
      CHPAR=1.
      AL=450.
      RA=350.
      ECOSM1=0.4     ! 1-st boundary in momentum
      ECOSM2=5000.   ! 2-nd boundary in momentum
c
      IF(IEVENT.EQ.1) PRINT 1502
c
      GRX=RLU(0)
c
      IF(GRX.LE.0.5) THEN
c
      GRX=RLU(0)
c
        PMU=ECOSM1*GRX
      ELSE
c
 25     GRX=RLU(0)
c
        PMU=ECOSM1/GRX
        IF(PMU.GT.ECOSM2) GOTO 25
      ENDIF
c
      PPP=PMU
c
      CALL COSRN(RA,AL,VERTEX,TH,PH,PPP,PLAB)
c
      VERX=VERTEX(1)
      VERTEX(1)=VERTEX(2)
      VERTEX(2)=VERX
      PLBX=PLAB(1)
      PLAB(1)=PLAB(2)
      PLAB(2)=PLBX
c
      NTRACK=1
      IPARTICLE(1)=IPART
c
      call gfpart(5,chnpar,itrtyp,amass_mu,charge_mu,tlife_mu,ub,nwb)
c
      EPART(1)=SQRT(PLAB(1)**2+PLAB(2)**2+PLAB(3)**2+AMASS_MU**2)
      PXPART(1)=PLAB(1)
      PYPART(1)=PLAB(2)
      PZPART(1)=PLAB(3)
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000
c
c------------------------------------------------------------------
c
c  Космика (Е.М.Балдин)
c
 53   CALL GEN_COSMICS(IPRTRK)
c
      KGEN=KGEN0                    ! returns initial value
      EACT=0.
      GOTO 2000
c
c------------------------------------------------------------------
c
c  D+ D-, D0 /D0 uniform production
c
 70   CONTINUE
c
c  Input parameters:
c
c  GENPAR(1)   Wtot   -  average energy of collision (GeV)
c  GENPAR(2)   SigmaW - sigma of total energy of collision (Gev)
c
      if(GENPAR(1).ne.0.) then
        Wtot=GENPAR(1)
      else
        Wtot=Mpsi3770
      endif
c
      if(GENPAR(2).ne.0.) then
c  Gauss of Wtot
        dWtot = GENPAR(2)*COS(RLU(0)*TWOPI)*SQRT(-2*ALOG(RLU(0)))
        Wtot  = Wtot + dWtot          ! Total energy with spread
      endif
c
c      if(RLU(0).lt.0.5) then
      if(RLU(0).lt.0.0) then
           kf=411                  ! D+
      else
           kf=421                  ! D0
      endif
c
      Wmin=PMAS(LUCOMP(kf),1)+PMAS(LUCOMP(-kf),1)
      IF(Wtot.lt.Wmin) GOTO 70
      EACT=WTOT/2                  ! actual beam energy in cms
c
      call LU2ENT(1,kf,-kf,Wtot)   ! two D-mesons, 1-st and 2-nd lines
c
c      call LULIST(1)
c
      phi=PI*2.*RLU(0)
c
 71   X=2.*RLU(0)-1.               ! generate x=cos(theta), 1-x^2
c
      if(1-x**2.lt.RLU(0)) goto 71
      theta=acos(x)
c
      call LUROBO(theta,phi,0.,0.,0.)
c
c      call LULIST(1)
c
      call LUEXEC
c
c      CALL LUEDIT(2)    ! to exclude unstable or undetectable partons/particles
c      call LULIST(1)
c
      NTRACK=0
c
      DO I=1,N
        ITYPE=0
        KS=k(i,1)
        KODHEP=K(I,2)
c
        IF(KS.eq.1.or.KS.eq.4) THEN
c
          CALL PstPCode1(KODHEP,ITYPE)     ! KF code -> GEANT code
c
  	  if(ITYPE.EQ.0) then
            write(6,*)' Gen.60: unknown type of particle', k(i,2)
            STOP
          end if
c
          PLAB(1)=P(I,1)
          PLAB(2)=P(I,2)
          PLAB(3)=P(I,3)
c
          NTRACK=NTRACK+1
 	  IPARTICLE(NTRACK)=ITYPE
 	  EPART(NTRACK)=Wtot/2
 	  PXPART(NTRACK)=PLAB(1)
 	  PYPART(NTRACK)=PLAB(2)
 	  PZPART(NTRACK)=PLAB(3)
c
        ENDIF
c
      END DO
c
      KGEN=KGEN0                    ! returns initial value
      GOTO 2000
c
c------------------------------------------------------------------
c
 60   CONTINUE
c
c  Input parameters:
c
c  GENPAR(1)   Wtot   -  average energy of collision (GeV)
c  GENPAR(2)   SigmaW - sigma of total energy of collision (Gev)
c  GENPAR(3)   if 1 or 3 - call PHOTOS (FSR)
c              if 2 or 3 - call RadCor (ISR)
c              if 4      - RadCor with Fadin-Kuraev model
c              if 5      - RadCor with Fadin-Kuraev model (no pair-creation)
c              if 6      - RadCor with Fadin-Kuraev model (no vac. polariz.)
c  GENPAR(4)   Probability of D+D- (the rest is D0D0bar)
c  GENPAR(5)   Photon emission probability variation
c
c	print *,'Initialization modifier generator 60'
c
      if (IEVENT.eq.1) then
        IF(IGENPAR(3).EQ.1.or.IGENPAR(3).ge.3)
     +		CALL PHOINI      ! initialization of PHOTOS
        if(IGENPAR(3).ge.2)      ! initialize RadCor
c     +		call rcini(rccs0,rcben,'/home/ovtin/development/Dmeson/simulation/KedrGen/rccs.dat',rcndt,1000,20,30)
     +		call rcini(rccs0,rcben,'rccs.dat',rcndt,1000,20,30)
        print *,'Photon CS variation=',GENPAR(5)
      endif

      if(GENPAR(1).ne.0.) then
         Wtot=GENPAR(1)
      else
         Wtot=Mpsi3770
      endif

      dnpp = GENPAR(5)

c      print *,'Photon CS variation=',dnpp
c
      if(GENPAR(2).ne.0.) then
c  Gauss of Wtot
      dWtot = GENPAR(2)*COS(RLU(0)*6.283185307)*SQRT(-2*ALOG(RLU(0)))
      Wtot  = Wtot + dWtot          ! Total energy with spread
      endif
c
      if(RLU(0).lt.GENPAR(4)) then
           kf=411              ! D+
      else
           kf=421              ! D0
      endif
c
c     Call RadCor to simulate ISR
      if (IGENPAR(3).ge.2) then
         if (IGENPAR(3).eq.4) then
      	   call RCFTG(frand,0.001,100.,rccs0,rcben,rcndt,Wtot*1000.,
     +              rcfen,rcfth,rcffi,4,dnpp)
         elseif (IGENPAR(3).eq.5) then
      	   call RCFTG(frand,0.001,100.,rccs0,rcben,rcndt,Wtot*1000.,
     +              rcfen,rcfth,rcffi,3,dnpp)
         elseif (IGENPAR(3).eq.6) then
      	   call RCFTG(frand,0.001,100.,rccs0,rcben,rcndt,Wtot*1000.,
     +              rcfen,rcfth,rcffi,-4,dnpp)
         else
      	   call RCFTG(frand,0.001,100.,rccs0,rcben,rcndt,Wtot*1000.,
     +              rcfen,rcfth,rcffi,1,dnpp)
         endif
         Wtot = Wtot - rcfen/1000.  ! Now only simulate energy loss
c         print *,'RadCor: photon energy=',rcfen
c         print *,'RadCor: rcndt=',rcndt
      endif
c
      Wmin=PMAS(LUCOMP(kf),1)+PMAS(LUCOMP(-kf),1)
      if(Wtot.lt.Wmin) goto 60
      EACT=WTOT/2                  ! actual beam energy in cms
c       print *,'Wtot:',Wtot,'  Wmin:',Wmin
c
      call LU2ENT(1,kf,-kf,Wtot)
c      call LULIST(1)
      phi=PI*2.*RLU(0)
c
 61   x=2.*RLU(0)-1.             ! generate x=cos(theta), 1-x^2
c
      if(1-x**2.lt.RLU(0)) goto 61
      theta=acos(x)
c
      call LUROBO(theta,phi,0.,0.,0.)
c
c      call LULIST(1)
c
      call LUEXEC
c
c-------------------------------------------------------
c     PHOTOS call (added by A.Poluektov)
c-------------------------------------------------------
      IF(IGENPAR(3).EQ.1.or.IGENPAR(3).ge.3) THEN    ! FSR with PHOTOS
        CALL LUHEPC(1)        ! Conversion from JETSET to /HEPEVT/ standard
        NEVHEP=IEVENT
c        CALL PHODMP           ! Write event record before emission...
        CALL PHOTOS(1)        ! Generate photon(s)...
c        CALL PHODMP           ! Write event record after emission...
        CALL LUHEPC(2)        ! Conversion from /HEPEVT/ to JETSET standard
      ENDIF
c
c      CALL LUEDIT(2)    ! to exclude unstable or undetectable partons/particles
c      call LULIST(1)
c      CALL GSVERT(VERTEX,0,0,0,0,NVERT)
cc
      NTRACK=0
c
      DO I=1,N
        ITYPE=0
        KS=k(i,1)
        KODHEP=K(I,2)
c
	IF(KS.eq.1.or.KS.eq.4) THEN
c
        CALL PstPCode1(KODHEP,ITYPE)     !KF code -> GEANT code
c
  	IF(ITYPE.EQ.0) THEN
          write(6,*)' Gen.60: unknown type of particle', k(i,2)
          STOP
        END IF
c
        PLAB(1)=P(I,1)
        PLAB(2)=P(I,2)
        PLAB(3)=P(I,3)
c        IF(IPRTRK.EQ.1) PRINT 397,IEVENT,I,ITYPE,PLAB,VERTEX
c
c        CALL GSKINE(PLAB,ITYPE,NVERT,0,0,NT)
c
        NTRACK=NTRACK+1
 	IPARTICLE(NTRACK)=ITYPE
c 	EPART(NTRACK)=EN1
 	EPART(NTRACK)=Wtot/2
 	PXPART(NTRACK)=PLAB(1)
 	PYPART(NTRACK)=PLAB(2)
 	PZPART(NTRACK)=PLAB(3)
c
		endif
      END DO
c
      KGEN=KGEN0                    ! returns initial value
      GOTO 2000
c
c------------------------------------------------------------------
c
c  GENE=102-103 - Eidelman's generators
c
 1000 CONTINUE
c
      EACT=GENPAR(1)   ! actual beam energy in cms
      NPRT=1
      IMOD=IGENPAR(2)  ! generators modes
      EN=2*GENPAR(1)   ! total energy in GeV
      ANG=GENPAR(3)    ! minimal polar angle in deg.
      IF (ANG .GT. 1.E9) ANG=0.
c
c-----------------------------------------------------------------
c
      IF (KGEN.EQ.102) THEN       ! 2 particle generators
c
        IF(IMOD.LT.1.OR.IMOD.GT.8) THEN
          PRINT 1500
          STOP
        END IF
c
        IF(IEVENT.EQ.1) PRINT 1501,NAM2P(IMOD),GENPAR(1),GENPAR(3)
c
c  Parameters:
c
c       IMOD=1: e+ e-
c            2: 2 gamma
c            3: mu+ mu-
c            4: pi+ pi-
c            5: K+ K-
c            6: KL KS
c            7: eta gamma,
c            8: pi0 gamma.
c       EN  - total energy in GeV,
c       ANG - minimal polar angle in deg.
c
        IF(IMOD.EQ.2.AND.ANG.GE.90.) THEN
          PRINT 1507,ANG
          STOP
        END IF
c
        CALL GEN_2PRT(IMOD,EN,ANG)         ! e+e- -> 2 particles
c
      ENDIF
c
c----------------------------------------------------------------
c
      IF (KGEN.EQ.103) THEN                !  e+e- -> 3pi
c
c  Parameters:  IMOD - process number:
c                    =1 - sum of ropi,
c                    =2 - phase space
c               EN   - total energy in GeV
c               ANG  - limiting polar angle in degrees
c
        if(IMOD.LT.1.OR.IMOD.GT.2) then
          PRINT 1503
          STOP
        endif
c
        IF(IEVENT.EQ.1) PRINT 1504,NAM3PI(IMOD),GENPAR(1),GENPAR(3)
c
        CALL GEN_3PRT(IMOD,EN,ANG)   ! e+e- -> 3 pions
c
      ENDIF
c
c----------------------------------------------------------------
c
      IF(IERPR.GT.1) THEN
        PRINT *,' Error in generator 102: ',IERPR
        RETURN
      ENDIF
c
      DO 1025 J=1,NPRT
        IPART = ISORT(J)
        PLL=QQ(4,J)
        PLAB(1)=PLL*QQ(1,J)          ! Components of momentum
        PLAB(2)=PLL*QQ(2,J)
        PLAB(3)=PLL*QQ(3,J)
        PP=SQRT(PLAB(1)**2+PLAB(2)**2+PLAB(3)**2)
c
        NTRACK=J
        IPARTICLE(NTRACK)=IPART
        EPART(NTRACK)=QQ(5,J)
        PXPART(NTRACK)=PLAB(1)
        PYPART(NTRACK)=PLAB(2)
        PZPART(NTRACK)=PLAB(3)
c
 1025 CONTINUE
c
      KGEN=KGEN0                    ! returns initial value
c
c---- End of Eidelman's generators -------------------------
c
 2000 IF(IEVENT.EQ.NEVENT) THEN         ! this is the last event
c
        IF(IABS(KGEN).EQ.102.AND.IMOD.EQ.1) THEN
c
c  Cross-section for e+e- -> e+e-
c
          X102=COS(ANG*PI/180.)
          SECEE102=8.1427E-33/(EN/2)**2*(16.*(1./(1.-X102)-1./(1.+X102))
     &  + 16.*ALOG((1.-X102)/(1.+X102)) + 18.*X102 + 2./3.*X102**3)
          PRINT 1505,SECEE102,NEVENT/SECEE102
        END IF
c
        IF(IABS(KGEN).EQ.102.AND.IMOD.EQ.2) THEN
c
c  Cross-section for e+e- -> gamma gamma
c
          X102=COS(ANG*PI/180.)
          A102=2.*PI*(2.818E-13)**2*(0.511E-3/EN)**2
          B102=2.*(0.511E-3/EN)**2
          SECGG102=A102*(ALOG(((1.+X102)+B102)/((1.-X102)+B102))-X102)
          PRINT 1506,SECGG102,NEVENT/SECGG102
        END IF
c
        IF(IABS(KGEN).EQ.102.AND.IMOD.EQ.3) THEN
c
c  Cross-section for e+e- -> mu+ mu-
c
          X102=COS(ANG*PI/180.)                ! cos of min. angle (1-0)
          A102=PI*(2.818E-13)**2*(0.511E-3/EN)**2
          B102=SQRT(1.-(2*0.105658/EN)**2)
          SECMM102=A102*B102*((2.-B102**2)*X102+1./3.*B102**2*X102**3)
          PRINT 1508,SECMM102,NEVENT/SECMM102
        END IF
c
      END IF
c
 15   FORMAT(/,' UM1086: luminosity integral =',1pe10.3, ' 1/nb,',
     *         I7,' events', /)
 105  FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 1: one particle events simulation',/,
     +  ' ---------------------------------------------',//,
     +        F6.1,' - Geant type of particle ',A12,/,
     +        1pE10.2,' - particle momentum (GeV/c)',/,
     +        2(1pE10.2),' - interval in theta (deg.)',/,
     +        2(1pE10.2),' - interval in phi (deg.)',//,1x,60(1H*),/)
 108  FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 3: one particle events simulation',/,
     +  ' ---------------------------------------------',//,
     +        F6.1,' - Geant type of particle ',A12,/,
     +        2(1pE10.2),' - interval in particle momentum (GeV/c)',/,
     +        2(1pE10.2),' - interval in theta (deg.)',/,
     +        2(1pE10.2),' - interval in phi (deg.)',//,1x,60(1H*),/)
 1500 FORMAT(//,' Error in generator 102: wrong parameter MOD',/)
 1501 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 102: two paricles events simulation',/,
     +  ' -----------------------------------------------',//,
     +  ' Process e+e- ->',A9,//,
     +  1pE10.2,' - beam energy (GeV)',/,
     +  1pE10.2,' - minimal theta (deg.)',//,
     +  1x,60(1H*),/)
 1502 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 52: cosmic muons (mu+) simulation',//,
     +  ' 0 - 0.4 GeV/c - uniform distribution',/,
     +  ' 0.4 - 5000 GeV/c - acc. 1/p^2',//,
     +  1x,60(1H*),/)

 1503 FORMAT(//,' Error in generator 102: wrong parameter MOD',/)
 1504 FORMAT(/,1x,60(1H*),//,
     +  ' Generator # 103: 3-pi events simulation',/,
     +  ' ---------------------------------------',//,
     +  ' Process e+e- ->',A9,//,
     +  1pE10.2,' - beam energy (GeV)',/,
     +  1pE10.2,' - minimal theta (deg.)',//,
     +  1x,60(1H*),/)
 1505 FORMAT(/,1x,60(1H-),//,' Results:',//,
     +        ' Cr. section of e+e- sc.= ',1pE10.3,' cm^2'  ,//,
     +        ' Integrated luminosity  = ',1pE10.3,' 1/cm^2',/)
 1506 FORMAT(/,1x,60(1H-),//,' Results:',//,
     +        ' Cr. sec. e+e- -> gam gam = ',1pE10.3,' cm^2'  ,//,
     +        ' Integrated luminosity    = ',1pE10.3,' 1/cm^2',/)
 1507 FORMAT(/,' Error in data for GEN.102, Min.angle=',
     +         1pe10.3,' Deg, but should be < 90',//)
 1508 FORMAT(/,1x,60(1H-),//,' Results:',//,
     +        ' Cr. sec. e+e- -> mu+ mu- = ',1pE10.3,' cm^2'  ,//,
     +        ' Integrated luminosity    = ',1pE10.3,' 1/cm^2',/)
c
      END
