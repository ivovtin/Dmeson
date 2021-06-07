      SUBROUTINE gen_GgResRc(Eb0,ITAG0,Q1Smin,Q1Smax,Q2Smin,Q2Smax)
c***********************************************************************
c                                                                      *
c  Main subroutine of the generator                                    *
c                                                                      *
c  Input: Eb0 - beam energy, GeV                                       *
c         ITAG0=1/2/3 - tagged particle: e+/e-/mix                     *
c         Q1Smin,Q1Smax,Q2Smin,Q2Smax - limits on photon virtualities  *
c         IRAD=1/0 - with/without r.c. (from ggresrc.inc)              *
c         ...                                                          *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 EB0,R0,RMA,E,S,T1,T2,S1,S2,WEI,W,t1minp,t1maxp,t2minp
      Parameter (R0=2.817940289D-13)
      Real *8 Q1Smin,Q1Smax,Q2Smin,Q2Smax
      Real *8 t2maxp,P1P2,P1K2,P2K1,AK1K2,B1,B2,B3,B
      Real *8 FAC,FAC1,FAC2,FAC3,SS,FI,RND,GGRFVMDM
      Real *8 RR,beta,beta0,C(3),GG(3),ptot,gamma,ll,GGRpolar,MAX,MIN
      Integer *4 ITAG0,I,J
c
      Save 
c
      Data GG/0.,0.,1./
c
 3    NOBR=NOBR+1              ! counter of all cycles
      BETA0=1.                 ! used to avoid warning
c
      ITAG=ITAG0               ! define e+ or e- tagging. ITAG now in /GGRPAR/
c
      IF(ITAG0.EQ.3) THEN
c
        CALL GGRRNDM(RND,1)
c
        ITAG=1
        IF(RND.GT.0.5) ITAG=2
      END IF
c
      IF(IRAD.EQ.1) THEN    ! radiation from initial state
c
        Call GGRRNDM(RND,1)
c
        BETA0=ALPHA/PI*(DLOG(-t2imax*(1.-Rmax)/(em**2))-1.)
        RR=Rmax*exp(DLOG(RND)/BETA0)
      ELSE
        RR=0.
      END IF
c
      IF(RR.gt.Rmin) THEN         ! radiation from initial state
        S=4.D0*Eb0**2*(1.D0-RR)   ! correction of s
        T2maxp=T2imax*(1.D0-RR)
      ELSE
        S=4.D0*Eb0**2
        t2maxp=t2imax
      END IF  
c
      E=DSQRT(s)/2.D0  
      T1minp=t1imin
      T1maxp=t1imax
      T2minp=t2imin
c
c  Generate eta_c or eta_b mass using Breit-Wigner distribution
c
      IF(IR.le.3) THEN
        rm=rmas
      ELSE  
        min=atan(((rmas-15.*rwid)**2-rmas**2)/rmas/rwid)/pi
        max=atan(((rmas+15.*rwid)**2-rmas**2)/rmas/rwid)/pi
c
        CALL GGRRNDM(RND,1)
c
        rnd=(max-min)*rnd+min
        rm=sqrt(rmas**2+rmas*rwid*tan(pi*rnd))
      END IF
      
      RMA=RM
c      
      Call GGRINV(S,RMA,t1minp,t1maxp,t2minp,t2maxp, T1,T2,S1,S2,WEI)
c
      SS=0.
      FAC2=1.
      FAC3=1.
c
      IF(WEI.NE.0.) THEN
        W=RM
        P1P2=S/2.-EM**2
        P1K2=1./2.*(S1-T2-EM**2)
        P2K1=1./2.*(S2-T1-EM**2)
        AK1K2=1./2.*(RM**2-T1-T2)
c.........
c   B from paper of H.Terazava, Rev.Mod.Phys. 43(1973)615
        B1=(4.*P1P2-2.*P1K2-2.*P2K1+AK1K2)**2+
     &    AK1K2**2-T1*T2-16.*EM**4
        B2=P1P2*AK1K2-P1K2*P2K1
        B3=T1*(2*P1K2-AK1K2)**2+T2*(2*P2K1-AK1K2)**2+
     &    4.*EM**2*AK1K2**2
        B=1./4.*T1*T2*B1-4.*B2**2+EM**2*B3
c...........
c  B using Budnev's formalism 
c        nu=(w**2-t1-t2)/2.
c        X=nu**2-t1*t2
c        u1=s2-em**2-t1
c        u2=s1-em**2-t2
c        b=((u2-nu)**2/X*t1+t1+4.*em**2)*
c     &    ((u1-nu)**2/X*t2+t2+4.*em**2)*X/8.
c        cophi=(-2.*s+u1+u2-nu+4*em**2+
c     &    nu*(u2-nu)*(u1-nu)/x)/
c     &    sqrt(t1*t2*((u2-nu)**2/X-1.+4.*em**2/t1)*
c     &    ((u1-nu)**2/X-1.+4.*em**2/t2))
c        cophi=cophi**2*2.-1.
c        B=B-
c     &    abs(((u2-nu)**2/X*t1-t1+4.*em**2))*
c     &    abs(((u1-nu)**2/X*t2-t2+4.*em**2))*
c     &    cophi*X/8.
c        
        FAC=1./(4.*PI)/E**4 *B/T1/T2
        FAC1=(R0*EM)**2*1.E33
c
        IF(KVMDM.NE.0) FAC2=GGRFVMDM(T1,T2)
c         
        IF(IRAD.NE.0) THEN          ! correction of cr.sec due to ISR,FSR
          ll=dlog(-t2/em**2)-1.
          beta=alpha/pi*ll
          FAC3=(1.+
     &      alpha/pi*(3./4.*ll-0.25))*
     &      beta/beta0*dexp(beta0*dlog(rmax))*          
     &      dexp((beta-beta0)*dlog(rr))
     &      /(1-GGRpolar(-t2))**2/(1-GGRpolar(-t1))**2

        END IF
c
        SS=FAC1*FAC*FAC2*FAC3*(RG*1.E-6)/RM**3*WEI   ! cr.sec. in nb
      END IF
c
      SUM=SUM+SS
      ES=ES+SS**2
      SUM1=SUM1+FAC2   ! sum for average VMDM factor 
      SUM2=SUM2+FAC3   ! sum for avaerge (1+r.c.) factor
c
      IF(SS.GT.FM) THEN
c        print *,' GGRESRC: ss > fm: ss=',ss
        FM=SS                                 ! define maximum weight
      END IF  
c
      IF(SS.GT.FMAX) THEN
        NGT=NGT+1
        IF(NGT.le.10) PRINT *,' GGRESRC, warning: ss > Fmax: ss=',SS
      END IF
c
      CALL GGRRNDM(RND,1)
c
      IF(FMAX*RND.GT.SS) GOTO 3
c
      Nact=Nact+1                ! number of events with weight=1
c
c   Calculation of lab.mom-s of products of reaction ee-> eeR
c      
      CALL GGRRNDM(RND,1)
c
      FI=2.*PI*RND
c
      CALL GGRLMOM(S,S1,S2,T1,T2,RM,FI)      
c
      NPART=3              ! current number of particles in /GGREV/ 
c    
      IF(RR.GT.Rmin) THEN  ! 
c
c  Lorenz transformation of momentums of scattered e+, e- and produced
c  resonance into lab. system
c
        Gamma=(2.d0-rr)/(2.d0*dsqrt(1.d0-rr))
c 
        Ptot=DSQRT(PPART(1,1)**2+PPART(2,1)**2+PPART(3,1)**2)
        C(1)=PPART(1,1)/Ptot
        C(2)=PPART(2,1)/Ptot
        C(3)=PPART(3,1)/Ptot
c
        CALL GGRLOR(GG,gamma,C,PPART(4,1),em)
c
        Ptot=dsqrt(PPART(4,1)**2-em**2)
        PPART(1,1)=C(1)*Ptot
        PPART(2,1)=C(2)*Ptot
        PPART(3,1)=C(3)*Ptot
c        
        Ptot=DSQRT(PPART(1,2)**2+PPART(2,2)**2+PPART(3,2)**2)
        C(1)=PPART(1,2)/Ptot
        C(2)=PPART(2,2)/Ptot
        C(3)=PPART(3,2)/Ptot
c
        CALL GGRLOR(GG,gamma,C,PPART(4,2),em)
c
        Ptot=dsqrt(PPART(4,2)**2-em**2)
        PPART(1,2)=C(1)*Ptot
        PPART(2,2)=C(2)*Ptot
        PPART(3,2)=C(3)*Ptot
c      
        Ptot=DSQRT(PPART(1,3)**2+PPART(2,3)**2+PPART(3,3)**2)
        C(1)=PPART(1,3)/Ptot
        C(2)=PPART(2,3)/Ptot
        C(3)=PPART(3,3)/Ptot
c
        CALL GGRLOR(GG,gamma,C,PPART(4,3),rm)
c
        Ptot=dsqrt(PPART(4,3)**2-rm**2)       
        PPART(1,3)=C(1)*Ptot
        PPART(2,3)=C(2)*Ptot
        PPART(3,3)=C(3)*Ptot
c
c  Radiative photon (ISR) 
c
        NPART=4             ! 4-th particle in /GGREV/
        Type(4)=22
        Mother(4)=0
        MPART(4)=0.
        PPART(4,4)=Eb0*RR
        PPART(1,4)=0.d0
        PPART(2,4)=0.d0
        PPART(3,4)=-PPART(4,4)
      END IF
c
      IF(IRAD.NE.0) Call GGRFSR(t2)  !  final state radiation
c
      IF(ITAG.EQ.1) GOTO 11
c
      IF(ITAG0.EQ.3) THEN
        ITAG=1
c
        CALL GGRRNDM(RND,1)
c
        IF(RND.GT.0.5) ITAG=2
      END IF
c
c  For ITAG=2 change e-, e+ types and directions of all particles
c     
      IF(ITAG.EQ.2) THEN
c
        DO I=1,2
          Type(I)=-Type(I)
c
          DO J=1,3 
            PPART(J,I)=-PPART(J,I)
          END DO
c
        END DO      
c
        DO I=3,NPART
          DO J=1,3
            PPART(J,I)=-PPART(J,I)
          END DO
        END DO
c
      END IF
c
 11   GOTO (10,20,30,40,50) IR
c 
 10   TYPE(3)=111   ! pi0
      IF(IMODE.NE.0) CALL GGRPI0D(IMODE)   ! pi0 decay
      GOTO 100
c
 20   TYPE(3)=221   ! eta
      IF(IMODE.NE.0) CALL GGRETD(3,IMODE)  ! eta decay
      GOTO 100
c
 30   TYPE(3)=331   ! eta'
      IF(imode.ne.0) CALL GGRET1D(3,IMODE) ! eta' decay
      GOTO 100
c
 40   TYPE(3)=441   ! eta_c
      IF(IMODE.NE.0) CALL GGRETCD(3,IMODE) ! eta_c decay
      GOTO 100
c
 50   TYPE(3)=551   ! eta_b
      IF(IMODE.NE.0) CALL GGRDEC2G(3)      ! eta_b -> 2gamma
c
 100  RETURN
c
      END
 
!
!***********************************************************************
!

      SUBROUTINE GGRESINI(Eb0,IR0,IMODE0,KVMDM0,ITAG0,IRAD0,Fmax0,Rmax0,
     &  Q1Smin, Q1Smax, Q2Smin, Q2Smax,Kmin0)
c***********************************************************************
c                                                                      *
c   Input parameters for generator:                                    *
c                                                                      *
c   Eb0 - Energy of beam, GeV                                          *
c   IR0 = 1-pi0, 2-eta, 3-eta' 4-eta_c, 5-eta_b                        *
c   IMODE0 - index of decay mode, 0 - no decay                         *
c                                                                      *
c   For pi0 (IR0=1) IMODE0:                                            *
c     1 - pi0 -> 2gamma                                                *
c     2 - pi0 -> e+ e- gamma                                           *
c                                                                      *
c   For eta (IR0=2) IMODE0:                                            *
c     1 - eta -> 2gamma                                                *
c     2 - eta -> 3pi0                                                  *
c     3 - eta -> pi+ pi- pi0                                           *
c     4 - eta -> pi+ pi- gamma                                         *
c                                                                      *
c   For eta' (IR0=3) IMODE0:                                           *
c     1 - eta-prime -> 2gamma                                          *
c     2 - eta-prime -> pi+ pi- eta, eta -> 2gamma                      *
c     3 - eta-prime -> pi+ pi- eta, eta -> 3pi0                        *
c     4 - eta-prime -> pi+ pi- eta, eta -> pi+ pi- pi0                 *
c     5 - eta-prime -> pi+ pi- eta, eta -> pi+ pi- gamma               *
c     6 - eta-prime -> pi0 pi0 eta, eta -> 2gamma                      *
c     7 - eta-prime -> pi0 pi0 eta, eta -> 3pi0                        *
c     8 - eta-prime -> pi0 pi0 eta, eta -> pi+ pi- pi0                 *
c     9 - eta-prime -> pi0 pi0 eta, eta -> pi+ pi- gamma               *
c    10 - eta-prime -> rho0 gamma                                      *
c                                                                      *
c   For eta_c (IR0=4) IMODE0:                                          *
c     1 - eta_c -> KS K+pi-                                            *
c     2 - eta_c -> 2gamma                                              *
c                                                                      *
c   For eta_b (IR0=5) IMODE0:                                          *
c     1 - eta_b -> 2gamma                                              *
c                                                                      *
c   KVMDM0 - key for Vector Meson Domimance Model: 1 - included        *
c   ITAG0  - tagged particle: 1-e+, 2-e-, 3- e+ or e-                  *
c   IRAD0  - radiative corrections: 0/1 -  without/with r.c.           *
c   Fmax0  - max value of cross section                                *
c   Rmax0  - max energy of phot./Ebeam                                 *
c   Q1Smin (>0) - min value of -t1                                     *
c   Q1Smax (>0) - max value of -t1                                     *
c   Q2Smin (>0) - min value of -t2                                     *
c   Q2Smax (>0) - max value of -t2                                     *
c   Kmin0       - min energy (GEV) of FSR photon                       *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 EB0,FMAX0,Rmax0,Rmin0,Q1Smin, Q1Smax, Q2Smin, Q2Smax
      Integer *4 IR0,IMODE0,KVMDM0,ITAG0,IRAD0,I
      Real *8 Kmin0,RMASS(5),RGGG(5),RWIDTH(5),TM,BrPi0I(2)
      Real *8 BrEtaI(4),BrEtaPrimI(4),BrRhoI
      Character *6 TEXTRES(5)
      Character *23 TEXTRAD(2)
      Character *8 TEXTTAG(3)
      Character *19 TEXTVMDM(2)
c
      Data TEXTRES/'pi0','eta','eta-pr','eta_c','eta_b'/
      Data TEXTRAD/'simulation without r.c.','simulation with r.c.   '/
      Data TEXTTAG/'e+      ','e-      ','e+ or e-'/ 
      Data TEXTVMDM/'without VMDM factor','with VMDM factor   '/ 
      Data Rmin0/1.D-4/ ! min energy of radiative phot.=Rmin0*Ebeam
c
      Data RMASS/       ! masses of PS resonances, Gev (PDG2008)
     &     0.1349766D0,0.547853D0,0.95766D0,2.9803D0,9.3889/
c
      Data RGGG/        ! gg-widths of resonances, keV
     &     0.007742D0,0.51103D0,4.305D0,6.408D0,0.4/
c
      Data RWIDTH/ ! full widths of resonances, GeV (used for eta_c, eta_b)
     &  7.84d-9,1.3d-6,2.05d-4,26.7d-3,30.0d-3/
c
      Data BrPi0I/0.98798,0.01198/  ! Br pi0->2gamma, pi0->e+e-gamma 
c  Br eta->2gamma, 3pi0, pi+pi-pi0, pi+pi-gamma
      Data BrEtaI/0.3931,0.3256,0.2273,0.046/ 
c  Br eta'->2gamma, pi+pi-eta, pi0pi0eta, rho0gamma
      Data BrEtaPrimI/0.021,0.446,0.207,0.294/
c      
      Data BrRhoI/1./           ! Br rho->pi+pi-
c
      Save
c
      CALL GGRFVP               ! fills common with vacuum polar. data
c
c    Estimation of maximum weight for Ebeam=5 Gev without corrections 
c
      Fmax=Fmax0                           
      IF(IR0.EQ.1.AND.FMAX.LE.0.) Fmax=15.     !  majorant value for pi0
      IF(IR0.EQ.2.AND.FMAX.LE.0.) Fmax=10.     !  majorant value for eta
      IF(IR0.EQ.3.AND.FMAX.LE.0.) Fmax=10.     !  majorant value for eta'
      IF(IR0.eq.4.AND.FMAX.LE.0.) Fmax=0.1     !  majorant value for eta_c
      IF(IR0.eq.5.AND.FMAX.LE.0.) Fmax=0.00001 !  majorant value for eta_b
c
      IF(IR0.LT.1.OR.IR0.GT.5) THEN
        PRINT *,' GGRESINI, error: IR0=',IR0,', but should be 1-5'
        STOP
      END IF
c
      IR=IR0
      IMODE=IMODE0
      KVMDM=KVMDM0
      IRAD=IRAD0
      RMAS=RMASS(IR)
      RWID=RWIDTH(IR)
      RG=RGGG(IR)
      Rmax=Rmax0
      Rmin=Rmin0
      Kmin=Kmin0
      BrPi0(1)=BrPi0I(1)
      BrPi0(2)=BrPi0I(2)
      BrRho=BrRhoI
c
      DO I=1,4
        BrEta(I)=BrEtaI(I)
        BrEtaPrim(I)=BrEtaPrimI(I)
      END DO
c
      IF(KVMDM.LT.0.OR.KVMDM.GT.1) THEN
        PRINT *,' GGRESINI, error: KVMDM should be 0 or 1'
        STOP
      END IF
c
      IF(ITAG0.LT.1.OR.ITAG0.GT.3) THEN
        PRINT *,' GGRESINI, error: ITAG0 should be 1 - 3'
        STOP
      END IF
c
      IF(IRAD.LT.0.OR.IRAD.GT.1) THEN
        PRINT *,' GGRESINI, error: IRAD should be  0 or 1'
        STOP
      END IF
c                                          
      IF(IRAD.EQ.1.AND.(Rmax.LE.0..OR.Rmax.GE.1)) THEN
        PRINT *,' GGRESINI, error: for IRAD =1 should be 0 < Rmax < 1'
        STOP
      END IF
c
      IF(Q1Smin.GT.Q1Smax.OR.Q2Smin.GT.Q2Smax) THEN
        PRINT *,' GGRESINI, error: wrong limits on momentum transfer'
        STOP
      END IF
c
      PI=DACOS(-1.D0)
      Alpha=1./137.0360   ! PDG2008
      EM=0.51099891D-3
      Mpi0=0.1349766D0
      Mpi=0.13957018D0
      Meta=0.547853D0
      Metap=0.95766
      Mks=0.497614
      Mkc=0.493677
      Mrho=0.77549D0
      Mjpsi=3.096916
      Mups=9.4603
c                                                                        
      t2imax=-Q2Smin       ! t2 used for tagged particle 
      t2imin=-Q2Smax
      t1imax=-Q1Smin
      t1imin=-Q1Smax       
c      
      IF(IRAD.NE.0) THEN   ! correction of limit on t2 
        TM=4.*EM**2/(1.-Rmax)
        IF(t2imax.GT.-TM) t2imax=-TM
      END IF
c
      IF(RMAS+2.*EM.GE.2.*EB0) THEN
        PRINT *,' GGRESINI, error: beam energy is too low'
        STOP
      END IF
c
      SUM=0.
      ES=0.
      SUM1=0.
      SUM2=0.
      Fm=0.
      Fm1=0.   ! used for FSR
      Fmax1=0. ! used for FSR
      NGT=0
      NOBR=0
      Nact=0
c      
      PRINT 29, EB0,TEXTRES(IR),RMAS,RWID,RG,KVMDM,TEXTVMDM(KVMDM+1)
      PRINT 32, ITAG0,TEXTTAG(ITAG0),IRAD,TEXTRAD(IRAD+1)
      IF(IRAD.NE.0) PRINT 30, Rmax,Rmin,Kmin
      PRINT 31, Q1Smin,Q1Smax,Q2Smin,Q2Smax
      PRINT 33, FMAX,IMODE
      BrTot=1.     ! total probability of decay chain
c
      IF(IR.EQ.1) THEN
        IF(IMODE.EQ.1) THEN
          print *, ' pi0 -> 2gamma, Br=',BrPi0(1)*100,'%'
          BrTot=BrPi0(1)
        END IF
c
        IF(IMODE.EQ.2) THEN
          print *, ' pi0 -> e+ e- gamma, Br=',BrPi0(2)*100,'%'
          BrTot=BrPi0(2)
        END IF
c
        IF(IMODE.EQ.0) PRINT *,' without decay of resonance'
c
        IF(IMODE.LT.0.OR.IMODE.GT.2) THEN
          PRINT *,' GGRESINI, error: for pi0 IMODE should be 0-2'
          STOP
        END IF         
      END IF
c
      IF(IR.EQ.2) THEN
        IF(IMODE.EQ.1) THEN
          PRINT *, ' eta -> 2gamma, Br=',BrEta(1)*100,'%'
          BrTot=BrEta(1)
        END IF
c
        if(IMODE.EQ.2) then 
          print *, ' eta -> 3pi0, ( pi0->2gamma), Br=',
     &    BrEta(2)*BrPi0(1)**3*100,'%'
          BrTot=BrEta(2)*BrPi0(1)**3
        end if
c
        if(IMODE.EQ.3) then
          print *, ' eta -> pi+ pi- pi0, ( pi0->2gamma)',
     &    ', Br=',BrEta(3)*BrPi0(1)*100,'%'
          BrTot=BrEta(3)*BrPi0(1)
        end if
c
        if(IMODE.EQ.4) then 
          print *, ' eta -> pi+ pi- gamma, Br=',BrEta(4)*100,'%'
          BrTot=BrEta(4)
        end if
c
        if(IMODE.EQ.0) print *, ' without decay of resonance'
        if(IMODE.LT.0.OR.IMODE.GT.4) then
          PRINT *,' GGRESINI, error: for eta IMODE should be 0-4'
          STOP
        end if
      END IF
c
      IF(IR.EQ.3) THEN
        if(IMODE.EQ.1) then
          print *, ' eta-prime -> 2gamma, Br=',BrEtaPrim(1)*100,'%'
          BrTot=BrEtaPrim(1)
        end if
c
        if(IMODE.EQ.2) then 
          print *,' eta-prime -> pi+ pi- eta, (eta->2gamma), Br=',
     &    BrEtaPrim(2)*BrEta(1)*100,'%'
          BrTot=BrEtaPrim(2)*BrEta(1)
        end if
c
        if(IMODE.EQ.3) then 
          print *,
     &    ' eta-prime -> pi+ pi- eta (eta ->3pi0, pi0->2gamma), Br=',
     &    BrEtaPrim(2)*BrEta(2)*BrPi0(1)**3*100,'%'
          BrTot=BrEtaPrim(2)*BrEta(2)*BrPi0(1)**3
        end if
c
        if(IMODE.EQ.4) then
          print *,
     &    ' eta-prime -> pi+ pi- eta (eta ->pi+ pi- pi0, pi0->2gamma)',
     &    ' Br=',BrEtaPrim(2)*BrEta(3)*BrPi0(1)*100,'%'
          BrTot=BrEtaPrim(2)*BrEta(3)*BrPi0(1)
        end if
c
        if(IMODE.EQ.5) then 
          print *,
     &    ' eta-prime -> pi+ pi- eta (eta ->pi+ pi- gamma), Br=',
     &    BrEtaPrim(2)*BrEta(4)*100,'%'
          BrTot=BrEtaPrim(2)*BrEta(4)
        end if
c
        if(IMODE.EQ.6) then
         print *,
     &    ' eta-prime -> pi0 pi0 eta (eta ->2gamma, pi0->2gamma), Br=',
     &    BrEtaPrim(3)*BrEta(1)*BrPi0(1)*BrPi0(1)*100,'%'
          BrTot=BrEtaPrim(3)*BrEta(1)*BrPi0(1)*BrPi0(1)
        end if
c 
        if(IMODE.EQ.7) then
          BrTot=BrEtaPrim(3)*BrEta(2)*BrPi0(1)**5
          print *,
     &    ' eta-prime -> pi0 pi0 eta (eta ->3pi0, pi0->2gamma), Br=',
     &    BrTot*100,'%'
        end if
c
        if(IMODE.EQ.8) then
          BrTot=BrEtaPrim(3)*BrEta(3)*BrPi0(1)**3
          print *,
     &    ' eta-prime -> pi0 pi0 eta (eta ->pi+ pi- pi0, pi0->2gamma)',
     &    ', Br=',BrTot*100,'%'
        end if 
c
        if(IMODE.EQ.9) then
          print *,
     &    ' eta-prime -> pi0 pi0 eta (eta ->pi+ pi- gamma, pi0->2gamma)'
     &    ,', Br=',BrEtaPrim(3)*BrEta(4)*BrPi0(1)**2*100,'%'
          BrTot=BrEtaPrim(3)*BrEta(4)*BrPi0(1)**2
        end if
c
        if(IMODE.EQ.10) then
          print *,' eta-prime -> rho0 gamma (rho0 ->pi+ pi-), Br=',
     &    BrEtaPrim(4)*BrRho*100,'%'
          BrTot=BrEtaPrim(4)*BrRho
        end if
c
        if(IMODE.EQ.0) print *,' without decay of resonance'
        if(IMODE.LT.0.OR.IMODE.GT.10) then
          PRINT *,' GGRESINI, error: for eta-prime IMODE should be 0-10'
          STOP
        end if
      END IF
c
      IF(IR.EQ.4) THEN
c
        if(IMODE.EQ.1) then
          BrTot=7.0D-2/3.
          print *,' eta_c -> KS K+ pi-, Br=',BrTot*100,'%'
        end if
c
        if(IMODE.EQ.2) then
          BrTot=3.0D-4
          print *,' eta_c -> 2gamma, Br=',BrTot*100,'%'
        end if
c
        if(IMODE.EQ.0) print *,' without decay of resonance'
        if(IMODE.LT.0.OR.IMODE.GT.2) then
          PRINT *,' GGRESINI, error: for eta_c IMODE should be 0-2'
          STOP
        end if
      END IF
c
      IF(IR.EQ.5) THEN
        IF(IMODE.EQ.1) print *,' eta_b -> 2gamma'
        if(IMODE.EQ.0) print *,' without decay of resonance'
        if(IMODE.LT.0.OR.IMODE.GT.1) then
          PRINT *,' GGRESINI, error: for eta_b IMODE should be 0 or 1'
          STOP
        end if
      END IF
c
      Print 21
c
 21   FORMAT(/,80(1H*))

 29   FORMAT(/,80(1H*),//,
     &' Simualtion of e+e- -> e+e- + R(0-+) with r.c.',/,
     &' ---------------------------------------------',//,
     &' Ebeam = ',F6.3,' GeV',/,
     &' Resonance: ',A6,/,
     &' Resonance mass = ',F6.4,' GeV',/,
     &' Resonance full width = ',1pE8.2,' GeV',/,
     &' Resonance gg width =', 0pF8.5,' keV',/,
     &' KVMDM =',I1,' - cross section ',A19)

 30   FORMAT(' ISR generation: Eph/Ebeam = ',1pE8.2,' - ',1pE8.2,/,
     & ' FSR generation: Kmin = ',1pE8.2,' GeV')

 31   FORMAT(' Q1 squared = ','(',0pF6.3,' -',0pF7.3,') GeV^2',/,
     &' Q2 squared = ','(',0pF6.3,' -',0pF7.3,') GeV^2')

 32   FORMAT(' ITAG =',I2,' - tagging of ',A8,/,' IRAD =',I2,' - ',A23)

 33   FORMAT(' Fmax = ', 1pE8.2,/,
     &       ' Resonance decay mode =',I2,':',/)

      END          

! 
!*********************************************************************** 
! 
      SUBROUTINE GGRESEND
c***********************************************************************
c                                                                      *
c  Prints final results                                                *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 ERSEC,TSEC,TCORR
c
      Save
c
      ERSEC= ES-SUM**2/NOBR
      IF(ERSEC.LT.0.)ERSEC=0.
      ERSEC= SQRT(ERSEC)/NOBR
      TSEC=SUM/NOBR
      PRINT 1,NACT,NOBR,NGT,FM,TSEC,ERSEC
      IF(IR.LE.4) PRINT 4,TSEC*BrTot,ERSEC*BrTot
c
      TCORR=SUM1/NOBR
      PRINT 2,TCORR
c 
      TCORR=SUM2/NOBR
      PRINT 3,TCORR
c      print *,'Fm for FSR =', Fm1
c                          
      PRINT 21
 1    FORMAT(/,80(1H*),//,' Results of simulation:',/,
     &                    ' ----------------------',//,
     & ' NACT =',I10,2X,/,
     & ' NOBR =',I10,2X,/,
     & ' NGT =',I6,2X,//,
     & ' Maximal weight Fm =',1pD9.2,//,
     &       ' Production cross sec. = (',1pD10.4,' +-',1pD8.2,') nb')
 2    FORMAT(' Average VMDM factor =',F7.4)
 3    FORMAT(' Average (1+r.c.) factor =',F7.4,/)
 4    Format(' Prod. cross sect.*Br  = (',1pD10.4,' +-',1pD8.2,') nb',/)
 21   FORMAT(/,80(1H*))
c
      END

! 
!*********************************************************************** 
! 
 
      SUBROUTINE GGRPREV(EB0,Nev,K)
c***********************************************************************
c                                                                      *
c  Print out one event                                                 *
c                                                                      *
c  Input: Nev - number of event                                        *
c         K - regime:                                                  *
c         K=1 - initial state: e+ e- res (gamma) (gamma)               *
c         K=2 - all                                                    *
c                                                                      *
c***********************************************************************
      Implicit NONE
c
      include 'ggresrc.inc'
c                  
      Real *8 Sump(4),QSQ(2),EB0,PB
      Integer *4 K,J,J1,NEV,PROD(25),PRODL(25,2),IND
c
      DO J=1,4
        SumP(J)=0.
      END DO 
c
      DO J=1,Npart
        PROD(J)=0   ! for control that there is >= 1 decay product
        PRODL(J,1)=0 
        PRODL(J,2)=0 
      END DO       
c
      IF(K.LT.1.OR.K.GT.2) GOTO 500
c      
c-----------------------------------------------------------------------                                              
c
      PB=DSQRT(EB0**2-EM**2)
      QSQ(1)=2.*EB0*PPART(4,1)-22./TYPE(1)*PB*PPART(3,1)-2.*EM**2 ! Q1 squared
      QSQ(2)=2.*EB0*PPART(4,2)-22./TYPE(2)*PB*PPART(3,2)-2.*EM**2 ! Q2 squared      
c
      IF(K.EQ.1) THEN     ! initial state
c
        Print 211,Nev
c
        DO J1=1,NPART
c
          if(MOTHER(J1).EQ.0) then
            Print 222, J1, TYPE(J1),MOTHER(J1),(PPART(J,J1),J=1,4)
c
            do J=1,4
              SUMP(J)=SUMP(J)+PPART(J,J1)
            end do
c
          end if
c
        END DO
c
        Print 221,Sump
      END IF
c
c-----------------------------------------------------------------------
c
      IF(K.EQ.2) THEN     ! all particles
c
        DO 10 J=4,NPART   ! 1-st do cycle on decay products of resonance
          IND=Mother(J)
          IF(IND.EQ.0) GOTO 10 ! for r.c. photons
          PRODL(IND,1)=J  ! min0 index
          PRODL(IND,2)=J  ! max index
 10     CONTINUE
c                                                                  
        DO 20 J=4,NPART   ! 2-nd do cycle on decay products of resonance
          IND=Mother(J)
          IF(IND.EQ.0) GOTO 20 ! for r.c. photons
            IF(J.LT.PRODL(IND,1)) PRODL(IND,1)=J  ! min index
 20     CONTINUE
c
        Print 225,Nev
c
        DO J1=1,NPART            
c
          IF(PRODL(J1,1).EQ.0) THEN
            IF(J1.LE.2)  Print 224, J1,TYPE(J1),MOTHER(J1), PRODL(J1,1),
     &        PRODL(J1,2),(PPART(J,J1),J=1,4),QSQ(J1)  ! Px, Py, Pz, E,Q^2
                 
            IF(J1.GT.2) Print 224, J1,TYPE(J1),MOTHER(J1), PRODL(J1,1),
     &        PRODL(J1,2),(PPART(J,J1),J=1,4)  ! Px, Py, Pz, E
c
          do J=1,4
            SUMP(J)=SUMP(J)+PPART(J,J1)
          end do
c                                      
          ELSE
          Print 226, J1,TYPE(J1),MOTHER(J1), PRODL(J1,1),PRODL(J1,2),
     &               (PPART(J,J1),J=1,4)  ! Px, Py, Pz, E
          END IF               
c          
        END DO
c
        Print 223,SUMP
c                
      END IF
c     
 211  FORMAT(/,'Event: ',I6,'  Initial state',/,
     & ' No    KF  Orig      Px           Py           Pz            E')
 221  FORMAT(1X,'Sum:',10X,4(1pe13.5)) 
 222  FORMAT(I3,I6,I5,1X,4(1pe13.5))
 223  FORMAT(1X,'Sum(stable part.):',2X,4(1pe13.5))
 224  FORMAT(I3,I6,3I4,5(1pe13.5)) 
 225  FORMAT(/,'Event: ',I6,'   All particles',/,
     &    ' No    KF Orig   Prod      Px           Py           Pz',
     &    '           E        Q^2')
 226  FORMAT('*',I2,I6,3I4,4(1pe13.5))
c
 500  RETURN
      END
      
!
!***********************************************************************
!

      SUBROUTINE GGRINV(S, RM, t1minp, t1maxp, t2minp, t2maxp,
     &                  T1,T2,S1,S2,WEI)
c***********************************************************************
c                                                                      *
c  Simulation of invariants                                            *
c                                                                      *
c  Input: S, RM, t1minp, t1maxp, t2minp, t2maxp                        *
c                                                                      *
c  Output: T1,T2,S1,S2,WEI                                             *
c                                                                      *
c***********************************************************************
      Implicit None
