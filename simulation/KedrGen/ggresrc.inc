      Real *8 Sum,Es,Fm,Sum1,Sum2,Fm1
      Integer *4 NOBR,Nact,ngt
      COMMON /GGRSTA324/Sum,Es,Sum1,Sum2,Fm,Fm1,NOBR,Nact,Ngt

      Real *8 EB,RMAS,RWID,RG,RM,FMAX,Rmax,Rmin,t1imin,t1imax,t2imin
      Real *8 t2imax,Fmax1,Kmin
      Integer *4 IR,IMODE,KVMDM,ITAG,IRAD
      COMMON /GGRPAR324/EB,RMAS,RWID,RG,RM,FMAX,Rmax,Rmin,t1imin,t1imax,
     &               t2imin,t2imax,Kmin,Fmax1,IR,IMODE,KVMDM,ITAG,IRAD

      Real *8 alpha,PI,EM,mPi0,mPi,mEta,mEtap,mKs,mKc,mRho,mJpsi,mUps
      Real *8 BrPi0,BrEta,BrEtaPrim,BrRho,BrTot     
      COMMON /GGRCON324/alpha,PI,EM,mPi0,mPi,mEta,mEtap,mKs,mKc,mRho,
     &                  mJpsi,mUps,BrPi0(2),BrEta(4),BrEtaPrim(4),BrRho,
     &                  BrTot

      Real *8 PPART,MPART
      Integer * 4 NPART,TYPE,MOTHER
      COMMON /GGREV324/PPART(4,25),MPART(25),TYPE(25),MOTHER(25),NPART

      REAL *8 SETS,SETPOL
      COMMON /GGRPOL324/ SETS(7330),SETPOL(7330)
