C********************************************************************
C               Pi(1300) width
C          16.02.2000   Viacheslav Shary
C***************************************************************

      DOUBLE PRECISION  FUNCTION WdPiPrime(E2)

      implicit none

      integer N
      parameter (N=1580)

      DOUBLE PRECISION  E2

      INTEGER index, LUN
      DATA LUN /51/

      REAL  Energy(N), Width(N)
      SAVE Energy, Width

      logical firststep
      save firststep
      data firststep /.true./

      integer ios

      double precision MsP /1.3d3/, ls
      character*10 FileName /'wdpipr.wid'/

c========== чтение файла с зависимостью ширины от энергии ========
      
      IF (firststep) then

        open(UNIT=LUN, FILE=FileName,STATUS='old',IOSTAT=ios,
     &    FORM='FORMATTED')

        if(ios .ne. 0) then
          
          open(UNIT=LUN, FILE='M:'//FileName,STATUS='old',IOSTAT=ios,
     &      FORM='FORMATTED')
          if(ios .ne. 0) then
            write(6,*) 'ERROR when open ', FileName,
     &        ' and M:'//FileName
            write(6,*) '    IOSTAT = ', ios
            return
          end if

        end if


        DO index = 1, N

          read (LUN,'(8x,F6.1,1x,F12.4)',IOSTAT=ios)
     &      energy(index), width(index)

          if(ios .ne. 0) then
            write(6,*) 'ERROR when read ', FileName, ' file !!!'
            write(6,*) '    IOSTAT = ', ios
            return
          end if


        END DO
        
        close (LUN)

        firststep =.false.
        
      END IF

c------------------------------------------------------------------------

      if (E2 .lt. energy(1)) then
			
        WdPiPrime = 0.	
			
      else if (E2 .ge. energy(N)) then
			
        WdPiPrime = -1.	
			
      else		
			
c ==== Линейная интерполяция между двумя точками по энергии (шаг - 1 МэВ)
			
        index = IDINT(E2 -  energy(1))
			
        WdPiPrime = MsP*(Width(index+1)*(E2-energy(index)) +
     &    Width(index)*(energy(index+1)-E2))/E2
			
      end if		
      			
			
      END		

c====================================================================
c      Inverse propagator of Pi(1300)
c      Viacheslav Shary  February 2000
c====================================================================

      COMPLEX*16 FUNCTION DpPiPrime(S)
      
       implicit none

       REAL S

       double precision MsP /1.3d3/,WdPiPrime,E2
       
      if(S.le.0)then
        E2=0.
        write(6,*) '----> DpPiPrime warning: 2E .le. 0 !!!!!'
      else
        E2=sqrt(S)
      end if      


       DpPiPrime=dcmplx(MsP**2-S,-(E2*WdPiPrime(E2)))

       END

