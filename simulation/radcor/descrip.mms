!=====================================================
!    $Id: descrip.mms,v 1.2 1999/07/19 03:04:33 bukind Exp $
!
!    Creating of library RADCOR
!        10.12.96 V.Ivanchenko     
!        15.07.99 D.Bukin
!=====================================================

.INCLUDE SND:MakeProj.mms

.INCLUDE SND:MakeForOpt.mms

!=====================================================
!    Group of files with cross sections and widths
!       10.12.96   V. Ivanchenko
!=====================================================

group1 = afcnst.for, ccrho2pi.for, cr2pi9703.for, -
 crs2kc.for, crs2pi.for, crs3pi.for, crs_proc.for, -
 crspig.for, crsppg.for, formf.for, formpi.for, -
 inifit.for, phsp2.for, phsp3.for, sp3pi.for, -
 wdk892.for, wdom.for, wdphi.for, wdr980.for, -
 wdrho.for, wdrho1450.for, wdrho1700.for, wdsig.for

!=====================================================
!    Group of files - radiative corrections
!        5.01.96   Z. Silagadze
!=====================================================

group2 = rcftg.for, rcftgm.for, rcfun.for, rcini.for, -
 rcvcs.for, rcvcsm.for, simps1.for

!=====================================================
!    Name of library
!=====================================================

libr   = radcor.olb

!=====================================================
!    Creating of the library using standard file
!=====================================================


all  : $(libr)
	write sys$output "Library $< is O'k."
	
$(libr) : $(group1), $(group2)
	write sys$output "Creating new library $@ ..."
        - delete $(@);*
	library/insert/log $@ $(group1)
	library/insert/log $@ $(group2)


!=====================================================
!    List of dependences    
!=====================================================

$(group1) : fitdata.inc, a0f0data.inc

$(group2) : rcvcsinc.inc

!offbux.inc : SND:offbux.inc
!	- copy/repl/log $< $@
!	write sys$output "File $@ is ok."

SND000.for : SND:snd000.for
	- copy/repl/log $< $@
	write sys$output "File $@ is ok."
