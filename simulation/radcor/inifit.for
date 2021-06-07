c====================================================================
c+++ subroutine inifit  (constants autoloader)
c --- see below for related routines: setfitp, getfitp, outfitp
      subroutine inifit
C********************************************************************
C   Inicialisation of parameters of particles
C   Parameters are stored in /FIT002/ and described in FitData.inc
C          V.Ivanchenko
C********************************************************************
c
c $Log: inifit.for,v $
c Revision 1.7  2000/09/22 15:56:31  bukind
c some parameter i/o and service routines for fit/snd-paw have changed
c
c Revision 1.6  2000/04/21 07:05:16  bukind
c inifit is cvsdsc-ed
c
c Revision 1.5  2000/04/21 05:32:54  bukind
c brrhopi0g added in getlibes
c
c Revision 1.4  2000/01/05 12:30:36  bukind
c inifit -- correspondence for Gphi index in setfitp fixed
c rcfun  -- opportunity to invoke rceffener added
c rceffener -- dead end drone for user's rceffener
c
c Revision 1.3  1999/10/20 10:55:33  bukind
c a0f0md.for transferred from gener
c
c Revision 1.2  1999/08/12 13:19:36  bukind
c More parameters added into inifit.
c Routines setfitall, getfitall to allow loading of all parameters.
c

      implicit none     

      include 'fitdata.inc'

      integer*4 i, is, istat, kascif
      real*4 femin,festep,f3pi(nstep)
      logical klu/.false./
      character*(*) idprog,iddate,idrevn,idauth,iddesc
      parameter (idprog = '$Desc: INIFIT $')
      parameter (idrevn = '$Revision: 1.7 $' )
      parameter (iddate = '$Date: 2000/09/22 15:56:31 $')
      parameter (idauth = '$Auth: vnivanch $')
      parameter (iddesc = '$Comment: initial crossection parameter values $')
      save klu

      if (klu) return
      klu=.true.

      call cvsdsc(idprog,idrevn,iddate,idauth,iddesc)

C========= Inicialisation
c --- the old data that were in operations until 14.10.1998
c       MsPi=139.56995D0
c       MsPi0=134.9764D0
c       MsEta=547.45D0
c       MsEtap=957.77D0
c       MsKs=497.672D0
c       MsKc=493.677D0
c       MsRho=768.5D0
c       MsOm=781.94D0
c       MsF0=950.0D0
c       MsA0=982.4D0
c       MsPhi=1019.413D0
c       MsK892=891.59D0
c       MsK0892=896.10D0
c       GRho=150.7D0
c       GOm=8.43D0
c       GPhi=4.43D0
c       GK892=49.8D0
c       GK0892=50.5D0
c       PhRho=0.D0
c       PhOm=0.D0
c       PhPhi=155.D0
c       BrRhoPiG=4.5D-4
c       BrRhoPi0G=7.9D-4
c       BrRhoEtaG=3.8D-4
c       BrRhoEe=4.46D-5
c       BrOm3Pi=0.888D0
c       BrOmPi0G=0.085
c       BrOmEtaG=8.3D-4
c       BrOm2Pi=0.0221D0
c       PhOm2Pi=90.D0
c       BrOmEe=7.15D-5
c       BrPhi2Kc=0.491D0
c       BrPhiKsKl=0.343D0
c       BrPhi3Pi=0.154D0
c       BrPhiPi0G=1.31D-3
c       BrPhiEtaG=1.28D-2
c       BrPhi2Pi=8.D-5
c       PhPhi2Pi=-20.D0
c       BrPhiEe=3.09D-4
c       Pi=3.1415926D0
c       MeVnb=3.894D+11
c       Alpha=1.D0/137.036D0
c       AOmRho=3.D0

