c
c I'd kill author of routines with names like "lambda", "ro",
c (see below).
c                                 D.A.Bukin


C*************************************************************
C    Set of functions to determine f0 and a0 widths.
C          from N.N.Achasov, V.N.Ivanchenko
C        Nuclear Physics B315 (1989) 465-476
C              2.04.97  Berdugin Al.
C*************************************************************
C
       real*8 function wdphiee(mphi)
C*************************************************************
C      The width of Phi->e+e- decay
C            Berdugin Al.
C*************************************************************
       implicit none
       include 'fitdata.inc'
       real *8 MPhi
       logical KLU/.true./
       save KLU
       if(KLU)then
         KLU=.false.
         call IniFit
       end if
       if(MPhi.le.1.022D0)then
         WdPhiEe=0.D0
         return
       end if
       WdPhiEe=GPhi*BrPhiEe*(MsPhi/MPhi)**3
       return
       END
C
       REAL*8 FUNCTION WdPhiF0G(MF0,MPhi)
C*************************************************************
C      The width of Phi -> f0 gamma decay
C            Berdugin Al.
C*************************************************************
       implicit none
       real *8 MF0,MPhi,const
       complex *16 gR980
       logical KLU/.true./
       save KLU,const
       if(KLU)then
         KLU=.false.
         const=1.D0/(24.D0*3.1415926D0)
       end if
       if(MPhi.le.MF0)then
         WdPhiF0G=0.D0
         return
       end if
       WdPhiF0G=const*(abs(gR980(MF0,MPhi,'F0')))**2*
     #             (1.D0-(MF0/MPhi)**2)/MPhi
       return
       END


       REAL*8 FUNCTION WdPhiA0G(MA0,MPhi)
C*************************************************************
C      The width of Phi -> a0 gamma decay
C            Berdugin Al.
C*************************************************************
       implicit none
       real *8 MA0,MPhi,const
       complex *16 gR980
       logical KLU/.true./
       save KLU,const
       if(KLU)then
         KLU=.false.
         const=1.D0/(24.D0*3.1415926D0)
       end if
       if(MPhi.le.MA0)then
         WdPhiA0G=0.D0
         return
       end if
       WdPhiA0G=const*(abs(gR980(MA0,MPhi,'A0')))**2*
     #             (1.D0-(MA0/MPhi)**2)/MPhi
       return
       END


       COMPLEX *16 FUNCTION gR980(MR,MPhi,Res)
