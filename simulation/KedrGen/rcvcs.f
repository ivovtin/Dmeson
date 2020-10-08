C ---------------------------------------------------------------------
C calculates corrected cross section CSV=DLT*CS0
C at the energy E=SQRT(s).
C DLT1 - radiative correction
C DLT - the full correction, including radiative tail:
C DLT=1+DLT1+DLTB
C M=1 - Bonneau-Martin model ( Nucl. Phys. B27(1971), 381 )
C change 11.12.97 by Al.Berdyugin
C modified by Z.Silagadze 09.02.98 :
C M=2 - Bonneau-Martin model - a variant of calculation:
C the radiative tail is evaluated by SIMPS integration
C M=3 - Kuraev-Fadin model ( Yad. Fiz. 41(1985), 733 )
C       without pair-creation terms
C M=4 - Kuraev-Fadin model ( Yad. Fiz. 41(1985), 733 )
C       with pair-creation terms
C Soft photon terms are actually taken from Phys. Lett. 196(1987),551
C see also "Radiative corrections at DAPHNE" in DAPHNE Physics Handbook      
C
C modified by Z.Silagadze 16.02.98 :
C if RCNONE=1 Born cross-section is evaluated by using RCFUN      
C if RCNONE=1 and M=1, M=2 is assumed
C
C if M<0 model type is |M|, but vacuum polarization is not included
c
C modified by Z.Silagadze 30.03.98      
C
C modified by Z.Silagadze 18.03.99
C M=1 model will no longer depend on E_min
C but only E_min > 0.1 MeV is allowed
C
C modified by Z.Silagadze 28.03.99
C ----------------------------------------------------------------------
        subroutine rcvcs( EMIN, EMAX, E,CS0,BEN,N,CSV,DLT,DLT1,M)
        implicit none
        real emin, emax, e, CSV, DLT, DLT1   
        integer n, m,mm
        real*8 cs0(n), ben(n), eemin, eemax
        real*8 xxmin,ebm0

        integer lou, RCNONE,rcvp
        common /rclun/ lou, RCNONE
        common /rcvp/ rcvp
        real*8 en
        common /E/ EN
        real*8 me, pi, alp, kf
        common /UMBB05/ me,pi,alp,kf

        real*8 bt,Le,xm,vp
        common /RCBTLE/bt,Le,xm

      logical bornxsect
      double precision dreale
      integer procnum
      common /rcfun_cmn/ dreale, procnum, bornxsect

        complex PS
c --- functions
        real*8 rcsgm, rcint, rckfrf, rcsphf, rcfun, rcintm

c --- locals
        integer ier
        real*8 xmin, xmax, s0, s, ds, ymin, xwm, xwp, xfm, xfp
        data ymin /1.D-6/, ebm0/0.1D0/
        common /RCWFSP/ds, xwm, xwp, xfm, xfp 
        logical userwarned
        data userwarned /.false./
        save userwarned


        ds = -1.D-4
        eemin = emin
        eemax = emax

        if (M.LT.0) then
C  No vacuum polarization
          MM=-M
          rcvp=0
        else
          MM=M
          rcvp=1
        end if
        if(RCNONE.eq.1.and.MM.eq.1) MM=2

C  Check if EMAX<=E/2 and EMAX>EMIN 
        if (eemax.gt.0.5d0*e-1.) then
          if ( .NOT.userwarned ) then
            userwarned = .true.
            write (lou,55) eemax, e*0.5d0
55          format( ' RCVCS warning: Emax=',f7.0,' > Ebeam-1.=',f7.0 )
          endif
          eemax = 0.5D0*e - 1.
        endif

        if (eemin.gt.eemax) then
          if ( .NOT.userwarned ) then
            userwarned = .true.
            write (lou,65) eemin, eemax
