*CMZ :  1.01/00 27/11/91  16.21.59  by  Master Librarian (CMD)
*-- Author :
      subroutine COSRN(RAD,ALEN,XYZ,THETA,PHI,P,PXYZ)
#include "gconst.inc"
      DIMENSION XYZ(3),PXYZ(3)
C
      CALL GRNDM(X,1)
      XYZ(3)=ALEN*(X-.5)
10    CALL GRNDM(X,1)
      ALFA=(X-.5)*TWOPI
      CALL GRNDM(X,1)
      THETA=X*PI
      CALL GRNDM(X,1)
      PHI=X*TWOPI
      CALL GRNDM(X,1)
      COT=COS(THETA)
      SIT=SIN(THETA)
      COA=COS(ALFA)
      SIA=SIN(ALFA)
      COP=COS(PHI)
      ADIS=COT**2*(COT*COA-SIT*SIA*COP)
C        PRINT *,ADIS,X
      IF(X.GT.ADIS)GO TO 10
      XYZ(1)=  RAD*COA
      XYZ(2)= RAD*SIA
      PXYZ(1)=-P*COT
      PP=P*SIT
      PXYZ(2)=PP*COP
      PXYZ(3)=PP*SIN(PHI)
      RETURN
      END
