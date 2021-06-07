	subroutine qed(k1,k2,k3)
c**********************************************************************
c
c  Main subr. for generators 201-204 
c
c  Updates: 19.08.2003. /gckine/ -> /kedr_gen/. V.A.Tayursky 
c           15.03.2005.  print modes of of tau+ tau decays 
c
c**********************************************************************
#include "gcflag.inc"
        COMMON /KEDR_GEN/  KHEP,KGEN,GENPAR(20)  ! parameters for generators
	common/qed000/iout
      integer       iout,ifot, iw

      dimension k1(4),k2(4),k3(4)

      double precision dbeam,k1,k2,k3,mass
      double precision dangmin,dangmax,demin,demax,ethr
c
	iout=6
c
	dbeam=GENPAR(1)  ! Beam energy (GeV)    
	ifot=1
	iw=1
c
	mass=1.7771d0    ! tau-lepton mass
c
	if(ievent.eq.1) then
            write (6,1)
c
          if(KGEN.eq.201) then ! e+ e- -> e+ e- (gamma)
            dangmin=GENPAR(2)
            dangmax=GENPAR(3)
            demin=GENPAR(4)
            demax=GENPAR(5)
c
            write (6,2) 
c
	    call qed011(dbeam,dangmin,dangmax,demin,demax)
c
          endif
c
          if(KGEN.eq.202) then ! e+ e- -> mu+ mu- (gamma)
            dangmin=GENPAR(2)
            demin=GENPAR(3)
            demax=GENPAR(4)
c
            write (6,3)
c
            call qed021(dbeam,dangmin,demin,demax,ifot,iw)
c
          endif
c
          if(KGEN.eq.203) then ! e+ e- -> tau+ tau- (gamma)
c
             write (6,4) GENPAR(2),GENPAR(3)
c
            call qed031(dbeam,0.d0,mass,0,0.d0)
c
          endif
c
          if(KGEN.eq.204) then ! e+ e- -> gamma gamma (gamma)
            dangmin=GENPAR(2)
            ethr=GENPAR(3)
c
            write (6,5)
c
            call qed041(dbeam,dangmin,ethr)
c
          endif
c
	  write(6,1)
	endif
c
        if(KGEN.eq.201) call qed012(k1,k2,k3)
c
        if(KGEN.eq.202) call qed022(k1,k2,k3)
c
        if(KGEN.eq.203) call qed032(k1,k2,k3)
c
        if(KGEN.eq.204) call qed042(k1,k2,k3)
c
	do i=1,4
          k1(i)=k1(i)*dbeam
          k2(i)=k2(i)*dbeam
          k3(i)=k3(i)*dbeam
	end do
c
	if(ievent.eq.nevent)then
          write(6,1)
c
	  if(KGEN.eq.201) call qed013
c
	  if(KGEN.eq.202) call qed023
c
          if(KGEN.eq.203) call qed033
c
	  if(KGEN.eq.204) call qed043
c
          write(6,1)
	endif
c
1     format('=================================================')
2     format(/,'     GENERATOR 201: e+ e-  ->  e+ e- (gamma) ',/)
3     format(/,'     GENERATOR 202: e+ e-  ->  mu+ mu- (gamma) ',/)
4     format(/,'     GENERATOR 203: e+ e-  ->  tau+ tau- (gamma) ',//,
     &         '     Decay modes: for tau+ ',F4.0,' for tau- ',F4.0,/)
5     format(/,'     GENERATOR 204: e+ e-  ->  gamma gamma (gamma) ',/)
      return
      end
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE BRSTRT(ENERGY)
C-----------ROUTINES BRSTRT AND QED031 GOT CHANGED 5.JUNE.85
      IMPLICIT DOUBLE PRECISION (A-H,K-Z)
      DIMENSION PH(4)
c
        CALL QED031(ENERGY,0.D0,0.D0,0,0.D0)
c
      RETURN
C
C
      ENTRY BREVNT(PH)
c
      CALL QED032(PH,PH,PH)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION DILOG1(X)
C     *****************
      IMPLICIT REAL*8(A-H,O-Z)
c
CERN      C304      VERSION    29/07/71 DILOG1        59                C
c
      Z=-1.64493406684822
      IF(X .LT.-1.0) GO TO 1
      IF(X .LE. 0.5) GO TO 2
      IF(X .EQ. 1.0) GO TO 3
      IF(X .LE. 2.0) GO TO 4
      Z=3.2898681336964
    1 T=1.0/X
      S=-0.5
      Z=Z-0.5* LOG(ABS(X))**2
      GO TO 5
    2 T=X
      S=0.5
      Z=0.
      GO TO 5
    3 DILOG1=1.64493406684822
      RETURN
    4 T=1.0-X
      S=-0.5
      Z=1.64493406684822 - LOG(X)* LOG(ABS(T))
    5 Y=2.66666666666666 *T+0.66666666666666
      B=      0.00000 00000 00001
      A=Y*B  +0.00000 00000 00004
      B=Y*A-B+0.00000 00000 00011
      A=Y*B-A+0.00000 00000 00037
      B=Y*A-B+0.00000 00000 00121
      A=Y*B-A+0.00000 00000 00398
      B=Y*A-B+0.00000 00000 01312
      A=Y*B-A+0.00000 00000 04342
      B=Y*A-B+0.00000 00000 14437
      A=Y*B-A+0.00000 00000 48274
      B=Y*A-B+0.00000 00001 62421
      A=Y*B-A+0.00000 00005 50291
      B=Y*A-B+0.00000 00018 79117
      A=Y*B-A+0.00000 00064 74338
      B=Y*A-B+0.00000 00225 36705
      A=Y*B-A+0.00000 00793 87055
      B=Y*A-B+0.00000 02835 75385
      A=Y*B-A+0.00000 10299 04264
      B=Y*A-B+0.00000 38163 29463
      A=Y*B-A+0.00001 44963 00557
      B=Y*A-B+0.00005 68178 22718
      A=Y*B-A+0.00023 20021 96094
      B=Y*A-B+0.00100 16274 96164
      A=Y*B-A+0.00468 63619 59447
      B=Y*A-B+0.02487 93229 24228
      A=Y*B-A+0.16607 30329 27855
      A=Y*A-B+1.93506 43008 6996
      DILOG1=S*T*(A-B)+Z
      RETURN
C=======================================================================
C===================END OF CPC PART ====================================
C=======================================================================
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE EVGENH(FUNCTN,X00,X11,ANSWER)
c
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      REAL RANP
      EXTERNAL RANP
      DOUBLE PRECISION FUNCTN
      EXTERNAL FUNCTN
c
      DATA EPS1/1.D-6/
      DATA EPS2/1.D-4/
c
      F(X)=SGNN*FUNCTN(X)
c
      SGNN=+1.D0
      X0=DMIN1(X00,X11)
      X1=DMAX1(X00,X11)
      DIFF=1.D00
      EPS=EPS1
      DEL0=DABS(X1-X0)*1.D-6
      DEL1=0.1*DEL0
      F0=F(X0)
      Y0=X0
      F1=F(X1)
      Y1=X1
      IF(F0 .LE. F1)GOTO 10021
      F0=-F0
      F1=-F1
      SGNN=-1.D0
10021 CONTINUE
      DEL000=F1-F0
      VAL=DEL000*RANP(0)+F0
      J=0
10030 M=1
      GOTO 10033
10031 M=M+1
10033 IF((M).GT.(6))GOTO 10032
      JJ=J
c
10040 DO 10041 I=1,6
      AAA0=ANSWER
      ANSWER=0.5D0*(Y1+Y0)
      FM=F(ANSWER)
      IF(FM.EQ.VAL) GOTO 10050
      IF(FM .GE. VAL)GOTO 10071
      Y0=ANSWER
      F0=FM
      GOTO 10081
10071 CONTINUE
      Y1=ANSWER
      F1=FM
10081 CONTINUE
10061 CONTINUE
10041 CONTINUE
c
10042 CONTINUE
      DIFF=ANSWER-AAA0
      ANSWER=0.5D0*(Y1+Y0)
10090 J=JJ+1
      GOTO 10093
10091 J=J+1
10093 IF((J).GT.(7))GOTO 10092
      FM=F(ANSWER)
      ERROLD=ERROR
      ERROR=DABS(VAL-FM)/DEL000
      IF (ERROR.LE.EPS) GOTO 10050
      IF(ERROR.GT.ERROLD.AND.J.GT.3)GOTO 10092
      DELTA=DMIN1(DEL0,DABS(DIFF))
      ANO=ANSWER
      ANN=ANO+DELTA
      IF(ANN .LE. X1)GOTO 10111
      EPS=EPS2
      DELTA=0.5*DELTA
      ANN=X1
      FM=F(ANN-DELTA)
10111 CONTINUE
      FM1=(F(ANN)-FM)/DELTA
      IF(FM1 .NE. 0.D0)GOTO 10131
      ANSWER=ANO
      GOTO 10092
10131 CONTINUE
      DIFF=(FM-VAL)/FM1
      ANSWER=ANO-DIFF
      IF((ANSWER .GE. Y0) .AND. (ANSWER .LE. Y1))GOTO 10151
      ANSWER=ANO
      GOTO 10092
10151 CONTINUE
      IF (DABS(DIFF).LT.DEL1) GOTO 10050
      GOTO 10091
10092 CONTINUE
      GOTO 10031
10032 CONTINUE
10050 CONTINUE
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION EXACT(K,Z,X,C,X1,C1)
c
C...CALCULATES EXACT CROSSECTION FOR THREE GAMMA PRODUCTION
c
      IMPLICIT DOUBLE PRECISION(A-Z)
C   DUMMY added by PA to make COMMON right length 6-11-85
      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
C...CONSTRUCT SIX DOT PRODUCTS
c
      K11=K*(E-Z)
      K12=K*(E+Z)
      K21=X*(E-C)
      K22=X*(E+C)
      K31=X1*(E-C1)
      K32=X1*(E+C1)
C...CROSSECTION
C      EXACT=-2.D0*M**2*((K22/K32+K32/K22)/K11**2
C     Z               +(K21/K31+K31/K21)/K12**2
C     Z               +(K12/K32+K32/K12)/K21**2
C     Z               +(K11/K31+K31/K11)/K22**2
C     Z               +(K12/K22+K22/K12)/K31**2
C     Z               +(K11/K21+K21/K11)/K32**2)
C     Z   +4.D0*E**2/K11/K12/K21/K22/K31/K32
C     Z            *(  K11*K12*(K11**2+K12**2)
C     Z               +K21*K22*(K21**2+K22**2)
C     Z               +K31*K32*(K31**2+K32**2) )
C
C The full expression gives the mips compiler fits (if -g is specified),
C so break it into byte-sized pieces.
C     -dsr, 9/18/91
C
      T1 =      (K22/K32+K32/K22)/K11**2
      T1 = T1 + (K21/K31+K31/K21)/K12**2
      T1 = T1 + (K12/K32+K32/K12)/K21**2
      T1 = T1 + (K11/K31+K31/K11)/K22**2
      T1 = T1 + (K12/K22+K22/K12)/K31**2
      T1 = T1 + (K11/K21+K21/K11)/K32**2
      T2 =      K11*K12*(K11**2+K12**2)
      T2 = T2 + K21*K22*(K21**2+K22**2)
      T2 = T2 + K31*K32*(K31**2+K32**2)
      EXACT = -2.D0*M**2*T1 + 4.D0*E**2/K11/K12/K21/K22/K31/K32*T2
C...NORMALIZATION AND RETURN
      EXACT=ALFA**3/8.D0/PI2/S*EXACT
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION GENCOS(X)
c
C...THIS ROUTINE GENERATES THE COSINE COS(X) OF AN ANGLE
C...WITH A DISTRIBUTION PROPORTIONAL TO
C...             1/(1-COS(X)+M**2/2)
C...THIS CAN BE USED FOR GENERATING C THE LOWEST ORDER CROSSECTION
C...BEFORE TESTING , AS WELL AS FOR GENERATING Z
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
      REAL RANP
      EXTERNAL RANP
c
      SSS=RANP(0)
      IF(SSS.GT.0.5) GOTO 1
         GENCOS=E-DL*DEXP(-LE*SSS)
      GOTO 2
1        SSS=1.-SSS
         GENCOS=E-MU*DEXP(+LE*SSS)
2     RETURN
      END
c
c-=---------------------------------------------------------------------
c
      DOUBLE PRECISION FUNCTION PIHINT(S)
c
C...HADRONIC VACUUM POLARIZATION BY LOGARITHMIC INTERPOLATION
C...THIS IS A GOOD APPROXIMATION FAR FROM RESONANCES
C...THE VALUES OF SS ARE CHOSEN TO BE LOGARITHMICALLY
C...DISTRIBUTED ; THE VALUES OF REPIH ARE CALCULATED
C...USING PIH (GAUSSIAN INTEGRATION + ANALYTIC CONTRIBUTIONS OF RES.)
c
      IMPLICIT DOUBLE PRECISION (A-H,K,O-Z)
      DIMENSION SS(20),REPIH(20)
c
      DATA SS/ 0.100D-01,0.196D-01,0.384D-01,0.753D-01,
     *   0.148D+00,0.289D+00,0.567D+00,0.111D+01,
     *   0.218D+01,0.427D+01,0.837D+01,0.164D+02,
     *   0.321D+02,0.630D+02,0.123D+03,0.242D+03,
     *   0.474D+03,0.930D+03,0.182D+04,0.357D+04/
      DATA REPIH/ -0.101D-03,-0.194D-03,-0.367D-03,-0.673D-03,
     *   -0.118D-02,-0.195D-02,-0.299D-02,-0.425D-02,
     *   -0.569D-02,-0.728D-02,-0.905D-02,-0.110D-01,
     *   -0.131D-01,-0.153D-01,-0.175D-01,-0.198D-01,
     *   -0.221D-01,-0.245D-01,-0.268D-01,-0.292D-01/
      DATA DELTA/0.672944D0/
c
      COMMON/QED000/IOUT
