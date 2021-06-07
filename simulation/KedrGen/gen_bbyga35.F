      SUBROUTINE GEN_BBYGA35(ICHI,EBEAM,THMINI,THMAXI,EMINI,ZMAXI,
     &     IRESI,FMAX)
c***********************************************************************
c
c   Event generator on base of BABAYAGA 3.5 for                        
c                                                                  
c   ICHI=1:  e+ e- ----> e+ e-  (gammas)                     
c   ICHI=2:  e+ e- ----> mu+ mu- (gammas)                    
c   ICHI=3:  e+ e- ----> gamma gamma (gammas)                
c   ICHI=4:  e+ e- ----> pi+ pi- (gammas)                    
c 
c   Input:
c
c     ICHI    = 1-4, channel, see above
c     EBEAM   - beam energy, GeV
c     THMINI  - minimum pair particles angle (deg.)
c     THMAXI  - maximum pair particles angle (deg.)
c     EMINI   - minimum pair particles energy (GeV)
c     ZMAXI   - maximum acollinearity of pair (deg.)
c     IRESI   = 0/1 : include hadronic resonances in VP for ICH = 1, 2
c     FMAX    - majorant value for weight. Used if FMAX>0
c                                                                  
c  Authors: C.M. Carloni Calame, G. Montagna, O. Nicrosini, F. Piccinini                                                 
c                                                                  
c   1)  Dipartamento di Fisica Nucleare e Teorica Universita di Pavia                                       
c   2)  INFN Sezione di Pavia      
c
c***********************************************************************
c
      IMPLICIT NONE
c
      REAL *8 EBEAM,THMINI,THMAXI,EMINI,ZMAXI,EGMINI,THGMINI,THGMAXI
      INTEGER *4 ICHI,IRESI
c      
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH

      COMMON /BBYFOTONY/ QPH(40,0:3),NPHO,NPHOTEV,ICUTPHOTONS
      REAL *8 QPH
      INTEGER *4 NPHO,NPHOTEV,ICUTPHOTONS

      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES       

      COMMON /BBYEXPCUTS/ THMIN,THMAX,EMIN,ZMAX,EGMIN,THGMIN,THGMAX
      REAL *8 THMIN,THMAX,EMIN,ZMAX,EGMIN,THGMIN,THGMAX

      COMMON /BBYRESLTS/ CTRL,XNCALLS,SEZ,ERR,WSEZ,WERR,SDMAX,SDMAXR,
     &                   EVENT(25)
      REAL *8 CTRL,XNCALLS,SEZ,ERR,WSEZ,WERR,SDMAX,SDMAXR
      REAL *4 EVENT
c                                                   
      REAL *8 PFINEL(0:3),PFINPOS(0:3),PM(0:3),PP(0:3) 
      REAL *8 QMIRR(0:3),QPIRR(0:3),P1(0:3),Y(10),X(40)
      REAL *8 Q2MIN,Q2MINMU,AMAA,XPOS,ENGMAX,R,VAR,XNEV,CSI
      REAL *8 COSCM,SDCM,XJAC,Q2MAX,CMIN,CMAX,RS,S,EPS,EPSP,X1MIN,A
      REAL *8 CCM,PHIFS,CMAXCM,SMAX,FATT,BBYPNB,BBYPNOB,ALNE,AIEPS,AI
      REAL *8 BBYSDIF,ANORM,BIN,WSUM,WSUM2,ESP,THETAL,TCM,UCM,FSQ2M,Q2F
      REAL *8 XEL,SHAT,COSG,ENG,BBYDOT,FMAX
      REAL *4 RVEC2(2),PH(1),RLU
c
      INTEGER *4 IPHCUT,ICUTG
      INTEGER *4 Oalpha,NEV,NCALLS,nemi,n10mi,nepi,n10pi,K,ICUT
      INTEGER *4 I,IWR,nemf,n10mf,nepf,n10pf
      CHARACTER *1 PHCUT,CUTG
c
      DATA NEV/0/
c
      SAVE NEV,NCALLS,OALPHA,CMIN,CMAX,ANORM,Q2MIN,Q2MINMU,Q2MAX
      SAVE PP,PM,PHCUT
      SAVE /BBYCONST/,/BBYEXPCUTS/,/BBYMASWI/,/BBYRESLTS/,/BBYFOTONY/
c            
      NEV=NEV+1
c
      IF(NEV.GT.1) GOTO 100
c
c************************************************************************
c
c  Important parameters are set to:
c
      ALPHA   = 1.D0/137.0359895D0   
      AME     = 0.51099906D-3      ! electron mass
      AMMU    = 105.658389D-3      ! muon mass
      AMPI    = 139.56995D-3       ! pion mass
      CONVFAC = 0.389379660D6      ! conversion factor from natural
                                   ! units to nanobarn
      Oalpha  = 0
      SDMAXR=0.         ! for real maximum weight calculation (T.V.A.)
c
      ICH=ICHI
      THMIN=THMINI
      THMAX=THMAXI
      EMIN=EMINI
      ZMAX=ZMAXI
      IARUN=1      ! IARUN=1 for ICH=1,2,4; IARUN=0 for ICH=3 - it is set below 
      IRES=IRESI   ! IRES=0 for ICH=3,4, see below
      EGMIN=EGMINI
      THGMIN=THGMINI
      THGMAX=THGMAXI
      ICUTG=0
      SEZ=-1.
c
      IF(ICH.LT.0.OR.ICH.GT.4) THEN 
        PRINT *,' GEN_BBYGA35: error, wrong number of channel'
        STOP
      END IF
c
      IF(ICH.eq.1.and.EMIN.lt.ame)  EMIN = AME   ! corrections
      IF(ICH.eq.2.and.EMIN.lt.ammu) EMIN = AMMU
      IF(ICH.eq.4.and.EMIN.lt.ampi) EMIN = AMPI
c
      ON=0                         ! FSR switch for ICH = 2 (0 = off, 1 = on)
      IF (ICH.NE.2) ON=1           ! by default
      IF (ICH.EQ.3.OR.ICH.EQ.4) ON = 0 ! really it is set below
c
c--------------------- Print initial data ----------------------------
c
      PRINT 3230
c
      IF(ICH.EQ.1) THEN
        PRINT *,'Generator 323, process = 1: e+e- --> e+ e- (n gam)'
        PRINT 3231,EBEAM,EMIN,THMIN,ZMAX,IRES
        IARUN=1         ! running alpha
        IF(IARUN.EQ.1) PRINT *,'Alpha QED is running'
        IF(IARUN.EQ.0) PRINT *,'Alpha QED is not running'
        ON=1
        PRINT *,'FSR is switched on'
        IPHCUT=0 ! to avoid double counting of gammas when ICH = 3 (Y/N)
        PRINT *,'FMAX=',FMAX
      END IF

      IF(ICH.EQ.2) THEN
        PRINT *,'Generator 323, process = 2: e+e- --> mu+ mu- (n gam)'
        PRINT 3231,EBEAM,EMIN,THMIN,ZMAX,IRES
        IARUN=1         ! running alpha
        PRINT *,'Alpha QED is running'
        ON=1
        PRINT *,'FSR is switched on'
        IPHCUT=0 ! to avoid double counting of gammas when ICH = 3 (Y/N)
        PRINT *,'FMAX=',FMAX
      END IF
c
      IF(ICH.EQ.3) THEN
        PRINT *,'Generator 323, process = 3: e+e- --> gam gam (n gam)'
        IRES=0   ! should be 0
        PRINT 3231,EBEAM,EMIN,THMIN,ZMAX,IRES
        IARUN=0  ! should be 0
        PRINT *,'Alpha QED is not running'
        ON=0
        PRINT *,'FSR is switched off'
        IPHCUT=1 ! to avoid double counting of gammas when ICH = 3 (Y/N)
        PRINT *,'FMAX=',FMAX
      END IF
c
c
      IF(ICH.EQ.4) THEN
        PRINT *,'Generator 323, process = 3: e+e- --> pi+ pi- (n gam)'
        IRES=0
        PRINT 3231,EBEAM,EMIN,THMIN,ZMAX,IRES
        IARUN=1   ! running alpha
        PRINT *,'Alpha QED is running'
        ON=0
        PRINT *,'FSR is switched off'
        IPHCUT=0 ! to avoid double counting of gammas when ICH = 3 (Y/N)
        PRINT *,'FMAX=',FMAX
      END IF
c
      PRINT *,'No cuts are imposed on PS photons' ! ICUTG=0
      PRINT 3230
c
c----------------------------------------------------------------------
c
      ILL = 0
      IF (ICH.EQ.2.AND.ON.EQ.0) ILL = 1
      IF (ICH.GE.3) ILL = 1
c
      PHCUT = 'N'
      IF (ICH.EQ.3.AND.IPHCUT.EQ.1) PHCUT='Y'

      CUTG = 'N'
      IF (ICUTG.eq.1) CUTG='Y'
      ICUTPHOTONS = 0
      IF (CUTG.EQ.'Y') ICUTPHOTONS = 1
c            
      IF (ICUTPHOTONS.EQ.0) then
        EGMIN=0.
        THGMIN=0.
        THGMAX=0.
      END IF
c
cc      IF (ICH.eq.1) PRINT*,'Simulated process: e+ e-  -->  e+ e- '
cc      IF (ICH.eq.2) PRINT*,'Simulated process: e+ e-  -->  mu+ mu- '
cc      IF (ICH.eq.3) PRINT*,'Simulated process: e+ e-  -->  gamma gamma'
cc      IF (ICH.eq.4) PRINT*,'Simulated process: e+ e-  -->  pi+ pi-'
cc      PRINT *,' '
c
cc      PRINT 200,EBEAM
 200  FORMAT(' Beam energy: ',F7.4,' GeV')
c
cc      PRINT 201,THMIN, THMAX
 201  FORMAT(' Angular cuts: ',F8.3,' deg. - ',F8.3,' deg.')
c
cc      PRINT 202,EMIN
 202  FORMAT(' Minimum energy: ',F11.6,' GeV')      
c
cc      PRINT 203,ZMAX
 203  FORMAT(' Maximum acollinearity: ',F8.4,' deg.')
cc      PRINT *,' '      
c
cc      IF (ICUTPHOTONS.eq.0) PRINT *,'No cuts are imposed on photons'
cc      IF (ICUTPHOTONS.eq.1) PRINT 204,EGMIN,THGMIN,THGMAX
 204  FORMAT(' Photon cuts:',F7.4,' GeV, ',F8.4,' deg. -',F8.4,' deg.')      
c
cc      IF (ON.EQ.1) PRINT *,'FSR is switched on'
cc      IF (ON.EQ.0) PRINT *,'FSR is switched off'
c
cc      IF(ICH.NE.3) THEN 
cc        IF (IARUN.eq.1) PRINT *,'Alpha is running'      
cc        IF (IARUN.eq.0) PRINT *,'Alpha is not running'
cc      END IF
c
cc      IF (IRES.EQ.1.AND.ICH.LE.2) PRINT *,
cc     &     'Hadronic resonances are included'
cc      IF (IRES.eq.0.and.ich.le.2) print*,
cc     &     'Hadronic resonances are not included'
cc       PRINT *,' '
c
cc      IF (ICH.eq.3) then
cc       PRINT *,'Phcut (for double counting in e+ e- ----> gamma gamma):
cc     &        ',phcut
cc      END IF
c
c----------------------------------------------------------------------
c
      PI    = 4.D0*ATAN(1.D0)
      ZMAX  = ZMAXI*PI/180.D0
      THMIN = THMINI*PI/180.D0
      THMAX = THMAXI*PI/180.D0

      THgmin = thgmin*pi/180.d0
      THgmax = thgmax*pi/180.d0

      CMIN = COS(THMAX)
      CMAX = COS(THMIN)
c
      Q2MIN   = EXP(1.D0)*AME**2 
      Q2MINMU = EXP(1.D0)*AMMU**2
      PIQ2    = 4.d0*ampi**2

      RS = 2.D0*EBEAM
      S  = RS**2 
c
      EPS = 1.D-5
      IF (Oalpha.gt.0) eps = 1.d-5
c
      EPSP=AME/EBEAM  
