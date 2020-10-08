       SUBROUTINE GEN_GGMMG(EBEAM,ICRS,K0PHOT,WMIN,EWEMAX,ITAU)
c----------------------------------------------------------------------
c    Monte Carlo generator of Berends for the processes :
c
c      e- e+ -> e- e+ + mu- mu+ + (photon)
c  or  e- e+ -> e- e+ + tau- tau+ + (photon)
c
c    Input parameters:
c
c    EBEAM  - beam energy(GeV)
c    ICRS   - # unweighted events for cr.sec. estimat. (if=0 -generator)
c    K0PHOT - min. hard photon energy
c    WMIN   - min. inv mass of mu+mu- pair
c    EWEMAX - estimated majoranta (max.weight)
c    ITAU   - 0/1 : two-photon production mu+ mu- / tau+ tau-
c
c*********************************************************************
c*                                                                   *
c*    Authors : F.A. Berends, P.H. Daverveldt, R. Kleiss             *
c*              University of Leiden                                 *
c*              Instituut-Loretz voor theoretische natuurkunde       *
c*              Nieuwsteeg 18                                        *
c*              2311 SB Leiden                                       *
c*              The Netherlands                                      *
c*                                                                   *
c*    Problems : contact P.H. Daverveldt                             *
c*               tel 011 31 71 148333 extension 2724                 *
c*                                                                   *
c*    Installation date:                                             *
c*    Last update     : 21 August 1984                               *
c*                                                                   *
c*********************************************************************
c
c  For a detailed description of this MC program we refer to the
c  Leiden preprint (1984):
c  " Radiative corrections to the process e e -> e e mu mu".
c  (Submitted to Nucl. Phys.)
c  Computational details will be published elsewhere
c
c  This program runs in double precision Fortran H-EXT.
c
c  Only the radiative corrections on the external e- and e+
c  lines of the two multiperipheral Feinman diagrams are taken into
c  account
c
c Convention:  PV3 = four-momentum scattered electron
c              PV5 = four-momentum scattered positron
c              PV6 = four-momentum produced muon
c              PV7 = four-momentum produced anti-muon
c              KV  = four-momentum bremsstrahlung photon
c
c Incoming electron beam goes in the positive Z direction
c
c PV3(1) = X component of four-momentum
c PV3(2) = Y component of four-momentum
c PV3(3) = Z component of four-momentum
c PV3(4) = energy of four-momentum.
c
c When no photon is generated ( i.e. soft event)
c
c KV(4) equals (0,0,0,0)
c
c This MCprogram first decides whether a soft or a hard photon
c will be generated. The probability to generate soft or hard
c photons depends on the approximate cross sections for soft resp.
c hard bremsstrahlung.
c
c Soft photons are defined as follows :    EG  <   KS    or
c                                         MPK  <   (L+ME)**2.
c Soft photons are not generated.
c Hard photons are defined as follows :    EG  >   KS    and
c                                         MPK  >   (L+ME)**2.
c  EG  = photon energy
c  MPK = (KV + PV3)**2
c  KS  = input parameter which must be smaller or equal to K0.
c  L determines the boundary value of MPK and is calculated from the
c  input parameter K0.
c  ME  = electron mass.
c
c The program is devided into two parts.
c
c The first part generates hard bremsstrahlung.
c Only radiation from the electron line is calculated.
c The contribution from the positron line is taken into
c account by multiplying the correction by 2.
c
c In the second part the soft bremsstrahlung is treated.
c This section includes the vertex correction and the
c vacuum polarization for electron, muon, tau and quark
c (hadrons) loops.
c Again the contribution from the positron line gives
c a factor 2 in the final expression for the soft cross
c section.
c
c     INPUT PARAMETERS :
c
c       E       = Beam energy (GeV)
c       WM      = Min. value invariant mass**2 mu+ mu- pair
c       K0      = Max energy soft photons
c       KS      = Min energy hard photons
c       EWE     = Estimated maximum weight
c       IN      = Requested number of weighted events
c
c     OUTPUT :
c
c       COMMON /LPLOT/ contains variables which must be put
c                      into histograms
c       COMMON /VEC/   containes 4momenta of generated event
c       COMMON /WEIGHT/ containes weight and IWE
c                       IWE = 1  : event is accepted
c                       IWE = 0  : event is rejected
c
      IMPLICIT REAL*8(A-H,K-Z)
      COMMON /GGMMGVEC/     PV3(4),PV5(4),PV6(4),PV7(4),KV(4)
      COMMON /GGMMGWEIGHT/  WE
      COMMON /GGMMGMCLOG/   HFLAG
      COMMON /GGHPRT/ ITPARTE,PPARTE(4,20),IPARTE(20)
c-------------------
c      COMMON /INPUT/  E,WM,K0,KS,EWE
      COMMON /GGMMGEXTS/   SWES,SWESK,MWES,SIG1S
      COMMON /GGMMGEXTH/   SWEH,SWEHK,MWEH,SIG1H
      COMMON /GGMMGEXTRA/  IFAILS,IFAILH,IK0S,IK0H,IEVES,IEVEH,IUNDFS,
     +                     IUNDFH
      COMMON /GGMMGMCCOUN/ IACCS,IACCH
c      COMMON /LPLOT/  WI
c------------------
      LOGICAL HFLAG
      REAL *4 EBEAM,K0PHOT,PPARTE,WMIN,EWEMAX
      SAVE ICALL,IUNWEI,IPRCRS
c
      DATA ICALL  /0/
      DATA IUNWEI /0/  !  counter of unweighted events
      DATA IPRCRS /0/  !  flag of cross section print
c
      ICALL=ICALL+1
c
      E=EBEAM
      K0=K0PHOT
c
c  Minimum invariant mass squared of produced pair
c
      WM=4.D0*0.105658387D0*0.105658387D0    ! WM=(2 muon mass)^2
      IF(ITAU.EQ.1) WM=4.D0*1.777D0*1.777D0  ! WM=(2 tau mass)^2
c
      IF(WMIN**2.LT.WM) THEN 
        PRINT *,' GEN_GGMMG: WMIN was changed to ',DSQRT(WM)
      ELSE
        WM=WMIN**2
      END IF 
c
      IF(WMIN.GE.2*(E-0.000511)) THEN
        PRINT *,' GEN_GGMMG: wrong WMIN'
        STOP
      END IF  
c
      IF(ICALL.EQ.1) THEN
        IF(ITAU.EQ.0) PRINT 102,EBEAM,ICRS,K0PHOT,DSQRT(WM),EWEMAX
        IF(ITAU.EQ.1) PRINT 103,EBEAM,ICRS,K0PHOT,DSQRT(WM),EWEMAX
      END IF
c........
c
c   Notice that estimated maximum weight (EWE) should not be
c   chosen very much larger then the actual maximum weight (MWE).
c   Otherwise the efficiency of your program will be reduced
c   considerably. Therefore it is adviced to run first a fast test
c   job to get an accurate estimate of the maximum weight.
c
c  Estimated maximum weight
c      EWE=1.25D0
       EWE=EWEMAX
c........
c  Maximum energy of soft photons
c      K0=E*0.01D0
c  Minimum energy of hard photons
      KS=K0
c
1     CALL GG_MMG1(E,WM,K0,KS,EWE,IDUMP,ITAU)
c
      IF(ICRS.EQ.0.OR.IPRCRS.EQ.1) GOTO 3
c 
      IF (HFLAG) THEN
      SWEH=SWEH+WE          ! for cross section calcul. for 'hard' ph. 
      SWEHK=SWEHK+WE*WE
      IF (MWEH.LT.WE) MWEH=WE
      ELSE
      SWES=SWES+WE          ! for cross section calcul. for 'soft' ph.
      SWESK=SWESK+WE*WE
      IF (MWES.LT.WE) MWES=WE
      END IF      
c
3     IF(WE.LT.EWEMAX*RNF100(0)) GOTO 1
c
c   Event is accepted
c
c   Generated particles now in /GGPRT/ ITPARTE,PPARTE(4,20),IPARTE(20):
c
c      ITPARTE - number of generated particles in event (here 4)
c      PPARTE(1-3,I) - momentum of I-th particle, GeV/c
c      PPARTE(4,I)   - its energy, GeV
c      IPARTE(I)     - type of I-th particle
c
      IUNWEI=IUNWEI+1             ! counter of unweighted events
c
      IF(ICRS.EQ.0.OR.IPRCRS.EQ.1) GOTO 2
c
      IF(HFLAG) THEN  ! for cr.sec. calculation
      IACCH=IACCH+1
      ELSE
      IACCS=IACCS+1
      END IF
c
      IF(IUNWEI.EQ.ICRS) THEN
c
      CALL FINIS1(EWE)
c
      IPRCRS=1
      GOTO 1      
      END IF
c
      GOTO 1
c
2     ITPARTE=4
c
      DO I=1,4
      PPARTE(I,1)=PV3(I)      
      PPARTE(I,2)=PV5(I)
      PPARTE(I,3)=PV6(I)
      PPARTE(I,4)=PV7(I)
      END DO
c 
      IPARTE(1)=3
      IPARTE(2)=2
      IPARTE(3)=5
      IPARTE(4)=6
c
      IF (HFLAG) GOTO 1001   ! was generated rad. photon?
      GOTO 1002
c
1001  ITPARTE=5
      IACCH=IACCH+1
c
      DO I=1,4
      PPARTE(I,5)=KV(I)
      END DO
c
      IPARTE(5)=1
