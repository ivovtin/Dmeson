c-----------------------------------------------------------------
c   Width of V -> rho + pi -> 3 pi
c    = gvrp**2/(4.*pi)*W(mom)
c
c     W(mom)=mom**3/1000.*(mom/781.94)**5*(1.-(414.12/mom)**2)**4*B(mom)
c     B(mom) are calculated by this program and saved in file.
c
c     Used a formula from 
c     E.A.Kuraev, Z.K.Silagadze.
c     Once more about the omega->3 pi contact term.
c     Yadernaya phisica, 1995, V58, N9, p.1678-1694.
c     with some constant modification.
c
c     external subroutines: INIFIT,
c                           DSIMPS ( CERNLIB ) 
c
c     11-JAN-1996 V.Druzhinin
c------------------------------------------------------------------
	program WRhoPi
	implicit none

	include 'fitdata.inc'
	real*8 mpi2,mpi02,mom,mom2,gpp

c Constant of Omega -> Rho+pi decay (1/MeV).
C Used for calculation control 
	real*8 gorp 
	parameter (gorp=0.0143066)

	integer N
c        parameter (N=200)
        parameter (N=400)
        integer npoi
        parameter (npoi = 1000)
	
	real*8 x,dx,xmin,xmax
	real*8 y,dy,y1,y2,ymin,ymax
	real*8 Mrhopi
	real*8 f(0:1000),g(0:1000)
        real*8 dsimps,A,B(npoi),BB
	integer i,j,k
        integer kascif, ios, iostat, lun


	call inifit

        Npoint=npoi
	Emin=415.
	Estep=5.

      do k=1,Npoint
	mom=Emin+(k-1)*Estep
	mpi2=mspi**2
	mpi02=mspi0**2
	mom2=mom**2
c constant of rho -> 2 pi decay
	gpp=48.*pi*grho/msrho/sqrt(1.-(2.*mspi/msrho)**2)**3
	gpp=sqrt(gpp)

	xmin=mspi/mom+1.d-10
	xmax=(1.-mspi0*(2.*mspi+mspi0)/mom2)/2.-1.d-10
	dx=(xmax-xmin)/N

	do i=0,N
	  x=xmin+i*dx
	  y1=0.5/(1.-2.*x+mpi2/mom2)*
     *    (1.-x)*(1.-2.*x+(2.*mpi2-mpi02)/mom2)
	  y2=0.5/(1.-2.*x+mpi2/mom2)*
     *    sqrt((x**2-mpi2/mom2)*
     *    (1-2.*x+mspi0*(2.*mspi-mspi0)/mom2)*
     *    (1-2.*x-mspi0*(2.*mspi+mspi0)/mom2))
	  ymin=y1-y2
	  ymax=y1+y2
	  dy=(ymax-ymin)/N
	  do j=0,N
	    y=ymin+j*dy
	    g(j)=mrhopi(mom,x,y)
	  enddo
	  f(i)=DSIMPS(g,ymin,ymax,N)
	enddo
	A=DSIMPS(f,xmin,xmax,N)
c-----------------------------------------------------------------
c   Width of omega -> rho + pi -> 3 pi
c    =A*(mom/msrho)**4*gpp**2*mom**3/48./pi**2*(gorp**2/4./pi)
c    =(gorp**2/4./pi)*W(mom)
c     W(mom)=mom**3/1000*(mom/781.94)**5*(1.-(414.12/mom)**2)**4*B(mom)
c------------------------------------------------------------------
	B(k)=A*gpp**2/48./pi**2*(mom/msrho)**4/
     *    (1.-(414.12/mom)**2)**4/(mom/781.94)**5*1000.

c Width of Omega ->3 Pi decay. Used for calculation control.
	BB=(mom/781.94)**5*mom**3/1000.*(1.-(414.12/mom)**2)**4*B(k)
	BB=BB*(gorp**2/4./pi)
	WRITE(*,*)'E=',mom,' Width=',BB

      enddo

      lun = 0
      ios = kascif(lun, 'wrhopi.wid', 2, iostat )
      if ( ios.ne.0 ) then
        write (6,*) 'Failed to create wrhopi.wid, code=',ios,iostat
        stop
      endif

      write(lun,2)Npoint,Emin,Estep
      write(lun,1)B
      close(lun)

1     format(1x,5F9.5)
2     format(' ## WRhoPi:', I6,' Points, Emin=',F8.2,'; Estep=',F6.2)
      end



      real*8 function mrhopi(mom,x,y)
      implicit none
      include 'fitdata.inc'

	real*8 mom,x,y

	real*8 mom2,mpi2,mpi02
	real*8 G
	real*8 s0,s1,s2
	complex*16 rhoprop,M

	mpi2=mspi**2
	mpi02=mspi0**2
	mom2=mom**2

	G=4.*(x**2-mpi2/mom2)*(y**2-mpi2/mom2)-
     *	  (1.-2.*x-2.*y+2*x*y+(2.*mpi2-mpi02)/mom2)**2

	s0=mom2*(2*x+2*y-1.)+mpi02
	s1=mom2*(1.-2*y)+mpi2
	s2=mom2*(1.-2*x)+mpi2

	M=ct-1./rhoprop(s0,0)
     *      -1./rhoprop(s1,1)
     *      -1./rhoprop(s2,1)
	mrhopi=G*(Dreal(M)**2+Dimag(M)**2)

	end

        complex*16 function Rhoprop(s,j)
        implicit none
	include 'fitdata.inc'
        real*8 s
        integer j
c j=0 rho zero
c j=1 rho plus
        real*8 mrho2,W

	mrho2=msrho**2
	
        if(j.eq.0)then
           W=sqrt(
     *       (1.-4.*mspi**2/s    )/   
     *       (1.-4.*mspi**2/mrho2)
     *           )**3
        else
           W=sqrt(
     *       (1.-(mspi+mspi0)**2/s    )*
     *       (1.-(mspi-mspi0)**2/s    )/
     *       (1.-(mspi+mspi0)**2/mrho2)/
     *       (1.-(mspi-mspi0)**2/mrho2)
     *           )**3
        endif

        Rhoprop = dcmplx(s-mrho2,grho*s/msrho*W)/mrho2
        end
