C     ***********************************************************
C     *   Генератор космики на основе алгоритма, приведённого в статье  *
C     * Energy calibrations of the NaI(Tl) calorimeter of the   *
C     * SND detector    using cosmic muons                      *
C     * M.N.Achasov, A.D.Bykin, D.A.Bykin, V.D.Druzhinin,       *
C     * V.B.Golubev,V.N.Invanchenko, S.V.Koshuba,               *
C     * S.I.Serednyakov  NIM in Phys Res A 401 (1997) 179-186   *
C     *                                                         *
C     * Реализация: Балдин Е.М. E.M.Baldin@inp.nsk.su              * 
C     *                                                         *
c     * Corrections:                                            *
c     * 19.03.2004. GRNDM -> RLU, V.A.Tayursky                  *
C     * 28.09.2005  аналитическая процедура пересечения с объёмом и   *
C     * правильное определение максимума распределения А.Л. Масленников *
C     *                                                         *
C     ***********************************************************

      SUBROUTINE GEN_COSMICS(IPRTRK)

c     Z в этом генераторе направлена по вертикали как  Y в моделировании
c     X как Z в моделировании (на нас если смотреть слева от пультовой на
c     детектор) и Y как X - внешняя сторона ВЭПП-4М
c     В конце будет перекодировка

c      Доступ к данным mc.cards      
      COMMON /KEDR_GEN/KHEP,KGEN,GENPAR(20) ! input parameters for generators
c      include 'gckine.inc'     ! ikine,pkine(10),...
c      COMMON/GCKINE/IKINE,PKINE(10),ITRA,ISTAK,IVERT,IPART,ITRTYP
c     +      ,NAPART(5),AMASS,CHARGE,TLIFE,VERT(3),PVERT(4),IPAOLD
c     Для внутреннего пользования - оценка загрузки
      COMMON/MYCOSGEN/count,xmin,xmax,ymin,ymax
C NTRACK,IPARTICLE(50),... - for output file
#include "KedrSim/pkin.inc"    
C ..., IEVENT, ... , NEVENT, ...
#include "gcflag.inc"  
C event vertex
#include "KedrSim/ver_event.inc"  
c
      integer IPRTRK            !печать отладочной информации 0/1 
      real grx(7)               !случайное число для theta,p,prob,phi,x,y,mu+/-
c     Минимум и максиму для импульса в Гэвах pmin>=0.5
      real pmin,pmax 
c     Минимум и максимум для theta в радианах (откладывается от вертикали)
      real tmin,tmax
c     Параметры триггерного объёма в сантиметрах
      real Fvol,Bvol,Rvol
c     Параметры объёма детектора  в сантиметрах
      real Fdetect,Bdetect,Rdetect
c     Значения для вычисления p и theta с помощью MC
      real theta,phi,p,prob,prob_max,result
c     Значения для вычисления x,y
      real x,y,xmin,xmax,ymin,ymax,xi,yi,zi
      real ct,st,cp,sp,stcp,stsp,stcp2,diskr,r_lim(3),x_lim(2)
c     Константы взятые из статьи  
      real p0,k,sigma,s1,s2
      real PLAB(3),VERTEX(3)    !импульс и точка возникновения частицы
      integer ITYPE             !тип частицы
      integer NVERT,NT          !Параметры для внутреннего использования
      integer count

c   Инициализация параметров объёма детектора  в сантиметрах
      DATA Fdetect/260./,Bdetect/-260./,Rdetect/300./

c   Инициализация констант взятых из статьи  
      DATA p0/0.5/,k/3.86/,s1/2.86/,s2/1.54/
C      DATA p0/0.5/,k/2.86/,s1/2.86/,s2/1.54/

      count=0
c     Инициализация параметров генератора
      pmin=genpar(1)  !pmin в Гэвах
      pmax=genpar(2) !pmax в Гэвах
      tmin=genpar(3)*3.1415926/180. !tmin в радианах
      tmax=genpar(4)*3.1415926/180. !tmax в радианах
      Bvol=genpar(5) !Bvolume в см
      Fvol=genpar(6) !Fvolume в см
      Rvol=genpar(7) !Rvolume в см
