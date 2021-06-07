c ---------------------------------------------------------------
c The routine is to calculate phase space for pi0 pi0 gamma decay
c The difficulty here is that there is a function (ompinp) by Z.S.
c which calculate a cross section and no matrix element available.
c Cross section contains contribution of three different
c intermediate states:
c   1) rho pi0,  2) omega pi0, 3) direct decay into
c   pi0 pi0 gamma, and   4) sigma(600) gamma
c that all interfere with each other.  So we
c need information about their relative phases.
c  The program prints data, then you process it with
c  simple macro, which is placed at the end of this file.
c  then insert results into crsppg.for
c ---------------------------------------------------------------
      program cphppg
      implicit none
      include 'fitdata.inc'

      real*8 e, e1, e2, de
      real*8 crs, crs1, crs2

      write (6,*) 'A subroutine to calculate the interference matrix for pi0pi0g'
      write (6,*) 'For description look at crsppg.for.'
      write (6,*) '  Below are printed:'
      write (6,*) 'energy(MeV), then elements of interference matrix sigm(4,4)'
      write (6,*) 'by rows, 2 numbers per each: value and error.'
      write (6,*) 'Then the total cross section and its error.  So, the whole'
      write (6,*) 'record for energy point contains 35 numbers.'

      e1 = 360.
      e2 = 2400.
      de = 5.
      call inifit

c --- adjust some masses, etc.
c     gom = 8.6

      do e = e1, e2, de
        call cphppg1(e)
      enddo
      end


c --- cross section of rho, rhop, rhopp
c --- cross section e+e- ---> rho ---> omega pi0 ---> pi0 pi0 gamma
c     adapted from ompinp program by V.D. & Z.S.
c     The comments for that program follow:
c -----------------------------------------------------------------
c Monte-Carlo simulation of e+ e- -> rho -> omega pi0 ->
c                    pi0 pi0 gamma
c
c   Differential cross-section have been calculated by
c                 Z.Silagadze
c
c    16-dec-1996 V.Druzhinin
c
c    6-MAY-1997  phi,omega and rhop contributions have been added
c                     Z.Silagadze
c
c    7-MAY-1997  V.Ivanchenko Rho-Prop changed on Rho-PropX
c                             M2OmPi changed on M2OmPiX
c
c    22-jan-98  rad.corrections were included; Z.Silagadze.
c------------------------------------------------------------------
      subroutine cphppg1( e0 )
      implicit none
      include 'fitdata.inc'
      real*8 e0
      real*8 grg, gfg, gorp, gfrp, gopg, grpg, gwg, gpp
      common /ompi_cons/ grg,gfg,gorp,gfrp,gopg,grpg,gwg,gpp

      integer nev
      parameter ( nev = 100000)

      real*8 mpi, mpi2
      real*8 sp3pi
      real*8 e
      real*8 cons
      real*8 kmax
      integer j
      real*8 x
      real*8 drndm
      real*8 e2p, m2p, c2p, s2p, v2p(3)
      real*8 k(0:3), p1(0:3), p2(0:3)
      real*8 p1p, cpi, spi
      real*8 cf, sf
      integer i
      real*8 f, g

c --- cross section
      integer n, n1, n2, ih, iv
      integer nco
      integer nstates
      parameter (nstates = 4)
      parameter (nco = nstates*nstates+1)
      real*8 sum(nco), ssq(nco), gmax(nco), cscon(nco)

      logical firstpass /.true./
      save firstpass


c --- initialization
      if ( firstpass ) then
        firstpass = .false.
        call inifit

        grg=alpha*sqrt(4.D0*pi/3.D0*msrho/(grho*BrRhoEe))
        gwg=alpha*sqrt(4.D0*pi/3.D0*msom/(gom*BrOmEe))
        gfg=alpha*sqrt(4.D0*pi/3.D0*msphi/(gphi*BrPhiEe))
        gorp=sqrt(4.D0*pi*gom *BrOm3Pi /sp3pi(msom ))
        gfrp=sqrt(4.D0*pi*gphi*BrPhi3Pi/sp3pi(msphi))
        gopg=24.D0*gom*BrOmPi0G /msom**3 /(1.D0-(mspi0/msom)**2)**3
        gopg=sqrt(gopg)
        grpg=24.D0*grho*BrRhoPiG/msrho**3/(1.D0-(mspi/msrho)**2)**3
        grpg=sqrt(grpg)
  
        write(6,*)' ### Coupling constants:'
        write(6,*)
     &    ' for Rho  ->  gamma   transition       :  ',grg
        write(6,*)
     &    ' for Omega->  gamma   transition       :  ',gwg
        write(6,*)
     &    ' for Phi  ->  gamma   transition       :  ',gfg
        write(6,*)
     &    ' for Omega->  Rho+pi  transition(1/MeV):  ',gorp
        write(6,*)
     &    ' for Phi  ->  Rho+pi  transition(1/MeV):  ',gfrp
        write(6,*)
     &    ' for Omega->  Pi0+gamma transition(1/MeV):',gopg
        write(6,*)
     &    ' for Rho  ->  Pi +gamma transition(1/MeV):',grpg
      endif