65          format( ' RCVCS warning: Emin=',f7.0,' > Emax=',f7.0 )
          endif
          eemin = eemax
        endif

        en = e
        xmin = 2.0D0*(eemin/EN)
        if ( xmin.lt.ymin ) then
          xmin = ymin
        endif
        xxmin = 2.0D0*(ebm0/EN)
        xmax = 2.0D0*(eemax/EN)

        xwm = 1.D0-(807.23/EN)**2
        xwp = 1.D0-(756.65/EN)**2
        xfm = 1.D0-(1032.703/EN)**2
        xfp = 1.D0-(1006.123/EN)**2
        
        if (mm.eq.1.or.mm.eq.2) then
C  Bonneau-Martin model

          if (eemin.lt.0.1) xmin=0.2/EN

          DLT = -1.D0 + 2.D0*DLOG(EN/me)

C          DLT1 = DLT * ( 13.0D0/12.0D0 + DLOG(xmin) )
           DLT1 = DLT * ( 13.0D0/12.0D0 + DLOG(xxmin) )

          DLT1 = DLT1 - 17.0D0/36.0D0 + (pi/6.0D0)*pi
       IF(RCVP.EQ.0) DLT1=DLT1-0.66666667*DLOG(EN/me)+0.55555556
          DLT1 = kf*DLT1

         if (RCNONE.EQ.0) then
           s0 = rcsgm( cs0, ben, n, en, ier)
           if (ier.eq.1) goto 99
         else if (RCNONE.EQ.1) then
c --- added by BukinD on 2001-11-23 (see rcvcsm for details)
           bornxsect = .true.
           s0 = rcfun(en)
         end if
         bornxsect = .false.

         if(mm.eq.1.and.RCNONE.eq.0) then
         dlt1=dlt1+kf * rcint(xxmin,xmin,cs0,ben,n) * DLT/s0
         else
         dlt1=dlt1+kf*rcintm(xxmin,xmin,cs0,ben,n,mm)*DLT/s0
         end if
           
         if (mm.eq.1.and.RCNONE.eq.0) then
            dlt = kf * rcint(xmin,xmax,cs0,ben,n) * DLT
         else
            dlt = kf * rcintm(xmin,xmax,cs0,ben,n,mm) * DLT
         end if            

           CSV = (1+DLT1)*s0 + DLT

              if (s0.GT.0) then

             dlt = 1+DLT1+DLT/s0

              else
            
            dlt = 1
            goto 9999
          endif

        else if(mm.eq.3.or.mm.eq.4) then
C  Kuraev-Fadin model

          Le = 2.D0*DLOG(en/me)
          bt = 4.6456392D-3*(Le-1)
          xm = 4*me/en

C  Electron vacuum polarization          
        if (rcvp.eq.1) then
          PS=(Le/3.-0.55555556-(0.0,1.0471976))*2.3228196D-3
          vp=(1-PS)*CONJG(1-PS)
          vp=1./vp
        else if (rcvp.eq.0) then
          vp=1.
        end if
        
C  Born cross-section
         if (RCNONE.EQ.0) then
           s0 = rcsgm( cs0, ben, n, en, ier)
           if (ier.eq.1) goto 99
         else if (RCNONE.EQ.1) then
           bornxsect = .true.
           s0 = rcfun(en)
         end if           
         bornxsect = .false.

C  Soft photon part
         DLT1 = (ymin**bt)*rcsphf(1.D0)*vp*s0
         call RCKFRT(s,ymin,xmin,ds,N,MM,CS0,BEN)
         DLT1 = DLT1+s
         
C  Hard photon part (the radiative tail)

          CSV = DLT1 +  rcintm(xmin,xmax,cs0,ben,n,mm) 

          if (s0.GT.0) then
            dlt = CSV/s0
            DLT1 = DLT1/s0 - 1
          else
            dlt = 1
            goto 9999
          endif
          
          
        else

C    unknown model
          goto 999

        endif

        return

99      WRITE(LOU,100)
        WRITE(LOU,*) 'RCVCS: too high energy  E > BEN(N) !'
        WRITE(LOU,*) '       E= ',E,' and BEN(N)= ',BEN(N)
        WRITE(LOU,*) '       programm interupted due to error.'
        WRITE(LOU,100)
100     FORMAT(80('*')) 
        STOP

