C********************************************************************
C    Set of functions to determine width correction factors
C          11.12.96  V.Ivanchenko  
C***************************************************************

       real*8 function ccrho2pi(e2)
C********************************************************************
C      The cutting function for ro->2pi decay
C      Avvakumov S.
C      Ivanchenko V.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2
       CcRho2Pi=1.D0
       END

       real*8 function ccphi3pi(e2)
C********************************************************************
C      The cutting function for FI->ro+pi decay
C      Avvakumov S.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2
       CcPhi3Pi=1.D0
c       CFIROPI=((1D0+(R*MFI)**2)/(1D0+(R*E2)**2))**2
       END

       real*8 function ccompi0g(e2)
C********************************************************************
C      The cutting function for omega->pi+gamma decay
C      Avvakumov S.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2
       CcOmPi0G=1.D0
c       COMPIG=((1D0+(R*MOM)**2)/(1D0+(E2*R)**2))**2
       end




       real*8 function ccom3pi(e2)
C********************************************************************
C      The cutting function for omega->ro+pi decay
C      Avvakumov S.
C********************************************************************
       implicit none	
       include 'fitdata.inc'
       REAL*8 E2
       CcOm3Pi=1.D0
c       COMROPI=((1D0+(R*MOM)**2)/(1D0+(E2*R)**2))**2
       end
