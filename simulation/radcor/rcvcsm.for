C     ---------------------------------------------------------------------
C     calculates corrected cross section CSV=DLT*CS0
C     at the energy E=SQRT(s).
C     DLT1 - radiative correction
C     DLT - the full correction, including radiative tail:
C     DLT=1+DLT1+DLTB
C     M=1 - Bonneau-Martin model ( Nucl. Phys. B27(1971), 381 )
C     change 11.12.97 by Al.Berdyugin
C     modified by Z.Silagadze 09.02.98 :
C     M=2 - Bonneau-Martin model - a variant of calculation:
C     the radiative tail is evaluated by SIMPS integration
C     M=3 - Kuraev-Fadin model ( Yad. Fiz. 41(1985), 733 )
C     without pair-creation terms
C     M=4 - Kuraev-Fadin model ( Yad. Fiz. 41(1985), 733 )
C     with pair-creation terms
C     Soft photon terms are actually taken from Phys. Lett. 196(1987),551
C     see also "Radiative corrections at DAPHNE" in DAPHNE Physics Handbook      
C     
C     modified by Z.Silagadze 16.02.98 :
C     if N=0 Born cross-section is evaluated by using RCFUN      
C     if N=0 and M=1, M=2 is assumed
C     
C     if M<0 model type is |M|, but vacuum polarization is not included
c     
C     modified by Z.Silagadze 30.03.98      
c
c     28.07.98 - Modifications by A.Salnikov
c
c     1. Rename to rcvcsM to avoid name collision
c     2. all other subroutines were also renamed
c     3. signature of rcvcsM was changed - all parameters were made
c        double precision and RCFUN is paased as parameter
c     4. No need to call RCINI subroutine now, except for reading
c        c-s files, all other initializations were moved here
C     ----------------------------------------------------------------------

      subroutine rcvcsM( E, EMIN, EMAX, N, BEN, CS0, RCFUN, M,
     $     CSV, DLT, DLT1 )

      implicit none

      double precision e              ! c.m. energy
      double precision emin, emax     ! limits for the rad.gamma energy
      integer n                       ! num.points in ben() and cs0()
      double precision ben(n)         ! tabulated energy points
      double precision cs0(n)         ! tabulated cross-section
      double precision rcfun          ! user's function for born c.s.
      external rcfun                  !  called when N==0
      integer m                       ! mode 
      double precision csv            ! returned cross-section value
      double precision dlt            ! "Full" rad.correction
      double precision dlt1           ! "Soft" rad.correction

      include 'rcvcsinc.inc'

      integer NP_SOFT
      parameter (NP_SOFT=31)
      integer NP_HARD
      parameter (NP_HARD=3)

      double precision ymin
      parameter (ymin=1D-6)

c     --- locals
      double precision eemin, eemax
      integer mm
      double complex PS
      integer ier
      double precision vp
      double precision xmin, xmax
      double precision s0, s

      logical userwarned /.false./
      save userwarned

      logical needsInit /.true./
      save needsInit

c     --- functions
      double precision rcm_rcsgm, rcm_rcint, rcm_rckfrf,
     $     rcm_rcsphf, rcm_rckfrt
      external rcm_rcsgm, rcm_rcint, rcm_rckfrf,
     $     rcm_rcsphf, rcm_rckfrt

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

c     === make a one-time init ===
      if ( needsInit ) then 
         call rcm_initDefBen
         needsInit = .false.
      endif


      eemin = emin
      eemax = emax

      if (M.LT.0) then
C        No vacuum polarization
         MM=-M
         rcvp=0
      else
         MM=M
         rcvp=1
      end if
      if( N.eq.0 .and. MM.eq.1 ) MM=2

C     Check if EMAX<=E/2 and EMAX>EMIN 
      if (eemax.ge.0.5d0*e-1.) then
         if ( .NOT.userwarned ) then
            userwarned = .true.
            print 55, eemax, e*0.5d0
 55         format( ' RCVCS warning: Emax=',f7.0,' > Ebeam=',f7.0 )
         endif
         eemax = 0.5D0*e - 1.
      endif

      if (eemin.gt.eemax) then
         if ( .NOT.userwarned ) then
            userwarned = .true.
            print 65, eemin, eemax
 65         format( ' RCVCS warning: Emin=',f7.0,' > Emax=',f7.0 )
         endif
         eemin = eemax
      endif

      cmEnergy = e
      xmin = 2.0D0*(eemin/cmEnergy)
      if ( xmin.lt.ymin ) then
        xmin = ymin
      endif
      xmax = 2.0D0*(eemax/cmEnergy)

      if ( mm.eq.1 .or. mm.eq.2 ) then