999     WRITE(LOU,100)
        WRITE(LOU,*) 'RCVCS: unknown model for radiative corrections!'
        WRITE(LOU,*) '       programm interupted due to error.'
        WRITE(LOU,100)  
        STOP

9999    if ( .NOT.userwarned ) then
          WRITE(LOU,100)
          WRITE (LOU,*)
     &      'RCVCS warning: zero cross section! DLT=1 is set.'
          WRITE(LOU,100)
          userwarned = .true.
        endif
        RETURN  

        END  


C ------------------------------------------------------------
C calculates integral for radiative tail in the small interval
C (ymin,BEN(i0)) , if i=0 ; or (BEN(in),ymax) , if i=-1 ; 
C or (BEN(i-1),BEN(i)) , if i>0 ;
C or (ymin,ymax) , if i=-2 ;
C ------------------------------------------------------------
        DOUBLE PRECISION FUNCTION rcisi(
     &    i, i0, in, ymin, ymax, CS0, BEN, N)
        IMPLICIT NONE
        DOUBLE PRECISION E,RCSGM,yi,yim,sgi,sgim,s1,s2,s3,sx
        DOUBLE PRECISION ymin,ymax
        INTEGER N,IER,i,i0,in 
        DOUBLE PRECISION CS0(N), BEN(N)
        COMMON /E/ E 
 
        IF(i.EQ.0) THEN
          ! interval ymin -- ben(i0)

          if (real(ymin).LT.ben(1)) then
            ! strange condition ???
            rcisi = 0.0D0
            return
          endif
          
          yim = ymin
          yi = BEN(i0)

          ! interval ymin -- ben(i0)
        else if (i.EQ.-1) then
          ! interval ben(in) -- ymax

          yim=BEN(in)
          yi=ymax

          ! interval ben(in) -- ymax
        else if (i.EQ.-2) then
          ! interval ymin -- ymax

          yim=ymin
          yi=ymax

          ! interval ymin -- ymax
        else if (i.GT.0) then
          ! interval ben(i-1) -- ben(i)

          yim=BEN(i-1)
          yi=BEN(i)

          ! interval ben(i-1) -- ben(i)
        endif         

        sgim = RCSGM(CS0,BEN,N,yim,IER)
        sgi =  RCSGM(CS0,BEN,N,yi,IER)

        if (yi-yim.LT.1.0D-6) then
          RCISI = 0.0D0
          RETURN
        endif  

C...........
        s1 = dlog( (1.0D0-(yim/E)**2) / (1.0D0-(yi/E)**2) )
        s1 = s1*( sgim*(yi/(yi-yim)) - sgi*(yim/(yi-yim)) )
        s2=( (yi+yim)/(2.0D0*E) )*( sgim*(yi/E)-sgi*(yim/E) )
        s3=( sgim*(yi/E)-sgi*(yim/E) )/4.0D0
        sx=(yi/E)**3+(yi/E)**2*(yim/E)+(yi/E)*(yim/E)**2+(yim/E)**3
        s3=s3*sx

        RCISI = s1-s2-s3

      s1=(yi/E)**4+(yi/E)**3*(yim/E)+(yi/E)**2*(yim/E)**2
      s1=s1+(yi/E)*(yim/E)**3+(yim/E)**4
      s1=s1/5.0D0
      s2=(yi/E)**2+(yi/E)*(yim/E)+(yim/E)**2
      s2=s2/3.0D0
      s3=(1-(yim/E))*(1+(yi/E))
      sx=(1-(yi/E))*(1+(yim/E))
      sx=s3/sx
      s3=E/(yi-yim)
      s3=s3*DLOG(sx)
      sx=(sgi-sgim)*(-2.0D0-s1-s2+s3)

        RCISI=RCISI+sx

              END

C ------------------------------------------------------------
C calculates integral for radiative tail for M=1 model
C ------------------------------------------------------------
       DOUBLE PRECISION FUNCTION RCINT(xmin,xmax,CS0,BEN,N)
               IMPLICIT NONE
         DOUBLE PRECISION xmin,xmax,ymin,ymax,E,RCISI
         INTEGER N,i,i0,in,RCCBEN,IER
         DOUBLE PRECISION CS0(N),BEN(N)
         COMMON /E/E
         
          ymin=E*DSQRT(1-xmax)
          ymax=E*DSQRT(1-xmin)

