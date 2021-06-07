c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to a1\pi \to 2\pi^+2\pi^-
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c    author Viacheslav Shary (based on the Alexey Berdyugin subprogram) 
c
c                   November'99
c
c=============================================================================

      SUBROUTINE A1_PI4c(ME2,Ja1)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 ta1(3),Ja1(3)

      integer i

c==============================================================================

       call a1p1(p1,p2,p3,p4,Ja1)

       call a1p1(p1,p4,p3,p2,ta1)
       do i=1,3
         Ja1(i)=Ja1(i)+ta1(i)
       end do

       call a1p1(p2,p1,p3,p4,ta1)
       do  i=1,3
        Ja1(i)=Ja1(i)+ta1(i)
       end do

       call a1p1(p2,p4,p3,p1,ta1)
       do  i=1,3
         Ja1(i)=Ja1(i)+ta1(i)
       end do

       call a1p1(p1,p2,p4,p3,ta1)
       do i=1,3
         Ja1(i)=Ja1(i)+ta1(i)
       end do

       call a1p1(p1,p3,p4,p2,ta1)
       do  i=1,3
         Ja1(i)=Ja1(i)+ta1(i)
       end do

       call a1p1(p2,p1,p4,p3,ta1)
       do  i=1,3
         Ja1(i)=Ja1(i)+ta1(i)
       end do

       call a1p1(p2,p3,p4,p1,ta1)
       do  i=1,3
         Ja1(i)=Ja1(i)+ta1(i)
       end do
         

         ME2 = (abs(Ja1(1)))**2 + (abs(Ja1(2)))**2
       
       RETURN
       END


c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to a1\pi \to \sigma\pi \to 2\pi^+2\pi^-
c  using formulas from the preprint BINP 99-56 (CMD2 collaborations)     
c
c    author Viacheslav Shary (based on the Alexey Berdyugin subprogram) 
c
c                   April'00
c
c=============================================================================

      SUBROUTINE A1S_PI4c(ME2,Ja1s)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 ta1s(3),Ja1s(3)

      integer i

