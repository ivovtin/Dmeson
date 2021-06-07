C********************************************************************
C               A1(1230) width
C         15.02.99   Viacheslav Shary
C***************************************************************

      DOUBLE PRECISION  FUNCTION WdA1(E2)

      implicit none

      integer N
      parameter (N=1580)

      DOUBLE PRECISION  E2

      INTEGER index, LUN
      DATA LUN /51/

      integer Nmodel
      parameter(Nmodel=6)

      REAL  Energy(Nmodel,N), Width(Nmodel,N)
      SAVE Energy, Width

      logical firststep(Nmodel) /.true.,.true.,.true.,
     &  .true.,.true.,.true./
      save firststep

      integer ios

      double precision Msa1, wa1, ls
      integer Model
      common/SIMSET/ MSa1, wa1, ls, Model

      character*10 FileName(Nmodel) /'wda11.wid','wda12.wid',
     &  'wda13.wid','wda14.wid','wda15.wid','wda16.wid'/

c========== чтение файлов с зависимостью ширины от энергии ========

      if (firststep(model)) then

        open(UNIT=LUN, FILE=FileName(model),STATUS='old',IOSTAT=ios,
     &    FORM='FORMATTED')

        if(ios .ne. 0) then
          
          open(UNIT=LUN, FILE='M:'//FileName(model),STATUS='old',
     &      IOSTAT=ios,FORM='FORMATTED')
          if(ios .ne. 0) then
            write(6,*) 'ERROR when open ', FileName(model),
     &        ' and M:'//FileName(model)
            write(6,*) '    IOSTAT = ', ios
            return
          end if

        end if
        

        DO index = 1, N
          
          read (LUN,'(8x,F6.1,1x,F12.4)',IOSTAT=ios)
     &      energy(model,index), width(model,index)
          
          if(ios .ne. 0) then
            write(6,*) 'ERROR when read ', FileName(model), ' !!!'
            write(6,*) '    IOSTAT = ', ios
            return
          end if
          
        END DO
      
        close (LUN)

        firststep(model) = .false.

      end if
      
c----------------------------------------------------------------------

      if (E2 .lt. energy(model,1)) then
			
        WdA1 = 0.	
			
      else if (E2 .ge. energy(model,N)) then
			
        WdA1 = -1.	
			
      else		
			
c ==== Линейная интерполяция между двумя точками по энергии (шаг - 1 МэВ)
			
        index = IDINT(E2 -  energy(model,1))
			
        WdA1 = Msa1*(Width(model,index+1)*(E2-energy(model,index)) +
     &    Width(model,index)*(energy(model,index+1)-E2))/E2
			
      end if		
      			
			
      END		

C********************************************************************
C      Inverse propagator of A1(1230) 
C      Viacheslav Shary   16.02.99
C********************************************************************

      COMPLEX*16 FUNCTION DpA1(S)
      
      implicit none
      
      DOUBLE PRECISION  E2, WdA1

      REAL S

      double precision Msa1, wa1, ls
      integer Model
      common/SIMSET/ MSa1, wa1, ls, Model

      if(S.le.0)then
        E2=0.
        write(6,*) '----> DpA1 warning: 2E .le. 0 !!!!!'
      else
        E2=sqrt(S)
      end if      

       DpA1=dcmplx(MsA1**2-S,-(E2*WdA1(E2)))

       END

C********************************************************************
C      Form-factor A1(1230) 
C      Viacheslav Shary   16.02.99
C********************************************************************

       REAL*8 FUNCTION FmA1(S)
      
       implicit none

       double precision Msa1, wa1, ls
       integer Model
       common/SIMSET/ MSa1, wa1, ls, Model

       REAL S

       if(ls.eq.0.)then
         FmA1 = 1.
       else
         FmA1 = ((1+MsA1**2/ls)/(1+s/ls))
       end if

      END