c
      IF((S.GT.(0.04D0)).AND.(S.LT.(120.D0))) WRITE (IOUT,5) S
    5 FORMAT(/,10X,'S =',F7.3,' GEV**2;',/,
     Z 10X,'FOR THIS VALUE PIH MAY BE BADLY APPROXIMATED DUE',/,
     Z 10X,'TO THE PRESENCE OF MANY RESONANCES UNDER W=10 GEV')
    6 S=DABS(S)
      IF(S.LE.SS(1)) GO TO 3
c
      DO 1 J=2,20
      J2=J
    1 IF(S.LE.SS(J)) GO TO 2
c
    2 PIHINT=REPIH(J2-1)
     Z     +(REPIH(J2)-REPIH(J2-1))*DLOG(S/SS(J2-1))/DELTA
      RETURN
    3 PIHINT=0.D0
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION PROXIM(K,Z,X,C,X1,C1)
C --------------------------------------------------------------------------
C...CALCULATES ONE-SIXTH OF THE APPROXIMANT BY CHOOSING A DEFINITE
C...LABELING OF THE THREE PHOTONS ; ONE OF THEM REMAINS DUMMY (3RD)
C...THE TRIAL EVENTS ARE GENERATED WITH VARIABLES K AND X , WHICH
C...GIVE RISE TO A PHASE SPACE FACTOR  X**2*K/2/(1-K); TO
C...MAKE THE PHASE SPACE SYMMETRIC UNDER ANY PERMUTATION AS IN THE
C...EXACT EXPRESSION , WE HAVE TO DIVIDE BY THIS FACTOR.
C --------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
c
      KM=E-K
      CP=E+C
      CM=E-C
      ZP=E+Z
      ZM=E-Z
      YP=2.D0*E-K*(1.D0-C)
      YM=2.D0*E-K*(1.D0+C)
C...APPROXIMANT
      PROXIM=4.D0/CM/ZM*(KM/K/CP+1.D0/YP)+4.D0/CP/ZP*(KM/K/CM+1.D0/YM)
      PROXIM=ALFA**3/8.D0/PI2/S*PROXIM
C...PHASE SPACE RENORMALIZATION
      PROXIM=PROXIM*2.D0*(E-K)/K/X**2
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED011(ARG1,ARG2,ARG3,ARG4,ARG5)
c
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      COMMON/QED000/IOUT
      COMMON / BAPARM / SIG0,SIGS,SIGH,SIGT,WT(20)
     *                 ,YSOFT,K0,KRAT,DMIN,DMAX,XLCMIN,XM2,TWOPI
     *                 ,EM2,CMIN,CMAX,WMAX,ZSOFT,EBEAM
     *                 ,SIGSW,WTWT(2)
c
      EBEAM=ARG1
      THMIN=ARG2
      THMAX=ARG3
      KMIN=ARG4
      KMAX=ARG5
      WMAX=2.D0
c
      DO I=1,20
        WT(I)=0.D0
      END DO
c
      WT(13)=WMAX
      WT(17)=WMAX
      WTWT(1)=0.D0
      WTWT(2)=0.D0
      XM2=(0.5110034D-03/EBEAM)**2
      EM2=1.D0+.5D0*XM2
      XL2=DLOG(2.D0/XM2)
      TWOPI=4.D0*DASIN(1.D0)            !6. 2831 8530 7179 586D0
      CMIN=DCOS(THMAX*TWOPI/360.D0)
      CMAX=DCOS(THMIN*TWOPI/360.D0)
      DMIN=0.5D0/DSIN(THMAX*TWOPI/720.D0)**2    !1./(1.-CMIN)
      DMAX=0.5D0/DSIN(THMIN*TWOPI/720.D0)**2    !1./(1.-CMAX)
      XLCMIN=XL2-DLOG(DMIN)                     !XL2+DLOG(1.-CMIN)
      XLCMAX=XL2-DLOG(DMAX)                     !XL2+DLOG(1.-CMAX)
      SIG0=8.1427d0/EBEAM**2*(
     . 16.*(DMAX-DMIN) + 16.d0*DLOG(DMIN/DMAX) + 9.d0*(CMAX-CMIN)
     . + (CMAX**2-CMIN**2) + 1.d0/3.d0*(CMAX**3-CMIN**3)         )
      K0=0.01D0
      GOTO 1234
c
      ENTRY QED014(ARG1,ARG2)
c
      K0=ARG1
      KMAX=ARG2
C
 1234 K1=DMAX1(K0,KMIN)
      KRAT=KMAX/K1
      SIGH=1.2105d0/EBEAM**2*DLOG(KRAT)*
     . ((1.D0+XLCMAX)*DMAX - (1.D0+XLCMIN)*DMIN )
      SIGS=0.d0
      SIGSW=0.d0
      SIGT=SIGH
      YSOFT=0.d0
      ZSOFT=0.d0
      IF(KMIN.GE.K0) GOTO 411
C
      NINTGR=1000
c
      DO I=1,NINTGR
        R=(I-0.5D0)/DFLOAT(NINTGR)
        OMC=1.D0/(R*DMAX+(1.D0-R)*DMIN)
        C=1.D0-OMC
c
        CALL VIRSOF(EBEAM,K1,OMC,BORN,CORR,CORR3)
c
        DSIGSS=BORN*(1.D0+CORR)*OMC**2
        SIGS=SIGS+DSIGSS
        SIGSW=SIGSW+DSIGSS*CORR3/(1.D0+CORR)
      END DO
c
      DSIGSS=TWOPI*(DMAX-DMIN)/DFLOAT(NINTGR)
      SIGS=SIGS*DSIGSS
      SIGSW=SIGSW*DSIGSS
c
C--SIGS=2*PI*INTGRL(VIRSOF/(1-C)**2)
c
      SIGT=SIGS+SIGH
      YSOFT=SIGS/SIGT
      ZSOFT=(DMAX-DMIN)/SIGS*TWOPI
C
  411 SIGS=SIGS/SIG0
      SIGSW=SIGSW/SIG0
      SIGH=SIGH/SIG0
      SIGT=SIGT/SIG0
      WRITE(IOUT,5) EBEAM,THMIN,THMAX,K1,KMAX,SIG0,SIGS,SIGSW,SIGH,SIGT
c
    5 FORMAT(/,70(1H-),/,
     . 37H INITIALIZATION FOR BHABHA SCATTERING,/,
     . 37H                          BEAM ENERGY ,F15.6,4H GEV,/,
     . 37H             MINIMUM SCATTERING ANGLE ,F15.6,8H DEGREES,/,
     . 37H             MAXIMUM SCATTERING ANGLE ,F15.6,8H DEGREES,/,
     . 37H   MINIMUM HARD BREMSSTRAHLUNG ENERGY ,F15.6,/,
     . 37H   MAXIMUM HARD BREMSSTRAHLUNG ENERGY ,F15.6,/,
     . 37H           LOWEST ORDER CROSS SECTION ,F20.8,3H NB,/,
     . 37H   APPROX. CROSS SECTION IN SOFT PART ,F15.6,/,
     . 37H   APPROX. Z0-INTERFERENCE CONTRIBUTN ,F15.6,/,
     . 37H   APPROX. CROSS SECTION IN HARD PART ,F15.6,/,
     . 37H          APPROX. CROSS SECTION TOTAL ,F15.6,//)
      K0=K1
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED012(QP,QM,QK)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      REAL RANP
      EXTERNAL RANP
      DIMENSION QP(4),QM(4),QK(4)
      COMMON / BAPARM / SIG0,SIGS,SIGH,SIGT,WT(20)
     *                 ,YSOFT,K0,KRAT,DMIN,DMAX,XLCMIN,XM2,TWOPI
     *                 ,EM2,CMIN,CMAX,WMAX,ZSOFT,EBEAM
     *                 ,SIGSW,WTWT(2)
c
      DATA NERR/10/
c
C-------------------------------------------- CHOOSE HARD OR SOFT -----
c
    6 IF(RANP(0).GT.YSOFT) GOTO 11
c
C-------------------------------------------- SOFT PHOTON PART --------
      WT(7)=WT(7)+1.D0
c
C-------------------------------------------- GENERATE C VALUE --------
c
      OMC=1.D0/(DMIN+RANP(0)*(DMAX-DMIN))
      C=1.D0-OMC
c
C-------------------------------------------- CALCULATE WEIGHT --------
c
      CALL VIRSOF(EBEAM,K0,OMC,BORN,CORR,CORR3)
c
      W=BORN*(1.D0+CORR)*OMC**2*ZSOFT
      WZ0=W*CORR3/(1.D0+CORR)
      WT(8)=WT(8)+W
      WT(9)=WT(9)+W*W
      WTWT(1)=WTWT(1)+WZ0
      WTWT(2)=WTWT(2)+WZ0*WZ0
      IF(W.LT.0.D0)   WT(15)=WT(15)+1.D0
      IF(W.GT.WMAX)   WT(16)=WT(16)+1.D0
      IF(W.LT.WT(17)) WT(17)=W
      IF(W.GT.WT(18)) WT(18)=W
c
C-------------------------------------------- REJECT W VALUES ---------
c
      IF(W.LE.WMAX) GOTO 313
      IF(NERR.LE.0) GOTO 313
      NERR=NERR-1
      IF(NERR.NE.0) GOTO 313
313   IF(W.LT.WMAX*RANP(0)) GOTO 6
      WT(10)=WT(10)+1.D0
c
C-------------------------------------------- CONSTRUCT MOMENTA -------
c
      SC=DSQRT(OMC*(2.D0-OMC))
      K=0.D0
      X=1.D0
      QK1=0.d0
      QK2=0.d0
      QK3=0.d0
      GOTO 311
c
C-------------------------------------------- HARD PHOTON PART --------
c 
   11 WT(1)=WT(1)+1.D0
C-------------------------------------------- GENERATE K VALUE --------
C      DN/DK === 1/K
      K=K0*KRAT**RANP(0)
c
C-------------------------------------------- GENERATE C VALUE --------
C      DN/DC === (1-C)**-2 * FF(1-C)/FF(1-CMIN) WITH FF(X)=LN(2*X/ME**2)
c
    7 OMC=1.D0/(DMIN+RANP(0)*(DMAX-DMIN))
      WT(2)=WT(2)+1.D0
      REJFUN=DLOG(2.D0*OMC/XM2)/XLCMIN
      IF(RANP(0).GT.REJFUN) GOTO 7
      C=1.D0-OMC
      SC=DSQRT(OMC*(2.D0-OMC))
c
C-------------------------------------------- GENERATE U VALUE --------
C      DN/DU === (1+D-U)**-1 + (U+D)**-1
      CM=2.D0*OMC
      D=XM2/CM
      R=-1.D0+2.D0*RANP(0)
      V=(1.D0+1.D0/D)**DABS(R)
      U=D*(V-1.D0)
      OMU=1.D0-U
      IF(R.GE.0.D0) OMU=U
      IF(R.GE.0.D0) U=1.D0-OMU
      E2=U*OMU*CM
      EV=DSQRT(1.D0-E2)
      E2=XM2+E2
c
C-------------------------------------------- GENERATE C1 VALUE -------
c
      R=RANP(0)
      VC=2.D0*E2*(1.D0-R)/(E2+2.D0*EV*(EM2+EV)*R)
      C1=1.D0-VC
      SC1=DSQRT(VC*(2.D0-VC))
c
C-------------------------------------------- GENERATE F1 VALUE -------
c
      F1=TWOPI*RANP(0)
      CF1=DCOS(F1)
      SF1=DSIN(F1)
c
C-------------------------------------------- CONSTRUCT QK DIRECTION --
c
      UC=-OMU-U*C
      QK1=(UC*SC1*CF1-U*SC*C1)/EV
      QK2=SC1*SF1
      QK3=(U*SC*SC1*CF1+UC*C1)/EV
      CG=C*QK3+SC*QK1
c
C-------------------------------------------- REJECT CT VALUES --------
c
      KM=1.D0-K
      OMX=K*(1.+CG)/(2.-K+K*CG)
      OMXT=K-OMX
      X=1.-OMX
      XT=1.-OMXT
c
CCC      CT=(X*C+K*QK3)/XT
c
      OMCT=(2.*OMX+X*OMC-K*(1.+QK3))/XT
      CT=1.-OMCT
      IF(CT.LT.CMIN.OR.CT.GT.CMAX) GOTO 6
      WT(3)=WT(3)+1.D0
c
C-------------------------------------------- CALCULATE WEIGHT --------
c
      S =4.D0
      S1=4.D0*KM
      T =-2.D0*X *OMC
      T1=-2.D0*XT*OMCT
      U =-2.D0*XT*(1.D0+CT)
      U1=-2.D0*X *(1.D0+C )
      X1=K*(EM2-QK3)
      X2=K*(EM2+QK3)
      DY=.5D0*XM2*K/KM
      Y1=2.D0*OMXT+DY
      Y2=2.D0*OMX +DY
      W=(S*S1*(S*S+S1*S1)+T*T1*(T*T+T1*T1)+U*U1*(U*U+U1*U1))
     .  /(4.*S*S*S*S1)
     .  *(1.D0-(S*Y1*Y2+S1*X1*X2+U*X2*Y1+U1*X1*Y2)
     .         /(T*X2*Y2+T1*X1*Y1))
     .  *(1.D0-XM2*K/(1.D0+KM*KM)
     .        *(KM/X1+KM/X2+1.D0/Y1+1.D0/Y2))
      WT(4)=WT(4)+W
      WT(5)=WT(5)+W*W
      IF(W.LT.0.D0)   WT(11)=WT(11)+1.D0
      IF(W.GT.WMAX)   WT(12)=WT(12)+1.D0
      IF(W.LT.WT(13)) WT(13)=W
      IF(W.GT.WT(14)) WT(14)=W
c
C-------------------------------------------- REJECT W VALUES ---------
c
      IF(W.LE.WMAX) GOTO 312
      IF(NERR.LE.0) GOTO 312
      NERR=NERR-1
      IF(NERR.NE.0) GOTO 312
  312 R=WMAX*RANP(0)/W
      IF(R.GT.1.d0) GOTO 6
      WT(6)=WT(6)+1.D0
c
C-------------------------------------------- CONSTRUCT MOMENTA -------
c
  311 FI=RANP(0)*TWOPI
      CFI=DCOS(FI)
      SFI=DSIN(FI)
      QK(4)=K
      QK(3)=K*QK3
      QK(2)=K*(QK2*CFI-QK1*SFI)
      QK(1)=K*(QK2*SFI+QK1*CFI)
      QP(4)=X
      QP(3)=X*C
      QP(2)=-X*SC*SFI
      QP(1)=X*SC*CFI
      QM(1)=-QP(1)-QK(1)
      QM(2)=-QP(2)-QK(2)
      QM(3)=-QP(3)-QK(3)
      QM(4)=2.D0-K-X
c
C-------------------------------------------- REFLECTION POINT --------
c
      REFLCT=RANP(0)
      IF(REFLCT.LT.0.5D0) GOTO 10
c
      DO I=1,3
        QK(I)=-QK(I)
        QPI=QP(I)
        QP(I)=-QM(I)
        QM(I)=-QPI
      END DO
c
      QPI=QP(4)
      QP(4)=QM(4)
      QM(4)=QPI
   10 CONTINUE
c
      WT(19)=WT(19)+1.D0
      WT(20)=WT(20)+1.D0
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED013
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)

      COMMON /QED000/ IOUT
      COMMON /BAPARM/ SIG0,SIGS,SIGH,SIGT,WT(20)
     *                 ,YSOFT,XK0,XKRAT,DMIN,DMAX,XLCMIN,XM2,TWOPI
     *                 ,EM2,CMIN,CMAX,WMAX,ZSOFT,EBEAMM
     *                 ,SIGSW,WTWT(2)
