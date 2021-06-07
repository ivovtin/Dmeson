c+++ vdppg rho->omega+pi0 routine w/ courtesy of V.D.
c    
      real*8 function vdppg(e2)
      implicit none
      real*8 e2

      complex*16 z0, r770
      real*8 omphn

      z0 = 1./r770( e2**2 )
      vdppg = abs(z0)**2 * omphn( e2 )
      end

c+++ some approximation for the phase space
      real*8 function omphn(x)
      implicit none
      real*8 x,y

      if( x.ge.1000. )then
        omphn=7.3784*(sqrt((1.-(646.96/x)**2)*(1.-(915.74/x)**2)))**3
      else if( x.ge.918. )then
        y=x/900.-1.
        omphn=0.1675009*
     &         (0.056112-4.3776*y+234.83*y**2-1229.5*y**3+3177.6*y**4)
      else if(x.ge.900.)then
        y=x/900.-1.
        omphn=0.8905086E-02 +(y-0.02)*(0.22343+y*4.8769+y**2*326.96)
      else  if(x.ge.800.)then
        y=(x/800.-1)/0.125
        IF(y.le.0.)then
          omphn=0.4436486E-02*exp(-1.6)*(7.667/8.667)**2
        else if(y.ge.1.)then
          omphn=0.4436486E-02
        else
          omphn=0.4436486E-02*exp(-1.6*(1.-y))*
     &                 ((y**4+7.667)/8.667)**2
        endif
      else
        omphn=0.
      endif
      end


c+++ rho 770 propagator by V.D.
      complex*16 function r770(s)
      implicit none
      include 'fitdata.inc'
      real*8 s,orp,r
      real*8 P,P0,mgrho,mrho2,pw,pw0,qqq,qqq1

      mrho2=msrho**2
      pw=(s-(646.96)**2)*(s-(915.74)**2)/s
      if(pw.le.0.)pw=0.
      pw=sqrt(pw)/2.
      P =sqrt(s-4.*mspi**2)/2.
      P0=sqrt(msrho**2-4.*mspi**2)/2.
      qqq=1.
      qqq1=1.
      mgrho=sqrt(s)*grho*msrho**2/s*(p/p0)**3

      r770= dcmplx(s-mrho2,mgrho)/mrho2
      end
