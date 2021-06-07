C ---------------------------------------------------------------
C  generates photon, radiated from the initial state.
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
C  14.03.99 changed by Z.Silagadze -- bug in RCINTT fixed.
C                                     should not have effect.
C  18.03.99 changed by Z.Silagadze -- M>1 models are now allowed
C ----------------------------------------------------------------
       SUBROUTINE RCFTG(FunRand,EMIN,EMAX,CS0,BEN,N,E,FEN,FTH,FFI,M)
                   IMPLICIT NONE
          REAL EMIN,EMAX,E,FEN,FTH,FFI,EMEM,EMEMP,DLT,DLT1
          INTEGER N,i,fst,fnpp,M,MM,LOU,RCNONE
          DOUBLE PRECISION CS0(N),BEN(N),xmin,xmax,dx,RCINT,FunRand
          DOUBLE PRECISION me,pi,alp,kf,RCINTT,npp,EN,RCINTM
          DOUBLE PRECISION IIE(0:1000)
          DOUBLE PRECISION x,x1,x2,y,z,z1,z2,tnorm,enorm,tmax,qfth
          COMMON /UMBB05/me,pi,alp,kf, /E/EN, /RCLUN/LOU,RCNONE
          DATA EMEM/0.0/,IIE(0)/0.0D0/,EMEMP/0.0/
          DATA IIE(1000)/1.0D0/
          SAVE EMEM,IIE,npp,EMEMP
          real eemax, eemin
          logical userwarned
          data userwarned /.false./
          save userwarned

c --- decrease max. rad photon energy so that
c     max.photon is at min. cross section
          eemax = emax
          eemin = emin
          if ( eemax.GT.e*0.5d0-1.d0 ) then
            if ( .NOT.userwarned ) then
              write (6,*)
     &          'RCFTG warning: Emax is greater than Ebeam-1.'
              userwarned = .true.
            endif
            eemax = e*0.5d0-1.d0
          endif

          if ( e-eemax.LT.ben(1)+0.5d0 ) then
            if ( .NOT.userwarned ) then
              write (6,*)
     &          'RCFTG warning: Emax is below cross section edge'
              userwarned = .true.
            endif
            eemax = e - ben(1) - 0.5d0
          endif

          if ( eemin.GT.eemax ) then
            if ( .NOT.userwarned ) then
              userwarned = .true.
              write (6,*) 'RCFTG warning: Emin is greater than Emax'
            endif
            eemin = eemax
          endif
       
          MM=M
          IF(MM.LT.0) MM=-MM
         if(RCNONE.eq.1.and.MM.eq.1) MM=2

          EN=E
          fst=1
          fnpp=1
          IF(E.EQ.EMEM) fst=0
          IF(E.EQ.EMEMP) fnpp=0

C    check if photon is emited
          IF (fnpp.EQ.1) THEN
            if ( eemax.LT.0 ) then
              write (6,*)
     &          'RCFTG warning: trying to generate photon with E<0'
              npp = 1
            else
              CALL RCVCS(eemin,eemax,E,CS0,BEN,N,x,DLT,DLT1,M)
              npp = (1+DBLE(DLT1))/DBLE(DLT)
            endif
          endif

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
          xmin=2.0D0*(DBLE(eemin)/DBLE(E))
          xmax=2.0D0*(DBLE(eemax)/DBLE(E))
          dx=(xmax-xmin)/1.0D3

C                IF(M.EQ.1) THEN
C  Bonneau-Martin model ( Nucl. Phys. B27(1971), 381 
             IF(fst.EQ.1) THEN
               IF(MM.EQ.1) THEN
                 enorm=RCINT(xmin,xmax,CS0,BEN,N)
               ELSE
                 enorm=RCINTM(xmin,xmax,CS0,BEN,N,MM)
               END IF
                  DO 1 i=1,999
                    x=xmin+dx*i
               IF(MM.EQ.1) THEN
                    IIE(i)=RCINT(xmin,x,CS0,BEN,N)/enorm
               ELSE
                    IIE(i)=RCINTM(xmin,x,CS0,BEN,N,MM)/enorm
               END IF

1                 CONTINUE 
             END IF

             y=FunRand(0.0)
                 DO 2 i=0,1000
                  IF(IIE(i).GT.y) GO TO 3
2                CONTINUE

3         x1=xmin+(i-1)*dx
          x2=xmin+i*dx
          z1=y-IIE(i-1)
          z2=y-IIE(i)
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
C      Make all calculations in double precision
 4        qfth=(x1+x2)/2.0D0
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

C -------------------------------------------------------
C integral of photon angular distribution
C th - maximal angle theta
C -------------------------------------------------------
            DOUBLE PRECISION FUNCTION RCINTT(th,E,x)
             DOUBLE PRECISION th,x,me,alp,pi,kf,p,z,ee,zm,zx
             REAL E
             COMMON /UMBB05/me,pi,alp,kf

             ee=E/2.0D0
             p=DSQRT(ee**2-me**2)
             RCINTT=-0.5D0+DLOG(E/me)
             z=DLOG( (ee+p*DCOS(th))/(ee-p*DCOS(th)) )
             RCINTT=RCINTT-z/2.0D0
             zx=2.0D0*(x**2-2*x+2)
             z=x**2*DCOS(th)/zx
             RCINTT=RCINTT+z
             zm=(me/ee)**2
             z=DSIN(th)**2+zm*DCOS(th)**2
             zm=zm/z
             z=zm*DCOS(th)*( 0.5D0-(x**2/zx) )
             RCINTT=RCINTT+z

              END
              
              





