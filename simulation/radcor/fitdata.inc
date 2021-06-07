C********************************************************************
C Include file with parameters for calculation cross-section 
C                   V.Ivanchenko, A. Bozhenok
C********************************************************************
C********************************************************************
C  Nstep - Number of energy points for table of 3-body phase space
C********************************************************************
   
      
      real*8        PS3PI,Emin,Estep
      integer*4     Npoint,Npoim,Nstep
      parameter     (Nstep=500)
       
      real*8 MsPi,MsPi0,MsEta,MsEtap,MsKs,MsKc,
     &  MsRho,MsOm,MsPhi,MsK892,MsK0892,MsF0,MsA0,
     &  GRho,GOm,GPhi,GK892,GK0892,
     &  PhRho,PhOm,PhPhi,PhRhoP,
     &  BrRhoPiG,BrRhoPi0G,BrRhoEtaG,BrRhoEe,
     &  BrOm3Pi,BrOmPi0G,BrOmEtaG,BrOm2Pi,PhOm2Pi,BrOmEe,
     &  BrPhi2Kc,BrPhiKsKl,BrPhi3Pi,
     &  BrPhiPi0G,BrPhiEtaG,BrPhi2Pi,PhPhi2Pi,BrPhiEe,
     &  MeVnb,Alpha,AOmRho,ARhoPRho,CT,
     &  mssig,gsig,brsigpipi,
     &  Rrho, Rom, Rphi

      common /FIT001/ Npoint,Npoim,Emin,Estep,PS3PI(Nstep) 
      common /FIT002/ MsPi,MsPi0,MsEta,MsEtap,MsKs,MsKc,
     &  MsRho,MsOm,MsPhi,MsK892,MsK0892,MsF0,MsA0,
     &  GRho,GOm,GPhi,GK892,GK0892,
     &  PhRho,PhOm,PhPhi,PhRhoP,
     &  BrRhoPiG,BrRhoPi0G,BrRhoEtaG,BrRhoEe,
     &  BrOm3Pi,BrOmPi0G,BrOmEtaG,BrOm2Pi,PhOm2Pi,BrOmEe,
     &  BrPhi2Kc,BrPhiKsKl,BrPhi3Pi,
     &  BrPhiPi0G,BrPhiEtaG,BrPhi2Pi,PhPhi2Pi,BrPhiEe,
     &  MeVnb,Alpha,AOmRho,ARhoPRho,CT,
     &  mssig,gsig,brsigpipi,
     &  Rrho, Rom, Rphi

c --- parameters related pi0 pi0 gamma decay
      real*8 msrho1450, msrho1700, grho1450, grho1700,
     &  arhoompi0, arho1450ompi0, arho1700ompi0,
     &  phrhoompi0, phrho1450ompi0, phrho1700ompi0,
     &  aomrhopi0, phomrhopi0,
     &  arhopi0pi0g, aompi0pi0g, phrhopi0pi0g, phompi0pi0g,
     &  brrho1450ompi0, brrho1450pipi, 
     &  brrho1700ompi0, brrho1700pipi,
     &  aphirhopi0, phphirhopi0,
     &  arhosigg, phrhosigg,
     &  aomsigg, phomsigg
      common /fit003/ msrho1450, msrho1700, grho1450, grho1700,
     &  arhoompi0, arho1450ompi0, arho1700ompi0,
     &  phrhoompi0, phrho1450ompi0, phrho1700ompi0,
     &  aomrhopi0, phomrhopi0,
     &  arhopi0pi0g, aompi0pi0g, phrhopi0pi0g, phompi0pi0g,
     &  brrho1450ompi0, brrho1450pipi,
     &  brrho1700ompi0, brrho1700pipi,
     &  aphirhopi0, phphirhopi0,
     &  arhosigg, phrhosigg,
     &  aomsigg, phomsigg

      real*8 pi
      parameter (pi = 3.1415926535898d0)
      real*8 deg2rad
      parameter (deg2rad = pi/180)
