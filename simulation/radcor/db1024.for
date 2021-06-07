c --- Transformation of number into string
c (c) 1996 by BukinD
c Creation: 19-nov-96
c Revision: 08-feb-97
c
c input: real*8 number           	R
c        int*4  string length		F >= 5
c          1 - sign
c          N>=3 for mantissa
c          1 - for unit prefix
c Mantissa -> .1000 -- 99.99
c output:string				S(1:F)
c
c        program db1024_tst
c        implicit none
c        integer linelen
c        character*20 line
c        real*8 a_number
c
c10      write (6,*) 'Enter line len'
c        read (5,*) linelen
c        if ( linelen.LT.2 ) stop
c20      write (6,*) 'Enter a number'
c        read (5,*) a_number
c        if ( a_number.EQ.0 ) goto 10
c        call db1024( a_number, linelen, line )
c        write (6,15) line(1:linelen)
c15      format(1x,A)
c        goto 20
c        end
c

c ---
	subroutine db1024(r,f,s)
	implicit none
	real*8 r
	integer*4 f
	character*(*) s

c --- locals
	integer bounum
	parameter (bounum = 12)
	integer firstpower
	parameter (firstpower = -18)
	integer defaultpower
	parameter (defaultpower = 7)
	real*8 bounds(bounum)
	character*1 prefixes(bounum)
	data bounds /
     &	  0.1d-18, 0.1d-15, 0.1d-12, 0.1d-9, 0.1d-6, 0.1d-3, 0.1,
     &	  0.1d3, 0.1d6, 0.1d9, 0.1d12, 0.1d15 /
	data prefixes /
     &	  'a','f','p','n','u','m',' ','k','M','G','T','E'/

	integer i, l, p, nf, pp, borrow, j, k
	real*8 ar, m
        character*20 line
        byte bline(20)
        equivalence (line,bline)

	save bounds, prefixes



c --- get the power and mantissa
	i = defaultpower
        ar = abs(r)
        nf = f
	if ( ar.lt.bounds(1) ) then
	  m = 0.
	elseif ( ar.ge.bounds(bounum)*999 ) then
          do j = 2, nf
	    s(j:j) = '*'
	  enddo
	  m = -1.
        else
	  l = 1
	  p = bounum
	  do while( (ar.lt.bounds(i) .or. ar.ge.bounds(i+1)) .and.
     &	    i.gt.1 .and. i.lt.bounum )
	    if ( ar.lt.bounds(i) ) then
	      p = i
	      i = (i + l)/2
	    else
	      l = i
	      i = (i + p + 1)/2
	    endif
	  enddo
	  m = ar/bounds(i)/10.
          if ( i.ne.defaultpower ) nf = f - 1
	endif

c        write (6,*) 'Mantis=',m,' Prefix=',Prefixes(i)

c --- prints
        if ( m.ge.0 ) then
	  ! get the floating point position
          if ( m.lt.1. ) then
            pp = 1
          else if ( m.lt.10. ) then
            pp = 2
            m = m/10
          else
            pp = 3
            m = m/100
          endif
          ! special treatment for 0.1k-- 0.999k
          if ( pp.eq.1 .and. i.eq.defaultpower+1 ) nf = f
          write (line,15) m
15        format(f17.15)
          line(2:2) = line(1:1)
          ! round-up
          if (bline(nf+1).gt.52 ) borrow = 1
          do j = nf, 2, -1
            bline(j) = bline(j) + borrow
            if ( bline(j).gt.57 ) then
              borrow = 1
              bline(j) = 48
            else
              borrow = 0
            endif
          enddo
          ! check the highest digit - if mantissa became 100.
          !  then flip the power
          j = 3
          if ( bline(2).eq.49 ) then
            j = 2
            if (pp.eq.3) then
              pp = 0
              i = i + 1
            endif
          endif
          ! special treatment for 0.1 -- 999. numbers
          if (pp.le.1 .and. j.eq.pp+2 .and. i.eq.defaultpower+1) then
            pp = pp + 3
            i = defaultpower
            nf = f
          endif
          !
          k = 2
          do while( k.le.nf )
            if (j.eq.pp+2) then
              s(k:k) = '.'
              k = k + 1
            endif
            if (k.le.nf) s(k:k) = line(j:j)
            k = k + 1
            j = j + 1
          enddo
        endif

c        write (6,*) 'Mantis=',m,' Prefix=',Prefixes(i),' PP=',pp

c --- sign
	if ( r.lt.0 ) then
	  s(1:1) = '-'
	else
	  s(1:1) = ' '
	endif

c --- power
	if (i.ne.defaultpower) s(f:f) = prefixes(i)
	end