c        ===================================
C               Bonneau-Martin model
c        ===================================

c        ---> born c-s
         if (N.gt.1) then
            s0 = rcm_rcsgm( cs0, ben, n, cmEnergy, ier)
            if (ier.eq.1) goto 99
         else
c --- added by BukinD on 2001-11-23
c     this s0 cross-section can be pure born cross-section
c     w/o efficiency.  The flag bornxsect in rcfun_cmn
c     can be used to control this feature.
c     The default behaviour is to use pure cross-section.
c     If you really want cross-section with efficiency,
c     override rcfun() function.
            bornxsect = .true.
            s0 = rcfun(cmEnergy)
         end if
         bornxsect = .false.

c        ---> soft photon part
         DLT = -1.D0 + 2.D0*DLOG(cmEnergy/mass_e)
         DLT1 = DLT * ( 13.0D0/12.0D0 + DLOG(xmin) )
         DLT1 = DLT1 - 17.0D0/36.0D0 + (pi/6.0D0)*pi
         IF(RCVP.EQ.0)
     $        DLT1=DLT1-0.66666667*DLOG(cmEnergy/mass_e)+0.55555556
         DLT1 = alpha2pi*DLT1

         CSV = (1+DLT1)*s0
c         print 1000,0.0,xmin,csv
c 1000    format ('RCVCSM(soft) -- xmin:',F10.8,
c     $        '  xmax:',F10.8,'  s:',F10.7)

c        ---> hard photon part
         if ( mm.eq.1 .and. N.gt.1 ) then

            s = alpha2pi*dlt*rcm_rcint(xmin,xmax,cs0,ben,n)

         else

            if ( N.gt.1 ) then 
               s = alpha2pi*dlt*
     $              RCM_RCKFRT(xmin,xmax,N,BEN,CS0,rcfun,NP_HARD,MM)
            else
               s = alpha2pi*dlt*RCM_RCKFRT(xmin,xmax,
     $              -defBenLen,defBen,CS0,rcfun,NP_HARD,MM)
            endif

         end if

c         print 1001,xmin,xmax,s
c 1001    format ('RCVCSM(hard) -- xmin:',F10.8,
c     $        '  xmax:',F10.8,'  s:',F10.7)
         
         CSV = CSV + s

         if (s0.GT.0) then

            dlt = csv / s0

         else
            
            dlt = 1
            goto 9999

         endif

      else if ( mm.eq.3 .or. mm.eq.4 ) then

c        ===================================
C                Kuraev-Fadin model
c        ===================================

         Le = 2.D0*DLOG(cmEnergy/mass_e)
         bt = 4.6456392D-3*(Le-1)
         xm = 4*mass_e/cmEnergy

C        ---> Electron vacuum polarization          
         if (rcvp.eq.1) then
            PS=(Le/3.-0.55555556-(0.0,1.0471976))*2.3228196D-3
            vp=(1-PS)*CONJG(1-PS)
            vp=1./vp
         else if (rcvp.eq.0) then
            vp=1.
         end if
         
C        ---> Born cross-section
         if ( N.gt.1 ) then
            s0 = rcm_rcsgm( cs0, ben, n, cmEnergy, ier)
            if (ier.eq.1) goto 99
         else
            bornxsect = .true.
            s0 = rcfun(cmEnergy)
         end if
         bornxsect = .false.

C        ---> Soft photon part
         DLT1 = (ymin**bt)*rcm_rcsphf(1.D0)*vp*s0
         if ( N.gt.1 ) then 
            s = RCM_RCKFRT(ymin,xmin,N,BEN,CS0,rcfun,NP_SOFT,MM)
         else
            s = RCM_RCKFRT(ymin,xmin,-defBenLen,defBen,CS0,
     $           rcfun,NP_SOFT,MM)
         endif
         DLT1 = DLT1+s
