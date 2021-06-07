C -----------------------------------------------------------------
C  reads information from FILE and prepares CS0 and BEN arrays
C  NMAX - the dimension of CS0 and BEN arrays
C  N - actual number of points readed from FILE
C  LIN - logical number for input
C  LOU - logical number for output
C  change 11.12.97 by Al.Berdyugin
C  changed 16.03.98 by Z.Silagadze 
C -----------------------------------------------------------------
           SUBROUTINE RCINI(CS0,BEN,FILE,N,NMAX,LIN,LOU)
                IMPLICIT NONE

            INTEGER*4 LOUT,is,istat,KASCIF
            CHARACTER*(*) FILE,LTS(80)*1
            INTEGER RCFL,RCFS,RCTTN,RCLTN,p(6),N,nl,
     &              NMAX,m,i,nm,LIN,LOU,RCNONE
            DOUBLE PRECISION RCTTR,CS0(NMAX),BEN(NMAX)
            DOUBLE PRECISION me,pi,alp,alp2pi
            COMMON /RCLUN/LOUT,RCNONE
            COMMON /UMBB05/me,pi,alp,alp2pi

                 N=0 
                 nl=0
                 LOUT=LOU

C     constants          
                 me=0.51099906D0
                 pi=3.141592653D0
                 alp=1.0D0/137.0359895D0
                 alp2pi=(2.0D0/pi)*alp
                 
         IF(FILE.EQ.'NONE') THEN

C  Born cross-section is evaluated by FUNCTION RCFUN                    
                   RCNONE=1
                   N=1
          WRITE(LOU,7)
          WRITE(LOU,*)
     + 'RCINI message: Born cross-sectin will be evaluated by using '
     + //'RCFUN function'    
          WRITE(LOU,7) 
          WRITE(LOU,'(/)')           

        else if ( file .EQ. '---' ) then
          write (lou,*) 'RCINI : no file specified'
          write (lou,*)
     &      '        cross section will be tabulated in user program'
          rcnone = 0
          n = 1
          
         ELSE
C  Born cross-section is tabulated in FILE
                   RCNONE=0

           DO 1 i=1,NMAX
             BEN(i)=0.0
             CS0(i)=0.0
1          CONTINUE

ccc    use following instead of  OPEN(UNIT=LIN,FILE=FILE,STATUS='OLD')
           is = KASCIF(LIN,FILE,0,istat)
           if(is.ne.0)then
             write(LOU,*)' ## RCINI unable to open file:',FILE
             write(LOU,*)'          code = ',istat
              stop 8
           end if

2              READ(LIN,5,END=99) LTS

C   find edge positions for numbers
           p(1)=RCFL(LTS,1)
           p(2)=RCFS(LTS,p(1))
           p(3)=RCFL(LTS,p(2))
           p(4)=RCFS(LTS,p(3))
           p(5)=RCFL(LTS,p(4))
           p(6)=RCFS(LTS,p(5))

C   check if it is a commentary
           m=RCLTN(LTS(p(1)))
           IF(m.EQ.-1) GO TO 2

C  there must be just 6 edge positions 
             m=1
         DO 3 i=1,6
            IF(p(i).EQ.0) m=0
3        CONTINUE
        
C   reconstruct numbers
             nm=nl
             nl=RCTTN(LTS,p(1),p(2)-1)
               IF(m.EQ.1.AND.nl.NE.-1) THEN 
             N=N+1   
              IF(N.GT.NMAX) THEN
         WRITE(LOU,6)
         WRITE(LOU,*)  
     +   'RCINI warning: there are more than NMAX data in FILE ', 
     +    FILE
         WRITE(LOU,6)
         WRITE(LOU,'(/)') 
         N=N-1 
         GO TO 99
              END IF
 
            BEN(N)=RCTTR(LTS,p(3),p(4)-1)
            CS0(N)=RCTTR(LTS,p(5),p(6)-1)

               ELSE
