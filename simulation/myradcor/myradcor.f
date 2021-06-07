	double precision function frand(par)
	real par
	double precision r

c	print *,'FunRand called'
	
	call rm48(r,1)
	frand = r
	
	end

	program test
	
	double precision frand
	double precision cs0(1000), ben(1000)
	real fen,fth,ffi
	integer n
	external frand
	
	call rcini(cs0,ben,'cs.dat',N,1000,20,30)
	
	do i=1, 10000
          call RCFTG(frand,0.0001,100.,cs0,ben,N,3770.,
     +		   FEN,FTH,FFI,2)
c	  if (egam.gt.0.0005) 
	  print *,fen,fth,ffi
	enddo
	
	end
