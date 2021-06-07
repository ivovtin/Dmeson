C********************************************************************
C    Set of functions to determine widths of 3pi decays
C          11.12.96  V.Ivanchenko  
C***************************************************************

c       REAL*8 FUNCTION Sp3Pi(E2)
C********************************************************************
C      The width of e+e- ->3pi decay  
C      Calculated widths are in array PS3PI(1000)
C      This function provides linear interpolation.
C      Avvakumov S.
C********************************************************************

c       implicit none	
c       include 'fitdata.inc'
c       REAL*8 E2
c       INTEGER*4 I
c       I = min(int((E2-EMIN)/ESTEP)+1,NPOINT-1)
c       Sp3Pi=( PS3PI(I)+((E2-EMIN)/ESTEP-float(I-1))
c     #         *(PS3PI(I+1)-PS3PI(I)) ) 
c       return
c       END



       REAL*8 FUNCTION Sp3PiI(E2)
C********************************************************************
C      Avvakumov S.  14.11.94
C      Ivanchenko V. 29.03.96
C********************************************************************

       implicit none	
       include 'fitdata.inc'
       EXTERNAL Sp3PiA
       REAL*8 E2,Y,X1,X2

       COMMON/AV000/Q2,SS
       REAL*8 Q2,SS

       SS=E2**2
       X1 = MsPi + MsPi
       X2 = E2 - MsPi0
       if(X2.le.X1)then
         Sp3PiI = 0.D0
       else  
         call SIMPS1(Y,X1,X2,Sp3PiA,1.D-6)
         Sp3PiI = 2.D0*Y*MsRho**3/Pi
       end if
       return
       END

       SUBROUTINE Sp3PiA(Y,X)
C********************************************************************
C      Avvakumov S.  14.11.94
C      Ivanchenko V. 29.03.96
C********************************************************************

       implicit none	
       include 'fitdata.inc'
       REAL*8 X,Y,WdRho2Pi,PhSp2
       EXTERNAL Sp3PiC
       COMPLEX*16 DpRho

       COMMON/AV000/Q2,SS
       REAL*8 Q2,SS,SS12,ZZZ

       SS12=sqrt(SS)
       Q2=X**2
       CALL SIMPS2(ZZZ,-1.D0,1.D0,Sp3PiC,1.D-6)
       ZZZ=1.D0+1.5D0*ZZZ
       Y=Q2*ZZZ*WdRho2Pi(X)*(PhSp2(SS12,X,MsPi)/MsRho)**3/
     *   cdabs(DpRho(Q2))**2

       return
       END

       SUBROUTINE Sp3PiC(Y,X)
C********************************************************************
C      Avvakumov S.  14.11.94
C      Ivanchenko V. 29.03.96
C********************************************************************

       implicit none	
       include 'fitdata.inc'
       REAL*8 X,Y,CcRho2Pi,QP2,Phsp2
       COMPLEX*16 DpRho,FP

       COMMON/AV000/Q2,SS
       REAL*8 Q2,SS,SS12

       REAL*8 Factor/1.D0/
       LOGICAL CCC/.false./,KLU/.true./
       SAVE CCC,KLU,Factor
 
       if(KLU)then
         KLU=.false.
         if(CCRho2Pi(MsRho*2.D0).ne.1.D0)CCC=.true.
       end if

       SS12=sqrt(SS)
       QP2=(SS+3.D0*MsPi**2-Q2)*0.5D0+
     *   X*PhSp2(SS12,sqrt(Q2),MsPi)*SS12*sqrt(1.D0-4.D0*MsPi**2/Q2)

       if(CCC)Factor=DSQRT(CcRho2Pi(sqrt(QP2))/CcRho2Pi(sqrt(Q2)))

       FP=(1.D0-X**2)*Factor*DpRho(Q2)/DpRho(QP2)
       Y=dreal(FP)

       return
       END
