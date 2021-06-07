       COMPLEX*16 FUNCTION FORMF(KP,KM,K0)
C********************************************************************
C      Formfactor for gamma->ro+pi decay with ro-omega
C      mixing .
C      Avvakumov S.
C********************************************************************
	implicit none
       	include 'fitdata.inc'
	REAL*8 KP,KM,K0,BR0
	DATA BR0 /-111111./
	COMPLEX*16 DpRho,DpOm,DELTA
        SAVE BR0,DELTA

       	if ( BrOm2Pi.ne.BR0 ) then
          call INIFIT
          BR0=BrOm2Pi
          DELTA=dcmplx(cos(PhOm2Pi*DEG2RAD),sin(PhOm2Pi*DEG2RAD))*
     *         sqrt(BROm2Pi*GRho*GOm*0.5D0)
       end if 

       FORMF=1.D0/DpRho(KP)+
     @       1.D0/DpRho(KM)+
     @       1.D0/DpRho(K0)*(1.D0+
     @   2.D0*AOmRho*MsOm*DELTA/DpOm(K0))
       END