c
c   Проверка на допустимые интервалы
c
      if (pmin<0.5) then     !pmin должен быть больше 0.5 Гэв
         pmin=0.5
         print *,'pmin=pkine(1)<0.5: ',pmin
         print *,'pmin now equal 0.5 '
      endif

      if (tmax>=3.1415926/2.) then !tmax должно быть меньше 90
         tmax=89.*3.1415926/180.
         print *,'tmin=pkine(3)>=90: ',tmin/3.1415926*180.
         print *,'tmax now equal 89 '
      endif
c
c     Проверка на неправильные параметры
c
      if ((tmin.ge.tmax).or.(pmin.ge.pmax).or.(Rvol.le.0).or.
     $     (Fvol.le.Bvol))   then  
c         if (IPRTRK.gt.0) then
         print *,'Something wrong in mc.cards: cosgen warning '
         print *,'tmin (pkine(3)),tmax(pkine(4)),pmin(pkine(1)),',
     $        'pmax(pkine(2)),Rvol(pkine(7)),Fvol(5),Bvol(6) '
         print *,tmin,tmax,pmin,pmax,Rvol,Fvol,Bvol 
c         endif
         return
      endif

c     цикл на отлов удачной частицы в нужном диапазоне p,theta 
c     распределение из статьи MC

      prob_max= !  maximum of 2d distribution over p,theta (see below)
     $   exp(-( (log(pmin/p0)*s2/s1)**2 + (k+1.)*log(k+1.)-k*log(k) )/2.)
c..  exp(-(log(p/p0)/sigma)**2/2.) has max at p=pmin and cos(theta) = 0
c    max ( cos**k * sin) = exp(-( (k+1.)*log(k+1.)-k*log(k) )/2.) at angle = atan(1./sqrt(k))

 10   CONTINUE 

      DO I=1,3
c
        GRX(I)=RLU(0)
c       call grndm(grx,3)
c
      END DO
c
      theta=tmin+(tmax-tmin)*grx(1)
      ct=cos(theta)
      st=sin(theta)
      p=pmin+(pmax-pmin)*grx(2)
      sigma=(s1-ct)/s2
      prob=prob_max*grx(3)
      result=ct**k*st*exp(-(log(p/p0)/sigma)**2/2.)
      count=count+1
      if (prob>result) GOTO 10       ! конец цикла по theta,p
c
	DO I=1,3
c
 	GRX(I)=RLU(0)
c	call grndm(grx,3)
c
 	END DO
c
c     розыгрыш x, y, phi
c
      xmin=Bvol-Rvol*tan(tmax)
      xmax=Fvol+Rvol*tan(tmax)
      x=xmin+(xmax-xmin)*grx(1) !x
      ymax=Rvol/cos(tmax)
      ymin=-ymax
      y=ymin+(ymax-ymin)*grx(2) !y
      phi=2*3.1415926*grx(3)    !phi
      cp=cos(phi)
      sp=sin(phi)
      stcp=st*cp
      stsp=st*sp
      stcp2=1.-stcp**2
      
c
c     Проверка на попадание в объём
c     Предполагаем, что триггерная область цилиндр
c     (Fvol-Bvol)- длина (по X), Rvol- радиус
c

c..  Equation (y+t*stsp)**2 + (0+t*ct)**2 = Rvol**2
      diskr= Rvol**2*stcp2 - (y*ct)**2
      if (diskr < 0.) goto 10   ! does not cross cylinder at all, Не попали
      r_lim(3)= -y*stsp/stcp2   ! auxillary
      diskr= sqrt(diskr)/stcp2
      r_lim(1)= r_lim(3)-diskr  ! solution t_min
      r_lim(2)= r_lim(3)+diskr  ! solution t_max

c..  Equations Bvol=x+t*stcp, Fvol=x+t*stcp
      if(stcp>0.) then
         x_lim(1)=(Bvol-x)/stcp
         x_lim(2)=(Fvol-x)/stcp
      elseif(stcp<0.) then
         x_lim(1)=(Fvol-x)/stcp
         x_lim(2)=(Bvol-x)/stcp
      else                      ! does not cross sides Bvol, Fvol at all -> OK
         x_lim(1)=-9999.
         x_lim(2)= 9999.
      endif

      if (r_lim(2).le.x_lim(1) .or. r_lim(1).ge.x_lim(2)) goto 10   ! Не попали
 30   continue                  !попали

