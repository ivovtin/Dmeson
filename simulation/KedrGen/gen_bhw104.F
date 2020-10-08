      SUBROUTINE GEN_BHW104(ievent,NevTot,CMSEne,ThMinp,ThMaxp,ThMine,
     +    ThMaxe,EnMinp,EnMine,Acolli,epsCMS)
c*********************************************************************
c
c  My version of generator
c
c
c  Subr:    BOX -> BH_BOX
c        GPRINT -> BH_GPRINT
c        DUMPS  -> BH_DUMPS
c        VACPOL -> BH_VACPOL
c
c  Commons:  /.../ -> /BH.../
c
c  9.05.2003. V.A.Tayursky
c  19.03.2004 V.A.Tayursky: RNG = RLU
c
c*********************************************************************
      IMPLICIT REAL*8 (A-H,O-Z)
c      PARAMETER( pi = 3.1415926535897932d0 )
c  Input/output files
      COMMON /BHcglib / b(50000)
      COMMON /BHINOUT / NINP,NOUT
      COMMON /BHMOMSET/ p1(4),q1(4),p2(4),q2(4),phot(100,4),nphot
      COMMON /BHWGTALL/ wtmod,wtcrud,wttrig,wtset(300)
      DIMENSION  xpar(100),npar(100)
      SAVE /BHINOUT /, /BHMOMSET /, /BHWGTALL /,XPAR,NPAR
c
      IF(IEVENT.EQ.1) THEN
c
        CALL GLIMIT(50000)  ! Initialization of histogramming package
c
        CALL GOUTPU(16)     ! Initialization of histogramming package
c
        NOUT = 16
c
        OPEN(nout,FILE='bhwide.output')
c
c  Input parameters for  BHWIDE
c
c      CMSEne = 200.0    ! CMS Energy = 2*Ebeam [GeV]
c      ThMinp =  25.0    ! Detector range ThetaMin [deg] for positrons
c      ThMaxp = 155.0    ! Detector range ThetaMax [deg] for positrons
c      ThMine =  25.0    ! Detector range ThetaMin [deg] for electrons
c      ThMaxe = 155.0    ! Detector range ThetaMax [deg] for electrons
c      EnMinp =   1.0    ! Energy minimum [GeV] for detected positrons
c      EnMine =   1.0    ! Energy minimum [GeV] for detected electrons
c      Acolli =  10.0    ! Maximum acollinearity [deg] of final e+e-
c      epsCMS =  1d-5    ! Infrared cut on photon energy
c
       WTMAX  =   3.0    ! Maximum Weight for rejection
      AMAZ   =  91.1882 ! Z mass
      GAMMZ  =  2.4952  ! Z width (may be recalculated by EW library)
      SINW2  =  0.22225 ! sin^2(theta_W) (may be recalculated by EW library)
      AMTOP  = 174.3    ! top quark mass
      AMHIG  = 115.0    ! Higgs mass
c
! Try both options for KeyWgt, result should be the same
c
      KeyWgt =   0   ! unweighted (WT=1) events, for detector simulation
c      KeyWgt = 1   ! weighted events
c
      KeyRnd =   1   ! MARRAN=RANMAR random numbers -> RLU (JETSET74)
c      KeyRnd =   2   ! RANECU random numbers
c      KeyRnd =   3   ! CARRAN random numbers
c
c			WRITE(NOUT,10) TEXTRND(KEYRND)
      KeyCha =   0   ! Channel choice: all/s-only/t-only: =0/1/2
      KeyZof =   0   ! Z-contribution ON/OFF: =0/1
      KeyOpt = 1000*KeyZof +100*KeyCha +10*KeyWgt + KeyRnd
c
c      KeyEWC = 0   ! QED corrections only
      KeyEWC =   1   ! Total O(alpha) ElectroWeak corr. included
c      KeyLib = 1   ! ElectroWeak corrections from BABAMC (obsolete!)
      KeyLib =   2   ! ElectroWeak corrections from ALIBABA
c
      KeyMod = 1   ! Hard bremsstr. matrix element from MODEL1
c      KeyMod =   2   ! Hard bremsstr. matrix alement from MODEL2
      KeyPia =   3   ! Vacuum polarization option (0/1/2/3)
      KeyRad = 1000*KeyEWC + 100*KeyLib + 10*KeyMod + KeyPia
c
c  Filling BHWIDE parameter arrays
c
        NPAR(1) = KeyOpt
        NPAR(2) = KeyRad
        XPAR(1) = CMSEne
        XPAR(2) = ThMinp
        XPAR(3) = ThMaxp
        XPAR(4) = ThMine
        XPAR(5) = ThMaxe
        XPAR(6) = EnMinp
        XPAR(7) = EnMine
        XPAR(8) = Acolli
        XPAR(9) = epsCMS
c
        xpar(10) = WTMAX
        xpar(11) = AMAZ
        xpar(12) = GAMMZ
        xpar(13) = SINW2
        xpar(14) = AMTOP
        xpar(15) = AMHIG
c
        CALL BHWIDE(-1,XPAR,NPAR)
c
      END IF
c
      CALL BHWIDE(0,XPAR,NPAR)
c
c  Print four-momenta of first events
c
      IF (IEVENT.LE.5) CALL BH_DUMPS(nout)
c
      IF (MOD(IEVENT,10000).EQ.1) WRITE(nout,*)' ievent = ',ievent
      IF(IEVENT.EQ.NEVTOT)then
c
        CALL BHWIDE( 2,XPAR,NPAR)
c
        Xsec = xpar(10)*0.001     ! pb -> nb
        Erel = xpar(11)
        Xcru = xpar(20)
c
c  Print cross-section (in bhwide.output)
c
      WRITE(nout,*)'|||||||||||||||||||||||||||||||||||||||||||||||||||'      
      WRITE(nout,'(a,f15.8,a)')' Xsec_accep = ',Xsec    ,' Nanob.'
     $                        ,' error      = ',Xsec*Erel,' Nanob.'
      WRITE(nout,*) ' Lt=',NEVTOT/Xsec,' 1/nb'
      WRITE(nout,*)'|||||||||||||||||||||||||||||||||||||||||||||||||||'
c
c  Print cross-section (in KEDRSIM output)
c
      WRITE(6,*)
      WRITE(6,*)'|||||||||||||||||||||||||||||||||||||||||||||||||||||'
      WRITE(6,'(a,f15.8,a)')'  Xsec_accep = ',Xsec    ,' nanobarn'
     $                        ,'  error      = ',Xsec*Erel,' nanobarn'
      WRITE(6,*) ' Lt=',NEVTOT/Xsec,' 1/nb'
      WRITE(6,*)'|||||||||||||||||||||||||||||||||||||||||||||||||||||'
!----------------------------------------------------------------------
c
        CLOSE(nout)
c
      END IF
10    FORMAT(/,10X,A30,/)

      END

c  gen_bhw104

      SUBROUTINE INITBH(XMZ,XMH,XMT)
c*****************************************************************
*
* Initialization routine, needed when using the routine BHABHA.
* The parameters are the masses of the Z, Higgs and top in GeV.
* All variables are input.
c
c*****************************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHFORMFA /FZV(0:NRMASS),FZA(0:NRMASS),
     +                FGV(0:NRMASS),FGA(0:NRMASS)
      COMPLEX*16 FZV,FZA,FGV,FGA
      COMMON/BHFORMMZ /FZVMZ(0:NRMASS),FZAMZ(0:NRMASS),
     +                FGVMZ(0:NRMASS),FGAMZ(0:NRMASS)
      COMPLEX*16 FZVMZ,FZAMZ,FGVMZ,FGAMZ
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
      COMMON/BHOPTION / IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
      COMMON/BHBOOKKP / IBH1,IBH2,IBH3,IBH4,IBH5,IBH6
      COMMON/BHBHSTAT / ISIGH,ISIGF,ITWOH,IZBR,IRNON,IEVS,IEEW
      REAL*8 IMSIGZ,IMZ2
      CHARACTER*13 NAMES(0:NRMASS+1)
c
      DATA NAMES /'     neutrino','     electron','         muon',
     +            '          tau','     up quark','   down quark',
     +            '  charm quark','strange quark',
     +            '    top quark',' bottom quark','      hadrons'/
c
      RMZ    = XMZ
      RMH    = XMH
      RMT    = XMT
*
* A few options that can be set by the user. These determine what is
* calculated and what is not.
* IWEAK  : 0/1 switches weak (non-QED) corrections off/on.
* IORDER : the order of the initial state LL QED corrections. Valid are
*          0: no initial state LL corrections
*          1: first  order initial state LL corrections
*          2: second order initial state LL corrections
*          3: first  order initial state LL corrections+exponentiation
*          4: second order initial state LL corrections+exponentiation
*             For s-channel processes IORDER=0 also switches off the
*             non-log terms from the initial state (when t-channel is
*             included 'initial state radiation' is not a gauge
*             invariant subset any more).
* IFINAL : the order of the final state LL QED corrections. Valid are
*          0: no final state LL corrections
*          1: first  order final state LL corrections
*          2: second order final state LL corrections
*              For s-channel processes IFINAL=0 also switches off the
*              non-log terms from the final state (when t-channel is
*              included 'final state radiation' is not a gauge
*              invariant subset any more).
* NONLOG : 0/1 switches off/on: the calculation of the first order
*              non-log correction terms (SLOW! [ = 5 dim. int. ! ]).
*              It is NOT possible to switch off parts of the
*              non log terms (like final state e.g.) in the case of
*              Bhabha scattering.
* ( "Best     choice": iweak=1, iorder=4, ifinal=2, nonlog=1 (SLOW!),
*   "Best LLA choice": iweak=1, iorder=4, ifinal=2, nonlog=0        )
*
* These options can be altered after calling INITBH, by picking
* up the common block OPTION and change them elsewhere; another call
* to INITBH is NOT needed then. Upon changing Z, Higgs or top mass,
* however, INITBH has to be called again!
*
      IWEAK  = 1
      IORDER = 4
      IFINAL = 2
      NONLOG = 1
*
* IOUT  : the unit nr where the output goes to (6=screen).
* ICHANN: enables calculating only certain channels:
*         =0 calculates s + t channels plus interference,
*         =1 calculates s channel only,
*         =2 calculates t channel only,
*         The option =3 calculates only s-t interference for the
*         LL part but the s+t total for the non log part. To put
*         it simply: this option is not implemented very well.
* IFERM : final state fermion label. IFERM=1 means Bhabha scattering,
*         for the other ones see the data statement. The choices
*         8 (top) and 10 (hadrons) are not allowed. Neutrino
*         production can be calculated in s channel only, for one
*         species only.
*
      IOUT   = 6
!WP      ICHANN = 0
!WP: ICHANN set up by BHWIDE (from input parameters)
c
      CALL SETCHA(ICHANN)
c
      IFERM  = 1
*
* From here on: NOT user settable
*
!WP   ALFAS  = .12D0
      ALFAS = 0.119d0
* ALFA and HBARC2 from Particle Data Group Publ. 1990.
      ALFA   = 1D0 / 137.0359895D0
      HBARC2 = 3.8937966D8
      PI = 4D0*DATAN(1D0)
      EE = SQRT( 4D0*PI*ALFA )
* QCD and QED correction factors
      FACQCD = ALFAS/PI + (ALFAS/PI)**2*( 1.98D0 - 5D0*.115D0 )
      FACQCB = 0.045D0
      IF (ALFAS .LE. 0D0) THEN
        FACQCB = 0D0
      END IF
      FACQED = 3D0*ALFA/4D0/PI
* Starting value for sin**2(theta-w)
      SIN2TH = .2310D0
      RMW = RMZ*DSQRT( 1D0 - SIN2TH )
* Iterate to find the value for sin**2(theta-w) and Mw
* After this all couplings and renormalization constants are defined.
      NITER = 20

      CALL COUPLS(SIN2TH,RMT)

      DO 110 I = 1 , NITER
        RMWOLD = RMW
c
        CALL RNORM()
c
        CALL COUPLS(SIN2TH,RMT)
c
        IF(DABS(RMWOLD-RMW)/RMW .LT. 1D-6) GOTO 130
  110 CONTINUE
      WRITE(*,120) NITER
  120 FORMAT(' The calculation of MW does not converge in',I4,' steps')
      STOP' We stop right here !'
  130 CONTINUE
*
* Echo the given input and write all calculated parameters.
      WRITE(IOUT,135)
  135 FORMAT(/,' Thank you for flying .... choosing A L I B A B A',/,
     + ' ',35X,'=============',//,' A (semi) Analytical Leading log',
     + ' Improved BhABhA scattering calculation.',/,' This program is',
     + ' meant for large angle Bhabha scattering [and for other',/,
     + ' fermion pair production (but then only in s channel)].')
      WRITE(IOUT,140)
  140 FORMAT(/,' ',67('*'),/,
     1 ' * Authors: W.J.P. Beenakker, F.A. Berends and S.C.',
     2 ' van der Marck. *',/,' * Address: Instituut-Lorentz, ',
     3 'University of Leiden',16X,'*',/,' * ',9X,
     4 'P.o.b. 9506, 2300 RA Leiden, The Netherlands',11X,'*',/,
     5 ' * Bitnet addresses: BEENAKKER @ HLERUL59',26X,'*',/,
     6 ' * ',18X,'BERENDS @ HLERUL5 or BERENDS @ HLERUL59',7X,'*',/,
     7 ' * ',18X,'VANDERMARCK @ HLERUL59',24X,'*',/,
     8 ' *',19X,'joint address:',' LORENTZ @ HLERUL5',14X,'*',/,
     9 ' ',67('*'))
      WRITE(IOUT,145)
  145 FORMAT(' * References:',53X,'*',/,' * [1] W. Beenakker, F.A.',
     1 ' Berends and S.C. van der Marck,',10X,'*',/,
     2 ' *',5X,'"Large angle Bhabha scattering" and "Higher order',
     3 11X,'*',/,' *',5X,'corrections to the forward-backward',
     4 ' asymmetry,"',13X,'*',/
     5 ' *',5X,'Leiden preprints 1990, for the treatment of the',
     6 ' purely',6X,'*',/,' *',5X,'QED corrections and the',
     7 ' incorporation of cuts on energy and *',/,' *',5X,'angle',
     8 ' of both outgoing particles and their acollinearity.   *',/,
     9 ' * [2] W. Beenakker and W. Hollik, ECFA workshop on LEP 200,',
     1 7X,'*',/,' *',8X,'CERN 87-08 p.185, ed. by A. Boehm and W.',
     2 ' Hoogland;',7X,'*',/,' *',5X,'W. Hollik,',
     3 ' DESY preprint 88-188, both for the treatment',5X,'*',/,
     4 ' *',5X,'of the weak (non-QED) corrections.',26X,'*',/,
     5 ' ',67('*'),/,' Version 2.0, August 1990')
*
* Differences with version 1.0:
*  1) Integration from theta1 to theta2 (and theta3->theta4)
*     instead of theta->180-theta. Therefore Afb calculation
*     is possible with version 2.0.
*  2) Different energy cuts for e+ and e- available.
*  3) ZZ and WW boxes added.
*  4) Technicalities: Labda2 'stable' for x<1d-6.
*                     EEEEW s-t separation fixed.
*                     Erroneous check on acol cut left out.
*
      WRITE(IOUT,150) (I,NAMES(I),RMASS(I),PWIDTH(I),I=0,NRMASS)
  150 FORMAT(/,' The properties of the fermions:',/,3X,
     +       ' label',7X,'name',4X,' mass (GeV)',
     +       '  partial width of the Z (GeV)',/,
     +       (' ',I6,1X,A13,1X,F12.7,8X,F12.7))
      WRITE(IOUT,'(1X,I6,1X,A13,21X,F12.7)')NRMASS+1,'      hadrons',
     +              PWIDTH(4)+PWIDTH(5)+PWIDTH(6)+PWIDTH(7)+PWIDTH(9)
      Z = RMZ**2

      CALL FORMFS(Z,9)

      DO 160 I = 0 , NRMASS
         FZVMZ(I) = FZV(I)
         FZAMZ(I) = FZA(I)
         FGVMZ(I) = FGV(I)
         FGAMZ(I) = FGA(I)
  160 CONTINUE
      ZWID = (IMSIGZ(Z)+IMZ2(Z))/RMZ/(1D0+BIGPIZ(Z))
      WRITE(IOUT,170) RMZ,ZWID,RMW,SIN2TH,RMH
  170 FORMAT(/,' For the bosons we have (everything in GeV):',/,
     + '  mass of the   Z   =',F10.4,
     + '    total width of the Z = ',F10.7,/,
     + '  mass of the   W   =',F10.4,
     + '    <==> sin**2(theta-w) = ',F10.7,/,
     + '  mass of the Higgs =',F10.4,/)
      WRITE(IOUT,180) 1D0/ALFA,1D0+FACQED,ALFAS,1D0+FACQCD
  180 FORMAT(' Some coupling strengths:',/,
     +       '                    1/alfa = ',F10.3,/,
     +       ' the QED correction factor = ',F14.7,/,
     +       '               alfa-strong = ',F10.3,/,
     +       ' the QCD correction factor = ',F14.7,/)
* Don't forget to initialize the random number generator.
!WP   CALL RMARIN(2125,3106,IOUT)
* Bookkeeping
      IBH1 = IWEAK+10
      IBH2 = ICHANN
      IBH3 = IORDER
      IBH4 = IFINAL
      IBH5 = NONLOG
      IBH6 = IFERM
      ISIGH = 0
      ISIGF = 0
      ITWOH = 0
      IZBR  = 0
      IRNON = 0
      IEVS  = 0
      IEEW  = 0
      END

c  gen_bhw104

      FUNCTION FINAL2()
*     ---------------
* Second order LL final state corrections as a factor times Born.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
      COMMON/BHCONTRL / C1,C2,C3,C4,EP0,EM0,ACOLMX,SCM,BETALL,BETALF,
     +                 EPS,EPS2

* This was the formula for EP0=EM0
*      RLOG1 = LOG( 1D0 - E0 )
*      RLOG2 = LOG( E0 )
*      DILO  = DILOG( 1D0 - E0 )
*      FAC = ( 2D0*RLOG1 + E0 + .5D0*E0**2 )**2 + 2D0*(
*     +      - PI**2/3D0 + 2D0*DILO + 2D0*RLOG1**2 - 4D0*(1D0-E0)*RLOG1
*     +      + 4D0*(1D0-E0) + (1D0-E0)**2*( RLOG1 - .5D0 )
*     +      - 1.5D0*E0*RLOG2 + 1.5D0*E0 - .75D0*E0**2*( RLOG2-.5D0 )
*     +      + 3D0*RLOG1 + 2.5D0*E0 + .25D0*E0**2 - 3.5D0   )
* Now for the new one:
      RLOGP1 = LOG( 1D0 - EP0 )
      RLOGM1 = LOG( 1D0 - EM0 )
      RLOGP2 = 0D0
      RLOGM2 = 0D0
      IF(EP0.GT.0D0) RLOGP2 = LOG( EP0 )
      IF(EM0.GT.0D0) RLOGM2 = LOG( EM0 )
      FAC = 2D0*DILOG(1D0-EP0) + 2D0*DILOG(1D0-EM0) - PI*PI*2D0/3D0 +
     1      2D0*( RLOGP1 + RLOGM1 )**2 + 2D0*( RLOGP1 + RLOGM1 )*
     2      ( EP0*(1D0+.5D0*EP0) + EM0*(1D0+.5D0*EM0) ) + EP0 + EM0 +
     3      1D0/8D0*( EP0**2 + EM0**2 ) + EP0*EM0*(1D0+.5D0*EP0)*
     4      (1D0+.5D0*EM0) - 1.5D0*EP0*(1D0+.5D0*EP0)*RLOGP2 -
     5                       1.5D0*EM0*(1D0+.5D0*EM0)*RLOGM2
      FINAL2 = FAC * (BETALF/4D0)**2
      END

c  gen_bhw104

      FUNCTION DOT(P,Q)
*     ------------
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 P(0:3),Q(0:3)
      DOT = P(0)*Q(0) - P(1)*Q(1) - P(2)*Q(2) - P(3)*Q(3)
      END

c  gen_bhw104

      SUBROUTINE HEAVYB(S,T,VZZ,AZZ,VWW,AWW)
*     -----------------
* Subroutine giving the 'couplings' with which to contract the
* ZZ and WW boxes with the Born matrix element.
* S,T are input and VZZ,AZZ,VWW,AWW are complex*16 output.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHOPTION / IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
      COMPLEX*16 VZZ,AZZ,VWW,AWW,RI5ST,RIST,RI5SU,RISU

      U = - S - T

      CALL HEAVYI(S,T,RMZ,RIST,RI5ST)

      CALL HEAVYI(S,U,RMZ,RISU,RI5SU)

      VZZ = ALFA/2D0/PI*( RIST  - RISU  )
      AZZ = ALFA/2D0/PI*( RI5ST + RI5SU )
*     WW boxes depend strongly on the isospin of the produced fermion
      IF(IFERM.EQ.0.OR.IFERM.EQ.4.OR.IFERM.EQ.6.OR.IFERM.EQ.8) THEN
*       isospin = + 1/2

        CALL HEAVYI(S,U,RMW,RISU,RI5SU)

        VWW = ALFA/2D0/PI*( - RISU  )
        AWW = ALFA/2D0/PI*( + RI5SU )
      ELSE
*       isospin = - 1/2

        CALL HEAVYI(S,T,RMW,RIST,RI5ST)

        VWW = ALFA/2D0/PI*( + RIST  )
        AWW = ALFA/2D0/PI*( + RI5ST )
      ENDIF
* To get the normalization right
      E2 = EE**2
      VZZ = VZZ * E2/S
      AZZ = AZZ * E2/S
      VWW = VWW * E2/S/4D0/SIN2TH**2
      AWW = AWW * E2/S/4D0/SIN2TH**2
      END

c  gen_bhw104

      SUBROUTINE HEAVYI(S,T,RM,RI,RI5)
*     -----------------
* Function needed to calculate ZZ or WW boxes.
* S,T,RM are input, RI,RI5 are complex*16 output.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( EPS = 1D-10 )
      COMMON/BHADHOC/ ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
      COMPLEX*16 RI,RI5,SPENCF,ROOT1,ROOT2,X1,X2,Y1,Y2,FOURSP,RLOG12
      COMPLEX*16 SHELP,THELP,I,X1X2

      IF ( S.GT.0D0 . AND. T.GT.0D0 ) THEN
        WRITE(*,'(A)')' HEAVYI: both S and T > 0.  This is not valid!'
        RI  = (0D0,0D0)
        RI5 = (0D0,0D0)
        RETURN
      ENDIF
      RM2 = RM**2
      IF( S .GT. 0D0 ) THEN
        SHELP = 4D0*RM2/CMPLX(S,EPS)
      ELSE
        SHELP = 4D0*RM2/S
      ENDIF
      IF( T .GT. 0D0 ) THEN
        THELP = RM2/CMPLX(T,EPS)
      ELSE
        THELP = RM2/T
      ENDIF
      ROOT1 = SQRT( (1D0,0D0)-SHELP )
      IF(S.LT.0D0.AND.T.LT.0D0.AND.4D0*RM2/S*(1D0+RM2/T).GT.1D0) THEN
        I = (0D0,1D0)
        ROOT2 = I*SQRT( -( (1D0,0D0)-SHELP*( (1D0,0D0) + THELP ) ) )
      ELSE
        ROOT2 =   SQRT(    (1D0,0D0)-SHELP*( (1D0,0D0) + THELP )   )
      ENDIF
      Y1 = .5D0*( 1D0 + ROOT1 )
      Y2 = .5D0*( 1D0 - ROOT1 )
      X1 = .5D0*( 1D0 + ROOT2 )
      X2 = .5D0*( 1D0 - ROOT2 )
      X1X2 = ROOT2
      FOURSP = SPENCF(X1/(X1-Y1)) + SPENCF(X1/(X1-Y2)) -
     +         SPENCF(X2/(X2-Y2)) - SPENCF(X2/(X2-Y1))
      RLOG12 = LOG(-Y1/Y2)
      IF( ABS(X1X2) .LT. 10D0*EPS ) THEN
        X1X2 = (1D0,0D0)
        FOURSP = 1D0/(Y1-Y2)*( - 4D0*Y1*LOG(2D0*Y1/(Y1-Y2))
     +                         + 4D0*Y2*LOG(2D0*Y2/(Y2-Y1)) )
      ENDIF
      RI5 = (2D0*T+S+2D0*RM2)/(2D0*(S+T))*(
     +      SPENCF( 1D0+CMPLX(T,EPS)/RM2 ) - PI*PI/6D0 - RLOG12**2 ) +
     +      .5D0*LOG(-CMPLX(T,EPS)/RM2) + (Y2-Y1)/2D0*RLOG12 +
     +      ( S+2D0*T - 4D0*T*RM2/S + 2D0*RM2**2/T - 2D0*RM2**2/S )/
     +      ( 2D0*( S + T )*(-X1X2) ) * FOURSP
      RI5 = S/( S + T ) * RI5
      RI  = RI5 + 2D0*RLOG12**2 + 2D0/X1X2*FOURSP
      END

c  gen_bhw104

      SUBROUTINE HISTO(I,ISTAT,X,X0,X1,WEIGHT,LINLOG,TITLE,IUNIT,NX)
*     ----------------
* Steven van der Marck, April 2nd, 1990.
* I      = number of this particular histogram (must be >0, <N(=50))
* ISTAT  = 0   : clear the arrays for all  histo's
*          1   : fill  the arrays for histo nr. I
*          2   : print histogram nr. I to unit nr. IUNIT
*          3   : output the data to HISTO.GRA - to be used for a
*                'home made' graphics program.
*          4   : same as 3, but the whole histogram is divided by
*                the number of points.
*          5   : save all relevant information to a file HISTO.DAT
*          6   : read all relevant information from file HISTO.DAT
*          ELSE: rescale all  histo's by a factor X
* X      = x-value to be placed in a bin of histogram nr. I
*          If ISTAT=2 and LINLOG<>1, x = the number of decades (def=3).
* X0     = the minimum for x in histogram nr. I
* X1     = the maximum for x in histogram nr. I
* WEIGHT = If ISTAT=1: the weight assigned to this value of x.
*          If ISTAT=2: the number of divisions on the y-axis (def=20),
*                     should not be <5 or >80 (because of screenwidth).
* LINLOG = determines the scale of both axes of the histogram.
*          If ISTAT=1 it goes for the x axis, for ISTAT=2 the y axis.
*          For LINLOG=1 the axis is linear, ELSE logarithmic.
*          If a linear histo has only one peak that is too sharp,
*          this routine will automatically switch to a log. y axis.
* TITLE  = title of this particular histogram ( character*(*) )
* IUNIT  = unit number to write this histogram to
* NX     = the number of divisions on the x-axis for this histogram
*          NX should not be greater than NXMAX (=50 in this version).
*
* When ISTAT = 0   : IUNIT is used.
*            = 1   : I, X, X0, X1, WEIGHT, LINLOG and NX are used.
*            = 2   : I, X, WEIGHT, LINLOG, TITLE and IUNIT are used.
*            = 3,4 : I, LINLOG and TITLE are used. The user should not
*             be using unit nr 11 when invoking HISTO with this option!
*            = 5,6 : no other variables are used.
*            = ELSE: only X is used.
      IMPLICIT LOGICAL(A-Z)
      INTEGER N,NX,NXMAX,I,ISTAT,LINLOG,IUNIT
* N = the maximum number of histo's allowed; can be changed on its own.
* NXMAX = the maximum allowed for NX(= nr. of divisions on the x-axis)
      PARAMETER( N = 50 , NXMAX = 50 )
      INTEGER J,J1,J2,IX,IY,JUNIT,NYDIV, LINLOX(N), IWARN
      REAL*8 X,X0,X1,WEIGHT, Z,WEISUM,WEISU2,FACTOR
      REAL*8 Y(N,NXMAX), YMAX(N), BOUND0(N), BOUND1(N),
     +                 XMIN(N), XMAX(N), YSQUAR(N,NXMAX), YOUT(N)
      INTEGER IUNDER(N), IIN(N), IOVER(N), NRBINS(N), IBIN(N,NXMAX)
      CHARACTER TITLE*(*),LINE(132),BLANK,STAR,TEXT*12
      CHARACTER FORM1*80,F*80,STRP*1,FH*30,F2(1:3)*12

      SAVE

      DATA STRP/'-'/F2/'(1X,4I10)','(1X,10I10)','(1X,10D12.5)'/
      DATA BLANK/' '/STAR/'*'/FH/'(A),''I'',3X,G11.4,2X,G11.4,I12)'/

*     Is this a valid histo nr.? (Not necessary if ISTAT=0.)
      IF( (I.LT.1.OR.I.GT.N) .AND. (ISTAT.NE.0) ) GOTO 910
*     ISTAT decides on several MUTUALLY EXCLUSIVE branches.
      IF(ISTAT .EQ. 0) THEN
*       Zero everything you've got.
        DO 20 J1 = 1 , N
          BOUND0(J1) = 0D0
          BOUND1(J1) = 0D0
          XMIN  (J1) = 0D0
          XMAX  (J1) = 0D0
          YMAX  (J1) = 0D0
          YOUT  (J1) = 0D0
          IUNDER(J1) = 0
          IIN   (J1) = 0
          IOVER (J1) = 0
          NRBINS(J1) = 0
          DO 10 J2 = 1 , NXMAX
            Y     (J1,J2) = 0D0
            YSQUAR(J1,J2) = 0D0
            IBIN  (J1,J2) = 0
   10     CONTINUE
   20   CONTINUE
        IWARN = 0
*       Finished ... - exit !
      ELSEIF(ISTAT.EQ.1) THEN
*       Fill arrays with this x value
        IF(NRBINS(I) .EQ. 0) THEN
*         First time around: remember boundaries, lin or log x-scale,
*         and the number of divisions on the x axis.
          BOUND0(I) = X0
          BOUND1(I) = X1
          LINLOX(I) = LINLOG
          IF(LINLOX(I) .NE. 1) THEN
            IF(BOUND0(I)*BOUND1(I) .GT. 0D0) THEN
              BOUND0(I) = LOG(ABS( BOUND0(I) ))
              BOUND1(I) = LOG(ABS( BOUND1(I) ))
            ELSE
              LINLOX(I) = 1
            ENDIF
          ENDIF
          NRBINS(I) = NXMAX
          IF(NX.GT.0 .AND. NX.LE.NXMAX) NRBINS(I) = NX
        ENDIF
        IF(LINLOX(I) .NE. 1) THEN
          IF(ABS(X) .GT. 0D0) THEN
            Z = LOG(ABS(X))
          ELSE
            Z = BOUND0(I) - 1D-10
          ENDIF
        ELSE
          Z = X
        ENDIF
*       Does this x value lie within the boundaries? Update statistics!
        IF(Z.LT.BOUND0(I))THEN
          IUNDER(I) = IUNDER(I) + 1
          YOUT  (I) = YOUT  (I) + WEIGHT
          IF(Z.LT.XMIN(I).OR.IUNDER(I).EQ.1) XMIN(I) = Z
        ELSEIF(Z.GT.BOUND1(I))THEN
          IOVER(I) = IOVER(I) + 1
          YOUT (I) = YOUT (I) + WEIGHT
          IF(Z.GT.XMAX(I).OR. IOVER(I).EQ.1) XMAX(I) = Z
        ELSE
          IIN(I) = IIN(I) + 1
          IX = INT((Z-BOUND0(I))/(BOUND1(I)-BOUND0(I))*NRBINS(I))+1
          IF(IX.EQ.NRBINS(I)+1) IX = NRBINS(I)
          IBIN  (I,IX) = IBIN  (I,IX) + 1
          Y     (I,IX) = Y     (I,IX) + WEIGHT
          YSQUAR(I,IX) = YSQUAR(I,IX) + WEIGHT**2
          IF(Y(I,IX).GT.YMAX(I)) YMAX(I) = Y(I,IX)
        ENDIF
*       Finished ... - exit !
      ELSEIF(ISTAT .EQ. 2) THEN
*       Print histogram. First a header.
        WRITE(IUNIT,'(//,A,I2,A,I10,A,I8,A,I8)')' Histogram nr.',I,
     +  '  Points in:',IIN(I),'  under:',IUNDER(I),'  over:',IOVER(I)
        WRITE(IUNIT,*)' ',TITLE
*       Leave if all entries have equal 0 weight.
        IF(ABS(YMAX(I)).LE.0D0) GOTO 920
*       Determine the number of divisions on the y axis.
        NYDIV = INT(WEIGHT)
        IF(NYDIV .LT. 5 .OR. NYDIV .GT. 80) NYDIV = 20
*       Determine lin/log scale y axis.
        IF(LINLOG .EQ. 1) THEN
*         Count the number of entries that will show up in a lin scale,
*         for if they are too few, make it a log one.
          IX = 0
          DO 30 J1 = 1 , NRBINS(I)
            IF(Y(I,J1)/YMAX(I)*NYDIV .GT. 1D0) IX = IX + 1
   30     CONTINUE
        ENDIF
        IF(IX .LE. 2 .OR. LINLOG .NE. 1) THEN
          IX = 2
          FACTOR = 1D3/YMAX(I)
          IF(X.GE.1D0 .AND. X.LE.10D0) FACTOR = 10D0**X/YMAX(I)
        ELSE
          IX = 1
        ENDIF
*       Prepare the formats (they depend on #divisions in y)
        WRITE(FORM1,'(A,I3,A)') '('' '',G11.4,1X,',NYDIV,'(A),A)'
        WRITE(F,'(A,I3,A)') '('' '',A12,',NYDIV,FH
        Z = BOUND0(I)
        IF(LINLOX(I) .NE. 1) Z = EXP(Z)
        WRITE(IUNIT,FORM1) Z,(STRP,J1=1,NYDIV),
     +    '   bin boundary   bin ''area''    # points'
        WEISUM = 0D0
        WEISU2 = 0D0
*       Loop over the divisions on the x axis. Print a line per div.
        DO 50 J1 = 1 , NRBINS(I)
*         First determine the height of this entry on the y axis.
          IY=1
          IF(IX.EQ.1) THEN
            IF(Y(I,J1).GT.0D0) IY=INT(Y(I,J1)/YMAX(I)*FLOAT(NYDIV))+1
          ELSE
            IF(FACTOR*Y(I,J1).GT.1D0) IY=INT(LOG(FACTOR*Y(I,J1))/
     +                            LOG(FACTOR*YMAX(I))*FLOAT(NYDIV))+1
          ENDIF
*         Fill the character array LINE that will be printed.
          IF(IY .EQ. NYDIV+1) IY = NYDIV
          DO 40 J2 = 1 , NYDIV
            LINE(J2)=BLANK
            IF(J2.EQ.IY) LINE(J2)=STAR
   40     CONTINUE
*         Prepare surrounding text and numbers
          Z = BOUND0(I) + J1/FLOAT(NRBINS(I))*(BOUND1(I)-BOUND0(I))
          IF(LINLOX(I) .NE. 1) Z = EXP(Z)
          WEISUM = WEISUM + Y(I,J1)
          WEISU2 = WEISU2 + YSQUAR(I,J1)
          IF(J1.EQ.INT(FLOAT(NRBINS(I))/2D0))THEN
            TEXT = ' (x,y) =   I'
          ELSEIF(J1.EQ.INT(FLOAT(NRBINS(I))/2D0)+1)THEN
            TEXT = ' (lin,lin) I'
            IF(IX.NE.1.AND.LINLOX(I).EQ.1) TEXT = ' (lin,log) I'
            IF(IX.EQ.1.AND.LINLOX(I).NE.1) TEXT = ' (log,lin) I'
            IF(IX.NE.1.AND.LINLOX(I).NE.1) TEXT = ' (log,log) I'
          ELSE
            TEXT = '           I'
          ENDIF
*         The actual WRITE !
          WRITE(IUNIT,F)TEXT,(LINE(J2),J2=1,NYDIV),Z,Y(I,J1),IBIN(I,J1)
   50   CONTINUE
        Z = BOUND1(I)
        IF(LINLOX(I) .NE. 1) THEN
          Z       = EXP(Z)
          XMIN(I) = EXP(XMIN(I))
          XMAX(I) = EXP(XMAX(I))
        ENDIF
*       End with information. Then we're through.
        WRITE(IUNIT,FORM1) Z,(STRP,J1=1,NYDIV),' '
        Z=SQRT(ABS(WEISU2-WEISUM**2/FLOAT(IIN(I))))/FLOAT(IIN(I))
        WRITE(IUNIT,'(12X,''The average of the entries amounts to '',
     +    G11.4,'' +- '',G11.4,/,12X,
     +    ''The fraction inside the histo bounds: '',G11.4)')WEISUM/
     +    FLOAT(IIN(I)+IUNDER(I)+IOVER(I)),Z,WEISUM/(WEISUM+YOUT(I))
        IF(IUNDER(I).GE.1) WRITE(IUNIT,60)'minimum',XMIN(I)
        IF( IOVER(I).GE.1) WRITE(IUNIT,60)'maximum',XMAX(I)
   60   FORMAT(12X,'The ',A,' value that occurred was   ',G11.4)
*       Finished ... - exit !
      ELSEIF(ISTAT .EQ. 3 .OR. ISTAT .EQ. 4) THEN
        IF(YMAX(I) .LE. 0D0) GOTO 930
        JUNIT = 11
        OPEN(UNIT=JUNIT,FILE='HISTO',STATUS='NEW')
        FACTOR = NRBINS(I)/(BOUND1(I)-BOUND0(I))
        IF(ISTAT .EQ. 4) FACTOR=FACTOR/FLOAT(IIN(I)+IUNDER(I)+IOVER(I))
        IF(LINLOG .EQ. 1) THEN
          IF(LINLOX(I) .EQ. 1) THEN
            WRITE(JUNIT,110) BOUND0(I),BOUND1(I),1.1D0*YMAX(I)*FACTOR
  110       FORMAT('*B',/,'VH 3.0',/,'LX 14.0',/,'LY 14.0',/,
     +       'XM ',D12.4,2X,D12.4,' 10',/,'YM 0. ',D12.4,' 10',/,'//')
          ELSE
            WRITE(JUNIT,120) 1.1D0*YMAX(I)*FACTOR
  120       FORMAT('*B',/,'VH 3.0',/,'LX 14.0',/,'LY 14.0',/,
     +       'XL',/,'YM 0. ',D12.4,' 10',/,'//')
          ENDIF
        ELSE
          Z = YMAX(I)*FACTOR
          DO 130 J1 = 2 , NRBINS(I)
            IF(FACTOR*Y(I,J1).LT.Z.AND.Y(I,J1).GT.0D0) Z=Y(I,J1)*FACTOR
  130     CONTINUE
          WEISUM = .8D0*Z
          IF(LINLOX(I) .EQ. 1) THEN
            WRITE(JUNIT,140) BOUND0(I),BOUND1(I)
          ELSE
            WRITE(JUNIT,150)
          ENDIF
  140     FORMAT('*B',/,'VH 3.0',/,'LX 14.0',/,'LY 14.0',/,'XM ',D12.4,
     +      2X,D12.4,' 10',/,'YL ',/,'//')
  150     FORMAT('*B',/,'VH 3.0',/,'LX 14.0',/,'LY 14.0',/,'XL',
     +      /,'YL',/,'//')
        ENDIF
        WRITE(JUNIT,*)' ',TITLE
        WRITE(JUNIT,'(///,''//'',/,''*P'',/,''SN -1'',/,''CL'')')
        Z = BOUND0(I)
        IF(LINLOX(I) .NE. 1) Z = EXP(Z)
        IF(Y(I,1).GT.0D0 .OR. LINLOG.EQ.1)
     +    WRITE(JUNIT,170) Z,Y(I,1)*FACTOR
        DO 160 J1 = 1 , NRBINS(I)-1
          Z = BOUND0(I) + J1/FLOAT(NRBINS(I))*(BOUND1(I)-BOUND0(I))
          IF(LINLOX(I) .NE. 1) Z = EXP(Z)
          IF((Y(I,J1).GT.0D0.AND.Y(I,J1+1).GT.0D0).OR.LINLOG.EQ.1)THEN
            WRITE(JUNIT,170) Z,Y(I,J1  )*FACTOR
            WRITE(JUNIT,170) Z,Y(I,J1+1)*FACTOR
          ELSEIF(Y(I,J1).GT.0D0) THEN
            WRITE(JUNIT,170) Z,Y(I,J1)*FACTOR
            WRITE(JUNIT,170) Z, WEISUM
            WRITE(JUNIT,'(''/'')')
          ELSEIF(Y(I,J1+1).GT.0D0) THEN
            WRITE(JUNIT,170) Z, WEISUM
            WRITE(JUNIT,170) Z,Y(I,J1+1)*FACTOR
          ENDIF
  160   CONTINUE
        J1 = NRBINS(I)
        Z  = BOUND1(I)
        IF(LINLOX(I) .NE. 1) Z = EXP(Z)
        IF(Y(I,J1).GT.0D0 .OR. LINLOG.EQ.1)
     +    WRITE(JUNIT,170) Z,Y(I,J1)*FACTOR
  170   FORMAT(' ',2D15.7)
        WRITE(JUNIT,'(''//'',/,''*E'')')
        CLOSE(UNIT=JUNIT)
      ELSEIF(ISTAT .EQ. 5) THEN
        JUNIT = 11
        OPEN(UNIT=JUNIT,FILE='HISTO',STATUS='NEW')
        WRITE(JUNIT,F2(1))(IUNDER(J),IIN(J),IOVER(J),NRBINS(J),J=1,N)
        WRITE(JUNIT,F2(2)) ((IBIN(J1,J2),J2=1,NXMAX),J1=1,N)
        WRITE(JUNIT,F2(3)) (YMAX(J1),BOUND0(J1),BOUND1(J1),
     +                     XMIN(J1),XMAX  (J1),YOUT  (J1),J1=1,N)
        WRITE(JUNIT,F2(3))((Y(J1,J2),YSQUAR(J1,J2),J2=1,NXMAX),J1=1,N)
        CLOSE(UNIT=JUNIT)
      ELSEIF(ISTAT .EQ. 6) THEN
        JUNIT = 11
        OPEN(UNIT=JUNIT,FILE='HISTO',STATUS='OLD')
        READ(JUNIT,F2(1))(IUNDER(J),IIN(J),IOVER(J),NRBINS(J),J=1,N)
        READ(JUNIT,F2(2)) ((IBIN(J1,J2),J2=1,NXMAX),J1=1,N)
        READ(JUNIT,F2(3)) (YMAX(J1),BOUND0(J1),BOUND1(J1),
     +                    XMIN(J1),XMAX  (J1),YOUT  (J1),J1=1,N)
        READ(JUNIT,F2(3))((Y(J1,J2),YSQUAR(J1,J2),J2=1,NXMAX),J1=1,N)
        CLOSE(UNIT=JUNIT)
      ELSE
*       Scaling of the y axis with factor X. Useful for normalization.
        DO 200 J1 = 1 , N
          YMAX(J1) = X * YMAX(J1)
          DO 190 J2 = 1 , NXMAX
            Y     (J1,J2) = X    * Y     (J1,J2)
            YSQUAR(J1,J2) = X**2 * YSQUAR(J1,J2)
  190     CONTINUE
  200   CONTINUE
      ENDIF
      RETURN
*     A few error returns.
  910 IWARN = IWARN + 1
      IF(IWARN .LE. 5) WRITE(*,'(A,I10,A,I2)')' HISTO called with I =',
     +                       I,',     Warning nr.',IWARN
      RETURN
  920 WRITE(IUNIT,'(A)')' All bins have weights <=0. No histo printed.'
      RETURN
  930 WRITE(  *  ,'(A)')' All bins have weights <=0. No histo printed.'
      RETURN
      END

c  gen_bhw104

      SUBROUTINE COUPLS(SIN2TH,RMT)
*     -----------------
* Define the fermion masses and their couplings to the bosons.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
c
      RMASS(0) = 0D0
* Charged lepton masses from Particle Data Group Publ. 1990.
!WP      RMASS(1) = .51099906D-3
!WP      RMASS(2) = .105658387D0
!WP      RMASS(3) = 1.7841D0
!WP      RMASS(4) = .04145D0
!WP      RMASS(5) = .04146D0
!WP      RMASS(6) = 1.5D0
!WP      RMASS(7) = .15D0
!WP      RMASS(8) = RMT
!WP      RMASS(9) = 4.5D0
!WP: Charged lepton masses from Particle Data Group Publ. 1998.
      RMASS(1) = 0.51099907d-3
      RMASS(2) = 0.105658389d0
      RMASS(3) = 1.77705d0
      RMASS(4) = 0.00325d0
      RMASS(5) = 0.006d0
      RMASS(6) = 1.250d0
      RMASS(7) = 0.115d0
      RMASS(8) = RMT
      RMASS(9) = 4.250d0
      SW    = DSQRT( SIN2TH )
      CW    = DSQRT( 1D0 - SIN2TH )
      DO 10 I = 0 , NRMASS
         RMASS2(I) = RMASS(I)**2
         IF(I .EQ. 0) THEN
            Q  =  0D0
            T3 = .5D0
         ELSEIF(I .LE. 3) THEN
            Q  = -  1D0
            T3 = - .5D0
         ELSEIF(I.EQ.4 .OR. I.EQ.6 .OR. I.EQ.8) THEN
            Q  =   2D0/3D0
            T3 =  .5D0
         ELSE
            Q  = -  1D0/3D0
            T3 = - .5D0
         ENDIF
         VF(I) = ( T3 - 2D0*Q*SIN2TH ) /2D0/CW/SW
         AF(I) = T3 /2D0/SW/CW
         QF(I) =   Q
   10 CONTINUE
      END

c  gen_bhw104

      SUBROUTINE RNORM()
*     ----------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Calculate all quantities that have to do with weak corrections on
* boson propagators.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHRENORM /PIGAM0,SIGGZ0,DELMZ,DELMW,DELZ2Z,DELZ2G,DELZ2W,
     +                 SUMQ1,SUMQ2
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE

      SW  = DSQRT( SIN2TH )
      CW2 =  1D0 - SIN2TH
      CW  = DSQRT( CW2 )
      Z   = RMZ**2
      W   = RMW**2
      SIGGZ0 = USIGGZ( 0D0 )
      PIGAM0 = DUSIGG( 0D0 )
*
* Renormalization constants eq. (3.16) and (3.17) of ref.2b
      DELMZ  =   USIGZ( Z )
      DELMW  =   USIGW( W )
      DELZ2G = - PIGAM0
      DELZ2Z = - PIGAM0 - 2D0*(CW2-SIN2TH)/SW/CW*SIGGZ0/Z +
     +                    (CW2-SIN2TH)/SIN2TH*( DELMZ/Z - DELMW/W )
      DELZ2W = - PIGAM0 - 2D0*CW/SW*SIGGZ0/Z +
     +                    CW2/SIN2TH*( DELMZ/Z - DELMW/W )
*
* Contributions from the DELTA-i terms
      SUMQ1 = ALFA/4D0/PI/2D0/SIN2TH/W*(
     +      + ( RMASS2(4)-RMASS2(5) )*DLOG(RMASS(4)/RMASS(5))
     +      + ( RMASS2(6)-RMASS2(7) )*DLOG(RMASS(6)/RMASS(7))
     +      + ( RMASS2(8)-RMASS2(9) )*DLOG(RMASS(8)/RMASS(9)) )
      SUMQ2 = ALFA/2D0/PI*( + DLOG(RMASS(4)/RMASS(5))
     +                      + DLOG(RMASS(6)/RMASS(7))
     +                      + DLOG(RMASS(8)/RMASS(9)) )
*
* Calculate delta-r and update the values for sin(theta-w) and MW.
      DR = DELTAR()
      BIGA0  = 37.281D0**2
      SIN2TH = .5D0*(  1D0 - DSQRT( 1D0-4D0*BIGA0/Z/(1D0-DR) )  )
      RMW = DSQRT( Z*( 1D0 - SIN2TH ) )
      END

c  gen_bhw104

      SUBROUTINE FORMFS(QSQR,IFERM)
*     -----------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Calculate the vector and axial vector formfactors for the Z-ff and
* the gamma-ff couplings.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
      COMMON/BHFORMFA /FZV(0:NRMASS),FZA(0:NRMASS),
     +                FGV(0:NRMASS),FGA(0:NRMASS)
      COMPLEX*16 FZV,FZA,FGV,FGA,FL1,FL2,FL3,FL4,FL5
      COMPLEX*16 RL2Z,RL2W,RL3W,RL3Z
*
      CALL LABDAS(QSQR,RMZ,RL2Z,RL3Z)

      CALL LABDAS(QSQR,RMW,RL2W,RL3W)

      CW2  = 1D0 - SIN2TH
      SW   = DSQRT( SIN2TH )
      CW   = DSQRT( CW2 )
      ALF4PI = ALFA/4D0/PI
* eq. (C.4) ref 2b.
      FL1 = RL2W/8D0/SW**3/CW - 3D0*CW/4D0/SW**3*RL3W
      FL2 = -(1D0-2D0/3D0*SIN2TH)/8D0/SW**3/CW*RL2W +
     +         3D0*CW/4D0/SW**3*RL3W
      FL3 =  (1D0-4D0/3D0*SIN2TH)/8D0/SW**3/CW*RL2W -
     +         3D0*CW/4D0/SW**3*RL3W
      IF(IFERM .EQ. 9) THEN

         CALL FLBOT(QSQR,FL4,FL5)

      ELSE
         FL4 = FL3
         FL5 = 1D0/6D0/SIN2TH*RL2W - 3D0/4D0/SIN2TH*RL3W
      ENDIF
* eq. (C.3) of ref 2b.
      FZV(0) = ALFA/4D0/PI/4D0/SW/CW*( RL2Z/4D0/CW2/SIN2TH +
     +           (1D0-1D0/2D0/SIN2TH)*RL2W + 3D0*CW2/SIN2TH*RL3W )
      FZA(0) = FZV(0)
      FZV(1) = ALF4PI*( VF(1)*(VF(1)**2+3D0*AF(1)**2)*RL2Z + FL1 )
      FZA(1) = ALF4PI*( AF(1)*(3D0*VF(1)**2+AF(1)**2)*RL2Z + FL1 )
      FZV(4) = ALF4PI*( VF(4)*(VF(4)**2+3D0*AF(4)**2)*RL2Z + FL2 )
      FZA(4) = ALF4PI*( AF(4)*(3D0*VF(4)**2+AF(4)**2)*RL2Z + FL2 )
      FZV(5) = ALF4PI*( VF(5)*(VF(5)**2+3D0*AF(5)**2)*RL2Z + FL3 )
      FZA(5) = ALF4PI*( AF(5)*(3D0*VF(5)**2+AF(5)**2)*RL2Z + FL3 )
      FZV(9) = ALF4PI*( VF(9)*(VF(9)**2+3D0*AF(9)**2)*RL2Z + FL4 )
      FZA(9) = ALF4PI*( AF(9)*(3D0*VF(9)**2+AF(9)**2)*RL2Z + FL4 )
* eq. (C.12) ref 2b.
      FL1 = -3D0/ 4D0/SIN2TH*RL3W
      FL2 = -1D0/12D0/SIN2TH*RL2W + 3D0/4D0/SIN2TH*RL3W
      FL3 =  1D0/ 6D0/SIN2TH*RL2W - 3D0/4D0/SIN2TH*RL3W
      FGV(0) = CMPLX(0D0,0D0)
      FGA(0) = FGV(0)
* eq. (C.11) ref 2b.
      FGV(1) = ALF4PI*( QF(1)*(VF(1)**2+AF(1)**2)*RL2Z + FL1 )
      FGA(1) = ALF4PI*( QF(1)*( 2D0*VF(1)*AF(1) )*RL2Z + FL1 )
      FGV(4) = ALF4PI*( QF(4)*(VF(4)**2+AF(4)**2)*RL2Z + FL2 )
      FGA(4) = ALF4PI*( QF(4)*( 2D0*VF(4)*AF(4) )*RL2Z + FL2 )
      FGV(5) = ALF4PI*( QF(5)*(VF(5)**2+AF(5)**2)*RL2Z + FL3 )
      FGA(5) = ALF4PI*( QF(5)*( 2D0*VF(5)*AF(5) )*RL2Z + FL3 )
      FGV(9) = ALF4PI*( QF(9)*(VF(9)**2+AF(9)**2)*RL2Z + FL5 )
      FGA(9) = ALF4PI*( QF(9)*( 2D0*VF(9)*AF(9) )*RL2Z + FL5 )
* all others are related to the previous ones.
      DO 10 I = 0 , NRMASS
         IF(I.EQ.2 .OR. I.EQ.3) THEN
            FZV(I) = FZV(1)
            FZA(I) = FZA(1)
            FGV(I) = FGV(1)
            FGA(I) = FGA(1)
         ELSEIF(I.EQ.6 .OR. I.EQ.8) THEN
            FZV(I) = FZV(4)
            FZA(I) = FZA(4)
            FGV(I) = FGV(4)
            FGA(I) = FGA(4)
         ELSEIF(I.EQ.7) THEN
            FZV(I) = FZV(5)
            FZA(I) = FZA(5)
            FGV(I) = FGV(5)
            FGA(I) = FGA(5)
         ENDIF
   10 CONTINUE
      END

c  gen_bhw104

      SUBROUTINE LABDAS(QSQR,RM,LABDA2,LABDA3)
*     -----------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 LABDA2,LABDA3,W,X,BIGK,SPENCF
      PARAMETER( EPS = 1D-10 )

      W = RM**2/DCMPLX( QSQR , EPS )
      X = LOG( - BIGK(QSQR,RM) )
* This way of writing was not very stable for qsqr << rm**2. The
* second way is somewhat better, but still has to be cut off at some
* low qsqr value, in which case it should yield zero.
*      LABDA2 = -3.5D0 - 2D0*W - (2D0*W+3D0)*LOG(-W)+
*     +   2D0*(1D0+W)**2*( SPENCF(1D0+1D0/W) - PI**2/6D0 )
      LABDA2 = -3.5D0 - 2D0*W - (2D0*W+3D0)*LOG(-W)+
     +   2D0*(1D0+W)**2*( -SPENCF(-1D0/W)+LOG(-W)*LOG(1D0+1D0/W) )
      IF(DBLE(W).GT.1D6) LABDA2 = (0D0,0D0)
      LABDA3 =  5D0/6D0 - 2D0*W/3D0 - 1D0/3D0*(2D0*W+1)*
     +   CDSQRT(1D0-4D0*W)*X + 2D0/3D0*W*(W+2D0)*X**2
      END

c  gen_bhw104

      FUNCTION BIGK(QSQR,RM)
*     -------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 BIGK,W

      W = RM**2/DCMPLX( QSQR , 1D-10 )
      BIGK = - ( CDSQRT(1D0-4D0*W) - 1D0 )/( CDSQRT(1D0-4D0*W) + 1D0 )
      END

c  gen_bhw104

      FUNCTION SIGG(QSQR)
*     -------------
* Real part of the renormalized weakly corrected photon propagator
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHRENORM /PIGAM0,SIGGZ0,DELMZ,DELMW,DELZ2Z,DELZ2G,DELZ2W,
     +                 SUMQ1,SUMQ2
* eq. (3.23) ref 2b.
      SIGG = USIGG(QSQR) - PIGAM0 * QSQR
      END

c  gen_bhw104

      FUNCTION SIGGZ(QSQR)
*     --------------
* Real part of the renormalized weakly corrected photon-Z mixing
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHRENORM /PIGAM0,SIGGZ0,DELMZ,DELMW,DELZ2Z,DELZ2G,DELZ2W,
     +                 SUMQ1,SUMQ2
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
c
      CW2 = 1D0 - SIN2TH
      CW  = DSQRT( CW2 )
      SW  = DSQRT( SIN2TH )
* eq. (3.23) ref 2b.
      SIGGZ = USIGGZ(QSQR) - SIGGZ0 - QSQR* CW*SW/(CW2-SIN2TH)*
     +        ( DELZ2Z - DELZ2G ) +
     +        QSQR*( - CW/SW*SUMQ1 - SUMQ2/6D0/CW/SW )
      END

c  gen_bhw104

      FUNCTION SIGZ(QSQR)
*     -------------
* Real part of the renormalized weakly corrected Z propagator
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHRENORM /PIGAM0,SIGGZ0,DELMZ,DELMW,DELZ2Z,DELZ2G,DELZ2W,
     +                 SUMQ1,SUMQ2
      COMMON/BHBOSONS /RMZ,RMW,RMH,RMT,SIN2TH,ZWID
c
      CW2 = 1D0 - SIN2TH
* eq. (3.23) ref 2b.
      SIGZ = USIGZ(QSQR) - DELMZ + DELZ2Z*( QSQR - RMZ**2 ) +
     +       (QSQR-RMZ**2)*((CW2-SIN2TH)/SIN2TH*SUMQ1+SUMQ2/3D0/SIN2TH)
      END

c  gen_bhw104

      FUNCTION SIGW(QSQR)
*     -------------
* Real part of the renormalized weakly corrected W propagator
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHRENORM /PIGAM0,SIGGZ0,DELMZ,DELMW,DELZ2Z,DELZ2G,DELZ2W,
     +                 SUMQ1,SUMQ2
      COMMON/BHBOSONS /RMZ,RMW,RMH,RMT,SIN2TH,ZWID
c
      CW2 = 1D0 - SIN2TH
* eq. (3.23) ref 2b.
      SIGW = USIGW(QSQR) - DELMW + DELZ2W*( QSQR - RMW**2 ) +
     +       (QSQR-RMW**2)*( CW2/SIN2TH*SUMQ1 + SUMQ2/3D0/SIN2TH )
      END

c  gen_bhw104

      FUNCTION DELTAR()
*     ---------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* The weak correction factor delta-r
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHBOSONS /RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  /ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
* eq. (4.18) ref 2b.
      DELTAR = SIGW(0D0)/RMW**2 + ALFA/4D0/PI/SIN2TH*
     +        ( 6D0 + (7D0-4D0*SIN2TH)/2D0/SIN2TH*DLOG(1D0-SIN2TH) )
      END

c  gen_bhw104

      FUNCTION USIGG(QSQR)
*     --------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Real part of the unrenormalized weakly corrected photon prop
* eq. (B.2) ref 2b with errata, a minus sign and a bracket.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
      S   = QSQR
      TOT = 0D0
      FAC = 1D0
      DO 10 I = 1 , NRMASS
         IF(I .EQ. 4) FAC = 3D0
         RM = RMASS(I)
         TOT = TOT + 4D0/3D0*QF(I)**2*(
     +         ( S+2D0*RMASS2(I) )*FREAL(S,RM,RM) - S/3D0 )  *  FAC
   10 CONTINUE
      TOT = TOT - ( 3D0*S + 4D0*RMW**2 )*FREAL(S,RMW,RMW)
      USIGG = ALFA/4D0/PI * TOT
      END

c  gen_bhw104

      FUNCTION DUSIGG(QSQR)
*     ---------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Derivative of the real part of the unrenormalized
* weakly corrected photon propagator
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE

      S   = QSQR
      TOT = 0D0
      FAC = 1D0
      DO 10 I = 1 , NRMASS
         IF(I .EQ. 4) FAC = 3D0
         RM = RMASS(I)
         TOT = TOT + 4D0/3D0*QF(I)**2*( + FREAL(S,RM,RM) +
     +         ( S+2D0*RMASS2(I) )*DFREAL(S,RM,RM) - 1D0/3D0 )  *  FAC
   10 CONTINUE
      TOT = TOT - 3D0*FREAL(S,RMW,RMW) -
     +            ( 3D0*S + 4D0*RMW**2 )*DFREAL(S,RMW,RMW)
      DUSIGG = ALFA/4D0/PI * TOT
      END

c  gen_bhw104

      FUNCTION PHADPI(QSQR)
*     ---------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Real part of the hadronic part of sigma-g(qsqr) / qsqr = pi-hadronic,
* calculated perturbatively.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
      S   = QSQR
      TOT = 0D0
      FAC = 3D0
      DO 10 I = 4 , NRMASS
         RM = RMASS(I)
         IF(I.NE.8) TOT = TOT + 4D0/3D0*QF(I)**2*(
     +         ( S+2D0*RMASS2(I) )*FREAL(S,RM,RM) - S/3D0 ) * FAC/S
   10 CONTINUE
      PHADPI = ALFA/4D0/PI * TOT
      END

c  gen_bhw104

      FUNCTION USIGGZ(QSQR)
*     ---------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Real part of the unrenormalized photon-Z mixing propagator
* eq. (B.3) ref 2b.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE

      S   = QSQR
      SW  = DSQRT(       SIN2TH )
      CW  = DSQRT( 1D0 - SIN2TH )
      TOT = 0D0
      FAC = 1D0
      DO 10 I = 1 , NRMASS
         IF(I .EQ. 4) FAC = 3D0
         RM = RMASS(I)
         TOT = TOT - 4D0/3D0*QF(I)*VF(I)*(
     +         ( S+2D0*RMASS2(I) )*FREAL(S,RM,RM) - S/3D0 )  *  FAC
   10 CONTINUE
      TOT = TOT + 1D0/CW/SW*( ( 3D0*CW**2 + 1D0/6D0 )*S
     +                      + ( 4D0*CW**2 + 4D0/3D0 )*RMW**2 )*
     +                       FREAL(S,RMW,RMW)  +  S/9D0/CW/SW
      USIGGZ = ALFA/4D0/PI * TOT
      END

c  gen_bhw104

      FUNCTION USIGZ(QSQR)
*     --------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Real part of the unrenormalized weakly corrected Z propagator,
* for QSQR > 0.
* eq. (B.4) ref 2b. 1 erratum in the pole part, not apparent here.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE

      S   = QSQR
      CW2 =  1D0 - SIN2TH
      TOT = 0D0
      FAC = 1D0
      DO 10 I = 1 , NRMASS
         IF(I .EQ. 4) FAC = 3D0
         IF(I .LE. 3) TOT = TOT + 4D0/3D0* 2D0*AF(I)**2*S*(
     +                    + 5D0/3D0 - DLOG(ABS( S/RMASS2(I) )) ) * FAC
         RM = RMASS(I)
         F = FREAL(S,RM,RM)
         TOT = TOT + 4D0/3D0*(  ( VF(I)**2+AF(I)**2 )*(
     +                         + ( S+2D0*RMASS2(I) )*F - S/3D0 )
     +             - 3D0/8D0/SIN2TH/CW2*RMASS2(I)*F ) * FAC
   10 CONTINUE
      W = RMW**2
      Z = RMZ**2
      H = RMH**2
      TOT = TOT + ( ( -CW2**2*(40D0*S+80D0*W) + 12D0*W +
     1              (CW2-SIN2TH)**2*( 8D0*W+S ) )*FREAL(S,RMW,RMW) +
     2            ( 10D0*Z - 2D0*H + S + (H-Z)**2/S )*FREAL(S,RMH,RMZ)-
     3            2D0*H*DLOG(H/W) - 2D0*Z*DLOG(Z/W) +
     4            ( 10D0*Z - 2D0*H + S )*( 1D0 - (H+Z)/(H-Z)*
     5              DLOG(RMH/RMZ) - DLOG(RMH*RMZ/W) ) +
     6            2D0/3D0*S*( 1D0 + (CW2-SIN2TH)**2 - 4D0*CW2**2 )
     7  )/12D0/CW2/SIN2TH
      USIGZ = ALFA/4D0/PI * TOT
      END

c  gen_bhw104

      FUNCTION USIGW(QSQR)
*     --------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Real part of the unrenormalized weakly corrected W propagator,
* for QSQR >= 0.
* eq. (B.5) ref 2b with errata: a factor 3 for the last 7 lines,
*                               one factor s, one factor 1/s and a sign
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      REAL*8 MP,MM
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE

      S   = QSQR
      CW2 =  1D0 - SIN2TH
      W   = RMW**2
      Z   = RMZ**2
      H   = RMH**2
      TOT = 0D0
      IF(DABS(S) .GT. 1D-10) THEN
         DO 10 I = 1 , NRMASS
            RM  = RMASS (I)
            RM2 = RMASS2(I)
            IF(I .LE. 3) THEN
              TOT = TOT + ( S-RM2/2D0-RM2**2/2D0/S )*FREAL(S,0D0,RM) +
     +                     2D0/3D0*S - RM2/2D0
            ELSE
               FAC = 3D0
               IF(MOD(I,2) .EQ. 0) THEN
                  MP  = RMASS(I)
                  MM  = RMASS(I+1)
                  SUM = RMASS2(I) + RMASS2(I+1)
                  DIF = RMASS2(I) - RMASS2(I+1)
                  TOT = TOT + (
     +               (S-SUM/2D0-DIF**2/2D0/S)*FREAL(S,MP,MM)+
     +               (S-SUM/2D0)*(1D0-SUM/DIF*DLOG(MP/MM))-S/3D0) * FAC
               ENDIF
            ENDIF
   10    CONTINUE
         TOT = TOT + 3D0*(  ( SIN2TH**2*Z - CW2/3D0*( 7D0*Z + 7D0*W +
     1                  10D0*S - 2D0*(Z-W)**2/S ) - 1D0/6D0*(W+Z-S/2D0-
     2              (Z-W)**2/2D0/S ) )*FREAL(S,RMZ,RMW) +
     3       SIN2TH/3D0*( -4D0*W-10D0*S+2D0*W**2/S )*FREAL(S,0D0,RMW) +
     4       1D0/6D0*( 5D0*W-H+S/2D0+(H-W)**2/2D0/S )*FREAL(S,RMH,RMW)+
     5       ( CW2/3D0*( 7D0*Z+7D0*W+10D0*S-4D0*(Z-W) ) - SIN2TH**2*Z +
     6         1D0/6D0*( 2D0*W - S/2D0 ) ) * Z/(Z-W)*DLOG(Z/W) -
     7       ( 2D0/3D0*W + S/12D0 ) * H/(H-W)*DLOG(H/W) -
     8       CW2/3D0*( 7D0*Z + 7D0*W + 32D0/3D0*S ) + SIN2TH**2*Z +
     9       1D0/6D0*( 5D0/3D0*S + 4D0*W - Z - H ) -
     1       SIN2TH/3D0*( 4D0*W + 32D0/3D0*S )  )
      ELSE
         DO 20 I = 1 , NRMASS
            RM  = RMASS (I)
            RM2 = RMASS2(I)
            IF(I .LE. 3) THEN
              TOT = TOT - 3D0/4D0 * RM2
            ELSE
               FAC = 3D0
               IF(MOD(I,2) .EQ. 0) THEN
                  MP  = RMASS(I)
                  MM  = RMASS(I+1)
                  SUM = RMASS2(I) + RMASS2(I+1)
                  DIF = RMASS2(I) - RMASS2(I+1)
                  TOT = TOT -.5D0*(
     +                      3D0/2D0*SUM - DLOG(MP/MM)/DIF*
     +                      (SUM**2+2D0*RMASS2(I)*RMASS2(I+1)) ) * FAC
               ENDIF
            ENDIF
   20    CONTINUE
         TOT = TOT +3D0*( (2D0/3D0*CW2+1D0/12D0)*(.5D0*(W+Z)-W*Z/(W-Z)*
     1               DLOG(W/Z) ) + W/3D0*SIN2TH + 1D0/12D0*( .5D0*
     2               (H+W)-H*W/(W-H)*DLOG(W/H) ) + ( CW2/3D0*( 3D0*Z+
     3               11D0*W ) - SIN2TH**2*Z + 1D0/3D0*W )*Z/(Z-W)*
     4               DLOG(Z/W) - 2D0/3D0*W*H/(H-W)*DLOG(H/W) -
     5               1D0/3D0*CW2*(7D0*Z+7D0*W) + SIN2TH**2*Z + 1D0/6D0*
     6              (4D0*W-Z-H) - SIN2TH/3D0*4D0*W  )
      ENDIF
      USIGW = ALFA/4D0/PI /3D0/SIN2TH  * TOT
      END

c  gen_bhw104

      FUNCTION BIGPIZ(QSQR)
*     ---------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Derivative of the real part of the renormalized
* weakly corrected Z propagator, for QSQR > 0.
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON/BHRENORM / PIGAM0,SIGGZ0,DELMZ,DELMW,DELZ2Z,DELZ2G,DELZ2W,
     +                 SUMQ1,SUMQ2
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE

      S   = QSQR
      CW2 = 1D0 - SIN2TH
      TOT = 0D0
      FAC = 1D0
      DO 10 I = 1 , NRMASS
         IF(I .EQ. 4) FAC = 3D0
         IF(I .LE. 3) TOT = TOT + 4D0/3D0* 2D0*AF(I)**2*(
     +                    + 2D0/3D0 - DLOG(ABS( S/RMASS2(I) )) ) * FAC
         RM = RMASS(I)
         F  =  FREAL(S,RM,RM)
         DF = DFREAL(S,RM,RM)
         TOT = TOT + 4D0/3D0*(  ( VF(I)**2+AF(I)**2 )*(
     +                   F  + ( S+2D0*RMASS2(I) )*DF - 1D0/3D0 )
     +             - 3D0/8D0/SIN2TH/CW2*RMASS2(I)*DF ) * FAC
   10 CONTINUE
      W = RMW**2
      Z = RMZ**2
      H = RMH**2
      TOT = TOT + ( ( -CW2**2*(40D0*S+80D0*W) + 12D0*W +
     1                (CW2-SIN2TH)**2*( 8D0*W+S ) )*DFREAL(S,RMW,RMW) +
     2               (-40D0*CW2**2+(CW2-SIN2TH)**2 )*FREAL(S,RMW,RMW) +
     3            ( 10D0*Z-2D0*H+S+(H-Z)**2/S )*DFREAL(S,RMH,RMZ) +
     4            (        1D0 - (H-Z)**2/S**2 )*FREAL(S,RMH,RMZ) +
     5            ( 1D0-(H+Z)/(H-Z)*DLOG(RMH/RMZ)-DLOG(RMH*RMZ/W) ) +
     6            2D0/3D0*( 1D0 + (CW2-SIN2TH)**2 - 4D0*CW2**2 )
     7  )/12D0/CW2/SIN2TH
      BIGPIZ = TOT * ALFA/4D0/PI + DELZ2Z +
     +                    (CW2-SIN2TH)/SIN2TH*SUMQ1 + SUMQ2/3D0/SIN2TH
      END

c  gen_bhw104

      FUNCTION FREAL(S,RM1,RM2)
*     --------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Real part of the function F(s,ma,mb), eq. (B.6) ref 2b.
      IMPLICIT REAL*8(A-H,O-Z)

      PARAMETER( EPS = 1D-10 )

      IF(RM1 .LT. RM2) THEN
        RMA = RM1
        RMB = RM2
      ELSE
        RMA = RM2
        RMB = RM1
      ENDIF
      RMA2 = RMA**2
      RMB2 = RMB**2
      IF(DABS(S) .LT. EPS) THEN
        F = 0D0
      ELSEIF(S .GT. 0D0) THEN
        IF(RMA2 .LT. EPS .AND. RMB2 .LT. EPS) THEN
          WRITE(*,*)'FREAL: ma = mb = 0 cannot be handled !'
          F = 0D0
        ELSEIF(RMA2 .LT. EPS) THEN
          F = - 1D0 + DLOG( RMB2 )
        ELSEIF(DABS(RMA2-RMB2) .LT. EPS) THEN
          F =         DLOG( RMB2 )
        ELSE
          F = - 1D0 + ( RMA2*DLOG(RMA2)-RMB2*DLOG(RMB2) )/(RMA2-RMB2)
        ENDIF
        F = - F
        IF(RMA2 .LT. EPS) THEN
          IF(DABS(S-RMB2) .LT. EPS) THEN
            F = F + DLOG(S) - 2D0
          ELSE
            F = F + DLOG(S) - 1D0 + RMB2/S*DLOG(RMB2/S) - RMB2/S -
     +        ( (RMB2/S-1D0)*DLOG(DABS(RMB2/S-1D0)) - (RMB2/S-1D0) )
          ENDIF
        ELSE
          S0   = - .5D0*( 1D0 + RMA2/S - RMB2/S )
          S1   =   .5D0*( 1D0 - RMA2/S + RMB2/S )
          DISCR= ( (S+RMA2-RMB2)**2 - 4D0*RMA2*S ) /4D0/S**2
          ROOTD= DSQRT( DABS( DISCR ) )
          F = F + DLOG(S) + S1*DLOG( RMB2/S ) - 2D0*S1 -
     +                      S0*DLOG( RMA2/S ) + 2D0*S0
          IF(DISCR .GE. 0D0) THEN
            IF(S.LT.RMA2 .OR. S.LT.RMB2) THEN
              F = F + ROOTD*( DLOG( (S1+ROOTD)**2*S/RMB2 )
     +                      - DLOG( (S0+ROOTD)**2*S/RMA2 ) )
            ELSE
              F = F + ROOTD*( DLOG( (S1+ROOTD)**2*S/RMB2 )
     +                      - DLOG( RMA2/S/(S0-ROOTD)**2 ) )
            ENDIF
          ELSE
            F = F + 2D0*ROOTD*( DATAN(S1/ROOTD) - DATAN(S0/ROOTD) )
          ENDIF
        ENDIF
      ELSE
        IF(RMA2 .LT. EPS .AND. RMB2 .LT. EPS) THEN
          WRITE(*,*)'FREAL: ma = mb = 0 cannot be handled !'
          F = 0D0
        ELSEIF(RMA2 .LT. EPS) THEN
          F = - 1D0 - ( 1D0-RMB2/S )*LOG( RMB2/(RMB2-S) )
        ELSE
          IF(ABS(RMA2-RMB2) .LT. EPS) THEN
            F = - 2D0
          ELSE
            F = - 1D0 - ( (RMA2-RMB2)/S - (RMA2+RMB2)/(RMA2-RMB2) )*
     +                  .5D0*LOG(RMB2/RMA2)
          ENDIF
          ROOTA = SQRT( (RMA+RMB)**2 - S )
          ROOTB = SQRT( (RMA-RMB)**2 - S )
          F = F - ROOTA*ROOTB/S*LOG( (ROOTA+ROOTB)**2/4D0/RMA/RMB )
        ENDIF
      ENDIF
      FREAL = - F
      END

c  gen_bhw104

      FUNCTION FIMAG(S,RMA,RMB)
*     --------
* Imaginary part of the function F(s,ma,mb)
      IMPLICIT REAL*8 (A-H,O-Z)

      PARAMETER (PI=3.1415926535897932D0)

      FIMAG = 0D0
      IF(S.GT.(RMA+RMB)**2) FIMAG=PI*DSQRT((S-(RMA+RMB)**2)*
     +                                     (S-(RMA-RMB)**2))/S
      END

c  gen_bhw104

      FUNCTION DFREAL(S,RM1,RM2)
*     ---------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Derivative of the real part of the function F(s,ma,mb).
      IMPLICIT REAL*8(A-H,O-Z)

      EPS = 1D-10
      IF(RM1 .LT. RM2) THEN
         RMA = RM1
         RMB = RM2
      ELSE
         RMA = RM2
         RMB = RM1
      ENDIF
      RMA2 = RMA**2
      RMB2 = RMB**2
      DIFF = RMB2 - RMA2
      IF(S.LT.EPS .AND. RMA2.LT.EPS .AND. RMB2.LT.EPS) THEN
         WRITE(*,*)'DFREAL: S = Ma = Mb = 0 cannot be handled !'
         F = 0D0
      ELSEIF(RMA2.LT.EPS .AND. RMB2.LT.EPS) THEN
         F = 1D0/S
      ELSEIF(ABS(S).LT.EPS .AND. DABS(RMA2-RMB2).LT.EPS) THEN
         F = - 1D0/6D0/RMA2
      ELSEIF(RMA2 .LT. EPS) THEN
         F = 1D0/S*( 1D0 - RMB2/S*DLOG( RMB2/DABS(RMB2-S) ) )
      ELSEIF(ABS(S) .LT. EPS) THEN
         F = 1D0/DIFF*( .5D0 - RMB2/DIFF -
     +                  RMA2*RMB2/DIFF**2*DLOG(RMB2/RMA2) )
      ELSEIF(S .LT. 0D0) THEN
         A = (RMA+RMB)**2 - S
         B = (RMA-RMB)**2 - S
         ROOTA = SQRT( A )
         ROOTB = SQRT( B )
         F = .5D0*(RMA2-RMB2)/S**2*LOG(RMB2/RMA2) + ROOTA*ROOTB/S*( (
     +       1D0/2D0/A + 1D0/2D0/B + 1D0/S )*
     +       LOG( (ROOTA+ROOTB)**2/4D0/RMA/RMB ) + 1D0/ROOTA/ROOTB )
      ELSE
         DISCR = - ( ( S + RMA2 - RMB2 )**2 - 4D0*RMA2*S )/4D0/S**2
         ROOTD = DSQRT( DABS( DISCR ) )
         SP = (   S - RMA2 + RMB2 )/2D0/S
         SM = ( - S - RMA2 + RMB2 )/2D0/S
         IF(ROOTD .LT. EPS) THEN
            F = - ( 1D0/SP - 1D0/SM ) / S
         ELSEIF(DISCR .LT. 0D0) THEN
            IF(S.LT.RMA2 .OR. S.LT.RMB2) THEN
               F =-.5D0/S/ROOTD*DLOG( (ROOTD+SP)**2/RMB2
     +                               /(ROOTD+SM)**2*RMA2 )
            ELSE
               F =-.5D0/S/ROOTD*( DLOG( (ROOTD+SP)**2*S/RMB2 )
     +                          - DLOG( RMA2/S/(SM-ROOTD)**2 ) )
            ENDIF
         ELSE
            F = 1D0/S/ROOTD*( DATAN(SP/ROOTD) - DATAN(SM/ROOTD) )
         ENDIF
         F = F * ( - S*(RMA2+RMB2) + DIFF**2 )/2D0/S**2 +
     +         1D0/S - DIFF/2D0/S**2*DLOG(RMB2/RMA2)
      ENDIF
      DFREAL = - F
      END

c  gen_bhw104

      FUNCTION PWIDTH(I)
*     ---------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* The partial width of the Z due to fermion i.
* Fermionic 2 loop effects have been taken into account using
* eq. (5.18) ref 2b and simple QED and QCD correction factors.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHFORMFA /FZV(0:NRMASS),FZA(0:NRMASS),
     +                FGV(0:NRMASS),FGA(0:NRMASS)
      COMPLEX*16 FZV,FZA,FGV,FGA
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
      Z = RMZ**2
      GZMIX  = SIGGZ(Z) / Z

      CALL FORMFS(Z,I)

      TOT = 0D0
      IF(I .EQ. 0) THEN
         FAC = 1D0
      ELSEIF(I .LE. 3) THEN
         FAC = 1D0*( 1D0 + FACQED*QF(I)**2 )
      ELSEIF(I .EQ. 9) THEN
         FAC = 3D0*( 1D0 + FACQED*QF(I)**2 )*( 1D0 + FACQCB )
      ELSE
         FAC = 3D0*( 1D0 + FACQED*QF(I)**2 )*( 1D0 + FACQCD )
      ENDIF
      IF(Z .GT. 4.D0*RMASS2(I)) THEN
         TOT = ALFA*DSQRT(1D0-4D0*RMASS2(I)/Z)*
     +      ( ( VF(I)**2 + AF(I)**2 )*( Z + 2D0*RMASS2(I) ) -
     +       6D0*RMASS2(I)*AF(I)**2 )/3.D0 * FAC
*
         TOT = TOT + FAC * 2D0/3D0*ALFA*Z*(
     +         VF(I)*( DBLE(FZV(I)) + QF(I)*GZMIX )
     +       + AF(I)*  DBLE(FZA(I)) )
      ENDIF
      PWIDTH = TOT/( 1D0 + BIGPIZ(Z) )/ RMZ
      END

c  gen_bhw104

      FUNCTION IMSIGZ(S)
*     ---------------
* Imaginary part of the 1-loop Z self-energy
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      REAL*8 IMSIGZ
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
      CW2 = 1D0 - SIN2TH
      TOT = 0D0
      DO 10 I = 0 , NRMASS
         IF(I .EQ. 0) FAC = 3D0
         IF(I .EQ. 1) FAC = 1D0
         IF(I .EQ. 4) FAC = 3D0
         IF(S .GT. 4.D0*RMASS2(I)) THEN
            TOT = TOT + DSQRT(1D0-4D0*RMASS2(I)/S)*
     +         ( ( VF(I)**2 + AF(I)**2 )*( S + 2D0*RMASS2(I) ) -
     +          6D0*RMASS2(I)*AF(I)**2 )/3.D0 * FAC
         ENDIF
   10 CONTINUE
      IF(S .GT. 4D0*RMW**2) TOT = TOT + DSQRT(1D0-4D0*RMW**2/S)*
     +       ((-10D0*S-20D0*RMW**2)*CW2**2+(2D0*RMW**2+S/4D0)*
     +             (CW2-SIN2TH)**2+3D0*RMW**2)*4.D0*AF(1)**2/3D0
      IF(S .GT. (RMH+RMZ)**2) TOT = TOT +
     +        (10D0*RMZ**2-2D0*RMH**2+S+(RMH**2-RMZ**2)**2/S)*AF(1)**2*
     +        DSQRT((1D0-(RMZ-RMH)**2/S)*(1D0-(RMZ+RMH)**2/S))/3D0
      IMSIGZ = TOT * ALFA
      END

c  gen_bhw104

      FUNCTION IMZ2(S)
*     -------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* Imaginary part of the fermionic 2-loop Z self-energy.
* eq. (5.18) ref 2b and simple QED and QCD correction factors.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      REAL*8 IMZ2
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHFORMMZ /FZVMZ(0:NRMASS),FZAMZ(0:NRMASS),
     +                FGVMZ(0:NRMASS),FGAMZ(0:NRMASS)
      COMPLEX*16 FZVMZ,FZAMZ,FGVMZ,FGAMZ
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
      Z = RMZ**2
      GZMIX  = SIGGZ(Z) / Z
      TOT = 0D0
      DO 10 I = 0 , NRMASS
*!!!=============================================
*!!! WP: Here was a BUG - fixed 30.05.2001 (WP)
*!!!         IF(S .GT. 4D0*RMASS2(I)) THEN
         IF(Z .GT. 4D0*RMASS2(I)) THEN
*!!!=============================================
            IF(I .EQ. 0) THEN
               FAC1 = 3D0*FACQED*QF(I)**2
               FAC2 = 3D0 + FAC1
            ELSEIF(I .LE. 3) THEN
               FAC1 = 1D0*FACQED*QF(I)**2
               FAC2 = 1D0 + FAC1
            ELSEIF(I .EQ. 9) THEN
               FAC1 = 3D0*( FACQED*QF(I)**2*(1D0+FACQCB) + FACQCB )
               FAC2 = 3D0 + FAC1
            ELSE
               FAC1 = 3D0*( FACQED*QF(I)**2*(1D0+FACQCD) + FACQCD )
               FAC2 = 3D0 + FAC1
            ENDIF
            TOT = TOT +
     +           RMZ**2*ALFA*DSQRT(1D0-4D0*RMASS2(I)/Z)*
     +         ( ( VF(I)**2 + AF(I)**2 )*( 1D0 + 2D0*RMASS2(I)/Z ) -
     +          6D0*RMASS2(I)/Z*AF(I)**2 )/3.D0 * FAC1
            TOT = TOT + FAC2 * 2D0/3D0*ALFA*RMZ**2*(
     +               VF(I)*( DBLE(FZVMZ(I)) + QF(I)*GZMIX )
     +             + AF(I)*  DBLE(FZAMZ(I)) )
         ENDIF
   10 CONTINUE
      TOT  = TOT * S/RMZ**2
      IMZ2 = TOT
      END

c  gen_bhw104

      FUNCTION IMSIGG(S)
*     ---------------
* Imaginary part of the 1-loop QED vacuumpolarization
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      REAL*8 IMSIGG
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
      TOT = 0D0
      FAC = 1D0
      DO 10 I = 1 , NRMASS
         IF(I .EQ. 4) FAC = 3D0
         IF(S .GT. 4D0*RMASS2(I)) TOT = TOT + FAC * QF(I)**2*
     +        DSQRT(1D0-4D0*RMASS2(I)/S)*(1D0+2D0*RMASS2(I)/S)/3D0
   10 CONTINUE
      IF(S .GT. 4D0*RMW**2) TOT = TOT -
     +         DSQRT(1D0-4D0*RMW**2/S)*(3D0/4D0+RMW**2/S)
      IMSIGG = TOT * ALFA * S
      END

c  gen_bhw104

      FUNCTION IMSGGZ(S)
*     ---------------
* Imaginary part of the 1-loop Z-gamma mixing
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      REAL*8 IMSGGZ
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
c
      CW2 = 1D0 - SIN2TH
      TOT = 0D0
      FAC = 1D0
      DO 10 I = 1 , NRMASS
         IF(I .EQ. 4) FAC = 3D0
         IF(S .GT. 4D0*RMASS2(I)) TOT = TOT - S*QF(I)*VF(I)/3D0* FAC*
     +             DSQRT(1D0-4D0*RMASS2(I)/S)*(1D0+2D0*RMASS2(I)/S)
   10 CONTINUE
      IF(S .GT. 4D0*RMW**2) TOT = TOT-S*AF(1)*DSQRT(1D0-4D0*RMW**2/S)*
     +                ( (3D0*CW2+1D0/6D0)+RMW**2/S*(4D0*CW2+4D0/3D0) )
      IMSGGZ = TOT * ALFA
      END

c  gen_bhw104

      SUBROUTINE FLBOT(QSQR,FZL9,FGL9)
*     ----------------
* W.J.P. Beenakker, F.A.Berends and S.C. van der Marck, June 14th 1989
* The left handed Z-bb and gamma-bb form factors
* see eqs (C.8),(C.9), (C.14) ff. of ref 2b.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMPLEX*16 FI(1:7),GI(1:7),ZLFIN,TOT1,TOT2,FZL9,FGL9,HELP
      COMPLEX*16 C1,C2,C3,C4,C5,C6,C7,C8,C9,C10
      COMPLEX*16 B1BAR,C0SCAL,C1PLUS,C2ZERO,C2MIN,C2PLUS
c
      SW = DSQRT( SIN2TH )
      CW2 = 1D0 - SIN2TH
      CW  = DSQRT( CW2 )
      RT = RMASS(8)
      RB = RMASS(9)
      C1 = C0SCAL(QSQR,RT,RMW,RB)
      C2 = C1PLUS(QSQR,RT,RMW,RB)
      C3 = C2MIN (QSQR,RT,RMW,RB)
      C4 = C2ZERO(QSQR,RT,RMW,RB)
      C5 = C2PLUS(QSQR,RT,RMW,RB)
      C6 = C0SCAL(QSQR,RMW,RT,RB)
      C7 = C1PLUS(QSQR,RMW,RT,RB)
      C8 = C2MIN (QSQR,RMW,RT,RB)
      C9 = C2ZERO(QSQR,RMW,RT,RB)
      C10= C2PLUS(QSQR,RMW,RT,RB)
      ZLFIN = 1D0/2D0/SIN2TH*( 2D0 + RT**2/RMW**2 )*(
     +         B1BAR(RB**2,RT,RMW) )
      FI(1) = (2D0/3D0*SIN2TH-1D0)/4D0/CW/SW * ZLFIN
      GI(1) = -1D0/6D0*ZLFIN
      HELP  = -1.5D0 + 2D0*DLOG(RMW/RT) + 4D0*C4 - 2D0*QSQR*(C5 - C3)
     +        + 4D0*QSQR*(C2-.5D0*C1)
      FI(2) = (VF(8)+AF(8))/4D0/SIN2TH*( HELP )
     +      - (VF(8)-AF(8))/4D0/SIN2TH*2D0*RT**2*C1
      GI(2) =  1D0/6D0/SIN2TH*( HELP - 2D0*RT**2*C1 )
      HELP = -1.5D0 + 12D0*C9 - 2D0*QSQR*( C10 - C8 ) + 4D0*QSQR*C7
      FI(3) = -  CW/4D0/SIN2TH/SW * HELP
      GI(3) = - 1D0/4D0/SIN2TH    * HELP
      HELP = RT**2/RMW**2*( -.75D0 + DLOG(RMW/RT) + 2D0*C4 -
     +       QSQR*( C5 - C3 ) )
      FI(4) = (VF(8)-AF(8))/4D0/SIN2TH*HELP -
     +        (VF(8)+AF(8))/4D0/SIN2TH*RT**4/RMW**2*C1
      GI(4) = 1D0/6D0/SIN2TH*( HELP - RT**4/RMW**2*C1 )
      HELP  = RT**2/RMW**2*( - .25D0 + 2D0*C9 )
      FI(5) = (SIN2TH-CW2)/8D0/SIN2TH/SW/CW*HELP
      GI(5) = - 1D0/4D0/SIN2TH*HELP
      FI(6) = - RT**2/4D0/SW/CW *C6
      GI(6) =   RT**2/4D0/SIN2TH*C6
      FI(7) = FI(6)
      GI(7) = GI(6)
      TOT1 = 0D0
      TOT2 = 0D0
      DO 10 I = 1 , 7
         TOT1 = TOT1 + FI(I)
         TOT2 = TOT2 + GI(I)
   10 CONTINUE
      FZL9 = TOT1
      FGL9 = TOT2
      END

c  gen_bhw104

      FUNCTION B0BAR(QSQR,RM1,RM2)
*     --------------
* eq. (C.15)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 DCMPLX,B0BAR
c
      IF(DABS(RM1-RM2) .GT. 1D-10) THEN
         B0BAR = 1D0 - (RM1**2+RM2**2)/(RM1**2-RM2**2)*DLOG(RM1/RM2) +
     +           DCMPLX( FREAL(QSQR,RM1,RM2) , FIMAG(QSQR,RM1,RM2) )
      ELSE
         B0BAR = DCMPLX( FREAL(QSQR,RM1,RM2) , FIMAG(QSQR,RM1,RM2) )
      ENDIF
      END

c  gen_bhw104

      FUNCTION B1BAR(QSQR,RM1,RM2)
*     --------------
* eq. (C.16)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 DCMPLX,B1BAR
c
      IF(DABS(RM1-RM2) .GT. 1D-10) THEN
         B1BAR = -.25D0 + RM1**2/(RM1**2-RM2**2)*DLOG(RM1/RM2) +
     +           ( RM2**2-RM1**2-QSQR )/2D0/QSQR*
     +            DCMPLX( FREAL(QSQR,RM1,RM2) , FIMAG(QSQR,RM1,RM2) )
      ELSE
         B1BAR = -.25D0 + .5D0 +
     +           ( RM2**2-RM1**2-QSQR )/2D0/QSQR*
     +            DCMPLX( FREAL(QSQR,RM1,RM2) , FIMAG(QSQR,RM1,RM2) )
      ENDIF
      END

c  gen_bhw104

      FUNCTION C0SCAL(QSQR,RM1,RM2,RMF)
*     ---------------
* The scalar 3 point function with equal external masses.
* eq. (5.10), (C.17)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 X(1:3),Y(1:3,1:2),HELP,AA,BB,CC,DD,FF,TOT,C0SCAL
      COMPLEX*16 SPENCF,DCMPLX
c
      AA = DCMPLX(RMF**2,0D0)
      BB = DCMPLX(QSQR,0D0)
      CC = - BB
      DD = DCMPLX(RM1**2 - RM2**2 - RMF**2,0D0)
      FF = DCMPLX(RM2**2,-1D-15)
      ALPHA = 2D0*RMF**2/QSQR/( 1D0 + DSQRT(1D0-4D0*RMF**2/QSQR) )
      X(1) = - ( DD + 2D0*AA + CC*ALPHA )/(CC+2D0*ALPHA*BB)
      X(2) = - DD/( (1D0-ALPHA)*(CC+2D0*ALPHA*BB) )
      X(3) = DD/ALPHA/(CC+2D0*ALPHA*BB)
      HELP = CDSQRT( CC**2 - 4D0*BB*( AA + DD + FF ) )
      IF(DBLE(CC) .GE. 0D0) THEN
         Y(1,1) = ( - CC - HELP )/2D0/BB
         Y(1,2) = 4D0*BB*( AA + DD + FF )/(-CC-HELP)/2D0/BB
      ELSE
         Y(1,1) = 4D0*BB*( AA + DD + FF )/(-CC+HELP)/2D0/BB
         Y(1,2) = ( - CC + HELP )/2D0/BB
      ENDIF
      HELP = CDSQRT( DD**2 - 4D0*FF*( AA + BB + CC ) )
      IF(DBLE(DD) .GE. 0D0) THEN
         Y(2,1) = ( - DD - HELP )/2D0/AA
         Y(2,2) = 4D0*FF*( AA + BB + CC )/(-DD-HELP)/2D0/AA
      ELSE
         Y(2,1) = 4D0*FF*( AA + BB + CC )/(-DD+HELP)/2D0/AA
         Y(2,2) = ( - DD + HELP )/2D0/AA
      ENDIF
      Y(3,1) = Y(2,1)
      Y(3,2) = Y(2,2)
      TOT = 0D0
      DO 20 J = 1 , 2
         DO 10 L = 1 , 3
            TOT = TOT + (-1D0)**L*(SPENCF(  X(L)     /(X(L)-Y(L,J)) )
     +                            -SPENCF( (X(L)-1D0)/(X(L)-Y(L,J)) ) )
   10    CONTINUE
   20 CONTINUE
      C0SCAL = TOT / ( CC + 2D0*ALPHA*BB )
      END

c  gen_bhw104

      FUNCTION C1PLUS(QSQR,RM1,RM2,RMF)
*     ---------------
* eq. (C.9)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 C0SCAL,HELP,B0BAR,C1PLUS
c
      HELP = DLOG(RM2/RM1) + B0BAR(QSQR,RM1,RM1) -
     +       B0BAR(RMF**2,RM1,RM2) + (RM2**2-RM1**2+RMF**2)*
     +       C0SCAL(QSQR,RM1,RM2,RMF)
      C1PLUS = HELP / ( 4D0*RMF**2 - QSQR )
      END

c  gen_bhw104

      FUNCTION C2ZERO(QSQR,RM1,RM2,RMF)
*     ---------------
* eq. (C.9)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 B0BAR,C0SCAL,C1PLUS,C2ZERO
c
      C2ZERO = .25D0*( B0BAR(QSQR,RM1,RM1) + 1D0 ) +
     +         .5D0*( RM1**2 - RM2**2 - RMF**2 )*
     +         C1PLUS(QSQR,RM1,RM2,RMF) + .5D0*RM2**2*
     +         C0SCAL(QSQR,RM1,RM2,RMF)
      END

c  gen_bhw104

      FUNCTION C2PLUS(QSQR,RM1,RM2,RMF)
*     ---------------
* eq. (C.9)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 B0BAR,B1BAR,C1PLUS,C2ZERO,HELP,C2PLUS
c
      HELP = .5D0*B0BAR(QSQR,RM1,RM1) + .5D0*( B1BAR(RMF**2,RM2,RM1)
     +       - .25D0 ) + ( RM2**2-RM1**2+RMF**2 )*
     +       C1PLUS(QSQR,RM1,RM2,RMF) - C2ZERO(QSQR,RM1,RM2,RMF)
      C2PLUS = HELP / ( 4D0*RMF**2 - QSQR )
      END

c  gen_bhw104

      FUNCTION C2MIN(QSQR,RM1,RM2,RMF)
*     --------------
* eq. (C.9)
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 HELP,B1BAR,C2ZERO,C2MIN
c
      HELP = -.5D0*( B1BAR(RMF**2,RM2,RM1) - .25D0 ) -
     +         C2ZERO(QSQR,RM1,RM2,RMF)
      C2MIN = HELP / QSQR
      END

c  gen_bhw104

      FUNCTION SPENCF(X)
*     ---------------
* Hans Kuijf, 1988
* SPENCF(X) calcs the complex spence-function, through mapping on
* the area where there is a quickly convergent series.
      REAL*8 PI
      COMPLEX*16 X, SPENC, SPENCF
c
      PI=4D0*DATAN(1D0)
* Map the x on the unit circle.
* But so that x is not in the neighbourhood of (1,0)
* ABS(Z)=-CDLOG(1D0-X) is always smaller than 1.10
* But (1.10)^19/(19!)*bernoulli(19)=2.7D-15
      IF (CDABS(1D0-X).LT.1D-13) THEN
        SPENCF=PI*PI/6D0
      ELSE IF (CDABS(1D0-X).LT.0.5D0) THEN
        SPENCF=PI*PI/6D0-CDLOG(1D0-X)*CDLOG(X)-SPENC(1D0-X)
      ELSE IF (CDABS(X).GT.1D0) THEN
        SPENCF=-PI*PI/6D0-0.5D0*CDLOG(-X)*CDLOG(-X)-SPENC(1D0/X)
      ELSE
        SPENCF = SPENC(X)
      END IF
      END

c  gen_bhw104

      FUNCTION SPENC(X)
      COMPLEX*16 X,SUM,Z,Z2,SPENC
c
      Z=-CDLOG(1D0-X)
      Z2=Z*Z
* Horner's rule for the powers z^3 through z^19
      SUM=43867D0/798D0
      SUM=SUM*Z2/342D0-3617D0/510D0
      SUM=SUM*Z2/272D0+7D0/6D0
      SUM=SUM*Z2/210D0-691D0/2730D0
      SUM=SUM*Z2/156D0+5D0/66D0
      SUM=SUM*Z2/110D0-1D0/30D0
      SUM=SUM*Z2/ 72D0+1D0/42D0
      SUM=SUM*Z2/ 42D0-1D0/30D0
      SUM=SUM*Z2/ 20D0+1D0/6D0
* The first three terms of the power series
      SUM=Z2*Z*SUM/6D0-0.25D0*Z2+Z
      SPENC=SUM
      END

c  gen_bhw104

* --- From here on: general purpose routines from other authors.

      FUNCTION DILOG(X)
*     --------------
      IMPLICIT REAL*8(A-H,O-Z)
c
      Z=-1.644934066848226D0
      IF(DABS(X-1.D0) .LE. 1.D-17) THEN
         DILOG=1.644934066848226D0
      ELSE
         IF(X.LE.-1.D0 .OR. X.GT.2.D0)THEN
            IF(X.GT.2.D0) Z=3.289868133696453D0
            T=1.D0/X
            S=-0.5D0
            Z=Z-0.5D0*DLOG(DABS(X))**2
         ELSEIF(X .LE. 0.5D0)THEN
            T=X
            S=0.5D0
            Z=0.D0
         ELSEIF(X .LE. 2.D0)THEN
            T=1.D0-X
            S=-0.5D0
            Z=1.644934066848226D0-DLOG(X)*DLOG(DABS(T))
         ENDIF
         Y=2.666666666666667D0*T+0.666666666666667D0
         B=      0.000000000000001D0
         A=Y*B  +0.000000000000004D0
         B=Y*A-B+0.000000000000011D0
         A=Y*B-A+0.000000000000037D0
         B=Y*A-B+0.000000000000121D0
         A=Y*B-A+0.000000000000398D0
         B=Y*A-B+0.000000000001312D0
         A=Y*B-A+0.000000000004342D0
         B=Y*A-B+0.000000000014437D0
         A=Y*B-A+0.000000000048274D0
         B=Y*A-B+0.000000000162421D0
         A=Y*B-A+0.000000000550291D0
         B=Y*A-B+0.000000001879117D0
         A=Y*B-A+0.000000006474338D0
         B=Y*A-B+0.000000022536705D0
         A=Y*B-A+0.000000079387055D0
         B=Y*A-B+0.000000283575385D0
         A=Y*B-A+0.000001029904264D0
         B=Y*A-B+0.000003816329463D0
         A=Y*B-A+0.000014496300557D0
         B=Y*A-B+0.000056817822718D0
         A=Y*B-A+0.000232002196094D0
         B=Y*A-B+0.001001627496164D0
         A=Y*B-A+0.004686361959447D0
         B=Y*A-B+0.024879322924228D0
         A=Y*B-A+0.166073032927855D0
         A=Y*A-B+1.935064300869969D0
         DILOG=S*T*(A-B)+Z
      ENDIF
      END

c  gen_bhw104

      FUNCTION HADRQQ(S)
C  HADRONIC IRREDUCIBLE QQ SELF-ENERGY: TRANSVERSE
C     parametrize the real part of the photon self energy function
C     by  a + b ln(1+C*|S|) , as in my 1981 TASSO note but using
C     updated values, extended using RQCD up to 100 TeV
C     for details see:
C     H.Burkhardt, F.Jegerlehner, G.Penso and C.Verzegnassi
C     in CERN Yellow Report on "Polarization at LEP" 1988
C               H.BURKHARDT, CERN/ALEPH, AUGUST 1988
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 HADRQQ
C
      DATA A1,B1,C1/   0.0   ,   0.00835,  1.0   /
      DATA A2,B2,C2/   0.0   ,   0.00238,  3.927 /
      DATA A3,B3,C3/ 0.00165 ,   0.00300,  1.0   /
      DATA A4,B4,C4/ 0.00221 ,   0.00293,  1.0   /
C
c      DATA PI/3.141592653589793/
      DATA ALFAIN/137.0359895D0/,INIT/0/
C
      IF(INIT.EQ.0) THEN
        INIT=1
        ALFA=1./ALFAIN
      ENDIF
      T=ABS(S)
      IF(T.LT.0.3**2) THEN
        REPIAA=A1+B1*LOG(1.+C1*T)
      ELSEIF(T.LT.3.**2) THEN
        REPIAA=A2+B2*LOG(1.+C2*T)
      ELSEIF(T.LT.100.**2) THEN
        REPIAA=A3+B3*LOG(1.+C3*T)
      ELSE
        REPIAA=A4+B4*LOG(1.+C4*T)
      ENDIF
C     as imaginary part take -i alfa/3 Rexp
      HADRQQ=REPIAA-(0.,1.)*ALFA/3.*REXP(S)
      END

c  gen_bhw104

      FUNCTION REXP(S)
C  HADRONIC IRREDUCIBLE QQ SELF-ENERGY: IMAGINARY
      IMPLICIT REAL*8(A-H,O-Z)
C     continuum R = Ai+Bi W ,  this + resonances was used to calculate
C     the dispersion integral. Used in the imag part of HADRQQ
      PARAMETER (NDIM=18)
      DIMENSION WW(NDIM),RR(NDIM),AA(NDIM),BB(NDIM)
c
      DATA WW/1.,1.5,2.0,2.3,3.73,4.0,4.5,5.0,7.0,8.0,9.,10.55,
     .  12.,50.,100.,1000.,10 000.,100 000./
      DATA RR/0.,2.3,1.5,2.7,2.7,3.6,3.6,4.0,4.0,3.66,3.66,3.66,
     .   4.,3.87,3.84, 3.79, 3.76,    3.75/
      DATA INIT/0/
c
      IF(INIT.EQ.0) THEN
        INIT=1
C       calculate A,B from straight lines between R measurements
        BB(NDIM)=0.
        DO 4 I=1,NDIM
          IF(I.LT.NDIM) BB(I)=(RR(I)-RR(I+1))/(WW(I)-WW(I+1))
          AA(I)=RR(I)-BB(I)*WW(I)
    4   CONTINUE
      ENDIF
      REXP=0.D0
      IF(S.GT.0.D0) THEN
        W=DBLE(SQRT(S))
        IF(W.GT.WW(1)) THEN
          DO 2 I=1,NDIM
C           find out between which points of the RR array W is
            K=I
            IF(I.LT.NDIM) THEN
              IF(W.LT.WW(I+1)) GOTO 3
            ENDIF
    2     CONTINUE
    3     CONTINUE
          REXP=AA(K)+BB(K)*W
        ENDIF
      ENDIF
      END

c  gen_bhw104

      FUNCTION ZBRENT(FUNC,X1,X2,TOL)
*     ---------------
* Ref.: William H. Press et.al., Numerical Recipes,
*       Cambridge Univ. Press, 1987.
* Using Brent's method,  find the root of a function FUNC known to
* lie between X1 and X2. The root, returned as ZBRENT, will be refined
* untill its accuracy is TOL.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER ( ITMAX=100 , EPS=3D-8 )
      EXTERNAL FUNC
c
      A  = X1
      B  = X2
      FA = FUNC(A)
      FB = FUNC(B)
      IF(FB*FA.GT.0D0) THEN
*       Root is not bracketed. Return the value closest to 0.
        WRITE(*,'(A)')' ZBRENT: the root is not bracketed.'
        ZBRENT = A
        IF ( ABS(FB) .LT. ABS(FA) ) ZBRENT = B
        RETURN
      ENDIF
      FC = FB
      DO 10 ITER=1,ITMAX
        IF(FB*FC.GT.0D0) THEN
*         Rename A,B,C and adjust bounding interval D.
          C = A
          FC= FA
          D = B-A
          E = D
        ENDIF
        IF(ABS(FC).LT.ABS(FB)) THEN
          A =B
          B =C
          C =A
          FA=FB
          FB=FC
          FC=FA
        ENDIF
        TOL1=2D0*EPS*ABS(B)+0.5D0*TOL
        XM=.5D0*(C-B)
*       Convergence check:
        IF(ABS(XM).LE.TOL1 .OR. DABS(FB).LT.1D-20) GOTO 999
        IF(ABS( E).GE.TOL1 .AND. ABS(FA).GT.ABS(FB)) THEN
*         Attempt inverse quadratic interpolation
          S=FB/FA
          IF(DABS(A-C).LT.1D-20) THEN
            P=2.*XM*S
            Q=1D0-S
          ELSE
            Q=FA/FC
            R=FB/FC
            P=S*(2.*XM*Q*(Q-R)-(B-A)*(R-1D0))
            Q=(Q-1D0)*(R-1D0)*(S-1D0)
          ENDIF
          IF(P.GT.0D0) Q=-Q
*         Check whether in bounds
          P=ABS(P)
          IF(2D0*P .LT. MIN(3D0*XM*Q-ABS(TOL1*Q),ABS(E*Q))) THEN
*           Accept interpolation
            E=D
            D=P/Q
          ELSE
*           Interpolation failed, use bisection.
            D=XM
            E=D
          ENDIF
        ELSE
*         Bounds decreasing too slowly, use bisection.
          D=XM
          E=D
        ENDIF
*       Move last guess to A
        A=B
        FA=FB
        IF(ABS(D) .GT. TOL1) THEN
*         Evaluate new trial root
          B=B+D
        ELSE
          B=B+SIGN(TOL1,XM)
        ENDIF
        FB=FUNC(B)
   10 CONTINUE
      WRITE(*,'(A,2G18.8)')' ZBRENT exceeding maximum iterations.',A,B
  999 ZBRENT=B
      END

c  gen_bhw104

      FUNCTION DGAUSS(F,A,B,EPS)
C.----------------------------------------------------------------------
C.
C.    GAUSS INTEGRAL OF THE FUNCTION F IN INTERVAL A,B
C.    LAST UPDATE: 12/03/87
C.
C.----------------------------------------------------------------------
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION W(12),X(12)
      EXTERNAL F

      DATA CONST/1.E-12/
      DATA W
     &/0.101228536290376, 0.222381034453374, 0.313706645877887,
     & 0.362683783378362, 0.027152459411754, 0.062253523938648,
     & 0.095158511682493, 0.124628971255534, 0.149595988816577,
     & 0.169156519395003, 0.182603415044924, 0.189450610455069/
      DATA X
     &/0.960289856497536, 0.796666477413627, 0.525532409916329,
     & 0.183434642495650, 0.989400934991650, 0.944575023073233,
     & 0.865631202387832, 0.755404408355003, 0.617876244402644,
     & 0.458016777657227, 0.281603550779259, 0.095012509837637/
C--
C--   INITIALISE
      DELTA=CONST*ABS(A-B)
      DGAUSS=0.
      AA=A
C--
C--   ITERATION LOOP
   10 Y=B-AA
C--
C--   EPSILON REACHED ??
      IF (ABS(Y).LE.DELTA) RETURN
   20 BB=AA+Y
      C1=0.5*(AA+BB)
      C2=C1-AA
      S8=0.
      S16=0.
      DO 30 I=1,4
         U=X(I)*C2
   30 S8=S8+W(I)*(F(C1+U)+F(C1-U))
      DO 40 I=5,12
         U=X(I)*C2
   40 S16=S16+W(I)*(F(C1+U)+F(C1-U))
      S8=S8*C2
      S16=S16*C2
      IF (ABS(S16-S8).GT.EPS*(1.0+ABS(S16))) GOTO 50
      DGAUSS=DGAUSS+S16
      AA=BB
      GOTO 10
   50 Y=0.5*Y
      IF (ABS(Y).GT.DELTA) GOTO 20
      WRITE (6,9000)
      DGAUSS=0.
      RETURN
 9000 FORMAT(1H ,'****** DGAUSS... TOO HIGH ACCURACY REQUIRED ******')
      END

c  gen_bhw104

      SUBROUTINE BAREAD
*
*     Routine to set input values by FFREAD.         27/04/88   DAM
*
      REAL*8 EB,XMZ,S2W,XMH,XMT,THMIN,THMAX,XKMAX,WMAX,XK0
      REAL*4 X(10)
      COMMON /BHINPUT1 / EB
      COMMON /BHINPUT2 / XMZ,S2W,XMH,XMT
      COMMON /BHINPUT3 / THMIN,THMAX,XKMAX
      COMMON /BHNEVCOM / NEVENT
      COMMON /BHWMXCOM / WMAX
      COMMON /BHXK0COM / XK0
      COMMON /BHREJCOM / IREJEC
      COMMON /BHDBCOM  / IFLDB
*
      COMMON /BHCFREAD / SPACE(1000)
c
*     CALL FFINIT(1000)
*     CALL FFSET('SIZE',6)
*     CALL FFSET('LOUT',6)
*     CALL FFSET('LINP',3)
*
*.... Conversion to REAL*4 for FFREAD
      X(1) = EB
      X(2) = XMZ
      X(3) = XMT
      X(4) = XMH
      X(5) = THMIN
      X(6) = THMAX
      X(7) = XK0
      X(8) = XKMAX
      X(9) = WMAX
*
*     CALL FFKEY( 'EB'     , X(1) ,1,'REAL')
*     CALL FFKEY( 'XMZ'    , X(2) ,1,'REAL')
*     CALL FFKEY( 'XMT'    , X(3) ,1,'REAL')
*     CALL FFKEY( 'XMH'    , X(4) ,1,'REAL')
*     CALL FFKEY( 'THMIN'  , X(5) ,1,'REAL')
*     CALL FFKEY( 'THMAX'  , X(6) ,1,'REAL')
*     CALL FFKEY( 'XK0'    , X(7) ,1,'REAL')
*     CALL FFKEY( 'XKMAX'  , X(8) ,1,'REAL')
*     CALL FFKEY( 'NEVENT' , NEVENT ,1,'INTEGER ')
C
*     CALL FFKEY( 'IREJEC'  , IREJEC ,1,'INTEGER ')
*     CALL FFKEY( 'WMAX'    , X(9)   ,1,'REAL')
*     CALL FFKEY( 'IFLDB'   , IFLDB  ,1,'INTEGER ')
*
*     CALL FFGO
*
*.... Then back to REAL*8
      EB    = X(1)
      XMZ   = X(2)
      XMT   = X(3)
      XMH   = X(4)
      THMIN = X(5)
      THMAX = X(6)
      XK0   = X(7)
      XKMAX = X(8)
      WMAX  = X(9)
*
      RETURN
      END

c  gen_bhw104

      SUBROUTINE SETUPS(E,XMZ,XGZ,SW2,XMH,XMT,XK0)
C
C   VIRTUAL AND SOFT PHOTON CORRECTIONS TO
C   BHABHA SCATTERING , QED CORRECTIONS + WEAK CORRECTIONS
C
C     (CORRECTED VERSION, 15 NOV 85)
C
      IMPLICIT REAL*8(A-Z)
      INTEGER I,J,IIN,IUT
      DIMENSION MF(6,2),VF(6,2),M(6,2),VF2(6,2),AF2(6,2)
      COMMON /BHBOS/    MZ,MW,MH
      COMMON /BHLEPT/   ME,MMU,MTAU
     .       /BHHAD/    MU,MD,MS,MC,MB,MT
     .       /BHCOUP/   SW,CW,V,A,VU,AU,VD,AD
     .       /BHWIDTH/  GZ
     .       /BHALF/    AL,ALPHA,ALFA
     .       /BHFERMI/  MF,VF,M,VF2,AF2
     .       /BHCONV/   CST
      COMMON /BHSVLCOM/ SVALUE,DEL
      COMMON /BHUNICOM /IIN,IUT
C
      CALL OUTCRY('SETUPS')
C
C START OF THE INPUT DATA AND ARGUMENT TRANSFER
C
C THE TOTAL INVARIANT MASS SQUARED
      SVALUE=4.*E*E
C
C MASS OF THE Z0
      MZ=XMZ
C
C SIN**2 OF THE ELECTROWEAK MIXING ANGLE
      SW=SW2
C
C MASS OF THE W BOSON
      CW=1.-SW
      MW=MZ*DSQRT(CW)
C
C MASS OF THE HIGGS BOSON
      MH=XMH
C
C MASSES OF THE FERMIONS: LEPTONS...
      ME=.511D-3
      MMU=.106D0
      MTAU=1.785D0
C
C ...AND QUARKS (THE TOP QUARK MASS IS STILL A FREE PARAMETER)
      MU=.032D0
      MD=.0321D0
      MS=.15D0
      MC=1.5D0
      MB=4.5D0
      MT=XMT
C
C PUT THE MASSES IN ARRAY FORM
      MF(1,1)=0.D0
      MF(2,1)=0.D0
      MF(3,1)=0.D0
      MF(1,2)=ME
      MF(2,2)=MMU
      MF(3,2)=MTAU
      MF(4,1)=MU
      MF(4,2)=MD
      MF(5,1)=MC
      MF(5,2)=MS
      MF(6,1)=MT
      MF(6,2)=MB
C
C THE COUPLING CONSTANTS
      SW1=DSQRT(SW)
      CW1=DSQRT(CW)
      A=-1.D0/(4.D0*SW1*CW1)
      V=(1.D0-4.D0*SW)*A
      VU=(8.D0/3.D0*SW-1.D0)*A
      VD=(1.D0-4.D0/3.D0*SW)*A
      AU=-A
      AD=A
C
C PUT THE COUPLING CONSTANTS IN ARRAY FORM
      VF(1,1)=-A
      VF(2,1)=-A
      VF(3,1)=-A
      VF(1,2)=V
      VF(2,2)=V
      VF(3,2)=V
      VF(4,1)=VU
      VF(5,1)=VU
      VF(6,1)=VU
      VF(4,2)=VD
      VF(5,2)=VD
      VF(6,2)=VD
C
C SQUARES OF COUPLINGS AMD MASSES
      DO 1 I=1,6
        DO 1 J=1,2
          M(I,J)=MF(I,J)**2
          VF2(I,J)=VF(I,J)**2
          AF2(I,J)=A*A
    1 CONTINUE
C
C KINEMATICAL VARIABLES : E IS THE BEAM ENERGY IN GEV
      W=2.D0*E
      S=W*W
      E=W/2.D0
C
C MAXIMUM ENERGY OF THE SOFT PHOTON, AS FRACTION OF THE BEAM ENERGY
      DEL=XK0
C
C NUMERICAL CONSTANTS
      ALFA=1./137.0359895D0
      PI=3.1415926536D0
      AL=ALFA/PI
      ALPHA=AL/4.
      CST=ALFA*ALFA/4.D0/S*389385.7D03
C
C END OF THE INPUT STEP
C
C CALCULATE THE Z0 WIDTH:
    3 A2=A*A
      MTZ=(MT/MZ)**2
!WP   GZ=IMSZ(MZ**2)/MZ
!WP   XGZ=GZ
!WP: Z-width from BHWIDE
      GZ=XGZ
      WRITE(IUT,1001) XGZ
 1001 FORMAT(' SETUPS : I FOUND A TOTAL Z0 WIDTH OF ',F10.4,' GEV'/,
     . ' ',50('-'))
!WP      SETUPS=0.
      RETURN
      END

c  gen_bhw104

      SUBROUTINE GBOX(S,T,V1S,V2S,A1S,A2S,V1T,V2T,A1T,A2T)
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 VS,VT,AS,AT,CPI,MST,MSU,MTS,MTU
c
      PI=3.1415926536D0
      CPI=DCMPLX(0.D0,PI)
      LST=DLOG(-T/S)
      U=-S-T
      LSU=DLOG(-U/S)
      MST=.5D0*S/(S+T)*(LST+CPI)
     1  -.25D0*S*(S+2.D0*T)/(S+T)**2*(LST**2+2.D0*CPI*LST)
      MSU=.5D0*S/(S+U)*(LSU+CPI)
     1  -.25D0*S*(S+2.D0*U)/(S+U)**2*(LSU**2+2.D0*CPI*LSU)
      LTS=-LST
      LTU=DLOG(T/U)
      MTS=.5D0*T/(S+T)*(LTS-CPI)
     1  -.25D0* T*(T+2.D0*S)/(S+T)**2*(LTS**2-2.D0*CPI*LTS)
      MTU=-.5D0*T/(T+U)*LTU
     1  -.25D0*T*(T+2.D0*U)/(T+U)**2*(LTU**2+PI**2)
      VS=MST-MSU+2.D0*CPI*LTU
      VT=MTS-MTU+2.D0*LST*(LSU+CPI)
      AS=MST+MSU
      AT=MTS+MTU
      PI2=2.D0*PI
C
      V1S=DBLE(VS)
      V2S=DIMAG(VS)/PI2
      A1S=DBLE(AS)
      A2S=DIMAG(AS)/PI2
      V1T=DBLE(VT)
      V2T=DIMAG(VT)/PI2
      A1T=DBLE(AT)
      A2T=DIMAG(AT)/PI2
      RETURN
      END

c  gen_bhw104

*DECK,GZBOX
      SUBROUTINE GZBOX(S,T,V1ZS,V2ZS,A1ZS,A2ZS,V1ZT,V2ZT,A1ZT,A2ZT)
       IMPLICIT REAL*8(A-Z)
       COMPLEX*16 VS,VT,AS,AT,M,ABOX,     CPI,SPENCE,
     1            LMSS,LMSM,VST,VSU,AST,ASU,VTS,VTU,
     2            ATS,ATU,LMT,LMTM
       COMMON /BHBOS/MZ,MW,MH
       COMMON /BHWIDTH/GZ

       U=-S-T
       XM2=MZ*MZ
       YM2=-MZ*GZ
       M=DCMPLX(XM2,YM2)
       PI=3.1415926536D0
       CPI=DCMPLX(0.D0,PI)
       PI2=2.D0*PI
       AST=ABOX(S,T)
       ASU=ABOX(S,U)
       ATS=ABOX(T,S)
       ATU=ABOX(T,U)
       LMSS=CDLOG((M-S)/S)
       LMSM=CDLOG(M/(M-S))
       LMTM=CDLOG(M/(M-T))
       LMT=CDLOG((M-T)/S)
       VST=AST+  (SPENCE((M+T)/T)+   LMSM*DLOG(-T/S))*2.D0
       VSU=ASU+  (SPENCE((M+U)/U)+   LMSM*DLOG(-U/S))*2.D0
       VTS=ATS+  (SPENCE((M+S)/S)+   LMTM*DLOG(-S/T))*2.D0
       VTU=ATU+  (SPENCE((M+U)/U)+   LMTM*(DLOG(U/T)+CPI))*2.D0
C
       VS=VST-VSU-   DLOG(U/T)*LMSS*2.D0
       VT=VTS-VTU+   (DLOG(-U/S)+CPI)*LMT*2.D0
       AS=AST+ASU
       AT=ATS+ATU
C
       V1ZS=DBLE(VS)
       A1ZS=DBLE(AS)
       V1ZT=DBLE(VT)
       A1ZT=DBLE(AT)
       V2ZS=DIMAG(VS)/PI2
       A2ZS=DIMAG(AS)/PI2
       V2ZT=DIMAG(VT)/PI2
       A2ZT=DIMAG(AT)/PI2
       RETURN
       END

c  gen_bhw104

*DECK,ABOX
      FUNCTION ABOX(S,T)
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 ABOX,SPENCE,M,KLAM1,KLAM2,A
      COMMON /BHBOS/   MZ,MW,MH
      COMMON /BHWIDTH/ GZ
c
      XMZ=MZ*MZ
      YMZ=-MZ*GZ
      M=DCMPLX(XMZ,YMZ)
      KLAM1=SPENCE(S/M)-SPENCE(-T/M)
     1     +CDLOG(-T/M)*CDLOG((M-S)/(M+T))
      KLAM2=CDLOG(T/(S-M))+M/S*CDLOG((M-S)/M)
      A=(S+2.D0*T+M)/(S+T)*KLAM1+KLAM2
      ABOX=A*(S-M)/(S+T)
      RETURN
      END

c  gen_bhw104

*DECK,PIG
      FUNCTION PIG(S)
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 PIG,CPI,IPIL,IPIH,IPIT,PII
      COMMON /BHLEPT/ ME,MMU,MTAU
      COMMON /BHHAD/  MU,MD,MS,MC,MB,MT
     1       /BHALF/  AL,ALPHA,ALFA
     2       /BHBOS/  MZ,MW,MH
c
      PI=3.1415926536D0
      CPI=DCMPLX(0.D0,PI)
      QU=4.D0/3.D0
      QD=1.D0/3.D0
C  SQUARE OF QUARK CHARGES INCLUDING COLOUR FAKTOR 3
      X=DABS(S)
      W=DSQRT(X)
      L1=   DLOG(W/ME)*2.D0
      L2= -(1.D0+2.D0*MMU**2/S) *BH_F(S,MMU,MMU)+2.D0
      L3= -(1.D0+2.D0*MTAU**2/S)*BH_F(S,MTAU,MTAU)+2.D0
      H1= -(1.D0+2.D0*MU**2/S)*BH_F(S,MU,MU)+2.D0
      H2= -(1.D0+2.D0*MD**2/S)*BH_F(S,MD,MD)+2.D0
      H3= -(1.D0+2.D0*MS**2/S)*BH_F(S,MS,MS)+2.D0
      H4= -(1.D0+2.D0*MC**2/S)*BH_F(S,MC,MC)+2.D0
      H5= -(1.D0+2.D0*MB**2/S)*BH_F(S,MB,MB)+1.D0/3.D0
      H6= -(1.D0+2.D0*MT**2/S)*BH_F(S,MT,MT)+1.D0/3.D0
      PIL=(L1+L2+L3-5.D0)*AL/3.D0
      PIH=(QU*(H1+H4+H6-10.D0/3.D0)+QD*(H2+H3+H5-10.D0/3.D0))*AL/3.D0
C   GAUGE AND HIGGS PART
      PIW=(3.D0+4.D0*MW*MW/S)*BH_F(S,MW,MW)-2.D0/3.D0
      PIW= ALPHA*PIW
      PIR=PIL+PIH+PIW
      IPIL=-CPI*AL
      IPIH=-CPI*(2.D0*QU+3.D0*QD)
      MTH=4.D0*MT*MT
      IF(S.LT.MTH) GOTO 5
      SQ=DSQRT(1.D0-MTH/S)
      IPIT=-CPI*SQ*(1.D0+MTH/2.D0/S)*QU
      IPIH=(IPIH+IPIT)*AL/3.D0
      PII=IPIL+IPIH
      PIG=DCMPLX(PIR,0.D0)+PII
      GOTO 7
    5 IF(S.LT.0.) GOTO 6
      PII= IPIL+IPIH *AL/3.D0
      PIG=DCMPLX(PIR,0.D0)+PII
      GOTO 7
    6 PIG=DCMPLX(PIR,0.D0)
    7 RETURN
      END

c  gen_bhw104

*DECK,F
      DOUBLE PRECISION FUNCTION BH_F(Y,A,B)
c
      IMPLICIT REAL*8(A-Z)

      IF(A.LT.1.0D-05) GO TO 50
      F1=2.D0
      IF(A.EQ.B) GO TO 10
      F1=1.D0+((A*A-B*B)/Y-(A*A+B*B)/(A*A-B*B))*DLOG(B/A)
   10 CONTINUE
      Q=(A+B)*(A+B)
      P=(A-B)*(A-B)
      IF(Y.LT.P) GO TO 20
      IF(Y.GE.Q) GO TO 30
      F2=DSQRT((Q-Y)*(Y-P))*(-2.D0)*DATAN(DSQRT((Y-P)/(Q-Y)))
      GO TO 40
   20 CONTINUE
      F2=DSQRT((Q-Y)*(P-Y))*DLOG((DSQRT(Q-Y)+DSQRT(P-Y))**2/
     &                                               (4.D0*A*B))
      GO TO 40
   30 CONTINUE
      F2=DSQRT((Y-Q)*(Y-P))*(-1.D0)*DLOG((DSQRT(Y-P)+DSQRT(Y-Q))**2/
     &                                               (4.D0*A*B))
   40 CONTINUE
      BH_F=F1+F2/Y
      GO TO 70
   50 CONTINUE
      IF(Y.EQ.(B*B)) GO TO 65
      IF(Y.LT.(B*B)) GO TO 60
      BH_F=1.D0+(1.D0-B*B/Y)*DLOG(B*B/(Y-B*B))
      GO TO 70
   60 CONTINUE
      BH_F=1.D0+(1.D0-B*B/Y)*DLOG(B*B/(B*B-Y))
      GO TO 70
   65 CONTINUE
      BH_F=1.D0
   70 CONTINUE
      RETURN
      END

c  gen_bhw104

*DECK,XINT
      SUBROUTINE XINT(S,T,M1,IST,I5ST)
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 IST,I5ST,SPENCE,X1,X2,Y1,Y2,LN2,SP4,P1,P2,K1,
     1           LN,SQX,SQY,Z1,Z2,Z3,Z4,M
      COMMON /BHWIDTH/GZ
c
      XM2=M1*M1
      YM2=-M1*GZ
      M=DCMPLX(XM2,YM2)
      SQY=CDSQRT(1.D0-4.D0*M/S)
      SQX=CDSQRT(1.D0-4.D0*M/S*(1.D0+M/T))
      Y1=(1.D0+SQY)*.5D0
      Y2=(1.D0-SQY)*.5D0
      X1=(1.D0+SQX)*.5D0
      X2=(1.D0-SQX)*.5D0
      Z1=X1/(X1-Y1)
      Z2=X1/(X1-Y2)
      Z3=X2/(X2-Y1)
      Z4=X2/(X2-Y2)
      SP4=SPENCE(Z1)+SPENCE(Z2)-SPENCE(Z3)-SPENCE(Z4)
      LN=CDLOG(-Y1/Y2)
      LN2=LN*LN
      SP4=SP4/(X1-X2)
      K1=SPENCE(1.D0+T/M)-LN2-3.1415926536D0**2/6.
      P1=(2.D0*T+S+2.D0*M)/(S+T)/2.D0
      P2=(S+2.D0*T-4.D0*T*M/S+2.D0*M*M/T-2.D0*M*M/S)/(S+T)/2.D0
      I5ST=S/(S+T)*(P1*K1+.5D0*CDLOG(-T/M)+(Y2-Y1)/2.D0*LN-P2*SP4)
      IST =I5ST+2.D0*LN2+2.D0*SP4
      RETURN
      END

c  gen_bhw104

*DECK,RESZ
      FUNCTION RESZ(X)
C   REAL PART OF THE Z SELF ENERGY
      IMPLICIT REAL*8(A-Z)
      INTEGER I,J,L
      DIMENSION M(6,2),V(6,2),A(6,2),VF(6,2),MF(6,2),T(25)
      COMMON /BHBOS/MZ,M0,MH
      COMMON /BHFERMI/MF,VF,M,V,A
     1       /BHALF/AL,ALPHA,ALFA
     2       /BHCOUP/SW,CW,VL,A1,VU,AU,VD,AD
C  MF IS THE ARRAY OF FERMION MASSES, M THAT OF FERMION MASS SQUARED
C  I = FAMILY INDEX (1...6); J = 1,2 DENOTES UP AND DOWN MEMBERS
C  VF IS THE ARRAY OF CORRESPONDING VECTOR COUPLINGS
C  V,A ARE THE ARRAYS OF THE SQUARES OF V AND A COUPLINGS
c
      PI=3.1415926536D0
      GF=1.6632D-5
      Z=MZ*MZ
      W=M0*M0
      H=MH*MH
      C=CW
      S=SW
      DO 111 L=1,25,1
        T(L)=0.D0
  111 CONTINUE
      T(1)=0.D0
      C13=1.D0/3.D0
      C38=3.D0/8.D0
      DO 71 I=1,3,1
        T(1)=T(1) + (V(I,1)+A(I,1))*(X*(BH_F(X,MF(I,2),MF(I,2))-C13)-
     &       Z*(BH_F(Z,MF(I,2),MF(I,2))-C13))
   71 CONTINUE
      T(1)=T(1)*4.D0/3.D0
      T(2)=0.D0
      DO 72 I=1,3,1
        T(2)=T(2) + (V(I,2)+A(I,2))*(X*(BH_F(X,MF(I,2),MF(I,2))-C13)-
     &       Z*(BH_F(Z,MF(I,2),MF(I,2))-C13)  +
     & 2.D0 *M(I,2)*(BH_F(X,MF(I,2),MF(I,2))-BH_F(Z,MF(I,2),MF(I,2))))-
     &       C38*M(I,2)/(C*S)*(BH_F(X,MF(I,2),MF(I,2))-
     &       BH_F(Z,MF(I,2),MF(I,2)))
   72 CONTINUE
      T(2)=T(2)*4.D0/3.D0
      T(3)=0.D0
      DO 73 L=4,6,1
        DO 173 I=1,2,1
          T(3)=T(3) + (V(L,I)+A(L,I))*(X*(BH_F(X,MF(L,I),MF(L,I))-C13)-
     &         Z*(BH_F(Z,MF(L,I),MF(L,I))-C13)+
     &         2.D0*M(L,I)*(BH_F(X,MF(L,I),MF(L,I))-
     &   BH_F(Z,MF(L,I),MF(L,I))))-C38*M(L,I)*(BH_F(X,MF(L,I),MF(L,I))-
     &         BH_F(Z,MF(L,I),MF(L,I)))/(    C*S)
  173   CONTINUE
   73 CONTINUE
      T(3)=T(3)*4.D0
      T(4)=2.D0*(X-Z)/3.D0+(10.D0*X+20.D0*W)*BH_F(X,M0,M0)-
     &     (10.D0*Z+20.D0*W)*BH_F(Z,M0,M0)
      T(4)=T(4)*(-C)/(3.D0*S)
      T(5)=3.D0*W*(BH_F(X,M0,M0)-BH_F(Z,M0,M0))+(X-Z)/4D0*
     &     (1D0-DLOG(MH*MZ/W)-
     & (H+Z)/(H-Z)*DLOG(MH/MZ))+(10.D0*Z-2.D0*H+X)/4.D0*BH_F(X,MH,MZ)-
     &     (11.D0*Z-2D0*H)/4.D0*BH_F(Z,MH,MZ)
      T(5)=T(5)/(3.D0*S*C)
      T(6)=(X-Z)/6.D0+(H-Z)*(H-Z)/4.D0*(BH_F(X,MZ,MH)/X 
     &     - BH_F(Z,MZ,MH)/Z)
      T(6)=T(6)/(3.D0*S*C)
      T(7)=(X-Z)/6.D0+(2.0*W+X/4.D0)*BH_F(X,M0,M0)-(2.D0*W+Z/4.D0)*
     &     BH_F(Z,M0,M0)
      T(7)=T(7)*(C-S)*(C-S)/(3.D0*S*C)
      T(8)=0.D0
      DO 78 J=1,3,1
        T(8)=T(8)+(BH_F(Z,MF(J,2),MF(J,2))- C13)*(V(J,1)+V(J,2)+A(J,1)+
     &       A(J,2)) +(2.D0*(V(J,2)+A(J,2))- C38/(   C*S))*M(J,2)/Z*
     &       BH_F(Z,MF(J,2),MF(J,2))
   78 CONTINUE
      T(8)=T(8)*(X-Z)*(C-S)/S*4.D0/3.D0
      T(9)=0.D0
      DO 79 L=4,6,1
        DO 719 I=1,2,1
          FZLI=BH_F(Z,MF(L,I),MF(L,I))
          T(9)=T(9)+(FZLI -C13)                   *(V(L,I)+A(L,I)) +
     &         (2.D0*(V(L,I)+A(L,I))-C38/(    C*S))*M(L,I)/Z*FZLI
  719   CONTINUE
   79 CONTINUE
      T(9)=T(9)*4.D0*(X-Z)*(C-S)/S
      T(10)=(C/(3.D0*S)*(10.D0+20.D0*C)-1.D0/S-(C-S)*(C-S)/(12.D0*S*C)*
     &      (1.D0+8.D0*C))*BH_F(Z,M0,M0)
      T(10)=T(10)*(X-Z)*(C-S)/S*(-1.D0)
      T(11)=(1.D0/(12.0*S*C)*(2.D0*H/Z-11.D0)-1.D0/(12.D0*S*C)*(H-Z)*
     &      (H-Z)/(Z*Z))*BH_F(Z,MH,MZ)
      T(11)=T(11)*(X-Z)*(C-S)/S*(-1.D0)
      T(12)=(-1.D0)/(12.D0*S*C)*(2.D0*H/Z-11.D0)*(1.D0-(H+Z)/(H-Z)*
     &      DLOG(MH/MZ) - DLOG(MH*MZ/W))
      T(12)=T(12)*(X-Z)*(C-S)/S
      T(13)=(-1.D0)/(6.D0*S*C)*(H/Z*DLOG(H/W) + DLOG(Z/W)) -2.D0*C/
     &      (9.D0*S)+1.D0/(18.D0*S*C) + (C-S)*(C-S)/(18.D0*S*C)
      T(13)=T(13)*(X-Z)*(C-S)/S
      T(14)=0.D0
      DO 714 J=1,3,1
        T(14)=T(14)+(1.D0-M(J,2)/(2.D0*W))*(1.D0+BH_F(W,0.D0,MF(J,2)))-
     &   C13-
     &        0.5D0*M(J,2)*M(J,2)/(W*W)*BH_F(W,0.D0,MF(J,2))
  714 CONTINUE
      T(14)=T(14)/(3.D0*S)*(X-Z)*(C-S)/S*(-1.D0)
      T(15)=0.D0
      DO 715 L=4,6,1
        T(15)=T(15)+
     &        (1.D0-(M(L,1)+M(L,2))/(2.D0*W))*(1.D0-(M(L,1)+M(L,2))/
     &        (M(L,1)-M(L,2))*DLOG(MF(L,1)/MF(L,2))+
     &        BH_F(W,MF(L,1),MF(L,2)))-
     &        C13 -.5D0*(M(L,1)-M(L,2))*(M(L,1)-M(L,2))/(W*W)*
     &        BH_F(W,MF(L,1),MF(L,2))
  715 CONTINUE
      T(15)=T(15)/S*(X-Z)*(C-S)/S*(-1.D0)
      T(16)=(5.D0*S/(3.D0*C)-7.D0/3.D0-8.D0*C/S+1.D0/(12.D0*S)*Z/W*
     &      (Z/W-4.D0))*BH_F(W,MZ,M0)
      T(16)=T(16)*(X-Z)*(C-S)/S*(-1.D0)
      T(17)=(1.D0/S+1.D0/(12.D0*S)*H/W*(H/W-4.D0))*BH_F(W,MH,M0)-
     &      4.D0*BH_F(W,0.D0,M0)
      T(17)=T(17)*(X-Z)*(C-S)/S*(-1.D0)
      T(18)=(1.D0+8.D0*C/S-S/C+1.D0/(4.D0*S))*Z/(Z-W)*DLOG(Z/W)
      T(18)=T(18)*(X-Z)*(C-S)/S*(-1.D0)
      T(19)=(-3.D0)/(4.D0*S)*H/(H-W)*DLOG(H/W) +
     &      (17.D0/18.D0-(Z+H)/(6.0*W))/S+S/C-2.D0*C/(9.D0*S)-8.D0*C/S-
     &      44.D0/9.D0-7.D0/3.D0
      T(19)=T(19)*(X-Z)*(C-S)/S*(-1.D0)
      T(20)=0.D0
      DO 720 L=4,6,1
        T(20)=T(20)+(4.D0/3.D0+(C-S)/C*(M(L,1)-M(L,2))/(Z-W))*
     &        DLOG(M(L,1)/M(L,2))
  720 CONTINUE
      T(20)=(T(20)/(4.D0*S)+2.D0/3.D0)*(X-Z)
      RESZ=0.D0
      DO 700 I=1,20,1
        RESZ=RESZ+T(I)
  700 CONTINUE
      RESZ=RESZ*ALPHA
      RETURN
      END

c  gen_bhw104

*DECK,IMSZ

      FUNCTION IMSZ(X)
C  IMAGINARY PART OF THE Z SELF ENERGY
      IMPLICIT REAL*8(A-Z)
      INTEGER I,L
      DIMENSION MF(6,2),VF(6,2),M(6,2),V(6,2),A(6,2),T(25)
      COMMON /BHBOS/MZ,M0,MH
      COMMON /BHFERMI/MF,VF,M,V,A
     1       /BHALF/AL,ALPHA,ALFA
     2       /BHCOUP/SW,CW,VL,A1,VU,AU,VD,AD
c
      PI=3.1415926536D0
      Z=MZ*MZ
      W=M0*M0
      H=MH*MH
      S=SW
      C=CW
      DO 111 L=1,20,1
        T(L)=0.D0
  111 CONTINUE
      T(1)=0.D0
      DO 1 I=1,3,1
        T(1)=T(1) + (V(I,1)+A(I,1))*X*BH_G(X,MF(I,2),MF(I,2))
    1 CONTINUE
      T(1)=T(1)*4.D0/3.D0
      T(2)=0.D0
      DO 2 I=1,3,1
      T(2)=T(2)+(V(I,2)+A(I,2))*(X+2.D0*M(I,2))*BH_G(X,MF(I,2),MF(I,2))-
     &       3.D0*M(I,2)/(8.D0*C*S)*BH_G(X,MF(I,2),MF(I,2))
    2 CONTINUE
      T(2)=T(2)*4.D0/3.D0
      T(3)=0.D0
      DO 311 L=4,6,1
        DO 113 I=1,2,1
          T(3)=T(3) +
     &         (V(L,I)+A(L,I))*(X+2.D0*M(L,I))*BH_G(X,MF(L,I),MF(L,I))-
     &         3.D0*M(L,I)/(8.D0*C*S)*BH_G(X,MF(L,I),MF(L,I))
  113   CONTINUE
  311 CONTINUE
      T(3)=T(3)*4.D0
      T(4)=(10.D0*X+20.D0*W)*(-C)*C+3.D0*W+(2.D0*W+X/4.D0)*(C-S)*(C-S)
      T(4)=T(4)*BH_G(X,M0,M0)/(3.D0*S*C)
      T(5)=10.D0*Z-2.D0*H+X + (H-Z)*(H-Z)/X
      T(5)=T(5)*BH_G(X,MH,MZ)/(12.D0*S*C)
      IMSZ=0.D0
      DO 100 I=1,5,1
        IMSZ=IMSZ+T(I)
  100 CONTINUE
      IMSZ=IMSZ*ALPHA
      RETURN
      END

c  gen_bhw104

*DECK,G
      FUNCTION BH_G(Y,A,B)
C  IMAGINARY PART OF THE COMPLEX FUNCTION F
      IMPLICIT REAL*8(A-Z)

      PI=3.1415927
C     G(Y,M1,M2) = IM F(Y,M1,M2)
      P=(A+B)*(A+B)
      Q=(A-B)*(A-B)
      IF ( Y .LE. P ) GO TO 10
      BH_G=DSQRT(Y-P)*DSQRT(Y-Q)*PI/Y
      GO TO 20
   10 CONTINUE
      BH_G=0.0
   20 CONTINUE
      RETURN
      END

c  gen_bhw104

*DECK,RESGZ
      FUNCTION RESGZ(X)
C  REAL PART OF THE PHOTON-Z MIXING ENERGY
      IMPLICIT REAL*8(A-Z)
      INTEGER I,J,L
      DIMENSION M(6,2),V(6,2),A(6,2),VF(6,2),MF(6,2),T(20)
      COMMON /BHBOS/MZ,M0,MH
      COMMON /BHFERMI/MF,VF,M,V,A
     1       /BHALF/AL,ALPHA,ALFA
     2       /BHCOUP/SW,CW,VL,A1,VU,AU,VD,AD
C  MF IS THE ARRAY OF FERMION MASSES, M THAT OF F MASS SQUARED
C  I = FAMILY INDEX (1...6); J = 1,2 DENOTES UP AND DOWN MEMBERS
C  VF IS THE ARRAY OF CORRESPONDING VECTOR COUPLINGS
C  V,A ARE THE ARRAYS OF THE SQUARES OF V AND A COUPLINGS
c
      PI=3.1415926536D0
      GF=1.16634D-5
      Z=MZ*MZ
      W=M0*M0
      H=MH*MH
      C=CW
      S=SW
      CS=DSQRT(C*S)
      C13=1.D0/3.D0
      C38=3.D0/8.D0
      DO 333 J=1,20,1
        T(J)=0.D0
  333 CONTINUE
      T(1)=0.D0
      DO 71 I=1,3,1
        T(1)=T(1) +VF(I,2)*(X*(BH_F(X,MF(I,2),MF(I,2))-C13)+2.D0*M(I,2)*
     &       BH_F(X,MF(I,2),MF(I,2)))
   71 CONTINUE
      T(1)=T(1)*4.*C13
      T(2)=0.D0
c
      DO 72 I=4,6,1
        T(2)=T(2)+VF(I,1)*(X*(BH_F(X,MF(I,1),MF(I,1))-C13)+2.D0*M(I,1)*
     &       BH_F(X,MF(I,1),MF(I,1)))
   72 CONTINUE
c
      T(2)=T(2)*(-8.D0)/3.D0
      T(3)=0.D0
      DO 73 I=4,6,1
        T(3)=T(3)+VF(I,2)*(X*(BH_F(X,MF(I,2),MF(I,2))-C13)+2.D0*M(I,2)*
     &       BH_F(X,MF(I,2),MF(I,2)))
   73 CONTINUE
      T(3)=T(3)*4.D0*C13
      T(4)=(X*(3.D0*C+1.D0/6.D0)+W*(4.D0*C+4.D0*C13))*BH_F(X,M0,M0)/CS
      T(5)=X/(9.D0*CS)
      T(8)=0.D0
      DO 78 J=1,3,1
        T(8)=T(8)+(BH_F(Z,MF(J,2),MF(J,2))-C13)*(V(J,1)+V(J,2)+A(J,1)+
     &       A(J,2)) +(2.D0*(V(J,2)+A(J,2))-3.D0/(8.D0*C*S))*M(J,2)/Z*
     &       BH_F(Z,MF(J,2),MF(J,2))
   78 CONTINUE
      T(8)=T(8)*(-X)*CS/S*4.D0*C13
      T(9)=0.D0
      DO 79 L=4,6,1
        DO 719 I=1,2,1
          FZLI=BH_F(Z,MF(L,I),MF(L,I))
          T(9)=T(9)+( FZLI -C13)                  *(V(L,I)+A(L,I)) +
     &         (2.D0*(V(L,I)+A(L,I))-C38/(    C*S))*M(L,I)/Z*FZLI
  719   CONTINUE
   79 CONTINUE
      T(9)=T(9)*4.D0*(-X)*CS/S
      T(10)=(C/(3.D0*S)*(10.D0+20.D0*C)-1.D0/S-(C-S)**2/(12.D0*S*C)*
     &      (1.D0+8.D0*C))*BH_F(Z,M0,M0)
      T(10)=T(10)*X*CS/S
      T(11)=(1.D0/(12.D0*S*C)*(2.D0*H/Z-11.D0)-1.D0/(12.D0*S*C)*(H-Z)*
     &      (H-Z)/(Z*Z))*BH_F(Z,MH,MZ)
      T(11)=T(11)*X*CS/S
      T(12)=(-1.D0)/(12.D0*S*C)*(2.D0*H/Z-11.D0)*(1.D0-(H+Z)/(H-Z)*
     &      DLOG(MH/MZ) - DLOG(MH*MZ/W))
      T(12)=T(12)*(-X)*CS/S
      T(13)=(-1.D0)/(6.D0*S*C)*(H/Z*DLOG(H/W) + DLOG(Z/W)) -2.D0*C/
     &      (9.D0*S)+1.D0/(18.D0*S*C) + (C-S)*(C-S)/(18.D0*S*C)
      T(13)=T(13)*(-X)*CS/S
      T(14)=0.D0
      DO 714 J=1,3,1
        T(14)=T(14)+(1.D0-M(J,2)/(2.D0*W))*(1.D0+BH_F(W,0.D0,MF(J,2)))
     &  -C13-
     &        0.5D0*M(J,2)*M(J,2)/(W*W)*BH_F(W,0.D0,MF(J,2))
  714 CONTINUE
      T(14)=T(14)/(3.D0*S)*(-X)*CS/S*(-1.D0)
      T(15)=0.D0
      DO 715 L=4,6,1
        T(15)=T(15)+
     &        (1.D0-(M(L,1)+M(L,2))/(2.D0*W))*(1.D0-(M(L,1)+M(L,2))/
     &        (M(L,1)-M(L,2))*DLOG(MF(L,1)/MF(L,2))+
     &        BH_F(W,MF(L,1),MF(L,2)))-
     &        C13   -.5D0*(M(L,1)-M(L,2))*(M(L,1)-M(L,2))/(W*W)*
     &        BH_F(W,MF(L,1),MF(L,2))
  715 CONTINUE
      T(15)=T(15)/S*(-X)*CS/S*(-1.D0)
      T(16)=(5.D0*S/(3.D0*C)-7.D0*C13-8.D0*C/S+1.D0/(12.D0*S)*Z/W*
     &      (Z/W-4.D0))*BH_F(W,MZ,M0)
      T(16)=T(16)*(-X)*CS/S*(-1.D0)
      T(17)=(1.D0/S+1.D0/(12.D0*S)*H/W*(H/W-4.D0))*BH_F(W,MH,M0)-
     &      4.D0*BH_F(W,0.D0,M0)
      T(17)=T(17)*(-X)*CS/S*(-1.D0)
      T(18)=(1.D0+8.D0*C/S-S/C+1.D0/(4.D0*S))*Z/(Z-W)*DLOG(Z/W)
      T(18)=T(18)*(-X)*CS/S*(-1.D0)
      T(19)=(-3.D0)/(4.D0*S)*H/(H-W)*DLOG(H/W) +
     &      (17.D0/18.D0-(Z+H)/(6.D0*W))/S+S/C-2.D0*C/(9.D0*S)-8.D0*C/S-
     &      44.D0/9.D0-7.D0/3.D0
      T(19)=T(19)*(-X)*CS/S*(-1.D0)
      T(20)=0.D0
      DO 720 L=4,6,1
        T(20)=T(20)+(2.D0/3.D0+(M(L,1)-M(L,2))/(Z-W))*
     &        DLOG(M(L,1)/M(L,2))
CCC   T(20)=T(20)+2.D0/3.D0*DLOG(M(L,1)/M(L,2))
  720 CONTINUE
      T(20)=T(20)*(-X)/(4.D0*CS)
      RESGZ=0.D0
      DO 70 I=1,20,1
        RESGZ=RESGZ + T(I)
   70 CONTINUE
      RESGZ=RESGZ*ALPHA
      RETURN
      END

c  gen_bhw104

*DECK,IMSGZ
      FUNCTION IMSGZ(X)
C  IMAGINARY PART OF PHOTON-Z MIXING ENERGY
      IMPLICIT REAL*8(A-Z)
      INTEGER I
      DIMENSION  T(25), VF(6,2),M(6,2),V(6,2),A(6,2),MF(6,2)
      COMMON /BHBOS/MZ,M0,MH
      COMMON /BHFERMI/MF,VF,M,V,A
     1       /BHALF/AL,ALPHA,ALFA
     2       /BHCOUP/SW,CW,VL,A1,VU,AU,VD,AD

      C=CW
      S=SW
      Z=MZ*MZ
      W=M0*M0
      H=MH*MH
      PI=3.1415926536D0
      CS=DSQRT(C*S)
      C13=1.D0/3.D0
      T(1)=0.D0
      DO 1 I=1,3,1
        T(1)=T(1) + VF(I,2)*(X*BH_G(X,MF(I,2),MF(I,2))+2.D0*M(I,2)*
     &       BH_G(X,MF(I,2),MF(I,2)))
    1 CONTINUE
      T(1)=T(1)*4.D0*C13
      T(2)=0.D0
      DO 2 I=4,6,1
        T(2)=T(2) + VF(I,1)*(X*BH_G(X,MF(I,1),MF(I,1))+2.D0*M(I,1)*
     &       BH_G(X,MF(I,1),MF(I,1)))
    2 CONTINUE
      T(2)=T(2)*(-8.D0)/3.D0
      T(3)=0.D0
      DO 3 I=4,6,1
        T(3)=T(3) + VF(I,2)*(X*BH_G(X,MF(I,2),MF(I,2))+2.D0*M(I,2)*
     &       BH_G(X,MF(I,2),MF(I,2)))
    3 CONTINUE
      T(3)=T(3)*4.D0*C13
      T(4)=(X*(3.D0*C+1.D0/6.D0)+W*(4.D0*C+4.D0*C13))*BH_G(X,M0,M0)/CS
      IMSGZ=0.D0
      DO 30 I=1,4,1
        IMSGZ=IMSGZ + T(I)
   30 CONTINUE
      IMSGZ=IMSGZ*ALPHA
      RETURN
      END

c  gen_bhw104

*DECK,INFRA
      SUBROUTINE INFRA(DEL,S,T,CIR,CIR1,CIR2)
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 CIR1,M2,D1,D2,DEL2,DEL3
      COMMON /BHBOS/MZ,MW,MH
      COMMON /BHLEPT/ME,MMU,MTAU
      COMMON /BHWIDTH/GZ
     1       /BHALF/AL,ALPHA,ALFA
c
      XM2=MZ*MZ
      YM2=-MZ*GZ
      M2=DCMPLX(XM2,YM2)
      W=DSQRT(S)
      E=W/2.D0
      U=-S-T
      BE=DLOG(W/ME)*2-1.D0
      BINT=DLOG(T/U)
      DEL1=DLOG(DEL)
      D1=(S-M2)/(S-M2-S*DEL)
      D2=S/(M2-S+S*DEL)
      AD1=CDABS(D1)
      AD2=CDABS(D2)
      CIR=4.D0*AL*(BE+BINT)*DEL1
      DEL2=CDLOG(DEL*DEL*D1)
      DEL3=CDLOG(DEL*DEL*D2)
      CIR1=2.D0*AL*(BE*DEL2+BINT*DEL3)
      DEL4=DLOG(DEL*DEL*AD1)
      DEL5=DLOG(DEL*AD2)
      PHI0=DATAN((MZ**2-S)/MZ/GZ)
      PHI= DATAN((MZ**2-S+DEL*S)/MZ/GZ)
      CIR2=2.D0*AL*(BE*DEL4+2.D0*BINT*DEL5+BE*(S-MZ**2)/MZ/GZ
     1                                        *(PHI-PHI0))
      RETURN
      END

c  gen_bhw104

*DECK,SPENCE
      FUNCTION SPENCE(XX)
      IMPLICIT REAL*8(A-Z)
      INTEGER N
      COMPLEX*16 XX,X,Z,D,P,SPENCE
      DIMENSION A(19)
c
      PI=3.1415926536D0
      X=XX
      XR=DBLE(X)
      XI=DIMAG(X)
      IF(XR.NE.1.) GOTO 111
      IF(XI.EQ.0.) GOTO 20
  111 CONTINUE
C    PROJEKTION IN DEN KONVERGENZKREIS
      VOR=1.D0
      P=DCMPLX(0.D0,0.D0)
      R=DBLE(X)
      IF (R .LE. 0.5D0) GOTO 1
      P=PI*PI/6.D0- CDLOG(X)*CDLOG(1.D0-X)
      VOR=-1.D0
      X=1.D0-X
    1 CONTINUE
      B=CDABS(X)
      IF (B .LT. 1.D0) GOTO 2
      P=P - (PI*PI/6.D0+ CDLOG(-X)*CDLOG(-X)/2.D0)*VOR
      VOR=VOR*(-1.D0)
      X=1.D0/X
    2 CONTINUE
C    BERECHNUNG DER SPENCE-FUNCTION
      A(1)=1.D0
      A(2)=-0.5D0
      A(3)=1.D0/6.D0
      A(5)=-1.D0/30.D0
      A(7)=1.D0/42.D0
      A(9)=-1.D0/30.D0
      A(11)=5.D0/66.D0
      A(13)=-691.D0/2730.D0
      A(15)=7.D0/6.D0
      A(17)=-3617.D0/510.D0
      A(19)=43867.D0/798.D0
      DO 5 N=2,9,1
        A(2*N)=0.D0
    5 CONTINUE
      Z=(-1.D0)*CDLOG(1.D0-X)
      D=DCMPLX(A(19),0.D0)
      DO 10 N=1,18,1
        D=D*Z/(20.D0-N) + A(19-N)
   10 CONTINUE
      D=D*Z
      SPENCE=D*VOR + P
      GOTO 30
   20 CONTINUE
      SPENCE=PI*PI/6.D0
   30 CONTINUE
      RETURN
      END

c  gen_bhw104

*DECK,FGAM
      SUBROUTINE FGAM(S,FGVS,FGAS)
C  FORM FACTOR OF THE PHOTON
C  FGVS: VECTOR,  FGAS: AXIALVECTOR,  S = Q**2
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 FGVS,FGAS,LAM2,L2,LAM3,G1
      COMMON /BHBOS/MZ,MW,MH
      COMMON /BHCOUP/SW,CW,V,A,VU,AU,VD,AD
     1       /BHALF/AL,ALPHA,ALFA
c
C  WEAK CORRECTIONS TO PHOTON-LEPTON VERTEX
      W=V*V+A*A
      U=2.D0*V*A
      G1=.75D0/SW*LAM3(S,MW)
      L2=LAM2(S,MZ)
      FGVS=ALPHA*(W*L2+G1)
      FGAS=ALPHA*(U*L2+G1)
      RETURN
      END

c  gen_bhw104

*DECK,FZ
      SUBROUTINE BH_FZ(S,FZVS,FZAS)
C   FORMFACTOR OF THE Z BOSON
C   FZVS: VECTOR,  FZAS: AXIALVECTOR,  S = Q**2
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 FZVS,FZAS,LAM2,L2Z,L2W,LAM3,L3W
      COMMON /BHBOS/MZ,MW,MH
      COMMON /BHCOUP/SW,CW,V,A,VU,AU,VD,AD
     1       /BHALF/AL,ALPHA,ALFA
c
c  WEAK CORRECTIONS TO Z-LEPTON VERTEX
c
      L2Z=LAM2(S,MZ)
      SW1=DSQRT(SW)
      CW1=DSQRT(CW)
      L2W=LAM2(S,MW)/(8.D0*SW1*CW1*SW)
      L3W=LAM3(S,MW)*.75D0*CW1/(SW1*SW)
      V2=V*V
      A2=A*A
      W3=V2+3.D0*A2
      U3=3.D0*V2+A2
      FZVS=ALPHA*(V*W3*L2Z+L2W-L3W)
      FZAS=ALPHA*(A*U3*L2Z+L2W-L3W)
      RETURN
      END

c  gen_bhw104

*DECK,LAM2
      FUNCTION LAM2(S,M)
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 LAM2,SPENCE,      X1,X2,R3
c
      X=M*M/S
      R1=-3.5D0-2.D0*X-(2.D0*X+3.D0)*DLOG(DABS(X))
      PI=3.1415926536D0
      IF(X.LT.0.D0) GOTO 10
      L1=DLOG(1.D0+1.D0/X)
      W1=(1.D0+X)**2
      X1=DCMPLX(-1.D0/X,0.D0)
      R3=2.D0*W1*(DLOG(X)*L1-SPENCE(X1))
      R2=DBLE(R3)
      IM=3.D0+2.D0*X-2.D0*W1*L1
      RLAM=R1+R2
      ILAM=-IM*PI
      LAM2=DCMPLX(RLAM,ILAM)
      GOTO 20
   10 W1=(1.D0+X)**2
      RX2=1.D0+1.D0/X
      X2=DCMPLX(RX2,0.D0)
      PI2=PI*PI
      R3=2.D0*W1*(SPENCE(X2)-PI2/6.D0)
      R2=DBLE(R3)
      LAM2=DCMPLX(R1+R2,0.D0)
   20 RETURN
      END

c  gen_bhw104

*DECK,LAM3
      FUNCTION LAM3(S,M)
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16 CPI,LAM3
c
      X=M*M/S
C  VALID ALSO FOR S GREATER THAN 4*M**2
      IF(X.GT.0.D0) GOTO 10
      SQ=DSQRT(1.D0-4.D0*X)
      LN=DLOG((SQ+1.D0)/(SQ-1.D0))
      LN2=LN*LN
      LA3 =5.D0/6.D0-2.D0/3.D0*X+(2.D0*X+1.D0)/3.D0*SQ*LN
     1    +2.D0/3.D0*X*(X+2.D0)*LN2
      LAM3=DCMPLX(LA3,0.D0)
      GOTO 20
   10 DISC=4.D0*X-1.D0
      IF (DISC.LT.0.D0) GOTO 11
      SQ=DSQRT(DISC)
      A=DATAN(1.D0/SQ)
      A2=A*A
      LA3 =5.D0/6.D0-2.D0/3.D0*X+2.D0/3.D0*(2.D0*X+1.D0)*SQ*A
     1     -8.D0/3.D0*X*(X+2.D0)*A2
      LAM3=DCMPLX(LA3,0.D0)
      GOTO 20
   11 DISC=-DISC
      SQ=DSQRT(DISC)
      PI=3.1415926536D0
      CPI=DCMPLX(0.D0,PI)
      LN=DLOG((1.D0+SQ)/(1.D0-SQ))
      LAM3=5.D0/6.D0-2.D0*X/3.D0+(2.D0*X+1.D0)/3.D0*SQ*LN
     1    +2.D0/3.D0*X*(X+2.D0)*(LN*LN-PI*PI)
     2    -CPI*((2.D0*X+1.D0)/3.D0*SQ+2.D0*LN)
   20 RETURN
      END

c  gen_bhw104

*DECK,BOX
      SUBROUTINE BH_BOX(S,T,V1ZZS,V2ZZS,A1ZZS,A2ZZS,
     1                     V1ZZT,V2ZZT,A1ZZT,A2ZZT,
     2                     V1WS,V2WS,V1WT,V2WT)
C  HEAVY BOX DIAGRAMS
C  1:REAL PARTS,  2: IMAGINARY PARTS
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16      IST,ISU,ITS,ITU,I5ST,I5SU,I5TS,I5TU,CPI,
     1           VS,AS,VT,AT,VWS,VWT
      COMMON /BHBOS/MZ,MW,MH
      COMMON /BHWIDTH/GZ
c
      PI2=2.*3.1415926536D0
      CPI=DCMPLX(0.D0,PI2)

      CALL XINT(S,T,MZ,IST,I5ST)

      U=-S-T

      CALL XINT(S,U,MZ,ISU,I5SU)

      CALL XINT(T,S,MZ,ITS,I5TS)

      CALL XINT(T,U,MZ,ITU,I5TU)
C
      VS=IST-ISU
      AS=I5ST+I5SU
      VT=ITS-ITU
      AT=I5TS+I5TU
C
      CALL XINT(S,T,MW,IST,I5ST)

      VWS=IST+I5ST

      CALL XINT(T,S,MW,ITS,I5TS)

      VWT=ITS+I5TS
C
      V1ZZS=DBLE(VS)
      A1ZZS=DBLE(AS)
      V1ZZT=DBLE(VT)
      A1ZZT=DBLE(AT)
      V2ZZS=DIMAG(VS)/PI2
      A2ZZS=DIMAG(AS)/PI2
      V2ZZT=DIMAG(VT)/PI2
      A2ZZT=DIMAG(AT)/PI2
      V1WS=DBLE(VWS)
      V1WT=DBLE(VWT)
      V2WS=DIMAG(VWS)/PI2
      V2WT=DIMAG(VWT)/PI2
      RETURN
      END

c  gen_bhw104

*DECK,OUTCRY
      SUBROUTINE OUTCRY(STRING)
      CHARACTER*6 STRING
      COMMON /BHUNICOM / IIN,IUT
c
      WRITE(IUT,1) STRING
    1 FORMAT(' ROUTINE "',A6,'" STARTING NOW ... GO!')
      RETURN
      END

c  gen_bhw104

*DECK,POL
      SUBROUTINE POL(S,T,ALSS,ALTT,ALTS,AUSS,AUTT,AUTS,BUSS,BUTT)
      IMPLICIT REAL*8(A-H,P-Z)
      REAL*8 MZ,MH,MW
      COMPLEX*16 CHIS,CHIT
      COMMON /BHCOUP/SW,CW,V,A,VU,AU,VD,AD
      COMMON /BHBOS/ MZ,MW,MH
      COMMON /BHWIDTH/GZ
c
      GPL=DSQRT(SW/CW)
      GMI=(2D0*SW-1D0)/DSQRT(4D0*CW*SW)
      CHIS=DCMPLX(S  ,0D0)/DCMPLX(S-MZ**2,MZ*GZ)
      CHIT=DCMPLX(T,0D0)/DCMPLX(T-MZ**2,0D0)
      ALSS=.5D0*(GMI**2-GPL**2)*DBLE(DCONJG(CHIS)+CHIS)+.5D0*(GMI**4-
     $      GPL**4)*DBLE(DCONJG(CHIS)*CHIS)
      ALTT=.5D0*(GMI**2-GPL**2)*DBLE(DCONJG(CHIT)+CHIT)+.5D0*(GMI**4-
     $      GPL**4)*DBLE(DCONJG(CHIT)*CHIT)
      ALTS=.5D0*(GMI**2-GPL**2)*DBLE(DCONJG(CHIT)+CHIS)+.5D0*(GMI**4-
     $      GPL**4)*DBLE(DCONJG(CHIT)*CHIS)
      AUSS=1D0+
     $     .5D0*(GMI**2+GPL**2)*DBLE(DCONJG(CHIS)+CHIS)+.5D0*(GMI**4+
     $      GPL**4)*DBLE(DCONJG(CHIS)*CHIS)
      AUTT=1D0+
     $     .5D0*(GMI**2+GPL**2)*DBLE(DCONJG(CHIT)+CHIT)+.5D0*(GMI**4+
     $      GPL**4)*DBLE(DCONJG(CHIT)*CHIT)
      AUTS=1D0+
     $     .5D0*(GMI**2+GPL**2)*DBLE(DCONJG(CHIT)+CHIS)+.5D0*(GMI**4+
     $      GPL**4)*DBLE(DCONJG(CHIT)*CHIS)
      BUSS=1D0+
     $           GMI*GPL       *DBLE(DCONJG(CHIS)+CHIS)+      GMI**2*
     $      GPL**2 *DBLE(DCONJG(CHIS)*CHIS)
      BUTT=1D0+
     $           GMI*GPL       *DBLE(DCONJG(CHIT)+CHIT)+      GMI**2*
     $      GPL**2 *DBLE(DCONJG(CHIT)*CHIT)
      RETURN
      END

c  gen_bhw104

      FUNCTION SPOL1(S,T,POLR1)
      IMPLICIT REAL*8(A-H,P-Z)
c
      CALL POL(S,T,ALSS,ALTT,ALTS,AUSS,AUTT,AUTS,BUSS,BUTT)
c
      U=-S-T
      SPOL1=-POLR1*(U*U*ALSS/S**2+U*U*ALTT/(T*T)+2D0*U*U*ALTS/(S*T))/
     $      (U*U*AUSS/S**2+U*U*AUTT/(T*T)+2D0*U*U*AUTS/(S*T)
     $       +T*T*BUSS/S**2+S*S*BUTT/(T*T))
      RETURN
      END

c  gen_bhw104

      SUBROUTINE BHWID1(MODE,XPAR,NPAR)
*     *********************************
!----------------------------------------------------------------------!
!          **************************************************          !
!          *       **********************************       *          !
!          *       *      *******************       *       *          !
!          *       *      *                 *       *       *          !
!          *       *      *   B H W I D 1   *       *       *          !
!          *       *      *                 *       *       *          !
!          *       *      *******************       *       *          !
!          *       **********************************       *          !
!          **************************************************          !
!======================================================================!
!=======================     AUTHORS      =============================!
!============   S. Jadach, W. Placzek and B.F.L. Ward  ================!
!===================  VERSION 1.04    May 2001  =======================!
!======================================================================!
!                                                                      !
! Main subprogram in MC multiphoton generator for Bhabha scattering.   !
! It is multiphoton generator with Yennie-Frautschi-Suura first        !
! order exponentiation based on refs. [1-3].                           !
! Electroweak virtual and soft photon correction are taken from        !
! the program BABAMC [4,5] or the program ALIBABA [6] (the latter      !
! is recommended in this version).                                     !
! [1] S. Jadach, W. Placzek and B.F.L. Ward, UTHEP-95-1001 (Oct. 1995) !
!     hep-ph/9608412; Phys. Lett. B390 (1997) 298.                     !
! [2] S. Jadach and B.F.L. Ward,                                       !
!     Phys. Rev. D40 (1989) 3582.                                      !
! [3] S. Jadach, E. Richter-Was, B.F.L. Ward  and Z. Was,              !
!     Comput. Phys. Commun. 70 (1992) 305; TH-6230, Sept. 1991.        !
! [4] M. Bohm, A. Denner and W. Hollik,                                !
!     Nucl. Phys. B304 (1988) 687.                                     !
! [5] F.A. Berends, R. Kleiss and W. Hollik,                           !
!     Nucl. Phys. B304 (1988) 712.                                     !
! [6] W. Beenakker, F.A. Berends and S.C. van der Marck,               !
!     Nucl. Phys. B349 (1991) 323.                                     !
!                                                                      !
!----------------------------------------------------------------------!
!                 INPUT and OUTPUT of BHWID1                           !
!----------------------------------------------------------------------!
! All input and output goes through parameters in                      !
!                 CALL BHWID1(MODE,XPAR,NPAR)                          !
! and through /MOMSET/ and /WGTALL/ common blocks.                     !
! In the following we shall  briefly indicate the meaning of the       !
! above parameters/variables.                                          !
!                                                                      !
! IF( MODE =-1 ) THEN                                                  !
! ===================                                                  !
! Initialization is performed, all input parameters are transfered     !
! through XPAR and NPAR.                                               !
! In the following table we indicate the meaning of NPAR, XPAR.        !
!                                                                      !
!      Table,           Input parameters of BHWID1                     !
!----------------------------------------------------------------------!
!  Entry    Variable   Meaning                                         !
!----------------------------------------------------------------------!
!  NPAR( 1)  KeyOpt = 1000*KeyZof +100*KeyCha +10*KeyWgt +KeyRnd       !
!                    General option switch:                            !
!            KeyZof - Z-contribution switch-off:                       !
!                   =0 Z-ON (DEFAULT)                                  !
!                   =1 Z-OFF (for tests!)                              !
!            KeyCha - channel choice:                                  !
!                   =0 both s and t-channels + interferences (DEFAULT) !
!                   =1 s-channel only (for tests!)                     !
!                   =2 t-channel only (for tests!)                     !
!            KeyWgt - switch for constant, variable weight WTMOD:      !
!                   =0 WTMOD=1 useful for apparatus Monte Carlo,       !
!                      To make it more efficient the user may need     !
!                      to adjust a value of WTMAX (input parameter)    !
!                   =1 WTMOD varying, faster/safer, RECOMMENDED        !
!            KeyRnd =1,2 type of random number generator RANMAR,RANECU !
!  NPAR( 2) =KeyRad =1000*KeyEWC +100*KeyLib +10*KeyMod +KeyPia        !
!                    is option switch for ElectroWeak Radiative Corr.  !
!            KeyEWC - switching ON/OFF weak corrections:               !
!                   =0 only QED corrections included                   !
!                      (here both KeyLib =1,2 should be equivalent)    !
!                   =1 all ElectroWeak Corrections included            !
!            KeyLib - option for ElectroWeak Corrections Library:      !
!                   =1 ElectroWeak Corr. from BABAMC (obsolete)        !
!                   =2 ElectroWeak Corr. from ALIBABA, RECOMMENDED     !
!            KeyMod - type of MODEL subprogram and QED matrix element  !
!                     for hard bremsstrahlung:                         !
!                   =1 obtained by the authors (helicity amplitudes)   !
!                   =2 from CALKUL, Nucl. Phys. B206 (1982) 61.        !
!                      Checked to be in a very good agreement!         !
!            KeyPia - photon vacuum polarization switch:               !
!                   =0 OFF,                                            !
!                   =1 ON, Burkhardt et.al. 1989, as in BHLUMI 2.0x    !
!                   =2 ON, S. Eidelman, F. Jegerlehner, Z.Phys.C(1995) !
!                   =3 ON, Burkhardt and Pietrzyk 1995 (Moriond).      !
!                   NOTE: Now it works for both ALIBABA and BABAMC     !
!                         rutines as well as for KeyEWC=0!             !
!  XPAR( 1) =CMSENE Total center mass energy [GeV]                     !
!  XPAR( 2) =THMINP Minimum scattering angle [deg] for positron        !
!  XPAR( 3) =THMAXP Maximum scattering angle [deg] for positron        !
!  XPAR( 4) =THMINE Minimum scattering angle [deg] for electron        !
!  XPAR( 5) =THMAXE Maximum scattering angle [deg] for electron        !
!  XPAR( 6) =ENMINP Minimum energy [GeV] for final state positron      !
!  XPAR( 7) =ENMINE Minimum energy [GeV] for final state electron      !
!  XPAR( 8) =ACOLLI Maximum acollinearity [deg] of final state e+e-    !
!  XPAR( 9) =EPSCMS Dimensionless infrared cut on CMS energy of soft   !
!                   photons, ( E_phot > CMSENE*EPSCMS/2 )              !
!  XPAR(10) =WTMAX  Maximum Weight for rejection (if <= 0, it is reset !
!                   inside the program)                                !
!  >>> IMPOTRANT NOTE: In the case of generating UNWEIGHTED events,    !
!      the user should check in the OUTPUT if the number of            !
!      OVERWEIGHTED events and/or the fraction of the corresponding    !
!      cross section is ACCEPTABLE for his/her desired PRECISION.      !
!      If not, the value of WTMAX has to be adjusted (increased)       !
!      accordingly (making a histogram of the weight might be helpful).!
!  XPAR(11) =AMAZ   Z mass  [GeV]                                      !
!  XPAR(12) =GAMMZ  Z width [GeV]  (may be recalculated by EW library) !
!  XPAR(13) =SINW2  sin^2(theta_W) (may be recalculated by EW library) !
!  XPAR(14) =AMTOP  top quark mass  [GeV]                              !
!  XPAR(15) =AMHIG  Higgs     mass  [GeV]                              !
! Note: All the above angular limits are given with respect to the     !
!       corresponding incoming particle (positron or electron, resp.). !
!                                                                      !
! Some other parameters (like other fermion masses, alpha_s) are       !
! set up in the EW libraries (alibaba.f, babamc.f).                    !
! Note: In some cases the user may also need to adjust transfer limits !
!       (trmin and/or trmid) in routine FILBHW.                        !
!----------------------------------------------------------------------!
!                                                                      !
! ELSE IF( MODE = 0 ) THEN                                             !
! ========================                                             !
! Generation of the single Monte Carlo event.                          !
! The four momenta of the final state electron, positron and photon    !
! and of real photons are encoded in                                   !
!      COMMON / MOMSET / P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT     !
! where P1 and Q1 are four-momenta of positron and elecron beams.      !
! P2 and Q2 are four-momenta of outgoing positron and electron.        !
! The list PHOT(100,4) four-momenta contains                           !
! NPHOT four-momenta of real the photons, all in GeV.                  !
! NOTE: +z axis points along incoming e+.                              !
!                                                                      !
! The principal weight WTMOD of the event is placed in:                !
!      COMMON / WGTALL / WTMOD,WTCRUD,WTTRIG,WTSET(300)                !
! It is often of interest to use "paralel weights" from WTSET.         !
! The event weight is constructed then as WT= WTCRUD*WTTRIG*WTSET(J).  !
! Which J is alowed and what version of the QED matrix element         !
! it represents is summarized in the table below.                      !
! (Note that using "parallel weights" makes only sense for calculation !
! with variable weights, KEYWGT=1.)                                    !
! WTTRIG is a "trigger" weight (0 or 1) calculated in routine trigMC   !
! (see below) for acceptances defined by the input parameters. It is   !
! evaluated before the model weights WTSET(J) are calculated           !
! (the latter is done only for WTTRIG=1 which increases the efficiency !
! of the program).                                                     !
! To avoid unnecessary crashes of the program while using the parallel !
! weights the kinematical calculations should be protected by an       !
! appriopriate conditional statement:                                  !
! IF (WTCRUD*WTTRIG.NE.0D0) THEN ... ENDIF                             !
!                                                                      !
!              Table of WTSETS entries for BHWID1                      !
!----------------------------------------------------------------------!
!  Entry      Type of QED calculation in MODEL1                        !
!----------------------------------------------------------------------!
!  WTSET(10)    O(alpha^0)exp (YFS exponentiated)                      !
!  WTSET(11)    O(alhpa^1)exp (YFS exponentiated)                      !
!  WTSET(20)    O(alpha^0)    (non-exponentiated)                      !
!  WTSET(21)    O(alhpa^1)    (non-exponentiated)                      !
!----------------------------------------------------------------------!
! Principal weight from MODEL1 (used to calculate WTMOD) is WTSET( 1). !
! The best and default set-up for MODEL1 is:                           !
!              WTSET( 1) = WTSET(11)                                   !
!----------------------------------------------------------------------!
!  Entry      Type of QED calculation in MODEL2                        !
!----------------------------------------------------------------------!
!  WTSET(110)    O(alpha^0)exp (YFS exponentiated)                     !
!  WTSET(111)    O(alhpa^1)exp (YFS exponentiated)                     !
!  WTSET(120)    O(alpha^0)    (non-exponentiated)                     !
!  WTSET(121)    O(alhpa^1)    (non-exponentiated)                     !
!----------------------------------------------------------------------!
! Principal weight from MODEL2 (used to calculate WTMOD) is WTSET(101).!
! The best and default set-up for MODEL2 is:                           !
!              WTSET(101) = WTSET(111)                                 !
!                                                                      !
! ELSE IF( MODE = 1 ) THEN                                             !
! ========================                                             !
! The total cross section corresponding to generated series of event,  !
! i.e. resulting from MC integrartion is calculated and stored in XPAR !
! and NPAR, see table below.                                           !
!----------------------------------------------------------------------!
!  Entry    Variable   Meaning                                         !
!----------------------------------------------------------------------!
!  NPAR(10)  NEVGEN  Number of generated MC events                     !
!  NPAR(20)  IEVENT  Number of generated MC events                     !
!  XPAR(10)   XMCPB  Total x-section [pb]                              !
!  XPAR(11)    EREL  The relative error of XPAR(10)                    !
!  XPAR(12)     XMC  Total x-section [GEV**(-2)]                       !
!  XPAR(20)  SIG0PB  Crude total MC x-section [pb] which is necessary  !
!                    for rescaling histograms in run with              !
!                    weighted events.                                  !
!  XPAR(21)          =0, error of XPAR(20) is zero                     !
!  XPAR(20)    SIG0  Crude x-section as XPAR(20) but in [GeV**(-2)]    !
!----------------------------------------------------------------------!
! For constant weight option KEYWGT=0 (convevience in rescaling histos)!
! we put XPAR(20,21,22)=XPAR(10,11,12)                                 !
! For MODE=1 program is called upon many times in the process of       !
! rescaling histograms, therefore, there is no output printed          !
! in this mode.                                                        !
!                                                                      !
! ELSE IF( MODE = 2 ) THEN                                             !
! ========================                                             !
! Only in this MODE=2 in addition to filling XPAR and NPAR as for      !
! MODE=1 the values of various x-sections are printed on standard      !
! output file.                                                         !
!                                                                      !
! ENDIF                                                                !
! ====                                                                 !
!----------------------------------------------------------------------!
! Last update: 30.05.2001                   by: W. Placzek             !
!======================================================================!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( PI = 3.1415926535897932D0, ALFINV = 137.0359895D0)
      PARAMETER( ALFPI=  1D0/PI/ALFINV ,ALFA=1D0/ALFINV)
      PARAMETER( GNANOB=389.385D-30*1.D33 )
      CHARACTER*80   BXOPE,BXCLO,BXTXT,BXL1I,BXL1F,BXL2F,BXL1G,BXL2G
      PARAMETER(
     $BXOPE =  '(//1X,15(5H=====)    )',
     $BXTXT =  '(1X,1H=,                  A48,25X,    1H=)',
     $BXL1I =  '(1X,1H=,I17,                 16X, A20,A12,A7, 1X,1H=)',
     $BXL1F =  '(1X,1H=,F17.8,               16X, A20,A12,A7, 1X,1H=)',
     $BXL2F =  '(1X,1H=,F17.8, 4H  +-, F11.8, 1X, A20,A12,A7, 1X,1H=)',
     $BXL1G =  '(1X,1H=,G17.8,               16X, A20,A12,A7, 1X,1H=)',
     $BXL2G =  '(1X,1H=,G17.8, 4H  +-, F11.8, 1X, A20,A12,A7, 1X,1H=)',
     $BXCLO =  '(1X,15(5H=====)/   )'    )
      DIMENSION  XPAR(*), NPAR(*)
      COMMON / BHPAR1 / DEL,EPSCMS,THMIN,XMIVIS
      COMMON / BHPAR2 / CMSENE,AMEL
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      COMMON / BHCRUD / trmid,crufla,Zprof,sg01,sg02,sg03,sig0
      COMMON / BHTRANSR / TRAN,TRMIN,TRMAX
      COMMON / BHMOMS1  / TRANP,P1(4),P2(4),PHOT1(100,4),PHSU1(4),NPHOT1
      COMMON / BHMOMS2  / TRANQ,Q1(4),Q2(4),PHOT2(100,4),PHSU2(4),NPHOT2
      COMMON / BHMOMZ1  / AL1(50),BE1(50),WTM1(50),MK1(50)
      COMMON / BHMOMZ2  / AL2(50),BE2(50),WTM2(50),MK2(50)
      COMMON / BHMOMSET / PX1(4),QX1(4),PX2(4),QX2(4),PHOT(100,4),NPHOT
      COMMON / BHWGTALL / WTMOD,WTCRUD,WTTRIG,WTSET(300)
      COMMON / BHWGTSUP / WKP,WKQ,WTT1,WTT2,FPHS,FYFSU,FYFSD,WT3
      COMMON / BHINOUT  / NINP,NOUT
      SAVE   / BHPAR1 /, / BHPAR2 /, / BHPAR3 /, / BHTRANSR /
      SAVE   / BHMOMS1  /, / BHMOMS2  /, / BHMOMZ1  /, / BHMOMZ2 /
      SAVE   / BHMOMSET /
      SAVE   / BHWGTALL /, / BHWGTSUP /, / BHINOUT/, /BHPARZ/, /BHCRUD/
      SAVE   SVAR, WTMAX, TRMX2, EMIN, IDA,IDC, KEYWGT, KEYREM, KEYUPD
      SAVE   IDGEN, NEVGEN, IEVENT, SIG0PB
      REAL*8 DRVEC(100)
!
      IF(MODE.EQ.-1) THEN
*     ===================
! Set input parameters

      CALL FILBHW(XPAR,NPAR)

      SVAR  = CMSENE**2
! Switches/keys
      KeyOpt = NPAR(1)
      KeyCha = MOD(KeyOpt,1000)/100
! Calculate total crude x-section
      IF (KeyCha.NE.2) THEN
         Zprof = (GV**2+GA**2)**2 *SVAR**2
     $        /( (SVAR-AMAZ**2)**2 + (AMAZ*GAMMZ)**2 )
      ELSE
         Zprof = 0d0
      ENDIF
      crufla= Zprof + (SVAR/trmid)**2
      sg01  = 4*PI*ALFA**2 *Zprof*(TRMAX-trmid)/SVAR**2
      sg02  = 4*PI*ALFA**2 *(1/trmid - 1/TRMAX)
      sg03  = 4*PI*ALFA**2 *crufla*(trmid-TRMIN)/SVAR**2
      sig0  = sg01 + sg02 + sg03
      SIG0PB= sig0*GNANOB *1d3
! Maximum weight
      WTMAX  = XPAR(10)
! Important histo which remembers total x-section
      IDGEN = 1

      CALL GMONIT(  -1, IDGEN,0D0,SIG0PB*WTMAX,1D0)

!-- maximum transfer for photon angular distributions
!-- TRMX2=svar is a safe choice, for low  angles
!-- (thmin,thmax << 10mrad)
!-- it can be lowered to speed up generation (but with great care).
!--      TRMX2 = TRMAX
! (over)conservative and safe choice is TRMX2=SVAR
      TRMX2 = SVAR
!--      IF(TRMX2.GT.SVAR) TRMX2=SVAR
      EMIN = CMSENE/2D0*EPSCMS
! WEIGHT MONITORING INITIALIZATION
      IDA=50
      DO 11 I=IDA+1,IDA+20

  11  CALL GMONIT(  -1, I,0D0,1D0,1D0)

      IDC = 90
      DO 12 I=IDC+1,IDC+9

  12  CALL GMONIT(  -1, I,0D0,1D0,1D0)

      CALL GBOOK1(9001,' Total weight distribution $',60,-1D0,11D0)

      KEYWGT = MOD(KEYOPT,100)/10
      KEYREM = MOD(KEYOPT,1000)/100
      KEYUPD = MOD(KEYRAD,1000)/100
      IEVENT=0
      NEVGEN=0
      ELSEIF(MODE.EQ.0) THEN
*     ======================
      NEVGEN = NEVGEN+1
  200 CONTINUE
      IEVENT=IEVENT+1
      WT1    =0
      WT2    =0
      WT3    =0
      WT4    =0
      WT5    =0
      WT6    =0
      WTKIN  =0
      WTCRUD =0
      WTTRIG =0
!--------- Generate t-channel transfer (true one) ---------

      CALL gentra(TRMIN,TRMX2,TRAN)

!--------------------  Photon generation ------------------

      CALL MLTIBR(TRAN,TRMX2,AMEL,DEL,
     $            NPHOT1,PHOT1,PHSU1,AL1,BE1,TRANP,AMSP,MK1,WKP,WTM1)

      CALL MLTIBR(TRAN,TRMX2,AMEL,DEL,
     $            NPHOT2,PHOT2,PHSU2,AL2,BE2,TRANQ,AMSQ,MK2,WKQ,WTM2)

      IF(WKP*WKQ.EQ.0D0) GOTO 140
!-- Construct fermions, transform photons and fermions to CMS frame

      CALL KINO4(SVAR,TRAN,AMEL,AMSP,AMSQ,WT3)

      CALL GMONIT(   0,IDA+3,  WT3, 1D0,5D-4)

      IF(WT3.EQ.0D0) GOTO 140
!-- Beyond this point only events conserving four-momentum !!!
      WTKIN=1D0
!-- Manipulations on mass weights, removal of soft photons

      CALL PIATEK(CMSENE,TRMX2,AMEL,EMIN,DEL,
     $      NPHOT1,P1,P2,PHOT1,PHSU1,WTM1,WTT1,WTMR1,WCTA1,WCTB1)

      CALL PIATEK(CMSENE,TRMX2,AMEL,EMIN,DEL,
     $      NPHOT2,Q1,Q2,PHOT2,PHSU2,WTM2,WTT2,WTMR2,WCTA2,WCTB2)
c
!-- Removing photons < EPSCMS from the record
!-- Mass weight WTMR1,2 is product of mass weights for ENE>EminCM times
!-- Average weight for photons with  ENE<EminCM.
c
      CALL REMPHO(EMIN,NPHOT1,PHOT1,AL1,BE1,WTM1,MK1)

      CALL REMPHO(EMIN,NPHOT2,PHOT2,AL2,BE2,WTM2,MK2)
c
!---------- monitoring control weights
c
      CALL GMONIT(   0,IDC+1,       WCTA1, 1D0,5D-4)
      CALL GMONIT(   0,IDC+2,       WCTA2, 1D0,5D-4)
      CALL GMONIT(   0,IDC+3, WCTA1*WCTA2, 1D0,5D-4)
      CALL GMONIT(   0,IDC+4,       WCTB1, 1D0,5D-4)
      CALL GMONIT(   0,IDC+5,       WCTB2, 1D0,5D-4)
      CALL GMONIT(   0,IDC+6, WCTB1*WCTB2, 1D0,5D-4)
c
      WTM1T2 = WTMR1*WTMR2
c
      CALL GMONIT(   0,IDA+1,      WTM1T2,  2D0,5D-4)
c
      WT1 = WTMR1*WKP
      WT2 = WTMR2*WKQ
!-- Merge photons/fermion into one common block
      CALL MERGIK
!-- Crude weight before calculating a trigger weight
      WTCRUD = WT1*WT2*WT3
!-- M.C. trigger weight

      CALL trigMC(WTTRIG)

      IF (WTTRIG.EQ.0D0) GOTO 140
!----------------- YFS FORMFACTOR ----------------------
! Crude
      fPHS  = EXP( 4*ALFPI*LOG(TRMX2/AMEL**2)*LOG(1/DEL) )
! Exact
      pdel = DEL*BCUD(P1,P2,PHSU1)
      qdel = DEL*BCUD(Q1,Q2,PHSU2)
      Blogp = LOG(TRANP/AMEL**2)
      Blogq = LOG(TRANQ/AMEL**2)
      fYFSu = EXP( ALFPI*( -2*(Blogp -1)*LOG(1/pdel) +0.5*Blogp -1 ) )
      fYFSd = EXP( ALFPI*( -2*(Blogq -1)*LOG(1/qdel) +0.5*Blogq -1 ) )
      fYFSr = YFSfsu(EPSCMS)
      fYFS  = fYFSu*fYFSd*fYFSr
! Weight
      WT4 = fYFS*fPHS
      CALL GMONIT(   0,IDA+4,WT4,  1D0,5D-4)
!-- Restoring up-down interference
      CALL WTinte(WT5)
      CALL GMONIT(   0,IDA+5,WT5,  1D0,5D-4)
!-- Crude weight before including a model weight
      WTCRUD = WTCRUD*WT4*WT5
!---------------------- MODEL ----------------------------------
      CALL MODEL(1,WT6)
 140  CONTINUE
!-- Total weight
      WT  = WTCRUD*WTTRIG*WT6
!-- Monitoring model weight
      CALL GMONIT(   0,IDA+20,WT,WTMAX,RN)
      WTOVR = MAX(0D0,WT-WTMAX)
      CALL GMONIT(   0,IDA+18,  WTOVR,0D0,0D0)
      WTNEG = MIN(WT,0D0)
      CALL GMONIT(   0,IDA+19,  WTNEG,0D0,0D0)
      CALL GF1(9001,WT,1D0)
! ...Rejection according to principal weight
      IF (KEYWGT.EQ.0) THEN
        IF (WT.EQ.0D0) GOTO 200
! ...unweihgted events with WT=1
c
        CALL VARRAN(DRVEC,1)
c
        RN = DRVEC(1)
        IF(WT.LT.RN*WTMAX) GOTO 200
        WTMOD = 1
! ...WTCRUD, WTTRIG  weights are RESET to zero for control
        WTCRUD = 0
        WTTRIG = 0
      ELSE
! ...weighted events
        WTMOD  = WT
        CALL GMONIT(  0, IDGEN, SIG0PB, WTMAX,1D0)
      ENDIF
      ELSE
*     ====
      NPAR(10)= NEVGEN
      NPAR(20)= NEVGEN
      CALL GMONIT(   1,IDA+20,AWTOT,DWTOT,XNTOT )
      CALL GMONIT(   2,IDA+20,XNACC,XNNEG,XNOVE )
      NEVNEG = NINT(XNNEG)
      NEVOVE = NINT(XNOVE)
      XSMC   = SIG0  *AWTOT
      XSMCPB = SIG0PB*AWTOT
      EREL   = DWTOT
      ERMC   = XSMCPB*EREL
      XPAR(10) = XSMCPB
      XPAR(11) = EREL
      XPAR(12) = XSMC
      IF(KEYWGT.EQ.0) THEN
! ...WT=1  events, normal option...
         XPAR(20)=XSMCPB
         XPAR(21)=EREL
         XPAR(22)=XSMC
      ELSE
! ...Weighted events, additional information on x-sections
         XPAR(20)= SIG0PB
         XPAR(21)= 0D0
         XPAR(22)= SIG0
      ENDIF
! Printout only for MODE=2
      IF(MODE.EQ.1) RETURN
!=====(((
!#     CALL GPRINT(9001)
!=====)))
      WRITE(NOUT,BXOPE)
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXTXT) '  BHWIDE:        WINDOW A        '
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXL1I) NEVGEN,     ' Accepted total    ','NEVGEN','A1'
      WRITE(NOUT,BXL1I) IEVENT,     ' Raw prior reject. ','IEVENT','A2'
      WRITE(NOUT,BXL2G) XSMCPB,ERMC,' Xsec M.C. [pb]    ','XSECMC','A3'
      WRITE(NOUT,BXL1F) EREL,       ' relat. error      ','ERELMC','A4'
      WRITE(NOUT,BXL2F) AWTOT,DWTOT,' weight  M.C.      ','AWT   ','A5'
      WRITE(NOUT,BXL1I) NEVNEG,     ' WT<0              ','NEVNEG','A6'
      WRITE(NOUT,BXL1I) NEVOVE,     ' WT>WTMAX          ','NEVOVE','A7'
      WRITE(NOUT,BXL1F) WTMAX ,     ' Maximum WT        ','WWMX  ','A8'
      WRITE(NOUT,BXCLO)
! PRINT ADDITIONAL INFOS
!------------------------------------------------------------
      CALL GMONIT(   1,IDA+1, AWT1 ,DWT1 ,DUMM3)
      CALL GMONIT(   1,IDA+2, AWT2 ,DWT2 ,DUMM3)
      CALL GMONIT(   1,IDA+3, AWT3 ,DWT3 ,DUMM3)
      CALL GMONIT(   1,IDA+4, AWT4 ,DWT4 ,DUMM3)
      WRITE(NOUT,BXOPE)
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXTXT) '  BHWIDE:        WINDOW B        '
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXL2F) AWT1,DWT1  ,'WT1*WT2*T/TP*T/TQ  ','      ','B1'
      WRITE(NOUT,BXL2F) AWT3,DWT3  ,'WT3 from KINO4     ','      ','B2'
      WRITE(NOUT,BXL2F) AWT4,DWT4  ,'YFS formfac        ','WT    ','B4'
      WRITE(NOUT,BXL2F) AWTOT,DWTOT,'TOTAL              ','      ','B5'
      CALL GMONIT(   1,IDA+18, AWT18 ,RWT18 ,DUMM3)
      XWT18 = AWT18/AWTOT
      DWT18 = XWT18*RWT18
      WRITE(NOUT,BXL2F) XWT18,DWT18,'xsec/xtot: WT>WTMAX','WT    ','B6'
      CALL GMONIT(   1,IDA+19, AWT19 ,RWT19 ,DUMM3)
      XWT19 = AWT19/AWTOT
      DWT19 = XWT19*RWT19
      WRITE(NOUT,BXL2F) XWT19,DWT19,'xsec/xtot: WT<0    ','WT    ','B7'
      WRITE(NOUT,BXCLO)
! ---------------------------------------------------------------
      CALL GMONIT( 1,IDC+1,AWT1,DWT1,DUMM3)
      CALL GMONIT( 1,IDC+2,AWT2,DWT2,DUMM3)
      CALL GMONIT( 1,IDC+3,AWT3,DWT3,DUMM3)
      CALL GMONIT( 1,IDC+4,AWT4,DWT4,DUMM3)
      CALL GMONIT( 1,IDC+5,AWT5,DWT5,DUMM3)
      CALL GMONIT( 1,IDC+6,AWT6,DWT6,DUMM3)
      WRITE(NOUT,BXOPE)
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXTXT) '  BHWIDE:        WINDOW C        '
      WRITE(NOUT,BXTXT) 'Built-in average control weights.'
      WRITE(NOUT,BXTXT) 'Should equal one +- statist. err.'
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXL2F) AWT1,DWT1  ,'<WCTA1>            ','      ','C1'
      WRITE(NOUT,BXL2F) AWT2,DWT2  ,'<WCTA2>            ','      ','C2'
      WRITE(NOUT,BXL2F) AWT3,DWT3  ,'<WCTA1*WCTA2>      ','      ','C3'
      WRITE(NOUT,BXL2F) AWT4,DWT4  ,'<WCTB1>            ','      ','C4'
      WRITE(NOUT,BXL2F) AWT5,DWT5  ,'<WCTB2>            ','      ','C5'
      WRITE(NOUT,BXL2F) AWT6,DWT6  ,'<WCTB1*WCTB2>      ','      ','C6'
      WRITE(NOUT,BXCLO)
      ENDIF
*     =====
      END

c  gen_bhw104

      SUBROUTINE FILBHW(XPAR,NPAR)
*     ****************************
!----------------------------------------------------------------------!
! In this routine input parameters are set up and stored in            !
! appriopriate COMMON blocks.                                          !
!----------------------------------------------------------------------!
! Last update: 14.03.2001                   by: W. Placzek             !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (A-H,O-Z)
      DIMENSION  XPAR(*), NPAR(*)
      PARAMETER( PI = 3.1415926535897932D0, ALFINV = 137.0359895D0)
      CHARACTER*80   BXOPE,BXCLO,BXTXT,BXL1I,BXL1F,BXL2F,BXL1G,BXL2G
      PARAMETER(
     $BXOPE =  '(//1X,15(5H=====)    )',
     $BXTXT =  '(1X,1H=,                  A48,25X,    1H=)',
     $BXL1I =  '(1X,1H=,I17,                 16X, A20,A12,A7, 1X,1H=)',
     $BXL1F =  '(1X,1H=,F17.8,               16X, A20,A12,A7, 1X,1H=)',
     $BXL2F =  '(1X,1H=,F17.8, 4H  +-, F11.8, 1X, A20,A12,A7, 1X,1H=)',
     $BXL1G =  '(1X,1H=,G17.8,               16X, A20,A12,A7, 1X,1H=)',
     $BXL2G =  '(1X,1H=,G17.8, 4H  +-, F11.8, 1X, A20,A12,A7, 1X,1H=)',
     $BXCLO =  '(1X,15(5H=====)/   )'    )
      COMMON / BHTRANSR / TRAN,TRMIN,TRMAX
      COMMON / BHPAR1 / DEL,EPSCMS,THMIN,XMIVIS
      COMMON / BHPAR2 / CMSENE,AMEL
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPAR4 / THMIRP,THMARP,THMIRE,THMARE,ENMINP,ENMINE,ACOLLR
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      COMMON / BHCRUD / trmid,crufla,Zprof,sg01,sg02,sg03,sig0
! Communicates with VARRAN
      COMMON / BHRANPAR / KEYRND
      COMMON / BHINOUT  / NINP,NOUT
! Commons from BABAMC
      COMMON /BHINPUT1/EB
      COMMON /BHINPUT2/XMZ,S2W,XMH,XMT
      COMMON /BHINPUT3/TMIND,TMAXD,XKMAX
      COMMON /BHNEVCOM/ NEVT
      COMMON /BHXK0COM/ XK0
      COMMON /BHWMXCOM/ WMAX
      COMMON /BHREJCOM/ IREJEC
      COMMON /BHUNICOM/IIN,IUT
      COMMON /BHDBCOM/ IFLDB
! Commons from ALIBABA
      COMMON /BHOPTION/ IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
      COMMON /BHBOSONS/ RMZ,RMW,RMH,RMT,SIN2TH,ZWID
!--
      SAVE   /BHINOUT/, /BHRANPAR/, /BHTRANSR/, / BHCRUD /
      SAVE   /BHPAR1 /, /BHPAR2 /,  /BHPAR3 /, / BHPAR4 /, /BHPARZ/
      SAVE
      EXTERNAL dsigbo
!--
      CMSENE = XPAR(1)
      THMINP = XPAR(2)
      THMAXP = XPAR(3)
      THMINE = XPAR(4)
      THMAXE = XPAR(5)
      ENMINP = XPAR(6)
      ENMINE = XPAR(7)
      ACOLLI = XPAR(8)
      EPSCMS = XPAR(9)
      WTMAX  = XPAR(10)
! Re-set WTMAX if non-positive
      IF (WTMAX.LE.0D0) THEN
         WTMAX = 10D0
         XPAR(10) = WTMAX
      ENDIF
! Z parameters
      AMAZ  = XPAR(11)
      GAMMZ = XPAR(12)
! Weak mixing angle
      SINW2 = XPAR(13)
! Masses of top quark and Higgs boson
      AMTOP = XPAR(14)
      AMHIG = XPAR(15)
! Switches/keys
      KeyOpt = NPAR(1)
      KeyRad = NPAR(2)
      KeyRnd = MOD(KeyOpt,10)
      KeyWgt = MOD(KeyOpt,100)/10
      KeyCha = MOD(KeyOpt,1000)/100
      KeyZof = MOD(KeyOpt,10000)/1000
      KeyPia = MOD(KeyRad,10)
      KeyMod = MOD(KeyRad,100)/10
      KeyLib = MOD(KeyRad,1000)/100
      KeyEWC = MOD(KeyRad,10000)/1000
      IF (KeyCha.GT.0) THEN
        IF (KeyMod.NE.2) THEN
          KeyMod = 2
          WRITE(6,   *)'>> KeyMod reset to KeyMod =',KeyMod
          WRITE(6,   *)'>> KeyCha =',KeyCha,' works only for KeyMod =',
     &                 KeyMod,' !!!'
          KeyMod = 2
          WRITE(NOUT,*)'>> KeyMod reset to KeyMod =',KeyMod
          WRITE(NOUT,*)'>> KeyCha =',KeyCha,' works only for KeyMod =',
     &                 KeyMod,' !!!'
        ENDIF
        IF (KeyLib.NE.2) THEN
          KeyLib = 2
          WRITE(6,   *)'>> KeyLib reset to KeyLib =',KeyLib
          WRITE(6,   *)'>> KeyCha =',KeyCha,' works only for KeyLib =',
     &                 KeyLib,' !!!'
          WRITE(NOUT,*)'>> KeyLib reset to KeyLib =',KeyLib
          WRITE(NOUT,*)'>> KeyCha =',KeyCha,' works only for KeyLib =',
     &                 KeyLib,' !!!'
        ENDIF
      ENDIF
      IF (KeyZof.GT.0) THEN
        IF (KeyEWC.NE.0) THEN
          KeyEWC = 0
          WRITE(6,   *)'>> KeyEWC reset to KeyEWC =',KeyEWC
          WRITE(6,   *)'>> KeyZof =',KeyZof,' works only for KeyEWC =',
     &                 KeyEWC,' !!!'
          WRITE(NOUT,*)'>> KeyEWC reset to KeyEWC =',KeyEWC
          WRITE(NOUT,*)'>> KeyZof =',KeyZof,' works only for KeyEWC =',
     &                 KeyEWC,' !!!'
        ENDIF
      ENDIF
      KeyRad = 1000*KeyEWC +100*KeyLib +10*KeyMod +KeyPia
      IF (KeyEWC.GT.0 .AND. KeyPia.EQ.0) THEN
        WRITE(6   ,*)'>> FILBHW: Wrong KeyPia !!!, KeyPia=',KeyPia
        WRITE(6   ,*)'>> For KeyEWC >0, KeyPia must be >0 too!'
        WRITE(NOUT,*)'>> FILBHW: Wrong KeyPia !!!, KeyPia=',KeyPia
        WRITE(NOUT,*)'>> For KeyEWC >0, KeyPia must be >0 too!'
        STOP
      ENDIF
!--------------------------------------------------
! Electron mass and s-variable
      AMEL = 0.5111D-3
      SVAR = CMSENE**2
! Angles in radians
      DEGRAD = PI/180D0
      THMIRP = THMINP *DEGRAD
      THMARP = THMAXP *DEGRAD
      THMIRE = THMINE *DEGRAD
      THMARE = THMAXE *DEGRAD
      ACOLLR = ACOLLI *DEGRAD
! Find the minimum transfer for M.C. generation
      THMIN  = DMIN1(THMIRP,THMIRE)
      Ene    = CMSENE/2D0
      XEMINP = ENMINP/Ene
      XEMINE = ENMINE/Ene
cc      xmivis = DMIN1(XEMINP,XEMINE)
cc      xmivis = xmivis**2
      xmivis = XEMINP*XEMINE
      AMER   = AMEL/Ene
      beteli = DSQRT(1 - AMER**2)
      betelf = DSQRT(1 - AMER**2/xmivis)
! Minimum transfer in LL approx.
      TRMILL = SVAR*xmivis*(1 -beteli*betelf*COS(THMIN))/2 -2*AMEL**2
! Safe value of minimum transfer for MC generation
      trmin  = 0.5*TRMILL
! Find some intermediate transfer (to increase efficiency of MC generation).
! For trmin < tran < trmid, transfer is generated from a flat distribution.
! The choice of trmid and trmin may depend on a given case (CMS energy,
! selection criteria, etc.).
      thmid = DMAX1(THMIRP,THMIRE)
cc      trmid = trmin
cc      trmid = SVAR*xmivis*(1 -beteli*betelf*COS(thmid))/2 -2*AMEL**2
cc      trmid = SVAR*       (1 -beteli*betelf*COS(thmid))/2 -2*AMEL**2
      trmid = SVAR*(1 - COS(thmid) )/2
! Maximum transfer (safe value: TRMAX=SVAR)
      TRMAX = SVAR
      XIMIN = TRMIN/SVAR
      XIMAX = TRMAX/SVAR
! Internal soft photon cut-off (the same as in BHLUMI)
      DEL = EPSCMS*1d-2
!---------------------------------------------------------------------
! Weak couplings
      GA = -1/(4*DSQRT(SINW2*(1-SINW2)))
      GV = GA*(1-4*SINW2)
! Switch OFF Z contribution
      IF (KeyZof.EQ.1) THEN
        GA = 0
        GV = 0
      ENDIF
      AMT = AMTOP
      AMH = AMHIG
!---------------------------------------------------------------------
! Initialization of ElectroWeak Libraries (virtual+soft corrections)
      IF (KeyLib.EQ.2) THEN
!... ALIBABA routines
! NOTE: The above values of weak parameters are replaced by ones
!       calculated by ALIBABA!

        CALL INITBH(AMAZ,AMH,AMT)

        IWEAK = KeyEWC
! Weak parameters as calculated by ALIBABA
        GAMMZ = ZWID
        SINW2 = SIN2TH
        GA = -1/(4*DSQRT(SINW2*(1-SINW2)))
        GV = GA*(1-4*SINW2)
! Switch OFF Z contribution
        IF (KeyZof.EQ.1) THEN

          CALL ZbcOFF

          GA = 0
          GV = 0
        ENDIF
      ELSEIF (KeyLib.EQ.1) THEN
!... BABAMC routines
        EB  = CMSENE/2
        XMZ = AMAZ
        XGZ = GAMMZ
        XMT = AMT
        XMH = AMH
        S2W = SINW2
        TMIND = DMAX1(THMINP,THMINE)
        TMAXD = DMIN1(THMAXP,THMAXE)
        XKMAX = 1.0
        IIN = 5
        IUT = 6
        IREJEC = 0
        WMAX = 0.01
        IFLDB = 0
c
        CALL BAREAD
c
        XK0 = EPSCMS
        GVB = GV*DSQRT(4*PI/ALFINV)
        GAB = GA*DSQRT(4*PI/ALFINV)

        CALL SETUPS(EB,XMZ,XGZ,S2W,XMH,XMT,XK0)

      ELSE
        WRITE(6   ,*)'>> FILBHW: Wrong KeyLib !!!, Keylib=',KeyLib
        WRITE(NOUT,*)'>> FILBHW: Wrong KeyLib !!!, Keylib=',KeyLib
        STOP
      ENDIF
!---------------------------------------------------------------------
! Total Born cross section
      thminb = DMAX1(THMIRE,THMIRP)
      thmaxb = DMIN1(THMARE,THMARP)
      trminb = SVAR/2 *(1 -beteli**2*COS(thminb)) -2*AMEL**2
      trmaxb = SVAR/2 *(1 -beteli**2*COS(thmaxb)) -2*AMEL**2
      eeps = -1d-8
      KeyTem = KeyRad
      KeyRad = 100*KeyLib

      CALL GAUSJD(dsigbo,trminb,trmaxb,eeps,BORNXS)

      KeyRad = KeyTem
!---------------------------------------------------------------------
      WRITE(NOUT,BXOPE)
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXTXT) '  BHWIDE: INPUT PARAMETRES       '
      WRITE(NOUT,BXTXT) '*********************************'
      WRITE(NOUT,BXL1I) KeyOpt,     ' OPTIONS  Switches ','KeyOpt','N1'
      WRITE(NOUT,BXL1I) KeyZof,     ' Z Switch-OFF      ','KeyZof','  '
      WRITE(NOUT,BXL1I) KeyCha,     ' Channel   Choice  ','KeyCha','  '
      WRITE(NOUT,BXL1I) KeyWgt,     ' Weighting Switch  ','KeyWgt','  '
      WRITE(NOUT,BXL1I) KeyRnd,     ' Rand. Numb. Switch','KeyRnd','  '
      WRITE(NOUT,BXL1I) KeyRad,     ' RAD. COR. Switches','KeyRad','N2'
      WRITE(NOUT,BXL1I) KeyEWC,     ' EW Correct. Switch','KeyEWC','  '
      WRITE(NOUT,BXL1I) KeyLib,     ' EWC Libary choice ','KeyLib','  '
      WRITE(NOUT,BXL1I) KeyMod,     ' QED Mat.El. choice','KeyMod','  '
      WRITE(NOUT,BXL1I) KeyPia,     ' Vac. Pol. Switch  ','KeyPia','  '
      WRITE(NOUT,BXL1F) CMSENE,     ' CMS energy   [GeV]','CMSENE','X1'
      WRITE(NOUT,BXL1G) SVAR  ,     ' CMSENE^2   [GeV^2]','SVAR  ','  '
      WRITE(NOUT,BXL1F) THMINP,     ' Theta_Min_e+ [deg]','THMINP','X2'
      WRITE(NOUT,BXL1F) THMAXP,     ' Theta_Max_e+ [deg]','THMAXP','X3'
      WRITE(NOUT,BXL1F) THMINE,     ' Theta_Min_e- [deg]','THMINE','X4'
      WRITE(NOUT,BXL1F) THMAXE,     ' Theta_Max_e- [deg]','THMAXE','X5'
      WRITE(NOUT,BXL1F) THMIRP,     ' Theta_Min_e+ [rad]','THMIRP','  '
      WRITE(NOUT,BXL1F) THMARP,     ' Theta_Max_e+ [rad]','THMARP','  '
      WRITE(NOUT,BXL1F) THMIRE,     ' Theta_Min_e- [rad]','THMIRE','  '
      WRITE(NOUT,BXL1F) THMARE,     ' Theta_Max_e- [rad]','THMARE','  '
      WRITE(NOUT,BXL1F) ENMINP,     ' Energy_Min_e+[GeV]','ENMINP','X6'
      WRITE(NOUT,BXL1F) ENMINE,     ' Energy_Min_e-[GeV]','ENMINE','X7'
      WRITE(NOUT,BXL1F) XEMINP,     ' E_Min_e+/E_beam   ','XEMINP','  '
      WRITE(NOUT,BXL1F) XEMINE,     ' E_Min_e-/E_beam   ','XEMINE','  '
      WRITE(NOUT,BXL1F) ACOLLI,     ' Acollinearity[deg]','ACOLLI','X8'
      WRITE(NOUT,BXL1F) ACOLLR,     ' Acollinearity[rad]','ACOLLR','  '
      WRITE(NOUT,BXL1G) TRMIN ,     ' Trasf_Min [GeV^2] ','TRMIN ','  '
      WRITE(NOUT,BXL1G) TRMAX ,     ' Trasf_Max [GeV^2] ','TRMAX ','  '
      WRITE(NOUT,BXL1G) XIMIN ,     ' Xi_Min=TRMIN/SVAR ','XIMIN ','  '
      WRITE(NOUT,BXL1G) XIMAX ,     ' Xi_Max=TRMAX/SVAR ','XIMAX ','  '
      WRITE(NOUT,BXL1G) EPSCMS,     ' Soft-Photon Cut   ','EPSCMS','X9'
      WRITE(NOUT,BXL1G) DEL   ,     ' Internal Soft Cut ','DEL   ','  '
      WRITE(NOUT,BXL1F) WTMAX ,     ' Maximum Weight    ','WTMAX ','X10'
      WRITE(NOUT,BXL1F) AMAZ  ,     ' Z mass [GeV]      ','AMAZ  ','X11'
      WRITE(NOUT,BXL1F) GAMMZ ,     ' Z width [GeV]     ','GAMMZ ','X12'
      WRITE(NOUT,BXL1F) SINW2 ,     ' sin^2(theta_W)    ','SINW2 ','X13'
      WRITE(NOUT,BXL1F) AMTOP ,     ' t-quark mass [GeV]','AMTOP ','X14'
      WRITE(NOUT,BXL1F) AMHIG ,     ' Higgs   mass [GeV]','AMHIG ','X15'
      WRITE(NOUT,BXL1G) BORNXS,     ' Born Xsecion [pb] ','BORNXS','  '
      WRITE(NOUT,BXCLO)
      END

c  gen_bhw104

      SUBROUTINE gentra(TRMIN,TRMAX,TRAN)
*     ***********************************
!--------------------------------------------------------------!
! Generation of momentum transfer squared TRAN=|Q**2| for      !
! Bhabha scattering according to "crude" distribution.         !
! INPUT:  TRMIN,TRMAX  - min. and max. transfer                !
! OUTPUT: TRAN         - generated transfer                    !
!--------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995 !
! Last update: 25.05.1995         by: W.P.                     !
!--------------------------------------------------------------!
      implicit REAL*8 (a-h,o-z)
      COMMON / BHCRUD / trmid,crufla,Zprof,sg01,sg02,sg03,sig0
      SAVE   / BHCRUD /
      REAL*8 drvec(100)
!
      cu01 = sg01/sig0
      cu02 = cu01 +sg02/sig0
c
      call VARRAN(drvec,2)
c
      rn1 = drvec(1)
      rn2 = drvec(2)
      IF (rn1.LE.cu01) THEN
         TRAN = (1-rn2)*trmid + rn2*TRMAX
      ELSEIF (rn1.LE.cu02) THEN
         TRAN = 1/ ( (1-rn2)/trmid + rn2/TRMAX )
      ELSE
         TRAN = (1-rn2)*TRMIN + rn2*trmid
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE trigMC(wt)
*     *********************
!--------------------------------------------------------------!
! Trigger for wide angle Bhabha scattering: cuts imposed on    !
! positron and electron energies, angles and acollinearity.    !
! OUTPUT: wt  - weight corresponding to the above trigger      !
!--------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995 !
! Last update: 19.07.1995         by: W.P.                     !
!--------------------------------------------------------------!
      implicit REAL*8 (a-h,o-z)
      PARAMETER( PI = 3.1415926535897932d0 )
      COMMON / BHPAR4 / THMINP,THMAXP,THMINE,THMAXE,ENMINP,ENMINE,ACOLLI
      COMMON /BHMOMSET / P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT
      SAVE   / BHPAR4 /, /BHMOMSET /
      LOGICAL lanp,lane,lenp,lene,laco
!
      wt = 0
! Energy cuts
      lenp = P2(4).gt.ENMINP
      lene = Q2(4).gt.ENMINE
      IF (lenp.AND.lene) THEN
        pmod = SQRT(p2(1)**2+p2(2)**2+p2(3)**2)
        qmod = SQRT(q2(1)**2+q2(2)**2+q2(3)**2)
        costhp = p2(3)/pmod
        costhe =-q2(3)/qmod
! Angular cuts
        lanp = costhp.LE.COS(THMINP) .AND. costhp.GE.COS(THMAXP)
        lane = costhe.LE.COS(THMINE) .AND. costhe.GE.COS(THMAXE)
        IF (lanp.AND.lane) THEN
          pq = p2(1)*q2(1) + p2(2)*q2(2) + p2(3)*q2(3)
          costpe =-pq/(pmod*qmod)
! Acollinearity cut
          laco = costpe.ge.COS(ACOLLI)
          IF (laco) wt = 1
        ENDIF
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE REMPHO(EMIN,NPHOT,PHOT,ALF,BET,WTM,MK)
*     ****************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION PHOT(100,4),ALF(50),BET(50),WTM(50),MK(50)
!
      IF (NPHOT.EQ.0) RETURN
      NPH=NPHOT
c
      DO 100 J=NPHOT,1,-1
      IF(PHOT(J,4).LT.EMIN) THEN
c
         DO 60 I=J+1,NPH
           ALF(I-1)=ALF(I)
           BET(I-1)=BET(I)
           WTM(I-1)=WTM(I)
           MK( I-1)=MK( I)
c
           DO 60 K=1,4
   60      PHOT(I-1,K)=PHOT(I,K)
c
         NPH=NPH-1
      ENDIF
  100 CONTINUE
c
!.....................................................
! Correction by Alex Read and Tiziano Camporesi DELPHI
! Date: Fri, 25 Nov 94 17:50:37 WET
!      Code added by ALR 22.11.94 to fix problem with
!      photon handling. Have to erase the discarded
!      photons or they cause occasional problems in
!      MERGIK when merging the PHOT1 and PHOT2 arrays
!      (REMPHO operates on these here).
!
      DO J=NPH+1,NPHOT
         DO K=1,4
           PHOT(J,K) = 0.D0
         ENDDO
      ENDDO
!.....................................................
      NPHOT=NPH
      END

c  gen_bhw104

      SUBROUTINE PIATEK(CMSENE,TRMAX,AMEL,EMIN,DELTA,
     $         NPHOT,P1,P2,PHOT,PHSU,WMAT,WTAL,WTMRE,WCTR1,WCTR2)
C     ***************************************************************
c Input:
c        CMSENE         CMS energy
c        TRMAX          maximum transfer
c        AMEL           electron mass (GeV)
c        EMIN           CMS minimum photon energy (GeV)
c        DELTA          MC minimum photon energy (dimensionless)
c        NPHOT          photon number
c        P1,P2(4)       fermion momenta
c        PHOT(100,4)    photon four-momenta
c        PHSU(50)       sum of photon four-momenta
c        WMAT(50)       mass weights from MLTIBR
c Output:
c        WTAL       mass weight for all photons
c        WTMRE      In the case of removal the new mass weight
c        WCTR1      Control weight for delta-->epsilon rejection
c        WCTR2      control weight for photons below EMIN removal
*     ************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER(PI=3.1415926535897932D0,ALFINV=137.0359895D0)
      PARAMETER(ALF1=1/ALFINV/PI )
      DIMENSION P1(4),P2(4),WMAT(50),PHOT(100,4),PHSU(4)
C
      DATA ICONT /0/
C
      ICONT=ICONT+1
C Calculate mass weight for all photons and separately for
C photons with energy below/above EMIN
      EPSCM = 2*EMIN/CMSENE
      WTAL = 1D0
      WTM1 = 1D0
      WTM2 = 1D0
      WTEPSP=1D0
      DO 100 I=1,NPHOT
      WTAL = WTAL*WMAT(I)
      IF(WTAL.LT.1D-15) WTAL =0D0
      IF(PHOT(I,4).LT.EMIN) THEN
        WTM1 = WTM1*WMAT(I)
        IF(WTM1.LT.1D-15) WTM1=0D0
        WTEPSP = 0D0
      ELSE
        WTM2 = WTM2*WMAT(I)
        IF(WTM2.LT.1D-15) WTM2=0D0
      ENDIF
  100 CONTINUE
C Control weight for delta-->epsilon  "REJECTION"
      DELT1 = DELTA*BCUD(P1,P2,PHSU)

      CALL WFORM(TRMAX,P1,P2,AMEL,DELT1,EMIN,PDYFS)

      WCTR1 = WTEPSP*PDYFS
C control weight for photons ENE<EMIN  "REMOVAL"
      TRANP = 2D0*(P1(4)*P2(4)-P1(3)*P2(3)-P1(2)*P2(2)-P1(1)*P2(1))
      EPS1  =  SQRT(EMIN**2/P1(4)/P2(4))
      DELB2 = -2*ALF1*(DLOG(TRMAX/TRANP)+1) *DLOG(EPS1/DELT1)
      WCTR2 = WTM1*EXP(-DELB2)
C In the case of removal the new mass weight is this
      WTMRE = WTM2*EXP(DELB2)
      END

c  gen_bhw104

      FUNCTION YFSfsu(epsCMS)
*     ***********************
!-------------------------------------------------------------------!
! Yennie-Frautschi-Suura form-factor for Bhabha scattering in CMS   !
! summed over s and u channels (t-channels is already included      !
! in earlier steps of MC algorithm).                                !
! INPUT: epsCMS - soft photon limit in CMS as a fraction            !
!                 of the beam energy                                !
!-------------------------------------------------------------------!
! Written by: Wieslaw Placzek                Knoxville, Oct. 1995   !
! Last update: 04.10.1995           by: W.P.                        !
!-------------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER ( pi = 3.1415926535897932D0, alfinv = 137.0359895D0)
      PARAMETER ( alfpi = 1/alfinv/pi )
      COMMON / BHPAR2 / CMSEne,amel
      COMMON /BHMOMSET / p1(4),q1(4),p2(4),q2(4),phot(100,4),nphot
! Save value of YFSfsu for some further use
      COMMON /BHsufyfs / fofasu
      SAVE   / BHPAR2 /, /BHMOMSET /, /BHsufyfs /
!
      s = CMSEne**2
      Emin = epsCMS*CMSENE/2
      Bslog = LOG(s/amel**2)
! s-channel: initial state
      Rs  = alfpi*( 2*(Bslog -1)*LOG(epsCMS) +0.5*Bslog -1 +pi**2/3 )
! s-channel: final state
      Rs1 = finfra(p2,q2,Emin,amel) +alfpi*pi**2/2
! u-channel
      Ru  = finfra(p1,q2,Emin,amel)
      Ru1 = finfra(q1,p2,Emin,amel)
! form-factor
      fofasu = EXP(Rs + Rs1 - Ru - Ru1)
      YFSfsu = fofasu
      END

c  gen_bhw104

      FUNCTION YFSfmf(epsCMS)
*     ***********************
!-------------------------------------------------------------------!
! Total Yennie-Frautschi-Suura form-factor for Bhabha scattering    !
! in CMS.                                                           !
! INPUT: epsCMS - soft photon limit in CMS as a fraction            !
!                 of the beam energy                                !
! NOTE: Function YFSfsu should be called prior this function is     !
!       used. This is done to increase efficiency of MC generation, !
!       as YFSfsu is normally called in the earlier step of MC      !
!       algorithm and it provides a major part of the result.       !
!-------------------------------------------------------------------!
! Written by: Wieslaw Placzek                Knoxville, Oct. 1995   !
! Last update: 05.10.1995           by: W.P.                        !
!-------------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER ( pi = 3.1415926535897932D0, alfinv = 137.0359895D0)
      PARAMETER ( alfpi = 1/alfinv/pi )
      COMMON / BHPAR2 / CMSEne,amel
      COMMON /BHMOMSET / p1(4),q1(4),p2(4),q2(4),phot(100,4),nphot
! Value of YFS formfactor summed over s and u channels from YFSfsu
      COMMON /BHsufyfs / fofasu
      SAVE   / BHPAR2 /, /BHMOMSET /, /BHsufyfs /
!
      Emin = epsCMS*CMSENE/2
! t-channels form-factors
      finftp = finfra(p1,p2,Emin,amel)
      finftq = finfra(q1,q2,Emin,amel)
      fofatp = EXP(finftp)
      fofatq = EXP(finftq)
! Total YFS form-factor
      YFSfmf = fofasu*fofatp*fofatq
      END

c  gen_bhw104

      FUNCTION YFSirf(p1,q1,p2,q2,epsCMS,amel)
*     ****************************************
!-------------------------------------------------------------------!
! Yennie-Frautschi-Suura infrared factor in CMS summed over s, t    !
! and u channels (to be subtructed from O(alpha^1) virtual+soft     !
! correction in order to get function beta_0 in YFS formula).       !
! INPUT: p1,q1,p2,q2 - initial and final lepton 4-momenta           !
!        epsCMS      - soft photon limit in CMS as a fraction       !
!                      of the beam energy                           !
!        amel        - electron mass [in GeV]                       !
!-------------------------------------------------------------------!
! Written by: Wieslaw Placzek                Knoxville, Oct. 1995   !
! Last update: 04.10.1995           by: W.P.                        !
!-------------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER ( pi = 3.1415926535897932D0, alfinv = 137.0359895D0)
      PARAMETER ( alfpi = 1/alfinv/pi )
      REAL*8 p1(4),q1(4),p2(4),q2(4)
!
      Emin = epsCMS*p1(4)
      s = 2*( p1(4)*q1(4) -p1(3)*q1(3) -p1(2)*q1(2) -p1(1)*q1(1) )
      Bslog = LOG(s/amel**2)
! infrared factors for s, t, u channels
      BBs = alfpi*( 2*(Bslog -1)*LOG(epsCMS) +0.5*Bslog -1 +pi**2/3 )
      BBt = finfra(p1,p2,Emin,amel)
      BBu = finfra(p1,q2,Emin,amel)
! total infrared factor
      YFSirf = 2*(BBs + BBt - BBu)
      END

c  gen_bhw104

      FUNCTION finfra(p1,p2,Emin,amel)
*     ********************************
!-------------------------------------------------------------------!
! Yennie-Frautschi-Suura infrared factor (virtual + real soft)      !
! in CMS for t and u channels, for any pair of electrons            !
! and/or positrons.                                                 !
! To get the result for the s-channel one has to add to the result  !
! of this function only the constant term: (alpha/pi)*(pi**2/2).    !
! INPUT: p1,p2 - leptons four-momenta                               !
!        Emin  - minimum energy of hard photons in CMS [in GeV]     !
!        amel  - electron mass [in GeV]                             !
!-------------------------------------------------------------------!
! Written by: Wieslaw Placzek                Knoxville, Oct. 1995   !
! Last update: 04.10.1995           by: W.P.                        !
!-------------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER ( pi = 3.1415926535897932D0, alfinv = 137.0359895D0)
      PARAMETER ( alfpi = 1/alfinv/pi )
      REAL*8 p1(4),p2(4)
!
      E1 = p1(4)
      E2 = p2(4)
      QQ = 2*( p1(4)*p2(4) -p1(3)*p2(3) -p1(2)*p2(2) -p1(1)*p2(1) )
      Biglog = LOG(QQ/amel**2)
      eps2 = Emin**2/E1/E2
      om = E1 + E2
      de = E1 - E2
      Dt = SQRT(QQ + de**2)
      Root = (Biglog -1)*LOG(eps2) +0.5*Biglog -1
! At low angles Remn should be approximately equal to:
!           -pi**2/6,  for s, u channels;
!            0,        for t channel.
      Remn = pi**2/3 -0.5*LOG(E2/E1)**2
     &      -0.25*LOG( (Dt+de)**2/(4*E1*E2) )**2
     &      -0.25*LOG( (Dt-de)**2/(4*E1*E2) )**2
     &      -DILOGY( (Dt+om)/(Dt+de) ) -DILOGY( (Dt+om)/(Dt-de) )
     &      -DILOGY( (Dt-om)/(Dt+de) ) -DILOGY( (Dt-om)/(Dt-de) )
      finfra = alfpi*(Root + Remn)
      END

c  gen_bhw104

      SUBROUTINE WFORM(TRMAX,Q1,Q2,AMF,DELTA,EMIN,DYFS)
C     *************************************************
C For tests only.
C Yennie-Frautschi-Suura Formfactors for the single fermion pair
C This is for crude distribition before mass weights
C The triangle effect included (pi**2/6)
C     ***********************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER(PI=3.1415926535897932D0,ALFINV=137.0359895D0)
      PARAMETER(ALF1=1/ALFINV/PI )
      DIMENSION Q1(4),Q2(4)
C
C ...Momenta q1,q2 should be in CMS
      Q1Q2  = Q1(4)*Q2(4)-Q1(3)*Q2(3)-Q1(2)*Q2(2)-Q1(1)*Q2(1)
      E1 = Q1(4)
      E2 = Q2(4)
      BETF2 = 2*ALF1* DLOG(TRMAX /AMF**2)
      DELB  = BETF2*DLOG(EMIN/SQRT(E1*E2)/DELTA)
      EP    = E1+E2
      EM    = E1-E2
      DL    = SQRT( 2*Q1Q2 +EM**2 )
C Note that approximately REMN= +(1./6.)*PI**2 for t-channel
      REMN  = PI**2/2
     $        -0.50*DLOG(E1/E2)**2
     $        -0.25*DLOG((DL+EM)**2/(4*E1*E2))**2
     $        -0.25*DLOG((DL-EM)**2/(4*E1*E2))**2
     $        - DILOGY((DL+EP)/(DL+EM)) -DILOGY((DL-EP)/(DL-EM))
     $        - DILOGY((DL-EP)/(DL+EM)) -DILOGY((DL+EP)/(DL-EM))
C This (alf/pi)*pi**2/6 is related to replacing (y+z)>epsilon
C by max(y,z)>epsilon.   (Rejection delta=> epsilon over-estimated)
      TRIANG = -PI**2/6D0
      DYFS   = EXP( DELB +ALF1*REMN +ALF1*TRIANG)
      END

c  gen_bhw104

      FUNCTION BCUD(P1,P2,SF)
*     ************************
      IMPLICIT REAL*8(A-H,O-Z)
      DIMENSION P1(4),P2(4),SF(4)
C
      XPP  = P2(4)*P1(4)-P2(3)*P1(3)-P2(2)*P1(2)-P2(1)*P1(1)
      XPR  = P1(4)*(P2(4)+SF(4)) - P1(3)*(P2(3)+SF(3))
     $     - P1(2)*(P2(2)+SF(2)) - P1(1)*(P2(1)+SF(1))
      BCUD= XPR/XPP
      END

c  gen_bhw104

      SUBROUTINE MLTIBR(TRAN,TRMAX,AMEL,DEL,
     $      NPH,PHOT,PHSU,ALF1,BET1,TRANP,AMSP,MK,WT1,WTM)
*     ****************************************************
* This provides momenta of photons in a fermion proper frame
C Input : TRAN    = principal t-channel transfer     (GEV**2)
C         TRMAX   = max. transf. (>0) for angular phot. dist. [GEV**2]
C         AMEL    = electron energy         (GEV)
C         DEL     = low energy photon limit   (dimensionless)
C Output: NPH     = photon multiplicity
C         PHOT    = list of photon four-momenta
C         PHSU    = sum of photon momenta
C         ALF1,BET1   = Sudakov variables
C         TRANP   = (P2-P1)**2
C         AMSP    = (P2+PHSU)**2
C         MK      = marked photons
C         WT1     = TRANP/TRAN is Jacobian, =0 outside ph.sp.
C         WTM     = list of mass weights
*     ************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER (PI=3.1415926535897932D0, ALFINV=137.0359895D0)
      PARAMETER (NMAX=20)
      DIMENSION PHOT(100,4),PHSU(4),PH(4)
      DIMENSION MK(50),WTM(50)
      DIMENSION ALF(50),BET(50),ALF1(50),BET1(50),Y(50),Z(50)
      DIMENSION RR(100),P2(4)
      DOUBLE PRECISION DRVEC(100)
      DATA ICONT /0/

      ICONT=ICONT+1

      DELS  = AMEL**2/TRMAX
      BILGS = LOG(TRMAX/AMEL**2)
      DELL  = LOG(DEL)
      WT1    = 1D0
      DO  11 I=1,50
      DO  11 K=1,4
   11 PHOT(I,K)=0D0
      AVERG=2D0/(PI*ALFINV)*BILGS*LOG(1D0/DEL)

      CALL POISSG(AVERG,NMAX,NPH,RR)

      IF(NPH.GT.NMAX) GOTO 900
* No photon
      DO 45 K=1,4
   45 PHSU(K)=0D0
      IF(NPH.EQ.0) THEN
        TRANP=TRAN
      ELSE
* One or more photons
   50   CALL VARRAN(DRVEC,NPH)
        BSUM=0D0
        DO 80 I=1,NPH
* We define R=LOG(MAX(YGR,ZET))
        R=DELL*RR(I)
* Photons close to lower infrared boundry are marked for tests
        MK(I)=0
        IF(EXP(R).LT.DEL*3D0) MK(I)=1
        T= 2D0*DRVEC(I)
        IF(T.GT.1D0) THEN
           YGR=R
           ZET=R-(T-1D0)*BILGS
        ELSE
           ZET=R
           YGR=R-T*BILGS
        ENDIF
        YGR=EXP(YGR)
        ZET=EXP(ZET)
        Y(I)=YGR
        Z(I)=ZET
* Define ALPHA and BETA (prim)
        ALF1(I)=YGR-ZET*DELS
        BET1(I)=ZET-YGR*DELS
        IF(ALF1(I).LE.0D0.OR.BET1(I).LE.0D0) GOTO 50
   80   BSUM=BSUM+BET1(I)
        IF(BSUM.GT.1D0) GOTO 800
* Rescale ALPHA and BETA
        CALL VARRAN(DRVEC,NPH)
        DO 90 I=1,NPH
        ALF(I)=ALF1(I)/(1D0-BSUM)
   90   BET(I)=BET1(I)/(1D0-BSUM)
* Define photon four momenta in SQRT(TRANP)/2 units
        DO 100 I=1,NPH
        PHOT(I,4)= ALF(I)+BET(I)
        PHOT(I,3)=-ALF(I)+BET(I)
        R1 = DRVEC(I)
        PHI=2D0*PI*R1
        PTRAN=2D0*DSQRT(DABS(ALF(I)*BET(I)))
        PHOT(I,1)=PTRAN*COS(PHI)
        PHOT(I,2)=PTRAN*SIN(PHI)
        DO 100 K=1,4
  100   PHSU(K)=PHSU(K)+PHOT(I,K)
* Define factor for rescaling photon momenta
        XMK2=PHSU(4)**2-PHSU(3)**2-PHSU(2)**2-PHSU(1)**2
        YY2=1D0/(1D0+PHSU(3)-.25D0*XMK2)
* YY2 negative when outside phase space (abs(t)>abs(s))
        IF(YY2.LE.0D0) GOTO 900
        TRANP=TRAN*YY2
        ENER =SQRT(TRANP)/2D0
* RESCALE ALL PHOTON MOMENTA
        DO 120 K=1,4
        PHSU(K)=PHSU(K)*ENER
        DO 120 I=1,NPH
  120   PHOT(I,K)=PHOT(I,K)*ENER
* This rotation makes PHSU(2)=0
* (we get rid her of dummy angle, see "poprawka" in the notes)
        PSIT=ANGFIX(PHSU(1),PHSU(2))
        CALL RXTOD3(-PSIT, PHSU,PHSU)
        DO 140 I=1,NPH
        DO 135 K=1,4
  135   PH(K)=PHOT(I,K)
        CALL RXTOD3(-PSIT, PH,PH)
        DO 140 K=1,4
  140   PHOT(I,K)=PH(K)
      ENDIF
c+++      IF(TRANP.EQ.0D0) GO TO 900
      IF(TRANP.LE. 4*AMEL**2) GO TO 900
      BETEL=SQRT(1D0-4D0*AMEL**2/(TRANP+4D0*AMEL**2))
      P2(3)=SQRT(TRANP)/2D0
      P2(4)=SQRT(P2(3)*P2(3)+AMEL**2)
      P2(2)=0D0
      P2(1)=0D0
      AMSP=(P2(4)+PHSU(4))**2-(P2(3)+PHSU(3))**2
     $    -(P2(2)+PHSU(2))**2-(P2(1)+PHSU(1))**2
* And the weight finally
      WT1 = TRANP/TRAN
      DELT=AMEL**2/TRANP
      DO 200 I=1,NPH
* Generated distribution
C here some numerical regularization
      DIST0 = 1D0/((ALF1(I)+DELS*BET1(I))*(BET1(I)+DELS*ALF1(I)))
      YGR=ALF1(I)+DELT*BET1(I)
      ZET=BET1(I)+DELT*ALF1(I)
* Desired distribution = soft factor
      DIST1 = ALF1(I)*BET1(I)/(YGR*ZET)**2
      WTM(I)= DIST1/DIST0
  200 CONTINUE
      RETURN
C Event outside phase space
C Note that distinction is made (TRANP=-2,-1) to facilitate tests
c event dropped due to: sum(beta) > 1
 800  CONTINUE
      TRANP = -1D0
      WT1   =  0D0
      RETURN
c event dropped due to: tranp < m^2, or earlier because YY2 < 0
 900  CONTINUE
      TRANP = -2D0
      WT1   =  0D0
      END

c  gen_bhw104

      SUBROUTINE POISSG(AVERG,NMAX,MULT ,RR)
C     **************************************
* DIFFERS FROM THAT IN EXPAND DEC. 87
* THIS GENERATES PHOTON MULTIPLICITY ACCORDING TO POISSON DISTRIBUTION
* INPUT:  AVERG = AVERAGE MULTIPLICITY
*         NMAX  = MAXIMUM MULTIPLICITY
* OUTPUT: MULT  = GENERATED MULTIPLICITY
*         RR(1:100) LIST OF ORDERED UNIFORM RANDOM NUMBERS,
*         A BYPRODUCT RESULT, TO BE EVENTUALLY USED FOR SOME FURTHER
*         PURPOSE (I.E.  GENERATION OF PHOTON ENERGIES).
*     **************************************
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 RR(100)
      DOUBLE PRECISION DRVEC(100)
      SAVE NFAIL

      DATA NFAIL/0/

   50 NN=0
      IF(NMAX.GT.100) GOTO 900
      CALL VARRAN(DRVEC,NMAX)
      SUM=0D0
      DO 100 IT=1,NMAX
      RN = DRVEC(IT)
      Y= LOG(RN)
      SUM=SUM+Y
      NN=NN+1
      IF(SUM.LT.-AVERG) GOTO 130
      RR(NN)=SUM/(-AVERG)
  100 CONTINUE
      NFAIL=NFAIL+1
      IF(NFAIL.GT.100) GOTO 900
      GOTO 50
  130 MULT =NN-1
      RETURN
  900 WRITE(6,*) ' POISSG: TO SMALL OR TO BIG NMAX',NMAX
      STOP
      END

c  gen_bhw104

      SUBROUTINE KINO4(SVAR,TRAN,AMEL,AMSP,AMSQ,WTKK)
*     ************************************************
* Kinematics, construction of momenta in CMS
*     ************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( PI =3.1415926535897932D0)
      COMMON /BHMOMS1/ TRANP,P1(4),P2(4),PHOT1(100,4),PHSU1(4),NPHOT1
      COMMON /BHMOMS2/ TRANQ,Q1(4),Q2(4),PHOT2(100,4),PHSU2(4),NPHOT2
      COMMON /BHMOMZ1  / AL1(50),BE1(50),WTM1(50),MK1(50)
      COMMON /BHMOMZ2  / AL2(50),BE2(50),WTM2(50),MK2(50)
      COMMON /BHPSIPHI / TH1,EXT1,EXB1,PSI1,EXW1,
     $                  TH2,EXT2,EXB2,PSI2,EXW2,EXE2,FIF,PHI
      SAVE   /BHMOMS1  /, /BHMOMS2  /, /BHMOMZ1/, /BHMOMZ2/,/BHPSIPHI/
      DOUBLE PRECISION DRVEC(100)
      REAL*8 PH(4)
      DIMENSION QCM(4)

      BTEL=DSQRT(1D0-4D0*AMEL**2/SVAR)
      WTKK=1D0
* Three azimuthal angles
      CALL VARRAN(DRVEC,3)
      PSI1= 2D0*PI*DRVEC(1)
      PSI2= 2D0*PI*DRVEC(2)
      PHI = 2D0*PI*DRVEC(3)
* Upper vertex: transf. from P2-P1 proper frame
      CALL KLIPER(TRANP,AMEL,PHSU1,P2,TH1,EXT1,EXB1)
* Lower vertex: transf. from q2-q1 proper frame
      CALL KLIPER(TRANQ,AMEL,PHSU2,Q2,TH2,EXT2,EXB2)
* Define P1, Q1  in central QMS
      P1(3)= -(TRAN+AMSP-AMEL**2)/SQRT(TRAN)/2D0
      Q1(3)=  (TRAN+AMSQ-AMEL**2)/SQRT(TRAN)/2D0
      RPQK=(Q1(3)+P1(3))/DSQRT(SVAR)
* Correcting for electron mass
C     PX2=SVAR*(SVAR+4D0*P1(3)*Q1(3))/((Q1(3)+P1(3))**2+SVAR)/4D0
C     PX2=PX2-AMEL**2
      GPQK= P1(3)-Q1(3)
      PX2=(BTEL**2*SVAR*(1D0+RPQK*RPQK)-GPQK*GPQK)/(1D0+RPQK*RPQK)/4D0
      IF(PX2.LE.0D0) GOTO 900
      PX=SQRT(PX2)
      P1(2)=  0D0
      Q1(2)=  0D0
      P1(1)=  -PX
      Q1(1)=   PX
      P1(4)=  SQRT(P1(1)**2+P1(2)**2+P1(3)**2+AMEL**2)
      Q1(4)=  SQRT(Q1(1)**2+Q1(2)**2+Q1(3)**2+AMEL**2)
* Correcting for electron mass
C     BETP = SQRT(1D0-(AMEL/P1(4))**2)
C     BETQ = SQRT(1D0-(AMEL/Q1(4))**2)
C     DO 7 K=1,3
C     P1(K)=BETP* P1(K)
C   7 Q1(K)=BETQ* Q1(K)
      EXW1=SQRT((P1(4)+P1(1))/(P1(4)-P1(1)))
      EXW2=SQRT((Q1(4)+Q1(1))/(Q1(4)-Q1(1)))
* Construct momentum transfer Q in CMS
      QCM(4)=(AMSP-AMSQ)/SQRT(SVAR)/2D0
      QMOD=SQRT(TRAN+QCM(4)**2)
      QCM(3)=(-TRAN-AMSP/2D0-AMSQ/2D0+AMEL**2)/SQRT(SVAR-4D0*AMEL**2)
      QCM(2)=0D0
      QCM(1)=SQRT(QMOD**2-QCM(3)**2)
      FIF =ANGFIX(QCM(3),QCM(1))
      EXE2=SQRT((QMOD+QCM(4))/(QMOD-QCM(4)))

* Final set of transformations from QMSP and QMSQ to CMS
* First branch, tranformed are P2, PHSU1, PHOT1
      CALL  PTRAL(TH1,EXT1,EXB1,PSI1,EXW1,EXE2,FIF,PHI,P2)
      IF(NPHOT1.NE.0) THEN
       CALL PTRAL(TH1,EXT1,EXB1,PSI1,EXW1,EXE2,FIF,PHI,PHSU1)
       DO 20 I=1,NPHOT1
       DO 15 K=1,4
   15  PH(K)=PHOT1(I,K)
       CALL PTRAL(TH1,EXT1,EXB1,PSI1,EXW1,EXE2,FIF,PHI,PH)
       DO 16 K=1,4
   16  PHOT1(I,K)=PH(K)
   20  CONTINUE
      ENDIF
* Second branch, tranformed are Q2, PHSU2, PHOT2
      CALL  QTRAL(TH2,EXT2,EXB2,PSI2,EXW2,EXE2,FIF,PHI,Q2)
      IF(NPHOT2.NE.0) THEN
       CALL QTRAL(TH2,EXT2,EXB2,PSI2,EXW2,EXE2,FIF,PHI,PHSU2)
       DO 30 I=1,NPHOT2
       DO 25 K=1,4
   25  PH(K)=PHOT2(I,K)
       CALL QTRAL(TH2,EXT2,EXB2,PSI2,EXW2,EXE2,FIF,PHI,PH)
       DO 26 K=1,4
   26  PHOT2(I,K)=PH(K)
   30  CONTINUE
      ENDIF
* Finally, beams P1 and Q1

      CALL BXSTD3(EXE2,P1,P1)

      CALL RXTOD2( FIF,P1,P1)

      CALL BXSTD3(EXE2,Q1,Q1)

      CALL RXTOD2( FIF,Q1,Q1)

      RETURN
* Event outside phase space
  900 WTKK=0D0
      END

c  gen_bhw104

      SUBROUTINE PTRAL(TH,EXT,EXB,PSI,EXW,EXE,FIF,PHI,P)
*     **************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 P(4)

      CALL RXTOD2( -TH, P, P)

      CALL BXSTD3( EXT, P, P)

      CALL BOSTD1( EXB, P, P)

      CALL RXTOD3( PSI, P, P)

      CALL BOSTD1( EXW, P, P)

      CALL BXSTD3( EXE, P, P)

      CALL RXTOD2( FIF, P, P)

      CALL RXTOD3( PHI, P, P)

      END

c  gen_bhw104

      SUBROUTINE QTRAL(TH,EXT,EXB,PSI,EXW,EXE,FIF,PHI,P)
*     **************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( PI =3.1415926535897932D0)
      REAL*8 P(4)

      CALL RXTOD2( -TH, P, P)

      CALL BXSTD3( EXT, P, P)

      CALL BOSTD1( EXB, P, P)

      CALL RXTOD3( PSI, P, P)

      CALL RXTOD2(  PI, P, P)

      CALL BOSTD1( EXW, P, P)

      CALL BXSTD3( EXE, P, P)

      CALL RXTOD2( FIF, P, P)

      CALL RXTOD3( PHI, P, P)

      END

c  gen_bhw104

      SUBROUTINE KLIPER(TRANP,AMEL,PHSUM,P2,TH,EXT,EXB)
*     **************************************************
* Deals with Lorentz transf. from QQ1 to QQ frame
* where QQ1=P2-P1, QQ=P2+PHSUM-P1, TRANP=QQ1**2, P1**2=P2**2=AMEL**2
* Input: TRANP,AMEL,PHSUM
* Output: P2,TH,EXT,EXB,PHSUM
* Here, TH, EXT, EXB are transformation params.
*     **************************************************
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 PHSUM(4),P2(4)
      REAL*8 P1(4),QQ1(4)

      BETEL=SQRT(1D0-4D0*AMEL**2/(TRANP+4D0*AMEL**2))
* No photon
      IF(PHSUM(4).EQ.0D0) THEN
        P2(3)= SQRT(TRANP)/2D0
        P2(4)= SQRT(P2(3)*P2(3)+AMEL**2)
        P2(2)=0D0
        P2(1)=0D0
        TH =0D0
        EXT=1D0
        EXB=1D0
      ELSE
* One photon or more
        ENER1=SQRT(TRANP)/2D0

        P1(1)=0D0
        P1(2)=0D0
        P1(3)=-ENER1
        P1(4)= SQRT(P1(3)*P1(3)+AMEL**2)

        P2(1)=0D0
        P2(2)=0D0
        P2(3)= ENER1
        P2(4)= SQRT(P2(3)*P2(3)+AMEL**2)

        DO 33 I=1,4
  33    QQ1(I)=P2(I)+PHSUM(I)-P1(I)

* Rotation 2 puts QQ1 paralel to axis 3
* Note that  PHSUM(2)=0 is already assured in MLTIBR!
        TH  =ANGFIX(QQ1(3),QQ1(1))
        CALL RXTOD2(-TH ,QQ1,QQ1)
        CALL RXTOD2(-TH ,P1,P1)
* Boost 3 puts QQ1(4)=0
        EXT = SQRT((QQ1(3)-QQ1(4))/(QQ1(3)+QQ1(4)))
        CALL BXSTD3( EXT ,QQ1,QQ1)
        CALL BXSTD3( EXT , P1, P1)
        EXB = SQRT((P1(4)-P1(1))/(P1(4)+P1(1)))
CC Testing obsolete appendix
CC Boost 1 puts P1 antiparallel to axis 3
CC      CALL RXTOD2( -TH , P2, P2)
CC      CALL BXSTD3( EXT , P2, P2)
CC      CALL BOSTD1( EXB , P2, P2)
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE MERGIK
*     *****************
* Transfer momenta and mark into proper commons
* photons ordered according to cms energy
* (the hardest in the first position)
!----------------------------------------------
!--- Modified by W. Placzek, Sept. 1995
!----------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON / BHPAR2 / CMSENE,AMEL
      SAVE   / BHPAR2 /
      COMMON /BHMOMS1/ TRANP,P1(4),P2(4),PHOT1(100,4),PHSU1(4),NPHOT1
      COMMON /BHMOMS2/ TRANQ,Q1(4),Q2(4),PHOT2(100,4),PHSU2(4),NPHOT2
      COMMON /BHMOMZ1/ AL1(50),BE1(50),WTM1(50),MK1(50)
      COMMON /BHMOMZ2 / AL2(50),BE2(50),WTM2(50),MK2(50)
      COMMON /BHMOMSET/ PX1(4),QX1(4),PX2(4),QX2(4),PHOT(100,4),NPHOT
      COMMON /BHMARPKP/ MARKP(100)
      SAVE   /BHMOMS1/,/BHMOMS2/,/BHMOMZ1/,/BHMOMZ2/,/BHMOMSET/
      SAVE   /BHMARPKP/
!WP: photon radiation tags
      Common /BHRadTag / idrad(100)
      SAVE   /BHRadTag /
      REAL*8 phx(4),pk(4)
!
      NPHOT=NPHOT1+NPHOT2
      I1=1
      I2=1
      DO 207 I=1,NPHOT
      IF(PHOT1(I1,4).GT.PHOT2(I2,4)) THEN
         DO 205 K=1,4
  205    PHOT( I,K)=PHOT1(I1,K)
         MARKP(I)  =  MK1(I1)
!WP: initial state radiation (positron line)
         IF (al1(I1)-be1(I1).gt.0) THEN
           idrad(I) = 1
!WP: final state radiation (positron line)
         ELSE
           idrad(I) = 3
         ENDIF
         I1=I1+1
      ELSE
         DO 206 K=1,4
  206    PHOT( I,K)=PHOT2(I2,K)
         MARKP(I)  =  MK2(I2)
!WP: initial state radiation (electron line)
         IF (al2(I2)-be2(I2).gt.0) THEN
           idrad(I) = 2
!WP: final state radiation (electron line)
         ELSE
           idrad(I) = 4
         ENDIF
         I2=I2+1
      ENDIF
  207 CONTINUE
      DO 300 K=1,4
      PX1(K)=P1(K)
      PX2(K)=P2(K)
      QX1(K)=Q1(K)
      QX2(K)=Q2(K)
  300 CONTINUE
!WP: balance initial-final energy-momentum when some photons removed
      DO k = 1,4
        phx(k) = PX2(k) + QX2(k)
        DO i = 1,NPHOT
          phx(k) = phx(k) + PHOT(i,k)
        ENDDO
      ENDDO
      ECMSf = DSQRT( phx(4)**2 -phx(3)**2 -phx(2)**2 -phx(1)**2 )
      IF (CMSENE-ECMSf.gt.1d-6) THEN

        CALL BOSTDQ( 1,phx,PX2,PX2)

        CALL BOSTDQ( 1,phx,QX2,QX2)

        refa = CMSENE/ECMSf
        PX2(4) = PX2(4)*refa
        QX2(4) = QX2(4)*refa
        p2m  = DSQRT( PX2(1)**2 + PX2(2)**2 + PX2(3)**2 )
        q2m  = DSQRT( QX2(1)**2 + QX2(2)**2 + QX2(3)**2 )
        p2mr = DSQRT( PX2(4)**2 - AMEL**2 )
        q2mr = DSQRT( QX2(4)**2 - AMEL**2 )
        DO k = 1,3
          PX2(k) = PX2(k)*p2mr/p2m
          QX2(k) = QX2(k)*q2mr/q2m
        ENDDO
        DO i = 1,NPHOT
          DO k = 1,4
            pk(k) = PHOT(i,k)
          ENDDO
          CALL BOSTDQ( 1,phx,pk,pk)
          DO k = 1,4
            PHOT(i,k) = pk(k)*refa
          ENDDO
        ENDDO
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE WTinte(wt)
*     *********************
!---------------------------------------------------------------!
! This routine provides a weight for restoring up-down          !
! interference in YFS forrmula for Bhabha scattering.           !
! OUTPUT: wt  - the up-down interference weight                 !
!---------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995  !
! Last update: 23.05.1995       by: W.P.                        !
!---------------------------------------------------------------!
      implicit REAL*8 (a-h,o-z)
      COMMON / BHPAR2 / CMSENE,AMEL
      COMMON /BHMOMSET/ p1(4),q1(4),p2(4),q2(4),phot(100,4),nphot
      SAVE  / BHPAR2 /, /BHMOMSET /
      COMMON /BHMOMZ1  / AL1(50),BE1(50),WTM1(50),MK1(50)
      COMMON /BHMOMZ2  / AL2(50),BE2(50),WTM2(50),MK2(50)
      save   /BHMOMZ1  /, /BHMOMZ2 /
!
      wt = 1
      if (nphot.EQ.0) RETURN
      ame = AMEL
      p1q1 = p1(4)*q1(4)-p1(3)*q1(3)-p1(2)*q1(2)-p1(1)*q1(1)
      p1p2 = p1(4)*p2(4)-p1(3)*p2(3)-p1(2)*p2(2)-p1(1)*p2(1)
      p1q2 = p1(4)*q2(4)-p1(3)*q2(3)-p1(2)*q2(2)-p1(1)*q2(1)
      q1p2 = q1(4)*p2(4)-q1(3)*p2(3)-q1(2)*p2(2)-q1(1)*p2(1)
      q1q2 = q1(4)*q2(4)-q1(3)*q2(3)-q1(2)*q2(2)-q1(1)*q2(1)
      p2q2 = p2(4)*q2(4)-p2(3)*q2(3)-p2(2)*q2(2)-p2(1)*q2(1)
      DO i = 1,nphot
! Scalar products of photon 4-momentum with other 4-momenta
        p1k = p1(4)*phot(i,4) -p1(3)*phot(i,3)
     &       -p1(2)*phot(i,2) -p1(1)*phot(i,1)
        q1k = q1(4)*phot(i,4) -q1(3)*phot(i,3)
     &       -q1(2)*phot(i,2) -q1(1)*phot(i,1)
        p2k = p2(4)*phot(i,4) -p2(3)*phot(i,3)
     &       -p2(2)*phot(i,2) -p2(1)*phot(i,1)
        q2k = q2(4)*phot(i,4) -q2(3)*phot(i,3)
     &       -q2(2)*phot(i,2) -q2(1)*phot(i,1)
! Soft factors S-tilde (factor alpha/4pi^2 omitted!)
! Upper-line only
        sfu = 2*p1p2/(p1k*p2k) -(ame/p1k)**2 -(ame/p2k)**2
! Lower-line only
        sfl = 2*q1q2/(q1k*q2k) -(ame/q1k)**2 -(ame/q2k)**2
! Interference terms
        sfi = 2*( p1q1/(p1k*q1k) -p1q2/(p1k*q2k)
     &           -q1p2/(q1k*p2k) +p2q2/(p2k*q2k) )
! Weight
        wt = wt *( 1 + sfi/(sfu+sfl) )
      ENDDO
      END

c  gen_bhw104

C==================================================================
C======================== MODEL====================================
C==================================================================
      SUBROUTINE MODEL(MODE,WTM)
*     ****************************
! Interface to various models for hard bremsstrhlung matrix element
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /BHWGTALL / WTMOD,WTCRUD,WTTRIG,WTSET(300)
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON /BHINOUT  / NINP,NOUT
      SAVE   /BHWGTALL /, /BHINOUT  /, / BHPAR3 /
C
      KEYMOD = MOD(KEYRAD,100)/10
      IF (KEYMOD.EQ.1) THEN
c
        CALL MODEL1(MODE)
c
        WTM = WTSET(  1)
      ELSEIF (KEYMOD.EQ.2) THEN
c
        CALL MODEL2(MODE)
c
        WTM = WTSET(101)
      ELSE
        WRITE(NOUT,*) ' +++++ MODEL: wrong keymod=',KEYMOD
        STOP
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE BH_DUMPS(NOUT)
*     **********************
* THIS PRINTS OUT FOUR MOMENTA OF PHOTONS
* ON OUTPUT UNIT NOUT
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /BHMOMSET / P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT
      SAVE   /BHMOMSET /
      REAL*8 SUM(4)
C
      WRITE(NOUT,*) '=====================DUMPS===================='
      WRITE(NOUT,3100) ' P2',(P2(K),K=1,4)
      WRITE(NOUT,3100) ' Q2',(Q2(K),K=1,4)
      DO 100 I=1,NPHOT
  100 WRITE(NOUT,3100) 'PHO',(PHOT(I,K),K=1,4)
      DO 200 K=1,4
  200 SUM(K)=P2(K)+Q2(K)
      DO 210 I=1,NPHOT
      DO 210 K=1,4
  210 SUM(K)=SUM(K)+PHOT(I,K)
      WRITE(NOUT,3100) 'SUM',(SUM(K),K=1,4)
 3100 FORMAT(1X,A3,1X,5F18.13)
      END

c  gen_bhw104

      SUBROUTINE BHWIDE(MODE,XPAR,NPAR)
*     *********************************
!                                                                      !
!   BBBBBBB   BBB   BBB  BBB       BBB  BBB  BBBBBBB    BBBBBBB        !
!   BBB  BBB  BBB   BBB  BBB       BBB  BBB  BBB  BBB   BBB            !
!   BBB  BBB  BBB   BBB  BBB       BBB  BBB  BBB   BBB  BBB            !
!   BBBBBBB   BBBBBBBBB  BBB       BBB  BBB  BBB   BBB  BBBBBB         !
!   BBBBBBB   BBBBBBBBB  BBB   B   BBB  BBB  BBB   BBB  BBBBBB         !
!   BBB  BBB  BBB   BBB  BBB  BBB  BBB  BBB  BBB   BBB  BBB            !
!   BBBBBBBB  BBB   BBB  BBBBBB BBBBBB  BBB  BBB  BBB   BBB            !
!   BBBBBBB   BBB   BBB  BBBBB    BBBB  BBB  BBBBBBB    BBBBBBB        !
!                                                                      !
!======================================================================!
!======================================================================!
!======================================================================!
!===============             B H W I D E            ===================!
!======================================================================!
!======================================================================!
!=============== MONTE CARLO FOR WIDE-ANGLE BHABHA ====================!
!===============            VERSION 1.04            ===================!
!======================================================================!
!======================       May  2001     = =========================!
!======================================================================!
!======================================================================!
!=======================     AUTHORS      =============================!
!============  S. Jadach, W. Placzek, B.F.L. Ward  ====================!
!======================================================================!
!======================================================================!
!= Last modification: 30.05.2001  ================== by: WP ===========!
!======================================================================!
!                                                                      !
! BHWIDE is based on the following papers:                             !
! [1] S. Jadach, W. Placzek and B.F.L. Ward,                           !
!     Phys. Lett. B390 (1997) 298;                                     !
!     UTHEP-95-1001 (Oct. 1995); hep-ph/9608412.                       !
! [2] S. Jadach and B.F.L. Ward,                                       !
!     Phys. Rev. D40 (1989) 3582.                                      !
! [3] S. Jadach, E. Richter-Was, B.F.L. Ward  and Z. Was,              !
!     Comput. Phys. Commun. 70 (1992) 305; TH-6230, Sept. 1991.        !
! [4] M. Bohm, A. Denner and W. Hollik,                                !
!     Nucl. Phys. B304 (1988) 687.                                     !
! [5] F.A. Berends, R. Kleiss and W. Hollik,                           !
!     Nucl. Phys. B304 (1988) 712.                                     !
! [6] W. Beenakker, F.A. Berends and S.C. van der Marck,               !
!     Nucl. Phys. B349 (1991) 323.                                     !
!                                                                      !
!                  IMPORTANT NOTE                                      !
!                  --------------                                      !
! The user is kindly requested to cite at least ref. [1].              !
!----------------------------------------------------------------------!
!                        INPUT and OUTPUT                              !
!----------------------------------------------------------------------!
! All input and output goes through parameters in                      !
!                 CALL BHWIDE(MODE,XPAR,NPAR)                          !
! and through /MOMSET/ and /WGTALL/ common blocks.                     !
! In the following we shall  briefly indicate the meaning of the       !
! above parameters/variables.                                          !
!                                                                      !
! IF( MODE =-1 ) THEN                                                  !
! ===================                                                  !
! Initialization is performed, all input parameters are transfered     !
! through XPAR and NPAR.                                               !
!----------------------------------------------------------------------!
!  Entry    Variable   Meaning                                         !
!----------------------------------------------------------------------!
!  NPAR( 1)  KeyOpt = 1000*KeyZof +100*KeyCha +10*KeyWgt +KeyRnd       !
!                    General option switch                             !
!            KeyZof =0,1: Z contribution switched ON/OFF               !
!            KeyCha =0,1,2: channel choice: s+t, s-only, t-only        !
!            KeyRnd =1,2: type of random number generator RANMAR,RANECU!
!            KeyWgt =0,1: for constant, variable weight WTMOD          !
!  NPAR( 2)  KeyRad =1000*KeyEWC +100*KeyLib +10*KeyMod + KeyPia       !
!                    is option switch for ElectroWeak Radiative Corr.; !
!                    see tables in BHWID1 for more details.            !
!  XPAR( 1)  CMSENE Total center mass energy [GeV]                     !
!  XPAR( 2)         see tables in BHWID1,                              !
!  XPAR( 3)         see tables in BHWID1,                              !
!  XPAR( 4)         see tables in BHWID1,                              !
!  XPAR( 5)         see tables in BHWID1,                              !
!  XPAR( 6)         see tables in BHWID1,                              !
!  XPAR( 7)         see tables in BHWID1,                              !
!  XPAR( 8)         see tables in BHWID1,                              !
!  XPAR( 9)         see tables in BHWID1,                              !
!  XPAR(10)         see tables in BHWID1,                              !
!  XPAR(11)         see tables in BHWID1,                              !
!  XPAR(12)         see tables in BHWID1,                              !
!  XPAR(13)         see tables in BHWID1,                              !
!  XPAR(14)         see tables in BHWID1,                              !
!  XPAR(15)         see tables in BHWID1,                              !
!----------------------------------------------------------------------!
!                                                                      !
! ELSE IF( MODE = 0 ) THEN                                             !
! ========================                                             !
! Generation of the single Monte Carlo event                           !
! The four momenta of the final state electron positron and photon     !
! are encoded in                                                       !
!      COMMON / MOMSET / P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT     !
! where P1 and Q1 are four-momenta of positron and elecron beams,      !
! P2 and Q2 are four-momenta of outgoing positron and electron,        !
! PHOT(100,4) contains list of photon four-momenta                     !
! and NPHOT is the number of real photons in PHOT.                     !
! NOTE: +z axis points along incoming e+.                              !
!                                                                      !
! For weighted events it may be profitable to use "paralel weights"    !
! from                                                                 !
!      COMMON / WGTALL / WTMOD,WTCRUD,WTTRIG,WTSET(300)                !
! where WTMOD is the principal model weight and another useful weights !
! representing some interesting version of the matrix element          !
! can be constructed as WT= WTCRU1*WTCRU2*WTSET(J).                    !
!                                                                      !
! ELSE IF( MODE = 1 ) THEN                                             !
! ========================                                             !
! The total cross section corresponding to generated series of event,  !
! i.e. resulting from MC integrartion is calculated and stored in XPAR !
! and NPAR.                                                            !
! In the table below we describe their most essential entries.         !
!----------------------------------------------------------------------!
!  Entry    Variable   Meaning                                         !
!----------------------------------------------------------------------!
!  NPAR(10)  NEVGEN  Number of generated MC events                     !
!  NPAR(20)  NEVGEN  Number of generated MC events                     !
!  XPAR(10)    XSEC  Total x-section [pb]                              !
!  XPAR(11)   RXSEC  The relative (statistical) error of XSEC          !
!  XPAR(20)          Crude total MC x-section [pb] which is necessary  !
!                    for rescaling histograms in run                   !
!                    with weighted events.                             !
!  XPAR(21)          =0, error of XPAR(20) is zero                     !
!----------------------------------------------------------------------!
! For constant weight option KEYWGT=0 (convevience in rescaling histos)!
! we put XPAR(20,21)=XPAR(10,11)                                       !
! For MODE=1 program is called upon many times in the process of       !
! rescaling histograms and therefore no output is printed.             !
!                                                                      !
! ELSE IF( MODE = 2 ) THEN                                             !
! ========================                                             !
! Only in this MODE=2 in addition to filling XPAR and NPAR             !
! (as for MODE=1)                                                      !
! the values of various x-sections are printed on the standard         !
! output file.                                                         !
!                                                                      !
! ENDIF                                                                !
! ====                                                                 !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      CHARACTER*80    BXOPE,BXCLO,BXTXT,BXL1I,BXL1F,BXL2F,BXL1G,BXL2G
      PARAMETER(
     $BXOPE =  '(//1X,15(5H=====)    )',
     $BXTXT =  '(1X,1H=,                  A48,25X,    1H=)',
     $BXL1I =  '(1X,1H=,I17,                 16X, A20,A12,A7, 1X,1H=)',
     $BXL1F =  '(1X,1H=,F17.8,               16X, A20,A12,A7, 1X,1H=)',
     $BXL2F =  '(1X,1H=,F17.8, 4H  +-, F11.8, 1X, A20,A12,A7, 1X,1H=)',
     $BXL1G =  '(1X,1H=,G17.8,               16X, A20,A12,A7, 1X,1H=)',
     $BXL2G =  '(1X,1H=,G17.8, 4H  +-, F11.8, 1X, A20,A12,A7, 1X,1H=)',
     $BXCLO =  '(1X,15(5H=====)/   )'    )
      DIMENSION  XPAR(*),NPAR(*)
      COMMON /BHINOUT/ NINP,NOUT
      COMMON /BHPAR3/ KEYRAD,KEYOPT
      SAVE   /BHINOUT/, /BHPAR3/
      SAVE   NEVG
!-- Data
      CHARACTER*64 Logo(40)
      DATA Logo /
     &'***************************************************************',
     &'***************************************************************',
     &'* BBBBBBB   BBB   BBB  BBB       BBB  BBB  BBBBBBB    BBBBBBB *',
     &'* BBB  BBB  BBB   BBB  BBB       BBB  BBB  BBB  BBB   BBB     *',
     &'* BBB  BBB  BBB   BBB  BBB       BBB  BBB  BBB   BBB  BBB     *',
     &'* BBBBBBB   BBBBBBBBB  BBB       BBB  BBB  BBB   BBB  BBBBBB  *',
     &'* BBBBBBB   BBBBBBBBB  BBB   B   BBB  BBB  BBB   BBB  BBBBBB  *',
     &'* BBB  BBB  BBB   BBB  BBB  BBB  BBB  BBB  BBB   BBB  BBB     *',
     &'* BBBBBBBB  BBB   BBB  BBBBBB BBBBBB  BBB  BBB  BBB   BBB     *',
     &'* BBBBBBB   BBB   BBB  BBBBB    BBBB  BBB  BBBBBBB    BBBBBBB *',
     &'***************************************************************',
     &'*     MC Event Generator for Wide-Angle Bhabha Scattering     *',
     &'*                    BHWIDE version 1.04                      *',
     &'***************************************************************',
     &'*********************** May     2001 **************************',
     &'***************************************************************',
     &'*              Last modification: 30.05.2001                  *',
     &'***************************************************************',
     &'*                        AUTHORS:                             *',
     &'*          S. Jadach              (Stanislaw.Jadach@cern.ch)  *',
     &'*          W. Placzek             (Wieslaw.Placzek@cern.ch)   *',
     &'*          B.F.L. Ward            (bflw@slac.stanford.edu)    *',
     &'***************************************************************',
     &'*                        PAPERS:                              *',
     &'* [1] S. Jadach, W. Placzek, B.F.L. Ward,                     *',
     &'*     Phys. Lett. B390 (1997) 298; hep-ph/9608412.            *',
     &'***************************************************************',
     &'*                        HISTORY:                             *',
     &'* (1) September 1995:  version 1.00                           *',
     &'* (2) September 1996:  version 1.01                           *',
     &'* (3) February  2001:  version 1.02                           *',
     &'* (4) March     2001:  version 1.03                           *',
     &'* (5) May       2001:  version 1.04                           *',
     &'***************************************************************',
     &'*                          WWW:                               *',
     &'*  http://cern.ch/placzek                                     *',
     &'*  http://enigma.phys.utk.edu/pub/BHWIDE/                     *',
     &'***************************************************************',
     &'***************************************************************',
     &' '/

      IF (MODE.EQ.-1) THEN
        NINP = 15
        NOUT = 16
! Print-out logo
        WRITE(6,   '(8X,A)') Logo
        WRITE(NOUT,'(8X,A)') Logo
!
        NEVG = 0
c
        CALL BHWID1(-1,XPAR,NPAR)
c
      ELSEIF (MODE.EQ.0) THEN
        NEVG = NEVG + 1
c
        CALL BHWID1( 0,XPAR,NPAR)
c
! Clean final state common blocks if necessary (safety reason)
c
        CALL BHCLEN
c
      ELSE
        CALL BHWID1(MODE,XPAR,NPAR)
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE BHCLEN
*     *****************
! This routine prevents user from using zero weight events
! and parallel weights when they should not be used!
*     ************************
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON /BHMOMSET/ P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT
      COMMON /BHWGTALL/ WTMOD,WTCRUD,WTTRIG,WTSET(300)
      SAVE   /BHMOMSET/, /BHWGTALL/

! Parallel weights should not be used for constant weight events.
      IF(WTMOD.EQ.1D0) THEN
        DO I = 1,300
          WTSET(I) = 0D0
        ENDDO
! Clean final state momenta for events outside phase space
      ELSEIF(WTCRUD*WTTRIG.EQ.0D0)  THEN

        DO K = 1,4
          P2(K)=0D0
          Q2(K)=0D0
        ENDDO

        NPHOT=0

        DO J = 1,100
          DO K = 1,4
            PHOT(J,K) = 0D0
          ENDDO
        ENDDO

      ENDIF
      END

c  gen_bhw104

!======================================================================
!======================= G L I B K  ===================================
!==================General Library of utilities========================
!===========It is similar but not identical to HBOOK and HPLOT=========
!======================================================================
!
!                      Version:    1.20
!              Last correction:    September 1996
!
!
!  Installation remarks:
!  (1) printing backslash character depends on F77 compilator,
!      user may need to modify definition of BS variable in HPLCAP
!
!  Usage of the program:
!  (1) In most cases names and meanings of programs and their
!      parameters is the same as in original CERN libraries HBOOK
!  (2) Unlike to original HBOOK and HPLOT, all floating parameters
!      of the programs are in double precision!
!  (3) GLIBK stores histograms in double precision and always with
!      errors. REAL*8 storage is essential for 10**7 events statistics!
!  (4) Output from GLIBK is a picture recorded as regular a LaTeX file
!      with frame and curves/histograms, it is easy to change fonts
!      add captions, merge plots, etc. by normal editing. Finally,
!      picture may be inserted in any place into LaTeX source of the
!      article.
!  (5) WARNING: two-dimensional histograms are not active!!!
!
!  ********************************************************************
!  *  History of the program:                                         *
!  *  MINI-HBOOK writen by S. Jadach, Rutherford Lab. 1976            *
!  *  Rewritten December 1989 (S.J.)                                  *
!  *  Version with DOUBLE PRECISION ARGUMENTS ONLY!  and SAVE         *
!  *  Subprogram names start with G instead of H letter!               *
!  *  Entries:   Obligatory:  GLIMIT                                  *
!  *             Optional: see table below                            *
!  *  non-user subprograms in brackets                                *
!  ********************************************************************
!    SUBR/FUNC  1 PAR. 2 PAR. 3 PAR. 4 PAR. 5 PAR. 6 PAR.
!  ====================================================================
*     (G_INIT)  ----   ----    ----   ----   ----   ----
*      GI       INT    INT     ----   ----   ----   ----
*      GIE      INT    INT     ----   ----   ----   ----
*      GF1      INT    DBL     DBL    ----   ----   ----
*      GFILL    INT    DBL     DBL    DBL    ----   ----
*      GBOOK1   INT    CHR*80  INT    DBL    DBL    ----
*     (GOPTOU)  INT    INT     INT    INT    INT     INT
* (L.F. GEXIST) INT    -----  ------  ----   ----   ----
*      GIDOPT   INT    CHR*4   -----  ----   ----   ----
*      GBFUN1   INT    CHR*80   INT   DBL    DBL  DP-FUNC
*      GIDOPT   INT    CHR*4   -----  ----   ----   ----
*      GBOOK2   INT    CHR*80   INT   DBL    DBL     INT   DBL   DBL
*      GISTDO     ---   ----   ----   ----   ----   ----
*      GOUTPU   INT     ----   ----   ----   ----   ----
*      GPRINT   INT     ----   ----   ----   ----   ----
*      GOPERA   INT    CHR*1   INT    INT    DBL    DBL
*      GINBO1   INT    CHR*8   INT    DBL    DBL    ----
*      GUNPAK   INT    DBL(*) CHR*(*) INT    ---    ----
*      GPAK     INT    DBL(*)  ----   ----   ---    ----
*      GPAKE    INT    DBL(*)  ----   ----   ---    ----
*      GRANG1   INT    DBL     DBL    ----   ---    ----
*      GINBO2   INT    INT     DBL    DBL    INT    DBL   DBL
*      GMAXIM   INT    DBL     ----   ----   ---    ----
*      GMINIM   INT    DBL     ----   ----   ---    ----
*      GRESET   INT   CHR*(*)  ----   ----   ---    ----
*      GDELET   INT     ----   ----   ----   ----   ----
*      GLIMIT   INT     ----   ----   ----   ----   ----
*     (COPCH)   CHR*80 CHR*80  ----   ----   ----   ----
* (F. JADRES)   INT     ----   ----   ----   ----   ----
*      GRFILE   INT   CHR*(*) CHR*(*) ----   ----   ----
*      GROUT    INT    INT    CHR*8   ----   ----   ----
*      GRIN     INT    INT     INT    ----   ----   ----
*      GREND   CHR*(*) ----    ----   ----   ----   ----
!  *******************  HPLOT entries ******************
*      GPLINT   INT    ----    ----   ----   ----   ----
*      GPLCAP   INT    ----    ----   ----   ----   ----
*      GPLEND   ----   ----    ----   ----   ----   ----
*      GPLOT    INT    CHR*1   CHR*1   INT   ----   ----
*     (LFRAM1)  INT      INT     INT  ----   ----   ----
*     (SAXIX)   INT      DBL     DBL   INT    DBL   ----
*     (SAXIY)   INT      DBL     DBL   INT    DBL   ----
*     (PLHIST)  INT      INT     DBL   DBL    INT    INT
*     (PLHIS2)  INT      INT     DBL   DBL    INT    INT
*     (PLCIRC)  INT      INT     INT   DBL    DBL    DBL
*     (APROF)   DBL      INT     DBL  ----   ----   ----
*      GPLSET   INT      DBL    ----  ----   ----   ----
*      GPLTIT   INT    CHR*80   ----  ----   ----   ----
!  *******************  WMONIT entries ******************
*      GMONIT   INT ???
!  *******************************************************************
!                         END OF TABLE
!  *******************************************************************
*          Map of memory for single histogram
*          ----------------------------------
*  (1-7) Header
*  ist +1   mark      9999999999999
*  ist +2   mark      9d12 + id*10 + 9
*  ist +3   iflag1    9d12 + iflag1*10 +9
*  ist +4   iflag2    9d12 + iflag2*10 +9
*  ist +5   scamin    minimum y-scale
*  ist +6   scamax    maximum y-scale
*  ist +7   jdlast    address of the next histogram
*                     from previous history of calls (see jadres)
*          ----------------------------------
*              Binning size informations
*          ----------------------------------
*  One dimensional histogram            Two dimensional histog.
*  -------------------------            ----------------------
*  (8-11) Binning information           (8-15) Binning information
*  ist2 +1    NCHX                          ist2 +5   NCHY
*  ist2 +2      XL                          ist2 +6     YL
*  ist2 +3      XU                          ist2 +7     YU
*  ist2 +4   FACTX                          ist2 +8  FACTY
*
*          ----------------------------------
*           All kind of sums except of maxwt
*          ----------------------------------
*  (12-24) Under/over-flow average x    (16-24)
*  ist3 +1   Underflow                     All nine combinations
*  ist3 +2   Normal                        (U,N,O) x (U,N,O)
*  ist3 +3   Overerflow                    sum wt only (no errors)
*  ist3 +4   U  sum w**2
*  ist3 +5   N  sum w**2
*  ist3 +6   O  sum w**2
*  ist3 +7   Sum 1
*  ist3 +8   Sum wt*x
*  ist3 +9   Sum wt*x*x
*  ist3 +10  nevzer    (gmonit)
*  ist3 +11  nevove    (gmonit)
*  ist3 +12  nevacc    (gmonit)
*  ist3 +13  maxwt     (gmonit)
*          ----------------------------------
*           Content of bins including errors
*          ----------------------------------
*  (25 to 24+2*nchx)                     (25 to 24 +nchx*nchy)
*     sum wt and sum wt**2            sum wt only (no errors)
*  ----------------------------------------------------------------

      SUBROUTINE g_init
*     ****************
! First Initialization called from may routines
*     *************************************
      IMPLICIT DOUBLE PRECISION (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib/b(50000)
      COMMON /BHgind/ nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
c
      SAVE /BHgind/, /BHcglib/
      SAVE init

      DATA init /0/
*
      IF(init .NE. 0) RETURN
      init=1
! this is version version number
      nvrs=111
! default output unit
      nout=16
      lenmax=0
      length=0
      DO i=1,idmx
         DO k=1,3
            index(i,k)=0
         ENDDO
         DO k=1,80
            titlc(i)(k:k)=' '
         ENDDO
      ENDDO
      DO k=1,50000
         b(k)=0d0
      ENDDO
      END



      LOGICAL FUNCTION gexist(id)
!     ***************************
! this function is true when id  exists !!!!
!     ***************************
      IMPLICIT DOUBLE PRECISION (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/ nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
!
      lact=jadres(id)
      gexist = lact .NE. 0
!###  IF(gexist)      WRITE(6,*) 'gexist: does   ID,lact= ',id,lact
!###  IF(.not.gexist) write(6,*) 'gexist: doesnt ID,lact= ',id,lact
      END



      FUNCTION gi(id,ib)
!     ******************
! getting out bin content
! S.J. 18-Nov. 90
!     ***********************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
      SAVE idmem,nch,lact,ist,ist2,ist3

      DATA idmem / -1256765/
!
      IF(id .EQ. idmem) goto 100
      idmem=id
! some checks, not repeated if id the same as previously
      lact=jadres(id)
      IF(lact .EQ. 0) THEN
        WRITE(nout,*) ' gi: nonexisting histo id=',id
        WRITE(   6,*) ' gi: nonexisting histo id=',id
        gi= 0d0
        STOP
      ENDIF
      ist  = index(lact,2)
      ist2 = ist+7
      ist3 = ist+11
! checking if histo is of proper type
      iflag2   = nint(b(ist+4)-9d0-9d12)/10
      ityphi   = mod(iflag2,10)
      IF(ityphi .NE. 1) THEN
        WRITE(nout,*) ' gi: 1-dim histos only !!! id=',id
        WRITE(   6,*) ' gi: 1-dim histos only !!! id=',id
        gi= 0d0
        STOP
      ENDIF
  100 continue
      nch  = nint(b(ist2+1))
      IF(ib .EQ. 0) THEN
! underflow
         gi=   b(ist3 +1)
      ELSEIF(ib .GE. 1.and.ib .LE. nch) THEN
! normal bin
         gi=   b(ist +nbuf+ib)
      ELSEIF(ib .EQ. nch+1) THEN
! overflow
         gi=   b(ist3 +3)
      ELSE
! abnormal exit
         WRITE(nout,*) ' gi: wrong binning id,ib=',id,ib
         WRITE(   6,*) ' gi: wrong binning id,ib=',id,ib
         gi=0d0
         STOP
      ENDIF
      END



      FUNCTION  gie(id,ib)
!     ********************
! getting out error of the bin
! s.j. 18-nov. 90
!     ***********************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
      SAVE idmem,nch,lact,ist,ist2,ist3

      DATA idmem / -1256765/
!
      IF(id .EQ. idmem) goto 100
      idmem=id
! some checks, not repeated if id the same as previously
      lact=jadres(id)
      IF(lact .EQ. 0) THEN
        WRITE(nout,*) ' gie: nonexisting histo id=',id
        WRITE(   6,*) ' gie: nonexisting histo id=',id
        gie= 0d0
        STOP
      ENDIF
      ist  = index(lact,2)
      ist2 = ist+7
      ist3 = ist+11
! checking if histo is of proper type
      iflag2   = nint(b(ist+4)-9d0-9d12)/10
      ityphi   = mod(iflag2,10)
      IF(ityphi .NE. 1) THEN
        WRITE(nout,*) ' gie: 1-dim histos only !!! id=',id
        WRITE(   6,*) ' gie: 1-dim histos only !!! id=',id
        gie= 0d0
        STOP
      ENDIF
  100 continue
      nch  = b(ist2+1)
      IF(ib .EQ. 0) THEN
! underflow
         gie=   dsqrt( dabs(b(ist3 +4)))
      ELSEIF(ib .GE. 1.and.ib .LE. nch) THEN
!...normal bin, error content
         gie=   dsqrt( dabs(b(ist+nbuf+nch+ib)) )
      ELSEIF(ib .EQ. nch+1) THEN
! overflow
         gie=   dsqrt( dabs(b(ist3 +6)))
      ELSE
! abnormal exit
         WRITE(nout,*) ' gie: wrong binning id, ib=',id,ib
         WRITE(   6,*) ' gie: wrong binning id, ib=',id,ib
         gie=0d0
         STOP
      ENDIF
      END



      SUBROUTINE gf1(id,xx,wtx)
!     ************************
! recommended fast filling 1-dim. histogram s.j. 18 nov. 90
! overflow/underflow corrected by Maciek and Zbyszek
!     ***********************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib/ b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE
!
      lact=jadres(id)
! exit for non-existig histo
      IF(lact .EQ. 0)  RETURN
      ist  = index(lact,2)
      ist2 = ist+7
      ist3 = ist+11
! one-dim. histo only
      iflag2   = nint(b(ist+4)-9d0-9d12)/10
      ityphi   = mod(iflag2,10)
      IF(ityphi .NE. 1) RETURN
      x1= xx
      wt1= wtx
      index(lact,3)=index(lact,3)+1
! all entries
      b(ist3 +7)  =b(ist3 +7)   +1
! for average x
      b(ist3 +8)  =b(ist3 +8)  +wt1*x1
      b(ist3 +9)  =b(ist3 +9)  +wt1*x1*x1
! filling coordinates
      nchx  =b(ist2 +1)
      xl    =b(ist2 +2)
      xu    =b(ist2 +3)
      factx =b(ist2 +4)
      IF(x1 .LT. xl) THEN
! underflow
         iposx1 = ist3 +1
         ipose1 = ist3 +4
         kposx1 = 0
      ELSEIF(x1 .GT. xu) THEN
! or overflow
         iposx1 = ist3 +3
         ipose1 = ist3 +6
         kposx1 = 0
      ELSE
! or any normal bin
         iposx1 = ist3 +2
         ipose1 = ist3 +5
! or given normal bin
         kx = (x1-xl)*factx+1d0
         kx = MIN( MAX(kx,1) ,nchx)
         kposx1 = ist +nbuf+kx
         kpose1 = ist +nbuf+nchx+kx
      ENDIF
      b(iposx1) = b(iposx1)  +wt1
      b(ipose1) = b(ipose1)  +wt1*wt1
      IF( kposx1 .NE. 0) b(kposx1) = b(kposx1)  +wt1
      IF( kposx1 .NE. 0) b(kpose1) = b(kpose1)  +wt1*wt1
      END   !gf1



      SUBROUTINE gbook1(id,title,nnchx,xxl,xxu)
*     *****************************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
      CHARACTER*80 title
      LOGICAL gexist
!
      CALL g_init

      IF(gexist(id)) goto 900
      ist=length
      lact=jadres(0)
! the case of no free entry in the index
      IF(lact .EQ. 0) goto 901
      index(lact,1)=id
      index(lact,2)=length
      index(lact,3)=0
*----
!cc      WRITE(6,*) 'GBOOK1: ID= ',ID
! -------
      CALL copch(title,titlc(lact))
      nchx =nnchx
      xl   =xxl
      xu   =xxu
! ---------- title and bin content ----------
      lengt2 = length +2*nchx +nbuf+1
      IF(lengt2 .GE. lenmax) goto 902
      do 10 j=length+1,lengt2+1
  10  b(j) = 0d0
      length=lengt2
!... default flags
      ioplog   = 1
      iopsla   = 1
      ioperb   = 1
      iopsc1   = 1
      iopsc2   = 1
      iflag1   =
     $ ioplog+10*iopsla+100*ioperb+1000*iopsc1+10000*iopsc2
      ityphi   = 1
      iflag2   = ityphi
! examples of decoding flags
!      id       = nint(b(ist+2)-9d0-9d12)/10
!      iflag1   = nint(b(ist+3)-9d0-9d12)/10
!      ioplog = mod(iflag1,10)
!      iopsla = mod(iflag1,100)/10
!      ioperb = mod(iflag1,1000)/100
!      iopsc1 = mod(iflag1,10000)/1000
!      iopsc2 = mod(iflag1,100000)/10000
!      iflag2   = nint(b(ist+4)-9d0-9d12)/10
!      ityphi = mod(iflag2,10)
!--------- buffer -----------------
! header
      b(ist +1)  = 9999999999999d0
      b(ist +2)  = 9d12 +     id*10 +9d0
      b(ist +3)  = 9d12 + iflag1*10 +9d0
      b(ist +4)  = 9d12 + iflag2*10 +9d0
! dummy vertical scale
      b(ist +5)  =  -100d0
      b(ist +6)  =   100d0
! pointer used to speed up search of histogram address
      b(ist +7)  =   0d0
! information on binning
      ist2       = ist+7
      b(ist2 +1) = nchx
      b(ist2 +2) = xl
      b(ist2 +3) = xu
      ddx = xu-xl
      IF(ddx .EQ. 0d0) goto 903
      b(ist2 +4) = float(nchx)/ddx
! under/over-flow etc.
      ist3       = ist+11
      do 100  j=1,13
 100  b(ist3 +j)=0d0
!
      RETURN
 900  continue
      WRITE(6   ,*) ' WARNING gbook1: already exists id=  ', id
      WRITE(NOUT,*) ' WARNING gbook1: already exists id=  ', id
      RETURN
 901  continue
      CALL gstop1(' gbook1: to many histos !!!!!,     id=  ',id)
 902  continue
      CALL gstop1(' gbook1: to litle storage!!!!,  lenmax= ',lenmax)
 903  continue
      CALL gstop1('  gbook1:    xl=xu,               id=   ',id)
      END


      SUBROUTINE gstop1(mesage,id)
*     *******************************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE   /BHgind/
      CHARACTER*40 mesage

      WRITE(nout,'(a)')
     $          '++++++++++++++++++++++++++++++++++++++++++++++++++++++'
      WRITE(nout,'(a,a,i10,a)')
     $                          '+ ', mesage, id, ' +'
      WRITE(nout,'(a)')
     $          '++++++++++++++++++++++++++++++++++++++++++++++++++++++'
      WRITE(6   ,'(a)')
     $          '++++++++++++++++++++++++++++++++++++++++++++++++++++++'
      WRITE(6   ,'(a,a,i10,a)')
     $                          '+ ', mesage, id, ' +'
      WRITE(6   ,'(a)')
     $          '++++++++++++++++++++++++++++++++++++++++++++++++++++++'
      STOP
      END


      SUBROUTINE goptou(id,ioplog,iopsla,ioperb,iopsc1,iopsc2)
!     ********************************************************
! decoding option flags
!     **********************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/

      lact=jadres(id)
      IF(lact .EQ. 0) RETURN
      ist=index(lact,2)
! decoding flags
      iflag1   = nint(b(ist+3)-9d0-9d12)/10
      ioplog = mod(iflag1,10)
      iopsla = mod(iflag1,100)/10
      ioperb = mod(iflag1,1000)/100
      iopsc1 = mod(iflag1,10000)/1000
      iopsc2 = mod(iflag1,100000)/10000
      END


      SUBROUTINE gidopt(id,ch)
!     ************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
      CHARACTER*4 ch
!
      lact=jadres(id)
      IF(lact .EQ. 0) RETURN
      ist=index(lact,2)
! decoding flags
      CALL goptou(id,ioplog,iopsla,ioperb,iopsc1,iopsc2)
      IF(ch .EQ.       'LOGY'  ) THEN
! log scale for print
        ioplog = 2
      ELSEIF(ch .EQ.   'ERRO'  ) THEN
! errors in printing/plotting
       ioperb  = 2
      ELSEIF(ch .EQ.   'SLAN'  ) THEN
! slanted line in plotting
       iopsla  = 2
      ELSEIF(ch .EQ.   'YMIN'  ) THEN
       iopsc1  = 2
      ELSEIF(ch .EQ.   'YMAX'  ) THEN
       iopsc2  = 2
      ENDIF
! encoding back
      iflag1   =
     $ ioplog+10*iopsla+100*ioperb+1000*iopsc1+10000*iopsc2
      b(ist+3) = 9d12 + iflag1*10 +9d0
      END


      SUBROUTINE goutpu(ilun)
*     ***********************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHgind/
c
      CALL g_init
c
      nout=ilun
      END


      SUBROUTINE BH_GPRINT(id)
*     *********************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
      CHARACTER*1 line(0:105),lchr(22),lb,lx,li,l0
      LOGICAL llg

      SAVE lb,lx,li,l0,lchr

      DATA lb,lx,li,l0 /' ','X','I','0'/
      DATA lchr/' ','1','2','3','4','5','6','7','8','9',
     $      'A','B','C','D','E','F','G','H','I','J','K','*'/

      lact=jadres(id)
      IF(lact .EQ. 0) goto 900
      ist  = index(lact,2)
      ist2 = ist+7
      ist3 = ist+11
      idec    = nint(b(ist+2)-9d0-9d12)/10
      IF(idec .NE. id) write(6,*) '+ BH_GPRINT: PANIC! ID,IDEC=',ID,IDEC

      CALL goptou(id,ioplog,iopsla,ioperb,iopsc1,iopsc2)
      ker    =  ioperb-1
      lmx = 67
      IF(ker .EQ. 1) lmx=54
      nent=index(lact,3)
      IF(nent  .EQ.  0)                          GOTO 901
      WRITE(nout,1000) id,titlc(lact)
 1000 FORMAT('1',/,1X,I9,10X,A)
!
! one-dim. histo
      iflag2   = nint(b(ist+4)-9d0-9d12)/10
      ityphi   = mod(iflag2,10)
      IF(ityphi .NE. 1) goto 200
      nchx =   b(ist2 +1)
      xl   =   b(ist2 +2)
      dx   =  (  b(ist2 +3)-b(ist2 +2)  )/float(nchx)
! fixing vertical scale
      istr=ist+nbuf+1
      bmin = b(istr)
      bmax = b(istr)+1d-5*abs(b(istr))  ! problems for single bin case
      do 15 ibn=istr,istr+nchx-1
      bmax = max(bmax,b(ibn))
      bmin = min(bmin,b(ibn))
  15  continue
      IF(bmin  .EQ.  bmax)                       GOTO 903
      IF(iopsc1 .EQ. 2) bmin=b(ist +5)
      IF(iopsc2 .EQ. 2) bmax=b(ist +6)
!
      llg=ioplog .EQ. 2
      IF(llg.and.bmin .LE. 0d0) bmin=bmax/10000.d0
!
      deltb = bmax-bmin
      IF(deltb  .EQ.  0d0)                       GOTO 902
      fact  = (lmx-1)/deltb
      kzer  = -bmin*fact+1.00001d0
      IF(llg) fact=(lmx-1)/(log(bmax)-log(bmin))
      IF(llg) kzer=-log(bmin)*fact+1.00001d0
!
      undf = b(ist3 +1)
      ovef = b(ist3 +3)
      avex = 0d0
      sum  = b(ist3 +8)
      IF(nent .NE. 0) avex = sum/nent
      WRITE(nout,'(4a15      )')  'nent','sum','bmin','bmax'
      WRITE(nout,'(i15,3e15.5)')   nent,  sum,  bmin,  bmax
      WRITE(nout,'(4a15  )')      'undf','ovef','avex'
      WRITE(nout,'(4e15.5)')       undf,  ovef,  avex
!
      IF(llg) write(nout,1105)
 1105 format(35x,17hlogarithmic scale)
!
      kzer=max0(kzer,0)
      kzer=min0(kzer,lmx)
      xlow=xl
      do 100 k=1,nchx
! first fill with blanks
      do  45 j=1,105
   45 line(j)  =lb
! THEN fill upper and lower boundry
      line(1)  =li
      line(lmx)=li
      ind=istr+k-1
      bind=b(ind)
      bind= max(bind,bmin)
      bind= min(bind,bmax)
      kros=(bind-bmin)*fact+1.0001d0
      IF(llg) kros=log(bind/bmin)*fact+1.0001d0
      k2=max0(kros,kzer)
      k2=min0(lmx,max0(1,k2))
      k1=min0(kros,kzer)
      k1=min0(lmx,max0(1,k1))
      do 50 j=k1,k2
   50 line(j)=lx
      line(kzer)=l0
      z=b(ind)
      IF(ker .NE. 1) THEN
        WRITE(nout,'(a, f7.4,  a, d14.6,  132a1)')
     $             ' ', xlow,' ',     z,' ',(line(i),i=1,lmx)
      ELSE
        er=dsqrt(dabs(b(ind+nchx)))
        WRITE(nout,'(a,f7.4,  a,d14.6,  a,d14.6, 132a1 )')
     $             ' ',xlow,' ',    z,' ',   er,' ',(line(i),i=1,lmx)
      ENDIF
      xlow=xlow+dx
  100 continue
      RETURN
!------------- two dimensional requires complete restoration!!!----------------
  200 continue
      nchx=B(ist+1)
      nchy=B(ist+5)
      WRITE(nout,2000) (lx,i=1,nchy)
 2000 format(1h ,10x,2hxx,100a1)
      do 300 kx=1,nchx
      do 250 ky=1,nchy
      k=ist +NBUF2 +kx+nchx*(ky-1)
      N=B(K)+1.99999D0
      n=max0(n,1)
      n=min0(n,22)
      IF(DABS(b(k)) .LT. 1D-20) n=1
      line(ky)=lchr(n)
  250 continue
      line(nchy+1)=lx
      i1=nchy+1
      WRITE(nout,2100) (line(i),i=1,i1)
 2100 format(1h ,10x,1hx,100a1)
  300 continue
      WRITE(nout,2000) (lx,i=1,nchy)
      RETURN
  900 WRITE(NOUT,*) ' +++BH_GPRINT: NONEXISTING HISTO',ID
      WRITE(6   ,*) ' +++BH_GPRINT: NONEXISTING HISTO',ID
      RETURN
 901  WRITE(NOUT,*) ' +++BH_GPRINT: nent.eq.0',ID
      WRITE(   6,*) ' +++BH_GPRINT: nent.eq.0',ID
      RETURN
 902  WRITE(NOUT,*) ' +++BH_GPRINT: wrong plotting limits',ID,bmin,bmax
      WRITE(   6,*) ' +++BH_GPRINT: wrong plotting limits',ID,bmin,bmax
      RETURN
 903  WRITE(NOUT,*) ' +++BH_GPRINT: bmin.eq.bmax',ID,bmin
      WRITE(   6,*) ' +++BH_GPRINT: bmin.eq.bmax',ID,bmin
      END

      SUBROUTINE ginbo1(id,title,nchx,xl,xu)
!     **************************************
      IMPLICIT DOUBLE PRECISION (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
      CHARACTER*80 title
!
      lact=jadres(id)
      IF(lact .EQ. 0) THEN
         WRITE(6,*) '+++++ STOP in ginbo1: wrong id=',id
         STOP
      ENDIF
      ist=index(lact,2)
      ist2   = ist+7
      nchx   = b(ist2 +1)
      xl     = b(ist2 +2)
      xu     = b(ist2 +3)
      title  = titlc(lact)
      END


      SUBROUTINE gpak(id,a)
!     *********************
! Loading in histogram content
!     ***********************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      DIMENSION  a(*)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
!
      lact=jadres(id)
      IF(lact .EQ. 0) goto 900
      ist  = index(lact,2)
      ist2 = ist+7
      nch=b(ist2 +1)
      local = ist+nbuf
! 2-dimens histo alowed
      iflag2   = nint(b(ist+4)-9d0-9d12)/10
      ityphi   = mod(iflag2,10)
      IF(ityphi .EQ. 2) THEN
        nchy  = b(ist2+5)
        nch   = nch*nchy
        local = ist+nbuf2
      ENDIF
      do 10 ib=1,nch
   10 b(local +ib) = a(ib)
! one nominal entry recorded
      index(lact,3)  = 1
      RETURN
  900 write(nout,*) '+++gpak: nonexisting id=',id
      WRITE(6   ,*) '+++gpak: nonexisting id=',id
      END

      SUBROUTINE gmaxim(id,wmax)
*     **************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
!
      IF(id .NE. 0) THEN
        lact=jadres(id)
        IF(lact .EQ. 0) RETURN
        ist= index(lact,2)
        b(ist+6) =wmax
        CALL gidopt(id,'YMAX')
      ELSE
        do 20 k=1,idmx
        IF(index(k,1) .EQ. 0) goto 20
        ist=index(k,2)
        jd =index(k,1)
        b(ist+6) =wmax
        CALL gidopt(jd,'YMAX')
   20   continue
      ENDIF
      END



      SUBROUTINE gminim(id,wmin)
*     **************************
      IMPLICIT DOUBLE PRECISION (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
!
      IF(id .NE. 0) THEN
        lact=jadres(id)
        IF(lact .EQ. 0) RETURN
        ist =index(lact,2)
        b(ist+5) =wmin
        CALL gidopt(id,'YMIN')
      ELSE
        do 20 k=1,idmx
        IF(index(k,1) .EQ. 0) goto 20
        ist=index(k,2)
        jd =index(k,1)
        b(ist+5) =wmin
        CALL gidopt(jd,'YMIN')
   20   continue
      ENDIF
      END

      SUBROUTINE GDELET(ID1)
*     *********************
! Now it should work (stj Nov. 91) but watch out!
! should works for 2-dim histos, please check this!
*     ***********************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHcglib/,/BHgind/
      LOGICAL gexist
!
      ID=ID1
      IF(id .EQ. 0) GOTO 300
      IF(.not.gexist(id)) GOTO 900
      lact = jadres(id)
      ist  = index(lact,2)
      ist2 = ist+7
*----
![[[      WRITE(6,*) 'GDELET-ing ID= ',ID
      idec    = nint(b(ist+2)-9d0-9d12)/10
      IF(idec .NE. id) WRITE(6,*) '++++GDELET: ALARM! ID,IDEC= ',ID,IDEC
*----
      nch  = b(ist2 +1)
      iflag2   = nint(b(ist+4)-9d0-9d12)/10
      ityphi   = mod(iflag2,10)
      IF(ityphi .EQ. 1) THEN
! one-dim.
        nchx  = b(ist2 +1)
        nch   = 2*nchx
! lenght of local histo to be removed
        local = nch+nbuf+1
      ELSEIF(ityphi .EQ. 2) THEN
! two-dim.
        nchx  = b(ist2 +1)
        nchy  = b(ist2 +5)
        nch   = nchx*nchy
! lenght of local histo to be removed
        local = nch+nbuf2+1
      ELSE
         WRITE(nout,*) '+++gdelet: wrong type id=',id
         WRITE(6   ,*) '+++gdelet: wrong type id=',id
        RETURN
      ENDIF
! starting position of next histo in storage b
      next = ist+1 +local
! move down all histos above this one
      DO 15 k =next,length
      b(k-local)=b(k)
   15 CONTINUE
! define new end of storage
      length=length-local
! clean free space at the end of storage b
      DO 20 k=length+1, length+local
   20 b(k)=0d0
! shift adresses of all displaced histos
      DO 25 l=lact+1,idmx
      IF(index(l,1) .NE. 0) index(l,2)=index(l,2)-local
   25 CONTINUE
! move entries in index down by one and remove id=lact entry
      DO 30 l=lact+1,idmx
      index(l-1,1)=index(l,1)
      index(l-1,2)=index(l,2)
      index(l-1,3)=index(l,3)
      titlc(l-1)=titlc(l)
   30 CONTINUE
! last entry should be always empty
      index(idmx,1)=0
      index(idmx,2)=0
      index(idmx,3)=0
      do 50 k=1,80
   50 titlc(idmx)(k:k)=' '
      RETURN
! -----------------------------------
! Deleting all histos at once!!!
  300 length=0
      DO 400 i=1,idmx
      DO 340 k=1,3
  340 index(i,k)=0
      DO 350 k=1,80
  350 titlc(i)(k:k)=' '
 400  CONTINUE
      RETURN
! -----------------------------------
 900  CONTINUE
      WRITE(nout,*) ' +++GDELET: nonexisting histo id= ',id
      WRITE(   6,*) ' +++GDELET: nonexisting histo id= ',id
      END



      SUBROUTINE glimit(lenmx)
*     ************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHgind/
c
      CALL g_init
c
      IF(lenmx .GE. lenmax) THEN
         lenmax=lenmx
      ELSE
         CALL gstop1('glimit: cant decrease storage lenmx  =',lenmx)
      ENDIF
      END



      SUBROUTINE copch(ch1,ch2)
*     *************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
* copies CHARACTER*80 ch1 into ch2 up to a first $ sign
      CHARACTER*80 ch1,ch2
      LOGICAL met

      met = .false.
      do 10 i=1,80
      IF( ch1(i:i) .EQ. '$' .or. met )   THEN
        ch2(i:i)=' '
        met=.true.
      ELSE
        ch2(i:i)=ch1(i:i)
      ENDIF
  10  continue
      END



      FUNCTION jadres(id1)
*     *********************
*--------------------------------------------------------------------
* Educated guess based on past history is used to find quickly
* location of the histogram in the matrix index.
* This is based on observation that subsequent histogram calls
* are linked into loops (so one can predict easily which histo will
* be called next time).
*--------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE /BHgind/
      SAVE iguess,jdlast,idlast
c
      DATA iguess,jdlast,idlast /-2141593,-3141593,-3141593/

      id=id1
! --- The case of ID=0 treated separately, it is used to find out
! --- last entry in the index (it is marked with zero)
      IF(id .EQ. 0) THEN
         DO i=1,idmx
            IF(index(i,1) .EQ. 0) goto 4
         ENDDO
         WRITE(6,*) '+++++jadres: STOP index to short'
         STOP
 4       CONTINUE
         jadres = i
         RETURN
      ENDIF

! --- Omit sophistications if lack of initialization
      IF(jdlast .EQ. -3141593) GOTO 10
      IF(iguess .EQ. -2141593) GOTO 10
      IF(iguess .EQ. 0) GOTO 10
      IF(jdlast .EQ. 0) GOTO 10

! --- Try first previous histo (for repeated calls)
      IF(jdlast .LT. 1 .OR. jdlast .GT. idmx) THEN
         WRITE(6,*) '+++++ jadres: jdlast=',jdlast
      ENDIF
      IF(index(jdlast,1) .EQ. id) THEN
         jadres = jdlast
!##   write(6,*)
!##   $   'found, guess based on previous call to jadres ',jdlast
         GOTO 20
      ENDIF

! --- Try current guess based on previous call
      IF(iguess .LT. 1 .OR. iguess .GT. idmx)  THEN
         WRITE(6,*)'+++++ jadres: iguess=',iguess
      ENDIF
      IF(index(iguess,1) .EQ. id) THEN
         jadres = iguess
!##   write(6,*)
!##   $   'found, guess on previous calls recorded in b(ist+7)',jdlast
         GOTO 20
      ENDIF

! ================================================
!    Do it HARD WAY, Search all matrix index
! ================================================
 10   CONTINUE
!##   write(6,*) 'trying HARD WAY'
      DO i=1,idmx
         jadres=i
         IF(index(i,1) .EQ. id) GOTO 20
      ENDDO
! -------------------------------------
!     Nothing found: jadres=0
! -------------------------------------
      jadres=0
      RETURN
! =====================================
!     Found: Set new guess for next call
! =====================================
 20   CONTINUE
! --- and store result as a new guess in previous histo
! --- but only if it existed!!!!
      DO i=1,idmx
         IF(index(i,1) .EQ. 0) GOTO 40
         IF(index(i,1) .EQ. idlast) THEN
            ist=index(i,2)
            IF(ist .GT. 0 .AND. ist .LT. 50000) b(ist +7) = jadres
!##   write(6,*) 'STORED     id=',id
            GOTO 40
         ENDIF
      ENDDO
 40   CONTINUE
!##   write(6,*)  'found, hard way searching all of index)', jdlast
      iguess = b( index(jadres,2) +7)
      jdlast = jadres
      idlast = id
      END

!======================end of gbook====================================


c  gen_bhw104


      SUBROUTINE gmonit(mode,id,par1,par2,par3)
!     *****************************************
! Utility program for monitoring m.c. rejection weights.
! ---------------------------------------------------------
! It is backward compatible with WMONIT except:
!  (1) for id=-1 one  should call as follows:
!      gmonit(-1,id,0d0,1d0,1d0) or skip initialisation completely!
!  (2) maximum absolute weight is looked for,
!  (3) gprint(-id) prints weight distribution, net profit!
!  (4) no restriction id<100 any more!
! ---------------------------------------------------------
! wt is weight, wtmax is maximum weight and rn is random number.
! IF(mode .EQ. -1) then
!          initalization if entry id,
!        - wtmax is maximum weight used for couting overweighted
!          other arguments are ignored
! ELSEIF(mode .EQ. 0) then
!          summing up weights etc. for a given event for entry id
!        - wt is current weight.
!        - wtmax is maximum weight used for couting overweighted
!          events with wt>wtmax.
!        - rn is random number used in rejection, it is used to
!          count no. of accepted (rn < wt/wtmax) and rejected
!          (wt > wt/wtmax) events,
!          if ro rejection then put rn=0d0.
! ELSEIF(mode .EQ. 1) THEN
!          in this mode wmonit repports on accumulated statistics
!          and the information is stored in COMMON /cmonit/
!        - averwt= average weight wt counting all event
!        - errela= relative error of averwt
!        - nevtot= total number of accounted events
!        - nevacc= no. of accepted events (rn < wt/wtmax)
!        - nevneg= no. of events with negative weight (wt < 0)
!        - nevzer= no. of events with zero weight (wt = 0d0)
!        - nevove= no. of overweghted events (wt > wtmax)
!          and if you do not want to use cmonit then the value
!          the value of averwt is assigned to wt,
!          the value of errela is assigned to wtmax and
!          the value of wtmax  is assigned to rn in this mode.
! ELSEIF(mode .EQ. 2) THEN
!          all information defined for entry id defined above
!          for mode=2 is just printed of unit nout
! ENDIF
! note that output repport (mode=1,2) is done dynamically just for a
! given entry id only and it may be repeated many times for one id and
! for various id's as well.
!     ************************
      IMPLICIT double precision (a-h,o-z)
      PARAMETER( idmx=400,nbuf=24,nbuf2=24)
      COMMON /BHcglib / b(50000)
      COMMON /BHgind/nvrs,nout,lenmax,length,index(idmx,3),titlc(idmx)
      CHARACTER*80 titlc
      SAVE
!
      idg = -id
      IF(id .LE. 0) THEN
           WRITE(nout,*) ' =====> Gmonit: wrong id= ',id
           WRITE(   6,*) ' =====> Gmonit: wrong id= ',id
           STOP
      ENDIF
      IF(mode .EQ. -1) THEN
!     *******************
           nbin = nint(dabs(par3))
           IF(nbin .GT. 100) nbin =100
           IF(nbin .EQ. 0)   nbin =1
           xl   =  par1
           xu   =  par2
           IF(xu .LE. xl) THEN
             xl = 0d0
             xu = 1d0
           ENDIF
           lact=jadres(idg)
           IF(lact .EQ. 0) THEN
              CALL gbook1(idg,' gmonit $',nbin,xl,xu)
           ELSE
              WRITE(nout,*) ' WARNING gmonit: exists, id= ',id
              WRITE(   6,*) ' WARNING gmonit: exists, id= ',id
           ENDIF
      ELSEIF(mode .EQ. 0) THEN
!     **********************
           lact=jadres(idg)
           IF(lact .EQ. 0) THEN
              WRITE(nout,*) ' *****> Gmonit: uninitialized, id= ',id
              WRITE(   6,*) ' *****> Gmonit: uninitialized, id= ',id
              CALL gbook1(idg,' gmonit $',1,0d0,1d0)
              lact=jadres(idg)
           ENDIF
           wt   =par1
           wtmax=par2
           rn   =par3
!     standard entries
           CALL gf1(idg,wt,1d0)
!     additional goodies
           ist  = index(lact,2)
           ist2 = ist+7
           ist3 = ist+11
!    maximum weight -- maximum by absolute value but keeping sign
           b(ist3+13)    = max( dabs(b(ist3+13)) ,dabs(wt))
           IF(wt .NE. 0d0) b(ist3+13)=b(ist3+13) *wt/dabs(wt)
!    nevzer,nevove,nevacc
           IF(wt .EQ. 0d0)        b(ist3+10) =b(ist3+10) +1d0
           IF(wt .GT. wtmax)      b(ist3+11) =b(ist3+11) +1d0
           IF(rn*wtmax .LE. wt)   b(ist3+12) =b(ist3+12) +1d0
      ELSEIF(mode .GE. 1 .OR. mode .LE. 10) THEN
!     *************************************
           lact=jadres(idg)
           IF(lact .EQ. 0) THEN
              WRITE(nout,*) ' +++++++++ STOP in  wmonit ++++++++++++++'
              WRITE(   6,*) ' +++++++++ STOP in  wmonit ++++++++++++++'
              WRITE(nout,*) ' lack of initialization, id=',id
              WRITE(   6,*) ' lack of initialization, id=',id
              STOP
           ENDIF
           ist    = index(lact,2)
           ist2   = ist+7
           ist3   = ist+11
           ntot   = nint(b(ist3 +7))
           swt    =      b(ist3 +8)
           sswt   =      b(ist3 +9)
           IF(ntot .LE. 0 .or. swt  .EQ.  0d0 )  THEN
              averwt=0d0
              errela=0d0
           ELSE
              averwt=swt/float(ntot)
              errela=sqrt(abs(sswt/swt**2-1d0/float(ntot)))
           ENDIF
           nevacc = b(ist3 +12)
           nevneg = b(ist3  +1)
           nevove = b(ist3 +11)
           nevzer = b(ist3 +10)
           wwmax  = b(ist3 +13)
           nevtot = ntot
!  output through parameters
           par1   = averwt
           par2   = errela
           par3   = nevtot
           IF(mode .EQ. 2) THEN
              par1   = nevacc
              par2   = nevneg
              par3   = nevove
           ELSEIF(mode .EQ. 3) THEN
              par1   = nevneg
              par2   = nevzer
              par3   = wwmax
           ENDIF
!  no printout for mode > 1
!  ************************
           IF(mode .LE. 9) RETURN
           WRITE(nout,1003) id, averwt, errela, wwmax
           WRITE(nout,1004) nevtot,nevacc,nevneg,nevove,nevzer
           IF(mode .EQ. 2) RETURN
           CALL BH_GPRINT(idg)
      ELSE
!     ****
           WRITE(nout,*) ' =====wmonit: wrong mode',mode
           WRITE(   6,*) ' =====wmonit: wrong mode',mode
           STOP
      ENDIF
!     *****
 1003 format(
     $  ' =======================gmonit========================'
     $/,'   id           averwt         errela            wwmax'
     $/,    i5,           e17.7,         f15.9,           e17.7)
 1004 format(
     $  ' -----------------------------------------------------------'
     $/,'      nevtot      nevacc      nevneg      nevove      nevzer'
     $/,   5i12)
      END

c  gen_bhw104

      SUBROUTINE ZbcOFF
*     *****************
!---------------------------------------------------------------!
! Switch OFF the Z-boson contribution in the ALIBABA part.      !
! Written by: Wieslaw Placzek                 CERN, Dec. 1998   !
! Last update: 09.12.1998     by: W.P.                          !
!---------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      SAVE

      DO I = 0 , NRMASS
        VF(I) = 0d0
        AF(I) = 0d0
      ENDDO
      END

c  gen_bhw104

      SUBROUTINE SETCHA(Ichann)
*     *************************
!---------------------------------------------------------------!
! Set up a process channel in ALIBABA:                          !
! Ichann = 0/1/2: s+t/s-only/t-only channel.                    !
! Written by: Wieslaw Placzek                 CERN, Dec. 1998   !
! Last update: 10.12.1998     by: W.P.                          !
!---------------------------------------------------------------!
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      SAVE   / BHPAR3 /
!
      KeyCha = MOD(KeyOpt,1000)/100
      Ichann = KeyCha
      END

c  gen_bhw104

      SUBROUTINE babewc(s,t,epsCMS,dsig0,dsig)
*     ****************************************
!---------------------------------------------------------------!
! This routine comes originally from BABAMC (see below).        !
! Modified by: Wieslaw Placzek           Knoxville, Oct. 1995   !
! Last update: 08.02.1996     by: W.P.                          !
!---------------------------------------------------------------!
!WP   SUBROUTINE BABCOR(S,T,DEL, DSIG0,DSIG)
C
C THE 'WORKING HORSE' THAT CALCULATES THE CORRECTED D(SIGMA)/D(OMEGA)
C
C   S,T ARE THE MANDELSTAM VARIABLES
C   DEL IS MAXIMUM PHOTON ENERGY / BEAM ENERGY
C   DSIG0: DIFFERENTIAL BORN CROSS SECTION (IN PBARN)
C   DSIG : DIFFERENTIAL CROSS SECTION WITH RAD. CORRECTIONS (PBARN)
C
C  MZ, MW, MH ARE THE BOSON MASSES, ME,...MT THE FERMION MASSES IN GEV.
C  SW = SIN**2 THETA-W, CW = COS**2 THETA-W, THETA-W = WEINBERG ANGLE.
C  V,A ARE THE LEPTONIC VECTOR AND AXIALVECTOR COUPLING CONSTANTS;
C  VU,AU THOSE OF I=1/2 QUARKS; VD,AD THOSE OF I=-1/2 QUARKS
C  (ALL NORMALIZED TO E=SQRT(4*PI*ALFA)).
C  GZ IS THE WIDTH OF THE Z IN GEV.
C  MF(I,J) IS THE ARRAY OF FERMION MASSES, WHERE I =1,..6 AND J=1,2;
C  LEPTONS(I=1,2,3) AND QUARKS(I=4,5,6);  J=1: UP,  J=2: DOWN MEMBERS.
C  VF IS THE CORRESPONDING ARRAY OF THE FERMION VECTOR COUPLINGS,
C  VF2, AF2 ARE THE CORRESPONDING ARRAYS OF THE VECTOR AND AXIALVECTOR
C  COUPLINGS SQUARED.
C  M IS THE ARRAY OF THE FERMION MASSES SQUARED.
C  ALFA = 1/137.036, ALPHA = ALFA/4*PI, AL = ALFA/PI
C*****************************************************************
      IMPLICIT REAL*8(A-Z)
      COMPLEX*16   CIR1,PIGS,PIGT,PIG,X1C,X2C,SP1,SP2,SPENCE,CHIS,
     1             TGZS,TGZTS,TZZTS,TZBZS,TZBZTS,TWZS,TWZTS,TGVZS,
     2             TGZ5S,TZZZ5S,TGGZS,TGGZTS,TGZZST,TGZZTS,TGGVT,
     3             TGGVS,TGVZST,TGVZTS,TGVZT,TGZVS,TGZVST,TGZVTS,
     4             TGZVT,TZVZS,TZVZST,TZVZTS,TZVZT,TGGVST,TGGVTS,
     5             FZVS,FZAS,FZVT,FZAT,FGVS,FGAS,FGVT,FGAT,
     6             CFZVS,CFZAS,CFGVS,CFGAS,FS1,FS2,FT1,FT2,
     7             ZS,PROP,PIZS,CHITC,TGZST,TGZT
      DIMENSION MF(6,2),VF(6,2),M(6,2),VF2(6,2),AF2(6,2)
      COMMON /BHBOS/MZ,MW,MH
      COMMON /BHLEPT/ME,MMU,MTAU
     1       /BHHAD/MU,MD,MS,MC,MB,MT
     2       /BHCOUP/SW,CW,V,A,VU,AU,VD,AD
     3       /BHWIDTH/GZ
     4       /BHALF/AL,ALPHA,ALFA
     5       /BHFERMI/MF,VF,M,VF2,AF2
     6       /BHCONV/CST
!WP: Common block from BHWIDE
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      INTEGER           KEYRAD,KEYOPT,KeyEWC
      SAVE
C
!WP: Switch for weak corrections
      KeyEWC = MOD(KeyRad,10000)/1000
!WP: Soft photon cut-off
      DEL = epsCMS
C  LEPTONIC COUPLING CONSTANTS
      SW1=DSQRT(SW)
      CW1=DSQRT(CW)
      A2=A*A
      V2=V*V
      W=V2+A2
      U=2.D0*V*A
C  Z PROPAGATOR
      MZ2=MZ**2
      G2=GZ**2
      SM=S-MZ2
      TM=T-MZ2
      DS=SM**2+MZ2*G2
!WP   DT=TM**2+MZ2*G2
      DT=TM**2
      CHISR=S*SM/DS
      CHITR=T*TM/DT
      CHISI=-MZ*GZ/DS*S
      CHITI=0.D0
      CHITC=DCMPLX(CHITR,CHITI)
      CHIT=T/TM
      CHIS=DCMPLX(CHISR,CHISI)
      CHIS2=S*S/DS
      CHIT2=(T/TM)**2
C   COMBINATION OF ANGLES
      C=1.D0+2.D0*T/S
      C2=1.D0+C*C
      C1=1.D0-C
      C0=1.D0+C
      C3=C0**2/C1
      C4=(C0**2+4.D0)/C1**2
      C5=(C0**2-4.D0)/C1**2
C
      PI=3.1415926536D0
C
C  NOW THE TIJ... ARE SPECIFIED        ********************
C
C  1) BORN TERMS:
      TGZS=(V2*C2+2.D0*A2*C)*CHIS
      TGZST=-W*C3*CHITC
      TGZTS=-W*C3*CHIS
      TGZT=(V2*C4+A2*C5)*2.D0*CHITC
C
      TZZS=(W*W*C2+U*U*2.D0*C)*CHIS2
      TZZTS=-(W*W+U*U)*C3*CHIS*CHITC
      TZZT=(W*W*C4+U*U*C5)*2.D0*CHIT2
C
C  2) TERMS APPEARING IN THE PHOTON-Z-MIXING PART
C
      TGGZS=2.D0*V*C2*CHIS
      TGGZST=-2.D0*V*C3*CHIT
      TGGZTS=-2.D0*V*C3*CHIS
      TGGZT=4.D0*V*C4*CHIT
C
      TGZZS=2.D0*(V*W*C2+A*U*2.D0*C)*CHIS2
      TGZZST=-2.D0*(V*W+A*U)*DCONJG(CHIS)*CHIT*C3
      TGZZTS=-2.D0*(V*W+A*U)*CHIS*CHIT*C3
      TGZZT=4.D0*(V*W*C4+A*U*C5)*CHIT2
C
C  3) TERMS WITH WEAK VERTEX CORRECTIONS
C
!WP: Including weak corrections
      IF (KeyEWC.EQ.1) THEN

        CALL FGAM(S,FGVS,FGAS)

        CALL FGAM(T,FGVT,FGAT)

        CALL BH_FZ(S,FZVS,FZAS)

        CALL BH_FZ(T,FZVT,FZAT)

      ELSE
        FGVS = 0
        FGAS = 0
        FGVT = 0
        FGAT = 0
        FZVS = 0
        FZAS = 0
        FZVT = 0
        FZAT = 0
      ENDIF
      CFGVS=DCONJG(FGVS)
      CFGAS=DCONJG(FGAS)
      CFZVS=DCONJG(FZVS)
      CFZAS=DCONJG(FZAS)
C
      TGGVS=2.D0*FGVS*C2
      TGGVST=-2.D0*FGVT*C3
      TGGVTS=-2.D0*FGVS*C3
      TGGVT=4.D0*FGVT*C4
C
      TGVZS=2.D0*(V*(V*CFGVS+A*CFGAS)*C2+A*(V*CFGAS+A*CFGVS)*2.D0*C)
     1      *CHIS
      TGVZST=-2.D0*(W*CFGVS+U*CFGAS)*C3*CHIT
      TGVZTS=-2.D0*(W*FGVT+U*FGAT)*C3*CHIS
      TGVZT=4.D0*(V*(V*FGVT+A*FGAT)*C4+A*(V*FGAT+A*FGVT)*C5)*CHIT
C
      TGZVS=2.D0*(V*FZVS*C2+A*FZAS*2.D0*C)*CHIS
      TGZVST=-2.D0*(V*FZVT+A*FZAT)*C3*CHIT
      TGZVTS=-2.D0*(V*FZVS+A*FZAS)*C3*CHIS
      TGZVT=  (V*FZVT*C4+   A*FZAT*C5)*4.D0*CHIT
C
      FS1=V*CFZVS+A*CFZAS
      FS2=V*CFZAS+A*CFZVS
      FT1=V*FZVT+A*FZAT
      FT2=V*FZAT+A*FZVT
C
      TZVZS=2.D0*(W*FS1*C2+U*FS2*2.D0*C)*CHIS2
      TZVZST=-2.D0*(W*FS1+U*FS2)*C3*CHIT*DCONJG(CHIS)
      TZVZTS=-2.D0*(W*FT1+U*FT2)*C3*CHIT*CHIS
      TZVZT=4.D0*(W*FT1*C4+U*FT2*C5)*CHIT2
C
C
C  4) TERMS WHICH APPEAR WITH BOX DIAGRAMS
C
      TGZB=W*W*C2+U*U*2.D0*C
      TGZBST=-(W**2+U**2)*C3
      TGZBT=2.D0*(W*W*C4+U*U*C5)
C
      S16=16.D0*SW**2
      TGWS=C0*C0/S16
      TGWST=-2.D0*C3/S16
      TGWT=4.D0*(C0/C1)**2/S16
C
      W3=V2+3.D0*A2
      U3=3.D0*V2+A2
      TZBZS=(V2*W3*W3*C2+A2*U3*U3*2.D0*C)*CHIS
      TZBZST=-(V2*W3*W3+A2*U3*U3)*CHIT
      TZBZTS=TZBZST/CHIT*CHIS
      TZBZT=2.D0*(V2*W3*W3*C4+A2*U3*U3*C5)*CHIT
C
      VA2=(V+A)**2/S16
      TWZS=VA2*C0*C0*CHIS
      TWZST=-2.D0*VA2*C3*CHIT
      TWZTS=TWZST/CHIT*CHIS
      TWZT=4.D0*VA2*(C0/C1)**2*CHIT
C
      TGZ5S=(A2*C2+V2*2.D0*C)*CHIS
      TGZ5T =2.D0 *(A2*C4+V2*C5)*CHIT
      TZZ5S=(U*U*C2+W*W*2.D0*C)*CHIS2
      TZZ5T=2.D0*(U*U*C4+W*W*C5)*CHIT2
C
      TGZZ5S=U*U*C2+W*W*C*2.
      TGZZ5T=2.D0*(U*U*C4+W*W*C5)
      TZZZ5S=(A2*U3*U3*C2+V2*W3*W3*2.D0*C)*CHIS
      TZZZ5T=2.D0*(A2*U3*U3*C4+V2*W3*W3*C5)*CHIT
C
C END OF DEFINITION OF THE TIJ... TERMS      **************
C
C  NOW THE INFRARED CORRECTIONS ARE CALLED:
C  CIR: NON RESONANT
C  CIR1: INTERFERENCE RESONANT - NON RESONANT
C  CIR2: RESONANT
      CALL INFRA(DEL,S,T,CIR,CIR1,CIR2)
C  DEL: MAX. PHOTONENERGY/BEAM ENERGY
C  CIR1 COMPLEX, OTHERS REAL
C
C  SPECIFICATION OF THE FINITE QED CORRECTIONS:
      ME2=ME*ME
      BE=   DLOG(S/ME2)-1.D0
      X1=C1/2.D0
      X2=C0/2.D0
      DX1=DLOG(X1)
      DX2=DLOG(X2)
      X1C=DCMPLX(X1,0.D0)
      X2C=DCMPLX(X2,0.D0)
      SP1=SPENCE(X1C)
      SP2=SPENCE(X2C)
      X=DX1**2-DX2**2-2.D0*DBLE(SP1)+2.D0*DBLE(SP2)
      Z= 3.D0*BE-1.D0+2.D0*PI**2/3.D0
      Y=1.5D0*DX1-.5D0*DX1**2-PI**2/2.D0
C  TWO PHOTON BOXES

      CALL GBOX(S,T,V1S,V2S,A1S,A2S,V1T,V2T,A1T,A2T)

C  PHOTON-Z BOXES

      CALL GZBOX(S,T,V1ZS,V2ZS,A1ZS,A2ZS,V1ZT,V2ZT,A1ZT,A2ZT)

C  PHOTON VACUUM POLARIZATION
!WP   PIGS=PIG(S)
!WP   PIGT=PIG(T)
!WP   RPIGS=DBLE(PIGS)
!WP   IPIGS=DIMAG(PIGS)
!WP   RPIGT=DBLE(PIGT)
!WP: Vacuum polarization included in BHWIDE routines
      IF (KeyEWC.EQ.1) THEN
        PIGS  = PIG(S)
      ELSE
        PIGS = 0
      ENDIF
      PIGT  = 0
      RPIGS = 0
      IPIGS = DIMAG(PIGS)
      RPIGT = 0
C  SPECIFICATION OF THE WEAK CORRECTIONS:
C  Z BOSON SELF ENERGY
!WP: Obsolete!
!WP   RZS=RESZ(S)
!WP   IZS=IMSZ(S)
!WP   RZT=RESZ(T)
      RZS = 0
      IZS = 0
      RZT = 0
      ZS=DCMPLX(RZS,IZS)
      GM= MZ*GZ
      PROP= DCMPLX(SM,GM)
!WP   PIZS= PROP/(SM+ZS)-1.D0
!WP   PIZT= TM/(TM+RZT)-1.D0
      PIZS = 0
      PIZT = 0
      RPIZT=PIZT
      RPIZS=DBLE(PIZS)
      IPIZS=DIMAG(PIZS)
!WP: Including weak corrections
      IF (KeyEWC.EQ.1) THEN
C  PHOTON-Z MIXING ENERGY
        RPIGZS=-RESGZ(S)/S
        IPIGZS=-IMSGZ(S)/S
        RPIGZT=-RESGZ(T)/T
C  HEAVY BOX DIAGRAMS
        CALL BH_BOX(S,T,V1ZZS,V2ZZS,A1ZZS,A2ZZS,
     1             V1ZZT,V2ZZT,A1ZZT,A2ZZT,
     2             V1WS,V2WS,V1WT,V2WT)
      ELSE
        RPIGZS = 0
        IPIGZS = 0
        RPIGZT = 0
        V1ZZS = 0
        V2ZZS = 0
        A1ZZS = 0
        A2ZZS = 0
        V1ZZT = 0
        V2ZZT = 0
        A1ZZT = 0
        A2ZZT = 0
        V1WS  = 0
        V2WS  = 0
        V1WT  = 0
        V2WT  = 0
      ENDIF
C  COMPOSITION OF THE "REDUCED CROSS SECTIONS"     ***********
C  PHOTON-PHOTON
      DEL1=CIR+2.D0*RPIGS+AL*(X+Z+V1S+A1S*2.D0*C/C2)
      DEL2=CIR+RPIGS+RPIGT+AL*(X+Y+Z+.5D0*(V1S+V1T+A1S+A1T))
      DEL3=CIR+2.D0*RPIGT+AL*(X+2.D0*Y+Z+V1T+A1T*C5/C4)
      SGGS=C2*(1.D0+DEL1)+2.D0*DBLE(TGGVS)
     1    +AL*(TGZB*V1ZZS+TGZZ5S*A1ZZS+TGWS*V1WS)
      SGGST=-2.D0*C3*(1.D0+DEL2)
     1    +2.D0*DBLE(TGGVTS+TGGVST)
     2     +AL*(TGZBST*(V1ZZS+A1ZZS+V1ZZT+A1ZZT)
     3          +TGWST*(V1WS+V1WT))
      SGGT=2.D0*C4*(1.D0+DEL3)
     1     +2.D0*DBLE(TGGVT)
     2     +AL*(TGZBT*V1ZZT+TGZZ5T*A1ZZT+TGWT*V1WT)
C  PHOTON-Z-INTERFERENCE
      RCIR=DBLE(CIR1)
      ICIR=DIMAG(CIR1)
      DEL11=RCIR+RPIGS+AL*(X+Z+.5D0*(V1S+V1ZS))+RPIZS
      DEL12=ICIR-IPIGS+ALFA*(V2ZS-V2S)+IPIZS
      SGZS=2.D0*DBLE(TGZS)*(1.+DEL11)-DIMAG(TGZS)*DEL12*2.D0
     1    +AL*DBLE(TGZ5S)*(A1S+A1ZS)-2.D0*ALFA*DIMAG(TGZ5S)
     &                              *(A2ZS-A2S)
     2    +2.D0*DBLE(TGGZS)*RPIGZS -2.D0*DIMAG(TGGZS)*IPIGZS
     3    +2.D0*DBLE(TGVZS+TGZVS)
     4    +AL*(DBLE(TZBZS)*V1ZZS+DBLE(TZZZ5S)*A1ZZS
     5         +DBLE(TWZS)*V1WS)
     6    +2.D0*ALFA*(DIMAG(TZBZS)*V2ZZS+DIMAG(TZZZ5S)*A2ZZS
     7              +DIMAG(TWZS)*V2WS)
C
      DEL21=CIR+RPIGS+AL*(X+Y+Z+.5D0*(V1S+A1S+V1ZT+A1ZT))+RPIZT
      DEL22=IPIGS-ALFA*(1.5D0-V2S-A2S+V2ZT+A2ZT)
      SGZST=  DBLE(TGZST)*(1.D0+DEL21)*2.D0
     1      +2.D0*TGGZST*RPIGZT +2.D0*DBLE(TGVZST+TGZVST)
     2      +AL*(TZBZST*(V1ZZS+A1ZZS)+TWZST*V1WS)
      DEL31=RCIR+RPIGT+AL*(X+Y+Z+.5D0*(V1T+A1T+V1ZS+A1ZS))+RPIZS
      DEL32=ICIR-ALFA *(1.5D0 +A2T-V2ZS-A2ZS+V2T)+IPIZS
      SGZTS=2.D0*DBLE(TGZTS)*(1.D0+DEL31)-2.D0*DIMAG(TGZTS)*DEL32
     1     +2.D0*DBLE(TGGZTS)*RPIGZS-2.D0*DIMAG(TGGZTS)*IPIGZS
     2     +2.D0 *DBLE(TGVZTS+TGZVTS)
     3     +AL*(DBLE(TZBZTS)*(V1ZZT+A1ZZT)+DBLE(TWZTS)*V1WT)
     4     +2.D0*ALFA*(DIMAG(TZBZTS)*(V2ZZT+A2ZZT)
     5               +DIMAG(TWZTS)*V2WT)
      DEL41=CIR+RPIGT+AL*(X+2.D0*Y+Z+.5D0*(V1T+V1ZT))+RPIZT
      SGZT=2.D0*DBLE(TGZT)*(1.D0+DEL41)+    TGZ5T *AL*(A1T+A1ZT)
     1     +2.D0*TGGZT*RPIGZT+2.D0*DBLE(TGZVT+TGVZT)
     2     +AL*(TZBZT*V1ZZT+TZZZ5T*A1ZZT+TWZT*V1WT)
C  Z-Z TERMS
      DEL51=CIR2+AL*(X+Z+V1ZS)+2.D0*RPIZS
      SZZS=TZZS*(1.D0+DEL51)+TZZ5S*AL*A1ZS
     1    +2.D0*TGZZS*RPIGZS+2.D0*DBLE(TZVZS)
      DEL61=RCIR+AL*(X+Y+Z+.5D0*(V1ZS+V1ZT+A1ZS+A1ZT))+RPIZS+PIZT
      DEL62=ICIR-ALFA*(1.5D0+V2ZT-V2ZS+A2ZT-A2ZS)+IPIZS
      SZZST=2.D0*DBLE(TZZTS)*(1.+DEL61)-2.*DIMAG(TZZTS)*DEL62
     1     +2.D0*DBLE(TGZZTS)*(RPIGZS+RPIGZT)
     2     +2.D0*DBLE(TZVZTS+TZVZST)-2.D0*DIMAG(TGZZTS) *IPIGZS
      DEL71=CIR+AL*(X+2.D0*Y+Z +V1ZT )+2.D0*PIZT
      SZZT=TZZT*(1.D0+DEL71)+TZZ5T*AL*A1ZT
     1    +2.D0*TGZZT*RPIGZT+2.D0*DBLE(TZVZT)
C  RADIATIVELY CORRECTED CROSS SECTION
      DSIG=SGGS+SGZS+SZZS
     1    +SGGST+SGZST+SGZTS+SZZST
     3    +SGGT+SGZT+SZZT
      DSIG=DSIG*CST
C  CROSS SECTION IN LOWEST ORDER IN NBARN
      DSIG0=C2-2.D0*C3+2.D0*C4
     1     +2.D0*DBLE(TGZS+TGZTS)+(TGZT+TGZST)*2.D0
     2     +TZZS+2.D0*DBLE(TZZTS)+TZZT
      DSIG0=DSIG0*CST
      END

c  gen_bhw104

      FUNCTION xmatel(p1,q1,p2,q2,pk)
*     *******************************
!----------------------------------------------------------------------!
! This function provides a value of the matrix element squared for     !
! Bhabha scattering including single hard photon radiation.            !
!                                                                      !
!         e+(p1) + e-(q1) ---> e+(p2) + e-(q2) + gamma(pk)             !
!                                                                      !
! where p1, q1, p2, q2, pk  are 4-momenta of corresponding particles.  !
!                                                                      !
! INPUT:  p1(4),q1(4),p2(4),q2(4),pk(4) - 4-momenta of the particles,  !
!                                       all FERMIONS must be MASSIVE!  !
!                                                                      !
! Note: Vacuum polarization corrections are included in the above      !
!       matrix element as Dyson-type factors at the level of the       !
!       helicity amplitudes calculation.                               !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                 Knoxville, May 1995      !
! Last update: 07.02.1996      by: W. P.                               !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      REAL*8 p1(4) ,q1(4) ,p2(4) ,q2(4) ,pk(4)
      REAL*8 p1r(4),q1r(4),p2r(4),q2r(4),pkr(4)
      COMPLEX*16 amp(12)
!
! Rescaling 4-momenta of all particles for the massless limit
      pmod = SQRT(p2(1)**2 +p2(2)**2 +p2(3)**2)
      qmod = SQRT(q2(1)**2 +q2(2)**2 +q2(3)**2)
      refa = ( pmod + qmod + pk(4) )/( p1(4) + q1(4) )
      DO i=1,4
         p1r(i) = p1(i)
         q1r(i) = q1(i)
         p2r(i) = p2(i)/refa
         q2r(i) = q2(i)/refa
         pkr(i) = pk(i)/refa
      ENDDO
      p1r(3) = p1r(4)
      q1r(3) =-q1r(4)
      p2r(4) = pmod/refa
      q2r(4) = qmod/refa
! Matrix element squared for massless spinors

      CALL amphel(p1r,q1r,p2r,q2r,pkr,amp)

      suma = 0
      DO i=1,12
         suma = suma + amp(i)*DCONJG(amp(i))
      ENDDO
      xmem0 = suma/4
! Mass correction terms (here fermions must be massive!)
      xmemc = xmelmc(p1,q1,p2,q2,pk)
! Total matrix element squared
      xmatel = xmem0 + xmemc
      END

c  gen_bhw104

      SUBROUTINE amphel(p1,q1,p2,q2,pk,amp)
*     *************************************
!----------------------------------------------------------------------!
! This routine calculates helicity amplitude for the Bhabha scattering !
! process with sigle photon radiation:                                 !
!                                                                      !
!    e+(p1,l1) + e-(q1,l2) ---> e+(p2,l3) + e-(q2,l4) + gamma(pk,l5)   !
!                                                                      !
! where p1, q1, p2, q2, pk  are 4-momenta of corresponding particles,  !
! while l1, l2, l3, l4, l5 are their helicities.                       !
! Note: Both gamma and Z exchange diagrams are included.               !
!                                                                      !
! INPUT:  p1(4),q1(4),p2(4),q2(4),pk(4) - 4-momenta of the particles,  !
!                                      all PARTICLES must be MASSLESS! !
! OUTPUT: amp(12) - complex-type array of 12 helicity amplitudes,      !
!                   amp(i) = M(l1,l2,l3,l4,l5);                        !
!                                                                      !
!          amp( 1) = M(+++++),     amp( 2) = M(++++-)                  !
!          amp( 3) = M(----+),     amp( 4) = M(-----)                  !
!          amp( 5) = M(-++-+),     amp( 6) = M(-++--)                  !
!          amp( 7) = M(+--++),     amp( 8) = M(+--+-)                  !
!          amp( 9) = M(+-+-+),     amp(10) = M(+-+--)                  !
!          amp(11) = M(-+-++),     amp(12) = M(-+-+-)                  !
!                                                                      !
! Note: Vacuum polarization corrections are included in the above      !
!       helicity aplitudes as Dyson-type factors.                      !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                 Knoxville, May 1995      !
! Last update: 19.01.1999      by: W. P.                               !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      PARAMETER( PI = 3.1415926535897932D0, ALFINV = 137.0359895D0)
      PARAMETER( ALFPI=  1D0/PI/ALFINV ,ALFA=1D0/ALFINV)
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      SAVE   / BHPAR3 /, / BHPARZ /
      REAL*8 p1(4),q1(4),p2(4),q2(4),pk(4)
      COMPLEX*16 amp(12)
      COMPLEX*16 Fspinp,Gspinp
      COMPLEX*16 F1 ,F2 ,F3 ,F4 ,F5 ,F6 ,G1 ,G2 ,G3 ,G4
      COMPLEX*16 F1s,F2s,F3s,F4s,F5s,F6s,G1s,G2s,G3s,G4s
      COMPLEX*16 c,Rs,gs,zs,gs1,zs1
      SAVE e,c,ale,ari,alar,ale2,ari2,ifset

      DATA ifset /0/

! Statement functions for propagator factors
      Rs(a,gs,zs) = gs + a*zs
      Rt(a,gt,zt) = gt + a*zt
!
! Set up some constants
      IF (ifset.EQ.0) THEN
        ifset = 1
! Electric charge
        e = SQRT(4*PI*ALFA)
        c = DCMPLX(0d0,2*DSQRT(2d0)*e**3)
! Left and right coupling constant for Z exchange
        ale  = GV + GA
        ari  = GV - GA
        alar = ale*ari
        ale2 = ale**2
        ari2 = ari**2
      ENDIF
! Mandelstam variables
      s  = 2*( p1(4)*q1(4)-p1(3)*q1(3)-p1(2)*q1(2)-p1(1)*q1(1) )
      s1 = 2*( p2(4)*q2(4)-p2(3)*q2(3)-p2(2)*q2(2)-p2(1)*q2(1) )
      tp =-2*( p1(4)*p2(4)-p1(3)*p2(3)-p1(2)*p2(2)-p1(1)*p2(1) )
      tq =-2*( q1(4)*q2(4)-q1(3)*q2(3)-q1(2)*q2(2)-q1(1)*q2(1) )
      u  =-2*( p1(4)*q2(4)-p1(3)*q2(3)-p1(2)*q2(2)-p1(1)*q2(1) )
      u1 =-2*( q1(4)*p2(4)-q1(3)*p2(3)-q1(2)*p2(2)-q1(1)*p2(1) )
! gamma and Z propagator factors

      CALL profas(s ,gs ,zs )
      CALL profas(s1,gs1,zs1)
      CALL profat(tp,gtp,ztp)
      CALL profat(tq,gtq,ztq)

! Functions of spinor products
      F1 = Fspinp(p1,q1)
      F2 = Fspinp(p2,q2)
      F3 = Fspinp(p1,p2)
      F4 = Fspinp(q1,q2)
      F5 = Fspinp(p1,q2)
      F6 = Fspinp(q1,p2)
      G1 = Gspinp(p1,p2,q1,q2,pk)/tp
      G2 = Gspinp(q2,q1,p1,p2,pk)/tq
      G3 = Gspinp(q2,p2,p1,q1,pk)/s1
      G4 = Gspinp(p1,q1,p2,q2,pk)/s
      F1s= DCONJG(F1)
      F2s= DCONJG(F2)
      F3s= DCONJG(F3)
      F4s= DCONJG(F4)
      F5s= DCONJG(F5)
      F6s= DCONJG(F6)
      G1s= DCONJG(G1)
      G2s= DCONJG(G2)
      G3s= DCONJG(G3)
      G4s= DCONJG(G4)
! Helicity amplitudes
      amp( 1) = -c*s *F1 *( Rt(alar,gtp,ztp)*G1  +Rt(alar,gtq,ztq)*G2  )
      amp( 2) = -c*s1*F2s*( Rt(alar,gtp,ztp)*G1s +Rt(alar,gtq,ztq)*G2s )
      amp( 3) = -c*s1*F2 *( Rt(alar,gtp,ztp)*G1  +Rt(alar,gtq,ztq)*G2  )
      amp( 4) = -c*s *F1s*( Rt(alar,gtp,ztp)*G1s +Rt(alar,gtq,ztq)*G2s )
      amp( 5) = -c*tq*F4 *( Rs(alar,gs1,zs1)*G3  +Rs(alar,gs ,zs )*G4  )
      amp( 6) = -c*tp*F3s*( Rs(alar,gs1,zs1)*G3s +Rs(alar,gs ,zs )*G4s )
      amp( 7) = -c*tp*F3 *( Rs(alar,gs1,zs1)*G3  +Rs(alar,gs ,zs )*G4  )
      amp( 8) = -c*tq*F4s*( Rs(alar,gs1,zs1)*G3s +Rs(alar,gs ,zs )*G4s )
      amp( 9) =  c*u *F5 *( Rt(ale2,gtp,ztp)*G1  +Rt(ale2,gtq,ztq)*G2
     $                     +Rs(ale2,gs1,zs1)*G3  +Rs(ale2,gs ,zs )*G4  )
      amp(10) =  c*u1*F6s*( Rt(ale2,gtp,ztp)*G1s +Rt(ale2,gtq,ztq)*G2s
     $                     +Rs(ale2,gs1,zs1)*G3s +Rs(ale2,gs ,zs )*G4s )
      amp(11) =  c*u1*F6 *( Rt(ari2,gtp,ztp)*G1  +Rt(ari2,gtq,ztq)*G2
     $                     +Rs(ari2,gs1,zs1)*G3  +Rs(ari2,gs ,zs )*G4  )
      amp(12) =  c*u *F5s*( Rt(ari2,gtp,ztp)*G1s +Rt(ari2,gtq,ztq)*G2s
     $                     +Rs(ari2,gs1,zs1)*G3s +Rs(ari2,gs ,zs )*G4s )
      END

c  gen_bhw104

      SUBROUTINE profas(s,gs,zs)
*     **************************
!----------------------------------------------------------------------!
! This subroutine privides values of gamma and Z propagator factors    !
! (i.e. s*propagator) for the s-channel exchange.                      !
! Various forms depending on the input parameters KeyEWC and KeyLib.   !
!----------------------------------------------------------------------!
! Written by: Wielaw Placzek                    Knoxville, Sep. 1995   !
! Last update: 25.09.1996         by: W. P.                            !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      COMMON / BHINOUT  / NINP,NOUT
      SAVE   / BHPAR3 /, / BHPARZ /, /BHINOUT  /
      COMPLEX*16 gs,zs,ags,azs
      REAL*8 IMSIGG
!
      KeyEWC = MOD(KeyRad,10000)/1000
      KeyLib = MOD(KeyRad,1000)/100
      KeyPia = MOD(KeyRad,10)
! Vacuum polarization

      CALL BH_VACPOL(KeyPia,s,SINW2,RePis,dRePis)

      IF (KeyEWC.EQ.0) THEN
        gs = 1/(1+RePis)
! Constant Z width
        zs = s/DCMPLX(s-AMAZ**2,GAMMZ*AMAZ) /(1+RePis)
      ELSEIF (KeyEWC.EQ.1) THEN
        IF (KeyLib.eq.2) THEN
! Propagators from ALIBABA

          CALL sprogz(s,ags,azs)

!WP          gs = s*ags
! Photon propagator: real part from vacpol, imaginary part from ALIBABA
          gsRe = 1 + RePis
          gsIm = IMSIGG(s)/s
          gs = 1/DCMPLX(gsRe,gsIm)
! Z propagator (from ALIBABA)
          zs = s*azs
        ELSEIF (KeyLib.EQ.1) THEN
          gs = 1/(1+RePis)
! Running Z width
          zs = s/DCMPLX(s-AMAZ**2,s*GAMMZ/AMAZ) /(1+RePis)
        ELSE
          WRITE(6   ,*)'>> profas: Wrong KeyLib !!!, KeyLib=',KeyLib
          WRITE(NOUT,*)'>> profas: Wrong KeyLib !!!, KeyLib=',KeyLib
          STOP
        ENDIF
      ELSE
        WRITE(6   ,*)'>> profas: Wrong KeyEWC !!!, KeyEWC=',KeyEWC
        WRITE(NOUT,*)'>> profas: Wrong KeyEWC !!!, KeyEWC=',KeyEWC
        STOP
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE profat(t,gt,zt)
*     **************************
!----------------------------------------------------------------------!
! This subroutine privides values of gamma and Z propagator factors    !
! (i.e. t*propagator) for the t-channel exchange.                      !
! Various forms depending on the input parameters KeyEWC and KeyLib.   !
!----------------------------------------------------------------------!
! Written by: Wielaw Placzek                    Knoxville, Sep. 1995   !
! Last update: 25.09.1996         by: W. P.                            !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      COMMON / BHINOUT  / NINP,NOUT
      SAVE   / BHPAR3 /, / BHPARZ /, / BHINOUT  /
!
      KeyEWC = MOD(KeyRad,10000)/1000
      KeyLib = MOD(KeyRad,1000)/100
      KeyPia = MOD(KeyRad,10)
! Vacuum polarization

      CALL BH_VACPOL(KeyPia,t,SINW2,RePit,dRePit)

      IF (KeyEWC.EQ.0) THEN
        gt = 1/(1+RePit)
        zt = t/(t-AMAZ**2) /(1+RePit)
      ELSEIF (KeyEWC.EQ.1) THEN
        IF (KeyLib.EQ.2) THEN
! Propagators from ALIBABA

          CALL tprogz(t,agt,azt)

!WP          gt  = t*agt
          gt  = 1/(1+RePit)
          zt  = t*azt
        ELSEIF (KeyLib.EQ.1) THEN
          gt = 1/(1+RePit)
          zt = t/(t-AMAZ**2) /(1+RePit)
        ELSE
          WRITE(6   ,*)'>> profat: Wrong KeyLib !!!, KeyLib=',KeyLib
          WRITE(NOUT,*)'>> profat: Wrong KeyLib !!!, KeyLib=',KeyLib
          STOP
        ENDIF
      ELSE
        WRITE(6   ,*)'>> profat: Wrong KeyEWC !!!, KeyEWC=',KeyEWC
        WRITE(NOUT,*)'>> profat: Wrong KeyEWC !!!, KeyEWC=',KeyEWC
        STOP
      ENDIF
      END

c  gen_bhw104

      COMPLEX*16 FUNCTION Fspinp(p,q)
*     *******************************
!----------------------------------------------------------------------!
! This functions gives the result of the following expression          !
! of spinor products:                                                  !
!                                <pq>                                  !
!                       F(p,q) = -----                                 !
!                                <pq>*                                 !
! where the spinor product <pq> is defined in Ref. Zhan Xu et al.,     !
! Nucl. Phys. B291 (1987) 392; <pq>* is a complex conjugate of <pq>.   !
!                                                                      !
! INPUT: p(4), q(4) - two 4-vectors                                    !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                     Knoxville, May 1995  !
! Last update: 03.05.1995       by: W. P.                              !
!----------------------------------------------------------------------!
      REAL*8 p(4),q(4)
      COMPLEX*16 spipro,pxq

! Spinor product
      pxq = spipro(p,q)
      Fspinp = pxq/DCONJG(pxq)
      END

c  gen_bhw104

      COMPLEX*16 FUNCTION Gspinp(p,q,r,s,k)
*     *************************************
!----------------------------------------------------------------------!
! This functions gives the result of the following expression          !
! of spinor products:                                                  !
!                                  <pq>*                               !
!                       F(p,q) = --------                              !
!                                <rk><ks>                              !
! where the spinor products <..> are defined in Ref. Zhan Xu et al.,   !
! Nucl. Phys. B291 (1987) 392; <pq>* is a complex conjugate of <pq>.   !
!                                                                      !
! INPUT: p(4), q(4), r(4), s(4), k(4) - five 4-vectors                 !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                     Knoxville, May 1995  !
! Last update: 03.05.1995       by: W. P.                              !
!----------------------------------------------------------------------!
      REAL*8 p(4),q(4),r(4),s(4),k(4)
      COMPLEX*16 spipro,pxq,rxk,kxs

! Spinor products
      pxq = spipro(p,q)
      rxk = spipro(r,k)
      kxs = spipro(k,s)
      Gspinp = DCONJG(pxq)/(rxk*kxs)
      END

c  gen_bhw104

      COMPLEX*16 FUNCTION spipro(p,q)
*     *******************************
!----------------------------------------------------------------------!
! This functions gives the value of the spinor product <pq> = <p-|q+>  !
! as defined in Ref. Zhan Xu et al., Nucl. Phys. B291 (1987) 392.      !
! INPUT: p(4), q(4) - two 4-vectors                                    !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                     Knoxville, May 1995  !
! Last update: 08.05.1995       by: W. P.                              !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      REAL*8 p(4),q(4)
      COMPLEX*16 pt,qt,eip,eiq
!
      pp = p(4)+p(3)
      pm = p(4)-p(3)
      pta= SQRT(pp*pm)
      IF (pta.gt.0) THEN
         pt = DCMPLX(p(1),p(2))
         eip = pt/pta
      ELSE
         eip = 1
      ENDIF
      qp = q(4)+q(3)
      qm = q(4)-q(3)
      qta= SQRT(qp*qm)
      IF (qta.gt.0) THEN
         qt = DCMPLX(q(1),q(2))
         eiq = qt/qta
      ELSE
         eiq = 1
      ENDIF
! Spinor product
      spipro = SQRT(pm*qp)*eip - SQRT(pp*qm)*eiq
      END

c  gen_bhw104

      FUNCTION xmelmc(p1,q1,p2,q2,pk)
*     *******************************
!----------------------------------------------------------------------!
! This function provides a value of the finite fermion mass correction !
! to the matrix element for Bhabha scattering including hard photon    !
! radiation:                                                           !
!                                                                      !
!         e+(p1) + e-(q1) ---> e+(p2) + e-(q2) + gamma(pk)             !
!                                                                      !
! where p1, q1, p2, q2, pk  are 4-momenta of corresponding particles.  !
!                                                                      !
! INPUT:  p1(4),q1(4),p2(4),q2(4),pk(4) - 4-momenta of the particles,  !
!                                       all FERMIONS must be MASSIVE!  !
!                                                                      !
! Note: Vacuum polarization corrections are included in the above      !
!       matrix element as Dyson-type factors.                          !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                 Knoxville, May 1995      !
! Last update: 08.05.1995      by: W. P.                               !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      PARAMETER( PI = 3.1415926535897932D0, ALFINV = 137.0359895D0)
      PARAMETER( ALFA=1D0/ALFINV)
      COMMON / BHPAR2 / CMSENE,AMEL
      SAVE   / BHPAR2 /
      REAL*8 p1(4),q1(4),p2(4),q2(4),pk(4)
!
      ame = AMEL
! Electric charge squared
      e2 = 4*PI*ALFA
! Mandelstam variables
      s  = (p1(4)+q1(4))**2 - (p1(3)+q1(3))**2
     $    -(p1(2)+q1(2))**2 - (p1(1)+q1(1))**2
      s1 = (p2(4)+q2(4))**2 - (p2(3)+q2(3))**2
     $    -(p2(2)+q2(2))**2 - (p2(1)+q2(1))**2
      tp = (p1(4)-p2(4))**2 - (p1(3)-p2(3))**2
     $    -(p1(2)-p2(2))**2 - (p1(1)-p2(1))**2
      tq = (q1(4)-q2(4))**2 - (q1(3)-q2(3))**2
     $    -(q1(2)-q2(2))**2 - (q1(1)-q2(1))**2
      u  = (p1(4)-q2(4))**2 - (p1(3)-q2(3))**2
     $    -(p1(2)-q2(2))**2 - (p1(1)-q2(1))**2
      u1 = (q1(4)-p2(4))**2 - (q1(3)-p2(3))**2
     $    -(q1(2)-p2(2))**2 - (q1(1)-p2(1))**2
! Scalar products of photon 4-momentum with other 4-momenta
      p1k = p1(4)*pk(4)-p1(3)*pk(3)-p1(2)*pk(2)-p1(1)*pk(1)
      q1k = q1(4)*pk(4)-q1(3)*pk(3)-q1(2)*pk(2)-q1(1)*pk(1)
      p2k = p2(4)*pk(4)-p2(3)*pk(3)-p2(2)*pk(2)-p2(1)*pk(1)
      q2k = q2(4)*pk(4)-q2(3)*pk(3)-q2(2)*pk(2)-q2(1)*pk(1)
! Mass correction terms
      xmelmc = -e2*( (ame/p1k)**2 *xmate0(s1,tq,u1)
     $              +(ame/q1k)**2 *xmate0(s1,tp,u )
     $              +(ame/p2k)**2 *xmate0(s ,tq,u )
     $              +(ame/q2k)**2 *xmate0(s ,tp,u1) )
      END

c  gen_bhw104

      FUNCTION xmate0(s,t,u)
*     **********************
!----------------------------------------------------------------------!
! This function provides a value of the lowest order matrix element    !
! squared for Bhabha scattering.                                       !
! INPUT:  s, t, u - Mandelstam varriables                              !
! Note: Vacuum polarization corrections are included in the above      !
!       matrix element as Dyson-type factors.                          !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                 Knoxville, May 1995      !
! Last update: 08.02.1996      by: W. P.                               !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      PARAMETER( PI = 3.1415926535897932D0, ALFINV = 137.0359895D0)
      PARAMETER( ALFA=1D0/ALFINV)
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      SAVE   / BHPAR3 /, / BHPARZ /
      COMPLEX*16 Rs,Rsl2,Rsl2s,Rsr2,Rsr2s,Rslr,Rslrs,gs,zs
      SAVE e4,ale,ari,alar,ale2,ari2,ifset,KeyCha

      DATA ifset /0/

! Statement functions for propagator factors
      Rs(a,gs,zs) = gs + a*zs
      Rt(a,gt,zt) = gt + a*zt
!
! Set up some constants
      IF (ifset.EQ.0) THEN
        ifset = 1
! Electric charge: e**4
        e4= (4*PI*ALFA)**2
! left and right coupling constant for Z exchange
        ale  = GV + GA
        ari  = GV - GA
        alar = ale*ari
        ale2 = ale**2
        ari2 = ari**2
! Channel switch (s+t, s-only or t-only)
        KeyCha = MOD(KeyOpt,1000)/100
      ENDIF
! gamma and Z propagator factors

      CALL profas(s,gs,zs)

      CALL profat(t,gt,zt)

! Combinations of the above factors
      Rsl2 = Rs(ale2,gs,zs)
      Rsl2s= DCONJG(Rsl2)
      Rsr2 = Rs(ari2,gs,zs)
      Rsr2s= DCONJG(Rsr2)
      Rslr = Rs(alar,gs,zs)
      Rslrs= DCONJG(Rslr)
      Rtl2 = Rt(ale2,gt,zt)
      Rtr2 = Rt(ari2,gt,zt)
      Rtlr = Rt(alar,gt,zt)
! Various (real) combinations of the above factors
      Asl2 = Rsl2*Rsl2s
      Asr2 = Rsr2*Rsr2s
      Aslr = Rslr*Rslrs
      Atl2 = Rtl2*Rtl2
      Atr2 = Rtr2*Rtr2
      Atlr = Rtlr*Rtlr
      Astl = DBLE(Rsl2s)*Rtl2
      Astr = DBLE(Rsr2s)*Rtr2
!... s-channel off
      IF (KeyCha.EQ.2) THEN
        Asl2 = 0
        Asr2 = 0
        Aslr = 0
        Astl = 0
        Astr = 0
      ENDIF
!... t-channel off
      IF (KeyCha.EQ.1) THEN
        Atl2 = 0
        Atr2 = 0
        Atlr = 0
        Astl = 0
        Astr = 0
      ENDIF
! Matrix element
      xmate0 = e4*( ( (Asl2+Asr2)*u**2 + 2*Aslr*t**2 )/s**2
     $            + ( (Atl2+Atr2)*u**2 + 2*Atlr*s**2 )/t**2
     $            + 2*(Astl+Astr)*u**2/s/t )
      END

c  gen_bhw104

      FUNCTION xmecal(p1,q1,p2,q2,pk)
*     *******************************
!----------------------------------------------------------------------!
! This function provides a value of the matrix element squared for     !
! Bhabha scattering including single hard photon radiation as given    !
! in Ref. (CALKUL) F.A. Berends et al., Nucl. Phys. B206 (1982) 61.    !
!                                                                      !
!         e+(p1) + e-(q1) ---> e+(p2) + e-(q2) + gamma(pk)             !
!                                                                      !
! where p1, q1, p2, q2, pk  are 4-momenta of corresponding particles.  !
!                                                                      !
! INPUT:  p1(4),q1(4),p2(4),q2(4),pk(4) - 4-momenta of the particles,  !
!                                       all FERMIONS must be MASSIVE!  !
!                                                                      !
! Note: Vacuum polarization corrections are included in the above      !
!       matrix element as Dyson-type factors.                          !
!----------------------------------------------------------------------!
! Written by: Wieslaw Placzek                 Knoxville, May 1995      !
! Last update: 08.02.1996      by: W. P.                               !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      PARAMETER( PI = 3.1415926535897932D0, ALFINV = 137.0359895D0)
      PARAMETER(ALFA=1D0/ALFINV)
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      SAVE   / BHPAR3 /, / BHPARZ /

      REAL*8 p1(4) ,q1(4) ,p2(4) ,q2(4) ,pk(4)
      REAL*8 p1r(4),q1r(4),p2r(4),q2r(4),pkr(4)
      COMPLEX*16 Asa2,Asa2c,Asb2,Asb2c,Asab,Asabc
      COMPLEX*16 As1a2,As1a2c,As1b2,As1b2c,As1ab,As1abc
      COMPLEX*16 As,gs,zs,gs1,zs1
      SAVE e6,a,b,a2,b2,ab,ifset,KeyCha
      DATA ifset /0/
! Statement function for propagator factors
      As(a,gs,zs) = gs + 4*a*zs
      At(a,gt,zt) = gt + 4*a*zt
!
! Set up some constants
      IF (ifset.eq.0) THEN
        ifset = 1
! Electric charge: e**6
        e6 = (4*PI*ALFA)**3
! Z coupling constans
        a = (GV+GA)/2
        b = (GV-GA)/2
        a2= a*a
        b2= b*b
        ab= a*b
! Channel switch (s+t, s-only or t-only)
        KeyCha = MOD(KeyOpt,1000)/100
      ENDIF
! Rescaling 4-momenta of all particles for the massless limit (tests)
cc      pmod = DSQRT(p2(1)**2+p2(2)**2+p2(3)**2)
cc      qmod = DSQRT(q2(1)**2+q2(2)**2+q2(3)**2)
cc      refa = ( pmod + qmod + pk(4) )/( p1(4) + q1(4) )
      refa = 1
      DO i=1,4
         p1r(i) = p1(i)
         q1r(i) = q1(i)
         p2r(i) = p2(i)/refa
         q2r(i) = q2(i)/refa
         pkr(i) = pk(i)/refa
      ENDDO
cc      p1r(3) = p1r(4)
cc      q1r(3) =-q1r(4)
cc      p2r(4) = pmod/refa
cc      q2r(4) = qmod/refa
! Mandelstam variables
      s  = 2*( p1r(4)*q1r(4)-p1r(3)*q1r(3)-p1r(2)*q1r(2)-p1r(1)*q1r(1) )
      s1 = 2*( p2r(4)*q2r(4)-p2r(3)*q2r(3)-p2r(2)*q2r(2)-p2r(1)*q2r(1) )
      tp =-2*( p1r(4)*p2r(4)-p1r(3)*p2r(3)-p1r(2)*p2r(2)-p1r(1)*p2r(1) )
      tq =-2*( q1r(4)*q2r(4)-q1r(3)*q2r(3)-q1r(2)*q2r(2)-q1r(1)*q2r(1) )
      u  =-2*( p1r(4)*q2r(4)-p1r(3)*q2r(3)-p1r(2)*q2r(2)-p1r(1)*q2r(1) )
      u1 =-2*( q1r(4)*p2r(4)-q1r(3)*p2r(3)-q1r(2)*p2r(2)-q1r(1)*p2r(1) )
! Scalar products of photon 4-momentum with other 4-momenta
      p1k = p1r(4)*pkr(4)-p1r(3)*pkr(3)-p1r(2)*pkr(2)-p1r(1)*pkr(1)
      q1k = q1r(4)*pkr(4)-q1r(3)*pkr(3)-q1r(2)*pkr(2)-q1r(1)*pkr(1)
      p2k = p2r(4)*pkr(4)-p2r(3)*pkr(3)-p2r(2)*pkr(2)-p2r(1)*pkr(1)
      q2k = q2r(4)*pkr(4)-q2r(3)*pkr(3)-q2r(2)*pkr(2)-q2r(1)*pkr(1)
! Propagator factors
! ... if s-channel ON
      IF (KeyCha.NE.2) THEN

        CALL profas(s ,gs ,zs )
        CALL profas(s1,gs1,zs1)

        Asa2  = As(a2,gs,zs)
        Asa2c = DCONJG(Asa2)
        Asb2  = As(b2,gs,zs)
        Asb2c = DCONJG(Asb2)
        Asab  = As(ab,gs,zs)
        Asabc = DCONJG(Asab)
        As1a2 = As(a2,gs1,zs1)
        As1a2c= DCONJG(As1a2)
        As1b2 = As(b2,gs1,zs1)
        As1b2c= DCONJG(As1b2)
        As1ab = As(ab,gs1,zs1)
        As1abc= DCONJG(As1ab)
      ELSE
! ... s-channel OFF
        Asa2  = 0
        Asa2c = 0
        Asb2  = 0
        Asb2c = 0
        Asab  = 0
        Asabc = 0
        As1a2 = 0
        As1a2c= 0
        As1b2 = 0
        As1b2c= 0
        As1ab = 0
        As1abc= 0
      ENDIF
! ... if t-channel ON
      IF (KeyCha.NE.1) THEN
        CALL profat(tp,gtp,ztp)
        CALL profat(tq,gtq,ztq)
        Atpa2 = At(a2,gtp,ztp)
        Atpb2 = At(b2,gtp,ztp)
        Atpab = At(ab,gtp,ztp)
        Atqa2 = At(a2,gtq,ztq)
        Atqb2 = At(b2,gtq,ztq)
        Atqab = At(ab,gtq,ztq)
      ELSE
! ... t-channel OFF
        Atpa2 = 0
        Atpb2 = 0
        Atpab = 0
        Atqa2 = 0
        Atqb2 = 0
        Atqab = 0
      ENDIF
! Radiation factors
      rf1 = s /(p1k*q1k)
      rf2 = s1/(p2k*q2k)
      rf3 =-tp/(p1k*p2k)
      rf4 =-tq/(q1k*q2k)
      rf5 = u /(p1k*q2k)
      rf6 = u1/(q1k*p2k)
      W1 = rf1
      W2 = rf2
      W3 = rf3 + rf4 + rf5 + rf6
      W4 = rf3
      W5 = rf4
      W6 = rf1 + rf2 + rf5 + rf6
! Some traces
      Tr1 = 2*(s *p2k +u1*p1k -tp*q1k)
      Tr2 = 2*(s *q2k +u *q1k -tq*p1k)
      Tr3 = 2*(s1*p1k +u *p2k -tp*q2k)
      Tr4 = 2*(s1*q1k +u1*q2k -tq*p2k)
      epspq = s/2 *( p2(2)*q2(1) - p2(1)*q2(2) )
! Matrix element squared for massless spinors
      xm1 = ( W1*As1ab*As1abc +W2*Asab *Asabc +W3*DBLE(Asab *As1abc) )
     $     *(tp**2 + tq**2)/(s *s1)
      xm2 = ( W4*Atqab*Atqab  +W5*Atpab*Atpab +W6*     Atpab*Atqab   )
     $     *(s**2  + s1**2)/(tp*tq)
      xm3 = ( W1*(As1a2*As1a2c + As1b2*As1b2c)
     $       +W2*(Asa2 *Asa2c  + Asb2 *Asb2c )
     $       +W3*DBLE(Asa2 *As1a2c + Asb2 *As1b2c) )
     $     *(u**2 + u1**2)/(2*s *s1)
      xm4 = ( W4*(Atqa2*Atqa2  + Atqb2*Atqb2 )
     $       +W5*(Atpa2*Atpa2  + Atpb2*Atpb2 )
     $       +W6*    (Atpa2*Atqa2  + Atpb2*Atqb2 ) )
     $     *(u**2 + u1**2)/(2*tp*tq)
      xm5 = ( p1k/(s *tp)*Tr1*DBLE(Asa2 *Atpa2 + Asb2 *Atpb2)
     $       +q1k/(s *tq)*Tr2*DBLE(Asa2 *Atqa2 + Asb2 *Atqb2)
     $       +p2k/(s1*tp)*Tr3*DBLE(As1a2*Atpa2 + As1b2*Atpb2)
     $       +q2k/(s1*tq)*Tr4*DBLE(As1a2*Atqa2 + As1b2*Atqb2) )
     $     *(u**2 + u1**2)/(4*p1k*q1k*p2k*q2k)
      xm6 =-( (s-s1)/(s*s1)*DIMAG(Asa2*As1a2c - Asb2*As1b2c)
     $       +2*p1k/(s *tp)*DIMAG(Asa2 *Atpa2 - Asb2 *Atpb2)
     $       +2*q1k/(s *tq)*DIMAG(Asa2 *Atqa2 - Asb2 *Atqb2)
     $       -2*p2k/(s1*tp)*DIMAG(As1a2*Atpa2 - As1b2*Atpb2)
     $       -2*q2k/(s1*tq)*DIMAG(As1a2*Atqa2 - As1b2*Atqb2) )
     $     *(u**2 - u1**2)*epspq/(2*p1k*q1k*p2k*q2k)
      xmem0 = e6 *(xm1+xm2+xm3+xm4+xm5+xm6)
! Mass correction terms (here fermions must be massive!)
      xmemc = xmelmc(p1,q1,p2,q2,pk)
! Total matrix element squared
      xmecal = xmem0 + xmemc
      END

c  gen_bhw104

      SUBROUTINE MODEL1(MODE)
!     ***********************
!======================================================================!
!                                                                      !
!    Matrix element for Bhabha scattering inluding O(alpha)            !
!    radiative corrections as defined in Yennie-Frautschi-Suura        !
!    formula by functions beta0 and beta1.                             !
!                                                                      !
!    1. Electroweak virtual and real soft photon corrections           !
!       are taken from the program BABAMC or the program               !
!       ALIBABA depending on the switch parameter KeyLib.              !
!    2. Hard photon radiation contribution is calculated according     !
!       to formulae obtained by the authors (see routine xmatel).      !
!                                                                      !
!======================================================================!
!    Written by: Wieslaw Placzek                  Knoxville, May 1995  !
!    Last update: 09.02.2001       by: W.P.                            !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( pi = 3.1415926535897932d0, alfinv=137.0359895d0)
      PARAMETER( alfpi=  1/pi/alfinv, alfa= 1d0/alfinv)
      PARAMETER( Gnanob=389.385D3 )
      COMMON / BHPAR1 / DEL,EPSCM,THMIN,XMIVIS
      COMMON / BHPAR2 / CMSENE,AMEL
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHCRUD / trmid,crufla,Zprof,sg01,sg02,sg03,sig0
      COMMON / BHTRANSR / TRAN,TRMIN,TRMAX
      COMMON / BHMOMSET / P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT
      COMMON / BHWGTALL / WTMOD,WTCRUD,WTTRIG,WTSET(300)
!WP: photon radiation tags
      Common / BHRadTag / idrad(100)
      SAVE   / BHPAR1 /, / BHPAR2 /, / BHPAR3 /, / BHTRANSR /, /BHCRUD/
      SAVE   / BHMOMSET /, / BHWGTALL /, / BHRadTag /
      REAL*8 p1r0(4),q1r0(4),p2r0(4),q2r0(4)
      REAL*8 p1r(4),q1r(4),p2r(4),q2r(4),pk(4),pkr(4)
      REAL*8 p1e(4),q1e(4),qq(4),pp(4)
! Switch for some diagnostic printouts: 0/1 (OFF/ON)

      DATA KeyDia /1/
! Count bad weights if appear
      DATA ibadw0 /0/, ibadw1 /0/
      DATA icont /0/
c      SAVE
!---
      icont=icont+1
      eps = EPSCM
      ame = AMEL
      s   = CMSENE**2
      t   =-TRAN
      u   = 4*ame**2 -s -t
      zeta = TRAN/s
! Crude MC distribution
      IF (TRAN.ge.trmid) THEN
        crude =  Zprof + (s/t)**2
      ELSE
! Flat distribution for very small values of TRAN
        crude = crufla
      ENDIF
! Calculate fermion effective 4-momenta at the interation point
      DO k = 1,4
        p1e(k) = p1(k)
        q1e(k) = q1(k)
      ENDDO
      DO i = 1,NPHOT
        ira = idrad(i)
        IF (ira.eq.1) THEN
          DO k =1,4
            p1e(k) = p1e(k) -PHOT(i,k)
          ENDDO
        ELSEIF (ira.eq.2) THEN
          DO k =1,4
            q1e(k) = q1e(k) -PHOT(i,k)
          ENDDO
        ENDIF
      ENDDO
      DO k = 1,4
        qq(k) = p1e(k) + q1e(k)
      ENDDO
      IF (NPHOT.eq.0) THEN
        DO k = 1,4
          p1r0(k) = p1(k)
          q1r0(k) = q1(k)
          p2r0(k) = p2(k)
          q2r0(k) = q2(k)
        ENDDO
      ELSE
! Reduction for beta0 (Born-like process)
        CALL REDUZ0(qq,p1,q1,p1r0,q1r0)
        CALL REDUZ0(qq,p2,q2,p2r0,q2r0)
      ENDIF
! Mandelstam variables
      s1 = qq(4)**2 -qq(3)**2 -qq(2)**2 -qq(1)**2
      t1 = (p1r0(4)-p2r0(4))**2 -(p1r0(3)-p2r0(3))**2
     $    -(p1r0(2)-p2r0(2))**2 -(p1r0(1)-p2r0(1))**2
      u1 = 4*ame**2 -s1 -t1
! Born matrix element
      xmebo = xmate0(s1,t1,u1)
      dis00 = xmebo /(4*pi*alfa)**2/4
! Electroweak O(alpha) virtual and real soft photon corrections:
      KeyEWC = MOD(KeyRad,10000)/1000
      KeyLib = MOD(KeyRad,1000)/100
      IF (KeyLib.EQ.2) THEN
! ... From ALIBABA
        xmqed = xmatvs(s1,t1,eps)
        alivs = xmebo + xmqed
        IF (KeyEWC.EQ.1) THEN
          xweak = xmatwc(s1,t1)
          alivs = xweak + xmqed
        ENDIF
        dis01 = alivs /(4*pi*alfa)**2/4
      ELSEIF (KeyLib.EQ.1) THEN
! ... From BABAMC
!    dsig0 - Born cross section, dsig1 - O(alpha) cross section.
        CALL babewc(s1,t1,eps,dsig0,dsig1)
        babvs = dsig1/dsig0
        dis01 = dis00*babvs
      ENDIF
! Infrared factor
      finf = YFSirf(p1r0,q1r0,p2r0,q2r0,eps,ame)
!===================================================================
!          ########################################
!          #               beta0                  #
!          ########################################
      beta00 = dis00
      beta01 = dis01  -finf*beta00
!          ########################################
!          #               beta1                  #
!          ########################################
      beta10 = 0
      DO i = 1,NPHOT
        ira = idrad(i)
        DO k = 1,4
          pk(k) = PHOT(i,k)
        ENDDO
        IF (NPHOT.eq.1) THEN
          DO k = 1,4
            p1r(k) = p1(k)
            q1r(k) = q1(k)
            p2r(k) = p2(k)
            q2r(k) = q2(k)
            pkr(k) = pk(k)
          ENDDO
        ELSE
! Initial state radiation
          IF (ira.eq.1 .or. ira.eq.2) THEN
! Reduction procedure (e+e- ---> e+e- + gamma like process)

            call REDUZ1(qq,p1,q1,pk,p1r,q1r,pkr)

            DO k = 1,4
              p2r(k) = p2r0(k)
              q2r(k) = q2r0(k)
              pp(k)  = p1r(k) + q1r(k)
            ENDDO

            CALL boost5(pp ,p1r,q1r,p2r,q2r,pkr)

            CALL rotat5(p1r,q1r,p2r,q2r,pkr)

! Final state radiation
          ELSE
! Reduction procedure (e+e- ---> e+e- + gamma like process)
            DO k = 1,4
               pk(k) = -pk(k)
            ENDDO

            CALL REDUZ1(qq,p2,q2,pk,p2r,q2r,pkr)

            DO k = 1,4
              p1r(k) = p1r0(k)
              q1r(k) = q1r0(k)
              pkr(k) =-pkr(k)
            ENDDO
          ENDIF
        ENDIF
        thp1k = angvec(p1r,pkr)
        thq1k = angvec(q1r,pkr)
        thp2k = angvec(p2r,pkr)
        thq2k = angvec(q2r,pkr)
        delth = 1d-7
! Collinear approx. if angle between lepton and photon less than delth
        IF (thp1k.LT.delth) THEN
          dis10 = 0
          z = pkr(4)/p1r(4)
!WP          beta1i = beta00 *z*(z-2)/2
          beta1i = beta00 *z**2/2/(1-z)
        ELSEIF (thq1k.LT.delth) THEN
          dis10 = 0
          z = pkr(4)/q1r(4)
!WP          beta1i = beta00 *z*(z-2)/2
          beta1i = beta00 *z**2/2/(1-z)
        ELSEIF (thp2k.LT.delth) THEN
          dis10 = 0
          z = pkr(4)/(p2r(4)+pkr(4))
!WP          beta1i = beta00 *z*(z-2)/2
          beta1i = beta00 *z**2/2/(1-z)
        ELSEIF (thq2k.LT.delth) THEN
          dis10 = 0
          z = pkr(4)/(q2r(4)+pkr(4))
!WP          beta1i = beta00 *z*(z-2)/2
          beta1i = beta00 *z**2/2/(1-z)
        ELSE
! Soft factor
          sfr = SoftFa(p1r,q1r,p2r,q2r,pkr)
! Single hard photon bremss. matrix element
          dis10 = xmatel(p1r,q1r,p2r,q2r,pkr) /( 4*(4*pi*alfa)**3 )
! beta1 O(alpha1)
          beta1i = dis10/sfr - beta00
        ENDIF
! Sum of beta1 for all photons
        beta10 = beta10 + beta1i
      ENDDO
!
!          **************************************
!          **     Definitions of MC weights    **
!          **************************************
! All beta's:  O(alf0),O(alf1)
      wtset(10) =  beta00           /crude
      wtset(11) = (beta01 + beta10) /crude
!==================================================================
!==================================================================
!                  Non-exponentiated version                      !
!==================================================================
!==================================================================
! Entire 0,1-photon distributions
      dsne0 = 0
      dsne1 = 0
      fYFS  = 1
      IF(NPHOT.eq.0) THEN
! [0] No hard photons
! O(alpha^0,^1) entire distributions
        dsne0 = dis00
        dsne1 = dis01
! YFS formfactor
        fYFS = YFSfmf(eps)
      ELSEIF(NPHOT.eq.1) THEN
! [1] One hard photon
! O(alpha^1) entire distribution
        dsne1 = dis10 /sfr
! YFS formfactor
        fYFS = YFSfmf(eps)
      ENDIF
!
!          **************************************
!          ****   Definitions of MC weights  ****
!          ****    Non-exponentiated case    ****
!          **************************************
! TOTAL O(alpha^0),O(alpha^1)
      wtset(20) = dsne0 /fYFS/crude
      wtset(21) = dsne1 /fYFS/crude
!
!---------------------------------------------------------------!
! Setting some "bad" weights to zero!
      wtx1 =-10.0
      wtx2 = 50.0
      wt0 = wtcrud*wttrig*wtset(10)
! This is less dangerous
      IF (wt0.lt.wtx1 .or. wt0.gt.wtx2) THEN
        ibadw0 = ibadw0 + 1
        IF (KeyDia.eq.1) THEN
          IObad = 6
          WRITE(IObad,*)' '
          WRITE(IObad,*)'>>> BHWIDE WARNING !!! <<<'
          WRITE(IObad,*)'>>> MODEL1: BAD weight wt0 -> reset to zero!'
          WRITE(IObad,*)'iwt0,wt0=',ibadw0,wt0
          WRITE(IObad,*)'s,s1=',s,s1
          WRITE(IObad,*)'t,t1=',t,t1
          WRITE(IObad,*)'idrad=',(idrad(i),i=1,nphot)

          CALL BH_DUMPS(IObad)

        ENDIF
        wtset(10) = 0
      ENDIF
      wt1 = wtcrud*wttrig*wtset(11)
! This is more dangerous
      IF (wt1.lt.wtx1 .or. wt1.gt.wtx2) THEN
        ibadw1 = ibadw1 + 1
        IF (KeyDia.eq.1) THEN
          IObad = 6
          WRITE(IObad,*)' '
          WRITE(IObad,*)'>>> BHWIDE WARNING !!! <<<'
          WRITE(IObad,*)'>>> MODEL1: BAD weight wt1 -> reset to zero!'
          WRITE(IObad,*)'iwt1,wt1=',ibadw1,wt1
          WRITE(IObad,*)'s,s1=',s,s1
          WRITE(IObad,*)'t,t1=',t,t1
          WRITE(IObad,*)'idrad=',(idrad(i),i=1,nphot)

          CALL BH_DUMPS(IObad)

        ENDIF
        wtset(11) = 0
      ENDIF
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!+++++++++++++++++++ PRINCIPAL WEIGHT ++++++++++++++++++++++++++!
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
      wtset( 1) = wtset(11)
      END

c  gen_bhw104

      FUNCTION angvec(p,q)
*     ********************
!---------------------------------------------------------------!
! This function provides a value of an agle between 2 vectors.  !
! INPUT:  p(4),q(4) - two 4-vectors                             !
!---------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995  !
! Last update: 19.07.1995       by: W.P.                        !
!---------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      REAL*8 p(4),q(4)
!
      pm = SQRT( p(1)**2 + p(2)**2 + p(3)**2 )
      qm = SQRT( q(1)**2 + q(2)**2 + q(3)**2 )
      pq = p(1)*q(1) + p(2)*q(2) + p(3)*q(3)
      costhe = pq/(pm*qm)
      IF (costhe.LT.-1d0) costhe =-1d0
      IF (costhe.GT. 1d0) costhe = 1d0
      angvec = ACOS(costhe)
      END

c  gen_bhw104

      function SoftFa(p1,q1,p2,q2,pk)
*     *******************************
!---------------------------------------------------------------!
! This function provides a value of the soft factor S-tilde     !
! for massless fermions (factor (alpha/4pi^2) omitted!).        !
! INPUT:  p1(4),q1(4),p2(4),q2(4) - fermion 4-momenta           !
!                           pk(4) - photon  4-momentum          !
!---------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995  !
! Last update: 23.05.1995       by: W.P.                        !
!---------------------------------------------------------------!
      implicit REAL*8 (a-h,o-z)
      COMMON / BHPAR2 / CMSENE,AMEL
      SAVE   / BHPAR2 /
      REAL*8 p1(4) ,q1(4) ,p2(4) ,q2(4) ,pk(4)
      REAL*8 p1r(4),q1r(4),p2r(4),q2r(4),pkr(4)
!
      ame = AMEL
! Scalar products of massive fermion 4-momenta
      p1km = p1(4)*pk(4)-p1(3)*pk(3)-p1(2)*pk(2)-p1(1)*pk(1)
      q1km = q1(4)*pk(4)-q1(3)*pk(3)-q1(2)*pk(2)-q1(1)*pk(1)
      p2km = p2(4)*pk(4)-p2(3)*pk(3)-p2(2)*pk(2)-p2(1)*pk(1)
      q2km = q2(4)*pk(4)-q2(3)*pk(3)-q2(2)*pk(2)-q2(1)*pk(1)
! Rescaling 4-momenta of all particles for the massless limit
      pmod = SQRT(p2(1)**2 +p2(2)**2 +p2(3)**2)
      qmod = SQRT(q2(1)**2 +q2(2)**2 +q2(3)**2)
      refa = ( pmod + qmod + pk(4) )/( p1(4) + q1(4) )
      DO i = 1,4
         p1r(i) = p1(i)
         q1r(i) = q1(i)
         p2r(i) = p2(i)/refa
         q2r(i) = q2(i)/refa
         pkr(i) = pk(i)/refa
      ENDDO
      p1r(3) = p1r(4)
      q1r(3) =-q1r(4)
      p2r(4) = pmod/refa
      q2r(4) = qmod/refa
! Scalar products of massless fermion 4-momenta
      p1k  = p1r(4)*pkr(4)-p1r(3)*pkr(3)-p1r(2)*pkr(2)-p1r(1)*pkr(1)
      q1k  = q1r(4)*pkr(4)-q1r(3)*pkr(3)-q1r(2)*pkr(2)-q1r(1)*pkr(1)
      p2k  = p2r(4)*pkr(4)-p2r(3)*pkr(3)-p2r(2)*pkr(2)-p2r(1)*pkr(1)
      q2k  = q2r(4)*pkr(4)-q2r(3)*pkr(3)-q2r(2)*pkr(2)-q2r(1)*pkr(1)
      p1q1 = p1r(4)*q1r(4)-p1r(3)*q1r(3)-p1r(2)*q1r(2)-p1r(1)*q1r(1)
      p1p2 = p1r(4)*p2r(4)-p1r(3)*p2r(3)-p1r(2)*p2r(2)-p1r(1)*p2r(1)
      p1q2 = p1r(4)*q2r(4)-p1r(3)*q2r(3)-p1r(2)*q2r(2)-p1r(1)*q2r(1)
      q1p2 = q1r(4)*p2r(4)-q1r(3)*p2r(3)-q1r(2)*p2r(2)-q1r(1)*p2r(1)
      q1q2 = q1r(4)*q2r(4)-q1r(3)*q2r(3)-q1r(2)*q2r(2)-q1r(1)*q2r(1)
      p2q2 = p2r(4)*q2r(4)-p2r(3)*q2r(3)-p2r(2)*q2r(2)-p2r(1)*q2r(1)
! Massless terms
      sfml = 2*( p1p2/(p1k*p2k) +p1q1/(p1k*q1k) -p1q2/(p1k*q2k)
     &          -q1p2/(q1k*p2k) +p2q2/(p2k*q2k) +q1q2/(q1k*q2k) )
! Mass terms
      sfmt = ame**2 *(1/p1km**2 +1/q1km**2 +1/p2km**2 +1/q2km**2)
      SoftFa = sfml - sfmt
      END

c  gen_bhw104

      SUBROUTINE REDUZ0(QQ,P1,P2,PR1,PR2)
*     ***********************************
!---------------------------------------------------------------!
! This routine comes originally from the program YFS3.          !
! Modified by: W. Placzek        Knoxville, May 1995            !
!---------------------------------------------------------------!
C reduction of momenta for beta0, second one
C I.E. WE MAPP:   P1,P2 ==> PR1,PR2
C such that  PR1+PR2 = QQ
C Resulting PRi QRi are in QQ rest frame.
C     ***********************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER( EPS1 =1D-15)
      DIMENSION QQ(4),P1(4),P2(4),PR1(4),PR2(4)
      DIMENSION PP(4),PX1(4),PX2(4),PPX(4)
C
      DO 20 K=1,4
 20   PP(K)=P1(K)+P2(K)
      IF((PP(1)**2+PP(2)**2+PP(3)**2)/PP(4)**2 .GT. EPS1) THEN
C transform all momenta to QQ rest-frame

         CALL BOSTDQ( 1,QQ,P1 ,PX1)
         CALL BOSTDQ( 1,QQ,P2 ,PX2)
         CALL BOSTDQ( 1,QQ,PP ,PPX)

C transform all momenta to PP rest-frame

         CALL BOSTDQ( 1,PPX,PX1,PX1)
         CALL BOSTDQ( 1,PPX,PX2,PX2)

!WP      CALL BOSTDQ( 1,PP,P1,PX1)
!WP      CALL BOSTDQ( 1,PP,P2,PX2)
      ELSE
C do nothing if we are already in PP rest-frame
         DO 23 K=1,4
            PX1(K)=P1(K)
   23       PX2(K)=P2(K)
      ENDIF
C construct reduced beam momenta PR1,PR2
C note: they are understood to be in QQ rest-frame
      SVAR1 = QQ(4)**2-QQ(3)**2-QQ(2)**2-QQ(1)**2
      SVAR  = PP(4)**2-PP(3)**2-PP(2)**2-PP(1)**2
      VV    = 1D0 -SVAR1/SVAR
      IF(ABS(VV).GT. EPS1) THEN
         AMEL2=  P1(4)**2-P1(3)**2-P1(2)**2-P1(1)**2
         PR1(4)= SQRT(SVAR1)/2D0
         PR2(4)= PR1(4)
         PXMOD = SQRT(PX1(1)**2+PX1(2)**2+PX1(3)**2)
         PRMOD = SQRT(PR1(4)**2-AMEL2)
         DO 30 K=1,3
         PR1(K)= PX1(K)/PXMOD*PRMOD
 30      PR2(K)= PX2(K)/PXMOD*PRMOD
      ELSE
         DO 40 K=1,4
         PR1(K)= PX1(K)
 40      PR2(K)= PX2(K)
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE REDUZ1(QQ,P1,P2,PH,PR1,PR2,PHR)
*     ******************************************
!---------------------------------------------------------------!
! This routine comes originally from the program YFS3.          !
! Modified by: W. Placzek        Knoxville, May 1995            !
!---------------------------------------------------------------!
C reduction of 4-momenta for beta1
C           P1,P2,PH ==--> PR1,PR2,PHR
C such that  PR1+PR2 = QQ+PHR
C     ***********************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER( EPS1 =1D-15)
      COMMON / BHINOUT  / NINP,NOUT
      SAVE   / BHINOUT  /
      DIMENSION QQ(4), P1(4), P2(4), PH(4), PR1(4),PR2(4),PHR(4)
      DIMENSION PP(4),QQK(4),PPX(4), PPK(4)
      DIMENSION PX1(4),PX2(4),PHX(4)
C
      DO 20 K=1,4
      PP(K)   = P1(K)+P2(K)
      PPK(K)  = P1(K)+P2(K)-PH(K)
 20   QQK(K)  = QQ(K)+PH(K)
      SVAR  =  PP(4)**2 -PP(3)**2 -PP(2)**2 -PP(1)**2
      SVAR1 =  QQ(4)**2 -QQ(3)**2 -QQ(2)**2 -QQ(1)**2
      SS1   = PPK(4)**2-PPK(3)**2-PPK(2)**2-PPK(1)**2
      SS2   = QQK(4)**2-QQK(3)**2-QQK(2)**2-QQK(1)**2
      IF((PP(1)**2+PP(2)**2+PP(3)**2)/PP(4)**2 .GT. EPS1) THEN
C transform all momenta to QQ rest-frame
         CALL BOSTDQ( 1,QQ,P1 ,PX1)
         CALL BOSTDQ( 1,QQ,P2 ,PX2)
         CALL BOSTDQ( 1,QQ,PH ,PHX)
         CALL BOSTDQ( 1,QQ,PP ,PPX)
C transform all momenta to PP rest-frame
         CALL BOSTDQ( 1,PPX,PX1,PX1)
         CALL BOSTDQ( 1,PPX,PX2,PX2)
         CALL BOSTDQ( 1,PPX,PHX,PHX)
!WP      CALL BOSTDQ( 1,PP,P1,PX1)
!WP      CALL BOSTDQ( 1,PP,P2,PX2)
!WP      CALL BOSTDQ( 1,PP,PH,PHX)
      ELSE
C do nothing if we are already in PP rest-frame
         DO 23 K=1,4
            PHX(K)=PH(K)
            PX1(K)=P1(K)
   23       PX2(K)=P2(K)
      ENDIF
C construct reduced beam momenta PR1,PR2
C note: they are understood to be in QQ rest-frame
      VV2   = 1D0 - SS2/SVAR
      IF(ABS(VV2).GT. EPS1) THEN
CCCCC    PK    =  (PX1(4)+PX2(4))*PHX(4)
CCCCC    XLAM= SQRT(SVAR1/SVAR+(PK/SVAR)**2)+PK/SVAR
         XLAM= SQRT(SVAR1/SS1)
         AMEL2=  P1(4)**2-P1(3)**2-P1(2)**2-P1(1)**2
         PXMOD = SQRT(PX1(1)**2+PX1(2)**2+PX1(3)**2)
         PX1(4)= PX1(4)*XLAM
         PX2(4)= PX2(4)*XLAM
CCC      PRMOD = SQRT(PX1(4)**2-AMEL2)
         PRMOD =      PX1(4)**2-AMEL2
         IF(PRMOD.LE.0D0) WRITE(NOUT,*) ' REDUZ1: PRMOD=', PRMOD
         IF(PRMOD.LE.0D0) WRITE(   6,*) ' REDUZ1: PRMOD=', PRMOD
         PRMOD = SQRT(ABS(PRMOD))
         DO 30 K=1,3
         PX1(K)= PX1(K)/PXMOD*PRMOD
 30      PX2(K)= PX2(K)/PXMOD*PRMOD
         DO 31 K=1,4
 31      PHX(K)= PHX(K)*XLAM
      ENDIF
C then, boost away the three-vector part of P1+P2-PH
C that is transform to QQ rest frame
      DO 35 K=1,4
 35   PP(K)= PX1(K)+PX2(K)-PHX(K)
      CALL BOSTDQ( 1,PP,PX1,PR1)
      CALL BOSTDQ( 1,PP,PX2,PR2)
      CALL BOSTDQ( 1,PP,PHX,PHR)
      END

c  gen_bhw104

      SUBROUTINE boost5(qq,p1,p2,p3,p4,p5)
*     ************************************
!---------------------------------------------------------------!
! Boost of the 4-vectors p1,p2,p3,p4,p5 to the rest frame of qq.!
!---------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995  !
!---------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      REAL*8 qq(4),p1(4),p2(4),p3(4),p4(4),p5(4)
C
      CALL bostdq( 1,qq,p1,p1)
      CALL bostdq( 1,qq,p2,p2)
      CALL bostdq( 1,qq,p3,p3)
      CALL bostdq( 1,qq,p4,p4)
      CALL bostdq( 1,qq,p5,p5)
      END

c  gen_bhw104

      SUBROUTINE rotat5(p1,q1,p2,q2,pk)
*     *********************************
!---------------------------------------------------------------!
! Rotation of the 4-vectors p1,q1,p2,q2,pk given in the rest    !
! frame of p1+q1 such that the resulting vector p1 points along !
! the +z axis.                                                  !
!---------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995  !
!---------------------------------------------------------------!
      IMPLICIT REAL*8 (a-h,o-z)
      PARAMETER ( pi = 3.1415926535897932d0 )
      REAL*8 p1(4),q1(4),p2(4),q2(4),pk(4)
!
      p1m = SQRT( p1(1)**2 + p1(2)**2 + p1(3)**2 )
      p1t = p1(1)**2 + p1(2)**2
      IF (p1t.GT.1d-20) THEN
        phi = angfix(p1(1),p1(2))
        CALL rxtod3(-phi,p2,p2)
        CALL rxtod3(-phi,q2,q2)
        CALL rxtod3(-phi,pk,pk)
      ENDIF
      the = ACOS(p1(3)/p1m)
      CALL rxtod2(-the,p2,p2)
      CALL rxtod2(-the,q2,q2)
      CALL rxtod2(-the,pk,pk)
      p1(3) = p1m
      p1(2) = 0
      p1(1) = 0
      q1(3) =-p1m
      q1(2) = 0
      q1(1) = 0
      END

c  gen_bhw104

      SUBROUTINE MODEL2(MODE)
!     ***********************
!======================================================================!
!                                                                      !
!    Matrix element for Bhabha scattering inluding O(alpha)            !
!    radiative corrections as defined in Yennie-Frautschi-Suura        !
!    formula by functions beta0 and beta1.                             !
!                                                                      !
!    1. Electroweak virtual and real soft photon corrections           !
!       are taken from the program BABAMC or the program               !
!       ALIBABA depending on the switch parameter KeyLib.              !
!    2. Hard photon radiation contribution is calculated according     !
!       to the matrix element given by CALKUL, F.A. Berends et al.,    !
!       Nucl. Phys. B206 (1982) 61.                                    !
!                                                                      !
!======================================================================!
!    Written by: Wieslaw Placzek                  Knoxville, July 1995 !
!    Last update: 09.02.2001       by: W.P.                            !
!----------------------------------------------------------------------!
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( pi = 3.1415926535897932d0, alfinv=137.0359895d0)
      PARAMETER( alfpi=  1/pi/alfinv, alfa= 1d0/alfinv)
      PARAMETER( Gnanob=389.385D3 )
      COMMON / BHPAR1 / DEL,EPSCMS,THMIN,XMIVIS
      COMMON / BHPAR2 / CMSENE,AMEL
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHCRUD / trmid,crufla,Zprof,sg01,sg02,sg03,sig0
      COMMON /BHTRANSR / TRAN,TRMIN,TRMAX
      COMMON /BHMOMSET / P1(4),Q1(4),P2(4),Q2(4),PHOT(100,4),NPHOT
      COMMON /BHWGTALL / WTMOD,WTCRUD,WTTRIG,WTSET(300)
! Photon radiation tags (needed for reduction procedure)
      Common /BHRadTag / idrad(100)
      REAL*8 p1r0(4),q1r0(4),p2r0(4),q2r0(4)
      REAL*8 p1r(4),q1r(4),p2r(4),q2r(4),pk(4),pkr(4)
      REAL*8 p1e(4),q1e(4),qq(4),pp(4)
      SAVE   / BHPAR1 /, / BHPAR2 /, /BHPAR3 /, /BHTRANSR/, /BHCRUD /
      SAVE   /BHMOMSET /, /BHWGTALL /, /BHRadTag /
! Switch for some diagnostic printouts: 0/1 (OFF/ON)
C
      DATA KeyDia /1/
! Count bad weights if appear
      DATA ibadw0 /0/, ibadw1 /0/
      DATA icont /0/
c      SAVE
!---
      icont=icont+1
      eps = EPSCMS
      ame = AMEL
      s   = CMSENE**2
      t   =-TRAN
      u   = 4*ame**2 -s -t
! Crude MC distribution
      IF (TRAN.ge.trmid) THEN
        crude =  Zprof + (s/t)**2
      ELSE
! Flat distribution for very small values of TRAN
        crude = crufla
      ENDIF
! Calculate fermion effective 4-momenta at the interation point
      DO k = 1,4
        p1e(k) = p1(k)
        q1e(k) = q1(k)
      ENDDO
      DO i = 1,NPHOT
        ira = idrad(i)
        IF (ira.eq.1) THEN
          DO k =1,4
            p1e(k) = p1e(k) -PHOT(i,k)
          ENDDO
        ELSEIF (ira.eq.2) THEN
          DO k =1,4
            q1e(k) = q1e(k) -PHOT(i,k)
          ENDDO
        ENDIF
      ENDDO
      DO k = 1,4
        qq(k) = p1e(k) + q1e(k)
      ENDDO
      IF (NPHOT.eq.0) THEN
        DO k = 1,4
          p1r0(k) = p1(k)
          q1r0(k) = q1(k)
          p2r0(k) = p2(k)
          q2r0(k) = q2(k)
        ENDDO
      ELSE
! Reduction for beta0 (Born-like process)
        CALL REDUZ0(qq,p1,q1,p1r0,q1r0)
        CALL REDUZ0(qq,p2,q2,p2r0,q2r0)
      ENDIF
! Mandelstam variables
      s1 = qq(4)**2 -qq(3)**2 -qq(2)**2 -qq(1)**2
      t1 = (p1r0(4)-p2r0(4))**2 -(p1r0(3)-p2r0(3))**2
     $    -(p1r0(2)-p2r0(2))**2 -(p1r0(1)-p2r0(1))**2
      u1 = 4*ame**2 -s1 -t1
! Born matrix element
      xmebo = xmate0(s1,t1,u1)
      dis00 = xmebo /(4*pi*alfa)**2/4
! Electroweak O(alpha) virtual and real soft photon corrections:
      KeyEWC = MOD(KeyRad,10000)/1000
      KeyLib = MOD(KeyRad,1000)/100
      IF (KeyLib.EQ.2) THEN
! ... From ALIBABA
        xmqed = xmatvs(s1,t1,eps)
        alivs = xmebo + xmqed
        IF (KeyEWC.EQ.1) THEN
          xweak = xmatwc(s1,t1)
          alivs = xweak + xmqed
        ENDIF
        dis01 = alivs /(4*pi*alfa)**2/4
      ELSEIF (KeyLib.EQ.1) THEN
! ... From BABAMC
!    dsig0 - Born cross section, dsig1 - O(alpha) cross section.
        CALL babewc(s1,t1,eps,dsig0,dsig1)
        babvs = dsig1/dsig0
        dis01 = dis00*babvs
      ENDIF
! Infrared factor
      finf = YFSirf(p1r0,q1r0,p2r0,q2r0,eps,ame)
!===================================================================
!          ########################################
!          #               beta0                  #
!          ########################################
      beta00 = dis00
      beta01 = dis01  -finf*beta00
!          ########################################
!          #               beta1                  #
!          ########################################
      beta10 = 0
      DO i = 1,NPHOT
        ira = idrad(i)
        DO k = 1,4
          pk(k) = PHOT(i,k)
        ENDDO
        IF (NPHOT.eq.1) THEN
          DO k = 1,4
            p1r(k) = p1(k)
            q1r(k) = q1(k)
            p2r(k) = p2(k)
            q2r(k) = q2(k)
            pkr(k) = pk(k)
          ENDDO
        ELSE
! Initial state radiation
          IF (ira.eq.1 .or. ira.eq.2) THEN
! Reduction procedure (e+e- ---> e+e- + gamma like process)
            CALL REDUZ1(qq,p1,q1,pk,p1r,q1r,pkr)
            DO k = 1,4
              p2r(k) = p2r0(k)
              q2r(k) = q2r0(k)
              pp(k)  = p1r(k) + q1r(k)
            ENDDO
            CALL boost5(pp ,p1r,q1r,p2r,q2r,pkr)
            CALL rotat5(p1r,q1r,p2r,q2r,pkr)
! Final state radiation
          ELSE
! Reduction procedure (e+e- ---> e+e- + gamma like process)
            DO k = 1,4
               pk(k) = -pk(k)
            ENDDO
            CALL REDUZ1(qq,p2,q2,pk,p2r,q2r,pkr)
            DO k = 1,4
              p1r(k) = p1r0(k)
              q1r(k) = q1r0(k)
              pkr(k) =-pkr(k)
            ENDDO
          ENDIF
        ENDIF
! Soft factor (for massive fermion 4-momenta)
        sfr = SoftFm(p1r,q1r,p2r,q2r,pkr)
!Soft factor (for massless fermion 4-momenta) - for tests
!WP        sfr = SoftFa(p1r,q1r,p2r,q2r,pkr)
! Single hard photon bremss. matrix element
        dis10 = xmecal(p1r,q1r,p2r,q2r,pkr) /( 4*(4*pi*alfa)**3 )
! beta1 O(alpha1)
        beta1i = dis10/sfr - beta00
! Sum of beta1 for all photons
        beta10 = beta10 + beta1i
      ENDDO
!
!          **************************************
!          **     Definitions of MC weights    **
!          **************************************
! All beta's:  O(alf0),O(alf1)
      wtset(110) =  beta00           /crude
      wtset(111) = (beta01 + beta10) /crude
!==================================================================
!==================================================================
!                  Non-exponentiated version                      !
!==================================================================
!==================================================================
! Entire 0,1-photon distributions
      dsne0 = 0
      dsne1 = 0
      fYFS  = 1
      IF(NPHOT.eq.0) THEN
! [0] No hard photons
! O(alpha^0,^1) entire distributions
        dsne0 = dis00
        dsne1 = dis01
! YFS formfactor
        fYFS = YFSfmf(eps)
      ELSEIF(NPHOT.eq.1) THEN
! [1] One hard photon
! O(alpha^1) entire distribution
        dsne1 =  dis10 /sfr
! YFS formfactor
        fYFS = YFSfmf(eps)
      ENDIF
!
!          **************************************
!          ****   Definitions of MC weights  ****
!          ****    Non-exponentiated case    ****
!          **************************************
! TOTAL O(alpha^0),O(alpha^1)
      wtset(120) = dsne0 /fYFS/crude
      wtset(121) = dsne1 /fYFS/crude
!---------------------------------------------------------------!
! Setting some "bad" weights to zero!
      wtx1 =-10.0
      wtx2 = 50.0
      wt0 = wtcrud*wttrig*wtset(110)
! This is less dangerous
      IF (wt0.lt.wtx1 .or. wt0.gt.wtx2) THEN
        ibadw0 = ibadw0 + 1
        IF (KeyDia.EQ.2) THEN
          IObad = 6
          WRITE(IObad,*)' '
          WRITE(IObad,*)'>>> BHWIDE WARNING !!! <<<'
          WRITE(IObad,*)'MODEL2: BAD weight wt0 -> reset to zero!'
          WRITE(IObad,*)'iwt0,wt0=',ibadw0,wt0
          WRITE(IObad,*)'s,s1=',s,s1
          WRITE(IObad,*)'t,t1=',t,t1
          WRITE(IObad,*)'idrad=',(idrad(i),i=1,nphot)
          CALL BH_DUMPS(IObad)
        ENDIF
        wtset(110) = 0
      ENDIF
      wt1 = wtcrud*wttrig*wtset(111)
! This is more dangerous
      IF (wt1.lt.wtx1 .or. wt1.gt.wtx2) THEN
        ibadw1 = ibadw1 + 1
        IF (KeyDia.GT.0) THEN
          IObad = 6
          WRITE(IObad,*)' '
          WRITE(IObad,*)'>>> BHWIDE WARNING !!! <<<'
          WRITE(IObad,*)'>>> MODEL2: BAD weight wt1 -> reset to zero!'
          WRITE(IObad,*)'iwt1,wt1=',ibadw1,wt1
          WRITE(IObad,*)'s,s1=',s,s1
          WRITE(IObad,*)'t,t1=',t,t1
          WRITE(IObad,*)'idrad=',(idrad(i),i=1,nphot)
          WRITE(IObad,*)'beta00,beta10=',beta00,beta10
          CALL BH_DUMPS(IObad)
        ENDIF
        wtset(111) = 0
      ENDIF
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
!+++++++++++++++++++ PRINCIPAL WEIGHT ++++++++++++++++++++++++++!
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
      wtset(101) = wtset(111)
      END

c  gen_bhw104

      FUNCTION SoftFm(p1,q1,p2,q2,pk)
*     *******************************
!---------------------------------------------------------------!
! This function provides a value of the soft factor S-tilde     !
! for massless fermions (factor (alpha/4pi^2) omitted!).        !
! INPUT:  p1(4),q1(4),p2(4),q2(4) - fermion 4-momenta           !
!                           pk(4) - photon  4-momentum          !
!---------------------------------------------------------------!
! Written by: Wieslaw Placzek              Knoxville, May 1995  !
! Last update: 14.07.1995       by: W.P.                        !
!---------------------------------------------------------------!
      implicit REAL*8 (a-h,o-z)
      COMMON / BHPAR2 / CMSENE,AMEL
      SAVE   / BHPAR2 /
      REAL*8 p1(4) ,q1(4) ,p2(4) ,q2(4) ,pk(4)
!
      ame = AMEL
! Scalar products of various 4-momenta
      p1k = p1(4)*pk(4)-p1(3)*pk(3)-p1(2)*pk(2)-p1(1)*pk(1)
      q1k = q1(4)*pk(4)-q1(3)*pk(3)-q1(2)*pk(2)-q1(1)*pk(1)
      p2k = p2(4)*pk(4)-p2(3)*pk(3)-p2(2)*pk(2)-p2(1)*pk(1)
      q2k = q2(4)*pk(4)-q2(3)*pk(3)-q2(2)*pk(2)-q2(1)*pk(1)
      p1q1 = p1(4)*q1(4)-p1(3)*q1(3)-p1(2)*q1(2)-p1(1)*q1(1)
      p1p2 = p1(4)*p2(4)-p1(3)*p2(3)-p1(2)*p2(2)-p1(1)*p2(1)
      p1q2 = p1(4)*q2(4)-p1(3)*q2(3)-p1(2)*q2(2)-p1(1)*q2(1)
      q1p2 = q1(4)*p2(4)-q1(3)*p2(3)-q1(2)*p2(2)-q1(1)*p2(1)
      q1q2 = q1(4)*q2(4)-q1(3)*q2(3)-q1(2)*q2(2)-q1(1)*q2(1)
      p2q2 = p2(4)*q2(4)-p2(3)*q2(3)-p2(2)*q2(2)-p2(1)*q2(1)
! Soft factor
      sfml = 2*( p1p2/(p1k*p2k) +p1q1/(p1k*q1k) -p1q2/(p1k*q2k)
     &          -q1p2/(q1k*p2k) +p2q2/(p2k*q2k) +q1q2/(q1k*q2k) )
      sfmt = ame**2 *(1/p1k**2 +1/q1k**2 +1/p2k**2 +1/q2k**2)
      SoftFm = sfml - sfmt
      END

c  gen_bhw104

      SUBROUTINE  BH_VACPOL(KeyPia,Q2,SINW2,RePiE,dRePiE)
!     ************************************************
!  Interface to various calculations of real part RePi
!  of cacuum polarization on the photon line.
!  Input:
!     Q2 = transfer GeV**2, negative for spacelike
!  Output:
!     RePiE  = Real Part Vacuum polarization on photon line
!              Leptonic + hadronic.
!     dRePiE = absolute error of RePiE
!     ***************************
      IMPLICIT REAL*8(A-H,O-Z)
      SAVE
      REAL *4 enq,st2,der,errder,deg,errdeg

      QQ=Q2
      IF(KeyPia .EQ. 0) THEN
        RePiE  = 0d0
        dRePiE = 0d0
      ELSEIF(KeyPia .EQ. 1) THEN
! From Burkhardt 1981,1989
        RePiE  = REPI(QQ)
        dRePiE = 0d0
      ELSEIF(KeyPia .EQ. 2) THEN
! From S. Eidelman, F. Jegerlehner, Z. Phys. C (1995)
        enq= QQ/sqrt(abs(QQ))
        st2= SINW2
        CALL hadr5(enq,st2,der,errder,deg,errdeg)
! Leptonic part taken from Burkhardt
        RePiE  = -der + REPIL(QQ)  ! total
        dRePiE = errder
      ELSEIF(KeyPia .EQ. 3) THEN
! From Burkhardt and Pietrzyk 1995 (Moriond)
        RePiE  = REPI95(QQ)
        dRePiE = 0d0
      ELSE
        WRITE(6,*) 'STOP in VACPOL ++++ WRONG KeyPia=', KeyPia
        STOP
      ENDIF
      END

c  gen_bhw104

      FUNCTION REPIL(S)
!-------------------------------------------- REMARKS ---------------
! VACUUM POLARIZATION IN QED. THE LEPTONIC CONTRIBUTION IS AN ANALY
! EXPRESSION INVOLVING THE LEPTON MASS; THE HADRONIC CONTRIBUTION IS
! A DISPERSION INTEGRAL OVER THE KNOWN HADRONIC CROSS SECTION. THE
! RESULT USED HERE IS A PARAMETRIZATION GIVEN BY
! H.BURKHARDT, TASSO NOTE 192(1981).
! updated see H.Burkhardt et al. Pol. at Lep CERN 88-06 VOL I
! lepton masses now fully taken into account, H.Burkhardt June 89
!--------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 BETA
      REAL*8 M(3)
      SAVE M
      SAVE I, AL3PI
!
      DATA M/0.51099906D-3,0.10565839D0,1.7841D0/

!
!     for leptons use F,P functions see Burgers, Hollik etc.
!     F(s,m1,m2) for m1=m2 depends only on beta = sqrt((1-4m**2)/s)
      FSYM(BETA)=2.D0+BETA*LOG( (BETA-1.D0)/(BETA+1.D0) )
      P(S,XM,BETA)=1.D0/3.D0-(1.D0+2.D0*XM**2/S) * FSYM(BETA)
!     asymptotic formula for high energies (real part)
      PASYM(S,XM)=-5.D0/3.D0 - LOG (ABS(XM**2/S))
!
!---------------------------------- init and  CHECK FOR S VALUES ----
      DATA I/0/
c
      IF(I.EQ.0) THEN
        I=1
        AL3PI=1./ (3.D0 * 137.0359895D0 * 3.141592653589793D0)
        IF(S.GT.0.D0.AND.S.LT.100.D0)
     .  WRITE(6,'(3H0S=,F6.3,7H GEV**2,/,
     .    46H VACUUM POLARIZATION MAY BE BADLY APPROXIMATED)')
      ENDIF
!-------------------------------------------- LEPTONIC PART ---------
      REPIL=0.D0
!     loop over leptons
      DO 1 I=1,3
        IF(ABS(S).GT.1.D3*M(I)**2) THEN
!         asymptotic formula for s,t >> m**2
          REPIL=REPIL-PASYM(S,M(I))
        ELSE
          BETA=1.D0-4.D0*M(I)**2/S
          BETA=SQRT(BETA)
          REPIL=REPIL-P(S,M(I),BETA)
        ENDIF
    1 CONTINUE
      REPIL=AL3PI*REPIL
      END

c  gen_bhw104

      FUNCTION REPI95(S)
C-------------------------------------------- REMARKS ---------------
C Vacuum polarization in QED. The leptonic contribution is an analytic
C expression involving the lepton mass; the hadronic contribution is fro
C a dispersion integral over the known hadronic cross section. The
C result used here is a Parametrization given by
C H.Burkhardt, TASSO note 192(1981).
C updated by H.Burkhardt, B.Pietrzyk; see H.Burkhardt in proceedings
C of electroweak Moriond 1995 and   Burkhardt, Pietrzyk to be published
C--------+---------+---------+---------+---------+---------+---------+--
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 BETA
      REAL*8 M(3)
      PARAMETER (NREG=5)
      DIMENSION WREG(0:NREG),AREG(NREG),BREG(NREG),CREG(NREG)
C
      DATA WREG/-0.4,-2.,-4.,-10.,91.2,100 000./
      DATA AREG/0.,0.,0.,0.00122270,0.00164178/
      DATA BREG/0.00228770,0.00251507,0.00279328,0.00296694,0.00292051/
      DATA CREG/4.08041425,3.09624477,2.07463133,1.0,1.0/
C
      DATA M/0.51099906D-3,0.10565839D0,1.7841D0/
C
C     for leptons use F,P functions see Burgers, Hollik etc.
C     F(s,m1,m2) for m1=m2 depends only on beta = sqrt((1-4m**2)/s)
      FSYM(BETA)=2.D0+BETA*LOG( (BETA-1.D0)/(BETA+1.D0) )
      P(S,XM,BETA)=1.D0/3.D0-(1.D0+2.D0*XM**2/S) * FSYM(BETA)
C     asymptotic formula for high energies (real part)
      PASYM(S,XM)=-5.D0/3.D0 - LOG (ABS(XM**2/S))
C
C---------------------------------- init and  CHECK FOR S VALUES ----
      DATA I/0/
      IF(I.EQ.0) THEN
        I=1
        AL3PI=1./ (3.D0 * 137.0359895D0 * 3.141592653589793D0)
c
        IF(S.GT.0.D0.AND.S.LT.100.D0)
     .  WRITE(6,'(3H S=,F6.3,7H GeV**2,//,
     .    46H vacuum polarization may be badly approximated)') S
      ENDIF
C-------------------------------------------- LEPTONIC PART ---------
      REPI95=0.D0
C     loop over leptons
      DO I=1,3
        IF(ABS(S).GT.1.D3*M(I)**2) THEN
C         asymptotic formula for s,t >> m**2
          REPI95=REPI95-PASYM(S,M(I))
        ELSE
          BETA=1.D0-4.D0*M(I)**2/S
          BETA=SQRT(BETA)
          REPI95=REPI95-P(S,M(I),BETA)
        ENDIF
      ENDDO
      REPI95=AL3PI*REPI95
C-------------------------------------------- hadronic part ---------
      T=ABS(S)
      DO I=1,NREG
        IREG=I
        IF(T.LT.WREG(I)**2) GOTO 1
      ENDDO
    1 CONTINUE
      HADPI=AREG(IREG)+BREG(IREG)*LOG(1.+CREG(IREG)*T)
C     WRITE(6,*) ' SQRTS=',SQRT(T),' leptonic part=',REPI95,
C    .  ' hadronic part=',HADPI,' total=',REPI95-HADPI
      REPI95=REPI95-HADPI
      END

c  gen_bhw104

      FUNCTION REPI(S)
!-------------------------------------------- REMARKS ---------------
! VACUUM POLARIZATION IN QED. THE LEPTONIC CONTRIBUTION IS AN ANALY
! EXPRESSION INVOLVING THE LEPTON MASS; THE HADRONIC CONTRIBUTION IS
! A DISPERSION INTEGRAL OVER THE KNOWN HADRONIC CROSS SECTION. THE
! RESULT USED HERE IS A PARAMETRIZATION GIVEN BY
! H.BURKHARDT, TASSO NOTE 192(1981).
! updated see H.Burkhardt et al. Pol. at Lep CERN 88-06 VOL I
! lepton masses now fully taken into account, H.Burkhardt June 89
!--------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
      COMPLEX*16 BETA
      REAL*8 M(3)
      SAVE A1,B1,C1,A2,B2,C2,A3,B3,C3,A4,B4,C4,M
      SAVE I, AL3PI
!
      DATA A1,B1,C1/   0.0   ,   0.00835,  1.0   /
      DATA A2,B2,C2/   0.0   ,   0.00238,  3.927 /
      DATA A3,B3,C3/ 0.00165 ,   0.00300,  1.0   /
      DATA A4,B4,C4/ 0.00221 ,   0.00293,  1.0   /
!
      DATA M/0.51099906D-3,0.10565839D0,1.7841D0/

!
!     for leptons use F,P functions see Burgers, Hollik etc.
!     F(s,m1,m2) for m1=m2 depends only on beta = sqrt((1-4m**2)/s)
      FSYM(BETA)=2.D0+BETA*LOG( (BETA-1.D0)/(BETA+1.D0) )
      P(S,XM,BETA)=1.D0/3.D0-(1.D0+2.D0*XM**2/S) * FSYM(BETA)
!     asymptotic formula for high energies (real part)
      PASYM(S,XM)=-5.D0/3.D0 - LOG (ABS(XM**2/S))
!
!---------------------------------- init and  CHECK FOR S VALUES ----
      DATA I/0/
      IF(I.EQ.0) THEN
        I=1
        AL3PI=1./ (3.D0 * 137.0359895D0 * 3.141592653589793D0)
        IF(S.GT.0.D0.AND.S.LT.100.D0)
     .  WRITE(6,'(3H0S=,F6.3,7H GEV**2,/,
     .    46H VACUUM POLARIZATION MAY BE BADLY APPROXIMATED)')
      ENDIF
!-------------------------------------------- LEPTONIC PART ---------
      REPI=0.D0
!     loop over leptons
      DO 1 I=1,3
        IF(ABS(S).GT.1.D3*M(I)**2) THEN
!         asymptotic formula for s,t >> m**2
          REPI=REPI-PASYM(S,M(I))
        ELSE
          BETA=1.D0-4.D0*M(I)**2/S
          BETA=SQRT(BETA)
          REPI=REPI-P(S,M(I),BETA)
        ENDIF
    1 CONTINUE
      REPI=AL3PI*REPI
!-------------------------------------------- HADRONIC PART ---------
      X=DABS(S)
      IF(X.LT.0.3**2) THEN
        REPI=REPI- (A1+B1*LOG(1.+C1*X))
      ELSEIF(X.LT.3.**2) THEN
        REPI=REPI- (A2+B2*LOG(1.+C2*X))
      ELSEIF(X.LT.100.**2) THEN
        REPI=REPI- (A3+B3*LOG(1.+C3*X))
      ELSE
        REPI=REPI- (A4+B4*LOG(1.+C4*X))
      ENDIF
      END

!Return-Path: <jegerlehner@PSICLU.CERN.CH>
!Date: Mon, 20 Mar 1995 10:30:49 +0100
!From: jegerlehner@psiclu.cern.ch (Fred Jegerlehner)
!X-Vms-To: DXMINT::jadach@cernvm.cern.ch
!X-Vms-Cc: JEGERLEHNER
!Subject: Re: hadronic vacuum polarization
!X-Mail11-Ostype: VAX/VMS
!Apparently-To: <jadach@cernvm.cern.ch>
!Dear Staszek,
!the uncertainty of course depends on the energy and goes to zero as E -> 0.
!The routine I have sent you gives you the uncertainty for a given energy.
!At 1 GeV spacelike I get
!     E        delta alpha   uncertainty
! -1.0000E+00   3.7362E-03   9.2977E-05
!A copy of our paper you may get by anonymous ftp as follows:
!ftp 129.129.40.58
!anonymous
!username
!cd pub
!cd preprints
!get vapogm2.ps.gz

c  gen_bhw104

      subroutine hadr5(e,st2,der,errder,deg,errdeg)
c ******************************************************************
c *                                                                *
c *      subroutine for the evaluation of the light hadron         *
c *           contributions to Delta_r  and  Delta_g               *
c *                    using fits to the                           *
c *          QED vacuum polarization from e^+ e^- data             *
c *                                                                *
c *    F. Jegerlehner, Paul Scherrer Institute, CH-5232 Villigen   *
c *                                                                *
c *    E-mail:jegerlehner@cvax.psi.ch                              *
c *    Phone :   +41-56-993662                                     *
c *                                                                *
c *    Reference: F. Jegerlehner, Z. Phys. C32 (1986) 195          *
c *               H. Burkhardt et al., Z. Phys. C42 (1989) 497     *
c *               S. Eidelman, F. Jegerlehner, Z. Phys. C (1995)   *
c *                                                                *
c ******************************************************************
c       VERSION: 24/02/1995
c
C  Notation: E energy ( momentum transfer ): E>0 timelike , E<0 spacelike
C            st2 is sin^2(Theta); st2=0.2322 is the reference value
C  the routine returns the hadronic contribution of 5 flavors (u,d,s,c,b)
C                 to   DER=Delta_r with hadronic error ERRDER
C                and   DEG=Delta_g with hadronic error ERRDEG
C  The effective value of the fine structure constant alphaQED at energy
C  E is alphaQED(E)=alphaQED(0)/(1-Delta_r) ,similarly for the SU(2)
C  coupling alphaSU2(E)=alphaSU2(0)/(1-Delta_g), where Delta_r(g) is the
C  sum of leptonic, hadronic contributions (top to be added).
C
C  This program does not yet know how to compute Delta r and Delta g for
C  energies in the ranges  |E|>1TeV and 2m_pi < E < 40(13) GeV !!!!!!!!!
C
       implicit none
       integer *2 nf,ns,i,j
       parameter(nf=9,ns=4)
       real *4 e,st2,st20,der,deg,errder,errdeg,s,s0,x1,xi,x2,xlog,xlar
       real *4 m1(nf),c1(nf,ns),c2(nf,ns),c3(nf,ns),c4(nf,ns),ae(nf,ns)
       real *4 eu(nf),eo(nf),res(ns),l1(nf,ns),fx,gx,hx,xx,u,Se
C
       do i=1,nf
         do j=1,ns
           ae(i,j)=0.0
         enddo
       enddo
c #1# Delta_r
c Fit parameters spacelike  -1000 to  -200 GeV
      eu(1)  =-1000.
      eo(1)  = -200.
      m1(1)=  -1000.000
      c1(1,1)=  4.2069394e-02
      c2(1,1)=  2.9253566e-03
      c3(1,1)= -6.7782454e-04
      c4(1,1)=  9.3214130e-06
c   chi2=  2.5763808e-05
c Fit parameters spacelike  -200 to  -20 GeV
      eu(2)  = -200.
      eo(2)  =  -20.
      m1(2)  =  -100.0000
      c1(2,1)=  2.8526291e-02
      c2(2,1)=  2.9520725e-03
      c3(2,1)= -2.7906310e-03
      c4(2,1)=  6.4174528e-05
c   chi2=  6.6264300e-04
c Fit parameters spacelike   -20 to   -2 GeV
      eu(3)  =  -20.
      eo(3)  =   -2.
      m1(3)  =   -20.0000
      l1(3,1)=  9.3055e-3
      c1(3,1)=  2.8668314e-03
      c2(3,1)=  0.3514608
      c3(3,1)=  0.5496359
      c4(3,1)=  1.9892334e-04
c   chi2=  4.2017717e-03
      ae(3,1)=  3.0
c Fit parameters spacelike    -2 to    0.25 GeV
      eu(4)  =   -2.
      eo(4)  =    0.25
      m1(4)  =    -2.0000
      l1(4,1)=  9.3055e-3
      c1(4,1)=  2.2694240e-03
      c2(4,1)=   8.073429
      c3(4,1)=  0.1636393
      c4(4,1)= -3.3545541e-05
c   chi2=  0.1239052
      ae(4,1)=  2.0
c Fit parameters timelike   0.25 to    2 GeV
      eu(5)  =    0.25
      eo(5)  =    2.
c Fit parameters timelike   2    to   40 GeV
      eu(6)  =    2.
      eo(6)  =   40.
c Fit parameters timelike     40 to   80 GeV
      eu(7)  =   40.
      eo(7)  =   80.
      m1(7)  =   80.00000
      c1(7,1)=  2.7266588e-02
      c2(7,1)=  2.9285045e-03
      c3(7,1)= -4.7720564e-03
      c4(7,1)=  7.7295507e-04
c   chi2=  7.7148885e-05
c Fit parameters timelike     80 to  250 GeV
      eu(8)  =   80.
      eo(8)  =  250.
      m1(8)  =   91.18880
      c1(8,1)=  2.8039809e-02
      c2(8,1)=  2.9373798e-03
      c3(8,1)= -2.8432352e-03
      c4(8,1)= -5.2537734e-04
c   chi2=  4.2241514e-05
c Fit parameters timelike    250 to 1000 GeV
      eu(9)  =  250.
      eo(9)  = 1000.
      m1(9)  = 1000.00000
      c1(9,1)=  4.2092260e-02
      c2(9,1)=  2.9233438e-03
      c3(9,1)= -3.2966913e-04
      c4(9,1)=  3.4324117e-07
c   chi2=  6.0426464e-05
c #2# Delta_g
c Fit parameters spacelike  -1000 to  -200 GeV
c     eu(1)  =-1000.
c     eo(1)  = -200.
c     m1(1)=  -1000.000
      c1(1,2)=  8.6415343e-02
      c2(1,2)=  6.0127582e-03
      c3(1,2)= -6.7379221e-04
      c4(1,2)=  9.0877611e-06
c   chi2=  9.6284139e-06
c Fit parameters spacelike  -200 to  -20 GeV
c     eu(2)  = -200.
c     eo(2)  =  -20.
c     m1(2)  =  -100.0000
      c1(2,2)=  5.8580618e-02
      c2(2,2)=  6.0678599e-03
      c3(2,2)= -2.4153464e-03
      c4(2,2)=  6.1934326e-05
c   chi2=  6.3297758e-04
c Fit parameters spacelike   -20 to   -2 GeV
c     eu(3)  =  -20.
c     eo(3)  =   -2.
c     m1(3)  =   -20.0000
      l1(3,2)=  1.9954e-2
      c1(3,2)=  5.7231588e-03
      c2(3,2)=  0.3588257
      c3(3,2)=  0.5532265
      c4(3,2)=  6.0730567e-04
c   chi2=  7.9884287e-03
      ae(3,2)=  3.0
c   chi2=  4.2017717e-03
c Fit parameters spacelike    -2 to    0.25 GeV
c     eu(4)  =   -2.
c     eo(4)  =    0.25
c     m1(4)  =    -2.0000
      l1(4,2)=  1.9954e-2
      c1(4,2)=  4.8065037e-03
      c2(4,2)=   8.255167
      c3(4,2)=  0.1599882
      c4(4,2)= -1.8624817e-04
c   chi2=  0.1900761
      ae(3,2)=  2.0
c Fit parameters timelike     40 to   80 GeV
c     eu(7)  =   40.
c     eo(7)  =   80.
c     m1(7)  =   80.00000
      c1(7,2)=  5.5985276e-02
      c2(7,2)=  6.0203830e-03
      c3(7,2)= -5.0066952e-03
      c4(7,2)=  7.1363564e-04
c   chi2=  7.6000040e-05
c Fit parameters timelike     80 to  250 GeV
c     eu(8)  =   80.
c     eo(8)  =  250.
c     m1(8)  =   91.18880
      c1(8,2)=  5.7575710e-02
      c2(8,2)=  6.0372148e-03
      c3(8,2)= -3.4556778e-03
      c4(8,2)= -4.9574347e-04
c   chi2=  3.3244669e-05
c Fit parameters timelike    250 to 1000 GeV
c     eu(9)  =  250.
c     eo(9)  = 1000.
c     m1(9)  = 1000.00000
      c1(9,2)=  8.6462371e-02
      c2(9,2)=  6.0088057e-03
      c3(9,2)= -3.3235471e-04
      c4(9,2)=  5.9021050e-07
c   chi2=  2.9821187e-05
c #3# error Delta_r
c Fit parameters spacelike  -1000 to  -200 GeV
c     eu(1)  =-1000.
c     eo(1)  = -200.
c     m1(1)=  -1000.000
      c1(1,3)=  6.3289929e-04
      c2(1,3)=  3.3592437e-06
      c3(1,3)=  0.0
      c4(1,3)=  0.0
c   chi2=  2.3007713E-05
c Fit parameters spacelike  -200 to  -20 GeV
c     eu(2)  = -200.
c     eo(2)  =  -20.
c     m1(2)  =  -100.0000
      c1(2,3)=  6.2759849e-04
      c2(2,3)= -1.0816625e-06
      c3(2,3)=   5.050189
      c4(2,3)= -9.6505374e-02
c   chi2=  3.4677869e-04
      ae(2,3)=  1.0
c Fit parameters spacelike   -20 to   -2 GeV
c     eu(3)  =  -20.
c     eo(3)  =   -2.
c     m1(3)  =   -20.0000
      l1(3,3)=  2.0243e-4
      c1(3,3)=  1.0147886e-04
      c2(3,3)=   1.819327
      c3(3,3)= -0.1174904
      c4(3,3)= -1.2404939e-04
c   chi2=  7.1917898e-03
      ae(3,3)=  3.0
c Fit parameters spacelike    -2 to    0.25 GeV
c     eu(4)  =   -2.
c     eo(4)  =    0.25
c     m1(4)  =    -2.0000
      l1(4,3)=  2.0243e-4
      c1(4,3)= -7.1368617e-05
      c2(4,3)=  9.980347e-04
      c3(4,3)=   1.669151
      c4(4,3)=  3.5645600e-05
c   chi2=  0.1939734
      ae(4,3)=  2.0
c Fit parameters timelike     40 to   80 GeV
c     eu(7)  =   40.
c     eo(7)  =   80.
c     m1(7)  =   80.00000
      c1(7,3)=  6.4947648e-04
      c2(7,3)=  4.9386853e-07
      c3(7,3)=  -55.22332
      c4(7,3)=   26.13011
c   chi2=  7.2068366e-04
c Fit parameters timelike     80 to  250 GeV
c     eu(8)  =   80.
c     eo(8)  =  250.
c     m1(8)  =   91.18880
      c1(8,3)=  6.4265809e-04
      c2(8,3)= -2.8453374e-07
      c3(8,3)=  -23.38172
      c4(8,3)=  -6.251794
c   chi2=  1.1478480e-07
c Fit parameters timelike    250 to 1000 GeV
c     eu(9)  =  250.
c     eo(9)  = 1000.
c     m1(9)  = 1000.00000
      c1(9,3)=  6.3369947e-04
      c2(9,3)= -2.0898329e-07
      c3(9,3)=  0.0
      c4(9,3)=  0.0
c   chi2=  2.9124376E-06
c #4# error Delta_g
c Fit parameters spacelike  -1000 to  -200 GeV
c     eu(1)  =-1000.
c     eo(1)  = -200.
c     m1(1)=  -1000.000
      c1(1,4)=  1.2999176e-03
      c2(1,4)=  7.4505529e-06
      c3(1,4)=  0.0
      c4(1,4)=  0.0
c   chi2=  2.5312527E-05
c Fit parameters spacelike  -200 to  -20 GeV
c     eu(2)  = -200.
c     eo(2)  =  -20.
c     m1(2)  =  -100.0000
      c1(2,4)=  1.2883141e-03
      c2(2,4)= -1.3790827e-06
      c3(2,4)=   8.056159
      c4(2,4)= -0.1536313
c   chi2=  2.9774895e-04
      ae(2,4)=  1.0
c Fit parameters spacelike   -20 to   -2 GeV
c     eu(3)  =  -20.
c     eo(3)  =   -2.
c     m1(3)  =   -20.0000
      l1(3,4)=  4.3408e-4
      c1(3,4)=  2.0489733e-04
      c2(3,4)=   2.065011
      c3(3,4)= -0.6172962
      c4(3,4)= -2.5603661e-04
c   chi2=  7.5258738e-03
      ae(3,4)=  3.0
c Fit parameters spacelike    -2 to    0.25 GeV
c     eu(4)  =   -2.
c     eo(4)  =    0.25
c     m1(4)  =    -2.0000
      l1(4,4)=  4.3408e-4
      c1(4,4)= -1.5095409e-04
      c2(4,4)=  9.9847501e-04
      c3(4,4)=   1.636659
      c4(4,4)=  7.5892596e-05
c   chi2=  0.1959371
      ae(4,4)=  2.0
c Fit parameters timelike     40 to   80 GeV
c     eu(7)  =   40.
c     eo(7)  =   80.
c     m1(7)  =   80.00000
      c1(7,4)=  1.3335156e-03
      c2(7,4)=  2.2939612e-07
      c3(7,4)=  -246.4966
      c4(7,4)=   114.9956
c   chi2=  7.2293193e-04
c Fit parameters timelike     80 to  250 GeV
c     eu(8)  =   80.
c     eo(8)  =  250.
c     m1(8)  =   91.18880
      c1(8,4)=  1.3196438e-03
      c2(8,4)=  2.8937683e-09
      c3(8,4)=   5449.778
      c4(8,4)=   930.3875
c   chi2=  4.2109136e-08
c Fit parameters timelike    250 to 1000 GeV
c     eu(9)  =  250.
c     eo(9)  = 1000.
c     m1(9)  = 1000.00000
      c1(9,4)=  1.3016918e-03
      c2(9,4)= -3.6027674e-07
      c3(9,4)=  0.0
      c4(9,4)=  0.0
c   chi2=  2.8220852E-06
C ######################################################################
       Se=654./643.      ! rescaling error to published version 1995
       st20=0.2322
       s=e**2
       der=0.0
       deg=0.0
       errder=0.0
       errdeg=0.0
       if ((e.gt.1.e3).or.(e.lt.-1.e3)) goto 100
       if ((e.lt.4.e1).and.(e.gt.0.25)) goto 100
       i=1
       do while (e.ge.eo(i))
         i=i+1
       enddo
       if (e.eq.1.e3) i=9
       if (e.eq.0.0 ) goto 100
       s0=sign(1.0,m1(i))*m1(i)**2
       s =sign(1.0,e)*e**2
       x1=s0/s
       xi=1.0/x1
       x2=x1**2
       if (ae(i,1).le.0.0) then
         do j=1,4
           xlar=xi+ae(i,j)*exp(-xi)
           xlog=log(xlar)
           res(j)=c1(i,j)
     .           +c2(i,j)*(xlog+c3(i,j)*(x1-1.0)+c4(i,j)*(x2-1.0))
         enddo
       else if (ae(i,1).eq.2.0) then
         hx     =xi**2
         do j=1,2
           fx     =1.0-c2(i,j)*s
           gx     = c3(i,j)*s/(c3(i,j)-s)
           xx     =log(abs(fx))+c2(i,j)*gx
           res(j)=c1(i,j)*xx-l1(i,j)*gx+c4(i,j)*hx
         enddo
         do j=3,4
           u      =abs(s)
           gx     =-c3(i,j)*u/(c3(i,j)+u)
           xx     =xi**3/(sqrt(abs(xi))**5+c2(i,j))
           res(j)=c1(i,j)*xx-l1(i,j)*gx+c4(i,j)*hx
         enddo
       else if (ae(i,1).eq.3.0) then
         hx     =xi
         do j=1,4
           fx     =1.0-c2(i,j)*s
           gx     = c3(i,j)*s/(c3(i,j)-s)
           xx     =log(abs(fx))+c2(i,j)*gx
           res(j)=c1(i,j)*xx-l1(i,j)*gx+c4(i,j)*hx
         enddo
       endif
       der=res(1)
       deg=res(2)*st20/st2
       errder=res(3)*Se
       errdeg=res(4)*Se
       goto 100
 99    write(*,*) ' out of range! '
100    return
       end

c  gen_bhw104

      SUBROUTINE DESK1W(FUNSKO,JDIV)
C     ******************************
C THIS ROUTINE BELONGS TO VESK8A PACKAGE
C IT SUDIVIDES INTO TWO EQUAL PARTS THE INTERVAL
C (XX(JDIV),XX(JDIV+1))  IN THE LATICE
C     ***********************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      save
      COMMON /BHCESK1W / XX(1025),YY(1025),ZINT(1025),ZSUM,JMAX
      COMMON /BHINOUT  / NINP,NOUT
      EXTERNAL FUNSKO
C
      XNEW=.5D0*(XX(JDIV) +XX(JDIV+1))
      DO 100 J=JMAX,JDIV,-1
      XX(J+2)  =XX(J+1)
      YY(J+2)  =YY(J+1)
  100 ZINT(J+1)=ZINT(J)
      XX(JDIV+1)= XNEW
      YY(JDIV+1)= FUNSKO(XNEW)
      IF(YY(JDIV+1).LT.0.) GOTO 999
      ZINT(JDIV)  =.5D0*(YY(JDIV+1)+YY(JDIV)  )*(XX(JDIV+1)-XX(JDIV)  )
      ZINT(JDIV+1)=.5D0*(YY(JDIV+2)+YY(JDIV+1))*(XX(JDIV+2)-XX(JDIV+1))
      JMAX=JMAX+1
      RETURN
  999 WRITE(NOUT,9000)
 9000 FORMAT(' **** STOP IN DESK1W, NEGATIVE VALUE OF FUNSKO ')
      STOP
      END

c  gen_bhw104

      SUBROUTINE VINSKW(FUNSKO)
C     *************************
C THIS ROUTINE BELONGS TO VESKO2 PACKAGE
C JLIM1 IS THE NUMBER OF CELLS, DIVISION OF THE UNIT PLAQUE INTO CELLS
C IS MADE IN THE FIRST STAGE.    JLIM2 IS THE TOTAL MAXIMUM
C NUMBER OF CELLS, NOTE THAT DIMENSIONS OF
C MATRICES IN /VESKOA/ SHOULD BE AT LEAST JLIM2
C     **********************************
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      save
C ------------------------------------------------------------
      PARAMETER( JLIM1 = 64, JLIM2 = 1000 , NOUT = 6 )
      COMMON /BHVESW2  / XX(JLIM2,2),DX(JLIM2,2),YY(JLIM2,2,2)
     $  ,YYMX(JLIM2),ZINT(JLIM2),ZSUM,LEV(JLIM2),JMAX
      EXTERNAL FUNSKO

C...  INITIALISATION PART, SAMPLING DISTRIBUTION FUNSKO
C...  AND FILLING MATRICES XX,YY,ZINT ETC.
      JMAX=1
      XX(1,1)=0D0
      XX(1,2)=0D0
      DX(1,1)=1D0
      DX(1,2)=1D0
      LEV(1)=1
      SUM=0D0
      DO 150 I=1,2
      DO 150 K=1,2
C... THIS IS NOT ELEGANT BUT SIMPLE
      YY(1,I,K)=FUNSKO(XX(1,1)+(I-1.)*DX(1,1),XX(1,2)+(K-1.)*DX(1,2))
      IF(YY(1,I,K).LT.0.0) GO TO 999
  150 SUM=SUM+YY(1,I,K)
      ZINT(1)=SUM*DX(1,1)*DX(1,2)/4D0

      JDIV=1
      DO 200 KK=1,JLIM2-1
      IF(JMAX.LT.JLIM1) THEN
C...    NOTE THAT DIVSKW INCREMENTS JMAX=JMAX+1 IN EVERY CALL

        CALL DIVSKW(JDIV,FUNSKO)

C(((((((((((
c      IF(JMAX.EQ.JLIM1) THEN
c      PRINT 9900,JMAX,(LEV(I),I=1,JMAX)
c 9900 FORMAT(///,' JMAX...  LEV LEV LEV LEV LEV',I10,/(24I5))
c      PRINT 9901,((XX(JD,I),I=1,2),JD=1,JMAX)
c 9901 FORMAT('  XX XX XX XX XX XX XX  ',/(10E12.5))
c      PRINT 9902,((DX(JD,I),I=1,2),JD=1,JMAX)
c 9902 FORMAT('  DX  DX DX DX DX DX ',/(10E12.5))
c      PRINT 9903,(((YY(JD,I,K),I=1,2),K=1,2),JD=1,JMAX)
c 9903 FORMAT('  YY  YY YY YY YY YY ',/(8E15.5))
c      PRINT 9904,(ZINT(I),I=1,JMAX)
c 9904 FORMAT('   ZINT ZINT ZINT ZINT ',/(10E12.5))
c      ENDIF
C))))))))))))
        JDIV=JDIV+2
        IF(JDIV.GT.JMAX) JDIV=1
      ELSE
        JDIV=1
        ZMX=ZINT(1)
        DO 180 J=1,JMAX
        IF(ZMX.LT.ZINT(J)) THEN
          ZMX=ZINT(J)
          JDIV=J
        ENDIF
  180   CONTINUE
        CALL DIVSKW(JDIV,FUNSKO)
      ENDIF
  200 CONTINUE

C(((((((((((
c      JPRN=64
c      PRINT 9910,JMAX,(LEV(I),I=1,JMAX)
c 9910 FORMAT(/,' JMAX...  LEV LEV LEV LEV LEV',I10,/(24I5))
c      IF(JMAX.LE.JPRN) PRINT 9911,((XX(JD,I),I=1,2),JD=1,JMAX)
c 9911 FORMAT('  XX XX XX XX XX XX XX  ',/(10E12.5))
c      IF(JMAX.LE.JPRN) PRINT 9912,((DX(JD,I),I=1,2),JD=1,JMAX)
c 9912 FORMAT('  DX  DX DX DX DX DX ',/(10E12.5))
c      IF(JMAX.LE.JPRN) PRINT 9913,(((YY(JD,I,K),I=1,2),K=1,2),JD=1,JMAX)
c 9913 FORMAT('  YY  YY YY YY YY YY ',/(8E15.5))
c      IF(JMAX.LE.JPRN) PRINT 9914,(ZINT(I),I=1,JMAX)
c 9914 FORMAT('   ZINT ZINT ZINT ZINT ',/(10E12.5))
C     DO 902 J=1,JMAX
C     Z=1D0*J-.5D0
C 902 CALL HFILL(202,Z,ZINT(J))
C))))))))))))
C...  FINAL ADMINISTRATION, NORMALIZING ZINT ETC.
      ZSUM1=0D0
      ZSUM =0D0
      DO 260 J=1,JMAX
      ZSUM1=ZSUM1+ZINT(J)
      YMAX= 0D0
      DO 250 I=1,2
      DO 250 K=1,2
  250 YMAX= MAX(YMAX,YY(J,I,K))
      YYMX(J)=YMAX
      ZINT(J)=YMAX*DX(J,1)*DX(J,2)
  260 ZSUM=ZSUM+ZINT(J)
C((((((((
      ZR=ZSUM1/ZSUM
      PRINT 7000,ZR
 7000 FORMAT(' /////// ZSUM1/ZSUM= ',F20.8)
C)))))))))
      SUM=0D0
      DO 240 J=1,JMAX
      SUM=SUM+ZINT(J)
  240 ZINT(J)=SUM/ZSUM
C(((((((((((
c     JPRN=64
c     PRINT 9932,JMAX
c9932 FORMAT(/'=====JMAX ZINT ZINT ZINT  ',I10)
c     IF(JMAX.LE.JPRN) PRINT 9935,(ZINT(I),I=1,JMAX)
c9935            FORMAT(10E12.5)
C     DO 901 J=2,JMAX
C 901 CALL HFILL(201,(ZINT(J)-ZINT(J-1))*JMAX)
C     CALL HFILL(201,ZINT(1)*JMAX)
C))))))))))))
      RETURN
  999 WRITE(NOUT,9000)
 9000 FORMAT(' **** STOP IN VINSKW, NEGATIVE VALUE OF FUNSKO ')
      STOP
      END

c  gen_bhw104

      SUBROUTINE DIVSKW(JD,FUNSKO)
C     ****************************
C THIS ROUTINE BELONGS TO VESKO2 PACKAGE
C IT SUBDIVIDES ONE CELL (NO. JD) INTO TWO EQUAL SIZE CELLS
C     **********************************
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      save
C ------------------------------------------------------------
      PARAMETER( JLIM1 = 64, JLIM2 = 1000 , NOUT = 6 )
      COMMON /BHVESW2  / XX(JLIM2,2),DX(JLIM2,2),YY(JLIM2,2,2)
     $  ,YYMX(JLIM2),ZINT(JLIM2),ZSUM,LEV(JLIM2),JMAX
      EXTERNAL FUNSKO

C...  MOOVE TO MAKE A HOLE FOR A NEW ENTRY (ONE ADDITIONAL CELL)
      DO 100 J=JMAX,JD,-1
      ZINT(J+1)=ZINT(J)
      LEV(J+1)=LEV(J)
      DO 100 I=1,2
      XX(J+1,I)  =XX(J,I)
      DX(J+1,I)  =DX(J,I)
      DO 100 K=1,2
  100 YY(J+1,I,K)  =YY(J,I,K)
C...  CREATE TWO NEW CELLS AND STORE THEM
      LL= MOD(LEV(JD),2)+1
      DX(JD,LL)=DX(JD,LL)/2D0
      DX(JD+1,LL)=DX(JD+1,LL)/2D0
      XX(JD+1,LL)=XX(JD,LL)+DX(JD,LL)
      IF(LL.EQ.1) THEN
        DO 150 I=1,2
C... THIS IS NOT ELEGANT, PROBABLY COULD BE DONE BETTER
        YY(JD,2,I)=FUNSKO(XX(JD,1)+DX(JD,1),XX(JD,2)+(I-1.)*DX(JD,2))
  150   YY(JD+1,1,I)=YY(JD,2,I)
      ELSE
        DO 152 I=1,2
        YY(JD,I,2)=FUNSKO(XX(JD,1)+(I-1.)*DX(JD,1),XX(JD,2)+DX(JD,2))
  152   YY(JD+1,I,1)=YY(JD,I,2)
      ENDIF
C...  ESTIMATE THE INTEGRALS OVER NEW CELLS RESULTING FROM DIVISION
      DO 220 JDV=JD,JD+1
      LEV(JDV)=LEV(JDV)+1
      SUM=0D0
      DO 210 I=1,2
      DO 210 K=1,2
      IF(YY(JDV,I,K).LT.0.D0) GO TO 999
  210 SUM=SUM+YY(JDV,I,K)
  220 ZINT(JDV) =SUM*DX(JDV,1)*DX(JDV,2)/4D0
      JMAX=JMAX+1
      RETURN
  999 WRITE(NOUT,9000)
 9000 FORMAT(' **** STOP IN DIVSKW, NEGATIVE VALUE OF FUNSKO ')
      STOP
      END

c  gen_bhw104

      SUBROUTINE GAUSJD(FUN,AA,BB,EEPS,RESULT)
C     ****************************************
C Gauss integration by S. Jadach, Oct. 90.
C This is NON-ADAPTIVE (!!!!) UNOPTIMIZED (!!!) integration subprogram.
C     *************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION WG(12),XX(12)
      COMMON /BHINOUT  / NINP,NOUT
      EXTERNAL FUN
      save /BHinout/,wg,xx,ITERMX
      DATA WG
     $/0.101228536290376D0, 0.222381034453374D0, 0.313706645877887D0,
     $ 0.362683783378362D0, 0.027152459411754D0, 0.062253523938648D0,
     $ 0.095158511682493D0, 0.124628971255534D0, 0.149595988816577D0,
     $ 0.169156519395003D0, 0.182603415044924D0, 0.189450610455069D0/
      DATA XX
     $/0.960289856497536D0, 0.796666477413627D0, 0.525532409916329D0,
     $ 0.183434642495650D0, 0.989400934991650D0, 0.944575023073233D0,
     $ 0.865631202387832D0, 0.755404408355003D0, 0.617876244402644D0,
     $ 0.458016777657227D0, 0.281603550779259D0, 0.095012509837637D0/
      DATA ITERMX / 15/
      EPS=ABS(EEPS)
      A=AA
      B=BB
      NDIVI=1
C iteration over subdivisions terminated by precision requirement
      DO 400 ITER=1,ITERMX
      CALK8  =0D0
      CALK16 =0D0
C sum over DELTA subintegrals
      DO 200 K = 1,NDIVI
      DELTA = (B-A)/NDIVI
      X1    =  A + (K-1)*DELTA
      X2    =  X1+ DELTA
      XMIDLE= 0.5D0*(X2+X1)
      RANGE = 0.5D0*(X2-X1)
      SUM8 =0D0
      SUM16=0D0
C 8- and 12-point   Gauss integration over single DELTA subinterval
      DO 100 I=1,12
      XPLUS= XMIDLE+RANGE*XX(I)
      XMINU= XMIDLE-RANGE*XX(I)
      FPLUS=FUN(XPLUS)
      FMINU=FUN(XMINU)
      IF(I.LE.4) THEN
          SUM8 =SUM8  +(FPLUS+FMINU)*WG(I)/2D0
      ELSE
          SUM16=SUM16 +(FPLUS+FMINU)*WG(I)/2D0
      ENDIF
  100 CONTINUE
      CALK8 = CALK8 + SUM8 *(X2-X1)
      CALK16= CALK16+ SUM16*(X2-X1)
  200 CONTINUE
      ERABS = ABS(CALK16-CALK8)
      ERELA = 0D0
      IF(CALK16.NE.0D0) ERELA= ERABS/ABS(CALK16)
c     write(6,*) 'gausjd: CALK8,CALK16=',ITER,CALK8,CALK16,ERELA
C precision check to terminate integration
      IF(EEPS.GT.0D0) THEN
        IF(ERABS.LT. EPS) GOTO 800
      ELSE
        IF(ERELA.LT. EPS) GOTO 800
      ENDIF
  400 NDIVI=NDIVI*2
      WRITE(NOUT,*) ' +++++ GAUSJD:  REQUIRED PRECISION TO HIGH!'
      WRITE(NOUT,*) ' +++++ GAUSJD:  ITER,ERELA=',ITER,ERELA
  800 RESULT= CALK16
      END

c  gen_bhw104

      FUNCTION GAUS(F,A,B,EEPS)
C     *************************
C THIS IS ITERATIVE INTEGRATION PROCEDURE
C ORIGINATES  PROBABLY FROM CERN LIBRARY
C IT SUBDIVIDES INEGRATION RANGE UNTIL REQUIRED PRECISION IS REACHED
C PRECISION IS A DIFFERENCE FROM 8 AND 16 POINT GAUSS ITEGR. RESULT
C EEPS POSITIVE TREATED AS ABSOLUTE PRECISION
C EEPS NEGATIVE TREATED AS RELATIVE PRECISION
C     *************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION W(12),X(12)
      COMMON /BHINOUT  / NINP,NOUT
      save     /BHINOUT/, CONST, W, X
      EXTERNAL F

      DATA CONST /1.0D-19/
      DATA W
     1/0.10122 85362 90376d0, 0.22238 10344 53374d0,
     1 0.31370 66458 77887d0,
     2 0.36268 37833 78362d0, 0.02715 24594 11754d0,
     2 0.06225 35239 38648d0,
     3 0.09515 85116 82493d0, 0.12462 89712 55534d0,
     3 0.14959 59888 16577d0,
     4 0.16915 65193 95003d0, 0.18260 34150 44924d0,
     4 0.18945 06104 55069d0/
      DATA X
     1/0.96028 98564 97536d0, 0.79666 64774 13627d0,
     1 0.52553 24099 16329d0,
     2 0.18343 46424 95650d0, 0.98940 09349 91650d0,
     1 0.94457 50230 73233d0,
     3 0.86563 12023 87832d0, 0.75540 44083 55003d0,
     1 0.61787 62444 02644d0,
     4 0.45801 67776 57227d0, 0.28160 35507 79259d0,
     1 0.09501 25098 37637d0/
      EPS=ABS(EEPS)
      DELTA=CONST*ABS(A-B)
      GAUS=0D0
      AA=A
    5 Y=B-AA
      IF(ABS(Y) .LE. DELTA) RETURN
    2 BB=AA+Y
      C1=0.5D0*(AA+BB)
      C2=C1-AA
      S8=0D0
      S16=0D0
      DO 1 I=1,4
      U=X(I)*C2
    1 S8=S8+W(I)*(F(C1+U)+F(C1-U))
      DO 3 I=5,12
      U=X(I)*C2
    3 S16=S16+W(I)*(F(C1+U)+F(C1-U))
      S8=S8*C2
      S16=S16*C2
      IF(EEPS.LT.0D0) THEN
        IF(ABS(S16-S8) .GT. EPS*ABS(S16)) GO TO 4
      ELSE
        IF(ABS(S16-S8) .GT. EPS) GO TO 4
      ENDIF
      GAUS=GAUS+S16
      AA=BB
      GO TO 5
    4 Y=0.5D0*Y
      IF(ABS(Y) .GT. DELTA) GOTO 2
      WRITE(NOUT,7)
      GAUS=0D0
      RETURN
    7 FORMAT(1X,36HGAUS  ... TOO HIGH ACCURACY REQUIRED)
      END

c  gen_bhw104

      FUNCTION GAUS2(F,A,B,EEPS)
C     *************************
C THIS IS ITERATIVE INTEGRATION PROCEDURE
C ORIGINATES  PROBABLY FROM CERN LIBRARY
C IT SUBDIVIDES INEGRATION RANGE UNTIL REQUIRED PRECISION IS REACHED
C PRECISION IS A DIFFERENCE FROM 8 AND 16 POINT GAUSS ITEGR. RESULT
C EEPS POSITIVE TREATED AS ABSOLUTE PRECISION
C EEPS NEGATIVE TREATED AS RELATIVE PRECISION
C     *************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION W(12),X(12)
      COMMON /BHINOUT  / NINP,NOUT
      save     /BHINOUT/, CONST, W, X
      EXTERNAL F

      DATA CONST /1.0D-19/
      DATA W
     1/0.10122 85362 90376d0, 0.22238 10344 53374d0,
     1 0.31370 66458 77887d0,
     2 0.36268 37833 78362d0, 0.02715 24594 11754d0,
     2 0.06225 35239 38648d0,
     3 0.09515 85116 82493d0, 0.12462 89712 55534d0,
     3 0.14959 59888 16577d0,
     4 0.16915 65193 95003d0, 0.18260 34150 44924d0,
     4 0.18945 06104 55069d0/
      DATA X
     1/0.96028 98564 97536d0, 0.79666 64774 13627d0,
     1 0.52553 24099 16329d0,
     2 0.18343 46424 95650d0, 0.98940 09349 91650d0,
     1 0.94457 50230 73233d0,
     3 0.86563 12023 87832d0, 0.75540 44083 55003d0,
     1 0.61787 62444 02644d0,
     4 0.45801 67776 57227d0, 0.28160 35507 79259d0,
     1 0.09501 25098 37637d0/
      EPS=ABS(EEPS)
      DELTA=CONST*ABS(A-B)
      GAUS2=0D0
      AA=A
    5 Y=B-AA
      IF(ABS(Y) .LE. DELTA) RETURN
    2 BB=AA+Y
      C1=0.5D0*(AA+BB)
      C2=C1-AA
      S8=0D0
      S16=0D0
      DO 1 I=1,4
      U=X(I)*C2
    1 S8=S8+W(I)*(F(C1+U)+F(C1-U))
      DO 3 I=5,12
      U=X(I)*C2
    3 S16=S16+W(I)*(F(C1+U)+F(C1-U))
      S8=S8*C2
      S16=S16*C2
      IF(EEPS.LT.0D0) THEN
        IF(ABS(S16-S8) .GT. EPS*ABS(S16)) GO TO 4
      ELSE
        IF(ABS(S16-S8) .GT. EPS) GO TO 4
      ENDIF
      GAUS2=GAUS2+S16
      AA=BB
      GO TO 5
    4 Y=0.5D0*Y
      IF(ABS(Y) .GT. DELTA) GOTO 2
      WRITE(NOUT,7)
      GAUS2=0D0
      RETURN
    7 FORMAT(1X,36HGAUS2 ... TOO HIGH ACCURACY REQUIRED)
      END

c  gen_bhw104

      FUNCTION GAUS3(F,A,B,EEPS)
C     *************************
C THIS IS ITERATIVE INTEGRATION PROCEDURE
C ORIGINATES  PROBABLY FROM CERN LIBRARY
C IT SUBDIVIDES INEGRATION RANGE UNTIL REQUIRED PRECISION IS REACHED
C PRECISION IS A DIFFERENCE FROM 8 AND 16 POINT GAUSS ITEGR. RESULT
C EEPS POSITIVE TREATED AS ABSOLUTE PRECISION
C EEPS NEGATIVE TREATED AS RELATIVE PRECISION
C     *************************
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DIMENSION W(12),X(12)
      COMMON /BHINOUT  / NINP,NOUT
      save     /BHINOUT/, CONST, W, X
      EXTERNAL F
      DATA CONST /1.0D-19/
      DATA W
     1/0.10122 85362 90376d0, 0.22238 10344 53374d0,
     1 0.31370 66458 77887d0,
     2 0.36268 37833 78362d0, 0.02715 24594 11754d0,
     2 0.06225 35239 38648d0,
     3 0.09515 85116 82493d0, 0.12462 89712 55534d0,
     3 0.14959 59888 16577d0,
     4 0.16915 65193 95003d0, 0.18260 34150 44924d0,
     4 0.18945 06104 55069d0/
      DATA X
     1/0.96028 98564 97536d0, 0.79666 64774 13627d0,
     1 0.52553 24099 16329d0,
     2 0.18343 46424 95650d0, 0.98940 09349 91650d0,
     1 0.94457 50230 73233d0,
     3 0.86563 12023 87832d0, 0.75540 44083 55003d0,
     1 0.61787 62444 02644d0,
     4 0.45801 67776 57227d0, 0.28160 35507 79259d0,
     1 0.09501 25098 37637d0/
      EPS=ABS(EEPS)
      DELTA=CONST*ABS(A-B)
      GAUS3=0D0
      AA=A
    5 Y=B-AA
      IF(ABS(Y) .LE. DELTA) RETURN
    2 BB=AA+Y
      C1=0.5D0*(AA+BB)
      C2=C1-AA
      S8=0D0
      S16=0D0
      DO 1 I=1,4
      U=X(I)*C2
    1 S8=S8+W(I)*(F(C1+U)+F(C1-U))
      DO 3 I=5,12
      U=X(I)*C2
    3 S16=S16+W(I)*(F(C1+U)+F(C1-U))
      S8=S8*C2
      S16=S16*C2
      IF(EEPS.LT.0D0) THEN
        IF(ABS(S16-S8) .GT. EPS*ABS(S16)) GO TO 4
      ELSE
        IF(ABS(S16-S8) .GT. EPS) GO TO 4
      ENDIF
      GAUS3=GAUS3+S16
      AA=BB
      GO TO 5
    4 Y=0.5D0*Y
      IF(ABS(Y) .GT. DELTA) GOTO 2
      WRITE(NOUT,7)
      GAUS3=0D0
      RETURN
    7 FORMAT(1X,36HGAUS3 ... TOO HIGH ACCURACY REQUIRED)
      END

c  gen_bhw104

      DOUBLE PRECISION FUNCTION DILOGX(X)
C-------------------------------------------- REMARKS ---------------
C DILOGARITHM FUNCTION: DILOG(X)=INT( -LN(1-Z)/Z ) , 0 < Z < X .
C THIS IS THE CERNLIB VERSION.
C--------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)

      Z=-1.644934066848226D0
      IF(X .LT.-1.D0) GO TO 1
      IF(X .LE. 0.5D0) GO TO 2
      IF(X .EQ. 1.D0) GO TO 3
      IF(X .LE. 2.D0) GO TO 4
      Z=3.289868133696453D0
    1 T=1.D0/X
      S=-0.5D0
      Z=Z-0.5D0*DLOG(DABS(X))**2
      GO TO 5
    2 T=X
      S=0.5D0
      Z=0.D0
      GO TO 5
    3 DILOGX=1.644934066848226D0
      RETURN
    4 T=1.D0-X
      S=-0.5D0
      Z=1.644934066848226D0-DLOG(X)*DLOG(DABS(T))
    5 Y=2.666666666666667D0*T+0.666666666666667D0
      B=      0.000000000000001D0
      A=Y*B  +0.000000000000004D0
      B=Y*A-B+0.000000000000011D0
      A=Y*B-A+0.000000000000037D0
      B=Y*A-B+0.000000000000121D0
      A=Y*B-A+0.000000000000398D0
      B=Y*A-B+0.000000000001312D0
      A=Y*B-A+0.000000000004342D0
      B=Y*A-B+0.000000000014437D0
      A=Y*B-A+0.000000000048274D0
      B=Y*A-B+0.000000000162421D0
      A=Y*B-A+0.000000000550291D0
      B=Y*A-B+0.000000001879117D0
      A=Y*B-A+0.000000006474338D0
      B=Y*A-B+0.000000022536705D0
      A=Y*B-A+0.000000079387055D0
      B=Y*A-B+0.000000283575385D0
      A=Y*B-A+0.000001029904264D0
      B=Y*A-B+0.000003816329463D0
      A=Y*B-A+0.000014496300557D0
      B=Y*A-B+0.000056817822718D0
      A=Y*B-A+0.000232002196094D0
      B=Y*A-B+0.001001627496164D0
      A=Y*B-A+0.004686361959447D0
      B=Y*A-B+0.024879322924228D0
      A=Y*B-A+0.166073032927855D0
      A=Y*A-B+1.935064300869969D0
      DILOGX=S*T*(A-B)+Z
      END

c  gen_bhw104

      DOUBLE PRECISION FUNCTION DILOGY(X)
C-------------------------------------------- REMARKS ---------------
C DILOGARITHM FUNCTION: DILOG(X)=INT( -LN(1-Z)/Z ) , 0 < Z < X .
C THIS IS THE CERNLIB VERSION.
C--------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)

      Z=-1.644934066848226D0
      IF(X .LT.-1.D0) GO TO 1
      IF(X .LE. 0.5D0) GO TO 2
      IF(X .EQ. 1.D0) GO TO 3
      IF(X .LE. 2.D0) GO TO 4
      Z=3.289868133696453D0
    1 T=1.D0/X
      S=-0.5D0
      Z=Z-0.5D0*DLOG(DABS(X))**2
      GO TO 5
    2 T=X
      S=0.5D0
      Z=0.D0
      GO TO 5
    3 DILOGY=1.644934066848226D0
      RETURN
    4 T=1.D0-X
      S=-0.5D0
      Z=1.644934066848226D0-DLOG(X)*DLOG(DABS(T))
    5 Y=2.666666666666667D0*T+0.666666666666667D0
      B=      0.000000000000001D0
      A=Y*B  +0.000000000000004D0
      B=Y*A-B+0.000000000000011D0
      A=Y*B-A+0.000000000000037D0
      B=Y*A-B+0.000000000000121D0
      A=Y*B-A+0.000000000000398D0
      B=Y*A-B+0.000000000001312D0
      A=Y*B-A+0.000000000004342D0
      B=Y*A-B+0.000000000014437D0
      A=Y*B-A+0.000000000048274D0
      B=Y*A-B+0.000000000162421D0
      A=Y*B-A+0.000000000550291D0
      B=Y*A-B+0.000000001879117D0
      A=Y*B-A+0.000000006474338D0
      B=Y*A-B+0.000000022536705D0
      A=Y*B-A+0.000000079387055D0
      B=Y*A-B+0.000000283575385D0
      A=Y*B-A+0.000001029904264D0
      B=Y*A-B+0.000003816329463D0
      A=Y*B-A+0.000014496300557D0
      B=Y*A-B+0.000056817822718D0
      A=Y*B-A+0.000232002196094D0
      B=Y*A-B+0.001001627496164D0
      A=Y*B-A+0.004686361959447D0
      B=Y*A-B+0.024879322924228D0
      A=Y*B-A+0.166073032927855D0
      A=Y*A-B+1.935064300869969D0
      DILOGY=S*T*(A-B)+Z
      END

c  gen_bhw104

      DOUBLE PRECISION FUNCTION DPGAMM(Z)
C     **********************************
C Double precision Gamma function
      DOUBLE PRECISION Z,Z1,X,X1,X2,D1,D2,S1,S2,S3,PI,C(20),CONST

      save C,PI,CONST

      DATA C( 1) / 8.3333333333333333333333333332D-02/
      DATA C( 2) /-2.7777777777777777777777777777D-03/
      DATA C( 3) / 7.9365079365079365079365079364D-04/
      DATA C( 4) /-5.9523809523809523809523809523D-04/
      DATA C( 5) / 8.4175084175084175084175084175D-04/
      DATA C( 6) /-1.9175269175269175269175269175D-03/
      DATA C( 7) / 6.4102564102564102564102564102D-03/
      DATA C( 8) /-2.9550653594771241830065359477D-02/
      DATA C( 9) / 1.7964437236883057316493849001D-01/
      DATA C(10) /-1.3924322169059011164274322169D+00/
      DATA C(11) / 1.3402864044168391994478951001D+01/
      DATA C(12) /-1.5684828462600201730636513245D+02/
      DATA C(13) / 2.1931033333333333333333333333D+03/
      DATA C(14) /-3.6108771253724989357173265219D+04/
      DATA C(15) / 6.9147226885131306710839525077D+05/
      DATA C(16) /-1.5238221539407416192283364959D+07/
      DATA C(17) / 3.8290075139141414141414141414D+08/
      DATA C(18) /-1.0882266035784391089015149165D+10/
      DATA C(19) / 3.4732028376500225225225225224D+11/
      DATA C(20) /-1.2369602142269274454251710349D+13/
      DATA PI    / 3.1415926535897932384626433832D+00/
      DATA CONST / 9.1893853320467274178032973641D-01/
      IF(Z.GT.5.75D 1)                                     GOTO  6666
      NN = Z
      IF (Z  -  DBLE(FLOAT(NN)))                 3,1,3
    1 IF (Z    .LE.    0.D 0)                    GOTO 6667
      DPGAMM = 1.D 0
      IF (Z    .LE.    2.D 0)                    RETURN
      Z1 = Z
    2 Z1 = Z1  -  1.D 0
      DPGAMM = DPGAMM * Z1
      IF (Z1  -  2.D 0)                          61,61,2
    3 IF (DABS(Z)    .LT.    1.D-29)             GOTO 60
      IF (Z    .LT.    0.D 0)                    GOTO 4
      X  = Z
      KK = 1
      GOTO 10
    4 X  = 1.D 0  -  Z
      KK = 2
   10 X1 = X
      IF (X    .GT.    19.D 0)                   GOTO 13
      D1 = X
   11 X1 = X1  +  1.D 0
      IF (X1    .GE.    19.D 0)                  GOTO 12
      D1 = D1 * X1
      GOTO 11
   12 S3 = -DLOG(D1)
      GOTO 14
   13 S3 = 0.D 0
   14 D1 = X1 * X1
      S1 = (X1  -  5.D-1) * DLOG(X1)  -  X1  +  CONST
      DO 20                  K=1,20
      S2 = S1  +  C(K)/X1
      IF (DABS(S2  -  S1)    .LT.    1.D-28)     GOTO 21
      X1 = X1 * D1
   20 S1 = S2
   21 S3 = S3  +  S2
      GOTO (50,22),    KK
   22 D2 = DABS(Z  -  NN)
      D1 = D2 * PI
      IF (D1    .LT.    1.D-15)                  GOTO 31
   30 X2 =  DLOG(PI/DSIN(D1))  -  S3
      GOTO 40
   31 X2 = -DLOG(D2)
   40 MM = DABS(Z)
      IF(X2      .GT.      1.74D2)                         GO TO 6666
      DPGAMM = DEXP(X2)
      IF (MM    .NE.    (MM/2) * 2)              RETURN
      DPGAMM = -DPGAMM
      RETURN
   50 IF(S3      .GT.      1.74D2)                         GO TO 6666
      DPGAMM = DEXP(S3)
      RETURN
 6666 PRINT *, 2000
      RETURN
 6667 PRINT *, 2001
      RETURN
   60 DPGAMM = 0.D 0
      IF(DABS(Z)   .LT.   1.D-77)   RETURN
      DPGAMM = 1.D 0/Z
   61 RETURN
 2000 FORMAT (/////, 2X, 32HDPGAMM ..... ARGUMENT TOO LARGE., /////)
 2001 FORMAT (/////, 2X, 32HDPGAMM ..... ARGUMENT IS A POLE., /////)
      END

c  gen_bhw104

      SUBROUTINE BOSTDQ(MODE,QQ,PP,R)
C     *******************************
C BOOST ALONG ARBITRARY AXIS (BY RONALD KLEISS).
C P BOOSTED INTO R  FROM ACTUAL FRAME TO REST FRAME OF Q
C FORTH (MODE = 1) OR BACK (MODE = -1).
C Q MUST BE A TIMELIKE, P MAY BE ARBITRARY.
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      PARAMETER ( NOUT =6 )
      DIMENSION QQ(*),PP(*),R(*)
      DIMENSION Q(4),P(4)

      DO 10 K=1,4
      P(K)=PP(K)
   10 Q(K)=QQ(K)
      AMQ =DSQRT(Q(4)**2-Q(1)**2-Q(2)**2-Q(3)**2)
      IF    (MODE.EQ.-1) THEN
         R(4) = (P(1)*Q(1)+P(2)*Q(2)+P(3)*Q(3)+P(4)*Q(4))/AMQ
         FAC  = (R(4)+P(4))/(Q(4)+AMQ)
      ELSEIF(MODE.EQ. 1) THEN
         R(4) =(-P(1)*Q(1)-P(2)*Q(2)-P(3)*Q(3)+P(4)*Q(4))/AMQ
         FAC  =-(R(4)+P(4))/(Q(4)+AMQ)
      ELSE
         WRITE(NOUT,*) ' ++++++++ WRONG MODE IN BOOST3 '
         STOP
      ENDIF
      R(1)=P(1)+FAC*Q(1)
      R(2)=P(2)+FAC*Q(2)
      R(3)=P(3)+FAC*Q(3)
      END

c  gen_bhw104

C BOOST ALONG X AXIS, EXE=EXP(ETA), ETA= HIPERBOLIC VELOCITY.
      SUBROUTINE BOSTD1(EXE,PVEC,QVEC)
C     ********************************
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION PVEC(4),QVEC(4),RVEC(4)

      DO 10 I=1,4
  10  RVEC(I)=PVEC(I)
      RPL=RVEC(4)+RVEC(1)
      RMI=RVEC(4)-RVEC(1)
      QPL=RPL*EXE
      QMI=RMI/EXE
      QVEC(2)=RVEC(2)
      QVEC(3)=RVEC(3)
      QVEC(1)=(QPL-QMI)/2
      QVEC(4)=(QPL+QMI)/2
      END

c  gen_bhw104

C BOOST ALONG Z AXIS, EXE=EXP(ETA), ETA= HIPERBOLIC VELOCITY.
      SUBROUTINE BXSTD3(EXE,PVEC,QVEC)
C     ********************************
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION PVEC(4),QVEC(4),RVEC(4)

      DO 10 I=1,4
  10  RVEC(I)=PVEC(I)
      RPL=RVEC(4)+RVEC(3)
      RMI=RVEC(4)-RVEC(3)
      QPL=RPL*EXE
      QMI=RMI/EXE
      QVEC(1)=RVEC(1)
      QVEC(2)=RVEC(2)
      QVEC(3)=(QPL-QMI)/2
      QVEC(4)=(QPL+QMI)/2
      END

c  gen_bhw104

      SUBROUTINE RXTOD2(PH1,PVEC,QVEC)
C     ********************************
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION PVEC(4),QVEC(4),RVEC(4)

      PHI=PH1
      CS=COS(PHI)
      SN=SIN(PHI)
      DO 10 I=1,4
  10  RVEC(I)=PVEC(I)
      QVEC(1)= CS*RVEC(1)+SN*RVEC(3)
      QVEC(2)=RVEC(2)
      QVEC(3)=-SN*RVEC(1)+CS*RVEC(3)
      QVEC(4)=RVEC(4)
      END

c  gen_bhw104

      SUBROUTINE RXTOD3(PH1,PVEC,QVEC)
C     ********************************
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DOUBLE PRECISION PVEC(4),QVEC(4),RVEC(4)

      PHI=PH1
      CS=COS(PHI)
      SN=SIN(PHI)
      DO 10 I=1,4
  10  RVEC(I)=PVEC(I)
      QVEC(1)= CS*RVEC(1)-SN*RVEC(2)
      QVEC(2)= SN*RVEC(1)+CS*RVEC(2)
      QVEC(3)=RVEC(3)
      QVEC(4)=RVEC(4)
      END

c  gen_bhw104

      FUNCTION ANGFIX(X,Y)
C     *******************
* CALCULATES ANGLE IN (0,2*PI) RANGE OUT OF X-Y
*     ***********************
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
      DATA PI /3.1415926535897932D0/

      IF(ABS(Y).LT.ABS(X)) THEN
        THE=ATAN(ABS(Y/X))
        IF(X.LE.0D0) THE=PI-THE
      ELSE
        THE=ACOS(X/SQRT(X**2+Y**2))
      ENDIF
      IF(Y.LT.0D0) THE=2D0*PI-THE
      ANGFIX=THE
      END

c  gen_bhw104

      SUBROUTINE sprogz(s,PROPG,PROPZ)
!---------------------------------------------------------------!
! This routine comes originally from ALIBABA (see below).       !
! Propagators factor in the s-channel.                          !
! Modified by: Wieslaw Placzek           Knoxville, Oct. 1995   !
! Last update: 09.02.1996     by: W.P.                          !
!---------------------------------------------------------------!
!WP   SUBROUTINE GZPROP(QSQR,PROPG,PROPZ,MIXING)
*     -----------------
* The gamma-Z propagators and their mixing, up to one loop corrections,
* but for the imaginary part of the Z propagator, which includes
* second order corrections.
* QSQR is input: the momentum transfer squared through the progagators.
* PROPG, PROPZ and MIXING are complex*16 output.
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 IMSIGG,IMSIGZ,IMZ2
      COMPLEX*16 Z1,Z2,PROPG,PROPZ
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHOPTION /IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
!WP
      SAVE  /BHBOSONS /, /BHOPTION /
      QSQR = s
      IF(IWEAK .EQ. 1) THEN
        Z1 = DCMPLX( SIGG (QSQR) , IMSIGG(QSQR) )
        Z2 = DCMPLX( SIGZ (QSQR) , IMSIGZ(QSQR) + IMZ2(QSQR) )
!WP     Z3 = DCMPLX( SIGGZ(QSQR) , IMSGGZ(QSQR) )
        PROPG = 1D0/( QSQR + Z1 )
        PROPZ = 1D0/( QSQR - RMZ**2 + Z2 )
!WP     MIXING= - Z3/( QSQR*(QSQR-RMZ**2+Z2) )
      ELSE
        PROPG  = 1D0/QSQR
!WP     IF(QSQR .GT. 0D0) THEN
          PROPZ  = 1D0/DCMPLX( QSQR-RMZ**2 , RMZ*ZWID )
!WP     ELSE
!WP       PROPZ  = 1D0/DCMPLX( QSQR-RMZ**2 , 0D0 )
!WP     ENDIF
!WP      MIXING = DCMPLX( 0D0 , 0D0 )
      ENDIF
      END

c  gen_bhw104

      SUBROUTINE tprogz(t,gprof,zprof)
*     ********************************
!---------------------------------------------------------------!
! This routine comes originally from ALIBABA (see below).       !
! Propagators factor in  t-channel (no imaginary parts!).       !
! Modified by: Wieslaw Placzek           Knoxville, Oct. 1995   !
! Last update: 09.02.1996     by: W.P.                          !
!---------------------------------------------------------------!
!WP   SUBROUTINE GZPROP(QSQR,PROPG,PROPZ,MIXING)
*     -----------------
* The gamma-Z propagators and their mixing, up to one loop corrections,
* but for the imaginary part of the Z propagator, which includes
* second order corrections.
* QSQR is input: the momentum transfer squared through the progagators.
* PROPG, PROPZ and MIXING are complex*16 output.
      IMPLICIT REAL*8(A-H,O-Z)
!WP   REAL*8 IMSIGG,IMSGGZ,IMSIGZ,IMZ2
!WP   COMPLEX*16 Z1,Z2,Z3, PROPG,PROPZ,MIXING
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHOPTION / IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
!WP
      SAVE  /BHBOSONS /, /BHOPTION /
      COMPLEX*16 HADRQQ
      IF(IWEAK .EQ. 1) THEN
!WP     Z1 = DCMPLX( SIGG (QSQR) , IMSIGG(QSQR) )
!WP     Z2 = DCMPLX( SIGZ (QSQR) , IMSIGZ(QSQR) + IMZ2(QSQR) )
!WP     Z3 = DCMPLX( SIGGZ(QSQR) , IMSGGZ(QSQR) )
!WP     PROPG = 1D0/( QSQR + Z1 )
!WP     PROPZ = 1D0/( QSQR - RMZ**2 + Z2 )
!WP     MIXING= - Z3/( QSQR*(QSQR-RMZ**2+Z2) )
!WP: No imaginary parts in t-channel
        hadcor = HADRQQ(t)
        gprof = 1/( t + SIGG(t) )/( 1 - hadcor - PHADPI(t) )
        zprof = 1/( t - RMZ**2 + SIGZ(t) )
      ELSE
!WP     PROPG  = 1D0/QSQR
!WP     IF(QSQR .GT. 0D0) THEN
!WP       PROPZ  = 1D0/DCMPLX( QSQR-RMZ**2 , RMZ*ZWID )
!WP     ELSE
!WP       PROPZ  = 1D0/DCMPLX( QSQR-RMZ**2 , 0D0 )
!WP     ENDIF
!WP     MIXING = DCMPLX( 0D0 , 0D0 )
!WP: No imaginary parts in t-channel
        gprof = 1/t
        zprof = 1/(t - RMZ**2)
      ENDIF
      END

c  gen_bhw104

      FUNCTION xmatvs(s,t,epsCMS)
*     ***************************
!---------------------------------------------------------------!
! This routine comes originally from ALIBABA (see below).       !
! Modified by: Wieslaw Placzek           Knoxville, Oct. 1995   !
! Last update: 25.09.1996     by: W.P.                          !
!---------------------------------------------------------------!
!WP   FUNCTION EEEEVS(COSTH)
*     ---------------
* Calculation of the non-log terms of the virtual and soft corrections
* on the Born Bhabha cross section. Included are the corrections due
* to final state and initial state photons and their interference,
* and hence also box diagrams. COSTH is input and is to be integrated
* over.
* W. Beenakker and S.C. van der Marck, April 1990.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( OFFSET = 1D-10 )
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
      COMMON/BHCONTRL / C1,C2,C3,C4,EP0,EM0,ACOLMX,SCM,BETALL,BETALF,
     +                 EPS,EPS2
      COMMON/BHOPTION / IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
      COMMON/BHSTAT / ISIGH,ISIGF,ITWOH,IZBR,IRNON,IEVS,IEEW
      REAL*8 MATRIX(1:6), RESEFF(1:4)
      COMPLEX*16 LABDAS,LABDAT,LABDFS,LABDFT,LE,LL,G,A, SPENCE,MZ2
      COMPLEX*16 GS,GT,ZS,ZT,MIX,GZS(-1:1,-1:1),GZT(-1:1,-1:1)
      COMPLEX*16 AGZS,VGZS,AGGS,VGGS,AGZT,VGZT,AGGT,VGGT,GDINT,HULP
      SAVE

* Statement functions for the box corrections
      G(SL,TL) = SL/2D0/(SL+TL)*LOG(TL/CMPLX(SL,OFFSET)) -
     +           SL*(SL+2D0*TL)/4D0/(SL+TL)**2*(
     +             LOG(TL/CMPLX(SL,OFFSET))**2 + PI*PI )
      A(SL,TL) = (SL-MZ2)/(SL+TL)*( LOG(TL/(SL-MZ2)) +
     +             MZ2/SL*LOG(1D0-SL/MZ2) + (SL+2D0*TL+MZ2)/(SL+TL)*(
     +               LOG(-TL/MZ2)*LOG((MZ2-SL)/(MZ2+TL)) +
     +               SPENCE(SL/MZ2) - SPENCE(-TL/MZ2) ) )
      IEVS=IEVS+1
!
!WP: COSTH from BHWIDE
      COSTH = 1 +2*t/s
!WP: Soft photon cut-off from BHWIDE
      EPS2  = epsCMS
!WP   S = SCM
      PPQP = .25D0*S*( 1D0 - COSTH )
      PPQM = .25D0*S*( 1D0 + COSTH )
      PPPM =  .5D0*S
!WP   T = - 2D0*PPQP
* Define propagators.
      E2   = EE**2
      QF2  = QF(1)*QF(IFERM)
      QF3  = QF(1)**2
!WP   CALL GZPROP(S ,GS ,ZS ,MIX)
!WP   CALL GZPROP(T ,GT ,ZT ,MIX)

      CALL FprogZ(S ,GS ,ZS ,MIX)

      CALL FprogZ(T ,GT ,ZT ,MIX)

      IF(ICHANN .EQ. 1) THEN
        ZT = (0D0,0D0)
        GT = (0D0,0D0)
      ELSEIF(ICHANN .EQ. 2) THEN
        ZS = (0D0,0D0)
        GS = (0D0,0D0)
      ENDIF
      I=IFERM
      DO 20 L1 = - 1 , 1 , 2
        DO 10 L2 = - 1 , 1 , 2
          GZS(L1,L2)=E2*(QF2*GS+(VF(1)-L1*AF(1))*(VF(I)-L2*AF(I))*ZS)
          GZT(L1,L2)=E2*(QF3*GT+(VF(1)-L1*AF(1))*(VF(1)-L2*AF(1))*ZT)
   10   CONTINUE
   20 CONTINUE
* Start calculating corrections
      SK = S
      U  = - S - T
      MZ2 = CMPLX( RMZ**2 , - RMZ*ZWID )
* The photonic vertex correction: initial state -------------------
      LE =   LOG( -CMPLX(S,OFFSET)/RMASS2(1) )
      LL = - LOG( -CMPLX(S,OFFSET)/SK )
      LABDAS= ALFA/2D0/PI*QF(1)**2*( 2D0*LL*( LE-1D0 ) + LE*(LE-1D0)
     +                           + 2D0*LE + 4D0*( PI**2/12D0 - 1D0 ) )
      LE =   LOG( -CMPLX(T,OFFSET)/RMASS2(1) )
      LL = - LOG( -CMPLX(T,OFFSET)/SK )
      LABDAT= ALFA/2D0/PI*QF(1)**2*( 2D0*LL*( LE-1D0 ) + LE*(LE-1D0)
     +                           + 2D0*LE + 4D0*( PI**2/12D0 - 1D0 ) )
* and final state (more precise: the other fermion current)
      LE =   LOG( -CMPLX(S,OFFSET)/RMASS2(IFERM) )
      LL = - LOG( -CMPLX(S,OFFSET)/SK )
      LABDFS= ALFA/2D0/PI*QF(IFERM)**2*( 2D0*LL*(LE-1D0) + LE*(LE-1D0)
     +                           + 2D0*LE + 4D0*( PI**2/12D0 - 1D0 ) )
      LE =   LOG( -CMPLX(T,OFFSET)/RMASS2(IFERM) )
      LL = - LOG( -CMPLX(T,OFFSET)/SK )
      LABDFT= ALFA/2D0/PI*QF(IFERM)**2*( 2D0*LL*(LE-1D0) + LE*(LE-1D0)
     +                           + 2D0*LE + 4D0*( PI**2/12D0 - 1D0 ) )
* Subtract the leading log terms, to end up with non-log terms only
      BETAL1 = BETALL + 2D0*ALFA/PI
      BETAF1 = BETALF + 2D0*ALFA/PI*QF(IFERM)**2
!WP   LABDAS = LABDAS + LABDFS - .75D0*( BETAL1 + BETALF )
!WP   LABDAT = LABDAT + LABDFT - .75D0*( BETAL1 + BETALF )
      LABDAS = LABDAS + LABDFS
      LABDAT = LABDAT + LABDFT
* The soft photon corrections ----------------------------
      XF    = - RMASS2(IFERM)/S
      XFLOG = LOG(-XF)
      XFLI2 = PI*PI/6D0
      BE    = LOG(S/RMASS2(1)) - 1D0
      BFIN  = BE
      BINT  = 0D0
      IF(ABS(ABS(COSTH)-1D0).GT.0D0) BINT=2D0*LOG(T/U)
      IF (IFERM .GT. 1) BFIN = LOG(S/RMASS2(IFERM)) - 1D0
      IF (IFERM .EQ. 0) BFIN = 0D0
      GIR = - ALFA/PI*LOG(SK/S)*( QF(1)**2*BE + QF(IFERM)**2*BFIN
     +                          + QF(1)*QF(IFERM)*BINT )
      GD = ALFA/PI*2D0*LOG(EPS2)*( QF(1)**2*BE + QF(IFERM)**2*BFIN
     +         + QF(1)*QF(IFERM)*BINT )
      GFIN =-ALFA/PI*( QF(1)**2*( PI**2/3D0 - .5D0 + .5D0*BE**2 )
     +        + QF(IFERM)**2*( XFLOG + 2D0*XFLI2 + .5D0*XFLOG**2 ) )
      IF(ABS(ABS(COSTH)-1D0).GT.0D0)
     +  GFIN = GFIN - ALFA/PI*( + 2D0*QF(1)*QF(IFERM)*(
     +              + DILOG(1D0+S/T) - DILOG(1D0+S/U) ) )
      DELSOF = GIR + GD + GFIN
* Subtract the leading log terms, to end ...
!WP   DELSOF = DELSOF - LOG(EPS2)*( BETALL + BETALF )
      DELSOF = DELSOF
* Resonance effects when soft photons are not all that soft ...
      HULP = (S-MZ2)/(S*(1D0-EPS)-MZ2)
      GDINT = ALFA/PI*2D0*( QF(1)**2*BE*LOG(HULP) +
     +        .5D0*QF(1)*QF(IFERM)*BINT*LOG(HULP) )
      GDRES = ALFA/PI*2D0*( QF(1)**2*BE*LOG(ABS(HULP)) +
     +             QF(1)*QF(IFERM)*BINT*LOG(ABS(HULP)) +
     +             QF(1)**2*BE*(S-RMZ**2)/RMZ/ZWID*(
     +          ATAN((RMZ**2-S*(1D0-EPS))/(RMZ*ZWID)) -
     +          ATAN((RMZ**2-S          )/(RMZ*ZWID)) )  )
      K = 0
      E4 = E2 * E2
      DO 40 L1 = - 1 , 1 , 2
        DO 30 LF = - 1 , 1 , 2
          K = K + 1
          RESEFF(K) = E4*
     +              DBLE((VF(1)-L1*AF(1))*(VF(IFERM)-LF*AF(IFERM))*ZS*
     +      CONJG((VF(1)-L1*AF(1))*(VF(IFERM)-LF*AF(IFERM))*ZS))*GDRES
     +           + 2D0*DBLE( QF(1)*QF(IFERM)*GS*CONJG(
     +            (VF(1)-L1*AF(1))*(VF(IFERM)-LF*AF(IFERM))*ZS))*GDINT
   30   CONTINUE
   40 CONTINUE
      RESEFF(1) = RESEFF(1) + E4*
     +           2D0*DBLE( (QF(1)*QF(1)*GT+(VF(1)+AF(1))**2*ZT)*
     +           CONJG( (VF(1)+AF(1))*(VF(1)+AF(1))*ZS ) )*GDINT
      RESEFF(4) = RESEFF(4) + E4*
     +           2D0*DBLE( (QF(1)*QF(1)*GT+(VF(1)-AF(1))**2*ZT)*
     +           CONJG( (VF(1)-AF(1))*(VF(1)-AF(1))*ZS ) )*GDINT
      ALPI = ALFA/PI * EE**2
      IF ( ICHANN .EQ. 1 ) THEN
        IF( IFINAL+IORDER .EQ. 0 ) THEN
          LABDAS = (0D0,0D0)
          DELSOF = 0D0
          ALPI   = 0D0
        ELSEIF ( IFINAL.EQ.0 ) THEN
          LABDAT = (0D0,0D0)
          LABDAS = LABDAS - ( LABDFS - .75D0*BETAF1 )
          DELSOF =-ALFA/PI*QF(1)**2*( PI**2/3D0 -.5D0 +.5D0*BE**2 )
          ALPI   = 0D0
        ELSEIF ( IORDER.EQ.0 .AND. ICHANN.EQ.1 ) THEN
          LABDAT = (0D0,0D0)
          LABDAS = LABDFS - .75D0*BETAF1
          DELSOF = - ALFA/PI*QF(IFERM)**2*
     +                  (XFLOG+2D0*XFLI2+.5D0*XFLOG**2)
          ALPI   = 0D0
        ENDIF
      ENDIF
*
* And finally the box corrections ------------------------
      AGGS = ALPI*( G(S,T) + G(S,U) )
      VGGS = ALPI*( G(S,T) - G(S,U) + 2D0*LOG(SK/CMPLX(-S,-OFFSET))*
     +                                    LOG(T/U) )
      AGZS = ALPI*( A(S,T) + A(S,U) )
      VGZS = ALPI*( A(S,T) - A(S,U) + 2D0*SPENCE(1D0+MZ2/T) -
     +                                2D0*SPENCE(1D0+MZ2/U) +
     +                        4D0*LOG(SQRT(MZ2*SK)/(MZ2-S))*LOG(T/U) )
      AGGT = ALPI*( G(T,S) + G(T,U) )
      VGGT = ALPI*( G(T,S) - G(T,U) + 2D0*LOG(SK/CMPLX(-T,-OFFSET))*
     +                                    LOG(CMPLX(S,OFFSET)/U) )
      AGZT = ALPI*( A(T,S) + A(T,U) )
      VGZT = ALPI*( A(T,S) - A(T,U) + 2D0*SPENCE(1D0+MZ2/S) -
     +                                2D0*SPENCE(1D0+MZ2/U) +
     +          4D0*LOG(SQRT(MZ2*SK)/(MZ2-T))*LOG(CMPLX(S,OFFSET)/U) )
*
* Combine the corrections with right helicity combinations with the
* different matrix element structures.
* The six helicity combinations are (p+ p- q+ q-):
* + + + +, - - - -, + + - -, - - + +, + - + -, - + - +
      MATRIX(1) = 16D0*PPQM**2*( (GZS( 1, 1)+GZT( 1, 1))*
     1                    DCONJG( GZS( 1, 1)*(LABDAS+DELSOF) +
     2                            GZT( 1, 1)*(LABDAT+DELSOF) +
     3             QF(1)**2*QF(IFERM)**2*GS*( VGGS + AGGS ) +
     4                 QF(1)**2*QF(1)**2*GT*( VGGT + AGGT ) +
     5     QF(1)*QF(IFERM)*(VF(1)-AF(1))*(VF(IFERM)-AF(IFERM))*
     6                                   ZS*( VGZS + AGZS ) +
     7     QF(1)*QF(1)*(VF(1)-AF(1))*(VF(1)-AF(1))*
     8                                   ZT*( VGZT + AGZT ) )
     +     + RESEFF(4) )
      MATRIX(2) = 16D0*PPQM**2*( (GZS(-1,-1)+GZT(-1,-1))*
     1                    DCONJG( GZS(-1,-1)*(LABDAS+DELSOF) +
     2                            GZT(-1,-1)*(LABDAT+DELSOF) +
     3             QF(1)**2*QF(IFERM)**2*GS*( VGGS + AGGS ) +
     4                 QF(1)**2*QF(1)**2*GT*( VGGT + AGGT ) +
     5     QF(1)*QF(IFERM)*(VF(1)+AF(1))*(VF(IFERM)+AF(IFERM))*
     6                                   ZS*( VGZS + AGZS ) +
     7     QF(1)*QF(1)*(VF(1)+AF(1))*(VF(1)+AF(1))*
     8                                   ZT*( VGZT + AGZT ) )
     +     + RESEFF(1) )
      MATRIX(3) = 16D0*PPQP**2*( GZS( 1,-1)*
     1                   DCONJG( GZS( 1,-1)*(LABDAS+DELSOF) +
     2              QF(1)**2*QF(IFERM)**2*GS*( VGGS - AGGS ) +
     3     QF(1)*QF(IFERM)*(VF(1)-AF(1))*(VF(IFERM)+AF(IFERM))*
     4                                    ZS*( VGZS - AGZS ) )
     +     + RESEFF(3) )
      MATRIX(4) = 16D0*PPQP**2*( GZS(-1, 1)*
     1                   DCONJG( GZS(-1, 1)*(LABDAS+DELSOF) +
     2              QF(1)**2*QF(IFERM)**2*GS*( VGGS - AGGS ) +
     3     QF(1)*QF(IFERM)*(VF(1)+AF(1))*(VF(IFERM)-AF(IFERM))*
     4                                    ZS*( VGZS - AGZS ) )
     +     + RESEFF(2) )
      MATRIX(5) = 16D0*PPPM**2* GZT( 1,-1)*
     1                  DCONJG( GZT( 1,-1)*(LABDAT+DELSOF) +
     2            QF(1)**2*QF(IFERM)**2*GT*( VGGT - AGGT ) +
     3     QF(1)*QF(1)*(VF(1)-AF(1))*(VF(1)+AF(1))*
     4                                  ZT*( VGZT - AGZT ) )
      MATRIX(6) = 16D0*PPPM**2* GZT(-1, 1)*
     1                  DCONJG( GZT(-1, 1)*(LABDAT+DELSOF) +
     2             QF(1)**2*QF(IFERM)**2*GT*( VGGT - AGGT ) +
     3     QF(1)*QF(1)*(VF(1)+AF(1))*(VF(1)-AF(1))*
     4                                   ZT*( VGZT - AGZT ) )
*
      SUM = MATRIX(1) + MATRIX(2) + MATRIX(3) +
     +      MATRIX(4) + MATRIX(5) + MATRIX(6)
* conversion to picobarn, 2pi from azimuthal angle, 1/8/(2pi)**2 from
* phase space, 1/(2s) from flux factor, 1/4 from spin averaging.
!WP   EEEEVS = HBARC2/8D0/2D0/PI/2D0/S/4D0 * SUM
      xmatvs = SUM/4
      END

c  gen_bhw104

      FUNCTION xmatwc(s,t)
*     ********************
!---------------------------------------------------------------!
! This routine comes originally from ALIBABA (see below).       !
! Modified by: Wieslaw Placzek           Knoxville, Oct. 1995   !
! Last update: 25.09.1996     by: W.P.                          !
!---------------------------------------------------------------!
!WP   FUNCTION EEEEW(COSTH)
*     ---------------
* The Born e+e- --> e+e- matrix element squared, including both gamma
* and Z in both s and t channel, and including WEAK corrections.
* Summing/averaging over spins is performed.
* COSTH is input and is to integrated over.
* W. Beenakker and S.C. van der Marck, April 1990.
* Heavy boxes (ZZ and WW) added: July 1990.
      IMPLICIT REAL*8(A-H,O-Z)
      PARAMETER( NRMASS = 9 )
      COMMON/BHMASSES / RMASS(0:NRMASS), RMASS2(0:NRMASS),
     +            VF(0:NRMASS),AF(0:NRMASS),QF(0:NRMASS)
      COMMON/BHFORMFA /FZV(0:NRMASS),FZA(0:NRMASS),
     +                FGV(0:NRMASS),FGA(0:NRMASS)
      COMPLEX*16 FZV,FZA,FGV,FGA
      COMMON/BHADHOC  / ALFA, PI, FACQCB, FACQCD,FACQED,HBARC2,EE
      COMMON/BHCONTRL / C1,C2,C3,C4,EP0,EM0,ACOLMX,SCM,BETALL,BETALF,
     +                 EPS,EPS2
      COMMON/BHOPTION / IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
      COMMON/ BHSTAT / ISIGH,ISIGF,ITWOH,IZBR,IRNON,IEVS,IEEW
      REAL*8 MATRIX(1:6),ZCOP(-1:1,-1:1)
      COMPLEX*16 GS,GT,ZS,ZT,MIXS,MIXT,GZS(-1:1,-1:1), GZT(-1:1,-1:1)
      COMPLEX*16 VZZS,AZZS,VWWS,AWWS,VZZT,AZZT,VWWT,AWWT
      SAVE

      IEEW=IEEW+1
!
!WP: COSTH from BHWIDE
      COSTH = 1 +2*t/s
!WP   S = SCM
      PPQP = .25D0*S*( 1D0 - COSTH )
      PPQM = .25D0*S*( 1D0 + COSTH )
      PPPM =  .5D0*S
!WP   T    = - 2D0*PPQP
* Define propagators, and include vertex form factors.
      E2   = 4D0*PI*ALFA
!WP   CALL GZPROP(S,GS,ZS,MIXS)
      CALL FprogZ(S,GS,ZS,MIXS)
      CALL FORMFS(S,IFERM)
      IF(ICHANN .EQ. 2) THEN
        GS = (0D0,0D0)
        ZS = (0D0,0D0)
        MIXS=(0D0,0D0)
      ENDIF
      I=IFERM
      DO 20 L1 = - 1 , 1 , 2
        DO 10 L2 = - 1 , 1 , 2
          GZS(L1,L2)=E2*( ( -QF(1)-FGV(1)-L1*(      -FGA(1) ) )*
     +                    ( -QF(I)-FGV(I)-L2*(      -FGA(I) ) )*GS +
     +                    (  VF(1)+FZV(1)-L1*( AF(1)+FZA(1) ) )*
     +                    (  VF(I)+FZV(I)-L2*( AF(I)+FZA(I) ) )*ZS -
     +      ( QF(1)*(VF(I)-L2*AF(I)) + QF(I)*(VF(1)-L1*AF(1)) )*MIXS )
          ZCOP(L1,L2) = ((VF(1)-L1*AF(1))*(VF(IFERM)-L2*AF(IFERM)))**2
   10   CONTINUE
   20 CONTINUE
*     Heavy boxes !
      IF(ICHANN .EQ. 2) THEN
        VZZS = (0D0,0D0)
        AZZS = (0D0,0D0)
        VWWS = (0D0,0D0)
        AWWS = (0D0,0D0)
      ELSE
        CALL HEAVYB(S,T,VZZS,AZZS,VWWS,AWWS)
      ENDIF
*     Now everything for the t channel
!WP   CALL GZPROP(T,GT ,ZT ,MIXT)
      CALL FprogZ(T,GT ,ZT ,MIXT)
      CALL FORMFS(T,1)
*     Incorporate the Burkhardt fit for the light quark loops.
!WP   GT = GT/( 1D0 - HADRQQ(T) - PHADPI(T) )
      IF(ICHANN .EQ. 1) THEN
        GT = (0D0,0D0)
        ZT = (0D0,0D0)
        MIXT=(0D0,0D0)
      ENDIF
      DO 40 L1 = - 1 , 1 , 2
        DO 30 L2 = - 1 , 1 , 2
          GZT(L1,L2)=E2*(
     +         ( -QF(1)-FGV(1)-L1*(      -FGA(1) ) )*
     +         ( -QF(1)-FGV(1)-L2*(      -FGA(1) ) )*GT +
     +         (  VF(1)+FZV(1)-L1*( AF(1)+FZA(1) ) )*
     +         (  VF(1)+FZV(1)-L2*( AF(1)+FZA(1) ) )*ZT -
     +       (QF(1)*(VF(1)-L2*AF(1))+QF(1)*(VF(1)-L1*AF(1)))*MIXT )
   30   CONTINUE
   40 CONTINUE
*     Heavy boxes !
      IF(ICHANN .EQ. 1) THEN
        VZZT = (0D0,0D0)
        AZZT = (0D0,0D0)
        VWWT = (0D0,0D0)
        AWWT = (0D0,0D0)
      ELSE
        CALL HEAVYB(T,S,VZZT,AZZT,VWWT,AWWT)
      ENDIF
* There are 6 different helicity combinations (see EEEEVS).
      IF ( ICHANN .NE. 3 ) THEN
        MATRIX(1) = 16D0*PPQM**2*(GZS( 1, 1)+GZT( 1, 1))*
     +                      CONJG(GZS( 1, 1)+GZT( 1, 1))
        MATRIX(2) = 16D0*PPQM**2*(GZS(-1,-1)+GZT(-1,-1))*
     +                      CONJG(GZS(-1,-1)+GZT(-1,-1))
        MATRIX(3) = 16D0*PPQP**2* GZS( 1,-1)*CONJG(GZS( 1,-1))
        MATRIX(4) = 16D0*PPQP**2* GZS(-1, 1)*CONJG(GZS(-1, 1))
        MATRIX(5) = 16D0*PPPM**2* GZT( 1,-1)*CONJG(GZT( 1,-1))
        MATRIX(6) = 16D0*PPPM**2* GZT(-1, 1)*CONJG(GZT(-1, 1))
*       Heavy boxes (factor 2 from 2*M0*M1)
        MATRIX(1) = MATRIX(1)+32D0*PPQM**2*(GZS( 1, 1)+GZT( 1, 1))*
     +                        CONJG((VZZS+AZZS+VZZT+AZZT)*ZCOP( 1, 1))
        MATRIX(2) = MATRIX(2)+32D0*PPQM**2*(GZS(-1,-1)+GZT(-1,-1))*
     +    CONJG((VZZS+AZZS+VZZT+AZZT)*ZCOP(-1,-1)+VWWS+AWWS+VWWT+AWWT)
        MATRIX(3) = MATRIX(3) +     32D0*PPQP**2*GZS( 1,-1)*
     +                         CONJG(VZZS-AZZS)*ZCOP( 1,-1)
        MATRIX(4) = MATRIX(4) +     32D0*PPQP**2*GZS(-1, 1)*
     +                         CONJG(VZZS-AZZS)*ZCOP(-1, 1)
        MATRIX(5) = MATRIX(5) +     32D0*PPPM**2*GZT( 1,-1)*
     +                         CONJG(VZZT-AZZT)*ZCOP( 1,-1)
        MATRIX(6) = MATRIX(6) +     32D0*PPPM**2*GZT(-1, 1)*
     +                         CONJG(VZZT-AZZT)*ZCOP(-1, 1)
      ELSE
        MATRIX(1) = 16D0*PPQM**2*2D0*GZS( 1, 1)*CONJG(GZT( 1, 1))
        MATRIX(2) = 16D0*PPQM**2*2D0*GZS(-1,-1)*CONJG(GZT(-1,-1))
*       Heavy boxes
        MATRIX(1) = MATRIX(1)+32D0*PPQM**2*GZS( 1, 1)*
     +                             CONJG((VZZT+AZZT)*ZCOP( 1, 1))
     +                       +32D0*PPQM**2*GZT( 1, 1)*
     +                             CONJG((VZZS+AZZS)*ZCOP( 1, 1))
        MATRIX(2) = MATRIX(2)+32D0*PPQM**2*GZS(-1,-1)*
     +                  CONJG((VZZT+AZZT)*ZCOP(-1,-1)+VWWT+AWWT)
     +                       +32D0*PPQM**2*GZT(-1,-1)*
     +                  CONJG((VZZS+AZZS)*ZCOP(-1,-1)+VWWS+AWWS)
        MATRIX(3) = 0D0
        MATRIX(4) = 0D0
        MATRIX(5) = 0D0
        MATRIX(6) = 0D0
      ENDIF
      SUM = MATRIX(1) + MATRIX(2) + MATRIX(3) +
     +      MATRIX(4) + MATRIX(5) + MATRIX(6)
!WP   EEEEW = HBARC2/8D0/2D0/PI/2D0/S/4D0 * SUM
      xmatwc = SUM/4
      END

c  gen_bhw104

      SUBROUTINE FprogZ(QSQR,PROPG,PROPZ,MIXING)
!---------------------------------------------------------------!
! This routine comes originally from ALIBABA (see below).       !
! Gamma and Z propagators and their mixing.                     !
! New vacuum polarization added!                                !
! Modified by: Wieslaw Placzek           Knoxville, Sept. 1996  !
! Last update: 25.09.1996     by: W.P.                          !
!---------------------------------------------------------------!
!WP   SUBROUTINE GZPROP(QSQR,PROPG,PROPZ,MIXING)
*     -----------------
* The gamma-Z propagators and their mixing, up to one loop corrections,
* but for the imaginary part of the Z propagator, which includes
* second order corrections.
* QSQR is input: the momentum transfer squared through the progagators.
* PROPG, PROPZ and MIXING are complex*16 output.
      IMPLICIT REAL*8(A-H,O-Z)
      REAL*8 IMSIGG,IMSGGZ,IMSIGZ,IMZ2
      COMPLEX*16 Z1,Z2,Z3, PROPG,PROPZ,MIXING
      COMMON/BHBOSONS / RMZ,RMW,RMH,RMT,SIN2TH,ZWID
      COMMON/BHOPTION / IWEAK,ICHANN,IOUT,IORDER,IFINAL,NONLOG,IFERM
!WP
      COMMON / BHPAR3 / KEYRAD,KEYOPT
      COMMON / BHPARZ / AMAZ,GAMMZ,SINW2,GV,GA
      SAVE  /BHBOSONS /, /BHOPTION /, / BHPAR3 /, / BHPARZ /
!
      KeyPia = MOD(KeyRad,10)
! Vacuum polarization

      CALL BH_VACPOL(KeyPia,QSQR,SINW2,RePiq,dRePiq)

      IF(IWEAK .EQ. 1) THEN
!WP        Z1 = DCMPLX( SIGG (QSQR) , IMSIGG(QSQR) )
        Z1 = DCMPLX( QSQR*RePiq , IMSIGG(QSQR) )
        Z2 = DCMPLX( SIGZ (QSQR) , IMSIGZ(QSQR) + IMZ2(QSQR) )
        Z3 = DCMPLX( SIGGZ(QSQR) , IMSGGZ(QSQR) )
        PROPG = 1D0/( QSQR + Z1 )
        PROPZ = 1D0/( QSQR - RMZ**2 + Z2 )
        MIXING= - Z3/( QSQR*(QSQR-RMZ**2+Z2) )
      ELSE
!WP        PROPG  = 1D0/QSQR
        PROPG  = 1D0/QSQR/(1+RePiq)
        IF(QSQR .GT. 0D0) THEN
          PROPZ  = 1D0/DCMPLX( QSQR-RMZ**2 , RMZ*ZWID ) /(1+RePiq)
        ELSE
          PROPZ  = 1D0/DCMPLX( QSQR-RMZ**2 , 0D0 ) /(1+RePiq)
        ENDIF
        MIXING = DCMPLX( 0D0 , 0D0 )
      ENDIF
      END

c  gen_bhw104

      FUNCTION dsigbo(tran)
*     *********************
! Differential Born cross section dsigma/dt in pb.
      IMPLICIT REAL*8 (a-h,o-z)
      PARAMETER( pi = 3.1415926535897932d0, alfinv=137.0359895D0)
      PARAMETER( alfpi=  1/pi/alfinv, alfa= 1d0/alfinv)
      PARAMETER( Gnanob=389.385D3 )
      COMMON / BHPAR2 / CMSENE,AMEL
      SAVE   / BHPAR2 /
!
      s = CMSENE**2
      t = -tran
      u = 4*AMEL**2 -s -t
      dsig0 = xmate0(s,t,u)/(4*pi*alfa)**2
      dsigbo = Gnanob*1d3 *pi*alfa**2/s**2 *dsig0
      END

c  gen_bhw104

      SUBROUTINE VARRAN(DRVEC,LENGT)
c******************************************************************
c
c  Switchable random number generator to GEANT one (V.A.T.)
c  Translation to double precision
c
c******************************************************************
      COMMON /BHRANPAR / KEYRND
      save   /BHRANPAR /
      DOUBLE PRECISION DRVEC(*)
      DIMENSION RVEC(1000)
c
      IF(LENGT.LT.1.OR.LENGT.GT.1000) GOTO 901
   10 CONTINUE
c
      DO I=1,LENGT
c
        RVEC(I)=RLU(0)           ! Corrected by V.A.T.
c
      END DO
c
c  Random numbers 0 and 1 not accepted
c
      DO 30 I=1,LENGT
        IF(RVEC(I).LE.0E0.OR.RVEC(I).GE.1E0) THEN
          WRITE(6,*) ' +++++ VARRAN: RVEC=',RVEC(I)
          GOTO 10
        ENDIF
        DRVEC(I)=RVEC(I)
   30 CONTINUE
c
      RETURN
  901 WRITE(6,*) ' +++++ STOP IN VARRAN: LENGT=',LENGT
      STOP
      END












