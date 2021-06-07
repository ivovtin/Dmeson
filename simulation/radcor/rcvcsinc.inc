c	-*- Mode: Fortran -*-
c
c
c

      double precision mass_e
      parameter (mass_e=0.51099906D0)
      double precision pi
      parameter (pi=3.141592653D0)
      double precision alpha
      parameter (alpha=1.0D0/137.0359895D0)
      double precision alpha2pi
      parameter (alpha2pi=(2.0D0/pi)*alpha)


      integer rcvp
      common /rcm_rcvp/ rcvp

      double precision cmEnergy
      common /rcm_cmenergy/ cmEnergy

      double precision bt,Le,xm
      common /rcm_rcbtle/bt,Le,xm

      integer defBenSize
      parameter (defBenSize=3000)
      double precision defBen
      integer defBenLen, dummyDefBen
      common /rcm_defbencom/ defBenLen, dummyDefBen, defBen(defBenSize)

      logical bornxsect
      double precision dreale
      integer procnum
      common /rcfun_cmn/ dreale, procnum, bornxsect
