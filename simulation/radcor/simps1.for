C--------------------------------------------------------------------
       Subroutine Simps1 (s,a,b,Fun,ds)
C *** Calculation of finite integral "s" of function "Fun(f,x)"
C     over variable "x" in the interval (a,b)
C     with automatic accuracy:
C               absolute ds (if ds > 0)
C          or arbitrary -ds (if ds < 0)
C     Basic number of intervals is 8
C
	EXTERNAL FUN
	REAL*8 S,A,B,DS

	REAL*8 H,SMAX,X,F,F2,F4,F1,F3,S1,ERR,ERRCNT,REST
        DATA M /8/
        SAVE M

C
        h = (b-a) / M
        s = 0.
        smax = 0.
c     Unsufficient value of accuracy for single precision
        IF (ds.gt.0 .or. ds.lt.-1.e-5) GO TO 5
        WRITE (6,1) ds
    1   FORMAT (' You want too high accuracy ',1PE10.3,'; RETURN')
        RETURN
    5   x = a
        CALL Fun(f , x)
   10   CALL Fun(f2, x+2.*h)
        CALL Fun(f4, x+4.*h)
   20   CALL Fun(f1, x+   h)
   30   CALL Fun(f3, x+3.*h)
C     Partial sum for a four steps
        s1 = h/3. * (f + 4.*f1 + 2.*f2 + 4.*f3 + f4)
        smax = DMAX1 (smax,ABS(s1))
C     Typical error for a four steps
        err = DABS(4.*h/90.*(f - 4.*f1 + 6.*f2 - 4.*f3 + f4))
        errcnt = ds
        IF (ds.lt.0.) errcnt = -(ds*smax)
        IF (smax.eq.0.) GO TO 40
        IF (err.lt.errcnt) GO TO 40
C     Decreasing of step value
        h = h/2.
        f4 = f2
        f2 = f1
        GO TO 20
   40   s = s + s1
        f = f4
        x = x + 4.*h
C     Step has been finished,
C     check for the possibility to increase step value
        rest = DABS ((b-x)/h)
C     Exit

c --- modified by Bukin D. / new values taken from Phsp3
c        IF (rest.lt.1.E-5) RETURN
c        IF (err .lt. 1.E-2*errcnt) GO TO 60
        IF ( rest.LT.1.D-7 ) RETURN
        IF ( err.LT.1.D-3*errcnt ) GOTO 60
c
        IF (rest.ge.4.) GO TO 10
C     The integration of the rest of interval
   50   h = (b-x)/4.
        GO TO 10
C     Increasing of step value
   60   IF (rest.le.8.) GO TO 50
             h = 2.*h
             f1 = f2
             f2 = f4
             CALL Fun(f4,x+4.*h)
             GO TO 30
        END
C
C--------------------------------------------------------------------
C
        Subroutine Simps2 (s,a,b,Fun,ds)
C *** Calculation of finite integral "s" of function "Fun(f,x)"
C     over variable "x" in the interval (a,b)
C     with automatic accuracy:
C               absolute ds (if ds > 0)
C          or arbitrary -ds (if ds < 0)
C     Basic number of intervals is 8
C
        REAL*8 S,A,B,DS
        EXTERNAL FUN

        REAL*8 H,SMAX,X,F,F2,F4,F1,F3,S1,ERR,ERRCNT,REST
        DATA M /8/
	SAVE M
C
        h = (b-a) / M
        s = 0.
        smax = 0.
c     Unsufficient value of accuracy for single precision
        IF (ds.gt.0 .or. ds.lt.-1.e-5) GO TO 5
        WRITE (6,1) ds
    1   FORMAT (' You want too high accuracy ',1PE10.3,'; RETURN')
        RETURN
    5   x = a
        CALL Fun(f , x)
   10   CALL Fun(f2, x+2.*h)
        CALL Fun(f4, x+4.*h)
   20   CALL Fun(f1, x+   h)
   30   CALL Fun(f3, x+3.*h)
C     Partial sum for a four steps
        s1 = h/3. * (f + 4.*f1 + 2.*f2 + 4.*f3 + f4)
        smax = DMAX1 (smax,ABS(s1))
C     Typical error for a four steps
        err = DABS(4.*h/90.*(f - 4.*f1 + 6.*f2 - 4.*f3 + f4))
        errcnt = ds
        IF (ds.lt.0.) errcnt = -(ds*smax)
        IF (smax.eq.0.) GO TO 40
        IF (err.lt.errcnt) GO TO 40
C     Decreasing of step value
        h = h/2.
        f4 = f2
        f2 = f1
        GO TO 20
   40   s = s + s1
        f = f4
        x = x + 4.*h
C     Step has been finished,
C     check for the possibility to increase step value
        rest = DABS ((b-x)/h)
C     Exit

c --- modified by Bukin D. / new values taken from Phsp3
c        IF (rest.lt.1.E-5) RETURN
c        IF (err .lt. 1.E-2*errcnt) GO TO 60
        IF (rest.lt.1.D-7) RETURN
        IF (err .lt. 1.D-3*errcnt) GO TO 60
c
        IF (rest.ge.4.) GO TO 10
C     The integration of the rest of interval
   50   h = (b-x)/4.
        GO TO 10
C     Increasing of step value
   60   IF (rest.le.8.) GO TO 50
             h = 2.*h
             f1 = f2
             f2 = f4
             CALL Fun(f4,x+4.*h)
             GO TO 30
        END
