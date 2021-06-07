c-----------------------------------------------------------------------
c    A parametrization of cross section ee -> something -> pi0 pi0 gamma
c  crppg = Re( ampv(i) * sigm(i,j) * conjg(ampv(j)) )
c  Indices i, j run across 1...4, where
c    1 - intermediate state of \omega\pi0,
c    2 - intermediate state of \rho\pi0,
c    3 - direct \pi0\pi0\gamma decay.
c    4 - intermediate states \sigma\gamma      
c  ampv(1:4) - complex vector of amplitudes, including propagators,
c     particularly, now it contains:
c    1 - rho(770), rho(1450), rho(1700)
c    2 - omega(782), phi(1020)
c    3 - rho(770), omega(782)
c    4 - rho(770), omega(782)
c  sigm(1:4,1:4) - complex interference matrix, describing the phase space
c    dependence on s.  It was calculated using procedure cphppg, and then
c    approximated.
c-----------------------------------------------------------------------
c+++ R8 crppg( R8 e2 ) cross section of pi0 pi0 gamma
      real*8 function crppg( e2 )
      implicit none
      include 'fitdata.inc'
      real*8 e2

c --- data
      integer nstates
      parameter (nstates=4)
      integer nmat
      parameter (nmat=nstates*nstates)
      integer nodes
      parameter (nodes=15)
      integer nodyy
      parameter (nodyy=nodes*2)
      real*8 vf(nodyy,nmat)
