      SUBROUTINE GEN_REVENT(NF,NMAX,NEVREAD,NPART,ARREVT)
c*************************************************************************
c                                                                        *
c  Generator 310: reads events (primary tracks) from text file at disk   *
c                                                                        *
c                                                                        *
c  Name of file should be:  kedr_trks1.dat - kedr_trks10.dat             *
c                                                                        *
c                                                                        *
c  Input parameters:                                                     *
c                                                                        *
c  NF=1-10 -determines name of file: kedr_trks1.dat, kedr_trks2.dat, etc *
c  NMAX  - number of events in file                                      *
c                                                                        *
c  Structure of the text file kedr_trks*.dat:                            *
c                                                                        *
c  1-st line (80 symb): comments                                         *
c  2-nd line (etc): N1 N2 ITYP Px Py Pz X Y Z  F-T(I5,2I4,3F10.6,3F10.4) *
c  N1 - number of event: 1,2,...                                         *
c  N2 - number of tracks in this event: 1,2,...                          *
c  ITYP     - GEANT particle type                                        *
c  Px Py Pz - particle momentum (GeV/c)                                  *
c  X Y Z    - particle coordinates (cm)                                  *
c                                                                        *
c                                                                        *
c  Output:                                                               *
c                                                                        *
c  NEVREAD - number of events, which were read from file                 *
c  NPART   - number of tracks (particles) in event (<=100)               *
c  ARREVT  - array with parameters of tracks in event                    *
c                                                                        *
c  Author: V.A.Tayursky                                                  *
c                                                                        *
c  22.01.2003                                                            *
c                                                                        *
c*************************************************************************
c
! IDEBUG, ..., IEVENT, ..., NEVENT, ...
#include "gcflag.inc"
      DIMENSION ARREVT(7,100),P(3),R(3)
      CHARACTER *1 TEXTLN(80)
      SAVE NCALL
      EQUIVALENCE (IA,AI)
c
      DATA NCALL/0/    ! counters of calls, flag of events in buffer
c
      NPART=0          ! counter of tracks in event
c
      CALL SEARCH_FREE_UNIT(LU)
c
      IF(NF.LT.1.OR.NF.GT.10) THEN
        PRINT 3,NF
        STOP
      END IF
c
      IF(NCALL.EQ.0) PRINT 10       !  --------------------
      IF(NCALL.EQ.0) PRINT 101      !  |                  |
c
      IF(NF.EQ.1) THEN
        OPEN (LU,FILE = 'kedr_trks1.dat')
        IF(NCALL.EQ.0) PRINT 11,NMAX
      END IF
c
      IF(NF.EQ.2) THEN
        OPEN (LU,FILE = 'kedr_trks2.dat')
        IF(NCALL.EQ.0) PRINT 12,NMAX
      END IF
c
      IF(NF.EQ.3) THEN
        OPEN (LU,FILE = 'kedr_trks3.dat')
        IF(NCALL.EQ.0) PRINT 13,NMAX
      END IF
c
      IF(NF.EQ.4) THEN
        OPEN (LU,FILE = 'kedr_trks4.dat')
        IF(NCALL.EQ.0) PRINT 14,NMAX
      END IF
c
      IF(NF.EQ.5) THEN
        OPEN (LU,FILE = 'kedr_trks5.dat')
        IF(NCALL.EQ.0) PRINT 15,NMAX
      END IF
c
      IF(NF.EQ.6) THEN
        OPEN (LU,FILE = 'kedr_trks6.dat')
        IF(NCALL.EQ.0) PRINT 16,NMAX
      END IF
c
      IF(NF.EQ.7) THEN
        OPEN (LU,FILE = 'kedr_trks7.dat')
        IF(NCALL.EQ.0) PRINT 17,NMAX
      END IF
c
      IF(NF.EQ.8) THEN
        OPEN (LU,FILE = 'kedr_trks8.dat')
        IF(NCALL.EQ.0) PRINT 18,NMAX
      END IF
