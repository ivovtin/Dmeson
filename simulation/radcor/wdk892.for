c--------------------------------------------------------------------
C    Set of functions to determine K* widths
C          28.11.98 Al.Berdyugin
c--------------------------------------------------------------------
c+++ R8 wdk892( R8 e2 ) width of K*(892)
       real *8 function wdk892(e2)
c--------------------------------------------------------------------
C      Width of K*
C      Al.Berdyugin
c--------------------------------------------------------------------
       implicit none
       include 'fitdata.inc'
       real *8 E2,PhSp2,PhSp0
       logical first/.true./
       save first,PhSp0
C--------------------------------------------------------------------
       if(first)then
         first=.false.
	 call IniFit
	 PhSp0=PhSp2(MsK0892,MsKs,MsPi0)
       end if
C--------------------------------------------------------------------
       if(E2.lt.MsKs+MsPi0.or.PhSp0.eq.0.D0)then
         WdK892=0.D0
	 return
       end if
C--------------------------------------------------------------------
       WdK892=GK0892*(PhSp2(E2,MsKs,MsPi0)/PhSp0)**3*(MsK0892/E2)**2
       return
       end


C--------------------------------------------------------------------
C
C--------------------------------------------------------------------

c+++ C16 dpk892( R8 s ) inverse propagator of K*(892)
       complex *16 function DpK892(S)
C--------------------------------------------------------------------
C      Inverse propagator of K*(892)
C      Al.Berdyugin
C--------------------------------------------------------------------
C
       implicit none
       include 'fitdata.inc'
       real *8 S,E2,WdK892
       logical first/.true./
       save first
C--------------------------------------------------------------------
       if(first)then
         first=.false.
	 call IniFit
       end if
C--------------------------------------------------------------------
       E2=sqrt(S)
       DpK892=dcmplx(MsK0892**2-S,-(E2*WdK892(E2)))
       END