c --- the data taken from http://www.inp.nsk.su/pdg mirror of PDG.
c     on 14.10.1998 by BukinD
c parameters:
c Ms - mass
c G  - total width
c Ph - phase
c Br - branching ratio
c
c Values for PhRhoP and ARhoPRho is used in crppg0 routine
c and were obtained by Z.S. in fitting ND data.      
      MsPi = 139.56995D0        ! not changed
      MsPi0= 134.9764D0         ! not changed
      MsEta= 547.30D0           ! was 547.45
      MsEtap=957.78D0           ! was 957.78
      MsKs = 497.672D0          ! not changed
      MsKc=493.677D0            ! not changed
      MsRho= 770.0D0            ! +-0.8, was 768.5+-0.6
      MsOm = 781.94D0           ! +-0.12, not changed
      MsF0 = 980.0D0            ! +-10, was 950, where from?
      MsA0 = 983.4D0            ! +-0.9, was 982.4, where from?
      MsPhi= 1019.413D0         ! +-0.008, not changed
      MsK892 = 891.66D0         ! was 891.59
      MsK0892 = 896.10D0        ! not changed
      GRho = 150.7D0            ! +-1.1, was 150.7+-1.2
      GOm = 8.41D0              ! +-0.12, was 8.43+-0.10
      GPhi = 4.43D0             ! +-0.05, not changed
      GK892 = 50.8D0            ! was 49.8
      GK0892 = 50.5D0           ! not changed
      PhRho = 0.D0              ! not touched
      PhOm = 0.D0               ! not touched
      PhPhi= 155.D0             ! not touched
      PhRhoP = 186.d0           ! +-5
      
      BrRhoPiG = 4.5D-4         ! not changed
      BrRhoPi0G= 6.8D-4         ! +-1.7, was (7.9+-2.0)d-4
      BrRhoEtaG= 2.4D-4         ! +0.8-0.9, was (3.8+-0.7)d-4
      BrRhoEe = 4.49D-5         ! +-0.22, was 4.46, where from?
      BrOm3Pi = 0.888D0         ! +-0.007, not changed
      BrOmPi0G= 0.085           ! +-0.005, not changed
      BrOmEtaG= 6.5D-4          ! +-1.0, was 8.3+-2.1
      BrOm2Pi = 0.0221D0        ! +-0.003, not changed
      PhOm2Pi = 90.D0           ! not touched
      BrOmEe = 7.07D-5          ! +-0.19, was 7.15+-0.19
      BrPhi2Kc = 0.491D0        ! +-0.008, was +-0.06
      BrPhiKsKl= 0.341D0        ! +-0.006, was 0.343, where from?
      BrPhi3Pi = 0.155D0        ! +-0.007, was 0.154, where from?
      BrPhiPi0G= 1.31D-3        ! +-0.13, not changed
      BrPhiEtaG= 1.26D-2        ! +-0.06, was 1.28, where from?
      BrPhi2Pi = 8.D-5          ! +5-4, not changed
      PhPhi2Pi = -20.D0         ! not touched
      BrPhiEe = 2.99D-4         ! +-0.08, was 3.09, where from?
c      Pi = 3.1415926D0         ! not touched
      MeVnb = 3.8938D+11        ! was 3.894
      Alpha = 1.D0/137.036D0    ! not touched
      AOmRho = 3.D0             ! not touched
      ARhoPRho = 0.72           ! +-.03 amplitude ratio for RhoP and Rho in pi0pi0g decay
      ct=0. ! contact term for omega -> 3 pi decay
      mssig = 600.
      gsig = 500.
      brsigpipi = 1.

c --- parameters of interaction (1/MeV)
      rrho = 1.0d0/msrho
      rom = 1.0d0/msom
      rphi = 1.0d0/msphi

c --- fill data for pi0 pi0 gamma decay
      msrho1450 = 1465.
      msrho1700 = 1700.
      grho1450 = 310.
      grho1700 = 240.
      arhoompi0 = 1.
      arho1450ompi0 = 1.
      arho1700ompi0 = 1.
      phrhoompi0 = 0.
      phrho1450ompi0 = 180.
      phrho1700ompi0 = 0.
      aomrhopi0 = 1.
      phomrhopi0 = 0.
      arhopi0pi0g = 0.
      aompi0pi0g = 0.
      phrhopi0pi0g = 0.
      phompi0pi0g = 0.
      brrho1450ompi0 = 0.02
      brrho1450pipi = 0.50
      brrho1700ompi0 = 1.0
      brrho1700pipi = 0.02
      aphirhopi0 = 1.
      phphirhopi0 = 180.
      arhosigg = 0.
      phrhosigg = 0.
      aomsigg = 0.
      phomsigg = 0.

C========= Reading arrays with phase space integral from input file

      if (NPOIM.eq.0) then

c================================================================
c Opening file wrhopi.wid with tabulated data 
c================================================================

         is=KASCIF(12,'M:wrhopi.wid',0,istat)
         if(is.ne.0)then
           write(6,*)' ## IniFit: Unable open M:wrhopi.wid; ISTAT=',
     &       istat, ', is=',is
           return     
         end if     
         npoim=nstep
         read  (12,2)npoint,femin,festep
         EMIN=FEMIN
         ESTEP=FESTEP
         NPOINT = min(NPOINT,NSTEP)
         write (6,3) npoint,emin,estep
         read (12,1) (f3pi(i), i=1,npoint)
         do I=1,NPOINT
           PS3PI(I)=F3PI(I)
         end do
         close(12)
         write (6,*) ' ## inifit: file m:wropi.wid have been read' 
       end if