C   there were not three numbers found or the record number is absent
         WRITE(LOU,6)
         WRITE(LOU,*)  'RCINI: incorect format !'
         WRITE(LOU,*) '       record ignored !'
         WRITE(LOU,*) '       the last correct record number = ',nm
         WRITE(LOU,6)
         WRITE(LOU,'(/)') 
            GO TO 2
               END IF

C   check if the reconstruction was sucessful
       IF(BEN(N).EQ.-1.OR.CS0(N).EQ.-1) THEN
         WRITE(LOU,6) 
         WRITE(LOU,*) 
     +    'RCINI: incorect format for the record number ',nl
         WRITE(LOU,*) '       record ignored !'
       WRITE(LOU,*) '       the last correct record number = ',nm
         WRITE(LOU,6)
         WRITE(LOU,'(/)') 
           BEN(N)=0
           CS0(N)=0
           N=N-1
        END IF  
             GO TO 2

99           CLOSE(LIN)
          WRITE(LOU,7)
          WRITE(LOU,*) 
     + 'RCINI message: ',N,' records were read from file ',FILE
          WRITE(LOU,7) 
          WRITE(LOU,'(/)')
          
         END IF

             RETURN

5         FORMAT(80A1)
6         FORMAT(80('*'))
7         FORMAT(80('.'))
              END

C --------------------------------------------------------
C     finds the first letter position in the array LTS(80)
C     in the interval (i1:80).
C     RCFL - the position found.
C     RCFL=0 - no letter was found.     
C --------------------------------------------------------
              INTEGER FUNCTION RCFL(LTS,i1)
                 IMPLICIT NONE
               CHARACTER LTS(80)*1
               INTEGER i,i1 
                i=i1
1            IF(LTS(i).NE.' ') GO TO 2
                i=i+1
               IF(i.GT.80) THEN
                RCFL=0
                RETURN
               END IF
               GO TO 1
2             RCFL=i
              END

C --------------------------------------------------------
C     finds the first space position in the array LTS(80)
C     in the interval (i1:80).
C     RCFS - the position found.
C     RCFS=81 - no space was found.     
C --------------------------------------------------------
              INTEGER FUNCTION RCFS(LTS,i1)
                 IMPLICIT NONE
               CHARACTER LTS(80)*1
               INTEGER i,i1
                i=i1
1            IF(LTS(i).EQ.' ') GO TO 2
                i=i+1
               IF(i.GT.80) THEN
                RCFS=81
                RETURN
               END IF
               GO TO 1
2             RCFS=i
              END
  
C ----------------------------------------------------------
C  character to number convertor
C  RCLTN=-1 - if L is not from '0123456789'
C ----------------------------------------------------------               
             INTEGER FUNCTION RCLTN(L)
                 IMPLICIT NONE
               CHARACTER L*1
                IF(L.EQ.'0') THEN
                 RCLTN=0
                ELSE IF(L.EQ.'1') THEN
                 RCLTN=1
                ELSE IF(L.EQ.'2') THEN
                 RCLTN=2
                ELSE IF(L.EQ.'3') THEN
                 RCLTN=3
                ELSE IF(L.EQ.'4') THEN
                 RCLTN=4
                ELSE IF(L.EQ.'5') THEN
                 RCLTN=5
                ELSE IF(L.EQ.'6') THEN
                 RCLTN=6
                ELSE IF(L.EQ.'7') THEN
                 RCLTN=7
                ELSE IF(L.EQ.'8') THEN
                 RCLTN=8
                ELSE IF(L.EQ.'9') THEN
                 RCLTN=9
                ELSE
                 RCLTN=-1
                END IF
             END

C ----------------------------------------------------------
C   constructs positive integer number from LTS(i1:i2)
C   RCTTN=-1 - a bad (i1:i2) interval
C ----------------------------------------------------------
             INTEGER FUNCTION RCTTN(LTS,i1,i2)
                IMPLICIT NONE
              CHARACTER LTS(80)*1
              INTEGER N(80),RCLTN,i1,i2,nm,ii,i
               nm=i2-i1+1
                 DO 1 i=1,nm
                   ii=i1+i-1
                   N(i)=RCLTN(LTS(ii))
                    IF(N(i).EQ.-1) THEN
                    RCTTN=-1
                    RETURN
                    END IF