c
      WRITE (IOUT,'(/,A37,F15.6,A10)')
     *  '           LOWEST ORDER CROSS SECTION',SIG0,' NB = UNIT'
C
      IF(WT(1).EQ.0.D0) GOTO 1
      SIGHE=SIGH*WT(4)/WT(1)
      DSIGHE=SIGH/WT(1)*DSQRT(WT(5)-WT(4)**2/WT(1))
      SIGHM=SIGH*WMAX*WT(6)/WT(1)
      EC=WT(1)/WT(2)
      ECT=WT(3)/WT(1)
      EWH=WT(6)/WT(3)
      WRITE(IOUT,611) SIGH,SIGHE,DSIGHE,SIGHM,WT(1),WT(6),EC,ECT,EWH
  611 FORMAT(
     . 37H    APPROXIMATED HARD PHOTON XSECTION ,F15.6,/,
     . 37H           EXACT HARD PHOTON XSECTION ,F15.6,' +- ',F15.6,/,
     . 37H           M.C.  HARD PHOTON XSECTION ,F15.6,2F10.0,//,
     . 37H  W.R.P EFFICIENCY IN INTERNAL C LOOP ,F15.6,/,
     . 37H    "      "      OF C/CT RESTRICTION ,F15.6,/,
     . 37H    "      "         FOR HARD WEIGHTS ,F15.6,//)
C
    1 IF(WT(7).EQ.0.D0) GOTO 2
      SIGSE=SIGS*WT(8)/WT(7)
      DSIGSE=SIGS/WT(7)*DSQRT(WT(9)-WT(8)**2/WT(7))
      SIGSM=SIGS*WMAX*WT(10)/WT(7)
      EWS=WT(10)/WT(7)
      WRITE (IOUT,612) SIGS,SIGSE,DSIGSE,SIGSM,WT(7),WT(10),EWS
  612 FORMAT(
     . 37H    APPROXIMATED SOFT PHOTON XSECTION ,F15.6,/,
     . 37H           EXACT SOFT PHOTON XSECTION ,F15.6,' +- ',F15.6,/,
     . 37H           M.C.  SOFT PHOTON XSECTION ,F15.6,2F10.0,//,
     . 37H   W.R.P. EFFICIENCY FOR SOFT WEIGHTS ,F15.6,//)
C
    2 continue
      etr = wt(20) / wt(19)
      WRITE (IOUT,619) etr
  619 FORMAT(
     . 37H   W.R.P. EFFICIENCY   OF TRIGMC CUTS ,F15.6,//)
C
chm   DTE =SIGHE+SIGSE
chm   DDTE=DSIGHE+DSIGSE
      DTE =(SIGHE+SIGSE)*etr
      DDTE=(DSIGHE+DSIGSE)*etr
      WTA=WT(1)+WT(7)
chm   WTB=WT(6)+WT(10)
      WTB=wt(20)
      DTM=SIGT*WMAX*WTB/WTA
      WRITE(IOUT,613) SIGT,DTE,DDTE,DTM,WTA,WTB
  613 FORMAT(
     . 37H     APPROXIMATED TOTAL CROSS SECTION ,F15.6,/,
     . 37H            EXACT TOTAL CROSS SECTION ,F15.6,' +- ',F15.6,/,
     . 37H            M.C.  TOTAL CROSS SECTION ,F15.6,2F10.0,//)

      WRITE(IOUT,615) DTE*sig0,DDTE*sig0
  615 FORMAT(
     . 37H            EXACT TOTAL CROSS SECTION ,F15.6,' NB +- ',
     .                                           F15.6,' NB ',//)
C
      WRITE (IOUT,614) (WT(J),J=11,18)
c
  614 FORMAT(' GENERATED WEIGHTS:',/,
     *6X,'    < 0 IN HARD PART',F20.6,/,
     *6X,' > WMAX IN HARD PART',F20.6,/,
     *6X,'MINIMUM IN HARD PART',F20.6,/,
     *6X,'MAXIMUM IN HARD PART',F20.6,/,
     *6X,'    < 0 IN SOFT PART',F20.6,/,
     *6X,' > WMAX IN SOFT PART',F20.6,/,
     *6X,'MINIMUM IN SOFT PART',F20.6,/,
     *6X,'MAXIMUM IN SOFT PART',F20.6,//)

      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED021(ARG1,ARG2,ARG3,ARG4,IARG5,IARG6)
c
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      COMMON / TRY / RHO,TES,ITRY,IEV,ISYM
      COMMON/QED000/IOUT
      LOGICAL LWK
c
      ENER=ARG1
      AMIN=ARG2
      KMIN=ARG3
      KMAX=ARG4
c
CLSFOT=IARG5.NE.0
      CALL QED027(IARG5)
      LWK  =IARG6.NE.0
c
C...NATURAL CONSTANTS
      BARN=(1.9732858D0)**2*(1.D+05)
c
C     THIS IS A CONVERSION FROM GEV**-2 TO NANOBARN
      PI=3.1415927D0
      AE=0.5110034D-03
      AM=105.65948D-03
      AT=1777.1D-03
      ALFA=1.D0/137.035982D0
      PI2=PI*PI
c
C...CALCULATE ENERGY-DEPENDENT CONSTANTS
c
      S=4.D0*ENER**2
      AE=AE/ENER
      AM=AM/ENER
      AT=AT/ENER
      ALE=2.D0*DLOG(2.D0/AE)
      ALM=2.D0*DLOG(2.D0/AM)
      ALL=ALE+ALM
      E=DSQRT(1.D0+AE*AE)
c
C...RESTRICTIONS ON PHASE SPACE
C     AMIN=5.D0
C     THIS IS THE SMALLEST ANGLE BETWEEN E+ AND MU+TO BE GENERATED
C     WHEN THIS BECOMES TOO SMALL,NEGATIVE CROSSECTIONS WILL RESULT
C     IF IT BECOMES TOO LARGE,FUNCTION Y2K IS NO LONGER CORRECT
c
      CMAX=DCOS(AMIN*PI/180.D0)
c
C...REPRODUCE INPUT
c
      WRITE (IOUT,1) ENER,AMIN,KMIN,KMAX
    1 FORMAT(/,20X,'BEAM ENERGY ',F10.4,' GEV',
     Z       /,20X,'ANGLE CUT AT',F10.4,' DEGREES',
     Z       /,20X,'K MIN       ',F10.7,
     Z       /,20X,'K MAX       ',F10.7)
c
C...LOWEST ORDER CROSSECTION AND ORDER OF MAGNITUDE FOR BREMSSTRAHLUNG
C     THE LOWEST ORDER IS ALSO RESTRICTED WITHIN AMIN AND 180-AMIN
c
      SIG1=2.D0*CMAX*(1.D0+CMAX**2/3.D0)
      SIG0=BARN*ALFA**2/4.D0/S*2.D0*PI*SIG1
      SIG00=SIG0*(8./3./SIG1)
c
C...SIG00 IS THE ZERORDER #SECT. WITHOUT ANGLE LIMITS
C...VERTEX CORRECTIONS AND VACUUM POLARIZATION OF ELECTRON AND MUON
c
      FAKTOR=2.D0*ALFA/PI
      BETA=FAKTOR*(ALL-2.D0)
      DELE=FAKTOR*(0.333D0*ALE-5.D0/9.D0)
      DELM=FAKTOR*(0.333D0*ALM-5.D0/9.D0)
      DELV=FAKTOR*(0.75D0*(ALE+ALM)+PI2/3.D0-2.D0)
      DAR=DELE+DELM+DELV
c
C...VACUUM POLARIZATION OF TAU
      A2=1.D0-AT**2
      A=DSQRT(A2)
      DELT=8.D0/9.D0-A2/3.D0+A*(1.D0-A2/3.D0)*DLOG(AT/(1.D0+A))
      DELT=-FAKTOR*DELT
c
C...HADRONIC VACUUM POLARIZATION
      DELH=-2.D0*PIHINT(S)
c
C     IT IS FASTER TO USE PIHINT(S) THAN PIH(S)
C...WEAK CONTRIBUTION TO TOTAL CROSSECTION
      SIN2=0.22D0
c
C     THIS IS A POPULAR VALUE FOR SIN(TH.W)**2
      GKL=4.4D-05
c
C     GKL HAS DIMENSION GEV**-2
      AZ2=1.D0/(16.D0*GKL*SIN2*(1.D0-SIN2))
      GV2=(-1.D0+4.D0*SIN2)**2
      CHI=0.D0
      IF(LWK) CHI=GKL*S*AZ2/(S-AZ2)
      DELW=2.D0*CHI*GV2
c
C...TOTAL CROSSECTION IN COLINEAR APPROXIMATION
C
      K0  =0.01D0
      GOTO 1234
C
      ENTRY QED024(ARG1,ARG2)
c
      K0=ARG1
      KMAX=ARG2
C
 1234 CONTINUE
      IF(KMAX.LT.1.D0) GOTO 1235
      KMAX=0.9999D0
      WRITE (IOUT,1236) KMAX
1236  FORMAT(' KMAX=1.0 ILLEGAL...CHANGED TO',F10.7)
1235  CONTINUE
C
C     THIS IS ONE OF THE INTERNAL PARAMETERS FOR SUBROUTINE EVENT
c
      SOFT1=1.D0 + DAR + DELT + DELH + BETA*DLOG(K0)
      Y2KMIN=Y2K(KMIN)
      Y2KMAX=Y2K(KMAX)
      SIGTOT=Y2KMAX-Y2KMIN
c
C...EXACT TOTAL CROSSECTION WITHOUT ANGLE LIMITS!!
c
      EXMAX= KMAX - 0.5D0*KMAX**2 + DLOG(1.D0-KMAX)
      EXMIN= KMIN - 0.5D0*KMIN**2 + DLOG(1.D0-KMIN)
      SIGEX=SIGTOT+0.5D0*(FAKTOR*SIG00)*(EXMAX-EXMIN)
      DELTOT=SIGTOT/SIG0
      DELTEX=SIGEX /SIG0
c
C...PRINTOUT
      WRITE (IOUT,2) SIG0,DELV,DELE,DELM,DELT,DELH,
     *      SIGTOT,DELTOT,SIGEX,DELTEX
    2 FORMAT(/,20X,'LOWEST ORDER CROSSECTION ',0PF10.6,' NANOBARN',
     Z       /,20X,'VERTEX CORRECTIONS       ',2PF10.3,'      %',
     Z       /,20X,'VAC. POL. (ELECTR)       ',2PF10.3,'      %',
     Z       /,20X,'VAC. POL. (MUON)         ',2PF10.3,'      %',
     Z       /,20X,'VAC. POL. (TAU)          ',2PF10.3,'      %',
     Z       /,20X,'VAC. POL. (HADRONS)      ',2PF10.3,'      %',
     Z       /,20X,'WITH HARD PHOTONS IN COLINEAR APPROXIMATION :',
     Z       /,20X,'TOTAL CROSSECTION        ',0PF10.6,' NANOBARN',
     Z       /,20X,'                =        ',2PF10.3,'      %',
     Z       /,20X,'WITH HARD PHOTONS TREATED EXACTLY :',
     Z       /,20X,'TOTAL CROSSECTION        ',0PF10.6,' NANOBARN',
     Z       /,20X,'                =        ',2PF10.3,'      %')
      IF(LWK) WRITE (IOUT,3) DELW
    3 FORMAT(  20X,'CONTRIBUTION FROM Z0=    ',2PF10.3,'      %')
      WRITE (IOUT,4)
    4 FORMAT(/,20X,'PERCENTAGES REFER TO THE LOWEST ORDER CROSSECTION ')
c
C (GENERATED EVENTS CORRESPOND TO THE EXACT CROSSSECTION)
C...INTERNAL PARAMETERS FOR EVENT GENERATION
c
      ITRY=0
      IEV=0
      ISYM=0
      RHO=2.0D0
      TRSHLD=0.D0
      Y2KK0=Y2K(K0)
      IF(KMIN.LT.K0)TRSHLD=(Y2KK0-Y2KMIN)/SIGTOT
      K0=DMAX1(K0,KMIN)
c
C     TRSHLD DETERMINES THE APPROXIMATE FRACTION OF SOFT EVENTS
C     IF KMIN > K0 , THERE WILL BE NO ELASTIC EVENTS POSSIBLE
C...CHECK ON EXOTIC INPUT AND RETURN
c
      IF(KMAX.LT.K0) WRITE (IOUT,5) KMAX,K0
    5 FORMAT(///,20X,'KMAX =',F10.7,' IS SMALLER THAN ',F10.7,/,
     Z 20X,'THIS WILL LEAD TO ERRORS IN ROUTINE EVENT')
C
C---> ADDITION 1-19-81
C
      KTEST=1.D0-.5D0*AM
      IF(KMAX.GT.KTEST) WRITE (IOUT,6) KMAX,KTEST
    6 FORMAT(///,20X,'KMAX =',F10.7,' IS LARGER THAN KTEST =',F10.7,/,
     Z 20X,'FOR VERY HARD PHOTONS THE EVENT '
     Z    ,'DISTRIBUTION MAY BE DISTORTED.')
      IF(KMAX.LT.KMIN) WRITE (IOUT,7)
    7 FORMAT(///,20X,'KMAX IS SMALLER THAN KMIN ,',/,
     Z  20X,'THIS GIVES NEGATIVE CROSSECTIONS ETC.')
      RETURN
C
      ENTRY QED023
c
      FEV=DFLOAT(IEV)
      FTRY=DFLOAT(ITRY)
      CROSS=(FEV/FTRY*RHO) * SIGEX
      DCROSS=CROSS/SIG0
      WRITE (IOUT,11) IEV,ITRY,ISYM,RHO,CROSS,DCROSS
c
   11 FORMAT(///,
     Z 20X,'# EVENTS GENERATED    =',I10,/,
     Z 20X,'# TRIALS NECESSARY    =',I10,/,
     Z 20X,'# WASTED DUE TO SYMM. =',I10,/,
     Z 20X,'RATIO FOR TESTING     =',F10.3,//,
     Z 20X,'TRUE CROSSECTION       ',F10.6,' NANOBARN',/,
     Z 20X,'                      =',2PF10.3,'      %')

      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED022(QP,QM,PH)

      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      DIMENSION QP(4),QM(4),PH(4)
      COMMON /CONSTQ/ E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      COMMON / TRY /  RHO,TES,ITRY,IEV,ISYM
      COMMON /OUTPAR/ K,C,CG,FIG,FI
      COMMON /OUTPA2/ S,SG,CFIG,SFIG,CFI,SFI
      REAL RANP
      EXTERNAL RANP
      EXTERNAL Y2KQ,Y2C,Y2CSFT,Y2CG,Y2FIG
c
      IEV=IEV+1
    1 ITRY=ITRY+1
      ISYM=ISYM+1
c
c...DETERMINE HARD OR SOFT USING HELMUT'S METHOD
c
      IF(RANP(0).GT.TRSHLD) GOTO 311
         K=0.D0
c
         CALL EVGENH(Y2CSFT,-1.D0,+1.D0,C)
c
ccc      print *,' qed022: c soft = ', c
         IF(DABS(C).GT.CMAX) GOTO 1
         CG=1.D0
         FIG=0.D0
         CFIG=1.D0
         SFIG=0.D0
         SG=0.D0
        GOTO 312
c
311      CALL EVGENH(Y2KQ,0.D0,DLOG(KMAX/K0),KKK)
c
         K=K0*DEXP(KKK)
c
         CALL EVGENH(Y2C,-1.D0,+1.D0,C)
c
ccc      print *,' qed022: c hard = ', c
         IF(DABS(C).GT.CMAX) GOTO 1
         CALL EVGENH(Y2CG,-1.D0,1.D0,CG)
         CALL EVGENH(Y2FIG,0.D0,2.D0*PI,FIG)
         SG=DSQRT((1.D0-CG)*(1.D0+CG))
         CFIG=DCOS(FIG)
         SFIG=DSIN(FIG)
312   CONTINUE
c
      S=DSQRT((1.D0-C)*(1.D0+C))
      FI=2.D0*PI*RANP(0)
      CFI=DCOS(FI)
      SFI=DSIN(FI)
c
c...impose angular cut on photon
coff  if (K.GT.0.D0) then
c        Y=2.D0-K+K*CG
c        XP=2.D0*(1.D0-K)/Y
c        XM=2.D0-K-XP
c        XMZ=-K*(C*CG+S*SG*CF)-XP*C
ccc      print *,' qed022: xmz/xm = ', xmz/xm
c        IF (DABS(XMZ/XM).GT.CMAX) GOTO 1
coff  end if
c
      ISYM=ISYM-1
      IF(QEDTS2(dummy).LT.(RANP(0)*RHO))GO TO 1
c
c...construct scaled momenta
c
      CALL QED02A(QP,QM,PH)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED026
C  ----------------------------------------------------------------------------
C...GENERATES SOFT PHOTON APPROXIMATION WITH EXPONENTIATION
C...FORMERLY CALLED FIXFOT + SOFOT
C  ----------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      COMMON / OUTPAR / K,C,CG,FIG,FI
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      REAL RANP
      EXTERNAL RANP
c
C----DEFINE DOUBLE PRECISION RANDOM FUNCTION
c
      DRAN(IRAN)=RANP(0)+0.D0
C
      AE2=AE**2
      AM2=AM**2
      K0BETA=K0**BETA
      C0=BETA*SOFT1/K0BETA
      D1=BETA*(1.D0-BETA)*(SIG0-SOFT1)/K0
      C1=(BETA*SIG0-D1*K0)/K0BETA
      WMAX=SIG0/SOFT1
    1 GOTO 311
  312 WEIGH=(C1+D1*K**(1.D0-BETA))/C0
      IF(WMAX*DRAN(0).GT.WEIGH) GOTO 1
      CG=Y
      FIG=FG
      IF(I.EQ.1) RETURN
      FIG=DATAN2(DSIN(FG) ,
     *  C*DCOS(FG)-CG*DSQRT((1.-C)*(1.+C)/(1.-CG)/(1.+CG))   )
      RETURN
C--------------------
  311 CONTINUE
c
CCCCCCSUBROUTINE SOFOT(AE2,AM2,C,K0,BETA,PI,K,Z,FG)
C
C GENERATES FOTON ANGLE ACCORDING TO:
C
C D/DOMEGA = 1/DOT(E+,K) + 1/DOT(E-,K) + 1/DOT(MU+,K) + 1/DOT(MU-,K)
C
C DONE BY A) CHOOSING IF RADIATING ALONG E+- OR MU+-
C         B) IMPOSING SIGN SYMMETRY AFTERWARDS
C         C) THIS LEAVES SIMPLY A 1/DOT(E,K) TERM, WHATEVER THE 'E' IS.
C
C THEN A WEIGHTING FUNCTION IS IMPOSED AT THE END.
C
      K=K0*DRAN(IRAN)**(1./BETA)
      EPSE=AE2/2.D0
      EPSM=AM2/2.D0
      WMIXT=DLOG(2.D0/EPSE) / DLOG(4.D0/EPSE/EPSM)
  313 FG=2.D0*PI*DRAN(IRAN)
      IF(DRAN(IRAN).GT.WMIXT) GOTO 411
      I=0
c
C---RADIATE OFF E+,E-
c
      OMZ=EPSE*((2.D0/EPSE+1.D0)**DRAN(IRAN) - 1.D0)
      OPZ=2.D0-OMZ
      IF(DRAN(IRAN).GT.0.5D0) GOTO 412
      OPZ=OMZ
      OMZ=2.D0-OPZ
  412 Z=(OPZ-OMZ)/2.D0
      Y=C*Z + DSQRT((1.D0-C)*(1.D0+C)*OPZ*OMZ)*DCOS(FG)
      OMY=1.D0-Y
      OPY=1.D0+Y
      GOTO 500
  411 I=1
c
C---RADIATE OFF MU+,MU-
c
      OMY=EPSM*((2.D0/EPSM+1.D0)**DRAN(IRAN) - 1.D0)
      OPY=2.D0-OMY
      IF(DRAN(IRAN).GT.0.5D0) GOTO 417
      OPY=OMY
      OMY=2.D0-OPY
  417 Y=(OPY-OMY)/2.D0
      Z=C*Y + DSQRT((1.D0-C)*(1.D0+C)*OPY*OMY)*DCOS(FG)
      OMZ=1.D0-Z
      OPZ=1.D0+Z
  500 YP=OPY+EPSM
      YM=OMY+EPSM
      ZP=OPZ+EPSE
      ZM=OMZ+EPSE
      EXACT=OMZ*OPZ*YP*YM/ZP/ZM
     *     +OMY*OPY*ZP*ZM/YP/YM
     *     +0.5D0*(1.D0-C)*(ZP*YP+ZM*YM)
     *     -0.5D0*(1.D0+C)*(ZP*YM+ZM*YP)
      PROXIM=ZP*ZM+YP*YM
      WEIGH=EXACT/PROXIM
c
C8) TEST FOR EXIT ASSUMING MAXIMUM WEIGHT SMALLER THAN 10
c
      IF(DRAN(IRAN)*10.D0.LE.WEIGH) GOTO 312
      GO TO 313
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED02A(QP,QM,PH)
C  ----------------------------------------------------------------------------
C...CONSTRUCT 4MOMENTA FROM EVENT PARAMETERS K,C,CG,FIG,FI
C...THE ENERGIES ARE NORMALIZED TO THE BEAM ENERGY ;
C...THE POSITRON DIRECTION IS THE POSITIVE Z-AXIS  ;
C...THE PARTICLE ENERGIES ARE THE FOURTH COMPONENTS.
C  ----------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      DIMENSION QP(4),QM(4),PH(4)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,C,CG,FIG,FI
      COMMON / OUTPA2 / S,SG,CF,SF,CI,SI
      LOGICAL LSFOT
c
      DATA LSFOT/.FALSE./
c
      GOTO 7777
C
      ENTRY QED027(IARG)
c
      LSFOT=IARG.NE.0
      RETURN
C
 7777 CONTINUE
c
C...QP=Q*ROTA*ROTB*(0,0,1)
C...PH=K*ROTA*ROTB*(SG*SF,SG*CF,CG)
C
C ROTA=(+CI,+SI,0 // +SI,-CI,0 // 0,0,1)
C ROTB=(1,0,0 // 0,-C,+S // 0,+S,+C)
C
      IF(K.NE.0.D0) GOTO 300
      IF(.NOT.LSFOT) GOTO 400
      CALL QED026
      CF=DCOS(FIG)
      SF=DSIN(FIG)
c
C...4MOMENTUM OF MU+
c
  300 Q=2.D0*(1.D0-K)/(2.D0-K+K*CG)
      QP(1)=Q*SI*S
      QP(2)=-Q*CI*S
      QP(3)=Q*C
      QP(4)=Q
c
C...4MOMENTUM OF THE PHOTON
c
      PH(1)=K*(CG*S*SI-C*SI*SG*CF+CI*SG*SF)
      PH(2)=K*(-CI*CG*S+CI*C*SG*CF+SI*SG*SF)
      PH(3)=K*(C*CG+S*SG*CF)
      PH(4)=K
      GOTO 500
C
  400 QP(1)=SI*S
      QP(2)=-CI*S
      QP(3)=C
      QP(4)=1.D0
      PH(1)=0.D0
      PH(2)=0.D0
      PH(3)=0.D0
      PH(4)=0.D0
C
C...4MOMENTUM OF THE MU- IS GIVEN BY MOMENTUM CONSERVATION
C
  500 QM(1)=-QP(1)-PH(1)
      QM(2)=-QP(2)-PH(2)
      QM(3)=-QP(3)-PH(3)
      QM(4)=-QP(4)-PH(4)+2.D0
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED031(ARG1,ARG2,ARG3,IARG4,ARG5)
C  ---------------------------------------------------------------------------
C   MAIN ROUTINE FOR RADIATIVE TAU PRODUCTION.  SPECIAL FORM
C   FOR THE HARD BREMSTRAHLUNG INTEGRAL CONTAINING THE
C   CROSS SECTION FOR THE TURN-ON OF A HEAVY LEPTON PAIR
C   IS USED HERE.  (SEE B+K PAPER ON INITIAL STATE RADIATION
C   APPENDIX B).
C  ---------------------------------------------------------------------------
C beam energy and mass to be given in gev
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON/QED000/IOUT
      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / GRENS / KMAX,A ,CMAX,SOFT,TRSHLD,K0
      COMMON/TRY5/ITRY,IEV
c
C constants
c
      ENERGY=ARG1
      AMIN  =ARG2
      MASS  =ARG3
      INCL  =IARG4
      KMAXX =ARG5
      K0   =1.D-2
      ITRY=0
      IEV =0
      BARN=(1.9732858D0)**2*(1.D+05)
      PI=3.1415927D0
      ME=0.5110034D-03
      MM=105.65948D-03
      MT=1.7771D0
      ALFA=1./137.035982D0
      CMAX=DCOS(AMIN*PI/180.D0)
c
C DIMNESIONLESS QUANTITIES AND S
c
      S=4.D0*ENERGY**2
      LE=DLOG(S/ME**2)
      LM=DLOG(S/MM**2)
      FAKTOR=2.D0*ALFA/PI
      BETA=FAKTOR*(LE-1.D0)
      AME=(ME/ENERGY)**2
      EME=DSQRT(1.D0+AME)
c
C..NOTE...AT=STANDARD TAU MASS, OF NO CONCERN TO OUTSIDE ROUTINES
c
      AT=MT/ENERGY
c
C....AMT=THE INPUTTED FINAL LEPTON MASS, NEEDED EVERYWHERE
C...SIGNAL AMT=0.D0 IF JUST INITIAL STATE RADIATION WANTED (BREVNT)
c
      AMT=(MASS/ENERGY)**2
c
C ELECTRON VERTEX CORRECTION AND VACUUM POLARIZATION
c
      DVTX=FAKTOR*(0.75D0*LE+PI**2/6.D0-1.D0)
      DELEC=FAKTOR*(LE/3.D0-5.D0/9.D0)
c
C MUON VACUUM POLARIZATION
c
      DMUON=FAKTOR*(LM/3.D0-5.D0/9.D0)
c
C TAU VACUUM POLARIZATION
c
      A2=1.D0-AT*AT
      A=DSQRT(A2)
      LOGB=DLOG(AT**2/(1.D0+A)**2)
      DTAU=-FAKTOR*(8.D0/9.D0-A2/3.D0+A*(0.5D0-A2/6.D0)*LOGB)
c
C HADRONIC VACUUM POLARIZATION
C-----DELTH=-2.D0*PIH(S*1.D+6)----IS TOO SLOW
c
      DELTH=-2.D0*PIHINT(S)
c
C FINITE PART ANALYTIC CORRECTION
c
      DELTA=DVTX+DELEC+DMUON+DTAU+DELTH
      SOFT=1.D0+DELTA+BETA*DLOG(K0)
c
C LOWEST ORDER CROSSECTION
c
      SIG0=4.D0*ALFA**2*PI/3.D0/S*BARN
c
C----------INCLUDE MASSEFFECTS FROM OUTGOING LEPTON-------
c
      SIG0=SIG0*DSQRT(1.D0-AMT)*(1.D0+0.5D0*AMT)
c
C---APPLY ANGULAR CUT
c 
      SIG00=SIG0 / (4./3.) * CMAX*(1.+CMAX**2/3.)
c
C TOTAL CROSSECTION AND CORRECTION
c
      KMAX=1.D0-AMT
c
C---THE FOLLOWING FOR BRSTRT PURPOSES
C---FIXUP 5.JUNE.85   0.5 GEV INTO 0.5 MEV
c
      IF(AMT.EQ.0.D0) KMAX=1.D0-0.0005/ENERGY
c
C------FIXUP 5.JUNE.85------
c
      IF (KMAXX.GT.0.D0.AND.KMAXX.LT.1.D0) KMAX=DMIN1(KMAX,KMAXX)
      SIGT=Y3K(KMAX)
      DELTOT=SIGT/SIG00-1.D0
      TRSHLD=SOFT*SIG0/SIGT
c
C PRINT OUT RESULTS
c
      WRITE (IOUT,2) ENERGY,AMIN,SIG00,KMAX,DVTX,DELEC,DMUON,DTAU,DELTH
    2 FORMAT(1H ,/
     Z      ,20X,'BEAM ENERGY                        =',F10.5,' GEV',/
     Z      ,20X,'ANGLE CUT AT                       =',F10.5,
     Z' DEGREES',/
     Z      ,20X,'LOWEST ORDER CROSSECTION           =',F10.5,' NB',/
     Z      ,20X,'UPPER LIMIT ON K/E                 =',F10.5,/
     Z      ,20X,'VERTEX CORRECTIONS                 =',2PF10.5,' %',/
     Z      ,20X,'ELECTRON VACUUM POLARIZATION       =',2PF10.5,' %',/
     Z      ,20X,'MUON   VACUUM POLARIZATION         =',2PF10.5,' %',/
     Z      ,20X,'TAU    VACUUM POLARIZATION         =',2PF10.5,' %',/
     Z      ,20X,'HADRON VACUUM POLARIZATION         =',2PF10.5,' %')
      IF(MASS.GT.0.)WRITE(IOUT,233) MASS
  233 FORMAT(20X,'HEAVY PARTICLE MASS                =',F10.5,' GEV')
C
C HEAVY PARTICLE VACUUM POLARIZATION
C
      IF(INCL.EQ.0)GOTO 43
      A2=1.D0-AMT
      A=DSQRT(A2)
      LOGB=DLOG(AMT/(1.D0+A)**2)
      DHEAVY=-FAKTOR*(8.D0/9.D0-A2/3.D0+A*(0.5D0-A2/6.D0)*LOGB)
      DELTA=DELTA+DHEAVY
      WRITE (IOUT,3) DHEAVY
    3 FORMAT(20X,'HEAVY PARTICLE VACUUM POLARIZATION =',2PF10.5,' %')
   43 CONTINUE
C
      WRITE (IOUT,4) DELTA,SIGT,DELTOT
    4 FORMAT(20X,'FINITE ANALYTIC CORRECTION         =',2PF10.5,' %',/
     Z      ,20X,'CORRECTED CROSSECTION              =',0PF10.5,' NB',/
     Z      ,20X,'TOTAL CORRECTION                   =',2PF10.5,' %')
      RETURN
C
      ENTRY QED034
c
      RETURN
C
      ENTRY QED033
c
      WRITE (IOUT,3331) ITRY,IEV
3331  FORMAT(//,' TRIED',I10,' EVENTS',/,
     *    ' ACCEPTED',I10,' EVENTS AFTER ANGLE CUT')
      CROSS=SIGT*(IEV+0.D0)/(ITRY+0.D0)
      DCROSS=CROSS/SIG00-1.D0
      WRITE (IOUT,3332) CROSS,DCROSS
3332  FORMAT(20X,'FINAL CROSSECTION     =',0PF10.5,' NB',/,
     *         20X,'TOTAL CORRECTION      =',2PF10.5,' %')

      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED032(QPP,QM,PH)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      DIMENSION QPP(4),QM(4),PH(4)
      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / GRENS / KMAX,A ,CMAX,SOFT,TRSHLD,K0
      COMMON / OUT11 / K,Z,ZM,ZP,SZ,FG,SFG,CFG
      COMMON / INV1 / EPLMN,PYPLMN,PZPLMN,BOOST1,BOOST2,BOOST3,IPLUS
      EXTERNAL Y3KQ,Y3ZQ
      COMMON/TRY5/ITRY,IEV
      REAL RANP
      EXTERNAL RANP
c
      IEV=IEV+1
      CMXX=1.D0-CMAX
      DMXX=CMAX
111   ITRY=ITRY+1
      IF(RANP(0).GT.TRSHLD) GOTO 911
c
C----SOFT REGIME------
c
      K=0.D0
      Z=1.D0
      ZM=0.D0
      ZP=2.D0
      SZ=0.D0
      FG=0.D0
      CFG=1.D0
      SFG=0.D0
      FP=1.D0
      FM=1.D0
      S1=4.D0
      W1=2.D0
      GOTO 910
c
C----HARD REGIME------
c
911   CALL EVGENH(Y3KQ,0.D0,DLOG(KMAX/K0),QKQK)
c
      K=K0*DEXP(QKQK)
      EPSLN=AME/2.
      CALL EVGENH(Y3ZQ,1./(EPSLN+2.),1./EPSLN,ZQZQ)
      ZM=1./ZQZQ-EPSLN
      Z=1.D0-ZM
      ZP=2.D0-ZM
      IF(RANP(0).LT.0.5D0) GOTO 311
            ZP=ZM
            Z=ZP-1.D0
            ZM=2.-ZP
311   SZ=DSQRT(ZM*ZP)
      FG=2.D0*PI*RANP(0)
      SFG=DSIN(FG)
      CFG=DCOS(FG)
c
C CALCULATE K-DEPENDENT INVARIANTS IN LAB FRAME
c
      DELDEL=AME/(EME+1.D0)      !=EME-1
      ZETA=Z/EME
      IF(ZETA.LT.0.) GOTO 312
            OMZETA=(DELDEL+ZM)/EME
            OPZETA=1.D0+ZETA
            GOTO 313
312         OMZETA=1.D0-ZETA
            OPZETA=(DELDEL+ZP)/EME
313   KM=1.D0-K
      S1=4.D0*KM
      W1=DSQRT(S1)
c
C....FP AND FM ARE NEEDED ONLY AS RELATIVE WEIGHTS IN Y3C,Y3F
c
      FP=-2.D0*AME*S1*(OMZETA/OPZETA)+(S1+2.D0*OPZETA)**2
      FM=-2.D0*AME*S1*(OPZETA/OMZETA)+(S1+2.D0*OMZETA)**2
C
C PICK AXIS ALONG WHICH TO MEASURE ANGLE OF FINAL LEPTON
C (EITHER R(+) OR R(-) )
C.......IPLUS=1 SELECT R(+),  IPLUS=-1 SELECT R(-)
C
910   PH(4)=K
      PH(3)=K*Z
      PH(1)=K*SZ*SFG
      PH(2)=K*SZ*CFG
      IPLUS=1
      IF(RANP(0)*(FP+FM).GT.FP) IPLUS=-1
c
C---ENERGY/MOMENTUM VECTOR OF E+ (OR E-)
c
      IF(K.NE.0.D0) GOTO 411
            EPLMN=EME
            PZPLMN=IPLUS

            GOTO 412
411   EPLMN=W1/2.+K/W1*(EME+IPLUS*Z)
      PYPLMN=EME+K*IPLUS*Z/(2.*EME-K+W1)
      PZPLMN=IPLUS + PYPLMN*K/W1*Z
      PYPLMN=        PYPLMN*K/W1*SZ
      PPPLMN=DSQRT(PYPLMN**2+PZPLMN**2)
      PYPLMN=PYPLMN/PPPLMN
      PZPLMN=PZPLMN/PPPLMN
      BOOST1=(2.*EME-K)/W1
      BOOST2=-K*SZ/W1
      BOOST3=-K*Z/W1
C
C HAVE NOW THE BOOST FACTORS AND ROTATION STUFF TOGETHER
C
412   IF(AMT.EQ.0.D0) RETURN
C
C
C NOW PICK TETA AND FAI FOR THE FINAL LEPTONS IN THE C.M. FRAME
C     OF THE FINAL STATE.
      A=4.D0*AMT/S1
      A1=1.D0+A
      A2=1.D0-A
c
CCCCCCCALL EVGENH(Y3CC,-1.D0,1.D0,C)
c
      C=RANP(0)*2.D0-1.D0
      IF(RANP(0)*(A1+A2/3.D0).GT.A1) C=DSIGN(DABS(C)**0.333333D0,C)
c
CCCCCCCCCCCCCCCCCCC
      SC=DSQRT(1.D0-C*C)
      FI=2.D0*PI*RANP(0)
      QQQ=W1/2.*DSQRT(A2)
      QPP(1)=QQQ*SC*DCOS(FI)
      QPP(2)=QQQ*SC*DSIN(FI)
      QPP(3)=QQQ*C
      QPP(4)=W1/2.
c
C...APPLY ROTATION+BOOST+FIROTATION
c
      CALL QED03T(QPP)
c
      IF(QPP(3)**2*CMXX.GT.(QPP(1)**2+QPP(2)**2)*DMXX) GOTO 111
      QM(1)=-QPP(1)-PH(1)
      QM(2)=-QPP(2)-PH(2)
      QM(3)=-QPP(3)-PH(3)
      QM(4)=2.D0-QPP(4)-PH(4)
      IF(QM(3)**2*CMXX.GT.(QM(1)**2+QM(2)**2)*DMXX) GOTO 111
C
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED03T(Q)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      DIMENSION Q(4)
      COMMON / OUT11 / K,Z,ZM,ZP,SZ,FG,SFG,CFG
      COMMON / INV1 / EPLMN,PYPLMN,PZPLMN,BOOST1,BOOST2,BOOST3,IPLUS
c
      QX=Q(1)
      QY=Q(2)
      QZ=Q(3)
      QE=Q(4)
      IF(K.EQ.0.D0) GOTO 411
C
C first rotate such that if
C Q(1..4) were = (0,0,PPPLMN,EPLMN) then it would be rotated into
C                (0,PYPLMN,PZPLMN,EPLMN)
C
C any incoming angular distribution with respect to the 3-axis
C is changed into one w.r.to the E(+) [ or the E(-)] axis
C in the hadron C.O.M. system
C
      QQ=QY
      QY=PZPLMN*QQ+PYPLMN*QZ
      QZ=PZPLMN*QZ-PYPLMN*QQ
C
C now boost back from the hadron C.O.M. system to the lab system0
C
      QDOT=(QY*BOOST2+QZ*BOOST3)
      QEEE=BOOST1*QE+QDOT
      QDOT=QE+QDOT/(BOOST1+1.)
      QY=QY+BOOST2*QDOT
      QZ=QZ+BOOST3*QDOT
      QE=QEEE
C
C
C now rotate by fi around the lab-z-axis
C  (originally, 'K' in the Y/Z plane)
C
411   QQ=QY
      QY=QQ*CFG-QX*SFG
      QX=QQ*SFG+QX*CFG
C
C
      Q(1)=QX
      Q(2)=QY
      Q(3)=QZ
      Q(4)=QE
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED041(ARG1,ARG2,ARG3)
c --------------------------------------------------------------------------
c...SETUP ROUTINE FOR CONSTANTS, PARAMETERS AND CROSSECTIONS
c --------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / TRY4 / RHO,TTOT,IEV,ITRY,ISYM
      INTEGER IEV,ITRY,ISYM
      COMMON/QED000/IOUT
      INTEGER       IOUT
c
      ENERGY=ARG1
      AMIN  =ARG2
      CMAX=DCOS(AMIN*3.1415926D0/180.D0)
c
c... NATURAL CONSTANTS
c
      BARN=(1.9732858D0)**2*(1.D+05)
      PI=3.1415927D0
      ME=0.5110034D-03
      ALFA=1.D0/137.035982D0
      PI2=PI*PI
c
c      K0=0.01D0
c	K0=0.001D0
        K0=ARG3
c
      GOTO 1234
c
      ENTRY QED044(ARG1)
      K0=ARG1
c
1234  CONTINUE
c     THIS IS ONE OF THE PARAMETERS FOR SUBROUTINE EVENT
c...INPUT PARAMETERS
c
      S=4.D0*ENERGY*ENERGY
      M=ME/DSQRT(ENERGY*ENERGY-ME*ME)
      MU=0.5D0*M*M*(1.D0-0.25D0*M*M)
c
c???this causes scaled momenta > 1.0d0E
      E =1.D0+MU
      DL=2.D0+MU
c
c???
      LE=DLOG(DL/MU)
      S=S/BARN
c
c...COEFFICIENT OF INFRARED DIVERGENCY
c
      LK0=DLOG(K0)
      BETA=2.D0*ALFA/PI*(LE-1.D0)
c
c...LOWEST ORDER CROSSECTION (NO ANGULAR CUT, FULL FOURPI)
c
      SIG0=2.D0*ALFA**2*PI/S * (LE-1.D0)
c
c...APPLY ANGULAR CUT
c
      SIG00=2.D0*ALFA**2*PI/S * (DLOG((E+CMAX)/(E-CMAX))-CMAX)
c
c...ANALYTIC CORRECTION OF CROSSECTION
c
      SIGA=SIG0*(1.D0+BETA*LK0)
     Z   +2.D0*ALFA**3/S*(LE**3/6.D0+0.75D0*LE**2+(PI2/3.D0-3.D0)
     1 *LE-PI2/12.D0)
      DELA=SIGA/SIG0
c
c...TOTAL CROSSCECTIONS AND CORRECTION
c...EXACT TOTAL CROSSECTION INTEGRATED OVER ALL K (NO KMAX)
c
      SIGTOT=-SIG0*BETA*LK0  +  SIGA
     Z   +2.D0*ALFA**3*(-(LE-1.D0)**2+3.D0) /S
c
c...COLINEAR CROSSECTION INTEGRATED OVER ALL K
c
      SIGCOL=Y4K(1.D0)
      DELTOT=SIGTOT/SIG0
      DELCOL=SIGCOL/SIG0
c
c...PARAMETERS FOR SUBROUTINE EVENT
c
      IEV=0
      ITRY=0
      TTOT=0.D0
      ISYM=0
      RHO=2.0D0
      THRSLD=SIGA/SIGCOL
c
c...PRINTOUT AND RETURN
c
      WRITE(IOUT,1) ENERGY,LE,AMIN,K0
c
    1 FORMAT(/,70(1H-),/,
     . 42H INITIALIZATION FOR GAMMA-GAMMA SCATTERING ,//,
     . 37H                          BEAM ENERGY ,F15.6,4H GEV,/,
     . 37H                          LOG(S/M**2) ,F15.6,/,
     . 37H             MINIMUM SCATTERING ANGLE ,F15.6,8H DEGREES,/,
     . 37H   MINIMUM HARD BREMSSTRAHLUNG FRACT. ,F15.6,/)
c     . 37H   MAXIMUM HARD BREMSSTRAHLUNG FRACT. ,F15.6,/)
      WRITE(IOUT,2)K0,THRSLD,RHO
c
    2 FORMAT(  /,18X,'SOFT-HARD BORDER         =',F12.5
     Z        ,/,18X,'# SOFT EVENTS (COL.APP.) =',2PF12.5,' %'
     Z        ,/,18X,'TEST CUTOFF RHO          =',0PF12.5)
      WRITE(IOUT,3)SIG0,SIG00,SIGA,DELA,SIGTOT,DELTOT,SIGCOL,DELCOL
c
    3 FORMAT(  /,18X,'SIG0 (4 PI)              =',F12.5,' NB'
     Z        ,/,18X,'LOWEST ORDER CROSSECTION =',F12.5,' NB'   
     Z        ,/,18X,'TOTAL ANALYTIC XSN       =',F12.5,' NB',
     Z' =',2PF8.1,' % OF SIG0'
     Z        ,/,18X,'TOTAL EXACT XSN          =',0PF12.5,' NB',
     Z' =',2PF8.1,' % OF SIG0'
     Z        ,/,18X,'TOTAL COLINEAR XSN       =',0PF12.5,' NB',
     Z' =',2PF8.1,' % OF SIG0')
      RETURN
c
      ENTRY QED043
c
      FEV=DFLOAT(IEV)
      FTRY=DFLOAT(ITRY)
      TTRY=TTOT/FTRY
c
c...TTRY=SAME THING AS RATIO, EXCEPT USING WEIGHTS INSTEAD OF HIT/REJCT
      RATIO=FEV/FTRY*RHO
c
chm   SIGCOR=SIGCOL*TTRY
      SIGCOR=SIGCOL*ratio
      DELCOR=SIGCOR/SIG00
      WRITE(IOUT,212)IEV,ITRY,ISYM,RHO,ttry,RATIO,SIGCOR,DELCOR
c
c*****TYPE     212,IEV,ITRY,ISYM,RHO,RATIO,SIGCOR,DELCOR
c
  212 FORMAT(///,
     Z 20X,'# EVENTS GENERATED       =',I10,/,
     Z 20X,'# TRIALS NECESSARY       =',I10,/,
     Z 20X,'# LOST DUE TO ANG.CUT    =',I10,/,
     Z 20X,'RATIO FOR TESTING (RHO)  =',F10.5,/,
     Z 20X,'RATIO CROSSECTIONS (TTRY)=',F10.5,/,
     Z 20X,'RATIO CROSSECTIONS       =',F10.5,/,
     Z 20X,'THE ACCEPTED TOTAL CROSSECTION BECOMES ',/,
     Z 20X,'AFTER WEIGHTING       :',F10.5,' NB',' =',2PF10.1,' % OF SIG0')

      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED042(K1,K2,K3)

      IMPLICIT DOUBLE PRECISION(A-Z)
      DOUBLE PRECISION K1(4),K2(4),K3(4)
      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / TRY4 / RHO,TTOT,IEV,ITRY,ISYM
      COMMON / OUT13 / K,C,Z,FI,FG
      COMMON / OUT12 / SC,SZ,CGAM,E2
      DIMENSION EE(3),EEZ(3)
      real*8 ksave(4)
      INTEGER IP,I
      INTEGER IEV,ITRY,ISYM
      REAL RANP
      EXTERNAL RANP
      EXTERNAL Y4KQ,Y4CQ
c
      IEV=IEV+1
    1 ITRY=ITRY+1
      ISYM=ISYM+1
      FI=2.D0*PI*RANP(0)
      FG=2.D0*PI*RANP(0)
      IF(RANP(0).GT.THRSLD) GOTO 311
c
C...SOFT CASE: NO BREMSSTRAHLUNG ASSUMED
C...C GOES AS 2./(SIN**2(TH)+M**2) (GIVEN BY "GENCOS" PLUS REFLECTION)
c
         K=0.D0
         C=GENCOS(K)
         IF(RANP(0).GT.0.5D0) C=-C
         Z=1.D0
      GOTO 312
c
C...HARD CASE; GENERATE BREMSSTRAHLUNG ABOVE K0
c
311      CALL EVGENH(Y4KQ,0.D0,DLOG(1.D0/K0),KLOG)
c
         K=K0*DEXP(KLOG)
c
         CALL EVGENH(Y4CQ,0.D0,DLOG(1.D0+1.D0/MU),CCC)
c
         C=(1.D0+MU)*(1.D0-DEXP(-CCC))
         IF(RANP(0).GT.0.5D0) C=-C
         Z=GENCOS(K)
         IF(RANP(0).GT.WEIZ(K,C)) Z=-Z
312   CONTINUE
      SC=DSQRT((1.D0-C)*(1.D0+C))
      SZ=DSQRT((1.D0-Z)*(1.D0+Z))
      K=E*K
      CGAM=C*Z+SC*SZ*DCOS(FI-FG)
      E2=2.D0*E*(E-K)/(2.D0*E-K+K*CGAM)
c...impose angular cuts
      EE(1)=MAX(1.D-7,K)
      EE(2)=MAX(1.D-7,E2)
      EE(3)=MAX(1.D-7,2.D0*E-EE(1)-EE(2) )
      EEZ(1)=EE(1)*Z
      EEZ(2)=EE(2)*C
      EEZ(3)=-EEZ(1)-EEZ(2)
c...note that this cut requires ALL tracks to be outside the acceptance.
c...there are a fair amount of events with one or more tracks inside.
      IF(( DABS(EEZ(1)/EE(1)).GT.CMAX .OR. EE(1).LT.1.D-6 ) .AND.
     *   ( DABS(EEZ(2)/EE(2)).GT.CMAX .OR. EE(2).LT.1.D-6 ) .AND.
     *   ( DABS(EEZ(3)/EE(3)).GT.CMAX .OR. EE(3).LT.1.D-6 ) )
     * GOTO 1
c        write(6,*)"CMAX:",CMAX,"  ez3:",EEZ(3),"  ee3:",EE(3)
      ISYM=ISYM-1
      T=QEDTS4(dummy)
      TTOT=TTOT+T
      IF(RHO*RANP(0).GT.T) GO TO 1
c
      CALL QED04A(K1,K2,K3)
c
      CALL QED04B(K1,K2,K3)
c
C-- For 3 gamma case define K3 as the weakest photon
      IP=1
      IF(K1(4).GT.K2(4)) IP=2
      IF(DMIN1(K1(4),K2(4)).GT.K3(4)) IP=3
      if (ip .eq. 1) then
c
         do i = 1,4
            ksave(i) = k3(i)
            k3(i)    = k1(i)
            k1(i)    = ksave(i)
         end do
c
      elseif (ip .eq. 2) then
c
         do i = 1,4
            ksave(i) = k3(i)
            k3(i)    = k2(i)
            k2(i)    = ksave(i)
         end do
c
      end if
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED04A(K1,K2,K3)

C  ---------------------------------------------------------------------------
C...CONSTRUCT 4VECTORS OUT OF GENERATED VARIABLES ;
C...THIS IS EXACT BECAUSE THE PARTICLES ARE MASSLES.
C...THE FOURTH COMPONENT IS THE ENERGY;THE THIRD COMPONENT
C...IS THE DIRECTION OF THE POSITRON BEAM
C  ---------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      DIMENSION K1(4),K2(4),K3(4)
      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / OUT13 / E1,C,Z,FI,FG
      COMMON / OUT12 / SC,SZ,CGAM,E2
c
      K1(1)=E1*SZ*DCOS(FG)
      K1(2)=E1*SZ*DSIN(FG)
      K1(3)=E1*Z
      K1(4)=E1
      K2(1)=E2*SC*DCOS(FI)
      K2(2)=E2*SC*DSIN(FI)
      K2(3)=E2*C
      K2(4)=E2
      K3(1)=-K1(1)-K2(1)
      K3(2)=-K1(2)-K2(2)
      K3(3)=-K1(3)-K2(3)
      K3(4)=-K1(4)-K2(4)+2.D0*E
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QED04B(K1,K2,K3)

      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      REAL RANP
      EXTERNAL RANP
      DIMENSION L(3,4),K1(4),K2(4),K3(4)
      INTEGER PERM(3,6)
c
      DATA PERM/1,2,3, 2,3,1, 3,1,2, 3,2,1, 2,1,3, 1,3,2/
c
      DO 11 I=1,4
      L(1,I)=K1(I)
      L(2,I)=K2(I)
11    L(3,I)=K3(I)
c
C...PICK ANY PERMUTATION OF THE THREE MOMENTA
C...TO ASSURE SYMMETRICAL EVENT SHAPES
c
      IT=IDINT(RANP(0)*6.D0)+1
      J1=PERM(1,IT)
      J2=PERM(2,IT)
      J3=PERM(3,IT)
c
      DO 7 J=1,4
      K1(J)=L(J1,J)
      K2(J)=L(J2,J)
    7 K3(J)=L(J3,J)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      DOUBLE PRECISION FUNCTION QED04Z(C)

C  ----------------------------------------------------------------------------
C...FINITE ANGLE-DEPENDENT PART OF VIRTUAL CORRECTIONS
C...THIS MUST BE EVEN IN C
C...THE PSEUDODIVERGENCE IN 1/(K-MU/2) IS TREATED SEPARATELY
C  ----------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
c
      M2=0.5D0*MU
      QED04Z=0.D0
      I=0
      C1=C
c
    1 K=0.5D0*(1.D0+C1)+M2
      T=0.5D0*(1.D0-C1)+M2
      H0=.5D0/K+.5D0/T
      H1=0.5D0/K+1.D0/T-0.5D0
      H2=2.D0/K-0.5D0+MU/K/K
      H3=-K-0.75D0/T+0.75D0
      H4=-1.5D0/T+1.5D0 -MU/T/T
      H5=2.D0/T+1.D0/K-1.D0 +2.D0*M2*M2/K/K/K
      U=K/M2-1.D0
      FACLI2=PI2/6.D0-DILOG1(-U)
      IF(U.LE.1.D-03) GO TO 4
      DIVTRM=DLOG(U+1.D0)*(-1.D0/MU/U-0.5D0/U/U)+0.5D0/U
      GO TO 5
c
    4 DIVTRM=-1.D0/MU
    5 QED04Z=(0.25D0*LE*LE-PI2/12.D0)*(H0 + 1.D0)
     Z +(DLOG(K)+LE)*(-2.D0*LE*H1 + H2)
     Z +(PI2-LE*LE)*H3 + (2.D0*M2/K-1.D0)*LE
     Z +H4 + FACLI2*H5 + DIVTRM + QED04Z
      IF (I.EQ.1) RETURN
      I=1
      C1=-C
      GO TO 1
c
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QEDSY2(IERR)
C...
C...IMPOSE ANGLE LIMIT ON THE PHOTON
C...
      IMPLICIT DOUBLE PRECISION (A-H,K,O-Z)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      COMMON/OUTPAR/K,C,CG,FIG,FI
      COMMON/OUTPA2/S,SG,CF,SFIG,CFI,SFI
c
      IERR = 0
      Y=2.D0-K+K*CG
      XP=2.D0*(1.D0-K)/Y
      XM=2.D0-K-XP
      XMZ=-K*(C*CG+S*SG*CF)-XP*C
ccc   print *,' qedsy2: xmz/xm = ', xmz/xm
      IF(DABS(XMZ/XM).GT.CMAX) GOTO 50
      RETURN

50    IERR = 1
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE QEDSY4(IERR)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / OUT13 / K,C,Z,FI,FG
      COMMON / OUT12 / SC,SZ,CGAM,E2
      DIMENSION EE(3),EEZ(3)
c
      IERR = 0
      EE(1)=MAX(1.D-7,K)
      EE(2)=MAX(1.D-7,E2)
      EE(3)=MAX(1.D-7,2.D0*E-EE(1)-EE(2) )
      EEZ(1)=EE(1)*Z
      EEZ(2)=EE(2)*C
      EEZ(3)=-EEZ(1)-EEZ(2)
      IF(( DABS(EEZ(1)/EE(1)).GT.CMAX .OR. EE(1).LT.1.D-6 ) .AND.
     *   ( DABS(EEZ(2)/EE(2)).GT.CMAX .OR. EE(2).LT.1.D-6 ) .AND.
     *   ( DABS(EEZ(3)/EE(3)).GT.CMAX .OR. EE(3).LT.1.D-6 ) )
     * GOTO 50
      RETURN

50    IERR = 1
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION QEDTS2(DUMMY)
C  ---------------------------------------------------------------------------
C...TEST EVENT FOR ACCEPTANCE BY COMPARING COLINEAR APPROXIMATION
C...WITH THE EXACT DISTRIBUTION IN BOTH REGIMES
C  ---------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
      COMMON / OUTPAR / K,C,CG,FIG,FI
      COMMON / OUTPA2 / S,SG,CFIG,SFIG,CFI,SFI
      COMMON/QED000/IOUT
c
      CP=1.D0+C
      CM=1.D0-C
      CS=1.D0+C*C
      IF(K.EQ.0.D0)GO TO 2
c
c...HARD EVENT
c
      Y=2.D0-K+K*CG
      Y2=Y*Y
      KM=1.D0-K
      KM2=1.D0+KM*KM
      AM2=AM*AM
      AE2=AE*AE
      AE3=0.5D0*AE2
      DEL=.25D0*AM2*K/KM
      X=2.D0*KM/Y
      TK=2.D0*(X-KM+DEL)
      UK=2.D0*(1.D0-X+DEL)
      AKA=C*CG+S*SG*CFIG
      KA1=((1.D0+AKA)+AE3)*K
      KA =((1.D0-AKA)+AE3)*K
      T =X*CM
      T1=X*CP
      U =2.D0-T-KA
      U1=2.D0-T1-KA1
      T2 =T*T
      T12=T1*T1
      U2 =U*U
      U12=U1*U1
      ACOLL=(-AE2*((U12+T12)/KA/KA+(U2+T2)/KA1/KA1)/KM/KM
     Z       -AM2*((U2+U12)/TK/TK+(T2+T12)/UK/UK)
     Z  +(T2+T12+U2+U12)/KM*(2.D0/KA/KA1+2.D0*KM/TK/UK
     Z  +T/TK/KA-T1/TK/KA1-U/UK/KA+U1/UK/KA1))*K*KM/Y/Y
      AKC =(CP*CP+KM*KM*CM*CM)/(CP+KM*CM)**4
      AKCM=(CM*CM+KM*KM*CP*CP)/(CM+KM*CP)**4
      COLL=4.D0*( AKC*(-AE2*K*KM/KA+KM2)/KA
     Z          +AKCM*(-AE2*K*KM/KA1+KM2)/KA1)
     Z +2.D0*CS*KM*(   (-AM2*K/TK+KM2)/TK
     Z             +(-AM2*K/UK+KM2)/UK  )/Y2
      QEDTS2=ACOLL/COLL
      IF(QEDTS2.LT.0.D0) WRITE (IOUT,10) ACOLL,COLL,K,C,CG,CFIG
   10 FORMAT(/,20X,'TEST NEGATIVE',/,20X,6D15.7)
      RETURN
C
C...SOFT EVENT
C
    2 CP=0.5D0*CP
      CM=0.5D0*CM
      ALCP=DLOG(CP)
      ALCM=DLOG(CM)
      DARC=2.D0*ALFA/PI*(
     Z -0.5D0/CS*(C*(ALCP*ALCP+ALCM*ALCM)+2.D0*(CM*ALCP-CP*ALCM))
     Z +0.5D0*(ALCM*ALCM-ALCP*ALCP)  +DILOG1(CP)-DILOG1(CM) )
      DARC=DARC+4.D0*ALFA/PI*(ALCM-ALCP)*DLOG(K0)
      DWC=2.D0*CHI*(GV2+2.D0*C/CS)
      QEDTS2=(SOFT1 + DARC + DWC)/(SOFT1+DELW)
      IF(QEDTS2.LT.0.D0) WRITE (IOUT,10) K,C,SOFT1,DARC,DWC,DELW
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      DOUBLE PRECISION FUNCTION QEDTS4(DUMMY)
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      COMMON / OUT13 / K,C,Z,FI,FG
      COMMON / OUT12 / SC,SZ,CGAM,X
      COMMON/QED000/IOUT
      INTEGER       IOUT
c
C...COMPUTE RATIO BETWEEN EXACT CROSSECTION AND COLINEAR APPROXIMATION
C...IN BOTH EXPRESSIONS THERE IS AN OVERALL FACTOR
C...ALFA**3/8./PI**2/S LEFT OUT
c
      IF(K.EQ.0.D0) GO TO 1
c
C...HARD PART
C...CALCULATE ENERGY AND SCATTERING ANGLE OF THIRD PHOTON AS WELL
C...THIS IS NECESSARY TO CALCULATE SYMMETRIC APPROXIMANT
c
      X1=2.D0*E-K-X
      IF(X1.LE.0.D0)WRITE(5,11)X1
      IF(X1.LE.0.D0)WRITE(IOUT,11)X1
   11 FORMAT(1X,'  X1 <= 0',F20.16)
      C1=-(X*C+K*Z)/X1
      IF(DABS(C1).GT.1.D0)WRITE(5,12)C1
      IF(DABS(C1).GT.1.D0)WRITE(IOUT,12)C1
   12 FORMAT(1X,'  /C1/ > 1',F20.16)
c
C...CALCULATE VALUE OF APPROXIMANT AVERAGED OVER ALL PERMUTATIONS
c
      COLL=    PROXIM(  K,Z    ,X,C    ,X1,C1 )
     Z       + PROXIM(  X,C    ,X1,C1  ,K,Z   )
     Z       + PROXIM(  X1,C1  ,K,Z    ,X,C   )
     Z       + PROXIM(  X1,C1  ,X,C    ,K,Z   )
     Z       + PROXIM(  X,C    ,K,Z    ,X1,C1 )
     Z       + PROXIM(  K,Z    ,X1,C1  ,X,C   )
      IF(COLL.LE.0.D0) WRITE(5,13)ACOLL,K,C,Z
      IF(COLL.LE.0.D0) WRITE(IOUT,13)ACOLL,K,C,Z
   13 FORMAT('COLL <= 0',4D15.7)
c
C...CALCULATE EXACT CROSSECTION
c
      ACOLL=EXACT(K,Z,X,C,X1,C1)
      IF(ACOLL.LE.0.D0) WRITE(5,14)ACOLL,K,Z,X,C,X1,C1
      IF(ACOLL.LE.0.D0) WRITE(IOUT,14)ACOLL,K,Z,X,C,X1,C1
   14 FORMAT(1X,'  EXCT <= 0',7F15.6)
c
C...TEST IS THE RATIO BETWEEN THE TWO EXPRESSIONS
c
      QEDTS4=ACOLL/COLL
      RETURN
c
C...SOFT CASE
C...REMEMBER THAT THE C DISTRIBUTION IN THE SOFT PART IS NOT
C...GENERATED AS (1+C**2)/(1-C**2) BUT AS 2/(1-C**2)
c
    1 QEDTS4=1.D0 + BETA*LK0
     Z +ALFA/2.D0/PI*(LE*LE+PI2/3.D0+(E*E-C*C)/(E*E+C*C)*QED04Z(C))
c
C...NORMALIZE FOR CORRECT TOTAL NUMBER OF EVENTS
c
      QEDTS4=QEDTS4*SIG0/SIGA
c
C...NORMALIZE AGAIN FOR SLIGHTLY DIFFERENT ANGULAR DISTRIBUTION
c
      QEDTS4=QEDTS4*(1.D0+C*C)/2.D0*LE/(LE-1.D0)
      IF(QEDTS4.LE.0.D0) WRITE(5,21)QEDTS4,C
      IF(QEDTS4.LE.0.D0) WRITE(IOUT,21)QEDTS4,C
   21 FORMAT(1X,'TEST(K=0) <=0',2F20.16)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION RANP(IDUMMY)
c
      IMPLICIT NONE
c
      INTEGER *4 IDUMMY
c      INTEGER *4 LENV/1/
      REAL *4 RANP,RLU 
c
c-----------------------------------------------------------------------
c
c      CALL GRNDM(RVEC,LENV)

      RANP = RLU(0)   ! RNG enerator of jetset74
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION REPI1(S)
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
C-------------------------------------------- REMARKS -----------------
C VACUUM POLARIZATION IN QED. THE LEPTONIC CONTRIBUTION IS AN ANALYTIC
C EXPRESSION INVOLVING THE LEPTON MASS; THE HADRONIC CONTRIBUTION IS
C A DISPERSION INTEGRAL OVER THE KNOWN HADRONIC CROSS SECTION. THE
C RESULT USED HERE IS A PARAMETRIZATION GIVEN BY
C H.BURKHARDT, TASSO NOTE 192(1981).
C----------------------------------------------------------------------

C     Calling arguments

*
C     Local variables

*
C     External declarations


      DATA IFLAG/0/
c
      IF(S.LE.0.D0.OR .S.GT.100.D0) GOTO 311
1               FORMAT('0S=',F6.3,' GEV**2',/,
     *          ' VACUUM POLARIZATION MAY BE BADLY APPROXIMATED')
                IFLAG=1
311   X=DABS(S)
C-------------------------------------------- HADRONIC PART -----------
      IF(X.LT.1.)  REPI1= - 0.002302*DLOG(1.+4.091*X)
      I F(X.GE.1..AND.
     *   X.LT.64.) REPI1= - 0.002822*DLOG(1.+1.218*X) - 0.001512
      IF(X.GE.64.) REPI1= - 0.003068*DLOG(1.+      X) - 0.0011344
C-------------------------------------------- LEPTONIC PART -----------
      REPI1= REPI1 - 0.01045 - 0.002323*DLOG(X)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      SUBROUTINE VIRSOF(EB,XK0,OMX,BORN,CORR,CORR3)
C-------------------------------------------- REMARKS -----------------
C BHABHA SCATTERING DIFFERENTIAL CROSS SECTION WITH CORRECTIONS:
C 1) SELF-ENERGY DIAGRAMS FOR IN- AND OUTGOING LEPTONS;
C 2) VERTEX CORRECTION DIAGRAMS;
C 3) BOX DIAGRAMS (TWO-PHOTON EXCHANGE);
C 4) SOFT BREMSSTRAHLUNG (PHOTON ENERGY < XK0*EBEAM );
C 5) VACUUM POLARIZATION (PHOTON SELF-ENERGY DIAGRAMS);
C 6) INTERFERENCE BETWEEN PHOTON AND Z0 EXCHANGE GRAPHS.
C FORMULA AND CONVENTIONS TAKEN FROM:
C F.A.BERENDS ET AL, NUCL.PHYS.B68(1974)541.
C EB   = BEAM ENERGY IN GEV;
C XK0  = CUTOFF ON SOFT BREMSSTRAHLUNG ENERGY;
C X    = COSINE OF POLAR SCATTERING ANGLE OF POSITRON;
C OMX  = 1. - X
C BORN = LOWEST-ORDER DIFFERENTIAL CROSS SECTION IN NANOBARN;
C CORR = TOTAL OF CORRECTIONS GIVEN ABOVE.
C ASSUMED VALUES: 90 GEV FOR THE Z0 MASS, .23 FOR SIN**2(TH).
C----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)
c
C-------------------------------------------- LOWEST ORDER ------------
c
      X=1.D0-OMX
      OPX=1.D0+X
      X2=X*X
      X3=X2*X
      X4=X3*X
      XNUM=9.D0+6.D0*X2+X4
      BORN=1.295958D0/EB**2*XNUM/OMX**2