c
      Real *8 S,RM,T1,T2,S1,S2,WEI,t1minp,t1maxp,t2minp,t2maxp,PI,EM
      Real *8 RND,lambda,x,y,z,m,w,m2,w2,beta,wm2,t2min,t2max,dt2,y2,q
      Real *8 a1,b1,del1,t1min,t1max,dt1,y1,nupKW,ds1,Xs1,ffa,ffb,ffdel
      Parameter (EM=0.51099891D-3,PI=3.141592654)
c
      Save
c
      lambda(x,y,z) = (x - y - z)**2  - 4.D0*y*z
c
      W     = rm
      m     = em
      m2    = m*m
      W2    = W*W
      beta  = dsqrt(1d0 - 4d0*m2/s)
c.........
c t2 generation    
      Wm2   = (W + 2d0*m)**2
      t2min=(4d0*m2-s+w2+2.d0*m*w-beta*dsqrt((s-w2)*(s-wm2)))/2d0
      t2max=m2*w2*wm2/s/t2min
      t2max=min(t2max,t2maxp)
c
      IF(t2min.ge.t2max) THEN
        wei=0.
        return
      END IF
c
      IF(t2minp.gt.t2min) THEN
        if(t2minp.ge.t2max) then
          wei=0.
          return
        else
          t2min=t2minp
        end if
      END IF

      dt2   = dlog(t2max/t2min)
c
      CALL GGRRNDM(RND,1)
c
      t2    = t2min*dexp(RND*dt2)
c..........
c t1 generation
      y2    = dsqrt(1d0 - 4d0*m2/t2)
      Q     = 4d0*(s+t2-4d0*m2)/(1d0+beta*y2) - t2 - W2
      a1    = 2d0*(Q+t2+2d0*m2+W2)
      b1    = Q**2-W2**2+2d0*W2*t2-t2**2-8d0*m2*t2-8d0*m2*W2
      Del1  = (Q+t2-W2+4d0*m*W)*(Q+t2-W2-4d0*m*W)*
     &  (Q**2-2d0*Q*t2+2d0*Q*W2+t2**2+W2**2-16d0*m2*t2-2d0*W2*t2)
      t1min = - (b1 + dsqrt(Del1))/2d0/a1
      t1max = 4d0*m2*(W2-t2)**2/(a1*t1min)
      t1max = min(t1max,t1maxp)
c
      if(t1min.ge.t1max) then
        wei=0.
        return
      end if  
c
      IF(t1minp.gt.t1min) THEN
        if(t1minp.ge.t1max) then
          wei=0.
          return
        else
          t1min=t1minp
        end if
      END IF
c
      dt1   = dlog(t1max/t1min)
c
      CALL GGRRNDM(RND,1)
c
      t1  = t1min*dexp(RND*dt1)
c.........
c s1 generation
      y1    = dsqrt(1d0 - 4d0*m2/t1)     
      nupKW = (W2-t1-t2)/2d0 + dsqrt(lambda(W2,t1,t2))/2d0
      ds1   = dlog( s*(1d0+beta)**2/(nupKW*(1d0+y1)*(1d0+y2)) )
c
      CALL GGRRNDM(RND,1)
c
      Xs1   = nupKW*(1d0+y1)*dexp(ds1*RND)
      s1    = Xs1/2d0 + m2 + t2 + 2d0*m2*t2/Xs1
c.........
c s2 generation
      ffa = -2.D0*m**2*s1-2.D0*m**2*t2+m**4+s1**2-2.D0*t2*s1+t2**2
      ffb = -2.D0*m**6+4.D0*m**4*s1-4.D0*m**4*w**2+2.D0*S*t2*w**2-
     &  2.D0*m**2*s1**2+2.D0*m**2*S*w**2+2.D0*t1*S*s1-2.D0*m**2*t2*S+
     &  8.D0*t2*m**4-2.D0*m**2*t2**2-2.D0*t2*m**2*t1+4.D0*m**2*s1*w**2-
     &  2.D0*t2**2*S+2.D0*t1*m**4+2.D0*t1*t2*S+2.D0*S*t2*s1+
     &  2.D0*t1*t2*s1-2.D0*S*s1*w**2-2.D0*t1*s1**2-2.D0*S*m**2*t1
      ffdel = 16.D0*(m**2*t2**2+m**2*w**4-t1*s1*w**2-
     &  2.D0*m**2*t2*w**2+t1*t2*w**2-t1*m**2*w**2-2.D0*t1*m**2*s1-
     &  t1*t2*s1+t1**2*s1+t1*s1**2-t2*m**2*t1+t1*m**4)*(m**2*s1**2-
     &  2.D0*m**4*s1-S*t2*s1-3.D0*m**2*t2*S+t2*S**2+m**6+t2**2*S)
c
      IF(ffdel.lt.0d0) THEN
        wei = 0d0
      ELSE  
c
        CALL GGRRNDM(RND,1)
c
        s2 = (-ffb - dsqrt(ffdel)*dcos(RND*Pi))/(2d0*ffa)
        wei = dt1*dt2*ds1*4.d0*pi
      END IF

      END

! 
!*********************************************************************** 
! 

      FUNCTION GGRFVMDM(T1,T2)
c***********************************************************************
c                                                                      *
c  VMDM factor                                                         *
c                                                                      *
c  T  - momentum transfer in (GeV/c)**2                                *
c  AM - vector meson mass in GeV/c**2                                  *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 T1,T2,AM,GGRFVMDM
c
      Save
c      
      IF(IR.le.3) THEN
        AM=Mrho
        else if(IR.eq.4) then  
          AM=Mjpsi
        else if(IR.eq.5) then
          AM=Mups
        else
          AM=Mrho
      END IF  
c
      GGRFVMDM=1./(1.-T1/AM**2)**2/
     &  (1.-T2/AM**2)**2
c
      END

! 
!*********************************************************************** 
!

      SUBROUTINE GGRLMOM(S,S1,S2,T1,T2,W,FI)
c***********************************************************************
c                                                                      *
c  Calculation of lab. momenta of produced e-, e+, resonance           *
c                                                                      *
c  Angle Teta - from direction of electrons (in +z axis)               *
c                                                                      *
c   Parameters of produced e-,e+, resonance in /GGREV/ in laboratory:  *
c   PPART(1-3,i) - Px,Py,Pz (GeV/c) of e- (i=1), e+(i=2), res.(i=3)    *
c   PPART(4,i)   - their total energy (GeV)                            *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 S,S1,S2,T1,T2,W,FI,E,EM2,PB,EPL,PPL,CTPL,STPL,EMI,PMI
      Real *8 CTMI,STMI,EW,PPW,CTW,STW,PTE,PTP,PTW,CFPL,CFMI,SIG,SFPL
      Real *8 SFMI,FIPL,FIMI,RND
c
      Save
c
      EM2=EM**2
      E=DSQRT(S)/2.
      PB=DSQRT((E+EM)*(E-EM))
c
      EPL=(S-S1+EM2)/4./E             !  e+
      PPL=DSQRT((EPL-EM)*(EPL+EM))
      CTPL=-(E*EPL-EM2+0.5*T2)/PB/PPL
c
      IF(CTPL.le.-1.D0) THEN
        CTPL=-1.D0
        STPL=0.D0
      else if(CTPL.ge.1.D0)then
        CTPL=1.D0
        STPL=0.D0
      else
        STPL=sqrt((1.-CTPL)*(1.+CTPL))
      END IF  
c
      EMI=(S-S2+EM2)/4./E             !  e-
      PMI=DSQRT((EMI-EM)*(EMI+EM))
      CTMI=(E*EMI-EM2+0.5*T1)/PB/PMI
c
      IF(CTMI.le.-1.D0) THEN
        CTMI=-1.D0
        STMI=0.D0
      else if(CTMI.ge.1.D0)then
        CTMI=1.D0
        STMI=0.D0
      else
        STMI=sqrt((1.-CTMI)*(1.+CTMI))
      END IF  
c
      EW=(S1+S2-2*EM2)/4./E           !  resonance
      PPW=DSQRT((EW-W)*(EW+W))
      CTW=(E*EW-0.5*(S1+T1-T2-EM2))/PB/PPW
c
      IF(CTW.le.-1.D0) THEN
        CTW=-1.D0
        STW=0.D0
      else if(CTW.ge.1.D0)then
        CTW=1.D0
        STW=0.D0
      else
        STW=sqrt((1.-CTW)*(1.+CTW))
      END IF        
c
      PTE=PMI*STMI      ! Ptr of e-
      PTP=PPL*STPL      ! Ptr of e+
      PTW=PPW*STW       ! Ptr of res
c
      CFPL=(PTE**2-PTP**2-PTW**2)/2./PTP/PTW        ! cos(fi) of e+
c
      IF(CFPL.le.-1.D0) THEN
        CFPL=-1.D0
        SFPL=0.D0
      else if (CFPL.ge.1.D0) then
        CFPL=1.D0
        SFPL=0.D0
      else
        SFPL=Dsqrt((1.D0-CFPL)*(1.D0+CFPL))
      END IF
c
      SIG=1.
c
      CALL GGRRNDM(RND,1)
c
      IF(RND.GT.0.5) SIG=-1.
c
      SFPL=SIG*SFPL
c
      CFMI=(PTP**2-PTE**2-PTW**2)/2./PTE/PTW        ! cos(fi) of e-
      SFMI=-PTP/PTE*SFPL
      FIPL=DATAN2(SFPL,CFPL)+FI
      FIMI=DATAN2(SFMI,CFMI)+FI      
c......
c   Scattered electron
      PPART(3,1)=PMI*CTMI
      PPART(2,1)=PTE*DSIN(FIMI)
      PPART(1,1)=PTE*DCOS(FIMI)
      PPART(4,1)=EMI
      MPART(1)=EM
      TYPE(1)=11
      MOTHER(1)=0
c.......
c   Scattered positron
      PPART(3,2)=PPL*CTPL
      PPART(2,2)=PTP*DSIN(FIPL)
      PPART(1,2)=PTP*DCOS(FIPL)
      PPART(4,2)=EPL
      MPART(2)=EM
      TYPE(2)=-11
      MOTHER(2)=0
c.......
c   Produced resonance
      PPART(3,3)=PPW*CTW
      PPART(2,3)=PTW*DSIN(FI)
      PPART(1,3)=PTW*DCOS(FI)
      PPART(4,3)=EW
      MPART(3)=W
      TYPE(3)=0
      MOTHER(3)=0
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRPI0D(IMOD)
c***********************************************************************
c                                                                      *
c  Simulation of pi0 decay                                             *
c                                                                      *
c  Input: IMOD =1: pi0 -> 2gamma          (PDG: 98.8%)                 *
c               2: pi0 -> e+ e- gamma     (PDG: 1.2%)                  *
c                                                                      *
c***********************************************************************
      Implicit NONE
c      
      Integer *4 IMOD
c
      IF(IMOD.EQ.1) CALL GGRDEC2G(3) ! pi0 -> 2gamma
c  
      IF(IMOD.EQ.2) CALL GGRPI0D1(3) ! pi0 -> e+ e- gamma
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRDEC2G(IND)
c***********************************************************************
c                                                                      *
c  Isotropic decay of resonance to 2 gamma in lab.system.              *
c                                                                      *
c  Input: IND - index of particle in /GGREV/                           *
c                                                                      *
c  Output: particles in /GGREV/                                        *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 PRES(4),PGAM1(4),PGAM2(4),GG(3),C(3),RND
      Real *8 C_T,S_T,FI,S_F,C_F,EPI,GAM,PREST,E
      Integer *4 IND,I
c
      Save
c
      DO I=1,4
        PRES(I)=PPART(I,IND)
      END DO
c
      CALL GGRRNDM(RND,1)
c
      C_T=-1.+2.*RND
      S_T=DSQRT(DABS(1.D0-C_T**2))
c
      CALL GGRRNDM(RND,1)
c
      FI=2.*PI*RND
      S_F=DSIN(FI)
      C_F=DCOS(FI)
c
      EPI=PRES(4)
      GAM=EPI/MPART(IND) 
      PREST=DSQRT(PRES(1)**2+PRES(2)**2+PRES(3)**2)
      GG(1)=PRES(1)/PREST 
      GG(2)=PRES(2)/PREST
      GG(3)=PRES(3)/PREST
c
      C(1)=C_T
      C(2)=S_T*C_F
      C(3)=S_T*S_F
      E=MPART(IND)/2.
c
      CALL GGRLOR(GG,GAM,C,E,0.D0)
c
      PGAM1(4)=E
      PGAM1(1)=E*C(1)
      PGAM1(2)=E*C(2)
      PGAM1(3)=E*C(3)
c
      C(1)=-C_T
      C(2)=-S_T*C_F
      C(3)=-S_T*S_F
      E=MPART(IND)/2.
c
      CALL GGRLOR(GG,GAM,C,E,0.D0)
c
      PGAM2(4)=E
      PGAM2(1)=E*C(1)
      PGAM2(2)=E*C(2)
      PGAM2(3)=E*C(3)

      DO I=1,4
        PPART(I,NPART+1)=PGAM1(I)
        PPART(I,NPART+2)=PGAM2(I)
      END DO
c
      MPART(NPART+1)=0.d0
      MPART(NPART+2)=0.d0
      type(NPART+1)=22
      type(NPART+2)=22
      mother(NPART+1)=ind
      mother(NPART+2)=ind
      NPART=NPART+2
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRPI0D1(IND)
c***********************************************************************
c                                                                      *
c  Simulation of pi0 -> e+e-gamma /Bukin, ... Prep. Budker INP 77-101/ *
c                                                                      *
c  Input: IND - index of pi0 in /GGREV/                                *
c                                                                      *
c  Output:                                                             *
c                                                                      *
c  Output: particles in /GGREV/                                        *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 CC,R,P
      Integer *4 NP
      Common /GGRARIP324/ CC(4),R(20),P(4,20),NP

      Integer *4 IND,I,I1
      Real*8 GG(3),C(3),GAM,PREST,FMAJ,ELM2,FSPC,RND,EPI,PMASS,ENER,PTOT
      REAL*8 PP(4),PE(4),PGAM(4),QK,PETOT,PPTOT,SS,PMK,PPK,AMSQ,FSPCM,AM
c
      Save
c
      FMAJ=1.5D-6 ! majorant value for decay simulation
      AM=MPI0     ! pi0 mass
c
      DO I=1,3
        CC(I)=0.
      END DO
c
      CC(4)=AM            ! inv. mass of system of particles (pi0)
      R(1)=EM             ! e-
      R(2)=EM             ! e+
      R(3)=0.             ! gamma
      NP=3                ! 3 particles for GGRSPC3
      ELM2=EM**2          ! electron mass squared
c
 1    CALL GGRSPC3(FSPC)  ! pi0 decay at rest
c
c   Matrix element squared in rest system of pi0
c
      PGAM(4)=P(4,3)      ! energy of gamma
      PE(4)=P(4,1)
      PP(4)=P(4,2)
      QK=PGAM(4)*AM
      PETOT=DSQRT(PE(4)**2-ELM2)
      PPTOT=DSQRT(PP(4)**2-ELM2)
c
      DO I=1,3
        PE(I)=PETOT*P(I,1)
        PP(I)=PPTOT*P(I,2)
        PGAM(I)=PGAM(4)*P(I,3)
      END DO
c
      SS=(PE(4)+PP(4))**2 -(PE(1)+PP(1))**2-(PE(2)+PP(2))**2
     .  -(PE(3)+PP(3))**2
      PMK=PE(4)*PGAM(4)-PE(1)*PGAM(1)-PE(2)*PGAM(2)-PE(3)*PGAM(3)
      PPK=PP(4)*PGAM(4)-PP(1)*PGAM(1)-PP(2)*PGAM(2)-PP(3)*PGAM(3)
      AMSQ=QK**2+2.*ELM2/SS*(PMK**2+PPK**2)-2.*(1.-2*ELM2/SS)*PMK*PPK
      FSPCM=FSPC*AMSQ
c
      CALL GGRRNDM(RND,1)
c
      IF(FMAJ*RND.GT.FSPCM) GOTO 1
      IF(FSPCM.GT.FMAJ) PRINT 920, FSPC,FMAJ
c
      EPI=PPART(4,IND)
      GAM=EPI/AM               ! Lorentz-factor of pi0 in lab.
      PREST=DSQRT(PPART(1,IND)**2+PPART(2,IND)**2+PPART(3,IND)**2)
      GG(1)=PPART(1,IND)/PREST ! direction cosines of pi0 in lab.
      GG(2)=PPART(2,IND)/PREST
      GG(3)=PPART(3,IND)/PREST
c
      DO 11 I=1,3
        C(1)=P(1,I)
        C(2)=P(2,I)
        C(3)=P(3,I)
        PMASS=R(I)
        ENER=P(4,I)
c
        CALL GGRLOR(GG,GAM,C,ENER,PMASS)
c
        IF(I.EQ.2) GOTO 12
        IF(I.EQ.3) GOTO 13
c.....
c  e- parameters in lab.
        PTOT=DSQRT(ENER**2-PMASS**2)
        PE(1)=PTOT*C(1)
        PE(2)=PTOT*C(2)
        PE(3)=PTOT*C(3)
        PE(4)=ENER
c
        DO I1=1,4
          PPART(I1,NPART+1)=PE(I1)
        END DO
c
        MPART(NPART+1)=EM
        type(NPART+1)=11
        mother(NPART+1)=ind
        NPART=NPART+1
        GOTO 11
c.....
c  e+ parameters in lab.
 12     PTOT=DSQRT(ENER**2-PMASS**2)
        PP(1)=PTOT*C(1)
        PP(2)=PTOT*C(2)
        PP(3)=PTOT*C(3)
        PP(4)=ENER
c
        DO I1=1,4
          PPART(I1,NPART+1)=PP(I1)
        END DO
c
        MPART(NPART+1)=EM
        type(NPART+1)=-11
        mother(NPART+1)=ind
        NPART=NPART+1
        GOTO 11
c.....
c  gamma parameters in lab.
 13     PTOT=DSQRT(ENER**2-PMASS**2)
        PGAM(1)=PTOT*C(1)
        PGAM(2)=PTOT*C(2)
        PGAM(3)=PTOT*C(3)
        PGAM(4)=ENER
c
        DO I1=1,4
          PPART(I1,NPART+1)=PGAM(I1)
        END DO
c
        MPART(NPART+1)=0.
        type(NPART+1)=22
        mother(NPART+1)=ind
        NPART=NPART+1
 11   CONTINUE
c
 910  Format(' GGRPI0D1:',7(1pE9.1))
 920  Format(' GGRPI0D1: F,Fmaj=',2(1pE10.2))
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRETD(IND,IMOD)
c***********************************************************************
c                                                                      *
c  Simulation of ETA0 decay                                            *
c                                                                      *
c  Input: IND - position of eta in /GGREV/                             *
c                                                                      *
c  IMOD =1: eta -> 2gamma      (PDG: 39.2%)                            *
c        2: eta -> 3pi0        (PDG: 32.2%)                            *
c        3: eta -> pi+pi-pi0   (PDG: 21.3%)                            *
c        4: eta -> pi+pi-gamma (PDG: 4.8%)                             *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 CC,R,P
      Integer *4 NP
      Common /GGRARIP324/ CC(4),R(20),P(4,20),NP
c
      Integer *4 IND,IMOD,i,i1,i2,ty(3),IND0
      Real *8 FMAT,FMAJ,RND,F,Q,T0,Y,PMASS,P1MOM,P2MOM,PGMOM,P1P2
      Real *8 GAM,PREST,GG(3),C(3),ENER,PTOT,P1PG,P2PG
c
      Save
c
      IND0=IND
      FMAT=1.                               ! used to avoid warning
c
      IF(IMOD.EQ.1) THEN                    !   eta -> 2gamma
c
        CALL GGRDEC2G(IND)                  
c
      else if(IMOD.GE.2.AND.IMOD.LE.4) then !   eta -> 3 particles
c
        DO I=1,3
          CC(I)=0.
        END DO
c
        CC(4)=MPART(IND)    !  inv. mass of system of particles
        NP=3
c
        if(IMOD.EQ.2) then
c........
c   eta -> 3pi0             (PDG: 32.2 %)
          R(1)=mpi0
          R(2)=mpi0
          R(3)=mpi0
          ty(1)=111
          ty(2)=111
          ty(3)=111
          FMAT=1.   !  uniform distribution
          FMAJ=3.
        else if(IMOD.eq.3) then
c...........
c  eta -> pi+pi-pi0         (PDG: 21.3%)
          R(1)=mpi
          R(2)=mpi
          R(3)=mpi0
          ty(1)=211
          ty(2)=-211
          ty(3)=111
          FMAJ=1.
        else if(IMOD.eq.4) then
c.........
c  eta -> pi+pi-gamma       (PDG: 4.8%)
          R(1)=mpi
          R(2)=mpi
          R(3)=0.
          ty(1)=211
          ty(2)=-211
          ty(3)=22
          FMAJ=5.E-5
        else
          GOTO 500
        end if
c
 1      CALL GGRSPC3(F)
c
        CALL GGRRNDM(RND,1)
c
        if(IMOD.EQ.3) then
c
c  |M|^2 for decay  eta -> pi+pi-pi0: /M.Gormley e.a., PR D2(1970)501/
c
          Q=MPART(IND)-R(1)-R(2)-R(3)
          T0=P(4,3)-mpi0               ! kin.energy of pi0
          Y=3.*(T0/Q-1.)
          FMAT=1.-1.15*Y+0.16*Y**2
        else if(IMOD.EQ.4) then
c
c   Mat.element**2. for decay  eta -> pi+pi-gamma
c    /A.D.Bukin, S.I.Eidelman, Preprint Budker INP 77-101/
c
          P1MOM=SQRT(P(4,1)**2-mpi**2)     ! pi+ momentum
          P2MOM=SQRT(P(4,2)**2-mpi**2)     ! pi- ........
          PGMOM=P(4,3)                     ! gamma ......
          P1P2=P(4,1)*P(4,2)-P1MOM*P2MOM*
     &      (P(1,1)*P(1,2)+P(2,1)*P(2,2)+P(3,1)*P(3,2))
          P1PG=P(4,1)*P(4,3)-P1MOM*PGMOM*
     &      (P(1,1)*P(1,3)+P(2,1)*P(2,3)+P(3,1)*P(3,3))
          P2PG=P(4,2)*P(4,3)-P2MOM*PGMOM*
     &      (P(1,2)*P(1,3)+P(2,2)*P(2,3)+P(3,2)*P(3,3))
          FMAT=2*P1P2*P1PG*P2PG-mpi**2*(P1PG**2+P2PG**2)
        end if
c
        if(FMAJ*RND.GT.F*FMAT ) goto 1
        if(F*FMAT.GT.FMAJ) PRINT 920, F*FMAT,FMAJ
c
        GAM=PPART(4,ind)/MPART(ind)  ! Lorentz-fact. of resonance in lab.
        PREST=
     &    DSQRT(PPART(1,ind)**2+PPART(2,ind)**2+PPART(3,ind)**2)
        GG(1)=PPART(1,ind)/PREST     ! direction cosines in lab.
        GG(2)=PPART(2,ind)/PREST
        GG(3)=PPART(3,ind)/PREST
c
        DO I=1,3
          npart=npart+1
          MOTHER(npart)=IND0
          TYPE(npart)=ty(i)
          MPART(npart)=R(I)
          PMASS=R(I)
          C(1)=P(1,I)
          C(2)=P(2,I)
          C(3)=P(3,I)
          ENER=P(4,I)
c
          CALL GGRLOR(GG,GAM,C,ENER,PMASS)
c
          PTOT=DSQRT(ENER**2-R(I)**2)
          PPART(4,npart)=ENER
          PPART(1,npart)=PTOT*C(1)
          PPART(2,npart)=PTOT*C(2)
          PPART(3,npart)=PTOT*C(3)
        END DO
c
        I1=npart-2
        I2=npart
c
        DO I=I1,I2
          IF(TYPE(I).eq.111) CALL GGRDEC2G(I) ! pi0 decay to 2gamma
        END DO
c
      END IF
c
 920  Format(' GGRDEC3: F,Fmaj=',2(1pE10.2))
 500  RETURN
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRETCD(IND,IMOD)
c***********************************************************************
c                                                                      *
c  Simulation of ETAC decay                                            *
c                                                                      *
c  Input: IND - position of eta_c in /GGREV/                           *
c                                                                      *
c  IMOD =1: etac -> KS K+ pi-                                          *
c  IMOD =2: etac -> 2gamma                                             *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 CC,R,P
      Integer *4 NP
      Common /GGRARIP324/ CC(4),R(20),P(4,20),NP

      Integer *4 IND,IMOD,I,ty(3),IND0
      Real *8 FMAT,FMAJ,RND,F,PMASS,GAM,PREST,GG(3),C(3),ENER,PTOT
c
      Save
c
      IND0=IND
      FMAT=1.                  ! used to avoid warning
c
      IF(IMOD.EQ.2) THEN
c
        CALL GGRDEC2G(3)       ! eta_c -> 2gamma
c
        GOTO 500
      END IF
c
      IF(IMOD.EQ.1)THEN    !   etac -> KS K+pi- phase space 
c
        DO I=1,3
          CC(I)=0.
        END DO
c
        CC(4)=MPART(IND)    !  inv. mass of system of particles
        NP=3
        R(1)=mks
        R(2)=mkc
        R(3)=mpi
        ty(1)=310
c
        CALL GGRRNDM(RND,1)
c
        if(rnd.gt.0.5)then
          ty(2)=321
          ty(3)=-211
        else
          ty(2)=-321
          ty(3)=211
        end if  
c
        FMAT=1.   !  uniform distribution
        FMAJ=12.
c
 1      CALL GGRSPC3(F)
c
        CALL GGRRNDM(RND,1)
c
        IF(FMAJ*RND.GT.F*FMAT ) GOTO 1
        IF(F*FMAT.GT.FMAJ) PRINT 920, F*FMAT,FMAJ
c..........
        GAM=PPART(4,ind)/MPART(ind) ! Lorentz-fact. of resonance in lab.
        PREST=
     &    DSQRT(PPART(1,ind)**2+PPART(2,ind)**2+PPART(3,ind)**2)
        GG(1)=PPART(1,ind)/PREST    ! direction cosines in lab.
        GG(2)=PPART(2,ind)/PREST
        GG(3)=PPART(3,ind)/PREST
c
        DO I=1,3
          npart=npart+1
          MOTHER(npart)=IND0
          TYPE(npart)=ty(i)
          MPART(npart)=R(I)
          PMASS=R(I)
          C(1)=P(1,I)
          C(2)=P(2,I)
          C(3)=P(3,I)
          ENER=P(4,I)
c
          CALL GGRLOR(GG,GAM,C,ENER,PMASS)
c
          PTOT=DSQRT(ENER**2-R(I)**2)
          PPART(4,npart)=ENER
          PPART(1,npart)=PTOT*C(1)
          PPART(2,npart)=PTOT*C(2)
          PPART(3,npart)=PTOT*C(3)
        END DO
c
      ELSE
        GOTO 500
      END IF
c
 920  Format(' GGRETCD: F,Fmaj=',2(1pE10.2))
c
 500  RETURN
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRET1D(ind,IMOD)
c***********************************************************************
c                                                                      *
c  Simulation of eta' decays                                           *
c                                                                      *
c  Input: IND  - index of eta' in /GGREV/                              *
c         IMOD - decay mode                                            *
c                                                                      *
c   IMOD=decay mode:                                                   *
c        1  - eta' -> 2gamma,                                          *
c        2  - eta' -> pi+ pi- eta (eta->2gamma)                        *
c        3  - eta' -> pi+ pi- eta (eta ->3pi0, pi0->2gamma)            *
c        4  - eta' -> pi+ pi- eta (eta ->pi+ pi- pi0, pi0->2gamma)     *
c        5  - eta' -> pi+ pi- eta (eta ->pi+ pi- gamma)                *
c        6  - eta' -> pi0 pi0 eta (eta ->2gamma)                       *
c        7  - eta' -> pi0 pi0 eta (eta ->3pi0, pi0->2gamma)            *
c        8  - eta' -> pi0 pi0 eta (eta ->pi+ pi- pi0, pi0->2gamma)     *
c        9  - eta' -> pi0 pi0 eta (eta ->pi+ pi- gamma)                *  
c       10  - eta' -> rho0 gamma (rho0 ->pi+ pi-)                      *
c                                                                      *
c   In /GGREV/ this subr. adds for i=4,... (or i=5,...):               *
c   PPART(1-3,i) - moments (GeV/c) of particles from resonance decay   *
c   PPART(4,i)   - their total energy (GeV)                            *
c   PPART(5,i)   - their GEANT types                                   *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c      
      Integer *4 IND,IMOD,NN
c
      Save
c
      IF(IMOD.EQ.1)THEN                    !    eta' -> 2gamma
c
        CALL GGRDEC2G(IND)
c
      else if(imod.ge.2.and.imod.le.5)then ! eta' -> pi+ pi- eta
c
        CALL GGRET1D1(ind,1)
c
        CALL GGRETD(npart,imod-1)
c
      else if(imod.ge.6.and.imod.le.9)then !   eta' -> pi0 pi0 eta
c
        CALL GGRET1D1(ind,2)
c
        nn=npart
c
        CALL GGRDEC2G(nn-2)
c
        CALL GGRDEC2G(nn-1)
c
        call GGRETD(nn,imod-5)
c
      else if(imod.eq.10)then
c
        CALL GGRET1D2(ind)        !   eta' -> rh0 gamma (rho->pi+pi-)
c
      END IF  
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRET1D1(IND,IMOD)
c***********************************************************************
c                                                                      *
c   Decays eta' -> pi+ pi- eta (IMOD=1)                                *
c                  pi0 pi0 eta (IMOD=2)                                *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 CC,R,P
      Integer *4 NP
      Common /GGRARIP324/ CC(4),R(20),P(4,20),NP

      Integer *4 IND,IMOD,TY(3),I
      Real *8 FSPC,Fmaj,ENER1,ENER2,ENER3,y,AMELSQ,F,RND
      Real *8 GAM,PREST,GG(3),PMASS,ENER,C(3),PTOT
c
      Save
c
      DO I=1,3
        CC(I)=0.
      END DO