c___________________________________
c All energies are divided by beam energy
c-----------------------------------

      e = e0 / 2.

      mpi = mspi0 / e
      mpi2 = mpi**2
      cons = 1./(2.*pi)**4 / 16.*0.3894d6 * (1000./e0)**2/(137.)**2/2.

      kmax = 1.-mpi2

c --- clean arrays
      do n = 1, nco
        sum(n) = 0.
        ssq(n) = 0.
        gmax(n) = 0.
      enddo

c --- loop over statistics
      do j = 1, nev

C Photon energy, mass and energy of 2 pi0 state 
        x = kmax * DRNDM(0.0)
        M2p = 2.*sqrt(1.-x)
        E2p = 2.-x
          
C 2 pi0 state unit vector
        C2p=2.D0*DRNDM(0.0)-1.d0
        S2p=sqrt(1.d0-C2p**2)
        call DDCOSI(CF,SF)
        V2p(1)=S2p*cf
        V2p(2)=S2p*sf
        V2p(3)=C2p      
c photon 4-momentum in laboratory frame                         
        K(0)=x
        do i=1,3
          K(i)=-V2p(i)*x
        enddo

c 1-st Pi0 4-momentum in 2pi rest frame
        P1(0)=M2p/2.d0
        P1p=sqrt(P1(0)**2-mpi2)
        Cpi=2.D0*DRNDM(0.0)-1.d0
        Spi=sqrt(1.d0-Cpi**2)
        call DDCOSI(CF,SF)
        P1(1)=Spi*cf*P1p
        P1(2)=Spi*sf*P1p
        P1(3)=Cpi*P1p   

c 2-nd Pi0 4-momentum in 2pi rest frame
        P2(0)= P1(0)
        P2(1)=-P1(1)
        P2(2)=-P1(2)
        P2(3)=-P1(3)    
C Lorentz transformation for Pi0 mesons  
        call LorTr( V2p, E2p/M2p, P1)
        call LorTr( V2p, E2p/M2p, P2)
        
c --- here we should check the acceptance of our detector
c     but now here is nothing ... will do that later

c     Phase space ( no 1/8*1/(twopi)**9 )

        f = sqrt(1.d0 - mpi2/(1.d0-x))*x*4.d0 *(2.d0*pi)**2 *kmax/2.d0

c --- abs(matrix element)**2 calculation
        call m2ppgx( e, k, p1, p2, nstates, cscon )

c --- subtract trivial contribution from non-diagonal element of the matrix
        do ih = 1, nstates
          do iv = 1, nstates
            if ( ih.ne.iv ) then
              n = (iv-1) * nstates + ih
              n1 = (iv-1) * nstates + iv
              n2 = (ih-1) * nstates + ih
              cscon(n) = cscon(n) - cscon(n1) - cscon(n2)
            endif
          enddo
        enddo

c --- sum up
        do n = 1, nco

          g = cons * cscon(n) * f
          if ( g.gt.gmax(n) ) gmax(n) = g
          sum(n) = sum(n) + g
          ssq(n) = ssq(n) + g*g

        enddo

      enddo ! end of stat loop
        
c --- make average/error
      do n = 1, nco
        sum(n) = sum(n) / nev
        ssq(n) = sqrt( (ssq(n)/nev - sum(n)*sum(n)) / nev )
      enddo

      write (6,11) e0
      write (6,11) (sum(n), ssq(n), n = 1, nco)
11    format(d15.8)
      end



