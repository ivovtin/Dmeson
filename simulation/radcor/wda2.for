C********************************************************************
C                    A2  width
C            15.02.2000   Viacheslav Shary
C***************************************************************

      DOUBLE PRECISION  FUNCTION Wda2(E2)

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

      double precision MsA2 /1.318d3/, ls
      character*10 FileName /'wda2.wid'/

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
			

      if (E2 .lt. energy(1)) then
			
        Wda2 = 0.	
			
      else if (E2 .ge. energy(N)) then
			
        Wda2 = -1.	
			
      else		
			
c ==== Линейная интерполяция между двумя точками по энергии (шаг - 1 МэВ)
			
        index = IDINT(E2 -  energy(1))
			
        Wda2 = MsA2*(Width(index+1)*(E2-energy(index)) +
     &    Width(index)*(energy(index+1)-E2))/E2
			
      end if		
      			
			
      END		

c====================================================================
c      Inverse propagator of a2
c         Viacheslav Shary
c           February 2000
c====================================================================

      COMPLEX*16 FUNCTION Dpa2(S)
      
       implicit none

       REAL S

       double precision MsA2 /1.318d3/, Wda2, E2
       
      if(S.le.0)then
        E2=0.
        write(6,*) '----> DpA2 warning: 2E .le. 0 !!!!!'
      else
        E2=sqrt(S)
      end if      


       Dpa2=dcmplx(MsA2**2-S,-(E2*Wda2(E2)))

       END