1      FORMAT(1x,5F9.5)
2      FORMAT(' ## WRhoPi:', I6,' Points, Emin=',F8.2,'; Estep=',F6.2)
3      FORMAT('  ## WRhoPi:', I6,' Points, Emin=',F8.2,'; Estep=',F6.2)
       end


c+++       How to set/get fit parameters:
c+++ R8 setfitp( I4 index, R8 newval ) sets fit parameter via index (returns oldval)
c+++    if idx<0 then gets the old value of parameter (newval is not used)
c+++ R8 getfitp( I4 index ) gets fit parameter via index
c+++ I4 setfitall( I4 vlen, R8 vdat ) sets all fit parameters, returns old values
c+++ I4 getfitall( I4 vlen, R8 vdat ) gets all fit parameters
c+++
      real*8 function setfitp( id, newval )
      implicit none
      include 'fitdata.inc'
      integer id
      real*8 newval
      character*80 name
      character*80 desc
      common /setfit001/ name, desc
c
      integer idx
      integer n
      real*8 vals(2)
      logical init /.true./
      save init
      if ( init ) then
        call inifit
        init = .false.
      endif
c
      vals(1) = 0.
      vals(2) = newval
      idx = id
      if ( idx.lt.0 ) then
        n = 1
        idx = -idx
      else
        n = 2
      endif

      if ( idx.eq.1 ) then
        vals(1) = mspi