c      character*40 csfile
c      parameter (csfile='/home/bukind/gener/crsppg.crs')
      save vf
      data vf /
     &  -0.19089125E-07,   0.32273148E-04,   0.15628741E-05,   0.59332361E-04,
     &   0.64790723E-05,   0.14665756E-03,   0.17793165E-04,   0.29792492E-03,
     &   0.38776969E-04,   0.55379905E-03,   0.74154915E-04,   0.96711739E-03,
     &   0.14585837E-03,   0.18268722E-02,   0.24256192E-03,   0.34614911E-02,
     &   0.61847068E-03,   0.86934797E-02,   0.24321912E-02,   0.47581444E-01,
     &   0.52962468E-02,   0.42134964E+00,   0.12379127E+00,   0.70175479E+00,
     &   0.21287338E+00,  -0.78414770E-01,   0.96129450E-01,  -0.12061843E+00,
     &   0.55614024E-01,  -0.71440396E-01,  -0.30658879E-08,   0.56630216E-05,
     &   0.31074369E-06,   0.11221506E-04,   0.12906063E-05,   0.29985960E-04,
     &   0.35324154E-05,   0.59500715E-04,   0.77055338E-05,   0.10564256E-03,
     &   0.14760598E-04,   0.17331956E-03,   0.28836588E-04,   0.29793923E-03,
     &   0.48331707E-04,   0.48872906E-03,   0.11887953E-03,   0.12134901E-02,
     &   0.35042940E-03,   0.39246204E-02,   0.43985683E-03,   0.83026871E-02,
     &   0.22031139E-02,   0.11726667E-01,   0.36819075E-02,  -0.10728835E-02,
     &   0.17248290E-02,  -0.20608574E-02,   0.10209317E-02,  -0.11453780E-02,
     &   0.42186381E-05,   0.69634687E-04,   0.15184055E-04,   0.29506199E-03,
     &   0.33035862E-04,   0.38704544E-03,   0.55672849E-04,   0.39173748E-03,
     &   0.80538196E-04,   0.46724948E-03,   0.10696470E-03,   0.46041911E-03,
     &   0.13976636E-03,   0.42108637E-03,   0.16837850E-03,   0.53494584E-03,
     &   0.22682099E-03,   0.65875001E-03,   0.32831289E-03,   0.15996977E-02,
     &   0.35346526E-03,   0.22250770E-02,   0.47487028E-03,  -0.27526388E-03,
     &   0.27211460E-03,  -0.10624051E-02,  -0.46990841E-04,  -0.83275955E-04,
     &  -0.58436956E-04,  -0.28401010E-04,  -0.27774245E-05,  -0.87315625E-04,
     &  -0.20424645E-04,  -0.65193828E-03,  -0.74175790E-04,  -0.14530627E-02,
     &  -0.13367709E-03,  -0.19695237E-03,  -0.83863497E-04,   0.18548723E-02,
     &  -0.10610284E-07,   0.13383589E-02,   0.56389268E-04,   0.56684991E-03,
     &   0.78047518E-04,   0.27668401E-03,   0.93082235E-04,   0.74130731E-04,
     &   0.10330859E-03,   0.19027387E-03,   0.97441296E-04,  -0.85886566E-03,
     &  -0.18666899E-03,  -0.16623323E-02,  -0.32683838E-03,   0.45947800E-03,
     &  -0.80053358E-04,   0.16248822E-03,  -0.34776914E-04,   0.77171264E-04,
     &   0.95222949E-09,  -0.22153924E-07,   0.24680325E-09,   0.72513606E-07,
     &   0.65278624E-09,   0.14464377E-06,   0.15320556E-07,   0.96186175E-06,
     &   0.99308577E-07,   0.39751190E-05,   0.38500887E-06,   0.12408898E-04,
     &   0.14468358E-05,   0.38425097E-04,   0.37316109E-05,   0.10105187E-03,
     &   0.20463452E-04,   0.44039519E-03,   0.17822148E-03,   0.40095825E-02,
     &   0.31182639E-03,   0.97163276E-02,   0.98379294E-03,   0.12875753E-02,
     &   0.87043068E-03,  -0.11787310E-02,   0.23274709E-03,  -0.38743773E-03,
     &   0.11686107E-03,  -0.21176884E-03,   0.14659881E-08,   0.10231932E-06,
     &   0.15547955E-07,   0.54598425E-06,   0.64210430E-07,   0.14979308E-05,
     &   0.17597405E-06,   0.29769889E-05,   0.38458480E-06,   0.52978912E-05,
     &   0.73824791E-06,   0.86935866E-05,   0.14471296E-05,   0.14908452E-04,
     &   0.24384418E-05,   0.24476888E-04,   0.60752847E-05,   0.62513170E-04,
     &   0.18434064E-04,   0.20964059E-03,   0.22711653E-04,   0.25041694E-03,
     &   0.57892810E-04,   0.23096119E-03,   0.85124571E-04,  -0.19767060E-04,
     &   0.44104882E-04,  -0.49069808E-04,   0.27456219E-04,  -0.27009988E-04,
     &   0.40183774E-06,   0.90945864E-05,   0.15069456E-05,   0.29824074E-04,
     &   0.32821054E-05,   0.38743616E-04,   0.55376267E-05,   0.39027054E-04,
     &   0.80206315E-05,   0.46643167E-04,   0.10664756E-04,   0.46132217E-04,
     &   0.13952420E-04,   0.42098403E-04,   0.16821654E-04,   0.52564495E-04,
     &   0.22567227E-04,   0.60179656E-04,   0.30553814E-04,   0.89505696E-04,
     &   0.31271091E-04,   0.75451569E-04,   0.34937411E-04,  -0.30401310E-04,
     &   0.20322282E-04,  -0.73508892E-04,  -0.64034385E-05,  -0.10834541E-04,
     &  -0.87188562E-05,  -0.61128196E-06,  -0.25503347E-06,  -0.11451878E-04,
     &  -0.20286234E-05,  -0.65668116E-04,  -0.73731789E-05,  -0.14546432E-03,
     &  -0.13327246E-04,  -0.21387728E-04,  -0.85408962E-05,   0.18048812E-03,
     &  -0.48089681E-06,   0.12740942E-03,   0.46502251E-05,   0.48202710E-04,
     &   0.62034404E-05,   0.13356771E-04,   0.57065711E-05,  -0.26352462E-04,
     &   0.35335765E-07,  -0.10359423E-03,  -0.18821800E-05,  -0.11656104E-03,
     &  -0.17309715E-04,  -0.76410166E-04,  -0.22778165E-04,   0.34168176E-04,
     &  -0.56841564E-05,   0.11494601E-04,  -0.25374014E-05,   0.44582002E-05,
     &  -0.44764051E-10,  -0.40738293E-08,  -0.35742383E-10,   0.12423647E-08,
     &  -0.20245864E-09,  -0.22590972E-07,  -0.67519789E-09,  -0.54308686E-07,
     &  -0.18572190E-08,  -0.12632143E-06,  -0.46838040E-08,  -0.23514852E-06,
     &  -0.13818149E-07,  -0.71660431E-06,  -0.23392256E-07,  -0.19715821E-05,
     &  -0.10914541E-06,  -0.51120681E-05,  -0.12319686E-05,  -0.44780609E-04,
     &  -0.68071433E-05,  -0.89067301E-03,  -0.22547179E-03,  -0.18554551E-02,
     &  -0.51275491E-03,  -0.29591465E-03,  -0.35299464E-03,   0.33439585E-03,
     &  -0.23415835E-03,   0.35918993E-03,   0.75003720E-10,  -0.83902301E-08,
     &   0.73658537E-12,  -0.45493224E-09,  -0.29511025E-09,  -0.25101578E-07,
     &  -0.78360268E-08,  -0.28603398E-06,  -0.40782403E-07,  -0.10213879E-05,
     &  -0.12126257E-06,  -0.20159660E-05,  -0.32084523E-06,  -0.39590851E-05,
     &  -0.62681382E-06,  -0.73111936E-05,  -0.18166681E-05,  -0.19851866E-04,
     &  -0.61297461E-05,  -0.79161739E-04,  -0.72845203E-05,  -0.91394900E-04,
     &  -0.21254935E-04,  -0.95841909E-04,  -0.36821789E-04,  -0.12477472E-04,
     &  -0.24818617E-04,   0.22714318E-04,  -0.16866488E-04,   0.14877697E-04,
     &   0.22544342E-03,   0.37361332E-02,   0.38494701E-03,   0.24871804E-02,
     &   0.47912467E-03,   0.12646418E-02,   0.52054112E-03,   0.37548082E-03,
     &   0.52922001E-03,  -0.14428303E-03,   0.51813364E-03,  -0.43537367E-03,
     &   0.49092507E-03,  -0.59360246E-03,   0.46326437E-03,  -0.58569150E-03,
     &   0.41093711E-03,  -0.56831447E-03,   0.35677625E-03,  -0.47421033E-03,
     &   0.34570718E-03,  -0.47402911E-03,   0.28776780E-03,  -0.39534251E-03,
     &   0.20646835E-03,  -0.25422963E-03,   0.97586343E-04,  -0.90197477E-04,
     &   0.69592568E-04,  -0.55118134E-04,  -0.15702372E-03,  -0.46916887E-02,
     &  -0.54195618E-03,  -0.10101454E-01,  -0.11184889E-02,  -0.11187251E-01,
     &  -0.12972893E-02,   0.78761689E-02,  -0.57107647E-03,   0.16396531E-01,
     &   0.62970590E-08,   0.67547611E-02,   0.20458648E-03,   0.11510347E-02,
     &   0.22054525E-03,  -0.25579130E-03,   0.17125618E-03,  -0.64964959E-03,
     &   0.11283047E-03,  -0.47406903E-03,   0.10242053E-03,  -0.41925702E-03,
     &   0.57426682E-04,  -0.23644661E-03,   0.19933446E-04,  -0.70419546E-04,
     &   0.19532071E-05,  -0.79714917E-05,   0.59433570E-06,  -0.44319015E-05,
     &  -0.24068764E-07,  -0.26904229E-04,  -0.32915986E-05,  -0.17326169E-03,
     &  -0.31315321E-04,  -0.11547858E-02,  -0.14495969E-03,  -0.31307570E-02,
     &  -0.28508956E-03,  -0.17959018E-02,  -0.33908090E-03,  -0.27651246E-03,
     &  -0.35134821E-03,   0.14938095E-03,  -0.35650190E-03,  -0.43878815E-04,
     &  -0.37333520E-03,  -0.24035002E-03,  -0.43790348E-03,  -0.13757201E-02,
     &  -0.46420858E-03,  -0.29052204E-02,  -0.51397531E-03,   0.11980837E-02,
     &  -0.16773003E-03,   0.87002651E-03,   0.13213732E-04,   0.14911876E-04,
     &   0.10091899E-04,   0.52937002E-05,  -0.14334874E-08,  -0.28006108E-05,
     &  -0.32712086E-06,  -0.17274025E-04,  -0.31129661E-05,  -0.11497357E-03,
     &  -0.14399932E-04,  -0.31138621E-03,  -0.28349160E-04,  -0.18002418E-03,
     &  -0.33827231E-04,  -0.30261992E-04,  -0.35257079E-04,   0.11732210E-04,
     &  -0.35990227E-04,  -0.68663549E-05,  -0.38003188E-04,  -0.21791398E-04,
     &  -0.42197183E-04,  -0.49418832E-04,  -0.41950968E-04,  -0.38158070E-04,
     &  -0.36618230E-04,   0.98434486E-04,  -0.12512847E-04,   0.65232357E-04,
     &   0.19461393E-05,   0.15829820E-05,   0.16427167E-05,  -0.51714986E-06,
     &  -0.70499059E-05,  -0.54997269E-03,  -0.86923426E-04,  -0.34080061E-02,
     &  -0.47293793E-03,  -0.13358422E-01,  -0.14106204E-02,  -0.20335606E-01,
     &  -0.19464011E-02,   0.49798395E-03,  -0.17011027E-02,   0.78751063E-02,
     &  -0.12750588E-02,   0.64380803E-02,  -0.10071766E-02,   0.46031871E-02,
     &  -0.68573836E-03,   0.27724496E-02,  -0.46903781E-03,   0.16527584E-02,
     &  -0.43351692E-03,   0.14210472E-02,  -0.27969607E-03,   0.84847529E-03,
     &  -0.13249651E-03,   0.33415615E-03,  -0.27173516E-04,   0.55991380E-04,
     &  -0.13336727E-04,   0.25792634E-04,   0.31407157E-04,   0.14992796E-02,
     &   0.22823988E-03,   0.72612912E-02,   0.89335276E-03,   0.20134697E-01,
     &   0.20451780E-02,   0.18912195E-01,   0.22489474E-02,  -0.10321527E-01,
     &   0.16135556E-02,  -0.13516859E-01,   0.97963376E-03,  -0.82109814E-02,
     &   0.66092659E-03,  -0.49922808E-02,   0.34951591E-03,  -0.23404663E-02,
     &   0.18715357E-03,  -0.11012084E-02,   0.16474284E-03,  -0.87243977E-03,
     &   0.81136740E-04,  -0.38698178E-03,   0.24965190E-04,  -0.93955558E-04,
     &   0.22086529E-05,  -0.10610100E-04,   0.60250814E-06,  -0.66678889E-05
     &  /