c==============================================================================

       call a1sp1(p1,p2,p3,p4,Ja1s)

       call a1sp1(p1,p4,p3,p2,ta1s)
       do i=1,3
         Ja1s(i)=Ja1s(i)-ta1s(i)
       end do

       call a1sp1(p2,p1,p3,p4,ta1s)
       do  i=1,3
        Ja1s(i)=Ja1s(i)+ta1s(i)
       end do

       call a1sp1(p2,p4,p3,p1,ta1s)
       do  i=1,3
         Ja1s(i)=Ja1s(i)-ta1s(i)
       end do

       call a1sp1(p1,p2,p4,p3,ta1s)
       do i=1,3
         Ja1s(i)=Ja1s(i)+ta1s(i)
       end do

       call a1sp1(p1,p3,p4,p2,ta1s)
       do  i=1,3
         Ja1s(i)=Ja1s(i)-ta1s(i)
       end do

       call a1sp1(p2,p1,p4,p3,ta1s)
       do  i=1,3
         Ja1s(i)=Ja1s(i)+ta1s(i)
       end do

       call a1sp1(p2,p3,p4,p1,ta1s)
       do  i=1,3
         Ja1s(i)=Ja1s(i)-ta1s(i)
       end do
         

         ME2 = (abs(Ja1s(1)))**2 + (abs(Ja1s(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to \pi(1300)\pi \to 2\pi^+2\pi^-
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c               author Viacheslav Shary
c
c                   February'00
c
c=============================================================================

      SUBROUTINE Pi_PI4c(ME2,Jp)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 tp(3),Jp(3)

      integer i

c==============================================================================

       call pp1(p1,p2,p3,p4,Jp)

       call pp1(p2,p1,p3,p4,tp)
       do  i=1,3
        Jp(i)=Jp(i)+tp(i)
       end do
       
       call pp1(p1,p2,p4,p3,tp)
       do  i=1,3
        Jp(i)=Jp(i)+tp(i)
       end do

       call pp1(p2,p1,p4,p3,tp)
       do  i=1,3
        Jp(i)=Jp(i)+tp(i)
       end do

       call pp1(p3,p2,p1,p4,tp)
       do  i=1,3
        Jp(i)=Jp(i)+tp(i)
       end do

       call pp1(p4,p2,p1,p3,tp)
       do  i=1,3
        Jp(i)=Jp(i)+tp(i)
       end do

       call pp1(p3,p1,p2,p4,tp)
       do  i=1,3
        Jp(i)=Jp(i)+tp(i)
       end do

       call pp1(p4,p1,p2,p3,tp)
       do  i=1,3
        Jp(i)=Jp(i)+tp(i)
       end do


         ME2 = (abs(Jp(1)))**2 + (abs(Jp(2)))**2
       
       RETURN
       END


c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to \sigma\pi \to 2\pi^+2\pi^-
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c             author Viacheslav Shary 
c
c                   February'00
c
c=============================================================================

      SUBROUTINE Sigma_PI4c(ME2,Jsig)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 tsig(3),Jsig(3)

      integer i

c==============================================================================

       call sigp1(p1,p2,p3,p4,Jsig)

       call sigp1(p2,p1,p3,p4,tsig)
       do  i=1,3
        Jsig(i)=Jsig(i)+tsig(i)
       end do
       
       call sigp1(p1,p2,p4,p3,tsig)
       do  i=1,3
        Jsig(i)=Jsig(i)+tsig(i)
       end do

       call sigp1(p2,p1,p4,p3,tsig)
       do  i=1,3
        Jsig(i)=Jsig(i)+tsig(i)
       end do


         ME2 = (abs(Jsig(1)))**2 + (abs(Jsig(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to a2\pi \to 2\pi^+2\pi^-
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c             author Viacheslav Shary 
c
c                   February'99
c
c=============================================================================
       
       SUBROUTINE A2_PI4c(ME2,Ja2)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 ta2(3),Ja2(3)

      integer i

c==============================================================================

       call a2p1(p1,p2,p3,p4,Ja2)

       call a2p1(p1,p4,p3,p2,ta2)
       do i=1,3
         Ja2(i)=Ja2(i)+ta2(i)
       end do

       call a2p1(p2,p1,p3,p4,ta2)
       do  i=1,3
        Ja2(i)=Ja2(i)+ta2(i)
       end do

       call a2p1(p2,p4,p3,p1,ta2)
       do  i=1,3
         Ja2(i)=Ja2(i)+ta2(i)
       end do

       call a2p1(p1,p2,p4,p3,ta2)
       do i=1,3
         Ja2(i)=Ja2(i)+ta2(i)
       end do

       call a2p1(p1,p3,p4,p2,ta2)
       do  i=1,3
         Ja2(i)=Ja2(i)+ta2(i)
       end do

       call a2p1(p2,p1,p4,p3,ta2)
       do  i=1,3
         Ja2(i)=Ja2(i)+ta2(i)
       end do

       call a2p1(p2,p3,p4,p1,ta2)
       do  i=1,3
         Ja2(i)=Ja2(i)+ta2(i)
       end do
         

         ME2 = (abs(Ja2(1)))**2 + (abs(Ja2(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to a1\pi \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c    author Viacheslav Shary (based on the Alexey Berdyugin subprogram) 
c
c                   December'99
c
c=============================================================================

       SUBROUTINE A1_PI4N(ME2,Ja1)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 ta1(3),Ja1(3)

      integer i

c==============================================================================

       call a1p1(p1,p2,p3,p4,Ja1)

       call a1p1(p4,p2,p3,p1,ta1)
       do i=1,3
         Ja1(i)=Ja1(i)-ta1(i)
       end do
       
       call a1p1(p1,p3,p2,p4,ta1)
       do i=1,3
         Ja1(i)=Ja1(i)+ta1(i)
       end do
       
       call a1p1(p4,p3,p2,p1,ta1)
       do i=1,3
         Ja1(i)=Ja1(i)-ta1(i)
       end do
       
       ME2 = (abs(Ja1(1)))**2 + (abs(Ja1(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to a1\pi \to \sigma\pi\pi \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 99-56 (CMD2 collaborations)     
c
c    author Viacheslav Shary (based on the Alexey Berdyugin subprogram) 
c
c                   December'99
c
c=============================================================================

       SUBROUTINE A1S_PI4N(ME2,Ja1s)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 ta1s(3),Ja1s(3)

      integer i

c==============================================================================

      call a1sp1(p2,p1,p3,p4,Ja1s)

      call a1sp1(p2,p4,p3,p1,ta1s)
      do i=1,3
        Ja1s(i)=Ja1s(i)-ta1s(i)
      end do
       
      ME2 = (abs(Ja1s(1)))**2 + (abs(Ja1s(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to h1\pi \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c               author Viacheslav Shary 
c
c                    February'00
c
c=============================================================================

       SUBROUTINE H1_PI4N(ME2,Jh1)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 th1(3),Jh1(3)

      integer i

c==============================================================================

      call h1p1(p1,p4,p3,p2,Jh1)

      call h1p1(p4,p1,p3,p2,th1)
      do i=1,3
        Jh1(i)=Jh1(i)-th1(i)
      end do
      
      call h1p1(p1,p3,p4,p2,th1)
      do i=1,3
        Jh1(i)=Jh1(i)-th1(i)
      end do
      
      
      call h1p1(p1,p4,p2,p3,Jh1)
      do i=1,3
        Jh1(i)=Jh1(i)+th1(i)
      end do

      call h1p1(p4,p1,p2,p3,th1)
       do i=1,3
         Jh1(i)=Jh1(i)-th1(i)
       end do
       
       call h1p1(p1,p2,p4,p3,th1)
       do i=1,3
         Jh1(i)=Jh1(i)-th1(i)
       end do
       

       ME2 = (abs(Jh1(1)))**2 + (abs(Jh1(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to \rho\rho \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c               author Viacheslav Shary 
c
c                    February 2000
c
c=============================================================================

      SUBROUTINE RhoRho_PI4N(ME2,Jrr)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      double precision mrho
      parameter (mrho=7.70d2)

      double precision Lambda
      parameter (Lambda=1.0d3)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 Jrr(3),c1,c2,DpRho,tmp1,tmp2

      real E
      
      real p1p2,p1p3,p1p4,p2p3,p2p4,p3p4

      real*8 s12, s34, s13, s24

      integer i

c==============================================================================

       E = p1(0)+p2(0)+p3(0)+p4(0)

       p1p2 = p1(1)*p2(1)+p1(2)*p2(2)+p1(3)*p2(3)
       p1p3 = p1(1)*p3(1)+p1(2)*p3(2)+p1(3)*p3(3)
       p1p4 = p1(1)*p4(1)+p1(2)*p4(2)+p1(3)*p4(3)
       p2p3 = p2(1)*p3(1)+p2(2)*p3(2)+p2(3)*p3(3)
       p2p4 = p2(1)*p4(1)+p2(2)*p4(2)+p2(3)*p4(3)
       p3p4 = p3(1)*p4(1)+p3(2)*p4(2)+p3(3)*p4(3)


       s12 = (p1(0)+p2(0))**2 - (p1(1)+p2(1))**2 -
     &   (p1(2)+p2(2))**2 - (p1(3)+p2(3))**2
       s13 = (p1(0)+p3(0))**2 - (p1(1)+p3(1))**2 -
     &   (p1(2)+p3(2))**2 - (p1(3)+p3(3))**2
       s24 = (p2(0)+p4(0))**2 - (p2(1)+p4(1))**2 -
     &   (p2(2)+p4(2))**2 - (p2(3)+p4(3))**2
       s34 = (p3(0)+p4(0))**2 - (p3(1)+p4(1))**2 -
     &   (p3(2)+p4(2))**2 - (p3(3)+p4(3))**2

       if(s12.lt.0) then
         write(6,*) 'VSHME4pi:  !!! Argument of DpRho <0 !!!'
         s12=0.
       end if

       if(s13.lt.0) then
         write(6,*) 'VSHME4pi:  !!! Argument of DpRho <0 !!!'
         s13=0.
       end if
       
       if(s24.lt.0) then
         write(6,*) 'VSHME4pi:  !!! Argument of DpRho <0 !!!'
         s24=0.
       end if
       
       if(s34.lt.0) then
         write(6,*) 'VSHME4pi:  !!! Argument of DpRho <0 !!!'
         s34=0.
       end if

       c1 = ((1+mrho**2/Lambda**2)/(1+s12/Lambda**2))**2*
     &   ((1+mrho**2/Lambda**2)/(1+s34/Lambda**2))**2/
     &   (DpRho(s12)*DpRho(s34))
       c2 = ((1+mrho**2/Lambda**2)/(1+s13/Lambda**2))**2*
     &   ((1+mrho**2/Lambda**2)/(1+s24/Lambda**2))**2/
     &   (DpRho(s13)*DpRho(s24))


       do i=1,3

          Jrr(i)=c1*(p1(i)*(p3(0)*p2(i)*p4(i)-p4(0)*p2(i)*p3(i)) -
     &     p2(i)*(p3(0)*p1(i)*p4(i)-p4(0)*p1(i)*p3(i)) -
     &     p3(i)*(p1(0)*p2(i)*p4(i)-p2(0)*p1(i)*p4(i)) +
     &     p4(i)*(p1(0)*p2(i)*p3(i)-p2(0)*p1(i)*p3(i))) +
     &     c2*(p1(i)*(p2(0)*p3(i)*p4(i)-p4(0)*p3(i)*p2(i)) -
     &     p3(i)*(p2(0)*p1(i)*p4(i)-p4(0)*p1(i)*p2(i)) -
     &     p2(i)*(p1(0)*p3(i)*p4(i)-p3(0)*p1(i)*p4(i)) +
     &     p4(i)*(p1(0)*p3(i)*p2(i)-p3(0)*p1(i)*p2(i)))

       end do
       
       ME2 = (abs(Jrr(1)))**2 + (abs(Jrr(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to \pi(1300)\pi \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c               author Viacheslav Shary 
c
c                    February'00
c
c=============================================================================

      SUBROUTINE Pi_PI4N(ME2,Jp)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 tp(3),Jp(3)

      integer i

c==============================================================================

      call pp1(p1,p2,p3,p4,Jp)

      call pp1(p1,p3,p2,p4,tp)
      do i=1,3
        Jp(i)=Jp(i)+tp(i)
      end do
      
      call pp1(p4,p1,p3,p2,tp)
      do i=1,3
        Jp(i)=Jp(i)+tp(i)
      end do
      
      
      call pp1(p4,p1,p2,p3,Jp)
      do i=1,3
        Jp(i)=Jp(i)+tp(i)
      end do


       ME2 = (abs(Jp(1)))**2 + (abs(Jp(2)))**2
       
       RETURN
       END


c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to \sigma\pi \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c               author Viacheslav Shary 
c
c                    February'00
c
c=============================================================================

      SUBROUTINE Sigma_PI4N(ME2,Jsig)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 tsig(3),Jsig(3)

      integer i

c==============================================================================

      call sigp1(p1,p2,p3,p4,Jsig)

      ME2 = (abs(Jsig(1)))**2 + (abs(Jsig(2)))**2
       
       RETURN
       END


c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to a2\pi \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c    author Viacheslav Shary (based on the Alexey Berdyugin subprogram) 
c
c                   February'99
c
c=============================================================================

       SUBROUTINE A2_PI4N(ME2,Ja2)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 ta2(3),Ja2(3)

      integer i

c==============================================================================

       call a2p1(p1,p2,p3,p4,Ja2)

       call a2p1(p4,p2,p3,p1,ta2)
       do i=1,3
         Ja2(i)=Ja2(i)-ta2(i)
       end do
       
       call a2p1(p1,p3,p2,p4,ta2)
       do i=1,3
         Ja2(i)=Ja2(i)+ta2(i)
       end do
       
       call a2p1(p4,p3,p2,p1,ta2)
       do i=1,3
         Ja2(i)=Ja2(i)-ta2(i)
       end do
       
       ME2 = (abs(Ja2(1)))**2 + (abs(Ja2(2)))**2
       
       RETURN
       END

c==========================================================================
c      
c        Matrix element calculation for the process
c              e^+e^- \to om\pi \to \pi^+\pi^-2\pi^0
c  using formulas from the preprint BINP 98-83 (CMD2 collaborations)     
c
c              author Viacheslav Shary 
c
c                   April'99
c
c=============================================================================

       SUBROUTINE OM_PI4N(ME2,Jom)

      implicit none

      double precision masspi
      parameter (masspi=1.3956995d2)

      double precision masspi0
      parameter (masspi0=1.349764d2)

      real ME2

c  энергия-импульс моделированных пионов
      common/PI4MC/ p1, p2, p3, p4
      real  p1(0:3),p2(0:3),p3(0:3),p4(0:3)

      complex*16 tom(3),Jom(3)

      integer i

c==============================================================================

      call omp1(p2,p4,p1,p3,Jom)

      call omp1(p2,p1,p4,p3,tom)
       do i=1,3
         Jom(i)=Jom(i)-tom(i)
       end do
       
       call omp1(p2,p3,p1,p4,tom)
       do i=1,3
         Jom(i)=Jom(i)-tom(i)
       end do
       
       call omp1(p3,p4,p1,p2,Jom)
       do i=1,3
         Jom(i)=Jom(i)+tom(i)
       end do

       call omp1(p3,p1,p4,p2,tom)
       do i=1,3
         Jom(i)=Jom(i)-tom(i)
       end do
       
       call omp1(p3,p2,p1,p4,tom)
       do i=1,3
         Jom(i)=Jom(i)-tom(i)
       end do
       
       
       ME2 = (abs(Jom(1)))**2 + (abs(Jom(2)))**2
       
       RETURN
       END