c ==============================================================
c --- phase space calculation
c e             one beam energy (MeV?)
c k, p1, p2     4-vectors of photon and pions in LabCS,
c               expressed in such units, that sqrt(s) = 2.
c 		Dipion mass then will be: m**2 = s*(1-k(0))
c
      subroutine m2ppgx(e,k,p1,p2,nstates,cscon)
      implicit none
      include 'fitdata.inc'
      
      real*8 grg,gfg,gorp,gfrp,gopg,grpg,gwg,gpp
      common /ompi_cons/grg,gfg,gorp,gfrp,gopg,grpg,gwg,gpp

      real*8 e,k(0:3),p1(0:3),p2(0:3)
      integer nstates
      integer nco
      real*8 cscon(nstates*nstates+1)

      real*8 x,q(0:3),q2,q0,q02,kk,kq,qq
      real*8 C11,C22,C33,C12,C13,C23
      complex*16 rrho,rom1,rom2,g1,g2,a1,a2,a3
      complex*16 rphi,rrho1,rrho2,rom,rrhop,rrhopp,rsig
      complex*16 DpOm, DpPhi, DpRhoP, rho_propX, dpsig
      real*8 consr, consf, consw, consrp, consrpp, consp, conss
      logical firstpass /.true./
      save firstpass
      
      real*8 s
      complex*16 prhopx
      integer ih, iv, n, i
      complex*16 kc(4)


      nco = nstates*nstates + 1

c --- here we need only contribution from
c     rho -> omega pi0,
c     omega -> rho pi0  and
c     direct decay -> pi0 pi0 gamma
c
      consr = pi*(msrho*gorp)*(msrho*gopg)/grg
      consp = consr
      consw = pi*(msom*gorp)*(msom*grpg)/gwg
      conss = consr

      consf = -pi*(msphi*gfrp)*(msphi*grpg)/gfg
c      consrp = -0.558*consr * in_use(4)
c        consrp = -0.72*consr * in_use(4)
c      consrpp = arh2 * exp(dcmplx(0.d0,prh2)) * consr * in_use(5)
c      consrp = arh1 * exp(dcmplx(0.d0,prh1)) * consr * in_use(4)
c      consr = arh0 * exp(dcmplx(0.d0,prh0)) * consr * in_use(1)
      if ( firstpass ) then
        firstpass = .false.
        write (6,*) ' Rho   ---> omega pi0 :', consr
        write (6,*) ' Omega ---> rho pi0   :', consw
        write (6,*) ' Phi   ---> rho pi0   :', consf, ' not used here.'
c        write (6,*) ' RhoP  ---> omega pi0 :', consrp
c        write (6,*) ' RhoPP ---> omega pi0 :', consrpp
      endif
      
      x = k(0)
      q(0)=(p1(0)-p2(0))/2.
      q(1)=(p1(1)-p2(1))/2.
      q(2)=(p1(2)-p2(2))/2.
      q(3)=(p1(3)-p2(3))/2.
      
      q2 = q(0)**2 - q(1)**2 - q(2)**2 - q(3)**2
      q0=q(0)
      q02=q0**2
      
      kk=k(1)**2 + k(2)**2
      kq=k(1)*q(1)+k(2)*q(2)
      qq=q(1)**2+q(2)**2
      
      C11 = 2.*x**2 - kk
      C22 = 8.*q02**2 - q02*q2*kk - 4.*q02*qq + 2.*q0*q2*x*kq - q2*x**2*qq
      C33 = 4.*(8.*q02 - q2*kk + 4.*q0*kq)
      C12 = 4.*x*q02 - x**2*qq + 2.*x*q0*kq - 2.*q0*kq - q02*kk
      C13 = 2.*(4.*x*q0 - q0*kk + x*kq)
      C23 = 2.*(8.*q0*q02 + 2.*q02*kq - 2.*x*q0*qq - q0*q2*kk+x*q2*kq)
      
      s = 4.*e**2

c --- decay rho -> omega pi0
c     Here we do not need propagator of rho meson,
c     so we assume that s**2/abs(DpRho(s))**2 = 1, and, therefore,
c     1/abs(rrho)**2 = (e)**4/s**2
c     rrho = rho_propX(E)
      rrho = 4.d0
      rom1=-dpom(s*(1.-p1(0))+mspi0**2)/e**2
      rom2=-dpom(s*(1.-p2(0))+mspi0**2)/e**2

c      rphi=-DpPhi(s)/E**2

