C -------------------------------------------------------------
C  generates photon, radiated from the initial state. (variant)
C  E=SQRT(s) - center of mass energy  (MeV)
C  FEN - photon energy  (MeV)
C  FTH - photon radiation angle theta (in radians)
C  FFI - photon radiation angle fi (in radians)
C  Probability that photon is not emited equals (1+DLT1)/DLT,
C  DLT1 and DLT being provided by the call of RCVCS.
C  If photon is not emited when FEN=0, FTH=0, FFI=0.
C  M=1 -- Bonneau-Martin model ( Nucl. Phys. B27(1971), 381 
C  change 11.12.97 by Al.Berdyugin
C  16.03.98 changed by Z.Silagadze      
C  19.03.99 changed by Z.Silagadze -- M>1 is now allowed
C --------------------------------------------------------------
       SUBROUTINE RCFTGM(FunRand,EMIN,EMAX,CS0,BEN,N,E,FEN,FTH,FFI,M)
                   IMPLICIT NONE
          REAL EMIN,EMAX,E,FEN,FTH,FFI,EMEM,EMEMP,DLT,DLT1
          INTEGER N,i,fst,fnpp,M,LOU,RCNONE
          DOUBLE PRECISION CS0(N),BEN(N),xmin,xmax,dx,RCINT,FunRand
          DOUBLE PRECISION me,pi,alp,kf,RCINTT,npp,EN,RCINTM
          DOUBLE PRECISION x,x1,x2,y,z,z1,z2,tnorm,enorm,tmax,qfth
          COMMON /UMBB05/me,pi,alp,kf, /E/EN, /RCLUN/LOU,RCNONE
          DATA EMEM/0.0/,EMEMP/0.0/
          SAVE EMEM,npp,EMEMP

             EN=E
             fst=1
             fnpp=1
          IF(E.EQ.EMEM) fst=0
          IF(E.EQ.EMEMP) fnpp=0

C    check if photon is emited
           IF(fnpp.EQ.1) THEN 
             CALL RCVCS(EMIN,EMAX,E,CS0,BEN,N,x,DLT,DLT1,M)
             npp=(1+DBLE(DLT1))/DBLE(DLT)
            END IF

              EMEMP=E
              y=FunRand(0.0)
             IF(y.LE.npp) THEN
C    no photon is emited !
                FEN=0.0
                FTH=0.0
                FFI=0.0
                RETURN
             END IF
     
C    generate photon energy
          xmin=2.0D0*(DBLE(EMIN)/DBLE(E))
          xmax=2.0D0*(DBLE(EMAX)/DBLE(E))

C                IF(M.EQ.1) THEN
C  Bonneau-Martin model ( Nucl. Phys. B27(1971), 381 
      
            IF(fst.EQ.1) THEN

             IF(M.EQ.1.OR.M.EQ.-1) THEN
              enorm=RCINT(xmin,xmax,CS0,BEN,N)
             ELSE
              enorm=RCINTM(xmin,xmax,CS0,BEN,N,M)
             END IF
           
            END IF
             y=FunRand(0.0)
          x1=xmin
          x2=xmax
          dx=x2-x1 
          z1=y
          z2=y-1
1         x=(x1+x2)/2.0D0
            IF(M.EQ.1.OR.M.EQ.-1) THEN
               z=y-RCINT(xmin,x,CS0,BEN,N)/enorm
            ELSE
               z=y-RCINTM(xmin,x,CS0,BEN,N,M)/enorm
            END IF
            IF(z1*z.GT.0) THEN
              x1=x
              z1=z
            ELSE IF(z1*z.LE.0) THEN
              x2=x
              z2=z
            END IF
          IF((x2-x1)/dx.GT.1.0D-4) GO TO 1
            x=(x1*z2-x2*z1)/(z2-z1)
               FEN=x*(E/2.0D0) 

C    generate angle fi
               y=FunRand(0.0)
          FFI=2.D0*y*pi

C    generate angle theta
          tmax=pi/2.0D0
          tnorm=RCINTT(tmax,E,x)

          y=FunRand(0.0)
          x1=0.0D0
          x2=tmax
          dx=x2-x1 
          z1=y
          z2=y-1
4         qfth=(x1+x2)/2.0D0
          z=y-RCINTT(qfth,E,x)/tnorm
            IF(z1*z.GT.0) THEN
              x1=qfth
              z1=z
            ELSE IF(z1*z.LE.0) THEN
              x2=qfth
              z2=z
            END IF
          IF((x2-x1)/dx.GT.1.0D-4) GO TO 4
            FTH=(x1*z2-x2*z1)/(z2-z1)

C     generate theta > pi/2 also
            y=FunRand(0.0)
          IF(y.GT.0.5D0) FTH=pi-FTH   

C                ELSE
C
C       WRITE(LOU,100)
C       WRITE(LOU,*) 'RCFTG: unknown model for radiative corrections!'
C       WRITE(LOU,*) '       programm interupted due to error.'
C       WRITE(LOU,100)  
C100     FORMAT(80('*'))
C          STOP
  
C                END IF 

            EMEM=E
 
           RETURN
           END 



