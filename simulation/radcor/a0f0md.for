C********************************************************************
       SUBROUTINE a0f0md(Modul,Model)
C********************************************************************
C    Inicialisation of parameters for calculation
C          Phi -> a0 gamma -> eta pi0 gamma,
C       Phi -> f0 gamma -> pi0 pi0 gamma decays
C  Parameters are stored in /gR980a/ and described in a0f0data.inc
C                         Al.Berdugin
C     13.04.98 V.Ivanchenko add SantiS model 
C     08.06.98 V.Ivanchenko add call to INIFIT
C********************************************************************
C
       implicit none	
       include 'fitdata.inc'
       include 'a0f0data.inc'
       character *6 Modul
       character *(*) Model

       call inifit

       if(Model.eq.'2quark'.or.Model.eq.'2QUARK')then
         gA0KcKc=sqrt(9.2D6*3.1415926D0)
         gA0EtaPi=1.6D0*gA0KcKc
         gA0EtapPi=1.2D0*gA0KcKc
         gF0KcKc=gA0KcKc
         gF02Pi=sqrt(1.D0/12.D0)*gF0KcKc
         gF02Pi0=sqrt(0.5)*gF02Pi
         gF02Eta=0.91D0*gF0KcKc
         gF0EtaEtap=0.96*gF0KcKc
         gF02Etap=0.51*gF0KcKc
         print 1,Modul
1        format(2x,'*** ',A6,' *** model f0(a0) -  2quark')
       else if(Model.eq.'4quark'.or.Model.eq.'4QUARK')then
         gF0KcKc=sqrt(9.2D6*3.1415926D0)
         gF02Pi=sqrt(1.D0/12.D0)*gF0KcKc
         gF02Pi0=sqrt(0.5)*gF02Pi
         gF02Eta=0.96D0*gF0KcKc
         gF0EtaEtap=-0.4D0*gF0KcKc
         gF02Etap=-gF02Eta
         gA0KcKc=-gF0KcKc
         gA0EtaPi=0.85*gA0KcKc
         gA0EtapPi=-1.13D0*gA0KcKc
         print 2,Modul
2        format(2x,'*** ',A6,' *** model f0(a0) - 4quark')
       else if(Model.eq.'f0_SND97'.or.Model.eq.'F0_SND97')then
         gF0KcKc=sqrt(9.2D6*3.1415926D0)
         gF02Pi=sqrt(1.6D6*3.1415926D0)
         gF02Pi0=sqrt(0.5)*gF02Pi
         gF02Eta=0.96D0*gF0KcKc
         gF0EtaEtap=-0.4D0*gF0KcKc
         gF02Etap=-gF02Eta
         gA0KcKc=-gF0KcKc
         gA0EtaPi=0.85*gA0KcKc
         gA0EtapPi=-1.13D0*gA0KcKc
         print 3,Modul
3        format(2x,'*** ',A6,' *** model f0 - 4quark',/,
     #          7x,'with parameters f0-meson receive from fit SND datas')
       else if(Model.eq.'f0_SND98'.or.Model.eq.'F0_SND98')then
         gF0KcKc=sqrt(4.D0*1.73D6*3.1415926D0)
         gF02Pi=sqrt(4.D0*0.52D6*3.1415926D0)
         gF02Pi0=sqrt(0.5)*gF02Pi
         gF02Eta=0.96D0*gF0KcKc
         gF0EtaEtap=-0.4D0*gF0KcKc
         gF02Etap=-gF02Eta
         gA0KcKc=-gF0KcKc
         gA0EtaPi=0.85*gA0KcKc
         gA0EtapPi=-1.13D0*gA0KcKc
         MsF0=974.1D0
         print 6,Modul
6        format(2x,'*** ',A6,' *** model f0 - 4quark',/,
     #          7x,'with parameters f0-meson from fit SND data 10.05.98')
       else if(Model.eq.'F0_SND98N')then
         gF0KcKc=sqrt(4.D0*2.1D6*3.1415926D0)
         gF02Pi=sqrt(4.D0*0.51D6*3.1415926D0)
         gF02Pi0=sqrt(0.5)*gF02Pi
         gF02Eta=0.96D0*gF0KcKc
         gF0EtaEtap=-0.4D0*gF0KcKc
         gF02Etap=-gF02Eta
         gA0KcKc=-gF0KcKc
         gA0EtaPi=0.85*gA0KcKc
         gA0EtapPi=-1.13D0*gA0KcKc
         MsF0=970.6D0
         print 6,Modul
60        format(2x,'*** ',A6,' *** model f0 - 4quark',/,
     #          7x,'with parameters f0-meson from fit SND data 04.06.98')
       else if(Model.eq.'2quarks'.or.Model.eq.'2QUARKS')then
         gF0KcKc=sqrt(18.4D6*3.1415926D0)
         gF02Pi=sqrt(1.D0/12.D0)*gF0KcKc
         gF02Pi0=sqrt(0.5)*gF02Pi
         gF02Eta=0.51D0*gF0KcKc
         gF0EtaEtap=-0.96D0*gF0KcKc
         gF02Etap=0.91D0*gF02Eta
         gA0KcKc=sqrt(9.2D6*3.1415926D0)
         gA0EtaPi=1.6D0*gA0KcKc
         gA0EtapPi=1.2D0*gA0KcKc
         print 5,Modul
5        format(2x,'*** ',A6,' *** model f0(a0) - 2quark SantiS')
       else
         print 4,Modul,Model
4        format(2x,'*** ',A6,' *** model f0(a0) : ',A8,
     #      'not found, model - 2quark')
       end if
       return
       END