c
1002  IACCS=IACCS+1
c
100   FORMAT(1x,I5)
101   FORMAT(1x,4(1pe12.3))
102   FORMAT(//,5x,'Generator e+e- -> e+e- mu+ mu- (gamma) of', 
     +' F.A.Berends e.a.',/,5x,58(1H-),//,
     + 10x,'Beam energy = ',F7.2,' GeV',/,
     + 10x,'Events with W=1 for cross section estimation =',I5,/,
     + 10x,'Minimum hard photon energy = ',F7.3,' GeV',/,
     + 10x,'Minimum inv.mass mu+mu- pair = ',F7.3,' GeV',/,
     + 10x,'Estimated majoranta = ',1pE10.2,//) 
103   FORMAT(//,5x,'Generator e+e- -> e+e- tau+ tau- (gamma) of',
     +' F.A.Berends e.a.',/,5x,58(1H-),//,
     + 10x,'Beam energy = ',F7.2,' GeV',/,
     + 10x,'Events with W=1 for cross section estimation =',I5,/,
     + 10x,'Minimum hard photon energy = ',F7.3,' GeV',/,
     + 10x,'Minimum inv.mass tau+tau- pair = ',F7.3,' GeV',/,
     + 10x,'Estimated majoranta = ',1pE10.2,//)


      RETURN
      END

      SUBROUTINE GG_MMG1(E,WM,K0,KS,EWE,IDUMP,ITAU)
c*********************************************************************
c
c  Calculation  e e -> e e + mu mu (gamma) or
c               e e -> e e + tau tau (gamma)
c
c  Input: E
c         WM 
c         KO
c         KS
c         EWE
c         IDUMP
c         ITAU  = 0/1 : two-photon production mu+ mu- / tau+ tau-
c
c*********************************************************************

      IMPLICIT REAL*8(A-H,K-Z)
      DIMENSION PPX(3)

c      COMMON /INPUT/  E,WM,K0,KS,EWE
      COMMON /GGMMGVEC/    PV3(4),PV5(4),PV6(4),PV7(4),KV(4)
      COMMON /GGMMGWEIGHT/ WE
      COMMON /GGMMGLPLOT/  WI
      COMMON /GGMMGEXTS/   SWES,SWESK,MWES,SIG1S
      COMMON /GGMMGEXTH/   SWEH,SWEHK,MWEH,SIG1H
      COMMON /GGMMGEXTRA/ IFAILS,IFAILH,IK0S,IK0H,IEVES,IEVEH,IUNDFS,
     .                    IUNDFH
      COMMON /GGMMGMCCOUN/ IACCS,IACCH
      COMMON /GGMMGCONST/  ME,MU,PI,ALFA,BARN
      COMMON /GGMMGMCLOG/  HFLAG
      LOGICAL HFLAG
c
      DATA ICALL /0/
c
      IF (ICALL.NE.0) GOTO 4
      ICALL=1
c
c  Initialisation
c
      EE=E*E
      VM=WM/EE
      C1MM = 0.D0
      C1MP = 2.D0
      L=0.000511D0*K0/(E*(DSQRT(1.D0+K0/E)+1.D0))
c
c Natural constants
c
      ME=0.000511D0
      MU=0.105658387D0
      MTAU=1.777D0
      IF(ITAU.EQ.1) MU=MTAU     ! my variant 
      PI=3.14159265359D0
      LG2=DLOG(2.D0)
      BARN=3.89385D+05
      ALFA=1.D0/137.036D0
c
      MEK=ME*ME
      ME2=MEK/EE
      MUK=MU*MU
      MU2=MUK/EE
      MUES=MUK+MEK
      TWOPI=2.D0*PI
      PP=EE-MEK
      P=DSQRT(PP)
      XE=E/P
      XEK=MEK/PP
      XE1=XEK/(XE+1.D0)
c
      ET1 = E + P
c
      H16=2.D0*E-ME
c
c Calculation total integral of the approximation used.
c
      LLN1S=DLOG(16.D0/(ME2*(VM-ME2)))
      LLN2S=DLOG(64.D0/(ME2*(VM-ME2)**2))
      LLN3S=DLOG(2.D0*VM/MU2)
      LLN4S=DLOG(4.D0/VM)
      SIG1S=(1.D0/VM-0.25D0)*LLN1S*LLN2S*LLN3S*LLN4S*ALFA**4/PI*
     .     BARN/EE
c
c We take corrections on positron line into account by multi-
c plying the approximate cross-section by 2.
c
      SIG1S=SIG1S*2.D0
c
      LLN1H=DLOG(16.D0*EE/(4.D0*(L*L+2.D0*L*ME)+
     .     (WM-(L+ME)*(L+ME))*ME2))
      LLN2H=DLOG(64.D0*EE*EE/(ME2*(WM-(L+ME)*(L+ME))**2))
      LLN3H=DLOG(2.D0*VM/MU2)
      LLN4H=DLOG(4.D0/VM)
      H11=((2.D0*E-ME-DSQRT(WM))**2-MEK)/(L*L+2.D0*L*ME)
      SIG1H=(1.D0/VM-0.25D0)*LLN1H*LLN2H*LLN3H*LLN4H*ALFA**5/
     .     PI/PI*32.D0/EE*BARN*DLOG(H11)
c
c We take corrections on positron line into account by multi-
c plying the approximate cross-section by 2.
c
      SIG1H=SIG1H*2.D0
c
      SIG1T=SIG1H+SIG1S
      EPSI=SIG1H/SIG1T
c
    4 CONTINUE
c
      HFLAG=.FALSE.
c
c if RNF100 > EPSI a soft photon is generated.
c if RNF100 < EPSI a hard photon is generated.
c
      IF (RNF100(14).GT.EPSI) GOTO 15
      IEVEH=IEVEH+1
      HFLAG=.TRUE.
c
c  MP generation
c
      MPME=H11**RNF100(1)*(L*L+2.D0*L*ME)
      MPK=MPME+MEK
      MP=DSQRT(MPK)
      MP2=MPK/EE
c
c  W4 generation
c
      H15=2.D0*E-MP
      WP=H15*H15
      ETA1=RNF100(2)
      W4=WP*WM/(WP*(1.D0-ETA1)+WM*ETA1)
      V4=W4/EE
      WI=DSQRT(W4)
c
c  X1 generation
c
      H22=(W4/(H15*H15))**RNF100(3)*H15*H15/(4.D0*EE)
      H2=H22-MP2*0.25D0
      X1=1.D0-H2
      XX1=DSQRT(X1*X1-MP2)
      H12=MP2/(X1+XX1)
      ET3=E*(X1+XX1)
      DE1=0.5D0/(P*E*XX1*ET1*ET3)*(MEK*ET3-MPK*ET1)*(ET3-ET1)
c
c  CT3 generation
c
      HH1=((2.D0*H22+X1*C1MM)*(C1MP+DE1)/((C1MM+DE1)*
     .     (2.D0*H22+X1*C1MP)))**RNF100(3)*(2.D0*H22+X1*C1MP)/
     .     (C1MP+DE1)
      C1M1=(2.D0*H22-HH1*DE1)/(HH1-X1)
      CT3=1.D0-C1M1
      ST3=DSQRT(C1M1*(2.D0-C1M1))
      H3=X1*C1M1
      DE2A=ME2/2.D0*((2.D0*H3+V4-MP2+2.D0*H12*CT3)/(4.D0*H22-V4))**2
c
c  Y generation  (Y is the Feynman parameter)
c
      DELTA=2.D0*DSQRT((2.D0*H22+H3-DE2A*X1)**2+(4.D0+MP2)*DE2A*H3)
      AA=-2.D0*H3-2.D0*H2*DE2A+DE2A*DE2A+MP2*H2+MP2*MP2/4.D0-MP2*DE2A
      BB=4.D0*H22+2.D0*H3-2.D0*X1*DE2A-2.D0*DE2A*DE2A+MP2*DE2A
      CC=2.D0*DE2A+DE2A*DE2A
      IF (BB.GT.0.D0) GOTO 1
      Y1=(-BB+DELTA)/2.D0/AA
      GOTO 11
c
    1 CONTINUE
      Y1=(-BB-DELTA)/2.D0/AA
c
   11 CONTINUE
      Y0=CC/(AA*Y1)
      H6=(Y1-Y1*Y0)/(Y0*(1.D0-Y1))
      HH2=-1.D0*DABS(Y0/Y1)*H6**RNF100(5)*DSIGN(1.D0,AA)
      Y=(Y0+HH2*Y1)/(1.D0+HH2)
c
c  PHI' generation
c
      PHIR=TWOPI*RNF100(6)
      CPG=DCOS(PHIR)
      SPG=DSIN(PHIR)
c
c  CT' generation
c
      EY0=(1.D0-Y)*(1.D0+DE2A)+2.D0*Y-X1*Y+0.5D0*MP2*Y
      EY2=(AA*Y+BB)*Y+CC
      EY=DSQRT(EY0*EY0-EY2)
      ETA4=RNF100(7)
      CTG1=2.D0*(1.D0-ETA4)*EY2/(EY2+2.D0*ETA4*EY*(EY0+EY))
      CTG=1.D0-CTG1
      STG=DSQRT(CTG1*(2.D0-CTG1))
c
c  Calculation CT5 = COS scattering angle positron
c
      SEY=Y*X1*ST3/EY
      CEY1=Y*Y*X1*X1*ST3*ST3/(EY*(EY+1.D0-Y+Y*X1*CT3))
      CEY=1.D0-CEY1
      IF (CEY1.GE.0.D0.AND.CEY1.LT.1.D-20.AND.
     .    CTG1.GE.0.D0.AND.CTG1.LT.1.D-20) GOTO 550
      CPROD = CEY1*CTG1
      GOTO 551
c
  550 CONTINUE
      IUNDFH = IUNDFH + 1
      CPROD  = 0.D0
c
  551 CONTINUE
      C2M1=SEY*STG*CPG+CEY1+CTG1-CPROD
      CT5=1.D0-C2M1
      ST5=DSQRT(C2M1*(2.D0-C2M1))
      CP=(CEY*STG*CPG+SEY*CTG)/ST5
      SP=STG*SPG/ST5
c
c Calculation C12P = 1 + COS (angle between electron and positron)
c
      C12P=C1M1+C2M1-C1M1*C2M1-ST3*ST5*CP
c
c Calculation energy positron in final state
c
      H7=(2.D0*H12+2.D0*XX1*C12P-MP2+V4)/(4.D0*H2+2.D0*H12
     .   +2.D0*XX1*C12P)
      XX2=1.D0-H7
      X2=DSQRT(XX2*XX2+ME2)
      H77=(H7*(1.D0+XX2)-ME2)/(1.D0+X2)
      ET5=E*(X2+XX2)
      DE2=0.5D0/(P*E*XX2*ET1*ET5)*MEK*(ET5-ET1)*(ET5-ET1)
c
c Determination virtual photon masses
c
      T1=-2.D0*P*E*XX1*(C1M1+DE1)
      T2=-2.D0*P*E*XX2*(C2M1+DE2)
c
      E3=X1*E
      P3=XX1*E
      E5=X2*E
      P5=XX2*E
c
c Generation trivial azimuthal angle
c
      PHIP=TWOPI*RNF100(8)
      CP5=DCOS(PHIP)
      SP5=DSIN(PHIP)
      CP3=-CP*CP5-SP*SP5
      SP3=SP*CP5-CP*SP5
c
c Construction 4momenta particles in final state
c The electron + photon
c
      PPV3X=P3*ST3*CP3
      PPV3Y=P3*ST3*SP3
      PPV3Z=P3*CT3
c
c The positron
c
      PV5(1)=P5*ST5*CP5
      PV5(2)=P5*ST5*SP5
      PV5(3)=-P5*CT5
      PV5(4)=P5
c
      H10=((H7-H2)*(H7+H2-2.D0)+MP2)/(XX2+XX1)
      PV4X=-PPV3X-PV5(1)
      PV4Y=-PPV3Y-PV5(2)
      PV4Z=E*(H10+C1M1*XX1-C2M1*XX2)
      E4=E*(H2+H7)
c
c Construction 4momentum of virtual photon
c
      Q1X=-PPV3X
      Q1Y=-PPV3Y
      Q1Z=(MPME+EE*H2*(1.D0+X1))/(P+P3)+P3*C1M1
      EQ1=E*H2
c
      TT2=(2.D0*E*H7-MEK/ET1)*MEK/ET1-2.D0*P*P5*C2M1
c
c Boost to CM system muon and anti-muon
c
      EQ1CM6=(W4+T1-TT2)/(2.D0*WI)
      FAC1=-(EQ1CM6+EQ1)/(E4+WI)
      Q1CM6X=Q1X+FAC1*PV4X
      Q1CM6Y=Q1Y+FAC1*PV4Y
      Q1CM6Z=Q1Z+FAC1*PV4Z
c
c Generation polar angle of muon
c Z axis is determined by photon 1
c
      ACT=-0.5D0*(W4-T1-T2)
      HCT=(1.D0-4.D0*MU2/V4)*((W4-T1-T2)**2-4.D0*T1*T2)
      BCT=DSQRT(HCT)/2.D0
      ETA=2.D0*RNF100(9)-1.D0
      APB=(MU2*((W4-T1-T2)**2-4.D0*T1*T2)+T1*T2*V4)/
     .    ((ACT-BCT)*V4)
      H4=(APB/(ACT-BCT))**DABS(ETA)
      CTCM61=(APB+H4*(BCT-ACT))/(BCT*(1.D0+H4))
      CTCM6=1.D0-CTCM61
      IF (ETA.LT.0.D0) CTCM6=-CTCM6
      STCM6=DSQRT(CTCM61*(2.D0-CTCM61))
c
c Generation of azimuthal angle of muon
c
      PHICM6=TWOPI*RNF100(10)
      CPCM6=DCOS(PHICM6)
      SPCM6=DSIN(PHICM6)
c
      ECM6=WI/2.D0
      PPCM6=DSQRT(ECM6*ECM6-MUK)
      PCM6X=PPCM6*STCM6*CPCM6
      PCM6Y=PPCM6*STCM6*SPCM6
      PCM6Z=PPCM6*CTCM6
c
c Rotation back to original Z axis
c
      LENGTH=DSQRT((W4-T1-TT2)**2-4.D0*T1*TT2)/(2.D0*WI)
      CT=Q1CM6Z/LENGTH
      ST=DSQRT(Q1CM6X*Q1CM6X+Q1CM6Y*Q1CM6Y)/LENGTH
      IF (ST.EQ.0.D0) GOTO 60
      CF=Q1CM6X/LENGTH/ST
      SF=Q1CM6Y/LENGTH/ST
      PC6X=PCM6X*CT*CF-PCM6Y*SF+PCM6Z*ST*CF
      PC6Y=PCM6X*CT*SF+PCM6Y*CF+PCM6Z*ST*SF
      PC6Z=-PCM6X*ST           +PCM6Z*CT
      GOTO 61
   60 PC6X=PCM6X
      PC6Y=PCM6Y
      PC6Z=PCM6Z
   61 CONTINUE
c
c Boost back to lab system
c
      PV6(4)=(E4*ECM6+PV4X*PC6X+PV4Y*PC6Y+PV4Z*PC6Z)/WI
      FAC2=(PV6(4)+ECM6)/(E4+WI)
      PV6(1)=PC6X+FAC2*PV4X
      PV6(2)=PC6Y+FAC2*PV4Y
      PV6(3)=PC6Z+FAC2*PV4Z
c
      PV7(1)=PV4X-PV6(1)
      PV7(2)=PV4Y-PV6(2)
      PV7(3)=PV4Z-PV6(3)
      PV7(4)=E4-PV6(4)
      E6=PV6(4)
      E7=PV7(4)
      P6=DSQRT(E6*E6-MUK)
      P7=DSQRT(E7*E7-MUK)
      PP6=DSQRT(PV6(1)*PV6(1)+PV6(2)*PV6(2))
      PP7=DSQRT(PV7(1)*PV7(1)+PV7(2)*PV7(2))
      CT6=PV6(3)/P6
      ST6=PP6/P6
      CT7=PV7(3)/P7
      ST7=PP7/P7
      AL6=1.D0-CT6
      BE6=1.D0+CT6
      IF (CT6.GT.0.D0) GOTO 70
      BE6=ST6*ST6/AL6
      GOTO 71
   70 AL6=ST6*ST6/BE6
   71 CONTINUE
      AL7=1.D0-CT7
      BE7=1.D0+CT7
      IF (CT7.GT.0.D0) GOTO 72
      BE7=ST7*ST7/AL7
      GOTO 73
   72 AL7=ST7*ST7/BE7
   73 CONTINUE
      CP6=PV6(1)/PP6
      SP6=PV6(2)/PP6
      CP7=PV7(1)/PP7
      SP7=PV7(2)/PP7
c
c Boost to CM system P3+K
c
      EP1=(MPK+MEK-T1)/(2.D0*MP)
      LA=(MPME-T1)*(MPME-T1)-4.D0*MEK*T1
      DLA=DSQRT(LA)
      PV=DLA/(2.D0*MP)
      PV0MPV = MEK/(EP1+PV)
      E3K=E3*E3
      DV3=(MPK*EE-MEK*E3K)/(P*E3+E*P3)
      FAC3=-(EP1+E)/(E3+MP)
      P1X=FAC3*PPV3X
      P1Y=FAC3*PPV3Y
      P1Z=(DV3+E*P3*C1M1+P*MP-EP1*P3*CT3)/(E3+MP)
c
c Z axis is determined by P1
c
c Generate angle of radiated photon in CM system P3+K
c
      ANSWER=((1.D0+2.D0*PV/PV0MPV)**RNF100(11)-1.D0)*PV0MPV/PV
      YZ=PV0MPV+PV*ANSWER
      CG=1.D0-ANSWER
      SG=DSQRT(ANSWER*(2.D0-ANSWER))
c
c Generate azimuthal angle radiated photon
c
      FI=TWOPI*RNF100(12)
      CFG=DCOS(FI)
      SFG=DSIN(FI)
c
c Construct 4momentum of radiated photon
c
      KV0=MPME/(2.D0*MP)
      KCMX=KV0*SG*CFG
      KCMY=KV0*SG*SFG
      KCMZ=KV0*CG
c
c Rotation back to original Z axis
c
      CTT=P1Z/PV
      STT=DSQRT(P1X*P1X+P1Y*P1Y)/PV
c
      IF (STT.EQ.0.D0) GOTO 65
      CFF=P1X/PV/STT
      SFF=P1Y/PV/STT
      KCX=KCMX*CTT*CFF-KCMY*SFF+KCMZ*STT*CFF
      KCY=KCMX*CTT*SFF+KCMY*CFF+KCMZ*STT*SFF
      KCZ=-KCMX*STT            +KCMZ*CTT
      GOTO 66
   65 KCX=KCMX
      KCY=KCMY
      KCZ=KCMZ
   66 CONTINUE
c
c Boost back to lab system
c Photon 4momentum
c
      KV(4)=(E3*KV0+PPV3X*KCX+PPV3Y*KCY+PPV3Z*KCZ)/MP
      FAC4=(KV(4)+KV0)/(E3+MP)
      KV(1)=KCX+PPV3X*FAC4
      KV(2)=KCY+PPV3Y*FAC4
      KV(3)=KCZ+PPV3Z*FAC4
c
c Electron 4momentum
      PV3(1)=PPV3X-KV(1)
      PV3(2)=PPV3Y-KV(2)
      PV3(3)=PPV3Z-KV(3)
      PV3(4)=E3-KV(4)
c
      EF4=KV(4)
c
c If KV(4) < KS we can not accept the generated event
c The weight of the event is therefore put equal to 0
c
      IF (EF4.LT.KS) GOTO 2
c
      PPF=DSQRT(KV(1)*KV(1)+KV(2)*KV(2))
      CTFO=KV(3)/EF4
      STFO=PPF/EF4
      CPFO=KV(1)/PPF
      SPFO=KV(2)/PPF
      ALF=1.D0-CTFO
      BEF=1.D0+CTFO
      IF (CTFO.GT.0.D0) ALF=STFO*STFO/BEF
c
      P3DK=MPME/2.D0
      P1DK=KV0*YZ
      COH1=(MPME-T1)*(MPME-T1)/(4.D0*T1)
      COH2=(2.D0*P1DK+T1)**2/(4.D0*T1)
      COH3=T1-MEK-MPK+2.D0*P1DK
      COH4=3.D0*MEK-T1+MPK-2.D0*P1DK-
     .     (4.D0*P1DK*P1DK+MPME*MPME)/(2.D0*T1)
      COH5=3.D0*MEK-T1+MPK-2.D0*P1DK-2.D0*P1DK*MPME/T1
c
      PO1=P3DK*P3DK
      PO2=P1DK*P1DK
      PO12=P1DK*P3DK
c
      COE1=8.D0*MEK/PO1+4.D0*(T1-2.D0*MEK)/PO12
      COE2=8.D0*MEK/PO2+4.D0*(T1-2.D0*MEK)/PO12
      COE3=8.D0*MEK/PO12
      COE4=8.D0*MEK*COH3/PO12-2.D0*T1*COH4/PO12+
     .     4.D0*MEK*COH5/PO12+8.D0*MEK*COH1/PO1+8.D0*MEK*COH2/PO2
c
      E5K=E5*E5
      E6K=E6*E6
      E7K=E7*E7
      P3K=P3*P3
      P6K=E6K-MUK
      P7K=E7K-MUK
      DP3=(MPK*EE+MEK*P3K)/(E3*E+P3*P)
      DP6=(MUK*EE+MEK*P6K)/(E6*E+P6*P)
      DP36=(MUK*E3K+MPK*P6K)/(E6*E3+P6*P3)
      DP37=(MUK*E3K+MPK*P7K)/(E7*E3+P7*P3)
      DP7=(MUK*EE+MEK*P7K)/(E7*E+P7*P)
      DP56=(MUK*E5K+MEK*P6K)/(E6*E5+P6*P5)
      DP57=(MUK*E5K+MEK*P7K)/(E7*E5+P7*P5)
c
      DV6=MUK/(E6+P6)
      DV7=MUK/(E7+P7)
c
      QG2=EF4*(E+P*CTFO)
      QG5=EF4*(E5+P5*CTFO*CT5-P5*ST5*STFO*(CP5*CPFO+SP5*SPFO))
      QG6=EF4*(DV6+P6*(AL6+CT6*ALF)-P6*ST6*STFO*(CP6*CPFO+SP6*SPFO))
      QG7=EF4*(DV7+P7*(AL7+CT7*ALF)-P7*ST7*STFO*(CP7*CPFO+SP7*SPFO))
      P16=DP6+P*P6*AL6
      P36=DP36+P3*P6*(C1M1+CT3*AL6)-P3*P6*ST3*ST6*
     .    (CP3*CP6+SP3*SP6)
      P26=DP6+P*P6*BE6
      P56=DP56+P5*P6*(C2M1+CT5*BE6)-P5*P6*ST5*ST6*
     .    (CP5*CP6+SP5*SP6)
      P17=DP7+P*P7*AL7
      P37=DP37+P3*P7*(C1M1+CT3*AL7)-P3*P7*ST3*ST7*
     .    (CP3*CP7+SP3*SP7)
      P27=DP7+P*P7*BE7
      P57=DP57+P5*P7*(C2M1+CT5*BE7)-P5*P7*ST5*ST7*
     .    (CP5*CP7+SP5*SP7)
c
      PP12=EE+PP
      PP15=E*E5+P*P5*CT5
      PP23=E*E3+P*P3*CT3
      PP35=E3*E5+P3*P5-P3*P5*C12P
c
      T2U=T2*0.25D0+MUES
      Q12=P26+P56
      Q22=P27+P57
c
c Definition 'gauge' parameter positron current
c
      Z2=-(1.D0+X2)/H77
c
      E2X=2.D0/H77*P5*ST5*CP5
      E2Y=2.D0/H77*P5*ST5*SP5
      E2Z=2.D0*MEK*(1.D0+X2)/(X2*P+P5)+2.D0/H77*P5*C2M1
c
      P12=-PV6(1)*E2X-PV6(2)*E2Y-PV6(3)*E2Z-0.5D0*Z2*T2
      P22=-PV7(1)*E2X-PV7(2)*E2Y-PV7(3)*E2Z-0.5D0*Z2*T2
c
      DD1=APB-BCT*CTCM61
      DD2=ACT-BCT+BCT*CTCM61
      IF (CTCM6.LT.0.D0) GOTO 63
      GOTO 64
   63 DDU=DD1
      DD1=DD2
      DD2=DDU
   64 CONTINUE
c
      FACA=(T1-MPME)/(2.D0*T1)
      QA11=(1.D0-FACA)*P16+FACA*P36
      QA21=(1.D0-FACA)*P17+FACA*P37
c
c Definition 'gauge' parameter Z1A
c
      Z1A=FACA-1.D0/H2
c
      EAX=PPV3X/H2
      EAY=PPV3Y/H2
      EAZ=-(DP3+MEK)/(P+P3)-MPME/(H2*(P+P3))-P3*C1M1/H2
c
      PA11=-EAX*PV6(1)-EAY*PV6(2)-EAZ*PV6(3)-0.5D0*Z1A*T1
      PA21=-EAX*PV7(1)-EAY*PV7(2)-EAZ*PV7(3)-0.5D0*Z1A*T1
      DDA=-EAX*E2X-EAY*E2Y-EAZ*E2Z
      DDA0=(1.D0-FACA)*(PP12+PP15)+FACA*(PP23+PP35)
c
      EA2=-LA/(4.D0*T1)
      MA1=(PA11*PA11+T1*0.25D0*EA2)*(P22*P22+T2*T2U)
      MA2=(PA21*PA21+T1*0.25D0*EA2)*(P12*P12+T2*T2U)
      MAH1=2.D0*PA11*P12*PA21*P22+DDA*DDA*DD1*DD2*0.25D0+
     .     PA11*P22*DDA*DD2+P12*PA21*DDA*DD1-
     .     2.D0*PA11*PA21*T2*T2U-0.5D0*P12*P22*T1*EA2-
     .     T2*0.25D0*EA2*((Q12+Q22)**2+(DD1-DD2)**2*0.25D0)-
     .     MEK*T1*(QA11+QA21)**2-0.25D0*MEK*EA2*(W4-T1-T2)**2
      MAH2=-0.25D0*(QA11-QA21)**2+0.5D0*EA2*(MUES-0.5D0*W4-
     .     0.25D0*T2)-0.25D0*DDA0*DDA0
      MATOT=MA1/DD1/DD1+MA2/DD2/DD2+MAH1/DD1/DD2+T1*T2*MAH2/DD1/DD2
c
      FACB=-0.5D0-P1DK/T1
      QB11=(1.D0+FACB)*P36-FACB*P16-QG6
      QB21=(1.D0+FACB)*P37-FACB*P17-QG7
      EFO=EF4/E
c
c Definition 'gauge' parameter Z1B
c
      Z1B=FACB-(X1-EFO)/H2
c
      EBX=(1.D0-EFO)*PPV3X/H2-KV(1)
      EBY=(1.D0-EFO)*PPV3Y/H2-KV(2)
      EBZ=-(1.D0-EFO)*P3*C1M1/H2-MPME/(H2*(P3+X1*P))-
     .     (1.D0+X1)*MEK/(P3+X1*P)+EFO*MPME/(H2*(P+P3))+
     .     EFO*EE*(1.D0+X1)/(P+P3)-KV(3)
      PB11=-EBX*PV6(1)-EBY*PV6(2)-EBZ*PV6(3)-0.5D0*Z1B*T1
      PB21=-EBX*PV7(1)-EBY*PV7(2)-EBZ*PV7(3)-0.5D0*Z1B*T1
      DDB=-EBX*E2X-EBY*E2Y-EBZ*E2Z
      DDB0=(1.D0+FACB)*(PP23+PP35)-FACB*(PP12+PP15)-QG2-QG5
c
      EB2=MEK-COH2
      MB1=(PB11*PB11+T1*0.25D0*EB2)*(P22*P22+T2*T2U)
      MB2=(PB21*PB21+T1*0.25D0*EB2)*(P12*P12+T2*T2U)
      MBH1=2.D0*PB11*P12*PB21*P22+DDB*DDB*DD1*DD2*0.25D0+
     .     PB11*P22*DDB*DD2+P12*PB21*DDB*DD1-
     .     2.D0*PB11*PB21*T2*T2U-0.5D0*P12*P22*T1*EB2-
     .     T2*0.25D0*EB2*((Q12+Q22)**2+(DD1-DD2)**2*0.25D0)-
     .     MEK*T1*(QB11+QB21)**2-0.25D0*MEK*EB2*(W4-T1-T2)**2
      MBH2=-0.25D0*(QB11-QB21)**2+0.5D0*EB2*(MUES-0.5D0*W4-
     .     0.25D0*T2)-0.25D0*DDB0*DDB0
      MBTOT=MB1/DD1/DD1+MB2/DD2/DD2+MBH1/DD1/DD2+T1*T2*MBH2/DD1/DD2
c
      FACC=(2.D0*P1DK-MPME)/(2.D0*T1)
      QC11=QG6-FACC*P16+FACC*P36
      QC21=QG7-FACC*P17+FACC*P37
c
c Definition 'gauge' parameter Z1C
c
      Z1C=FACC-EFO/H2
c
      ECX=KV(1)+EFO/H2*PPV3X
      ECY=KV(2)+EFO/H2*PPV3Y
      ECZ=KV(3)-EFO*MPME/(H2*(P+P3))-EFO*EE*(1.D0+X1)/(P+P3)-
     .    EFO/H2*P3*C1M1
c
      PC11=-ECX*PV6(1)-ECY*PV6(2)-ECZ*PV6(3)-0.5D0*Z1C*T1
      PC21=-ECX*PV7(1)-ECY*PV7(2)-ECZ*PV7(3)-0.5D0*Z1C*T1
      DDC=-ECX*E2X-ECY*E2Y-ECZ*E2Z
      DDC0=QG2+QG5-FACC*(PP12+PP15)+FACC*(PP23+PP35)
c
      EC2=-FACC*FACC*T1
      MC1=(PC11*PC11+T1*0.25D0*EC2)*(P22*P22+T2*T2U)
      MC2=(PC21*PC21+T1*0.25D0*EC2)*(P12*P12+T2*T2U)
      MCH1=2.D0*PC11*P12*PC21*P22+DDC*DDC*DD1*DD2*0.25D0+
     .     PC11*P22*DDC*DD2+P12*PC21*DDC*DD1-
     .     2.D0*PC11*PC21*T2*T2U-0.5D0*P12*P22*T1*EC2-
     .     T2*0.25D0*EC2*((Q12+Q22)**2+(DD1-DD2)**2*0.25D0)-
     .     MEK*T1*(QC11+QC21)**2-0.25D0*MEK*EC2*(W4-T1-T2)**2
      MCH2=-0.25D0*(QC11-QC21)**2+0.5D0*EC2*(MUES-0.5D0*W4-
     .     0.25D0*T2)-0.25D0*DDC0*DDC0
      MCTOT=MC1/DD1/DD1+MC2/DD2/DD2+MCH1/DD1/DD2+T1*T2*MCH2/DD1/DD2
c
c Calculation MU.NU part
c
      NA1=(0.5D0*T1+MUK)*(P22*P22+T2*T2U)
      NA2=(0.5D0*T1+MUK)*(P12*P12+T2*T2U)
      NAH1=-(T1+2.D0*MUK)*P12*P22-
     .      0.25D0*MEK*((W4-T1-T2)**2+(DD1-DD2)**2)
      NAH2=-0.5D0*(Q12**2+Q22**2)-0.0625D0*((W4+T1+T2)**2+
     .      (DD1-DD2)**2)+0.125D0*((4.D0*MUK-W4)*
     .     (4.D0*MUES+2.D0*T1+T2)+W4*(T2-4.D0*MUES))
      NTOT=NA1/DD1/DD1+NA2/DD2/DD2+NAH1/DD1/DD2+T2*NAH2/DD1/DD2
c
c Total exact |MATRIX ELEMENT| squared
c
      MAT=COE1*MATOT+COE2*MBTOT+COE3*MCTOT+COE4*NTOT
c
      WE1H=MAT*MPME*MPME*DD1*DD2*YZ*DLOG((MPK+MEK-T1+DLA)/(2.D0*MP*
     .   ME))/(512.D0*MP*T1*T2*DLA*EE*EE)
      WE2H=0.25D0*W4*W4/ACT/BCT*DLOG(APB/(ACT-BCT))/
     .    LLN3H*DSQRT(1.D0-4.D0*MUK/W4)
      WE3H=(4.D0*H22+2.D0*X1*C12P)/(4.D0*H2+2.D0*XX1*C12P+2.D0*H12)*
     .    (C2M1+DE2A)/(C2M1+DE2)
      H9=DABS(DLOG(H6))
      WE4H=(4.D0*H22+2.D0*H3)/DELTA*H9/LLN2H
      WE5H=2.D0*H22/(2.D0*H22-X1*DE1)*DLOG((2.D0*H22+X1*C1MM)*
     .    (C1MP+DE1)/((C1MM+DE1)*(2.D0*H22+X1*C1MP)))/LLN1H
      WE6H=DLOG(H15*H15/W4)/LLN4H
      WE7H=EE/PP*(1.D0/VM-EE/(H15*H15))/(1.D0/VM-0.25D0)
c
      WE=WE1H*WE2H*WE3H*WE4H*WE5H*WE6H*WE7H
      GOTO 3
    2 CONTINUE
      WE1H=0.D0
      WE2H=0.D0
      WE3H=0.D0
      WE4H=0.D0
      WE5H=0.D0
      WE6H=0.D0
      WE7H=0.D0
      WE=0.D0
      IK0H=IK0H+1
    3 CONTINUE
c
c Symmetrization over electon and positron momenta
c
      IF (RNF100(13).LE.0.5D0) GOTO 830
      PPX4=PV3(4)
      PV3(4)=PV5(4)
      PV5(4)=PPX4
      DO 83 I=1,3
      PPX(I)=PV3(I)
      PV3(I)=-PV5(I)
      PV5(I)=-PPX(I)
      PV6(I)=-PV6(I)
      PV7(I)=-PV7(I)
      KV(I)=-KV(I)
   83 CONTINUE
c
  830 CONTINUE
c
      IF (WE.LT.0.D0) GOTO 50
      RETURN
   50 CONTINUE
      IFAILH=IFAILH+1
      IF (IFAILH.EQ.1.AND.IDUMP.EQ.0) PRINT 55
   55 FORMAT('0',6X,'FOR DETAILED INFORMATION ABOUT THE EVENTS',
     .              ' WITH NEGATIVE WEIGHT SET IDUMP EQUAL TO 1')
c     IF (IDUMP.EQ.0) PRINT 51,IEVEH,WE
c  51 FORMAT(' ',6X,'***WARNING*** : WE < 0 ]      EVENT NO : ',
c    .        I7,' WE = ',D19.6)
      IF (IDUMP.EQ.1) GOTO 52
      RETURN
   52 write(2,53) WE,WE1H,WE2H,WE3H,WE4H,WE5H,WE6H,WE7H
   53 FORMAT('0',6X,'TOTAL WEIGHT = ',D35.25/
     .           7X,'WEIGHT 1     = ',D35.25/
     .           7X,'WEIGHT 2     = ',D35.25/
     .           7X,'WEIGHT 3     = ',D35.25/
     .           7X,'WEIGHT 4     = ',D35.25/
     .           7X,'WEIGHT 5     = ',D35.25/
     .           7X,'WEIGHT 6     = ',D35.25/
     .           7X,'WEIGHT 7     = ',D35.25)
      write(2,54) V4,MPK,H22,X1,X2,C1M1,C2M1,Y0,Y1,CT6,CT7
   54 FORMAT(' ',6X,'(INV.MASS/E)**2       = ',D35.25/
     .           7X,'MPK                   = ',D35.25/
     .           7X,'1-E3/E-MPK/(4*E**2)   = ',D35.25/
     .           7X,'E3/E                  = ',D35.25/
     .           7X,'E5/E                  = ',D35.25/
     .           7X,'1-CT3                 = ',D35.25/
     .           7X,'1-CT5                 = ',D35.25/
     .           7X,'Y0                    = ',D35.25/
     .           7X,'Y1                    = ',D35.25/
     .           7X,'CT6                   = ',D35.25/
     .           7X,'CT7                   = ',D35.25)
      write(2,56) DD1,DD2,T1,T2,MAT
   56 FORMAT(' ',6X,'DD1 = ',D35.25,2X,'DD2 = ',D35.25/
     .           7X,'T1  = ',D35.25,2X,'T2  = ',D35.25/
     .           7X,'MAT = ',D35.25)
      write(2,57) MATOT,MA1,MA2,MAH1,MAH2
   57 FORMAT(' ',6X,'MATOT = ',D35.25/
     .           7X,'MATRIX MA : ',4(D20.6,2X))
      write(2,58) MBTOT,MB1,MB2,MBH1,MBH2
   58 FORMAT(' ',6X,'MBTOT = ',D35.25/
     .           7X,'MATRIX MB : ',4(D20.6,2X))
      write(2,59) MCTOT,MC1,MC2,MCH1,MCH2
   59 FORMAT(' ',6X,'MCTOT = ',D35.25/
     .           7X,'MATRIX MC : ',4(D20.6,2X))
      write(2,80) NTOT,NA1,NA2,NAH1,NAH2
   80 FORMAT(' ',6X,'NTOT   = ',D35.25/
     .           7X,'MATRIX N  : ',4(D20.6,2X))
      write(2,81) PV3,KV,PV5,PV6,PV7
   81 FORMAT(' ',6X,'ELECTRON  4MOMENTUM : ',4(D20.6,2X)/
     .           7X,'PHOTON    4MOMENTUM : ',4(D20.6,2X)/
     .           7X,'POSITRON  4MOMENTUM : ',4(D20.6,2X)/
     .           7X,'MUON      4MOMENTUM : ',4(D20.6,2X)/
     .           7X,'ANTI-MUON 4MOMENTUM : ',4(D20.6,2X))
      RETURN
   15 CONTINUE
      IEVES=IEVES+1
c
c  W4 generation
c
      WP=H16*H16
      ETA1=RNF100(1)
      W4=WP*WM/(WP*(1.D0-ETA1)+WM*ETA1)
      V4=W4/EE
      WI=DSQRT(W4)
c
c  X1 generation
c
      H22=(W4/(H16*H16))**RNF100(2)*H16*H16/(4.D0*EE)
      H2=H22-ME2*0.25D0
      X1=1.D0-H2
      XX1=DSQRT(X1*X1-ME2)
      H12=ME2/(X1+XX1)
      ET3=E*(X1+XX1)
      DE1=0.5D0/(P*E*XX1*ET1*ET3)*(MEK*ET3-MEK*ET1)*(ET3-ET1)
c
c  CT3 generation
c
      HH1=((2.D0*H22+X1*C1MM)*(C1MP+DE1)/((C1MM+DE1)*
     .     (2.D0*H22+X1*C1MP)))**RNF100(3)*(2.D0*H22+X1*C1MP)/
     .     (C1MP+DE1)
      C1M1=(2.D0*H22-HH1*DE1)/(HH1-X1)
      CT3=1.D0-C1M1
      ST3=DSQRT(C1M1*(2.D0-C1M1))
      H3=X1*C1M1
      DE2A=ME2/2.D0*((2.D0*H3+V4-ME2+2.D0*H12*CT3)/(4.D0*H22-V4))**2
c
c  Y generation (Y is the Feynman parameter)
c
      DELTA=2.D0*DSQRT((2.D0*H22+H3-DE2A*X1)**2+(4.D0+ME2)*DE2A*H3)
      AA=-2.D0*H3-2.D0*H2*DE2A+DE2A*DE2A+ME2*H2+ME2*ME2/4.D0-ME2*DE2A
      BB=4.D0*H22+2.D0*H3-2.D0*X1*DE2A-2.D0*DE2A*DE2A+ME2*DE2A
      CC=2.D0*DE2A+DE2A*DE2A
      IF (BB.GT.0.D0) GOTO 101
      Y1=(-BB+DELTA)/2.D0/AA
      GOTO 111
  101 CONTINUE
      Y1=(-BB-DELTA)/2.D0/AA
  111 CONTINUE
      Y0=CC/(AA*Y1)
      H6=(Y1-Y1*Y0)/(Y0*(1.D0-Y1))
      HH2=-1.D0*DABS(Y0/Y1)*H6**RNF100(4)*DSIGN(1.D0,AA)
      Y=(Y0+HH2*Y1)/(1.D0+HH2)
c
c  PHI' generation
c
      PHIR=TWOPI*RNF100(5)
      CPG=DCOS(PHIR)
      SPG=DSIN(PHIR)
c
c  CT' generation
c
      EY0=(1.D0-Y)*(1.D0+DE2A)+2.D0*Y-X1*Y+0.5D0*ME2*Y
      EY2=(AA*Y+BB)*Y+CC
      EY=DSQRT(EY0*EY0-EY2)
      ETA4=RNF100(6)
      CTG1=2.D0*(1.D0-ETA4)*EY2/(EY2+2.D0*ETA4*EY*(EY0+EY))
      CTG=1.D0-CTG1
      STG=DSQRT(CTG1*(2.D0-CTG1))
c
c  Calculation CT5 = COS scattering angle positron
c
      SEY=Y*X1*ST3/EY
      CEY1=Y*Y*X1*X1*ST3*ST3/(EY*(EY+1.D0-Y+Y*X1*CT3))
      CEY=1.D0-CEY1
      IF (CEY1.GE.0.D0.AND.CEY1.LT.1.D-20.AND.
     .    CTG1.GE.0.D0.AND.CTG1.LT.1.D-20) GOTO 1550
      CPROD = CEY1*CTG1
      GOTO 1551
 1550 CONTINUE
      IUNDFS = IUNDFS + 1
      CPROD  = 0.D0
 1551 CONTINUE
      C2M1=SEY*STG*CPG+CEY1+CTG1-CPROD
      CT5=1.D0-C2M1
      ST5=DSQRT(C2M1*(2.D0-C2M1))
      CP=(CEY*STG*CPG+SEY*CTG)/ST5
      SP=STG*SPG/ST5
c
c Calculation C12P = 1 + COS angle between electron and positron
c
      C12P=C1M1+C2M1-C1M1*C2M1-ST3*ST5*CP
c
c Calculation energy positron in final state
c
      H7=(2.D0*H12+2.D0*XX1*C12P-ME2+V4)/(4.D0*H2+2.D0*H12
     .   +2.D0*XX1*C12P)
      XX2=1.D0-H7
      X2=DSQRT(XX2*XX2+ME2)
      H77=(H7*(1.D0+XX2)-ME2)/(1.D0+X2)
      ET5=E*(X2+XX2)
      DE2=0.5D0/(P*E*XX2*ET1*ET5)*MEK*(ET5-ET1)*(ET5-ET1)
c
c Determination virtual photon masses
c
      T1=-2.D0*P*E*XX1*(C1M1+DE1)
      T2=-2.D0*P*E*XX2*(C2M1+DE2)
C
      E3=X1*E
      P3=XX1*E
      E5=X2*E
      P5=XX2*E
c
c Generation trivial azimuthal angle
c
      PHIP=TWOPI*RNF100(7)
      CP5=DCOS(PHIP)
      SP5=DSIN(PHIP)
      CP3=-CP*CP5-SP*SP5
      SP3=SP*CP5-CP*SP5
c
c Construction 4momenta particles in final state
c the electron + photon
c
      PV3(1)=P3*ST3*CP3
      PV3(2)=P3*ST3*SP3
      PV3(3)=P3*CT3
      PV3(4)=E3
c
c The positron
c
      PV5(1)=P5*ST5*CP5
      PV5(2)=P5*ST5*SP5
      PV5(3)=-P5*CT5
      PV5(4)=P5
c
      H10=((H7-H2)*(H7+H2-2.D0)+ME2)/(XX2+XX1)
      PV4X=-PV3(1)-PV5(1)
      PV4Y=-PV3(2)-PV5(2)
      PV4Z=E*(H10+C1M1*XX1-C2M1*XX2)
      E4=E*(H2+H7)
c
c Construction 4momentum of virtual photon
c
      Q1X=-PV3(1)
      Q1Y=-PV3(2)
      Q1Z=EE*H2*(1.D0+X1)/(P+P3)+P3*C1M1
      EQ1=E*H2
c
      TT2=(2.D0*E*H7-MEK/ET1)*MEK/ET1-2.D0*P*P5*C2M1
c
c Boost to CM system muon and anti-muon
c
      EQ1CM6=(W4+T1-TT2)/(2.D0*WI)
      FAC=-(EQ1CM6+EQ1)/(E4+WI)
      Q1CM6X=Q1X+FAC*PV4X
      Q1CM6Y=Q1Y+FAC*PV4Y
      Q1CM6Z=Q1Z+FAC*PV4Z
c
c Generation polar angle of muon
c Z axis is determined by photon 1
c
      ACT=-0.5D0*(W4-T1-T2)
      HCT=(1.D0-4.D0*MU2/V4)*((W4-T1-T2)**2-4.D0*T1*T2)
      BCT=DSQRT(HCT)/2.D0
      ETA=2.D0*RNF100(8)-1.D0
      APB=(MU2*((W4-T1-T2)**2-4.D0*T1*T2)+T1*T2*V4)/
     .    ((ACT-BCT)*V4)
      H4=(APB/(ACT-BCT))**DABS(ETA)
      CTCM61=(APB+H4*(BCT-ACT))/(BCT*(1.D0+H4))
      CTCM6=1.D0-CTCM61
      IF (ETA.LT.0.D0) CTCM6=-CTCM6
      STCM6=DSQRT(CTCM61*(2.D0-CTCM61))
c
c Generation of azimuthal angle of muon
c
      PHICM6=TWOPI*RNF100(9)
      CPCM6=DCOS(PHICM6)
      SPCM6=DSIN(PHICM6)
c
      ECM6=WI/2.D0
      PPCM6=DSQRT(ECM6*ECM6-MUK)
      PCM6X=PPCM6*STCM6*CPCM6
      PCM6Y=PPCM6*STCM6*SPCM6
      PCM6Z=PPCM6*CTCM6
c
c Rotation back to original Z axis
c
      LENGTH=DSQRT((W4-T1-TT2)**2-4.D0*T1*TT2)/(2.D0*WI)
      CT=Q1CM6Z/LENGTH
      ST=DSQRT(Q1CM6X*Q1CM6X+Q1CM6Y*Q1CM6Y)/LENGTH
      IF (ST.EQ.0.D0) GOTO 160
      CF=Q1CM6X/LENGTH/ST
      SF=Q1CM6Y/LENGTH/ST
      PC6X=PCM6X*CT*CF-PCM6Y*SF+PCM6Z*ST*CF
      PC6Y=PCM6X*CT*SF+PCM6Y*CF+PCM6Z*ST*SF
      PC6Z=-PCM6X*ST           +PCM6Z*CT
      GOTO 161
  160 PC6X=PCM6X
      PC6Y=PCM6Y
      PC6Z=PCM6Z
  161 CONTINUE
c
c Boost back to lab system
c
      PV6(4)=(E4*ECM6+PV4X*PC6X+PV4Y*PC6Y+PV4Z*PC6Z)/WI
      FAC1=(PV6(4)+ECM6)/(E4+WI)
      PV6(1)=PC6X+FAC1*PV4X
      PV6(2)=PC6Y+FAC1*PV4Y
      PV6(3)=PC6Z+FAC1*PV4Z
c
      PV7(1)=PV4X-PV6(1)
      PV7(2)=PV4Y-PV6(2)
      PV7(3)=PV4Z-PV6(3)
      PV7(4)=E4-PV6(4)
      E6=PV6(4)
      E7=PV7(4)
      P6=DSQRT(E6*E6-MUK)
      P7=DSQRT(E7*E7-MUK)
      PP6=DSQRT(PV6(1)*PV6(1)+PV6(2)*PV6(2))
      PP7=DSQRT(PV7(1)*PV7(1)+PV7(2)*PV7(2))
      CT6=PV6(3)/P6
      ST6=PP6/P6
      CT7=PV7(3)/P7
      ST7=PP7/P7
      AL6=1.D0-CT6
      BE6=1.D0+CT6
      IF (CT6.GT.0.D0) GOTO 170
      BE6=ST6*ST6/AL6
      GOTO 171
  170 AL6=ST6*ST6/BE6
  171 CONTINUE
      AL7=1.D0-CT7
      BE7=1.D0+CT7
      IF (CT7.GT.0.D0) GOTO 172
      BE7=ST7*ST7/AL7
      GOTO 173
  172 AL7=ST7*ST7/BE7
  173 CONTINUE
      CP6=PV6(1)/PP6
      SP6=PV6(2)/PP6
      CP7=PV7(1)/PP7
      SP7=PV7(2)/PP7
c
c Calculation exeact matrix element
c
      E3K=E3*E3
      E5K=E5*E5
      E6K=E6*E6
      E7K=E7*E7
      P3K=P3*P3
      P6K=E6K-MUK
      P7K=E7K-MUK
      DP3=(MEK*EE+MEK*P3K)/(E3*E+P3*P)
      DP6=(MUK*EE+MEK*P6K)/(E6*E+P6*P)
      DP36=(MUK*E3K+MEK*P6K)/(E6*E3+P6*P3)
      DP37=(MUK*E3K+MEK*P7K)/(E7*E3+P7*P3)
      DP7=(MUK*EE+MEK*P7K)/(E7*E+P7*P)
      DP56=(MUK*E5K+MEK*P6K)/(E6*E5+P6*P5)
      DP57=(MUK*E5K+MEK*P7K)/(E7*E5+P7*P5)
      P16=DP6+P*P6*AL6
      P36=DP36+P3*P6*(C1M1+CT3*AL6)-P3*P6*ST3*ST6*
     .    (CP3*CP6+SP3*SP6)
      P26=DP6+P*P6*BE6
      P56=DP56+P5*P6*(C2M1+CT5*BE6)-P5*P6*ST5*ST6*
     .    (CP5*CP6+SP5*SP6)
      P17=DP7+P*P7*AL7
      P37=DP37+P3*P7*(C1M1+CT3*AL7)-P3*P7*ST3*ST7*
     .    (CP3*CP7+SP3*SP7)
      P27=DP7+P*P7*BE7
      P57=DP57+P5*P7*(C2M1+CT5*BE7)-P5*P7*ST5*ST7*
     .    (CP5*CP7+SP5*SP7)
      Q11=P16+P36
      Q12=P26+P56
      Q21=P17+P37
      Q22=P27+P57
c
c Define 'gauge' parameters
c
      Z1=-(1.D0+X1)/H2
      Z2=-(1.D0+X2)/H77
      E1X=2.D0/H2*PV3(1)
      E1Y=2.D0/H2*PV3(2)
      E1Z=-2.D0*MEK*(1.D0+X1)/(X1*P+P3)-2.D0*P3*C1M1/H2
      E2X=2.D0/H77*P5*ST5*CP5
      E2Y=2.D0/H77*P5*ST5*SP5
      E2Z=2.D0*MEK*(1.D0+X2)/(X2*P+P5)+2.D0/H77*P5*C2M1
      DD=-E1X*E2X-E1Y*E2Y-E1Z*E2Z
      PP12=EE+PP
      PP15=E*E5+P*P5*CT5
      PP23=E*E3+P*P3*CT3
      PP35=E3*E5+P3*P5-P3*P5*C12P
      DD0=PP12+PP15+PP23+PP35
      P11=-PV6(1)*E1X-PV6(2)*E1Y-PV6(3)*E1Z-0.5D0*Z1*T1
      P12=-PV6(1)*E2X-PV6(2)*E2Y-PV6(3)*E2Z-0.5D0*Z2*T2
      P21=-PV7(1)*E1X-PV7(2)*E1Y-PV7(3)*E1Z-0.5D0*Z1*T1
      P22=-PV7(1)*E2X-PV7(2)*E2Y-PV7(3)*E2Z-0.5D0*Z2*T2
      DD1=APB-BCT*CTCM61
      DD2=ACT-BCT+BCT*CTCM61
      IF (CTCM6.LT.0.D0) GOTO 163
      GOTO 164
  163 DDU=DD1
      DD1=DD2
      DD2=DDU
  164 CONTINUE
      T1U=T1*0.25D0+MUES
      T2U=T2*0.25D0+MUES
c
c Calculation sum E.MU*E.NU part and MU.NU part
c
      MA1=(P11*P11+T1*T1U)*
     .    (P22*P22+T2*T2U)
      MA2=(P12*P12+T2*T2U)*
     .    (P21*P21+T1*T1U)
      MAH1=2.D0*P11*P12*P21*P22+
     .     DD*DD1*P12*P21+DD*DD2*P11*P22+
     .     DD*DD*DD1*DD2*0.25D0-
     .     2.D0*T1*T1U*P12*P22-
     .     2.D0*T2*T2U*P11*P21-
     .     MEK*MEK*(T1+T2-W4)**2-MEK*T2*(Q12+Q22)**2-
     .     MEK*T1*(Q11+Q21)**2-MEK*(DD1-DD2)**2*(T1+T2)*0.25D0
      MAH2=-4.D0*(Q11-Q21)**2
     .     -4.D0*(Q12-Q22)**2
     .     -4.D0*DD0*DD0
     .     -(W4+T1+T2)*(W4+T1+T2+16.D0*MEK)
     .     -16.D0*MUES*W4
     .     +32.D0*T1U*T2U
      MTOT=MA1/(DD1*DD1)+MA2/(DD2*DD2)+
     .   MAH1/(DD1*DD2)+MAH2*T1*T2/(16.D0*DD1*DD2)
c
c Calculation MU.NU part
c
      NA1=T1*(0.5D0*T1+MUK)*(P22*P22+T2*T2U)
      NA2=T1*(0.5D0*T1+MUK)*(P12*P12+T2*T2U)
      NAH1=-2.D0*T1*(0.5D0*T1+MUK)*P12*P22-
     .      0.25D0*MEK*T1*((W4-T1-T2)**2+(DD1-DD2)**2)
      NAH2=-0.5D0*(Q12**2+Q22**2)-0.0625D0*((W4+T1+T2)**2+
     .      (DD1-DD2)**2)+0.125D0*((4.D0*MUK-W4)*
     .     (4.D0*MUES+2.D0*T1+T2)+W4*(T2-4.D0*MUES))
      NTOT=NA1/DD1/DD1+NA2/DD2/DD2+NAH1/DD1/DD2+T1*T2*NAH2/DD1/DD2
c
c Calculation form-factor of MTOT
c Both virtual (vertex) corrections and soft bremsstrahlung
c contribute to this form-factor.
c
c Notice that the infra-red divergence drops out
c
      A=DSQRT(1.D0-4.D0*MEK/T1)
      ALF=(A-1.D0)/(A+1.D0)
      VV=-(ALF*ALF-1.D0)*MEK/(2.D0*(ALF*E-E3))
      LN0=DLOG(ALF)
      LN1=DLOG((E+P)*(E+P)/MEK)
      LN2=DLOG((E3+P3)*(E3+P3)/MEK)
      DEL0=DLOG(2.D0*KS/ME)*(1.D0+(A*A+1.D0)/(2.D0*A)*LN0)
      DEL1=-0.25D0*(E/P*LN1+E3/P3*LN2)
      DEL2=(A*A+1.D0)/(4.D0*A)*(LN1*LN1*0.25D0-LN2*LN2*0.25D0+
     .      DILOGM((VV+ALF*MEK/(E+P))/VV)-
     .      DILOGM((VV+MEK/(E3+P3))/VV)+
     .      DILOGM((VV+ALF*E+ALF*P)/VV)-
     .      DILOGM((VV+E3+P3)/VV))
      DEL3=1.D0+(1.D0+2.D0*A*A)/(4.D0*A)*LN0+
     .     (1.D0+A*A)/(2.D0*A)*(-DILOGM(-ALF)+0.25D0*LN0*LN0-
     .     LN0*DLOG(2.D0*A/(1.D0+A))-PI*PI/12.D0)
c
      DETOT1=-2.D0*ALFA/PI*(DEL0+DEL1+DEL2+DEL3)
      XP=E3/P3
      XPK=MEK/P3K
      XP1=XPK/(XP+1.D0)
c
c Calculation boundaries of COS(THETA) integration of soft photon
c
      BZ=-XP1+(L*L+2.D0*L*ME)/(2.D0*P3*KS)
      IF (BZ.GT.2.D0) BZ=2.D0
      IF (BZ.LT.0.D0) GOTO 130
      XEP=(MEK-0.5D0*T1)/(P*P3)
      XEMP=XP1-XE1
      XD=DSQRT(T1*(T1-4.D0*MEK))/(2.D0*P*P3)
      XD2=XD*XD
      XA=XEMP+XE*C1M1
      XMU=XEK*(2.D0-C1M1)*C1M1
      LNPM=DLOG(XP1)
      LNPP=DLOG(XP1+BZ)
      XLND=DLOG(4.D0*XD2)
      XET1=(XE+1.D0)*C1M1
      XLN1=DLOG(XD-XA+XET1)
      LNET1=DLOG(XET1)
      XH1=DSQRT(XE1*XE1+2.D0*BZ*XE1+BZ*BZ+(2.D0*XE1-2.D0*XE*
     .    BZ+C1M1)*C1M1)
      IF (XE*C1M1-XE1.LT.BZ) GOTO 120
      XET0=XE*C1M1-XE1-BZ+XH1
      GOTO 121
  120 XET0=XMU/(XE1-XE*C1M1+BZ+XH1)
  121 CONTINUE
      XH=XEMP-C1M1*(2.D0*XE1-2.D0*XE*BZ+C1M1)/(XE1+BZ+XH1)
      XH2=XH+XD
      IF (XH.LT.0.D0) XH2=2.D0*XET0*(XP1+BZ)/(XD-XH)
      XLN2=DLOG(XH2)
      LNET0=DLOG(XET0)
c
      DEL4=DLOG((L*L+2.D0*ME*L)/(2.D0*P3*KS))*
     .     (XE1+2.D0*XEK*(CT3*XET0-XE*(1.D0+CT3)*C1M1)/
     .      (XET0*XET0+XMU)-BZ*(XP+1.D0)/
     .       (XP1+BZ)+2.D0*XEP/XD*(2.D0*(XLN1+XLN2-LG2)-LNET0-
     .       LNET1-LNPM-LNPP))
      DEL5=-XE1*LNPM+XEK*(2.D0*XE*(1.D0+CT3)*C1M1-2.D0*XET0*CT3)/
     .     (XET0*XET0+XMU)*LNPP-2.D0*XE*(LNET1-LNET0)-
     .      XEK*(XEMP-XP*C1M1+XD-XD*C1M1)/(XD*(XD+XA))*
     .      (LG2+LNET1+LNPM-XLN1-XLN2)-
     .      XEK*(XEMP-XP*C1M1-XD+XD*C1M1)/(XD*(XD-XA))*
     .      (XLN1+XLN2-LG2-LNET0-LNPP)
      DEL6=BZ*(XP+1.D0)/(XP1+BZ)-XPK/(XP1+BZ)*LNPP+
     .     (XP+1.D0)*LNPM
      DEL7=-2.D0*XEP/XD*
     .     (-XLN1*XLN1+2.D0*XLN1*(LG2+LNPM)-LG2*LG2-LG2*LNPM-
     .      0.5D0*LNPM*LNPM+LNET1*LNET1+XLN2*XLN2-2.D0*XLN2*LNET0-
     .      LG2*LNPP-0.5D0*LNPP*LNPP-DLOG(XD+XA)*(LNET1-LNET0)-
     .      (LG2+LNET1+LNPM-XLN1-XLN2)*XLND-LG2*(2.D0*(XLN1+XLN2-
     .       LG2)-LNET0-LNET1-LNPM-LNPP)+
     .       DILOGM(-XMU/(XET1*(XD+XA)))-DILOGM(-XMU/(XET0*(XD+XA)))+
     .       DILOGM(XET1/(XD+XA))-DILOGM(XET0/(XD+XA))+
     .       2.D0*DILOGM(XP1*XET1/(XD*(XD-XA+XET1)))-
     .       2.D0*DILOGM((XD+XA-XET0)/(2.D0*XD)))
      DETOT2=ALFA/(2.D0*PI)*(DEL4+DEL5+DEL6+DEL7)
      GOTO 133
  130 CONTINUE
      DETOT2=0.D0
  133 CONTINUE
c
c Corection for vacuum polarization by electron loops.
c
      DETOT3=-2.D0*ALFA/PI*(8.D0/9.D0-A*A/3.D0+
     .          A*(0.5D0-A*A/6.D0)*LN0)
c
c Correction for vacuum polarization by muon and tau loops
c is obtained by expanding the above formulae for large A.
c DETOT=-2*ALFA/PI*(-4/15*1/A**2-16/105/A**4.........)
c
      AMUK=1.D0-4.D0*MUK/T1
      IF (AMUK.LT.10.D0) GOTO 131
      DETOT4=2.D0*ALFA/PI*(4.D0/(15.D0*AMUK)+16.D0/(105.D0*AMUK*AMUK))
      GOTO 132
  131 CONTINUE
      AMUK = DSQRT(AMUK)
      DETOT4=-2.D0*ALFA/PI*(8.D0/9.D0-AMUK*AMUK/3.D0+AMUK*
     .       (0.5D0-AMUK*AMUK/6.D0)*DLOG((AMUK-1.D0)/(AMUK+1.D0)))
  132 CONTINUE
      ATAUK=1.D0-4.D0*MTAU*MTAU/T1
      IF (ATAUK.LT.10.D0) GOTO 134
      DETOT5=2.D0*ALFA/PI*(4.D0/(15.D0*ATAUK)+16.D0/(105.D0*ATAUK*
     .       ATAUK))
      GOTO 135
  134 CONTINUE
      ATAUK = DSQRT(ATAUK)
      DETOT5=-2.D0*ALFA/PI*(8.D0/9.D0-ATAUK*ATAUK/3.D0+ATAUK*
     .       (0.5D0-ATAUK*ATAUK/6.D0)*DLOG((ATAUK-1.D0)/(ATAUK+1.D0)))
  135 CONTINUE
c
c Hadronic vacuum polarization
c
      DETOT6=-2.D0*REPIM(T1)
c
      W1=0.5D0+DETOT1+DETOT2+DETOT3+DETOT4+DETOT5+DETOT6
c
c Calculation form-factor of NTOT
c Now only the virtual (vertex) corrections contribute
c This contribution is infra-red finite
c
      W2=2.D0*ALFA/PI*(1.D0-A*A)/(4.D0*A)*LN0
c
      MA=-(W1*MTOT+W2*NTOT)
c
c Calculation weight
c
      WE1S=MA*DD1*DD2/T1/T2/EE/EE*0.25D0
      WE2S=0.25D0*W4*W4/ACT/BCT*DLOG(APB/(ACT-BCT))/
     .    LLN3S*DSQRT(1.D0-4.D0*MUK/W4)
      WE3S=(4.D0*H22+2.D0*X1*C12P)/(4.D0*H2+2.D0*XX1*C12P+2.D0*H12)*
     .    (C2M1+DE2A)/(C2M1+DE2)
      H9=DABS(DLOG(H6))
      WE4S=(4.D0*H22+2.D0*H3)/DELTA*H9/LLN2S
      WE5S=2.D0*H22/(2.D0*H22-X1*DE1)*DLOG((2.D0*H22+X1*C1MM)*
     .    (C1MP+DE1)/((C1MM+DE1)*(2.D0*H22+X1*C1MP)))/LLN1S
      WE6S=DLOG(H16*H16/W4)/LLN4S
      WE7S=EE/PP*(1.D0/VM-EE/(H16*H16))/(1.D0/VM-0.25D0)
c
      WE=WE1S*WE2S*WE3S*WE4S*WE5S*WE6S*WE7S
c
      DO 100 I=1,4
      KV(I)=0.D0
  100 CONTINUE
c
c Symmetrization of electron and positron momentum
c
      IF (RNF100(13).LT.0.5D0) GOTO 1800
      PPX4=PV3(4)
      PV3(4)=PV5(4)
      PV5(4)=PPX4
      DO 180 I=1,3
      PPX(I)=PV3(I)
      PV3(I)=-PV5(I)
      PV5(I)=-PPX(I)
      PV6(I)=-PV6(I)
      PV7(I)=-PV7(I)
  180 CONTINUE
c
 1800 CONTINUE
      IF (WE.LT.0.D0) GOTO 150
      RETURN
  150 CONTINUE
      IFAILS=IFAILS+1
      IF (IFAILS.EQ.1.AND.IDUMP.EQ.0) write(2,155)
  155 FORMAT('0',6X,'FOR DETAILED INFORMATION ABOUT THE EVENTS',
     .              ' WITH NEGATIVE WEIGHT SET IDUMP EQUAL TO 1')
      IF (IDUMP.EQ.1) GOTO 152
      RETURN
  152 write(2,153) WE,WE1S,WE2S,WE3S,WE4S,WE5S,WE6S,WE7S
  153 FORMAT('0',6X,'TOTAL WEIGHT = ',D35.25/
     .           7X,'WEIGHT 1     = ',D35.25/
     .           7X,'WEIGHT 2     = ',D35.25/
     .           7X,'WEIGHT 3     = ',D35.25/
     .           7X,'WEIGHT 4     = ',D35.25/
     .           7X,'WEIGHT 5     = ',D35.25/
     .           7X,'WEIGHT 6     = ',D35.25/
     .           7X,'WEIGHT 7     = ',D35.25)
      write(2,154) V4,H22,X1,X2,C1M1,C2M1,Y0,Y1,CT6,CT7
  154 FORMAT(' ',6X,'(INV.MASS/E)**2       = ',D35.25/
     .           7X,'1-E3/E-MEK/(4*E**2)   = ',D35.25/
     .           7X,'E3/E                  = ',D35.25/
     .           7X,'E5/E                  = ',D35.25/
     .           7X,'1-CT3                 = ',D35.25/
     .           7X,'1-CT5                 = ',D35.25/
     .           7X,'Y0                    = ',D35.25/
     .           7X,'Y1                    = ',D35.25/
     .           7X,'CT6                   = ',D35.25/
     .           7X,'CT7                   = ',D35.25)
      write(2,156) DD1,DD2,W1,W2,MTOT,NTOT,T1,T2,
     .          MA1,MA2,MAH1,MAH2,NA1,NA2,NAH1,NAH2
  156 FORMAT(' ',6X,'DD1 = ',D35.25,2X,'DD2 = ',D35.25/
     .           7X,'W1  = ',D35.25,2X,'W2  = ',D35.25/
     .           7X,'MTOT = ',D35.25,2X,'NTOT = ',D35.25/
     .           7X,'T1  = ',D35.25,2X,'T2  = ',D35.25/
     .           7X,'MATRIX M : ',4(D20.6,2X)/
     .           7X,'MATRIX N : ',4(D20.6,2X))
      RETURN
      END

      FUNCTION REPIM(S)
C-------------------------------------------- REMARKS ------------------
C VACUUM POLARIZATION IN QED.
C THE HADRONIC CONTRIBUTION IS OBTAINED USING A DISPERSION INTEGRAL
C OVER THE KNOWN HADRONIC CROSS SECTION.
C THE RESULT USED HERE IS A PARAMETRIZATION GIVEN BY  
C H.BURKHARDT, TASSO NOTE 192(1981).   
C-----------------------------------------------------------------------
      IMPLICIT REAL*8(A-H,O-Z)
C-------------------------------------------- CHECK FOR S VALUES -------
      DATA I/0/
      IF(I.EQ.1) GOTO 2
      I=1
      IF(S.GT.0.D0.AND.S.LT.100.D0) WRITE(2,1) S
    1 FORMAT(3H0S=,F6.3,7H GEV**2/
     . 46H VACUUM POLARIZATION MAY BE BADLY APPROXIMATED)
    2 CONTINUE    
      X=DABS(S)   
C-------------------------------------------- HADRONIC PART -----------
      IF(X.LT.1.D0)
     . REPIM= - 2.302D-03*DLOG(1.D0+4.091D0*X)
      IF(X.GE.1.D0.AND.X.LT.64.D0)
     . REPIM= - 2.822D-03*DLOG(1.D0+1.218D0*X) - 1.512D-03
      IF(X.GE.64.D0)
     . REPIM= - 3.068D-03*DLOG(1.D0 +       X) - 1.1344D-03
      RETURN
      END


      DOUBLE PRECISION FUNCTION DILOGM(X)
CERN      C304      VERSION    29/07/71 DILOG        59                C
      IMPLICIT REAL*8(A-H,O-Z)
c
      Z=-1.644934066848226D0
      IF(X .LT.-1.D0) GO TO 1
      IF(X .LE. 0.5D0) GO TO 2
      IF(X .EQ. 1.D0) GO TO 3
      IF(X .LE. 2.D0) GO TO 4
C
      Z=3.289868133696453D0
    1 T=1.D0/X
      S=-0.5D0
      Z=Z-0.5D0*DLOG(DABS(X))**2
      GO TO 5
C
    2 T=X
      S=0.5D0
      Z=0.D0
      GO TO 5
C
    3 DILOGM=1.644934066848226D0
      RETURN
C
    4 T=1.D0-X
      S=-0.5D0
      Z=1.644934066848226D0-DLOG(X)*DLOG(DABS(T))
C
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
      DILOGM=S*T*(A-B)+Z
      RETURN
      END

      BLOCK DATA GG_TO_MMG
      IMPLICIT REAL*8(A-H,K-Z)
      COMMON /GGMMGEXTS/ SWES,SWESK,MWES,SIG1S
      COMMON /GGMMGEXTH/ SWEH,SWEHK,MWEH,SIG1H
      COMMON /GGMMGEXTRA/IFAILS,IFAILH,IK0S,IK0H,IEVES,IEVEH,IUNDFS,
     .                   IUNDFH
      COMMON /GGMMGMCCOUN/ IACCS,IACCH
      DATA SWES/0.D0/,SWESK/0.D0/,MWES/0.D0/,
     .     SWEH/0.D0/,SWEHK/0.D0/,MWEH/0.D0/,
     .     IFAILS/0/,IFAILH/0/,IEVES/0/,IEVEH/0/,
     .     IK0S/0/,IK0H/0/,IACCS/0/,IACCH/0/,
     .     IUNDFS/0/,IUNDFH/0/
      END

      REAL FUNCTION RNF100*8(IDUM)
c
c   Random numbers generator for GG_MMGGEN
c
      REAL *4 RLU
c
      RNF100=RLU(0)
c
      RETURN
      END

      SUBROUTINE FINIS1(EWE)
c
c   Print calculation results of MC1
c
      IMPLICIT REAL*8(A-H,K-Z)
c      COMMON /GGMMGINPUT/ E,WM,K0,KS,EWE
      COMMON /GGMMGEXTS/ SWES,SWESK,MWES,SIG1S
      COMMON /GGMMGEXTH/ SWEH,SWEHK,MWEH,SIG1H
      COMMON /GGMMGEXTRA/IFAILS,IFAILH,IK0S,IK0H,IEVES,IEVEH,IUNDFS,
     +                   IUNDFH
      COMMON /GGMMGMCCOUN/ IACCS,IACCH
C
      MEANWS=SWES/IEVES
      SDS=DSQRT(SWESK-SWES*SWES/IEVES)/IEVES
      SIGMAS=MEANWS*SIG1S
      ERRORS=SDS*SIG1S
      IF (MWES.NE.0.D0) EFFS=MEANWS/MWES*100.D0
C
      MEANWH=SWEH/IEVEH
      SDH=DSQRT(SWEHK-SWEH*SWEH/IEVEH)/IEVEH
      SIGMAH=MEANWH*SIG1H
      ERRORH=SDH*SIG1H
      IF (MWEH.NE.0.D0) EFFH=MEANWH/MWEH*100.D0
C
      PRINT 18
      IF (MWES.GT.EWE) PRINT 17
      PRINT 20, MWES,SWES,MEANWS,SDS,SIG1S,SIGMAS,ERRORS,
     .         IFAILS,IEVES,IACCS,IK0S,IUNDFS
      IF (MWES.NE.0.D0) PRINT 15, EFFS
      PRINT 19
      IF (MWEH.GT.EWE) PRINT 17
      PRINT 20, MWEH,SWEH,MEANWH,SDH,SIG1H,SIGMAH,ERRORH,
     .         IFAILH,IEVEH,IACCH,IK0H,IUNDFH
      IF (MWEH.NE.0.D0) PRINT 15, EFFH
C
      SIGT=SIGMAS+SIGMAH
      ERROR=DSQRT(ERRORS**2+ERRORH**2)
      PRINT 21, SIGT,ERROR
C
   15 FORMAT(' ',6X,'Efficiency         = ',1PD11.3,' %')
   17 FORMAT(6X,'****WARNING**** : Estimated weight too small',/)
   18 FORMAT(/,6X,'SOFT BREHMSSTRAHLUNG RESULTS',/,
     .         6X,'----------------------------',/)
   19 FORMAT(/,6X,'HARD BREHMSSTRAHLUNG RESULTS',/,
     .         6X,'----------------------------',/)
   20 FORMAT(    7X,'Maximum weight     = ',1PD11.3/
     .           7X,'Sum weights        = ',1PD11.3/
     .           7X,'Mean weight        = ',1PD11.3,' +-',1PD10.3/
     .           7X,'Sig1               = ',1PD11.3,' NB'/
     .           7X,'Cross section      = ',1PD11.3,' NB',
     *         ' +-',1PD10.3,' nb'//
     .           7X,'# Events with negative weight = ',I7/
     .           7X,'# Generated events            = ',I7/
     .           7X,'# Accepted events             = ',I7/
     .           7X,'# Events with weight 0        = ',I7/
     .           7X,'# Underflows                  = ',I7)
   21 FORMAT(/,7X,'Exact total cross section = ',1PD11.3,
     *            ' NB +-',1PD10.3,' NB',//,
     *       3x,74(1H-),/)
      RETURN
      END
