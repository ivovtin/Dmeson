      SUBROUTINE GEN_USERA(VERTEX,IPRTRK)
c*******************************************************************
c
c   Generator of user (#2)
c
c   Input:
c
c   Vertex - Vertex of event (from GUKINE)
c   IPRTRK=1/0 - print/no print initial tracks (from GUKINE)
c
c   As a random number generator should be used 
c   function (real*4) rlu(0) (generator from jetset74)
c
c   19.03.2004
c
c*******************************************************************
c
      COMMON /PKIN/    NTRACK,IPARTICLE(50),EPART(50), ! - for output file
     +                 PXPART(50),PYPART(50),PZPART(50)
      COMMON /KEDR_GEN/ KHEP,KGEN,GENPAR(20)      ! parameters for generator
      DIMENSION PLAB(3),VERTEX(3)
c 
c
c      CALL GSVERT(VERTEX,0,0,0,0,NVERT)
c
c      NTRACK=0
c
c      PLAB(1)=
c      PLAB(2)=
c      PLAB(3)=
c      ITYPE=            
c	                                    
c      CALL GSKINE(PLAB,ITYPE,NVERT,0,0,NT)
c
c      NTRACK=NTRACK+1
c
c      IPARTICLE(NTRACK)=ITYPE  
c      EPART(NTRACK)=VEPART(I,4)
c      PXPART(NTRACK)=PLAB(1)   
c      PYPART(NTRACK)=PLAB(2)   
c      PZPART(NTRACK)=PLAB(3)   
c      IF(IPRTRK.EQ.1) PRINT 397,IEVENT,NTRACK,ITYPE,PLAB,VERTEX
c
397   FORMAT(I5,2I4,3F10.6,3F10.4)
c
      END
 