c
      IF(NF.EQ.9) THEN
        OPEN (LU,FILE = 'kedr_trks9.dat')
        IF(NCALL.EQ.0) PRINT 19,NMAX
      END IF
c
      IF(NF.EQ.10) THEN
        OPEN (LU,FILE = 'kedr_trks10.dat')
        IF(NCALL.EQ.0) PRINT 20,NMAX
      END IF
c
      IF(NCALL.EQ.0) PRINT 101    !   |                  |
      IF(NCALL.EQ.0) PRINT 102    !   --------------------
c
      READ (LU,1) (TEXTLN(I),I=1,80)     ! comments: 1-st line of file
      IF(NCALL.EQ.0) PRINT 2,TEXTLN      ! print comments
c
      IF(NEVENT.GT.NMAX) THEN
        IF(NF.LT.10) PRINT 103,NF
        IF(NF.GE.10) PRINT 104,NF
        NEVENT=NMAX        ! NEVENT changed to maximum in file
      END IF
c
c=======================================================================
c
c                         #ev  #tr  typ   P(3)          R(3)
c                          !    !    !     !             !
100   READ (LU,4,END=200)  N1, N2,  IA, (P(I),I=1,3), (R(I),I=1,3)
c
      IF(N1.LT.NCALL+1) GOTO 100
      IF(N1.GT.NCALL+1.OR.N1.EQ.0) GOTO 200   ! N1=0: end of file
c
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
c
c----------------------------------------------------------------
c
200   CLOSE (LU)
c
      NCALL=NCALL+1 ! number of calls = number of events, which were read
c
      NEVREAD=NCALL
c
      IF(N1.EQ.0.AND.NPART.EQ.0) THEN
        PRINT 22,NMAX
        STOP
      END IF
c
1     FORMAT(80A1)
2     FORMAT(/,80A1,/)
3     FORMAT(/,' PST_REVENT: Error, NF=',I5,' but should be 1-10',/)
4     FORMAT(I5,2I4,3F10.6,3F10.4)
6     FORMAT(/,' PST_REVENT: Error, file NF=',I2,
     +         ' Event=',I5,' Tracks=',I5,/)
10    FORMAT(/10x,'---------------------------------------',
     +            '--------------')
101   FORMAT(10x,  '|                                      ',
     +            '             |')
102   FORMAT(10x,  '---------------------------------------',
     +            '--------------',/)
103   FORMAT(/,' NEVENT was changed to NMAX from file kedr_trks',i1,
     +         ' for generator 310',/)
104   FORMAT(/,' NEVENT was changed to NMAX from file kedr_trks',i2,
     +         ' for generator 310',/)
11    FORMAT(10x,  '| Generator 310. File: kedr_trks1.dat.',
     +       ' Events:',I4,' |')
12    FORMAT(10x,  '| Generator 310. File: kedr_trks2.dat. ',
     +       ' Events:',I4,' |')
13    FORMAT(10x,  '| Generator 310. File: kedr_trks3.dat. ',
     +       ' Events:',I4,' |')
14    FORMAT(10x , '| Generator 310. File: kedr_trks4.dat. ',
     +       ' Events:',I4,' |')
15    FORMAT(10x,  '| Generator 310. File: kedr_trks5.dat. ',
     +       ' Events:',I4,' |')
16    FORMAT(10x,  '| Generator 310. File: kedr_trks6.dat. ',
     +       ' Events:',I4,' |')
17    FORMAT(10x,  '| Generator 310. File: kedr_trks7.dat. ',
     +       ' Events:',I4,' |')
18    FORMAT(10x,  '| Generator 310. File: kedr_trks8.dat. ',
     +       ' Events:',I4,' |')
19    FORMAT(10x,  '| Generator 310. File: kedr_trks9.dat. ',
     +       ' Events:',I4,' |')
20    FORMAT(10x,  '| Generator 310. File: kedr_trks10.dat.',
     +       ' Events:',I4,' |')
22    FORMAT(/,'PST_REVENT: Error: end of file with',I5,' events',/)
c
      RETURN
      END