c
C-------------------------------------------- CORRECTIONS (NO VAC.POL.)
c
      U=2.D0*DLOG(3.9139D03*EB)
      V=U+DLOG(OPX)-0.6931472D0
      W=U+DLOG(OMX)-0.6931472D0
      CORR1=2.3228D-03*(
     .-4.D0*(1.D0-U+V-W)*DLOG(XK0) - 6.5797D0 + U*U - V*V + W*W
     .+ 2.*DILOG1(OPX/2.D0) - 2.*DILOG1(OMX/2.D0)
     .+ ( ( 1.-12.*X+12.*X2 -4.*X3 +3.*X4)*U
     .   -( 5. -7.*X +3.*X2    -X3       )*V
     .   +(31. +5.*X +9.*X2 +3.*X3       )*W
     .   +( 3. +7.*X -5.*X2 -3.*X3 -2.*X4)*U*U*.5
     .   +( 3. -3.*X    +X2    -X3       )*V*V
     .   -( 9. +7.*X+11.*X2 +5.*X3       )*W*W*.5
     .   -( 2.    -X           -X3       )*U*V*X*2.
     .   -(21. +3.*X +9.*X2 -3.*X3 +2.*X4)*U*W
     .   +( 6. +5.*X +4.*X2    +X3       )*V*W*2.
     .   -(36.      +24.*X2        +4.*X4)
     .   +(18.-15.*X+12.*X2 -3.*X3 +4.*X4)*3.2899)/XNUM)