c
      GRX(1)=RLU(0)     
c      call grndm(grx,1)     ! error?
c
c     Выбор между mu+ и mu- - из статьи
c
      if (grx(1)<1./(2.+0.35*exp(-0.22*log(p/7)**2))) then 
         ITYPE=6                ! mu-
      else
         ITYPE=5                ! mu+
      endif
c
c      if (IPRTRK>0) then
c         print *,'p=',p,' theta=',theta*180./3.14159,' phi=',
c     $        phi*180./3.14159
c         print *,'x=',x,' y=',y,' ITYPE=',ITYPE,' count=',count
c      endif

c
c     Формируем точку запуска - выходим за пределы детектора

c..  Equation (y+t*stsp)**2 + (0+t*ct)**2 = Rdet**2
      diskr= Rdetect**2*stcp2 - (y*ct)**2  ! >0, because crosses even smaller cylinder
      diskr= sqrt(diskr)/stcp2
c$$$      r_lim(1)= r_lim(3)-diskr  ! solution t_min, not used
      r_lim(2)= r_lim(3)+diskr  ! solution t_max

c..  Equations Bdetect=x+t*stcp, Fdetect=x+t*stcp
      if(stcp>0.) then
c$$$         x_lim(1)=(Bdetect-x)/stcp ! not used
         x_lim(2)=(Fdetect-x)/stcp
      elseif(stcp<0.) then
c$$$         x_lim(1)=(Fdetect-x)/stcp ! not used
         x_lim(2)=(Bdetect-x)/stcp
      else               ! does not cross sides Bdetect, Fdetect at all -> OK
c$$$         x_lim(1)=-9999. ! not used
         x_lim(2)= 9999.
      endif

c...  r_lim(3) = min of r_lim(2), x_lim(2)
      if (r_lim(2).le.x_lim(2)) then
         r_lim(3) = r_lim(2)
      else
         r_lim(3) = x_lim(2)
      endif
c
 100  continue                  ! Формировка непосредственно точки запуска
      xi=x+r_lim(3)*stcp   !  r_lim(3) = min of r_lim(2), x_lim(2)
      yi=y+r_lim(3)*stsp
      zi=r_lim(3)*ct
c$$$      if (r_lim(3).lt.0.) then ! check
c$$$        print '(A,4(1X,F9.4))',
c$$$     + 'cosgen -> r_lim(3)<0 for x,y,theta,phi= ',
c$$$     +  x,y,theta,phi
c$$$        print *,' R_lim= ',R_lim(1),R_lim(2),R_lim(3)
c$$$        print *,' X_lim= ',X_lim(1),X_lim(2),'   count= ',count
c$$$        print *,' xi,yi,zi= ',xi,yi,zi
c$$$      endif
      VERTEX(1)=yi              ! y->x
      VERTEX(2)=zi              ! z->y
      VERTEX(3)=xi              ! x->z
      VRTX(1)=VERTEX(1)
      VRTX(2)=VERTEX(2)
      VRTX(3)=VERTEX(3)
      PLAB(1)=-p*stsp           ! y->x
      PLAB(2)=-p*ct             ! z->y
      PLAB(3)=-p*stcp           ! x->z
c
c     То что ставится в моделировании для инициализации трека
c
      CALL GSVERT(VERTEX,0,0,0,0,NVERT)
c
      CALL GSKINE(PLAB,ITYPE,NVERT,0,0,NT)
c
      CALL GFPART(ITYPE,NAMPART,ITRTYPE,APMASS,PCHARGE,PTLIFE,UB,NWB)
c
      IF(IPRTRK.EQ.1)  PRINT 397,IEVENT,1,ITYPE,PLAB,VERTEX
c                                    
      NTRACK=1
      IPARTICLE(1)=ITYPE
      EPART(1)=SQRT(P**2+APMASS**2)
      PXPART(1)=PLAB(1)
      PYPART(1)=PLAB(2)
      PZPART(1)=PLAB(3)                               
c                                                                    
397   FORMAT(I5,2I4,3F10.6,3F10.4)
      END