C    the first point for the integration interval division    
          i0=RCCBEN(-1.D0,ymin,BEN,N,1,N,IER)

C         DO 1 i=1,N
C          IF(BEN(i).GE.ymin) GO TO 2
C1        CONTINUE
C2         i0=i

C    the last point for the integration interval division
          in=RCCBEN(-1.D0,ymax,BEN,N,i0-1,N,IER)-1

C         DO 3 i=i0-1,N
C          IF(BEN(i).GE.ymax) GO TO 4
C3        CONTINUE
C4          in=i-1

         RCINT=0.0D0
            IF(in.LT.i0) THEN
         RCINT=RCISI(-2,i0,in,ymin,ymax,CS0,BEN,N)
            ELSE 

              IF(in.GT.i0) THEN
C    main part of the integral
        DO 5 i=i0+1,in 
          RCINT=RCINT+RCISI(i,i0,in,ymin,ymax,CS0,BEN,N)
5       CONTINUE
              END IF

C    add remaining part
        RCINT=RCINT+RCISI(0,i0,in,ymin,ymax,CS0,BEN,N)
        RCINT=RCINT+RCISI(-1,i0,in,ymin,ymax,CS0,BEN,N)

            END IF

              END

C ------------------------------------------------------------
C calculates integral for radiative tail for M.NE.1 models
C ------------------------------------------------------------
       DOUBLE PRECISION FUNCTION RCINTM(xmin,xmax,CS0,BEN,N,M)
               IMPLICIT NONE
         DOUBLE PRECISION xmin,xmax
         INTEGER N,M,MM
          real*8 ds
         DOUBLE PRECISION CS0(N),BEN(N),s,sm,xwm,xwp,xfm,xfp
         COMMON /RCWFSP/ds, xwm, xwp, xfm, xfp

            MM=M
         IF(MM.LT.0) MM=-MM

C separate w and phi mesons
           if (xmax.ge.xwp) then

             if (xmin.ge.xwp) then
                 call RCKFRT(s,xmin,xmax,ds,N,MM,CS0,BEN)
             else if (xmin.ge.xwm) then
                 call RCKFRT(sm,xwp,xmax,ds,N,MM,CS0,BEN)
                 call RCKFRT(s,xmin,xwp,ds,N,MM,CS0,BEN)
                 s=sm+s
             else if (xmin.ge.xfp) then
                 call RCKFRT(sm,xmin,xwm,ds,N,MM,CS0,BEN)
                 call RCKFRT(s,xwm,xwp,ds,N,MM,CS0,BEN)               
                 sm=sm+s
                 call RCKFRT(s,xwp,xmax,ds,N,MM,CS0,BEN)
                 s=sm+s
             else if (xmin.ge.xfm) then
               call RCKFRT(sm,xfp,xwm,ds,N,MM,CS0,BEN)
               call RCKFRT(s,xmin,xfp,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xwm,xwp,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xwp,xmax,ds,N,MM,CS0,BEN)               
               s=sm+s
             else   
               call RCKFRT(sm,xmin,xfm,ds,N,MM,CS0,BEN)              
               call RCKFRT(s,xfm,xfp,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xfp,xwm,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xwm,xwp,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xwp,xmax,ds,N,MM,CS0,BEN)
               s=sm+s
             end if     

           else if (xmax.ge.xwm) then

             if (xmin.ge.xwm) then
               call RCKFRT(s,xmin,xmax,ds,N,MM,CS0,BEN)
             else if (xmin.ge.xfp) then
                 call RCKFRT(sm,xmin,xwm,ds,N,MM,CS0,BEN)
                 call RCKFRT(s,xwm,xmax,ds,N,MM,CS0,BEN)               
                 s=sm+s
             else if (xmin.ge.xfm) then
               call RCKFRT(sm,xfp,xwm,ds,N,MM,CS0,BEN)
               call RCKFRT(s,xmin,xfp,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xwm,xmax,ds,N,MM,CS0,BEN)
               s=sm+s
             else   
               call RCKFRT(sm,xmin,xfm,ds,N,MM,CS0,BEN)              
               call RCKFRT(s,xfm,xfp,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xfp,xwm,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xwm,xmax,ds,N,MM,CS0,BEN)
               s=sm+s
             end if  
             
           else if (xmax.ge.xfp) then

             if (xmin.ge.xfp) then
               call RCKFRT(s,xmin,xmax,ds,N,MM,CS0,BEN)
             else if (xmin.ge.xfm) then
               call RCKFRT(sm,xfp,xmax,ds,N,MM,CS0,BEN)
               call RCKFRT(s,xmin,xfp,ds,N,MM,CS0,BEN)
               s=sm+s
             else 
               call RCKFRT(sm,xmin,xfm,ds,N,MM,CS0,BEN)
               call RCKFRT(s,xfm,xfp,ds,N,MM,CS0,BEN)
               sm=sm+s
               call RCKFRT(s,xfp,xmax,ds,N,MM,CS0,BEN)
               s=sm+s
             end if

           else if (xmax.ge.xfm) then               

             if (xmin.ge.xfm) then
               call RCKFRT(s,xmin,xmax,ds,N,MM,CS0,BEN)
             else 
               call RCKFRT(sm,xmin,xfm,ds,N,MM,CS0,BEN)
               call RCKFRT(s,xfm,xmax,ds,N,MM,CS0,BEN)
               s=sm+s
             end if              

           else
               
               call RCKFRT(s,xmin,xmax,ds,N,MM,CS0,BEN)

           end if

          RCINTM = s

           END