c+++
c+++      The list of parameter indices follows:
c+++               Some masses:                
c+++     1 mspi                  2 mspi0                 3 mseta
c+++     4 msetap                5 msks                  6 mskc
c+++     7 msrho                 8 msom                  9 msphi
c+++    10 msk892               11 msk0892              12 msf0
c+++    13 msa0
c+++               Some widths:
c+++    14 grho                 15 gom                  16 gphi
c+++    17 gk892                18 gk0892
c+++               Some phases:
c+++    19 phrho                20 phom                 21 phphi
c+++    22 phrhop
c+++               Some branchings:
c+++    23 brrhopig             24 brrhoetag            25 brrhoee
c+++    26 brom3pi              27 brompi0g             28 brometag
c+++    29 brom2pi              30 phom2pi              31 bromee
c+++    32 brphi2kc             33 brphikskl            34 brphi3pi
c+++    35 brphipi0g		36 brphietag		37 brphi2pi
c+++    38 phphi2pi		39 brphiee		40 alpha
c+++    41 msrho1450		42 msrho1700		43 grho1450
c+++	44 grho1700		45 brrho1450ompi0	46 brrho1450pipi
c+++	47 brrho1700ompi0	48 brrho1700pipi        49 mssig
c+++    50 gsig                 51 brsigpipi            52 rrho
c+++    53 rom                  54 rphi                 55 brrhopi0g
c+++
        mspi = vals(n)
	name = 'mspi'
	desc = 'charged pion mass'
      else if ( idx.eq.2 ) then
        vals(1) = mspi0
        mspi0 = vals(n)
        name = 'mspi0'
        desc = 'neutral pion mass'
      else if ( idx.eq.3 ) then
        vals(1) = mseta
        mseta = vals(n)
        name = 'mseta'
        desc = 'eta meson mass'
      else if ( idx.eq.4 ) then
        vals(1) = msetap
        msetap = vals(n)
        name = 'msetap'
        desc = 'eta prime mass'
      else if ( idx.eq.5 ) then
        vals(1) = msks
        msks = vals(n)
        name = 'msks'
        desc = 'neutral kaon mass'
      else if ( idx.eq.6 ) then
        vals(1) = mskc
        mskc = vals(n)
        name = 'mskc'
        desc = 'charged kaon mass'
      else if ( idx.eq.7 ) then
        vals(1) = msrho
        msrho = vals(n)
        name = 'msrho'
        desc = 'rho meson mass'
      else if ( idx.eq.8 ) then
        vals(1) = msom
        msom = vals(n)
        name = 'msom'
        desc = 'omega meson mass'
      else if ( idx.eq.9 ) then
        vals(1) = msphi
        msphi = vals(n)
        name = 'msphi'
        desc = 'phi meson mass'
      else if ( idx.eq.10) then
        vals(1) = msk892
        msk892 = vals(n)
        name = 'msk892'
        desc = 'charged kaon(892) mass'
      else if ( idx.eq.11) then
        vals(1) = msk0892
        msk0892 = vals(n)
        name = 'msk0892'
        desc = 'neutral kaon(892) mass'
      else if ( idx.eq.12) then
        vals(1) = msf0
        msf0 = vals(n)
        name = 'msf0'
        desc = 'f0 meson mass'
      else if ( idx.eq.13) then
        vals(1) = msa0
        msa0 = vals(n)
        name = 'msa0'
        desc = 'a0 meson mass'
      else if ( idx.eq.14) then
        vals(1) = grho
        grho = vals(n)
        name = 'grho'
        desc = 'rho meson width'
      else if ( idx.eq.15) then
        vals(1) = gom
        gom = vals(n)
        name = 'gom'
        desc = 'omega meson width'
      else if ( idx.eq.16) then
        vals(1) = gphi
        gphi = vals(n)
        name = 'gphi'
        desc = 'phi meson width'
      else if ( idx.eq.17) then
        vals(1) = gk892
        gk892 = vals(n)
        name = 'gk892'
        desc = 'charged kaon(892) width'
      else if ( idx.eq.18) then
        vals(1) = gk0892
        gk0892 = vals(n)
        name = 'gk0892'
        desc = 'neutral kaon(892) width'
      else if ( idx.eq.19) then
        vals(1) = phrho
        phrho = vals(n)
        name = 'phrho'
        desc = 'rho meson phase'
      else if ( idx.eq.20) then
        vals(1) = phom
        phom = vals(n)
        name = 'phom'
        desc = 'omega meson phase'
      else if ( idx.eq.21) then
        vals(1) = phphi
        phphi = vals(n)
        name = 'phphi'
        desc = 'phi meson phase'
      else if ( idx.eq.22) then
        vals(1) = phrhop
        phrhop = vals(n)
        name = 'phrhop'
        desc = 'rho prime meson phase'
      else if ( idx.eq.23) then
        vals(1) = brrhopig
        brrhopig = vals(n)
        name = 'brrhopig'
        desc = 'branching rho+ -> pi+ gamma'
      else if ( idx.eq.24) then
        vals(1) = brrhoetag
        brrhoetag = vals(n)
        name = 'brrhoetag'
        desc = 'branching rho -> eta gamma'
      else if ( idx.eq.25) then
        vals(1) = brrhoee
        brrhoee = vals(n)
        name = 'brrhoee'
        desc = 'branching rho -> e+e-'
      else if ( idx.eq.26) then
        vals(1) = brom3pi
        brom3pi = vals(n)
        name = 'brom3pi'
        desc = 'branching omega -> 3pi'
      else if ( idx.eq.27) then
        vals(1) = brompi0g
        brompi0g = vals(n)
        name = 'brompi0g'
        desc = 'branching omega -> pi0 gamma'
      else if ( idx.eq.28) then
        vals(1) = brometag
        brometag = vals(n)
        name = 'brometag'
        desc = 'branching omega -> eta gamma'
      else if ( idx.eq.29) then
        vals(1) = brom2pi
        brom2pi = vals(n)
        name = 'brom2pi'
        desc = 'branching omega -> 2pi'
      else if ( idx.eq.30) then
        vals(1) = phom2pi
        phom2pi = vals(n)
        name = 'phom2pi'
        desc = 'phase omega -> 2pi'
      else if ( idx.eq.31) then
        vals(1) = bromee
        bromee = vals(n)
        name = 'bromee'
        desc = 'branching omega -> e+e-'
      else if ( idx.eq.32) then
        vals(1) = brphi2kc
        brphi2kc = vals(n)
        name = 'brphi2kc'
        desc = 'branching phi -> K+K-'
      else if ( idx.eq.33) then
        vals(1) = brphikskl
        brphikskl = vals(n)
        name = 'brphikskl'
        desc = 'branching phi -> KsKl'
      else if ( idx.eq.34) then
        vals(1) = brphi3pi
        brphi3pi = vals(n)
        name = 'brphi3pi'
        desc = 'branching phi -> 3pi'
      else if ( idx.eq.35) then
        vals(1) = brphipi0g
        brphipi0g = vals(n)
        name = 'brphipi0g'
        desc = 'branching phi -> pi0 gamma'
      else if ( idx.eq.36) then
        vals(1) = brphietag
        brphietag = vals(n)
        name = 'brphietag'
        desc = 'branching phi -> eta gamma'
      else if ( idx.eq.37) then
        vals(1) = brphi2pi
        brphi2pi = vals(n)
        name = 'brphi2pi'
        desc = 'branching phi -> 2pi'
      else if ( idx.eq.38) then
        vals(1) = phphi2pi
        phphi2pi = vals(n)
        name = 'phphi2pi'
        desc = 'phase phi -> 2pi'
      else if ( idx.eq.39) then
        vals(1) = brphiee
        brphiee = vals(n)
        name = 'brphiee'
        desc = 'branching phi -> e+e-'
      else if ( idx.eq.40) then
        vals(1) = alpha
        alpha = vals(n)
        name = 'alpha'
        desc = 'fine structure constant alpha'
      else if ( idx.eq.41) then
        vals(1) = msrho1450
        msrho1450 = vals(n)
        name = 'msrho1450'
        desc = 'rho(1450) mass'
      else if ( idx.eq.42) then
        vals(1) = msrho1700
        msrho1700 = vals(n)
        name = 'msrho1700'
        desc = 'rho(1700) mass'
      else if ( idx.eq.43) then
        vals(1) = grho1450
        grho1450 = vals(n)
        name = 'grho1450'
        desc = 'rho(1450) width'
      else if ( idx.eq.44) then
        vals(1) = grho1700
        grho1700 = vals(n)
        name = 'grho1700'
        desc = 'rho(1700) width'
      else if ( idx.eq.45) then
        vals(1) = brrho1450ompi0
        brrho1450ompi0 = vals(n)
        name = 'brrho1450ompi0'
        desc = 'branching rho(1450) -> omega pi0'
      else if ( idx.eq.46) then
        vals(1) = brrho1450pipi
        brrho1450pipi = vals(n)
        name = 'brrho1450pipi'
        desc = 'branching rho(1450) -> pipi'
      else if ( idx.eq.47) then
        vals(1) = brrho1700ompi0
        brrho1700ompi0 = vals(n)
        name = 'brrho1700ompi0'
        desc = 'branching rho(1700) -> omega pi0'
      else if ( idx.eq.48) then
        vals(1) = brrho1700pipi
        brrho1700pipi = vals(n)
        name = 'brrho1700pipi'
        desc = 'branching rho(1700) -> pipi'
      else if ( idx.eq.49) then
        vals(1) = mssig
        mssig = vals(n)
        name = 'mssig'
	desc = 'sigma(600) mass'
      else if ( idx.eq.50) then
        vals(1) = gsig
        gsig = vals(n)
        name = 'gsig'
	desc = 'sigma(600) width'
      else if ( idx.eq.51) then
        vals(1) = brsigpipi
        brsigpipi = vals(n)
        name = 'brsigpipi'
        desc = 'branching sigma(600) -> pipi'
      else if ( idx.eq.52) then
        vals(1) = rrho
        rrho = vals(n)
        name = 'rrho'
        desc = 'rho meson "radius"'
      else if ( idx.eq.53) then
        vals(1) = rom
        rom = vals(n)
        name = 'rom'
        desc = 'omega meson "radius"'
      else if ( idx.eq.54) then
        vals(1) = rphi
        rphi = vals(n)
	name = 'rphi'
	desc = 'phi meson "radius"'
      else if ( idx.eq.55 ) then
        vals(1) = brrhopi0g
        brrhopi0g = vals(n)
        name = 'brrhopi0g'
        desc = 'branching rho -> pi0 gamma'
      else
c ATTENTION: the value here is maximal index allowed
        vals(1) = -1e+15
        name = 'unknown'
        desc = 'unknown'
      endif
      setfitp = vals(1)
      end


      real*8 function getfitp( id )
      implicit none
      integer id
      real*8 setfitp
      getfitp = setfitp( -abs(id), 0.d0 )
      end


c+++ subr outfitp() output all fitdata.inc parameters
      subroutine outfitp
      implicit none
      include 'fitdata.inc'
      real*8 getfitp, parval
      integer i
      character*80 name
      character*80 desc
      common /setfit001/ name, desc
      integer kstrtrim
      character*12 chval

c
      name = ' '
      desc = ' '
      i = 1
      write (6,*) '  fitdata.inc parameters (masses and widths in MeV):'
      do while ( name.ne.'unknown' )

        parval = getfitp(i)
        if ( name.ne.'unknown' ) then
	  
          call db1024( parval, 12, chval )
          write (6,5) i, name, chval, desc(1:kstrtrim(desc))
5         format(1x,i3,1x,a20,a12,2x,a)

        endif

        i = i + 1
      enddo
      end