c --- decay omega -> rho pi0
c     The same words as for rho->omega pi0 decay.
c     We replace DpOm(s) -> -S
c      rom= -DpOm(s)/e**2
      rom = 4.d0
      rrho1 = rho_propX(sqrt(s*(1.-p1(0))+mspi0**2)/2.)
      rrho2 = rho_propX(sqrt(s*(1.-p2(0))+mspi0**2)/2.)

c !!!!
      rrho1 = rrho1*( 1-p1(0)+(mspi0/(2*E))**2 )
      rrho2 = rrho2*( 1-p2(0)+(mspi0/(2*E))**2 )

c      g1 = consr*4./rrho*4./rom1 +
c     &  consf*4./rphi*4./rrho1 +
c     &  consw*4./rom*4./rrho1 +
c     &  consrp*4./rrhop*4./rom1 +
c     &  consrpp*4./rrhopp*4./rom1
c      g2 = consr*4./rrho*4./rom2 +
c     &  consf*4./rphi*4./rrho2 +
c     &  consw*4./rom*4./rrho2 +
c     &  consrp*4./rrhop*4./rom2 +
c     &  consrpp*4./rrhopp*4./rom2
      
c --- decay  -> sigma pi0
c     a 
      rsig = -dpsig( s*(1-x) )/e**2

c --- here is interference matrix (3x3) calculation. Indices:
c       1 - omega pi0 intermediate state,
c       2 - rho pi0 intermediate state,
c       3 - direct decay into pi0 pi0 gamma.
      ih = 1
      iv = 1
      do n = 1, nco

        do i = 1, nstates
          kc(i) = 0.
        enddo

c --- the calculation of matrix element (iv,ih), where iv-number of a row,
c     ih-number of a column, is performed in three cases:
        if ( n.lt.nco ) then
          if ( ih.eq.iv ) then
            ! diagonal element - only corresponding contribution survives
            kc(ih) = 1
          else
            kc(min(ih,iv)) = 1
            if (ih.gt.iv) then
              ! upper triangle element - 0 degrees phase
              kc(ih) = 1
            else
              ! lower triangle element - -90 degrees phase
              kc(iv) = (0.d0,-1.d0)
            endif
          endif
          
        else
          ! the calculation of the total cross section by VDM
          ! there is only contribution of rho->omega pi0 and omega->rho pi0
          kc(1) = rrho/rho_propx(e)
          kc(2) = -rom/dpom(s)*e**2
        endif

c --- make complex vector
        g1 = consr*4./rrho*4./rom1*kc(1) +
     &    consw*4./rom*4./rrho1*kc(2)
        g2 = consr*4./rrho*4./rom2*kc(1) +
     &    consw*4./rom*4./rrho2*kc(2)

c --- I have to divide phase space contribution by sqrt(C11)
c       in order to compensate this factor
        A1=-(x/8.+q2/4.)*(g1+g2) + q0/2.*(g1-g2) +
     &    consp*kc(3)/sqrt(C11) +
     &    conss*kc(4)/rsig
        A2=(g1+g2)/4.
        A3=-(g1-g2)/8.
      
c        sscal = e*e*(
c     &    (p1(0)+p2(0))**2 -
c     &    (p1(1)+p2(1))**2 -
c     &    (p1(2)+p2(2))**2 -
c     &    (p1(3)+p2(3))**2 )
c        A1 = 1 / rrho * (mscal*gscal) / prhopx(sscal,mscal,gscal)
c        A2 = 0.
c        A3 = 0.
      
        cscon(n) =
     &    C11*(dreal(A1)**2 + dimag(A1)**2)+
     &    C22*(dreal(A2)**2 + dimag(A2)**2)+
     &    C33*(dreal(A3)**2 + dimag(A3)**2)+
     &    C12*2.*dreal(A1*conjg(A2))+
     &    C13*2.*dreal(A1*conjg(A3))+
     &    C23*2.*dreal(A2*conjg(A3))

c --- advance indices
        ih = ih + 1
        if ( ih.gt.nstates ) then
          ih = 1
          iv = iv + 1
        endif

      enddo
