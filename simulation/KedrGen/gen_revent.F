      SUBROUTINE GEN_REVENT(NF,NMAX,NEVREAD,NPART,ARREVT)
c*************************************************************************
c                                                                        *
c  Generator 310: reads 1 event (primary tracks) from file at disk       *
c                                                                        *
c  Name of text file should be:  kedr_trks1.dat - kedr_trks10.dat        *
c                                                                        *
c                                                                        *
c  Input parameters:                                                     *
c                                                                        *
c  NF=1-10 -determines name of file: kedr_trks1.dat, kedr_trks2.dat, etc *
c  NMAX  - number of events in file to be read                           *
c                                                                        *
c  Structure of the text file kedr_trks*.dat:                            *
c                                                                        *
c  1-st line (80 symb): comments                                         *
c  2-nd line (etc): N1 N2 ITYP Px Py Pz X Y Z       [ in free format]    *
c  N1 - number of event: 1,2,...                                         *
c  N2 - number of tracks in this event: 1,2,...                          *
c  ITYP     - GEANT particle type                                        *
c  Px Py Pz - particle momentum (GeV/c)                                  *
c  X Y Z    - particle coordinates (cm)                                  *
c                                                                        *
c                                                                        *
c  Output:                                                               *
c                                                                        *
c  NEVREAD - number of curent event which was read from file             *
c  NPART   - number of tracks (particles) in this event (<=100)          *
c  ARREVT  - array with parameters of tracks in event                    *
c                                                                        *
c  Author: V.A.Tayursky. 22.01.2003                                      *
c                                                                        *
c  Corrections:                                                          *
c                                                                        *
c  30.11.2007: 1) file is opened and closed once; 2) fixed ->free format *
c  27.12.2007: corrected print out of initial data                       *
c  18.06.2008: removed IEND from SAVE                                    *
c                                                                        *
c*************************************************************************
c
c  IDEBUG, ..., IEVENT, ..., NEVENT, ...
#include "gcflag.inc"
      DIMENSION ARREVT(7,100),P(3),R(3),ARREVT0(7)
      CHARACTER *1 TEXTLN(80)
c
      SAVE NCALL,LU,NR,ARREVT0
      EQUIVALENCE (IA,AI)
c
      DATA NCALL/0/    ! counters of calls, flag of events in buffer
c
      IF(NCALL.GT.0) THEN
        GOTO 105
      ELSE  
        IF(NF.LT.1.OR.NF.GT.10) THEN     ! wrong number of file
          PRINT 3,NF
          STOP
        END IF
c
        PRINT *, '    '
        PRINT 102    !  --------------------
c
        CALL SEARCH_FREE_UNIT(LU)
c
        IF(NF.EQ.1) THEN
          OPEN (LU,FILE = 'kedr_trks1.dat')
          PRINT *,'   Generator 310. File: kedr_trks1.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.2) THEN
          OPEN (LU,FILE = 'kedr_trks2.dat')
          PRINT *,'   Generator 310. File: kedr_trks2.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.3) THEN
          OPEN (LU,FILE = 'kedr_trks3.dat')
          PRINT *,'   Generator 310. File: kedr_trks3.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.4) THEN
          OPEN (LU,FILE = 'kedr_trks4.dat')
          PRINT *,'   Generator 310. File: kedr_trks4.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.5) THEN
          OPEN (LU,FILE = 'kedr_trks5.dat')
          PRINT *,'   Generator 310. File: kedr_trks5.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.6) THEN
          OPEN (LU,FILE = 'kedr_trks6.dat')
          PRINT *,'   Generator 310. File: kedr_trks6.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.7) THEN
          OPEN (LU,FILE = 'kedr_trks7.dat')
          PRINT *,'   Generator 310. File: kedr_trks7.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.8) THEN
          OPEN (LU,FILE = 'kedr_trks8.dat')
          PRINT *,'   Generator 310. File: kedr_trks8.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.9) THEN
          OPEN (LU,FILE = 'kedr_trks9.dat')
          PRINT *,'   Generator 310. File: kedr_trks9.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        IF(NF.EQ.10) THEN
          OPEN (LU,FILE = 'kedr_trks10.dat')
          PRINT *,'   Generator 310. File: kedr_trks10.dat. Events in',
     &            ' job: NMAX=',NMAX
        END IF
c
        PRINT *,' '
        PRINT 102    !   --------------------
c
        IF(NEVENT.GT.NMAX) THEN
          PRINT 103,NMAX
          NEVENT=NMAX                  ! NEVENT changed to maximum from job
        END IF
c
        NR=1                           ! number of event being read 
      END IF
c
c=== First line of file with comments ====================
c
      READ (LU,1) (TEXTLN(I),I=1,80)   
      IF(NCALL.EQ.0) PRINT 2,TEXTLN    ! print comments
c
 105  NPART=0                          ! counter of tracks in event
c
      IF(NR.GT.1) THEN              
        DO I=1,7
          ARREVT(I,1)=ARREVT0(I)       ! 1 track from previous call
        END DO
        NPART=1
      END IF      
c
c=======================================================================
c
c                         #ev  #tr  typ   P(3)          R(3)
c                          !    !    !     !             !
 100  READ (LU,*,END=200)  N1, N2,  IA, (P(I),I=1,3), (R(I),I=1,3)
c
      IF(N1.EQ.NR) THEN
        NPART=NPART+1            ! counter of tracks in event
c
        IF(NPART.GT.100) THEN
          PRINT 6,NF,N1,NPART	 ! initial tracks should be 1-100
          STOP
        END IF
c
        ARREVT(1,NPART)=AI
c
        DO I=1,3
          ARREVT(I+1,NPART)=P(I)
          ARREVT(I+4,NPART)=R(I)
        END DO
c
        GOTO 100
      ELSE
        IF(N1.EQ.0) GOTO 200
c
        ARREVT0(1)=AI          !  this track is saved for next event  
c
        DO I=1,3               !
          ARREVT0(I+1)=P(I)    !
          ARREVT0(I+4)=R(I)    !
        END DO                 !
c
        NR=NR+1
      END IF
c
      GOTO 201
c
c----------------------------------------------------------------
c
 200  IF(NEVENT.GT.NR) THEN
        NEVENT=NR 
        PRINT 104,NR
        CLOSE (LU)
        GOTO 202                 !  End of file with initial tracks 
      END IF
c
 201  NCALL=NCALL+1 ! number of calls = number of events, which were read
c
      NEVREAD=NCALL
c
      IF(NEVREAD.EQ.NMAX.OR.N1.EQ.0) CLOSE (LU)
c
      IF(N1.EQ.0.AND.NPART.EQ.0) THEN
        PRINT 22,NMAX
        STOP
      END IF
c
 1    FORMAT(80A1)
 2    FORMAT(/,80A1,/)
 3    FORMAT(/,' GEN_REVENT: Error, NF=',I5,' but should be 1-10',/)
c 4    FORMAT(I5,2I4,3F10.6,3F10.4)       ! old:  fixed format as in sim-n
 6    FORMAT(/,' GEN_REVENT: Error, file NF=',I2,
     +         ' Event=',I5,' Tracks=',I5,/)
 22   FORMAT(/,'Generator 310: end of file with',I6,' events',/)
 102  FORMAT(4X,65(1H-),/)
 103  FORMAT(/,' Gen 310: NEVENT (card TRIG) was changed to NMAX=',I5,/)
 104  FORMAT(/,' Gen 310: NEVENT (card TRIG) was changed to number of'
     +,' events in file =',I5,/)
c
 202  RETURN
      END