c
C-------------------------------------------- VACUUM POLARIZATION -----
c
      CORR2=
     .(6.*X -6.*X2 +2.*X3 -2.*X4)*REPI1(4.*EB*EB)/XNUM+
     .(-18.-6.*X-6.*X2-2.*X3)*REPI1(-2.*EB*EB*OMX)/XNUM
c
C-------------------------------------------- INTERFERENCE WITH Z0 ----
c
      CORR3=XSWEAK(EB,9.D01,.23D0,OMX)/BORN
      CORR=CORR1+CORR2+CORR3
    1 FORMAT(10H0***VIRSOF,6D15.6)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION WEIZ(K,C)
C  ----------------------------------------------------------------------------
C...CALCULATE YES OR NO FOR REFLECTION OF Z TO -Z AFTER
C...GENERATING Z BY "GENCOS". THIS IS DONE BY CALCULATING THE
C...RATIO OF THE TWO COEFFICIENTS IN THE EXPRESSION FOR
C...THE Z DISTRIBUTION
C  ----------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
c
      KM=1.D0-K
      CM=1.D0-C/E
      CP=1.D0+C/E
      COEFZM=(CP+KM*KM*CM)*(2.D0-K*CP)
      COEFZP=(CM+KM**2*CP)*(2.D0-K*CM)
      WEIZ=COEFZM/(COEFZM+COEFZP)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION XSWEAK(EB,XMZ0,SIN2,OMX)