C ------------------------------------------------------------
C linear interpolation for the cross section
C RCSGM=0 if  E < BEN(1)  or  E > BEN(N)
C IER=1 - too high energy E > BEN(N)
C ------------------------------------------------------------
       DOUBLE PRECISION FUNCTION RCSGM(CS0,BEN,N,E,IER)
           IMPLICIT NONE
         INTEGER i,IER,N,RCCBEN
         REAL*8 E 
         DOUBLE PRECISION CS0(N),BEN(N)
            IER=0

        IF(E.LT.BEN(1)) THEN
            RCSGM=0.0D0
            RETURN
        END IF

C          DO 1 i=1,N
C            IF(REAL(BEN(i)).GE.E) GO TO 2
C1         CONTINUE
           
           i=RCCBEN(E,0.D0,BEN,N,1,N,IER)
             IF(IER.EQ.1) THEN
                RCSGM=0.0D0
                RETURN
             END IF 

2       RCSGM=CS0(i)*(E-BEN(i-1))
        RCSGM=RCSGM+CS0(i-1)*(BEN(i)-E)
        RCSGM=RCSGM/(BEN(i)-BEN(i-1))

               END

C -----------------------------------------------------------------
C finds such i=RCCBEN that BEN(i)>E (or >EE, if E<0).
C the interval from i1 to in is examined.
C IER=1 if BEN(N)<E (or <EE, if E<0).
C -----------------------------------------------------------------
        INTEGER FUNCTION RCCBEN(E,EE,BEN,N,ii1,iin,IER)
                    IMPLICIT NONE
            INTEGER i,i1,in,ii1,iin,imem,N,IER
            REAL*8 E
            DOUBLE PRECISION EE,BEN(N)

                    IER=0
                    i1=ii1
                    in=iin
                    imem=-1
     
            IF(E.LT.0) THEN

              IF(BEN(1).GT.EE) THEN
                  RCCBEN=1
                  RETURN
              ELSE IF(BEN(N).LT.EE) THEN
                  IER=1
                  RCCBEN=0
                  RETURN
              ELSE
1               i=INT(0.5+FLOAT(i1+in)/2.0)
                   IF(BEN(i).GE.EE) THEN
                       in=i
                       IF(i.EQ.imem) GO TO 2
                       imem=i
                   ELSE
                       i1=i
                   END IF
                        GO TO 1
