c+++      Functions to get coupling constants
c+++ R8 cpgrhopipi() = g_{\rho\pi\pi} (dimensionless)
c+++      depends on Grho, MsRho, MsPi
      real*8 function cpgrhopipi()
      implicit none
      include 'fitdata.inc'
c --- cache
      logical firstpass /.true./
      real*8 grho_cached
      real*8 msrho_cached
      real*8 mspi_cached
      real*8 cpgrhopipi_cached
      save firstpass
      save grho_cached, cpgrhopipi_cached, msrho_cached, mspi_cached
      real*8 phsp2
c ---
      if ( firstpass ) then
        call inifit
        grho_cached = -1
        msrho_cached = -1
        mspi_cached = -1
        firstpass = .false.
      endif
c --- reference: many, for example Achasov, hep-ph/9609216 (2.13)
      if ( grho_cached.ne.grho .or.
     &  msrho.ne.msrho_cached .or.
     &  mspi.ne.mspi_cached ) then
        grho_cached = grho
        msrho_cached = msrho
        mspi_cached = mspi
        cpgrhopipi_cached = sqrt( grho * 6.0d0 * pi /
     &    phsp2(msrho,mspi,mspi)**3 ) * msrho
      endif
      cpgrhopipi = cpgrhopipi_cached
      end


c+++ R8 cpgrhoompi() = g_{\rho\omega\pi} is identically equal to
c+++ R8 cpgomrhopi() = g_{\omega\rho\pi} ( 1/MeV ) - coupling constant
c+++      depends on sp3pi(e) which depends on MsOm
      real*8 function cpgrhoompi()
      implicit none
      real*8 cpgomrhopi
      cpgrhoompi = cpgomrhopi()
      end

      real*8 function cpgomrhopi()
      implicit none
      include 'fitdata.inc'
      real*8 sp3pi
c --- cache
      logical firstpass /.true./
      save firstpass
      real*8 msom_cached, gom_cached, brom3pi_cached, sp3pi_cached
      save msom_cached, gom_cached, brom3pi_cached, sp3pi_cached
      real*8 cpgomrhopi_cached
      save cpgomrhopi_cached
c ---
      if ( firstpass ) then
        call inifit
        firstpass = .false.
        gom_cached = -1
        brom3pi_cached = -1
        msom_cached = -1
        sp3pi_cached = -1
      endif
      if ( msom_cached.ne.msom .or.
     &  gom_cached.ne.gom .or.
     &  brom3pi_cached.ne.brom3pi ) then
        if ( msom_cached.ne.msom ) sp3pi_cached = sp3pi(msom)
        gom_cached = gom
        brom3pi_cached = brom3pi
        cpgomrhopi_cached =
     &    sqrt( 4.0d0 * pi * gom * brom3pi / sp3pi_cached )
      endif
      cpgomrhopi = cpgomrhopi_cached
      end

c+++ R8 cpfrho() = f_{\rho} - rho leptonic coupling constant
c+++      depends on GRho, BrRhoee, MsRho
      real*8 function cpfrho()
      implicit none
      include 'fitdata.inc'
c --- cache
      logical firstpass /.true./
      save firstpass
      real*8 grho_cached
      real*8 brrhoee_cached
      real*8 msrho_cached
      real*8 cpfrho_cached
      save grho_cached, brrhoee_cached, msrho_cached, cpfrho_cached
c ---
      if ( firstpass ) then
        call inifit
        grho_cached = -1
        brrhoee_cached = -1
        msrho_cached = -1
        firstpass = .false.
      endif
      if ( grho_cached.ne.grho .or.
     &  brrhoee_cached.ne.brrhoee .or.
     &  msrho_cached.ne.msrho ) then
        grho_cached = grho
        brrhoee_cached = brrhoee
        msrho_cached = msrho
        cpfrho_cached = alpha * sqrt( 4.0d0 * pi / 3.0d0 * msrho /
     &    (grho * brrhoee))
      endif
      cpfrho = cpfrho_cached
      end

c+++ R8 cpfom() = f_{\omega} - omega leptonic coupling constant
c+++      depends on GOm, BrOmee, MsOm
      real*8 function cpfom()
      implicit none
      include 'fitdata.inc'
c --- cache
      logical firstpass /.true./
      save firstpass
      real*8 gom_cached
      real*8 bromee_cached
      real*8 msom_cached
      real*8 cpfom_cached
      save gom_cached, bromee_cached, msom_cached, cpfom_cached
c ---
      if ( firstpass ) then
        call inifit
        gom_cached = -1
        bromee_cached = -1
        msom_cached = -1
        firstpass = .false.
      endif
      if ( gom_cached.ne.gom .or.
     &  bromee_cached.ne.bromee .or.
     &  msom_cached.ne.msom ) then
        gom_cached = gom
        bromee_cached = bromee
        msom_cached = msom
        cpfom_cached = alpha * sqrt( 4.0d0 * pi / 3.0d0 * msom /
     &    (gom * bromee))
      endif
      cpfom = cpfom_cached
      end

c+++ R8 cpfphi() = f_{\phi} - phi leptonic coupling constant
c+++      depends on GPhi, BrPhiee, MsPhi
      real*8 function cpfphi()
      implicit none
      include 'fitdata.inc'
c --- cache
      logical firstpass /.true./
      save firstpass
      real*8 gphi_cached
      real*8 brphiee_cached
      real*8 msphi_cached
      real*8 cpfphi_cached
      save gphi_cached, brphiee_cached, msphi_cached, cpfphi_cached
c ---
      if ( firstpass ) then
        call inifit
        gphi_cached = -1
        brphiee_cached = -1
        msphi_cached = -1
        firstpass = .false.
      endif
      if ( gphi_cached.ne.gphi .or.
     &  brphiee_cached.ne.brphiee .or.
     &  msphi_cached.ne.msphi ) then
        gphi_cached = gphi
        brphiee_cached = brphiee
        msphi_cached = msphi
        cpfphi_cached = alpha * sqrt( 4.0d0 * pi / 3.0d0 * msphi /
     &    (gphi * brphiee))
      endif
      cpfphi = cpfphi_cached
      end