c        write (6,55)
c     &    e, c11, c22, c33, c12, c13, c23,
c     &    abs(a1), atan2(dimag(a1),dreal(a1))/deg2rad,
c     &    abs(a2), atan2(dimag(a2),dreal(a2))/deg2rad,
c     &    abs(a3), atan2(dimag(a3),dreal(a3))/deg2rad,
c     &    m2ompix
55    format( 'E,C11,C22,C33=',4d13.5,/
     &  'c12,c13,c23=',3d13.5,/
     &  'abs(rom1,rom2)=',2d13.5,/
     &  'a1,a2,a3=',3('(',2d13.5,') '),/
     &  'm2ompix=',d13.5 )
      end


      complex*16 function Rho_propX(E0)
      implicit none
      include 'fitdata.inc'
      real*8 E0
      real*8 P,P0,mgrho

      P =1.d0- (mspi/   E0     )**2
      if(p.le.0.)then
        P=0.
      else
        P =sqrt(P)
      endif
      P0=sqrt(1.d0-(mspi/(msrho/2.))**2)
      mgrho=4.*grho/msrho*(p/p0)**3
      Rho_propX = dcmplx(4.-(msrho/E0)**2,mgrho)
      end

c+++ A macro to process results from cphppg.for
c    Just put it in some file and remove c at the beginning of each line
cmacro cphppg file=cros/cphppg1.lif
cmess 'Изготовление фазовых обьемов:'
cmess ' 1) пропустите задание cphppg, взятое из CVS/gener.'
cmess ' 2) урежьте всю лишнюю печать, оставьте только данные.'
cmess ' 3) запустите этот макрос с file=<your file>'
cmess
cmess 'loading vector from' [file]
cif ( $vexist(ee).eq.0 ) then
c  ve/del *
c  ve/cre c(21,1000)
c  ve/read c [file]
c  ve/copy c(1) ee
c  v = $vlen(ee,1)
c  ve/del ee
c  ve/cre ee([v])
c  ve/copy c(1,1:[v]) ee
c  sigma de = array([v],0.05#0.05)
c  mess 'the total number of points is' [v]
c  do i = 1, 10
c    j = [i] * 2
c    ve/cre si[i]([v])
c    ve/copy c([j],1:[v]) si[i](1:[v])
c    j = [j] + 1
c    ve/cre di[i]([v])
c    ve/copy c([j],1:[v]) di[i](1:[v])
c  enddo
c  ve/del c
cendif
cmess 'vectors si[x] and di[x] were created.'
c* wait 'press <enter> to begin approximation.'
cmess
cmess 'loading library'
cexec getlibes
cnp = 18
cve/cre vffo([np])
cmess par1 = $call('getfitpr(1)')
cmess xpha = $call('xphppgr(1000.,vffo)')
cappli comis quit
c      real function ffphas(x)
c      real x
c      real xphppgr
c      real vffo
c      common /pawpar/ vffo(18)
c      ffphas = xphppgr(x,vffo)
c      end
c      real function pfphas(x)
c      real x
c      real xphppgr
c      real vffo
c      vector vffo(18)
c      pfphas = xphppgr(x,vffo)
c      end
cquit
c* mess par1 = $call('xphppgr(1000.,vffo)')
cve/cre vf([np],9)
cdo i = 1, 9
c  mess Approximation of element # [i]
c  ve/cre vf[i]([np]) r
c  set mtyp 1
c  ve/fit ee si[i] di[i] ffphas 0 [np] vf[i]
cenddo
cmess 'normalize cross section ppg to rwp level'
cve/copy vf1 vffo
cexec hsigma cs1 = &pfphas(ee)
cve/copy vf9 vffo
cexec hsigma cs9 = &pfphas(ee)
csigma cs = vsum( cs1/cs9 * (ee EQ 770.) )
csigma vf9 = vf9 * cs
csigma si9 = si9 * cs
csigma di9 = di9 * cs
csigma cs = sqrt(cs)
cfor i in 8 7 6 3
c  sigma si[i] = si[i] * cs
c  sigma di[i] = di[i] * cs
c  sigma vf[i] = vf[i] * cs
cendfor
cmess 'put all results back into vf vector'
cdo i = 1, 9
c  ve/copy vf[i](1:[np]) vf(1:[np],[i])
cenddo
cmess 'writing vector back on disk in' [file]//'.res'
cve/wr vf [file]//'.res' ('     & ',D15.7,3(',',D15.7))
cmess 'now it is done, use submacro #show to see the fit'
creturn
c
c
cmacro show i=1 opt=' '
cve/copy vf[i] vffo
cset ltyp 1
cfun/plot pfphas(x) 500 2400 [opt]
chp/err ee si[i] de di[i] $vdim(ee,1) 20 0.03 p0
creturn