c --- parameters
      complex*16 ii
      parameter (ii = (0.,1.d0))

c --- functions
c      integer kascif
      real*8 xphppg, sp3pi, cr3pi
      complex*16 ddprho, ddpom, ddprho1450, ddprho1700, ddpphi

c --- vars
      complex*16 sigm(nstates,nstates)
      complex*16 ampv(nstates)
      complex*16 camp(nstates)
      complex*16 melm
      complex*16 prho, pome
      real*8 s
      integer i, j
      logical init /.true./
      save init
      real*8 phiomratio
      save phiomratio
c      integer lun, ok, istat
      real*8 ratio(4), cs1, cs2
      save ratio

      real*8 ccrhoompi

c+++ (Arwp,Prwp), (Arrwp,Prrwp), (Arrrwp,Prrrwp),
c+++ (Awrp,Pwrp), (Arppg,Prppg), (Awppg,Pwppg), Gom, Mrrho
      if ( init ) then
        init = .false.
        call inifit
c        lun = 0
c        ok = kascif( lun, csfile, 0, istat )
c        if ( ok.ne.0 ) then
c          write (6,*) 'cannot open ',csfile,' istat=',istat
c          stop
c        endif
c        read (lun,*,iostat=istat) vf
c        if ( ok.ne.0 ) then
c          write (6,*) 'i/o error file ',csfile,' istat=',istat
c          stop
c        else
c          write (6,*) 'constants for crsppg were loaded from',csfile
c        endif

