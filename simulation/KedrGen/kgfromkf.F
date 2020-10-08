	function kgfromkf(kf)
c
c gets GEANT code (if exist) from LUND kf code 
c
      call pstpcode1(kf,kgeant)
c
      kgfromkf=kgeant
c	
      return
      end
