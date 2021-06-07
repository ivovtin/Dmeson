	FUNCTION kgfromkf(kf)
c***********************************************************************
c
c  Gets GEANT code (if exist) from LUND kf code 
c
c***********************************************************************
c
      CALL PstPCode1(kf,kgeant)
c
      kgfromkf=kgeant
c	
      END