c
c**********************************************************
c
c   Hit or miss maximum is calculated (SDMAX).  
c
c**********************************************************
c
      X1MIN=EMIN/EBEAM
      A=(1.D0-X1MIN)/(1.D0+X1MIN)
c
      CMAXCM=(CMAX+A)/(1.D0+A*CMAX)
c
      SMAX=4.D0*EMIN**2
c
      FATT = (BBYPNB(S,Q2MIN,EPS)/BBYPNOB(S,Q2MIN,EPS,EPSP))**2
c
c
      IF (ICH.EQ.1) THEN
        ALNE = LOG(EPS)
        AIEPS= -2.D0*ALNE-1.5D0+2.D0*EPS-0.5D0*EPS**2 
        AI   = LOG((1.D0-EPS)/EPSP*((1.D0-EPSP)/EPS)**2)-1.D0
     &        +EPS+EPSP
c
        IF (AIEPS.LT.AI) THEN
          Q2F=S*(1.D0-CMIN)/(1.D0+CMIN)
        ELSE
          Q2F=S*(1.D0-CMAX)/(1.D0+CMAX) 
        END IF
c
        FATT=(BBYPNB(Q2F,Q2MIN,EPS)/BBYPNOB(Q2F,Q2MIN,EPS,EPSP))**2
c
        SDMAX=BBYSDIF(S,0.D0)/4.5D0*(4.D0+(1.D0+CMAX)**2)
     &      -BBYSDIF(S,0.D0)/4.5D0*(1.D0-CMIN)*(5.D0*CMIN+CMIN**2
     &      +CMIN**3+1.D0)
c
        SDMAX = FATT*SDMAX
     &         *(CMAX-CMIN)/(1.D0-CMIN)/(1.D0-CMAX) 
      END IF
c
c
      IF (ICH.EQ.2) THEN
        SDMAX= FATT*BBYSDIF(S,0.d0)*(CMAX-CMIN)
     &        *(1.D0+CMAX**2+4.D0*AMMU**2/SMAX)
      ENDIF
c
c
      IF (ICH.EQ.3) THEN
        ANORM = 0.5D0*LOG((1.D0-CMIN)*(1.D0+CMAX)/
     &         (1.D0+CMIN)/(1.D0-CMAX)) 
c
        SDMAX = FATT*BBYSDIF(S,CMAX)*ANORM*(1.D0-CMAX**2)
      END IF
c
c
      IF (ICH.EQ.4) THEN
         PIQ2 =  (0.7726D0)**2
         SDMAX = FATT*BBYSDIF(PIQ2,0.D0)*(CMAX-CMIN)/1.5D0
         IF (Oalpha.GT.0) SDMAX = SDMAX/FATT*2.5D0
      END IF
c
c**************************************************************
c
      IF(FMAX.GT.0.D0) SDMAX=FMAX ! one should use max. weight FMAX (T.V.A.)
              
      CTRL=0.D0 ! it controls if the integrand function exceeds the maximum
c                                                                  
      NCALLS=0    
c
      BIN=SQRT(1.D0-AME**2/EBEAM**2)
      PM(0)=EBEAM
      PM(1)=0.D0
      PM(2)=0.D0
      PM(3)=BIN*EBEAM 
c	 	
      PP(0)=EBEAM
      PP(1)=0.D0
      PP(2)=0.D0
      PP(3)=-BIN*EBEAM 
*
      WSUM  = 0.d0           ! weighted integration
      WSUM2 = 0.d0
c
c======================================================================
c
c---------- Begin of do loop over events ------------------------------
c
 100  CONTINUE
c
 113  NCALLS=NCALLS+1 

      RVEC2(1)=RLU(0)
      RVEC2(2)=RLU(0)   
c
        PH(1)=RLU(0)
c
        PHIFS=2.D0*PI*PH(1)
c        
        IF (ICH.EQ.1) THEN 
          CCM = ((CMAX-CMIN)*RVEC2(1)+(1.D0-CMAX)*CMIN)/
     &          (1.D0-CMAX+(CMAX-CMIN)*RVEC2(1))   
        END IF
c
c
        IF (ICH.EQ.2.OR.ICH.EQ.4) THEN
          CCM = (CMAX-CMIN)*RVEC2(1)+CMIN
        END IF
c
c
        IF (ICH.EQ.3) THEN
          ESP=EXP(2.D0*ANORM*RVEC2(1))
          CCM=((1.D0+CMIN)*ESP-(1.D0-CMIN))/
     &        ((1.D0+CMIN)*ESP+(1.D0-CMIN)) 
        END IF   
c
c
        THETAL=ACOS(CCM)
c
        TCM = -0.5D0*S*(1.D0-CCM)
        UCM = -0.5D0*S*(1.D0+CCM)
c
        IF (ICH.EQ.1)             Q2MAX = S*TCM/UCM
        IF (ICH.GE.2.or.ON.eq.0)  Q2MAX = S 
        IF (ICH.EQ.2.and.ON.eq.1) Q2MAX = S*TCM/UCM
c
c   if (Oalpha.eq.0) then  ! for order alpha PS
c
c   ALL-ORDER PHOTONS SHOWERS FROM FERMIONS:
c
c   Initial state electron.....
c
        CALL BBYPHOTS(Q2MIN,Q2MAX,EPS,EPSP,Y,NEMI,N10MI)
c
        DO K=1,10
          X(K)=Y(K)
        END DO
c
c   Initial state positron.....
c
        CALL BBYPHOTS(Q2MIN,Q2MAX,EPS,EPSP,Y,NEPI,N10PI)
c
        DO K=1,10
          X(K+10)=Y(K)
        END DO
c
        FSQ2M=Q2MIN
        IF (ICH.EQ.2) FSQ2M=Q2MINMU  
c
c  Final state electron.....
c
        CALL BBYPHOTT(FSQ2M,Q2MAX,EPS,y,nemf,n10mf)        
c     
        DO K=1,10
          X(K+20)=Y(K)
        END DO	
c
c  And final state positron
c	
        CALL BBYPHOTT(FSQ2M,Q2MAX,EPS,y,nepf,n10pf)        
c
        DO K=1,10
          X(K+30)=Y(K)
        END DO
c
c     else                                 ! for order alpha PS           
c         CALL PSOAL(Q2MAX,Q2MIN,EPS,X)    ! for order alpha PS
c     endif                                ! for order alpha PS
c
        XEL =1.d0
	XPOS=1.d0
c
	DO K=1,10
          XEL=XEL*X(K)
          XPOS=XPOS*X(K+10)
	END DO
c
	IF (ICH.eq.1) AMAA=AME
	IF (ICH.eq.2) AMAA=AMMU
        IF (ICH.eq.3) AMAA=0.d0
        IF (ICH.eq.4) AMAA=AMPI
c
        CALL BBYKIN(PM,PP,AMAA,X,CCM,PHIFS,QMIRR,QPIRR,QPH,IWR)
c
        IF (IWR.gt.0) goto 113
c
        SHAT=XEL*XPOS*S
c
c   Angular cut on ISR photons to avoid double counting in 
c   gamma gamma final state
c
        ENGMAX = EMIN
c        
        IF (PHCUT.EQ.'Y') THEN
c
          DO K=1,40  
            COSG = 1.D0
            ENG = QPH(K,0)
            IF (ENG.GT.1.D-12) COSG=qph(K,3)/ENG
            IF (COSG.GT.CMIN.AND.COSG.LT.CMAX.AND.ENG.GT.ENGMAX)GOTO 113 
          END DO
c
        END IF
c
        DO K=0,3
          PFINEL(K)=QMIRR(K)        
        END DO
c      
        DO K=0,3
          PFINPOS(K)=QPIRR(K)        
        END DO
c
c   Experimental cuts
c
        DO I = 0,3
          P1(I)=PFINPOS(I)+PFINEL(I)
        END DO

        PIQ2 = BBYDOT(P1,P1)

        CALL BBYCUT(PFINEL,PFINPOS,ICUT)
c

        IF(ICUT.LT.1) GO TO 113
c
c  Hit or miss
c
        IF (ICH.EQ.1) THEN
          XJAC=((1.D0-CCM)**2)*(CMAX-CMIN)/
     &         ((1.D0-CMAX)*(1.D0-CMIN))
        END IF   
c
        IF (ICH.EQ.2.OR.ICH.EQ.4) THEN
          XJAC=(CMAX-CMIN)
        END IF
c
        IF (ICH.EQ.3) THEN
          XJAC=ANORM*(1.D0-CCM**2)
        END IF
c
        COSCM=CCM           
c
        SDCM = BBYSDIF(SHAT,COSCM)*XJAC 

        IF (Oalpha.eq.0) then
           SDCM = SDCM*XEL*XPOS
           SDCM = SDCM
     &   *(BBYPNB(Q2MAX,Q2MIN,EPS)/BBYPNOB(Q2MAX,Q2MIN,EPS,EPSP))**2
        END IF
        
c
        IF (SDCM.GT.SDMAX) THEN 
          CTRL=CTRL+1.D0
        END IF
c
        IF(SDCM.GT.SDMAXR) SDMAXR=SDCM       ! inserted by V.A.T.
c 
        WSUM  = WSUM  + SDCM           ! for weighted cross section
        WSUM2 = wsum2 + SDCM**2

        CSI=RVEC2(2)*SDMAX

        IF(NCALLS.GT.10000.AND.SEZ.LT.0.) THEN
          PRINT *,' GEN_BBYGA35, error: too large majorant value'
          STOP
        END IF        

        IF(CSI.GT.SDCM) GOTO 113              
c
        CALL BBYFILEV(PFINEL,PFINPOS,EVENT)
c
c  Cross section calculation (nb)
c
        XNCALLS = 1.D0*NCALLS
        XNEV    = 1.D0*NEV
        R       = XNEV/XNCALLS
        SEZ     = R*SDMAX*CONVFAC 
        WSEZ    = WSUM/XNCALLS*CONVFAC
c
c  Statistical error in the cross section calculation
c
        VAR  = SQRT(R*(1.D0-R)/XNCALLS)
        ERR  = VAR*SDMAX*CONVFAC 
        WERR = (wsum2/xncalls-(wsez/convfac)**2)/xncalls
        WERR = sqrt(werr)*convfac
c
 3230 FORMAT(/,1x,60(1H*),/)
 3231 FORMAT(/,' Ebeam =',F7.4,' GeV',/,
     &   ' Minimum energy of particle of pair =',F7.4,' GeV',/,
     &   ' Minimum angle with axis =',F8.2,' deg.',/,
     &   ' Maximum acollinearity =',F9.2,' deg.',/,
     &   ' Resonances inclusion in VP =',I2)
c
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYPHOTS(Q2MIN,Q2MAX,EPS,EPSP,X,NB,N10)
c***********************************************************************
c
c   Parton shower for initial state radiation.
c   It calculates D(X,Q2MAX)/X.
c
c************************************************************************
      IMPLICIT NONE
c 
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH
      
      COMMON /BBYFOTONY/ QPH(40,0:3),NPHO,NPHOTEV,ICUTPHOTONS
      REAL *8 QPH
      INTEGER *4 NPHO,NPHOTEV,ICUTPHOTONS
                        
      REAL *8 Q2MIN,Q2MAX,EPS,EPSP,X(10),AK2,ALNE,AIEPS,AI
      REAL *8 PROBNB,BBYPNOB,DVEC,AKP2,Y
      REAL *4 RVEC1(1),RLU
      INTEGER *4 NB,N10,K
c
      DO K=1,10
        X(K)=1.d0
      END DO 
c
c  Integral of AP splitting function
c
      ALNE=DLOG(EPS)
      AIEPS=-2.D0*ALNE-1.5D0+2.D0*EPS-0.5D0*EPS**2 
      AI=DLOG((1.D0-EPS)/EPSP*((1.D0-EPSP)/EPS)**2)-1.D0+EPS+EPSP
c    	 	
c  Parton-shower algorithm
c
      N10=0  
      NPHOTEV=0
      AK2=Q2MIN
c
 110  RVEC1(1)=RLU(0)
c
      DVEC=1.D0*RVEC1(1)
c
      PROBNB=BBYPNOB(Q2MAX,AK2,EPS,EPSP)