c         print 1000,0.0,xmin,dlt1
         
C        ---> Hard photon part (the radiative tail)
         if ( N.gt.1 ) then 
            s = RCM_RCKFRT(xmin,xmax,N,BEN,CS0,rcfun,NP_HARD,MM)
         else
            s = RCM_RCKFRT(xmin,xmax,-defBenLen,defBen,CS0,rcfun,
     $           NP_HARD,MM)
         endif
         CSV = DLT1 + s
c         print 1001,xmin,xmax,s

         if (s0.GT.0) then
            dlt = csv / s0
            DLT1 = DLT1 / s0 - 1
         else
            dlt = 1
            goto 9999
         endif
         
         
      else

C        unknown model
         goto 999

      endif

      return

 99   print 100
      print *, 'RCVCS: too high energy  E > BEN(N) !'
      print *, '       E= ',E,' and BEN(N)= ',BEN(N)
      print *, '       programm interupted due to error.'
      print 100
 100  FORMAT(80('*')) 
      STOP

 999  print 100
      print *, 'RCVCS: unknown model for radiative corrections!'
      print *, '       programm interupted due to error.'
      print 100
      STOP

 9999 if ( .NOT.userwarned ) then
         print 100
         print *,
     &        'RCVCS warning: zero cross section! DLT=1 is set.'
         print 100
         userwarned = .true.
      endif
      RETURN  

      END  


C     ------------------------------------------------------------
C     calculates integral for radiative tail in the small interval
C     (ymin,BEN(i0)) , if i=0 ; or (BEN(in),ymax) , if i=-1 ; 
C     or (BEN(i-1),BEN(i)) , if i>0 ;
C     or (ymin,ymax) , if i=-2 ;
C     ------------------------------------------------------------
      DOUBLE PRECISION FUNCTION rcm_rcisi(
     $     i, i0, in, ymin, ymax, CS0, BEN, N)
      IMPLICIT NONE

      INTEGER i,i0,in 
      DOUBLE PRECISION ymin,ymax
      INTEGER N
      DOUBLE PRECISION CS0(N), BEN(N)

      include 'rcvcsinc.inc'

      INTEGER IER
      double precision yi,yim,sgi,sgim
      double precision s1,s2,s3,sx
      
      DOUBLE PRECISION RCM_RCSGM
      external RCM_RCSGM

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      IF(i.EQ.0) THEN
                                ! interval ymin -- ben(i0)

         if ( ymin.LT.ben(1)) then
                                ! strange condition ???
            rcm_rcisi = 0.0D0
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

      sgim = RCM_RCSGM(CS0,BEN,N,yim,IER)
      sgi =  RCM_RCSGM(CS0,BEN,N,yi,IER)

      if (yi-yim.LT.1.0D-6) then
         RCM_RCISI = 0.0D0
         RETURN
      endif  

C...........
      s1 = dlog( (1.0D0-(yim/cmEnergy)**2) / (1.0D0-(yi/cmEnergy)**2) )
      s1 = s1*( sgim*(yi/(yi-yim)) - sgi*(yim/(yi-yim)) )
      s2=( (yi+yim)/(2.0D0*cmEnergy) )*
     $     ( sgim*(yi/cmEnergy)-sgi*(yim/cmEnergy) )
      s3=( sgim*(yi/cmEnergy)-sgi*(yim/cmEnergy) )/4.0D0
      sx=(yi/cmEnergy)**3+(yi/cmEnergy)**2*(yim/cmEnergy)+
     $     (yi/cmEnergy)*(yim/cmEnergy)**2+(yim/cmEnergy)**3
      s3=s3*sx

      RCM_RCISI = s1-s2-s3

      s1=(yi/cmEnergy)**4+(yi/cmEnergy)**3*(yim/cmEnergy)+
     $     (yi/cmEnergy)**2*(yim/cmEnergy)**2
      s1=s1+(yi/cmEnergy)*(yim/cmEnergy)**3+(yim/cmEnergy)**4
      s1=s1/5.0D0
      s2=(yi/cmEnergy)**2+(yi/cmEnergy)*(yim/cmEnergy)+(yim/cmEnergy)**2
      s2=s2/3.0D0
      s3=(1-(yim/cmEnergy))*(1+(yi/cmEnergy))
      sx=(1-(yi/cmEnergy))*(1+(yim/cmEnergy))
      sx=s3/sx
      s3=cmEnergy/(yi-yim)
      s3=s3*DLOG(sx)
      sx=(sgi-sgim)*(-2.0D0-s1-s2+s3)

      RCM_RCISI=RCM_RCISI+sx

      END