1                CONTINUE        
                  RCTTN=0
                     DO 2 i=1,nm
                       RCTTN=RCTTN+N(i)*10**(nm-i)
2                    CONTINUE
             END

C ----------------------------------------------------------
C    finds the position of '.' in the interval (i1:i2)
C    RCFP=0 - no '.' was found
C ----------------------------------------------------------
               INTEGER FUNCTION RCFP(LTS,i1,i2)
                    IMPLICIT NONE
                  CHARACTER LTS(80)*1
                  INTEGER i1,i2,i
                    DO 1 i=i1,i2
                       IF(LTS(i).EQ.'.') THEN
                         RCFP=i
                         RETURN
                       END IF 
1                   CONTINUE
                         RCFP=0
                    END  

C --------------------------------------------------------------------
C    finds the position of 'E' or 'e' in the interval (i1:i2)
C    RCFE=0 - no 'E' or 'e' was found
C --------------------------------------------------------------------
               INTEGER FUNCTION RCFE(LTS,i1,i2)
                     IMPLICIT NONE
                  CHARACTER LTS(80)*1
                  INTEGER i,i1,i2
                    DO 1 i=i1,i2
                       IF(LTS(i).EQ.'E'.OR.LTS(i).EQ.'e') THEN
                         RCFE=i
                         RETURN
                       END IF 
1                   CONTINUE
                         RCFE=0
                    END  

C -------------------------------------------------------------------
C constructs  positive real number from LTS(i1:i2)
C RCTTR=-1  a bad (i1:i2) interval
C -------------------------------------------------------------------
               DOUBLE PRECISION FUNCTION RCTTR(LTS,i1,i2)
                     IMPLICIT NONE
                  CHARACTER LTS(80)*1
                  INTEGER RCTTN,RCFP,RCFE,i1,i2,nd,ip,ie,N1,N2,N3
                  DOUBLE PRECISION d1,d2,r1,r2
                   nd=0
                   ip=RCFP(LTS,i1,i2)
                   ie=RCFE(LTS,i1,i2)
                     IF(ie.NE.0.AND.ie.LT.ip) GO TO 5
                IF(ip.EQ.0) THEN
                    RCTTR=DBLE(RCTTN(LTS,i1,i2)) 
                    RETURN
                ELSE IF(ip.EQ.i1) THEN
                    N1=0
                ELSE
                    N1=RCTTN(LTS,i1,ip-1)
                END IF
                  IF(ie.EQ.0) THEN
                     nd=i2-ip
                     N3=0
                    IF(ip.EQ.i2) THEN
                     N2=0
                    ELSE
                     N2=RCTTN(LTS,ip+1,i2)
                    END IF
                  ELSE
                     nd=ie-ip-1 
                      IF(ie-ip.EQ.1) THEN
                        N2=0
                      ELSE
                        N2=RCTTN(LTS,ip+1,ie-1)
                      END IF
                 IF(LTS(ie+1).EQ.'-') THEN
                    N3=-RCTTN(LTS,ie+2,i2)
                    IF(N3.EQ.1) GO TO 5
                 ELSE IF(LTS(ie+1).EQ.'+') THEN
                    N3=RCTTN(LTS,ie+2,i2)
                    IF(N3.EQ.-1) GO TO 5                    
                 ELSE
                    N3=RCTTN(LTS,ie+1,i2)
                    IF(N3.EQ.-1) GO TO 5
                 END IF
                   END IF
                 IF(N1.EQ.-1.OR.N2.EQ.-1) GO TO 5
                  d1=DBLE(N1)
                  d2=DBLE(N2)
                  r1=DBLE(N3)
                  r2=DBLE(nd)
                RCTTR=(10.D0**r1)*(d1+d2/(10.D0**r2))
                  RETURN 
5                   RCTTR=-1
               END 
                   