2                   RCCBEN=i
              END IF
                   RETURN
  
            ELSE       

             IF(BEN(1).GT.E) THEN
                  RCCBEN=1
                  RETURN
              ELSE IF(BEN(N).LT.E) THEN
                  IER=1
                  RCCBEN=0
                  RETURN
              ELSE
3               i=INT(0.5+FLOAT(i1+in)/2.0)
                   IF(BEN(i).GE.E) THEN
                       in=i
                       IF(i.EQ.imem) GO TO 4
                       imem=i 
                   ELSE
                       i1=i
                   END IF
                       GO TO 3
4                  RCCBEN=i
              END IF 

            END IF
                   END  
               
C --------------------------------------------------------------------
C          Kuraev-Fadin "radiator" function
C M=3 -- no pair-creation terms
C M=4 -- with pair-creation terms
C Soft photon ters are taken from
C O.Nicrosini, L.Trentadue,   Phys. Lett. 196(1987), 551.
C See also "Radiative corrections at DAPHNE"
C by G.Colangelo, S.Dubnicka, M.Greco
C Frascati preprint LNF-92/023, 1992
C and in the DAPHNE Physics Handbook                   
C --------------------------------------------------------------------
              DOUBLE PRECISION FUNCTION RCKFRF(x,M)
                IMPLICIT NONE
                DOUBLE PRECISION x,xm,z2,z3,bt,Le,Y,alpi,alpi2
                DOUBLE PRECISION DLT1,DLT2,RCSPHF
                INTEGER M
                PARAMETER(z2=1.64493407D0,z3=1.2020569D0)
                PARAMETER(alpi=2.3228196D-3,alpi2=5.395491D-6)
                COMMON/RCBTLE/bt,Le,xm

               DLT1=alpi*(1.5*Le+2*(z2-1))
               DLT2=(1.125-2*z2)*Le**2+(3*z3+5.5*z2-2.8125)*Le
               DLT2=DLT2-1.2*z2**2-4.5*z3-3.7838831*z2+4.75
               DLT2=DLT2*alpi2

               Y=(1+DLT1+DLT2)*bt*x**(bt-1)
               Y=Y-0.5*bt*(2-x)
               RCKFRF=Y
               Y=(2-x)*(3*DLOG(1-x)-4*DLOG(x))
               Y=Y-4*DLOG(1-x)/x+x-6
               Y=0.125*Y*bt**2
               RCKFRF=RCKFRF+Y

               IF(M.EQ.4) THEN

                 IF(x.LT.xm) RETURN

                 Y=Le+2*DLOG(x)-1.6666667
                 Y=Y**2*(2-2*x+x**2+bt*Y*0.33333333)
                 Y=0.16666667*(Y/x)*(x-xm)**bt
                 Y=Y*alpi2
                 RCKFRF=RCKFRF+Y
                 Y=0.66666667*(1./(1-x)-(1-x)**2)
                 Y=Y+(2-x)*DLOG(1-x)+0.5*x
                 Y=0.5*(Le*alpi)**2
                 RCKFRF=RCKFRF+Y
               
               END IF
               RETURN

               ENTRY RCSPHF(x)
               
               DLT1=alpi*(1.5*Le+2*(z2-1))
               DLT2=(1.125-2*z2)*Le**2+(3*z3+5.5*z2-2.8125)*Le
               DLT2=DLT2-1.2*z2**2-4.5*z3-3.7838831*z2+4.75
               DLT2=DLT2*alpi2
               RCSPHF=1+DLT1+DLT2
               
                   END

C ----------------------------------------------------------------
C               Radiative tail 
C          integration as in mysimps of D.Bukin
C                   
                   SUBROUTINE RCKFRT(s,a,b,ds,N,MOD,CS0,BEN)
                 IMPLICIT NONE
                 INTEGER N,MOD,M

 	EXTERNAL RCHe
        REAL*8 S,A,B,DS,CS0(N),BEN(N)

      real*8 x1, x2
      real*8 precise

