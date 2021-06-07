c --- formfactor of pi pi
	real*8 function formpi(e0)
	implicit none

	real*8 e0,e
	real*8 x(8)
	data x/775.35,140.34,0.16401,0.18953d-02,0.21579E-03,
     *         1177.9,119.32,0.15369/
	save x
c       x(1)- rho mass
c	x(2)- rho width
c       x(3)- d 
c	x(4)- re(a)
c	x(5)- im(a)
c	x(6)- m0
c	x(7)- g0
c	x(8)- no

	real*8 mpi,mom,gom,mpi2,mom2,pi
	parameter (mpi=139.57)
	parameter (mom=781.94)
	parameter (gom=  8.43)
	parameter (mpi2=mpi**2)
	parameter (mom2=mom**2)
	parameter (pi=3.1415926)

	real*8 mrho2,q0,rlg0,h0,dh
	save mrho2,q0,rlg0,h0,dh

	real*8 s,q,rlg,h,f
	complex*16 drho,dom,d0
	logical key/.true./
	real*8 form(0:1220)
	save key,form
	integer i

      if(key)then
	mrho2=x(1)**2
	q0=sqrt(mrho2-4.*mpi2)
	rlg0=log((x(1)+2.*q0)/2./mpi)
	h0=2.*q0/pi/x(1)*rlg0
	dh=(mpi2/q0/x(1)*rlg0+0.5)/pi/x(1)**2

	do i=0,1220

	e=280.+i	
	s=e**2
	q =sqrt(s-    4.*mpi2)
	rlg =log((E   +2.*q )/2./mpi)
	h =2.*q /pi/E   *rlg

	f=x(2)*mrho2/q0**3*(q**2*(h-h0)-(s-mrho2)*q0**2*dh)
	drho=dcmplx(mrho2-s+f,-mrho2/E*x(2)*(q/q0)**3)
	drho=mrho2*(1.+x(3)*x(2)/x(1))/drho
	dom=dcmplx(mom2-s,-gom*e)
	dom=mom2/dom
	drho=drho*(1.+dcmplx(x(4),x(5))*dom)
	d0=(x(6)**2/dcmplx(x(6)**2-s,-x(6)*x(7)))**x(8)
	if(E.gt.mom+mpi)then
	  drho=drho*d0
	else
	  drho=drho*dreal(d0)
	endif
	form(i)=dreal(drho)**2+dimag(drho)**2
	enddo
	key=.false.
      endif
	if(e0.le.280.)then
	  formpi=(form(0)-1.)*e0/280.+1.
	else if(e0.ge.1500.)then
	  formpi=form(1220)
	else
	  i=e0-280.
	  e=280.+i
	  formpi=form(i  )*(e+1.-e0)+ 
     *           form(i+1)*(e0-e   )
	endif
	end
