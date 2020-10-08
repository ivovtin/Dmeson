      SUBROUTINE GEN_TPRINTS                                
c*******************************************************************    
c                                                                       
c   Subroutine for short prints of movements of particles, Generator 312             
c   
c   Maximum number of lines = 10 000
c
c   V.A.Tayursky.   
c                 last update: 15.4.2004
c                                                                       
c*******************************************************************    
c
#include "gcflag.inc"
#include "gckine.inc"
#include "gcking.inc"
#include "gctmed.inc"
#include "gctrak.inc"
#include "gcvolu.inc"                                              
#include "gcmate.inc"
c      COMMON /GCMATE/ NMAT,NAMATE(5),A,Z,DENS,RADL,ABSL
c
      COMMON /KEDR_GEN/KHEP,KGEN,GENPAR(20) ! input parameters for generators
      CHARACTER *4 NAMES,NAMI
      CHARACTER *3 TXT(2)
c
      SAVE XIN,YIN,ZIN,LINEMAX,IPRINT,IEVENT0
c                                                                       
      DATA IPRINT,IEVENT0,LINEMAX/2*0,10000/                                          
      DATA XIN,YIN,ZIN/3*0./
      DATA TXT/'in ','out'/
c                            
      IF(IPRINT.EQ.LINEMAX) RETURN                                           
      IF(ABS(GENPAR(1)-1.).LT.0.5) GOTO 10  ! geantino, 1 event
      IF(ABS(GENPAR(1)-2.).LT.0.5) GOTO 20
      RETURN
c
 10   IF(IEVENT.GT.1) RETURN
c
c  1-st regime, particle=geantino
c           
      NAMI=NAMES(NLEVEL)          ! name of block with particle                                                   
c                                                                       
      IF(INWVOL.NE.1.AND.INWVOL.NE.2) RETURN
c
      IPRINT=IPRINT+1             ! counter of lines with prints
c                                   
      R_PART=SQRT(VECT(1)**2+VECT(2)**2)
      FI_PART=ATAN2(VECT(2),VECT(1))*57.29578
      IF(FI_PART.LT.0.) FI_PART=360+FI_PART
c
      SX=VECT(1)-XIN
      SY=VECT(2)-YIN
      SZ=VECT(3)-ZIN
c
      IF(IEVENT.NE.IEVENT0) THEN 
        PRINT 303,IEVENT	  ! number of current event
        IEVENT0=IEVENT
        SX=0.
        SY=0.
        SZ=0.
        STOT=0.
      END IF
c
      IF(INWVOL.EQ.1) PRINT 11,TXT(INWVOL),
     +      NATMED(1),NAMES(NLEVEL),VECT(1),VECT(2),VECT(3)
      IF(INWVOL.EQ.2) PRINT 1,TXT(INWVOL),                
     +      NATMED(1),NAMES(NLEVEL),VECT(1),SX,VECT(2),SY,VECT(3),SZ

c
      XIN=VECT(1)
      YIN=VECT(2)
      ZIN=VECT(3)
c
      IF(INWVOL.EQ.2) THEN
        SS=SQRT(SX**2+SY**2+SZ**2)
        IF(RADL.GT.0) STOT=STOT+SS/RADL
        PRINT 3,SS,NMAT,RADL,STOT
      END IF
c
      RETURN
c
c--------------------------------------------------------------------------
c
 20   CONTINUE
c
c  Test print for particles excluding Typ1-Typ6
c        
      DO I=1,6
        IF(IPART.EQ.IFIX(GENPAR(I+8))) RETURN      
      END DO
c
      NAMI=NAMES(NLEVEL)          ! name of block with particle 
c	                                                          
      IPRINT=IPRINT+1             ! counter of lines with prints
c      KCASE1=NEMPT        
c      IF(NGKINE.NE.0) KCASE1=KCASE            ! Print without photons
c	                                      
       IF(INWVOL.EQ.1) PRINT *,' '
c
      R_PART=SQRT(VECT(1)**2+VECT(2)**2)
      FI_PART=ATAN2(VECT(2),VECT(1))*57.29578
      IF(FI_PART.LT.0.) FI_PART=360+FI_PART
c
      IF(IEVENT.NE.IEVENT0) THEN 
        PRINT 303,IEVENT          ! number of current event
        IEVENT0=IEVENT
      END IF
c      
      PRINT 301,                                    
     *  (NAPART(IT),IT=1,2),VECT(7)*1.E3,VECT(3),R_PART,FI_PART, 
     *  INWVOL,NATMED(1),NAMES(NLEVEL),ISTOP
c                     
1     FORMAT(A3,1X,A4,'  Blk ',A4,'  X=',F7.2,' dX=',F6.2,
     +       ' Y=',F7.2,' dY=',F6.2,' Z=',F7.2,' dZ=',F6.2)                                                 
3     FORMAT('Ds=',F7.3,' cm,','  IMATE=',I3,',  Xo=',1pE9.2,' cm,',
     +       '  Total lenth of track = ',F6.2,' Xo'/)
11    FORMAT(A3,1X,A4,'  Blk ',A4,'  X=',F7.2,10X,
     +       ' Y=',F7.2,10X,' Z=',F7.2,9X)
301   FORMAT(2A4,' P=',F7.2,' Z=',F8.2,' R=',F8.2,' FI=',F5.1,       
     * ' inw=',i2,' Ma=',A4,' Blk=',A4,' st=',I2)
303   FORMAT(//,' EVENT #',I3,/)
c                                                                       
      END 