c      
      IF (DVEC.LE.PROBNB) GOTO 111
c
      NPHOTEV=NPHOTEV+1  
      
      IF (NPHOTEV.GT.10) N10=1 
c
c  Virtuality extraction from Sudakov form factor (function PNB)   
c
      AKP2=-2.D0*PI/ALPHA/AI*LOG(DVEC) 
*
      AKP2=AK2*EXP(AKP2)                  
c
c  X generation from AP splitting function (P(X)/X....) 
c
      CALL BBYAPVER(Y,EPS,EPSP)
c      
      IF (NPHOTEV.le.10) X(NPHOTEV)=Y  

      AK2=AKP2   
      GO TO 110 
c
c  Variables are rotated to the lab. frame
c
 111   CONTINUE
c
      NB=nphotev 
c
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYPHOTT(Q2MIN,Q2MAX,EPS,X,NB,N10)
c***********************************************************************
c
c   Parton shower for final-state radiation. 
c   Generated x according to D(x,s)
c
c***********************************************************************
c
      IMPLICIT NONE
c
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH

      COMMON /BBYFOTONY/ QPH(40,0:3),NPHO,NPHOTEV,ICUTPHOTONS
      REAL *8 QPH
      INTEGER *4 NPHO,NPHOTEV,ICUTPHOTONS

      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES
                  
      REAL *8 Q2MIN,Q2MAX,EPS,X(10),ALNE,AIEPS,AK2,AMA,DVEC,PROBNB
      REAL *8 BBYPNB,AKP2,Y
      REAL*4 RVEC1(1),RLU
      INTEGER *4 NB,N10,LEN1,I
c
      PARAMETER (LEN1=1)
c
      DO I=1,10
        X(I)=1.D0
      END DO
c
      ALNE=DLOG(EPS)
      AIEPS=-2.D0*ALNE-1.5D0+2.D0*EPS-0.5D0*EPS**2 
c
      N10=0
      NPHOTEV=0
c 
      AK2=Q2MIN
c
      IF (ON.eq.0) GOTO 113
c
      IF (ICH.EQ.1) AMA=AME
      IF (ICH.EQ.2) AMA=AMMU
c
 101  RVEC1(1)=RLU(0)
c
      DVEC=1.D0*RVEC1(1)
c   
      PROBNB=BBYPNB(Q2MAX,AK2,EPS)
c      
      IF (DVEC.LE.PROBNB) GOTO 113
c
      NPHOTEV=NPHOTEV+1   
      IF (NPHOTEV.GT.10) N10=1
c
      AKP2=-2.D0*PI/ALPHA/AIEPS*LOG(DVEC) 
c
      AKP2=AK2*EXP(AKP2)                  
c
      CALL BBYPEFR(Y,EPS)
c
      IF(NPHOTEV.LE.10) X(NPHOTEV)=Y
c
      AK2=AKP2
c
      GO TO 101 
c
 113  NB=NPHOTEV
c
      END
c
c----------------------------------------------------------------------- 
c
      SUBROUTINE BBYKIN(PM,PP,AMA,Y,CCM,PHI,P3,P4,QPH,IE)
c***********************************************************************
c
c  The soubroutine has been taken from Drell-Yan program, because it's
c  much cleaner and more "readable" than the one in BABAYAGA 3.0....
c  It is also much faster!
c
c  Y(40) contains the FERMIONS energy fractions
c  X(40) the PHOTONS fractions
c
c***********************************************************************
c
      IMPLICIT NONE
c
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH

      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES
            
      REAL *8 PM(0:3),PP(0:3),AMA,Y(40),CCM,PHI,P3(0:3),P4(0:3)
      REAL *8 QPH(40,0:3),X(40),VBOOST(0:3),XF(4),PTMP(0:3),DIR3(0:3)
      REAL *8 DIR4(0:3),MF(4),MTOTFS,TMP2(0:3),KONE(0:3),VER(0:3)
      REAL *8 ETOT,E3,E4,B3,B4,BQED,GQED,E1,E2,SCM,SPHI,CPHI,E3BEFORE
      REAL *8 E4BEFORE,E3AFTER,E4AFTER,B1,B2,O1,O2,O3,O4,PHPH,AN
      REAL *8 CTH,STH,CPH,SPH,BBYDOT,BCM,GCM,P3MODMO,BBY3DOT,P4MODMO
      REAL *8 WW,BBYWRW,WOK,RHO,TETTO,ABBASSATETTO,CFR,BBYWEI,VERMO
      REAL *4 RVEC(2),CSI(1),RLU
      INTEGER *4 LEG(4),IE,K,I_RIGENERA,N_RIGENERATI,I,J,NPHOT
c
      IE = 0

      do K = 1,4
         xf(k)  = 1.d0
         leg(k) = 0
      end do

      do K = 1,10         
         xf(1)=xf(1)*y(k)
         xf(2)=xf(2)*y(10+k)
         xf(3)=xf(3)*y(20+k)
         xf(4)=xf(4)*y(30+k)      
      end do

      mf(1) = ame
      mf(2) = ame
      mf(3) = ama
      mf(4) = ama
      
      E1 = pm(0)
      E2 = pp(0)

      scm  = sqrt(1.d0 - ccm*ccm)
      sphi = sin(phi)
      cphi = cos(phi)
      
      mtotfs = mf(3)+mf(4)

      do K = 1,40
        x(k) = 1.d0-y(k)
        qph(k,0) = 0.d0
        qph(k,1) = 0.d0
        qph(k,2) = 0.d0
        qph(k,3) = 0.d0
      end do      

      if (xf(1).eq.1.d0.and.xf(2).eq.1.d0.and.
     &    xf(3).eq.1.d0.and.xf(4).eq.1.d0) then
         
         Etot = E1 + E2
         
         E3 = (Etot**2+mf(3)**2-mf(4)**2)/2.d0/Etot
         E4 = Etot-E3
         
         b3 = (1.d0+mf(3)/E3)*(1.d0-mf(3)/E3)
         b3 = sqrt(b3)
         
         b4 = (1.d0+mf(4)/E4)*(1.d0-mf(4)/E4)
         b4 = sqrt(b4)
         
         p3(1) = b3*E3*sphi*scm
         p3(2) = b3*E3*cphi*scm
         p3(3) = b3*E3*ccm
         p3(0) = E3
         
         p4(1) = -p3(1)   
         p4(2) = -p3(2)   
         p4(3) = -p3(3)   
         p4(0) =  E4

         GOTO 500
      end if    

      do K=1,10
         if (x(k).gt.0.d0)    leg(1)=leg(1)+1
         if (x(k+10).gt.0.d0) leg(2)=leg(2)+1
         if (x(k+20).gt.0.d0) leg(3)=leg(3)+1
         if (x(k+30).gt.0.d0) leg(4)=leg(4)+1
      end do

      i_rigenera   = 1
      n_rigenerati = 0

      DO WHILE(i_rigenera.eq.1) !--------------------------------------------
*
      n_rigenerati = n_rigenerati + 1
* 
* This is the DO LOOP for weighting coherent photons....
*
      do k=0,3
         vboost(k) = 0.d0
         kone(k)   = 0.d0
      end do      
*
* the beta and gamma of the boost due to QED radiation are calculated
* 
      bqed = (xf(1)-xf(2))/(xf(1)+xf(2))
      gqed = 1.d0/dsqrt(1.d0-bqed*bqed)
*
* The momenta of the FS particles in the CM are reconstructed and boosted back
*
      E3 = xf(1)*E1*gqed*(1.d0-bqed)  ! E3 and E4 must be equal...
      E4 = xf(2)*E2*gqed*(1.d0+bqed)

! I mantain fully massive kinematics for final state....
      
      Etot = E3 + E4
      
      E3 = (Etot**2+mf(3)**2-mf(4)**2)/2.d0/Etot
      E4 = Etot-E3

      if (E3.lt.mf(3).or.E4.lt.mf(4)) then
         ie = 1
         GOTO 500
      endif
      
      b3 = (1.d0+mf(3)/E3)*(1.d0-mf(3)/E3)
      b3 = sqrt(b3)
      
      b4 = (1.d0+mf(4)/E4)*(1.d0-mf(4)/E4)
      b4 = sqrt(b4)
            
      p3(1) = b3*E3*cphi*scm
      p3(2) = b3*E3*sphi*scm
      p3(3) = b3*E3*ccm
      p3(0) = E3

      p4(1) = -p3(1)   
      p4(2) = -p3(2)   
      p4(3) = -p3(3)   
      p4(0) =  E4   
     
      vboost(3) = -bqed
            
      CALL BBYBOOST(GQED,VBOOST,P3,P3)

      CALL BBYBOOST(GQED,VBOOST,P4,P4)
*
* Once boosted back, p3 and p4 are degradated for QED radiation....
*      
!      p3modmo = 1.d0/sqrt(tridot(p3,p3))
!      p4modmo = 1.d0/sqrt(tridot(p4,p4))

*** dir3 and dir4 contain the directions along with I'll generate PS photons

      do i = 0,3
         dir3(i) = p3(i)
         dir4(i) = p4(i)
      enddo
**
      E3before = p3(0)
      E4before = p4(0)
      
      E3after = p3(0)*xf(3)
      E4after = p4(0)*xf(4)

      if (E3after.lt.mf(3).or.E4after.lt.mf(4)) then
         ie = 2
         GOTO 500
      endif
             
      b1 = (1+mf(1)/E1)*(1-mf(1)/E1)
      b1 = sqrt(b1)
      b2 = (1+mf(2)/E2)*(1-mf(2)/E2)
      b2 = sqrt(b2)
      b3 = (1+mf(3)/E3after)*(1-mf(3)/E3after)
      b3 = sqrt(b3)
      b4 = (1+mf(4)/E4after)*(1-mf(4)/E4after)
      b4 = sqrt(b4)
    
********** PHOTONS are reconstructed ***********

      o1 = E1
      o2 = E2
      o3 = E3before
      o4 = E4before
         
      do k = 1,10
      
         qph(k,0)    = o1*x(k)
         qph(k+10,0) = o2*x(k+10)
         qph(k+20,0) = o3*x(k+20)
         qph(k+30,0) = o4*x(k+30)
      
         o1 = o1 - qph(k,0)
         o2 = o2 - qph(k+10,0)
         o3 = o3 - qph(k+20,0)
         o4 = o4 - qph(k+30,0)
     