C*************************************************************
C         Berdugin Al.
C*************************************************************
       implicit none
       include 'fitdata.inc'
       include 'a0f0data.inc'
       real *8 WdPhi2Kc,gPhi2Kc,MR,MPhi,const,const0
       real *8 RMR2,atRMR,LRMR,RMR
       complex *16 ci,RMPhi,LMPhi,Ro,Lambda
       character *2 Res
       logical KLU/.true./
       save KLU,ci,const0
       if(KLU)then
         KLU=.false.
         call IniFit
         call AFcnst
         ci=(0.D0,1.D0)
         const0=sqrt(4.D0*Pi*Alpha)/(8.D0*Pi**2)
       end if
       RMPhi=Ro(MPhi)
       LMPhi=Lambda(MPhi)       
       gPhi2Kc=sqrt(48.D0*Pi*WdPhi2Kc(MsPhi)/(MsPhi*(Ro(MsPhi))**3))
       if(Res.EQ.'F0') const=const0*gPhi2Kc*gF0KcKc
       if(Res.EQ.'A0') const=const0*gPhi2Kc*gA0KcKc
       RMR2 = 1.D0-(2.D0*MsKc/MR)**2
       if(RMR2.LT.0.D0)then
         RMR=sqrt(-RMR2)
         atRMR=atan(1.D0/RMR)
         gR980=const*( 1.D0+(1.D0-RMR2)/(RMPhi**2-RMR2)*
     #     ( 2.D0*RMR*atRMR-RMPhi*LMPhi+ci*Pi*RMPhi-
     #       (1.D0-RMPhi**2)*(0.25D0*(Pi+ci*LMPhi)**2-atRMR**2) ) )
       else
         RMR=sqrt(RMR2)
         LRMR=log((1.D0+RMR)/(1.D0-RMR))
         gR980=const*(1.D0+(1.D0-RMR2)/(RMPhi**2-RMR2)*
     #     ( RMR*(LRMR-ci*Pi)-RMPhi*(LMPhi-ci*Pi)-
     #       0.25D0*(1.D0-RMPhi**2)*((Pi+ci*LMPhi)**2-(Pi+ci*LRMR)**2) ) )
       end if
       return
       END


       COMPLEX *16 FUNCTION Ro(m)
C*************************************************************
C         Berdugin Al.
C*************************************************************
       implicit none
       include 'fitdata.inc'
       real *8 m
       logical KLU/.true./
       save KLU
       if(KLU)then
         KLU=.false.
         call IniFit
       end if
       Ro=dcmplx(1.D0-4.D0*(MsKc/m)**2,0.D0)
       Ro=sqrt(Ro)
       return
       END
C
       COMPLEX *16 FUNCTION Lambda(m)
C*************************************************************
C         Berdugin Al.
C*************************************************************
       implicit none
       real *8 m
       complex *16 Ro
       Lambda=Ro(m)
       Lambda=log((1.D0+Lambda)/(1.D0-Lambda))
       return
       END
C
       REAL*8 FUNCTION WdF02Pi0(MF0)
C*************************************************************
C      The width of f0 -> 2pi0 decay
C            Berdugin Al.
C*************************************************************
       implicit none
       include 'fitdata.inc'
       include 'a0f0data.inc'
       real *8 MF0,Mplus
       logical KLU/.true./
       save KLU,Mplus
       if(KLU)then
         KLU=.false.
         call IniFit
         call AFcnst
         Mplus=2.D0*MsPi0
       end if
       if(MF0.le.Mplus)then
         WdF02Pi0=0.D0
         return
       end if
       WdF02Pi0=gF02Pi0**2*sqrt(1.D0-(Mplus/MF0)**2)/(16.D0*Pi*MF0)
       return
       END
C
       REAL*8 FUNCTION WdA0EtaPi(MA0)
C*************************************************************
C      The width of a0 -> pi0 eta decay
C            Berdugin Al.
C*************************************************************
       implicit none
       include 'fitdata.inc'
       include 'a0f0data.inc'
       real *8 MA0,Mplus,Mminus
       logical KLU/.true./
       save KLU,Mplus,Mminus
       if(KLU)then
         KLU=.false.
         call IniFit
         call AFcnst
         Mplus=MsEta+MsPi0
         Mminus=MsEta-MsPi0
       end if
       if(MA0.le.Mplus)then
         WdA0EtaPi=0.D0
         return
       end if
       WdA0EtaPi=gA0EtaPi**2*sqrt((1.D0-(Mplus/MA0)**2)*
     #            (1.D0-(Mminus/MA0)**2))/(16.D0*Pi*MA0)
       return
       END
C
       COMPLEX*16 FUNCTION DpF0(m)
C********************************************************************
C         propagator of f0(980)
C            Berdugin Al.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       real *8 m
       complex *16 PR
       logical KLU/.true./
       save KLU
       if(KLU)then
         KLU=.false.
         call IniFit
       end if
c..... note that using REAL on CPLX*16 is ambiguous/forbidden (Korol)
       DpF0=MsF0**2-m**2+DBLE(PR(MsF0,'F0'))-PR(m,'F0')
       return
       END

       COMPLEX*16 FUNCTION DpA0(m)
C********************************************************************
C         propagator of a0(982.4)
C            Berdugin Al.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       real *8 m
       complex *16 PR
       logical KLU/.true./
       save KLU
       if(KLU)then
         KLU=.false.
         call IniFit
       end if
c..... note that using REAL on CPLX*16 is ambiguous/forbidden (Korol)
       DpA0=MsA0**2-m**2+DBLE(PR(MsA0,'A0'))-PR(m,'A0')
       return
       END


       COMPLEX *16 FUNCTION PR(m,Res)
       implicit none
       include 'fitdata.inc'
       include 'a0f0data.inc'
       real *8 m,const
       complex *16 PRab
       character *2 Res
       logical KLU/.true./
       save KLU,const
       if(KLU)then
         KLU=.false.
         call IniFit
         call AFcnst
         const=1.D0/(16.D0*Pi)
       end if
       if(Res.EQ.'F0')then
         PR=const*(3.D0*gF02PI0**2*PRab(m,MsPi0,MsPi0)+
     #              gF02Eta**2*PRab(m,MsEta,MsEta)+
     #              gF0EtaEtap**2*PRab(m,MsEtap,MsEta)+
     #              gF02Etap**2*PRab(m,MsEtap,MsEtap)+
     #              gF0KcKc**2*PRab(m,MsKc,MsKc)+
     #              gF0KcKc**2*PRab(m,MsKs,MsKs))
       else
         PR=const*(gA0EtaPi**2*PRab(m,MsEta,MsPi0)+
     #             gA0EtapPi**2*PRab(m,MsEtap,MsPi0)+
     #             gA0KcKc**2*PRab(m,MsKc,MsKc)+
     #             gA0KcKc**2*PRab(m,MsKs,MsKs))
       end if
       return
       END
C
       COMPLEX *16 FUNCTION PRab(m,ma,mb)
       implicit none
       real *8 m,ma,mb,mab,mplus,mminus,Pi
       complex *16 ci
       logical KLU/.true./
       save KLU,ci,Pi
       if(KLU)then
         KLU=.false.
         ci=(0.D0,1.D0)
         Pi=3.1415926D0
       end if
       mplus=ma+mb
       mminus=abs(ma-mb)
       if(mb.le.ma)then
         mab=mb/ma
       else
         mab=ma/mb
       end if
       if(m.lt.mminus)then
         PRab=mplus*mminus*log(mab)/(Pi*m**2)-
     #    sqrt(((mplus/m)**2-1.D0)*((mminus/m)**2-1.D0))*
     #    log((sqrt(mplus**2-m**2)-sqrt(mminus**2-m**2))/
     #    (sqrt(mplus**2-m**2)+sqrt(mminus**2-m**2)))/Pi
       else if(m.ge.mminus.and.m.le.mplus)then
         PRab=mplus*mminus*log(mab)/(Pi*m**2)-
     #    sqrt(((mplus/m)**2-1.D0)*(1.D0-(mminus/m)**2))*
     #      (1.D0-2.D0*atan(sqrt((mplus**2-m**2)/
     #            (m**2-mminus**2)))/Pi)
       else
         PRab=mplus*mminus*log(mab)/(Pi*m**2)+
     #    sqrt((1.D0-(mplus/m)**2)*(1.D0-(mminus/m)**2))*
     #  (ci+log((sqrt(m**2-mminus**2)-sqrt(m**2-mplus**2))/
     #    (sqrt(m**2-mminus**2)+sqrt(m**2-mplus**2)))/Pi)
       end if
       return
       END
C
       REAL*8 FUNCTION WddPhiF02Pi0G(MF0,MPhi)
C*************************************************************
C             The difference width
C     of Phi -> f0 gamma -> 2pi0 gamma decay
C               Berdugin Al.
C*************************************************************
       implicit none
       real *8 MF0,MPhi,WdPhiF0G,WdF02Pi0,Pi
       complex *16 DpF0
       logical KLU/.true./
       save KLU,Pi
       if(KLU)then
         KLU=.false.
         Pi=3.1415926D0
       end if
       WddPhiF02Pi0G=2.D0*MF0**2*WdF02Pi0(MF0)*
     #        WdPhiF0G(MF0,MPhi)/(Pi*(abs(DpF0(MF0)))**2)
       return
       END
C

       real*8 function wddphia0etapig(ma0,mphi)
C*************************************************************
C             The difference width
C     of Phi -> a0 gamma -> eta pi0 gamma decay
C               Berdugin Al.
C*************************************************************
       implicit none
       real *8 MA0,MPhi,WdPhiA0G,WdA0EtaPi,Pi
       complex *16 DpA0
       logical KLU/.true./
       save KLU,Pi
       if(KLU)then
         KLU=.false.
         Pi=3.1415926D0
       end if
       WddPhiA0EtaPiG=2.D0*MA0**2*WdA0EtaPi(MA0)*
     #        WdPhiA0G(MA0,MPhi)/(Pi*(abs(DpA0(MA0)))**2)
       return
       END


       real*8 function wdphif02pi0g(mphi)
C*************************************************************
C  The width of Phi -> f0 gamma -> 2pi0 gamma decay
C               Berdugin Al.
C*************************************************************
       implicit none
       include 'fitdata.inc'
       common/masPhi/mas
       external GPhiF0
       real *8 MPhi,Mmin,mas,res
       logical KLU/.true./
       save KLU,Mmin
       if(KLU)then
         KLU=.false.
         call IniFit
         Mmin=2.D0*MsPi0
       end if
       mas=MPhi
       call simps1(res,Mmin,MPhi,GPhiF0,1.D-13)
       WdPhiF02Pi0G=res
       return
       end


       subroutine gphif0(f,x)
C*************************************************************
C         Berdugin Al.
C*************************************************************
       implicit none
       common/masPhi/mas
       real *8 f,x,mas,WddPhiF02Pi0G
       f=WddPhiF02Pi0G(x,mas)
       return
       END
C
       REAL*8 FUNCTION WdPhiA0EtaPiG(MPhi)
C*************************************************************
C  The width of Phi -> a0 gamma -> eta pi0 gamma decay
C               Berdugin Al.
C*************************************************************
       implicit none
       include 'fitdata.inc'
       common/masPhi/mas
       external GPhiA0
       real *8 MPhi,Mmin,mas
       logical KLU/.true./
       save KLU,Mmin
       if(KLU)then
         KLU=.false.
         call IniFit
         Mmin=MsEta+MsPi0
       end if
       mas=MPhi
       call simps1(WdPhiA0EtaPiG,Mmin,MPhi,GPhiA0,1.D-13)
       return
       END
C
       SUBROUTINE GPhiA0(f,x)
C*************************************************************
C         Berdugin Al.
C*************************************************************
       implicit none
       common/masPhi/mas
       real *8 f,x,mas,WddPhiA0EtaPiG
       f=WddPhiA0EtaPiG(x,mas)
       return
       END
