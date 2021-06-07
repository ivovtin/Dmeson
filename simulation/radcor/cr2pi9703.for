C================================================================
C Calculating born cross section for e+e- -> pi+pi- process
C================================================================
C         A.Varganov 12.03.97   
C================================================================

	real*8 function cr2pi9703(e2)
        implicit none
        real*8 pi, alpha, mpi
        parameter ( pi=3.141593 )
        parameter ( alpha=1./137.036 )
	parameter ( mpi=139.57 )
	real*8 e2,beta
	real*8 formpi
	
        cr2pi9703 = 0.
        if ( e2.le.1400.0) then
          if ( (1.-(2.*mpi/E2)**2).gt.0. ) then
            beta = sqrt(1.-(2.*mpi/E2)**2)
            cr2pi9703 = (pi*alpha**2*beta**3*3.89380D11)
     &        /(3.*E2**2)*formpi(E2)
          endif
        else
          write (6,*) 'The energy is out of available range'
        endif
	end