c --- calculate initial normalization for:
c 1) rho->ppg,  2) om->ppg,  3) rho->sigmag,  4) om->sigmag
c rho is normalized to process rho->ompi0,
c omega is normalized to process om->rhopi0
        cs1 = xphppg(msrho,vf(1,1))
        ratio(1) = sqrt(cs1/xphppg(msrho,vf(1,2*nstates+3)))
        ratio(3) = sqrt(cs1/xphppg(msrho,vf(1,3*nstates+4)))
        cs1 = xphppg(msom,vf(1,nstates+2))
        ratio(2) = sqrt(cs1/xphppg(msom,vf(1,2*nstates+3)))
        ratio(4) = sqrt(cs1/xphppg(msom,vf(1,3*nstates+4)))
        write (6,*) ' Ratio coefficients:'
        write (6,*) '    rho->omp /rho->ppg  :',ratio(1)
        write (6,*) '    om ->rhop/om ->ppg  :',ratio(2)
        write (6,*) '    rho->omp /rho->sigg :',ratio(3)
        write (6,*) '    om ->rhop/om ->sigg :',ratio(4)
c
        cs1 = cr3pi(msom)/brom3pi
        write (6,*) ' ee->omega cross section:',cs1
        cs2 = xphppg(msom,vf(1,nstates+2))*abs(msom**2/ddpom(msom))**2
        write (6,*) ' ee->omega->rho pi0   cs:',cs2
        write (6,*) ' omega->rho pi0 calculated branching:',cs2/cs1
      endif
      s = e2**2