C     ------------------------------------------------------------
C     calculates integral for radiative tail 
C     ------------------------------------------------------------

      DOUBLE PRECISION FUNCTION RCM_RCINT(xmin,xmax,CS0,BEN,N)

      IMPLICIT NONE

      DOUBLE PRECISION xmin,xmax
      INTEGER N
      DOUBLE PRECISION CS0(N),BEN(N)

      include 'rcvcsinc.inc'

      DOUBLE PRECISION ymin,ymax
      INTEGER i,i0,in,IER

      integer RCM_BSEARCH
      external RCM_BSEARCH
      DOUBLE PRECISION RCM_RCISI
      external RCM_RCISI
      
c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      ymin=cmEnergy*DSQRT(1-xmax)
      ymax=cmEnergy*DSQRT(1-xmin)

C     the first point for the integration interval division    
      i0=RCM_BSEARCH(ymin,BEN,1,N,IER)

C     the last point for the integration interval division
      in=RCM_BSEARCH(ymax,BEN,i0-1,N,IER)-1

      RCM_RCINT=0.0D0
      IF(in.LT.i0) THEN
         RCM_RCINT=RCM_RCISI(-2,i0,in,ymin,ymax,CS0,BEN,N)
      ELSE 

         IF(in.GT.i0) THEN
C           main part of the integral
            DO 5 i=i0+1,in 
               RCM_RCINT = RCM_RCINT +
     $              RCM_RCISI(i,i0,in,ymin,ymax,CS0,BEN,N)
 5          CONTINUE
         END IF

C        add remaining part
         RCM_RCINT = RCM_RCINT +
     $        RCM_RCISI(0,i0,in,ymin,ymax,CS0,BEN,N)
         RCM_RCINT = RCM_RCINT +
     $        RCM_RCISI(-1,i0,in,ymin,ymax,CS0,BEN,N)

      END IF

      END

C     ------------------------------------------------------------
C     linear interpolation for the cross section
C     RCM_RCSGM=0 if  E < BEN(1)  or  E > BEN(N)
C     IER=1 - too high energy E > BEN(N)
C     ------------------------------------------------------------

      DOUBLE PRECISION FUNCTION RCM_RCSGM(CS0,BEN,N,E,IER)

      IMPLICIT NONE

      INTEGER N
      DOUBLE PRECISION CS0(N),BEN(N)
      DOUBLE PRECISION E 
      INTEGER IER

      INTEGER i

      integer RCM_BSEARCH
      external RCM_BSEARCH

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      IER=0

      IF(E.LT.BEN(1)) THEN
         RCM_RCSGM=0.0D0
         RETURN
      END IF

      i=RCM_BSEARCH(E,BEN,1,N,IER)
      IF(IER.EQ.1) THEN
         RCM_RCSGM=0.0D0
         RETURN
      END IF 

      RCM_RCSGM = ( CS0(i)*(E-BEN(i-1)) + CS0(i-1)*(BEN(i)-E) ) /
     $     (BEN(i)-BEN(i-1))

      END

C     -----------------------------------------------------------------
C     finds first i so that BEN(i)>E.
C     the interval from i1 to in is examined.
C     IER=1 if BEN(N)<E
C     -----------------------------------------------------------------

      INTEGER FUNCTION RCM_BSEARCH(E,BEN,ii1,iin,IER)

      IMPLICIT NONE

      double precision E
      double precision BEN(*)
      integer ii1
      integer iin
      integer IER

      INTEGER i,i1,in,imem

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      IER=0
      i1=ii1
      in=iin
      imem=-1
      
      IF(BEN(i1).GT.E) THEN
         RCM_BSEARCH=i1
         RETURN
      ELSE IF(BEN(in).LT.E) THEN
         IER=1
         RCM_BSEARCH=0
         RETURN
      ELSE
 3       i=INT(0.5+FLOAT(i1+in)/2.0)
         IF(BEN(i).GE.E) THEN
            in=i
            IF(i.EQ.imem) GO TO 4
            imem=i 
         ELSE
            i1=i
         END IF
         GO TO 3
 4       RCM_BSEARCH=i
      END IF 
      
      END  
      