c
      CC(4)=MPART(IND) ! inv. mass of system of particles (eta')
      NP=3             ! particles from eta' decay
c
      IF(IMOD.eq.1)then
        R(1)=mpi  
        R(2)=mpi
        R(3)=meta
        ty(1)=211
        ty(2)=-211
        ty(3)=221
        FMAJ=6.D-2
      else if(IMOD.eq.2)then
        R(1)=mpi0  
        R(2)=mpi0
        R(3)=meta
        ty(1)=111
        ty(2)=111
        ty(3)=221
        FMAJ=6.D-2
      else
        GOTO 500
      END IF  
c
 1    CALL GGRSPC3(FSPC)
c
c  |M|**2 for eta' -> eta pi pi (G.R.Kalbfleisch, PR D10(1974)916), PDG2000
c
      ENER1=P(4,1)-R(1)   ! Ekin for pi
      ENER2=P(4,2)-R(2)
      ENER3=P(4,3)-R(3)   ! Ekin for eta
c
      y=(2*ENER3-ENER1-ENER2)/(ENER1+ENER2+ENER3)
      AMELSQ=(1-0.058*y)**2
c
      CALL GGRRNDM(RND,1)
c
      F=FSPC*AMELSQ
      IF(FMAJ*RND.GT.F) GOTO 1
      IF(F.GT.FMAJ) PRINT 920, F,FMAJ
c
      GAM=PPART(4,ind)/MPART(ind) ! Lorentz-fac. of eta' res. in lab.  
      PREST=DSQRT(PPART(1,ind)**2+PPART(2,ind)**2+PPART(3,ind)**2)
      GG(1)=PPART(1,ind)/PREST    ! direction cosines of eta' in lab.
      GG(2)=PPART(2,ind)/PREST
      GG(3)=PPART(3,ind)/PREST
c
      DO I=1,3
        C(1)=P(1,I)
        C(2)=P(2,I)
        C(3)=P(3,I)
        PMASS=R(I)
        ENER=P(4,I)
c
        CALL GGRLOR(GG,GAM,C,ENER,PMASS)
c
        npart=npart+1
        PPART(4,npart)=ENER
        PTOT=DSQRT(ENER**2-PMASS**2)
        PPART(1,npart)=PTOT*C(1)
        PPART(2,npart)=PTOT*C(2)
        PPART(3,npart)=PTOT*C(3)
        MPART(npart)=PMASS
        TYPE(npart)=ty(i)
        MOTHER(npart)=ind
c
      END DO
c
 920  Format(' GGRET1D1: F,Fmaj=',2(1pE10.2))
c
 500  RETURN
c 
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRET1D2(IND)
c***********************************************************************
c                                                                      *
c  Decay eta' -> rh0 gamma                                             *
c                                                                      *
c    Input:                                                            *
c                                                                      *
c    PRES(4) - lab.4-momentum of eta'                                  *
c                                                                      *
c    Output:                                                           *
c                                                                      *
c    P1(4) - lab.4-momentum of pi+                                     *
c    P2(4) - lab.4-momentum of pi-                                     *
c    P2(4) - lab.4-momentum of gamma                                   *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 CC,R,P
      Integer *4 NP
      Common /GGRARIP324/ CC(4),R(20),P(4,20),NP
c
      Integer *4 IND,I
      Real *8 RHOM,RHOG,RND
      Parameter (RHOM=0.77549,RHOG=0.1494)
      Real *8 FSPC,e0,p0,fmaj,P1TOT,P2TOT,P2PI(4),EPIPI,AMPIPI
      Real *8 GAM,PPIPI,PREST,GG(3),C(3),E
      Real *8 P1A(4),PTOT,P3A(4),PPI,CT,ST2,FAC,AMELSQ,F      
c
      R(1)=mpi   ! pi+ mass
      R(2)=mpi   ! pi- mass
      R(3)=0.    ! gamma mass
      E0=mrho/2.
      P0=DSQRT(E0**2-mpi**2)   ! mom. of pi for M(pipi)=M(rho)
      FMAJ=0.5
c
      DO I=1,3
        CC(I)=0.
      END DO
c
      CC(4)=MPART(ind) ! inv. mass of system of particles (eta')
      NP=3             ! particles from eta' decay
c
c  At first - decay in eta' system
c
 1    CALL GGRSPC3(FSPC)
c
      P1TOT=DSQRT(P(4,1)**2-mpi**2)
      P2TOT=DSQRT(P(4,2)**2-mpi**2)
c
      DO I=1,3
	P2PI(I)=P1TOT*P(I,1)+P2TOT*P(I,2)  ! 3-momentum of pi+pi- system
      END DO
c
      P2PI(4)=P(4,1)+P(4,2)                ! energy of pi+pi- system
c
      EPIPI=P2PI(4)
      AMPIPI=DSQRT(EPIPI**2-P2PI(1)**2-P2PI(2)**2-P2PI(3)**2) ! mass pi+pi-
c
c   Lorentz transformation for pi+, gamma to pipi-system
c
      GAM=EPIPI/AMPIPI      ! Lorentz-factor of pipi in eta'-system
      PPIPI=DSQRT(P2PI(1)**2+P2PI(2)**2+P2PI(3)**2)
c
      DO I=1,3
        GG(I)=P2PI(I)/PPIPI ! direction cosines of pipi in eta'-system
	C(I)=P(I,1)         ! dir. cos of pi+
      END DO
c
      E=P(4,1)              ! energy of pi+
c
      CALL GGRLOR(GG,GAM,C,E,mpi)
c
      P1A(4)=E                     !  pi+ parameters in pipi-system
      PTOT=DSQRT(E**2-mpi**2)
      P1A(1)=PTOT*C(1)
      P1A(2)=PTOT*C(2)
      P1A(3)=PTOT*C(3)
c
      E=P(4,3)                     ! energy of photon
c
      DO I=1,3
	C(I)=P(I,3)
      END DO
c
      CALL GGRLOR(GG,GAM,C,E,0.D0)
c
      P3A(1)=E*C(1)   !  photon parameters in pipi-system
      P3A(2)=E*C(2)
      P3A(3)=E*C(3)
      P3A(4)=E
c
c   |M|**2 calculation
c
      PPI=DSQRT(P1A(1)**2+P1A(2)**2+P1A(3)**2)
      CT=(P1A(1)*P3A(1)+P1A(2)*P3A(2)+P1A(3)*P3A(3))/PPI/E
      ST2=DSQRT(1.-CT**2)
      GAM=RHOG*(PPI/P0)**3*2*P0**2/(PPI**2+P0**2)
      FAC=1./((AMPIPI**2-RHOM**2)**2+(RHOM*GAM)**2)
      AMELSQ=PPI**2*E**2*AMPIPI**2*ST2*FAC ! |M|**2 for eta' -> pi+ pi- gamma
c
      CALL GGRRNDM(RND,1)
c
      F=FSPC*AMELSQ
      IF(FMAJ*RND.GT.F) GOTO 1
      IF(F.GT.FMAJ) PRINT 920, F,FMAJ
c
c   Transformation of parameters of pi+ pi- gamma to lab.
c
      GAM=PPART(4,ind)/MPART(ind) ! Lorentz-factor of eta' res. in lab.
      PREST=DSQRT(PPART(1,ind)**2+PPART(2,ind)**2+PPART(3,ind)**2)
      GG(1)=PPART(1,ind)/PREST ! direction cosines of eta' in lab.
      GG(2)=PPART(2,ind)/PREST
      GG(3)=PPART(3,ind)/PREST
c
c  pi+
c
      DO I=1,3
        C(I)=P(I,1)
      END DO
c
      E=P(4,1)
c
      CALL GGRLOR(GG,GAM,C,E,mpi)
c
      npart=npart+1
      PPART(4,npart)=E                     !  pi+ parameters in lab
      PTOT=DSQRT(E**2-mpi**2)
      PPART(1,npart)=PTOT*C(1)
      PPART(2,npart)=PTOT*C(2)
      PPART(3,npart)=PTOT*C(3)
      MPART(npart)=mpi
      TYPE(npart)=211
      MOTHER(npart)=ind
c
c  pi-
c
      DO I=1,3
        C(I)=P(I,2)
      END DO
c
      E=P(4,2)
c
      CALL GGRLOR(GG,GAM,C,E,mpi)
c
      npart=npart+1
      PPART(4,npart)=E                     !  pi- parameters in lab
      PTOT=DSQRT(E**2-mpi**2)
      PPART(1,npart)=PTOT*C(1)
      PPART(2,npart)=PTOT*C(2)
      PPART(3,npart)=PTOT*C(3)
      MPART(npart)=mpi
      TYPE(npart)=-211
      MOTHER(npart)=ind
c
c  photon
c
      DO I=1,3
        C(I)=P(I,3)
      END DO
c
      E=P(4,3)
c
      CALL GGRLOR(GG,GAM,C,E,0.D0)
c
      npart=npart+1
      PPART(4,npart)=E                     !  photon parameters in lab
      PTOT=DSQRT(E**2-mpi**2)
      PPART(1,npart)=PTOT*C(1)
      PPART(2,npart)=PTOT*C(2)
      PPART(3,npart)=PTOT*C(3)
      MPART(npart)=0.
      TYPE(npart)=22
      MOTHER(npart)=ind
c
 920  Format(' GGRET1D2: F,Fmaj=',2(1pE10.2))
      END

! 
!***********************************************************************
! 

      SUBROUTINE GGRLOR(GG,GAM,C,E,R)
c***********************************************************************
c                                                                      *
c   Lorentz transformation to the lab. system                          *
c                                                                      *
c   Input:                                                             *
c                                                                      *
c   GG(3) - cosines of moving system in lab.                           *
c   GAM   - gamma-factor of moving system                              *
c   C(3)  - cosines of particle in moving system                       *
c   E     - energy of particle in moving system                        *
c   R     - mass of particle                                           *
c                                                                      *
c   Output:                                                            *
c                                                                      *
c   C(3)  - cosines of particle in lab.syst.                           *
c   E     - energy of particle in lab.system                           *
c                                                                      *
c***********************************************************************
      Implicit NONE
c
      Real *8 GG(3),GAM,C(3),E,R,P_LAB(3),E_CM,P_CM,F,E_LAB,P_LABT
c
      Save
c
      E_CM=E                 ! part. energy in cms
      P_CM=DSQRT(E**2-R**2)  ! part. mom in cms
      F=P_CM*DSQRT(GAM**2-1.)*(C(1)*GG(1)+C(2)*GG(2)+C(3)*GG(3))
      E_LAB=GAM*E_CM+F
      F=(E_LAB+E_CM)*DSQRT(GAM**2-1.)/(GAM+1.)
c
      P_LAB(1)=P_CM*C(1)+F*GG(1)
      P_LAB(2)=P_CM*C(2)+F*GG(2)
      P_LAB(3)=P_CM*C(3)+F*GG(3)
      P_LABT=DSQRT(P_LAB(1)**2+P_LAB(2)**2+P_LAB(3)**2)
c
c  Output variables
c
      C(1)=P_LAB(1)/P_LABT
      C(2)=P_LAB(2)/P_LABT
      C(3)=P_LAB(3)/P_LABT
      E=E_LAB
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRSPC3(WSPC)
c************************************************************************
c                                                                       *
c   Calculation of weight of phase volume for 3 particles               *
c   and momenta of particles                                            *
c                                                                       *
c  Input:                                                               *
c         NP       - number of particles                                *
c         R(1-NP)  - masses of particles (GeV/c**2)                     *
c         CC(1-4)  - initial 4-momentum (P,E) of the system in lab.     *
c                                                                       *
c  Output:                                                              *
c          WSPC - weight, in /GGRPRT/:                                  *
c          P(1-3,.) - direction cosines of part. in init. system        *
c          P(4,.) - energy of part. in init. system (GeV)               *
c                                                                       *
c  Version for 3 particles                                              *
c                                                                       *
c************************************************************************
c
      Implicit NONE
c
      Integer *4 ND
      Parameter (ND=201)             !  ND=1/SKSI+1
c
      Real *8 CC,R,P
      Integer *4 NP
      Common /GGRARIP324/ CC(4),R(20),P(4,20),NP
c
      Real *8 WSPC,A(201),COMPO(3),COMP(3),CP(3),EFM(20),SKSI,PI
      Real *8 COEF,OM,RMU,TK,T,T1,TP1,PSI,Z,PIMPO,ETA,FI,GR
      Real *8 TP3,TP4,RAN,RAND,OMO,TP2
      Integer *4 IAITR,N,N1,I,I1,I2,I3,I4,K,K1,ITRUE
c
      Save 
c
      Data IAITR/1/
c
      Data A/
     &0.000000000D+00,5.993056109D-04,1.692539021D-03,3.104693703D-03,
     &4.772740940D-03,6.659960849D-03,8.741382470D-03,1.099853020D-02,
     &1.341697675D-02,1.598502356D-02,1.869291643D-02,2.153234559D-02,
     &2.449610963D-02,2.757788003D-02,3.077203057D-02,3.407351014D-02,
     &3.747774582D-02,4.098056744D-02,4.457814791D-02,4.826695524D-02,
     &5.204371351D-02,5.590537076D-02,5.984907220D-02,6.387213779D-02,
     &6.797204317D-02,7.214640342D-02,7.639295912D-02,8.070956423D-02,
     &8.509417561D-02,8.954484378D-02,9.405970487D-02,9.863697343D-02,
     &1.032749361D-01,1.079719459D-01,1.127264174D-01,1.175368218D-01,
     &1.224016831D-01,1.273195743D-01,1.322891143D-01,1.373089643D-01,
     &1.423778256D-01,1.474944368D-01,1.526575715D-01,1.578660360D-01,
     &1.631186677D-01,1.684143331D-01,1.737519260D-01,1.791303662D-01,
     &1.845485977D-01,1.900055878D-01,1.955003258D-01,2.010318213D-01,
     &2.065991038D-01,2.122012213D-01,2.178372395D-01,2.235062408D-01,
     &2.292073237D-01,2.349396015D-01,2.407022023D-01,2.464942676D-01,
     &2.523149521D-01,2.581634227D-01,2.640388585D-01,2.699404494D-01,
     &2.758673964D-01,2.818189104D-01,2.877942124D-01,2.937925323D-01,
     &2.998131090D-01,3.058551900D-01,3.119180303D-01,3.180008931D-01,
     &3.241030485D-01,3.302237735D-01,3.363623519D-01,3.425180735D-01,
     &3.486902342D-01,3.548781353D-01,3.610810836D-01,3.672983908D-01,
     &3.735293736D-01,3.797733528D-01,3.860296538D-01,3.922976058D-01,
     &3.985765417D-01,4.048657980D-01,4.111647144D-01,4.174726337D-01,
     &4.237889014D-01,4.301128657D-01,4.364438771D-01,4.427812883D-01,
     &4.491244540D-01,4.554727305D-01,4.618254759D-01,4.681820495D-01,
     &4.745418117D-01,4.809041239D-01,4.872683484D-01,4.936338480D-01,
     &4.999999858D-01,5.063661251D-01,5.127316293D-01,5.190958616D-01,
     &5.254581848D-01,5.318179610D-01,5.381745517D-01,5.445273174D-01,
     &5.508756173D-01,5.572188095D-01,5.635562503D-01,5.698872945D-01,
     &5.762112947D-01,5.825276014D-01,5.888355628D-01,5.951345246D-01,
     &6.014238293D-01,6.077028168D-01,6.139708235D-01,6.202271824D-01,
     &6.264712227D-01,6.327022696D-01,6.389196442D-01,6.451226631D-01,
     &6.513106379D-01,6.574828755D-01,6.636386773D-01,6.697773390D-01,
     &6.758981505D-01,6.820003956D-01,6.880833513D-01,6.941462879D-01,
     &7.001884682D-01,7.062091476D-01,7.122075734D-01,7.181829846D-01,
     &7.241346111D-01,7.300616738D-01,7.359633837D-01,7.418389418D-01,
     &7.476875381D-01,7.535083515D-01,7.593005491D-01,7.650632856D-01,
     &7.707957025D-01,7.764969277D-01,7.821660749D-01,7.878022423D-01,
     &7.934045124D-01,7.989719510D-01,8.045036060D-01,8.099985070D-01,
     &8.154556636D-01,8.208740652D-01,8.262526788D-01,8.315904488D-01,
     &8.368862949D-01,8.421391109D-01,8.473477633D-01,8.525110895D-01,
     &8.576278959D-01,8.626969561D-01,8.677170087D-01,8.726867550D-01,
     &8.776048564D-01,8.824699316D-01,8.872805538D-01,8.920352470D-01,
     &8.967324824D-01,9.013706746D-01,9.059481767D-01,9.104632754D-01,
     &9.149141853D-01,9.192990424D-01,9.236158975D-01,9.278627075D-01,
     &9.320373262D-01,9.361374945D-01,9.401608274D-01,9.441048006D-01,
     &9.479667342D-01,9.517437735D-01,9.554328665D-01,9.590307376D-01,
     &9.625338547D-01,9.659383909D-01,9.692401763D-01,9.724346379D-01,
     &9.755167249D-01,9.784808113D-01,9.813205689D-01,9.839934511D-01,
     &9.865615600D-01,9.889800747D-01,9.912372969D-01,9.933188000D-01,
     &9.952061097D-01,9.968742598D-01,9.982865594D-01,9.993803097D-01,
     &9.999999989D-01/
c
      IF(IAITR.EQ.0) GOTO 25
c
      IAITR=0
      SKSI=1./(ND-1)  ! SKSI - step in ksi
      PI=DACOS(-1.D0)
c
c--- Preliminary calculations ---------------------------------------
c
 25   COEF=1.D0               ! beginning of simulation
      ITRUE=0
      TP1=0.
c
      DO I=1,3
        CP(I)=CC(I)           ! CC(1-3) momentum of gg-system
        TP1=TP1+CP(I)*CP(I)   !
      END DO
c
      OM=CC(4)                ! energy of gg-system in lab
      IF(TP1.GT.0.) GOTO 26 
      EFM(NP)=CC(4)           ! M_eff for gg system in rest
      GOTO 27
c
 26   TP1=OM*OM-TP1           ! (E1+ E2)**2-(P1 + P2)**2=M_eff**2
      PRINT 80, TP1
c
      IF(TP1.LT.0.) THEN
        PRINT 80, TP1
        STOP
      END IF
c
      EFM(NP)=DSQRT(TP1)   ! eff. mass for moving gg-system
 27   RMU=R(1)             ! 1-st particle mass
c
      DO I=2,NP
        RMU=RMU+R(I)       ! RMU=sum of particle masses
      END DO
c
      TK=EFM(NP)-RMU      ! energy deposition in c.m.s.
      TP1=TK**((3.*NP-5.)/2.)/(2.*EFM(NP))  ! factor
c
      COEF=COEF*TP1
c
      N=NP  ! N=number of particles
      N1=N/2
c
      IF(2*N1-N) 51,53,51
c
 51   N1=3*(N-1)/2         ! N - odd
      T=PI**N1
      N1=N1-1
      T1=1.
c
      DO I=1,N1
        T1=T1*I
      END DO
c
      T=T/T1               ! T - factor for odd N
      GOTO 55
c
 53   T=PI**(3*(N-1)/2.)   ! N - even
      N1=3*N/2-2
      T1=DSQRT(PI)/2.
c
      DO I=2,N1
        T1=T1*(2*I-1)/2.
      END DO
c
      T=T/T1                ! T - factor for even N
c
 55   TP1=T
c
      COEF=COEF*TP1         ! new COEF
 3    I=NP-1                ! I = number of particles - 1
c
c--------------- Recurrence part ------------------------------------
c
      DO 12 I1=1,I          ! recurrence part of algorithm
      I2=NP+1-I1            ! I2=NP,NP-1,...,2
      TP1=TK                ! energy deposition
      I3=I2-1               ! I3=NP-1,..,1
c
      IF(I2-2) 4,4,5
c
 4    TK=0.                 !
      GOTO 6                ! end of recurrence part. I2=2
c
 5    CONTINUE              ! I2=3,... , I3=2,...
c
      K=I3
      K1=K-1                ! K1=NP-2,...,1
c
      IF(K1.LT.1.OR.K1.GT.18) PRINT 102, K
      IF(K1.LT.1.OR.K1.GT.18) STOP
c
      CALL GGRRNDM(RAN,1)
c
      DO 62 I=2,ND
        Z=A(I)
c
        IF(RAN-Z) 61,62,62
c
 61     Z=SKSI*(I-1-(RAN-Z)/(A(I-1)-Z)) ! K4: Z=ksi_k-1
        GOTO 63
 62   CONTINUE
c
 63   PSI=Z
c
      TK=TK*PSI             ! T_k-1=T_k*ksi_k-1
 6    RMU=RMU-R(I2)         ! K5: rest mass of particles 1,2,...,k-1
      TP1=TP1-TK            !
c
      IF(TP1-1.E-11) 25,70,70
c
 70   TP1=DSQRT(TP1)        ! factor for coefficient in weight
c
 7    COEF=COEF/TP1
      EFM(I3)=RMU+TK        ! K6: eff.mass of compound-particle O_k-1
      TP1=R(I2)*R(I2)       ! mass**2 of k-th particle
      OMO=(EFM(I2)*EFM(I2)+TP1-EFM(I3)*EFM(I3))/(2.*EFM(I2)) ! K7:
      PIMPO=OMO**2-TP1      ! energy and mom.**2 of k-th particle in O_k
c
      IF(PIMPO-1.E-11) 25,71,71
c
 71   PIMPO=DSQRT(PIMPO)     ! momentum of k-th particle in O_k
      COEF=COEF*PIMPO        ! factor for coefficient in weight
c
      CALL GGRRNDM(RAND,1)   ! K8:
c
      ETA=-1.+2.*RAND        ! cos(theta) simulation
c
      CALL GGRRNDM(RAND,1)   ! K9:
c
      FI=2.*PI*RAND          ! phi simulation
      TP2=1.-ETA**2          !
c
      IF(TP2-1.E-11) 30,31,31
c
 30   TP2=0.
      GOTO 32
c
 31   TP2=DSQRT(TP2)         ! K10:
c
 32   TP2=TP2*PIMPO
      COMPO(3)=ETA*PIMPO     ! Px 
      COMPO(1)=TP2*COS(FI)   ! Py
      COMPO(2)=TP2*SIN(FI)   ! Pz
c
      TP2=0.                 ! K11:
c
      DO I4=1,3
        TP2=TP2+COMPO(I4)*CP(I4)
      END DO
c
      P(4,I2)=(OM*OMO+TP2)/EFM(I2)   ! k-th particle energy in init. sys.
      GR=(P(4,I2)+OMO)/(OM+EFM(I2))  ! factor for Lorentz transformation
c
      DO I4=1,3                      ! K12:
        COMP(I4)=COMPO(I4)+CP(I4)*GR ! particle 3-momentum in init.syst.
      END DO
c
      TP2=P(4,I2)**2-TP1             ! mom.**2 of k-th part. in init.sys.
      IF(TP2-1.E-11) 33,34,34
c
 33   TP2=0.
      P(3,I2)=1.
      P(1,I2)=0.
      P(2,I2)=0.
      GOTO 101
c
 34   TP2=dsqrt(TP2)
c
 35   DO I4=1,3
        P(I4,I2)=COMP(I4)/TP2        ! dir. cos. of k-th part. in init.s.
      END DO
c
 101  OM=OM-P(4,I2)                  ! K13: en. of part. system in init. r.f.
c
      DO I4=1,3
        CP(I4)=CP(I4)-COMP(I4)    ! 3-momentum of 1,..,k-1 part. in init.r.f.
      END DO
c
      IF(I2-2) 13,13,12
c
 12   CONTINUE ! -------- end of recurrence procedure -----------
c
c
 13   DO I4=1,3         ! K14: last particle
        COMP(I4)=CP(I4)   ! 3-momentum of particle in init. r.f.
      END DO
c
      P(4,1)=OM         ! energy of last particle
      TP3=0.
c
      DO I4=1,3
        TP3=TP3+COMP(I4)*COMP(I4)
      END DO
c
      IF(TP3-1.E-11) 36,37,37
 36   TP4=0.
      P(3,1)=1.
      P(1,1)=0.
      P(2,1)=0.
      GOTO 41
c
 37   TP4=dsqrt(TP3)
c
 38   DO I4=1,3
        P(I4,1)=COMP(I4)/TP4   ! direction cosines of last particle
      END DO
c
 41   WSPC=COEF                ! weight of point
c
 80   Format(/,' ****** GGRSPC3: TP1=',E12.5,/)
 102  Format(' GGRSPC3: Call with wrong K: K=',I5,' out of 2-19')
 
      END

! 
!*********************************************************************** 
! 

      FUNCTION GGRPOLAR(t)
c***********************************************************************
c                                                                      *
c   Vacuum polarization of photon for correction of propagator         *
c                                                                      *
c   Input: t - invariant: t1 or t2                                     *
c                                                                      *
c   Output: GGRPOLAR - vacuum polarization                             *
c                                                                      *
c***********************************************************************
      Implicit NONE   
      Include 'ggresrc.inc'
c      
      Integer *4 I,N1,N2
      Real *8 GGRPOLAR,t
c
      Save
c
      N1=3665
      N2=3665
c
      DO i=1,17
        if(sets(n1).lt.t) then
          n2=abs(n2)/2
          if((t.gt.sets(n1+1)).and.(n2.eq.0)) then
            n2=1
          end if
        end if
c
        if(sets(n1).gt.t) then
          n2=-abs(n2)/2
          if(n2.eq.0) then
            n2=-1
          end if
        end if
c
        if(sets(n1).eq.t) then
          n2=0
        end if
c
        n1=n1+n2
c        print *,'n2=',n2
      END DO
c
      GGRPOLAR=setpol(n1)+(setpol(n1+1)-setpol(n1))/
     &         (sets(n1+1)-sets(n1))*(t-sets(n1))
c
      END

!      
!***********************************************************************
!

      SUBROUTINE GGRFSR(t2)
c***********************************************************************
c                                                                      *
c  Generation of photon emitted by the final positron                  *
c                                                                      *
c  The photon is added to list of particles. e+ and resonance momenta  *
c  are modified saving resonance direction in eR+gamma rest frame      *
c                                                                      *                                                                      *
c  Input parameters:                                                   *
c                                                                      *
c  t2 - squared momentum transfer for positron                         *
c                                                                      *
c  Input from common /GGRPAR/:                                         *
c  Kmin - minimal photon energy (GeV)                                  *
c  Fmax1 - majorant value for distr. funct. on photon energy and angle *
c                                                                      *
c  Output in common /GGRSTA/: Fm1 - actual maximum value of the funct. *
c                                                                      *
c***********************************************************************
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 T2,L,DELTA,PROB,RND,XMIN,XMAX,YMIN,YMAX,X,Y,EKF,FAC1
      Real *8 PHIK,BETA,COST,SINT,FAC2,V(4),TMP,COSP,SINP,KF(4)
      Real *8 C(3),C1(3),E,E1,GAM,MEPI,DZEROX,FUN,GGRFU
      Integer *4 NG,NC
c
      Real *8 AC
      Common /GGRFUC324/AC(3)
c
      External GGRFU
c
      Save
c
      IF(PPART(4,2).LE.MAX(0.01D0,KMIN)) GOTO 500
c
c  Probability of FSR
c
      L=DLOG(-T2/EM**2)-1.D0
      DELTA=1.-ALPHA/PI*((DLOG(1.D0/RMAX)-0.75D0)*L+0.25D0) 
      XMIN=KMIN/PPART(4,2)
      PROB=ALPHA/PI*((DLOG(1.D0/XMIN)-0.75D0)*L+0.25D0)/DELTA
c
      Call GGRRNDM(RND,1)
c
      IF(RND.GT.PROB) GOTO 500
c............
c  Generate FSR
      NG=0
      NC=0
 898  NG=NG+1
c
      IF(NG.GT.1000) THEN
        print *,'FSR generation: too many iterations ( > 1000)'
        GOTO 500
      END IF
c...........
c  Generate photon energy according 1/x
      XMAX=1.-0.001/PPART(4,2)
      YMIN=DLOG(XMIN)
      YMAX=DLOG(XMAX)
c
      CALL GGRRNDM(RND,1)
c
      Y=(YMAX-YMIN)*RND+YMIN
      X=DEXP(Y)
      EKF=PPART(4,2)*X
      FAC1=(YMAX-YMIN)*X
c
c  Generate photon angles relative positron,
c  beta*dcos(theta)/(1-beta*cos(theta))
c
      CALL GGRRNDM(RND,1)
c
      PHIK=2.*PI*RND
c
      CALL GGRRNDM(RND,1)
c
      BETA=DSQRT(1.D0-EM**2/(PPART(4,2)-EKF)**2)
      YMIN=DLOG(1.D0-BETA)
      YMAX=DLOG(1.D0+BETA)
      Y=(YMAX-YMIN)*RND+YMIN
      COST=(1.D0-DEXP(Y))/BETA
      SINT=DSQRT(1.D0-cost**2)
      FAC2=(YMAX-YMIN)*(1.D0-BETA*COST)/BETA
c............
c  Photon momentum 
      V(1)=EKF*DCOS(PHIK)*SINT
      V(2)=EKF*DSIN(PHIK)*SINT
      V(3)=EKF*COST
      V(4)=EKF
      TMP=DSQRT(PPART(1,2)**2+PPART(2,2)**2)
      COSP=PPART(1,2)/TMP
      SINP=PPART(2,2)/TMP
      TMP=DSQRT(PPART(1,2)**2+PPART(2,2)**2+PPART(3,2)**2)
      COST=PPART(3,2)/TMP
      SINT=DSQRT(1.D0-COST**2)
      KF(1)= V(1)*COST*COSP-V(2)*SINP+V(3)*SINT*COSP
      KF(2)= V(1)*COST*SINP+V(2)*COSP+V(3)*SINT*SINP
      KF(3)=-V(1)*SINT               +V(3)*COST
      KF(4)= V(4)
c
c  Energy and momentum of positron + resonance system
c
      V(1)=PPART(1,2)+PPART(1,3)
      V(2)=PPART(2,2)+PPART(2,3)
      V(3)=PPART(3,2)+PPART(3,3)
      V(4)=PPART(4,2)+PPART(4,3)
      TMP=DSQRT(V(1)**2+V(2)**2+V(3)**2)
      V(1)=-V(1)/TMP
      V(2)=-V(2)/TMP
      V(3)=-V(3)/TMP
      MEPI=DSQRT(V(4)**2-TMP**2)
      GAM=V(4)/MEPI
c
c  Photon in positron + resonance rest frame
c
      TMP=DSQRT(KF(1)**2+KF(2)**2+KF(3)**2)
      C1(1)=KF(1)/TMP
      C1(2)=KF(2)/TMP
      C1(3)=KF(3)/TMP
      E1=KF(4)
c
      CALL GGRLOR(V,GAM,C1,E1,0.d0)
c
c  Resonance direction in positron + resonace rest frame
c
      TMP=DSQRT(PPART(1,3)**2+PPART(2,3)**2+PPART(3,3)**2)
      C(1)=PPART(1,3)/TMP
      C(2)=PPART(2,3)/TMP
      C(3)=PPART(3,3)/TMP
      E=PPART(4,3)
c
      CALL GGRLOR(V,GAM,C,E,RM)
c.........
c  New resonance momentum
      AC(1)=E1
      AC(2)=(C1(1)*C(1)+C1(2)*C(2)+C1(3)*C(3))*E1
      AC(3)=MEPI
      IF(GGRFU(0.D0).GT.0.) GOTO 898
c
      TMP=DZEROX(0.D0,MEPI/2.D0,1.D-10,10000,GGRFU,1)
      E=DSQRT(TMP**2+RM**2)
c...........
c  New positron momentum in lab
      C1(1)=-E1*C1(1)-TMP*C(1)
      C1(2)=-E1*C1(2)-TMP*C(2)
      C1(3)=-E1*C1(3)-TMP*C(3)
      TMP=DSQRT(C1(1)**2+C1(2)**2+C1(3)**2)
      C1(1)=c1(1)/TMP
      C1(2)=c1(2)/TMP
      C1(3)=c1(3)/TMP
      E1=DSQRT(TMP**2+EM**2)
      V(1)=-V(1)
      V(2)=-V(2)
      V(3)=-V(3)
c
      CALL GGRLOR(V,GAM,C1,E1,EM)
c
c  New resonance momentum in lab
c
      CALL GGRLOR(V,GAM,C,E,RM)
c
c  Correct photon energy and angular distribution       
c
      BETA=DSQRT(1.D0-EM**2/E1)
      COST=(C1(1)*KF(1)+C1(2)*KF(2)+C1(3)*KF(3))/KF(4)
      FUN=FAC1*FAC2*(1.-X+X**2/2.)/X/(1.-BETA*COST)
c
      IF(FUN.GT.FM1) FM1=FUN ! define majorant value using all events      
      NC=NC+1
      IF(NC.LT.100) GOTO 898 ! define majorant value for this event 
      IF(NC.EQ.100) FMAX1=FM1*1.5  ! majorant value for this event
c      
      IF(FUN.gt.FMAX1) THEN
        WRITE(6 ,*) 'FSR: Function value exceeds majorant value: ',
     &  FUN,'>',FMAX1
      END IF
c                         
      Call GGRRNDM(RND,1)
c           
      IF(FMAX1*RND.GT.FUN) GOTO 898     
c
      TMP=DSQRT(E1**2-EM**2)
      PPART(1,2)=C1(1)*TMP
      PPART(2,2)=C1(2)*TMP
      PPART(3,2)=C1(3)*TMP
      PPART(4,2)=E1
      TMP=DSQRT(E**2-RM**2)
      PPART(1,3)=C(1)*TMP
      PPART(2,3)=C(2)*TMP
      PPART(3,3)=C(3)*TMP
      PPART(4,3)=e
      NPART=NPART+1
      TYPE(NPART)=22
      MOTHER(NPART)=0
      MPART(NPART)=0.
      PPART(1,NPART)=KF(1)
      PPART(2,NPART)=KF(2)
      PPART(3,NPART)=KF(3)
      PPART(4,NPART)=KF(4)
c
 500  RETURN
c
      END

!
!***********************************************************************
!
      FUNCTION GGRFU(X)
c***********************************************************************
c                                                                      *
c  Function for GGRFSR                                                 *
c                                                                      *
c***********************************************************************
c
      Implicit NONE
      Include 'ggresrc.inc'
c
      Real *8 AC
      Common /GGRFUC324/AC(3)
c
      Real *8 GGRFU,X
c
      SAVE
c
      GGRFU=AC(1)+DSQRT(X**2+AC(1)**2+2.*AC(2)*X+EM**2)+
     &      DSQRT(X**2+RM**2)-AC(3)
c
      END

! 
!*********************************************************************** 
! 

      SUBROUTINE GGRFVP
c***********************************************************************
c                                                                      *
c  Filles common with vacuum polarization DATA (CMD-2)                 *
c                                                                      *
c***********************************************************************
c
      Implicit NONE
c      
      Real *8 SETS,SETPOL
      Common /GGRPOL324/ SETS(7330),SETPOL(7330)
c
      Real *8 VP1(7330),VP2(7330)
      Integer *4 I
c
      Save
c 
      DATA VP1/  ! 1-st data from vpol10.dat with rel. error ~1.E-5
c
     +0.0000E+00,4.6000E-07,7.0000E-07,9.5000E-07,1.0210E-06,1.0400E-06,
     +1.0496E-06,1.0592E-06,1.0688E-06,1.0784E-06,1.0880E-06,1.0976E-06,
     +1.1072E-06,1.1168E-06,1.1264E-06,1.1360E-06,1.1456E-06,1.1552E-06,
     +1.1742E-06,1.1940E-06,1.2140E-06,1.2350E-06,1.2560E-06,1.2780E-06,
     +1.3000E-06,1.3220E-06,1.3650E-06,1.4060E-06,1.4470E-06,1.4880E-06,
     +1.5290E-06,1.6090E-06,1.6900E-06,1.7710E-06,1.8520E-06,1.9330E-06,
     +2.0930E-06,2.2600E-06,2.4300E-06,2.6100E-06,2.9700E-06,3.3300E-06,
     +3.6900E-06,4.3900E-06,5.1000E-06,6.5000E-06,9.3000E-06,1.4900E-05,
     +2.5900E-05,4.7900E-05,9.1900E-05,1.7190E-04,3.3190E-04,6.5190E-04,
     +1.2519E-03,2.4519E-03,4.8519E-03,9.6519E-03,1.8652E-02,2.7800E-02,
     +3.6900E-02,4.1500E-02,4.3900E-02,4.4560E-02,4.4651E-02,4.4654E-02,
     +4.4655E-02,4.4655E-02,4.4655E-02,4.4655E-02,4.4655E-02,4.4655E-02,
     +4.4655E-02,4.4655E-02,4.4655E-02,4.4656E-02,4.4657E-02,4.4658E-02,
     +4.4662E-02,4.4669E-02,4.4683E-02,4.4711E-02,4.4767E-02,4.4823E-02,
     +4.4933E-02,4.5050E-02,4.5280E-02,4.5520E-02,4.5760E-02,4.6230E-02,
     +4.6690E-02,4.7150E-02,4.8050E-02,4.8960E-02,4.9870E-02,5.0780E-02,
     +5.2580E-02,5.4500E-02,5.6500E-02,5.8600E-02,6.0800E-02,6.5100E-02,
     +6.9200E-02,7.3300E-02,8.1300E-02,8.9400E-02,1.0540E-01,1.2200E-01,
     + 0.1264000, 0.1285000, 0.1290600, 0.1293500, 0.1295100, 0.1295910,
     + 0.1295966, 0.1295995, 0.1295999, 0.1296000, 0.1296000, 0.1296000,
     + 0.1296000, 0.1296000, 0.1296001, 0.1296001, 0.1296002, 0.1296005,
     + 0.1296010, 0.1296019, 0.1296037, 0.1296073, 0.1296143, 0.1296283,
     + 0.1296563, 0.1297123, 0.1298223, 0.1300423, 0.1304823, 0.1312823,
     + 0.1328823, 0.1360823, 0.1420823, 0.1540823, 0.1606000, 0.1736000,
     + 0.1880000, 0.2030000, 0.2190000, 0.2500000, 0.2586000, 0.2630000,
     + 0.2710000, 0.2870000, 0.3040000, 0.3084000, 0.3125000, 0.3205000,
     + 0.3365000, 0.3448000, 0.3529000, 0.3570000, 0.3650000, 0.3731000,
     + 0.3891000, 0.3935000, 0.4015000, 0.4175000, 0.4220000, 0.4310000,
     + 0.4356000, 0.4362600, 0.4375600, 0.4401600, 0.4453600, 0.4553600,
     + 0.4655000, 0.4756000, 0.4763100, 0.4766700, 0.4773700, 0.4787700,
     + 0.4815700, 0.4871700, 0.4981700, 0.5100000, 0.5220000, 0.5350000,
     + 0.5387000, 0.5406000, 0.5406370, 0.5406560, 0.5406661, 0.5406665,
     + 0.5406667, 0.5406667, 0.5406667, 0.5406667, 0.5406667, 0.5406668,
     + 0.5406668, 0.5406669, 0.5406672, 0.5406677, 0.5406686, 0.5406704,
     + 0.5406740, 0.5406810, 0.5406950, 0.5407230, 0.5407790, 0.5408890,
     + 0.5411090, 0.5415490, 0.5423490, 0.5439490, 0.5471490, 0.5502000,
     + 0.5563000, 0.5594000, 0.5625000, 0.5629100, 0.5637100, 0.5653100,
     + 0.5685100, 0.5745100, 0.5762000, 0.5795000, 0.5855000, 0.5886000,
     + 0.5902000, 0.5919000, 0.5927600, 0.5936200, 0.5953200, 0.5971000,
     + 0.5980600, 0.5999600, 0.6011000, 0.6017100, 0.6023200, 0.6029300,
     + 0.6035400, 0.6041500, 0.6047600, 0.6053700, 0.6065700, 0.6072400,
     + 0.6079000, 0.6080800, 0.6081760, 0.6082250, 0.6083150, 0.6084950,
     + 0.6088550, 0.6090400, 0.6092300, 0.6096100, 0.6098000, 0.6101700,
     + 0.6105300, 0.6107200, 0.6109200, 0.6113100, 0.6115000, 0.6116010,
     + 0.6117020, 0.6118030, 0.6119040, 0.6120050, 0.6121060, 0.6123060,
     + 0.6125200, 0.6127400, 0.6128010, 0.6128620, 0.6129820, 0.6132220,
     + 0.6134700, 0.6137300, 0.6138700, 0.6141500, 0.6147100, 0.6150000,
     + 0.6153000, 0.6158900, 0.6164500, 0.6167400, 0.6173200, 0.6174800,
     + 0.6177900, 0.6178310, 0.6179110, 0.6180710, 0.6183910, 0.6189910,
     + 0.6196000, 0.6202100, 0.6208200, 0.6214300, 0.6220400, 0.6226500,
     + 0.6232600, 0.6235700, 0.6237400, 0.6240800, 0.6246800, 0.6258800,
     + 0.6272000, 0.6298000, 0.6325000, 0.6340000, 0.6355000, 0.6385000,
     + 0.6393100, 0.6397200, 0.6405200, 0.6421200, 0.6453200, 0.6513200,
     + 0.6545000, 0.6605000, 0.6666000, 0.6727000, 0.6847000, 0.6980000,
     + 0.7017000, 0.7036000, 0.7046100, 0.7056200, 0.7076200, 0.7116200,
     + 0.7196200, 0.7277000, 0.7358000, 0.7518000, 0.7690000, 0.7736000,
     + 0.7782000, 0.7828000, 0.7874000, 0.7964000, 0.8144000, 0.8192000,
     + 0.8282000, 0.8373000, 0.8419000, 0.8443000, 0.8456000, 0.8462600,
     + 0.8475600, 0.8501600, 0.8553600, 0.8653600, 0.8755000, 0.8856000,
     + 0.8907000, 0.8958000, 0.9009000, 0.9035000, 0.9062000, 0.9115000,
     + 0.9166000, 0.9266000, 0.9367000, 0.9468000, 0.9519000, 0.9570000,
     + 0.9596000, 0.9647000, 0.9747000, 0.9848000, 0.9899000, 0.9950000,
     + 1.0001000, 1.0052000, 1.0066000, 1.0073100, 1.0074110, 1.0074250,
     + 1.0074289, 1.0074325, 1.0074335, 1.0074337, 1.0074337, 1.0074338,
     + 1.0074338, 1.0074338, 1.0074338, 1.0074339, 1.0074340, 1.0074342,
     + 1.0074347, 1.0074356, 1.0074374, 1.0074410, 1.0074480, 1.0074620,
     + 1.0074900, 1.0075460, 1.0076560, 1.0078760, 1.0083160, 1.0091160,
     + 1.0107160, 1.0124000, 1.0141000, 1.0159000, 1.0168600, 1.0171100,
     + 1.0172500, 1.0172860, 1.0173050, 1.0173146, 1.0173195, 1.0173208,
     + 1.0173222, 1.0173223, 1.0173223, 1.0173224, 1.0173224, 1.0173224,
     + 1.0173224, 1.0173225, 1.0173226, 1.0173228, 1.0173232, 1.0173240,
     + 1.0173256, 1.0173288, 1.0173348, 1.0173468, 1.0173708, 1.0174188,
     + 1.0175088, 1.0176888, 1.0180488, 1.0187488, 1.0194600, 1.0201700,
     + 1.0203600, 1.0204120, 1.0204380, 1.0204419, 1.0204429, 1.0204434,
     + 1.0204434, 1.0204434, 1.0204434, 1.0204435, 1.0204435, 1.0204436,
     + 1.0204437, 1.0204440, 1.0204445, 1.0204456, 1.0204478, 1.0204522,
     + 1.0204602, 1.0204762, 1.0205082, 1.0205682, 1.0206882, 1.0207550,
     + 1.0208210, 1.0209510, 1.0212110, 1.0217310, 1.0222400, 1.0225000,
     + 1.0230200, 1.0235300, 1.0240400, 1.0245500, 1.0250600, 1.0255700,
     + 1.0260800, 1.0265900, 1.0271000, 1.0276100, 1.0281200, 1.0286300,
     + 1.0289000, 1.0291700, 1.0294400, 1.0297100, 1.0299800, 1.0302500,
     + 1.0305200, 1.0307900, 1.0310600, 1.0311310, 1.0312710, 1.0314200,
     + 1.0315700, 1.0317300, 1.0320400, 1.0326500, 1.0329600, 1.0331300,
     + 1.0334700, 1.0335560, 1.0336420, 1.0337280, 1.0338140, 1.0338370,
     + 1.0338820, 1.0339720, 1.0340630, 1.0341090, 1.0341330, 1.0341580,
     + 1.0342070, 1.0342530, 1.0342770, 1.0342836, 1.0342870, 1.0342886,
     + 1.0342888, 1.0342890, 1.0342890, 1.0342890, 1.0342890, 1.0342891,
     + 1.0342891, 1.0342893, 1.0342896, 1.0342901, 1.0342912, 1.0342934,
     + 1.0342978, 1.0343058, 1.0343218, 1.0343538, 1.0344138, 1.0344750,
     + 1.0345360, 1.0345970, 1.0347170, 1.0349570, 1.0352100, 1.0353500,
     + 1.0354900, 1.0355660, 1.0357160, 1.0358800, 1.0360500, 1.0360970,
     + 1.0361430, 1.0361560, 1.0361690, 1.0361950, 1.0362470, 1.0363470,
     + 1.0363990, 1.0364990, 1.0365510, 1.0366020, 1.0367020, 1.0369020,
     + 1.0371100, 1.0372200, 1.0374400, 1.0375700, 1.0378200, 1.0378910,
     + 1.0379620, 1.0379990, 1.0380690, 1.0382090, 1.0382860, 1.0383250,
     + 1.0383440, 1.0383810, 1.0384510, 1.0385910, 1.0387400, 1.0388900,
     + 1.0390500, 1.0393600, 1.0394040, 1.0394450, 1.0395250, 1.0396060,
     + 1.0396470, 1.0396880, 1.0397680, 1.0398490, 1.0399300, 1.0399710,
     + 1.0399830, 1.0399891, 1.0399952, 1.0399968, 1.0399985, 1.0399988,
     + 1.0399992, 1.0400003, 1.0400022, 1.0400034, 1.0400046, 1.0400059,
     + 1.0400084, 1.0400134, 1.0400224, 1.0400404, 1.0400764, 1.0401464,
     + 1.0402864, 1.0403260, 1.0403620, 1.0404320, 1.0405030, 1.0406430,
     + 1.0407900, 1.0409500, 1.0411100, 1.0411910, 1.0412320, 1.0412440,
     + 1.0412506, 1.0412540, 1.0412600, 1.0412631, 1.0412693, 1.0412813,
     + 1.0413053, 1.0413533, 1.0414433, 1.0416233, 1.0417180, 1.0418090,
     + 1.0419000, 1.0419460, 1.0420360, 1.0421270, 1.0422180, 1.0423980,
     + 1.0427580, 1.0431200, 1.0431690, 1.0432150, 1.0433050, 1.0433960,
     + 1.0434870, 1.0436670, 1.0437170, 1.0438070, 1.0438530, 1.0438990,
     + 1.0439890, 1.0440800, 1.0441710, 1.0441950, 1.0442200, 1.0442460,
     + 1.0442980, 1.0443980, 1.0445980, 1.0448100, 1.0449300, 1.0450600,
     + 1.0453100, 1.0455700, 1.0457100, 1.0457860, 1.0458620, 1.0460120,
     + 1.0463120, 1.0466200, 1.0469300, 1.0471000, 1.0474400, 1.0477500,
     + 1.0480700, 1.0483800, 1.0487000, 1.0490100, 1.0493200, 1.0496400,
     + 1.0502400, 1.0508500, 1.0514600, 1.0520700, 1.0526800, 1.0532900,
     + 1.0539000, 1.0545100, 1.0551200, 1.0563200, 1.0566500, 1.0572500,
     + 1.0575600, 1.0576460, 1.0578160, 1.0581560, 1.0587560, 1.0599560,
     + 1.0613000, 1.0627000, 1.0641000, 1.0656000, 1.0672000, 1.0680600,
     + 1.0682900, 1.0687500, 1.0688800, 1.0691300, 1.0696300, 1.0706300,
     + 1.0726300, 1.0747000, 1.0768000, 1.0809000, 1.0814600, 1.0820200,
     + 1.0831200, 1.0843000, 1.0866000, 1.0912000, 1.0958000, 1.1004000,
     + 1.1010600, 1.1017200, 1.1023800, 1.1036800, 1.1062800, 1.1114800,
     + 1.1166000, 1.1266000, 1.1367000, 1.1567000, 1.1624000, 1.1680000,
     + 1.1790000, 1.1900000, 1.2010000, 1.2041000, 1.2102000, 1.2163000,
     + 1.2224000, 1.2285000, 1.2405000, 1.2474000, 1.2540000, 1.2606000,
     + 1.2736000, 1.2880000, 1.3030000, 1.3180000, 1.3480000, 1.3790000,
     + 1.3871000, 1.3912000, 1.3992000, 1.4152000, 1.4320000, 1.4406000,
     + 1.4492000, 1.4536000, 1.4616000, 1.4657000, 1.4737000, 1.4897000,
     + 1.4984000, 1.5070000, 1.5240000, 1.5580000, 1.5661000, 1.5742000,
     + 1.5823000, 1.5864000, 1.5944000, 1.6025000, 1.6106000, 1.6266000,
     + 1.6354000, 1.6398000, 1.6478000, 1.6559000, 1.6640000, 1.6800000,
     + 1.6886000, 1.6972000, 1.7058000, 1.7228000, 1.7568000, 1.7650000,
     + 1.7691000, 1.7771000, 1.7852000, 1.7933000, 1.7974000, 1.8054000,
     + 1.8095000, 1.8175000, 1.8335000, 1.8500000, 1.8586000, 1.8756000,
     + 1.9096000, 1.9179000, 1.9220000, 1.9300000, 1.9311000, 1.9316600,
     + 1.9319500, 1.9320260, 1.9320650, 1.9320840, 1.9320936, 1.9320985,
     + 1.9320998, 1.9321000, 1.9321000, 1.9321000, 1.9321000, 1.9321000,
     + 1.9321000, 1.9321001, 1.9321002, 1.9321004, 1.9321008, 1.9321016,
     + 1.9321032, 1.9321064, 1.9321124, 1.9321244, 1.9321484, 1.9321964,
     + 1.9322864, 1.9324664, 1.9328264, 1.9335264, 1.9349264, 1.9377264,
     + 1.9433264, 1.9489000, 1.9504000, 1.9512100, 1.9514200, 1.9515400,
     + 1.9516010, 1.9516051, 1.9516072, 1.9516084, 1.9516087, 1.9516089,
     + 1.9516090, 1.9516090, 1.9516090, 1.9516090, 1.9516090, 1.9516091,
     + 1.9516092, 1.9516094, 1.9516098, 1.9516106, 1.9516122, 1.9516154,
     + 1.9516214, 1.9516334, 1.9516574, 1.9517054, 1.9517954, 1.9519754,
     + 1.9523354, 1.9530354, 1.9544354, 1.9572354, 1.9628354, 1.9738354,
     + 1.9948354, 2.0170000, 2.0610000, 2.0820000, 2.1230000, 2.1340000,
     + 2.1371000, 2.1388000, 2.1388660, 2.1389000, 2.1389041, 2.1389062,
     + 2.1389062, 2.1389062, 2.1389063, 2.1389063, 2.1389063, 2.1389063,
     + 2.1389064, 2.1389066, 2.1389069, 2.1389075, 2.1389087, 2.1389111,
     + 2.1389159, 2.1389249, 2.1389429, 2.1389789, 2.1390489, 2.1391889,
     + 2.1394689, 2.1400289, 2.1411289, 2.1433289, 2.1477289, 2.1557289,
     + 2.1638000, 2.1798000, 2.1970000, 2.2061000, 2.2107000, 2.2131000,
     + 2.2179000, 2.2269000, 2.2360000, 2.2540000, 2.2730000, 2.3110000,
     + 2.3470000, 2.3660000, 2.4040000, 2.4136000, 2.4326000, 2.4530000,
     + 2.4640000, 2.4860000, 2.5080000, 2.5310000, 2.5550000, 2.6030000,
     + 2.6930000, 2.7060000, 2.7190000, 2.7224000, 2.7284000, 2.7404000,
     + 2.7530000, 2.7601000, 2.7620000, 2.7658000, 2.7728000, 2.7868000,
     + 2.8020000, 2.8061000, 2.8141000, 2.8222000, 2.8382000, 2.8550000,
     + 2.8720000, 2.9050000, 2.9650000, 2.9731000, 2.9772000, 2.9852000,
     + 3.0012000, 3.0332000, 3.0640000, 3.0800000, 3.0970000, 3.1056000,
     + 3.1226000, 3.1273000, 3.1363000, 3.1543000, 3.1637000, 3.1728000,
     + 3.1908000, 3.2268000, 3.2968000, 3.3160000, 3.3261000, 3.3461000,
     + 3.3861000, 3.4561000, 3.4661000, 3.4851000, 3.5231000, 3.5256000,
     + 3.5263100, 3.5266700, 3.5268600, 3.5268740, 3.5268811, 3.5268830,
     + 3.5268840, 3.5268840, 3.5268840, 3.5268840, 3.5268841, 3.5268841,
     + 3.5268842, 3.5268845, 3.5268850, 3.5268859, 3.5268877, 3.5268913,
     + 3.5268983, 3.5269123, 3.5269403, 3.5269963, 3.5271063, 3.5273263,
     + 3.5277663, 3.5285663, 3.5301663, 3.5333663, 3.5393663, 3.5513663,
     + 3.5640000, 3.5890000, 3.6390000, 3.6530000, 3.6810000, 3.6960000,
     + 3.7041000, 3.7201000, 3.7521000, 3.7830000, 3.7990000, 3.8013000,
     + 3.8026000, 3.8051000, 3.8101000, 3.8201000, 3.8215000, 3.8222600,
     + 3.8237600, 3.8267600, 3.8327600, 3.8389000, 3.8420000, 3.8481000,
     + 3.8542000, 3.8603000, 3.8723000, 3.8963000, 3.9210000, 3.9700000,
     + 3.9940000, 3.9974000, 3.9991000, 3.9995600, 3.9998000, 3.9999300,
     + 3.9999960, 3.9999985, 3.9999998, 4.0000000, 4.0000000, 4.0000000,
     + 4.0000000, 4.0000000, 4.0000001, 4.0000002, 4.0000004, 4.0000009,
     + 4.0000017, 4.0000033, 4.0000065, 4.0000125, 4.0000245, 4.0000485,
     + 4.0000965, 4.0001865, 4.0003665, 4.0007265, 4.0014265, 4.0028265,
     + 4.0056265, 4.0112265, 4.0222265, 4.0432265, 4.0852265, 4.1652265,
     + 4.3252265, 4.5000000, 4.5460000, 4.6360000, 4.7270000, 4.9070000,
     + 5.2670000, 5.2920000, 5.2986000, 5.3020000, 5.3024100, 5.3026200,
     + 5.3027400, 5.3028010, 5.3028051, 5.3028057, 5.3028060, 5.3028062,
     + 5.3028062, 5.3028062, 5.3028063, 5.3028063, 5.3028063, 5.3028064,
     + 5.3028065, 5.3028067, 5.3028071, 5.3028079, 5.3028095, 5.3028127,
     + 5.3028187, 5.3028307, 5.3028547, 5.3029027, 5.3029927, 5.3031727,
     + 5.3035327, 5.3042327, 5.3056327, 5.3084327, 5.3140327, 5.3250327,
     + 5.3460327, 5.3880327, 5.4680327, 5.6280327, 5.8000000, 6.1400000,
     + 6.4500000, 6.7700000, 7.0800000, 7.2400000, 7.3260000, 7.4960000,
     + 7.6800000, 7.7760000, 7.8720000, 8.0620000, 8.1620000, 8.2130000,
     + 8.2390000, 8.2530000, 8.2566000, 8.2585000, 8.2594600, 8.2594600,
     + 8.2594600, 8.2594600, 8.2594601, 8.2594602, 8.2594604, 8.2594608,
     + 8.2594616, 8.2594632, 8.2594664, 8.2594724, 8.2594844, 8.2595084,
     + 8.2595564, 8.2596464, 8.2598264, 8.2601864, 8.2608864, 8.2622864,
     + 8.2650864, 8.2706864, 8.2816864, 8.3026864, 8.3446864, 8.4246864,
     + 8.5846864, 8.7500000, 8.8360000, 8.9220000, 9.0080000, 9.0940000,
     + 9.1380000, 9.1790000, 9.2200000, 9.2610000, 9.2830000, 9.3050000,
     + 9.3280000, 9.3510000, 9.3750000, 9.3880000, 9.4010000, 9.4140000,
     + 9.4270000, 9.4400000, 9.4466000, 9.4532000, 9.4598000, 9.4664000,
     + 9.4730000, 9.4796000, 9.4862000, 9.4928000, 9.4962000, 9.4993000,
     + 9.5024000, 9.5055000, 9.5086000, 9.5118000, 9.5149000, 9.5180000,
     + 9.5211000, 9.5242000, 9.5273000, 9.5304000, 9.5320000, 9.5336000,
     + 9.5352000, 9.5368000, 9.5385000, 9.5402000, 9.5419000, 9.5436000,
     + 9.5453000, 9.5462100, 9.5471200, 9.5480300, 9.5489400, 9.5498500,
     + 9.5507600, 9.5516700, 9.5525800, 9.5534900, 9.5544000, 9.5553100,
     + 9.5562200, 9.5571300, 9.5580400, 9.5589500, 9.5598600, 9.5603200,
     + 9.5607800, 9.5612400, 9.5617000, 9.5621600, 9.5626200, 9.5630800,
     + 9.5635400, 9.5640000, 9.5644600, 9.5649200, 9.5653800, 9.5658400,
     + 9.5663000, 9.5667600, 9.5672200, 9.5676800, 9.5681400, 9.5686000,
     + 9.5688400, 9.5690900, 9.5693400, 9.5695900, 9.5698500, 9.5701100,
     + 9.5703800, 9.5706500, 9.5709300, 9.5712200, 9.5715100, 9.5718000,
     + 9.5721000, 9.5724000, 9.5725600, 9.5727300, 9.5729000, 9.5730800,
     + 9.5732700, 9.5734600, 9.5736500, 9.5738400, 9.5740300, 9.5742200,
     + 9.5744100, 9.5746000, 9.5747900, 9.5749800, 9.5751700, 9.5753600,
     + 9.5754610, 9.5755620, 9.5756630, 9.5757640, 9.5758650, 9.5759660,
     + 9.5760670, 9.5761680, 9.5762690, 9.5763700, 9.5764710, 9.5765720,
     + 9.5766730, 9.5767740, 9.5768750, 9.5769760, 9.5770770, 9.5771780,
     + 9.5772790, 9.5773800, 9.5774810, 9.5775820, 9.5776830, 9.5777840,
     + 9.5778850, 9.5779860, 9.5780870, 9.5781880, 9.5782890, 9.5783900,
     + 9.5784910, 9.5785420, 9.5785930, 9.5786440, 9.5786950, 9.5787460,
     + 9.5787970, 9.5788480, 9.5788990, 9.5789500, 9.5790010, 9.5790520,
     + 9.5791030, 9.5791540, 9.5792050, 9.5792560, 9.5793070, 9.5793580,
     + 9.5794090, 9.5794600, 9.5795110, 9.5795620, 9.5796130, 9.5796640,
     + 9.5797150, 9.5797660, 9.5798170, 9.5798680, 9.5799190, 9.5799700,
     + 9.5800210, 9.5800720, 9.5801230, 9.5801740, 9.5802250, 9.5802760,
     + 9.5803270, 9.5803780, 9.5804290, 9.5804800, 9.5805060, 9.5805330,
     + 9.5805600, 9.5805880, 9.5806160, 9.5806450, 9.5806740, 9.5807040,
     + 9.5807340, 9.5807650, 9.5807960, 9.5808270, 9.5808580, 9.5808890,
     + 9.5809200, 9.5809510, 9.5809820, 9.5810130, 9.5810450, 9.5810760,
     + 9.5811070, 9.5811380, 9.5811690, 9.5812000, 9.5812310, 9.5812620,
     + 9.5812930, 9.5813240, 9.5813560, 9.5813870, 9.5814180, 9.5814490,
     + 9.5814800, 9.5815110, 9.5815270, 9.5815440, 9.5815610, 9.5815780,
     + 9.5815960, 9.5816140, 9.5816330, 9.5816520, 9.5816710, 9.5816900,
     + 9.5817090, 9.5817280, 9.5817470, 9.5817660, 9.5817850, 9.5818040,
     + 9.5818230, 9.5818420, 9.5818610, 9.5818800, 9.5818990, 9.5819180,
     + 9.5819370, 9.5819560, 9.5819750, 9.5819940, 9.5820130, 9.5820320,
     + 9.5820510, 9.5820700, 9.5820890, 9.5821080, 9.5821270, 9.5821460,
     + 9.5821650, 9.5821840, 9.5822030, 9.5822220, 9.5822410, 9.5822600,
     + 9.5822696, 9.5822792, 9.5822888, 9.5822984, 9.5823080, 9.5823176,
     + 9.5823272, 9.5823368, 9.5823464, 9.5823560, 9.5823656, 9.5823752,
     + 9.5823848, 9.5823944, 9.5824040, 9.5824136, 9.5824232, 9.5824328,
     + 9.5824424, 9.5824520, 9.5824616, 9.5824712, 9.5824808, 9.5824904,
     + 9.5825000, 9.5825096, 9.5825192, 9.5825288, 9.5825384, 9.5825480,
     + 9.5825576, 9.5825672, 9.5825768, 9.5825864, 9.5825960, 9.5826056,
     + 9.5826152, 9.5826248, 9.5826344, 9.5826440, 9.5826536, 9.5826632,
     + 9.5826728, 9.5826824, 9.5826920, 9.5827016, 9.5827112, 9.5827208,
     + 9.5827304, 9.5827400, 9.5827496, 9.5827592, 9.5827688, 9.5827784,
     + 9.5827880, 9.5827976, 9.5828072, 9.5828168, 9.5828264, 9.5828360,
     + 9.5828456, 9.5828552, 9.5828648, 9.5828744, 9.5828840, 9.5828936,
     + 9.5829032, 9.5829128, 9.5829224, 9.5829320, 9.5829416, 9.5829512,
     + 9.5829608, 9.5829704, 9.5829800, 9.5829896, 9.5829992, 9.5830088,
     + 9.5830184, 9.5830280, 9.5830376, 9.5830425, 9.5830515, 9.5830606,
     + 9.5830697, 9.5830788, 9.5830879, 9.5830970, 9.5831061, 9.5831107,
     + 9.5831197, 9.5831243, 9.5831289, 9.5831335, 9.5831381, 9.5831427,
     + 9.5831473, 9.5831519, 9.5831565, 9.5831611, 9.5831657, 9.5831703,
     + 9.5831749, 9.5831795, 9.5831841, 9.5831887, 9.5831933, 9.5831979,
     + 9.5832025, 9.5832071, 9.5832117, 9.5832163, 9.5832209, 9.5832255,
     + 9.5832301, 9.5832347, 9.5832393, 9.5832439, 9.5832485, 9.5832531,
     + 9.5832577, 9.5832601, 9.5832649, 9.5832695, 9.5832741, 9.5832787,
     + 9.5832833, 9.5832879, 9.5832925, 9.5832971, 9.5833017, 9.5833063,
     + 9.5833109, 9.5833155, 9.5833201, 9.5833247, 9.5833293, 9.5833339,
     + 9.5833385, 9.5833431, 9.5833477, 9.5833523, 9.5833613, 9.5833704,
     + 9.5833795, 9.5833886, 9.5833977, 9.5834068, 9.5834159, 9.5834250,
     + 9.5834341, 9.5834432, 9.5834612, 9.5834800, 9.5834896, 9.5834992,
     + 9.5835088, 9.5835137, 9.5835183, 9.5835229, 9.5835275, 9.5835321,
     + 9.5835367, 9.5835413, 9.5835459, 9.5835505, 9.5835551, 9.5835597,
     + 9.5835643, 9.5835689, 9.5835735, 9.5835781, 9.5835805, 9.5835830,
     + 9.5835855, 9.5835881, 9.5835908, 9.5835936, 9.5835965, 9.5835994,
     + 9.5836024, 9.5836055, 9.5836086, 9.5836118, 9.5836149, 9.5836180,
     + 9.5836212, 9.5836243, 9.5836275, 9.5836306, 9.5836337, 9.5836354,
     + 9.5836372, 9.5836390, 9.5836408, 9.5836426, 9.5836444, 9.5836462,
     + 9.5836481, 9.5836500, 9.5836520, 9.5836540, 9.5836561, 9.5836582,
     + 9.5836604, 9.5836626, 9.5836649, 9.5836672, 9.5836696, 9.5836721,
     + 9.5836746, 9.5836760, 9.5836774, 9.5836789, 9.5836804, 9.5836820,
     + 9.5836836, 9.5836852, 9.5836869, 9.5836887, 9.5836905, 9.5836923,
     + 9.5836941, 9.5836959, 9.5836978, 9.5836997, 9.5837017, 9.5837037,
     + 9.5837058, 9.5837079, 9.5837091, 9.5837103, 9.5837115, 9.5837127,
     + 9.5837139, 9.5837151, 9.5837163, 9.5837175, 9.5837187, 9.5837200,
     + 9.5837213, 9.5837226, 9.5837240, 9.5837255, 9.5837270, 9.5837285,
     + 9.5837300, 9.5837315, 9.5837330, 9.5837345, 9.5837361, 9.5837377,
     + 9.5837394, 9.5837411, 9.5837429, 9.5837447, 9.5837457, 9.5837466,
     + 9.5837476, 9.5837485, 9.5837495, 9.5837505, 9.5837514, 9.5837524,
     + 9.5837533, 9.5837543, 9.5837553, 9.5837562, 9.5837572, 9.5837581,
     + 9.5837591, 9.5837601, 9.5837610, 9.5837620, 9.5837629, 9.5837639,
     + 9.5837649, 9.5837658, 9.5837668, 9.5837677, 9.5837687, 9.5837697,
     + 9.5837706, 9.5837716, 9.5837725, 9.5837735, 9.5837745, 9.5837754,
     + 9.5837764, 9.5837773, 9.5837783, 9.5837793, 9.5837802, 9.5837812,
     + 9.5837821, 9.5837831, 9.5837841, 9.5837850, 9.5837860, 9.5837869,
     + 9.5837879, 9.5837889, 9.5837898, 9.5837908, 9.5837917, 9.5837927,
     + 9.5837937, 9.5837946, 9.5837956, 9.5837965, 9.5837975, 9.5837985,
     + 9.5837994, 9.5838004, 9.5838013, 9.5838023, 9.5838033, 9.5838042,
     + 9.5838052, 9.5838061, 9.5838071, 9.5838081, 9.5838090, 9.5838100,
     + 9.5838109, 9.5838119, 9.5838129, 9.5838138, 9.5838148, 9.5838157,
     + 9.5838167, 9.5838177, 9.5838186, 9.5838196, 9.5838205, 9.5838215,
     + 9.5838225, 9.5838234, 9.5838244, 9.5838253, 9.5838263, 9.5838273,
     + 9.5838282, 9.5838292, 9.5838301, 9.5838311, 9.5838321, 9.5838330,
     + 9.5838340, 9.5838349, 9.5838359, 9.5838369, 9.5838378, 9.5838388,
     + 9.5838397, 9.5838407, 9.5838417, 9.5838426, 9.5838436, 9.5838445,
     + 9.5838455, 9.5838465, 9.5838474, 9.5838484, 9.5838493, 9.5838503,
     + 9.5838513, 9.5838522, 9.5838532, 9.5838541, 9.5838551, 9.5838561,
     + 9.5838570, 9.5838580, 9.5838589, 9.5838599, 9.5838609, 9.5838618,
     + 9.5838628, 9.5838637, 9.5838647, 9.5838657, 9.5838666, 9.5838676,
     + 9.5838685, 9.5838695, 9.5838705, 9.5838714, 9.5838724, 9.5838733,
     + 9.5838743, 9.5838753, 9.5838762, 9.5838772, 9.5838781, 9.5838791,
     + 9.5838801, 9.5838810, 9.5838820, 9.5838829, 9.5838839, 9.5838849,
     + 9.5838858, 9.5838868, 9.5838877, 9.5838887, 9.5838897, 9.5838906,
     + 9.5838916, 9.5838925, 9.5838935, 9.5838945, 9.5838954, 9.5838964,
     + 9.5838973, 9.5838983, 9.5838993, 9.5839002, 9.5839012, 9.5839021,
     + 9.5839031, 9.5839041, 9.5839050, 9.5839060, 9.5839069, 9.5839079,
     + 9.5839089, 9.5839098, 9.5839108, 9.5839117, 9.5839127, 9.5839137,
     + 9.5839146, 9.5839156, 9.5839165, 9.5839175, 9.5839185, 9.5839194,
     + 9.5839204, 9.5839213, 9.5839223, 9.5839233, 9.5839242, 9.5839252,
     + 9.5839261, 9.5839271, 9.5839281, 9.5839290, 9.5839300, 9.5839309,
     + 9.5839328, 9.5839338, 9.5839357, 9.5839377, 9.5839397, 9.5839418,
     + 9.5839430, 9.5839442, 9.5839454, 9.5839477, 9.5839490, 9.5839503,
     + 9.5839517, 9.5839532, 9.5839547, 9.5839562, 9.5839591, 9.5839621,
     + 9.5839651, 9.5839682, 9.5839743, 9.5839804, 9.5839835, 9.5839867,
     + 9.5839898, 9.5839915, 9.5839933, 9.5839951, 9.5839969, 9.5839987,
     + 9.5840006, 9.5840025, 9.5840045, 9.5840065, 9.5840086, 9.5840097,
     + 9.5840109, 9.5840121, 9.5840133, 9.5840145, 9.5840158, 9.5840171,
     + 9.5840184, 9.5840198, 9.5840213, 9.5840228, 9.5840243, 9.5840258,
     + 9.5840273, 9.5840288, 9.5840303, 9.5840319, 9.5840335, 9.5840344,
     + 9.5840352, 9.5840369, 9.5840378, 9.5840387, 9.5840395, 9.5840404,
     + 9.5840413, 9.5840421, 9.5840430, 9.5840438, 9.5840447, 9.5840456,
     + 9.5840464, 9.5840473, 9.5840481, 9.5840490, 9.5840499, 9.5840507,
     + 9.5840516, 9.5840524, 9.5840533, 9.5840542, 9.5840550, 9.5840559,
     + 9.5840567, 9.5840576, 9.5840585, 9.5840593, 9.5840602, 9.5840610,
     + 9.5840619, 9.5840628, 9.5840636, 9.5840645, 9.5840653, 9.5840662,
     + 9.5840671, 9.5840679, 9.5840688, 9.5840696, 9.5840705, 9.5840714,
     + 9.5840722, 9.5840731, 9.5840739, 9.5840748, 9.5840757, 9.5840765,
     + 9.5840774, 9.5840782, 9.5840791, 9.5840800, 9.5840808, 9.5840817,
     + 9.5840825, 9.5840834, 9.5840843, 9.5840851, 9.5840860, 9.5840868,
     + 9.5840877, 9.5840886, 9.5840894, 9.5840903, 9.5840911, 9.5840920,
     + 9.5840929, 9.5840937, 9.5840946, 9.5840954, 9.5840963, 9.5840972,
     + 9.5840980, 9.5840989, 9.5840997, 9.5841006, 9.5841015, 9.5841023,
     + 9.5841032, 9.5841040, 9.5841049, 9.5841058, 9.5841066, 9.5841075,
     + 9.5841083, 9.5841092, 9.5841101, 9.5841109, 9.5841118, 9.5841126,
     + 9.5841135, 9.5841144, 9.5841152, 9.5841161, 9.5841169, 9.5841178,
     + 9.5841187, 9.5841195, 9.5841204, 9.5841212, 9.5841221, 9.5841230,
     + 9.5841238, 9.5841247, 9.5841255, 9.5841264, 9.5841273, 9.5841281,
     + 9.5841290, 9.5841298, 9.5841307, 9.5841316, 9.5841324, 9.5841333,
     + 9.5841341, 9.5841350, 9.5841359, 9.5841367, 9.5841376, 9.5841384,
     + 9.5841393, 9.5841402, 9.5841410, 9.5841419, 9.5841427, 9.5841436,
     + 9.5841445, 9.5841453, 9.5841462, 9.5841470, 9.5841479, 9.5841488,
     + 9.5841496, 9.5841505, 9.5841513, 9.5841522, 9.5841531, 9.5841539,
     + 9.5841548, 9.5841556, 9.5841565, 9.5841574, 9.5841582, 9.5841591,
     + 9.5841599, 9.5841608, 9.5841617, 9.5841625, 9.5841634, 9.5841642,
     + 9.5841651, 9.5841660, 9.5841668, 9.5841677, 9.5841685, 9.5841694,
     + 9.5841703, 9.5841711, 9.5841720, 9.5841728, 9.5841737, 9.5841746,
     + 9.5841763, 9.5841772, 9.5841781, 9.5841790, 9.5841799, 9.5841808,
     + 9.5841817, 9.5841827, 9.5841836, 9.5841845, 9.5841854, 9.5841863,
     + 9.5841872, 9.5841881, 9.5841890, 9.5841899, 9.5841908, 9.5841918,
     + 9.5841927, 9.5841936, 9.5841945, 9.5841954, 9.5841963, 9.5841972,
     + 9.5841981, 9.5841990, 9.5841999, 9.5842017, 9.5842027, 9.5842045,
     + 9.5842055, 9.5842064, 9.5842074, 9.5842083, 9.5842093, 9.5842102,
     + 9.5842112, 9.5842122, 9.5842141, 9.5842152, 9.5842164, 9.5842176,
     + 9.5842188, 9.5842201, 9.5842214, 9.5842227, 9.5842241, 9.5842256,
     + 9.5842271, 9.5842286, 9.5842301, 9.5842316, 9.5842331, 9.5842346,
     + 9.5842362, 9.5842378, 9.5842395, 9.5842412, 9.5842430, 9.5842448,
     + 9.5842467, 9.5842486, 9.5842506, 9.5842526, 9.5842547, 9.5842568,
     + 9.5842590, 9.5842612, 9.5842635, 9.5842658, 9.5842682, 9.5842696,
     + 9.5842710, 9.5842725, 9.5842740, 9.5842755, 9.5842771, 9.5842787,
     + 9.5842803, 9.5842820, 9.5842838, 9.5842856, 9.5842874, 9.5842892,
     + 9.5842910, 9.5842929, 9.5842948, 9.5842968, 9.5842988, 9.5843009,
     + 9.5843030, 9.5843052, 9.5843074, 9.5843097, 9.5843121, 9.5843146,
     + 9.5843171, 9.5843197, 9.5843224, 9.5843252, 9.5843281, 9.5843310,
     + 9.5843340, 9.5843371, 9.5843402, 9.5843434, 9.5843465, 9.5843496,
     + 9.5843528, 9.5843559, 9.5843591, 9.5843622, 9.5843653, 9.5843685,
     + 9.5843716, 9.5843747, 9.5843779, 9.5843810, 9.5843841, 9.5843873,
     + 9.5843904, 9.5843936, 9.5843967, 9.5843998, 9.5844030, 9.5844090,
     + 9.5844151, 9.5844212, 9.5844273, 9.5844334, 9.5844395, 9.5844456,
     + 9.5844517, 9.5844637, 9.5844877, 9.5845010, 9.5845081, 9.5845152,
     + 9.5845223, 9.5845294, 9.5845365, 9.5845436, 9.5845507, 9.5845578,
     + 9.5845649, 9.5845720, 9.5845791, 9.5845862, 9.5845933, 9.5846004,
     + 9.5846075, 9.5846146, 9.5846217, 9.5846288, 9.5846359, 9.5846430,
     + 9.5846501, 9.5846572, 9.5846643, 9.5846714, 9.5846785, 9.5846856,
     + 9.5846927, 9.5846998, 9.5847069, 9.5847140, 9.5847211, 9.5847282,
     + 9.5847353, 9.5847424, 9.5847495, 9.5847566, 9.5847637, 9.5847708,
     + 9.5847779, 9.5847850, 9.5847921, 9.5847992, 9.5848063, 9.5848134,
     + 9.5848205, 9.5848276, 9.5848347, 9.5848418, 9.5848489, 9.5848560,
     + 9.5848631, 9.5848702, 9.5848773, 9.5848844, 9.5848915, 9.5848986,
     + 9.5849057, 9.5849128, 9.5849199, 9.5849270, 9.5849341, 9.5849412,
     + 9.5849483, 9.5849554, 9.5849625, 9.5849696, 9.5849767, 9.5849838,
     + 9.5849909, 9.5849980, 9.5850051, 9.5850122, 9.5850193, 9.5850264,
     + 9.5850335, 9.5850406, 9.5850477, 9.5850548, 9.5850619, 9.5850690,
     + 9.5850761, 9.5850832, 9.5850903, 9.5850974, 9.5851045, 9.5851116,
     + 9.5851187, 9.5851258, 9.5851329, 9.5851400, 9.5851471, 9.5851542,
     + 9.5851613, 9.5851684, 9.5851755, 9.5851826, 9.5851897, 9.5851968,
     + 9.5852039, 9.5852110, 9.5852181, 9.5852252, 9.5852323, 9.5852394,
     + 9.5852465, 9.5852536, 9.5852607, 9.5852678, 9.5852749, 9.5852820,
     + 9.5852891, 9.5852962, 9.5853033, 9.5853104, 9.5853175, 9.5853246,
     + 9.5853317, 9.5853457, 9.5853534, 9.5853610, 9.5853686, 9.5853762,
     + 9.5853838, 9.5853914, 9.5853990, 9.5854066, 9.5854216, 9.5854299,
     + 9.5854380, 9.5854461, 9.5854542, 9.5854623, 9.5854704, 9.5854785,
     + 9.5854866, 9.5855026, 9.5855114, 9.5855200, 9.5855286, 9.5855372,
     + 9.5855458, 9.5855544, 9.5855714, 9.5855803, 9.5855973, 9.5856062,
     + 9.5856232, 9.5856410, 9.5856590, 9.5856686, 9.5856782, 9.5856878,
     + 9.5856974, 9.5857164, 9.5857263, 9.5857453, 9.5857650, 9.5857760,
     + 9.5857870, 9.5857990, 9.5858110, 9.5858230, 9.5858350, 9.5858470,
     + 9.5858590, 9.5858710, 9.5858830, 9.5858950, 9.5859070, 9.5859190,
     + 9.5859310, 9.5859440, 9.5859570, 9.5859700, 9.5859840, 9.5859990,
     + 9.5860140, 9.5860290, 9.5860450, 9.5860620, 9.5860790, 9.5860960,
     + 9.5861130, 9.5861300, 9.5861470, 9.5861650, 9.5861830, 9.5862020,
     + 9.5862210, 9.5862400, 9.5862590, 9.5862780, 9.5862970, 9.5863160,
     + 9.5863350, 9.5863540, 9.5863730, 9.5863920, 9.5864110, 9.5864300,
     + 9.5864490, 9.5864680, 9.5864870, 9.5865060, 9.5865250, 9.5865440,
     + 9.5865630, 9.5865820, 9.5866010, 9.5866200, 9.5866390, 9.5866580,
     + 9.5866770, 9.5866960, 9.5867150, 9.5867340, 9.5867530, 9.5867900,
     + 9.5868260, 9.5868620, 9.5868980, 9.5869340, 9.5869700, 9.5870060,
     + 9.5870420, 9.5870780, 9.5871140, 9.5871500, 9.5871860, 9.5872220,
     + 9.5872580, 9.5872940, 9.5873300, 9.5873660, 9.5874020, 9.5874380,
     + 9.5874740, 9.5875100, 9.5875460, 9.5875820, 9.5876180, 9.5876540,
     + 9.5876900, 9.5877260, 9.5877620, 9.5877980, 9.5878340, 9.5878700,
     + 9.5879060, 9.5879420, 9.5879780, 9.5880140, 9.5880500, 9.5880860,
     + 9.5881220, 9.5881580, 9.5881940, 9.5882300, 9.5882660, 9.5883360,
     + 9.5884070, 9.5884780, 9.5885490, 9.5886200, 9.5886910, 9.5887620,
     + 9.5888330, 9.5889040, 9.5889750, 9.5890460, 9.5891170, 9.5891880,
     + 9.5892590, 9.5893300, 9.5894010, 9.5894720, 9.5895430, 9.5896140,
     + 9.5896850, 9.5897560, 9.5898270, 9.5898980, 9.5899690, 9.5900400,
     + 9.5901110, 9.5901820, 9.5902530, 9.5903240, 9.5903950, 9.5904660,
     + 9.5905370, 9.5906080, 9.5906790, 9.5907500, 9.5908210, 9.5909610,
     + 9.5910360, 9.5911760, 9.5912540, 9.5914040, 9.5915600, 9.5917200,
     + 9.5918800, 9.5920500, 9.5922200, 9.5924000, 9.5924960, 9.5926860,
     + 9.5928000, 9.5929200, 9.5930500, 9.5931900, 9.5933400, 9.5934900,
     + 9.5936400, 9.5937900, 9.5939400, 9.5940900, 9.5942500, 9.5944100,
     + 9.5945800, 9.5947600, 9.5949500, 9.5951400, 9.5953300, 9.5955200,
     + 9.5957100, 9.5959000, 9.5960900, 9.5962800, 9.5964700, 9.5966600,
     + 9.5968500, 9.5970500, 9.5972500, 9.5974500, 9.5976500, 9.5978600,
     + 9.5980700, 9.5982900, 9.5985100, 9.5987400, 9.5989800, 9.5992200,
     + 9.5994600, 9.5999300, 9.6003900, 9.6008500, 9.6013100, 9.6017700,
     + 9.6022300, 9.6026900, 9.6031500, 9.6036100, 9.6040700, 9.6045300,
     + 9.6049900, 9.6054500, 9.6059100, 9.6063700, 9.6068300, 9.6072900,
     + 9.6077500, 9.6086500, 9.6095600, 9.6104700, 9.6113800, 9.6122900,
     + 9.6132000, 9.6141100, 9.6150200, 9.6159300, 9.6168400, 9.6177500,
     + 9.6186600, 9.6195700, 9.6204800, 9.6213900, 9.6231900, 9.6251000,
     + 9.6271000, 9.6292000, 9.6314000, 9.6337000, 9.6360000, 9.6383000,
     + 9.6406000, 9.6429000, 9.6452000, 9.6475000, 9.6498000, 9.6521000,
     + 9.6566000, 9.6612000, 9.6658000, 9.6704000, 9.6750000, 9.6796000,
     + 9.6842000, 9.6888000, 9.6934000, 9.7024000, 9.7115000, 9.7206000,
     + 9.7297000, 9.7388000, 9.7479000, 9.7570000, 9.7750000, 9.7940000,
     + 9.8140000, 9.8340000, 9.8540000, 9.8750000, 9.9160000, 9.9570000,
     + 9.9980000,10.0390000,10.1190000,10.2000000,10.2810000,10.4410000,
     +10.6100000,10.7800000,11.1100000,11.4200000,11.5900000,11.9200000,
     +12.2300000,12.5500000,12.5910000,12.6120000,12.6530000,12.6940000,
     +12.7740000,12.9340000,12.9560000,12.9591000,12.9599600,12.9599910,
     +12.9599991,12.9599997,12.9600000,12.9600000,12.9600000,12.9600000,
     +12.9600000,12.9600001,12.9600001,12.9600003,12.9600006,12.9600011,
     +12.9600022,12.9600044,12.9600088,12.9600168,12.9600328,12.9600648,
     +12.9601248,12.9602448,12.9604848,12.9609648,12.9618648,12.9636648,
     +12.9672648,12.9742648,12.9882648,13.0162648,13.0722648,13.1280000,
     +13.1840000,13.2400000,13.2960000,13.3250000,13.3540000,13.3830000,
     +13.3980000,13.4130000,13.4290000,13.4460000,13.4546000,13.4632000,
     +13.4676000,13.4687000,13.4688500,13.4688920,13.4688976,13.4688992,
     +13.4688996,13.4688998,13.4688999,13.4689000,13.4689000,13.4689000,
     +13.4689000,13.4689001,13.4689001,13.4689002,13.4689005,13.4689010,
     +13.4689019,13.4689037,13.4689073,13.4689143,13.4689283,13.4689563,
     +13.4690123,13.4691223,13.4693423,13.4697823,13.4705823,13.4721823,
     +13.4753823,13.4813823,13.4875000,13.4936000,13.4997000,13.5028000,
     +13.5036100,13.5040300,13.5042400,13.5042960,13.5043036,13.5043075,
     +13.5043094,13.5043104,13.5043106,13.5043108,13.5043108,13.5043108,
     +13.5043108,13.5043108,13.5043109,13.5043109,13.5043111,13.5043114,
     +13.5043119,13.5043130,13.5043152,13.5043196,13.5043276,13.5043436,
     +13.5043756,13.5044356,13.5045556,13.5047956,13.5052756,13.5061756,
     +13.5079756,13.5115756,13.5152000,13.5188000,13.5224000,13.5260000,
     +13.5296000,13.5332000,13.5351000,13.5370000,13.5390000,13.5411000,
     +13.5432000,13.5454000,13.5477000,13.5489000,13.5502000,13.5515000,
     +13.5529000,13.5544000,13.5560000,13.5568100,13.5576200,13.5584300,
     +13.5592400,13.5600500,13.5608600,13.5616700,13.5624800,13.5632900,
     +13.5641000,13.5649100,13.5657200,13.5661300,13.5665400,13.5669500,
     +13.5673600,13.5677700,13.5681800,13.5685900,13.5690000,13.5694100,
     +13.5698200,13.5702300,13.5706400,13.5710500,13.5714600,13.5718700,
     +13.5722800,13.5724900,13.5727100,13.5729300,13.5731600,13.5734000,
     +13.5736400,13.5738800,13.5741200,13.5743600,13.5746000,13.5748500,
     +13.5751000,13.5753500,13.5756000,13.5757400,13.5758900,13.5760400,
     +13.5761900,13.5763400,13.5765000,13.5766600,13.5768200,13.5769900,
     +13.5771600,13.5773400,13.5774360,13.5775320,13.5776280,13.5777240,
     +13.5778200,13.5779160,13.5780120,13.5781080,13.5782040,13.5783000,
     +13.5783960,13.5784920,13.5785880,13.5786840,13.5787800,13.5788760,
     +13.5789720,13.5790680,13.5791640,13.5792600,13.5793560,13.5794520,
     +13.5795480,13.5796440,13.5797400,13.5798360,13.5799320,13.5800280,
     +13.5801240,13.5802200,13.5803160,13.5804120,13.5805080,13.5806040,
     +13.5807000,13.5807960,13.5808920,13.5809880,13.5810840,13.5811800,
     +13.5812760,13.5813720,13.5814680,13.5815640,13.5816600,13.5817090,
     +13.5817550,13.5818010,13.5818470,13.5818930,13.5819390,13.5819850,
     +13.5820310,13.5820550,13.5820790,13.5821040,13.5821290,13.5821550,
     +13.5821820,13.5822090,13.5822360,13.5822640,13.5822920,13.5823210,
     +13.5823500,13.5823660,13.5823820,13.5823990,13.5824160,13.5824340,
     +13.5824520,13.5824710,13.5824900,13.5825090,13.5825280,13.5825470,
     +13.5825660,13.5825850,13.5826040,13.5826230,13.5826420,13.5826610,
     +13.5826800,13.5826990,13.5827180,13.5827370,13.5827560,13.5827750,
     +13.5827940,13.5828130,13.5828320,13.5828416,13.5828512,13.5828608,
     +13.5828704,13.5828800,13.5828896,13.5828992,13.5829088,13.5829184,
     +13.5829280,13.5829376,13.5829472,13.5829568,13.5829664,13.5829760,
     +13.5829856,13.5829952,13.5830048,13.5830144,13.5830240,13.5830336,
     +13.5830432,13.5830528,13.5830624,13.5830720,13.5830816,13.5830912,
     +13.5831008,13.5831104,13.5831200,13.5831296,13.5831392,13.5831488,
     +13.5831584,13.5831680,13.5831776,13.5831872,13.5831968,13.5832064,
     +13.5832160,13.5832256,13.5832352,13.5832448,13.5832544,13.5832640,
     +13.5832736,13.5832832,13.5832928,13.5833024,13.5833120,13.5833216,
     +13.5833406,13.5833520,13.5833640,13.5833760,13.5833880,13.5834000,
     +13.5834120,13.5834240,13.5834360,13.5834590,13.5834830,13.5835070,
     +13.5835310,13.5835550,13.5835790,13.5836260,13.5836720,13.5836960,
     +13.5837200,13.5837440,13.5837680,13.5837920,13.5838050,13.5838190,
     +13.5838340,13.5838490,13.5838640,13.5838800,13.5838960,13.5839130,
     +13.5839300,13.5839470,13.5839650,13.5839830,13.5839926,13.5840022,
     +13.5840118,13.5840214,13.5840310,13.5840406,13.5840502,13.5840598,
     +13.5840694,13.5840790,13.5840886,13.5840982,13.5841078,13.5841174,
     +13.5841270,13.5841366,13.5841462,13.5841558,13.5841654,13.5841750,
     +13.5841846,13.5841942,13.5842038,13.5842134,13.5842230,13.5842326,
     +13.5842422,13.5842518,13.5842614,13.5842710,13.5842806,13.5842902,
     +13.5842998,13.5843094,13.5843190,13.5843286,13.5843382,13.5843478,
     +13.5843574,13.5843670,13.5843766,13.5843862,13.5843958,13.5844054,
     +13.5844150,13.5844340,13.5844441,13.5844542,13.5844643,13.5844744,
     +13.5844845,13.5845045,13.5845250,13.5845360,13.5845480,13.5845600,
     +13.5845720,13.5845840,13.5845960,13.5846080,13.5846200,13.5846320,
     +13.5846440,13.5846670,13.5846800,13.5846930,13.5847070,13.5847220,
     +13.5847370,13.5847520,13.5847680,13.5847840,13.5848010,13.5848180,
     +13.5848350,13.5848530,13.5848710,13.5848900,13.5849090,13.5849280,
     +13.5849470,13.5849660,13.5849850,13.5850040,13.5850230,13.5850420,
     +13.5850790,13.5851150,13.5851510,13.5851870,13.5852230,13.5852590,
     +13.5852950,13.5853310,13.5853670,13.5854030,13.5854730,13.5855440,
     +13.5856150,13.5856860,13.5857570,13.5858280,13.5858990,13.5859700,
     +13.5860410,13.5861120,13.5861830,13.5862540,13.5863250,13.5863960,
     +13.5864670,13.5865380,13.5866090,13.5866800,13.5867510,13.5868220,
     +13.5868930,13.5869640,13.5870350,13.5871060,13.5871770,13.5872480,
     +13.5873190,13.5873900,13.5874610,13.5875320,13.5876030,13.5876740,
     +13.5877450,13.5878160,13.5878870,13.5879580,13.5880290,13.5881000,
     +13.5881710,13.5882420,13.5883130,13.5883840,13.5884550,13.5885260,
     +13.5886660,13.5887440,13.5888200,13.5889700,13.5890510,13.5891320,
     +13.5892920,13.5893770,13.5894630,13.5896330,13.5898100,13.5899900,
     +13.5901700,13.5903600,13.5905500,13.5907400,13.5909300,13.5911300,
     +13.5913300,13.5915300,13.5917300,13.5919400,13.5921500,13.5923700,
     +13.5925900,13.5928200,13.5930600,13.5933000,13.5935400,13.5937800,
     +13.5940200,13.5942600,13.5945000,13.5947500,13.5950000,13.5952500,
     +13.5955100,13.5957700,13.5960400,13.5963100,13.5965900,13.5968800,
     +13.5971700,13.5974700,13.5977700,13.5983600,13.5989200,13.5994800,
     +13.6000400,13.6006000,13.6011600,13.6017200,13.6022800,13.6028400,
     +13.6034000,13.6039600,13.6045200,13.6050800,13.6056400,13.6067400,
     +13.6079000,13.6091000,13.6104000,13.6117000,13.6131000,13.6146000,
     +13.6162000,13.6178000,13.6194000,13.6210000,13.6226000,13.6242000,
     +13.6258000,13.6274000,13.6306000,13.6337000,13.6368000,13.6399000,
     +13.6430000,13.6461000,13.6492000,13.6523000,13.6584000,13.6645000,
     +13.6706000,13.6767000,13.6828000,13.6889000,13.7009000,13.7140000,
     +13.7280000,13.7420000,13.7570000,13.7720000,13.8020000,13.8330000,
     +13.8950000,13.9110000,13.9154000,13.9195000,13.9236000,13.9277000,
     +13.9357000,13.9517000,13.9690000,14.0030000,14.0190000,14.0276000,
     +14.0320000,14.0400000,14.0481000,14.0522000,14.0563000,14.0604000,
     +14.0645000,14.0666000,14.0688000,14.0711000,14.0714100,14.0720300,
     +14.0732300,14.0756300,14.0781000,14.0794000,14.0808000,14.0835000,
     +14.0863000,14.0878000,14.0886100,14.0894200,14.0896300,14.0900500,
     +14.0908500,14.0924500,14.0956500,14.0964800,14.0972900,14.0981000,
     +14.0985100,14.0993100,14.1009100,14.1026000,14.1043000,14.1051600,
     +14.1060200,14.1068800,14.1073200,14.1075400,14.1079800,14.1087800,
     +14.1103800,14.1121000,14.1139000,14.1148600,14.1158200,14.1167800,
     +14.1172700,14.1181700,14.1199700,14.1219000,14.1230000,14.1242000,
     +14.1248100,14.1260100,14.1273000,14.1298000,14.1312000,14.1327000,
     +14.1334600,14.1342200,14.1346100,14.1353100,14.1360200,14.1367300,
     +14.1371000,14.1372900,14.1374800,14.1378500,14.1382100,14.1385700,
     +14.1392700,14.1406700,14.1422000,14.1426100,14.1430200,14.1438200,
     +14.1446300,14.1454400,14.1458500,14.1459060,14.1459210,14.1459249,
     +14.1459268,14.1459269,14.1459269,14.1459269,14.1459269,14.1459269,
     +14.1459270,14.1459271,14.1459272,14.1459275,14.1459281,14.1459293,
     +14.1459317,14.1459365,14.1459455,14.1459635,14.1459995,14.1460695,
     +14.1462095,14.1464895,14.1470495,14.1481495,14.1493000,14.1499100,
     +14.1505200,14.1508400,14.1511500,14.1514700,14.1520700,14.1523900,
     +14.1525500,14.1526360,14.1528060,14.1529900,14.1531800,14.1535500,
     +14.1539100,14.1541000,14.1544700,14.1551700,14.1558800,14.1565900,
     +14.1579900,14.1595000,14.1603100,14.1611200,14.1619300,14.1627400,
     +14.1631500,14.1639500,14.1655500,14.1659700,14.1663800,14.1665900,
     +14.1668000,14.1670100,14.1671300,14.1672600,14.1673900,14.1676500,
     +14.1677210,14.1678610,14.1681410,14.1684300,14.1687200,14.1692900,
     +14.1703900,14.1716000,14.1719400,14.1725400,14.1737400,14.1750000,
     +14.1775000,14.1789000,14.1796600,14.1804200,14.1808100,14.1811700,
     +14.1813600,14.1817300,14.1824300,14.1838300,14.1866300,14.1882000,
     +14.1890100,14.1906100,14.1938100,14.1946600,14.1954700,14.1962800,
     +14.1970900,14.1975000,14.1977200,14.1981500,14.1985600,14.1993600,
     +14.2009600,14.2041600,14.2058000,14.2075000,14.2084100,14.2102100,
     +14.2121000,14.2140000,14.2159000,14.2169100,14.2174200,14.2179300,
     +14.2189300,14.2209300,14.2221000,14.2227100,14.2239100,14.2245600,
     +14.2248700,14.2251900,14.2255000,14.2261200,14.2264400,14.2265210,
     +14.2266810,14.2270010,14.2276010,14.2279200,14.2280010,14.2281610,
     +14.2284810,14.2290810,14.2294000,14.2297100,14.2303200,14.2315200,
     +14.2339200,14.2353000,14.2380000,14.2408000,14.2423000,14.2431100,
     +14.2447100,14.2455600,14.2471600,14.2503600,14.2520000,14.2528600,
     +14.2537200,14.2554200,14.2563200,14.2567600,14.2571700,14.2575800,
     +14.2577900,14.2580100,14.2581300,14.2581960,14.2583260,14.2584700,
     +14.2587500,14.2590400,14.2596100,14.2607100,14.2619000,14.2625100,
     +14.2637100,14.2650000,14.2675000,14.2689000,14.2696600,14.2704200,
     +14.2711800,14.2715700,14.2717600,14.2719500,14.2723200,14.2726800,
     +14.2730400,14.2731360,14.2731610,14.2731629,14.2731629,14.2731629,
     +14.2731630,14.2731630,14.2731632,14.2731635,14.2731640,14.2731651,
     +14.2731673,14.2731717,14.2731797,14.2731957,14.2732277,14.2732877,
     +14.2734077,14.2736477,14.2741277,14.2750277,14.2759400,14.2777400,
     +14.2786800,14.2795900,14.2805000,14.2806300,14.2808800,14.2811400,
     +14.2814100,14.2819500,14.2829500,14.2832200,14.2837600,14.2847600,
     +14.2852800,14.2857900,14.2859300,14.2860800,14.2863800,14.2866900,
     +14.2868600,14.2869040,14.2869840,14.2871440,14.2874640,14.2876300,
     +14.2877210,14.2879010,14.2880900,14.2882800,14.2883760,14.2884010,
     +14.2884500,14.2885400,14.2887200,14.2890800,14.2894400,14.2896300,
     +14.2897260,14.2898220,14.2898710,14.2899170,14.2900070,14.2901870,
     +14.2905470,14.2909100,14.2911000,14.2912900,14.2913860,14.2914820,
     +14.2915780,14.2917680,14.2919700,14.2923700,14.2931700,14.2935800,
     +14.2937900,14.2940100,14.2942400,14.2943700,14.2944040,14.2944350,
     +14.2944660,14.2945270,14.2945880,14.2947080,14.2948400,14.2949110,
     +14.2950510,14.2953310,14.2956200,14.2957700,14.2958460,14.2959220,
     +14.2959980,14.2961480,14.2962300,14.2963900,14.2964760,14.2966460,
     +14.2969860,14.2971500,14.2973200,14.2974060,14.2974920,14.2976620,
     +14.2977520,14.2979220,14.2982620,14.2985700,14.2987400,14.2988260,
     +14.2989120,14.2990820,14.2991720,14.2992580,14.2993440,14.2995140,
     +14.2998540,14.3001600,14.3003300,14.3005000,14.3005910,14.3007710,
     +14.3011310,14.3014900,14.3016800,14.3018700,14.3022400,14.3024300,
     +14.3028000,14.3035000,14.3042100,14.3045700,14.3047600,14.3049500,
     +14.3050460,14.3052360,14.3053500,14.3055700,14.3060100,14.3068100,
     +14.3076200,14.3078300,14.3080400,14.3084600,14.3088700,14.3096700,
     +14.3104800,14.3120800,14.3138000,14.3147100,14.3156200,14.3160800,
     +14.3165400,14.3170000,14.3174600,14.3177000,14.3179400,14.3184200,
     +14.3188800,14.3197800,14.3206900,14.3224900,14.3234500,14.3244100,
     +14.3253700,14.3258600,14.3263200,14.3267800,14.3276800,14.3285900,
     +14.3303900,14.3323000,14.3334000,14.3340100,14.3346200,14.3358200,
     +14.3364700,14.3377700,14.3403700,14.3418000,14.3425600,14.3433200,
     +14.3440800,14.3448400,14.3456000,14.3471000,14.3501000,14.3517000,
     +14.3525100,14.3541100,14.3549600,14.3566600,14.3585000,14.3604000,
     +14.3613600,14.3623200,14.3625700,14.3630700,14.3640700,14.3660700,
     +14.3700700,14.3780700,14.3862000,14.3943000,14.3984000,14.4005000,
     +14.4047000,14.4127000,14.4287000,14.4374000,14.4397000,14.4442000,
     +14.4532000,14.4712000,14.5072000,14.5430000,14.5790000,14.5980000,
     +14.6360000,14.6720000,14.7420000,14.7516000,14.7706000,14.8086000,
     +14.8786000,14.9500000,14.9870000,14.9919000,14.9922400,14.9923210,
     +14.9923620,14.9923830,14.9923838,14.9923840,14.9923840,14.9923840,
     +14.9923840,14.9923840,14.9923841,14.9923841,14.9923842,14.9923845,
     +14.9923850,14.9923859,14.9923877,14.9923913,14.9923983,14.9924123,
     +14.9924403,14.9924963,14.9926063,14.9928263,14.9932663,14.9940663,
     +14.9956663,14.9988663,15.0048663,15.0110000,15.0230000,15.0360000,
     +15.0610000,15.1110000,15.1380000,15.1910000,15.2170000,15.2680000,
     +15.3190000,15.4190000,15.4330000,15.4401000,15.4437000,15.4507000,
     +15.4578000,15.4614000,15.4684000,15.4824000,15.4970000,15.5046000,
     +15.5196000,15.5279000,15.5439000,15.5610000,15.5701000,15.5881000,
     +15.5976000,15.6156000,15.6350000,15.6460000,15.6680000,15.6800000,
     +15.6920000,15.7050000,15.7300000,15.7560000,15.7631000,15.7771000,
     +15.7920000,15.7996000,15.8146000,15.8310000,15.8630000,15.8790000,
     +15.8876000,15.9046000,15.9093000,15.9183000,15.9274000,15.9365000,
     +15.9545000,15.9905000,15.9998000,16.0178000,16.0370000,16.0750000,
     +16.1110000,16.1300000,16.1490000,16.1591000,16.1791000,16.2000000,
     +16.2410000,16.2620000,16.3040000,16.3150000,16.3211000,16.3331000,
     +16.3460000,16.3526000,16.3560000,16.3620000,16.3681000,16.3712000,
     +16.3773000,16.3893000,16.3958000,16.4019000,16.4139000,16.4174000,
     +16.4191000,16.4224000,16.4284000,16.4345000,16.4406000,16.4526000,
     +16.4561000,16.4621000,16.4652000,16.4668000,16.4699000,16.4761000,
     +16.4822000,16.4883000,16.4944000,16.5064000,16.5128000,16.5159000,
     +16.5220000,16.5281000,16.5342000,16.5462000,16.5590000,16.5624000,
     +16.5655000,16.5716000,16.5777000,16.5838000,16.5899000,16.5960000,
     +16.6021000,16.6141000,16.6206000,16.6326000,16.6460000,16.6600000,
     +16.6636000,16.6706000,16.6846000,16.7000000,16.7300000,16.7460000,
     +16.7541000,16.7582000,16.7623000,16.7703000,16.7784000,16.7825000,
     +16.7905000,16.8065000,16.8108000,16.8188000,16.8269000,16.8350000,
     +16.8510000,16.8596000,16.8682000,16.8768000,16.8812000,16.8833000,
     +16.8875000,16.8955000,16.9036000,16.9077000,16.9118000,16.9139000,
     +16.9161000,16.9173000,16.9197000,16.9245000,16.9335000,16.9426000,
     +16.9517000,16.9564000,16.9577000,16.9602000,16.9652000,16.9703000,
     +16.9754000,16.9854000,16.9955000,17.0056000,17.0157000,17.0357000,
     +17.0757000,17.0854000,17.1044000,17.1143000,17.1333000,17.1530000,
     +17.1920000,17.2280000,17.2470000,17.2840000,17.3030000,17.3410000,
     +17.3600000,17.3790000,17.3891000,17.3992000,17.4192000,17.4400000,
     +17.4610000,17.4830000,17.4891000,17.4923000,17.4954000,17.5015000,
     +17.5135000,17.5375000,17.5510000,17.5586000,17.5736000,17.5900000,
     +17.6220000,17.6530000,17.7140000,17.7221000,17.7262000,17.7342000,
     +17.7383000,17.7404000,17.7415000,17.7437000,17.7481000,17.7522000,
     +17.7563000,17.7604000,17.7684000,17.7844000,17.8010000,17.8190000,
     +17.8540000,17.8589000,17.8679000,17.8859000,17.8956000,17.9146000,
     +17.9526000,17.9624000,17.9720000,17.9910000,18.0011000,18.0112000,
     +18.0312000,18.0712000,18.1070000,18.1166000,18.1356000,18.1470000,
     +18.1590000,18.1710000,18.1840000,18.1911000,18.2051000,18.2126000,
     +18.2276000,18.2359000,18.2519000,18.2605000,18.2775000,18.2950000,
     +18.3130000,18.3480000,18.3840000,18.4030000,18.4400000,18.5100000,
     +18.5290000,18.5490000,18.5880000,18.6240000,18.6600000,18.7300000,
     +18.8010000,18.8370000,18.8730000,18.9430000,19.0140000,19.0500000,
     +19.1200000,19.1390000,19.1580000,19.1960000,19.2009000,19.2099000,
     +19.2279000,19.2376000,19.2472000,19.2662000,19.2762000,19.2962000,
     +19.3080000,19.3310000,19.3550000,19.3680000,19.3820000,19.3960000,
     +19.4100000,19.4370000,19.4441000,19.4478000,19.4548000,19.4688000,
     +19.4968000,19.5120000,19.5420000,19.5730000,19.5811000,19.5852000,
     +19.5873000,19.5885000,19.5891100,19.5903100,19.5916000,19.5941000,
     +19.5991000,19.6091000,19.6291000,19.6691000,19.6786000,19.6966000,
     +19.7160000,19.7540000,19.7900000,19.8600000,19.8960000,19.9320000,
     +19.9680000,20.0040000,20.0400000,20.0590000,20.0790000,20.1180000,
     +20.1540000,20.2240000,20.3640000,20.5100000,20.8000000,20.8410000,
     +20.8820000,20.9040000,20.9056000,20.9058100,20.9059300,20.9059610,
     +20.9059691,20.9059733,20.9059745,20.9059751,20.9059752,20.9059752,
     +20.9059753,20.9059753,20.9059753,20.9059753,20.9059753,20.9059754,
     +20.9059754,20.9059756,20.9059760,20.9059767,20.9059781,20.9059809,
     +20.9059865,20.9059975,20.9060195,20.9060635,20.9061435,20.9063035,
     +20.9066235,20.9072235,20.9084235,20.9108235,20.9156235,20.9246235,
     +20.9426235,20.9786235,21.0486235,21.1886235,21.3400000,21.3810000,
     +21.4610000,21.5420000,21.7020000,21.7870000,21.9470000,21.9910000,
     +22.0710000,22.2310000,22.5510000,22.6360000,22.7220000,22.7251000,
     +22.7255400,22.7255412,22.7255418,22.7255418,22.7255418,22.7255418,
     +22.7255419,22.7255419,22.7255420,22.7255421,22.7255425,22.7255431,
     +22.7255443,22.7255467,22.7255515,22.7255605,22.7255785,22.7256145,
     +22.7256845,22.7258245,22.7261045,22.7266645,22.7277645,22.7299645,
     +22.7343645,22.7423645,22.7583645,22.7903645,22.8503645,22.9703645,
     +23.2103645,23.6903645,24.5903645,24.8400000,24.9700000,24.9880000,
     +24.9976000,24.9989000,24.9996100,24.9999700,24.9999950,24.9999984,
     +24.9999992,24.9999996,24.9999998,24.9999999,25.0000000,25.0000000,
     +25.0000000,25.0000000,25.0000000,25.0000001,25.0000001,25.0000002,
     +25.0000005,25.0000010,25.0000019,25.0000037,25.0000073,25.0000143,
     +25.0000283,25.0000563,25.0001123,25.0002223,25.0004423,25.0008823,
     +25.0016823,25.0032823,25.0064823,25.0124823,25.0244823,25.0484823,
     +25.0964823,25.1864823,25.3664823,25.5600000,25.9400000,26.6400000,
     +27.0000000,27.7000000,29.1000000,29.8600000,30.2500000,30.9500000,
     +32.3500000,35.1500000,35.9300000,36.3200000,36.5100000,36.7000000,
     +37.0800000,37.7800000,39.1800000,41.9800000,47.5800000,48.3500000,
     +48.4600000,48.4890000,48.4971000,48.4972500,48.4972890,48.4972939,
     +48.4972952,48.4972959,48.4972960,48.4972960,48.4972960,48.4972960,
     +48.4972960,48.4972960,48.4972961,48.4972962,48.4972964,48.4972969,
     +48.4972977,48.4972993,48.4973025,48.4973085,48.4973205,48.4973445,
     +48.4973925,48.4974825,48.4976625,48.4980225,48.4987225,48.5001225,
     +48.5029225,48.5085225,48.5195225,48.5405225,48.5825225,48.6625225,
     +48.8225225,49.1425225,49.7425225,50.9425225,52.2000000,54.7000000,
     +59.7000000,64.8000000,69.9000000,79.9000000,82.5000000,85.1000000,
     +86.6000000,87.4100000,87.8200000,88.0300000,88.1400000,88.3500000,
     +88.5700000,88.6900000,88.8100000,88.9400000,89.0060000,89.0720000,
     +89.1380000,89.1720000,89.2030000,89.2350000,89.2660000,89.2830000,
     +89.3000000,89.3170000,89.3350000,89.3446000,89.3542000,89.3638000,
     +89.3734000,89.3830000,89.3879000,89.3969000,89.4015000,89.4061000,
     +89.4107000,89.4153000,89.4199000,89.4245000,89.4291000,89.4315000,
     +89.4339000,89.4364000,89.4389000,89.4414000,89.4439000,89.4464000,
     +89.4490000,89.4504000,89.4519000,89.4535000,89.4551000,89.4567000,
     +89.4583000,89.4600000,89.4608600,89.4617200,89.4625800,89.4634400,
     +89.4643000,89.4651600,89.4660200,89.4668800,89.4677400,89.4686000,
     +89.4694600,89.4703200,89.4711800,89.4720400,89.4724800,89.4732800,
     +89.4736900,89.4741000,89.4745100,89.4749200,89.4753300,89.4757400,
     +89.4761500,89.4765600,89.4769700,89.4773800,89.4777900,89.4782000,
     +89.4786100,89.4790200,89.4794300,89.4798400,89.4800600,89.4802800,
     +89.4805000,89.4807200,89.4809400,89.4811600,89.4813800,89.4816000,
     +89.4818200,89.4820500,89.4822800,89.4825200,89.4827700,89.4830200,
     +89.4832800,89.4834200,89.4835700,89.4837200,89.4838800,89.4840500,
     +89.4842200,89.4843900,89.4845600,89.4847300,89.4849100,89.4851000,
     +89.4851960,89.4852920,89.4853880,89.4854840,89.4855800,89.4856760,
     +89.4857720,89.4858680,89.4859640,89.4860600,89.4861560,89.4862520,
     +89.4863480,89.4864440,89.4865400,89.4866360,89.4867320,89.4868280,
     +89.4869240,89.4870200,89.4871160,89.4872120,89.4873080,89.4874040,
     +89.4875000,89.4875960,89.4876920,89.4877880,89.4878370,89.4879270,
     +89.4879730,89.4880630,89.4881090,89.4881550,89.4882010,89.4882470,
     +89.4882930,89.4883390,89.4883850,89.4884310,89.4884770,89.4885230,
     +89.4885690,89.4886150,89.4886610,89.4887070,89.4887530,89.4887990,
     +89.4888450,89.4888910,89.4889370,89.4889830,89.4890290,89.4890750,
     +89.4891210,89.4891670,89.4892130,89.4892590,89.4893050,89.4893510,
     +89.4893970,89.4894430,89.4894890,89.4895350,89.4895810,89.4896270,
     +89.4896730,89.4897190,89.4897650,89.4897890,89.4898140,89.4898390,
     +89.4898640,89.4898900,89.4899170,89.4899440,89.4899720,89.4900010,
     +89.4900300,89.4900590,89.4900890,89.4901190,89.4901490,89.4901800,
     +89.4902110,89.4902430,89.4902740,89.4903060,89.4903370,89.4903690,
     +89.4904000,89.4904310,89.4904630,89.4904940,89.4905110,89.4905280,
     +89.4905450,89.4905620,89.4905790,89.4905960,89.4906130,89.4906300,
     +89.4906470,89.4906640,89.4906810,89.4906980,89.4907150,89.4907320,
     +89.4907490,89.4907660,89.4907830,89.4908000,89.4908170,89.4908340,
     +89.4908510,89.4908680,89.4908850,89.4909020,89.4909190,89.4909360,
     +89.4909530,89.4909700,89.4909870,89.4910040,89.4910210,89.4910380,
     +89.4910550,89.4910730,89.4910910,89.4911090,89.4911270,89.4911450,
     +89.4911640,89.4911830,89.4912020,89.4912220,89.4912420,89.4912630,
     +89.4912840,89.4913060,89.4913290,89.4913520,89.4913750,89.4913980,
     +89.4914210,89.4914450,89.4914690,89.4914930,89.4915400,89.4915860,
     +89.4915990,89.4915999,89.4916000,89.4916000,89.4916000,89.4916000,
     +89.4916001,89.4916001,89.4916003,89.4916006,89.4916011,89.4916022,
     +89.4916044,89.4916088,89.4916168,89.4916328,89.4916500,89.4916680,
     +89.4916771,89.4916862,89.4916953,89.4917044,89.4917135,89.4917226,
     +89.4917317,89.4917408,89.4917499,89.4917590,89.4917681,89.4917772,
     +89.4917863,89.4917954,89.4918045,89.4918136,89.4918227,89.4918318,
     +89.4918364,89.4918410,89.4918456,89.4918502,89.4918548,89.4918594,
     +89.4918640,89.4918686,89.4918732,89.4918778,89.4918824,89.4918870,
     +89.4918916,89.4918962,89.4919008,89.4919054,89.4919100,89.4919146,
     +89.4919192,89.4919238,89.4919284,89.4919330,89.4919376,89.4919422,
     +89.4919468,89.4919514,89.4919560,89.4919606,89.4919652,89.4919698,
     +89.4919744,89.4919790,89.4919836,89.4919882,89.4919928,89.4919974,
     +89.4920020,89.4920066,89.4920112,89.4920158,89.4920204,89.4920250,
     +89.4920296,89.4920342,89.4920388,89.4920434,89.4920480,89.4920526,
     +89.4920572,89.4920618,89.4920664,89.4920710,89.4920756,89.4920802,
     +89.4920848,89.4920894,89.4920940,89.4920964,89.4920988,89.4921012,
     +89.4921036,89.4921060,89.4921084,89.4921108,89.4921132,89.4921156,
     +89.4921180,89.4921204,89.4921228,89.4921252,89.4921276,89.4921300,
     +89.4921324,89.4921349,89.4921374,89.4921399,89.4921425,89.4921452,
     +89.4921479,89.4921506,89.4921534,89.4921562,89.4921591,89.4921620,
     +89.4921649,89.4921678,89.4921707,89.4921737,89.4921767,89.4921798,
     +89.4921830,89.4921861,89.4921893,89.4921924,89.4921956,89.4921987,
     +89.4922019,89.4922050,89.4922082,89.4922113,89.4922145,89.4922176,
     +89.4922207,89.4922239,89.4922270,89.4922302,89.4922333,89.4922365,
     +89.4922396,89.4922428,89.4922459,89.4922491,89.4922522,89.4922554,
     +89.4922585,89.4922617,89.4922648,89.4922680,89.4922711,89.4922743,
     +89.4922774,89.4922806,89.4922837,89.4922869,89.4922900,89.4922932,
     +89.4922963,89.4922995,89.4923026,89.4923058,89.4923089,89.4923121,
     +89.4923152,89.4923184,89.4923215,89.4923247,89.4923278,89.4923310,
     +89.4923341,89.4923373,89.4923404,89.4923435,89.4923467,89.4923498,
     +89.4923530,89.4923561,89.4923593,89.4923624,89.4923656,89.4923687,
     +89.4923719,89.4923750,89.4923782,89.4923813,89.4923845,89.4923905,
     +89.4923966,89.4924027,89.4924088,89.4924149,89.4924210,89.4924330,
     +89.4924460,89.4924531,89.4924602,89.4924673,89.4924744,89.4924815,
     +89.4924851,89.4924887,89.4924923,89.4924959,89.4924995,89.4925031,
     +89.4925067,89.4925103,89.4925139,89.4925175,89.4925211,89.4925247,
     +89.4925283,89.4925319,89.4925355,89.4925391,89.4925427,89.4925463,
     +89.4925499,89.4925535,89.4925571,89.4925607,89.4925643,89.4925679,
     +89.4925715,89.4925751,89.4925787,89.4925823,89.4925859,89.4925895,
     +89.4925931,89.4925967,89.4926003,89.4926039,89.4926075,89.4926111,
     +89.4926147,89.4926183,89.4926219,89.4926255,89.4926291,89.4926327,
     +89.4926363,89.4926399,89.4926435,89.4926471,89.4926507,89.4926543,
     +89.4926579,89.4926615,89.4926651,89.4926687,89.4926723,89.4926759,
     +89.4926795,89.4926831,89.4926867,89.4926903,89.4926939,89.4926975,
     +89.4927011,89.4927047,89.4927083,89.4927119,89.4927155,89.4927191,
     +89.4927227,89.4927263,89.4927299,89.4927335,89.4927371,89.4927407,
     +89.4927443,89.4927479,89.4927515,89.4927551,89.4927587,89.4927623,
     +89.4927659,89.4927695,89.4927731,89.4927767,89.4927803,89.4927839,
     +89.4927875,89.4927911,89.4927947,89.4927983,89.4928019,89.4928055,
     +89.4928091,89.4928127,89.4928163,89.4928199,89.4928235,89.4928271,
     +89.4928307,89.4928343,89.4928379,89.4928415,89.4928451,89.4928487,
     +89.4928523,89.4928559,89.4928595,89.4928631,89.4928667,89.4928703,
     +89.4928739,89.4928775,89.4928811,89.4928847,89.4928883,89.4928919,
     +89.4928955,89.4928991,89.4929027,89.4929063,89.4929099,89.4929135,
     +89.4929171,89.4929207,89.4929243,89.4929279,89.4929315,89.4929351,
     +89.4929387,89.4929423,89.4929459,89.4929495,89.4929531,89.4929567,
     +89.4929603,89.4929673,89.4929744,89.4929815,89.4929886,89.4929957,
     +89.4930028,89.4930099,89.4930170,89.4930241,89.4930312,89.4930383,
     +89.4930454,89.4930525,89.4930596,89.4930667,89.4930738,89.4930809,
     +89.4930880,89.4930951,89.4931022,89.4931093,89.4931164,89.4931235,
     +89.4931306,89.4931377,89.4931448,89.4931519,89.4931659,89.4931810,
     +89.4931970,89.4932140,89.4932310,89.4932480,89.4932650,89.4932980,
     +89.4933290,89.4933610,89.4933920,89.4934090,89.4934260,89.4934430,
     +89.4934600,89.4934770,89.4934940,89.4935110,89.4935280,89.4935450,
     +89.4935620,89.4935790,89.4935960,89.4936130,89.4936300,89.4936470,
     +89.4936640,89.4936810,89.4936980,89.4937150,89.4937320,89.4937490,
     +89.4937660,89.4937830,89.4938000,89.4938170,89.4938340,89.4938510,
     +89.4938680,89.4938850,89.4939020,89.4939190,89.4939360,89.4939530,
     +89.4939700,89.4939870,89.4940040,89.4940210,89.4940380,89.4940550,
     +89.4940730,89.4940910,89.4941090,89.4941270,89.4941450,89.4941630,
     +89.4941820,89.4942010,89.4942200,89.4942400,89.4942600,89.4942810,
     +89.4943030,89.4943260,89.4943490,89.4943720,89.4943950,89.4944180,
     +89.4944410,89.4944640,89.4944870,89.4945100,89.4945330,89.4945560,
     +89.4945800,89.4946040,89.4946280,89.4946520,89.4946770,89.4947020,
     +89.4947270,89.4947530,89.4947800,89.4948070,89.4948350,89.4948640,
     +89.4948930,89.4949220,89.4949520,89.4949820,89.4950120,89.4950430,
     +89.4950740,89.4951060,89.4951370,89.4951690,89.4952000,89.4952320,
     +89.4952630,89.4952940,89.4953260,89.4953570,89.4953890,89.4954200,
     +89.4954510,89.4954830,89.4955140,89.4955460,89.4955770,89.4956090,
     +89.4956400,89.4956710,89.4957030,89.4957340,89.4957660,89.4958260,
     +89.4958870,89.4959480,89.4960090,89.4960700,89.4961310,89.4961920,
     +89.4962530,89.4963140,89.4963750,89.4964360,89.4964970,89.4965580,
     +89.4966190,89.4966800,89.4967410,89.4968020,89.4968630,89.4969240,
     +89.4969850,89.4970460,89.4971070,89.4971680,89.4972290,89.4972900,
     +89.4973510,89.4974120,89.4974730,89.4975340,89.4975950,89.4976560,
     +89.4977170,89.4977780,89.4978390,89.4979000,89.4980200,89.4980860,
     +89.4982160,89.4982890,89.4983600,89.4984310,89.4985710,89.4986470,
     +89.4987230,89.4987990,89.4989490,89.4990310,89.4991910,89.4992770,
     +89.4993630,89.4995330,89.4997100,89.4998900,89.5000800,89.5001810,
     +89.5003810,89.5005900,89.5008000,89.5010200,89.5012400,89.5014600,
     +89.5016800,89.5019000,89.5021200,89.5023400,89.5025600,89.5027800,
     +89.5030000,89.5032300,89.5034600,89.5037000,89.5039500,89.5042000,
     +89.5044600,89.5047200,89.5049800,89.5052400,89.5055000,89.5057700,
     +89.5060500,89.5063300,89.5066200,89.5069200,89.5072200,89.5075200,
     +89.5078300,89.5081400,89.5084500,89.5087600,89.5093700,89.5099800,
     +89.5105900,89.5112000,89.5118100,89.5124200,89.5130300,89.5136400,
     +89.5142500,89.5148600,89.5154700,89.5160800,89.5166900,89.5173000,
     +89.5179100,89.5191100,89.5204000,89.5217000,89.5231000,89.5245000,
     +89.5260000,89.5276000,89.5292000,89.5308000,89.5324000,89.5341000,
     +89.5358000,89.5375000,89.5392000,89.5409000,89.5426000,89.5459000,
     +89.5490000,89.5522000,89.5553000,89.5585000,89.5616000,89.5647000,
     +89.5679000,89.5739000,89.5800000,89.5861000,89.5922000,89.5983000,
     +89.6044000,89.6105000,89.6225000,89.6350000,89.6480000,89.6610000,
     +89.6750000,89.6890000,89.7040000,89.7340000,89.7650000,89.7960000,
     +89.8280000,89.8880000,89.9490000,90.0100000,90.1300000,90.2600000,
     +90.5100000,90.7700000,91.2800000,91.7900000,92.7900000,94.7900000,
     +96.9000000,98.1000000,98.7600000,99.1000000,99.4100000,99.5700000,
     +99.7400000,99.8310000,99.9220000,99.9680000,99.9920000,99.9986000,
     +99.9995100,99.9997500,99.9998800,99.9999460,99.9999800,99.9999881,
     + 99.999990, 99.999993, 99.999995, 99.999996, 99.999997, 99.999998,
     + 99.999999,100.000000,100.000000,100.000000,100.000000,100.000000,
     +100.000000,100.000000,100.000000,100.000000,100.000000,100.000001,
     +100.000001,100.000002,100.000003,100.000004,100.000006,100.000009,
     +100.000015,100.000027,100.000051,100.000099,100.000189,100.000369,
     +100.000729,100.001429,100.002829,100.005629,100.011229,100.022229,
     +100.043229,100.085229,100.126000,100.167000,100.208000,100.249000,
     +100.270000,100.292000,100.315000,100.328000,100.342000,100.356000,
     +100.363600,100.371200,100.378800,100.386400,100.394000,100.397900,
     +100.401500,100.405100,100.408700,100.412300,100.415900,100.419500,
     +100.421400,100.423400,100.425400,100.427500,100.429600,100.431700,
     +100.433800,100.435000,100.436200,100.437400,100.438700,100.440100,
     +100.440810,100.441520,100.442230,100.442940,100.443650,100.444360,
     +100.445070,100.445780,100.446490,100.447200,100.447910,100.448620,
     +100.448980,100.449340,100.449700,100.450060,100.450420,100.450780,
     +100.451140,100.451500,100.451860,100.452220,100.452580,100.452940,
     +100.453300,100.453660,100.453850,100.454040,100.454240,100.454450,
     +100.454660,100.454870,100.455090,100.455310,100.455530,100.455750,
     +100.455970,100.456190,100.456410,100.456530,100.456660,100.456790,
     +100.456920,100.457050,100.457180,100.457310,100.457440,100.457570,
     +100.457700,100.457830,100.457960,100.458100,100.458240,100.458316,
     +100.458392,100.458468,100.458544,100.458620,100.458696,100.458772,
     +100.458848,100.458924,100.459000,100.459076,100.459152,100.459228,
     +100.459304,100.459380,100.459456,100.459532,100.459608,100.459684,
     +100.459760,100.459836,100.459912,100.459951,100.460021,100.460057,
     +100.460093,100.460129,100.460165,100.460201,100.460237,100.460273,
     +100.460309,100.460345,100.460381,100.460417,100.460453,100.460489,
     +100.460525,100.460561,100.460597,100.460633,100.460669,100.460705,
     +100.460741,100.460777,100.460813,100.460849,100.460885,100.460921,
     +100.460957,100.460993,100.461029,100.461065,100.461101,100.461137,
     +100.461173,100.461209,100.461228,100.461247,100.461267,100.461287,
     +100.461308,100.461330,100.461352,100.461375,100.461398,100.461421,
     +100.461445,100.461469,100.461493,100.461517,100.461542,100.461567,
     +100.461593,100.461619,100.461634,100.461649,100.461665,100.461682,
     +100.461699,100.461716,100.461733,100.461750,100.461767,100.461784,
     +100.461801,100.461818,100.461835,100.461852,100.461869,100.461886,
     +100.461903,100.461920,100.461937,100.461954,100.461971,100.461988,
     +100.462005,100.462022,100.462039,100.462056,100.462073,100.462090,
     +100.462099,100.462107,100.462116,100.462124,100.462133,100.462142,
     +100.462150,100.462159,100.462167,100.462176,100.462185,100.462193,
     +100.462202,100.462210,100.462219,100.462228,100.462236,100.462245,
     +100.462253,100.462262,100.462271,100.462279,100.462288,100.462296,
     +100.462305,100.462314,100.462322,100.462331,100.462339,100.462348,
     +100.462357,100.462365,100.462374,100.462382,100.462391,100.462400,
     +100.462408,100.462417,100.462425,100.462434,100.462443,100.462451,
     +100.462460,100.462468,100.462477,100.462486,100.462494,100.462503,
     +100.462511,100.462520,100.462529,100.462537,100.462546,100.462554,
     +100.462563,100.462572,100.462580,100.462589,100.462597,100.462606,
     +100.462615,100.462623,100.462640,100.462658,100.462676,100.462695,
     +100.462705,100.462714,100.462724,100.462733,100.462743,100.462748,
     +100.462752,100.462757,100.462762,100.462766,100.462771,100.462776,
     +100.462780,100.462785,100.462789,100.462794,100.462799,100.462803,
     +100.462808,100.462812,100.462817,100.462822,100.462826,100.462829,
     +100.462833,100.462836,100.462838,100.462840,100.462843,100.462845,
     +100.462848,100.462850,100.462852,100.462855,100.462857,100.462860,
     +100.462862,100.462865,100.462868,100.462870,100.462873,100.462876,
     +100.462879,100.462881,100.462884,100.462887,100.462890,100.462893,
     +100.462896,100.462899,100.462902,100.462904,100.462906,100.462908,
     +100.462909,100.462911,100.462913,100.462915,100.462918,100.462920,
     +100.462922,100.462924,100.462926,100.462929,100.462931,100.462933,
     +100.462936,100.462938,100.462941,100.462943,100.462945,100.462948,
     +100.462950,100.462953,100.462955,100.462957,100.462960,100.462962,
     +100.462965,100.462967,100.462969,100.462971,100.462972,100.462974,
     +100.462975,100.462977,100.462978,100.462980,100.462981,100.462983,
     +100.462985,100.462986,100.462988,100.462990,100.462992,100.462993,
     +100.462995,100.462997,100.462999,100.463001,100.463003,100.463005,
     +100.463007,100.463009,100.463011,100.463012,100.463013,100.463014,
     +100.463015,100.463017,100.463018,100.463019,100.463020,100.463021,
     +100.463023,100.463024,100.463026,100.463027,100.463028,100.463030,
     +100.463031,100.463033,100.463035,100.463036,100.463038,100.463040,
     +100.463042,100.463043,100.463045,100.463047,100.463049,100.463051,
     +100.463053,100.463055,100.463057,100.463059,100.463061,100.463063,
     +100.463065,100.463066,100.463067,100.463068,100.463070,100.463071,
     +100.463073,100.463074,100.463076,100.463077,100.463079,100.463081,
     +100.463083,100.463084,100.463086,100.463088,100.463089,100.463091,
     +100.463093,100.463095,100.463097,100.463099,100.463101,100.463103,
     +100.463105,100.463107,100.463110,100.463112,100.463114,100.463116,
     +100.463119,100.463121,100.463124,100.463126,100.463128,100.463131,
     +100.463133,100.463138,100.463143,100.463152,100.463156,100.463161,
     +100.463163,100.463166,100.463168,100.463171,100.463173,100.463175,
     +100.463178,100.463180,100.463183,100.463185,100.463188,100.463190,
     +100.463193,100.463196,100.463197,100.463199,100.463200,100.463202,
     +100.463203,100.463205,100.463207,100.463208,100.463210,100.463212,
     +100.463213,100.463215,100.463217,100.463219,100.463221,100.463223,
     +100.463225,100.463227,100.463230,100.463232,100.463234,100.463235,
     +100.463237,100.463239,100.463241,100.463242,100.463244,100.463245,
     +100.463247,100.463248,100.463250,100.463252,100.463253,100.463255,
     +100.463257,100.463258,100.463260,100.463262,100.463264,100.463266,
     +100.463268,100.463269,100.463271,100.463272,100.463273,100.463275,
     +100.463276,100.463278,100.463279,100.463281,100.463282,100.463284,
     +100.463286,100.463288,100.463289,100.463291,100.463293,100.463294,
     +100.463296,100.463298,100.463300,100.463302,100.463304,100.463306,
     +100.463308,100.463310,100.463312,100.463314,100.463317,100.463319,
     +100.463320,100.463322,100.463323,100.463324,100.463326,100.463328,
     +100.463329,100.463331,100.463333,100.463334,100.463336,100.463338,
     +100.463339,100.463341,100.463343,100.463345,100.463347,100.463349,
     +100.463351,100.463353,100.463355,100.463357,100.463359,100.463362,
     +100.463364,100.463366,100.463369,100.463371,100.463374,100.463376,
     +100.463378,100.463381,100.463383,100.463386,100.463388,100.463390,
     +100.463393,100.463395,100.463398,100.463400,100.463402,100.463405,
     +100.463407,100.463410,100.463412,100.463414,100.463417,100.463419,
     +100.463422,100.463424,100.463426,100.463429,100.463431,100.463434,
     +100.463436,100.463439,100.463441,100.463444,100.463447,100.463449,
     +100.463452,100.463455,100.463458,100.463461,100.463464,100.463467,
     +100.463470,100.463472,100.463476,100.463479,100.463482,100.463485,
     +100.463488,100.463491,100.463494,100.463498,100.463501,100.463504,
     +100.463510,100.463516,100.463522,100.463528,100.463534,100.463540,
     +100.463546,100.463553,100.463559,100.463565,100.463571,100.463583,
     +100.463596,100.463610,100.463624,100.463639,100.463655,100.463671,
     +100.463680,100.463688,100.463697,100.463705,100.463714,100.463723,
     +100.463731,100.463740,100.463748,100.463757,100.463766,100.463774,
     +100.463783,100.463791,100.463800,100.463809,100.463817,100.463826,
     +100.463834,100.463843,100.463852,100.463860,100.463869,100.463877,
     +100.463886,100.463895,100.463903,100.463912,100.463920,100.463929,
     +100.463938,100.463946,100.463955,100.463963,100.463972,100.463981,
     +100.463989,100.463998,100.464006,100.464015,100.464024,100.464032,
     +100.464041,100.464049,100.464058,100.464067,100.464075,100.464084,
     +100.464092,100.464101,100.464110,100.464118,100.464127,100.464135,
     +100.464144,100.464153,100.464161,100.464170,100.464178,100.464187,
     +100.464196,100.464204,100.464221,100.464230,100.464247,100.464265,
     +100.464283,100.464301,100.464319,100.464337,100.464356,100.464375,
     +100.464394,100.464414,100.464434,100.464455,100.464467,100.464479,
     +100.464491,100.464503,100.464515,100.464538,100.464551,100.464565,
     +100.464579,100.464594,100.464609,100.464625,100.464642,100.464659,
     +100.464676,100.464693,100.464710,100.464727,100.464744,100.464761,
     +100.464778,100.464795,100.464812,100.464829,100.464846,100.464863,
     +100.464880,100.464897,100.464914,100.464931,100.464948,100.464981,
     +100.465012,100.465044,100.465075,100.465107,100.465138,100.465170,
     +100.465201,100.465232,100.465264,100.465295,100.465327,100.465358,
     +100.465389,100.465421,100.465452,100.465484,100.465515,100.465547,
     +100.465578,100.465609,100.465641,100.465672,100.465704,100.465735,
     +100.465766,100.465798,100.465829,100.465861,100.465892,100.465924,
     +100.465955,100.466016,100.466077,100.466138,100.466199,100.466260,
     +100.466321,100.466382,100.466443,100.466504,100.466565,100.466626,
     +100.466687,100.466748,100.466809,100.466870,100.466931,100.466992,
     +100.467053,100.467114,100.467175,100.467236,100.467297,100.467358,
     +100.467419,100.467480,100.467541,100.467602,100.467722,100.467787,
     +100.467853,100.467983,100.468120,100.468260,100.468336,100.468486,
     +100.468569,100.468729,100.468900,100.469080,100.469270,100.469371,
     +100.469571,100.469780,100.469990,100.470200,100.470410,100.470630,
     +100.470850,100.471070,100.471290,100.471510,100.471730,100.471950,
     +100.472170,100.472390,100.472610,100.472830,100.473050,100.473280,
     +100.473510,100.473750,100.474000,100.474250,100.474510,100.474770,
     +100.475280,100.475790,100.476300,100.476810,100.477320,100.477830,
     +100.478340,100.478850,100.479360,100.479870,100.480380,100.480890,
     +100.481400,100.482400,100.483410,100.484420,100.485430,100.486440,
     +100.487450,100.488460,100.489470,100.490480,100.491490,100.492500,
     +100.494500,100.496600,100.498700,100.500800,100.502900,100.505100,
     +100.507300,100.509600,100.512000,100.514400,100.519200,100.523800,
     +100.528400,100.533000,100.537600,100.542200,100.551200,100.560300,
     +100.569400,100.578500,100.587600,100.605600,100.625000,100.645000,
     +100.665000,100.705000,100.741000,100.777000,100.847000,100.918000,
     +101.058000,101.210000,101.510000,102.110000,103.310000,104.600000,
     +105.260000,105.920000,106.260000,106.570000,106.740000,106.831000,
     +106.922000,106.968000,107.014000,107.038000,107.063000,107.089000,
     +107.103000,107.118000,107.126100,107.134200,107.142300,107.150400,
     +107.158500,107.162600,107.166700,107.170800,107.174900,107.179000,
     +107.183100,107.185200,107.187300,107.189400,107.191500,107.193600,
     +107.195700,107.197800,107.199900,107.201000,107.202200,107.203400,
     +107.204600,107.205800,107.207100,107.207810,107.208520,107.209230,
     +107.209940,107.210650,107.211360,107.212070,107.212780,107.213490,
     +107.214200,107.214910,107.215270,107.215630,107.215990,107.216350,
     +107.216710,107.217070,107.217430,107.217790,107.218150,107.218510,
     +107.218870,107.219230,107.219590,107.219780,107.219980,107.220180,
     +107.220390,107.220600,107.220810,107.221030,107.221250,107.221470,
     +107.221690,107.221910,107.222130,107.222250,107.222370,107.222500,
     +107.222630,107.222760,107.222890,107.223020,107.223150,107.223280,
     +107.223410,107.223550,107.223690,107.223766,107.223842,107.223918,
     +107.223994,107.224070,107.224146,107.224222,107.224298,107.224374,
     +107.224450,107.224526,107.224602,107.224678,107.224754,107.224830,
     +107.224906,107.224982,107.225058,107.225134,107.225210,107.225249,
     +107.225319,107.225355,107.225391,107.225427,107.225463,107.225499,
     +107.225535,107.225571,107.225607,107.225643,107.225679,107.225715,
     +107.225751,107.225787,107.225823,107.225859,107.225895,107.225931,
     +107.225967,107.226003,107.226039,107.226075,107.226111,107.226147,
     +107.226183,107.226219,107.226255,107.226291,107.226327,107.226363,
     +107.226399,107.226418,107.226437,107.226456,107.226476,107.226496,
     +107.226517,107.226539,107.226561,107.226584,107.226607,107.226631,
     +107.226655,107.226679,107.226703,107.226728,107.226753,107.226779,
     +107.226793,107.226808,107.226823,107.226839,107.226856,107.226873,
     +107.226890,107.226907,107.226924,107.226941,107.226958,107.226975,
     +107.226992,107.227009,107.227026,107.227043,107.227060,107.227077,
     +107.227094,107.227111,107.227128,107.227145,107.227162,107.227171,
     +107.227179,107.227188,107.227196,107.227205,107.227214,107.227222,
     +107.227231,107.227239,107.227248,107.227257,107.227265,107.227274,
     +107.227282,107.227291,107.227300,107.227308,107.227317,107.227325,
     +107.227334,107.227343,107.227351,107.227360,107.227368,107.227377,
     +107.227386,107.227394,107.227403,107.227411,107.227420,107.227429,
     +107.227437,107.227446,107.227454,107.227463,107.227472,107.227480,
     +107.227489,107.227497,107.227506,107.227515,107.227523,107.227532,
     +107.227540,107.227549,107.227558,107.227566,107.227575,107.227583,
     +107.227592,107.227601,107.227609,107.227618,107.227622,107.227630,
     +107.227638,107.227646,107.227654,107.227663,107.227667,107.227671,
     +107.227679,107.227683,107.227687,107.227691,107.227695,107.227699,
     +107.227704,107.227708,107.227712,107.227716,107.227720,107.227724,
     +107.227728,107.227732,107.227736,107.227740,107.227745,107.227749,
     +107.227753,107.227757,107.227761,107.227765,107.227769,107.227773,
     +107.227777,107.227781,107.227785,107.227790,107.227794,107.227798,
     +107.227802,107.227806,107.227810,107.227814,107.227818,107.227822,
     +107.227827,107.227831,107.227835,107.227843,107.227851,107.227859,
     +107.227867,107.227875,107.227883,107.227891,107.227899,107.227908,
     +107.227916,107.227924,107.227928,107.227932,107.227936,107.227940,
     +107.227944,107.227948,107.227952,107.227957,107.227961,107.227963,
     +107.227965,107.227967,107.227969,107.227972,107.227974,107.227976,
     +107.227979,107.227981,107.227984,107.227986,107.227988,107.227991,
     +107.227993,107.227996,107.227998,107.228000,107.228003,107.228005,
     +107.228008,107.228010,107.228013,107.228014,107.228015,107.228017,
     +107.228018,107.228020,107.228021,107.228023,107.228024,107.228026,
     +107.228028,107.228030,107.228031,107.228033,107.228035,107.228036,
     +107.228038,107.228040,107.228041,107.228042,107.228043,107.228044,
     +107.228045,107.228046,107.228047,107.228048,107.228049,107.228050,
     +107.228051,107.228052,107.228053,107.228054,107.228055,107.228056,
     +107.228057,107.228058,107.228059,107.228060,107.228061,107.228062,
     +107.228063,107.228064,107.228065,107.228066,107.228067,107.228068,
     +107.228069,107.228070,107.228071,107.228072,107.228073,107.228074,
     +107.228075,107.228076,107.228077,107.228078,107.228079,107.228081,
     +107.228082,107.228083,107.228084,107.228085,107.228086,107.228087,
     +107.228088,107.228089,107.228090,107.228091,107.228092,107.228093,
     +107.228094,107.228095,107.228096,107.228097,107.228098,107.228099,
     +107.228100,107.228101,107.228102,107.228103,107.228104,107.228105,
     +107.228106,107.228107,107.228108,107.228109,107.228110,107.228111,
     +107.228112,107.228113,107.228114,107.228115,107.228116,107.228117,
     +107.228118,107.228119,107.228120,107.228121,107.228122,107.228123,
     +107.228124,107.228125,107.228126,107.228127,107.228128,107.228129,
     +107.228130,107.228131,107.228132,107.228133,107.228134,107.228135,
     +107.228136,107.228137,107.228138,107.228139,107.228140,107.228141,
     +107.228142,107.228143,107.228144,107.228145,107.228146,107.228147,
     +107.228148,107.228149,107.228150,107.228151,107.228152,107.228153,
     +107.228154,107.228155,107.228156,107.228157,107.228158,107.228159,
     +107.228160,107.228161,107.228162,107.228163,107.228164,107.228165,
     +107.228166,107.228167,107.228168,107.228169,107.228170,107.228171,
     +107.228172,107.228173,107.228174,107.228175,107.228176,107.228177,
     +107.228178,107.228179,107.228180,107.228182,107.228183,107.228184,
     +107.228186,107.228188,107.228190,107.228192,107.228194,107.228196,
     +107.228201,107.228205,107.228207,107.228209,107.228211,107.228214,
     +107.228215,107.228216,107.228217,107.228218,107.228220,107.228221,
     +107.228222,107.228223,107.228224,107.228226,107.228227,107.228229,
     +107.228230,107.228232,107.228233,107.228234,107.228235,107.228236,
     +107.228237,107.228238,107.228239,107.228239,107.228240,107.228241,
     +107.228242,107.228243,107.228243,107.228244,107.228245,107.228246,
     +107.228247,107.228247,107.228248,107.228249,107.228250,107.228251,
     +107.228252,107.228252,107.228253,107.228254,107.228255,107.228256,
     +107.228256,107.228257,107.228258,107.228259,107.228260,107.228260,
     +107.228261,107.228262,107.228263,107.228264,107.228264,107.228265,
     +107.228266,107.228267,107.228268,107.228269,107.228269,107.228270,
     +107.228271,107.228272,107.228273,107.228273,107.228274,107.228275,
     +107.228276,107.228277,107.228277,107.228278,107.228279,107.228280,
     +107.228281,107.228281,107.228282,107.228283,107.228284,107.228285,
     +107.228286,107.228286,107.228287,107.228288,107.228289,107.228290,
     +107.228290,107.228291,107.228292,107.228293,107.228294,107.228294,
     +107.228295,107.228296,107.228297,107.228298,107.228298,107.228299,
     +107.228300,107.228301,107.228302,107.228303,107.228303,107.228304,
     +107.228305,107.228306,107.228307,107.228307,107.228308,107.228309,
     +107.228310,107.228311,107.228311,107.228312,107.228313,107.228314,
     +107.228315,107.228315,107.228316,107.228317,107.228318,107.228319,
     +107.228320,107.228320,107.228321,107.228322,107.228323,107.228324,
     +107.228324,107.228325,107.228326,107.228327,107.228328,107.228328,
     +107.228329,107.228330,107.228331,107.228332,107.228333,107.228333,
     +107.228334,107.228335,107.228336,107.228337,107.228338,107.228339,
     +107.228340,107.228341,107.228342,107.228342,107.228343,107.228344,
     +107.228345,107.228346,107.228347,107.228348,107.228349,107.228350,
     +107.228351,107.228352,107.228353,107.228354,107.228356,107.228357,
     +107.228358,107.228359,107.228360,107.228361,107.228362,107.228363,
     +107.228364,107.228366,107.228368,107.228370,107.228372,107.228374,
     +107.228376,107.228378,107.228379,107.228380,107.228381,107.228383,
     +107.228384,107.228386,107.228387,107.228389,107.228391,107.228392,
     +107.228394,107.228396,107.228397,107.228399,107.228401,107.228403,
     +107.228404,107.228406,107.228408,107.228410,107.228413,107.228415,
     +107.228417,107.228419,107.228421,107.228424,107.228426,107.228428,
     +107.228431,107.228433,107.228436,107.228439,107.228441,107.228444,
     +107.228447,107.228450,107.228452,107.228455,107.228458,107.228461,
     +107.228467,107.228472,107.228478,107.228484,107.228489,107.228500,
     +107.228512,107.228524,107.228530,107.228536,107.228542,107.228548,
     +107.228555,107.228561,107.228567,107.228573,107.228579,107.228585,
     +107.228591,107.228597,107.228603,107.228609,107.228616,107.228622,
     +107.228628,107.228634,107.228640,107.228646,107.228652,107.228658,
     +107.228664,107.228670,107.228677,107.228683,107.228689,107.228695,
     +107.228701,107.228707,107.228713,107.228719,107.228725,107.228731,
     +107.228737,107.228744,107.228750,107.228756,107.228762,107.228768,
     +107.228774,107.228780,107.228786,107.228792,107.228798,107.228805,
     +107.228811,107.228817,107.228823,107.228829,107.228835,107.228841,
     +107.228847,107.228853,107.228859,107.228866,107.228872,107.228878,
     +107.228884,107.228890,107.228896,107.228902,107.228908,107.228914,
     +107.228921,107.228927,107.228933,107.228939,107.228945,107.228951,
     +107.228957,107.228963,107.228969,107.228975,107.228982,107.228988,
     +107.228994,107.229006,107.229012,107.229019,107.229026,107.229032,
     +107.229039,107.229045,107.229058,107.229065,107.229078,107.229085,
     +107.229098,107.229112,107.229126,107.229140,107.229148,107.229163,
     +107.229171,107.229179,107.229187,107.229195,107.229203,107.229219,
     +107.229228,107.229244,107.229252,107.229269,107.229278,107.229295,
     +107.229313,107.229331,107.229341,107.229360,107.229371,107.229383,
     +107.229395,107.229407,107.229419,107.229431,107.229443,107.229455,
     +107.229468,107.229481,107.229494,107.229507,107.229521,107.229535,
     +107.229550,107.229565,107.229581,107.229598,107.229615,107.229632,
     +107.229649,107.229666,107.229683,107.229700,107.229717,107.229734,
     +107.229751,107.229768,107.229785,107.229802,107.229819,107.229836,
     +107.229853,107.229870,107.229903,107.229934,107.229966,107.229997,
     +107.230029,107.230060,107.230091,107.230123,107.230154,107.230186,
     +107.230217,107.230249,107.230280,107.230311,107.230343,107.230374,
     +107.230406,107.230437,107.230468,107.230500,107.230531,107.230563,
     +107.230594,107.230626,107.230657,107.230688,107.230720,107.230780,
     +107.230841,107.230902,107.230963,107.231024,107.231085,107.231146,
     +107.231207,107.231268,107.231329,107.231390,107.231451,107.231512,
     +107.231573,107.231634,107.231695,107.231756,107.231817,107.231878,
     +107.231939,107.232000,107.232061,107.232122,107.232183,107.232244,
     +107.232305,107.232425,107.232550,107.232680,107.232810,107.232950,
     +107.233090,107.233240,107.233400,107.233560,107.233730,107.233900,
     +107.234070,107.234240,107.234420,107.234610,107.234800,107.235000,
     +107.235210,107.235420,107.235630,107.235850,107.236070,107.236290,
     +107.236510,107.236730,107.236950,107.237170,107.237390,107.237610,
     +107.238040,107.238450,107.238860,107.239270,107.239680,107.240090,
     +107.240500,107.240910,107.241320,107.241730,107.242140,107.242550,
     +107.243350,107.244160,107.244970,107.245780,107.246590,107.247400,
     +107.248210,107.249020,107.249830,107.250640,107.252240,107.253900,
     +107.255600,107.257300,107.259000,107.260700,107.262400,107.264100,
     +107.267400,107.270500,107.273700,107.276800,107.280000,107.283100,
     +107.289300,107.295400,107.301500,107.307600,107.313700,107.325700,
     +107.339000,107.353000,107.368000,107.384000,107.415000,107.447000,
     +107.478000,107.540000,107.601000,107.721000,107.850000,108.100000,
     +108.600000,109.600000,110.110000,110.620000,110.880000,111.020000,
     +111.170000,111.251000,111.332000,111.413000,111.494000,111.535000,
     +111.576000,111.617000,111.658000,111.699000,111.740000,111.781000,
     +111.822000,111.863000,111.884000,111.906000,111.929000,111.952000,
     +111.975000,111.999000,112.047000,112.093000,112.139000,112.185000,
     +112.231000,112.277000,112.323000,112.369000,112.459000,112.550000,
     +112.641000,112.821000,113.010000,113.380000,114.080000,114.790000,
     +115.500000,116.210000,116.580000,116.940000,117.640000,117.830000,
     +118.020000,118.210000,118.590000,119.290000,119.650000,120.010000,
     +120.370000,120.730000,121.090000,121.280000,121.470000,121.840000,
     +122.200000,122.560000,123.260000,124.660000,127.460000,133.060000,
     +144.060000,166.060000,210.060000,290.060000,371.000000,531.000000,
     +6.9200E+02,1.0120E+03,1.3130E+03,1.9130E+03,2.5140E+03,3.1150E+03,
     +4.3150E+03,5.5200E+03,7.9200E+03,1.0330E+04,1.5130E+04,1.9640E+04,
     +2.8640E+04,3.7650E+04,4.6660E+04,6.4660E+04,8.2800E+04,1.0090E+05,
     +1.0996E+05,1.1447E+05,1.1898E+05,1.2012E+05,1.2068E+05,1.2123E+05,
     +1.2130E+05,1.2133E+05,1.2137E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,1.2138E+05,
     +1.2138E+05,1.2139E+05,1.2139E+05,1.2140E+05,1.2142E+05,1.2145E+05,
     +1.2151E+05,1.2163E+05,1.2187E+05,1.2235E+05,1.2325E+05,1.2505E+05,
     +1.2865E+05,1.3216E+05,1.3916E+05,1.4617E+05,1.6017E+05,1.7430E+05,
     +2.0230E+05,2.5830E+05,3.1340E+05,4.2340E+05,5.3400E+05,6.4500E+05,
     +8.6500E+05,9.7600E+05,9.9000E+05,1.0000E+06/
c
      Data VP2/   ! vac. pol. with rel. error < 1.E-4
c
     +0.0000E+00,2.3353E-04,3.3121E-04,4.2093E-04,4.4457E-04,4.5077E-04,
     +4.5388E-04,4.5698E-04,4.6007E-04,4.6315E-04,4.6621E-04,4.6926E-04,
     +4.7230E-04,4.7532E-04,4.7834E-04,4.8134E-04,4.8433E-04,4.8731E-04,
     +4.9316E-04,4.9922E-04,5.0529E-04,5.1161E-04,5.1788E-04,5.2439E-04,
     +5.3084E-04,5.3724E-04,5.4960E-04,5.6119E-04,5.7261E-04,5.8386E-04,
     +5.9494E-04,6.1611E-04,6.3695E-04,6.5724E-04,6.7700E-04,6.9625E-04,
     +7.3291E-04,7.6937E-04,8.0477E-04,8.4054E-04,9.0741E-04,9.6888E-04,
     +1.0258E-03,1.1256E-03,1.2151E-03,1.3659E-03,1.6003E-03,1.9254E-03,
     +2.3241E-03,2.7818E-03,3.2766E-03,3.7581E-03,4.2687E-03,4.7977E-03,
     +5.3166E-03,5.8646E-03,6.4470E-03,7.0826E-03,7.7719E-03,8.2481E-03,
     +8.6216E-03,8.7867E-03,8.8679E-03,8.8897E-03,8.8927E-03,8.8928E-03,
     +8.8929E-03,8.8929E-03,8.8929E-03,8.8929E-03,8.8929E-03,8.8929E-03,
     +8.8929E-03,8.8929E-03,8.8929E-03,8.8929E-03,8.8929E-03,8.8930E-03,
     +8.8931E-03,8.8933E-03,8.8938E-03,8.8947E-03,8.8965E-03,8.8984E-03,
     +8.9020E-03,8.9058E-03,8.9133E-03,8.9211E-03,8.9289E-03,8.9440E-03,
     +8.9587E-03,8.9733E-03,9.0017E-03,9.0300E-03,9.0579E-03,9.0855E-03,
     +9.1392E-03,9.1951E-03,9.2519E-03,9.3102E-03,9.3699E-03,9.4824E-03,
     +9.5852E-03,9.6842E-03,9.8672E-03,1.0041E-02,1.0355E-02,1.0650E-02,
     +1.0724E-02,1.0758E-02,1.0767E-02,1.0772E-02,1.0775E-02,1.0776E-02,
     +1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,
     +1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,
     +1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,1.0776E-02,
     +1.0777E-02,1.0778E-02,1.0780E-02,1.0783E-02,1.0790E-02,1.0803E-02,
     +1.0829E-02,1.0880E-02,1.0972E-02,1.1151E-02,1.1244E-02,1.1421E-02,
     +1.1608E-02,1.1792E-02,1.1978E-02,1.2312E-02,1.2399E-02,1.2443E-02,
     +1.2522E-02,1.2673E-02,1.2828E-02,1.2867E-02,1.2903E-02,1.2972E-02,
     +1.3107E-02,1.3174E-02,1.3239E-02,1.3272E-02,1.3334E-02,1.3397E-02,
     +1.3517E-02,1.3549E-02,1.3607E-02,1.3720E-02,1.3752E-02,1.3813E-02,
     +1.3845E-02,1.3849E-02,1.3858E-02,1.3875E-02,1.3910E-02,1.3976E-02,
     +1.4041E-02,1.4105E-02,1.4110E-02,1.4112E-02,1.4116E-02,1.4125E-02,
     +1.4143E-02,1.4177E-02,1.4245E-02,1.4316E-02,1.4386E-02,1.4462E-02,
     +1.4483E-02,1.4493E-02,1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,
     +1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,
     +1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,
     +1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,1.4494E-02,1.4495E-02,
     +1.4496E-02,1.4499E-02,1.4503E-02,1.4512E-02,1.4530E-02,1.4548E-02,
     +1.4581E-02,1.4599E-02,1.4616E-02,1.4618E-02,1.4622E-02,1.4631E-02,
     +1.4649E-02,1.4681E-02,1.4690E-02,1.4708E-02,1.4740E-02,1.4756E-02,
     +1.4765E-02,1.4774E-02,1.4778E-02,1.4783E-02,1.4792E-02,1.4801E-02,
     +1.4806E-02,1.4816E-02,1.4822E-02,1.4825E-02,1.4828E-02,1.4831E-02,
     +1.4834E-02,1.4838E-02,1.4841E-02,1.4844E-02,1.4850E-02,1.4854E-02,
     +1.4857E-02,1.4858E-02,1.4858E-02,1.4859E-02,1.4859E-02,1.4860E-02,
     +1.4862E-02,1.4863E-02,1.4864E-02,1.4866E-02,1.4867E-02,1.4869E-02,
     +1.4870E-02,1.4871E-02,1.4872E-02,1.4874E-02,1.4875E-02,1.4876E-02,
     +1.4876E-02,1.4877E-02,1.4878E-02,1.4878E-02,1.4879E-02,1.4880E-02,
     +1.4881E-02,1.4882E-02,1.4882E-02,1.4882E-02,1.4883E-02,1.4884E-02,
     +1.4886E-02,1.4887E-02,1.4888E-02,1.4889E-02,1.4892E-02,1.4893E-02,
     +1.4895E-02,1.4898E-02,1.4901E-02,1.4902E-02,1.4905E-02,1.4906E-02,
     +1.4908E-02,1.4908E-02,1.4908E-02,1.4909E-02,1.4911E-02,1.4914E-02,
     +1.4917E-02,1.4920E-02,1.4923E-02,1.4926E-02,1.4929E-02,1.4932E-02,
     +1.4935E-02,1.4937E-02,1.4938E-02,1.4939E-02,1.4942E-02,1.4948E-02,
     +1.4955E-02,1.4968E-02,1.4982E-02,1.4989E-02,1.4996E-02,1.5011E-02,
     +1.5015E-02,1.5017E-02,1.5021E-02,1.5029E-02,1.5045E-02,1.5074E-02,
     +1.5090E-02,1.5118E-02,1.5148E-02,1.5177E-02,1.5233E-02,1.5294E-02,
     +1.5311E-02,1.5320E-02,1.5325E-02,1.5329E-02,1.5338E-02,1.5356E-02,
     +1.5392E-02,1.5428E-02,1.5464E-02,1.5533E-02,1.5607E-02,1.5626E-02,
     +1.5645E-02,1.5664E-02,1.5683E-02,1.5720E-02,1.5793E-02,1.5813E-02,
     +1.5848E-02,1.5884E-02,1.5902E-02,1.5912E-02,1.5917E-02,1.5919E-02,
     +1.5924E-02,1.5934E-02,1.5954E-02,1.5993E-02,1.6031E-02,1.6069E-02,
     +1.6088E-02,1.6107E-02,1.6126E-02,1.6135E-02,1.6145E-02,1.6165E-02,
     +1.6183E-02,1.6219E-02,1.6255E-02,1.6291E-02,1.6309E-02,1.6327E-02,
     +1.6336E-02,1.6354E-02,1.6388E-02,1.6423E-02,1.6440E-02,1.6457E-02,
     +1.6475E-02,1.6492E-02,1.6496E-02,1.6499E-02,1.6499E-02,1.6499E-02,
     +1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,
     +1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,
     +1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,1.6499E-02,
     +1.6499E-02,1.6499E-02,1.6500E-02,1.6501E-02,1.6502E-02,1.6505E-02,
     +1.6510E-02,1.6516E-02,1.6521E-02,1.6527E-02,1.6530E-02,1.6531E-02,
     +1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,
     +1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,
     +1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,
     +1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,1.6532E-02,
     +1.6533E-02,1.6533E-02,1.6534E-02,1.6537E-02,1.6539E-02,1.6541E-02,
     +1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,
     +1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,
     +1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,1.6542E-02,
     +1.6542E-02,1.6542E-02,1.6542E-02,1.6543E-02,1.6543E-02,1.6543E-02,
     +1.6544E-02,1.6544E-02,1.6545E-02,1.6547E-02,1.6548E-02,1.6549E-02,
     +1.6551E-02,1.6552E-02,1.6554E-02,1.6556E-02,1.6557E-02,1.6559E-02,
     +1.6561E-02,1.6563E-02,1.6564E-02,1.6566E-02,1.6568E-02,1.6569E-02,
     +1.6570E-02,1.6571E-02,1.6572E-02,1.6573E-02,1.6574E-02,1.6575E-02,
     +1.6575E-02,1.6576E-02,1.6577E-02,1.6577E-02,1.6578E-02,1.6578E-02,
     +1.6579E-02,1.6579E-02,1.6580E-02,1.6582E-02,1.6583E-02,1.6584E-02,
     +1.6585E-02,1.6585E-02,1.6586E-02,1.6586E-02,1.6586E-02,1.6586E-02,
     +1.6586E-02,1.6587E-02,1.6587E-02,1.6587E-02,1.6587E-02,1.6587E-02,
     +1.6587E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,
     +1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,
     +1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,
     +1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,1.6588E-02,
     +1.6589E-02,1.6589E-02,1.6589E-02,1.6590E-02,1.6591E-02,1.6591E-02,
     +1.6592E-02,1.6592E-02,1.6592E-02,1.6593E-02,1.6593E-02,1.6594E-02,
     +1.6594E-02,1.6594E-02,1.6594E-02,1.6594E-02,1.6594E-02,1.6594E-02,
     +1.6595E-02,1.6595E-02,1.6595E-02,1.6595E-02,1.6596E-02,1.6596E-02,
     +1.6597E-02,1.6597E-02,1.6598E-02,1.6598E-02,1.6599E-02,1.6599E-02,
     +1.6600E-02,1.6600E-02,1.6600E-02,1.6600E-02,1.6601E-02,1.6601E-02,
     +1.6601E-02,1.6601E-02,1.6601E-02,1.6602E-02,1.6602E-02,1.6603E-02,
     +1.6603E-02,1.6604E-02,1.6604E-02,1.6604E-02,1.6605E-02,1.6605E-02,
     +1.6605E-02,1.6605E-02,1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,
     +1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,
     +1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,
     +1.6606E-02,1.6606E-02,1.6606E-02,1.6606E-02,1.6607E-02,1.6607E-02,
     +1.6607E-02,1.6607E-02,1.6607E-02,1.6608E-02,1.6608E-02,1.6608E-02,
     +1.6609E-02,1.6609E-02,1.6610E-02,1.6610E-02,1.6610E-02,1.6610E-02,
     +1.6610E-02,1.6610E-02,1.6610E-02,1.6610E-02,1.6610E-02,1.6610E-02,
     +1.6611E-02,1.6611E-02,1.6611E-02,1.6612E-02,1.6612E-02,1.6612E-02,
     +1.6612E-02,1.6613E-02,1.6613E-02,1.6613E-02,1.6613E-02,1.6614E-02,
     +1.6615E-02,1.6616E-02,1.6617E-02,1.6617E-02,1.6617E-02,1.6617E-02,
     +1.6618E-02,1.6618E-02,1.6618E-02,1.6619E-02,1.6619E-02,1.6619E-02,
     +1.6619E-02,1.6619E-02,1.6620E-02,1.6620E-02,1.6620E-02,1.6620E-02,
     +1.6620E-02,1.6621E-02,1.6621E-02,1.6622E-02,1.6622E-02,1.6623E-02,
     +1.6623E-02,1.6624E-02,1.6625E-02,1.6625E-02,1.6625E-02,1.6626E-02,
     +1.6627E-02,1.6628E-02,1.6629E-02,1.6629E-02,1.6630E-02,1.6631E-02,
     +1.6632E-02,1.6633E-02,1.6634E-02,1.6635E-02,1.6636E-02,1.6637E-02,
     +1.6639E-02,1.6641E-02,1.6643E-02,1.6645E-02,1.6647E-02,1.6649E-02,
     +1.6651E-02,1.6653E-02,1.6655E-02,1.6659E-02,1.6660E-02,1.6662E-02,
     +1.6663E-02,1.6663E-02,1.6664E-02,1.6665E-02,1.6667E-02,1.6671E-02,
     +1.6675E-02,1.6679E-02,1.6684E-02,1.6688E-02,1.6694E-02,1.6696E-02,
     +1.6697E-02,1.6698E-02,1.6699E-02,1.6700E-02,1.6701E-02,1.6704E-02,
     +1.6711E-02,1.6717E-02,1.6724E-02,1.6737E-02,1.6739E-02,1.6740E-02,
     +1.6744E-02,1.6747E-02,1.6755E-02,1.6769E-02,1.6783E-02,1.6797E-02,
     +1.6799E-02,1.6802E-02,1.6804E-02,1.6808E-02,1.6816E-02,1.6832E-02,
     +1.6847E-02,1.6877E-02,1.6908E-02,1.6967E-02,1.6984E-02,1.7001E-02,
     +1.7033E-02,1.7065E-02,1.7096E-02,1.7105E-02,1.7122E-02,1.7140E-02,
     +1.7157E-02,1.7174E-02,1.7207E-02,1.7226E-02,1.7245E-02,1.7263E-02,
     +1.7298E-02,1.7337E-02,1.7377E-02,1.7417E-02,1.7495E-02,1.7574E-02,
     +1.7594E-02,1.7605E-02,1.7625E-02,1.7664E-02,1.7706E-02,1.7726E-02,
     +1.7747E-02,1.7758E-02,1.7777E-02,1.7787E-02,1.7806E-02,1.7844E-02,
     +1.7864E-02,1.7884E-02,1.7924E-02,1.8002E-02,1.8020E-02,1.8038E-02,
     +1.8056E-02,1.8065E-02,1.8083E-02,1.8101E-02,1.8119E-02,1.8154E-02,
     +1.8173E-02,1.8183E-02,1.8200E-02,1.8217E-02,1.8235E-02,1.8269E-02,
     +1.8287E-02,1.8305E-02,1.8323E-02,1.8358E-02,1.8428E-02,1.8444E-02,
     +1.8453E-02,1.8469E-02,1.8485E-02,1.8501E-02,1.8509E-02,1.8525E-02,
     +1.8533E-02,1.8549E-02,1.8581E-02,1.8613E-02,1.8629E-02,1.8662E-02,
     +1.8727E-02,1.8742E-02,1.8750E-02,1.8765E-02,1.8767E-02,1.8768E-02,
     +1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,
     +1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,
     +1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,
     +1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,1.8769E-02,
     +1.8769E-02,1.8770E-02,1.8770E-02,1.8772E-02,1.8774E-02,1.8779E-02,
     +1.8790E-02,1.8800E-02,1.8803E-02,1.8804E-02,1.8805E-02,1.8805E-02,
     +1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,
     +1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,
     +1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,
     +1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8805E-02,1.8806E-02,
     +1.8806E-02,1.8808E-02,1.8810E-02,1.8816E-02,1.8826E-02,1.8846E-02,
     +1.8884E-02,1.8924E-02,1.9002E-02,1.9039E-02,1.9110E-02,1.9129E-02,
     +1.9134E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,
     +1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,
     +1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,
     +1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9137E-02,1.9138E-02,
     +1.9138E-02,1.9139E-02,1.9141E-02,1.9145E-02,1.9152E-02,1.9166E-02,
     +1.9179E-02,1.9206E-02,1.9235E-02,1.9250E-02,1.9258E-02,1.9262E-02,
     +1.9269E-02,1.9284E-02,1.9299E-02,1.9328E-02,1.9359E-02,1.9420E-02,
     +1.9477E-02,1.9506E-02,1.9565E-02,1.9580E-02,1.9609E-02,1.9639E-02,
     +1.9656E-02,1.9689E-02,1.9721E-02,1.9755E-02,1.9790E-02,1.9859E-02,
     +1.9985E-02,2.0003E-02,2.0021E-02,2.0026E-02,2.0034E-02,2.0050E-02,
     +2.0068E-02,2.0077E-02,2.0080E-02,2.0085E-02,2.0094E-02,2.0113E-02,
     +2.0134E-02,2.0139E-02,2.0150E-02,2.0160E-02,2.0182E-02,2.0204E-02,
     +2.0226E-02,2.0269E-02,2.0346E-02,2.0356E-02,2.0361E-02,2.0371E-02,
     +2.0391E-02,2.0431E-02,2.0469E-02,2.0489E-02,2.0510E-02,2.0520E-02,
     +2.0541E-02,2.0547E-02,2.0558E-02,2.0579E-02,2.0590E-02,2.0601E-02,
     +2.0623E-02,2.0665E-02,2.0747E-02,2.0769E-02,2.0780E-02,2.0803E-02,
     +2.0849E-02,2.0927E-02,2.0938E-02,2.0959E-02,2.1000E-02,2.1003E-02,
     +2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,
     +2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,
     +2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,
     +2.1004E-02,2.1004E-02,2.1004E-02,2.1004E-02,2.1005E-02,2.1005E-02,
     +2.1005E-02,2.1006E-02,2.1008E-02,2.1011E-02,2.1018E-02,2.1031E-02,
     +2.1044E-02,2.1071E-02,2.1124E-02,2.1139E-02,2.1168E-02,2.1184E-02,
     +2.1193E-02,2.1209E-02,2.1242E-02,2.1274E-02,2.1290E-02,2.1292E-02,
     +2.1294E-02,2.1296E-02,2.1301E-02,2.1311E-02,2.1313E-02,2.1314E-02,
     +2.1315E-02,2.1318E-02,2.1324E-02,2.1330E-02,2.1334E-02,2.1340E-02,
     +2.1346E-02,2.1352E-02,2.1364E-02,2.1388E-02,2.1412E-02,2.1460E-02,
     +2.1484E-02,2.1487E-02,2.1489E-02,2.1489E-02,2.1489E-02,2.1490E-02,
     +2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,
     +2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,
     +2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,
     +2.1490E-02,2.1490E-02,2.1490E-02,2.1490E-02,2.1491E-02,2.1492E-02,
     +2.1495E-02,2.1501E-02,2.1511E-02,2.1531E-02,2.1572E-02,2.1647E-02,
     +2.1794E-02,2.1950E-02,2.1990E-02,2.2067E-02,2.2144E-02,2.2292E-02,
     +2.2574E-02,2.2593E-02,2.2598E-02,2.2600E-02,2.2601E-02,2.2601E-02,
     +2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,
     +2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,
     +2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,
     +2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,2.2601E-02,
     +2.2601E-02,2.2602E-02,2.2603E-02,2.2605E-02,2.2609E-02,2.2618E-02,
     +2.2633E-02,2.2665E-02,2.2724E-02,2.2840E-02,2.2961E-02,2.3192E-02,
     +2.3393E-02,2.3592E-02,2.3776E-02,2.3869E-02,2.3918E-02,2.4013E-02,
     +2.4114E-02,2.4166E-02,2.4217E-02,2.4317E-02,2.4369E-02,2.4395E-02,
     +2.4408E-02,2.4415E-02,2.4417E-02,2.4418E-02,2.4418E-02,2.4418E-02,
     +2.4418E-02,2.4418E-02,2.4418E-02,2.4418E-02,2.4418E-02,2.4418E-02,
     +2.4418E-02,2.4418E-02,2.4418E-02,2.4418E-02,2.4418E-02,2.4418E-02,
     +2.4419E-02,2.4419E-02,2.4419E-02,2.4419E-02,2.4419E-02,2.4420E-02,
     +2.4421E-02,2.4424E-02,2.4430E-02,2.4440E-02,2.4462E-02,2.4502E-02,
     +2.4581E-02,2.4662E-02,2.4703E-02,2.4744E-02,2.4785E-02,2.4825E-02,
     +2.4846E-02,2.4865E-02,2.4884E-02,2.4902E-02,2.4913E-02,2.4923E-02,
     +2.4933E-02,2.4944E-02,2.4955E-02,2.4960E-02,2.4966E-02,2.4972E-02,
     +2.4978E-02,2.4984E-02,2.4987E-02,2.4990E-02,2.4993E-02,2.4996E-02,
     +2.4999E-02,2.5002E-02,2.5005E-02,2.5008E-02,2.5009E-02,2.5011E-02,
     +2.5012E-02,2.5013E-02,2.5015E-02,2.5016E-02,2.5018E-02,2.5019E-02,
     +2.5020E-02,2.5022E-02,2.5023E-02,2.5025E-02,2.5025E-02,2.5026E-02,
     +2.5027E-02,2.5028E-02,2.5028E-02,2.5029E-02,2.5030E-02,2.5031E-02,
     +2.5031E-02,2.5032E-02,2.5032E-02,2.5033E-02,2.5033E-02,2.5033E-02,
     +2.5034E-02,2.5034E-02,2.5035E-02,2.5035E-02,2.5035E-02,2.5036E-02,
     +2.5036E-02,2.5037E-02,2.5037E-02,2.5037E-02,2.5038E-02,2.5038E-02,
     +2.5038E-02,2.5038E-02,2.5039E-02,2.5039E-02,2.5039E-02,2.5039E-02,
     +2.5039E-02,2.5040E-02,2.5040E-02,2.5040E-02,2.5040E-02,2.5041E-02,
     +2.5041E-02,2.5041E-02,2.5041E-02,2.5041E-02,2.5042E-02,2.5042E-02,
     +2.5042E-02,2.5042E-02,2.5042E-02,2.5042E-02,2.5042E-02,2.5042E-02,
     +2.5043E-02,2.5043E-02,2.5043E-02,2.5043E-02,2.5043E-02,2.5043E-02,
     +2.5043E-02,2.5043E-02,2.5044E-02,2.5044E-02,2.5044E-02,2.5044E-02,
     +2.5044E-02,2.5044E-02,2.5044E-02,2.5044E-02,2.5044E-02,2.5044E-02,
     +2.5044E-02,2.5044E-02,2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,
     +2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,
     +2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,
     +2.5045E-02,2.5045E-02,2.5045E-02,2.5045E-02,2.5046E-02,2.5046E-02,
     +2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,
     +2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,
     +2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,
     +2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,
     +2.5046E-02,2.5046E-02,2.5046E-02,2.5046E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,2.5047E-02,
     +2.5047E-02,2.5047E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,
     +2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5048E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,2.5049E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,
     +2.5050E-02,2.5050E-02,2.5050E-02,2.5050E-02,2.5051E-02,2.5051E-02,
     +2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,
     +2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,
     +2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,
     +2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,
     +2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,2.5051E-02,
     +2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,
     +2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,
     +2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,2.5052E-02,
     +2.5053E-02,2.5053E-02,2.5053E-02,2.5053E-02,2.5053E-02,2.5053E-02,
     +2.5053E-02,2.5053E-02,2.5053E-02,2.5053E-02,2.5053E-02,2.5053E-02,
     +2.5053E-02,2.5053E-02,2.5053E-02,2.5054E-02,2.5054E-02,2.5054E-02,
     +2.5054E-02,2.5054E-02,2.5054E-02,2.5054E-02,2.5054E-02,2.5054E-02,
     +2.5054E-02,2.5054E-02,2.5055E-02,2.5055E-02,2.5055E-02,2.5055E-02,
     +2.5055E-02,2.5055E-02,2.5055E-02,2.5055E-02,2.5055E-02,2.5055E-02,
     +2.5055E-02,2.5056E-02,2.5056E-02,2.5056E-02,2.5056E-02,2.5057E-02,
     +2.5057E-02,2.5057E-02,2.5057E-02,2.5057E-02,2.5058E-02,2.5058E-02,
     +2.5058E-02,2.5058E-02,2.5058E-02,2.5059E-02,2.5059E-02,2.5059E-02,
     +2.5059E-02,2.5060E-02,2.5060E-02,2.5060E-02,2.5061E-02,2.5061E-02,
     +2.5062E-02,2.5062E-02,2.5062E-02,2.5063E-02,2.5063E-02,2.5064E-02,
     +2.5064E-02,2.5064E-02,2.5065E-02,2.5065E-02,2.5066E-02,2.5067E-02,
     +2.5068E-02,2.5069E-02,2.5070E-02,2.5071E-02,2.5072E-02,2.5073E-02,
     +2.5074E-02,2.5075E-02,2.5076E-02,2.5077E-02,2.5078E-02,2.5079E-02,
     +2.5081E-02,2.5083E-02,2.5085E-02,2.5087E-02,2.5089E-02,2.5091E-02,
     +2.5093E-02,2.5095E-02,2.5097E-02,2.5101E-02,2.5105E-02,2.5109E-02,
     +2.5113E-02,2.5117E-02,2.5121E-02,2.5125E-02,2.5133E-02,2.5141E-02,
     +2.5150E-02,2.5159E-02,2.5167E-02,2.5177E-02,2.5194E-02,2.5212E-02,
     +2.5230E-02,2.5247E-02,2.5281E-02,2.5316E-02,2.5350E-02,2.5416E-02,
     +2.5485E-02,2.5554E-02,2.5685E-02,2.5804E-02,2.5868E-02,2.5991E-02,
     +2.6103E-02,2.6217E-02,2.6231E-02,2.6238E-02,2.6252E-02,2.6267E-02,
     +2.6294E-02,2.6349E-02,2.6357E-02,2.6358E-02,2.6358E-02,2.6358E-02,
     +2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,
     +2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,
     +2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,
     +2.6358E-02,2.6358E-02,2.6358E-02,2.6358E-02,2.6359E-02,2.6359E-02,
     +2.6360E-02,2.6363E-02,2.6368E-02,2.6377E-02,2.6396E-02,2.6415E-02,
     +2.6434E-02,2.6452E-02,2.6471E-02,2.6481E-02,2.6490E-02,2.6500E-02,
     +2.6505E-02,2.6510E-02,2.6515E-02,2.6520E-02,2.6523E-02,2.6526E-02,
     +2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,
     +2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,
     +2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,
     +2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,
     +2.6528E-02,2.6528E-02,2.6528E-02,2.6528E-02,2.6529E-02,2.6529E-02,
     +2.6530E-02,2.6532E-02,2.6534E-02,2.6536E-02,2.6538E-02,2.6539E-02,
     +2.6539E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,
     +2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,
     +2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,
     +2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,
     +2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,2.6540E-02,
     +2.6541E-02,2.6542E-02,2.6543E-02,2.6544E-02,2.6546E-02,2.6547E-02,
     +2.6548E-02,2.6549E-02,2.6550E-02,2.6550E-02,2.6551E-02,2.6552E-02,
     +2.6552E-02,2.6553E-02,2.6554E-02,2.6554E-02,2.6555E-02,2.6555E-02,
     +2.6556E-02,2.6556E-02,2.6557E-02,2.6557E-02,2.6557E-02,2.6557E-02,
     +2.6558E-02,2.6558E-02,2.6558E-02,2.6558E-02,2.6559E-02,2.6559E-02,
     +2.6559E-02,2.6559E-02,2.6560E-02,2.6560E-02,2.6560E-02,2.6560E-02,
     +2.6560E-02,2.6560E-02,2.6561E-02,2.6561E-02,2.6561E-02,2.6561E-02,
     +2.6561E-02,2.6561E-02,2.6561E-02,2.6561E-02,2.6562E-02,2.6562E-02,
     +2.6562E-02,2.6562E-02,2.6562E-02,2.6562E-02,2.6562E-02,2.6562E-02,
     +2.6562E-02,2.6562E-02,2.6562E-02,2.6563E-02,2.6563E-02,2.6563E-02,
     +2.6563E-02,2.6563E-02,2.6563E-02,2.6563E-02,2.6563E-02,2.6563E-02,
     +2.6563E-02,2.6563E-02,2.6563E-02,2.6563E-02,2.6563E-02,2.6563E-02,
     +2.6563E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,
     +2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,
     +2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,
     +2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,
     +2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,2.6564E-02,
     +2.6564E-02,2.6564E-02,2.6564E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,2.6565E-02,
     +2.6565E-02,2.6565E-02,2.6565E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,2.6566E-02,
     +2.6566E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,
     +2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,
     +2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,
     +2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,
     +2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,
     +2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,2.6567E-02,
     +2.6567E-02,2.6567E-02,2.6567E-02,2.6568E-02,2.6568E-02,2.6568E-02,
     +2.6568E-02,2.6568E-02,2.6568E-02,2.6568E-02,2.6568E-02,2.6568E-02,
     +2.6568E-02,2.6568E-02,2.6568E-02,2.6568E-02,2.6568E-02,2.6568E-02,
     +2.6568E-02,2.6569E-02,2.6569E-02,2.6569E-02,2.6569E-02,2.6569E-02,
     +2.6569E-02,2.6569E-02,2.6569E-02,2.6569E-02,2.6569E-02,2.6569E-02,
     +2.6569E-02,2.6570E-02,2.6570E-02,2.6570E-02,2.6570E-02,2.6570E-02,
     +2.6570E-02,2.6570E-02,2.6570E-02,2.6570E-02,2.6571E-02,2.6571E-02,
     +2.6571E-02,2.6571E-02,2.6571E-02,2.6571E-02,2.6572E-02,2.6572E-02,
     +2.6572E-02,2.6572E-02,2.6572E-02,2.6573E-02,2.6573E-02,2.6573E-02,
     +2.6573E-02,2.6574E-02,2.6574E-02,2.6575E-02,2.6575E-02,2.6576E-02,
     +2.6576E-02,2.6577E-02,2.6577E-02,2.6578E-02,2.6578E-02,2.6579E-02,
     +2.6579E-02,2.6580E-02,2.6581E-02,2.6582E-02,2.6583E-02,2.6584E-02,
     +2.6585E-02,2.6586E-02,2.6587E-02,2.6588E-02,2.6590E-02,2.6592E-02,
     +2.6594E-02,2.6596E-02,2.6598E-02,2.6600E-02,2.6604E-02,2.6608E-02,
     +2.6612E-02,2.6617E-02,2.6622E-02,2.6627E-02,2.6636E-02,2.6646E-02,
     +2.6666E-02,2.6671E-02,2.6673E-02,2.6674E-02,2.6675E-02,2.6676E-02,
     +2.6679E-02,2.6684E-02,2.6690E-02,2.6700E-02,2.6705E-02,2.6708E-02,
     +2.6710E-02,2.6712E-02,2.6715E-02,2.6716E-02,2.6717E-02,2.6719E-02,
     +2.6720E-02,2.6721E-02,2.6721E-02,2.6722E-02,2.6722E-02,2.6722E-02,
     +2.6723E-02,2.6723E-02,2.6724E-02,2.6725E-02,2.6725E-02,2.6726E-02,
     +2.6727E-02,2.6727E-02,2.6727E-02,2.6728E-02,2.6728E-02,2.6728E-02,
     +2.6728E-02,2.6729E-02,2.6730E-02,2.6730E-02,2.6730E-02,2.6730E-02,
     +2.6731E-02,2.6731E-02,2.6731E-02,2.6732E-02,2.6732E-02,2.6733E-02,
     +2.6733E-02,2.6733E-02,2.6733E-02,2.6733E-02,2.6734E-02,2.6734E-02,
     +2.6734E-02,2.6735E-02,2.6735E-02,2.6736E-02,2.6736E-02,2.6736E-02,
     +2.6736E-02,2.6737E-02,2.6737E-02,2.6738E-02,2.6738E-02,2.6739E-02,
     +2.6739E-02,2.6739E-02,2.6740E-02,2.6740E-02,2.6741E-02,2.6741E-02,
     +2.6742E-02,2.6742E-02,2.6742E-02,2.6742E-02,2.6742E-02,2.6743E-02,
     +2.6743E-02,2.6743E-02,2.6743E-02,2.6743E-02,2.6743E-02,2.6743E-02,
     +2.6743E-02,2.6744E-02,2.6744E-02,2.6744E-02,2.6745E-02,2.6745E-02,
     +2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,
     +2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,
     +2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,2.6745E-02,
     +2.6745E-02,2.6745E-02,2.6745E-02,2.6746E-02,2.6746E-02,2.6746E-02,
     +2.6746E-02,2.6746E-02,2.6746E-02,2.6746E-02,2.6747E-02,2.6747E-02,
     +2.6747E-02,2.6747E-02,2.6747E-02,2.6747E-02,2.6747E-02,2.6748E-02,
     +2.6748E-02,2.6748E-02,2.6748E-02,2.6748E-02,2.6748E-02,2.6748E-02,
     +2.6748E-02,2.6748E-02,2.6748E-02,2.6748E-02,2.6749E-02,2.6749E-02,
     +2.6749E-02,2.6750E-02,2.6750E-02,2.6750E-02,2.6751E-02,2.6751E-02,
     +2.6751E-02,2.6751E-02,2.6752E-02,2.6752E-02,2.6752E-02,2.6752E-02,
     +2.6752E-02,2.6752E-02,2.6752E-02,2.6752E-02,2.6752E-02,2.6752E-02,
     +2.6752E-02,2.6752E-02,2.6752E-02,2.6753E-02,2.6753E-02,2.6753E-02,
     +2.6753E-02,2.6754E-02,2.6754E-02,2.6754E-02,2.6754E-02,2.6755E-02,
     +2.6755E-02,2.6756E-02,2.6756E-02,2.6756E-02,2.6756E-02,2.6757E-02,
     +2.6757E-02,2.6757E-02,2.6757E-02,2.6757E-02,2.6758E-02,2.6759E-02,
     +2.6759E-02,2.6760E-02,2.6761E-02,2.6761E-02,2.6761E-02,2.6761E-02,
     +2.6762E-02,2.6762E-02,2.6762E-02,2.6762E-02,2.6762E-02,2.6762E-02,
     +2.6763E-02,2.6764E-02,2.6764E-02,2.6765E-02,2.6765E-02,2.6766E-02,
     +2.6766E-02,2.6767E-02,2.6767E-02,2.6768E-02,2.6768E-02,2.6768E-02,
     +2.6768E-02,2.6769E-02,2.6769E-02,2.6770E-02,2.6770E-02,2.6770E-02,
     +2.6770E-02,2.6770E-02,2.6770E-02,2.6771E-02,2.6771E-02,2.6771E-02,
     +2.6771E-02,2.6771E-02,2.6771E-02,2.6771E-02,2.6771E-02,2.6771E-02,
     +2.6771E-02,2.6772E-02,2.6772E-02,2.6772E-02,2.6772E-02,2.6772E-02,
     +2.6773E-02,2.6773E-02,2.6774E-02,2.6775E-02,2.6776E-02,2.6776E-02,
     +2.6776E-02,2.6777E-02,2.6777E-02,2.6778E-02,2.6779E-02,2.6779E-02,
     +2.6779E-02,2.6780E-02,2.6780E-02,2.6780E-02,2.6780E-02,2.6780E-02,
     +2.6781E-02,2.6781E-02,2.6781E-02,2.6781E-02,2.6781E-02,2.6781E-02,
     +2.6781E-02,2.6781E-02,2.6781E-02,2.6781E-02,2.6782E-02,2.6782E-02,
     +2.6782E-02,2.6783E-02,2.6784E-02,2.6784E-02,2.6784E-02,2.6784E-02,
     +2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,
     +2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,
     +2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,
     +2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,2.6785E-02,
     +2.6785E-02,2.6785E-02,2.6786E-02,2.6786E-02,2.6786E-02,2.6787E-02,
     +2.6787E-02,2.6787E-02,2.6788E-02,2.6788E-02,2.6788E-02,2.6788E-02,
     +2.6788E-02,2.6788E-02,2.6788E-02,2.6788E-02,2.6789E-02,2.6789E-02,
     +2.6789E-02,2.6789E-02,2.6789E-02,2.6789E-02,2.6789E-02,2.6790E-02,
     +2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,
     +2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,
     +2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,2.6790E-02,
     +2.6790E-02,2.6790E-02,2.6791E-02,2.6791E-02,2.6791E-02,2.6791E-02,
     +2.6791E-02,2.6791E-02,2.6791E-02,2.6791E-02,2.6791E-02,2.6791E-02,
     +2.6791E-02,2.6791E-02,2.6791E-02,2.6791E-02,2.6792E-02,2.6792E-02,
     +2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,
     +2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,
     +2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,2.6792E-02,
     +2.6792E-02,2.6792E-02,2.6792E-02,2.6793E-02,2.6793E-02,2.6793E-02,
     +2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,
     +2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,
     +2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,2.6793E-02,2.6794E-02,
     +2.6794E-02,2.6794E-02,2.6794E-02,2.6794E-02,2.6794E-02,2.6794E-02,
     +2.6794E-02,2.6794E-02,2.6794E-02,2.6794E-02,2.6794E-02,2.6794E-02,
     +2.6795E-02,2.6795E-02,2.6795E-02,2.6795E-02,2.6795E-02,2.6795E-02,
     +2.6795E-02,2.6795E-02,2.6795E-02,2.6795E-02,2.6796E-02,2.6796E-02,
     +2.6796E-02,2.6796E-02,2.6796E-02,2.6796E-02,2.6796E-02,2.6797E-02,
     +2.6797E-02,2.6797E-02,2.6798E-02,2.6798E-02,2.6799E-02,2.6799E-02,
     +2.6799E-02,2.6799E-02,2.6799E-02,2.6799E-02,2.6799E-02,2.6799E-02,
     +2.6800E-02,2.6800E-02,2.6800E-02,2.6801E-02,2.6801E-02,2.6801E-02,
     +2.6802E-02,2.6802E-02,2.6802E-02,2.6802E-02,2.6802E-02,2.6803E-02,
     +2.6803E-02,2.6804E-02,2.6804E-02,2.6804E-02,2.6804E-02,2.6805E-02,
     +2.6805E-02,2.6805E-02,2.6806E-02,2.6807E-02,2.6807E-02,2.6807E-02,
     +2.6807E-02,2.6808E-02,2.6808E-02,2.6808E-02,2.6809E-02,2.6810E-02,
     +2.6810E-02,2.6810E-02,2.6811E-02,2.6811E-02,2.6812E-02,2.6812E-02,
     +2.6813E-02,2.6813E-02,2.6813E-02,2.6813E-02,2.6814E-02,2.6814E-02,
     +2.6815E-02,2.6818E-02,2.6820E-02,2.6823E-02,2.6824E-02,2.6825E-02,
     +2.6826E-02,2.6829E-02,2.6834E-02,2.6836E-02,2.6837E-02,2.6838E-02,
     +2.6841E-02,2.6847E-02,2.6858E-02,2.6869E-02,2.6880E-02,2.6886E-02,
     +2.6897E-02,2.6908E-02,2.6929E-02,2.6932E-02,2.6938E-02,2.6949E-02,
     +2.6970E-02,2.6992E-02,2.7003E-02,2.7004E-02,2.7004E-02,2.7005E-02,
     +2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,
     +2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,
     +2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,
     +2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,2.7005E-02,
     +2.7006E-02,2.7006E-02,2.7008E-02,2.7010E-02,2.7014E-02,2.7018E-02,
     +2.7025E-02,2.7040E-02,2.7048E-02,2.7063E-02,2.7071E-02,2.7086E-02,
     +2.7101E-02,2.7130E-02,2.7134E-02,2.7136E-02,2.7137E-02,2.7139E-02,
     +2.7141E-02,2.7142E-02,2.7144E-02,2.7149E-02,2.7153E-02,2.7155E-02,
     +2.7159E-02,2.7162E-02,2.7166E-02,2.7171E-02,2.7174E-02,2.7179E-02,
     +2.7182E-02,2.7187E-02,2.7193E-02,2.7196E-02,2.7202E-02,2.7205E-02,
     +2.7209E-02,2.7213E-02,2.7220E-02,2.7227E-02,2.7229E-02,2.7233E-02,
     +2.7237E-02,2.7240E-02,2.7244E-02,2.7248E-02,2.7258E-02,2.7262E-02,
     +2.7264E-02,2.7269E-02,2.7271E-02,2.7273E-02,2.7276E-02,2.7278E-02,
     +2.7283E-02,2.7294E-02,2.7296E-02,2.7301E-02,2.7307E-02,2.7317E-02,
     +2.7327E-02,2.7333E-02,2.7338E-02,2.7341E-02,2.7346E-02,2.7352E-02,
     +2.7363E-02,2.7369E-02,2.7381E-02,2.7384E-02,2.7386E-02,2.7389E-02,
     +2.7393E-02,2.7394E-02,2.7395E-02,2.7397E-02,2.7399E-02,2.7399E-02,
     +2.7401E-02,2.7404E-02,2.7406E-02,2.7408E-02,2.7411E-02,2.7412E-02,
     +2.7413E-02,2.7414E-02,2.7415E-02,2.7417E-02,2.7419E-02,2.7422E-02,
     +2.7423E-02,2.7424E-02,2.7425E-02,2.7426E-02,2.7427E-02,2.7428E-02,
     +2.7430E-02,2.7432E-02,2.7433E-02,2.7437E-02,2.7438E-02,2.7439E-02,
     +2.7441E-02,2.7442E-02,2.7444E-02,2.7447E-02,2.7451E-02,2.7452E-02,
     +2.7453E-02,2.7454E-02,2.7456E-02,2.7458E-02,2.7459E-02,2.7461E-02,
     +2.7463E-02,2.7466E-02,2.7468E-02,2.7471E-02,2.7475E-02,2.7478E-02,
     +2.7479E-02,2.7481E-02,2.7485E-02,2.7489E-02,2.7497E-02,2.7502E-02,
     +2.7504E-02,2.7505E-02,2.7506E-02,2.7508E-02,2.7510E-02,2.7511E-02,
     +2.7514E-02,2.7518E-02,2.7519E-02,2.7521E-02,2.7523E-02,2.7526E-02,
     +2.7530E-02,2.7532E-02,2.7534E-02,2.7537E-02,2.7538E-02,2.7538E-02,
     +2.7540E-02,2.7542E-02,2.7544E-02,2.7545E-02,2.7546E-02,2.7547E-02,
     +2.7547E-02,2.7548E-02,2.7548E-02,2.7549E-02,2.7552E-02,2.7554E-02,
     +2.7557E-02,2.7558E-02,2.7558E-02,2.7559E-02,2.7560E-02,2.7562E-02,
     +2.7563E-02,2.7566E-02,2.7568E-02,2.7571E-02,2.7574E-02,2.7579E-02,
     +2.7590E-02,2.7592E-02,2.7597E-02,2.7600E-02,2.7605E-02,2.7610E-02,
     +2.7620E-02,2.7630E-02,2.7635E-02,2.7645E-02,2.7650E-02,2.7660E-02,
     +2.7664E-02,2.7669E-02,2.7672E-02,2.7675E-02,2.7680E-02,2.7685E-02,
     +2.7691E-02,2.7697E-02,2.7698E-02,2.7699E-02,2.7700E-02,2.7701E-02,
     +2.7704E-02,2.7711E-02,2.7714E-02,2.7716E-02,2.7720E-02,2.7724E-02,
     +2.7732E-02,2.7740E-02,2.7756E-02,2.7758E-02,2.7759E-02,2.7761E-02,
     +2.7762E-02,2.7763E-02,2.7763E-02,2.7764E-02,2.7765E-02,2.7766E-02,
     +2.7767E-02,2.7768E-02,2.7770E-02,2.7774E-02,2.7778E-02,2.7783E-02,
     +2.7792E-02,2.7793E-02,2.7795E-02,2.7800E-02,2.7802E-02,2.7807E-02,
     +2.7817E-02,2.7819E-02,2.7822E-02,2.7827E-02,2.7829E-02,2.7832E-02,
     +2.7837E-02,2.7847E-02,2.7856E-02,2.7858E-02,2.7863E-02,2.7866E-02,
     +2.7869E-02,2.7872E-02,2.7875E-02,2.7877E-02,2.7880E-02,2.7882E-02,
     +2.7886E-02,2.7888E-02,2.7892E-02,2.7894E-02,2.7898E-02,2.7903E-02,
     +2.7907E-02,2.7916E-02,2.7925E-02,2.7930E-02,2.7939E-02,2.7956E-02,
     +2.7961E-02,2.7966E-02,2.7975E-02,2.7984E-02,2.7993E-02,2.8010E-02,
     +2.8027E-02,2.8036E-02,2.8045E-02,2.8062E-02,2.8079E-02,2.8087E-02,
     +2.8104E-02,2.8109E-02,2.8113E-02,2.8122E-02,2.8123E-02,2.8125E-02,
     +2.8130E-02,2.8132E-02,2.8134E-02,2.8139E-02,2.8141E-02,2.8146E-02,
     +2.8149E-02,2.8154E-02,2.8160E-02,2.8163E-02,2.8166E-02,2.8170E-02,
     +2.8173E-02,2.8179E-02,2.8181E-02,2.8182E-02,2.8183E-02,2.8187E-02,
     +2.8193E-02,2.8197E-02,2.8204E-02,2.8211E-02,2.8213E-02,2.8214E-02,
     +2.8215E-02,2.8215E-02,2.8215E-02,2.8215E-02,2.8216E-02,2.8216E-02,
     +2.8217E-02,2.8220E-02,2.8224E-02,2.8234E-02,2.8236E-02,2.8240E-02,
     +2.8245E-02,2.8253E-02,2.8262E-02,2.8278E-02,2.8286E-02,2.8295E-02,
     +2.8303E-02,2.8311E-02,2.8319E-02,2.8324E-02,2.8328E-02,2.8337E-02,
     +2.8345E-02,2.8361E-02,2.8393E-02,2.8426E-02,2.8490E-02,2.8500E-02,
     +2.8509E-02,2.8513E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,
     +2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,
     +2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,
     +2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,
     +2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,2.8514E-02,
     +2.8514E-02,2.8514E-02,2.8514E-02,2.8515E-02,2.8516E-02,2.8518E-02,
     +2.8522E-02,2.8530E-02,2.8545E-02,2.8576E-02,2.8609E-02,2.8617E-02,
     +2.8635E-02,2.8652E-02,2.8686E-02,2.8704E-02,2.8738E-02,2.8747E-02,
     +2.8764E-02,2.8798E-02,2.8864E-02,2.8881E-02,2.8899E-02,2.8900E-02,
     +2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,
     +2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,
     +2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,
     +2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8900E-02,2.8901E-02,
     +2.8901E-02,2.8903E-02,2.8906E-02,2.8913E-02,2.8925E-02,2.8949E-02,
     +2.8998E-02,2.9093E-02,2.9267E-02,2.9314E-02,2.9338E-02,2.9342E-02,
     +2.9343E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,
     +2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,
     +2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,
     +2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,
     +2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,2.9344E-02,
     +2.9344E-02,2.9345E-02,2.9345E-02,2.9346E-02,2.9348E-02,2.9353E-02,
     +2.9362E-02,2.9379E-02,2.9412E-02,2.9448E-02,2.9517E-02,2.9642E-02,
     +2.9705E-02,2.9825E-02,3.0058E-02,3.0180E-02,3.0242E-02,3.0350E-02,
     +3.0561E-02,3.0958E-02,3.1063E-02,3.1115E-02,3.1140E-02,3.1165E-02,
     +3.1214E-02,3.1304E-02,3.1480E-02,3.1814E-02,3.2424E-02,3.2502E-02,
     +3.2513E-02,3.2516E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,
     +3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,
     +3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,
     +3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,
     +3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,3.2517E-02,
     +3.2518E-02,3.2518E-02,3.2519E-02,3.2521E-02,3.2526E-02,3.2534E-02,
     +3.2550E-02,3.2582E-02,3.2641E-02,3.2758E-02,3.2878E-02,3.3108E-02,
     +3.3540E-02,3.3946E-02,3.4323E-02,3.4992E-02,3.5153E-02,3.5309E-02,
     +3.5397E-02,3.5444E-02,3.5467E-02,3.5479E-02,3.5486E-02,3.5498E-02,
     +3.5510E-02,3.5517E-02,3.5524E-02,3.5531E-02,3.5535E-02,3.5539E-02,
     +3.5542E-02,3.5544E-02,3.5546E-02,3.5548E-02,3.5550E-02,3.5551E-02,
     +3.5552E-02,3.5552E-02,3.5554E-02,3.5554E-02,3.5555E-02,3.5555E-02,
     +3.5556E-02,3.5556E-02,3.5556E-02,3.5557E-02,3.5557E-02,3.5558E-02,
     +3.5558E-02,3.5558E-02,3.5558E-02,3.5559E-02,3.5559E-02,3.5559E-02,
     +3.5559E-02,3.5559E-02,3.5559E-02,3.5560E-02,3.5560E-02,3.5560E-02,
     +3.5560E-02,3.5560E-02,3.5560E-02,3.5560E-02,3.5560E-02,3.5560E-02,
     +3.5560E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,
     +3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,
     +3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,
     +3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,3.5561E-02,
     +3.5561E-02,3.5561E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,
     +3.5562E-02,3.5562E-02,3.5562E-02,3.5562E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,3.5563E-02,
     +3.5563E-02,3.5563E-02,3.5563E-02,3.5564E-02,3.5564E-02,3.5564E-02,
     +3.5564E-02,3.5564E-02,3.5564E-02,3.5564E-02,3.5564E-02,3.5564E-02,
     +3.5564E-02,3.5564E-02,3.5564E-02,3.5564E-02,3.5564E-02,3.5564E-02,
     +3.5564E-02,3.5564E-02,3.5564E-02,3.5565E-02,3.5565E-02,3.5565E-02,
     +3.5565E-02,3.5565E-02,3.5565E-02,3.5565E-02,3.5565E-02,3.5565E-02,
     +3.5566E-02,3.5566E-02,3.5566E-02,3.5566E-02,3.5566E-02,3.5566E-02,
     +3.5567E-02,3.5567E-02,3.5567E-02,3.5568E-02,3.5568E-02,3.5568E-02,
     +3.5569E-02,3.5569E-02,3.5570E-02,3.5570E-02,3.5571E-02,3.5572E-02,
     +3.5573E-02,3.5573E-02,3.5574E-02,3.5576E-02,3.5578E-02,3.5579E-02,
     +3.5581E-02,3.5585E-02,3.5588E-02,3.5591E-02,3.5598E-02,3.5605E-02,
     +3.5619E-02,3.5634E-02,3.5662E-02,3.5690E-02,3.5745E-02,3.5853E-02,
     +3.5964E-02,3.6026E-02,3.6060E-02,3.6078E-02,3.6093E-02,3.6102E-02,
     +3.6110E-02,3.6115E-02,3.6119E-02,3.6122E-02,3.6123E-02,3.6123E-02,
     +3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,
     +3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,
     +3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,
     +3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,
     +3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,
     +3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,3.6123E-02,
     +3.6123E-02,3.6123E-02,3.6124E-02,3.6124E-02,3.6124E-02,3.6124E-02,
     +3.6126E-02,3.6128E-02,3.6130E-02,3.6132E-02,3.6134E-02,3.6136E-02,
     +3.6137E-02,3.6138E-02,3.6139E-02,3.6140E-02,3.6141E-02,3.6141E-02,
     +3.6142E-02,3.6142E-02,3.6143E-02,3.6143E-02,3.6143E-02,3.6143E-02,
     +3.6144E-02,3.6144E-02,3.6144E-02,3.6144E-02,3.6144E-02,3.6145E-02,
     +3.6145E-02,3.6145E-02,3.6145E-02,3.6145E-02,3.6145E-02,3.6145E-02,
     +3.6145E-02,3.6145E-02,3.6145E-02,3.6145E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,3.6146E-02,
     +3.6146E-02,3.6146E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,
     +3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6147E-02,3.6148E-02,
     +3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,
     +3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,
     +3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,3.6148E-02,
     +3.6148E-02,3.6148E-02,3.6149E-02,3.6149E-02,3.6149E-02,3.6149E-02,
     +3.6149E-02,3.6149E-02,3.6149E-02,3.6149E-02,3.6150E-02,3.6150E-02,
     +3.6150E-02,3.6150E-02,3.6151E-02,3.6151E-02,3.6151E-02,3.6152E-02,
     +3.6152E-02,3.6153E-02,3.6153E-02,3.6154E-02,3.6155E-02,3.6156E-02,
     +3.6157E-02,3.6159E-02,3.6161E-02,3.6163E-02,3.6166E-02,3.6170E-02,
     +3.6177E-02,3.6184E-02,3.6199E-02,3.6229E-02,3.6288E-02,3.6351E-02,
     +3.6383E-02,3.6415E-02,3.6431E-02,3.6446E-02,3.6454E-02,3.6458E-02,
     +3.6463E-02,3.6465E-02,3.6467E-02,3.6468E-02,3.6469E-02,3.6471E-02,
     +3.6471E-02,3.6472E-02,3.6472E-02,3.6473E-02,3.6473E-02,3.6474E-02,
     +3.6474E-02,3.6474E-02,3.6474E-02,3.6475E-02,3.6475E-02,3.6475E-02,
     +3.6475E-02,3.6475E-02,3.6475E-02,3.6475E-02,3.6476E-02,3.6476E-02,
     +3.6476E-02,3.6476E-02,3.6476E-02,3.6476E-02,3.6476E-02,3.6476E-02,
     +3.6476E-02,3.6476E-02,3.6476E-02,3.6476E-02,3.6476E-02,3.6476E-02,
     +3.6476E-02,3.6476E-02,3.6476E-02,3.6476E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,3.6477E-02,
     +3.6477E-02,3.6477E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,3.6478E-02,
     +3.6479E-02,3.6479E-02,3.6479E-02,3.6479E-02,3.6479E-02,3.6479E-02,
     +3.6479E-02,3.6479E-02,3.6479E-02,3.6480E-02,3.6480E-02,3.6480E-02,
     +3.6480E-02,3.6480E-02,3.6481E-02,3.6481E-02,3.6481E-02,3.6482E-02,
     +3.6482E-02,3.6483E-02,3.6484E-02,3.6485E-02,3.6486E-02,3.6488E-02,
     +3.6489E-02,3.6492E-02,3.6495E-02,3.6501E-02,3.6507E-02,3.6518E-02,
     +3.6542E-02,3.6588E-02,3.6612E-02,3.6635E-02,3.6647E-02,3.6654E-02,
     +3.6661E-02,3.6664E-02,3.6668E-02,3.6672E-02,3.6675E-02,3.6677E-02,
     +3.6679E-02,3.6681E-02,3.6683E-02,3.6685E-02,3.6687E-02,3.6689E-02,
     +3.6690E-02,3.6692E-02,3.6693E-02,3.6694E-02,3.6695E-02,3.6696E-02,
     +3.6697E-02,3.6698E-02,3.6701E-02,3.6703E-02,3.6705E-02,3.6707E-02,
     +3.6709E-02,3.6711E-02,3.6713E-02,3.6715E-02,3.6719E-02,3.6723E-02,
     +3.6728E-02,3.6736E-02,3.6744E-02,3.6761E-02,3.6792E-02,3.6823E-02,
     +3.6855E-02,3.6886E-02,3.6902E-02,3.6918E-02,3.6949E-02,3.6957E-02,
     +3.6965E-02,3.6973E-02,3.6990E-02,3.7020E-02,3.7035E-02,3.7050E-02,
     +3.7065E-02,3.7081E-02,3.7096E-02,3.7104E-02,3.7112E-02,3.7127E-02,
     +3.7142E-02,3.7157E-02,3.7186E-02,3.7244E-02,3.7358E-02,3.7577E-02,
     +3.7984E-02,3.8714E-02,3.9928E-02,4.1605E-02,4.2890E-02,4.4770E-02,
     +4.6162E-02,4.8166E-02,4.9541E-02,5.1530E-02,5.2977E-02,5.4113E-02,
     +5.5842E-02,5.7150E-02,5.9073E-02,6.0491E-02,6.2538E-02,6.3940E-02,
     +6.5987E-02,6.7484E-02,6.8667E-02,7.0484E-02,7.1878E-02,7.3002E-02,
     +7.3495E-02,7.3725E-02,7.3948E-02,7.4003E-02,7.4029E-02,7.4055E-02,
     +7.4059E-02,7.4060E-02,7.4062E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,7.4063E-02,
     +7.4063E-02,7.4063E-02,7.4063E-02,7.4064E-02,7.4064E-02,7.4066E-02,
     +7.4069E-02,7.4074E-02,7.4086E-02,7.4108E-02,7.4151E-02,7.4234E-02,
     +7.4398E-02,7.4553E-02,7.4852E-02,7.5138E-02,7.5670E-02,7.6164E-02,
     +7.7039E-02,7.8486E-02,7.9642E-02,8.1464E-02,8.2876E-02,8.4033E-02,
     +8.5840E-02,8.6582E-02,8.6670E-02,8.6732E-02/
c
      DO I=1,7330
        SETS(I)=VP1(I)
        SETPOL(I)=VP2(I)
      END DO
c
      END
!
!***********************************************************************
!
      SUBROUTINE GGRSTAB(NSTAB,TYPES,PPARTS)
c***********************************************************************
c                                                                      *
c   Obtaining stable particles from /GGREV/                            *
c                                                                      *
c   NSTAB - quantity of stable particles                               *
c   TYPES - types of stable particles                                  *
c   PPARTS - 4-vectors of stable particles                             *
c                                                                      *
c***********************************************************************
c
      Implicit NONE
c
      Real *8 PPART,MPART
      Integer * 4 NPART,TYPE,MOTHER
      COMMON /GGREV324/PPART(4,25),MPART(25),TYPE(25),MOTHER(25),NPART
c
      Integer *4 K,J,J1,NEV,PROD(25),PRODL(25,2),IND
      Integer *4 NSTAB,TYPES(25)
      REAL *8 PPARTS(4,25)
c
      DO J=1,NPART
        PROD(J)=0   ! for control that there is >= 1 decay product
        PRODL(J,1)=0
        PRODL(J,2)=0
      END DO                   
c
      NSTAB=0
c
      DO 1 J1=1,NPART
c
        IF(J1.EQ.3) GOTO 1           ! exclude resonance         
c
        IF(MOTHER(J1).EQ.0) THEN
          NSTAB=NSTAB+1              ! Scattered e+, e- + r.c. photons
          TYPES(NSTAB)=TYPE(J1)
          PPARTS(1,NSTAB)=PPART(1,J1)
          PPARTS(2,NSTAB)=PPART(2,J1)
          PPARTS(3,NSTAB)=PPART(3,J1)
          PPARTS(4,NSTAB)=PPART(4,J1)
        END IF
c
 1    CONTINUE
c
c   All particles excluding scattered and resonance
c
      DO 10 J=4,NPART        ! 1-st do cycle on decay products of resonance
        IND=Mother(J)
        IF(IND.EQ.0) GOTO 10 ! exclude r.c. photons
        PRODL(IND,1)=J       ! min0 index
        PRODL(IND,2)=J       ! max index 
 10   CONTINUE
c 
      DO 20 J=4,NPART        ! 2-nd do cycle on decay products of resonance
        IND=Mother(J)
        IF(IND.EQ.0) GOTO 20 ! exclude r.c. photons
        IF(J.LT.PRODL(IND,1)) PRODL(IND,1)=J  ! min index
 20   CONTINUE
c
      DO 30 J1=4,NPART
c
        IF(PRODL(J1,1).EQ.0.AND.MOTHER(J1).NE.0) THEN   ! stable
          NSTAB=NSTAB+1
          TYPES(NSTAB)=TYPE(J1)
          PPARTS(1,NSTAB)=PPART(1,J1)
          PPARTS(2,NSTAB)=PPART(2,J1)
          PPARTS(3,NSTAB)=PPART(3,J1)
          PPARTS(4,NSTAB)=PPART(4,J1)
c          Print 224, J1,TYPE(J1),MOTHER(J1), PRODL(J1,1),
c     &        PRODL(J1,2),(PPART(J,J1),J=1,4) 
        END IF
c
 30   CONTINUE
c
c 224  FORMAT(I3,I6,3I4,5(1pe13.5))
      END
!
!***********************************************************************
!       
 
      SUBROUTINE GGRRNDM(VEC,N)
c***********************************************************************
c                                                                      *
c   Interface for random number generator (as in GEANT, N=1)           *
c                                                                      *
c***********************************************************************
      Implicit NONE
c
      Real    *8 VEC,RLU
      Integer *4 N,N1
c
      Save
c
c   RNG from cernlib
c            
      VEC=RLU(0)
c
      N1=N
c      
      END
                                                            