c --- calculate interference matrix
      do i = 1, nstates
        do j = 1, nstates
          sigm(i,j) = dcmplx(xphppg(e2,vf(1,(i-1)*nstates+j)), 0.)
          if ( i.gt.j ) then
            sigm(i,j) = -ii * sigm(i,j)
          endif
        enddo
      enddo

c --- calculate amplitude vector
      prho = ddprho(e2)/s
      pome = ddpom(e2)/s
      ampv(1) = 0.
c --- rho -> omega pi0
      if ( arhoompi0.ne.0 ) then
        ampv(1) = ampv(1) +
     &    arhoompi0 * exp(ii*phrhoompi0*deg2rad) / prho *
     &    sqrt( ccrhoompi(e2) )
      endif
c --- rho1450 -> omega pi0
      if ( arho1450ompi0.ne.0 ) then
        ampv(1) = ampv(1) + 
     &    arho1450ompi0 * exp(ii*phrho1450ompi0*deg2rad) /
     &    (ddprho1450(e2)/s)
      endif
c --- rho1700 -> omega pi0
      if ( arho1700ompi0.ne.0 ) then
        ampv(1) = ampv(1) +
     &    arho1700ompi0 * exp(ii*phrho1700ompi0*deg2rad) /
     &    (ddprho1700(e2)/s)
      endif
c --- omega -> rho pi0
      ampv(2) = 0.
      if ( aomrhopi0.ne.0 ) then
        ampv(2) = ampv(2) +
     &    aomrhopi0 * exp(ii*phomrhopi0*deg2rad) / pome
      endif
c --- phi -> rho pi0
      if ( aphirhopi0.ne.0 ) then