C     --------------------------------------------------------------------
C     Kuraev-Fadin "radiator" function
C     M=3 -- no pair-creation terms
C     M=4 -- with pair-creation terms
C     Soft photon ters are taken from
C     O.Nicrosini, L.Trentadue,   Phys. Lett. 196(1987), 551.
C     See also "Radiative corrections at DAPHNE"
C     by G.Colangelo, S.Dubnicka, M.Greco
C     Frascati preprint LNF-92/023, 1992
C     and in the DAPHNE Physics Handbook                   
C     --------------------------------------------------------------------

      DOUBLE PRECISION FUNCTION RCM_RCKFRF(x,M)

      IMPLICIT NONE

      DOUBLE PRECISION x
      INTEGER M

      include 'rcvcsinc.inc'

      DOUBLE PRECISION z2,z3
      PARAMETER(z2=1.64493407D0,z3=1.2020569D0)
      DOUBLE PRECISION alpi,alpi2
      PARAMETER(alpi=2.3228196D-3,alpi2=5.395491D-6)

      DOUBLE PRECISION Y
      DOUBLE PRECISION DLT1,DLT2

      DOUBLE PRECISION RCM_RCSPHF

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      DLT1=alpi*(1.5*Le+2*(z2-1))
      DLT2=(1.125-2*z2)*Le**2+(3*z3+5.5*z2-2.8125)*Le
      DLT2=DLT2-1.2*z2**2-4.5*z3-3.7838831*z2+4.75
      DLT2=DLT2*alpi2

      Y=(1+DLT1+DLT2)*bt*x**(bt-1)
      Y=Y-0.5*bt*(2-x)
      RCM_RCKFRF=Y
      Y=(2-x)*(3*DLOG(1-x)-4*DLOG(x))
      Y=Y-4*DLOG(1-x)/x+x-6
      Y=0.125*Y*bt**2
      RCM_RCKFRF=RCM_RCKFRF+Y

      IF(M.EQ.4) THEN

         IF(x.LT.xm) RETURN

         Y=Le+2*DLOG(x)-1.6666667
         Y=Y**2*(2-2*x+x**2+bt*Y*0.33333333)
         Y=0.16666667*(Y/x)*(x-xm)**bt
         Y=Y*alpi2
         RCM_RCKFRF=RCM_RCKFRF+Y
         Y=0.66666667*(1./(1-x)-(1-x)**2)
         Y=Y+(2-x)*DLOG(1-x)+0.5*x
         Y=0.5*(Le*alpi)**2
         RCM_RCKFRF=RCM_RCKFRF+Y
         
      END IF
      RETURN

      ENTRY RCM_RCSPHF(x)
      
      DLT1=alpi*(1.5*Le+2*(z2-1))
      DLT2=(1.125-2*z2)*Le**2+(3*z3+5.5*z2-2.8125)*Le
      DLT2=DLT2-1.2*z2**2-4.5*z3-3.7838831*z2+4.75
      DLT2=DLT2*alpi2
      RCM_RCSPHF=1+DLT1+DLT2
      
      END

C     ----------------------------------------------------------------
c     Integration. Whole interval from xmin to xmax is divided into 
c     subintervals by some points from BEN() array, and these subintervals
c     are integrated by rcm_intbin function. When N>0 tabulated values of c-s
c     from CS0() array are used, otherwise RCFUN function is called.
c

      double precision function RCM_RCKFRT(xmin, xmax,
     $     N, BEN, CS0, RCFUN, NP, MOD)

      IMPLICIT NONE

      DOUBLE PRECISION xmin, xmax ! Limits
      INTEGER N                   ! Dimensionality of CS0 and BEN
                                  ! or neg.dim of BEN when RCFUN is used
      double precision BEN(1)     
      DOUBLE PRECISION CS0(1)
      double precision rcfun      ! User's function for Born c.s
      external rcfun
      INTEGER NP                  ! Number of points for integration (3,5,...)
      INTEGER MOD

      include 'rcvcsinc.inc'