C-------------------------------------------- REMARKS -----------------
C BHABHA CROSS SECTION DUE TO INTERFERENCE OF THE PHOTON AND Z0 GRAPHS.
C EB  = BEAM ENERGY (GEV)
C XMZ0= Z0 MASS (GEV)
C SIN2= SIN(WEAK MIXING ANGLE)**2
C X   = COSINE OF POLAR SCATTERING ANGLE OF POSITRON
C OMX = 1. - X
C THE COUPLING CONSTANTS OF THE ELECTRONS TO THE Z0 ARE CALCULATED
C ACCORDING TO THE STANDARD SU(2)*U(1) MODEL, USING SIN2. THE MASS
C XMZ0 IS TREATED AS AN ADDITIONAL, INDEPENDENT PARAMETER.
C NEITHER THE PURE Z0 CHANNEL, NOR THE EFFECTS OF A NONZERO Z0 WIDTH
C ARE TAKEN INTO ACCOUNT ---> THIS ROUTINE IS NOT GOOD FOR LEP/SLC.
C----------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-H,O-Z)

      DATA INIT /0/
c
      IF(INIT.NE.0) GOTO 1
      INIT=1
C-------------------------------------------- INITIALIZATION ----------
      A2=1./(16.*SIN2*(1.-SIN2))
      VP=((1.-4.*SIN2)**2+1.)*A2
      VM=VP-2.*A2
      CHIQ=(XMZ0/EB)**2/2.
      XS=1./(1.-CHIQ/2.)
      FACT=5.183833D0/EB**2
