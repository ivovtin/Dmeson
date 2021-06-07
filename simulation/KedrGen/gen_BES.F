      Subroutine Gen_BES(IE,MOD0,EBEAM,AD)
c***********************************************************************
c
c   Generator on base of the BES one 
c
c   Input: IE = 1: J/psi
c               2: psi' 
c               0: continuum
c
c        MOD0 =0   - all modes 
c        MOD0 (>0) - exclusive mode (1-31 for J/psi, 1-15 for psi')
c        EBEAM     - beam energy (GeV) for IE=0 (continuum)
c        AD (>0)   - parameter for simulation ang. distr. for 2-part. state
c                    from J/ps or psi' decay: ds/so ~ 1+ |AD|*cos^2(teta) 
c
c   V.A.Tayursky. July 2009, April 2010
c                 with correction by Todyshev in BESLUD1 (Apr. 2010)
c
c***********************************************************************

      Implicit NONE

      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)       !  jetset v7.4

      Real *4 PARU,PARJ
      Integer *4 MSTU,MSTJ
      COMMON /LUDAT1/   MSTU(200),PARU(200),MSTJ(200),PARJ(200)  ! jetset v7.4


      Real *4 pmas,parf,vckm
      Integer *4 kchg
      COMMON /LUDAT2/   kchg(500,3),pmas(500,4),parf(2000),vckm(4,4)

      Real *4 BRAT
      Integer *4 MDCY,MDME,KFDP
      COMMON /LUDAT3/   MDCY(500,3),MDME(2000,2),BRAT(2000),KFDP(2000,5)

      Real *4 brat_charm
      Integer *4 mdcy_charm,mdme_charm,kfdp_charm,moda
      COMMON /charm/  mdcy_charm(2),mdme_charm(100,2), brat_charm(100),
     &                kfdp_charm(100,5),moda
c
      Real *4 EnergyCM(2),EBEAM,AD,SQRTS,ERAND,FMAX,CT2,RND1,RLU
      Integer *4 ICALL,MOD0,IE,ITAB,ITAB1,KC,IDC,I,NDS,KG,IG,LUCOMP

      SAVE
c
      Data EnergyCM/3.0969,3.686/ ! 2E for J/psi and psi'
      Data ICALL/0/
c
      MODA=MOD0
c
      IF(IE.LT.0.or.IE.GT.2) THEN
        PRINT *, ' '
        PRINT *, ' gen_BES error: wrong IE, IE=',IE
        PRINT *, ' '  
        STOP
      END IF    
c
      IF(IE.EQ.1.and.(MODA.LT.0.OR.MODA.GT.31)) THEN
        PRINT *, ' '
        PRINT *, ' gen_BES error at IE=1: wrong MODA, MODA=',MODA
        PRINT *, ' '
        STOP
      END IF          
c
      IF(IE.EQ.2.and.(MODA.LT.0.OR.MODA.GT.15)) THEN
        PRINT *, ' '
        PRINT *, ' gen_BES error at IE=2: wrong MODA, MODA=',MODA
        PRINT *, ' '
        STOP
      END IF          
c
      ICALL=ICALL+1
c
      IF(ICALL.GT.1) GOTO 100
c
c========================================================================
c
      ITAB=50        ! 50 or 60, used for some statistics
      ITAB1=ITAB
c
      PRINT *, ' '
      PRINT 101   
      PRINT *, ' '

      IF(IE.EQ.1) THEN
        PRINT *,'Generator # 214: J/psi decays (BES)'
        PRINT *,' '
        PRINT *,'Ecms=3.0969 GeV'
        PRINT *,' '
c
       IF(MODA.EQ.0) PRINT *,'MODE=0: J/psi -> all modes'
       IF(MODA.EQ.1) PRINT *,'MODE=1: J/psi -> e+ e-'
       IF(MODA.EQ.2) PRINT *,'MODE=2: J/psi -> mu+ mu-'
       IF(MODA.EQ.3) PRINT *,'MODE=3: J/psi -> q q~ (with new channels)' 
       IF(MODA.EQ.4) PRINT *,'MODE=4: J/psi -> q q~'  
       IF(MODA.EQ.5) PRINT *,'MODE=5: J/psi -> gluon modes'
       IF(MODA.EQ.6) PRINT *,'MODE=6: J/psi -> eta_c gamma'
       IF(MODA.EQ.7) PRINT *,'MODE=7: J/psi -> rho- pi+ or rho+ pi-' 
       IF(MODA.EQ.8) PRINT *,'MODE=8: J/psi -> rho+ pi- or rho- pi+' 
       IF(MODA.EQ.9) PRINT *,'MODE=9: J/psi -> rho0 pi0' 
       IF(MODA.EQ.10) PRINT *,'MODE=10: J/psi -> a_2+ pi- or a_2- pi+ ' 
       IF(MODA.EQ.11) PRINT *,'MODE=11: J/psi -> a_2- pi+ or a_2+ pi- ' 
       IF(MODA.EQ.12) PRINT *,'MODE=12: J/psi -> a_20 pi0' 
       IF(MODA.EQ.13) PRINT *,'MODE=13: J/psi -> a_2+ rho- or a_2- rho+' 
       IF(MODA.EQ.14) PRINT *,'MODE=14: J/psi -> a_2- rho+ or a_2+ rho-' 
       IF(MODA.EQ.15) PRINT *,'MODE=15: J/psi -> a_20 rho0' 
       IF(MODA.EQ.16) PRINT *,'MODE=16: J/psi -> omega eta' 
       IF(MODA.EQ.17) PRINT *,'MODE=17: J/psi -> omega f_2' 
       IF(MODA.EQ.18) PRINT *,'MODE=18: J/psi -> omega prot+ a-prot-' 
       IF(MODA.EQ.19) PRINT *,'MODE=19: J/psi -> b_1- pi+ or b_1+ pi-' 
       IF(MODA.EQ.20) PRINT *,'MODE=20: J/psi -> b_1+ pi- or b_1- pi+ ' 
       IF(MODA.EQ.21) PRINT *,'MODE=21: J/psi -> b_10 pi0' 
       IF(MODA.EQ.22) PRINT *,'MODE=22: J/psi -> K- K*+ or K+ K*-' 
       IF(MODA.EQ.23) PRINT *,'MODE=23: J/psi -> K+ K*- or K- K*+' 
       IF(MODA.EQ.24) PRINT *,'MODE=24: J/psi -> K~0 K*0 or K0 K*~0' 
       IF(MODA.EQ.25) PRINT *,'MODE=25: J/psi -> K0 K*~0 or K*0 K~0' 
       IF(MODA.EQ.26) PRINT *,'MODE=26: J/psi -> K*- K*_2+ or K*_2- K*+' 
       IF(MODA.EQ.27) PRINT *,'MODE=27: J/psi -> K*+ K*_2- or K*- K*_2+' 
       IF(MODA.EQ.28) PRINT *,'MODE=28: J/psi -> K*~0 K*_20 or c.c.' 
       IF(MODA.EQ.29) PRINT *,'MODE=29: J/psi -> K*0 K*_2~0 or c.c.' 
       IF(MODA.EQ.30) PRINT *,'MODE=30: J/psi -> phi f-prime_2' 
       IF(MODA.EQ.31) PRINT *,'MODE=31: J/psi -> phi K- K+' 
c
c        CALL PmodBES(1,MODA) ! print out modes of decay
c
        PRINT *,'Parameter AD=',AD 
c
      END IF
c
      IF(IE.EQ.2) THEN
        PRINT *,'Generator # 215: psi(2S) decays (BES)'
        PRINT *,' '
        PRINT *,'Ecms =3.686 GeV'

       IF(MODA.EQ.0) PRINT *,'MODE=0: psi-prim -> all modes'  
       IF(MODA.EQ.1) PRINT *,'MODE=1: psi-prim -> e+ e-'
       IF(MODA.EQ.2) PRINT *,'MODE=2: psi-prim -> mu+ mu-'
       IF(MODA.EQ.3) PRINT *,'MODE=3: psi-prim -> q q~'
       IF(MODA.EQ.4) PRINT *,'MODE=4: psi-prim -> J/psi pi- pi+'  
       IF(MODA.EQ.5) PRINT *,'MODE=5: psi-prim -> J/psi pi0 pi0' 
       IF(MODA.EQ.6) PRINT *,'MODE=6: psi-prim -> J/psi eta'
       IF(MODA.EQ.7) PRINT *,'MODE=7: psi-prim -> J/psi pi0'  
       IF(MODA.EQ.8) PRINT *,'MODE=8: psi-prim -> chi_0c gamma'   
       IF(MODA.EQ.9) PRINT *,'MODE=9: psi-prim -> chi_1c gamma'  
       IF(MODA.EQ.10) PRINT *,'MODE=10: psi-prim -> chi_2c gamma'
       IF(MODA.EQ.11) PRINT *,'MODE=11: psi-prim -> eta_c gamma'
       IF(MODA.EQ.12) PRINT *,'MODE=12: psi-prim -> q q~' 
       IF(MODA.EQ.13) PRINT *,'MODE=13: psi-prim -> gluons'
       IF(MODA.EQ.14) PRINT *,'MODE=14: psi-prim -> tau+ tau-' 
       IF(MODA.EQ.15) PRINT *,'MODE=15: psi-prim -> J/psi mu+ mu-' 

c
c        CALL PmodBES(2,MODA) ! print out modes of decay
c
        PRINT *,'Parameter AD=',AD
c
      END IF
c
      IF(IE.EQ.0) THEN
        PRINT *,'Generator # 216: e+e- -> q q~ (BES)'
        PRINT *, ' '
        PRINT *,'Ecms =',2*Ebeam,' GeV'
c        PRINT *, ' '
c        PRINT *,'Parameter AD=',AD   ! is not used
c        PRINT *, ' '
      END IF
c
      PRINT *, ' '
      PRINT 101   
c
c*************************************************************************
c
c...............
c  Retune parametes
c      mstj(107)=0         ! (D=0) rediation correction (0/1=no/yes)
      parj(126)=1.0       ! (D=2.0GeV) Mmin of two partons in 3/4 jet

c...............
c  Baryon production parameters
      parj(1)=0.09        ! (D=0.1) p(qq)/p(q)
      parj(2)=0.4         ! (d=0.3) p(ss)/p(uu),(uu:dd:ss=1:1:parj(2))