c --- locals
      integer indices(0:6)
      data indices / 0,2,4,1,3,4,3/
      save indices
      real*8 fval(0:6)
      real*8 step, sum, maxsum, partsum, parterr, neederr
      real*8 x, xc, rest, f
      integer index, saved, ind

      x1 = a
      x2 = b
      precise = ds

      step = (x2 - x1)/8.d0
      maxsum = 0.d0
      sum = 0.d0
      x = x1
      index = 0
      saved = 1
      rest = 1.

      do while ( rest.GT.1.d-5 )

        ind = 0
        do while ( ind.NE.3 )
          ! node filling
          ind = indices(index)
          xc = x + step*ind

          ! Function calculation
          call rche(f , xc, n, mod, cs0, ben)
c          write (6,*) 'rckfrt: xc,f:',xc,f
          fval(ind) = f

          index = index + 1
        enddo ! node filling
          
        ! get partial sum & desired error
        partsum = step/3. * (fval(0) + 4.d0*fval(1) + 2.d0*fval(2) +
     &    4.d0*fval(3) + fval(4))
        parterr = dabs(4.d0*step/90.d0 * (fval(0) - 4.d0*fval(1) +
     &    6.d0*fval(2) - 4.d0*fval(3) + fval(4)))
        maxsum = max( maxsum, abs(partsum) )
        if ( precise.GT.0 ) then
          ! absolute error
          neederr = precise
        else if ( precise.LT.0 ) then
          ! relative error
          neederr = - (precise*(maxsum+1.D-10))
        else
          write (6,*) 'presicion 0 not allowed'
          stop
        endif
          
        if ( maxsum.EQ.0.d0 .OR. parterr.LT.neederr ) then
          ! integral = 0. or required precision was achieved
          sum = sum + partsum
          fval(0) = fval(4)
          index = saved
          if ( index.GT.1 ) then
            saved = 1
            fval(2) = fval(5)
            fval(4) = fval(6)
          endif
          x = x + 4.d0*step
            
          ! check the rest
          rest = dabs( (x2-x)/step )
          if ( rest.LT.1.d-7 ) then
            ! integration finished - doing nothing
          else
            if ( parterr.LT.1.d-3*neederr ) then
              ! increasing the step
              step = step*2.d0
              rest = rest/2.
              if ( index.GT.1 ) then
                index = 5
                fval(1) = fval(2)
                fval(2) = fval(4)
              endif
            endif
            if ( rest.LT.4.1d0 ) then
              step = (x2-x)/4.d0
              index = 1
            endif
          endif
        else
          ! too great error - need to split interval
          step = step/2.d0
          ! save function values for the next interval
          saved = 3
          fval(6) = fval(4)
          fval(5) = fval(3)
          ! save function values for this interval
          fval(4) = fval(2)
          fval(2) = fval(1)
          index = 3
          maxsum = 0.d0 ! ??? added by BukinD (is it correct?)
          rest = 1.
        endif
      enddo ! while (rest>1.d-7)

      s = sum
      end
C
C ----------------------------------------------------------------            
C             
      subroutine rche(y,x,n,m,cs0,ben)
      implicit none     
      real*8 y,x,e,s, rcsgm, rckfrf, rcfun
      real*8 ex
      integer m,n,ier,lou,rcnone,rcvp
      common /e/e, /rcvp/ rcvp
      common /rclun/lou, rcnone
      real*8 cs0(n),ben(n),vp,bt,le,xm
      common/rcbtle/bt,le,xm
      complex ps

      ex = e*dsqrt(1-x)
      if (rcnone.eq.0) then
        s = rcsgm(cs0,ben,n,ex,ier)
      else if (rcnone.eq.1) then
        s = rcfun(ex)
      end if  
      
      if (m.eq.2) then
        y = s*(1-x+0.5*x**2)/x
        return
      else if (m.eq.3.or.m.eq.4) then
        y = s*rckfrf(x,m)
        
C  Electron vacuum polarization
        if (rcvp.eq.1) then
          ps=((le+dlog(1-x))/3.-0.55555556-(0.0,1.0471976))*2.3228196d-3
          vp=(1-ps)*conjg(1-ps)
          vp=1./vp
          
          y = y*vp
          
        end if          
      end if
c      write (6,*) 'rche: x,ex,s,y:',x,ex,s,y
      end