*** Photons angles....

         if (qph(k,0).gt.0.d0) then 
            
            RVEC(1)=RLU(0)
            RVEC(2)=RLU(0)

            phph = 2.d0*pi*rvec(1)
            
            an  = -1.d0/b1*log((1.d0-b1)/(1.d0+b1))
            cth = (1.d0 - (1.d0+b1)*
     #           exp(-b1*an*rvec(2)))/b1
      
            sth = sqrt(1.d0-cth*cth)
            cph = cos(phph)
            sph = sin(phph)
            
            qph(k,1) = qph(k,0)*sph*sth
            qph(k,2) = qph(k,0)*cph*sth
            qph(k,3) = qph(k,0)*cth
            
         endif
**       
         if (qph(k+10,0).gt.0.d0) then 

            RVEC(1)=RLU(0)
            RVEC(2)=RLU(0)


            phph = 2.d0*pi*rvec(1)
            
            an  = -1.d0/b2*log((1.d0-b2)/(1.d0+b2))
            cth = (1.d0 - (1.d0+b2)*
     #           exp(-b2*an*rvec(2)))/b2
            
            sth = sqrt(1.d0-cth*cth)
            cph = cos(phph)
            sph = sin(phph)
            
            qph(k+10,1) = qph(k+10,0)*sph*sth
            qph(k+10,2) = qph(k+10,0)*cph*sth
            qph(k+10,3) = qph(k+10,0)*cth
            
         endif
**
         if (qph(k+20,0).gt.0.d0) then 
            
            RVEC(1)=RLU(0)
            RVEC(2)=RLU(0)

            phph = 2.d0*pi*rvec(1)
            
            an  = -1.d0/b3*log((1.d0-b3)/(1.d0+b3))
            cth = (1.d0 - (1.d0+b3)*
     #           exp(-b3*an*rvec(2)))/b3
            
            sth = sqrt(1.d0-cth*cth)
            cph = cos(phph)
            sph = sin(phph)
            
            qph(k+20,1) = qph(k+20,0)*sph*sth
            qph(k+20,2) = qph(k+20,0)*cph*sth
            qph(k+20,3) = qph(k+20,0)*cth
            
         endif
**
         if (qph(k+30,0).gt.0.d0) then 
            
            RVEC(1)=RLU(0)
            RVEC(2)=RLU(0)

            phph = 2.d0*pi*rvec(1)
            
            an  = -1.d0/b4*log((1.d0-b4)/(1.d0+b4))
            cth = (1.d0 - (1.d0+b4)*
     #           exp(-b4*an*rvec(2)))/b4
      
            sth = sqrt(1.d0-cth*cth)
            cph = cos(phph)
            sph = sin(phph)
            
            qph(k+30,1) = qph(k+30,0)*sph*sth
            qph(k+30,2) = qph(k+30,0)*cph*sth
            qph(k+30,3) = qph(k+30,0)*cth
            
         endif
**
      enddo

* reporting photons in the lab system....

***************************************************
      tmp2(0) =  1.d0
      tmp2(1) =  0.d0
      tmp2(2) =  0.d0
      tmp2(3) = -1.d0

      do k = 1,10
**       
       if (qph(k+10,0).gt.0.d0) then

          ptmp(0) = qph(k+10,0)
          ptmp(1) = qph(k+10,1)
          ptmp(2) = qph(k+10,2)
          ptmp(3) = qph(k+10,3)
       
          CALL BBYROTN(-1,TMP2,PTMP,PTMP)
          
          qph(k+10,0) = ptmp(0) 
          qph(k+10,1) = ptmp(1) 
          qph(k+10,2) = ptmp(2)
          qph(k+10,3) = ptmp(3)
          
       endif
**       
       if (qph(k+20,0).gt.0.d0) then

          ptmp(0) = qph(k+20,0)
          ptmp(1) = qph(k+20,1)
          ptmp(2) = qph(k+20,2)
          ptmp(3) = qph(k+20,3)
          
          CALL BBYROTN(-1,DIR3,PTMP,PTMP)
          
          qph(k+20,0) = ptmp(0) 
          qph(k+20,1) = ptmp(1) 
          qph(k+20,2) = ptmp(2)
          qph(k+20,3) = ptmp(3)
       
       endif
**      
       if (qph(k+30,0).gt.0.d0) then

          ptmp(0) = qph(k+30,0)
          ptmp(1) = qph(k+30,1)
          ptmp(2) = qph(k+30,2)
          ptmp(3) = qph(k+30,3)
       
          CALL BBYROTN(-1,DIR4,PTMP,PTMP)
          
          qph(k+30,0) = ptmp(0) 
          qph(k+30,1) = ptmp(1) 
          qph(k+30,2) = ptmp(2)
          qph(k+30,3) = ptmp(3)

       endif
**
      enddo
*
* I recalculate p3 and p4 in order to have exact 4-momentum conservation...
* The strategy is analogous to the one used in BABAYAGA
*
      do k = 1,40
         do j = 0,3
            kone(j) = kone(j)+qph(k,j)
         enddo
      enddo        
      
      ptmp(0) = E1+E2-kone(0)
      ptmp(1) = -kone(1)
      ptmp(2) = -kone(2)
      ptmp(3) = b1*E1-b2*E2-kone(3)
      
      if (BBYDOT(ptmp,ptmp).lt.mtotfs**2) then
       ie = 3 
       GOTO 500
      endif 
      
      vboost(0) = 0.d0
      vboost(1) = ptmp(1)/ptmp(0)
      vboost(2) = ptmp(2)/ptmp(0)
      vboost(3) = ptmp(3)/ptmp(0)
      
      bcm = sqrt(vboost(1)**2+vboost(2)**2+vboost(3)**2)
      gcm = 1.d0/sqrt(1.d0-bcm**2)
 
      CALL BBYBOOST(GCM,VBOOST,PTMP,PTMP)

      Etot = ptmp(0)

      E3 = (Etot**2+mf(3)**2-mf(4)**2)/2.d0/Etot
      E4 = Etot-E3

      if (E3.lt.mf(3).or.E4.lt.mf(4)) then
      	ie = 4
        GOTO 500
      endif	

      b3 = (1.d0+mf(3)/E3)*(1.d0-mf(3)/E3)
      b3 = sqrt(b3)      
      b4 = (1.d0+mf(4)/E4)*(1.d0-mf(4)/E4)
      b4 = sqrt(b4)
c
c  Now I use "versori" directed as dir3 and dir4. This do not mean that
c  p3 and p4 will be directed as dir3 and dir4 when boosted back in the 
c  lab., because they are massive! But this is not a real problem and it 
c  is implicit in the 2-body approximation of the PS....
c            
      CSI(1)=RLU(0)

      if (csi(1).lt.0.5) then

         p3modmo = 1.d0/DSQRT(BBY3DOT(dir3,dir3))        
         ver(0) = 1.d0          ! I forgot masses....
         ver(1) = dir3(1)*p3modmo
         ver(2) = dir3(2)*p3modmo
         ver(3) = dir3(3)*p3modmo

      else

         p4modmo = 1.d0/DSQRT(BBY3DOT(dir4,dir4))
         ver(0) = 1.d0          ! I forgot masses....
         ver(1) = dir4(1)*p4modmo
         ver(2) = dir4(2)*p4modmo
         ver(3) = dir4(3)*p4modmo

      endif

      CALL BBYBOOST(GCM,VBOOST,VER,VER)
*
**********************************************************
*  from /home/carlo/PhDThesis/programs/CNL+babayaga/kinematics_test_forsub.f 
*  IT IS NOT CORRECT!
*********************************************************
*      v = bcm
* 
*      cvb=tridot(vboost,ver)/v
*      
*      bp=sqrt(1.d0-mf(3)**2/E3**2)
*      
*      abig=gcm**2*(1.d0-bp**2)
*      
*      ax=(1.d0+v**2*abig*cvb**2) 
*      bx=-2.d0*abig*v*cvb
*      cx=abig-1.d0
*      
*      blab=-bx+sqrt(bx**2-4.d0*ax*cx)
*      blab=blab/2.d0/ax
*      
*      print*,blab,'IL PRINT é QUI!!!! ' 
*
*      elab=1.d0/(1.d0-blab**2)*mf(3)**2
*      elab=sqrt(elab)
*
*      ver(0)=elab
*      ver(1)=elab*blab*ver(1)
*      ver(2)=elab*blab*ver(2)
*      ver(3)=elab*blab*ver(3)
*
*      call boost(gcm,vboost,ver,ver) 
*     
*      v = sqrt(ver(1)**2+ver(2)**2+ver(3)**2)
*      
*      ver(1) = ver(1)/v
*      ver(2) = ver(2)/v
*      ver(3) = ver(3)/v
****************************************************
*****************************************************
*
      if (csi(1).lt.0.5) then
 
         vermo = 1.d0/DSQRT(BBY3DOT(ver,ver))

         p3(1) = b3*E3*ver(1)*vermo
         p3(2) = b3*E3*ver(2)*vermo
         p3(3) = b3*E3*ver(3)*vermo
         p3(0) = E3

         p4(1) = -p3(1)   
         p4(2) = -p3(2)   
         p4(3) = -p3(3)   
         p4(0) =  E4

      else

         vermo = 1.d0/DSQRT(BBY3DOT(ver,ver))

         p4(1) = b4*E4*ver(1)*vermo
         p4(2) = b4*E4*ver(2)*vermo
         p4(3) = b4*E4*ver(3)*vermo
         p4(0) = E4

         p3(1) = -p4(1)   
         p3(2) = -p4(2)   
         p3(3) = -p4(3)   
         p3(0) =  E3      
      endif
         
      do i=0,3
        vboost(i)=-vboost(i)
      enddo  

      CALL BBYBOOST(GCM,VBOOST,P3,P3)

      CALL BBYBOOST(GCM,VBOOST,P4,P4)

* Now I weight photon angular distribution to account for
* coherence effects...
      
      ww=BBYWRW(pm,pp,dir3,dir4,qph)       

      wok=BBYWEI(pm,pp,dir3,dir4,qph)
       
      CSI(1)=RLU(0)

      rho=1.d0*csi(1)  
      
      nphot=leg(1)+leg(2)+leg(3)+leg(4)
      
      tetto=ww

      abbassatetto = (1.d0 + ill)*(0.65d0-ill*0.05d0)

      tetto = tetto/abbassatetto
        
      if (nphot.gt.2) tetto=tetto/nphot*3.d0
      
      cfr=rho*tetto

***      if (tetto.lt.wok) print*,'warning: tetto < wok ',wok/tetto,leg

      if (cfr.gt.wok) i_rigenera = 1
      if (cfr.lt.wok) i_rigenera = 0
      
      END DO !-----------------------------------------------------
c            
 500  RETURN
      END
c      
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYROTN(IDIR,VECT,PIN,POUT)
c***********************************************************************
c
c  This subroutine rotate the 4-vector pin in the frame where the z-axis 
c  is directed along the 4-vector vect(0,1,2,3). The rotated vector is 
c  stored in pout
c
c  idir =  1 ---> direct rotation matrix
c  idir = -1 ---> inverse rotation matrix
c
c***********************************************************************
c
      IMPLICIT NONE
c
      REAL *8 VECT(0:3),PIN(0:3),POUT(0:3),PP(0:3),R(3,3),VERS(3)
      REAL *8 VMO,VT,V1OVT,V2OVT
      INTEGER *4 IDIR
c
      pp(0) = pin(0)
      pp(1) = pin(1)
      pp(2) = pin(2)
      pp(3) = pin(3)
      
      vmo = 1.d0/sqrt(vect(1)**2+vect(2)**2+vect(3)**2)
      
      vers(1) = vect(1)*vmo
      vers(2) = vect(2)*vmo
      vers(3) = vect(3)*vmo
            
      vt = DSQRT(vers(1)**2+vers(2)**2)
      
      v1ovt = vers(1)/vt
      if (vt.eq.0.d0) v1ovt = 0.d0

      v2ovt = vers(2)/vt
      if (vt.eq.0.d0) v2ovt = 1.d0
      
      if (idir.eq.(-1)) then !! INVERSE rotation matrix

         r(1,1) =  vers(3)*v1ovt
         r(1,2) = -v2ovt
         r(1,3) =  vers(1)
         
         r(2,1) =  vers(3)*v2ovt
         r(2,2) =  v1ovt
         r(2,3) =  vers(2)
      
         r(3,1) = -vt
         r(3,2) =  0.d0
         r(3,3) =  vers(3)      

      else ! if (idir.eq.1) !! DIRECT rotation matrix
 
         r(1,1) =  vers(3)*v1ovt
         r(2,1) = -v2ovt
         r(3,1) =  vers(1)
         
         r(1,2) =  vers(3)*v2ovt
         r(2,2) =  v1ovt
         r(3,2) =  vers(2)
         
         r(1,3) = -vt
         r(2,3) =  0.d0
         r(3,3) =  vers(3)      
     
      end if
            
      pout(0) = pp(0)
      pout(1) = r(1,1)*pp(1) + r(1,2)*pp(2) + r(1,3)*pp(3)
      pout(2) = r(2,1)*pp(1) + r(2,2)*pp(2) + r(2,3)*pp(3)
      pout(3) = r(3,1)*pp(1) + r(3,2)*pp(2) + r(3,3)*pp(3)
      
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION BBYWEI(P1,P2,P3,P4,Q)
c***********************************************************************
c
c
c      
c***********************************************************************
c
      IMPLICIT NONE
c      
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH

      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES
                  
      REAL *8 BBYWEI,P1(0:3),P2(0:3),P3(0:3),P4(0:3),Q(40,0:3)
      REAL *8 qc(40,0:3),qa(0:3),pij(4,4),pidq(4),W,WQL,BBYDOT
      INTEGER *4 IYFS,K,I,J,KMAX
c
      IYFS = 1-ILL

         pij(1,1) =    -BBYDOT(p1,p1)
         pij(2,1) =     BBYDOT(p2,p1)
         pij(3,1) =  on*BBYDOT(p3,p1)*iyfs
         pij(4,1) = -on*BBYDOT(p4,p1)*iyfs
         pij(1,2) =     BBYDOT(p1,p2)
         pij(2,2) =    -BBYDOT(p2,p2)
         pij(3,2) = -on*BBYDOT(p3,p2)*iyfs
         pij(4,2) =  on*BBYDOT(p4,p2)*iyfs
         pij(1,3) =  on*BBYDOT(p1,p3)*iyfs
         pij(2,3) = -on*BBYDOT(p2,p3)*iyfs
         pij(3,3) = -on*BBYDOT(p3,p3)
         pij(4,3) =  on*BBYDOT(p4,p3)
         pij(1,4) = -on*BBYDOT(p1,p4)*iyfs
         pij(2,4) =  on*BBYDOT(p2,p4)*iyfs
         pij(3,4) =  on*BBYDOT(p3,p4)
         pij(4,4) = -on*BBYDOT(p4,p4)      

*!*!*!*!*!*!*!      
      w=1.d0  
   
      do k=1,40
        do i=0,3
	  qc(k,i)=0.d0  
        enddo
      enddo 

      j=1
      do k=1,40 
      
        if (q(k,0).ne.0.d0) then
          do i=0,3
	   qc(j,i)=q(k,i)
          enddo
         j=j+1       
        endif
      enddo 

      kmax=j-1
      do k=1,kmax
      
      if (qc(k,0).ne.0.d0) then
      
        do i=0,3
         qa(i)=qc(k,i)
        enddo 	      
      
        pidq(1)=BBYDOT(p1,qa)
        pidq(2)=BBYDOT(p2,qa)
        pidq(3)=BBYDOT(p3,qa)
        pidq(4)=BBYDOT(p4,qa)
      
        wql=0.d0
         
        do i=1,4
          do j=1,4
           wql=wql+pij(i,j)/pidq(i)/pidq(j)*qa(0)*qa(0)
          enddo 
        enddo 
       endif
            
      w=w*wql/k
                
      enddo

      BBYWEI=W

      END
c
c-----------------------------------------------------------------------
c
      FUNCTION BBYWRW(P1,P2,P3,P4,Q)
c***********************************************************************
c
c
c
c***********************************************************************      
      IMPLICIT NONE
c
      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES
                  
      REAL *8 BBYWRW,P1(0:3),P2(0:3),P3(0:3),P4(0:3),Q(40,0:3)
      REAL *8 QC(40,0:3),qa(0:3),p(4,0:3),pidq(4),W,WQL,BBYDOT
      INTEGER *4 I,J,K,KMAX,IMAX
c
      w=1.d0  
 
      do j=0,3
         p(1,j)=p1(j)
      enddo
c
      do j=0,3
         p(2,j)=p2(j)
      enddo      
c      
      do j=0,3
         p(3,j)=p3(j)
      enddo      
c
      do j=0,3
         p(4,j)=p4(j)
      enddo 
c 
      do k=1,40
         do i=0,3
            qc(k,i)=0.d0  
         enddo
      enddo 
c
      j=1

      do k=1,40       
         if (q(k,0).ne.0.d0) then
            do i=0,3
               qc(j,i)=q(k,i)
            enddo
            j=j+1       
         endif
      enddo 

      kmax=j-1

      do k=1,kmax
         if (qc(k,0).ne.0.d0) then
            do i=0,3
               qa(i)=qc(k,i)
            enddo 	
            pidq(1)=BBYDOT(p1,qa)
            pidq(2)=BBYDOT(p2,qa)
            pidq(3)=BBYDOT(p3,qa)
            pidq(4)=BBYDOT(p4,qa)
            wql=0.d0
************ warning! think about the factor 4....      
            imax = 4
** ONLY ISR ------ i = 1 and 2!!!!!!

            if (on.eq.0) imax = 2

            do i=1,imax
               wql=wql+4.d0*1.d0/pidq(i)*qa(0)*p(i,0)
            enddo 
            
         endif
      
         w=w*wql/k
      enddo

      BBYWRW=W
             
      END
c
c-----------------------------------------------------------------------
c
       SUBROUTINE BBYBOOST(G,V,P,Q)
c***********************************************************************
c
c   Lorentz boost
c
c***********************************************************************
       IMPLICIT NONE
c       
       REAL *8 G,P(0:3),Q(0:3),PP(0:3),V(0:3),PPDV,BBY3DOT,V2
       INTEGER *4 I
c
       DO I = 0,3
          PP(I) = P(i)
          Q(I)  = P(i)
       END DO
c
       IF (G.GT.1.d0) THEN
c       
         PPDV = BBY3DOT(PP,V)
         V2   = V(1)**2+V(2)**2+V(3)**2
c
         Q(0) = G*(PP(0)-PPDV)
c
         DO I = 1,3
           Q(I) = PP(I)+(G-1.d0)*PPDV/V2*V(I)-G*V(I)*PP(0)
         END DO
c
       END IF
c
       END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYPICK4G(Q,Q1,Q2,Q3,Q4)
c***********************************************************************
c
c  Search for max 4 leading energetic photons
c
c  Input: Q
c
c  Output: Q1,Q2,Q3,Q4,NPH
c
c***********************************************************************
c
      IMPLICIT NONE
c
      REAL *8 Q(40,0:3),Q1(0:3),Q2(0:3),Q3(0:3),Q4(0:3)
      REAL *8 Q0(40)
      INTEGER *4 I,NPH,IQM(40)
c
      DO I = 0,3
        Q1(I) = 0.d0
        Q2(I) = 0.d0
        Q3(I) = 0.d0
        Q4(I) = 0.d0
      END DO
c                                      
      DO I=1,40
        Q0(I)=Q(I,0)
         
        IF(Q(I,0).GT.0.) THEN  ! max index of photons
          NPH=I
        END IF

      END DO
c
      CALL BBYPICNG(Q0,NPH,IQM)
c
      DO I=0,3
        IF(IQM(1).NE.0) Q1(I)=Q(IQM(1),I)
        IF(IQM(2).NE.0) Q2(I)=Q(IQM(2),I)
        IF(IQM(3).NE.0) Q3(I)=Q(IQM(3),I)
        IF(IQM(4).NE.0) Q4(I)=Q(IQM(4),I)
      END DO
c
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYPICNG(Q,NP,IQM)
c***********************************************************************
c      
c  Reordering of array Q(i), i=1 - NP  
c
c  Result: 
c           1)New order Q(1) >= Q(2) >= ...
c           2) IQM = positions of new values in initial array
c 
c***********************************************************************
c
      IMPLICIT NONE
c      
      REAL *8 Q(40),QMAX,QQ(40),Q0(40)
      INTEGER *4 N,I,I1,I2,I3,IM,IQM(40),NP
c      

      DO I=1, NP
        Q0(I)=Q(I)         ! copy initial data
        IQM(I)=0
      END DO

c-----------------------------------------

      DO 1 N=1,NP-1
        I1=N
        QMAX=Q(I1)      
c
        DO I=I1+1,NP      
          IF(Q(I).GT.QMAX) THEN
            QMAX=Q(I)
            IM=I
          END IF                        
        END DO
c
        IF(QMAX.EQ.Q(I1)) GOTO 1
c
        QQ(1)=Q(IM)
c
        I3=1
c
        DO I=I1,NP
          IF(I.NE.IM) THEN     ! new order
            I3=I3+1
            QQ(I3)=Q(I)
          END IF
        END DO
c
        I3=0           
c
        DO I=I1,NP
          I3=I3+1
          Q(I)=QQ(I3)
        END DO                 
c
 1    CONTINUE

c---------------------------------------

      DO 2 I1=1,NP
        DO I2=1,NP
                      
          IF(Q(I1).EQ.Q0(I2).AND.Q0(I2).NE.0.) THEN  ! positions of Q(i) 
                                                     ! in old array
            IQM(I1)=I2
            Q0(I2)=-100.
            GOTO 2
          END IF
                                                                    
        END DO
 2    CONTINUE

      END 
c
c-----------------------------------------------------------------------
c
       FUNCTION BBYDOT(P,Q)
c***********************************************************************
c
c  Scalar product of 4-vectors
c
c***********************************************************************
c
       IMPLICIT NONE
c
       REAL *8 BBYDOT,P(0:3),Q(0:3)       
*
       BBYDOT=P(0)*Q(0)-P(1)*Q(1)-P(2)*Q(2)-P(3)*Q(3)       
*
       END
c
c-----------------------------------------------------------------------
c
       FUNCTION BBY3DOT(P,Q)
c***********************************************************************
c
c   Scalar product of 3-vectors
c
c***********************************************************************       
c
       IMPLICIT NONE
c
       REAL*8 BBY3DOT,P(0:3),Q(0:3)       
*
       BBY3DOT = P(1)*Q(1)+P(2)*Q(2)+P(3)*Q(3)       
*
       END
c
c-----------------------------------------------------------------------
c
      FUNCTION BBYSDIF(S,C)
c***********************************************************************
c
c   Differential cross section
c
c***********************************************************************
      IMPLICIT NONE

      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL*8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH

      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES
                  
      REAL *8 BBYSDIF,S,C,AM(14),GT(14),GE(14),SQED,BET,T,COT,SDT,COS
      REAL *8 SDS,COST,SDST,SDHAD,V,DEN,SDH,SDHS,SDHT,BBYPFFM2,BBYVPOL
      REAL *8 SDIF
      INTEGER *4 J
c
      SAVE AM,GT,GE
c
*
* AM=HADRON MASSES, GT=TOTAL WIDTH, GE=PARTIAL E+E- WIDTH.
*
* 1=RHO, 2=OMEGA, 3=PHI, 4=J/PSI, 5=PSI(2S), 6=PSI(3770), 7=PSI(4040),
* 8=PSI(4160), 9=PSI(4415), 10=Y, 11=Y(2S), 12=Y(4S), 13=Y(10860),
* 14=Y(11020).
*
       DATA AM/0.770D0,0.782D0,1.019413D0,3.09688D0,3.686D0,3.7699D0,
     >         4.040D0,4.159D0,4.415D0,9.46037D0,10.02330D0,10.5800D0,
     >         10.865D0,11.019D0/
       DATA GT/0.1507D0,8.41D-3,4.43D-3,87.D-6,277.D-6,23.6D-3,
     >         52.D-3,78.D-3,43.D-3,52.5D-6,44.D-6,10.D-3,
     >         110.D-3,79.D-3/
       DATA GE/6.77D-6,0.60D-6,1.32457D-6,5.26D-6,2.14D-6,0.26D-6,
     >         0.75D-6,0.77D-6,0.47D-6,1.32D-6,0.520D-6,0.248D-6,
     >         0.31D-6,0.130D-6/
*
* QED DIFFERENTIAL CROSS SECTIONS (WITH OR WITHOUT RUNNING ALPHA):
*
      IF (ICH.EQ.3) THEN 
         SQED = 0.5D0*2.D0*PI*ALPHA**2*
     &        (1.D0+C**2)/(1.D0-C**2)/S
         SDIF = SQED
         GOTO 500
      END IF
*
      IF (ICH.EQ.4) THEN          
         BET  = SQRT(1.D0-4.D0*AMPI**2/S)
         SQED = 2.d0*pi*alpha**2*bet**3*(1-c**2)/8.d0/s
         SQED = SQED*BBYPFFM2(PIQ2)
         SQED = SQED*(BBYVPOL(S))**2
         SDIF = SQED
         GOTO 500
      END IF
*
      T=-(1.D0-C)*S/2.D0
      COT=PI*(ALPHA*BBYVPOL(T))**2/S
      SDT=COT*((1.D0+C)**2+4.D0)/((1.D0-C)**2) 
      COS=PI*(ALPHA*BBYVPOL(S))**2/(2.D0*S)
      SDS=COS*(1.D0+C**2)
      COST=PI*ALPHA**2*BBYVPOL(S)*BBYVPOL(T)/S
      SDST=-COST*(1.D0+C)**2/(1.D0-C)
*
* HADRON-EXCHANGE CONTRIBUTIONS
*
      SDHAD=0.D0
*
      IF (IRES.EQ.1) THEN
c
         DO J=1,14
*
            V=3.D0*GE(J)/AM(J)
            DEN=(S-AM(J)**2)**2+(GT(J)*AM(J))**2
*     
            SDH=PI*V**2*(1.D0+C**2)*S/2.D0/DEN
            SDHS=PI*ALPHA*BBYVPOL(S)*V*
     &           (1.D0+C**2)*(S-AM(J)**2)/DEN
            SDHT=-PI*ALPHA*BBYVPOL(T)*V*
     &           ((1.D0+C)**2/(1-C))*(S-AM(J)**2)/DEN
c     
            IF (ICH.EQ.1) SDHAD=SDHAD+SDH+SDHS+SDHT
c     
            IF (ICH.EQ.2) SDHAD=SDHAD+SDH+SDHS
c     
         END DO    
c
      END IF
c 
c  Differential cross sections SUM 
c
      IF (ICH.EQ.1) SQED = SDS+SDT+SDST
c
      IF (ICH.EQ.2) THEN
         BET=SQRT(1.D0-4.D0*AMMU**2/S)
         SQED=COS*BET*(1.D0+C**2+
     &        4.D0*AMMU**2/S*(1.D0-C**2))
      END IF
c      
      SDIF = SQED+SDHAD
c
 500  BBYSDIF=SDIF
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYPEFR(X,EPS)
c***********************************************************************
c
c   X GENERATION ACCORDING TO AP SPLITTING FUNCTION
c   (1+X^2)/(1-X), 0 <= X <= 1-EPS
c
c***********************************************************************
c
      IMPLICIT NONE
c
      REAL *8 X,EPS,ALNE,AIEPS,CX,OMX,RX,PX
      INTEGER *4 LEN2      
      PARAMETER (LEN2=2)
      REAL*4 RVEC2(LEN2),RLU
c
      ALNE = DLOG(EPS)
      AIEPS =-2.D0*ALNE-1.5D0+2.D0*EPS-0.5D0*EPS**2 
c
 120  RVEC2(1)=RLU(0)
      RVEC2(2)=RLU(0)

c     CALL RANLUX(RVEC2,LEN2)
c
      CX = RVEC2(1)
c
      OMX = DEXP(CX*ALNE)
      X = 1.D0 - OMX
c
      RX = RVEC2(2)*2.D0/OMX
      PX = (1.D0 + X**2)/OMX
      IF (RX.GT.PX) GO TO 120
c
      END
c
c-----------------------------------------------------
c
      SUBROUTINE BBYAPVER(X,EPS,EPSP)
c***********************************************************************
c
c  X GENERATION ACCORDING TO AP(X)/X SPLITTING FUNCTION
c  (1+X^2)/(1-X)/X, EPSP <= X <= 1-EPS
c
c***********************************************************************
      IMPLICIT NONE
c
      REAL *8 X,EPS,EPSP,XP,XM,A,CX,OMEX,RX,PX
      INTEGER *4 LEN2
      PARAMETER (LEN2=2)
      REAL*4 RVEC2(LEN2),RLU
c
      XP=1.D0-EPS
      XM=EPSP
*
      A=DLOG(XP/XM*(1.D0-XM)/(1.D0-XP)) 
c
 120  RVEC2(1)=RLU(0)
      RVEC2(2)=RLU(0)

c     CALL RANLUX(RVEC2,LEN2)
c
      CX = 1.D0*RVEC2(1)
c
      X = XM*EXP(CX*A)/(1.D0+XM*(EXP(CX*A)-1.D0))
      OMEX=1.D0-X
c 
***      IF (OMEX.EQ.0.D0) PRINT*,CX,EXP(CX*A),X,'!!!'
      IF (OMEX.EQ.0.D0) OMEX = 1.D0
      RX = RVEC2(2)*2.D0/OMEX/X
      PX = (1.D0 + X**2)/OMEX/X
      IF (RX.GT.PX) GO TO 120
c
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION BBYPNB(Q2,QP2,EPS)
c***********************************************************************
c
c   No-branching probability (Sudakov form factor)
c
c***********************************************************************
c
      IMPLICIT NONE
c       
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH
      
      REAL *8 Q2,QP2,EPS,AIEPS,PNB,BBYPNB
c
      AIEPS =-2.D0*DLOG(EPS)-1.5D0+2.D0*EPS-0.5D0*EPS**2
      PNB = -ALPHA/2.D0/PI*DLOG(Q2/QP2)*AIEPS
      BBYPNB = DEXP(PNB)
c
      END
c
c----------------------------------------------------------------------
c
      FUNCTION BBYPNOB(Q2,Q2P,EPS,EPSP)
***********************************************************************
c
c   NO-BRANCHING PROBABILITY FOR D(X,S)/X
c
c***********************************************************************
c
      IMPLICIT NONE
c
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH
c                  
      REAL *8 PNOB,Q2,Q2P,EPS,EPSP,BBYPNOB
c
      PNOB=DLOG((1.D0-EPS)/EPSP*((1.D0-EPSP)/EPS)**2)-1.D0+EPS+EPSP
      BBYPNOB=DEXP(-ALPHA/2.D0/PI*DLOG(Q2/Q2P)*PNOB) 
c
      END
c
c-----------------------------------------------------
c
      FUNCTION BBYVPOL(Q2) 
c***********************************************************************
c
c   Vacuum polarization: ALPHA(0)->ALPHA(0)*VPOL(Q2)
c
c***********************************************************************
      IMPLICIT NONE

      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH
 
      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES
                         
      REAL *8 VPOL,Q2,AMASSES(4),SOMMA,BBYSUM,AMODQ2,ST2,QIN,BBYVPOL
      REAL *8 DER,DEG,ERRDER,ERRDEG,DALPHA
      
      REAL*4 QIN4,ST24,DER4,ERRDER4,DEG4,ERRDEG4
      INTEGER *4 I

*
* E,MU,TAU,TOP MASSES: 
*
      DATA AMASSES /0.510999D-3,0.1056584D0,1.777D0,175.6D0/
*
      IF (IARUN.eq.0) THEN
        VPOL = 1.d0
        GOTO 500
      END IF

      SOMMA=0.D0
c
      DO I=1,4
        SOMMA=SOMMA+BBYSUM(AMASSES(I),Q2,I)
      END DO
c
      AMODQ2=DABS(Q2)

      ST2=0.2322
      QIN=DSQRT(AMODQ2)
      QIN=-QIN
      QIN4=QIN
      ST24=ST2
c
      CALL BBYHADR5(QIN4,ST24,DER4,ERRDER4,DEG4,ERRDEG4)
c
      DER=DER4
      DEG=DEG4
      ERRDER=ERRDER4
      ERRDEG=ERRDEG4
      DALPHA=ALPHA/PI*SOMMA+DER
      VPOL=1.D0/(1.D0-DALPHA)
c
 500  BBYVPOL=VPOL
c
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      FUNCTION BBYSUM(AM,Q2,I)
c***********************************************************************
c
c  LEPTONIC AND TOP CONTRIBUTION TO VACUUM POLARIZATION
c
c***********************************************************************
c
      IMPLICIT NONE 
c      
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH
      
      REAL*8 SUMMA,AM,Q2,NC(4),QF2(4),AM2,SQ,ARGLOG,BBYSUM
      INTEGER *4 I,J
*
* NC AND QF ARE COLOR FACTOR (1 FOR LEPTONS, 
* 3 FOR TOP) AND CHARGE
*
      DO J=1,3
        NC(J)=1.D0
        QF2(J)=1.D0
      END DO
c      
      NC(4)=3.D0
      QF2(4)=4.D0/9.D0
*
      AM2=AM**2
c
      IF (Q2.GE.0.D0.AND.Q2.LT.(4.D0*AM2)) THEN
c
       SQ=DSQRT(4.D0*AM2/Q2-1.D0)
c
       SUMMA=NC(I)*QF2(I)*(-5.D0/9.D0-(4.D0/3.D0)*(AM2/Q2)+
     &    (4.D0/3.D0*(AM2/Q2)**2+1.D0/3.D0*AM2/Q2-1.D0/6.D0)*
     &     4.D0/SQ*DATAN(1.D0/SQ))
c
        ELSE
c
       SQ=DSQRT(1.D0-4.D0*AM2/Q2)
       ARGLOG=DABS((1.D0-SQ)/(1.D0+SQ))
c
       SUMMA=NC(I)*QF2(I)*(-5.D0/9.D0-(4.D0/3.D0)*(AM2/Q2)+
     &    (4.D0/3.D0*(AM2/Q2)**2+1.D0/3.D0*AM2/Q2-1.D0/6.D0)*
     &     2.D0/SQ*DLOG(ARGLOG))
c
       END IF
c
       BBYSUM=SUMMA
       
       END
c
c--------------------------------------------------------------------
c 
       SUBROUTINE BBYHADR5(E,ST2,DER,ERRDER,DEG,ERRDEG)
c ******************************************************************
c    
c   Eidelman-Jegerlehner hadronic contribution to alpha_QED
c                                                                  *
c        SUBROUTINE FOR THE EVALUATION OF THE LIGHT HADRON         *
c             CONTRIBUTIONS TO DELTA_R  AND  DELTA_G               *
c                      USING FITS TO THE                           *
c            QED VACUUM POLARIZATION FROM E^+ E^- DATA             *
c                                                                  *
c      F. JEGERLEHNER, PAUL SCHERRER INSTITUTE, CH-5232 VILLIGEN   *
c                                                                  *
c      E-MAIL:JEGERLEHNER@CVAX.PSI.CH                              *
c      PHONE :   +41-56-993662                                     *
c                                                                  *
c      REFERENCE: F. JEGERLEHNER, Z. PHYS. C32 (1986) 195          *
c                 H. BURKHARDT ET AL., Z. PHYS. C42 (1989) 497     *
c                 S. EIDELMAN, F. JEGERLEHNER, Z. PHYS. C (1995)   *
c                                                                  *
c ******************************************************************
c       VERSION: 24/02/1995
C
C  NOTATION: E ENERGY ( MOMENTUM TRANSFER ): E>0 TIMELIKE , E<0 SPACELIKE
C            ST2 IS SIN^2(THETA); ST2=0.2322 IS THE REFERENCE VALUE
C  THE ROUTINE RETURNS THE HADRONIC CONTRIBUTION OF 5 FLAVORS (U,D,S,C,B)
C                 TO   DER=DELTA_R WITH HADRONIC ERROR ERRDER
C                AND   DEG=DELTA_G WITH HADRONIC ERROR ERRDEG
C  THE EFFECTIVE VALUE OF THE FINE STRUCTURE CONSTANT ALPHAQED AT ENERGY
C  E IS ALPHAQED(E)=ALPHAQED(0)/(1-DELTA_R) ,SIMILARLY FOR THE SU(2)
C  COUPLING ALPHASU2(E)=ALPHASU2(0)/(1-DELTA_G), WHERE DELTA_R(G) IS THE
C  SUM OF LEPTONIC, HADRONIC CONTRIBUTIONS (TOP TO BE ADDED).
C
C  THIS PROGRAM DOES NOT YET KNOW HOW TO COMPUTE DELTA R AND DELTA G FOR
C  ENERGIES IN THE RANGES  |E|>1TEV AND 2M_PI < E < 40(13) GEV !!!!!!!!!
C
       IMPLICIT NONE
       INTEGER *2 NF,NS,I,J
       PARAMETER(NF=9,NS=4)
       REAL *4 E,ST2,ST20,DER,DEG,ERRDER,ERRDEG,S,S0,X1,XI,X2,XLOG,XLAR
       REAL *4 M1(NF),C1(NF,NS),C2(NF,NS),C3(NF,NS),C4(NF,NS),AE(NF,NS)
       REAL *4 EU(NF),EO(NF),RES(NS),L1(NF,NS),FX,GX,HX,XX,U,SE
c
       DO I=1,NF
c
         DO J=1,NS
           AE(I,J)=0.0
         ENDDO
c
       ENDDO
c
C #1# DELTA_R
C FIT PARAMETERS SPACELIKE  -1000 TO  -200 GEV
      EU(1)  =-1000.
      EO(1)  = -200.
      M1(1)=  -1000.000
      C1(1,1)=  4.2069394E-02
      C2(1,1)=  2.9253566E-03
      C3(1,1)= -6.7782454E-04
      C4(1,1)=  9.3214130E-06
C   CHI2=  2.5763808E-05
C FIT PARAMETERS SPACELIKE  -200 TO  -20 GEV
      EU(2)  = -200.
      EO(2)  =  -20.
      M1(2)  =  -100.0000
      C1(2,1)=  2.8526291E-02
      C2(2,1)=  2.9520725E-03
      C3(2,1)= -2.7906310E-03
      C4(2,1)=  6.4174528E-05
C   CHI2=  6.6264300E-04
C FIT PARAMETERS SPACELIKE   -20 TO   -2 GEV
      EU(3)  =  -20.
      EO(3)  =   -2.
      M1(3)  =   -20.0000
      L1(3,1)=  9.3055E-3
      C1(3,1)=  2.8668314E-03
      C2(3,1)=  0.3514608
      C3(3,1)=  0.5496359
      C4(3,1)=  1.9892334E-04
C   CHI2=  4.2017717E-03
      AE(3,1)=  3.0
C FIT PARAMETERS SPACELIKE    -2 TO    0.25 GEV
      EU(4)  =   -2.
      EO(4)  =    0.25
      M1(4)  =    -2.0000
      L1(4,1)=  9.3055E-3
      C1(4,1)=  2.2694240E-03
      C2(4,1)=   8.073429
      C3(4,1)=  0.1636393
      C4(4,1)= -3.3545541E-05
C   CHI2=  0.1239052
      AE(4,1)=  2.0
C FIT PARAMETERS TIMELIKE   0.25 TO    2 GEV
      EU(5)  =    0.25
      EO(5)  =    2.
C FIT PARAMETERS TIMELIKE   2    TO   40 GEV
      EU(6)  =    2.
      EO(6)  =   40.
C FIT PARAMETERS TIMELIKE     40 TO   80 GEV
      EU(7)  =   40.
      EO(7)  =   80.
      M1(7)  =   80.00000
      C1(7,1)=  2.7266588E-02
      C2(7,1)=  2.9285045E-03
      C3(7,1)= -4.7720564E-03
      C4(7,1)=  7.7295507E-04
C   CHI2=  7.7148885E-05
C FIT PARAMETERS TIMELIKE     80 TO  250 GEV
      EU(8)  =   80.
      EO(8)  =  250.
      M1(8)  =   91.18880
      C1(8,1)=  2.8039809E-02
      C2(8,1)=  2.9373798E-03
      C3(8,1)= -2.8432352E-03
      C4(8,1)= -5.2537734E-04
C   CHI2=  4.2241514E-05
C FIT PARAMETERS TIMELIKE    250 TO 1000 GEV
      EU(9)  =  250.
      EO(9)  = 1000.
      M1(9)  = 1000.00000
      C1(9,1)=  4.2092260E-02
      C2(9,1)=  2.9233438E-03
      C3(9,1)= -3.2966913E-04
      C4(9,1)=  3.4324117E-07
C   CHI2=  6.0426464E-05
C #2# DELTA_G
C FIT PARAMETERS SPACELIKE  -1000 TO  -200 GEV
C     EU(1)  =-1000.
C     EO(1)  = -200.
C     M1(1)=  -1000.000
      C1(1,2)=  8.6415343E-02
      C2(1,2)=  6.0127582E-03
      C3(1,2)= -6.7379221E-04
      C4(1,2)=  9.0877611E-06
C   CHI2=  9.6284139E-06
C FIT PARAMETERS SPACELIKE  -200 TO  -20 GEV
C     EU(2)  = -200.
C     EO(2)  =  -20.
C     M1(2)  =  -100.0000
      C1(2,2)=  5.8580618E-02
      C2(2,2)=  6.0678599E-03
      C3(2,2)= -2.4153464E-03
      C4(2,2)=  6.1934326E-05
C   CHI2=  6.3297758E-04
C FIT PARAMETERS SPACELIKE   -20 TO   -2 GEV
C     EU(3)  =  -20.
C     EO(3)  =   -2.
C     M1(3)  =   -20.0000
      L1(3,2)=  1.9954E-2
      C1(3,2)=  5.7231588E-03
      C2(3,2)=  0.3588257
      C3(3,2)=  0.5532265
      C4(3,2)=  6.0730567E-04
C   CHI2=  7.9884287E-03
      AE(3,2)=  3.0
C   CHI2=  4.2017717E-03
C FIT PARAMETERS SPACELIKE    -2 TO    0.25 GEV
C     EU(4)  =   -2.
C     EO(4)  =    0.25
C     M1(4)  =    -2.0000
      L1(4,2)=  1.9954E-2
      C1(4,2)=  4.8065037E-03
      C2(4,2)=   8.255167
      C3(4,2)=  0.1599882
      C4(4,2)= -1.8624817E-04
C   CHI2=  0.1900761
      AE(3,2)=  2.0
C FIT PARAMETERS TIMELIKE     40 TO   80 GEV
C     EU(7)  =   40.

C     EO(7)  =   80.
C     M1(7)  =   80.00000
      C1(7,2)=  5.5985276E-02
      C2(7,2)=  6.0203830E-03
      C3(7,2)= -5.0066952E-03
      C4(7,2)=  7.1363564E-04
C   CHI2=  7.6000040E-05
C FIT PARAMETERS TIMELIKE     80 TO  250 GEV
C     EU(8)  =   80.
C     EO(8)  =  250.
C     M1(8)  =   91.18880
      C1(8,2)=  5.7575710E-02
      C2(8,2)=  6.0372148E-03
      C3(8,2)= -3.4556778E-03
      C4(8,2)= -4.9574347E-04
C   CHI2=  3.3244669E-05
C FIT PARAMETERS TIMELIKE    250 TO 1000 GEV
C     EU(9)  =  250.
C     EO(9)  = 1000.
C     M1(9)  = 1000.00000
      C1(9,2)=  8.6462371E-02
      C2(9,2)=  6.0088057E-03
      C3(9,2)= -3.3235471E-04
      C4(9,2)=  5.9021050E-07
C   CHI2=  2.9821187E-05
C #3# ERROR DELTA_R
C FIT PARAMETERS SPACELIKE  -1000 TO  -200 GEV
C     EU(1)  =-1000.
C     EO(1)  = -200.
C     M1(1)=  -1000.000
      C1(1,3)=  6.3289929E-04
      C2(1,3)=  3.3592437E-06
      C3(1,3)=  0.0
      C4(1,3)=  0.0
C   CHI2=  2.3007713E-05
C FIT PARAMETERS SPACELIKE  -200 TO  -20 GEV
C     EU(2)  = -200.
C     EO(2)  =  -20.
C     M1(2)  =  -100.0000
      C1(2,3)=  6.2759849E-04
      C2(2,3)= -1.0816625E-06
      C3(2,3)=   5.050189
      C4(2,3)= -9.6505374E-02
C   CHI2=  3.4677869E-04
      AE(2,3)=  1.0
C FIT PARAMETERS SPACELIKE   -20 TO   -2 GEV
C     EU(3)  =  -20.
C     EO(3)  =   -2.
C     M1(3)  =   -20.0000
      L1(3,3)=  2.0243E-4
      C1(3,3)=  1.0147886E-04
      C2(3,3)=   1.819327
      C3(3,3)= -0.1174904
      C4(3,3)= -1.2404939E-04
C   CHI2=  7.1917898E-03
      AE(3,3)=  3.0
C FIT PARAMETERS SPACELIKE    -2 TO    0.25 GEV
C     EU(4)  =   -2.
C     EO(4)  =    0.25
C     M1(4)  =    -2.0000
      L1(4,3)=  2.0243E-4
      C1(4,3)= -7.1368617E-05
      C2(4,3)=  9.980347E-04
      C3(4,3)=   1.669151
      C4(4,3)=  3.5645600E-05
C   CHI2=  0.1939734
      AE(4,3)=  2.0
C FIT PARAMETERS TIMELIKE     40 TO   80 GEV
C     EU(7)  =   40.
C     EO(7)  =   80.
C     M1(7)  =   80.00000
      C1(7,3)=  6.4947648E-04
      C2(7,3)=  4.9386853E-07
      C3(7,3)=  -55.22332
      C4(7,3)=   26.13011
C   CHI2=  7.2068366E-04
C FIT PARAMETERS TIMELIKE     80 TO  250 GEV
C     EU(8)  =   80.
C     EO(8)  =  250.
C     M1(8)  =   91.18880
      C1(8,3)=  6.4265809E-04
      C2(8,3)= -2.8453374E-07
      C3(8,3)=  -23.38172
      C4(8,3)=  -6.251794
C   CHI2=  1.1478480E-07
C FIT PARAMETERS TIMELIKE    250 TO 1000 GEV
C     EU(9)  =  250.
C     EO(9)  = 1000.
C     M1(9)  = 1000.00000
      C1(9,3)=  6.3369947E-04
      C2(9,3)= -2.0898329E-07
      C3(9,3)=  0.0
      C4(9,3)=  0.0
C   CHI2=  2.9124376E-06
C #4# ERROR DELTA_G
C FIT PARAMETERS SPACELIKE  -1000 TO  -200 GEV
C     EU(1)  =-1000.
C     EO(1)  = -200.
C     M1(1)=  -1000.000
      C1(1,4)=  1.2999176E-03
      C2(1,4)=  7.4505529E-06
      C3(1,4)=  0.0
      C4(1,4)=  0.0
C   CHI2=  2.5312527E-05
C FIT PARAMETERS SPACELIKE  -200 TO  -20 GEV
C     EU(2)  = -200.
C     EO(2)  =  -20.
C     M1(2)  =  -100.0000
      C1(2,4)=  1.2883141E-03
      C2(2,4)= -1.3790827E-06
      C3(2,4)=   8.056159
      C4(2,4)= -0.1536313
C   CHI2=  2.9774895E-04
      AE(2,4)=  1.0
C FIT PARAMETERS SPACELIKE   -20 TO   -2 GEV
C     EU(3)  =  -20.
C     EO(3)  =   -2.
C     M1(3)  =   -20.0000
      L1(3,4)=  4.3408E-4
      C1(3,4)=  2.0489733E-04
      C2(3,4)=   2.065011
      C3(3,4)= -0.6172962
      C4(3,4)= -2.5603661E-04
C   CHI2=  7.5258738E-03
      AE(3,4)=  3.0
C FIT PARAMETERS SPACELIKE    -2 TO    0.25 GEV
C     EU(4)  =   -2.
C     EO(4)  =    0.25
C     M1(4)  =    -2.0000
      L1(4,4)=  4.3408E-4
      C1(4,4)= -1.5095409E-04
      C2(4,4)=  9.9847501E-04
      C3(4,4)=   1.636659
      C4(4,4)=  7.5892596E-05
C   CHI2=  0.1959371
      AE(4,4)=  2.0
C FIT PARAMETERS TIMELIKE     40 TO   80 GEV
C     EU(7)  =   40.
C     EO(7)  =   80.
C     M1(7)  =   80.00000
      C1(7,4)=  1.3335156E-03
      C2(7,4)=  2.2939612E-07
      C3(7,4)=  -246.4966
      C4(7,4)=   114.9956
C   CHI2=  7.2293193E-04
C FIT PARAMETERS TIMELIKE     80 TO  250 GEV
C     EU(8)  =   80.
C     EO(8)  =  250.
C     M1(8)  =   91.18880
      C1(8,4)=  1.3196438E-03
      C2(8,4)=  2.8937683E-09
      C3(8,4)=   5449.778
      C4(8,4)=   930.3875
C   CHI2=  4.2109136E-08
C FIT PARAMETERS TIMELIKE    250 TO 1000 GEV
C     EU(9)  =  250.
C     EO(9)  = 1000.
C     M1(9)  = 1000.00000
      C1(9,4)=  1.3016918E-03
      C2(9,4)= -3.6027674E-07
      C3(9,4)=  0.0
      C4(9,4)=  0.0
C   CHI2=  2.8220852E-06
C ######################################################################
       SE=654./643.      ! RESCALING ERROR TO PUBLISHED VERSION 1995
       ST20=0.2322
       S=E**2
       DER=0.0
       DEG=0.0
       ERRDER=0.0
       ERRDEG=0.0
       IF ((E.GT.1.E3).OR.(E.LT.-1.E3)) GOTO 100
       IF ((E.LT.4.E1).AND.(E.GT.0.25)) GOTO 100
       I=1

       DO WHILE (E.GE.EO(I))
         I=I+1
       ENDDO

       IF (E.EQ.1.E3) I=9
       IF (E.EQ.0.0 ) GOTO 100
       S0=SIGN(1.0,M1(I))*M1(I)**2
       S =SIGN(1.0,E)*E**2
       X1=S0/S
       XI=1.0/X1
       X2=X1**2

       IF (AE(I,1).LE.0.0) THEN

         DO J=1,4
           XLAR=XI+AE(I,J)*EXP(-XI)
           XLOG=LOG(XLAR)
           RES(J)=C1(I,J)
     .           +C2(I,J)*(XLOG+C3(I,J)*(X1-1.0)+C4(I,J)*(X2-1.0))
         ENDDO

       ELSE IF (AE(I,1).EQ.2.0) THEN
         HX     =XI**2

         DO J=1,2
           FX     =1.0-C2(I,J)*S
           GX     = C3(I,J)*S/(C3(I,J)-S)
           XX     =LOG(ABS(FX))+C2(I,J)*GX
           RES(J)=C1(I,J)*XX-L1(I,J)*GX+C4(I,J)*HX
         ENDDO

         DO J=3,4
           U      =ABS(S)
           GX     =-C3(I,J)*U/(C3(I,J)+U)
           XX     =XI**3/(SQRT(ABS(XI))**5+C2(I,J))
           RES(J)=C1(I,J)*XX-L1(I,J)*GX+C4(I,J)*HX
         ENDDO

       ELSE IF (AE(I,1).EQ.3.0) THEN
         HX     =XI

         DO J=1,4
           FX     =1.0-C2(I,J)*S
           GX     = C3(I,J)*S/(C3(I,J)-S)
           XX     =LOG(ABS(FX))+C2(I,J)*GX
           RES(J)=C1(I,J)*XX-L1(I,J)*GX+C4(I,J)*HX
         ENDDO

       ENDIF

       DER=RES(1)
       DEG=RES(2)*ST20/ST2
       ERRDER=RES(3)*SE
       ERRDEG=RES(4)*SE
       GOTO 100
C 99    WRITE(*,*) ' OUT OF RANGE! '
c
 100   RETURN
       END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYCUT(PFINEL,PFINPOS,ICUT)
c**********************************************************************
c
c  CUTUSER implements the experimental selection criteria
c
c  ICUT = 1 --> event accepted
c  ICUT = 0 --> event rejected
c
c**********************************************************************
c
      IMPLICIT NONE
c      
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH
 
      COMMON /BBYFOTONY/ QPH(40,0:3),NPHO,NPHOTEV,ICUTPHOTONS
      REAL *8 QPH
      INTEGER *4 NPHO,NPHOTEV,ICUTPHOTONS
 
      COMMON /BBYMASWI/ PIQ2,ON,ILL,IARUN,IRES
      REAL *8 PIQ2
      INTEGER *4 ON,ILL,IARUN,IRES
                                           
      COMMON /BBYEXPCUTS/   thmin,thmax,emin,zmax,egmin,thgmin,thgmax
      REAL *8 thmin,thmax,emin,zmax,egmin,thgmin,thgmax
      
      REAL *8 PFINEL(0:3),PFINPOS(0:3),EEL,EPOS,PEL,PPOS,CEL,THEL
      REAL *8 CPOS,THPOS,Z
      INTEGER *4 ICUT,I_ALL
c
      ICUT = 1

      EEL  = PFINEL(0)
      EPOS = PFINPOS(0) 

      IF(EEL.LT.EMIN.OR.EPOS.LT.EMIN) ICUT = 0
      
      PEL  = DSQRT(PFINEL(1)**2+PFINEL(2)**2+PFINEL(3)**2)
      PPOS = DSQRT(PFINPOS(1)**2+PFINPOS(2)**2+PFINPOS(3)**2)
c
      CEL  = PFINEL(3)/PEL
      THEL = DACOS(CEL)
c
      CPOS  = PFINPOS(3)/PPOS
      THPOS = DACOS(CPOS)
c
      Z=DABS(PI-THPOS-THEL)    ! acollinearity angle
c
      if (thel.lt.thmin.or.thel.gt.thmax)   icut = 0
      if (thpos.lt.thmin.or.thpos.gt.thmax) icut = 0
      if (z.gt.zmax) icut = 0

      I_ALL = 1
c      
      if (icutphotons.eq.1) CALL BBYCUTPHOTS(I_ALL)

      if (I_ALL.ge.1) I_ALL = 1

      ICUT = ICUT*I_ALL

      END   
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BBYCUTPHOTS(I)
c***********************************************************************
c
c  CUTS_ON_PHOTONS imposes cuts on the generated photons:
c
c   i = 0 ---> no photons lie within the cuts
c   i > 0 ---> i photons lie within the cuts
c
c***********************************************************************
c
      IMPLICIT NONE
c      
      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH

      COMMON /BBYFOTONY/ QPH(40,0:3),NPHO,NPHOTEV,ICUTPHOTONS
      REAL *8 QPH
      INTEGER *4 NPHO,NPHOTEV,ICUTPHOTONS
                        
      COMMON /BBYEXPCUTS/    thmin,thmax,emin,zmax,egmin,thgmin,thgmax
      REAL *8 thmin,thmax,emin,zmax,egmin,thgmin,thgmax
 
      REAL *8 EG,TH
      INTEGER *4 I,K
c      
c  the matrix qph(i,j) has the momenta of the 40 photons (i=1,40)
c
      i = 0
      
      do k = 1,40
         eg = qph(k,0)
         th = 0.d0
         
         if (eg.gt.0.d0) th = Dacos(qph(k,3)/eg)
         
         if ((th.gt.thgmin.and.th.lt.thgmax).and.
     &    (eg.gt.egmin)) i = i+1
      end do

      END
c
c-----------------------------------------------------------------------
c
      FUNCTION BBYPFFM2(Q2)
c***********************************************************************
c
c  |PION FORM FACTOR|^2
c
c***********************************************************************
      IMPLICIT NONE

      COMMON /BBYCONST/ ALPHA,CONVFAC,PI,AME,AMMU,AMPI,ICH
      REAL *8 ALPHA,CONVFAC,PI,AME,AMMU,AMPI
      INTEGER *4 ICH
                          
      REAL *8 MO,GO,MR,GR,MRP,GRP,APFF,BPFF,Q2,A,B,GOQ2,GRQ2,GRPQ2,PFFM2       
      REAL *8 BBYPFFM2
      COMPLEX*16 PFF,BWR,BWRP,BWO,I
      INTEGER *4 IPAR
c      
      SAVE IPAR,I,MO,GO,MR,GR,MRP,GRP,APFF,BPFF 
      SAVE /BBYCONST/
c
      DATA IPAR/0/
c      
      IF (IPAR.eq.0) THEN
c********************************************************************
c
c The parameters of the Pion Form Factor are assigned only if ICH = 4
c The PFF functional form has been taken from PHOKHARA: see
c http://cern.ch/german.rodrigo/phokhara/ and references therein
c
c********************************************************************
        MO = 0.78194d0            ! MO:       omega mass  (GeV)
        GO = 8.43d-3              ! GO:       omega width (GeV)
        MR = 0.7685d0             ! MR:       rho mass    (GeV)
        GR = 0.1507d0             ! GR:       rho width   (GeV)
        MRP = 1.37d0              ! MRP:      rho' mass   (GeV)
        GRP = 0.51d0              ! GRP:      rho' width  (GeV)
        APFF = 1.85d-3            ! APFF:     A parameter
        BPFF= -0.145d0            ! BPFF:     B parameter
        I = (0.d0,1.d0)           ! imaginary unit
        IPAR=1

c        PRINT *,'Pion Form Factor parameters:'

c        PRINT 205,MO,GO
c 205  FORMAT(' Omega mass and width ',F11.5,' GeV ; ',F8.5,' GeV')

c        PRINT 206,MR,GR
c 206  FORMAT(' Rho mass and width ',F13.5,' GeV ; ',F8.5,' GeV')

c        PRINT 207,MRP,GRP
c 207  FORMAT(' Rho-prim mass and width ',F8.5,' GeV ; ',F8.5,' GeV')

c        PRINT 208,APFF,BPFF
c 208  FORMAT(' A and B parameters   ',F11.5,' ; ',F8.5)
c        PRINT *,' '
        
      END IF
c*********************************************************************
c
       A = apff
       B = bpff

       GOQ2 = go

       GRQ2 = gr*mr*mr/q2*(q2-4.d0*ampi*ampi)**(1.5d0)/
     &     (mr*mr-4.d0*ampi*ampi)**(1.5d0)

       GRPQ2 = grp*mrp*mrp/q2*(q2-4.d0*ampi*ampi)**(1.5d0)/
     &     (mrp*mrp-4.d0*ampi*ampi)**(1.5d0)

       BWr   = mr**2/(mr**2-q2-i*sqrt(q2)*grq2)
       BWrp  = mrp**2/(mrp**2-q2-i*sqrt(q2)*grpq2)
       BWo   = mo**2/(mo**2-q2-i*sqrt(q2)*goq2)

       pff   = BWr*(1.d0+a*BWo)/(1.d0+a)+b*BWrp
       pff   = pff/(1.d0+b)

       PFFM2 = pff*conjg(pff)
       BBYPFFM2 =PFFM2
       END
c
c-----------------------------------------------------------------------
c
c      SUBROUTINE BBYFILEV(P,Q,QPH,EVENT)

      SUBROUTINE BBYFILEV(P,Q,EVENT)
c***********************************************************************
c
c  P(0:3) and Q(0:3) are the momenta of the outgoing charged particles,
c  QPH(40,0:3) contains the photons momenta. 
c  QPHOT1 is the momentum of the most energetic photon and 
c  QPHOT2 is the momentum of the next-to-most energetic photon. 
c  EVENT(17) is the array which is then stored.
c
c  If you modify this subroutine, maybe you want also to change the tags
c  which will appear in the HBOOK file: this can be done modifying the
c  subroutine INIT_CHTAGS, which is below....
c
c***********************************************************************
      IMPLICIT NONE
c      
      COMMON /BBYFOTONY/ QPH(40,0:3),NPHO,NPHOTEV,ICUTPHOTONS
      REAL *8 QPH
      INTEGER *4 NPHO,NPHOTEV,ICUTPHOTONS
                  
c      REAL *8 P(0:3),Q(0:3),QPH(40,0:3),QPHOT1(0:3),QPHOT2(0:3)
      REAL *8 P(0:3),Q(0:3),QPHOT1(0:3),QPHOT2(0:3),QPHOT3(0:3)
      REAL *8 QPHOT4(0:3)
      REAL *4 EVENT(25)                  ! Px,Py,Pz,En
      INTEGER *4 I,I1      
c
      CALL BBYPICK4G(QPH,QPHOT1,QPHOT2,QPHOT3,QPHOT4) ! picks out maximum 4 
                                                      ! most energetic photons
      DO I=1,3
        EVENT(I)  = QPHOT1(I)
        EVENT(4+I)= QPHOT2(I)
        EVENT(8+I)= QPHOT3(I)
        EVENT(12+I)= QPHOT4(I)
      END DO
c
      EVENT(4)=QPHOT1(0)
      EVENT(8)=QPHOT2(0)
      EVENT(12)=QPHOT3(0)
      EVENT(16)=QPHOT4(0)
c
      DO I=1,3
        EVENT(16+I) = P(I) 
        EVENT(20+I) = Q(I)
      END DO
c
      EVENT(20)=P(0)
      EVENT(24)=Q(0)

      I1=0
      IF(QPHOT1(0).GT.0.) I1=1
      IF(QPHOT2(0).GT.0.) I1=I1+1 
      IF(QPHOT3(0).GT.0.) I1=I1+1 
      IF(QPHOT4(0).GT.0.) I1=I1+1 
      EVENT(25)=1.*I1
c
      END