c     --- locals
      logical useRcfun
      integer BenLen
      double precision sum        ! Result of integration
      double precision emin, emax
      double precision s, snext
      integer imin, imax, i
      integer ier

c     --- statement function below
      double precision cs
      double precision e
      
      integer rcm_bsearch
      external rcm_bsearch
      double precision rcm_intbin
      external rcm_intbin

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

c     --- linear interpolation of c-s on i-th energy interval
      cs(e,i) = ( cs0(i)*(ben(i+1)-e) + cs0(i+1)*(e-ben(i)) ) /
     $     (ben(i+1)-ben(i))


      useRcfun = N.lt.0
      BenLen = abs(N)

c     ---> energy limits
      emax = cmEnergy * sqrt( 1 - xmin )
      emin = cmEnergy * sqrt( 1 - xmax )

c     ---> find imin and imax so that Emin<Ben(imin) and Emax>Ben(imax)
      imin = rcm_bsearch ( emin, ben, 1, BenLen, ier )
      if ( ier .ne. 0 ) then
         print *, 'RCM_RCKFRT: Cannot find point ', emin
         rcm_rckfrt = 0
         return
      end if 
      imax = rcm_bsearch ( emax, ben, imin, BenLen, ier ) - 1
      if ( ier .ne. 0 ) then
         print *, 'RCM_RCKFRT: Cannot find point ', emin
         rcm_rckfrt = 0
         return
      end if 

c      print 1000,emin,imin,ben(imin),emax,imax,ben(imax)
c 1000 format ( 'RCM_RCKFRT: Emin=',F8.3,' <= Ben(',i4,')=',F8.3,
c     $     '  Emax=',F8.3,' >= Ben(',i4,')=',F8.3 )


      if ( imax .lt. imin ) then

c        --- both xmin and xmax lie in the same bin - no need to divide
c        --- this interval

         if ( useRcfun ) then
            s = rcfun(emin)
            snext = rcfun(emax)
         else
            s = cs(emin,max(imin-1,1))
            snext = cs(emax,min(imax,N-1))
         end if
         
         sum = 0
         if ( s.gt.0 .and. snext.gt.0 ) then
            sum = sum + rcm_intbin ( emin, emax, s, snext, np, MOD )
         end if

      else 

         sum = 0

         if ( useRcfun ) then
            s = rcfun(emin)
            snext = rcfun(ben(imin))
         else
            s = cs(emin,max(imin-1,1))
            snext = cs0(imin)
         end if

c        low-energy remainder from Emin to Ben(imin)
         if ( s.gt.0 .and. snext.gt.0 .and. emin .lt. ben(imin) ) then
            sum = sum +
     $           rcm_intbin ( emin, ben(imin), s, snext, np, MOD )
         end if

c        central part from Ben(imin) to Ben(imax)
         do i = imin, imax-1
            
            s = snext
            if ( useRcfun ) then
               snext = rcfun(ben(i+1))
            else
               snext = cs0(i+1)
            end if

            if ( s.gt.0 .and. snext.gt.0 ) then
               sum = sum + rcm_intbin ( ben(i), ben(i+1), s, snext,
     $              np, MOD )
            end if

         end do

c        high-energy remainder from Ben(imax) to Emax
         s = snext
         if ( useRcfun ) then
            snext = rcfun(emax)
         else
            snext = cs(emax,min(imax,N-1))
         end if
         if ( s.gt.0 .and. snext.gt.0 ) then
            sum = sum +
     $           rcm_intbin ( ben(imax), emax, s, snext, np, MOD )
         end if
         
      end if

c      print *,'RCM_RCKFRT -- xmin:',xmin,'  xmax:',xmax,'  s:',s

      rcm_rckfrt = sum

      end

     