c...............
c  Kinds of mesons parameters(pseudoscalar spin=0(pi(ud~),k(s),eta(uu~+dd~+ss~)
c   spin=1, J=1(Vector, rho, omiga, phi, h1..)
c
c   V/p=<3/1 suggested by spin and overlapper of wave function p227
c   i=11:u, 12:s, 13:c,
c
c     L=0,S=0,J=0, ratio=(1-parj(i))(1-parj(14))          pseudoscalar meson
c     L=0,S=1,J=1, ratio=parj(i)(1-parj(15)-parj(16)-parj(17))        vector 
c     L=1,S=0,J=1, ratio=(1-parj(i))parj(14)              axial vector meson
c     L=1,S=1,J=0, ratio=parj(i)parj(15)                  scalar meson
c     L=1,S=1,J=1, ratio=parj(i)parj(16)          another axial vector meson
c     L=0,S=1,J=2, ratio=parj(i)parj(17)                  tensor meson
c..........

c  marked * means effect on reduction scalar production
      PARJ(11)=0.60    ! *(D=0.5) V/p ratio of u
      PARJ(12)=0.66    ! (D=0.6)  V/p ratio of strange(s)
cc    PARJ(13)=0.8      ! (D=0.75) V/p ratio of Charm
      PARJ(14)=0.62    ! *(D=0.)  spin=0,L=1,J=1   axial Vector meson
      PARJ(15)=0.12    ! (D=0.)   spin=1,L=1,J=0   scalar meson
      PARJ(16)=0.12    ! (D=0.)   spin=1,L=1,J=1   anothe axial Vector
      PARJ(17)=0.10    ! (D=0.)   spin=1,L=1,J=2   tensor meson
      PARJ(25)=0.5     ! (D=1.)   extra suppression for eta production

c...(ME)Parameters for PETRA/PEP (p80 in manual)
      PARJ(21)=0.5        ! xgm(D=0.36), width in the Px,Py Gaussian dist.
      PARJ(33)=0.6        ! mass-q(D=0.8) 
c
      Call BESUPDAT    ! adding new decay channels for charm onium
c
c      Call LUTAB3(ITAB1)  ! reset for statistics stable part
c
c      CALL MYTAB(ITAB1)
c
c------------------------------------------------------------------------
c
      IF(IE.EQ.0) GOTO 100      ! this is for continuum simulation
c
 1    IF(IE.EQ.2) GOTO 2
c..........
c   IE=1 (J/psi)
c
      IF(MODA.GT.0) THEN      ! J/psi
c
        KC=LUCOMP(443)      ! Lund compressed code of J/psi from kf-code   
        IDC=MDCY(KC,2)      ! position of J/psi (code=KC) in decay table
c        
        DO I=1,3        
          MDME(IDC+I-1,1)=0 ! switch off all (=3) old decay channels
        END DO
c
        IF(MODA.GE.1.AND.MODA.LE.3) THEN
          MDME(IDC+MODA-1,1)=1
        END IF
c
        IF(MODA.GE.4) THEN     ! one selected mode from initial data
          MDME(IDC+2,1)=1
c
          DO I=1,50
            MDME_CHARM(I,1)=0
          END DO      
c
          MDME_CHARM(MODA-3,1)=1 
        END IF 
c
      END IF
c
      GOTO 100
c
c-----------------------------------------------------------------------
c
c   IE=2 (psi')
c
 2    IF(MODA.GT.0) THEN      
c
          KC=LUCOMP(30443)   ! Lund compressed code of particle from kf-code
          IDC=MDCY(KC,2)     ! this gives position of particle KC in decay tab.
c
          DO I=1,11
            MDME(IDC+I-1,1)=0   ! switch off all old decay channels
          END DO
c
        IF(MODA.GE.1.AND.MODA.LE.11) THEN  
c
          MDME(IDC+MODA-1,1)=1   ! switch on MODA decay channel
c
        END IF
c
        IF(MODA.GE.12) THEN
          MDME(IDC+2,1)=1
c
          DO I=51,100
            MDME_CHARM(I,1)=0
          END DO      
c                  
          MDME_CHARM(50+MODA-11,1)=1
c
        END IF
c
      END IF
c
c=======================================================================
c      
c
c------ Generator ------------------------------------------------------
c
 100  CONTINUE
c
      SQRTS= EnergyCM(IE)
      IF(IE.EQ.0) SQRTS=2*EBEAM    ! continuum
c
 200  ERAND=SQRTS
c
      CALL BESCHARM(4,ERAND)        ! call luoina1: charm-onia event
c
      IF(IE.EQ.0.OR.ABS(AD).LT.1.E-6) GOTO 500
c
c  Simulation of angular distribution for 2-particle modes
c
      NDS=0
c                 
      DO I=1,N     ! 2 particles in 1-st generation of J/psi, psi' decay
        KG=K(I,3)  ! index of generation
        IF(KG.EQ.1) THEN
          NDS=NDS+1           ! particles 1-st gen.  /LUJETS/
          IG=I
        END IF
      END DO
c
      IF(NDS.NE.2) GOTO 500
c
c  2 particles in 1-st generation. Simulation ds/do ~ 1+|AD|*cos^2(teta) 
c
      FMAX=1.+ABS(AD)
      CT2=P(IG,3)**2/(P(IG,1)**2+P(IG,2)**2+P(IG,3)**2)            
      RND1=RLU(0)
      IF(FMAX*RND1.GT.(1.+ABS(AD)*CT2)) GOTO 200 
c
 500  CONTINUE
c
c      CALL LUEDIT(1)           ! event without decayed particles, jets
c
 101  FORMAT(72(1H*))
      RETURN
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BESCGPAR(ip1,ip2,ip3,kgok,ngg,icg) 
c************************************************************************* 
c
c   BESCGPAR = former CGPARITY
c                                                                        *
c   Purpose:(1) Initial C&G parities of mesons(PDG98).                   *
c           (2) Compare C&G parities between decay meson and its decayed *
c               products.                                                *
c                   C=(-1)^J, G=(-1)^I*C                                 *
c   called:  luexec1.f, ludecy1.f                                        *
c   used in: luexec1.f, ludecy1.f                                        *
c                                                                        *
c   lgp1(i):  KF of meson ith meson, 1<i<ndim number of mesons.          *
c   lgp2C(i): C parity of ith meson.                                     *
c   lgp2G(i): G parity of ith meson.                                     *
c   lgpJ(i):  2*J of ith meson.                                          *
c   lgpI(i):  2*I of ith meson.                                          *
c   pgp(i):   the ith meson takes I+J or I+J+1.                          *
c                                                                        *
c   Input:    ip1, decay meson position in the /LUJETS/;                 *
c             ip2-ip3, decayed products position.                        *
c             ngg, 1/2 ggg/gamma*gg                                      *
c             icg 1=Cparity/2=Gparity                                    *
c                                                                        *
c   Output:  kgok, 1:C/Gparity ok; -1:bad;                               *
c                                                                        *
c                                      Chen Jiangchuan  1999.11.28       *
c                                                                        *
c*************************************************************************

      implicit NONE

      integer ndim,npart
      parameter (ndim=100,npart=62)
      COMMON/LUJETS/N,K(4000,5),P(4000,5),V(4000,5)
      integer N,K,P,V
      integer kgok,ip,ip1,ip2,ip3,initg,lastg,istatus,i,ndecy,orbitj
      integer lgp1(ndim),lgp2c(ndim),lgp3(20),lgp2g(ndim),lgpJ(ndim),
     &  lgpI(ndim), ngg,icg,orbiti
      real pgj(ndim),pgi(ndim)
c
c      save lgp1,lgp2c,lgp2g,lgpJ,lgpI,pgj,pgi

      SAVE
c
      real rlu
C....initial Gparities of mesons
*************************************************************************
c...KF of mesons in the jetset7.4
c               pi+ pi0 eta  eta'  f0    f0'    f1   f1'   f2 f2'  rho+
      data lgp1/211,111,221, 331, 10221,10331,20223,20333,225,335,213,

c     rho0 omega a0+  a00  a1+  a10   a2+ a20 phi   h1    h1'  h1c
     &113,223,10211,10111,20213,20113,215,115,333,10223,10333,10443,

c     b1+   b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon' etab
     &10213,10113,441, 443,10441,20443,445,30443,  553,  30553, 551,

c     gamma D0 XGM- XGM+ XGM0 XGM*0 XGM*- XGM*+ Xi- Xi0
     & 22,  3122,3112,3222,3212,3214,3114, 3224,3312,3322,

c      Delta+ Delta- Delta0 Delta++ K+ K0 K*+ K*0  K1+  K10   K0*+ 
     & 2214,  1114,  2114,  2224, 321,311,323,313,10323,10313,10321,

c      K0*0  K1*+  K1*0   K2*+ K2*0 n0  p+ 
     &10311,20323,20313, 325, 315,2112,2212,38*0/

c...C parities of mesons for single meson
c               pi+pi0 eta eta' f0   f0'   f1   f1'  f2  f2' rho+
      data lgp2c/0, +1, +1, +1, +1,  +1,   +1,  +1,  +1, +1, 0,

c      rho0 omega a0+  a00  a1+  a10  a2+ a20 phi   h1    h1' h1c
     &  -1,  -1,  0,   +1,   0,   +1,  0, +1,  -1,  -1,   -1,  -1,

c      b1+ b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon'etab
     &  0,  -1,   +1,   -1, +1,  +1,  +1,   -1,     -1,    -1,  +1,

c     gamma 
     &  -1, 65*0/

c...G parities of mesons
c               pi+-pi0 eta  eta' f0   f0'   f1   f1'   f2 f2' rho+-
      data lgp2g/-1, -1, +1, +1,  +1,  +1,   +1,  +1,  +1, +1,  +1,

c      rho0 omega a0+  a00  a1+   a10   a2+ a20 phi   h1    h1'  h1c
     &  +1,  -1, -1,   -1,  -1,   -1,   -1, -1, -1,  -1,   -1,   -1,

c      b1+   b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon' etab
     &  +1,  +1,   +1,   -1, +1,  +1,  +1,   -1,     -1,     -1,   +1,
     &  66*0/

c...2*J of particls for cluster particls
c               pi+pi0 eta eta' f0   f0' f1   f1'  f2  f2' rho+
      data lgpJ/0 ,0 , 0 , 0 ,  0 ,  0 , 2 ,  2 ,  4 , 4 ,  2,
c      rho0 omega a0+  a00  a1+   a10  a2+ a20 phi h1   h1' h1c
     &  2 ,  2,   0 ,  0 ,  2 ,   2 ,  4 ,  4 ,2,  2,  2,  2,
c      b1+ b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon'etab
     &  2,  2,   0,   2,    0,   2,   4,   2,      2,    2,  0,
c     gamma LMD0 XGM- XGM+ XGM0 XGM*0 XGM*- XGM*+ Xi- Xi0  
     &  2,   1,   1,    1,  1,   3,   3,     3,   1,   1,
c      Delta+ Delta- Delta0 Delta++ K+ K0 K*+ K*0  K1+  K10   K0*+ 
     &  3,      3,     3,     3,    0, 0, 2,   2,  2,   2,   0,
c      K0*0  K1*+  K1*0  K2*+ K2*0 n0   p+ 
     &  0,    2,    2,    4, 4,   1,   1,38*0/
      
c...2*I of particls for cluster particls
c               pi+pi0 eta eta' f0   f0' f1   f1'  f2  f2' rho+
      data lgpI/2 ,2 , 0 , 0 ,  0 ,  0 , 0 ,  0 ,  0 , 0 ,  2,
c      rho0 omega a0+  a00  a1+   a10  a2+ a20 phi h1   h1' h1c
     &  2 ,  0,   2 ,  2 ,  2 ,   2 ,  2 ,  2 ,0,  0,  0,  0,
c      b1+ b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon'etab
     &  2,  2,   0,   0,    0,   0,   0,   0,      0,    0,  0,
c     gamma LMD0 XGM- XGM+ XGM0 XGM*0 XGM*- XGM*+ Xi- Xi0  
     &  0,   0,   2,   2,  2,   2,     2,    2,   1,   1,
c      Delta+ Delta- Delta0 Delta++ K+ K0 K*+ K*0  K1+  K10  K0*+ 
     &  3,      3,     3,     3,    1, 1, 1,   1,  1,   1,   1,
c      K0*0  K1*+  K1*0   K2*+ K2*0 n0   p+ 
     &  1,    1,    1,    1,   1,   1,   1,38*0/

c... ratio of 2*J of particls for cluster particls
c               pi+pi0 eta eta' f0   f0' f1   f1'  f2  f2' rho+
      data pgj/.0 , 1., 1., 1. , 1.,  1., 0.,  0.,  1., 1., 1.,
c      rho0 omega a0+  a00  a1+   a10  a2+ a20 phi h1   h1' h1c
     &  1.,  1.,  1.,  1.,  1.,   0.,  .0, 1.,1., 1.,  1., 1.,
c      b1+ b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon'etab
     & 1., 1.,   1.,   1.,  1.,  0.,  1.,  1.,     1.,  1., 1.,
c     gamma LMD0 XGM- XGM+ XGM0 XGM*0 XGM*- XGM*+ Xi- Xi0  
     &1. , .07,  .15, .15, .15,  .2 ,  .2 , .2 ,   .7, .7,
c      Delta+ Delta- Delta0 Delta++ K+ k0 K*+ K*0  K1+  K10  K0*+ 
     &  .7,    .7,    .7,    .7,   .3, .3,.6, .6,  .7,  .7,  .7,
c      K0*0  K1*+  K1*0   K2*+ K2*0 n0   p+ 
     & .7,   .7,   .7,    0.,  0., .9 , .9 , 38*0/

c... ratio of 2*I of particls for cluster particls
c               pi+pi0 eta eta' f0   f0' f1   f1'  f2  f2' rho+
      data pgi/1. , 1., 1., 1. , 1.,  1., 1.,  1.,  1., 1., 1.,
c      rho0 omega a0+  a00  a1+   a10  a2+ a20 phi h1   h1' h1c
     &  1.,  1.,  1.,  1.,  1.,   1.,  1., 1.,1., 1.,  1., 1.,
c      b1+ b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon'etab
     & 1., 1.,   1.,   1.,  1.,  1.,  1.,  1.,     1.,  1., 1.,
c     gamma LMD0 XGM- XGM+ XGM0 XGM*0 XGM*- XGM*+ Xi- Xi0  
     &.5 ,  1.,  1.,  1. , 1. ,  1.,   1.,   1.,  1. ,1. ,
c      Delta+ Delta- Delta0 Delta++ K+ K0 K*+ K*0  K1+  K10  K0*+ 
     &  1.,    1.,    1.,    1.,  1. ,1. ,1., 1.,  1.,  1.,  1.,
c      K0*0  K1*+  K1*0   K2*+ K2*0 n0   p+ 
     & 1.,   1.,   1.,    1.,  1., .02, .02, 38*0/

*************************************************************************

c      print *, 'CGPARITY-in: ICG=',ICG

      kgok=-1
      initg=0
      lastg=0
c
      if(icg.eq.0) then
        write(*,*) 'icg=0!'
       goto 100
      endif
c..........
c  find decay meson C/G parity
      do 10 i=1,npart
c
        if(abs(k(ip1,2)).eq.lgp1(i)) then
          if(icg.eq.1) initG=lgp2c(i)
          if(icg.eq.2) initG=lgp2g(i)
          goto 20
        endif
c
 10   continue 
c
 20   continue 
c
      if(initg.eq.0) then    !decay meson no good C/G parity
        kgok=1
        goto 100
      endif 
c......
c  find C/G parity of its decayed products
      if((ip2.eq.0).or.(ip3.eq.0).or.(ip3.lt.ip2)) then
        write(*,*) 'Wrong in CGparity.f (ip3<ip2)!'
        goto 100
      endif  
c
       istatus=0         !check kind of sum quantum in the products
       orbitj=0.
       orbiti=0.
       ndecy=0
c
      do 40 ip=ip2,ip3
        ndecy=ndecy+1
        lgp3(ndecy)=0
c
        if(ndecy.gt.20) then
          write(*,*) 'in CGparity.f:too more decayed products!'
          kgok=1
          goto 100
        endif  
c
	do 30 i=1,npart
c
          if(abs(k(ip,2)).eq.lgp1(i)) then
c...........
c  C=C'(for normal neutral meson) or 1*(-1)**J(for charge,strang and baryon)
	      if(icg.eq.1) then
c
	        if(lgp2c(i).eq.0) then
                  lgp3(ndecy)=1
                  orbitj=orbitj+lgpJ(i)
                  if(rlu(0).gt.pgj(i)) orbitj=orbitj+1
                else 
                 lgp3(ndecy)=lgp2c(i)
	        endif 
c
              endif
c
c.......
c  G=G'(for normal neutral meson) of C'(-1)**I (for strang meson and baryon)
	      if(icg.eq.2) then
c
               if(lgp2g(i).ne.0) then
		lgp3(ndecy)=lgp2g(i)
		else
		 if(lgp2c(i).ne.0) then
		  lgp3(ndecy)=lgp2c(i)
	         else
		  lgp3(ndecy)=1
                  orbitj=orbitj+lgpJ(i)
	          if(rlu(0).gt.pgj(i)) orbitj=orbitj+1
		 endif 
c
        	orbiti=orbiti+lgpI(i)
                if(rlu(0).gt.pgi(i)) orbiti=orbiti+1
               endif
c
	      endif
           goto 32
          endif
c
 30   continue
 32   continue
c
          if(lgp3(ndecy).eq.0) then
                kgok=1
            goto 100
          endif 
 40   continue

c...compare G parity between decay meson and its decayed products 
      lastG=1
c
      do 50 i=1,ndecy
        lastG=lastG*lgp3(i)
 50   continue
c
        if(ngg.eq.2) then 
           orbitj=orbitj+lgpJ(35)
           if(icg.eq.2) then
	    orbiti=orbiti+lgpI(35)
	    if(rlu(0).gt.pgi(35)) orbiti=orbiti+2
           endif
        endif
c 
      if(orbitj.ge.2) lastg=lastg*(-1)**(orbitj/2) 
      if(orbiti.ge.2) lastg=lastg*(-1)**(orbiti/2)
c      
      if(lastG.eq.initG) then
        kgok=1
      else
        kgok=-1
      endif
c
 100  continue
c      print *,'CGPARITY-out: KGOK=',KGOK

      return
      end
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BESUPDAT 
c*************************************************************************** 
c                        
c   BESUPDAT = former CHARM_UPDAT
c                                                                          *
c   Purpose:(1) update some parameters in the jetset7.4                    *
c           (2) modify/reset J/psi & psi(2s) decay channel in jetset_74    *
c               by databook(98).                                           *
c                                                                          *
c   Used in:  ludecy1.f                                                    *
c                                                                          *
c   New added channels are put in the data common/charm/:                  *
c                                                                          *
c    (1) IDC region of new data: J/psi(1-50), psi(2s)(51-100):             *
c     (mdcy_charm(1)=50 for IDCmax of J/psi, mdcy_charm(2)=100 for psi(2s) *
c                                                                          *
c    (2) mdme_charm(IDC,1)=1/0 on/off decay channel;                       *
c                                                                          *
c    (3) brat_charm(IDC) branch ratio of the channel;                      *
c                                                                          *
c    (4) kfdp_charm(IDC,5)=KF of produced particles (maximum=5 particls).  *
c                                                                          *
c                                      Chen Jiangchuan  1998.5.11          *
c                                                                          *
****************************************************************************

      Implicit NONE

      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)       !  jetset v7.4

      Real *4 PARU,PARJ
      Integer *4 MSTU,MSTJ
      COMMON /LUDAT1/   MSTU(200),PARU(200),MSTJ(200),PARJ(200) ! jetset v7.4

      Real *4 pmas,parf,vckm
      Integer *4 kchg
      COMMON /LUDAT2/   kchg(500,3),pmas(500,4),parf(2000),vckm(4,4)

      Real *4 BRAT
      Integer *4 MDCY,MDME,KFDP
      COMMON /LUDAT3/   MDCY(500,3),MDME(2000,2),BRAT(2000),KFDP(2000,5)

      Real *4 brat_charm
      Integer *4 mdcy_charm,mdme_charm,kfdp_charm,moda
      COMMON /charm/  mdcy_charm(2),mdme_charm(100,2), brat_charm(100),
     &                kfdp_charm(100,5),moda

      SAVE

      data mdcy_charm,mdme_charm,brat_charm,kfdp_charm/50,100,800*0/

c
*****************************************************************************
*    Update some parameters in the jetset7.4                                *
*****************************************************************************
c      parj(127)=0.7              ! (D=1.)GeV Mass_min(g)(safe margin)
c      parj(126)=1.               ! (D=2.)GeV Mass_min(gg) in 3-4 Jet
c      parj(32)=parj(127)         ! GeV Mass_min(q)
c      parj(126)=1.               ! (D=2.)GeV Mass_min(gg) (merge g-g to g)
c
***********************************************************************
*           J/psi decay channel by databook(98)                       *
***********************************************************************
c
        brat(721)=0.0602       ! J/psi-->e+e-
        brat(722)=0.0601       ! J/psi-->mu+mu-
c
c..hadron(bran(qq~))-->qq~(0.17)+rgg/ggg+retac(0.013)+other_news
        brat(723)=0.8797       ! J/psi-->hadron     !ran(qq~)=1-(e+e-)-(mu+mu-)
c
c..adding decay channels (included in brat(J/psi-->hadron)),used in ludecy1.f:
        brat_charm(1)=0.17           ! J/psi-->qq~
        mdme_charm(1,1)=mdme(723,1)
        mdme_charm(1,2)=mdme(723,2)
        kfdp_charm(1,1)=kfdp(723,1)
        kfdp_charm(1,2)=kfdp(723,2)
        
        brat_charm(2)=0.64163 ! J/psi-->rgg/ggg=brat(723)-qq~-charmonia-news
        mdme_charm(2,1)=1
        mdme_charm(2,2)=0
        Kfdp_charm(2,1)=21
        kfdp_charm(2,2)=21
        kfdp_charm(2,3)=21

        brat_charm(3)=0.013     ! (charmonia) J/psi-->gamma etac
        mdme_charm(3,1)=1
        mdme_charm(3,2)=0
        kfdp_charm(3,1)=441
        kfdp_charm(3,2)=22

        brat_charm(4)=0.004     ! other more J/psi-->rho+ pi-
        mdme_charm(4,1)=1
        mdme_charm(4,2)=0
        kfdp_charm(4,1)=213
        kfdp_charm(4,2)=-211

        brat_charm(5)=0.004     ! other more J/psi-->rho- pi+
        mdme_charm(5,1)=1
        mdme_charm(5,2)=0
        kfdp_charm(5,1)=-213
        kfdp_charm(5,2)=211

        brat_charm(6)=0.0045    ! other more J/psi-->rho0 pi0
        mdme_charm(6,1)=1
        mdme_charm(6,2)=0
        kfdp_charm(6,1)=113
        kfdp_charm(6,2)=111

        brat_charm(7)=0.0019    ! other more J/psi-->a_2- pi+
        mdme_charm(7,1)=1
        mdme_charm(7,2)=0
        kfdp_charm(7,1)=-215
        kfdp_charm(7,2)=211

        brat_charm(8)=0.0019    ! other more J/psi-->a_2+ pi-
        mdme_charm(8,1)=1
        mdme_charm(8,2)=0
        kfdp_charm(8,1)=215
        kfdp_charm(8,2)=-211

        brat_charm(9)=0.0019    ! other more J/psi-->a_20 pi0 
        mdme_charm(9,1)=1
        mdme_charm(9,2)=0
        kfdp_charm(9,1)=115
        kfdp_charm(9,2)=111

        brat_charm(10)=0.0031   ! other more J/psi-->a_2- rho+
        mdme_charm(10,1)=1
        mdme_charm(10,2)=0
        kfdp_charm(10,1)=-215
        kfdp_charm(10,2)=213

        brat_charm(11)=0.0031   ! other more J/psi-->a_2+ rho-
        mdme_charm(11,1)=1
        mdme_charm(11,2)=0
        kfdp_charm(11,1)=215
        kfdp_charm(11,2)=-213

        brat_charm(12)=0.0032   ! other more J/psi-->a_20 rho0 
        mdme_charm(12,1)=1
        mdme_charm(12,2)=0
        kfdp_charm(12,1)=115
        kfdp_charm(12,2)=113

        brat_charm(13)=0.0013   ! other more J/psi-->omega eta 
        mdme_charm(13,1)=1
        mdme_charm(13,2)=0
        kfdp_charm(13,1)=223
        kfdp_charm(13,2)=221

        brat_charm(14)=0.0032   ! other more J/psi-->omega f_2 
        mdme_charm(14,1)=1
        mdme_charm(14,2)=0
        kfdp_charm(14,1)=223
        kfdp_charm(14,2)=225

        brat_charm(15)=0.0009   ! other more J/psi-->pp~ omega 
        mdme_charm(15,1)=1
        mdme_charm(15,2)=0
        kfdp_charm(15,1)=223
        kfdp_charm(15,2)=2212
        kfdp_charm(15,3)=-2212

        brat_charm(16)=0.0005  ! other more J/psi-->b_1- pi+
        mdme_charm(16,1)=1
        mdme_charm(16,2)=0
        kfdp_charm(16,1)=-10213
        kfdp_charm(16,2)=211

        brat_charm(17)=0.0005  ! other more J/psi-->b_1+ pi-
        mdme_charm(17,1)=1
        mdme_charm(17,2)=0
        kfdp_charm(17,1)=10213
        kfdp_charm(17,2)=-211

        brat_charm(18)=0.0008  ! other more J/psi-->b_10 pi0 
        mdme_charm(18,1)=1
        mdme_charm(18,2)=0
        kfdp_charm(18,1)=10113
        kfdp_charm(18,2)=111

        brat_charm(19)=0.0024   ! other more J/psi-->K+K*-~ 
        mdme_charm(19,1)=1
        mdme_charm(19,2)=0
        kfdp_charm(19,1)=321
        kfdp_charm(19,2)=-323

        brat_charm(20)=0.0024   ! other more J/psi-->K-K*+ 
        mdme_charm(20,1)=1
        mdme_charm(20,2)=0
        kfdp_charm(20,1)=-321
        kfdp_charm(20,2)=323

        brat_charm(21)=0.0018   ! other more J/psi-->K0K*0 
        mdme_charm(21,1)=1
        mdme_charm(21,2)=0
        kfdp_charm(21,1)=311
        kfdp_charm(21,2)=-313

        brat_charm(22)=0.0018   ! other more J/psi-->K0K*0 
        mdme_charm(22,1)=1
        mdme_charm(22,2)=0
        kfdp_charm(22,1)=-311
        kfdp_charm(22,2)=313

        brat_charm(23)=0.0028   ! other more J/psi-->K*+K*2-~ 
        mdme_charm(23,1)=1
        mdme_charm(23,2)=0
        kfdp_charm(23,1)=323
        kfdp_charm(23,2)=-325

        brat_charm(24)=0.0028   ! other more J/psi-->K*-K*2+ 
        mdme_charm(24,1)=1
        mdme_charm(24,2)=0
        kfdp_charm(24,1)=-323
        kfdp_charm(24,2)=325

        brat_charm(25)=0.0028   ! other more J/psi-->K*0K2*0-~ 
        mdme_charm(25,1)=1
        mdme_charm(25,2)=0
        kfdp_charm(25,1)=313
        kfdp_charm(25,2)=-315

        brat_charm(26)=0.0028   ! other more J/psi-->K*0~K2*0+ 
        mdme_charm(26,1)=1
        mdme_charm(26,2)=0
        kfdp_charm(26,1)=-313
        kfdp_charm(26,2)=315

        brat_charm(27)=0.00053  ! other more J/psi-->omega f_2' 
        mdme_charm(27,1)=1
        mdme_charm(27,2)=0
        kfdp_charm(27,1)=333
        kfdp_charm(27,2)=335

        brat_charm(28)=0.00114  ! other more J/psi-->phi K+K- 
        mdme_charm(28,1)=1
        mdme_charm(28,2)=0                
        kfdp_charm(28,1)=333
        kfdp_charm(28,2)=321
        kfdp_charm(28,3)=-321
*
************************************************************************
*            psi(2s) decay channel by databook(98)                     *
************************************************************************
*
c        brat(968)=0.0085       ! psi(2s)-->e+e-
c        brat(969)=0.0077       ! psi(2s)-->mu+mu-
c
c...ran(qq~)-->qq~(0.029)+rgg/ggg
c        brat(970)=0.21403      ! psi(2s)-->ran(qq~) !1-e-mu-(J/psi)-(rad)
c        brat(971)=0.302        ! psi(2s)-->J/pi pi+pi-
c        brat(972)=0.179        ! psi(2s)-->J/pi pi0pi0
c        brat(973)=0.027        ! psi(2s)-->J/pi eta
c        brat(974)=0.00097      ! psi(2s)-->J/pi pi0
c        brat(975)=0.093        ! psi(2s)-->xc0 gamma
c        brat(976)=0.087        ! psi(2s)-->xc1 gamma
c        brat(977)=0.078        ! psi(2s)-->xc2 gamma
c        brat(978)=0.0028       ! psi(2s)-->etac gamma
c
cCJC/98... on/off(1/0) for Charm-onia decay channel
c        MDME(971,1)=0            ! psi(2s)-->J/pi pi+pi-
c        MDME(972,1)=0            ! psi(2s)-->J/pi pi0pi0
c        MDME(973,1)=0            ! psi(2s)-->J/pi eta
c        MDME(974,1)=0            ! psi(2s)-->J/pi pi0
c        MDME(975,1)=0            ! psi(2s)-->xc0 gamma
c        MDME(976,1)=0            ! psi(2s)-->xc1 gamma
c        MDME(977,1)=0            ! psi(2s)-->xc2 gamma
c        MDME(978,1)=0            ! psi(2s)-->etac gamma
c
c... adding decay channels(included in brat(psi-->rad(qq~)), used in ludecy1.f:
c        brat_charm(51)=0.029           !psi(2s)-->qq~
c        mdme_charm(51,1)=mdme(970,1)
c        mdme_charm(51,2)=mdme(970,2)
c        kfdp_charm(51,1)=kfdp(970,1)
c        kfdp_charm(51,2)=kfdp(970,2)

c        brat_charm(52)=0.17188 ! psi(2s)-->rgg/ggg=brat(970)-brat(51)-53-54
c        mdme_charm(52,1)=1
c        mdme_charm(52,2)=0
c        kfdp_charm(52,1)=21
c        kfdp_charm(52,2)=21
c        kfdp_charm(52,3)=21
c
c        brat_charm(53)=0.00315 ! psi(2s)-->tau+tau-=0.3885*(Bee+Buu)/2
c        mdme_charm(53,1)=1
c        mdme_charm(53,2)=0
c        kfdp_charm(53,1)=15
c        kfdp_charm(53,2)=-15

c        brat_charm(54)=0.01    ! psi(2s)-->J/psi+mu+mu-
c        mdme_charm(54,1)=1
c        mdme_charm(54,2)=0
c        kfdp_charm(54,1)=443
c        kfdp_charm(54,2)=13
c        kfdp_charm(54,3)=-13

*
************************************************************************
*            psi(2s) decay channel by databook(96)&(98)                *
************************************************************************
*
        brat(968)=0.0085       ! psi(2s)-->e+e- (PDG(98)) for /LUDAT3/
        brat(969)=0.0077       ! psi(2s)-->mu+mu-

c...ran(qq~)-->qq~(0.029)+rgg/ggg
        brat(970)=0.18703      ! psi(2s)-->ran(qq~)  ! 1-(e)-(mu)-(J/psi)-(rad)
        brat(971)=0.324        ! psi(2s)-->J/pi pi+pi-   (PDG(96))
        brat(972)=0.184        ! psi(2s)-->J/pi pi0pi0   (PDG(96))
        brat(973)=0.027        ! psi(2s)-->J/pi eta
        brat(974)=0.00097      ! psi(2s)-->J/pi pi0
        brat(975)=0.093        ! psi(2s)-->xc0 gamma
        brat(976)=0.087        ! psi(2s)-->xc1 gamma
        brat(977)=0.078        ! psi(2s)-->xc2 gamma
        brat(978)=0.0028       ! psi(2s)-->etac gamma
c
c  adding decay channels (included in brat(psi-->rad(qq~)), used in ludecy1.f:
c
        brat_charm(51)=0.029           ! psi(2s)-->qq~
        mdme_charm(51,1)=mdme(970,1)
        mdme_charm(51,2)=mdme(970,2)
        kfdp_charm(51,1)=kfdp(970,1)
        kfdp_charm(51,2)=kfdp(970,2)

        brat_charm(52)=0.14488 ! psi(2s)-->rgg/ggg=brat(970)-brat(51)-53-54
        mdme_charm(52,1)=1
        mdme_charm(52,2)=0
        kfdp_charm(52,1)=21
        kfdp_charm(52,2)=21
        kfdp_charm(52,3)=21

        brat_charm(53)=0.00315 ! psi(2s)-->tau+tau-=0.3885*(Bee+Buu)/2 (PDG(98))
        mdme_charm(53,1)=1
        mdme_charm(53,2)=0
        kfdp_charm(53,1)=15
        kfdp_charm(53,2)=-15

        brat_charm(54)=0.01    ! psi(2s)-->J/psi+mu+mu- (PDG(98))
        mdme_charm(54,1)=1 
        mdme_charm(54,2)=0 
        kfdp_charm(54,1)=443
        kfdp_charm(54,2)=13
        kfdp_charm(54,3)=-13

      RETURN 
      END
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BESDEC1(KFA)
c***********************************************************************      
c
c   BESDEC1 = former DECAY1
c
c  Purpose: Statistics 1-st decay products of unstable particles in code 
c
c  Input: KFA  - kf code
c         =443   for J/psi
c         =30443 for psi'
c
c***********************************************************************
      Implicit NONE

      Common /LUDAT1/ MSTU(200),PARU(200),MSTJ(200),PARJ(200) 
      Integer *4 MSTU,MSTJ
      Real *4 PARU,PARJ

      Common /LUDAT2/ KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4) 
      Integer *4 KCHG
      Real *4 PMAS,PARF,VCKM

      Common /LUDAT3/ MDCY(500,3),MDME(2000,2),BRAT(2000),KFDP(2000,5) 
      Integer *4 MDCY,MDME,KFDP
      Real *4 BRAT

      Common /charm/  mdcy_charm(2),mdme_charm(100,2), brat_charm(100),
     &                kfdp_charm(100,5),moda
      Integer *4 mdcy_charm,mdme_charm,moda,kfdp_charm
      Real *4 brat_charm 

      Integer *4 NTRY,KFS,KC,KCA,I,KFA,KFSP,KFSN,NOPE,MDMDCY,KFP
      Integer *4 IDC_MIN,IDC_MAX,LEN,LEM,LUCOMP,IDC_Q,KDUMP
      Integer *4 ISIGN,IDL,MHADDY,KCP,KPA,KP,JT,JTMAX,NJT,IDC,IWR
      Real *4 bratsum,BRSU,RLU,BRidc

      Character CHAP*16,CHAc(10)*16
c
      SAVE
c      
c  Initial values
c
      NTRY=0 
      KFS=ISIGN(1,kfa) 
      KC=LUCOMP(KFA)   ! Lund compressed code of particle from kf-code
c
      do i=1,10
       CHAc(i)='                '
      end do  
c
      IWR=0
      IF(KFA.EQ.443.AND.(MODA.EQ.0.OR.(MODA.GE.3.AND.MODA.LE.5))) IWR=1
      IF(KFA.EQ.30443.AND.(MODA.EQ.0.OR.MODA.EQ.3.OR.MODA.EQ.12.OR.
     &   MODA.EQ.13))IWR=1

      IF(IWR.EQ.1) THEN
      WRITE(MSTU(11),*) ' '
      WRITE(MSTU(11),*) '     LUDECY list'
      WRITE(MSTU(11),*) ' '
      WRITE(MSTU(11),*) 'Probability       Complete final state'
      END IF
c      
c  Check existence of decay channels. Particle/antiparticle rules
c
      KCA=KC
c
      IF(MDCY(KC,2).GT.0) THEN   ! MDCY(KC,2) - position of decay channel 
        MDMDCY=MDME(MDCY(KC,2),2) 
        IF(MDMDCY.GT.80.AND.MDMDCY.LE.90) KCA=MDMDCY 
      END IF
c
      IF(MDCY(KCA,2).LE.0.OR.MDCY(KCA,3).LE.0) THEN
c
        CALL LUERRM(9,'(LUDECY:) no decay channel defined')
c
        RETURN
      END IF
c
      IF(MOD(KFA/1000,10).EQ.0.AND.(KCA.EQ.85.OR.KCA.EQ.87)) KFS=-KFS
c
      IF(KCHG(KC,3).EQ.0) THEN
        KFSP=1
        KFSN=0
        IF(RLU(0).GT.0.5) KFS=-KFS
      ELSE IF(KFS.GT.0) THEN
         KFSP=1
         KFSN=0
      ELSE
        KFSP=0
        KFSN=1
      END IF
c      
c  Sum branching ratios of allowed decay channels
c
  220 NOPE=0 
      BRSU=0. 
c
      DO 230 IDL=MDCY(KCA,2),MDCY(KCA,2)+MDCY(KCA,3)-1 
        IF(MDME(IDL,1).NE.1.AND.KFSP*MDME(IDL,1).NE.2.AND.
     &  KFSN*MDME(IDL,1).NE.3) GOTO 230
        
        IF(MDME(IDL,2).GT.100) GOTO 230 
        NOPE=NOPE+1               ! counter of decay channels
        BRSU=BRSU+BRAT(IDL) 
  230 CONTINUE 
c
      IF(NOPE.EQ.0) THEN 
c
        CALL LUERRM(2,'(LUDECY:) all decay channels closed by user') 
c
        RETURN 
      ENDIF 
c      
      DO 290 IDC=MDCY(KCA,2),MDCY(KCA,2)+MDCY(KCA,3)-1 
        IF(MDME(IDc,1).NE.1) goto 290
        IF(MDME(IDc,2).GT.100) GOTO 290 
        BRidc=BRAT(IDc)/BRSU 
c 
c  Read out decay products. Convert to standard flavour code
c
        NJT=0
        JTMAX=5 
        IF(MDME(IDC+1,2).EQ.101) JTMAX=10 
c
        DO 280 JT=1,JTMAX 
          IF(JT.LE.5) KP=KFDP(IDC,JT) 
          IF(JT.GE.6) KP=KFDP(IDC+1,JT-5) 
          IF(KP.EQ.0) GOTO 280 
          KPA=IABS(KP) 
          KCP=LUCOMP(KPA) 
          IF(KPA.GT.80) MHADDY=1 
c
          IF(KCHG(KCP,3).EQ.0.AND.KPA.NE.81.AND.KPA.NE.82) THEN 
            KFP=KP 
          ELSE IF(KPA.NE.81.AND.KPA.NE.82) THEN 
            KFP=KFS*KP 
          ELSE IF(KPA.EQ.81.AND.MOD(KFA/1000,10).EQ.0) THEN 
            KFP=-KFS*MOD(KFA/10,10) 
          ELSE IF(KPA.EQ.81.AND.MOD(KFA/100,10).GE.MOD(KFA/10,10)) THEN 
            KFP=KFS*(100*MOD(KFA/10,100)+3) 
          ELSE IF(KPA.EQ.81) THEN 
            KFP=KFS*(1000*MOD(KFA/10,10)+100*MOD(KFA/100,10)+1) 
          ELSE IF(KP.EQ.82) THEN 
            IDC_Q=IDC
c
c   Generate new quark (diquark) flavour and combine it with existing
c   flavour to obtain hadron
c
            CALL LUKFDI(-KFS*INT(1.+(2.+PARJ(2))*RLU(0)),0,KFP,KDUMP) 
c
            IF(KFP.EQ.0) GOTO 280 
c           MSTJ(93)=1 
c           IF(PV(1,5).LT.PARJ(32)+2.*ULMASS(KFP)) GOTO 260 
          ELSE IF(KP.EQ.-82) THEN 
            KFP=-KFP 
            IF(IABS(KFP).GT.10) KFP=KFP+ISIGN(10000,KFP) 
          END IF 
c
          NJT=NJT+1
          IF(KPA.EQ.81.OR.KPA.EQ.82) KCP=LUCOMP(KFP) 
c
c  Get particle name, pad it and check it is not too long
c
          CALL LUNAME(kfp,CHAP)
c
          LEN=0
c
          DO 100 LEM=1,16
            IF(CHAP(LEM:LEM).NE.' ') LEN=LEM
 100      CONTINUE
c
          CHAC(njt)=CHAP(1:len)
 280    CONTINUE
c
        IF(IWR.EQ.1) WRITE(MSTU(11),1100) bridc,(chac(i),i=1,njt)
c
 290  CONTINUE
c
      IF(IWR.EQ.1) THEN
      WRITE(MSTU(11),*) 'Sum of branch=',brsu 
      WRITE(MSTU(11),*) ' '
      WRITE(MSTU(11),*) 'New added channels (include in old  qq~brat)'
      WRITE(MSTU(11),*) 'old qq~brat=',brat(idc_q)
      WRITE(MSTU(11),*) ' '
      END IF
c
      idc_min=0
      idc_max=0
c 
      if(kfa.eq.443) then          ! J/psi
        idc_min=1
        idc_max=mdcy_charm(1)
      else if(kfa.eq.30443) then   ! psi'
        idc_min=mdcy_charm(1)+1
        idc_max=mdcy_charm(2)
      end if 
c
      bratsum=0.
c
      DO 1290 IDC=idc_min, idc_max
        IF(MDME_charm(IDC,1).NE.1) goto 1290
        BRatsum=bratsum+BRAT_charm(IDc) 
        BRidc=BRAT_charm(IDc) 
c............ 
C  Read out decay products. Convert to standard flavour code. 
        njt=0
        JTMAX=5 
c
        DO 1280 JT=1,JTMAX 
          IF(JT.LE.5) KP=KFDP_charm(IDC,JT) 
          IF(JT.GE.6) KP=KFDP_charm(IDC+1,JT-5) 
          IF(KP.EQ.0) GOTO 1280 
          KPA=IABS(KP) 
          KCP=LUCOMP(KPA) 
          IF(KPA.GT.80) MHADDY=1 
c
          IF(KCHG(KCP,3).EQ.0.AND.KPA.NE.81.AND.KPA.NE.82) THEN 
            KFP=KP 
          ELSE IF(KPA.NE.81.AND.KPA.NE.82) THEN 
            KFP=KFS*KP 
          ELSE IF(KPA.EQ.81.AND.MOD(KFA/1000,10).EQ.0) THEN 
            KFP=-KFS*MOD(KFA/10,10) 
          ELSE IF(KPA.EQ.81.AND.MOD(KFA/100,10).GE.MOD(KFA/10,10)) THEN 
            KFP=KFS*(100*MOD(KFA/10,100)+3) 
          ELSE IF(KPA.EQ.81) THEN 
            KFP=KFS*(1000*MOD(KFA/10,10)+100*MOD(KFA/100,10)+1) 
          ELSE IF(KP.EQ.82) THEN 
c
c   Generate new quark (diquark) flavour and combine it with existing
c   flavour to obtain hadron
c
            CALL LUKFDI(-KFS*INT(1.+(2.+PARJ(2))*RLU(0)),0,KFP,KDUMP) 
c
            IF(KFP.EQ.0) GOTO 1280 
          ELSE IF(KP.EQ.-82) THEN 
            KFP=-KFP 
            IF(IABS(KFP).GT.10) KFP=KFP+ISIGN(10000,KFP) 
          END IF 
c
          NJT=NJT+1
          IF(KPA.EQ.81.OR.KPA.EQ.82) KCP=LUCOMP(KFP) 
c
c  Get particle name, pad it and check it is not too long.
c
          CALL LUNAME(kfp,CHAP)
c
          LEN=0
c
          DO 500 LEM=1,16
            IF(CHAP(LEM:LEM).NE.' ') LEN=LEM
 500      CONTINUE
c
          CHAC(njt)=CHAP(1:len)
 1280   CONTINUE
c
        IF(IWR.EQ.1) WRITE(MSTU(11),1100) BRIDC,(CHAC(i),I=1,njt)

 1290 CONTINUE 
c
      IF(IWR.EQ.1) WRITE(MSTU(11),*) 'Sum of new channels=',bratsum
      IF(IWR.EQ.1) WRITE(MSTU(11),*) ' '
c
 1100  format(1x,f10.5,5x,10a10)
c
      END 
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BESCHARM(KFL0,ECM) 
c***********************************************************************
c 
c  BESCHARM = former LUCHARM 
c
c  Purpose: to handle the generation of an e+e- annihilation jet event. 
c       to generate charm-onium decays (call luexec1->ludecy1->luonia1)
c
c  Input: KFL0 - should be 4 (charm)
c         ECM  - 
c
c***********************************************************************
c      IMPLICIT DOUBLE PRECISION(D) 

      Implicit NONE
c
      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)       !  jetset v7.4

      Common /LUDAT1/ MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      Integer *4 MSTU,MSTJ
      Real *4 PARU,PARJ

      Common /LUDAT2/ KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      Integer *4 KCHG
      Real *4 PMAS,PARF,VCKM
c
      REAL *8 DBEK
      REAL *4 ECM,XTOT,ECMC,PAK,THEK,PHIK,ALPK,CUT,X1,X2,X3,X4,X12,X14
      REAL *4 CHI,THE,PHI
      INTEGER *4 KFL0,KFL,NTRY,NC,KFLC,KF1,KF2,KC1,KC2,MSTU10,IP,MK
      INTEGER *4 KF,NMIN,NJET,MSTJ14,KFLN,LDECLST,LUCOMP
c
c      SAVE /LUJETS/,/LUDAT1/,/LUDAT2/ , ldeclst

      SAVE 

      Data ldeclst/0 /
      
      kfl=kfl0
c..........
c  Check input parameters. 
cjc      IF(MSTU(12).GE.1) CALL LULIST1(0) 
c
      IF(kfl.ne.4) THEN       ! check if charm flavour
c
        CALL LUERRM(16,'(LUcharm1:) called with not charm(4) flavour')
c
        IF(MSTU(21).GE.1) RETURN
      END IF
c
      IF(ECM.LT.PARJ(127)+2.02*PARF(101)) THEN
c
        CALL LUERRM(16,'(BEScharm1:) called with too small CM energy')
c
        IF(MSTU(21).GE.1) RETURN
      END IF
c
      KFL=0
c.........
c  Check consistency of MSTJ options set. 
      IF(MSTJ(109).EQ.2.AND.MSTJ(110).NE.1) THEN 
c
        CALL LUERRM(6, 
     &  '(LUEEVT:) MSTJ(109) value requires MSTJ(110) = 1') 
c
        MSTJ(110)=1 
      ENDIF 
c
      IF(MSTJ(109).EQ.2.AND.MSTJ(111).NE.0) THEN 
c
        CALL LUERRM(6, 
     &  '(LUEEVT:) MSTJ(109) value requires MSTJ(111) = 0') 
c
        MSTJ(111)=0 
      ENDIF 
c........
c  Initialize alpha_strong and total cross-section. 
      MSTU(111)=MSTJ(108) 
c
      IF(MSTJ(108).EQ.2.AND.(MSTJ(101).EQ.0.OR.MSTJ(101).EQ.1)) 
     &   MSTU(111)=1 
      PARU(112)=PARJ(121) 
      IF(MSTU(111).EQ.2) PARU(112)=PARJ(122) 
c
      IF(MSTJ(116).GT.0.AND.(MSTJ(116).GE.2.OR.ABS(ECM-PARJ(151)).GE. 
     &   PARJ(139).OR.10*MSTJ(102)+KFL.NE.MSTJ(119))) 
c
     &   CALL LUXTOT(KFL,ECM,XTOT) ! calc. total hadron cross section
c
      IF(MSTJ(116).GE.3) MSTJ(116)=1 
      PARJ(171)=0. 
c......... 
c  Add initial e+e- to event record (documentation only). 
      NTRY=0 
 100  NTRY=NTRY+1 
c
      IF(NTRY.GT.100) THEN 
c
        CALL LUERRM(14,'(LUEEVT:) caught in an infinite loop') 
c
        RETURN 
      END IF 
c
      MSTU(24)=0 
      NC=0 
c
      IF(MSTJ(115).GE.2) THEN 
        NC=NC+2 
c
        CALL LU1ENT(NC-1,11,0.5*ECM,0.,0.)      ! adds 1 entry
c
        K(NC-1,1)=21 
c
        CALL LU1ENT(NC,-11,0.5*ECM,PARU(1),0.) 
c
        K(NC,1)=21 
      ENDIF 
c........ 
c  Radiative photon (in initial state). 
      MK=0 
      ECMC=ECM 
c
      IF(MSTJ(107).GE.1.AND.MSTJ(116).GE.1) 

     &   CALL LURADK(ECM,MK,PAK,THEK,PHIK,ALPK) ! init. state radiation
c
      IF(MK.EQ.1) ECMC=SQRT(ECM*(ECM-2.*PAK)) 
c
      IF(MSTJ(115).GE.1.AND.MK.EQ.1) THEN 
        NC=NC+1 
c
        CALL LU1ENT(NC,22,PAK,THEK,PHIK)       ! adds 1 entry
c
        K(NC,3)=MIN(MSTJ(115)/2,1) 
      END IF 
c........ 
c  Virtual exchange boson (gamma or Z0). 
      IF(MSTJ(115).GE.3) THEN 
        NC=NC+1 
        KF=22 
        IF(MSTJ(102).EQ.2) KF=23 
        MSTU10=MSTU(10) 
        MSTU(10)=1 
        P(NC,5)=ECMC 
c
        CALL LU1ENT(NC,KF,ECMC,0.,0.) 
c
        K(NC,1)=21 
        K(NC,3)=1 
        MSTU(10)=MSTU10 
      END IF
c      
c jc/99 
c  Choose x1 and x2 according to matrix element.
c
      KFLC=IABS(KFL0)
      KF1=110*KFLC+3         !J/psi
      kc1=lucomp(kf1)
      KF2=30000+110*KFLC+3   ! psi'
      kc2=lucomp(kf2)
c
c  select J/psi or psi' by ECM-mass(J/psi or psi') < width_channel/2
c
      IF(ABS(Ecmc-pmas(KC1,1)).lt.0.00240) THEN ! 2*sig_Eb=0.0012 GeV for BES
        kf=kf1
      else if(ABS(Ecmc-3.096).lt.0.00240) then  ! 2*sig_Eb=0.0012GeV for BES
         kf=kf1
      else if(abs(Ecmc-pmas(KC2,1)).lt.0.0028) then !2*sig_Eb=0.0014GeV for BES 
        kf=kf2
      else
        goto 105
      END IF
c.........
c  list decay branching
      IF(ldeclst.eq.0) THEN
c
	call BESDEC1(kf)
c
        ldeclst=1
      END IF
c.........
c  Generate a charm-onia
      MSTU10=MSTU(10)
      MSTU(10)=1
      ip=Nc+1
      P(ip,5)=ECMc
c
      CALL LU1ENT(ip,KF,ECMC,0.,0.)
c
      K(IP,3)=K(IP,3)+(MSTJ(115)/2)+(KFLC/5)*(MSTJ(115)/3)*(NC-1)
      MSTU(10)=MSTU10
c...........
c  Rotation and boost from radiative photon
      IF(MK.EQ.1) THEN 
        DBEK=-PAK/(ECM-PAK) 
        NMIN=NC+1-MSTJ(115)/3 
c
        CALL LUDBRB(NMIN,N,0.,-PHIK,0D0,0D0,0D0) 
c
        CALL LUDBRB(NMIN,N,ALPK,0.,DBEK*SIN(THEK),0D0,DBEK*COS(THEK)) 
c
        CALL LUDBRB(NMIN,N,0.,PHIK,0D0,0D0,0D0) 
c
      END IF 
c.............. 
c  Generate fragmentation. Information for LUTABU:
      IF(MSTJ(105).EQ.1) CALL BESEXEC1
c
      MSTU(161)=110*KFLC+3
      MSTU(162)=0
      RETURN
c
 105  CONTINUE
c
c jc--
c  Choice of flavour and jet configuration. 
c
      CALL LUXKFL(KFL,ECM,ECMC,KFLC) ! select flavour of primary qqbar pair
c
      IF(KFLC.EQ.0) GOTO 100 
c
      CALL LUXJET(ECMC,NJET,CUT) ! select (matrix element) jet multiplicity
c
      KFLN=21 
      IF(NJET.EQ.4) CALL LUX4JT(NJET,CUT,KFLC,ECMC,KFLN,X1,X2,X4, 
     &                          X12,X14) ! select kinematics of 4-jet event
c
      IF(NJET.EQ.3) CALL LUX3JT(NJET,CUT,KFLC,ECMC,X1,X3) ! 3-jet event
c
      IF(NJET.EQ.2) MSTJ(120)=1 
c 
c  Fill jet configuration and origin (2-, 3-, 4-entry=parton or particle)
c
      IF(NJET.EQ.2.AND.MSTJ(101).NE.5) CALL LU2ENT(NC+1,KFLC,-KFLC,ECMC) 
c
      IF(NJET.EQ.2.AND.MSTJ(101).EQ.5) CALL LU2ENT(-(NC+1),KFLC,-KFLC, 
     &                                             ECMC) 
c
      IF(NJET.EQ.3) CALL LU3ENT(NC+1,KFLC,21,-KFLC,ECMC,X1,X3) 
c
      IF(NJET.EQ.4.AND.KFLN.EQ.21) CALL LU4ENT(NC+1,KFLC,KFLN,KFLN, 
     &                             -KFLC,ECMC,X1,X2,X4,X12,X14) 
c
      IF(NJET.EQ.4.AND.KFLN.NE.21) CALL LU4ENT(NC+1,KFLC,-KFLN,KFLN, 
     &                             -KFLC,ECMC,X1,X2,X4,X12,X14) 
c
      IF(MSTU(24).NE.0) GOTO 100 
c
      DO 110 IP=NC+1,N 
        K(IP,3)=K(IP,3)+MIN(MSTJ(115)/2,1)+(MSTJ(115)/3)*(NC-1) 
 110  CONTINUE 
c........ 
c  Angular orientation according to matrix element. 
      IF(MSTJ(106).EQ.1) THEN 
c
        CALL LUXDIF(NC,NJET,KFLC,ECMC,CHI,THE,PHI) ! select angular orientation
c
        CALL LUDBRB(NC+1,N,0.,CHI,0D0,0D0,0D0) ! rotation, Lorentz transf.
c
        CALL LUDBRB(NC+1,N,THE,PHI,0D0,0D0,0D0) 
c
      END IF 
c......... 
c  Rotation and boost from radiative photon. 
      IF(MK.EQ.1) THEN 
        DBEK=-PAK/(ECM-PAK) 
        NMIN=NC+1-MSTJ(115)/3 
c
        CALL LUDBRB(NMIN,N,0.,-PHIK,0D0,0D0,0D0) 
c
        CALL LUDBRB(NMIN,N,ALPK,0.,DBEK*SIN(THEK),0D0,DBEK*COS(THEK)) 
c
        CALL LUDBRB(NMIN,N,0.,PHIK,0D0,0D0,0D0) 
c
      END IF 
c......... 
c  Generate parton shower. Rearrange along strings and check. 
      IF(MSTJ(101).EQ.5) THEN 
c
        CALL LUSHOW(N-1,N,ECMC) 
c
        MSTJ14=MSTJ(14) 
        IF(MSTJ(105).EQ.-1) MSTJ(14)=-1 
        IF(MSTJ(105).GE.0) MSTU(28)=0 
c
        CALL LUPREP(0) ! work with parton shower
c
        MSTJ(14)=MSTJ14 
        IF(MSTJ(105).GE.0.AND.MSTU(28).NE.0) GOTO 100 
      END IF 
c....... 
c  Fragmentation/decay generation. Information for LUTABU. 
      IF(MSTJ(105).EQ.1) CALL BESEXEC1 
c
      MSTU(161)=KFLC 
      MSTU(162)=-KFLC 
c 
      RETURN 
      END 
c
c----------------------------------------------------------------------
c
      SUBROUTINE BESLUD1(IP,NGG,IPG) 
c*********************************************************************
c
c  BESLUD1 = former LUDECY1
c
c  Purpose: to handle the decay of unstable particles
c
c  Input:  IP - particle to decay    
c
c  Output: NGG - J/psi, psi' decay into ggg; need to check G parity. 
c          IPG - ip of decayed J/psi or psi' to ggg.                
c
c                                         Chen Jiangchuan 1998.5.31  
c
c*********************************************************************

      Implicit NONE
c
      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)       !  jetset v7.4

      Common /LUDAT1/ MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      Integer *4 MSTU,MSTJ
      Real *4 PARU,PARJ

      Common /LUDAT2/ KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      Integer *4 KCHG
      Real *4 PMAS,PARF,VCKM
      
      Common /LUDAT3/MDCY(500,3),MDME(2000,2),BRAT(2000),KFDP(2000,5)
      Integer *4 MDCY,MDME,KFDP
      Real *4 BRAT
c
      Common/charm/mdcy_charm(2),mdme_charm(100,2), brat_charm(100),
     &  kfdp_charm(100,5),moda
      Integer *4 mdcy_charm,mdme_charm,kfdp_charm,moda
      REAL *4 brat_charm

      SAVE

      REAL *8 DBETAU(3)

      REAL *4 VDCY(4),PV(10,5),RORD(10),UE(3),BE(3),WTCOR(10),PTAU(4)
      REAL *4 PCMTAU(4),PAWT,FOUR,HMEPS,A,B,C,HA,HRQ,RLU,PHITAU
      REAL *4 ULANGL,THETAU,XBBMIX,BRSU,RBR,PS,PSQ,ULMASS,PSP,CNDE
      REAL *4 GAUSS,PSM,PQT,PSMC,HR1,HR2,HLQ,HUQ,HW,HQW,HLW,HUW
      REAL *4 HG,HATL,HM,HMV1,HMV2,HMV,HM1,HATM,HWT1,HWT2,HWT3
      REAL *4 HATU,HMP1,HREG,HACC,WTMAX,PMAX,PMIN,PMES,PMRHO2
      REAL *4 PGRHO2,PMST,WT,RSAV,PA,PHI,GA,BEP,FOUR12,FOUR13,FOUR10
      REAL *4 FOUR02,PMS1,PMS0,PMS2,HNUM,HDEN,HX1,HX2,HX3,HXM
      REAL *4 PM2,PM3,PM4,HB,HC,HD,HE,HF,HH,PCOR,PMR,PM1

c      DIMENSION VDCY(4),KFLO(4),KFL1(4),PV(10,5),RORD(10),UE(3),BE(3), 
c     &WTCOR(10),PTAU(4),PCMTAU(4) 

      INTEGER *4 IP,NGG,IPG,KFLO(4),KFL1(4),I,J,NTRY,NSAV,KFA,KFS
      INTEGER *4 KC,LUCOMP,MOUT,ITAU,IMTAU,KFORIG,IORIG,II,NDECAY
      INTEGER *4 MMAT,MBST,ND,MMIX,KCA,MDMDCY,KFSP,KFSN,NOPE,IDL
      INTEGER *4 IDC,NP,NQ, MREM,MHADDY,JTMAX,lonid,idccharm,JT
      INTEGER *4 KP,IDL_charm0,idl_max,IDL_charm,ipp,KPA,KCP,KFP,KDUMP
      INTEGER *4 KFPA,KQP,KFI,KFLDMP,KFL2,JT2,JT3,ip1,ip2
      Integer *4 KF1,KF2,JCON,ip3,icg,kcok,ksok,NM,KFAS,MSGN,IM,KFAM
      INTEGER *4 IL,ISIS,IL1,IL2,IS,KFTEMP,KFLDUM

c
      DATA WTCOR/2.,5.,15.,60.,250.,1500.,1.2E4,1.2E5,150.,16./ 
c 
c...Functions: momentum in two-particle decays, four-product and 
c...matrix element times phase space in weak decays. 
      PAWT(A,B,C)=SQRT((A**2-(B+C)**2)*(A**2-(B-C)**2))/(2.*A) 
      FOUR(I,J)=P(I,4)*P(J,4)-P(I,1)*P(J,1)-P(I,2)*P(J,2)-P(I,3)*P(J,3) 
      HMEPS(HA)=((1.-HRQ-HA)**2+3.*HA*(1.+HRQ-HA))* 
     &          SQRT((1.-HRQ-HA)**2-4.*HRQ*HA) 

C...Initial values. 
      NTRY=0 
      NSAV=N 
      KFA=IABS(K(IP,2)) 
      KFS=ISIGN(1,K(IP,2)) 
      KC=LUCOMP(KFA) 
      MSTJ(92)=0 

C...Choose lifetime and determine decay vertex. 
      IF(K(IP,1).EQ.5) THEN 
        V(IP,5)=0. 
      ELSEIF(K(IP,1).NE.4) THEN 
        V(IP,5)=-PMAS(KC,4)*LOG(RLU(0)) 
      ENDIF 
c
      DO 100 J=1,4 
        VDCY(J)=V(IP,J)+V(IP,5)*P(IP,J)/P(IP,5) 
  100 CONTINUE 
 
C...Determine whether decay allowed or not. 
      MOUT=0 
c
      IF(MSTJ(22).EQ.2) THEN 
        IF(PMAS(KC,4).GT.PARJ(71)) MOUT=1 
      ELSEIF(MSTJ(22).EQ.3) THEN 
        IF(VDCY(1)**2+VDCY(2)**2+VDCY(3)**2.GT.PARJ(72)**2) MOUT=1 
      ELSEIF(MSTJ(22).EQ.4) THEN 
        IF(VDCY(1)**2+VDCY(2)**2.GT.PARJ(73)**2) MOUT=1 
        IF(ABS(VDCY(3)).GT.PARJ(74)) MOUT=1 
      ENDIF 
c
      IF(MOUT.EQ.1.AND.K(IP,1).NE.5) THEN 
        K(IP,1)=4 
        RETURN 
      ENDIF 
 
C...Interface to external tau decay library (for tau polarization). 
      IF(KFA.EQ.15.AND.MSTJ(28).GE.1) THEN 
 
C...Starting values for pointers and momenta. 
        ITAU=IP 
        DO 110 J=1,4 
        PTAU(J)=P(ITAU,J) 
        PCMTAU(J)=P(ITAU,J) 
  110   CONTINUE 
 
C...Iterate to find position and code of mother of tau. 
        IMTAU=ITAU 
  120   IMTAU=K(IMTAU,3) 
c 
        IF(IMTAU.EQ.0) THEN 
C...If no known origin then impossible to do anything further. 
          KFORIG=0 
          IORIG=0 
 
        ELSEIF(K(IMTAU,2).EQ.K(ITAU,2)) THEN 
C...If tau -> tau + gamma then add gamma energy and loop. 
          IF(K(K(IMTAU,4),2).EQ.22) THEN 
            DO 130 J=1,4 
            PCMTAU(J)=PCMTAU(J)+P(K(IMTAU,4),J) 
  130       CONTINUE 
          ELSEIF(K(K(IMTAU,5),2).EQ.22) THEN 
            DO 140 J=1,4 
            PCMTAU(J)=PCMTAU(J)+P(K(IMTAU,5),J) 
  140       CONTINUE 
          ENDIF 
          GOTO 120 
 
        ELSEIF(IABS(K(IMTAU,2)).GT.100) THEN 
C...If coming from weak decay of hadron then W is not stored in record, 
C...but can be reconstructed by adding neutrino momentum. 
          KFORIG=-ISIGN(24,K(ITAU,2)) 
          IORIG=0 
          DO 160 II=K(IMTAU,4),K(IMTAU,5) 
          IF(K(II,2)*ISIGN(1,K(ITAU,2)).EQ.-16) THEN 
            DO 150 J=1,4 
            PCMTAU(J)=PCMTAU(J)+P(II,J) 
  150       CONTINUE 
          ENDIF 
  160     CONTINUE 
 
        ELSE 
C...If coming from resonance decay then find latest copy of this 
C...resonance (may not completely agree). 
          KFORIG=K(IMTAU,2) 
          IORIG=IMTAU 
c
          DO 170 II=IMTAU+1,IP-1 
          IF(K(II,2).EQ.KFORIG.AND.K(II,3).EQ.IORIG.AND. 
     &    ABS(P(II,5)-P(IORIG,5)).LT.1E-5*P(IORIG,5)) IORIG=II 
  170     CONTINUE 
c
          DO 180 J=1,4 
            PCMTAU(J)=P(IORIG,J) 
  180     CONTINUE 
        ENDIF 
c 
c...Boost tau to rest frame of production process (where known) 
c...and rotate it to sit along +z axis. 
c
        DO 190 J=1,3 
          DBETAU(J)=PCMTAU(J)/PCMTAU(4) 
  190   CONTINUE 
c
        IF(KFORIG.NE.0) CALL LUDBRB(ITAU,ITAU,0.,0.,-DBETAU(1), 
     &     -DBETAU(2),-DBETAU(3)) 
c
        PHITAU=ULANGL(P(ITAU,1),P(ITAU,2)) 
c
        CALL LUDBRB(ITAU,ITAU,0.,-PHITAU,0D0,0D0,0D0) 
c
        THETAU=ULANGL(P(ITAU,3),P(ITAU,1)) 
c
        CALL LUDBRB(ITAU,ITAU,-THETAU,0.,0D0,0D0,0D0) 
 
C...Call tau decay routine (if meaningful) and fill extra info. 
        IF(KFORIG.NE.0.OR.MSTJ(28).EQ.2) THEN 
c
          CALL LUTAUD(ITAU,IORIG,KFORIG,NDECAY) 
c
          DO 200 II=NSAV+1,NSAV+NDECAY 
            K(II,1)=1 
            K(II,3)=IP 
            K(II,4)=0 
            K(II,5)=0 
  200     CONTINUE 
c
          N=NSAV+NDECAY 
        ENDIF 
 
C...Boost back decay tau and decay products. 
        DO 210 J=1,4 
          P(ITAU,J)=PTAU(J) 
  210   CONTINUE 
c
        IF(KFORIG.NE.0.OR.MSTJ(28).EQ.2) THEN 
c
          CALL LUDBRB(NSAV+1,N,THETAU,PHITAU,0D0,0D0,0D0) 
c
          IF(KFORIG.NE.0) CALL LUDBRB(NSAV+1,N,0.,0.,DBETAU(1), 
     &    DBETAU(2),DBETAU(3)) 
 
C...Skip past ordinary tau decay treatment. 
          MMAT=0 
          MBST=0 
          ND=0 
          GOTO 660 
        ENDIF
c 
      ENDIF 
 
C...B-B~ mixing: flip sign of meson appropriately. 
      MMIX=0 
c
      IF((KFA.EQ.511.OR.KFA.EQ.531).AND.MSTJ(26).GE.1) THEN 
        XBBMIX=PARJ(76) 
        IF(KFA.EQ.531) XBBMIX=PARJ(77) 
        IF(SIN(0.5*XBBMIX*V(IP,5)/PMAS(KC,4))**2.GT.RLU(0)) MMIX=1 
        IF(MMIX.EQ.1) KFS=-KFS 
      ENDIF 
c 
c...Check existence of decay channels. Particle/antiparticle rules. 
      KCA=KC 
c
      IF(MDCY(KC,2).GT.0) THEN 
        MDMDCY=MDME(MDCY(KC,2),2) 
        IF(MDMDCY.GT.80.AND.MDMDCY.LE.90) KCA=MDMDCY 
      ENDIF 
c
      IF(MDCY(KCA,2).LE.0.OR.MDCY(KCA,3).LE.0) THEN 
        CALL LUERRM(9,'(LUDECY:) no decay channel defined') 
        RETURN 
      ENDIF 
c
      IF(MOD(KFA/1000,10).EQ.0.AND.(KCA.EQ.85.OR.KCA.EQ.87)) KFS=-KFS 
c
      IF(KCHG(KC,3).EQ.0) THEN 
        KFSP=1 
        KFSN=0 
        IF(RLU(0).GT.0.5) KFS=-KFS 
      ELSEIF(KFS.GT.0) THEN 
        KFSP=1 
        KFSN=0 
      ELSE 
        KFSP=0 
        KFSN=1 
      ENDIF 
c 
c...Sum branching ratios of allowed decay channels. 
  220 NOPE=0 
      BRSU=0. 
c
      DO 230 IDL=MDCY(KCA,2),MDCY(KCA,2)+MDCY(KCA,3)-1 
        IF(MDME(IDL,1).NE.1.AND.KFSP*MDME(IDL,1).NE.2.AND. 
     &  KFSN*MDME(IDL,1).NE.3) GOTO 230 
        IF(MDME(IDL,2).GT.100) GOTO 230 
        NOPE=NOPE+1 
        BRSU=BRSU+BRAT(IDL) 
  230 CONTINUE 
c
      IF(NOPE.EQ.0) THEN 
c
        CALL LUERRM(2,'(LUDECY:) all decay channels closed by user') 
c
        RETURN 
      ENDIF 
c 
c...Select decay channel among allowed ones. 
  240 RBR=BRSU*RLU(0) 
      IDL=MDCY(KCA,2)-1 
  250 IDL=IDL+1 
c
      IF(MDME(IDL,1).NE.1.AND.KFSP*MDME(IDL,1).NE.2.AND. 
     &KFSN*MDME(IDL,1).NE.3) THEN 
        IF(IDL.LT.MDCY(KCA,2)+MDCY(KCA,3)-1) GOTO 250 
      ELSEIF(MDME(IDL,2).GT.100) THEN 
        IF(IDL.LT.MDCY(KCA,2)+MDCY(KCA,3)-1) GOTO 250 
      ELSE 
        IDC=IDL 
        RBR=RBR-BRAT(IDL) 
        IF(IDL.LT.MDCY(KCA,2)+MDCY(KCA,3)-1.AND.RBR.GT.0.) GOTO 250 
      ENDIF 
c 
c...Start readout of decay channel: matrix element, reset counters. 
      MMAT=MDME(IDC,2) 
  260 NTRY=NTRY+1 
      IF(NTRY.GT.1000) THEN 
c
        CALL LUERRM(14,'(BESLUD1:) caught in infinite loop') 
c
        call lulist(1)
c
        IF(MSTU(21).GE.1) RETURN 
      ENDIF 
c
      I=N 
      NP=0 
      NQ=0 
      MBST=0 
      IF(MMAT.GE.11.AND.MMAT.NE.46.AND.P(IP,4).GT.20.*P(IP,5)) MBST=1 
c
      DO 270 J=1,4 
        PV(1,J)=0. 
        IF(MBST.EQ.0) PV(1,J)=P(IP,J) 
  270 CONTINUE 
c
      IF(MBST.EQ.1) PV(1,4)=P(IP,5) 
      PV(1,5)=P(IP,5) 
      PS=0. 
      PSQ=0. 
      MREM=0 
      MHADDY=0 
      IF(KFA.GT.80) MHADDY=1 
 
C...Read out decay products. Convert to standard flavour code. 
      JTMAX=5 
      IF(MDME(IDC+1,2).EQ.101) JTMAX=10 
      lonid=0
      idccharm=0
c
      DO 280 JT=1,JTMAX 
      IF(JT.LE.5) KP=KFDP(IDC,JT) 
      IF(JT.GE.6) KP=KFDP(IDC+1,JT-5) 
cjc... J/psi or psi(2S)(for resonace's random quark)
      if(((kfa.eq.443).or.(kfa.eq.30443)).and.(lonid.ne.1)) then

C...Select decay channel among allowed ones(adding for charm in charm_updat.f).
        if((abs(kp).eq.82).and.(jt.eq.1)) then
  272     RBR=brat(idl)*RLU(0) 
            if(kfa.eq.443) then
              IDL_charm0=0                          !J/psi   IDCmin=1 
              idl_max=mdcy_charm(1)
             else  
               IDL_charm0=mdcy_charm(1)             !psi(2S)  IDCmin=51
              idl_max=mdcy_charm(2)
            endif  
            IDL_charm=IDL_charm0 
  274     IDL_charm=IDL_charm+1 
          IF(MDME_charm(IDL_charm,1).NE.1) THEN 
              IF(IDL_charm.LT.idl_max) GOTO 274
            ELSE 
              IDCcharm=IDL_charm 
              RBR=RBR-BRAT_charm(IDL_charm) 
              IF((IDL_charm.LT.idl_max).AND.(RBR.GT.0.)) GOTO 274
            ENDIF 
        endif

        if(idccharm.eq.(idl_charm0+1))then
            lonid=1                                             !qq~ decay
         elseif(idccharm.eq.(idl_charm0+2))then       
cjc... J/psi --> rgg/ggg    (for J/psi resonace's random quark)
            MMAT=MDME_charm(IDCcharm,2) 
            K(IP,1)=11                                !Mark decayed particle
            ipp=ip
            ngg=0
c
            call BESONIA1(ipp,4,ngg)                   ! rgg/ggg decay
c
            if(ngg.ge.1) ipg=ipp               !decay meson ip(used for G)
           return
         elseif(idccharm.ge.(idl_charm0+3)) then
            MMAT=MDME_charm(IDCcharm,2) 
           if(jt.le.5) then
              kp=kfdp_charm(idccharm,jt)       ! adding particle channel
            else
              kp=0
           endif
         endif

      endif
cjc...
      IF(KP.EQ.0) GOTO 280 
      KPA=IABS(KP) 
      KCP=LUCOMP(KPA) 
      IF(KPA.GT.80) MHADDY=1 
      IF(KCHG(KCP,3).EQ.0.AND.KPA.NE.81.AND.KPA.NE.82) THEN 
        KFP=KP 
      ELSEIF(KPA.NE.81.AND.KPA.NE.82) THEN 
        KFP=KFS*KP 
      ELSEIF(KPA.EQ.81.AND.MOD(KFA/1000,10).EQ.0) THEN 
        KFP=-KFS*MOD(KFA/10,10) 
      ELSEIF(KPA.EQ.81.AND.MOD(KFA/100,10).GE.MOD(KFA/10,10)) THEN 
        KFP=KFS*(100*MOD(KFA/10,100)+3) 
      ELSEIF(KPA.EQ.81) THEN 
        KFP=KFS*(1000*MOD(KFA/10,10)+100*MOD(KFA/100,10)+1) 
      ELSEIF(KP.EQ.82) THEN 
c 
        CALL LUKFDI(-KFS*INT(1.+(2.+PARJ(2))*RLU(0)),0,KFP,KDUMP) 
c 
        IF(KFP.EQ.0) GOTO 260 
        MSTJ(93)=1 
        IF(PV(1,5).LT.PARJ(32)+2.*ULMASS(KFP)) GOTO 260 
      ELSEIF(KP.EQ.-82) THEN 
        KFP=-KFP 
        IF(IABS(KFP).GT.10) KFP=KFP+ISIGN(10000,KFP) 
      ENDIF 
      IF(KPA.EQ.81.OR.KPA.EQ.82) KCP=LUCOMP(KFP) 
c.......... 
c   Add decay product to event record or to quark flavour list. 
      KFPA=IABS(KFP) 
      KQP=KCHG(KCP,2) 
c
      IF(MMAT.GE.11.AND.MMAT.LE.30.AND.KQP.NE.0) THEN 
        NQ=NQ+1 
        KFLO(NQ)=KFP 
        MSTJ(93)=2 
        PSQ=PSQ+ULMASS(KFLO(NQ)) 
      ELSEIF((MMAT.EQ.42.OR.MMAT.EQ.43.OR.MMAT.EQ.48).AND.NP.EQ.3.AND. 
     &MOD(NQ,2).EQ.1) THEN 
        NQ=NQ-1 
        PS=PS-P(I,5) 
        K(I,1)=1 
        KFI=K(I,2) 
c
        CALL LUKFDI(KFP,KFI,KFLDMP,K(I,2)) 
c
        IF(K(I,2).EQ.0) GOTO 260 
        MSTJ(93)=1 
        P(I,5)=ULMASS(K(I,2)) 
        PS=PS+P(I,5) 
      ELSE 
        I=I+1 
        NP=NP+1 
        IF(MMAT.NE.33.AND.KQP.NE.0) NQ=NQ+1 
        IF(MMAT.EQ.33.AND.KQP.NE.0.AND.KQP.NE.2) NQ=NQ+1 
        K(I,1)=1+MOD(NQ,2) 
        IF(MMAT.EQ.4.AND.JT.LE.2.AND.KFP.EQ.21) K(I,1)=2 
        IF(MMAT.EQ.4.AND.JT.EQ.3) K(I,1)=1 
        K(I,2)=KFP 
        K(I,3)=IP 
        K(I,4)=0 
        K(I,5)=0 
        P(I,5)=ULMASS(KFP) 
        IF(MMAT.EQ.45.AND.KFPA.EQ.89) P(I,5)=PARJ(32) 
        PS=PS+P(I,5) 
      ENDIF 
c
  280 CONTINUE 
c   
C...Check masses for resonance decays. 
      IF(MHADDY.EQ.0) THEN 
        IF(PS+PARJ(64).GT.PV(1,5)) GOTO 240 
      ENDIF 
 
C...Choose decay multiplicity in phase space model.  (cjc/99 qq~ decay) 
  290 IF(MMAT.GE.11.AND.MMAT.LE.30) THEN          
        PSP=PS 
        CNDE=PARJ(61)*LOG(MAX((PV(1,5)-PS-PSQ)/PARJ(62),1.1)) 
        IF(MMAT.EQ.12) CNDE=CNDE+PARJ(63) 
  300   NTRY=NTRY+1 
c
        IF(NTRY.GT.5000) THEN 
c
          CALL LUERRM(14,'(BESLUD2:) caught in infinite loop') 
c
        call lulist(1)
c
          IF(MSTU(21).GE.1) RETURN 
        ENDIF 
c
        IF(MMAT.LE.20) THEN 
          GAUSS=SQRT(-2.*CNDE*LOG(MAX(1E-10,RLU(0))))* 
     &    SIN(PARU(2)*RLU(0)) 
          ND=0.5+0.5*NP+0.25*NQ+CNDE+GAUSS 
          IF(ND.LT.NP+NQ/2.OR.ND.LT.2.OR.ND.GT.10) GOTO 300 
          IF(MMAT.EQ.13.AND.ND.EQ.2) GOTO 300 
          IF(MMAT.EQ.14.AND.ND.LE.3) GOTO 300 
          IF(MMAT.EQ.15.AND.ND.LE.4) GOTO 300 
        ELSE 
          ND=MMAT-20 
        ENDIF 
 
C...Form hadrons from flavour content. 
        DO 310 JT=1,4 
          KFL1(JT)=KFLO(JT) 
  310   CONTINUE 
        IF(ND.EQ.NP+NQ/2) GOTO 330 
c
        DO 320 I=N+NP+1,N+ND-NQ/2 
          JT=1+INT((NQ-1)*RLU(0)) 
          CALL LUKFDI(KFL1(JT),0,KFL2,K(I,2)) 
          IF(K(I,2).EQ.0) GOTO 300 
          KFL1(JT)=-KFL2 
  320   CONTINUE 
c
  330   JT=2 
        JT2=3 
        JT3=4 
        IF(NQ.EQ.4.AND.RLU(0).LT.PARJ(66)) JT=4 
        IF(JT.EQ.4.AND.ISIGN(1,KFL1(1)*(10-IABS(KFL1(1))))* 
     &  ISIGN(1,KFL1(JT)*(10-IABS(KFL1(JT)))).GT.0) JT=3 
        IF(JT.EQ.3) JT2=2 
        IF(JT.EQ.4) JT3=2 
c
        CALL LUKFDI(KFL1(1),KFL1(JT),KFLDMP,K(N+ND-NQ/2+1,2)) 
c
        IF(K(N+ND-NQ/2+1,2).EQ.0) GOTO 300 
c
        IF(NQ.EQ.4) CALL LUKFDI(KFL1(JT2),KFL1(JT3),KFLDMP,K(N+ND,2)) 
c
        IF(NQ.EQ.4.AND.K(N+ND,2).EQ.0) GOTO 300 
        
C...Check that sum of decay product masses not too large. 
        PS=PSP 
c
        DO 340 I=N+NP+1,N+ND 
          K(I,1)=1 
          K(I,3)=IP 
          K(I,4)=0 
          K(I,5)=0 
          P(I,5)=ULMASS(K(I,2)) 
          PS=PS+P(I,5) 
  340   CONTINUE 
c
        IF(PS+PARJ(64).GT.PV(1,5)) GOTO 300 
c............
c   check C parity conservation (in gamma*-->qq~)
        ip1=ip
        ip2=n+1     ! np=0 usually when mmat=11-30,except g,q in products
        ip3=n+nd
	icg=1
c
        CALL BESCGPAR(ip1,ip2,ip3,kcok,0,icg)
c
        if(kcok.eq.-1) goto 300
c
        call BESSUPR(ip1,ip2,ip3,ksok)
c
        if(ksok.eq.-1) goto 300

C...Rescale energy to subtract off spectator quark mass. 
      ELSEIF((MMAT.EQ.31.OR.MMAT.EQ.33.OR.MMAT.EQ.44.OR.MMAT.EQ.45) 
     &.AND.NP.GE.3) THEN 
        PS=PS-P(N+NP,5) 
        PQT=(P(N+NP,5)+PARJ(65))/PV(1,5) 
c
        DO 350 J=1,5 
          P(N+NP,J)=PQT*PV(1,J) 
          PV(1,J)=(1.-PQT)*PV(1,J) 
  350   CONTINUE 
c
        IF(PS+PARJ(64).GT.PV(1,5)) GOTO 260 
        ND=NP-1 
        MREM=1 
 
C...Phase space factors imposed in W decay. 
      ELSEIF(MMAT.EQ.46) THEN 
        MSTJ(93)=1 
        PSMC=ULMASS(K(N+1,2)) 
        MSTJ(93)=1 
        PSMC=PSMC+ULMASS(K(N+2,2)) 
        IF(MAX(PS,PSMC)+PARJ(32).GT.PV(1,5)) GOTO 240 
        HR1=(P(N+1,5)/PV(1,5))**2 
        HR2=(P(N+2,5)/PV(1,5))**2 
        IF((1.-HR1-HR2)*(2.+HR1+HR2)*SQRT((1.-HR1-HR2)**2-4.*HR1*HR2) 
     &      .LT.2.*RLU(0)) GOTO 240 
        ND=NP 
 
C...Fully specified final state: check mass broadening effects. 
      ELSE
       IF(NP.GE.2.AND.PS+PARJ(64).GT.PV(1,5)) THEN  ! corr. by Todyshev
          IF(NTRY.gt.500) GOTO 240                  ! 
          GOTO 260                                  !
        END IF                                      !
c        IF(NP.GE.2.AND.PS+PARJ(64).GT.PV(1,5)) GOTO 260 ! old
        ND=NP 
      ENDIF 
 
C...Select W mass in decay Q -> W + q, without W propagator. 
      IF(MMAT.EQ.45.AND.MSTJ(25).LE.0) THEN 
        HLQ=(PARJ(32)/PV(1,5))**2 
        HUQ=(1.-(P(N+2,5)+PARJ(64))/PV(1,5))**2 
        HRQ=(P(N+2,5)/PV(1,5))**2 
  360   HW=HLQ+RLU(0)*(HUQ-HLQ) 
        IF(HMEPS(HW).LT.RLU(0)) GOTO 360 
        P(N+1,5)=PV(1,5)*SQRT(HW) 
 
C...Ditto, including W propagator. Divide mass range into three regions. 
      ELSEIF(MMAT.EQ.45) THEN 
        HQW=(PV(1,5)/PMAS(24,1))**2 
        HLW=(PARJ(32)/PMAS(24,1))**2 
        HUW=((PV(1,5)-P(N+2,5)-PARJ(64))/PMAS(24,1))**2 
        HRQ=(P(N+2,5)/PV(1,5))**2 
        HG=PMAS(24,2)/PMAS(24,1) 
        HATL=ATAN((HLW-1.)/HG) 
        HM=MIN(1.,HUW-0.001) 
        HMV1=HMEPS(HM/HQW)/((HM-1.)**2+HG**2) 
  370   HM=HM-HG 
        HMV2=HMEPS(HM/HQW)/((HM-1.)**2+HG**2) 
c
        IF(HMV2.GT.HMV1.AND.HM-HG.GT.HLW) THEN 
          HMV1=HMV2 
          GOTO 370 
        ENDIF 
c
        HMV=MIN(2.*HMV1,HMEPS(HM/HQW)/HG**2) 
        HM1=1.-SQRT(1./HMV-HG**2) 
c
        IF(HM1.GT.HLW.AND.HM1.LT.HM) THEN 
          HM=HM1 
        ELSEIF(HMV2.LE.HMV1) THEN 
          HM=MAX(HLW,HM-MIN(0.1,1.-HM)) 
        ENDIF 
c
        HATM=ATAN((HM-1.)/HG) 
        HWT1=(HATM-HATL)/HG 
        HWT2=HMV*(MIN(1.,HUW)-HM) 
        HWT3=0. 
c
        IF(HUW.GT.1.) THEN 
          HATU=ATAN((HUW-1.)/HG) 
          HMP1=HMEPS(1./HQW) 
          HWT3=HMP1*HATU/HG 
        ENDIF 
c 
c...Select mass region and W mass there. Accept according to weight. 
  380   HREG=RLU(0)*(HWT1+HWT2+HWT3) 
c
        IF(HREG.LE.HWT1) THEN 
          HW=1.+HG*TAN(HATL+RLU(0)*(HATM-HATL)) 
          HACC=HMEPS(HW/HQW) 
        ELSEIF(HREG.LE.HWT1+HWT2) THEN 
          HW=HM+RLU(0)*(MIN(1.,HUW)-HM) 
          HACC=HMEPS(HW/HQW)/((HW-1.)**2+HG**2)/HMV 
        ELSE 
          HW=1.+HG*TAN(RLU(0)*HATU) 
          HACC=HMEPS(HW/HQW)/HMP1 
        ENDIF 
        IF(HACC.LT.RLU(0)) GOTO 380 
        P(N+1,5)=PMAS(24,1)*SQRT(HW) 
      ENDIF 
c
c...Determine position of grandmother, number of sisters, Q -> W sign. 
      NM=0 
      KFAS=0 
      MSGN=0 
c
      IF(MMAT.EQ.3.OR.MMAT.EQ.46) THEN 
        IM=K(IP,3) 
        IF(IM.LT.0.OR.IM.GE.IP) IM=0 
        IF(MMAT.EQ.46.AND.MSTJ(27).EQ.1) THEN 
          IM=0 
        ELSEIF(MMAT.EQ.46.AND.MSTJ(27).GE.2.AND.IM.NE.0) THEN 
          IF(K(IM,2).EQ.94) THEN 
            IM=K(K(IM,3),3) 
            IF(IM.LT.0.OR.IM.GE.IP) IM=0 
          ENDIF 
        ENDIF 
c
        IF(IM.NE.0) KFAM=IABS(K(IM,2)) 
c
        IF(IM.NE.0.AND.MMAT.EQ.3) THEN 
c
          DO 390 IL=MAX(IP-2,IM+1),MIN(IP+2,N) 
            IF(K(IL,3).EQ.IM) NM=NM+1 
            IF(K(IL,3).EQ.IM.AND.IL.NE.IP) ISIS=IL 
  390     CONTINUE 
c
          IF(NM.NE.2.OR.KFAM.LE.100.OR.MOD(KFAM,10).NE.1.OR. 
     &    MOD(KFAM/1000,10).NE.0) NM=0 
          IF(NM.EQ.2) THEN 
            KFAS=IABS(K(ISIS,2)) 
            IF((KFAS.LE.100.OR.MOD(KFAS,10).NE.1.OR. 
     &      MOD(KFAS/1000,10).NE.0).AND.KFAS.NE.22) NM=0 
          ENDIF 
        ELSEIF(IM.NE.0.AND.MMAT.EQ.46) THEN 
          MSGN=ISIGN(1,K(IM,2)*K(IP,2)) 
          IF(KFAM.GT.100.AND.MOD(KFAM/1000,10).EQ.0) MSGN= 
     &    MSGN*(-1)**MOD(KFAM/100,10) 
        ENDIF 
      ENDIF 
c 
C...Kinematics of one-particle decays. 
      IF(ND.EQ.1) THEN 
c
        DO 400 J=1,4 
          P(N+1,J)=P(IP,J) 
  400   CONTINUE 
c
        GOTO 660 
      ENDIF 
 
C...Calculate maximum weight ND-particle decay. 
      PV(ND,5)=P(N+ND,5) 
c
      IF(ND.GE.3) THEN 
        WTMAX=1./WTCOR(ND-2) 
        PMAX=PV(1,5)-PS+P(N+ND,5) 
        PMIN=0. 
c
        DO 410 IL=ND-1,1,-1 
          PMAX=PMAX+P(N+IL,5) 
          PMIN=PMIN+P(N+IL+1,5) 
          WTMAX=WTMAX*PAWT(PMAX,PMIN,P(N+IL,5)) 
  410   CONTINUE 
c
      ENDIF 
 
C...Find virtual gamma mass in Dalitz decay. 
  420 IF(ND.EQ.2) THEN 
      ELSEIF(MMAT.EQ.2) THEN 
        PMES=4.*PMAS(11,1)**2 
        PMRHO2=PMAS(131,1)**2 
        PGRHO2=PMAS(131,2)**2 
  430   PMST=PMES*(P(IP,5)**2/PMES)**RLU(0) 
        WT=(1+0.5*PMES/PMST)*SQRT(MAX(0.,1.-PMES/PMST))* 
     &  (1.-PMST/P(IP,5)**2)**3*(1.+PGRHO2/PMRHO2)/ 
     &  ((1.-PMST/PMRHO2)**2+PGRHO2/PMRHO2) 
        IF(WT.LT.RLU(0)) GOTO 430 
        PV(2,5)=MAX(2.00001*PMAS(11,1),SQRT(PMST)) 
c.......... 
c  M-generator gives weight. If rejected, try again. 
      ELSE 
  440   RORD(1)=1. 
c
        DO 470 IL1=2,ND-1 
          RSAV=RLU(0) 
c
          DO 450 IL2=IL1-1,1,-1 
            IF(RSAV.LE.RORD(IL2)) GOTO 460 
            RORD(IL2+1)=RORD(IL2) 
  450     CONTINUE 
c
  460     RORD(IL2+1)=RSAV 
  470   CONTINUE 
c
        RORD(ND)=0. 
        WT=1. 
c
        DO 480 IL=ND-1,1,-1 
        PV(IL,5)=PV(IL+1,5)+P(N+IL,5)+(RORD(IL)-RORD(IL+1))*(PV(1,5)-PS) 
        WT=WT*PAWT(PV(IL,5),PV(IL+1,5),P(N+IL,5)) 
  480   CONTINUE 
c
        IF(WT.LT.RLU(0)*WTMAX) GOTO 440 
      ENDIF 
c............. 
c  Perform two-particle decays in respective CM frame. 
  490 DO 510 IL=1,ND-1 
        PA=PAWT(PV(IL,5),PV(IL+1,5),P(N+IL,5)) 
        UE(3)=2.*RLU(0)-1. 
        PHI=PARU(2)*RLU(0) 
        UE(1)=SQRT(1.-UE(3)**2)*COS(PHI) 
        UE(2)=SQRT(1.-UE(3)**2)*SIN(PHI) 
c
        DO 500 J=1,3 
          P(N+IL,J)=PA*UE(J) 
          PV(IL+1,J)=-PA*UE(J) 
  500   CONTINUE 
c
        P(N+IL,4)=SQRT(PA**2+P(N+IL,5)**2) 
        PV(IL+1,4)=SQRT(PA**2+PV(IL+1,5)**2) 
  510 CONTINUE 
c 
C...Lorentz transform decay products to lab frame. 
      DO 520 J=1,4 
        P(N+ND,J)=PV(ND,J) 
  520 CONTINUE 
c
      DO 560 IL=ND-1,1,-1 
c
        DO 530 J=1,3 
          BE(J)=PV(IL,J)/PV(IL,4) 
  530   CONTINUE 
c
        GA=PV(IL,4)/PV(IL,5) 
c
        DO 550 I=N+IL,N+ND 
          BEP=BE(1)*P(I,1)+BE(2)*P(I,2)+BE(3)*P(I,3) 
c
          DO 540 J=1,3 
            P(I,J)=P(I,J)+GA*(GA*BEP/(1.+GA)+P(I,4))*BE(J) 
  540     CONTINUE 
c
          P(I,4)=GA*(P(I,4)+BEP) 
  550   CONTINUE 
c
  560 CONTINUE 
 
C...Check that no infinite loop in matrix element weight. 
      NTRY=NTRY+1 
      IF(NTRY.GT.800) GOTO 590 
 
C...Matrix elements for omega and phi decays. 
      IF(MMAT.EQ.1) THEN 
        WT=(P(N+1,5)*P(N+2,5)*P(N+3,5))**2-(P(N+1,5)*FOUR(N+2,N+3))**2 
     &  -(P(N+2,5)*FOUR(N+1,N+3))**2-(P(N+3,5)*FOUR(N+1,N+2))**2 
     &  +2.*FOUR(N+1,N+2)*FOUR(N+1,N+3)*FOUR(N+2,N+3) 
        IF(MAX(WT*WTCOR(9)/P(IP,5)**6,0.001).LT.RLU(0)) GOTO 420 
 
C...Matrix elements for pi0 or eta Dalitz decay to gamma e+ e-. 
      ELSEIF(MMAT.EQ.2) THEN 
        FOUR12=FOUR(N+1,N+2) 
        FOUR13=FOUR(N+1,N+3) 
        WT=(PMST-0.5*PMES)*(FOUR12**2+FOUR13**2)+ 
     &  PMES*(FOUR12*FOUR13+FOUR12**2+FOUR13**2) 
        IF(WT.LT.RLU(0)*0.25*PMST*(P(IP,5)**2-PMST)**2) GOTO 490 
 
C...Matrix element for S0 -> S1 + V1 -> S1 + S2 + S3 (S scalar, 
C...V vector), of form cos**2(theta02) in V1 rest frame, and for 
C...S0 -> gamma + V1 -> gamma + S2 + S3, of form sin**2(theta02). 
      ELSEIF(MMAT.EQ.3.AND.NM.EQ.2) THEN 
        FOUR10=FOUR(IP,IM) 
        FOUR12=FOUR(IP,N+1) 
        FOUR02=FOUR(IM,N+1) 
        PMS1=P(IP,5)**2 
        PMS0=P(IM,5)**2 
        PMS2=P(N+1,5)**2 
        IF(KFAS.NE.22) HNUM=(FOUR10*FOUR12-PMS1*FOUR02)**2 
        IF(KFAS.EQ.22) HNUM=PMS1*(2.*FOUR10*FOUR12*FOUR02- 
     &  PMS1*FOUR02**2-PMS0*FOUR12**2-PMS2*FOUR10**2+PMS1*PMS0*PMS2) 
        HNUM=MAX(1E-6*PMS1**2*PMS0*PMS2,HNUM) 
        HDEN=(FOUR10**2-PMS1*PMS0)*(FOUR12**2-PMS1*PMS2) 
        IF(HNUM.LT.RLU(0)*HDEN) GOTO 490 
 
C...Matrix element for "onium" -> g + g + g or gamma + g + g. 
      ELSEIF(MMAT.EQ.4) THEN 
        HX1=2.*FOUR(IP,N+1)/P(IP,5)**2 
        HX2=2.*FOUR(IP,N+2)/P(IP,5)**2 
        HX3=2.*FOUR(IP,N+3)/P(IP,5)**2 
        WT=((1.-HX1)/(HX2*HX3))**2+((1.-HX2)/(HX1*HX3))**2+ 
     &  ((1.-HX3)/(HX1*HX2))**2 
        IF(WT.LT.2.*RLU(0)) GOTO 420 
        IF(K(IP+1,2).EQ.22.AND.(1.-HX1)*P(IP,5)**2.LT.4.*PARJ(32)**2) 
     &  GOTO 420 
 
C...Effective matrix element for nu spectrum in tau -> nu + hadrons. 
      ELSEIF(MMAT.EQ.41) THEN 
        HX1=2.*FOUR(IP,N+1)/P(IP,5)**2 
        HXM=MIN(0.75,2.*(1.-PS/P(IP,5))) 
        IF(HX1*(3.-2.*HX1).LT.RLU(0)*HXM*(3.-2.*HXM)) GOTO 420 
 
C...Matrix elements for weak decays (only semileptonic for c and b) 
      ELSEIF((MMAT.EQ.42.OR.MMAT.EQ.43.OR.MMAT.EQ.44.OR.MMAT.EQ.48) 
     &.AND.ND.EQ.3) THEN 
        IF(MBST.EQ.0) WT=FOUR(IP,N+1)*FOUR(N+2,N+3) 
        IF(MBST.EQ.1) WT=P(IP,5)*P(N+1,4)*FOUR(N+2,N+3) 
        IF(WT.LT.RLU(0)*P(IP,5)*PV(1,5)**3/WTCOR(10)) GOTO 420 
      ELSEIF(MMAT.EQ.42.OR.MMAT.EQ.43.OR.MMAT.EQ.44.OR.MMAT.EQ.48) THEN 
c
        DO 580 J=1,4 
          P(N+NP+1,J)=0. 
c
          DO 570 IS=N+3,N+NP 
            P(N+NP+1,J)=P(N+NP+1,J)+P(IS,J) 
  570     CONTINUE 
c
  580   CONTINUE 
c
        IF(MBST.EQ.0) WT=FOUR(IP,N+1)*FOUR(N+2,N+NP+1) 
        IF(MBST.EQ.1) WT=P(IP,5)*P(N+1,4)*FOUR(N+2,N+NP+1) 
        IF(WT.LT.RLU(0)*P(IP,5)*PV(1,5)**3/WTCOR(10)) GOTO 420 
c......... 
c  Angular distribution in W decay. 
      ELSEIF(MMAT.EQ.46.AND.MSGN.NE.0) THEN 
        IF(MSGN.GT.0) WT=FOUR(IM,N+1)*FOUR(N+2,IP+1) 
        IF(MSGN.LT.0) WT=FOUR(IM,N+2)*FOUR(N+1,IP+1) 
        IF(WT.LT.RLU(0)*P(IM,5)**4/WTCOR(10)) GOTO 490 
      ENDIF 
c.......... 
c  Scale back energy and reattach spectator. 
  590 IF(MREM.EQ.1) THEN 
c
        DO 600 J=1,5 
          PV(1,J)=PV(1,J)/(1.-PQT) 
  600   CONTINUE 
c
        ND=ND+1 
        MREM=0 
      ENDIF 
 
C...Low invariant mass for system with spectator quark gives particle, 
C...not two jets. Readjust momenta accordingly. 
      IF((MMAT.EQ.31.OR.MMAT.EQ.45).AND.ND.EQ.3) THEN 
        MSTJ(93)=1 
        PM2=ULMASS(K(N+2,2)) 
        MSTJ(93)=1 
        PM3=ULMASS(K(N+3,2)) 
        IF(P(N+2,5)**2+P(N+3,5)**2+2.*FOUR(N+2,N+3).GE. 
     &  (PARJ(32)+PM2+PM3)**2) GOTO 660 
        K(N+2,1)=1 
        KFTEMP=K(N+2,2) 
c
        CALL LUKFDI(KFTEMP,K(N+3,2),KFLDMP,K(N+2,2)) 
c
        IF(K(N+2,2).EQ.0) GOTO 260 
        P(N+2,5)=ULMASS(K(N+2,2)) 
        PS=P(N+1,5)+P(N+2,5) 
        PV(2,5)=P(N+2,5) 
        MMAT=0 
        ND=2 
        GOTO 490 
      ELSEIF(MMAT.EQ.44) THEN 
        MSTJ(93)=1 
        PM3=ULMASS(K(N+3,2)) 
        MSTJ(93)=1 
        PM4=ULMASS(K(N+4,2)) 
        IF(P(N+3,5)**2+P(N+4,5)**2+2.*FOUR(N+3,N+4).GE. 
     &  (PARJ(32)+PM3+PM4)**2) GOTO 630 
        K(N+3,1)=1 
        KFTEMP=K(N+3,2) 
c
        CALL LUKFDI(KFTEMP,K(N+4,2),KFLDMP,K(N+3,2)) 
c
        IF(K(N+3,2).EQ.0) GOTO 260 
        P(N+3,5)=ULMASS(K(N+3,2)) 
c
        DO 610 J=1,3 
          P(N+3,J)=P(N+3,J)+P(N+4,J) 
  610   CONTINUE 
c
        P(N+3,4)=SQRT(P(N+3,1)**2+P(N+3,2)**2+P(N+3,3)**2+P(N+3,5)**2) 
        HA=P(N+1,4)**2-P(N+2,4)**2 
        HB=HA-(P(N+1,5)**2-P(N+2,5)**2) 
        HC=(P(N+1,1)-P(N+2,1))**2+(P(N+1,2)-P(N+2,2))**2+ 
     &  (P(N+1,3)-P(N+2,3))**2 
        HD=(PV(1,4)-P(N+3,4))**2 
        HE=HA**2-2.*HD*(P(N+1,4)**2+P(N+2,4)**2)+HD**2 
        HF=HD*HC-HB**2 
        HG=HD*HC-HA*HB 
        HH=(SQRT(HG**2+HE*HF)-HG)/(2.*HF) 
c
        DO 620 J=1,3 
          PCOR=HH*(P(N+1,J)-P(N+2,J)) 
          P(N+1,J)=P(N+1,J)+PCOR 
          P(N+2,J)=P(N+2,J)-PCOR 
  620   CONTINUE 
c
        P(N+1,4)=SQRT(P(N+1,1)**2+P(N+1,2)**2+P(N+1,3)**2+P(N+1,5)**2) 
        P(N+2,4)=SQRT(P(N+2,1)**2+P(N+2,2)**2+P(N+2,3)**2+P(N+2,5)**2) 
        ND=ND-1 
      ENDIF 
 
C...Check invariant mass of W jets. May give one particle or start over. 
  630 IF((MMAT.EQ.42.OR.MMAT.EQ.43.OR.MMAT.EQ.44.OR.MMAT.EQ.48) 
     &.AND.IABS(K(N+1,2)).LT.10) THEN 
        PMR=SQRT(MAX(0.,P(N+1,5)**2+P(N+2,5)**2+2.*FOUR(N+1,N+2))) 
        MSTJ(93)=1 
        PM1=ULMASS(K(N+1,2)) 
        MSTJ(93)=1 
        PM2=ULMASS(K(N+2,2)) 
        IF(PMR.GT.PARJ(32)+PM1+PM2) GOTO 640 
        KFLDUM=INT(1.5+RLU(0)) 
c
        CALL LUKFDI(K(N+1,2),-ISIGN(KFLDUM,K(N+1,2)),KFLDMP,KF1) 
c
        CALL LUKFDI(K(N+2,2),-ISIGN(KFLDUM,K(N+2,2)),KFLDMP,KF2) 
c
        IF(KF1.EQ.0.OR.KF2.EQ.0) GOTO 260 
        PSM=ULMASS(KF1)+ULMASS(KF2) 
        IF((MMAT.EQ.42.OR.MMAT.EQ.48).AND.PMR.GT.PARJ(64)+PSM) GOTO 640 
        IF(MMAT.GE.43.AND.PMR.GT.0.2*PARJ(32)+PSM) GOTO 640 
        IF(MMAT.EQ.48) GOTO 420 
        IF(ND.EQ.4.OR.KFA.EQ.15) GOTO 260 
        K(N+1,1)=1 
        KFTEMP=K(N+1,2) 
c
        CALL LUKFDI(KFTEMP,K(N+2,2),KFLDMP,K(N+1,2)) 
c
        IF(K(N+1,2).EQ.0) GOTO 260 
        P(N+1,5)=ULMASS(K(N+1,2)) 
        K(N+2,2)=K(N+3,2) 
        P(N+2,5)=P(N+3,5) 
        PS=P(N+1,5)+P(N+2,5) 
        IF(PS+PARJ(64).GT.PV(1,5)) GOTO 260 
        PV(2,5)=P(N+3,5) 
        MMAT=0 
        ND=2 
        GOTO 490 
      ENDIF 
c.......... 
c  Phase space decay of partons from W decay. 
  640 IF((MMAT.EQ.42.OR.MMAT.EQ.48).AND.IABS(K(N+1,2)).LT.10) THEN 
        KFLO(1)=K(N+1,2) 
        KFLO(2)=K(N+2,2) 
        K(N+1,1)=K(N+3,1) 
        K(N+1,2)=K(N+3,2) 
c
        DO 650 J=1,5 
          PV(1,J)=P(N+1,J)+P(N+2,J) 
          P(N+1,J)=P(N+3,J) 
  650   CONTINUE 
c
        PV(1,5)=PMR 
        N=N+1 
        NP=0 
        NQ=2 
        PS=0. 
        MSTJ(93)=2 
        PSQ=ULMASS(KFLO(1)) 
        MSTJ(93)=2 
        PSQ=PSQ+ULMASS(KFLO(2)) 
        MMAT=11 
        GOTO 290 
      ENDIF 
c......... 
c  Boost back for rapidly moving particle. 
  660 N=N+ND 
      IF(MBST.EQ.1) THEN 
c
        DO 670 J=1,3 
          BE(J)=P(IP,J)/P(IP,4) 
  670   CONTINUE 
c
        GA=P(IP,4)/P(IP,5) 
        DO 690 I=NSAV+1,N 
        BEP=BE(1)*P(I,1)+BE(2)*P(I,2)+BE(3)*P(I,3) 
c
        DO 680 J=1,3 
          P(I,J)=P(I,J)+GA*(GA*BEP/(1.+GA)+P(I,4))*BE(J) 
  680   CONTINUE 
c
        P(I,4)=GA*(P(I,4)+BEP) 
  690   CONTINUE 
      ENDIF 
c......... 
c  Fill in position of decay vertex. 
      DO 710 I=NSAV+1,N 
c
        DO 700 J=1,4 
          V(I,J)=VDCY(J) 
  700   CONTINUE 
c
        V(I,5)=0. 
  710 CONTINUE 
c.......... 
c  Set up for parton shower evolution from jets. 
      IF(MSTJ(23).GE.1.AND.MMAT.EQ.4.AND.K(NSAV+1,2).EQ.21) THEN 
        K(NSAV+1,1)=3 
        K(NSAV+2,1)=3 
        K(NSAV+3,1)=3 
        K(NSAV+1,4)=MSTU(5)*(NSAV+2) 
        K(NSAV+1,5)=MSTU(5)*(NSAV+3) 
        K(NSAV+2,4)=MSTU(5)*(NSAV+3) 
        K(NSAV+2,5)=MSTU(5)*(NSAV+1) 
        K(NSAV+3,4)=MSTU(5)*(NSAV+1) 
        K(NSAV+3,5)=MSTU(5)*(NSAV+2) 
        MSTJ(92)=-(NSAV+1) 
      ELSEIF(MSTJ(23).GE.1.AND.MMAT.EQ.4) THEN 
        K(NSAV+2,1)=3 
        K(NSAV+3,1)=3 
        K(NSAV+2,4)=MSTU(5)*(NSAV+3) 
        K(NSAV+2,5)=MSTU(5)*(NSAV+3) 
        K(NSAV+3,4)=MSTU(5)*(NSAV+2) 
        K(NSAV+3,5)=MSTU(5)*(NSAV+2) 
        MSTJ(92)=NSAV+2 
      ELSEIF(MSTJ(23).GE.1.AND.(MMAT.EQ.32.OR.MMAT.EQ.44.OR.MMAT.EQ.46) 
     &.AND.IABS(K(NSAV+1,2)).LE.10.AND.IABS(K(NSAV+2,2)).LE.10) THEN 
        K(NSAV+1,1)=3 
        K(NSAV+2,1)=3 
        K(NSAV+1,4)=MSTU(5)*(NSAV+2) 
        K(NSAV+1,5)=MSTU(5)*(NSAV+2) 
        K(NSAV+2,4)=MSTU(5)*(NSAV+1) 
        K(NSAV+2,5)=MSTU(5)*(NSAV+1) 
        MSTJ(92)=NSAV+1 
      ELSEIF(MSTJ(23).GE.1.AND.(MMAT.EQ.32.OR.MMAT.EQ.44.OR.MMAT.EQ.46) 
     &.AND.IABS(K(NSAV+1,2)).LE.20.AND.IABS(K(NSAV+2,2)).LE.20) THEN 
        MSTJ(92)=NSAV+1 
      ELSEIF(MSTJ(23).GE.1.AND.MMAT.EQ.33.AND.IABS(K(NSAV+2,2)).EQ.21) 
     &THEN 
        K(NSAV+1,1)=3 
        K(NSAV+2,1)=3 
        K(NSAV+3,1)=3 
        KCP=LUCOMP(K(NSAV+1,2)) 
        KQP=KCHG(KCP,2)*ISIGN(1,K(NSAV+1,2)) 
        JCON=4 
        IF(KQP.LT.0) JCON=5 
        K(NSAV+1,JCON)=MSTU(5)*(NSAV+2) 
        K(NSAV+2,9-JCON)=MSTU(5)*(NSAV+1) 
        K(NSAV+2,JCON)=MSTU(5)*(NSAV+3) 
        K(NSAV+3,9-JCON)=MSTU(5)*(NSAV+2) 
        MSTJ(92)=NSAV+1 
      ELSEIF(MSTJ(23).GE.1.AND.MMAT.EQ.33) THEN 
        K(NSAV+1,1)=3 
        K(NSAV+3,1)=3 
        K(NSAV+1,4)=MSTU(5)*(NSAV+3) 
        K(NSAV+1,5)=MSTU(5)*(NSAV+3) 
        K(NSAV+3,4)=MSTU(5)*(NSAV+1) 
        K(NSAV+3,5)=MSTU(5)*(NSAV+1) 
        MSTJ(92)=NSAV+1 
c........... 
c  Set up for parton shower evolution in t -> W + b. 
      ELSEIF(MSTJ(27).GE.1.AND.MMAT.EQ.45.AND.ND.EQ.3) THEN 
        K(NSAV+2,1)=3 
        K(NSAV+3,1)=3 
        K(NSAV+2,4)=MSTU(5)*(NSAV+3) 
        K(NSAV+2,5)=MSTU(5)*(NSAV+3) 
        K(NSAV+3,4)=MSTU(5)*(NSAV+2) 
        K(NSAV+3,5)=MSTU(5)*(NSAV+2) 
        MSTJ(92)=NSAV+1 
      ENDIF 
c.......... 
c  Mark decayed particle; special option for B-B~ mixing. 
      IF(K(IP,1).EQ.5) K(IP,1)=15 
      IF(K(IP,1).LE.10) K(IP,1)=11 
      IF(MMIX.EQ.1.AND.MSTJ(26).EQ.2.AND.K(IP,1).EQ.11) K(IP,1)=12 
      K(IP,4)=NSAV+1 
      K(IP,5)=N 

      RETURN 
      END 
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BESEXEC1 
c*********************************************************************** 
c
c  BESEXEC1 = former LUEXEC1
c
c  Purpose: to administrate the fragmentation and decay chain. 
c
c***********************************************************************

      Implicit NONE

      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)       !  jetset v7.4

      Common /LUDAT1/ MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      Integer *4 MSTU,MSTJ
      Real *4 PARU,PARJ

      Common /LUDAT2/ KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      Integer *4 KCHG
      Real *4 PMAS,PARF,VCKM

      Common /LUDAT3/MDCY(500,3),MDME(2000,2),BRAT(2000),KFDP(2000,5)
      Integer *4 MDCY,MDME,KFDP
      Real *4 BRAT
c
c      SAVE /LUJETS/,/LUDAT1/,/LUDAT2/,/LUDAT3/
c
      REAL *4 PS(2,6),Kg1(4000,5),Pg1(4000,5),Vg1(4000,5),QMAX 
      REAL *4 PDEV
      INTEGER *4 ngg,MCONS,NSAV,I,J,MBE,IP,KC,ipg,IP1,MFRAG,LUCHGE
      INTEGER *4 LUCOMP,ntmp,ngp,igk,igg,jgk,ngentry,ip2,ip3,icg
      INTEGER *4 kcok,ksok,kgok 

      SAVE

c..........
C  Initialize and reset. 
      ngg=0
      MSTU(24)=0 
c
      IF(MSTU(12).GE.1) CALL LULIST(0) 
c
      MSTU(31)=MSTU(31)+1 
      MSTU(1)=0 
      MSTU(2)=0 
      MSTU(3)=0 
      IF(MSTU(17).LE.0) MSTU(90)=0 
      MCONS=1 
c...........      
C  Sum up momentum, energy and charge for starting entries. 
      NSAV=N 
c
      DO 110 I=1,2 
c
        DO 100 J=1,6 
          PS(I,J)=0. 
 100    CONTINUE 
c
 110  CONTINUE 
c
      DO 130 I=1,N 
        IF(K(I,1).LE.0.OR.K(I,1).GT.10) GOTO 130 
c
        DO 120 J=1,4 
          PS(1,J)=PS(1,J)+P(I,J) 
  120   CONTINUE 
c
        PS(1,6)=PS(1,6)+LUCHGE(K(I,2)) 
  130 CONTINUE 
c
      PARU(21)=PS(1,4) 
c......... 
C  Prepare system for subsequent fragmentation/decay. 
c
      CALL LUPREP(0) 
c........ 
C  Loop through jet fragmentation and particle decays. 
      MBE=0 
 140  MBE=MBE+1 
      IP=0 
 150  IP=IP+1 
      KC=0 
      IF(K(IP,1).GT.0.AND.K(IP,1).LE.10) KC=LUCOMP(K(IP,2)) 
c
      IF(KC.EQ.0) THEN 
c........... 
c  Particle decay if unstable and allowed. Save long-lived particle 
c  decays until second pass after Bose-Einstein effects. 
c
      ELSEIF(KCHG(KC,2).EQ.0) THEN 
        IF(MSTJ(21).GE.1.AND.MDCY(KC,1).GE.1.AND.(MSTJ(51).LE.0.OR.MBE 
     &  .EQ.2.OR.PMAS(KC,2).GE.PARJ(91).OR.IABS(K(IP,2)).EQ.311)) 
c
     &    CALL BESLUD1(IP,ngg,ipg) 
c...........
c  Decay products may develop a shower. 
        IF(MSTJ(92).GT.0) THEN 
          IP1=MSTJ(92) 
          QMAX=SQRT(MAX(0.,(P(IP1,4)+P(IP1+1,4))**2-(P(IP1,1)+P(IP1+1, 
     &    1))**2-(P(IP1,2)+P(IP1+1,2))**2-(P(IP1,3)+P(IP1+1,3))**2)) 
c
          CALL LUSHOW(IP1,IP1+1,QMAX) 
c
          CALL LUPREP(IP1) 
c
          MSTJ(92)=0 
        ELSEIF(MSTJ(92).LT.0) THEN 
          IP1=-MSTJ(92) 
c
          CALL LUSHOW(IP1,-3,P(IP,5)) 
c
          CALL LUPREP(IP1) 
c
          MSTJ(92)=0 
        END IF 
c...........
c  Jet fragmentation: string or independent fragmentation. 
      ELSEIF(K(IP,1).EQ.1.OR.K(IP,1).EQ.2) THEN 
        MFRAG=MSTJ(1) 
        IF(MFRAG.GE.1.AND.K(IP,1).EQ.1) MFRAG=2 
        IF(MSTJ(21).GE.2.AND.K(IP,1).EQ.2.AND.N.GT.IP) THEN 
          IF(K(IP+1,1).EQ.1.AND.K(IP+1,3).EQ.K(IP,3).AND. 
     &    K(IP,3).GT.0.AND.K(IP,3).LT.IP) THEN 
            IF(KCHG(LUCOMP(K(K(IP,3),2)),2).EQ.0) MFRAG=MIN(1,MFRAG) 
          END IF 
        END IF
c.............
cjc J/psi,psi' decay to rgg/ggg, need to check C&G parity conservation
       if(ngg.ge.1) then 
         ntmp=n
         ngp=0
           igk=0
c
           do igg=1,n
             do jgk=1,5
               kg1(igg,jgk)=k(igg,jgk)
               pg1(igg,jgk)=p(igg,jgk)
               vg1(igg,jgk)=v(igg,jgk)
             enddo
            enddo 
c
          ngentry=0
 154      ngentry=ngentry+1
c
          if(ngentry.gt.1000) then
            write(*,*) '(BESEXEC1):infinit loop for G conservation!'
            return
          endif 
c.........
cjc  reset g string initial value
            n=ntmp
            igk=0
c
            do igg=1,n
             do jgk=1,5
               k(igg,jgk)=kg1(igg,jgk)
               p(igg,jgk)=pg1(igg,jgk)
               v(igg,jgk)=vg1(igg,jgk)
             enddo
           enddo
c
          IF(MFRAG.EQ.1) CALL LUSTRF(IP) 
          IF(MFRAG.EQ.2) CALL LUINDF(IP) 
c
          IF(MFRAG.EQ.2.AND.K(IP,1).EQ.1) MCONS=0 
        IF(MFRAG.EQ.2.AND.(MSTJ(3).LE.0.OR.MOD(MSTJ(3),5).EQ.0)) MCONS=0 
c...........
cjc   check C&G parity conservation        
c
        if((k(ntmp+1,2).gt.80).and.(k(ntmp+1,2).lt.100)) then
             ip1=ipg
             ip2=ntmp+2
             ip3=n
	     icg=1
c
             call BESCGPAR(ip1,ip2,ip3,kcok,ngg,icg)
c
             if(kcok.eq.-1) goto 154
c
             call BESSUPR(ip1,ip2,ip3,ksok)
c
             if(ksok.eq.-1) goto 154
cjc           if(ngg.eq.1) then      ! G conservation in J/psi->ggg
c
           if(ngg.ge.1) then      ! G conservation in J/psi->ggg/rgg
            icg=2
c
	    call BESCGPAR(ip1,ip2,ip3,kgok,ngg,icg)
c
            if(kgok.eq.-1) goto 154
          endif   
c
         else
            write(*,*) 'LUEXEC!:Wrong, no string!'
         endif 
        else
c............
cjc  nomoral fragmentation of string
        IF(MFRAG.EQ.1) CALL LUSTRF(IP) 
c
        IF(MFRAG.EQ.2) CALL LUINDF(IP) 
c
        IF(MFRAG.EQ.2.AND.K(IP,1).EQ.1) MCONS=0 
        IF(MFRAG.EQ.2.AND.(MSTJ(3).LE.0.OR.MOD(MSTJ(3),5).EQ.0)) MCONS=0 
       endif
      ENDIF 
 
C...Loop back if enough space left in LUJETS and no error abort. 
      IF(MSTU(24).NE.0.AND.MSTU(21).GE.2) THEN 
      ELSEIF(IP.LT.N.AND.N.LT.MSTU(4)-20-MSTU(32)) THEN 
        GOTO 150 
      ELSEIF(IP.LT.N) THEN 
c
        CALL LUERRM(11,'(LUEXEC:) no more memory left in LUJETS') 
c
      ENDIF 
 
C...Include simple Bose-Einstein effect parametrization if desired. 
      IF(MBE.EQ.1.AND.MSTJ(51).GE.1) THEN 
c
        CALL LUBOEI(NSAV) 
c
        GOTO 140 
      ENDIF 
c..........
c  Check that momentum, energy and charge were conserved. 
      DO 170 I=1,N 
        IF(K(I,1).LE.0.OR.K(I,1).GT.10) GOTO 170 
c
        DO 160 J=1,4 
          PS(2,J)=PS(2,J)+P(I,J) 
 160    CONTINUE 
c
        PS(2,6)=PS(2,6)+LUCHGE(K(I,2)) 
 170  CONTINUE 
c
      PDEV=(ABS(PS(2,1)-PS(1,1))+ABS(PS(2,2)-PS(1,2))+ABS(PS(2,3)- 
     &PS(1,3))+ABS(PS(2,4)-PS(1,4)))/(1.+ABS(PS(2,4))+ABS(PS(1,4))) 
c
      IF(MCONS.EQ.1.AND.PDEV.GT.PARU(11)) CALL LUERRM(15, 
     &'(LUEXEC:) four-momentum was not conserved') 
c
      IF(MCONS.EQ.1.AND.ABS(PS(2,6)-PS(1,6)).GT.0.1) CALL LUERRM(15, 
     &'(LUEXEC:) charge was not conserved') 
c
      RETURN 
      END 
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BESONIA1(ipp,KFL,ngg) 
*****************************************************************************
*                                                                           *
c
c   BESONIA1 = former LUONIA1 
c
*     Modified from LUONIA.f in the jeset7.4                                * 
*                                                                           *
*     Purpose: to generate onium decays into three                          *
*     gluons or two gluons and a photon.                                    *
*                                                                           *
*     onia-->rgg/ggg in CM system and Lorentz boost to Exp. system          *
*      ipp: onia position in /LUJETS/                                       *
*      KFL: KF of onia                                                      *
*      ngg: 1-decay to ggg, 2-decay to rgg                                  *
*                                 Chen Jiangchuan 1998.5.31                 *
*                                                                           *
*****************************************************************************

      Implicit NONE

      Real *4 P,V
      Integer *4 N,K
      COMMON/LUJETS/ N,K(4000,5),P(4000,5),V(4000,5)       !  jetset v7.4

      Common /LUDAT1/ MSTU(200),PARU(200),MSTJ(200),PARJ(200)
      Integer *4 MSTU,MSTJ
      Real *4 PARU,PARJ

      Common /LUDAT2/ KCHG(500,3),PMAS(500,4),PARF(2000),VCKM(4,4)
      Integer *4 KCHG
      Real *4 PMAS,PARF,VCKM

      REAL *4 PV(5),Ecm,X1,X2,X3,RLU,QF,RGAM,ULALPS,ECMC,SQ2,HF1,HF3
      REAL *4 CT13,ST13,SIGL,SIGU,SIGT,SIGI,SIGMAX,CHI,CTHE,PHI,CCHI
      REAL *4 SCHI,C2CHI,S2CHI,THE,STHE,C2PHI,S2PHI,SIG,dtmp
      REAL *8 dps(5)
      INTEGER *4 NC,KFLC,Irgg,NTRY,NJET,I,ipp,KFL,MK,ngg,IP,J,MSTJ14

c      SAVE /LUJETS/,/LUDAT1/,/LUDAT2/ 

      SAVE

c...parent particle(onium) parameters
      do i=1,5
        pv(i)=p(ipp,i)
        DPS(i)=0D0
      enddo

c...decay in the CM system of onium  now
      Ecm=p(ipp,5)    ! Ecm=mass_onia

C...Printout. Check input parameters. 
cjc      IF(MSTU(12).GE.1) CALL lulist(1) 
c
      IF(KFL.LT.0.OR.KFL.GT.8) THEN 
        CALL LUERRM(16,'(LUONIA:) called with unknown flavour code') 
        IF(MSTU(21).GE.1) RETURN 
      ENDIF 
c
      IF(ECM.LT.PARJ(127)+2.02*PARF(101)) THEN 
        CALL LUERRM(16,'(LUONIA:) called with too small CM energy') 
        IF(MSTU(21).GE.1) RETURN 
      ENDIF 
 
C...Initial e+e- and onium state (optional). 
      NC=N 
      KFLC=IABS(KFL) 
 
C...Choose x1 and x2 according to matrix element. 
      Irgg=0       ! for keeping input B(rgg)/B(ggg)
      NTRY=0 
  100 X1=RLU(0) 
      X2=RLU(0) 
      X3=2.-X1-X2 
      IF(X3.GE.1..OR.((1.-X1)/(X2*X3))**2+((1.-X2)/(X1*X3))**2+ 
     &((1.-X3)/(X1*X2))**2.LE.2.*RLU(0)) GOTO 100 
      NTRY=NTRY+1 
      NJET=3 
      IF(MSTJ(101).LE.4) CALL LU3ENT(NC+1,21,21,21,ECM,X1,X3) 
      IF(MSTJ(101).GE.5) CALL LU3ENT(-(NC+1),21,21,21,ECM,X1,X3) 
 
C...Photon-gluon-gluon events. Small system modifications. Jet origin. 
      MSTU(111)=MSTJ(108) 
      IF(MSTJ(108).EQ.2.AND.(MSTJ(101).EQ.0.OR.MSTJ(101).EQ.1)) 
     &MSTU(111)=1 
      PARU(112)=PARJ(121) 
      IF(MSTU(111).EQ.2) PARU(112)=PARJ(122) 
      QF=0. 
      IF(KFLC.NE.0) QF=KCHG(KFLC,1)/3. 
      RGAM=7.2*QF**2*PARU(101)/ULALPS(ECM**2) 
cjc... correction for b(rgg)/b(ggg)=36/5*eq**2*aem/as(Q)*(1+2.2*as(q)/pi)
      rgam=rgam*(1.+2.2*ULALPS(ECM**2)/3.14159265)   
      MK=0 
      ECMC=ECM 
      ngg=0
      IF((RLU(0).GT.RGAM/(1.+RGAM)).and.(irgg.eq.0)) THEN  !parj(126)=mass_min(gg) (d=2GeV)
cjc      IF(RLU(0).GT.RGAM/(1.+RGAM)) THEN  !parj(126)=mass_min(gg) (d=2GeV)
        IF((1.-MAX(X1,X2,X3)).LE.MAX((PARJ(126)/ECM)**2,PARJ(125))) 
     &  NJET=2 
        IF(NJET.EQ.2.AND.MSTJ(101).LE.4) CALL LU2ENT(NC+1,21,21,ECM) 
        IF(NJET.EQ.2.AND.MSTJ(101).GE.5) CALL LU2ENT(-(NC+1),21,21,ECM) 
        ngg=1       ! decay to ggg
      ELSE 
        MK=1 
        ECMC=SQRT(1.-X1)*ECM 

cjc       IF(ECMC.LT.2.*PARJ(127))  GOTO 100       !2mg>2*parj(127)
       IF(ECMC.LT.2.*PARJ(127)) then
         irgg=1
         GOTO 100       !2mg>2*parj(127)
       endif 

        ngg=2

        K(NC+1,1)=1 
        K(NC+1,2)=22 
        K(NC+1,4)=0 
        K(NC+1,5)=0 
        IF(MSTJ(101).GE.5) K(NC+2,4)=MSTU(5)*(NC+3) 
        IF(MSTJ(101).GE.5) K(NC+2,5)=MSTU(5)*(NC+3) 
        IF(MSTJ(101).GE.5) K(NC+3,4)=MSTU(5)*(NC+2) 
        IF(MSTJ(101).GE.5) K(NC+3,5)=MSTU(5)*(NC+2) 
        NJET=2 
cjc/98.... cancel gg->phsspace
c        IF(ECMC.LT.4.*PARJ(127)) THEN   !parj(127)=mass_min(g)(d=1.0 GeV)
c          MSTU10=MSTU(10)                !phase_space (decay to qq~)
c          MSTU(10)=1 
c          P(NC+2,5)=ECMC 
c          CALL LU1ENT(NC+2,83,0.5*(X2+X3)*ECM,PARU(1),0.) 
c          MSTU(10)=MSTU10 
c          NJET=0 
c        ENDIF 
cjc/98..... 
      ENDIF 
      DO 110 IP=NC+1,N 
      K(IP,3)=IPP+(MSTJ(115)/2)+(KFLC/5)*(MSTJ(115)/3)*(NC-1) 
  110 CONTINUE 
 
C...Differential cross-sections. Upper limit for cross-section. 
      IF(MSTJ(106).EQ.1) THEN 
        SQ2=SQRT(2.) 
        HF1=1.-PARJ(131)*PARJ(132) 
        HF3=PARJ(133)**2 
        CT13=(X1*X3-2.*X1-2.*X3+2.)/(X1*X3) 
cjc...keep st13=/=0.
        if(abs(ct13).ge.1.) goto 100

        ST13=SQRT(1.-CT13**2) 
        SIGL=0.5*X3**2*((1.-X2)**2+(1.-X3)**2)*ST13**2 
        SIGU=(X1*(1.-X1))**2+(X2*(1.-X2))**2+(X3*(1.-X3))**2-SIGL 
        SIGT=0.5*SIGL 
cjc...keep st13=/=0.
	if(abs(st13).lt.0.000001) goto 100
        SIGI=(SIGL*CT13/ST13+0.5*X1*X3*(1.-X2)**2*ST13)/SQ2 
        SIGMAX=(2.*HF1+HF3)*ABS(SIGU)+2.*(HF1+HF3)*ABS(SIGL)+2.*(HF1+ 
     &  2.*HF3)*ABS(SIGT)+2.*SQ2*(HF1+2.*HF3)*ABS(SIGI) 
 
C...Angular orientation of event. 
  120   CHI=PARU(2)*RLU(0) 
        CTHE=2.*RLU(0)-1. 
        PHI=PARU(2)*RLU(0) 
        CCHI=COS(CHI) 
        SCHI=SIN(CHI) 
        C2CHI=COS(2.*CHI) 
        S2CHI=SIN(2.*CHI) 
        THE=ACOS(CTHE) 
        STHE=SIN(THE) 
        C2PHI=COS(2.*(PHI-PARJ(134))) 
        S2PHI=SIN(2.*(PHI-PARJ(134))) 
        SIG=((1.+CTHE**2)*HF1+STHE**2*C2PHI*HF3)*SIGU+2.*(STHE**2*HF1- 
     &  STHE**2*C2PHI*HF3)*SIGL+2.*(STHE**2*C2CHI*HF1+((1.+CTHE**2)* 
     &  C2CHI*C2PHI-2.*CTHE*S2CHI*S2PHI)*HF3)*SIGT-2.*SQ2*(2.*STHE*CTHE* 
     &  CCHI*HF1-2.*STHE*(CTHE*CCHI*C2PHI-SCHI*S2PHI)*HF3)*SIGI 
        IF(SIG.LT.SIGMAX*RLU(0)) GOTO 120 
        CALL LUDBRB(NC+1,N,0.,CHI,0D0,0D0,0D0) 
        CALL LUDBRB(NC+1,N,THE,PHI,0D0,0D0,0D0) 
      ENDIF 

cjc..Lorentz transform decay products(ggg) from onium-Ecm system to lab system 
      dtmp=0.0000001
      if((abs(pv(1)).gt.dtmp).and.(abs(pv(2)).gt.dtmp).and.
     & (abs(pv(3)).gt.dtmp)) then
      DO 130 J=1,5
        DPS(J)=DPS(J)+pv(J)
 130  CONTINUE
      DPS(4)=SQRT(DBLE(Pv(1))**2+DBLE(pv(2))**2+
     &  DBLE(Pv(3))**2+DBLE(Pv(5))**2)
      CALL LUDBRB(NC+1,N,0.,0.,DPS(1)/DPS(4),
     &  DPS(2)/DPS(4),DPS(3)/DPS(4))
      endif

cjc... take onia's vertex position as ggg's vertex position  
      do 150 i=nc+1,n
        do 140 j=1,5
          v(i,j)=v(ipp,j)
140    continue          
150    continue          
      
C...Generate parton shower. Rearrange along strings and check. 
      IF(MSTJ(101).GE.5.AND.NJET.GE.2) THEN 
        CALL LUSHOW(NC+MK+1,-NJET,ECMC) 
       MSTJ14=MSTJ(14) 
        IF(MSTJ(105).EQ.-1) MSTJ(14)=-1 
        IF(MSTJ(105).GE.0) MSTU(28)=0 
        CALL LUPREP(0) 
       MSTJ(14)=MSTJ14 
        IF(MSTJ(105).GE.0.AND.MSTU(28).NE.0) GOTO 100 
      ENDIF 
 
      RETURN 
      END 
c
c-----------------------------------------------------------------------
c
      SUBROUTINE BESSUPR(ip1,ip2,ip3,ksok) 
c*********************************************************************** 
c
c   BESSUPR = former PSUPRESS
c                                                                      *
c   Purpose:(1) Supression particle production(for rho pi puzzle).     *
c    called:  luexec1.f, ludecy1.f                                     *
c   used in:  luexec1.f, ludecy1.f                                     *
c   lgp1(i):  KF of meson which be supressed.                          *
c    pgp(i):  suppress ratio of ith meson.                             *
c                                                                      *
c     input:  ip1, decay meson position in the /LUJETS/;               *
c             ip2-ip3, decayed products position.                      *
c                                                                      *
c    output:  ksok,1: no supress; -1:upress                            *
c                                                                      *
c                                      Chen Jiangchuan  1998.5.31      *
c                                                                      *
c***********************************************************************

      implicit none

      integer ndim,npart
      parameter (ndim=20,npart=4)

      COMMON/LUJETS/N,K(4000,5),P(4000,5),V(4000,5)
      integer N,K,P,V
      integer lgp1(ndim),lgp2(ndim)
      real pgp(ndim)
      integer ksok,ip,ip1,ip2,ip3,i,istatus
      real  rlu

c      save lgp1,pgp

      SAVE

*************************************************************************
c...KF of mesons in the jetset7.4
c               pi+ pi0 eta  eta'  f0    f0'    f1   f1'   f2 f2'  rho+
c     data lgp1/211,111,221, 331, 10221,10331,20223,20333,225,335,213,
c     rho0 omega a0+  a00  a1+   a10   a2+ a20 phi   h1    h1'  h1c
c    &113,223,10211,10111,20213,20113,215,115,333,10223,10333,10443,
c     b1+   b10  etac J/psi xc0  xc1  xc2 psi(2s) upslon upsilon' etab
c    &10213,10113,441, 443,10441,20443,445,30443,  553,  30553, 551,
c     gamma LMD0 XGM- XGM+ XGM0 XGM*0 XGM*- XGM*+ Xi- Xi0  
c    & 22,  3122,3112,3222,3212,3214,3114, 3224,3312,3322,
c      Delta+ Delta- Delta0 Delta++ K+ K0 K*+ K*0  K1+  K10   K0*+ 
c    & 2214,  1114,  2114,  2224, 321,311,323,313,10323,10313,10321,
c      K0*0  K1*+  K1*0   K2*+ K2*0 n0    p+ 
c    &10311,20323,20313, 325, 315,2112,2212,88*0/
c                pi+  rho+ pi0 rho0  
       data lgp1/211, 213, 111, 113, 16*0/ 
c                pi+ rho0 pi0 rho0 
       data lgp2/1,  9,   1,   9, 16*0/ 

c... suppress ratio 
c               pi+ rho0 pi0 rho0
      data  pgp/1., .9, 1.,  .9, 16*0/

***********************************************************************
      ksok=1
      if(k(ip1,2).ne.443.and.k(ip1,2).ne.30443) return
c...find  meson whose decay being supressed  
        istatus=0
c
      if(ip3-ip2.eq.1) then
      do 40 ip=ip2,ip3
        do 30 i=1,npart
          if(abs(k(ip,2)).eq.lgp1(i)) then
            if(rlu(0).lt.pgp(i)) then
                istatus=istatus+lgp2(i)
                goto 32 
            endif
          endif
30    continue
32    continue
40    continue
      endif
c
      if(istatus.eq.10) then 
       ksok=-1
      endif 
c
      return
      end