c --- the constant is (msphi/msom)**2 *(gfrp/gfg)/(gwrp/gwg); (see cphppg)
c     where
c       gVg = alpha * sqrt( 4*pi/3. * msV/gVee ),  and
c       gVrp = sqrt(4*pi * gV3pi/sp3pi(mV))
c     combining, we obtain:
c       c = (msphi/msom)**2 * sqrt(
c         (gphi3pi*gphiee/msphi/sp3pi(msphi)) /
c         (gom3pi *gomee /msom /sp3pi(msom)) )
c     it is calculated for:
c       msphi=1020, gphi=4.43MeV, gphiee=1.325keV, gphi3pi=
c       msom=782., gomee=0.6keV, gphiee=1.33keV
c --- 
        if ( phiomratio.eq.0 ) then
          phiomratio = 
     &      (msphi/msom)**2 * gphi/gom * sqrt(
     &      (brphi3pi*brphiee/msphi/sp3pi(msphi)) /
     &      (brom3pi*bromee/msom/sp3pi(msom)) )
          write (6,*) 'crppg: phiomratio = ', phiomratio
        endif
        ampv(2) = ampv(2) +
     &    aphirhopi0 *
     &    phiomratio *
     &    exp(ii*phphirhopi0*deg2rad) / (ddpphi(e2)/s)
      endif
      ampv(3) = 0.
c --- direct decay: rho -> pi0 pi0 gamma (phase space)
      if ( arhopi0pi0g.ne.0 ) then
        ampv(3) = ampv(3) + ratio(1) *
     &    arhopi0pi0g * exp(ii*phrhopi0pi0g*deg2rad) / prho
      endif
c --- direct decay: omega -> pi0 pi0 gamma (phase space)
      if ( aompi0pi0g.ne.0 ) then
        ampv(3) = ampv(3) + ratio(2) *
     &    aompi0pi0g * exp(ii*phompi0pi0g*deg2rad) / pome
      endif
c --- rho -> sigma gamma
      ampv(4) = 0.
      if ( arhosigg.ne.0 ) then
        ampv(4) = ampv(4) + ratio(3) *
     &    arhosigg * exp(ii*phrhosigg*deg2rad) / prho
      endif
c --- omega -> sigma gamma
      if ( aomsigg.ne.0 ) then
        ampv(4) = ampv(4) + ratio(4) *
     &    aomsigg * exp(ii*phomsigg*deg2rad) / pome
      endif

c --- making a cross section
      do i = 1, nstates
        camp(i) = (0.,0.)
        do j = 1, nstates
          camp(i) = camp(i) + ampv(j) * sigm(j,i)
        enddo
      enddo
      melm = (0.,0.)
      do i = 1, nstates
        melm = melm + camp(i) * conjg(ampv(i))
      enddo
      crppg = dreal(melm)
      end


c+++ C16 dprop( R8 s, R8 m, R8 g ) inverse propagator of (m,g) at s
      complex*16 function dprop( s, m, g )
      implicit none
      real*8 s, m, g
      dprop = dcmplx(m**2-s,-(sqrt(s)*g))
      end


c+++ R8 xphppg( R8 ee, R8 vv(18) ) make spline
      real*8 function xphppg( ee, vv )
      implicit none
      integer np
      parameter (np=15)
      real*8 ee, vv(2*np)
      real*8 xx(np)
      real*8 sispli
      data xx /
     &  .35, .4, .45, .5, .55,
     &  .6, .66, .71, .8, .9,
     &  .92, 1.05, 1.3, 2.0, 2.4 /
      xphppg = sispli( np, xx, vv, ee/1000.)
      end