C----------------------------------------------------------------------
    1 XM=OMX
      X =1.D0-OMX
      XP=(1.+X)**2
      XT=1./(1.+CHIQ/XM)
C      XSWEAK=FACT*( XS*( VP*XP + VM*XM**2 )/4.
C     .            + XT*( VP*XP + VM*4.    )/(XM*XM)
C     .        -(XS+XT)*( VP*XP            )/(2.*XM) )

      XSWEAK =          FACT*XS*(VP*XP+VM*XM**2)/4.
      XSWEAK = XSWEAK + FACT*XT*(VP*XP+VM*4.)/(XM*XM)
      XSWEAK = XSWEAK + FACT*(-1.0)*(XS+XT)*(VP*XP)/(2.*XM)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y2C(C)
c
C...CUMULATIVE INTEGRAL OVER SCATTERING ANGLE OF MU+
c
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,DUMMY,CG,FIG,FI
c
      DATA KOLD/-999.D0/
c
      IF(KOLD.EQ.K) GOTO 1
      KOLD=K
      KM=1.D0-K
      KM0=1.D0+KM
      KM1=1.D0+KM*KM
      KM2=KM1/K
      KMK=2.D0*KM/K
      FAC1=4.D0*(ALE*KM2-KMK)/K/K/K
      FAC2=(ALM+DLOG(KM))*KM2-KMK
    1 KC=K*C
      W=KM0*KM0-KC*KC
      ZZ1=-2.D0*KC/W
      ZZ2=2.D0*KM0*ZZ1/W
      ZZ3=(2.D0*KM0*ZZ2 - ZZ1)/W
      A1= - KM1*ZZ1 + 2.D0*KM*KM0*ZZ2 - 8.D0*KM*KM*ZZ3/3.D0
      A2=C*(1.D0+C*C/3.D0)
      Y2C=FAC1*A1 + FAC2*A2
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y2CG(CTH)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,C,CG,FIG,FI
c
      DATA COLD/-999./,KOLD/-99./