C     ----------------------------------------------------------------
C     Calculation of the probabilty function for the photon
C     ----------------------------------------------------------------
     
      double precision function Rcm_Rche(x,MODE)

      IMPLICIT NONE     
      
      DOUBLE PRECISION x
      INTEGER MODE

      include 'rcvcsinc.inc'

      DOUBLE PRECISION Y
      DOUBLE PRECISION vp
      double COMPLEX PS

      DOUBLE PRECISION RCM_RCKFRF
      external RCM_RCKFRF

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      IF (MODE.EQ.2) THEN
         Y = (1-x+0.5*x**2)/x
      ELSE IF (MODE.EQ.3.OR.MODE.EQ.4) THEN
         Y = RCM_RCKFRF(x,MODE)
         
C        Electron vacuum polarization
         IF (RCVP.EQ.1) THEN
            PS=((Le+LOG(1-x))/3d0-0.55555556d0-(0d0,1.0471976d0))*
     $           2.3228196D-3
            vp=(1-PS)*CONJG(1-PS)
            vp=1./vp
            
            Y = Y*vp

         END IF          
      END IF

      rcm_rche = y
      
      END

c     ===============================================================
c     Integration of one subinterval. C-s is assumed to be linear on
c     the interval [e1,e2]. Uses Simpson rule and variable substitution
c     x=exp(t) for better precision.
c     ===============================================================

      double precision function rcm_intbin ( e1, e2, s1, s2, n, mod )

      implicit none 

      double precision e1, e2   ! energy limits (e1 < e2)
      double precision s1, s2   ! cross-sections in the above points
      integer n
      integer mod

      include 'rcvcsinc.inc'

      integer np
      double precision xmin, xmax, x
      double precision tmin, tmax, dt, expDt, t
      double precision sum

c     --- statement function below
      double precision cs
      double precision e
      
      double precision rcm_rche
      external rcm_rche

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      cs(e) = ( s1*(e2-e) + s2*(e-e1) ) / (e2-e1)

c      print *,'RCBININT -- e1,e2:',e1,',',e2
c      print *,'RCBININT -- s1,s2:',s1,',',s2

      np = (n/2)*2 + 1

c     !!! here x1 will be grater than x2
      xmin = 1 - (e2/cmEnergy)**2
      xmax = 1 - (e1/cmEnergy)**2

      tmin = log(xmin)
      tmax = log(xmax)

      dt = ( tmax - tmin ) / ( np - 1 )
      expDt = exp(dt)

      sum = s1*rcm_rche(xmax,MOD)*xmax +
     $     s2*rcm_rche(xmin,MOD)*xmin

      t = tmin + dt
      x = xmin*expDt
      e = cmEnergy*sqrt(1-x)
      sum = sum + 4 * cs(e) * rcm_rche( x, mod ) * x

      np = np - 3 
      do while ( np .gt. 0 ) 

         t = t + dt
         x = x*expDt
         e = cmEnergy*sqrt(1-x)
         sum = sum + 2 * cs(e) * rcm_rche( x, mod ) * x

         t = t + dt
         x = x*expDt
         e = cmEnergy*sqrt(1-x)
         sum = sum + 4 * cs(e) * rcm_rche( x, mod ) * x

         np = np - 2

      end do

      sum = sum * dt/3

      rcm_intbin = sum

c      print 1000,x2,x1,sum
c 1000 format ( 'RCBININT -- xmin:',F9.7,'  xmax:',F9.7,'  s:',F10.7 )

      end

c     ===============================================================
c     Initialization of the default energy binning which is used with
c     the RCFUN. Makes denser binning around phi and omega.

      subroutine rcm_initDefBen

      implicit none

      include 'rcvcsinc.inc'

      double precision e, step

      double precision shortStep, longStep
      parameter (shortStep=0.1,longStep=1)
      double precision minEnergy, maxEnergy
      parameter ( minEnergy=1, maxEnergy=2000)

c     +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      defBenLen = 0
      e = minEnergy
      do while ( e .le. maxEnergy )
         step = longStep - (longStep-shortStep) *
     $        ( exp(-0.5*((e-782)/20)**2) +
     $        exp(-0.5*((e-1019)/15)**2) ) 
         defBenLen = defBenLen + 1
         if ( defBenLen .gt. defBenSize ) then
            print *, 'RCVCSM::rcm_initDefBen -- out of bounds'
            stop
         end if
         defBen(defBenLen) = e
         e = e + step
      end do

c      print *,'rcm_initDefBen -- defBenLen:',defBenLen

      end