c+++ 0 crppgget( R4 vector(20) )
      subroutine crppgget(vv)
      implicit none
      include 'fitdata.inc'
      real*8 vv(20)
      logical init /.true./
      save init
      if ( init ) then
        init = .false.
        call inifit
      endif
      vv( 1) = arhoompi0
      vv( 2) = phrhoompi0
      vv( 3) = arho1450ompi0
      vv( 4) = phrho1450ompi0
      vv( 5) = arho1700ompi0
      vv( 6) = phrho1700ompi0  
      vv( 7) = aomrhopi0
      vv( 8) = phomrhopi0
      vv( 9) = arhopi0pi0g     
      vv(10) = phrhopi0pi0g
      vv(11) = aompi0pi0g
      vv(12) = phompi0pi0g     
      vv(13) = gom
      vv(14) = msrho1450
      vv(15) = aphirhopi0
      vv(16) = phphirhopi0
      vv(17) = arhosigg
      vv(18) = phrhosigg
      vv(19) = aomsigg
      vv(20) = phomsigg
      end


      subroutine crppgset(vv)
      implicit none
      include 'fitdata.inc'
      real*8 vv(20)
      logical init /.true./
      save init
      if ( init ) then
        init = .false.
        call inifit
      endif
      arhoompi0      = vv( 1)
      phrhoompi0     = vv( 2)
      arho1450ompi0  = vv( 3)
      phrho1450ompi0 = vv( 4)
      arho1700ompi0  = vv( 5)
      phrho1700ompi0 = vv( 6)
      aomrhopi0	     = vv( 7)
      phomrhopi0     = vv( 8)
      arhopi0pi0g    = vv( 9)
      phrhopi0pi0g   = vv(10)
      aompi0pi0g     = vv(11)
      phompi0pi0g    = vv(12)
      gom	     = vv(13)
      msrho1450	     = vv(14)
      aphirhopi0     = vv(15)
      phphirhopi0    = vv(16)
      arhosigg       = vv(17)
      phrhosigg      = vv(18)
      aomsigg        = vv(19)
      phomsigg       = vv(20)
      end



c+++ R8 sispli( I4 n, R8 xx(n), R8 yy(n), R8 x ) - make a cubic spline over points:
c+++   xx(i),yy(2*i-1),yy(2*i) - abscissa,ordinate,1st derivative
      real*8 function sispli( n, xx, yy, x )
      implicit none
      integer n
      real*8 xx(n)
      real*8 yy(2*n)
      real*8 x
c ---
      integer i
      real*8 x0,x1,y0,y1,yy0,yy1,h,dy,t,z,d,e
c ---
      if ( n.lt.1 ) then
        sispli = 0.
        return
      else if ( n.eq.1 ) then
        sispli = yy(n)
        return
      endif
      if ( x.ge.xx(n) ) then
        i = n
      else if ( x.le.xx(1) ) then
        i = 2
      else
        i = 2
        do while ( i.le.n .and. x.gt.xx(i) )
          i = i + 1
        enddo
        if ( i.gt.n ) then
          write (6,*) 'sispli: n < i; n,i = ', n,i
          stop
        endif
      endif
c ---
      x0 = xx(i-1)
      x1 = xx(i)
      y0 = yy(i*2-3)
      yy0 = yy(i*2-2)
      y1 = yy(i*2-1)
      yy1 = yy(i*2)
c ---
      h = x1 - x0
      dy = y1 - y0
      t = (x-x0)/h
      z = 1-t
      d = yy0*h - dy
      e = yy1*h - dy
      sispli = y0*z + y1*t + t*z*(d*z-e*t)
      end


c+++
      real*8 function p4toppgratio(e2)
      implicit none
      real*8 e2
      real*8 sispli
      integer np
      parameter (np=7)
c --- abscissas of phase space ratio spline
      real*8 xx(np)
      data xx /.600, .700, .800, .920, .960, 1.050, 2.400 /
c --- coefficients of phase space ratio spline
      real*8 spldat(np*2)
      data spldat /
     &   2.416276E-05, 4.376530E-02, 1.274298E-01, 2.851440E+00, 3.099190E+00,
     &   5.949108E+01, 9.224849E+00, 2.121501E+01, 1.006350E+01, 5.091377E+00,
     &   1.119314E+01, 2.378913E+00, 1.290021E+01, 1.872449E+00/
      save spldat
c
      p4toppgratio = sispli(np,xx,spldat,e2/1000.)
      end