c
      IF(KOLD.EQ.K.AND.COLD.EQ.C) GOTO 11
      COLD=C
      KOLD=K
      KM=1.D0-K
      KM2=1.D0+KM*KM
      DEL=K*AM*AM/4.D0/KM
      S2=(1.D0-C)*(1.D0+C)
      AS=AE*AE*S2
      CP=1.D0+C
      CM=1.D0-C
      CS=1.D0+C*C
      AKC =(CP*CP+KM*KM*CM*CM)/(CP+KM*CM)**4
      AKCM=(CM*CM+KM*KM*CP*CP)/(CM+KM*CP)**4
C
   11 Y=2.D0-K+K*CTH
      X=2.D0*KM/Y
      W =CTH-E*C
      WM=CTH+E*C
      RC =DSQRT(W*W  +AS)
      RMC=DSQRT(WM*WM+AS)
      IF(W.GT.0.D0) WRC=RC+W
      IF(W.LE.0.D0) WRC=AS/(RC-W)
      IF(WM.GT.0.D0) WRMC=RMC+WM
      IF(WM.LE.0.D0) WRMC=AS/(RMC-WM)
      Y2CG=8.D0/K*(AKC *(KM2*DLOG(WRC )-KM*W /RC )
     Z            +AKCM*(KM2*DLOG(WRMC)-KM*WM/RMC)  )
      X1=1.D0-X+DEL
      X2=X-KM+DEL
      Y2CG=Y2CG
     Z +CS*(KM2/K*DLOG(X1/X2)+.5D0*AM*AM*(1.D0/X1-1.D0/X2))
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y2CSFT(C)
      DOUBLE PRECISION C,Y2CSFT
c
      Y2CSFT=C*(1.D0+C*C/3.D0)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y2FIG(FIG)
c
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)

      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON / OUTPAR / K,C,CG,DUMMY,FI
c
      DATA COLD/-99./,KOLD/-99./,CGOLD/-99./
c
      IF(COLD.EQ.C.AND.KOLD.EQ.K.AND.CGOLD.EQ.CG) GOTO 11
      COLD=C
      KOLD=K
      CGOLD=CG
      AE2=AE*AE
      AE3=0.5D0*AE2
      AM2=AM*AM
      S2=1.D0-C*C
      AS2=AE2*S2
      SG=DSQRT(1.D0-CG*CG)
      S =DSQRT(S2)
      RC =DSQRT((CG-E*C)**2+AS2)
      RMC=DSQRT((CG+E*C)**2+AS2)
      ABC =CG*C+SG*S
      ABCM=(1.D0+ABC)+AE3
      ABC =(1.D0-ABC)+AE3
      KM=1.D0-K
      KM2=1.D0+KM*KM
      CP=1.D0+C
      CM=1.D0-C
      CS=1.D0+C*C
      AKC =(CP*CP+KM*KM*CM*CM)/(CP+KM*CM)**4
      AKCM=(CM*CM+KM*KM*CP*CP)/(CM+KM*CP)**4
      Y=2.D0-K+K*CG
      X=2.D0*KM/Y
      DEL=AM2*K/4.D0/KM
      TK=2.D0*(X-KM+DEL)
      UK=2.D0*(1.D0-X+DEL)
      TT=(KM2-AM2*K/TK)/TK
      TU=(KM2-AM2*K/UK)/UK
      Y2=Y*Y
C
   11 CF=DCOS(FIG)
      SF=DSIN(FIG)
      SF1=DSIN(.5D0*FIG)
      CF1=DCOS(.5D0*FIG)
      ARGTC =DATAN(RC *SF1/ABC /CF1)
      ARGTMC=DATAN(RMC*SF1/ABCM/CF1)
      IF(CF1.GT.(0.D0))GO TO 1
      ARGTC =ARGTC +PI
      ARGTMC=ARGTMC+PI
c
    1 E1C =2.D0/RC*ARGTC
      E1MC=2.D0/RMC*ARGTMC
      ABCF =C*CG+S*SG*CF
      ABCFM=(1.D0+ABCF)+AE3
      ABCF =(1.D0-ABCF)+AE3
      E2C =( S*SG*SF/ABCF +(E-C*CG)*E1C )/RC /RC
      E2MC=(-S*SG*SF/ABCFM+(E+C*CG)*E1MC)/RMC/RMC
      TC =KM2*E1C -AE2*KM*E2C
      TMC=KM2*E1MC-AE2*KM*E2MC
      Y2FIG=4.D0/K*( AKC*TC + AKCM*TMC )
     Z    +2.D0*CS*KM*FIG*( TT + TU )/Y2
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y2K(K)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
c
      IF(K.GE.K0) GOTO 311
C...SOFT CASE ; CONSIDER SMEARED-OUT SPECTRUM BETEEN 0 AND K0
         Y2K=K/K0*SIG0*SOFT1
         RETURN
C...HARD CASE
311   Y2K=SIG0*(SOFT1+Y2KQ(DLOG(K/K0)) )
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y2KQ(KWW)
      IMPLICIT DOUBLE PRECISION(A-H,K,O-Z)
      COMMON / CONSTQ / E,AE,AM,ALE,ALM,ALL,PI,PI2,ALFA,BETA
      COMMON /CONST1/ CMAX,K0,KMIN,KMAX,SIG0,SOFT1,TRSHLD,CHI,GV2,DELW
c
      K=K0*DEXP(KWW)
      KM=1.D0-K
      DLKM=DLOG(KM)
      Y=-.5D0*ALE*(K+DLKM)
     Z  +.25D0*KM*(3.D0-K)*DLKM
     Z   -DILOG1(K)+K*(1.75D0-.125D0*K)-ALM*K*(1.D0-.25D0*K)
      Y2KQ=BETA*KWW+2.D0*ALFA/PI*Y
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y3K(K)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / GRENS / KMAX,A ,CMAX,SOFT,TRSHLD,K0
c
      Y3=SIG0*SOFT
      IF(K.LE.K0) Y3K=Y3*(K/K0)
      IF(K.GT.K0) Y3K=Y3 + SIG0*Y3KQ(DLOG(K/K0))
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y3KQ(QKQK)
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)

      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / GRENS / KMAX,A ,CMAX,SOFT,TRSHLD,K0
c
      K=K0*DEXP(QKQK)
      KM=1.D0-K
c
C finite contribution of hard bremsstrahlung
c
      FINITE=0.5D0*(-DLOG(KM)-K)
      IF(AMT.EQ.0.D0) GOTO 43
C
C mass effects of heavy particle
C
      G=(KMAX-K)/AMT
      IF(G.GT.0.001D0)GO TO 1
c
C...note that kmax=1-amt
C...X=SQRT(1-AMT/KM) or: KM=AMT*(1+EPS)...X=SQRT(EPS/(EPS+1))
c
      IF(G.GE.0.D0) GOTO 3
      X=0.D0
      GOTO 2
c
    3 X=DSQRT(G*(1.D0-G*(1.D0-G)))
      GO TO 2
c
    1 X =DSQRT(1.D0-AMT/KM)
c
    2 X0=DSQRT(1.D0-AMT)
      FINITE=FINITE+DLOG((1.D0+X0)/(1.D0+X))
     Z   +X*(1.D0-X*X/6.D0)-X0*(1.D0-X0*X0/6.D0)
C TOTAL CORRECTED CROSSECTION WITH EXPONENTIATION (LAB SYSTEM)
   43 Y3KQ=BETA*(FINITE+QKQK)
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      DOUBLE PRECISION FUNCTION Y3ZQ(ZQZQ)
c
C.....USE ZQZQ=1/(E-Z) IN RANGE Z=-1.0...+1.0
C....AND WITH Y3Z(Z)=FF(Z)-FF(-Z), USE ONLY FF(+Z) PART
C....IN CALLING ROUTINE FLIP COIN TO CHANGE Z >>> -Z
c
      IMPLICIT DOUBLE PRECISION(A-H,K-Z)
      COMMON / GETAL / BARN,PI,ALFA,BETA,DELTA,SIG0,AME,AMT,EME,S
      COMMON / OUT11 / K,Z,ZM,ZP,SZ,FG,SFG,CFG
c
      Z = EME - 1./ZQZQ
      KM=1.D0-K
      KM2=1.D0+KM*KM
c
C CUMULATIVE INTEGRAL OF Z IN LAB SYSTEM
c
      Y3ZQ=KM2*DLOG(ZQZQ)-Z*K*K/2.-AME*KM*ZQZQ
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y4CQ(CCC)
C  ---------------------------------------------------------------------------
C...CUMULATIVE INTEGRAL OVER "ORIGINAL" SCATTERING ANGLE
C...ONLY FOR HARD PART; FOR SOFT PART "GENCOS" IS USED
C...THERE IS AN OVERALL FACTOR 2.D0*ALFA**3/S*LOG(S/M**2)
C...WHICH IS LEFT OUT
C  ---------------------------------------------------------------------------
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
      COMMON / OUT13 / K,C,Z,FI,FG
C MODIFY.....Y4C IS SYMMETRIC....Y4C(-C) = - Y4C(+C)
C
C THUS POPULATE ONLY C=0....1, THEN THROW RANDOM SIGN CHOICE
C USE CCC=-LOG(1-C/ETA), ETA=1+MU
C
      C=(1.+MU)*(1.-DEXP(-CCC))
C      B1=CCC
      B1=DLOG(((1.+C)+MU)/((1.-C)+MU))
      B2=DLOG((2.D0-K*(1.D0-C))/(2.D0-K*(1.D0+C)))
      Y4CQ=(1.D0-K)/K*B1+1.D0/(2.D0+MU*K)*(B1+B2)
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y4K(K)
      IMPLICIT DOUBLE PRECISION (A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
c
      Y4K=Y4KQ(DLOG(K/K0))*2.*ALFA**3/S*LE + SIGA
c
      RETURN
      END
c
c-=---------------------------------------------------------------------
c
      FUNCTION Y4KQ(KLOG)
      IMPLICIT DOUBLE PRECISION(A-Z)

      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,K0,CMAX,BETA,
     *                SIG0,SIGA,SIGCOL,THRSLD,LK0
      DATA K000/-33.D0/
c
      IF(K000.EQ.K0) GOTO 311
         K000=K0
         KM0=1.D0-K0
         HRD0  =KM0*DLOG(KM0)-K0*(LE-1.D0)
c
C...CUMULATIVE PHOTON MOMENTUM INTEGRAL FOR K LARGER THAN K0
C...FINITE PART
c
311   K=K0*DEXP(KLOG)
      KM =1.D0-K
      KMLNKM=0.D0
c
CPCK  IF(KM.NE.0.D0)KMLNKM=KM*DLOG(KM)
      IF(KM.GT.0.000001D0)KMLNKM=KM*DLOG(KM)

      Y4KQ=KMLNKM-K*(LE-1.D0) - HRD0 + 2.*LE*KLOG
c
C...ADD VIRTUAL AND SOFT FINITE TERMS AND RETURN
c
      RETURN
      END




